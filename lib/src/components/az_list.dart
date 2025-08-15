import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:sticky_az_list/src/typedef.dart';

import '../../sticky_az_list.dart';
import '../grouped_item.dart';
import '../tagged_item.dart';
import '../options/performance_options.dart';

class AZList<T extends TaggedItem> extends StatelessWidget {
  final ListOptions options;
  final ScrollPhysics? physics;
  final ScrollController controller;
  final List<GroupedItem<T>> data;
  final GlobalKey? viewKey;
  final SymbolNullableStateBuilder? defaultSpecialSymbolBuilder;
  final EnableSafeArea safeArea;
  final Widget Function(BuildContext context, int index, T item) itemBuilder;
  final double? cacheExtent;
  final double? itemExtent;
  final PerformanceOptions performanceOptions;

  const AZList({
    super.key,
    required this.options,
    this.physics,
    required this.controller,
    required this.data,
    this.viewKey,
    this.defaultSpecialSymbolBuilder,
    required this.safeArea,
    required this.itemBuilder,
    this.cacheExtent,
    this.itemExtent,
    this.performanceOptions = const PerformanceOptions(),
  });

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    
    // Effective values from performance options
    final effectiveCacheExtent = cacheExtent ?? performanceOptions.cacheExtent ?? 250.0;
    final effectiveItemExtent = itemExtent ?? performanceOptions.itemExtent;

    return Container(
      color: options.backgroundColor,
      padding: options.padding,
      child: CustomScrollView(
        key: viewKey,
        controller: controller,
        physics: physics,
        cacheExtent: effectiveCacheExtent,
        shrinkWrap: performanceOptions.shrinkWrap,
        slivers: [
          SliverToBoxAdapter(child: options.beforeList),
          ...data.map(
            (item) => SliverOffstage(
              offstage:
                  !item.items.isNotEmpty &&
                  !options.showSectionHeaderForEmptySections,
              sliver: SliverSafeArea(
                bottom: safeArea.bottom,
                top: safeArea.top,
                left: safeArea.left,
                right: safeArea.right,
                sliver: SliverStickyHeader(
                  key: item.key,
                  sticky: options.stickySectionHeader,
                  header: options.showSectionHeader
                      ? item.tag == "#" &&
                                    options.specialSymbolBuilder != null ||
                                item.tag == "#" &&
                                    defaultSpecialSymbolBuilder != null
                            ? options.specialSymbolBuilder?.call(
                                    context,
                                    item.tag,
                                    null,
                                  ) ??
                                  DefaultHeaderSymbol(
                                    alignment: options.headerAligment,
                                    symbolIcon: defaultSpecialSymbolBuilder
                                        ?.call(context, item.tag, null),
                                    backgroundColor:
                                        options.headerColor ??
                                        options.backgroundColor ??
                                        themeData.colorScheme.primary,
                                    symbol: item.tag,
                                  )
                            : options.listHeaderBuilder?.call(
                                    context,
                                    item.tag,
                                  ) ??
                                  DefaultHeaderSymbol(
                                    alignment: options.headerAligment,
                                    backgroundColor:
                                        options.headerColor ??
                                        options.backgroundColor ??
                                        themeData.colorScheme.primary,
                                    symbol: item.tag,
                                  )
                      : const SizedBox.shrink(),
                  sliver: effectiveItemExtent != null
                      ? SliverFixedExtentList(
                          itemExtent: effectiveItemExtent!,
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              return itemBuilder(context, index, item.items[index]);
                            },
                            childCount: item.itemCount,
                            addAutomaticKeepAlives: performanceOptions.addAutomaticKeepAlives,
                            addRepaintBoundaries: performanceOptions.addRepaintBoundaries,
                            addSemanticIndexes: performanceOptions.addSemanticIndexes,
                          ),
                        )
                      : SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              return itemBuilder(context, index, item.items[index]);
                            },
                            childCount: item.itemCount,
                            addAutomaticKeepAlives: performanceOptions.addAutomaticKeepAlives,
                            addRepaintBoundaries: performanceOptions.addRepaintBoundaries,
                            addSemanticIndexes: performanceOptions.addSemanticIndexes,
                          ),
                        ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(child: options.afterList),
        ],
      ),
    );
  }
}
