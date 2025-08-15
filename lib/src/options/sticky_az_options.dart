import 'package:flutter/material.dart';

import 'package:sticky_az_list/src/typedef.dart';
import 'package:sticky_az_list/sticky_az_list.dart';
import 'performance_options.dart';
import 'ultra_performance_options.dart';

class StickyAzOptions {
  const StickyAzOptions({
    this.startWithSpecialSymbol = false,
    this.specialSymbolBuilder,
    this.listOptions = const ListOptions(),
    this.scrollBarOptions = const ScrollBarOptions(),
    this.overlayOptions = const OverlayOptions(),
    this.padding,
    this.safeArea = const EnableSafeArea(),
    this.cacheExtent,
    this.itemExtent,
    this.performanceOptions = const PerformanceOptions(),
    this.ultraPerformanceOptions,
    this.useUltraPerformance = false,
  });

  /// Start with special symbol.
  final bool startWithSpecialSymbol;

  /// Define default special symbol for all components.
  final SymbolNullableStateBuilder? specialSymbolBuilder;

  /// Customisation options for the list.
  final ListOptions listOptions;

  /// Customisation options for the scrollbar.
  final ScrollBarOptions scrollBarOptions;

  /// Customisation options for the overlay.
  final OverlayOptions overlayOptions;

  /// Padding for the entire widget.
  final EdgeInsets? padding;

  /// Enable [SafeArea] for the list.
  final EnableSafeArea safeArea;

  /// Cache extent for performance optimization.
  /// Controls how many pixels beyond the visible area should be cached.
  /// Smaller values use less memory but may cause more frequent rebuilds.
  /// For large lists (10k+ items), consider values between 100-500.
  final double? cacheExtent;

  /// Fixed item extent for performance optimization.
  /// If all your list items have the same height, setting this will
  /// significantly improve scrolling performance and memory usage.
  /// Use SliverFixedExtentList internally for better performance.
  final double? itemExtent;

  /// Advanced performance options for large lists.
  /// Use PerformanceOptions.largeList for 10k+ items,
  /// PerformanceOptions.veryLargeList for 50k+ items,
  /// or PerformanceOptions.fixedHeight(height) for fixed-height items.
  final PerformanceOptions performanceOptions;

  /// Convenience getter for effective cache extent
  double? get effectiveCacheExtent => cacheExtent ?? performanceOptions.cacheExtent;

  /// Convenience getter for effective item extent
  double? get effectiveItemExtent => itemExtent ?? performanceOptions.itemExtent;

  /// Ultra performance options for extremely large lists (100k+ items).
  /// Use UltraPerformanceOptions.ultraLarge for 260k+ items.
  final UltraPerformanceOptions? ultraPerformanceOptions;

  /// Enable ultra performance mode for extremely large lists.
  /// This will use aggressive optimizations that may reduce features
  /// but dramatically improve performance for 100k+ items.
  final bool useUltraPerformance;

  /// Factory constructor for ultra large lists (26 groups x 10k items = 260k items)
  factory StickyAzOptions.ultraLarge({
    double? itemHeight,
    ListOptions? listOptions,
    ScrollBarOptions? scrollBarOptions,
    OverlayOptions? overlayOptions,
  }) {
    return StickyAzOptions(
      useUltraPerformance: true,
      ultraPerformanceOptions: itemHeight != null 
        ? UltraPerformanceOptions.ultraLargeFixed(itemHeight)
        : UltraPerformanceOptions.ultraLarge,
      listOptions: listOptions ?? const ListOptions(),
      scrollBarOptions: scrollBarOptions ?? const ScrollBarOptions(),
      overlayOptions: overlayOptions ?? const OverlayOptions(),
    );
  }
}
