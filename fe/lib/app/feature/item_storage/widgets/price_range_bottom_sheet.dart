import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class PriceRangeBottomSheet extends StatefulWidget {
  final double volume;
  final int currentMinPrice;
  final int currentMaxPrice;
  final int recommendedPrice;
  final Function(int, int) onPriceRangeChanged;

  const PriceRangeBottomSheet({
    Key? key,
    required this.volume,
    required this.currentMinPrice,
    required this.currentMaxPrice,
    required this.recommendedPrice,
    required this.onPriceRangeChanged,
  }) : super(key: key);

  @override
  State<PriceRangeBottomSheet> createState() => _PriceRangeBottomSheetState();
}

class _PriceRangeBottomSheetState extends State<PriceRangeBottomSheet> {
  late double _sliderMin;
  late double _sliderMax;

  // 추천 가격의 50% ~ 200% 범위 계산
  double get _minBound => (widget.recommendedPrice * 0.5 / 500).round() * 500;
  double get _maxBound => (widget.recommendedPrice * 2.0 / 500).round() * 500;

  @override
  void initState() {
    super.initState();

    // 현재 가격이 설정되어 있으면 사용, 없으면 추천 가격 기준으로 설정
    if (widget.currentMinPrice > 0 && widget.currentMaxPrice > 0) {
      // 현재 가격을 500원 단위로 반올림하고 범위 내로 제한
      _sliderMin = ((widget.currentMinPrice / 500).round() * 500).toDouble();
      _sliderMax = ((widget.currentMaxPrice / 500).round() * 500).toDouble();

      // 범위를 벗어나면 조정
      if (_sliderMin < _minBound) _sliderMin = _minBound;
      if (_sliderMin > _maxBound) _sliderMin = _maxBound;
      if (_sliderMax < _minBound) _sliderMax = _minBound;
      if (_sliderMax > _maxBound) _sliderMax = _maxBound;

      // 최소가 최대보다 크면 교체
      if (_sliderMin > _sliderMax) {
        final temp = _sliderMin;
        _sliderMin = _sliderMax;
        _sliderMax = temp;
      }
    } else {
      // 기본값: 추천 가격의 80% ~ 120%
      _sliderMin =
          ((widget.recommendedPrice * 0.8 / 500).round() * 500).toDouble();
      _sliderMax =
          ((widget.recommendedPrice * 1.2 / 500).round() * 500).toDouble();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  // 500원 단위로 반올림하는 헬퍼 메서드
  double _roundToNearest500(double value) {
    return (value / 500).round() * 500.0;
  }

  String _formatVolume(double volume) {
    if (volume < 1000) {
      return '${volume.toStringAsFixed(0)} cm³';
    } else if (volume < 1000000) {
      return '${(volume / 1000).toStringAsFixed(1)} L';
    } else {
      return '${(volume / 1000000).toStringAsFixed(2)} m³';
    }
  }

  String _getVolumeCategory(double volume) {
    if (volume < 50000) {
      return '소형 (가방 크기)';
    } else if (volume < 200000) {
      return '중형 (여행 가방 크기)';
    } else if (volume < 500000) {
      return '대형 (냉장고 크기)';
    } else {
      return '특대형';
    }
  }

  @override
  Widget build(BuildContext context) {
    final volumeCategory = _getVolumeCategory(widget.volume);

    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: BoxDecoration(
        color: ShadTheme.of(context).colorScheme.background,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: ShadTheme.of(context)
                  .colorScheme
                  .mutedForeground
                  .withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '가격 범위 설정',
                      style: ShadTheme.of(context).textTheme.h3,
                    ),
                    ShadButton.ghost(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '부피: ${_formatVolume(widget.volume)} ($volumeCategory)',
                  style: ShadTheme.of(context).textTheme.muted,
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: ShadTheme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: ShadTheme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.2),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.recommend,
                              size: 20,
                              color: ShadTheme.of(context).colorScheme.primary,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '추천 가격',
                              style: ShadTheme.of(context)
                                  .textTheme
                                  .small
                                  .copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '₩${widget.recommendedPrice.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                          style: ShadTheme.of(context).textTheme.h2,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '이 크기의 물건을 보관하는 평균 월 비용입니다',
                          style: ShadTheme.of(context).textTheme.muted.copyWith(
                                fontSize: 12,
                              ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    '가격 범위 슬라이더',
                    style: ShadTheme.of(context).textTheme.h4,
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: ShadTheme.of(context)
                          .colorScheme
                          .muted
                          .withOpacity(0.05),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: ShadTheme.of(context).colorScheme.border,
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '최소',
                              style: ShadTheme.of(context).textTheme.muted,
                            ),
                            Text(
                              '₩${_sliderMin.round().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                              style: ShadTheme.of(context)
                                  .textTheme
                                  .small
                                  .copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ShadSlider(
                          initialValue: _sliderMin,
                          onChanged: (value) {
                            final roundedValue = _roundToNearest500(value);
                            setState(() {
                              _sliderMin = roundedValue;
                              // 최소가 최대를 넘으면 최대도 같이 올림
                              if (_sliderMin > _sliderMax) {
                                _sliderMax = _sliderMin;
                              }
                            });
                          },
                          min: _minBound,
                          max: _maxBound,
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '최대',
                              style: ShadTheme.of(context).textTheme.muted,
                            ),
                            Text(
                              '₩${_sliderMax.round().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                              style: ShadTheme.of(context)
                                  .textTheme
                                  .small
                                  .copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ShadSlider(
                          initialValue: _sliderMax,
                          onChanged: (value) {
                            final roundedValue = _roundToNearest500(value);
                            setState(() {
                              _sliderMax = roundedValue;
                              // 최대가 최소보다 작으면 최소도 같이 내림
                              if (_sliderMax < _sliderMin) {
                                _sliderMin = _sliderMax;
                              }
                            });
                          },
                          min: _minBound,
                          max: _maxBound,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildPriceReference(context),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: ShadTheme.of(context).colorScheme.background,
              border: Border(
                top: BorderSide(
                  color: ShadTheme.of(context).colorScheme.border,
                ),
              ),
            ),
            child: ShadButton(
              onPressed: () {
                widget.onPriceRangeChanged(
                    _sliderMin.round(), _sliderMax.round());
                Navigator.of(context).pop();
              },
              size: ShadButtonSize.lg,
              child: const Text('가격 설정'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceReference(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '가격 참고',
          style: ShadTheme.of(context).textTheme.h4,
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: ShadTheme.of(context).colorScheme.muted.withOpacity(0.05),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: ShadTheme.of(context).colorScheme.border,
            ),
          ),
          child: Column(
            children: [
              _buildPriceReferenceRow(
                context,
                '소형 (< 50L)',
                '₩5,000 ~ ₩15,000',
                Icons.backpack,
              ),
              const SizedBox(height: 8),
              _buildPriceReferenceRow(
                context,
                '중형 (50L ~ 200L)',
                '₩15,000 ~ ₩40,000',
                Icons.luggage,
              ),
              const SizedBox(height: 8),
              _buildPriceReferenceRow(
                context,
                '대형 (> 200L)',
                '₩40,000 ~ ₩100,000',
                Icons.kitchen,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPriceReferenceRow(
    BuildContext context,
    String size,
    String price,
    IconData icon,
  ) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: ShadTheme.of(context).colorScheme.mutedForeground,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            size,
            style: ShadTheme.of(context).textTheme.small,
          ),
        ),
        Text(
          price,
          style: ShadTheme.of(context).textTheme.small.copyWith(
                fontWeight: FontWeight.w600,
                color: ShadTheme.of(context).colorScheme.primary,
              ),
        ),
      ],
    );
  }
}
