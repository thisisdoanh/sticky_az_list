import 'package:flutter/material.dart';

/// Performance optimization options for large lists
class PerformanceOptions {
  const PerformanceOptions({
    this.cacheExtent,
    this.itemExtent,
    this.addAutomaticKeepAlives = false,
    this.addRepaintBoundaries = true,
    this.addSemanticIndexes = true,
    this.shrinkWrap = false,
  });

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

  /// Whether to add automatic keep alives.
  /// Set to false for better memory usage with large lists.
  /// Default: false
  final bool addAutomaticKeepAlives;

  /// Whether to add repaint boundaries.
  /// Helps with rendering performance by isolating repaints.
  /// Default: true
  final bool addRepaintBoundaries;

  /// Whether to add semantic indexes.
  /// Improves accessibility but adds slight overhead.
  /// Default: true
  final bool addSemanticIndexes;

  /// Whether the scroll view should shrink-wrap its contents.
  /// Generally should be false for performance.
  /// Default: false
  final bool shrinkWrap;

  /// Create a copy with modified values
  PerformanceOptions copyWith({
    double? cacheExtent,
    double? itemExtent,
    bool? addAutomaticKeepAlives,
    bool? addRepaintBoundaries,
    bool? addSemanticIndexes,
    bool? shrinkWrap,
  }) {
    return PerformanceOptions(
      cacheExtent: cacheExtent ?? this.cacheExtent,
      itemExtent: itemExtent ?? this.itemExtent,
      addAutomaticKeepAlives: addAutomaticKeepAlives ?? this.addAutomaticKeepAlives,
      addRepaintBoundaries: addRepaintBoundaries ?? this.addRepaintBoundaries,
      addSemanticIndexes: addSemanticIndexes ?? this.addSemanticIndexes,
      shrinkWrap: shrinkWrap ?? this.shrinkWrap,
    );
  }

  /// Predefined settings for large lists (10k+ items)
  static const PerformanceOptions largeList = PerformanceOptions(
    cacheExtent: 200.0,
    addAutomaticKeepAlives: false,
    addRepaintBoundaries: true,
    addSemanticIndexes: false, // Disabled for performance
    shrinkWrap: false,
  );

  /// Predefined settings for very large lists (50k+ items)
  static const PerformanceOptions veryLargeList = PerformanceOptions(
    cacheExtent: 100.0,
    addAutomaticKeepAlives: false,
    addRepaintBoundaries: true,
    addSemanticIndexes: false,
    shrinkWrap: false,
  );

  /// Predefined settings for fixed height items
  static PerformanceOptions fixedHeight(double height) {
    return PerformanceOptions(
      cacheExtent: 200.0,
      itemExtent: height,
      addAutomaticKeepAlives: false,
      addRepaintBoundaries: true,
      addSemanticIndexes: false,
      shrinkWrap: false,
    );
  }
}
