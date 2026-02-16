import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart'; // coordinates of the restaurants
import 'package:url_launcher/url_launcher.dart';
import '../data/mock_data.dart';
import '../models/models.dart';

// map center and zoom limits
const LatLng kDefaultMapCenter = LatLng(44.9813951, -93.2315136);
const double kInitialMapZoom = 13;
const double kMinMapZoom = 3;
const double kMaxMapZoom = 18;

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final MapController _mapController = MapController(); //how map moves / zooms
  Restaurant _selected = mockRestaurants.first; //currently selected restaurant
  final Map<String, int> _duplicateMarkerCounts = {};

  void _zoomBy(double delta) {
    // zoom buttons
    final camera = _mapController.camera;
    final nextZoom = (camera.zoom + delta).clamp(kMinMapZoom, kMaxMapZoom);
    _mapController.move(camera.center, nextZoom);
  }

  void _selectRestaurant(Restaurant r) {
    // recenter map to current restaurant
    setState(() => _selected = r);
    _mapController.move(LatLng(r.lat, r.lng), _mapController.camera.zoom);
  }

  //for restaurant home page cards to redirect to maps
  Future<void> _navigateTo(Restaurant restaurant) async {
    final encoded = Uri.encodeComponent(restaurant.address);
    final url =
        Uri.parse('https://www.google.com/maps/search/?api=1&query=$encoded');
    await launchUrl(url, mode: LaunchMode.externalApplication);
  }

  LatLng _markerPointFor(Restaurant r) {
    final key = '${r.lat},${r.lng}';
    final duplicateIndex = _duplicateMarkerCounts[key] ?? 0;
    _duplicateMarkerCounts[key] = duplicateIndex + 1;

    if (duplicateIndex == 0) {
      return LatLng(r.lat, r.lng);
    }

    const distance = 0.00032;
    final angle = duplicateIndex * (math.pi / 3);
    return LatLng(
      r.lat + distance * math.cos(angle),
      r.lng + distance * math.sin(angle),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 80),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            FlutterMap(
              mapController: _mapController,
              options: const MapOptions(
                initialCenter: kDefaultMapCenter,
                initialZoom: kInitialMapZoom,
                interactionOptions: InteractionOptions(
                  flags: ~InteractiveFlag.rotate, // fixing rotation bug ?
                ),
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName:
                      'com.example.restaurant_discovery_flutter',
                ),
                MarkerLayer(
                  markers: () {
                    _duplicateMarkerCounts.clear();
                    return mockRestaurants.map((r) {
                      final isSelected = r.id == _selected.id;
                      final markerPoint = _markerPointFor(r);
                      return Marker(
                        // restaurant marker
                        point: markerPoint,
                        width: 54,
                        height: 44,
                        child: GestureDetector(
                          onTap: () => _selectRestaurant(r),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 7,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? const Color(0xFF111827)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(999),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x26000000),
                                  blurRadius: 8,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Text(
                              '${r.rating.toStringAsFixed(1)}',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: isSelected
                                    ? Colors.white
                                    : const Color(0xFF111827),
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList();
                  }(),
                ),
              ],
            ),
            Positioned(
              left: 12,
              right: 12,
              top: 12,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.95),
                  borderRadius: BorderRadius.circular(999),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x22000000),
                      blurRadius: 10,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: const Row(
                  children: [
                    Icon(Icons.search, color: Color(0xFF4B5563), size: 20),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Local Minneapolis Restaurants',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF111827),
                        ),
                      ),
                    ),
                    Icon(Icons.tune, color: Color(0xFF4B5563), size: 20),
                  ],
                ),
              ),
            ),
            Positioned(
              right: 12,
              top: 78,
              child: Column(
                children: [
                  FloatingActionButton.small(
                    heroTag: 'map_zoom_in',
                    onPressed: () => _zoomBy(1),
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF111827),
                    child: const Icon(Icons.add),
                  ),
                  const SizedBox(height: 8),
                  FloatingActionButton.small(
                    heroTag: 'map_zoom_out',
                    onPressed: () => _zoomBy(-1),
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF111827),
                    child: const Icon(Icons.remove),
                  ),
                ],
              ),
            ),
            Positioned(
              left: 12,
              right: 12,
              bottom: 58,
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.97),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x30000000),
                      blurRadius: 14,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        _selected.image,
                        width: 84,
                        height: 84,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _selected.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _selected.cuisine,
                            style: const TextStyle(
                              color: Color(0xFF6B7280),
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            _selected.address,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Color(0xFF6B7280),
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(
                                Icons.star,
                                size: 14,
                                color: Color(0xFFF59E0B),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${_selected.rating.toStringAsFixed(1)} (${_selected.reviewCount})',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: () => _navigateTo(_selected),
                      style: IconButton.styleFrom(
                        backgroundColor: const Color(0xFF111827),
                        foregroundColor: Colors.white,
                      ),
                      icon: const Icon(Icons.navigation),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 12,
              right: 12,
              bottom: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.95),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  '${mockRestaurants.length} places in this area', // we will change this later to be more dynamic
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF111827),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
