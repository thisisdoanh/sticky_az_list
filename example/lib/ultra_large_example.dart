import 'package:flutter/material.dart';
import 'package:sticky_az_list/sticky_az_list.dart';

/// Ví dụ cho danh sách siêu lớn: 26 groups x 10,000 items = 260,000 items
class UltraLargeExample extends StatelessWidget {
  const UltraLargeExample({super.key});

  @override
  Widget build(BuildContext context) {
    // Tạo danh sách siêu lớn: 26 groups, mỗi group 10,000 items
    final List<UltraItem> items = [];
    
    for (int groupIndex = 0; groupIndex < 26; groupIndex++) {
      final letter = String.fromCharCode(65 + groupIndex); // A-Z
      
      for (int itemIndex = 0; itemIndex < 10000; itemIndex++) {
        items.add(UltraItem(
          name: '$letter${itemIndex.toString().padLeft(4, '0')}',
          id: groupIndex * 10000 + itemIndex,
          group: letter,
        ));
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ultra Large List - 260k Items'),
        backgroundColor: Colors.red[700],
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.red[50],
            child: Row(
              children: [
                const Icon(Icons.warning, color: Colors.orange),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '⚡ Ultra Performance Mode: 26 groups × 10,000 items = 260,000 total items',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: StickyAzList<UltraItem>(
              items: items,
              builder: (context, index, item) {
                return Container(
                  height: 60, // Chiều cao cố định
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.grey[300]!,
                        width: 0.5,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      // Minimal avatar để giảm rendering cost
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: _getColorForGroup(item.group),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            item.group,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              item.name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              'ID: ${item.id}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 14,
                        color: Colors.grey[400],
                      ),
                    ],
                  ),
                );
              },
              // 🚀 SỬ DỤNG ULTRA PERFORMANCE MODE
              options: StickyAzOptions.ultraLarge(
                itemHeight: 60.0, // Chiều cao cố định để tối ưu tối đa
                listOptions: const ListOptions(
                  showSectionHeader: true,
                  stickySectionHeader: true,
                ),
                scrollBarOptions: const ScrollBarOptions(
                  width: 25,
                  alignment: ScrollBarAlignment.end,
                ),
                overlayOptions: const OverlayOptions(
                  showOverlay: true,
                  aligment: OverlayAligment.centered,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getColorForGroup(String group) {
    final colors = [
      Colors.red[400]!,
      Colors.blue[400]!,
      Colors.green[400]!,
      Colors.orange[400]!,
      Colors.purple[400]!,
      Colors.teal[400]!,
      Colors.indigo[400]!,
      Colors.pink[400]!,
    ];
    return colors[group.codeUnitAt(0) % colors.length];
  }
}

/// Ví dụ tùy chỉnh ultra performance
class CustomUltraPerformanceExample extends StatelessWidget {
  const CustomUltraPerformanceExample({super.key});

  @override
  Widget build(BuildContext context) {
    // Tạo danh sách lớn hơn: 50 groups x 5000 items = 250,000 items
    final List<UltraItem> items = [];
    
    for (int groupIndex = 0; groupIndex < 50; groupIndex++) {
      final groupName = 'Group${groupIndex.toString().padLeft(2, '0')}';
      
      for (int itemIndex = 0; itemIndex < 5000; itemIndex++) {
        items.add(UltraItem(
          name: '${groupName}_Item${itemIndex.toString().padLeft(4, '0')}',
          id: groupIndex * 5000 + itemIndex,
          group: groupName[0], // Chỉ lấy ký tự đầu để sort
        ));
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Custom Ultra Performance'),
        backgroundColor: Colors.purple[700],
        foregroundColor: Colors.white,
      ),
      body: StickyAzList<UltraItem>(
        items: items,
        builder: (context, index, item) {
          // Minimal rendering để tối đa hiệu suất
          return Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Row(
              children: [
                Container(
                  width: 6,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.purple[300],
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    item.name,
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
                Text(
                  '#${item.id}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          );
        },
        options: StickyAzOptions(
          useUltraPerformance: true,
          ultraPerformanceOptions: const UltraPerformanceOptions(
            cacheExtent: 20.0,           // Cache rất ít để tiết kiệm bộ nhớ
            itemExtent: 48.0,            // Chiều cao cố định
            addAutomaticKeepAlives: false,
            addRepaintBoundaries: false,  // Tắt để giảm overhead
            addSemanticIndexes: false,
            maxGroupsToRender: 2,        // Chỉ render 2 groups cùng lúc
            groupCacheSize: 1,           // Cache 1 group trước/sau
            useMinimalRendering: true,   // Rendering tối giản
          ),
          listOptions: const ListOptions(
            showSectionHeader: true,
            stickySectionHeader: true,
          ),
        ),
      ),
    );
  }
}

class UltraItem extends TaggedItem {
  final String name;
  final int id;
  final String group;

  UltraItem({
    required this.name,
    required this.id,
    required this.group,
  });

  @override
  String sortName() => name;
}
