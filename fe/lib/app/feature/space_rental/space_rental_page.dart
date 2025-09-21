import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hankan/app/auth/auth_helper.dart';
import 'package:hankan/app/feature/space_rental/logic/space_rental_provider.dart';
import 'package:hankan/app/feature/space_rental/logic/space_rental_state.dart';
import 'package:hankan/app/feature/space_rental/widgets/dimension_input_section.dart';
import 'package:hankan/app/feature/space_rental/widgets/storage_option_item.dart';
import 'package:hankan/app/widgets/date_range_picker.dart';
import 'package:hankan/app/feature/space_rental/models/space_rental_option.dart';
import 'package:hankan/app/widgets/location_panel.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class SpaceRentalPage extends ConsumerStatefulWidget {
  const SpaceRentalPage({Key? key}) : super(key: key);

  @override
  ConsumerState<SpaceRentalPage> createState() => _SpaceRentalPageState();
}

class _SpaceRentalPageState extends ConsumerState<SpaceRentalPage> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(spaceRentalProvider);
    final notifier = ref.read(spaceRentalProvider.notifier);

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
          '공간 빌려주기',
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
                DimensionInputSection(
                  imagePath: state.imagePath,
                  width: state.width,
                  depth: state.depth,
                  height: state.height,
                  onImageChanged: notifier.updateImagePath,
                  onDimensionsChanged: notifier.updateDimensions,
                ),
                const SizedBox(height: 20),
                LocationPanel(
                  region: state.region,
                  detailAddress: state.detailAddress,
                  onLocationChanged: notifier.updateLocation,
                  title: '지역 정보',
                  showStatusBadge: false,
                  statusIcon: Icon(
                    Icons.check_circle,
                    size: 16,
                    color: Colors.green,
                  ),
                  statusTitle: '현재 선택된 지역',
                ),
                const SizedBox(height: 20),
                DateRangePicker(
                  title: '대여 기간',
                  startDate: state.startDate,
                  endDate: state.endDate,
                  onDateRangeChanged: notifier.updateDateRange,
                  description: '공간을 대여할 기간을 선택해주세요',
                ),
                const SizedBox(height: 20),
                _buildOptionsSection(context, state, notifier),
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
                enabled: state.isValid && !state.isLoading,
                onPressed: state.isValid && !state.isLoading
                    ? () async {
                        debugPrint('Submit space rental');
                        final isAuthenticated =
                            await AuthHelper.checkAuthAndShowBottomSheet(
                          context: context,
                          ref: ref,
                        );
                        if (!isAuthenticated) return;

                        final success = await notifier.submitSpaceRental();
                        if (success && context.mounted) {
                          if (context.mounted) {
                            context.pop();
                            ShadToaster.of(context).show(
                              ShadToast(
                                title: const Text('등록 완료'),
                                description:
                                    const Text('공간 대여 정보가 성공적으로 등록되었습니다.'),
                              ),
                            );
                          }
                        }
                      }
                    : () {
                        debugPrint('Form is not valid or loading');
                      },
                size: ShadButtonSize.lg,
                child: state.isLoading
                    ? const CircularProgressIndicator()
                    : const Text('등록 완료'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionsSection(
    BuildContext context,
    SpaceRentalState state,
    SpaceRentalNotifier notifier,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '제공 가능한 옵션',
                style: ShadTheme.of(context).textTheme.h4,
              ),
              if (state.totalVolume > 0) ...[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '남은 공간',
                      style: ShadTheme.of(context).textTheme.small,
                    ),
                    Text(
                      '${(state.remainingVolume / 1000).toStringAsFixed(1)} L',
                      style: ShadTheme.of(context).textTheme.muted,
                    ),
                  ],
                ),
              ],
            ],
          ),
          const SizedBox(height: 12),
          if (state.totalVolume == 0) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(
                  color: ShadTheme.of(context).colorScheme.border,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  '먼저 공간 크기를 입력해주세요',
                  style: ShadTheme.of(context).textTheme.muted,
                ),
              ),
            ),
          ] else ...[
            ...StorageOption.values
                .where((option) => option != StorageOption.box)
                .map((option) {
              final quantity = state.optionQuantities[option] ?? 0;
              final price = state.optionPrices[option] ?? 0;
              final maxQuantity = state.getMaxQuantityForOption(option);

              return StorageOptionItem(
                option: option,
                quantity: quantity,
                price: price,
                maxQuantity: maxQuantity,
                onQuantityChanged: (newQuantity) {
                  notifier.updateOptionQuantity(option, newQuantity);
                },
                onPriceChanged: (newPrice) {
                  notifier.updateOptionPrice(option, newPrice);
                },
              );
            }),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color:
                    ShadTheme.of(context).colorScheme.muted.withOpacity(0.05),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 14,
                    color: ShadTheme.of(context).colorScheme.mutedForeground,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '부피로만 계산되어 실제 배치 가능 여부와 다를 수 있습니다',
                      style: ShadTheme.of(context).textTheme.muted.copyWith(
                            fontSize: 12,
                          ),
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
