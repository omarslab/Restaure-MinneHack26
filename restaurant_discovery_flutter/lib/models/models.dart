class Restaurant {
  final String id;
  final String name;
  final String cuisine;
  final String image;
  final double lat;
  final double lng;
  final String address;
  final double rating;
  final int reviewCount;

  const Restaurant({
    required this.id,
    required this.name,
    required this.cuisine,
    required this.image,
    required this.lat,
    required this.lng,
    required this.address,
    required this.rating,
    required this.reviewCount,
  });
}

class UserProfile {
  final String id;
  final String name;
  final String email;
  final int points;
  final DateTime joinedDate;

  const UserProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.points,
    required this.joinedDate,
  });

  UserProfile copyWith({
    String? id,
    String? name,
    String? email,
    int? points,
    DateTime? joinedDate,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      points: points ?? this.points,
      joinedDate: joinedDate ?? this.joinedDate,
    );
  }
}

class Review {
  final String id;
  final String restaurantId;
  final String userId;
  final String userName;
  final int rating;
  final String comment;
  final DateTime date;
  final int pointsEarned;

  const Review({
    required this.id,
    required this.restaurantId,
    required this.userId,
    required this.userName,
    required this.rating,
    required this.comment,
    required this.date,
    required this.pointsEarned,
  });
}

class CheckIn {
  final String id;
  final String restaurantId;
  final String userId;
  final DateTime date;
  final int pointsEarned;

  const CheckIn({
    required this.id,
    required this.restaurantId,
    required this.userId,
    required this.date,
    required this.pointsEarned,
  });
}

class LeaderboardEntry {
  final String userId;
  final String userName;
  final int points;
  final int rank;

  const LeaderboardEntry({
    required this.userId,
    required this.userName,
    required this.points,
    required this.rank,
  });
}
