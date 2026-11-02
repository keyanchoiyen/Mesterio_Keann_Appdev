import 'dart:io';

import 'package:flutter/material.dart';

import '../models/item.dart';
import '../theme/app_theme.dart';

class ItemDetailsScreen extends StatefulWidget {
  const ItemDetailsScreen({
    super.key,
    required this.item,
    this.onEdit,
    this.onDelete,
    this.onStatusChanged,
  });
  final Item item;
  final ValueChanged<Item>? onEdit;
  final ValueChanged<Item>? onDelete;
  final ValueChanged<Item>? onStatusChanged;
  @override
  State<ItemDetailsScreen> createState() => _ItemDetailsScreenState();
}

class _ItemDetailsScreenState extends State<ItemDetailsScreen> {
  late Item item;
  @override
  void initState() {
    super.initState();
    item = widget.item;
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Item Details'),
      actions: [
        IconButton(
          icon: const Icon(Icons.edit_outlined),
          onPressed: () => widget.onEdit?.call(item),
        ),
      ],
    ),
    body: ListView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      children: [
        Container(
          height: 210,
          decoration: BoxDecoration(
            color: AppTheme.lightYellow,
            borderRadius: BorderRadius.circular(18),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: item.imagePath != null && File(item.imagePath!).existsSync()
                ? Image.file(File(item.imagePath!), fit: BoxFit.cover)
                : const Icon(
                    Icons.inventory_2_outlined,
                    size: 86,
                    color: AppTheme.primaryOrange,
                  ),
          ),
        ),
        const SizedBox(height: 18),
        Row(
          children: [
            Expanded(
              child: Text(
                item.itemName,
                style: Theme.of(context).textTheme.headlineSmall
                    ?.copyWith(fontWeight: FontWeight.w800),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: item.type == 'Lost'
                    ? AppTheme.primaryOrange
                    : AppTheme.yellow,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                item.type,
                style: TextStyle(
                  color: item.type == 'Lost' ? Colors.white : AppTheme.darkText,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _DetailCard(
          children: [
            _DetailRow(
              icon: Icons.description_outlined,
              label: 'Description',
              value: item.description,
            ),
            const Divider(),
            _DetailRow(
              icon: Icons.location_on_outlined,
              label: 'Location',
              value: item.location,
            ),
            const Divider(),
            _DetailRow(
              icon: Icons.calendar_today_outlined,
              label: 'Date',
              value: item.date,
            ),
            const Divider(),
            _DetailRow(
              icon: Icons.flag_outlined,
              label: 'Status',
              value: item.status,
            ),
          ],
        ),
        const SizedBox(height: 18),
        ElevatedButton.icon(
          onPressed: () async {
            final statuses = ['Pending', 'Claimed', 'Returned'];
            final selected = await showModalBottomSheet<String>(
              context: context,
              builder: (_) => SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: statuses
                      .map(
                        (status) => ListTile(
                          title: Text(status),
                          onTap: () => Navigator.pop(context, status),
                        ),
                      )
                      .toList(),
                ),
              ),
            );
            if (selected != null) {
              setState(() {
                item = item.copyWith(status: selected);
                widget.onStatusChanged?.call(item);
              });
            }
          },
          icon: const Icon(Icons.sync_rounded),
          label: const Text('Update Status'),
        ),
        const SizedBox(height: 10),
        OutlinedButton.icon(
          onPressed: () async {
            final confirm =
                await showDialog<bool>(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text('Delete report?'),
                    content: const Text('This item will be removed.'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text('Delete'),
                      ),
                    ],
                  ),
                ) ??
                false;
            if (confirm) {
              widget.onDelete?.call(item);
              if (context.mounted) Navigator.pop(context);
            }
          },
          style: OutlinedButton.styleFrom(
            minimumSize: const Size.fromHeight(52),
            foregroundColor: Colors.red.shade700,
            side: BorderSide(color: Colors.red.shade300),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          icon: const Icon(Icons.delete_outline),
          label: const Text('Delete'),
        ),
      ],
    ),
  );
}

class _DetailCard extends StatelessWidget {
  const _DetailCard({required this.children});
  final List<Widget> children;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: AppTheme.white,
      borderRadius: BorderRadius.circular(16),
    ),
    child: Column(children: children),
  );
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });
  final IconData icon;
  final String label, value;
  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: AppTheme.lightYellow,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: AppTheme.primaryOrange, size: 20),
      ),
      const SizedBox(width: 12),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: AppTheme.darkText.withValues(alpha: .55),
              ),
            ),
            const SizedBox(height: 3),
            Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    ],
  );
}
