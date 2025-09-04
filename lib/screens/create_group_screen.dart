import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../models/group.dart';

class CreateGroupScreen extends StatefulWidget {
  const CreateGroupScreen({super.key});

  @override
  State<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _selectedCategory = '';
  String _selectedPrivacy = 'public';
  bool _isCreating = false;

  final List<String> _categories = [
    'Academic',
    'Study Group',
    'Campus Events',
    'Sports & Recreation',
    'Clubs & Societies',
    'Project Teams',
    'Social',
    'Other',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _handleCreateGroup() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isCreating = true;
    });

    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 1));

    final newGroup = Group(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: _nameController.text.trim(),
      description: _descriptionController.text.trim(),
      memberCount: 1, // Creator is the first member
      createdAt: DateTime.now(),
      category: _selectedCategory,
      privacy: _selectedPrivacy,
    );

    if (mounted) {
      context.read<AppProvider>().addGroup(newGroup);
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Group created successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      
      context.read<AppProvider>().setScreen('home');
    }

    setState(() {
      _isCreating = false;
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
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
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
                        'Create Group',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Start a new community',
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
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Column(
                  children: [
                    // Header Card
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            Container(
                              width: 64,
                              height: 64,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                gradient: const LinearGradient(
                                  colors: [Color(0xFF3B82F6), Color(0xFF8B5CF6)],
                                ),
                              ),
                              child: const Center(
                                child: Text(
                                  '✨',
                                  style: TextStyle(fontSize: 28),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Create Your Group',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Build a community around shared interests and goals',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Create Form
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Group Details',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Fill in the information about your new group',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 20),

                              TextFormField(
                                controller: _nameController,
                                decoration: const InputDecoration(
                                  labelText: 'Group Name *',
                                  hintText: 'e.g., Computer Science 2024',
                                  helperText: 'Choose a clear, descriptive name for your group',
                                ),
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Please enter a group name';
                                  }
                                  return null;
                                },
                                onChanged: (value) => setState(() {}),
                              ),
                              const SizedBox(height: 16),

                              TextFormField(
                                controller: _descriptionController,
                                decoration: InputDecoration(
                                  labelText: 'Description *',
                                  hintText: 'Describe what your group is about, its purpose, and what members can expect...',
                                  helperText: '${_descriptionController.text.length}/500 characters',
                                  alignLabelWithHint: true,
                                ),
                                maxLines: 4,
                                maxLength: 500,
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Please enter a group description';
                                  }
                                  return null;
                                },
                                onChanged: (value) => setState(() {}),
                              ),
                              const SizedBox(height: 16),

                              DropdownButtonFormField<String>(
                                value: _selectedCategory.isEmpty ? null : _selectedCategory,
                                decoration: const InputDecoration(
                                  labelText: 'Category *',
                                ),
                                items: _categories.map((category) {
                                  return DropdownMenuItem(
                                    value: category,
                                    child: Row(
                                      children: [
                                        Text(appProvider.getCategoryIcon(category)),
                                        const SizedBox(width: 8),
                                        Text(category),
                                      ],
                                    ),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _selectedCategory = value ?? '';
                                  });
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please select a category';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),

                              DropdownButtonFormField<String>(
                                value: _selectedPrivacy,
                                decoration: const InputDecoration(
                                  labelText: 'Privacy Setting',
                                  helperText: 'Choose who can find and join your group',
                                ),
                                items: [
                                  DropdownMenuItem(
                                    value: 'public',
                                    child: Row(
                                      children: [
                                        const Icon(Icons.public, size: 18),
                                        const SizedBox(width: 12),
                                        const Text('Public - Anyone can find and join'),
                                      ],
                                    ),
                                  ),
                                  DropdownMenuItem(
                                    value: 'private',
                                    child: Row(
                                      children: [
                                        const Icon(Icons.lock, size: 18),
                                        const SizedBox(width: 12),
                                        const Text('Private - Invite only'),
                                      ],
                                    ),
                                  ),
                                ],
                                onChanged: (value) {
                                  setState(() {
                                    _selectedPrivacy = value ?? 'public';
                                  });
                                },
                              ),
                              const SizedBox(height: 20),

                              // Preview
                              if (_nameController.text.isNotEmpty) ...[
                                const Text(
                                  'Preview',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[50],
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 48,
                                        height: 48,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(24),
                                          gradient: const LinearGradient(
                                            colors: [Color(0xFFDDD6FE), Color(0xFFE879F9)],
                                          ),
                                        ),
                                        child: Center(
                                          child: Text(
                                            _selectedCategory.isNotEmpty
                                                ? appProvider.getCategoryIcon(_selectedCategory)
                                                : '📌',
                                            style: const TextStyle(fontSize: 20),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              _nameController.text,
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            if (_descriptionController.text.isNotEmpty) ...[
                                              const SizedBox(height: 4),
                                              Text(
                                                _descriptionController.text,
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey[600],
                                                ),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                            const SizedBox(height: 8),
                                            Row(
                                              children: [
                                                const Icon(Icons.group, size: 12),
                                                const SizedBox(width: 4),
                                                const Text(
                                                  '1 member',
                                                  style: TextStyle(fontSize: 12),
                                                ),
                                                const SizedBox(width: 16),
                                                Icon(
                                                  _selectedPrivacy == 'public'
                                                      ? Icons.public
                                                      : Icons.lock,
                                                  size: 12,
                                                ),
                                                const SizedBox(width: 4),
                                                Text(
                                                  _selectedPrivacy,
                                                  style: const TextStyle(fontSize: 12),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 20),
                              ],

                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: _isCreating ? null : _handleCreateGroup,
                                  child: _isCreating
                                      ? const SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                          ),
                                        )
                                      : const Text('Create Group'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Tips
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Tips for Success',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),
                            _buildTip(
                              icon: Icons.tag,
                              iconColor: Colors.blue,
                              title: 'Use a clear, searchable name',
                              subtitle: 'Make it easy for others to find your group',
                            ),
                            const SizedBox(height: 12),
                            _buildTip(
                              icon: Icons.group,
                              iconColor: Colors.green,
                              title: 'Set clear expectations',
                              subtitle: 'Explain the group\'s purpose and guidelines',
                            ),
                            const SizedBox(height: 12),
                            _buildTip(
                              icon: Icons.public,
                              iconColor: Colors.purple,
                              title: 'Choose the right privacy level',
                              subtitle: 'Public groups grow faster, private ones stay focused',
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    // Add extra bottom padding for safe scrolling
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTip({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: iconColor,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}