import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:hankan/app/extension/context_x.dart';
import 'package:hankan/app/feature/home/screens/home/widgets/expandable_fab.dart';
import 'package:hankan/app/feature/home/screens/home/widgets/home_appbar.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppbar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
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
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Text(
                '인기 보관 공간',
                style: ShadTheme.of(context).textTheme.h4,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: 10,
                itemBuilder: (context, index) {
                  return Container(
                    width: 160,
                    margin: const EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.grey[300]!,
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 120,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(12),
                            ),
                          ),
                          child: Center(
                            child: Icon(
                              Icons.home_work,
                              size: 40,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '공간 ${index + 1}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '월 50,000원',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Text(
                '최근 등록된 보관 요청',
                style: ShadTheme.of(context).textTheme.h4,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 180,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: 8,
                itemBuilder: (context, index) {
                  return Container(
                    width: 140,
                    margin: const EdgeInsets.only(right: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.grey[300]!,
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.inventory_2,
                          size: 32,
                          color: Colors.blue[600],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '물건 ${index + 1}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '3개월',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '예상 금액',
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 10,
                          ),
                        ),
                        Text(
                          '₩30,000/월',
                          style: TextStyle(
                            color: Colors.blue[700],
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
      floatingActionButton: const ExpandableFAB(),
    );
  }
}
