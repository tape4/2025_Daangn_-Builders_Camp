import 'package:flutter/material.dart';
import 'package:hankan/app/shared/widgets/shared_location_panel.dart';

class LocationPanel extends StatelessWidget {
  final String region;
  final String detailAddress;
  final Function(String, String) onLocationChanged;

  const LocationPanel({
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
      showStatusBadge: false,
      statusIcon: Icon(
        Icons.check_circle,
        size: 16,
        color: Colors.green,
      ),
      statusTitle: '현재 선택된 지역',
    );
  }
}