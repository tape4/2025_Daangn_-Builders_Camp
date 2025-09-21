import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hankan/app/model/space_detail_model.dart';
import 'package:hankan/app/provider/location_provider.dart';
import 'package:hankan/app/service/gps_service.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class SpaceCarouselCard extends ConsumerWidget {
  final SpaceDetail space;
  final VoidCallback? onTap;

  const SpaceCarouselCard({
    Key? key,
    required this.space,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentPosition = ref.watch(currentLocationProvider);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: ShadTheme.of(context).colorScheme.background,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with name and rating
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          space.address,
                          style: ShadTheme.of(context).textTheme.h4,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.near_me_outlined,
                              size: 14,
                              color: ShadTheme.of(context)
                                  .colorScheme
                                  .mutedForeground,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: currentPosition.when(
                                data: (position) {
                                  if (position != null) {
                                    final distance = GpsService.I.calculateDistance(
                                      position.latitude,
                                      position.longitude,
                                      space.latitude,
                                      space.longitude,
                                    );
                                    return FutureBuilder<double>(
                                      future: Future.value(distance),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          final distanceInMeters = snapshot.data!;
                                          final formattedDistance = _formatDistance(distanceInMeters);
                                          return Text(
                                            formattedDistance,
                                            style: ShadTheme.of(context)
                                                .textTheme
                                                .muted
                                                .copyWith(
                                                  fontSize: 12,
                                                ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          );
                                        }
                                        return Text(
                                          '거리 계산 중...',
                                          style: ShadTheme.of(context)
                                              .textTheme
                                              .muted
                                              .copyWith(
                                                fontSize: 12,
                                              ),
                                        );
                                      },
                                    );
                                  }
                                  return Text(
                                    '위치 정보 없음',
                                    style: ShadTheme.of(context)
                                        .textTheme
                                        .muted
                                        .copyWith(
                                          fontSize: 12,
                                        ),
                                  );
                                },
                                loading: () => Text(
                                  '위치 확인 중...',
                                  style: ShadTheme.of(context)
                                      .textTheme
                                      .muted
                                      .copyWith(
                                        fontSize: 12,
                                      ),
                                ),
                                error: (_, __) => Text(
                                  '위치 확인 실패',
                                  style: ShadTheme.of(context)
                                      .textTheme
                                      .muted
                                      .copyWith(
                                        fontSize: 12,
                                      ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (space.rating > 0) ...[
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.amber.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 16),

              // Box capacity section
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color:
                      ShadTheme.of(context).colorScheme.muted.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.inventory_2_outlined,
                          size: 16,
                          color: ShadTheme.of(context).colorScheme.foreground,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '보관 가능 박스',
                          style: ShadTheme.of(context).textTheme.p.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        const Spacer(),
                        ShadBadge(
                          child: Text(
                            '총 ${space.totalBoxCount}개',
                            style: TextStyle(
                                fontSize: 11, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildBoxCapacityItem(
                            context, 'XS', space.boxCapacityXs),
                        _buildBoxCapacityItem(context, 'S', space.boxCapacityS),
                        _buildBoxCapacityItem(context, 'M', space.boxCapacityM),
                        _buildBoxCapacityItem(context, 'L', space.boxCapacityL),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBoxCapacityItem(
      BuildContext context, String size, int capacity) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: capacity > 0
                ? ShadTheme.of(context).colorScheme.primary.withOpacity(0.1)
                : ShadTheme.of(context).colorScheme.muted.withOpacity(0.5),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            size,
            style: ShadTheme.of(context).textTheme.small.copyWith(
                  fontWeight: FontWeight.w600,
                  color: capacity > 0
                      ? ShadTheme.of(context).colorScheme.primary
                      : ShadTheme.of(context).colorScheme.mutedForeground,
                ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '$capacity',
          style: ShadTheme.of(context).textTheme.muted.copyWith(
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
        ),
      ],
    );
  }

  String _formatDistance(double meters) {
    if (meters < 1000) {
      return '${meters.toStringAsFixed(0)}m';
    } else {
      final km = meters / 1000;
      return '${km.toStringAsFixed(1)}km';
    }
  }
}
