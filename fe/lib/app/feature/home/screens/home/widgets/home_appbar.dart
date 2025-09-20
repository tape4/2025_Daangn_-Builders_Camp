import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hankan/app/feature/home/logic/home_provider.dart';
import 'package:hankan/app/feature/home/screens/home/widgets/home_address_bottomsheet.dart';
import 'package:hankan/app/routing/router_service.dart';
import 'package:hankan/app/service/secure_storage_service.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class HomeAppbar extends ConsumerStatefulWidget implements PreferredSizeWidget {
  const HomeAppbar({Key? key}) : super(key: key);

  @override
  ConsumerState<HomeAppbar> createState() => _HomeAppbarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _HomeAppbarState extends ConsumerState<HomeAppbar> {
  String? selectedAddress;
  final SecureStorageService _storageService = SecureStorageService.I;

  @override
  void initState() {
    super.initState();
    _loadSavedAddress();
  }

  Future<void> _loadSavedAddress() async {
    final address = await _storageService.read('selected_address');
    if (mounted) {
      setState(() {
        selectedAddress = address;
      });
      if (address == null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _showAddressPrompt();
        });
      }
    }
  }

  void _showAddressPrompt() {
    showModalBottomSheet(
      context: context,
      isDismissible: true,
      builder: (context) {
        return HomeAddressBottomsheet();
      },
    ).then((result) {
      if (result != null && mounted) {
        setState(() {
          selectedAddress = result;
        });
        WidgetsBinding.instance.addPostFrameCallback((_) {
          RouterService.I.showNotification(
            title: '주소 설정 완료',
            message: '선택한 주소로 변경되었습니다',
          );
        });
      }
    });
  }

  String _getDisplayAddress(String? address) {
    if (address == null) return '주소를 선택해주세요';
    final parts = address.split(' ');
    if (parts.length >= 2) {
      return '${parts[0]} ${parts[1]}';
    }
    return address;
  }

  @override
  Widget build(BuildContext context) {
    final homeState = ref.watch(homeProvider);
    final homeNotifier = ref.read(homeProvider.notifier);

    return AppBar(
      elevation: 1,
      title: GestureDetector(
        onTap: () async {
          _showAddressPrompt();
        },
        child: Row(
          children: [
            Text(
              _getDisplayAddress(selectedAddress),
              style: ShadTheme.of(context).textTheme.h4,
              overflow: TextOverflow.ellipsis,
            ),
            Transform.rotate(
              angle: -3.14 / 2,
              child: Icon(Icons.chevron_left, size: 32),
            ),
          ],
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: ShadTheme.of(context).colorScheme.border,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  onTap: homeState.isBorrowMode
                      ? null
                      : () => homeNotifier.toggleBorrowMode(),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(7),
                    bottomLeft: Radius.circular(7),
                  ),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: homeState.isBorrowMode
                          ? ShadTheme.of(context).colorScheme.primary
                          : Colors.transparent,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(7),
                        bottomLeft: Radius.circular(7),
                      ),
                    ),
                    child: Text(
                      '빌릴레요',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: homeState.isBorrowMode
                            ? ShadTheme.of(context)
                                .colorScheme
                                .primaryForeground
                            : ShadTheme.of(context).colorScheme.foreground,
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 1,
                  height: 24,
                  color: ShadTheme.of(context).colorScheme.border,
                ),
                InkWell(
                  onTap: !homeState.isBorrowMode
                      ? null
                      : () => homeNotifier.toggleBorrowMode(),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(7),
                    bottomRight: Radius.circular(7),
                  ),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: !homeState.isBorrowMode
                          ? ShadTheme.of(context).colorScheme.primary
                          : Colors.transparent,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(7),
                        bottomRight: Radius.circular(7),
                      ),
                    ),
                    child: Text(
                      '빌려줄레요',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: !homeState.isBorrowMode
                            ? ShadTheme.of(context)
                                .colorScheme
                                .primaryForeground
                            : ShadTheme.of(context).colorScheme.foreground,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
