import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hankan/app/feature/space_rental/models/space_rental_option.dart';
import 'package:hankan/app/feature/space_rental/widgets/price_bottom_sheet.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class StorageOptionItem extends StatefulWidget {
  final StorageOption option;
  final int quantity;
  final int price;
  final int maxQuantity;
  final Function(int) onQuantityChanged;
  final Function(int) onPriceChanged;

  const StorageOptionItem({
    Key? key,
    required this.option,
    required this.quantity,
    required this.price,
    required this.maxQuantity,
    required this.onQuantityChanged,
    required this.onPriceChanged,
  }) : super(key: key);

  @override
  State<StorageOptionItem> createState() => _StorageOptionItemState();
}

class _StorageOptionItemState extends State<StorageOptionItem> {
  late TextEditingController _priceController;

  @override
  void initState() {
    super.initState();
    _priceController = TextEditingController(
      text: widget.price > 0 ? widget.price.toString() : '',
    );
  }

  @override
  void didUpdateWidget(StorageOptionItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.price != oldWidget.price && widget.price > 0) {
      _priceController.text = widget.price.toString();
    }
  }

  @override
  void dispose() {
    _priceController.dispose();
    super.dispose();
  }

  void _showPriceBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => PriceBottomSheet(
        option: widget.option,
        currentPrice: widget.price,
        onPriceChanged: (newPrice) {
          widget.onPriceChanged(newPrice);
          setState(() {
            _priceController.text = newPrice > 0 ? newPrice.toString() : '';
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isActive = widget.quantity > 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isActive
            ? ShadTheme.of(context).colorScheme.primary.withOpacity(0.05)
            : ShadTheme.of(context).colorScheme.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isActive
              ? ShadTheme.of(context).colorScheme.primary.withOpacity(0.2)
              : ShadTheme.of(context).colorScheme.border,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: ShadTheme.of(context).colorScheme.muted.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    widget.option.displayName,
                    style: ShadTheme.of(context).textTheme.h4.copyWith(
                          color: isActive
                              ? ShadTheme.of(context).colorScheme.primary
                              : ShadTheme.of(context).colorScheme.mutedForeground,
                        ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '옵션 ${widget.option.displayName}',
                      style: ShadTheme.of(context).textTheme.small.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.option.dimensionText,
                      style: ShadTheme.of(context).textTheme.muted.copyWith(
                            fontSize: 12,
                          ),
                    ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: ShadTheme.of(context).colorScheme.border,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    ShadButton.ghost(
                      size: ShadButtonSize.sm,
                      onPressed: widget.quantity > 0
                          ? () => widget.onQuantityChanged(widget.quantity - 1)
                          : null,
                      icon: const Icon(Icons.remove, size: 16),
                    ),
                    Container(
                      width: 40,
                      alignment: Alignment.center,
                      child: Text(
                        widget.quantity.toString(),
                        style: ShadTheme.of(context).textTheme.small.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),
                    ShadButton.ghost(
                      size: ShadButtonSize.sm,
                      onPressed: widget.quantity < widget.maxQuantity
                          ? () => widget.onQuantityChanged(widget.quantity + 1)
                          : null,
                      icon: const Icon(Icons.add, size: 16),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (widget.quantity > 0) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: _showPriceBottomSheet,
                    child: AbsorbPointer(
                      child: ShadInputFormField(
                        id: 'price_${widget.option.name}',
                        controller: _priceController,
                        label: Text(
                          '월 대여료',
                          style: ShadTheme.of(context).textTheme.muted.copyWith(
                                fontSize: 12,
                              ),
                        ),
                        placeholder: const Text('가격을 선택하세요'),
                        prefix: Text(
                          '₩',
                          style: ShadTheme.of(context).textTheme.muted,
                        ),
                        suffix: Icon(
                          Icons.arrow_drop_down,
                          color: ShadTheme.of(context).colorScheme.mutedForeground,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: ShadTheme.of(context).colorScheme.muted.withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 12,
                    color: ShadTheme.of(context).colorScheme.mutedForeground,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '추천 가격: ₩${widget.option.recommendedPrice.toString()}',
                    style: ShadTheme.of(context).textTheme.muted.copyWith(
                          fontSize: 11,
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