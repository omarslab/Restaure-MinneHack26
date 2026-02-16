import '../models/models.dart';

const List<Restaurant> mockRestaurants = [
  Restaurant(
    id: '1',
    name: 'Erta Ale Ethiopian',
    cuisine: 'Ethiopian',
    image:
        'https://s3-media0.fl.yelpcdn.com/bphoto/9kchbgjDZefPB_XmFpZ3Ag/o.jpg',
    lat: 44.949284,
    lng: -93.083572,
    address: '308 E Prince St STE 140, St Paul, MN 55101',
    rating: 4.8,
    reviewCount: 378,
  ),
  Restaurant(
    id: '2',
    name: 'Habanero Tacos Grill',
    cuisine: 'Mexican',
    image:
        'https://s3-media0.fl.yelpcdn.com/bphoto/_MiQK_86gGCXG0IJPEtpeQ/o.jpg',
    lat: 44.948090,
    lng: -93.224678,
    address: '3223 E Lake St, Minneapolis, MN 55406',
    rating: 4.6,
    reviewCount: 612,
  ),
  Restaurant(
    id: '3',
    name: 'Soberfish',
    cuisine: 'Sushi',
    image:
        'https://townsquare.media/site/715/files/2025/10/attachment-soberfish-1.jpg?w=1436&h=872&q=75',
    lat: 44.962571,
    lng: -93.233593,
    address: '2627 E Franklin Ave, Minneapolis, MN 55406',
    rating: 4.3,
    reviewCount: 987,
  ),
  Restaurant(
    id: '4',
    name: 'Taqueria La Hacienda',
    cuisine: 'Mexican',
    image:
        'https://s3-media0.fl.yelpcdn.com/bphoto/awSSAe_k9a_Cb-Y5ahnjOA/348s.jpg',
    lat: 44.884031,
    lng: -93.255599,
    address: '1645 E 66th St, Richfield, MN 55423',
    rating: 4.2,
    reviewCount: 650,
  ),
  Restaurant(
    id: '5',
    name: 'Afro Deli & Grill: Minneapolis',
    cuisine: 'African',
    image:
        'https://res.cloudinary.com/the-infatuation/image/upload/c_fill,w_1920,ar_4:3,g_center,f_auto/images/AfroDeli_MoonlitRoad_RachelNadeau02_x1g4ov',
    lat: 44.97363798356224,
    lng: -93.22752489451325,
    address: '720 Washington Ave SE, Minneapolis, MN 55414',
    rating: 4.6,
    reviewCount: 943,
  ),
  Restaurant(
    id: '6',
    name: 'Oasis Mediterranean Grill',
    cuisine: 'Mediterranean',
    image:
        'https://lh3.googleusercontent.com/p/AF1QipOCgvqUX-9Wty4vbqI7TAmdcs2qF5Jc0UwR4Fbo=w243-h406-n-k-no-nu',
    lat: 44.96872125911048,
    lng:  -93.24433393414787,
    address: '1939 S 5th St, Minneapolis, MN 55454',
    rating: 4.7,
    reviewCount: 242,
  ),
];

const List<LeaderboardEntry> mockLeaderboard = [
  LeaderboardEntry(
      userId: '1', userName: 'Emmanuel Girmaye', points: 2850, rank: 1),
  LeaderboardEntry(
      userId: '2', userName: 'Mohamed Omar', points: 2340, rank: 2),
  LeaderboardEntry(
      userId: '3', userName: 'Marvin Tounou-Akue', points: 1920, rank: 3),
  LeaderboardEntry(
      userId: '4', userName: 'Lebron James', points: 1675, rank: 4),
  LeaderboardEntry(userId: '5', userName: '...', points: 1450, rank: 5),
  LeaderboardEntry(userId: '6', userName: '...', points: 1230, rank: 6),
  LeaderboardEntry(userId: '7', userName: '...', points: 1100, rank: 7),
  LeaderboardEntry(userId: '8', userName: 'Hamza Ahmed', points: 980, rank: 8),
];
