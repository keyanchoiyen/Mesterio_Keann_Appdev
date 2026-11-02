import 'package:flutter/material.dart';

import '../models/item.dart';
import '../widgets/item_card.dart';

class MyReportsScreen extends StatelessWidget {
  const MyReportsScreen({
    super.key,
    required this.items,
    required this.onOpenItem,
    required this.onAddItem,
    this.onEdit,
    this.onDelete,
  });
  final List<Item> items;
  final ValueChanged<Item> onOpenItem;
  final VoidCallback onAddItem;
  final ValueChanged<Item>? onEdit;
  final ValueChanged<Item>? onDelete;
  @override
  Widget build(BuildContext context) => SafeArea(
    child: ListView(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
      children: [
        Text('My Reports', style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 14),
        if (items.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 60),
              child: Column(
                children: [
                  const Icon(Icons.inventory_2_outlined, size: 64),
                  const SizedBox(height: 12),
                  const Text(
                    'No reports yet',
                    style: TextStyle(fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 14),
                  ElevatedButton.icon(
                    onPressed: onAddItem,
                    icon: const Icon(Icons.add),
                    label: const Text('Add Report'),
                  ),
                ],
              ),
            ),
          )
        else
          ...items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: ItemCard(
                item: item,
                onTap: () => onOpenItem(item),
                trailing: PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert),
                  onSelected: (value) {
                    if (value == 'edit') {
                      onEdit?.call(item);
                    } else if (value == 'delete') {
                      onDelete?.call(item);
                    }
                  },
                  itemBuilder: (_) => const [
                    PopupMenuItem(value: 'edit', child: Text('Edit')),
                    PopupMenuItem(value: 'delete', child: Text('Delete')),
                  ],
                ),
              ),
            ),
          ),
      ],
    ),
  );
}
