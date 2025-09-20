import 'package:flutter/material.dart';
import 'package:hankan/app/feature/home/screens/home/widgets/home_address_bottomsheet.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class HomeAppbar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppbar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 1,
      title: GestureDetector(
        onTap: () {
          showModalBottomSheet(
            context: context,
            builder: (context) {
              return HomeAddressBottomsheet();
            },
          );
        },
        child: Row(
          children: [
            Text(
              "인천광역시",
              style: ShadTheme.of(context).textTheme.h4,
            ),
            Transform.rotate(
              angle: -3.14 / 2,
              child: Icon(Icons.chevron_left, size: 32),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
