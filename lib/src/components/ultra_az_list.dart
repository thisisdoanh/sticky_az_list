import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:sticky_az_list/src/typedef.dart';

import '../../sticky_az_list.dart';
import '../grouped_item.dart';
import '../tagged_item.dart';
import '../options/ultra_performance_options.dart';

class UltraAZList<T extends TaggedItem> extends StatefulWidget {
  final ListOptions options;
  final ScrollPhysics? physics;
  final ScrollController controller;
  final List<GroupedItem<T>> data;
  final GlobalKey? viewKey;
  final SymbolNullableStateBuilder? defaultSpecialSymbolBuilder;
  final EnableSafeArea safeArea;
  final Widget Function(BuildContext context, int index, T item) itemBuilder;
  final UltraPerformanceOptions performanceOptions;

  const UltraAZList({
    super.key,
    required this.options,
    this.physics,
    required this.controller,
    required this.data,
    this.viewKey,
    this.defaultSpecialSymbolBuilder,
    required this.safeArea,
    required this.itemBuilder,
    this.performanceOptions = const UltraPerformanceOptions(),
  });

  @override
  State<UltraAZList<T>> createState() => _UltraAZListState<T>();
}

class _UltraAZListState<T extends TaggedItem> extends State<UltraAZList<T>> {
  Set<int> _visibleGroups = {};
  double _lastScrollOffset = 0;
  
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_updateVisibleGroups);
    // Initialize with first few groups
    _visibleGroups = Set.from(List.generate(
      widget.performanceOptions.maxGroupsToRender.clamp(0, widget.data.length),
      (index) => index,
    ));
  }

  @override
  void dispose() {
    widget.controller.removeListener(_updateVisibleGroups);
    super.dispose();
  }

  void _updateVisibleGroups() {
    if (!widget.performanceOptions.enableGroupLazyLoading) return;
    
    final currentOffset = widget.controller.offset;
    final scrollDelta = (currentOffset - _lastScrollOffset).abs();
    
    // Only update if scroll delta is significant (avoid too frequent updates)
    if (scrollDelta < 100) return;
    
    _lastScrollOffset = currentOffset;
    
    // Calculate which groups should be visible based on scroll position
    final viewportHeight = MediaQuery.of(context).size.height;
    final estimatedItemHeight = widget.performanceOptions.itemExtent ?? 50.0;
    
    // Rough calculation of visible range
    final startIndex = (currentOffset / (estimatedItemHeight * 100)).floor().clamp(0, widget.data.length - 1);
    final endIndex = ((currentOffset + viewportHeight * 2) / (estimatedItemHeight * 100)).ceil().clamp(0, widget.data.length);
    
    final newVisibleGroups = <int>{};
    final maxGroups = widget.performanceOptions.maxGroupsToRender;
    final cacheSize = widget.performanceOptions.groupCacheSize;
    
    // Add groups in viewport + cache
    for (int i = (startIndex - cacheSize).clamp(0, widget.data.length); 
         i < (endIndex + cacheSize).clamp(0, widget.data.length) && newVisibleGroups.length < maxGroups; 
         i++) {
      newVisibleGroups.add(i);
    }
    
    if (newVisibleGroups != _visibleGroups) {
      setState(() {
        _visibleGroups = newVisibleGroups;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    return Container(
      color: widget.options.backgroundColor,
      padding: widget.options.padding,
      child: CustomScrollView(
        key: widget.viewKey,
        controller: widget.controller,
        physics: widget.physics,
        cacheExtent: widget.performanceOptions.cacheExtent,
        shrinkWrap: widget.performanceOptions.shrinkWrap,
        slivers: [
          SliverToBoxAdapter(child: widget.options.beforeList),
          ...widget.data.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            
            // Skip groups that are not visible (for ultra performance)
            if (widget.performanceOptions.enableGroupLazyLoading && 
                !_visibleGroups.contains(index)) {
              return SliverToBoxAdapter(
                child: SizedBox(
                  height: widget.performanceOptions.itemExtent != null 
                    ? widget.performanceOptions.itemExtent! * item.itemCount
                    : 50.0 * item.itemCount, // Estimated height
                ),
              );
            }
            
            return SliverOffstage(
              offstage: !item.items.isNotEmpty &&
                  !widget.options.showSectionHeaderForEmptySections,
              sliver: SliverSafeArea(
                bottom: widget.safeArea.bottom,
                top: widget.safeArea.top,
                left: widget.safeArea.left,
                right: widget.safeArea.right,
                sliver: SliverStickyHeader(
                  key: item.key,
                  sticky: widget.options.stickySectionHeader,
                  header: widget.options.showSectionHeader
                      ? _buildHeader(context, item, themeData)
                      : const SizedBox.shrink(),
                  sliver: _buildSliver(item),
                ),
              ),
            );
          }),
          SliverToBoxAdapter(child: widget.options.afterList),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, GroupedItem<T> item, ThemeData themeData) {
    if (widget.performanceOptions.useMinimalRendering) {
      // Ultra minimal header for performance
      return Container(
        height: 40,
        color: widget.options.headerColor ?? themeData.colorScheme.primary,
        alignment: widget.options.headerAligment,
        child: Text(
          item.tag,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }

    // Standard header rendering
    return item.tag == "#" &&
                widget.options.specialSymbolBuilder != null ||
            item.tag == "#" && widget.defaultSpecialSymbolBuilder != null
        ? widget.options.specialSymbolBuilder?.call(context, item.tag, null) ??
            DefaultHeaderSymbol(
              alignment: widget.options.headerAligment,
              symbolIcon: widget.defaultSpecialSymbolBuilder?.call(context, item.tag, null),
              backgroundColor: widget.options.headerColor ??
                  widget.options.backgroundColor ??
                  themeData.colorScheme.primary,
              symbol: item.tag,
            )
        : widget.options.listHeaderBuilder?.call(context, item.tag) ??
            DefaultHeaderSymbol(
              alignment: widget.options.headerAligment,
              backgroundColor: widget.options.headerColor ??
                  widget.options.backgroundColor ??
                  themeData.colorScheme.primary,
              symbol: item.tag,
            );
  }

  Widget _buildSliver(GroupedItem<T> item) {
    if (widget.performanceOptions.itemExtent != null) {
      return SliverFixedExtentList(
        itemExtent: widget.performanceOptions.itemExtent!,
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            return widget.itemBuilder(context, index, item.items[index]);
          },
          childCount: item.itemCount,
          addAutomaticKeepAlives: widget.performanceOptions.addAutomaticKeepAlives,
          addRepaintBoundaries: widget.performanceOptions.addRepaintBoundaries,
          addSemanticIndexes: widget.performanceOptions.addSemanticIndexes,
        ),
      );
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          return widget.itemBuilder(context, index, item.items[index]);
        },
        childCount: item.itemCount,
        addAutomaticKeepAlives: widget.performanceOptions.addAutomaticKeepAlives,
        addRepaintBoundaries: widget.performanceOptions.addRepaintBoundaries,
        addSemanticIndexes: widget.performanceOptions.addSemanticIndexes,
      ),
    );
  }
}
