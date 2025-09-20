import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hankan/app/feature/profile_edit/profile_edit_provider.dart';
import 'package:hankan/app/feature/profile_edit/profile_edit_state.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class ProfileEditPage extends ConsumerStatefulWidget {
  const ProfileEditPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends ConsumerState<ProfileEditPage> {
  late TextEditingController _nicknameController;
  final _formKey = GlobalKey<ShadFormState>();

  @override
  void initState() {
    super.initState();
    final state = ref.read(profileEditProvider);
    _nicknameController = TextEditingController(text: state.nickname);
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(profileEditProvider);
    final notifier = ref.read(profileEditProvider.notifier);

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
          Stack(
            children: [
              ShadAvatar(
                state.profileUrl.isEmpty
                    ? 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTF_IdW_JHgWJh_GBrudxZXPOFfdf5598pnew&s'
                    : state.profileUrl,
                placeholder: Text(
                  state.nickname.isNotEmpty ? state.nickname[0].toUpperCase() : 'U',
                ),
                size: const Size.square(100),
                fit: BoxFit.cover,
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  decoration: BoxDecoration(
                    color: ShadTheme.of(context).colorScheme.primary,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: ShadTheme.of(context).colorScheme.background,
                      width: 2,
                    ),
                  ),
                  child: ShadButton.ghost(
                    size: ShadButtonSize.sm,
                    icon: Icon(
                      Symbols.camera_alt,
                      color: ShadTheme.of(context).colorScheme.primaryForeground,
                      size: 18,
                    ),
                    onPressed: () {
                      _showImagePickerDialog(context, notifier);
                    },
                  ),
                ),
              ),
            ],
          ),
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

  Widget _buildNicknameField(
    BuildContext context,
    ProfileEditState state,
    ProfileEditNotifier notifier,
  ) {
    return ShadInputFormField(
      id: 'nickname',
      controller: _nicknameController,
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
        '${_nicknameController.text.length}/20',
        style: ShadTheme.of(context).textTheme.muted.copyWith(
              fontSize: 12,
            ),
      ),
    );
  }

void _showImagePickerDialog(BuildContext context, ProfileEditNotifier notifier) {
    final urlController = TextEditingController(text: ref.read(profileEditProvider).profileUrl);
    final dialogFormKey = GlobalKey<ShadFormState>();

    showShadDialog(
      context: context,
      builder: (context) => ShadDialog(
        title: const Text('프로필 사진 변경'),
        description: const Text('새 프로필 사진을 선택하거나 URL을 입력하세요.'),
        child: ShadForm(
          key: dialogFormKey,
          child: Column(
            children: [
              ShadInputFormField(
                id: 'profileUrl',
                controller: urlController,
                placeholder: const Text('이미지 URL 입력'),
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    final urlPattern = RegExp(
                      r'^https?:\/\/.*\.(jpg|jpeg|png|gif|webp)',
                      caseSensitive: false,
                    );
                    if (!urlPattern.hasMatch(value)) {
                      return '올바른 이미지 URL을 입력해주세요.';
                    }
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: ShadButton.outline(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('취소'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ShadButton(
                      onPressed: () {
                        if (dialogFormKey.currentState?.saveAndValidate() ?? false) {
                          notifier.updateProfileUrl(urlController.text);
                          Navigator.of(context).pop();
                        }
                      },
                      child: const Text('확인'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ).then((_) {
      urlController.dispose();
    });
  }
}
