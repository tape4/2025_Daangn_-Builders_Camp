import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class ItemImageDimensionSection extends StatefulWidget {
  final String imageUrl;
  final double width;
  final double depth;
  final double height;
  final Function(String) onImageChanged;
  final Function({double? width, double? depth, double? height}) onDimensionsChanged;

  const ItemImageDimensionSection({
    Key? key,
    required this.imageUrl,
    required this.width,
    required this.depth,
    required this.height,
    required this.onImageChanged,
    required this.onDimensionsChanged,
  }) : super(key: key);

  @override
  State<ItemImageDimensionSection> createState() => _ItemImageDimensionSectionState();
}

class _ItemImageDimensionSectionState extends State<ItemImageDimensionSection> {
  late TextEditingController _widthController;
  late TextEditingController _depthController;
  late TextEditingController _heightController;

  @override
  void initState() {
    super.initState();
    _widthController = TextEditingController(
      text: widget.width > 0 ? widget.width.toStringAsFixed(0) : '',
    );
    _depthController = TextEditingController(
      text: widget.depth > 0 ? widget.depth.toStringAsFixed(0) : '',
    );
    _heightController = TextEditingController(
      text: widget.height > 0 ? widget.height.toStringAsFixed(0) : '',
    );
  }

  @override
  void dispose() {
    _widthController.dispose();
    _depthController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  void _showImageUrlDialog() {
    final tempController = TextEditingController(text: widget.imageUrl);
    showShadDialog(
      context: context,
      builder: (context) => ShadDialog(
        title: const Text('물건 사진 추가'),
        description: const Text('물건 사진의 URL을 입력해주세요.'),
        child: Column(
          children: [
            ShadInput(
              controller: tempController,
              placeholder: const Text('https://example.com/image.jpg'),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ShadButton.outline(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('취소'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ShadButton(
                    onPressed: () {
                      widget.onImageChanged(tempController.text);
                      Navigator.of(context).pop();
                    },
                    child: const Text('확인'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ).then((_) {
      tempController.dispose();
    });
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '물건 사진',
                  style: ShadTheme.of(context).textTheme.small.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 8),
                InkWell(
                  onTap: _showImageUrlDialog,
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    height: 120,
                    decoration: BoxDecoration(
                      color: widget.imageUrl.isEmpty
                          ? ShadTheme.of(context).colorScheme.muted.withOpacity(0.1)
                          : null,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: ShadTheme.of(context).colorScheme.border,
                        width: 2,
                      ),
                      image: widget.imageUrl.isNotEmpty
                          ? DecorationImage(
                              image: NetworkImage(widget.imageUrl),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: widget.imageUrl.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.add_photo_alternate,
                                  size: 32,
                                  color: ShadTheme.of(context).colorScheme.mutedForeground,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '사진 추가',
                                  style: ShadTheme.of(context).textTheme.muted.copyWith(
                                        fontSize: 12,
                                      ),
                                ),
                              ],
                            ),
                          )
                        : null,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '물건 크기 (cm)',
                  style: ShadTheme.of(context).textTheme.small.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: _buildDimensionInput(
                        label: '가로 (W)',
                        controller: _widthController,
                        onChanged: (value) {
                          final doubleValue = double.tryParse(value) ?? 0;
                          widget.onDimensionsChanged(width: doubleValue);
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildDimensionInput(
                        label: '세로 (D)',
                        controller: _depthController,
                        onChanged: (value) {
                          final doubleValue = double.tryParse(value) ?? 0;
                          widget.onDimensionsChanged(depth: doubleValue);
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildDimensionInput(
                        label: '높이 (H)',
                        controller: _heightController,
                        onChanged: (value) {
                          final doubleValue = double.tryParse(value) ?? 0;
                          widget.onDimensionsChanged(height: doubleValue);
                        },
                      ),
                    ),
                  ],
                ),
                if (widget.width > 0 && widget.depth > 0 && widget.height > 0) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: ShadTheme.of(context).colorScheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.straighten,
                          size: 14,
                          color: ShadTheme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '부피: ${(widget.width * widget.depth * widget.height).toStringAsFixed(0)} cm³',
                          style: ShadTheme.of(context).textTheme.muted.copyWith(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: ShadTheme.of(context).colorScheme.primary,
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDimensionInput({
    required String label,
    required TextEditingController controller,
    required Function(String) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: ShadTheme.of(context).textTheme.muted.copyWith(
                fontSize: 10,
              ),
        ),
        const SizedBox(height: 4),
        ShadInput(
          controller: controller,
          placeholder: const Text('0'),
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
          onChanged: onChanged,
        ),
      ],
    );
  }
}