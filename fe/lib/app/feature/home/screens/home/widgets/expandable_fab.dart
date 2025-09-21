import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hankan/app/feature/auth/widgets/auth_bottom_sheet.dart';
import 'package:hankan/app/feature/home/screens/home/widgets/fab_item.dart';
import 'package:hankan/app/routing/router_service.dart';

class ExpandableFAB extends StatefulWidget {
  const ExpandableFAB({Key? key}) : super(key: key);

  @override
  State<ExpandableFAB> createState() => _ExpandableFABState();
}

class _ExpandableFABState extends State<ExpandableFAB>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleFAB() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (_isExpanded) ...[
                  FABItem(
                    label: '어떻게 사용하나요?',
                    heroTag: 'help',
                    onPressed: () {
                      _toggleFAB();
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (context) => AuthBottomSheet(),
                      );
                    },
                    backgroundColor: Colors.blue,
                    icon: Icons.book,
                    offset: 25,
                    animation: _animation,
                  ),
                  // FABItem(
                  //   label: '물건 보관하기',
                  //   heroTag: 'store',
                  //   onPressed: () {
                  //     _toggleFAB();
                  //     context.push(Routes.itemStorage);
                  //   },
                  //   backgroundColor: Colors.green,
                  //   icon: Icons.add_location_alt,
                  //   offset: 30,
                  //   animation: _animation,
                  // ),
                  FABItem(
                    label: '공간 빌려주기',
                    heroTag: 'rent',
                    onPressed: () {
                      _toggleFAB();
                      context.push(Routes.spaceRental);
                    },
                    backgroundColor: Colors.orange,
                    icon: Icons.edit_location_alt,
                    offset: 15,
                    animation: _animation,
                  ),
                ],
                FloatingActionButton(
                  onPressed: _toggleFAB,
                  child: AnimatedIcon(
                    icon: AnimatedIcons.menu_close,
                    progress: _animation,
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
