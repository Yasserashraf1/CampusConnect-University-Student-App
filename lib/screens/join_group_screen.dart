import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';

class JoinGroupScreen extends StatefulWidget {
  const JoinGroupScreen({super.key});

  @override
  State<JoinGroupScreen> createState() => _JoinGroupScreenState();
}

class _JoinGroupScreenState extends State<JoinGroupScreen> {
  final _searchController = TextEditingController();
  String? _joiningGroupId;

  // Mock available groups to join
  final List<Map<String, dynamic>> _availableGroups = [
    {
      'id': '4',
      'name': 'Machine Learning Study Group',
      'description': 'Weekly ML paper discussions and coding sessions. Open to all levels!',
      'memberCount': 89,
      'category': 'Academic',
      'privacy': 'public',
      'trending': true,
      'recentActivity': '5 new posts today'
    },
    {
      'id': '5',
      'name': 'Campus Photography Club',
      'description': 'Capture the beauty of campus life and improve your photography skills',
      'memberCount': 156,
      'category': 'Clubs & Societies',
      'privacy': 'public',
      'trending': false,
      'recentActivity': '2 events this week'
    },
    {
      'id': '6',
      'name': 'Web Development Bootcamp',
      'description': 'Learn modern web development technologies together',
      'memberCount': 234,
      'category': 'Academic',
      'privacy': 'public',
      'trending': true,
      'recentActivity': 'Daily challenges'
    },
    {
      'id': '7',
      'name': 'International Students',
      'description': 'Connect with fellow international students and share experiences',
      'memberCount': 312,
      'category': 'Social',
      'privacy': 'public',
      'trending': false,
      'recentActivity': 'Welcome event tomorrow'
    },
    {
      'id': '8',
      'name': 'Research Paper Reviews',
      'description': 'Graduate students discussing latest research in various fields',
      'memberCount': 67,
      'category': 'Academic',
      'privacy': 'private',
      'trending': false,
      'recentActivity': 'Weekly discussions'
    }
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredGroups {
    final query = _searchController.text.toLowerCase();
    if (query.isEmpty) return _availableGroups;
    
    return _availableGroups.where((group) {
      return group['name'].toLowerCase().contains(query) ||
             group['description'].toLowerCase().contains(query) ||
             group['category'].toLowerCase().contains(query);
    }).toList();
  }

  List<Map<String, dynamic>> get _trendingGroups {
    return _filteredGroups.where((group) => group['trending'] == true).toList();
  }

  List<Map<String, dynamic>> get _otherGroups {
    return _filteredGroups.where((group) => group['trending'] != true).toList();
  }

  Future<void> _handleJoinGroup(String groupId, String groupName) async {
    setState(() {
      _joiningGroupId = groupId;
    });

    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      context.read<AppProvider>().joinGroup(groupId);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Joined $groupName!'),
          backgroundColor: Colors.green,
        ),
      );
    }

    setState(() {
      _joiningGroupId = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final appProvider = context.read<AppProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => appProvider.setScreen('home'),
                  ),
                  const SizedBox(width: 12),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Discover Groups',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Find your community',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Hero Section
                    Card(
                      child: Column(
                        children: [
                          Container(
                            height: 128,
                            width: double.infinity,
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                              image: DecorationImage(
                                image: NetworkImage(
                                  'https://images.unsplash.com/photo-1629360035258-2ccb13aa3679?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxzdHVkZW50cyUyMHN0dWR5aW5nJTIwdG9nZXRoZXJ8ZW58MXx8fHwxNzU2MzA3NjI1fDA&ixlib=rb-4.1.0&q=80&w=1080',
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Column(
                              children: [
                                const Text(
                                  'Join a Community',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Connect with like-minded students, share knowledge, and grow together',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Text(
                                            '${_availableGroups.length}',
                                            style: const TextStyle(
                                              fontSize: 32,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            'Active Groups',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey[500],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        children: [
                                          const Text(
                                            '1.2k',
                                            style: TextStyle(
                                              fontSize: 32,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            'Total Members',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey[500],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Search
                    TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search groups by name, topic, or category...',
                        prefixIcon: const Icon(Icons.search),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onChanged: (value) => setState(() {}),
                    ),
                    const SizedBox(height: 24),

                    // Trending Groups
                    if (_trendingGroups.isNotEmpty) ...[
                      Row(
                        children: [
                          const Icon(Icons.trending_up, color: Colors.orange),
                          const SizedBox(width: 8),
                          const Text(
                            'Trending Groups',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.orange[100],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'Hot',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.orange[700],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _trendingGroups.length,
                        itemBuilder: (context, index) {
                          final group = _trendingGroups[index];
                          return _buildGroupCard(group, appProvider, isTrending: true);
                        },
                      ),
                      const SizedBox(height: 24),
                    ],

                    // All Groups
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'All Groups',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${_filteredGroups.length} groups',
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    if (_filteredGroups.isEmpty)
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(32.0),
                          child: Column(
                            children: [
                              const Text(
                                '🔍',
                                style: TextStyle(fontSize: 48),
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'No groups found',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _searchController.text.isNotEmpty
                                    ? 'Try adjusting your search terms'
                                    : 'No groups available',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                ),
                              ),
                              if (_searchController.text.isNotEmpty) ...[
                                const SizedBox(height: 16),
                                OutlinedButton(
                                  onPressed: () {
                                    _searchController.clear();
                                    setState(() {});
                                  },
                                  child: const Text('Clear Search'),
                                ),
                              ],
                            ],
                          ),
                        ),
                      )
                    else
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _otherGroups.length,
                        itemBuilder: (context, index) {
                          final group = _otherGroups[index];
                          return _buildGroupCard(group, appProvider);
                        },
                      ),

                    const SizedBox(height: 24),

                    // Create Group CTA
                    Card(
                      color: const Color(0xFFEBF8FF),
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          children: [
                            const Text(
                              '🚀',
                              style: TextStyle(fontSize: 32),
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'Can\'t find what you\'re looking for?',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Create your own group and bring together people with similar interests',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () => appProvider.setScreen('create-group'),
                              child: const Text('Create New Group'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGroupCard(Map<String, dynamic> group, AppProvider appProvider, {bool isTrending = false}) {
    final isJoining = _joiningGroupId == group['id'];

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: isTrending
              ? Border(left: BorderSide(color: Colors.orange, width: 4))
              : null,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      gradient: LinearGradient(
                        colors: isTrending
                            ? [Colors.orange[100]!, Colors.red[100]!]
                            : [const Color(0xFFDDD6FE), const Color(0xFFE879F9)],
                      ),
                    ),
                    child: Center(
                      child: Text(
                        appProvider.getCategoryIcon(group['category']),
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                group['name'],
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            if (isTrending)
                              const Icon(
                                Icons.local_fire_department,
                                color: Colors.orange,
                                size: 16,
                              ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          group['description'],
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.group, size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(
                        appProvider.formatMemberCount(group['memberCount']),
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                      const SizedBox(width: 16),
                      Icon(
                        group['privacy'] == 'public' ? Icons.public : Icons.lock,
                        size: 16,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        group['privacy'],
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                      const SizedBox(width: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          group['category'],
                          style: const TextStyle(fontSize: 10),
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: isJoining
                        ? null
                        : () => _handleJoinGroup(group['id'], group['name']),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: group['privacy'] == 'private' ? Colors.grey[300] : null,
                      foregroundColor: group['privacy'] == 'private' ? Colors.black : null,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    ),
                    child: isJoining
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(
                            group['privacy'] == 'private' ? 'Request' : 'Join',
                            style: const TextStyle(fontSize: 12),
                          ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                group['recentActivity'],
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}