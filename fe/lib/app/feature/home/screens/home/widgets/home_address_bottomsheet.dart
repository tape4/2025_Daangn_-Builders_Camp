import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hankan/app/routing/router_service.dart';
import 'package:hankan/app/service/gps_service.dart';
import 'package:hankan/app/service/secure_storage_service.dart';
import 'package:kpostal/kpostal.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class HomeAddressBottomsheet extends ConsumerStatefulWidget {
  const HomeAddressBottomsheet({Key? key}) : super(key: key);

  @override
  ConsumerState<HomeAddressBottomsheet> createState() => _HomeAddressBottomsheetState();
}

class _HomeAddressBottomsheetState extends ConsumerState<HomeAddressBottomsheet> {
  String? selectedAddress;
  final SecureStorageService _storageService = SecureStorageService.I;

  @override
  void initState() {
    super.initState();
    _loadSavedAddress();
  }

  Future<void> _loadSavedAddress() async {
    final address = await _storageService.read('selected_address');
    if (mounted) {
      setState(() {
        selectedAddress = address;
      });
    }
  }

  Future<void> _searchAddress() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => KpostalView(
          callback: (Kpostal result) async {
            // 선택한 주소의 좌표를 가져오기
            final locations = await GpsService.I.getCoordinatesFromAddress(result.address);
            if (locations == null || locations.isEmpty) {
              RouterService.I.showNotification(
                title: '주소 확인 실패',
                message: '선택한 주소의 위치를 확인할 수 없습니다',
                isError: true,
              );
              return;
            }

            // 현재 위치 가져오기
            final currentPosition = await GpsService.I.getCurrentLocation();
            if (currentPosition == null) {
              // 현재 위치를 가져올 수 없는 경우에도 주소 설정 허용
              setState(() {
                selectedAddress = result.address;
              });
              await _storageService.write('selected_address', result.address);
              if (mounted) {
                Navigator.pop(context, result.address);
              }
              return;
            }

            // 거리 계산 (미터 단위)
            final distance = await GpsService.I.calculateDistance(
              currentPosition.latitude,
              currentPosition.longitude,
              locations.first.latitude,
              locations.first.longitude,
            );

            // 10km 이내인지 확인
            if (distance > 10000) {
              RouterService.I.showNotification(
                title: '위치 확인 필요',
                message: '선택한 주소가 현재 위치에서 너무 멀리 떨어져 있습니다 (10km 이상)',
                isError: true,
              );
              return;
            }

            // 거리 확인 완료 - 주소 저장
            setState(() {
              selectedAddress = result.address;
            });
            await _storageService.write('selected_address', result.address);
            if (mounted) {
              Navigator.pop(context, result.address);
            }
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 280,
      child: Column(
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: Colors.black26,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 5),
          Center(
            child: Text(
              "지역 선택",
              style: ShadTheme.of(context).textTheme.h4,
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                if (selectedAddress != null) ...[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: ShadTheme.of(context)
                          .colorScheme
                          .muted
                          .withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: ShadTheme.of(context).colorScheme.border,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 20,
                          color: ShadTheme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '선택된 주소',
                                style: ShadTheme.of(context)
                                    .textTheme
                                    .muted
                                    .copyWith(
                                      fontSize: 12,
                                    ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                selectedAddress!,
                                style: ShadTheme.of(context)
                                    .textTheme
                                    .small
                                    .copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
                ShadButton(
                  onPressed: _searchAddress,
                  size: ShadButtonSize.lg,
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.search, size: 20, color: Colors.white),
                      const SizedBox(width: 8),
                      Text(selectedAddress != null ? '주소 변경' : '주소 검색'),
                    ],
                  ),
                ),
                if (selectedAddress != null) ...[
                  const SizedBox(height: 12),
                  ShadButton.outline(
                    onPressed: () {
                      Navigator.pop(context, selectedAddress);
                    },
                    size: ShadButtonSize.lg,
                    width: double.infinity,
                    child: Text('선택 완료'),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
