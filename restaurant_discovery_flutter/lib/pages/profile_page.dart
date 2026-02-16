import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/mock_data.dart';
import '../models/models.dart';
import '../widgets/app_state.dart';
import '../widgets/login_dialog.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final user = state.user;

    if (!state.isLoggedIn) {
      //show login prompt if not logged in
      return Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 40,
                backgroundColor: Color(0xFFFEF3C7),
                child: Icon(Icons.person, size: 40, color: Color(0xFFD97706)),
              ),
              const SizedBox(height: 16),
              const Text('Join Restaure',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text(
                'Sign up to earn points, leave reviews, and track your restaurant visits',
                textAlign: TextAlign.center,
                style: TextStyle(color: Color(0xFF6B7280)),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) => LoginDialog(
                      onSubmit: (user) => state.setUser(user),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD97706),
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: const Text('Sign Up / Log In'),
              ),
            ],
          ),
        ),
      );
    }
    // if logged in, show profile page
    final reviews = state.reviews;
    final checkIns = state.checkIns;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
      child: ListView(
        children: [
          const Text('Profile',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          const SizedBox(height: 16),
          Card(
            // user info card
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 28,
                        backgroundColor: Color(0xFFFEF3C7),
                        child: Icon(Icons.person,
                            size: 28, color: Color(0xFFD97706)),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(user!.name,
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                            Text(user.email,
                                style:
                                    const TextStyle(color: Color(0xFF6B7280))),
                            const SizedBox(height: 4),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _Stat(
                          icon: Icons.emoji_events,
                          color: Color(0xFFD97706),
                          value: user.points.toString()),
                      _Stat(
                          icon: Icons.chat_bubble_outline,
                          color: Color(0xFF2563EB),
                          value: '${reviews.length}'),
                      _Stat(
                          icon: Icons.star,
                          color: Color(0xFF16A34A),
                          value: '${checkIns.length}'),
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (reviews.isNotEmpty) ...[
            const SizedBox(height: 16),
            const Text('Recent Reviews',
                style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            ...reviews.reversed.take(3).map((review) {
              final restaurant = mockRestaurants.firstWhere(
                (r) => r.id == review.restaurantId,
                orElse: () => const Restaurant(
                  id: '0',
                  name: 'Unknown',
                  cuisine: '',
                  image: '',
                  lat: 0,
                  lng: 0,
                  address: '',
                  rating: 0,
                  reviewCount: 0,
                ),
              );
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      if (restaurant.image.isNotEmpty)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(restaurant.image,
                              width: 56, height: 56, fit: BoxFit.cover),
                        )
                      else
                        const SizedBox(width: 56, height: 56),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(restaurant.name,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600)),
                            const SizedBox(height: 4),
                            Row(
                              children: List.generate(5, (i) {
                                return Icon(
                                  Icons.star,
                                  size: 14,
                                  color: i < review.rating
                                      ? const Color(0xFFF59E0B)
                                      : const Color(0xFFD1D5DB),
                                );
                              }),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              review.comment,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontSize: 12, color: Color(0xFF6B7280)),
                            ),
                            const SizedBox(height: 4),
                            Text('+${review.pointsEarned} points',
                                style: const TextStyle(
                                    fontSize: 12, color: Color(0xFF16A34A))),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ],
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: () => state.setUser(null),
            icon: const Icon(Icons.logout),
            label: const Text('Log Out'),
          ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.icon, required this.color, required this.value});

  final IconData icon;
  final Color color;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color),
        const SizedBox(height: 4),
        Text(value,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
