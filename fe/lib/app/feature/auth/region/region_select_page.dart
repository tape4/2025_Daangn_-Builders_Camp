import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kpostal/kpostal.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class RegionSelectPage extends ConsumerStatefulWidget {
  final String phone;
  final String nickname;

  const RegionSelectPage({
    Key? key,
    required this.phone,
    required this.nickname,
  }) : super(key: key);

  @override
  ConsumerState<RegionSelectPage> createState() => _RegionSelectPageState();
}

class _RegionSelectPageState extends ConsumerState<RegionSelectPage> {
  String? _selectedRegion;
  String? _detailAddress;
  final TextEditingController _regionController = TextEditingController();
  final TextEditingController _detailController = TextEditingController();

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
              _selectedRegion = result.address;
              _regionController.text = result.address;
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ShadTheme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: ShadButton.ghost(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 24),
              Text(
                '지역을 선택해주세요',
                style: ShadTheme.of(context).textTheme.h2,
              ),
              const SizedBox(height: 8),
              Text(
                '서비스를 이용할 지역을 선택해주세요',
                style: ShadTheme.of(context).textTheme.muted,
              ),
              const SizedBox(height: 40),
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
                prefix: const Icon(Icons.location_on_outlined, size: 18),
                suffix: ShadButton.ghost(
                  size: ShadButtonSize.sm,
                  onPressed: _searchAddress,
                  child: const Text('주소 검색'),
                ),
                onPressed: _searchAddress,
              ),
              if (_selectedRegion != null) ...[
                const SizedBox(height: 16),
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
                  onChanged: (value) {
                    setState(() {
                      _detailAddress = value;
                    });
                  },
                ),
              ],
              const Spacer(),
              ShadButton(
                onPressed: _selectedRegion != null
                    ? () {
                        context.push(
                          '/auth/confirm',
                          extra: {
                            'phone': widget.phone,
                            'nickname': widget.nickname,
                            'region': _selectedRegion,
                            'detailAddress': _detailAddress,
                          },
                        );
                      }
                    : null,
                size: ShadButtonSize.lg,
                child: const Text('다음'),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
