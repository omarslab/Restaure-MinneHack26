import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_discovery_flutter/widgets/qr_scanner_dialog.dart';
import '../data/mock_data.dart';
import '../models/models.dart';
import '../widgets/app_state.dart';
import '../widgets/restaurant_card.dart';
import '../widgets/review_dialog.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _search = ''; //store search from keyboard

  List<Restaurant> _filtered() {
    // return all restaurants if empty, otherwise lowercase match
    if (_search.trim().isEmpty) return mockRestaurants;
    final query = _search.toLowerCase();
    return mockRestaurants
        .where(
          (r) =>
              r.name.toLowerCase().contains(query) ||
              r.cuisine.toLowerCase().contains(query),
        )
        .toList();
  }

  Future<void> _navigateTo(Restaurant restaurant) async {
    // google maps api popout
    final encoded = Uri.encodeComponent(restaurant.address);
    final url = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$encoded',
    );
    await launchUrl(url, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    // home page styling
    final results = _filtered();
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Discover',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          const Text(
            'Find great local restaurants',
            style: TextStyle(color: Color(0xFF6B7280)),
          ),
          const SizedBox(height: 16),
          TextField(
            onChanged: (value) => setState(() => _search = value),
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search),
              hintText: 'Search local restaurants...',
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: results.isEmpty
                ? const Center(
                    child: Text(
                      'No restaurants found',
                      style: TextStyle(color: Color(0xFF6B7280)),
                    ),
                  )
                : ListView.separated(
                    itemCount: results.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final restaurant = results[index];
                      return RestaurantCard(
                        restaurant: restaurant,
                        onNavigate: () => _navigateTo(restaurant),
                        onReview: () {
                          if (!context.read<AppState>().isLoggedIn) {
                            //popup for when the user try to leave a review
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('How to Earn Rewards'),
                                content: const Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                        'Pull up to a participating restaurant'),
                                    SizedBox(height: 16),
                                    Text('Look for a QR code that looks like:'),
                                    SizedBox(height: 12),
                                    Image(
                                      image: AssetImage('assets/nftqr.png'),
                                      width: 150,
                                      height: 150,
                                    ),
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      showDialog(
                                        context: context,
                                        builder: (_) => QRScannerDialog(
                                          onScan: (data) {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      );
                                    },
                                    child: const Text('Scan'),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                    child: const Text('Close'),
                                  ),
                                ],
                              ),
                            );
                            return;
                          }
                          showDialog(
                            context: context,
                            builder: (_) => ReviewDialog(
                              restaurant: restaurant,
                              onSubmit: (rating, comment) {
                                final user = context.read<AppState>().user!;
                                final review = Review(
                                  id: DateTime.now()
                                      .millisecondsSinceEpoch
                                      .toString(),
                                  restaurantId: restaurant.id,
                                  userId: user.id,
                                  userName: user.name,
                                  rating: rating,
                                  comment: comment,
                                  date: DateTime.now(),
                                  pointsEarned: 50,
                                );
                                context.read<AppState>().addReview(review);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Review submitted. +50 points!',
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
