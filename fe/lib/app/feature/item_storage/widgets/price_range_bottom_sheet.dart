import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  late TextEditingController _minPriceController;
  late TextEditingController _maxPriceController;
  late double _sliderMin;
  late double _sliderMax;

  @override
  void initState() {
    super.initState();
    _minPriceController = TextEditingController(
      text: widget.currentMinPrice > 0
          ? widget.currentMinPrice.toString()
          : widget.recommendedPrice.toString(),
    );
    _maxPriceController = TextEditingController(
      text: widget.currentMaxPrice > 0
          ? widget.currentMaxPrice.toString()
          : (widget.recommendedPrice * 1.5).round().toString(),
    );
    _sliderMin = widget.currentMinPrice > 0
        ? widget.currentMinPrice.toDouble()
        : widget.recommendedPrice.toDouble();
    _sliderMax = widget.currentMaxPrice > 0
        ? widget.currentMaxPrice.toDouble()
        : (widget.recommendedPrice * 1.5).toDouble();
  }

  @override
  void dispose() {
    _minPriceController.dispose();
    _maxPriceController.dispose();
    super.dispose();
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
              color: ShadTheme.of(context).colorScheme.mutedForeground.withOpacity(0.3),
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
                      color: ShadTheme.of(context).colorScheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: ShadTheme.of(context).colorScheme.primary.withOpacity(0.2),
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
                              style: ShadTheme.of(context).textTheme.small.copyWith(
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
                      color: ShadTheme.of(context).colorScheme.muted.withOpacity(0.05),
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
                              style: ShadTheme.of(context).textTheme.small.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ShadSlider(
                          initialValue: _sliderMin,
                          onChanged: (value) {
                            setState(() {
                              _sliderMin = value;
                              _minPriceController.text = value.round().toString();
                            });
                          },
                          min: 10000,
                          max: 200000,
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
                              style: ShadTheme.of(context).textTheme.small.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ShadSlider(
                          initialValue: _sliderMax,
                          onChanged: (value) {
                            setState(() {
                              _sliderMax = value;
                              _maxPriceController.text = value.round().toString();
                            });
                          },
                          min: 10000,
                          max: 200000,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    '직접 입력',
                    style: ShadTheme.of(context).textTheme.h4,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: ShadInputFormField(
                          id: 'min_price',
                          controller: _minPriceController,
                          label: Text(
                            '최소 금액',
                            style: ShadTheme.of(context).textTheme.small,
                          ),
                          placeholder: const Text('10,000'),
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          prefix: Text(
                            '₩',
                            style: ShadTheme.of(context).textTheme.muted,
                          ),
                          onChanged: (value) {
                            final intValue = int.tryParse(value) ?? 0;
                            if (intValue >= 10000 && intValue <= 200000) {
                              setState(() {
                                _sliderMin = intValue.toDouble();
                              });
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ShadInputFormField(
                          id: 'max_price',
                          controller: _maxPriceController,
                          label: Text(
                            '최대 금액',
                            style: ShadTheme.of(context).textTheme.small,
                          ),
                          placeholder: const Text('100,000'),
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          prefix: Text(
                            '₩',
                            style: ShadTheme.of(context).textTheme.muted,
                          ),
                          onChanged: (value) {
                            final intValue = int.tryParse(value) ?? 0;
                            if (intValue >= 10000 && intValue <= 200000) {
                              setState(() {
                                _sliderMax = intValue.toDouble();
                              });
                            }
                          },
                        ),
                      ),
                    ],
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
                final minPrice = int.tryParse(_minPriceController.text) ?? 0;
                final maxPrice = int.tryParse(_maxPriceController.text) ?? 0;
                widget.onPriceRangeChanged(minPrice, maxPrice);
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
                '소형 (< 50,000 cm³)',
                '₩10,000 ~ ₩30,000',
                Icons.backpack,
              ),
              const SizedBox(height: 8),
              _buildPriceReferenceRow(
                context,
                '중형 (< 200,000 cm³)',
                '₩30,000 ~ ₩80,000',
                Icons.luggage,
              ),
              const SizedBox(height: 8),
              _buildPriceReferenceRow(
                context,
                '대형 (> 200,000 cm³)',
                '₩80,000 ~ ₩200,000',
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