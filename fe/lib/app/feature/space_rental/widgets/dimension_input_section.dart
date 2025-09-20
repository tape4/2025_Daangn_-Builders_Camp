import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class DimensionInputSection extends StatefulWidget {
  final String? imagePath;
  final double width;
  final double depth;
  final double height;
  final Function(String?) onImageChanged;
  final Function({double? width, double? depth, double? height}) onDimensionsChanged;

  const DimensionInputSection({
    Key? key,
    this.imagePath,
    required this.width,
    required this.depth,
    required this.height,
    required this.onImageChanged,
    required this.onDimensionsChanged,
  }) : super(key: key);

  @override
  State<DimensionInputSection> createState() => _DimensionInputSectionState();
}

class _DimensionInputSectionState extends State<DimensionInputSection> {
  final ImagePicker _picker = ImagePicker();
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

  void _showImagePickerOptions() {
    showShadDialog(
      context: context,
      builder: (context) => ShadDialog(
        title: const Text('공간 사진 추가'),
        description: const Text('사진을 선택하는 방법을 선택해주세요.'),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: ShadButton.outline(
                    onPressed: () {
                      Navigator.of(context).pop();
                      _pickImage(ImageSource.camera);
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.camera_alt, size: 18),
                        SizedBox(width: 8),
                        Text('카메라'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ShadButton.outline(
                    onPressed: () {
                      Navigator.of(context).pop();
                      _pickImage(ImageSource.gallery);
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.photo_library, size: 18),
                        SizedBox(width: 8),
                        Text('갤러리'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            if (widget.imagePath != null) ...[
              const SizedBox(height: 8),
              ShadButton.destructive(
                onPressed: () {
                  widget.onImageChanged(null);
                  Navigator.of(context).pop();
                },
                child: const Text('사진 제거'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image != null) {
        widget.onImageChanged(image.path);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('이미지를 선택하는 중 오류가 발생했습니다: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
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
                  '공간 사진',
                  style: ShadTheme.of(context).textTheme.small.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 8),
                InkWell(
                  onTap: _showImagePickerOptions,
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    height: 120,
                    decoration: BoxDecoration(
                      color: widget.imagePath == null
                          ? ShadTheme.of(context).colorScheme.muted.withOpacity(0.1)
                          : null,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: ShadTheme.of(context).colorScheme.border,
                        width: 2,
                      ),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: widget.imagePath != null
                        ? Image.file(
                            File(widget.imagePath!),
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.broken_image,
                                      size: 32,
                                      color: ShadTheme.of(context).colorScheme.mutedForeground,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '이미지 로드 실패',
                                      style: ShadTheme.of(context).textTheme.muted.copyWith(
                                            fontSize: 12,
                                          ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          )
                        : Center(
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
                          ),
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
                  '공간 크기 (cm)',
                  style: ShadTheme.of(context).textTheme.small.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: _buildDimensionInput(
                        label: '가로',
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
                        label: '세로',
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
                        label: '높이',
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
                  Text(
                    '총 부피: ${(widget.width * widget.depth * widget.height).toStringAsFixed(0)} cm³',
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