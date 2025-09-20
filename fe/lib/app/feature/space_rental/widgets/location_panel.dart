import 'package:flutter/material.dart';
import 'package:kpostal/kpostal.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class LocationPanel extends StatefulWidget {
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
  State<LocationPanel> createState() => _LocationPanelState();
}

class _LocationPanelState extends State<LocationPanel> {
  late TextEditingController _regionController;
  late TextEditingController _detailController;

  @override
  void initState() {
    super.initState();
    _regionController = TextEditingController(text: widget.region);
    _detailController = TextEditingController(text: widget.detailAddress);
  }

  @override
  void dispose() {
    _regionController.dispose();
    _detailController.dispose();
    super.dispose();
  }

  Future<void> _searchAddress() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => KpostalView(
          useLocalServer: true,
          localPort: 8080,
          callback: (Kpostal result) {
            setState(() {
              _regionController.text = result.address;
            });
            widget.onLocationChanged(result.address, _detailController.text);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                Icons.location_on,
                size: 20,
                color: ShadTheme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text(
                '지역 정보',
                style: ShadTheme.of(context).textTheme.h4,
              ),
            ],
          ),
          const SizedBox(height: 12),
          ShadInputFormField(
            id: 'region',
            controller: _regionController,
            label: Text(
              '주소',
              style: ShadTheme.of(context).textTheme.small.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            placeholder: const Text('주소를 검색해주세요'),
            readOnly: true,
            prefix: const Icon(Icons.home, size: 18),
            suffix: ShadButton.ghost(
              size: ShadButtonSize.sm,
              onPressed: _searchAddress,
              child: const Text('주소 검색'),
            ),
            onPressed: _searchAddress,
          ),
          if (_regionController.text.isNotEmpty) ...[
            const SizedBox(height: 12),
            ShadInputFormField(
              id: 'detail',
              controller: _detailController,
              label: Text(
                '상세 주소',
                style: ShadTheme.of(context).textTheme.small.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              placeholder: const Text('상세 주소를 입력해주세요 (선택)'),
              prefix: const Icon(Icons.apartment, size: 18),
              onChanged: (value) {
                widget.onLocationChanged(_regionController.text, value);
              },
            ),
          ],
          if (_regionController.text.isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: ShadTheme.of(context).colorScheme.muted.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: ShadTheme.of(context).colorScheme.border,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.check_circle,
                    size: 16,
                    color: Colors.green,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '현재 선택된 지역',
                          style: ShadTheme.of(context).textTheme.muted.copyWith(
                                fontSize: 12,
                              ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _regionController.text,
                          style: ShadTheme.of(context).textTheme.small.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        if (_detailController.text.isNotEmpty) ...[
                          const SizedBox(height: 2),
                          Text(
                            _detailController.text,
                            style: ShadTheme.of(context).textTheme.muted.copyWith(
                                  fontSize: 12,
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