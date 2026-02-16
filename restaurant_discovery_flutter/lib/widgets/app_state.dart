import 'dart:math';
import 'package:flutter/foundation.dart';
import '../models/models.dart';
import '../data/mock_data.dart';

class AppState extends ChangeNotifier {
  UserProfile? _user;
  final List<Review> _reviews = [];
  final List<CheckIn> _checkIns = [];
  final List<LeaderboardEntry> _leaderboard = List.unmodifiable(mockLeaderboard);

  UserProfile? get user => _user;
  bool get isLoggedIn => _user != null;
  List<Review> get reviews => List.unmodifiable(_reviews);
  List<CheckIn> get checkIns => List.unmodifiable(_checkIns);
  List<LeaderboardEntry> get leaderboard => _leaderboard;

  void setUser(UserProfile? user) {
    _user = user;
    notifyListeners();
  }

  void addReview(Review review) {
    _reviews.add(review);
    earnPoints(review.pointsEarned);
    notifyListeners();
  }

  void addCheckIn(CheckIn checkIn) {
    _checkIns.add(checkIn);
    earnPoints(checkIn.pointsEarned);
    notifyListeners();
  }

  void earnPoints(int points) {
    if (_user == null) return;
    _user = _user!.copyWith(points: _user!.points + points);
    notifyListeners();
  }

  int randomRewardPoints() {
    return Random().nextInt(201) + 100;
  }
}
