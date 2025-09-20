import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hankan/app/feature/home/logic/home_provider.dart';
import 'package:hankan/app/feature/home/screens/home/widgets/expandable_fab.dart';
import 'package:hankan/app/feature/home/screens/home/widgets/home_appbar.dart';
import 'package:hankan/app/feature/home/screens/home/widgets/space_carousel_card.dart';
import 'package:latlong2/latlong.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late MapController _mapController;
  final CarouselSliderController _carouselController = CarouselSliderController();

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
  }

  void _onCarouselPageChanged(int index) {
    final homeState = ref.read(homeProvider);
    final spaces = homeState.availableSpaces;

    if (spaces.isNotEmpty && index < spaces.length) {
      ref.read(homeProvider.notifier).updateCarouselIndex(index);

      // Animate map to the selected marker
      _mapController.move(
        LatLng(spaces[index].latitude, spaces[index].longitude),
        15.0, // Zoom level
      );
    }
  }

  void _onMarkerTapped(int index) {
    _carouselController.animateToPage(index);
    ref.read(homeProvider.notifier).updateCarouselIndex(index);
  }
  @override
  Widget build(BuildContext context) {
    final homeState = ref.watch(homeProvider);
    final spaces = homeState.availableSpaces;
    final currentIndex = homeState.currentCarouselIndex;

    // Default center (Seoul) if no spaces
    final mapCenter = spaces.isNotEmpty
        ? LatLng(spaces[currentIndex].latitude, spaces[currentIndex].longitude)
        : LatLng(37.5665, 126.9780);

    return Scaffold(
      appBar: HomeAppbar(),
      body: Stack(
        children: [
          // Map with markers
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: mapCenter,
              initialZoom: 13.0,
            ),
            children: [
              // Tile layer
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.hankan',
              ),
              // Markers layer
              MarkerLayer(
                markers: spaces.asMap().entries.map((entry) {
                  final index = entry.key;
                  final space = entry.value;
                  final isSelected = index == currentIndex;

                  return Marker(
                    point: LatLng(space.latitude, space.longitude),
                    width: isSelected ? 50 : 40,
                    height: isSelected ? 50 : 40,
                    child: GestureDetector(
                      onTap: () => _onMarkerTapped(index),
                      child: Container(
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Theme.of(context).primaryColor
                              : Colors.grey.shade600,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 5,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.location_on,
                          color: Colors.white,
                          size: isSelected ? 26 : 20,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),

          // Carousel at bottom
          if (spaces.isNotEmpty)
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: SizedBox(
                height: 200,
                child: CarouselSlider.builder(
                  carouselController: _carouselController,
                  itemCount: spaces.length,
                  options: CarouselOptions(
                    height: 200,
                    viewportFraction: 0.85,
                    enableInfiniteScroll: false,
                    onPageChanged: (index, reason) {
                      _onCarouselPageChanged(index);
                    },
                  ),
                  itemBuilder: (context, index, realIndex) {
                    return SpaceCarouselCard(
                      space: spaces[index],
                      onTap: () {
                        // Navigate to space detail page
                        // You can implement navigation here
                      },
                    );
                  },
                ),
              ),
            ),

          // Loading indicator
          if (homeState.isLoading)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
      floatingActionButton: const ExpandableFAB(),
    );
  }
}



// const SizedBox(height: 20),
// Padding(
//   padding: const EdgeInsets.symmetric(horizontal: 24.0),
//   child: SizedBox(
//     height: 100,
//     child: DefaultTextStyle(
//       style: ShadTheme.of(context).textTheme.h3,
//       child: AnimatedTextKit(
//         pause: const Duration(milliseconds: 500),
//         repeatForever: true,
//         animatedTexts: [
//           RotateAnimatedText(
//             '공간만 차지하는 선풍기, 지금 바로 맡겨보세요!',
//             duration: const Duration(milliseconds: 5000),
//           ),
//           RotateAnimatedText(
//             '공간만 차지하는 선풍기, 지금 바로 맡겨보세요!',
//             duration: const Duration(milliseconds: 5000),
//           ),
//           RotateAnimatedText(
//             '집안의 남는 공간, 한칸에서 편하게 수익창출 해보세요!',
//             duration: const Duration(milliseconds: 5000),
//           ),
//           RotateAnimatedText(
//             '이사철, 짐 보관 걱정은 이제 그만! 한칸과 함께하세요!',
//             duration: const Duration(milliseconds: 5000),
//           ),
//         ],
//       ),
//     ),
//   ),
// ),
// const SizedBox(height: 24),