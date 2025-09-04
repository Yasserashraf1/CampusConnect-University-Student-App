import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../models/user.dart';
import '../models/group.dart';
import '../models/post.dart';

class AppProvider with ChangeNotifier {
  User? _user;
  String _currentScreen = 'splash';
  Group? _selectedGroup;
  List<Group> _groups = [];
  List<Post> _posts = [];
  Timer? _notificationTimer;

  User? get user => _user;
  String get currentScreen => _currentScreen;
  Group? get selectedGroup => _selectedGroup;
  List<Group> get groups => _groups;
  List<Post> get posts => _posts;

  AppProvider() {
    _initializeMockData();
  }

  void _initializeMockData() {
    _groups = [
      Group(
        id: '1',
        name: 'Computer Science 2024',
        description: 'CS students batch 2024',
        memberCount: 125,
        createdAt: DateTime(2024, 8, 1),
      ),
      Group(
        id: '2',
        name: 'Study Group - Algorithms',
        description: 'Weekly algorithm study sessions',
        memberCount: 23,
        createdAt: DateTime(2024, 8, 15),
      ),
      Group(
        id: '3',
        name: 'Campus Events',
        description: 'Stay updated with campus events and activities',
        memberCount: 456,
        createdAt: DateTime(2024, 7, 20),
      ),
    ];

    _posts = [
      Post(
        id: '1',
        groupId: '1',
        authorId: 'user1',
        authorName: 'Alice Johnson',
        content: 'Hey everyone! Anyone up for a study session this weekend? We could review the data structures material.',
        createdAt: DateTime(2024, 8, 28, 10, 30),
      ),
      Post(
        id: '2',
        groupId: '1',
        authorId: 'user2',
        authorName: 'Bob Smith',
        content: 'Check out this cool project I found on GitHub: https://github.com/example/awesome-project',
        createdAt: DateTime(2024, 8, 28, 9, 15),
      ),
      Post(
        id: '3',
        groupId: '2',
        authorId: 'user3',
        authorName: 'Carol Davis',
        content: 'This week\'s algorithm: Binary Search Trees. Let\'s meet Thursday 6 PM at the library.',
        createdAt: DateTime(2024, 8, 27, 14, 20),
      ),
    ];
  }

  void login(User userData) {
    _user = userData;
    _currentScreen = 'home';
    _startNotificationTimer();
    notifyListeners();
  }

  void logout() {
    _user = null;
    _currentScreen = 'login';
    _selectedGroup = null;
    _stopNotificationTimer();
    notifyListeners();
  }

  void setScreen(String screen) {
    _currentScreen = screen;
    notifyListeners();
  }

  void setSelectedGroup(Group? group) {
    _selectedGroup = group;
    notifyListeners();
  }

  void addGroup(Group group) {
    _groups.add(group);
    notifyListeners();
  }

  void joinGroup(String groupId) {
    // In a real app, this would update the user's joined groups
    debugPrint('Joined group: $groupId');
  }

  void addPost(String groupId, String authorId, String authorName, String content) {
    final newPost = Post(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      groupId: groupId,
      authorId: authorId,
      authorName: authorName,
      content: content,
      createdAt: DateTime.now(),
    );
    _posts.insert(0, newPost);
    notifyListeners();
  }

  List<Post> getGroupPosts(String groupId) {
    return _posts.where((post) => post.groupId == groupId).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  void _startNotificationTimer() {
    _notificationTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      if (_user != null && _currentScreen == 'home') {
        final randomMessages = [
          'New post in Computer Science 2024',
          'Someone joined your study group',
          'Campus event starting soon',
          'New message in Algorithms group'
        ];
        
        // Randomly show a notification
        if (Random().nextDouble() > 0.8) {
          final message = randomMessages[Random().nextInt(randomMessages.length)];
          // In a real app, this would be a push notification
          debugPrint('🔔 Notification: $message');
        }
      }
    });
  }

  void _stopNotificationTimer() {
    _notificationTimer?.cancel();
    _notificationTimer = null;
  }

  void simulateRealTimePost(String groupId) {
    if (_selectedGroup?.id == groupId) {
      final simulatedPosts = [
        "Just finished the assignment! Anyone want to review together?",
        "Great lecture today on data structures 👍",
        "Study group meeting moved to 7 PM today",
        "Check out this helpful tutorial I found",
        "Anyone free for coffee after class?"
      ];
      
      final randomPost = simulatedPosts[Random().nextInt(simulatedPosts.length)];
      final randomAuthors = ['Alex Chen', 'Sarah Williams', 'Mike Johnson', 'Emma Davis'];
      final randomAuthor = randomAuthors[Random().nextInt(randomAuthors.length)];
      
      addPost(groupId, 'simulated-user', randomAuthor, randomPost);
    }
  }

  String formatMemberCount(int count) {
    if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}k';
    }
    return count.toString();
  }

  String formatTimeAgo(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inMinutes < 1) return 'Just now';
    if (difference.inMinutes < 60) return '${difference.inMinutes}m ago';
    if (difference.inHours < 24) return '${difference.inHours}h ago';
    return '${difference.inDays}d ago';
  }

  String getAuthorInitials(String name) {
    return name.split(' ').map((n) => n.isNotEmpty ? n[0] : '').join('').toUpperCase();
  }

  String getGroupIcon(String groupName) {
    final name = groupName.toLowerCase();
    if (name.contains('computer') || name.contains('cs')) return '💻';
    if (name.contains('study') || name.contains('algorithm')) return '📚';
    if (name.contains('event') || name.contains('campus')) return '🎉';
    return '👥';
  }

  String getCategoryIcon(String category) {
    const icons = {
      'Academic': '🎓',
      'Study Group': '📚',
      'Campus Events': '🎉',
      'Sports & Recreation': '⚽',
      'Clubs & Societies': '🏛️',
      'Project Teams': '🚀',
      'Social': '👥',
      'Other': '📌'
    };
    return icons[category] ?? '📌';
  }

  @override
  void dispose() {
    _stopNotificationTimer();
    super.dispose();
  }
}