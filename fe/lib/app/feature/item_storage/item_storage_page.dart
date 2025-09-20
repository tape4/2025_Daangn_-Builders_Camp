import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hankan/app/feature/item_storage/logic/item_storage_provider.dart';
import 'package:hankan/app/feature/item_storage/logic/item_storage_state.dart';
import 'package:hankan/app/feature/item_storage/widgets/item_image_dimension_section.dart';
import 'package:hankan/app/feature/item_storage/widgets/item_location_panel.dart';
import 'package:hankan/app/feature/item_storage/widgets/price_range_bottom_sheet.dart';
import 'package:hankan/app/feature/item_storage/widgets/storage_period_picker.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class ItemStoragePage extends ConsumerStatefulWidget {
  const ItemStoragePage({Key? key}) : super(key: key);

  @override
  ConsumerState<ItemStoragePage> createState() => _ItemStoragePageState();
}

class _ItemStoragePageState extends ConsumerState<ItemStoragePage> {
  void _showPriceBottomSheet() {
    final state = ref.read(itemStorageProvider);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => PriceRangeBottomSheet(
        volume: state.volume,
        currentMinPrice: state.minPrice,
        currentMaxPrice: state.maxPrice,
        recommendedPrice: state.recommendedPrice,
        onPriceRangeChanged: (minPrice, maxPrice) {
          ref.read(itemStorageProvider.notifier).updatePriceRange(minPrice, maxPrice);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(itemStorageProvider);
    final notifier = ref.read(itemStorageProvider.notifier);

    return Scaffold(
      backgroundColor: ShadTheme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: ShadTheme.of(context).colorScheme.background,
        elevation: 0,
        leading: ShadButton.ghost(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: Text(
          '물건 맡기기',
          style: ShadTheme.of(context).textTheme.h4,
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ItemImageDimensionSection(
                  imageUrl: state.imageUrl,
                  width: state.width,
                  depth: state.depth,
                  height: state.height,
                  onImageChanged: notifier.updateImageUrl,
                  onDimensionsChanged: notifier.updateDimensions,
                ),
                ItemLocationPanel(
                  region: state.region,
                  detailAddress: state.detailAddress,
                  onLocationChanged: notifier.updateLocation,
                ),
                StoragePeriodPicker(
                  startDate: state.startDate,
                  endDate: state.endDate,
                  onPeriodChanged: notifier.updateStoragePeriod,
                ),
                _buildPriceSection(context, state),
                if (state.errorMessage != null) ...[
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ShadAlert.destructive(
                      icon: const Icon(Icons.error_outline),
                      title: const Text('알림'),
                      description: Text(state.errorMessage!),
                    ),
                  ),
                ],
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                color: ShadTheme.of(context).colorScheme.background,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(16),
              child: ShadButton(
                onPressed: state.isValid && !state.isLoading
                    ? () async {
                        final success = await notifier.submitItemStorage();
                        if (success && context.mounted) {
                          ShadToaster.of(context).show(
                            ShadToast(
                              title: const Text('등록 완료'),
                              description: const Text('물건 맡기기 요청이 성공적으로 등록되었습니다.'),
                            ),
                          );
                          if (context.mounted) {
                            context.pop();
                          }
                        }
                      }
                    : null,
                size: ShadButtonSize.lg,
                child: state.isLoading
                    ? const CircularProgressIndicator()
                    : const Text('작성 완료'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceSection(BuildContext context, state) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ShadTheme.of(context).colorScheme.card,
        border: Border(
          bottom: BorderSide(
            color: ShadTheme.of(context).colorScheme.border,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.attach_money,
                size: 20,
                color: ShadTheme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text(
                '희망 가격',
                style: ShadTheme.of(context).textTheme.h4,
              ),
              if (state.minPrice > 0 && state.maxPrice > 0) ...[
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.check_circle,
                        size: 12,
                        color: Colors.green,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '설정됨',
                        style: ShadTheme.of(context).textTheme.muted.copyWith(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Colors.green,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 12),
          InkWell(
            onTap: state.volume > 0 ? _showPriceBottomSheet : null,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: state.volume == 0
                      ? ShadTheme.of(context).colorScheme.border.withOpacity(0.5)
                      : ShadTheme.of(context).colorScheme.border,
                ),
                color: state.volume == 0
                    ? ShadTheme.of(context).colorScheme.muted.withOpacity(0.1)
                    : null,
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.price_check,
                    size: 18,
                    color: state.minPrice > 0 && state.maxPrice > 0
                        ? ShadTheme.of(context).colorScheme.foreground
                        : ShadTheme.of(context).colorScheme.mutedForeground,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          state.minPrice > 0 && state.maxPrice > 0
                              ? '₩${state.minPrice.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')} ~ ₩${state.maxPrice.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}'
                              : state.volume == 0
                                  ? '먼저 물건 크기를 입력해주세요'
                                  : '가격 범위를 설정하세요',
                          style: state.minPrice > 0 && state.maxPrice > 0
                              ? ShadTheme.of(context).textTheme.small.copyWith(
                                    fontWeight: FontWeight.w600,
                                  )
                              : ShadTheme.of(context).textTheme.muted.copyWith(
                                    fontSize: 14,
                                  ),
                        ),
                        if (state.volume > 0 && state.minPrice == 0) ...[
                          const SizedBox(height: 2),
                          Text(
                            '추천 가격: ₩${state.recommendedPrice.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')} / 월',
                            style: ShadTheme.of(context).textTheme.muted.copyWith(
                                  fontSize: 12,
                                  color: ShadTheme.of(context).colorScheme.primary,
                                ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (state.volume > 0) ...[
                    Icon(
                      Icons.chevron_right,
                      size: 20,
                      color: ShadTheme.of(context).colorScheme.mutedForeground,
                    ),
                  ],
                ],
              ),
            ),
          ),
          if (state.minPrice > 0 && state.maxPrice > 0) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: ShadTheme.of(context).colorScheme.primary.withOpacity(0.05),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: ShadTheme.of(context).colorScheme.primary.withOpacity(0.2),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 16,
                    color: ShadTheme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '설정된 가격 범위',
                          style: ShadTheme.of(context).textTheme.muted.copyWith(
                                fontSize: 11,
                              ),
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: ShadTheme.of(context).colorScheme.background,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                '최소: ₩${state.minPrice.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                                style: ShadTheme.of(context).textTheme.muted.copyWith(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: ShadTheme.of(context).colorScheme.background,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                '최대: ₩${state.maxPrice.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                                style: ShadTheme.of(context).textTheme.muted.copyWith(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                            ),
                          ],
                        ),
                        if (state.storageDays > 0) ...[
                          const SizedBox(height: 2),
                          Text(
                            '총 ${state.storageDays}일 보관 예정',
                            style: ShadTheme.of(context).textTheme.muted.copyWith(
                                  fontSize: 11,
                                ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}