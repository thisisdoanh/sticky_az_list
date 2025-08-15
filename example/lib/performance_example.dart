import 'package:flutter/material.dart';
import 'package:sticky_az_list/sticky_az_list.dart';

/// Ví dụ về cách sử dụng StickyAzList với các tùy chọn hiệu suất
/// cho danh sách lớn (10,000+ items)
class PerformanceExample extends StatelessWidget {
  const PerformanceExample({super.key});

  @override
  Widget build(BuildContext context) {
    // Tạo danh sách lớn với 10,000 items
    final List<ExampleItem> items = List.generate(10000, (index) {
      final letter = String.fromCharCode(65 + (index % 26)); // A-Z
      return ExampleItem(
        name: '$letter Item ${index + 1}',
        id: index,
      );
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Performance Example - 10k Items'),
      ),
      body: StickyAzList<ExampleItem>(
        items: items,
        builder: (context, index, item) {
          return ListTile(
            leading: CircleAvatar(
              child: Text(item.name[0]),
            ),
            title: Text(item.name),
            subtitle: Text('ID: ${item.id}'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Tapped on ${item.name}')),
              );
            },
          );
        },
        options: const StickyAzOptions(
          // Sử dụng tùy chọn hiệu suất cho danh sách lớn
          performanceOptions: PerformanceOptions.largeList,
          
          // Hoặc tùy chỉnh riêng:
          // performanceOptions: PerformanceOptions(
          //   cacheExtent: 200.0,  // Cache 200 pixels
          //   addAutomaticKeepAlives: false,  // Tiết kiệm bộ nhớ
          //   addRepaintBoundaries: true,     // Tối ưu rendering
          //   addSemanticIndexes: false,      // Tắt để tăng hiệu suất
          // ),
          
          // Nếu tất cả items có chiều cao cố định:
          // performanceOptions: PerformanceOptions.fixedHeight(72.0),
          
          listOptions: ListOptions(
            showSectionHeader: true,
            stickySectionHeader: true,
          ),
          scrollBarOptions: ScrollBarOptions(
            width: 30,
            alignment: ScrollBarAlignment.end,
          ),
          overlayOptions: OverlayOptions(
            showOverlay: true,
            aligment: OverlayAligment.dynamic,
          ),
        ),
      ),
    );
  }
}

class ExampleItem extends TaggedItem {
  final String name;
  final int id;

  ExampleItem({required this.name, required this.id});

  @override
  String sortName() => name;
}

/// Ví dụ về danh sách rất lớn (50,000+ items)
class VeryLargeListExample extends StatelessWidget {
  const VeryLargeListExample({super.key});

  @override
  Widget build(BuildContext context) {
    // Tạo danh sách rất lớn với 50,000 items
    final List<ExampleItem> items = List.generate(50000, (index) {
      final letter = String.fromCharCode(65 + (index % 26));
      return ExampleItem(
        name: '$letter Item ${index + 1}',
        id: index,
      );
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Very Large List - 50k Items'),
      ),
      body: StickyAzList<ExampleItem>(
        items: items,
        builder: (context, index, item) {
          return Container(
            height: 60, // Chiều cao cố định
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  child: Text(item.name[0]),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        item.name,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      Text(
                        'ID: ${item.id}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward_ios, size: 16),
              ],
            ),
          );
        },
        options: const StickyAzOptions(
          // Tùy chọn hiệu suất cho danh sách rất lớn với chiều cao cố định
          performanceOptions: PerformanceOptions(
            cacheExtent: 100.0,              // Cache ít hơn để tiết kiệm bộ nhớ
            itemExtent: 60.0,                // Chiều cao cố định
            addAutomaticKeepAlives: false,   // Tắt keep alive
            addRepaintBoundaries: true,      // Bật repaint boundaries
            addSemanticIndexes: false,       // Tắt semantic indexes
            shrinkWrap: false,               // Không shrink wrap
          ),
          
          listOptions: ListOptions(
            showSectionHeader: true,
            stickySectionHeader: true,
          ),
          scrollBarOptions: ScrollBarOptions(
            width: 25,
            alignment: ScrollBarAlignment.end,
          ),
          overlayOptions: OverlayOptions(
            showOverlay: true,
            aligment: OverlayAligment.centered,
          ),
        ),
      ),
    );
  }
}
