import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

class FaqPage extends ConsumerWidget {
  const FaqPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: ShadTheme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text('자주 묻는 질문(FAQ)', style: ShadTheme.of(context).textTheme.h3),
        backgroundColor: ShadTheme.of(context).colorScheme.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Symbols.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '동네 공유창고 서비스',
              style: ShadTheme.of(context).textTheme.h4,
            ),
            const SizedBox(height: 8),
            Text(
              '이웃과 함께 만드는 공간 공유 플랫폼에 대해 알아보세요',
              style: ShadTheme.of(context).textTheme.muted,
            ),
            const SizedBox(height: 24),
            _buildFaqSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildFaqSection(BuildContext context) {
    final faqCategories = [
      FaqCategory(
        title: '서비스 소개',
        icon: Symbols.home_storage,
        questions: [
          FaqItem(
            question: '동네 공유창고 서비스가 무엇인가요?',
            answer:
                '동네 사람들의 사용하지 않는 공간을 저장공간이 필요한 이웃들과 연결해주는 P2P 공유창고 서비스입니다. 안 쓰는 다락방, 베란다 한 켠, 창고 같은 작은 공간들을 이웃과 나누어 사용할 수 있도록 도와드립니다. 공간의 에어비앤비라고 생각하시면 됩니다.',
          ),
          FaqItem(
            question: '이 서비스를 만든 이유는 무엇인가요?',
            answer:
                '당근마켓의 비전처럼 "로컬의 모든 것을 연결해 동네의 숨은 가치를 깨우고자" 합니다. 여름에는 겨울옷을, 겨울에는 여름옷을 치워둘 공간이 필요한데 집에 공간이 부족한 경우가 많습니다. 그런데 우리 동네에는 비어있는 공간들이 있죠. 이런 잉여 공간이 누군가에게는 정말 필요한 공간이 될 수 있다고 생각했습니다.',
          ),
          FaqItem(
            question: '어떤 물건들을 보관할 수 있나요?',
            answer:
                '계절용품(여름/겨울 옷, 선풍기, 난방기구), 캠핑용품, 스포츠 장비, 이삿짐 임시보관, 책과 서적, 그리고 기타 일상생활에서 임시로 보관이 필요한 물품들을 보관할 수 있습니다. 위험물품, 불법물품, 부패하기 쉬운 음식물은 보관할 수 없습니다.',
          ),
        ],
      ),
      FaqCategory(
        title: '이용 방법',
        icon: Symbols.swap_horiz,
        questions: [
          FaqItem(
            question: '공간을 빌리려면 어떻게 해야 하나요?',
            answer:
                '앱에서 원하는 지역을 선택하고, 필요한 공간 크기와 기간을 입력하면 주변의 이용 가능한 공간 목록을 볼 수 있습니다. 마음에 드는 공간을 선택하고 공간 제공자와 채팅을 통해 세부사항을 조율한 후 예약하시면 됩니다.',
          ),
          FaqItem(
            question: '내 공간을 공유하고 싶은데 어떻게 등록하나요?',
            answer:
                '"공간 등록하기" 버튼을 눌러 공간 사진, 크기, 위치, 이용 가능 시간, 가격 등을 입력하면 됩니다. 공간의 특징(습도, 온도, 보안 등)을 상세히 적어주시면 이용자들이 선택하는데 도움이 됩니다.',
          ),
          FaqItem(
            question: '가격은 어떻게 책정되나요?',
            answer:
                '공간 제공자가 직접 가격을 설정할 수 있습니다. 지역별 평균 가격을 참고하실 수 있으며, 공간 크기, 위치, 편의시설 등에 따라 가격이 달라질 수 있습니다. 장기 이용 시 할인도 가능합니다.',
          ),
        ],
      ),
      FaqCategory(
        title: '안전과 신뢰',
        icon: Symbols.verified_user,
        questions: [
          FaqItem(
            question: '내 물건이 안전할까요?',
            answer:
                '모든 사용자는 본인 인증을 거치며, 거래 전 상호 프로필 확인이 가능합니다. 물품 보관 시 사진으로 상태를 기록하고, 만약의 사고에 대비한 보증 시스템도 운영하고 있습니다. 또한 이웃 간의 반복적인 거래를 통해 신뢰를 쌓아갈 수 있습니다.',
          ),
          FaqItem(
            question: '분쟁이 발생하면 어떻게 해결하나요?',
            answer:
                '먼저 당사자 간 대화로 해결하도록 권장합니다. 해결이 어려운 경우 고객센터에서 중재 서비스를 제공합니다. 거래 내역, 채팅 기록, 사진 등을 바탕으로 공정하게 중재하며, 필요시 보상 처리도 진행됩니다.',
          ),
          FaqItem(
            question: '개인정보는 어떻게 보호되나요?',
            answer:
                '정확한 주소는 예약 확정 후에만 공개되며, 모든 개인정보는 암호화되어 저장됩니다. 거래에 필요한 최소한의 정보만 상대방에게 공개되며, 거래 완료 후에도 평가와 신뢰도 확인을 위해서만 사용됩니다.',
          ),
        ],
      ),
      FaqCategory(
        title: '커뮤니티',
        icon: Symbols.groups,
        questions: [
          FaqItem(
            question: '이웃과의 신뢰는 어떻게 쌓나요?',
            answer:
                '거래 후 상호 평가 시스템을 통해 신뢰도가 쌓입니다. 프로필에 거래 횟수, 평점, 후기 등이 표시되어 다른 이용자들이 참고할 수 있습니다. 자주 거래하는 이웃은 "단골 이웃"으로 등록할 수도 있습니다.',
          ),
          FaqItem(
            question: '우리 동네에 공유 공간이 없으면 어떡하나요?',
            answer:
                '주변 이웃에게 서비스를 알려주세요! 공간 제공자를 초대하면 포인트도 적립됩니다. 또한 원하는 조건을 등록해두면 새로운 공간이 등록될 때 알림을 받을 수 있습니다.',
          ),
          FaqItem(
            question: '이 서비스가 동네에 어떤 도움이 되나요?',
            answer:
                '사용하지 않는 공간이 수익을 창출하고, 공간이 필요한 이웃은 저렴하게 이용할 수 있습니다. 이웃 간 반복적인 상호작용으로 지역사회 단절을 줄이고, 서로 도우며 살아가는 따뜻한 동네 문화를 만들어갑니다. 작은 신뢰가 모여 큰 공동체 가치를 만듭니다.',
          ),
        ],
      ),
    ];

    return Column(
      children: faqCategories.map((category) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 24),
          child: _buildCategorySection(context, category),
        );
      }).toList(),
    );
  }

  Widget _buildCategorySection(BuildContext context, FaqCategory category) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              category.icon,
              size: 20,
              color: ShadTheme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 8),
            Text(
              category.title,
              style: ShadTheme.of(context).textTheme.large.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ShadAccordion<String>(
          children: category.questions.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            return ShadAccordionItem(
              value: '${category.title}_$index',
              title: Text(
                item.question,
                style: ShadTheme.of(context).textTheme.p,
              ),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(
                  item.answer,
                  style: ShadTheme.of(context).textTheme.small.copyWith(
                        color:
                            ShadTheme.of(context).colorScheme.mutedForeground,
                        height: 1.5,
                      ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class FaqCategory {
  final String title;
  final IconData icon;
  final List<FaqItem> questions;

  FaqCategory({
    required this.title,
    required this.icon,
    required this.questions,
  });
}

class FaqItem {
  final String question;
  final String answer;

  FaqItem({
    required this.question,
    required this.answer,
  });
}
