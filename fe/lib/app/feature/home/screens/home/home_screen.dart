import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:hankan/app/extension/context_x.dart';
import 'package:hankan/app/feature/home/screens/home/widgets/home_appbar.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppbar(),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: SizedBox(
                    height: 100,
                    child: DefaultTextStyle(
                      style: ShadTheme.of(context).textTheme.h3,
                      child: AnimatedTextKit(
                        pause: const Duration(milliseconds: 500),
                        repeatForever: true,
                        animatedTexts: [
                          RotateAnimatedText(
                            '공간만 차지하는 선풍기, 지금 바로 맡겨보세요!',
                            duration: const Duration(milliseconds: 5000),
                          ),
                          RotateAnimatedText(
                            '공간만 차지하는 선풍기, 지금 바로 맡겨보세요!',
                            duration: const Duration(milliseconds: 5000),
                          ),
                          RotateAnimatedText(
                            '집안의 남는 공간, 한칸에서 편하게 수익창출 해보세요!',
                            duration: const Duration(milliseconds: 5000),
                          ),
                          RotateAnimatedText(
                            '이사철, 짐 보관 걱정은 이제 그만! 한칸과 함께하세요!',
                            duration: const Duration(milliseconds: 5000),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 50, width: double.maxFinite),
                SizedBox(
                  width: context.width * 0.5,
                  child: ShadButton(
                    onPressed: () {},
                    size: ShadButtonSize.lg,
                    icon: const Icon(Icons.add_location_alt, size: 24),
                    child: const Text("물건 맡기기"),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: context.width * 0.5,
                  child: ShadButton(
                    onPressed: () {},
                    size: ShadButtonSize.lg,
                    icon: const Icon(Icons.edit_location_alt, size: 24),
                    child: const Text('공간 빌려주기'),
                  ),
                ),
                const SizedBox(height: 50, width: double.maxFinite),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 70.0),
              child: ShadButton.outline(
                onPressed: () {},
                icon: const Icon(Icons.book),
                child: const Text('어떻게 사용하나요?'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
