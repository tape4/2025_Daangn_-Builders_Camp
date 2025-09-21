import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class HistoryTabBar extends StatelessWidget {
  final int selectedTab;
  final Function(int) onTabChanged;

  const HistoryTabBar({
    Key? key,
    required this.selectedTab,
    required this.onTabChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          Expanded(
            child: selectedTab == 0
                ? ShadButton(
                    onPressed: () => onTabChanged(0),
                    child: const Text('빌려준 공간'),
                  )
                : ShadButton.outline(
                    onPressed: () => onTabChanged(0),
                    child: const Text('빌려준 공간'),
                  ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: selectedTab == 1
                ? ShadButton(
                    onPressed: () => onTabChanged(1),
                    child: const Text('대여중인 공간'),
                  )
                : ShadButton.outline(
                    onPressed: () => onTabChanged(1),
                    child: const Text('대여중인 공간'),
                  ),
          ),
        ],
      ),
    );
  }
}

class HistoryEmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const HistoryEmptyState({
    Key? key,
    required this.icon,
    required this.title,
    required this.subtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 64,
              color: ShadTheme.of(context).colorScheme.muted,
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: ShadTheme.of(context).textTheme.large,
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: ShadTheme.of(context).textTheme.muted,
            ),
          ],
        ),
      ),
    );
  }
}

class HistoryErrorState extends StatelessWidget {
  final String errorMessage;

  const HistoryErrorState({
    Key? key,
    required this.errorMessage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: ShadTheme.of(context).colorScheme.destructive,
            ),
            const SizedBox(height: 16),
            Text(
              errorMessage,
              style: ShadTheme.of(context).textTheme.large,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class HistoryLoadingState extends StatelessWidget {
  const HistoryLoadingState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}

class SpaceImageContainer extends StatelessWidget {
  final String imageUrl;
  final IconData fallbackIcon;
  final double size;

  const SpaceImageContainer({
    Key? key,
    required this.imageUrl,
    required this.fallbackIcon,
    this.size = 100,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: ShadTheme.of(context).colorScheme.muted.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: ShadTheme.of(context).colorScheme.border,
        ),
      ),
      child: imageUrl.isNotEmpty
          ? ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    fallbackIcon,
                    size: 40,
                    color: ShadTheme.of(context).colorScheme.muted,
                  );
                },
              ),
            )
          : Icon(
              fallbackIcon,
              size: 40,
              color: ShadTheme.of(context).colorScheme.muted,
            ),
    );
  }
}

class InfoItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const InfoItem({
    Key? key,
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(
            icon,
            size: 14,
            color: color,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: ShadTheme.of(context).textTheme.small.copyWith(
                      color: ShadTheme.of(context).colorScheme.mutedForeground,
                    ),
              ),
              Text(
                value,
                style: ShadTheme.of(context).textTheme.small.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

enum StatusType {
  active(
    displayText: '진행중',
    backgroundColor: 0x1A4CAF50,
    textColor: 0xFF2E7D32,
  ),
  completed(
    displayText: '완료',
    backgroundColor: 0x1A9E9E9E,
    textColor: 0xFF616161,
  ),
  cancelled(
    displayText: '취소됨',
    backgroundColor: 0x1AF44336,
    textColor: 0xFFC62828,
  ),
  pending(
    displayText: '대기중',
    backgroundColor: 0x1AFF9800,
    textColor: 0xFFE65100,
  );

  final String displayText;
  final int backgroundColor;
  final int textColor;

  const StatusType({
    required this.displayText,
    required this.backgroundColor,
    required this.textColor,
  });

  static StatusType fromString(String status) {
    switch (status.toLowerCase()) {
      case 'active':
      case '진행중':
        return StatusType.active;
      case 'completed':
      case '완료':
        return StatusType.completed;
      case 'cancelled':
      case '취소됨':
        return StatusType.cancelled;
      case 'pending':
      case '대기중':
        return StatusType.pending;
      default:
        return StatusType.pending;
    }
  }
}

class StatusBadge extends StatelessWidget {
  final String status;

  const StatusBadge({
    Key? key,
    required this.status,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final statusType = StatusType.fromString(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Color(statusType.backgroundColor),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        statusType.displayText,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Color(statusType.textColor),
        ),
      ),
    );
  }
}

class PersonInfoRow extends StatelessWidget {
  final String? profileImage;
  final String title;
  final String name;
  final String? phone;
  final double avatarRadius;

  const PersonInfoRow({
    Key? key,
    this.profileImage,
    required this.title,
    required this.name,
    this.phone,
    this.avatarRadius = 20,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: avatarRadius,
          backgroundImage:
              profileImage != null ? NetworkImage(profileImage!) : null,
          child: profileImage == null
              ? Icon(Icons.person, size: avatarRadius)
              : null,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: ShadTheme.of(context).textTheme.small.copyWith(
                      color: ShadTheme.of(context).colorScheme.mutedForeground,
                    ),
              ),
              const SizedBox(height: 2),
              Text(
                name,
                style: ShadTheme.of(context).textTheme.p.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              if (phone != null)
                Text(
                  phone!,
                  style: ShadTheme.of(context).textTheme.small,
                ),
            ],
          ),
        ),
      ],
    );
  }
}