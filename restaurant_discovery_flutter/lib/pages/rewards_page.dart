import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/app_state.dart';
import '../widgets/qr_scanner_dialog.dart';

class RewardsPage extends StatelessWidget {
  const RewardsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final user = state.user;
    final leaderboard = state.leaderboard;
    final userRank = user == null
        ? null
        : (leaderboard.indexWhere((e) => e.points < user.points) + 1) == 0
            ? leaderboard.length + 1
            : leaderboard.indexWhere((e) => e.points < user.points) + 1;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
      child: ListView(
        children: [
          const Text('Rewards',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          const Text('Earn points and climb the leaderboard',
              style: TextStyle(color: Color(0xFF6B7280))),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFF59E0B), Color(0xFFEA580C)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Your Points',
                            style: TextStyle(color: Colors.white70)),
                        Text(
                          '${user?.points ?? 0}',
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 36,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const Icon(Icons.emoji_events,
                        size: 48, color: Colors.white24),
                  ],
                ),
                if (userRank != null) ...[
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.emoji_events,
                          size: 16, color: Colors.white),
                      const SizedBox(width: 6),
                      Text('Rank #$userRank on leaderboard',
                          style: const TextStyle(color: Colors.white)),
                    ],
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: ListTile(
              leading: const CircleAvatar(
                backgroundColor: Color(0xFFFEF3C7),
                child: Icon(Icons.qr_code, color: Color(0xFFD97706)),
              ),
              title: const Text('Scan QR Code'),
              subtitle: const Text('Scan in-store codes for rewards'),
              trailing: ElevatedButton(
                onPressed: () {
                  if (!state.isLoggedIn) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Log in to scan QR codes.')),
                    );
                    return;
                  }
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD97706),
                    foregroundColor: Colors.white),
                child: const Text('Scan'),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('How it works:',
                      style: TextStyle(fontWeight: FontWeight.w600)),
                  SizedBox(height: 12),
                  _HowStep(
                      index: 1, text: 'Visit a participating local business'),
                  _HowStep(
                      index: 2,
                      text:
                          'Find the QR code (on receipt, counter, or display)'),
                  _HowStep(index: 3, text: 'Scan the code to check in'),
                  _HowStep(index: 4, text: 'Earn points and unlock badges!'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text('Ways to Earn Points',
              style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              leading: const CircleAvatar(
                backgroundColor: Color(0xFFDCFCE7),
                child: Icon(Icons.emoji_events, color: Color(0xFF16A34A)),
              ),
              title: const Text('Leave a Review'),
              subtitle: const Text('50 points'),
            ),
          ),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              leading: const CircleAvatar(
                backgroundColor: Color(0xFFDBEAFE),
                child: Icon(Icons.qr_code, color: Color(0xFF2563EB)),
              ),
              title: const Text('Scan QR Code'),
              subtitle: const Text('100-300 points'),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: const [
              SizedBox(width: 8),
              Text('Leaderboard',
                  style: TextStyle(fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 8),
          Card(
            child: Column(
              children: leaderboard.map((entry) {
                final isTop = entry.rank <= 3;
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: entry.rank == 1
                        ? const Color(0xFFFACC15)
                        : entry.rank == 2
                            ? const Color(0xFFD1D5DB)
                            : entry.rank == 3
                                ? const Color(0xFFF97316)
                                : const Color(0xFFF3F4F6),
                    child: Text('${entry.rank}',
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  title: Text(
                    '${entry.userName}${user != null && entry.userId == user.id ? ' (You)' : ''}',
                    style: const TextStyle(fontSize: 14),
                  ),
                  subtitle: Text('${entry.points} points'),
                  trailing: isTop
                      ? Icon(
                          Icons.emoji_events,
                          color: entry.rank == 1
                              ? const Color(0xFFF59E0B)
                              : entry.rank == 2
                                  ? const Color(0xFF9CA3AF)
                                  : const Color(0xFFF97316),
                        )
                      : null,
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _HowStep extends StatelessWidget {
  const _HowStep({required this.index, required this.text});

  final int index;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 12,
            backgroundColor: const Color(0xFFD97706),
            child: Text('$index',
                style: const TextStyle(color: Colors.white, fontSize: 12)),
          ),
          const SizedBox(width: 8),
          Expanded(
              child:
                  Text(text, style: const TextStyle(color: Color(0xFF374151)))),
        ],
      ),
    );
  }
}
