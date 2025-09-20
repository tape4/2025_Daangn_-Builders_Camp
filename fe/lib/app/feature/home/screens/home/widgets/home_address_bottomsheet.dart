import 'package:flutter/material.dart';
// import 'package:kpostal_web/widget/kakao_address_widget.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class HomeAddressBottomsheet extends StatelessWidget {
  const HomeAddressBottomsheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Column(
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: Colors.black26,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 5),
          Center(
            child: Text(
              "지역 선택",
              style: ShadTheme.of(context).textTheme.h4,
            ),
          ),
          SizedBox(
            width: double.maxFinite,
            height: 150,
            // child: KakaoAddressWidget(
            //   onComplete: (kakaoAddress) {
            //     print('onComplete KakaoAddress: $kakaoAddress');
            //   },
            //   onClose: () {
            //     Navigator.of(context).pop();
            //   },
            // ),
          ),
        ],
      ),
    );
  }
}
