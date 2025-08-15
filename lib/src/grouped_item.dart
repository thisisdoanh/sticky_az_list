import 'package:flutter/material.dart';

class GroupedItem<T> {
  final String tag;
  final GlobalKey key;
  final List<T> items;
  final int itemCount;

  GroupedItem({
    required this.tag,
    required this.items,
  }) : key = GlobalKey(),
       itemCount = items.length;
}
