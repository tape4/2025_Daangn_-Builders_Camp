import 'package:flutter/material.dart';
import 'package:hankan/app/shared/widgets/shared_location_panel.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class ItemLocationPanel extends StatelessWidget {
  final String region;
  final String detailAddress;
  final Function(String, String) onLocationChanged;

  const ItemLocationPanel({
    Key? key,
    required this.region,
    required this.detailAddress,
    required this.onLocationChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SharedLocationPanel(
      region: region,
      detailAddress: detailAddress,
      onLocationChanged: onLocationChanged,
      title: '지역 정보',
      showStatusBadge: true,
      statusIcon: Icon(
        Icons.info_outline,
        size: 16,
        color: ShadTheme.of(context).colorScheme.mutedForeground,
      ),
      statusTitle: '현재 위치 정보',
    );
  }
}