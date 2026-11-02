import 'package:flutter/material.dart';

import '../models/item.dart';
import '../theme/app_theme.dart';
import '../widgets/item_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({
    super.key,
    required this.items,
    required this.onOpenItem,
  });

  final List<Item> items;
  final ValueChanged<Item> onOpenItem;

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String query = '';
  String type = 'All';
  String status = 'All';

  @override
  Widget build(BuildContext context) {
    final results = widget.items.where((item) {
      final matchesQuery = item.itemName.toLowerCase().contains(
        query.toLowerCase(),
      );
      final matchesType = type == 'All' || item.type == type;
      final matchesStatus = status == 'All' || item.status == status;
      return matchesQuery && matchesType && matchesStatus;
    }).toList();

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
        children: [
          Text(
            'Search Items',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 14),
          TextField(
            onChanged: (value) => setState(() => query = value),
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search_rounded),
              hintText: 'Search by item name',
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: ['All', 'Lost', 'Found'].map((value) {
              return ChoiceChip(
                label: Text(value),
                selected: type == value,
                selectedColor: AppTheme.yellow,
                onSelected: (_) => setState(() => type = value),
              );
            }).toList(),
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: ['All', 'Pending', 'Claimed', 'Returned'].map((value) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(value),
                    selected: status == value,
                    selectedColor: AppTheme.lightYellow,
                    onSelected: (_) => setState(() => status = value),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),
          if (results.isEmpty)
            const _EmptyState()
          else
            ...results.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: ItemCard(
                  item: item,
                  onTap: () => widget.onOpenItem(item),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 54),
      child: const Column(
        children: [
          Icon(Icons.search_off_rounded, size: 64, color: AppTheme.yellow),
          SizedBox(height: 12),
          Text(
            'No matching items',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
          ),
          SizedBox(height: 4),
          Text('Try changing your search or filters.'),
        ],
      ),
    );
  }
}
