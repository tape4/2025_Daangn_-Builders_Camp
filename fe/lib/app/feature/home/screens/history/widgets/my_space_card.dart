import 'package:flutter/material.dart';
import 'package:hankan/app/feature/home/screens/history/extensions/reservation_extensions.dart';
import 'package:hankan/app/feature/home/screens/history/widgets/history_widgets.dart';
import 'package:hankan/app/model/reservation_model.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class MySpaceCard extends StatelessWidget {
  final MySpaceReservation space;

  const MySpaceCard({
    Key? key,
    required this.space,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('yyyy년 MM월 dd일');

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: ShadCard(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 16),
              _buildInfoSection(context, dateFormat),
              if (space.hasRenter) _buildRenterSection(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SpaceImageContainer(
          imageUrl: space.imageUrl,
          fallbackIcon: Icons.home_work,
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      space.title,
                      style: ShadTheme.of(context).textTheme.large,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  StatusBadge(status: space.status),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                space.region,
                style: ShadTheme.of(context).textTheme.muted,
              ),
              const SizedBox(height: 2),
              Text(
                space.address,
                style: ShadTheme.of(context).textTheme.small.copyWith(
                      color: ShadTheme.of(context).colorScheme.mutedForeground,
                    ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.straighten,
                    size: 14,
                    color: ShadTheme.of(context).colorScheme.muted,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    space.volumeText,
                    style: ShadTheme.of(context).textTheme.small,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoSection(BuildContext context, DateFormat dateFormat) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: InfoItem(
                icon: Icons.inventory_2,
                label: '보관 옵션',
                value: '${space.storageOptions.length}종류',
                color: Colors.blue,
              ),
            ),
            Expanded(
              child: InfoItem(
                icon: Icons.storage,
                label: '이용률',
                value: space.occupancyRateText,
                color: Colors.orange,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: InfoItem(
                icon: Icons.calendar_today,
                label: '등록일',
                value: dateFormat.format(space.createdAt),
                color: Colors.purple,
              ),
            ),
            Expanded(
              child: InfoItem(
                icon: Icons.attach_money,
                label: '총 수익',
                value: '₩${NumberFormat('#,###').format(space.totalIncome)}',
                color: Colors.green,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRenterSection(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Colors.blue.withOpacity(0.3),
            ),
          ),
          child: PersonInfoRow(
            profileImage: space.renterProfileImage,
            title: '현재 대여자',
            name: space.renterName!,
            phone: space.renterPhone,
            avatarRadius: 16,
          ),
        ),
      ],
    );
  }
}