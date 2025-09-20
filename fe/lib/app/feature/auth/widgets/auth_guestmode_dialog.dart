import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class AuthGuestmodeDialog extends StatelessWidget {
  const AuthGuestmodeDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ShadDialog(
      title: const Text('둘러보기 모드'),
      description: const Text(
        '로그인 없이 한칸을 둘러볼 수 있습니다.\n일부 기능은 제한될 수 있어요.',
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Text(
            '이용 가능한 기능:',
            style: ShadTheme.of(context).textTheme.p.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 8),
          _buildListItem(context, '게시글 보기', true),
          _buildListItem(context, '동네 정보 확인', true),
          _buildListItem(context, '공지사항 읽기', true),
          const SizedBox(height: 16),
          Text(
            '제한되는 기능:',
            style: ShadTheme.of(context).textTheme.p.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 8),
          _buildListItem(context, '글쓰기 및 댓글', false),
          _buildListItem(context, '채팅 및 메시지', false),
          _buildListItem(context, '알림 받기', false),
        ],
      ),
      actions: [
        ShadButton.outline(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('취소'),
        ),
        ShadButton(
          onPressed: () {
            Navigator.of(context).pop();
            context.go('/');
          },
          child: const Text('둘러보기'),
        ),
      ],
    );
  }

  Widget _buildListItem(BuildContext context, String text, bool isAvailable) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Icon(
            isAvailable ? Icons.check_circle : Icons.cancel,
            size: 16,
            color: isAvailable
                ? ShadTheme.of(context).colorScheme.primary
                : ShadTheme.of(context).colorScheme.destructive,
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: ShadTheme.of(context).textTheme.small,
          ),
        ],
      ),
    );
  }
}
