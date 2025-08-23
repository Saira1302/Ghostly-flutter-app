import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../notification/notification_screen.dart';
import '../route.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  late Future<List<Map<String, dynamic>>> _futureImages = Future.value([]);
  final ScrollController _scrollController = ScrollController();
  int _unsplashPage = 1;
  int _pexelsPage = 1;
  List<Map<String, dynamic>> _allImages = [];
  bool _isLoadingMore = false;
  final Random _random = Random();

  // Firebase Firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _fetchNewImages();
    _scrollController.addListener(_onScroll);
  }

  Future<void> _fetchNewImages() async {
    _unsplashPage = _random.nextInt(100) + 1;
    _pexelsPage = _random.nextInt(100) + 1;
    try {
      // Fetch from all sources simultaneously
      final futures = await Future.wait([
        fetchUnsplashImages(_unsplashPage),
        fetchPexelsImages(_pexelsPage),
        fetchFirebaseImages(),
      ]);

      final unsplashImages = futures[0];
      final pexelsImages = futures[1];
      final firebaseImages = futures[2];

      setState(() {
        _allImages.clear();
        _allImages.addAll(firebaseImages); // Firebase images first
        _allImages.addAll(unsplashImages);
        _allImages.addAll(pexelsImages);
        _futureImages = Future.value(_allImages);
      });
    } catch (e) {
      print('Error fetching images: $e');
      setState(() {
        _futureImages = Future.error('Failed to load images: $e');
      });
    }
  }

  // Fetch images from Firebase Firestore
  Future<List<Map<String, dynamic>>> fetchFirebaseImages() async {
    try {
      final QuerySnapshot querySnapshot = await _firestore
          .collection('images')
          .orderBy('timestamp', descending: true)
          .limit(20) // Limit the number of Firebase images
          .get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return {
          'type': 'firebase',
          'id': doc.id,
          'url': data['imageUrl'] ?? '',
          'caption': data['name'] ?? 'No caption',
          'timestamp': data['timestamp'],
        };
      }).where((item) => item['url'].isNotEmpty).toList();
    } catch (e) {
      print('Error fetching Firebase images: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> fetchUnsplashImages(int page) async {
    const apiKey = 'O6ZnbQej2QLAa0w-A_CbDyh7NZqp-laGFTb_8Gf8Bg8';
    final url = Uri.parse('https://api.unsplash.com/photos/?client_id=$apiKey&per_page=30&page=$page');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((item) => {
          'type': 'unsplash',
          'url': item['urls']['regular'],
          'caption': item['description'] ?? item['alt_description'] ?? 'No caption',
        }).toList();
      } else {
        throw Exception('Failed to load Unsplash images');
      }
    } catch (e) {
      print('Error fetching Unsplash images: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> fetchPexelsImages(int page) async {
    const apiKey = 'ALveTX7L9meKp6IJH67ImryJCbKjSK6s4dt98IRo0q1k0c96eA0yL20a';
    final url = Uri.parse('https://api.pexels.com/v1/search?query=nature&per_page=30&page=$page');

    try {
      final response = await http.get(url, headers: {'Authorization': apiKey});
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> photos = data['photos'];
        return photos.map((item) => {
          'type': 'pexels',
          'url': item['src']['medium'],
          'caption': item['alt'] ?? 'No caption',
        }).toList();
      } else {
        throw Exception('Failed to load Pexels images');
      }
    } catch (e) {
      print('Error fetching Pexels images: $e');
      return [];
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 1500 && !_isLoadingMore) {
      setState(() {
        _isLoadingMore = true;
        _unsplashPage++;
        _pexelsPage++;
      });

      // Load more images from APIs only (Firebase images are loaded once)
      Future.wait([
        fetchUnsplashImages(_unsplashPage),
        fetchPexelsImages(_pexelsPage)
      ]).then((results) {
        final unsplashImages = results[0];
        final pexelsImages = results[1];
        if (unsplashImages.isNotEmpty || pexelsImages.isNotEmpty) {
          setState(() {
            _allImages.addAll(unsplashImages);
            _allImages.addAll(pexelsImages);
            _futureImages = Future.value(_allImages);
            _isLoadingMore = false;
          });
        } else {
          setState(() {
            _isLoadingMore = false;
          });
        }
      }).catchError((e) {
        print('Error loading more images: $e');
        setState(() {
          _isLoadingMore = false;
        });
      });
    }
  }

  void _onItemTapped(int index) {
    if (_selectedIndex == index && index == 0) return; // Stay on Home

    setState(() {
      _selectedIndex = index;
    });

    String? route;
    switch (index) {
      case 1:
        route = AppRoutes.search;
        break;
      case 2:
        route = AppRoutes.camera;
        break;
    }

    if (route != null) {
      Navigator.pushNamed(context, route);
    }
  }

  // Helper method to get image source indicator
  Widget _getSourceIndicator(String type) {
    IconData icon;
    Color color;
    String label;

    switch (type) {
      case 'firebase':
        icon = Icons.cloud;
        color = Colors.orange;
        label = 'Firebase';
        break;
      case 'unsplash':
        icon = Icons.photo_camera;
        color = Colors.blue;
        label = 'Unsplash';
        break;
      case 'pexels':
        icon = Icons.image;
        color = Colors.green;
        label = 'Pexels';
        break;
      default:
        icon = Icons.image;
        color = Colors.grey;
        label = 'Unknown';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.8),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: Colors.white),
          const SizedBox(width: 2),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const NotificationsScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.profileMenu);
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text("Home", style: TextStyle(color: Colors.white)),
            ),
            ListTile(
              title: const Text("Settings"),
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.settings);
              },
            ),
            ListTile(
              title: const Text("Logout"),
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.logout);
              },
            ),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await _fetchNewImages();
        },
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: _futureImages,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No images available.'));
            }

            final images = snapshot.data!;
            return SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        const Text("Welcome 😉", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10),
                        const Text("Browse the pictures"),
                        const SizedBox(height: 10),
                        // Show stats
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildStatCard('Firebase', images.where((img) => img['type'] == 'firebase').length, Colors.orange),
                            _buildStatCard('Unsplash', images.where((img) => img['type'] == 'unsplash').length, Colors.blue),
                            _buildStatCard('Pexels', images.where((img) => img['type'] == 'pexels').length, Colors.green),
                          ],
                        ),
                      ],
                    ),
                  ),
                  MasonryGridView.count(
                    controller: _scrollController,
                    crossAxisCount: 2,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    padding: const EdgeInsets.all(16),
                    itemCount: images.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final item = images[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            AppRoutes.feed,
                            arguments: item,
                          );
                        },
                        child: Card(
                          elevation: 4,
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: CachedNetworkImage(
                                  imageUrl: item['url'],
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                                  errorWidget: (context, url, error) => Container(
                                    height: 150,
                                    color: Colors.grey[300],
                                    child: const Center(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.error, size: 30, color: Colors.red),
                                          Text('Failed to load', style: TextStyle(fontSize: 12)),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              // Source indicator
                              Positioned(
                                top: 8,
                                left: 8,
                                child: _getSourceIndicator(item['type'] ?? 'unknown'),
                              ),
                              // Caption overlay
                              if (item['caption'] != null && item['caption'].isNotEmpty)
                                Positioned(
                                  bottom: 0,
                                  left: 0,
                                  right: 0,
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.bottomCenter,
                                        end: Alignment.topCenter,
                                        colors: [
                                          Colors.black.withOpacity(0.8),
                                          Colors.transparent,
                                        ],
                                      ),
                                      borderRadius: const BorderRadius.only(
                                        bottomLeft: Radius.circular(8),
                                        bottomRight: Radius.circular(8),
                                      ),
                                    ),
                                    child: Text(
                                      item['caption'],
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  if (_isLoadingMore)
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                ],
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.photo_library),
            label: 'Gallery',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildStatCard(String title, int count, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(
            count.toString(),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}