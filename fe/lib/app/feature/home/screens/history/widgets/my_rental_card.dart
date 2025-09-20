import 'package:flutter/material.dart';
import 'package:hankan/app/feature/home/screens/history/extensions/reservation_extensions.dart';
import 'package:hankan/app/feature/home/screens/history/widgets/history_widgets.dart';
import 'package:hankan/app/model/reservation_model.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class MyRentalCard extends StatelessWidget {
  final MyRentalReservation rental;

  const MyRentalCard({
    Key? key,
    required this.rental,
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
              _buildOwnerSection(context),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 16),
              _buildDetailsSection(context, dateFormat),
              if (rental.hasNote) _buildNoteSection(context),
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
          imageUrl: rental.spaceImageUrl,
          fallbackIcon: Icons.inventory_2,
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
                      rental.spaceName,
                      style: ShadTheme.of(context).textTheme.large,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  StatusBadge(status: rental.status),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                rental.region,
                style: ShadTheme.of(context).textTheme.muted,
              ),
              const SizedBox(height: 2),
              Text(
                rental.address,
                style: ShadTheme.of(context).textTheme.small.copyWith(
                      color: ShadTheme.of(context).colorScheme.mutedForeground,
                    ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOwnerSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: ShadTheme.of(context).colorScheme.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: ShadTheme.of(context).colorScheme.border,
        ),
      ),
      child: PersonInfoRow(
        profileImage: rental.ownerProfileImage,
        title: '공간 소유자',
        name: rental.ownerName,
        phone: rental.ownerPhone,
      ),
    );
  }

  Widget _buildDetailsSection(BuildContext context, DateFormat dateFormat) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: InfoItem(
                icon: Icons.category,
                label: '보관 유형',
                value: rental.itemDisplay,
                color: Colors.blue,
              ),
            ),
            Expanded(
              child: InfoItem(
                icon: Icons.calendar_month,
                label: '대여 기간',
                value:
                    '${dateFormat.format(rental.startDate)}\n~ ${dateFormat.format(rental.endDate)}',
                color: Colors.purple,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: InfoItem(
                icon: Icons.payments,
                label: '월 대여료',
                value: '₩${NumberFormat('#,###').format(rental.monthlyPrice)}',
                color: Colors.orange,
              ),
            ),
            Expanded(
              child: InfoItem(
                icon: Icons.attach_money,
                label: '총 금액',
                value: '₩${NumberFormat('#,###').format(rental.totalPrice)}',
                color: Colors.green,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildNoteSection(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: ShadTheme.of(context).colorScheme.muted.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '메모',
                style: ShadTheme.of(context).textTheme.small.copyWith(
                      fontWeight: FontWeight.w600,
                      color: ShadTheme.of(context).colorScheme.mutedForeground,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                rental.note!,
                style: ShadTheme.of(context).textTheme.small,
              ),
            ],
          ),
        ),
      ],
    );
  }
}