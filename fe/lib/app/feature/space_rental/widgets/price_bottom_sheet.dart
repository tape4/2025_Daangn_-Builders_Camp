import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hankan/app/feature/space_rental/models/space_rental_option.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class PriceBottomSheet extends StatefulWidget {
  final StorageOption option;
  final int currentPrice;
  final Function(int) onPriceChanged;

  const PriceBottomSheet({
    Key? key,
    required this.option,
    required this.currentPrice,
    required this.onPriceChanged,
  }) : super(key: key);

  @override
  State<PriceBottomSheet> createState() => _PriceBottomSheetState();
}

class _PriceBottomSheetState extends State<PriceBottomSheet> {
  late TextEditingController _priceController;
  int _selectedPrice = 0;

  @override
  void initState() {
    super.initState();
    _selectedPrice = widget.currentPrice > 0
        ? widget.currentPrice
        : widget.option.recommendedPrice;
    _priceController = TextEditingController(text: _selectedPrice.toString());
  }

  @override
  void dispose() {
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
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
                      '${widget.option.displayName} 옵션 가격 설정',
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
                  '크기: ${widget.option.dimensionText}',
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
                          '₩${widget.option.recommendedPrice}',
                          style: ShadTheme.of(context).textTheme.h2,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '이 크기의 평균 대여료입니다',
                          style: ShadTheme.of(context).textTheme.muted.copyWith(
                                fontSize: 12,
                              ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    '가격 범위 참고',
                    style: ShadTheme.of(context).textTheme.h4,
                  ),
                  const SizedBox(height: 12),
                  _buildPriceRange(context),
                  const SizedBox(height: 24),
                  Text(
                    '직접 입력',
                    style: ShadTheme.of(context).textTheme.h4,
                  ),
                  const SizedBox(height: 12),
                  ShadInputFormField(
                    id: 'custom_price',
                    controller: _priceController,
                    label: Text(
                      '월 대여료',
                      style: ShadTheme.of(context).textTheme.small,
                    ),
                    placeholder: const Text('가격을 입력하세요'),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    prefix: Text(
                      '₩',
                      style: ShadTheme.of(context).textTheme.muted,
                    ),
                    onChanged: (value) {
                      setState(() {
                        _selectedPrice = int.tryParse(value) ?? 0;
                      });
                    },
                  ),
                  const SizedBox(height: 24),
                  Text(
                    '빠른 선택',
                    style: ShadTheme.of(context).textTheme.h4,
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _getQuickPrices().map((price) {
                      final isSelected = _selectedPrice == price;
                      return InkWell(
                        onTap: () {
                          setState(() {
                            _selectedPrice = price;
                            _priceController.text = price.toString();
                          });
                        },
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? ShadTheme.of(context).colorScheme.primary
                                : ShadTheme.of(context).colorScheme.muted.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isSelected
                                  ? ShadTheme.of(context).colorScheme.primary
                                  : ShadTheme.of(context).colorScheme.border,
                            ),
                          ),
                          child: Text(
                            '₩${price}',
                            style: TextStyle(
                              color: isSelected
                                  ? ShadTheme.of(context).colorScheme.primaryForeground
                                  : ShadTheme.of(context).colorScheme.foreground,
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
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
                widget.onPriceChanged(_selectedPrice);
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

  Widget _buildPriceRange(BuildContext context) {
    final minPrice = (widget.option.recommendedPrice * 0.7).round();
    final maxPrice = (widget.option.recommendedPrice * 1.3).round();

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
          Expanded(
            child: Column(
              children: [
                Text(
                  '최저가',
                  style: ShadTheme.of(context).textTheme.muted.copyWith(
                        fontSize: 11,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  '₩$minPrice',
                  style: ShadTheme.of(context).textTheme.small.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
          ),
          Container(
            width: 1,
            height: 30,
            color: ShadTheme.of(context).colorScheme.border,
          ),
          Expanded(
            child: Column(
              children: [
                Text(
                  '평균가',
                  style: ShadTheme.of(context).textTheme.muted.copyWith(
                        fontSize: 11,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  '₩${widget.option.recommendedPrice}',
                  style: ShadTheme.of(context).textTheme.small.copyWith(
                        fontWeight: FontWeight.w600,
                        color: ShadTheme.of(context).colorScheme.primary,
                      ),
                ),
              ],
            ),
          ),
          Container(
            width: 1,
            height: 30,
            color: ShadTheme.of(context).colorScheme.border,
          ),
          Expanded(
            child: Column(
              children: [
                Text(
                  '최고가',
                  style: ShadTheme.of(context).textTheme.muted.copyWith(
                        fontSize: 11,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  '₩$maxPrice',
                  style: ShadTheme.of(context).textTheme.small.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<int> _getQuickPrices() {
    final base = widget.option.recommendedPrice;
    return [
      (base * 0.8).round(),
      base,
      (base * 1.1).round(),
      (base * 1.2).round(),
    ];
  }
}