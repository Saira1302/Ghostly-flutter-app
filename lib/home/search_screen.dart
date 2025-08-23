// search_screen.dart
import 'package:flutter/material.dart';
import '../route.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool _isLoading = false;
  String _selectedFilter = 'All'; // Filter options
  final List<String> _filters = ['All', 'Users', 'Posts', 'Videos'];

  // Sample data for search results
  final List<Map<String, dynamic>> _sampleData = [
    {'type': 'user', 'name': 'john_doe', 'preview': 'John Doe - 150 posts'},
    {'type': 'post', 'title': 'Beautiful Sunset', 'url': 'https://picsum.photos/400/600'},
    {'type': 'video', 'title': 'Buzzing Bee', 'url': 'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4'},
    {'type': 'user', 'name': 'jane_smith', 'preview': 'Jane Smith - 200 posts'},
    {'type': 'post', 'title': 'City Skyline', 'url': 'https://picsum.photos/400/400'},
  ];

  List<Map<String, dynamic>> _filteredResults = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text.toLowerCase();
      _filterResults();
    });
  }

  void _filterResults() {
    setState(() {
      _isLoading = true;
    });
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _filteredResults = _sampleData.where((item) {
          final matchesQuery = item.values
              .where((value) => value is String)
              .any((value) => value.toLowerCase().contains(_searchQuery));
          final matchesFilter = _selectedFilter == 'All' ||
              (item['type'] == _selectedFilter.toLowerCase());
          return matchesQuery && matchesFilter;
        }).toList();
        _isLoading = false;
      });
    });
  }

  void _clearSearch() {
    setState(() {
      _searchController.clear();
      _searchQuery = '';
      _filteredResults.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search bar with filter
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search users, posts, or videos...',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: _clearSearch,
                      )
                          : null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8.0),
                DropdownButton<String>(
                  value: _selectedFilter,
                  items: _filters.map((filter) {
                    return DropdownMenuItem<String>(
                      value: filter,
                      child: Text(filter),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedFilter = value!;
                      _filterResults();
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            // Search results
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _filteredResults.isEmpty
                  ? const Center(child: Text('No results found'))
                  : ListView.builder(
                itemCount: _filteredResults.length,
                itemBuilder: (context, index) {
                  final item = _filteredResults[index];
                  return ListTile(
                    leading: item['type'] == 'user'
                        ? const CircleAvatar(child: Icon(Icons.person))
                        : item['type'] == 'post' || item['type'] == 'video'
                        ? const Icon(Icons.image)
                        : null,
                    title: Text(item['name'] ?? item['title'] ?? ''),
                    subtitle: Text(item['preview'] ?? ''),
                    onTap: () {
                      if (item['type'] == 'user') {
                        Navigator.pushNamed(context, AppRoutes.profileMenu);
                      } else {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.feed,
                          arguments: {
                            'type': item['type'],
                            'url': item['url'],
                            'caption': item['title'],
                          },
                        );
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}