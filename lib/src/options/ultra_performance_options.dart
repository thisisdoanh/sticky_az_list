import 'package:flutter/material.dart';

/// Ultra performance options for extremely large lists (100k+ items)
class UltraPerformanceOptions {
  const UltraPerformanceOptions({
    this.cacheExtent = 50.0,
    this.itemExtent,
    this.addAutomaticKeepAlives = false,
    this.addRepaintBoundaries = false, // Tắt để giảm overhead
    this.addSemanticIndexes = false,
    this.shrinkWrap = false,
    this.maxGroupsToRender = 5, // Chỉ render tối đa 5 groups cùng lúc
    this.enableGroupLazyLoading = true,
    this.groupCacheSize = 2, // Cache 2 groups trước và sau viewport
    this.useMinimalRendering = true,
  });

  /// Cache extent - rất nhỏ để tiết kiệm bộ nhớ
  final double cacheExtent;

  /// Fixed item extent for better performance
  final double? itemExtent;

  /// Disable keep alives completely
  final bool addAutomaticKeepAlives;

  /// Disable repaint boundaries for ultra performance
  final bool addRepaintBoundaries;

  /// Disable semantic indexes
  final bool addSemanticIndexes;

  /// Never shrink wrap
  final bool shrinkWrap;

  /// Maximum number of groups to render simultaneously
  final int maxGroupsToRender;

  /// Enable lazy loading for groups
  final bool enableGroupLazyLoading;

  /// Number of groups to cache before/after viewport
  final int groupCacheSize;

  /// Use minimal rendering (skip complex widgets)
  final bool useMinimalRendering;

  /// Predefined for 260k+ items (26 groups x 10k items each)
  static const UltraPerformanceOptions ultraLarge = UltraPerformanceOptions(
    cacheExtent: 25.0,
    addAutomaticKeepAlives: false,
    addRepaintBoundaries: false,
    addSemanticIndexes: false,
    maxGroupsToRender: 3,
    groupCacheSize: 1,
    useMinimalRendering: true,
  );

  /// For fixed height ultra large lists
  static UltraPerformanceOptions ultraLargeFixed(double height) {
    return UltraPerformanceOptions(
      cacheExtent: 25.0,
      itemExtent: height,
      addAutomaticKeepAlives: false,
      addRepaintBoundaries: false,
      addSemanticIndexes: false,
      maxGroupsToRender: 3,
      groupCacheSize: 1,
      useMinimalRendering: true,
    );
  }

  UltraPerformanceOptions copyWith({
    double? cacheExtent,
    double? itemExtent,
    bool? addAutomaticKeepAlives,
    bool? addRepaintBoundaries,
    bool? addSemanticIndexes,
    bool? shrinkWrap,
    int? maxGroupsToRender,
    bool? enableGroupLazyLoading,
    int? groupCacheSize,
    bool? useMinimalRendering,
  }) {
    return UltraPerformanceOptions(
      cacheExtent: cacheExtent ?? this.cacheExtent,
      itemExtent: itemExtent ?? this.itemExtent,
      addAutomaticKeepAlives: addAutomaticKeepAlives ?? this.addAutomaticKeepAlives,
      addRepaintBoundaries: addRepaintBoundaries ?? this.addRepaintBoundaries,
      addSemanticIndexes: addSemanticIndexes ?? this.addSemanticIndexes,
      shrinkWrap: shrinkWrap ?? this.shrinkWrap,
      maxGroupsToRender: maxGroupsToRender ?? this.maxGroupsToRender,
      enableGroupLazyLoading: enableGroupLazyLoading ?? this.enableGroupLazyLoading,
      groupCacheSize: groupCacheSize ?? this.groupCacheSize,
      useMinimalRendering: useMinimalRendering ?? this.useMinimalRendering,
    );
  }
}
