import 'package:flutter/material.dart';
import 'package:hankan/app/model/space_detail_model.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class SpaceCarouselCard extends StatelessWidget {
  final SpaceDetail space;
  final VoidCallback? onTap;

  const SpaceCarouselCard({
    Key? key,
    required this.space,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: ShadTheme.of(context).colorScheme.background,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image section
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Image.network(
                  space.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: ShadTheme.of(context).colorScheme.muted,
                    child: Icon(
                      Icons.image_not_supported,
                      size: 40,
                      color: ShadTheme.of(context).colorScheme.mutedForeground,
                    ),
                  ),
                ),
              ),
            ),
            // Content section
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name and rating
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            space.name,
                            style: ShadTheme.of(context).textTheme.h4,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (space.rating > 0) ...[
                          const SizedBox(width: 8),
                          Row(
                            children: [
                              Icon(
                                Icons.star,
                                size: 14,
                                color: Colors.amber,
                              ),
                              const SizedBox(width: 2),
                              Text(
                                space.rating.toStringAsFixed(1),
                                style: ShadTheme.of(context).textTheme.small,
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    // Address
                    Text(
                      space.address,
                      style: ShadTheme.of(context).textTheme.muted.copyWith(
                        fontSize: 12,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    // Available boxes
                    Row(
                      children: [
                        Icon(
                          Icons.inventory_2_outlined,
                          size: 14,
                          color: ShadTheme.of(context).colorScheme.mutedForeground,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${space.totalBoxCount}개 보관 가능',
                          style: ShadTheme.of(context).textTheme.small,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Price badge
                    ShadBadge(
                      child: Text(
                        '₩ ${_getPriceRange(space)}',
                        style: TextStyle(fontSize: 11),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getPriceRange(SpaceDetail space) {
    // Calculate price range based on box capacities
    // This is a simplified version - adjust based on your pricing logic
    return '10,000 ~ 50,000';
  }
}