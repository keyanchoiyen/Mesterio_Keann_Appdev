import 'package:flutter/material.dart';

import '../models/item.dart';
import '../theme/app_theme.dart';

class ItemCard extends StatelessWidget {
  const ItemCard({super.key, required this.item, this.onTap, this.trailing});

  final Item item;
  final VoidCallback? onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final isLost = item.type == 'Lost';
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  color: isLost
                      ? AppTheme.lightYellow
                      : const Color(0xFFFFE7B7),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  isLost
                      ? Icons.search_off_rounded
                      : Icons.check_circle_outline_rounded,
                  color: AppTheme.primaryOrange,
                  size: 28,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            item.itemName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: isLost
                                ? AppTheme.primaryOrange
                                : AppTheme.yellow,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            item.type,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: isLost ? Colors.white : AppTheme.darkText,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${item.location}  •  ${item.date}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: AppTheme.darkText.withValues(alpha: .65),
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      item.status,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.darkOrange,
                      ),
                    ),
                  ],
                ),
              ),
              if (trailing != null) ...[const SizedBox(width: 4), trailing!],
            ],
          ),
        ),
      ),
    );
  }
}
