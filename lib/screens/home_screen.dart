import 'package:flutter/material.dart';

import '../models/item.dart';
import '../theme/app_theme.dart';
import '../widgets/item_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
    required this.items,
    required this.onOpenItem,
    required this.onAddItem,
  });
  final List<Item> items;
  final ValueChanged<Item> onOpenItem;
  final ValueChanged<String> onAddItem;

  @override
  Widget build(BuildContext context) {
    final lostCount = items.where((item) => item.type == 'Lost').length;
    final foundCount = items.where((item) => item.type == 'Found').length;
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Campus Lost & Found',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const Text(
                    'Find it. Return it.',
                    style: TextStyle(
                      color: AppTheme.darkOrange,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: _SummaryCard(
                          title: 'Lost Items',
                          count: lostCount,
                          icon: Icons.search_off_rounded,
                          color: AppTheme.primaryOrange,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _SummaryCard(
                          title: 'Found Items',
                          count: foundCount,
                          icon: Icons.check_circle_outline_rounded,
                          color: AppTheme.yellow,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Text(
                    'Quick Actions',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: _ActionButton(
                          label: 'Report Lost',
                          icon: Icons.remove_circle_outline,
                          onTap: () => onAddItem('Lost'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _ActionButton(
                          label: 'Report Found',
                          icon: Icons.add_circle_outline,
                          onTap: () => onAddItem('Found'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 22),
                  Text(
                    'Recently Reported',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
            sliver: SliverList.separated(
              itemCount: items.length,
              separatorBuilder: (_, _) => const SizedBox(height: 10),
              itemBuilder: (_, index) => ItemCard(
                item: items[index],
                onTap: () => onOpenItem(items[index]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.title,
    required this.count,
    required this.icon,
    required this.color,
  });
  final String title;
  final int count;
  final IconData icon;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: .04), blurRadius: 12),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withValues(alpha: .16),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: color == AppTheme.yellow ? AppTheme.darkOrange : color,
            ),
          ),
          const SizedBox(height: 10),
          Text('$count', style: Theme.of(context).textTheme.headlineMedium),
          Text(
            title,
            style: TextStyle(
              color: AppTheme.darkText.withValues(alpha: .65),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    required this.icon,
    required this.onTap,
  });
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon),
      label: Text(label),
    );
  }
}
