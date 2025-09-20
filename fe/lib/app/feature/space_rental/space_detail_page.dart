import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hankan/app/feature/space_rental/logic/space_detail_provider.dart';
import 'package:hankan/app/feature/space_rental/widgets/space_location_map.dart';
import 'package:intl/intl.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class SpaceDetailPage extends ConsumerWidget {
  final int spaceId;

  const SpaceDetailPage({
    Key? key,
    required this.spaceId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(spaceDetailProvider(spaceId));
    final notifier = ref.read(spaceDetailProvider(spaceId).notifier);

    if (state.isLoading) {
      return Scaffold(
        backgroundColor: ShadTheme.of(context).colorScheme.background,
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (state.hasError || state.spaceDetail == null) {
      return Scaffold(
        backgroundColor: ShadTheme.of(context).colorScheme.background,
        appBar: AppBar(
          backgroundColor: ShadTheme.of(context).colorScheme.background,
          leading: ShadButton.ghost(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.pop(),
          ),
        ),
        body: Center(
          child: ShadAlert.destructive(
            icon: const Icon(Icons.error_outline),
            title: const Text('오류'),
            description: Text(state.errorMessage ?? '공간 정보를 불러올 수 없습니다.'),
          ),
        ),
      );
    }

    final space = state.spaceDetail!;
    final dateFormat = DateFormat('yyyy.MM.dd');

    return Scaffold(
      backgroundColor: ShadTheme.of(context).colorScheme.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: ShadTheme.of(context).colorScheme.background,
            leading: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: ShadTheme.of(context).colorScheme.background.withOpacity(0.9),
                shape: BoxShape.circle,
              ),
              child: ShadButton.ghost(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => context.pop(),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                space.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: ShadTheme.of(context).colorScheme.muted,
                    child: Icon(
                      Icons.image_not_supported,
                      size: 60,
                      color: ShadTheme.of(context).colorScheme.mutedForeground,
                    ),
                  );
                },
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    space.name,
                    style: ShadTheme.of(context).textTheme.h2,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    space.description,
                    style: ShadTheme.of(context).textTheme.p,
                  ),
                  const SizedBox(height: 24),

                  _buildOwnerSection(context, space),
                  const SizedBox(height: 24),

                  _buildAvailablePeriod(context, space, dateFormat),
                  const SizedBox(height: 24),

                  _buildStorageOptions(context, space, state, notifier),
                  const SizedBox(height: 24),

                  Text(
                    '위치',
                    style: ShadTheme.of(context).textTheme.h4,
                  ),
                  const SizedBox(height: 12),
                  SpaceLocationMap(
                    latitude: space.latitude,
                    longitude: space.longitude,
                    address: space.address,
                    height: 250,
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ShadButton(
          onPressed: state.selectedSize != null
              ? () async {
                  final success = await notifier.submitRentalRequest();
                  if (success && context.mounted) {
                    ShadToaster.of(context).show(
                      ShadToast(
                        title: const Text('신청 완료'),
                        description: const Text('대여 신청이 성공적으로 접수되었습니다.'),
                      ),
                    );
                    context.pop();
                  }
                }
              : null,
          size: ShadButtonSize.lg,
          child: const Text('대여 신청하기'),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildOwnerSection(BuildContext context, space) {
    return ShadCard(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            ShadAvatar(
              space.owner.profileImageUrl,
              placeholder: Text(space.owner.nickname.substring(0, 1)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '공간 제공자',
                    style: ShadTheme.of(context).textTheme.small.copyWith(
                      color: ShadTheme.of(context).colorScheme.mutedForeground,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    space.owner.nickname,
                    style: ShadTheme.of(context).textTheme.p.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.star,
                      color: Colors.amber,
                      size: 18,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      space.owner.rating.toStringAsFixed(1),
                      style: ShadTheme.of(context).textTheme.p.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Text(
                  '리뷰 ${space.owner.reviewCount}개',
                  style: ShadTheme.of(context).textTheme.small.copyWith(
                    color: ShadTheme.of(context).colorScheme.mutedForeground,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvailablePeriod(BuildContext context, space, DateFormat dateFormat) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: ShadTheme.of(context).colorScheme.muted.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: ShadTheme.of(context).colorScheme.border,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.calendar_today,
            size: 16,
            color: ShadTheme.of(context).colorScheme.mutedForeground,
          ),
          const SizedBox(width: 8),
          Text(
            '대여 가능 기간: ',
            style: ShadTheme.of(context).textTheme.small,
          ),
          Text(
            '${dateFormat.format(space.availableStartDate)} ~ ${dateFormat.format(space.availableEndDate)}',
            style: ShadTheme.of(context).textTheme.small.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStorageOptions(BuildContext context, space, state, notifier) {
    final sizes = [
      {'label': 'XS', 'capacity': space.boxCapacityXs, 'size': 'xs'},
      {'label': 'S', 'capacity': space.boxCapacityS, 'size': 's'},
      {'label': 'M', 'capacity': space.boxCapacityM, 'size': 'm'},
      {'label': 'L', 'capacity': space.boxCapacityL, 'size': 'l'},
      {'label': 'XL', 'capacity': space.boxCapacityXl, 'size': 'xl'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '대여 가능한 사이즈',
          style: ShadTheme.of(context).textTheme.h4,
        ),
        const SizedBox(height: 12),
        Text(
          '총 ${space.totalBoxCount}개 박스 보관 가능',
          style: ShadTheme.of(context).textTheme.muted,
        ),
        const SizedBox(height: 16),
        ...sizes.map((size) {
          final isSelected = state.selectedSize == size['size'];
          final isAvailable = (size['capacity'] as int) > 0;

          return Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: InkWell(
              onTap: isAvailable
                  ? () => notifier.selectSize(size['size'] as String)
                  : null,
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isSelected
                        ? ShadTheme.of(context).colorScheme.primary
                        : ShadTheme.of(context).colorScheme.border,
                    width: isSelected ? 2 : 1,
                  ),
                  color: isSelected
                      ? ShadTheme.of(context).colorScheme.primary.withOpacity(0.05)
                      : isAvailable
                          ? Colors.transparent
                          : ShadTheme.of(context).colorScheme.muted.withOpacity(0.1),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: isAvailable
                            ? ShadTheme.of(context).colorScheme.primary
                            : ShadTheme.of(context).colorScheme.mutedForeground,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Center(
                        child: Text(
                          size['label'] as String,
                          style: TextStyle(
                            color: ShadTheme.of(context).colorScheme.primaryForeground,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '사이즈 ${size['label']}',
                            style: ShadTheme.of(context).textTheme.p.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            isAvailable
                                ? '${size['capacity']}개 보관 가능'
                                : '보관 불가',
                            style: ShadTheme.of(context).textTheme.small.copyWith(
                              color: isAvailable
                                  ? ShadTheme.of(context).colorScheme.mutedForeground
                                  : ShadTheme.of(context).colorScheme.destructive,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (isSelected)
                      Icon(
                        Icons.check_circle,
                        color: ShadTheme.of(context).colorScheme.primary,
                        size: 24,
                      ),
                  ],
                ),
              ),
            ),
          );
        }),
      ],
    );
  }
}