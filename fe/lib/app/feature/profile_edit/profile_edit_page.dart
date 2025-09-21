import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hankan/app/feature/profile_edit/profile_edit_provider.dart';
import 'package:hankan/app/feature/profile_edit/profile_edit_state.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class ProfileEditPage extends ConsumerStatefulWidget {
  const ProfileEditPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends ConsumerState<ProfileEditPage> {
  TextEditingController? _nicknameController;
  final _formKey = GlobalKey<ShadFormState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final state = ref.read(profileEditProvider);
        _nicknameController = TextEditingController(text: state.nickname);
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _nicknameController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(profileEditProvider);
    final notifier = ref.read(profileEditProvider.notifier);

    // Show loading while initializing controller
    if (_nicknameController == null) {
      return Scaffold(
        backgroundColor: ShadTheme.of(context).colorScheme.background,
        appBar: AppBar(
          backgroundColor: ShadTheme.of(context).colorScheme.background,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Symbols.arrow_back_ios,
              color: ShadTheme.of(context).colorScheme.foreground,
            ),
            onPressed: () => context.pop(),
          ),
          title: Text(
            '프로필 수정',
            style: ShadTheme.of(context).textTheme.h4,
          ),
          centerTitle: true,
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      backgroundColor: ShadTheme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: ShadTheme.of(context).colorScheme.background,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Symbols.arrow_back_ios,
            color: ShadTheme.of(context).colorScheme.foreground,
          ),
          onPressed: () => context.pop(),
        ),
        title: Text(
          '프로필 수정',
          style: ShadTheme.of(context).textTheme.h4,
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: state.isSaving
                ? null
                : () async {
                    if (_formKey.currentState?.saveAndValidate() ?? false) {
                      final success = await notifier.saveProfile();
                      if (success && mounted) {
                        ShadToaster.of(context).show(
                          ShadToast(
                            title: const Text('프로필이 업데이트되었습니다.'),
                          ),
                        );
                        context.pop();
                      }
                    }
                  },
            child: Text(
              '저장',
              style: TextStyle(
                color: state.isSaving
                    ? ShadTheme.of(context).colorScheme.mutedForeground
                    : ShadTheme.of(context).colorScheme.primary,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ShadForm(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildAvatarSection(context, state, notifier),
                const SizedBox(height: 32),
                _buildNicknameField(context, state, notifier),
                if (state.errorMessage != null) ...[
                  const SizedBox(height: 20),
                  ShadAlert.destructive(
                    icon: const Icon(Icons.error_outline),
                    title: const Text('오류'),
                    description: Text(state.errorMessage!),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAvatarSection(
    BuildContext context,
    ProfileEditState state,
    ProfileEditNotifier notifier,
  ) {
    return Center(
      child: Column(
        children: [
          _buildAvatar(state),
          const SizedBox(height: 12),
          ShadButton.outline(
            size: ShadButtonSize.sm,
            onPressed: () {
              _showImagePickerDialog(context, notifier);
            },
            child: const Text('프로필 사진 변경'),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar(ProfileEditState state) {
    final size = const Size.square(100);

    // Check if it's a local file path
    if (state.profileUrl.isNotEmpty && !state.profileUrl.startsWith('http')) {
      return ClipOval(
        child: Image.file(
          File(state.profileUrl),
          width: size.width,
          height: size.height,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            // Fallback to placeholder if image loading fails
            return Container(
              width: size.width,
              height: size.height,
              decoration: BoxDecoration(
                color: ShadTheme.of(context).colorScheme.muted,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.person,
                color: ShadTheme.of(context).colorScheme.mutedForeground,
                size: 40,
              ),
            );
          },
        ),
      );
    }

    // Use ShadAvatar for URLs or default image
    return Container(
      width: size.width,
      height: size.height,
      decoration: BoxDecoration(
        color: ShadTheme.of(context).colorScheme.muted,
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.person,
        color: ShadTheme.of(context).colorScheme.mutedForeground,
        size: 40,
      ),
    );
  }

  Widget _buildNicknameField(
    BuildContext context,
    ProfileEditState state,
    ProfileEditNotifier notifier,
  ) {
    return ShadInputFormField(
      id: 'nickname',
      controller: _nicknameController!,
      label: Text(
        '닉네임',
        style: ShadTheme.of(context).textTheme.small.copyWith(
              fontWeight: FontWeight.w600,
            ),
      ),
      placeholder: const Text('닉네임을 입력하세요'),
      onChanged: (value) {
        notifier.updateNickname(value);
        _formKey.currentState?.validate();
      },
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return '닉네임을 입력해주세요.';
        }
        if (value.length > 20) {
          return '닉네임은 20자 이하로 입력해주세요.';
        }
        if (value.trim().length < 2) {
          return '닉네임은 최소 2자 이상이어야 합니다.';
        }
        return null;
      },
      description: Text(
        '${_nicknameController!.text.length}/20',
        style: ShadTheme.of(context).textTheme.muted.copyWith(
              fontSize: 12,
            ),
      ),
    );
  }

  void _showImagePickerDialog(
      BuildContext context, ProfileEditNotifier notifier) {
    showShadDialog(
      context: context,
      builder: (context) => ShadDialog(
        title: const Text('프로필 사진 변경'),
        description: const Text('갤러리 또는 카메라에서 사진을 선택하세요.'),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ShadButton.outline(
              onPressed: () async {
                Navigator.of(context).pop();
                await _pickImage(ImageSource.gallery, notifier);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Symbols.photo_library),
                  const SizedBox(width: 8),
                  const Text('갤러리에서 선택'),
                ],
              ),
            ),
            const SizedBox(height: 12),
            ShadButton.outline(
              onPressed: () async {
                Navigator.of(context).pop();
                await _pickImage(ImageSource.camera, notifier);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Symbols.camera_alt),
                  const SizedBox(width: 8),
                  const Text('카메라로 촬영'),
                ],
              ),
            ),
            const SizedBox(height: 12),
            ShadButton.ghost(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('취소'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage(
      ImageSource source, ProfileEditNotifier notifier) async {
    final ImagePicker picker = ImagePicker();

    try {
      final XFile? image = await picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        // For now, we'll use the file path as a placeholder
        // In a real app, you would upload this to a server and get a URL back
        notifier.updateProfileUrl(image.path);

        // Show a toast to indicate success
        if (mounted) {
          ShadToaster.of(context).show(
            ShadToast(
              title: const Text('사진이 선택되었습니다.'),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ShadToaster.of(context).show(
          ShadToast.destructive(
            title: const Text('사진 선택 실패'),
            description: const Text('사진을 선택할 수 없습니다. 다시 시도해주세요.'),
          ),
        );
      }
    }
  }
}
