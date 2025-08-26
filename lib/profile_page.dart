import 'package:flutter/material.dart';
import 'settings/privacy_settings_page.dart';
import 'settings/account_settings_page.dart';
import 'settings/help_support_page.dart';
import 'login_page.dart';

class ProfilePage extends StatefulWidget {
  final bool isOwnProfile;

  const ProfilePage({
    Key? key,
    this.isOwnProfile = true, // Default to true for backward compatibility
  }) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isFollowing = false;
  int _followersCount = 5;

  // Sample video data - in a real app, this would come from your backend
  final List<Map<String, String>> _videos = [
    {
      'thumbnail': 'https://example.com/video1_thumb.jpg',
      'url': 'https://example.com/video1.mp4',
      'duration': '0:30',
    },
    {
      'thumbnail': 'https://example.com/video2_thumb.jpg',
      'url': 'https://example.com/video2.mp4',
      'duration': '1:15',
    },
  ];

  void _toggleFollow() {
    setState(() {
      _isFollowing = !_isFollowing;
      _followersCount += _isFollowing ? 1 : -1;
    });
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Orange curved background
          Container(
            height: MediaQuery.of(context).size.height * 0.3,
            decoration: const BoxDecoration(
              color: Colors.orange,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // Back button and settings
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios,
                            color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      IconButton(
                        icon: const Icon(Icons.menu, color: Colors.white),
                        onPressed: () {
                          showDialog(
                            context: context,
                            barrierColor:
                                Colors.black.withOpacity(0.5), // dim background
                            builder: (BuildContext context) {
                              return Dialog(
                                backgroundColor: Colors.transparent,
                                elevation: 0,
                                insetPadding:
                                    const EdgeInsets.only(top: 50, right: 16),
                                alignment: Alignment.topRight,
                                child: Container(
                                  width: 250,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      _buildSettingsOption(
                                        icon: Icons.edit,
                                        label: 'Edit Profile',
                                        onTap: () {
                                          Navigator.pop(context);
                                          // Add edit profile logic here
                                        },
                                      ),
                                      _buildSettingsOption(
                                        icon: Icons.lock,
                                        label: 'Privacy Settings',
                                        onTap: () {
                                          Navigator.pop(context);
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const PrivacySettingsPage(),
                                            ),
                                          );
                                        },
                                      ),
                                      _buildSettingsOption(
                                        icon: Icons.settings,
                                        label: 'Account Settings',
                                        onTap: () {
                                          Navigator.pop(context);
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const AccountSettingsPage(),
                                            ),
                                          );
                                        },
                                      ),
                                      _buildSettingsOption(
                                        icon: Icons.help_outline,
                                        label: 'Help & Support',
                                        onTap: () {
                                          Navigator.pop(context);
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const HelpSupportPage(),
                                            ),
                                          );
                                        },
                                      ),
                                      const Divider(),
                                      _buildSettingsOption(
                                        icon: Icons.logout,
                                        label: 'LOGOUT',
                                        isLogout: true,
                                        onTap: () {
                                          // First pop the dialog
                                          Navigator.of(context).pop();
                                          // Use Future.delayed to ensure the dialog is fully closed
                                          Future.delayed(Duration.zero, () {
                                            // Then navigate to login page
                                            Navigator.of(context)
                                                .pushNamedAndRemoveUntil(
                                              '/login',
                                              (route) => false,
                                            );
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),

                // Profile Section
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      // Profile Image
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 3),
                          image: const DecorationImage(
                            image: AssetImage('assets/default_profile.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Name and Age
                      const Text(
                        'SAGE',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        'age 1',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Stats Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildStatColumn('5', 'Friends'),
                          Container(
                            height: 40,
                            width: 1,
                            color: Colors.grey[300],
                            margin: const EdgeInsets.symmetric(horizontal: 20),
                          ),
                          _buildStatColumn(
                              _followersCount.toString(), 'Followers'),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Follow Button - only show for other profiles
                      if (!widget.isOwnProfile) ...[
                        ElevatedButton(
                          onPressed: _toggleFollow,
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                _isFollowing ? Colors.grey : Colors.green,
                            padding: const EdgeInsets.symmetric(horizontal: 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Text(
                            _isFollowing ? 'Following' : 'Follow',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],

                      // Bio
                      const Text(
                        'I am sage a beautiful 2-year-old Domestic Shorthair cat with soft, sleek orange fur and sparkling green eyes.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),

                // Tab Bar
                TabBar(
                  controller: _tabController,
                  tabs: const [
                    Tab(text: 'Photos'),
                    Tab(text: 'Videos'),
                    Tab(text: 'Bookmark'),
                  ],
                  labelColor: Colors.black,
                  unselectedLabelColor: Colors.grey,
                ),

                // Tab Bar View
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      // Photos Grid
                      GridView.builder(
                        padding: const EdgeInsets.all(8),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                        ),
                        itemCount: 4, // Adjust based on actual photos
                        itemBuilder: (context, index) {
                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.grey[300],
                            ),
                            // Add actual images here
                          );
                        },
                      ),

                      // Videos Tab
                      GridView.builder(
                        padding: const EdgeInsets.all(8),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                        ),
                        itemCount: _videos.length,
                        itemBuilder: (context, index) {
                          final video = _videos[index];
                          return GestureDetector(
                            onTap: () {
                              // Show video player
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  contentPadding: EdgeInsets.zero,
                                  content: AspectRatio(
                                    aspectRatio: 16 / 9,
                                    child: Container(
                                      color: Colors.black,
                                      child: const Center(
                                        child: Text(
                                          'Video Player Placeholder',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.grey[300],
                              ),
                              child: Stack(
                                children: [
                                  // Video Thumbnail
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      image: DecorationImage(
                                        image:
                                            NetworkImage(video['thumbnail']!),
                                        fit: BoxFit.cover,
                                        onError: (error, stackTrace) {},
                                      ),
                                    ),
                                  ),
                                  // Play Button Overlay
                                  Center(
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.5),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.play_arrow,
                                        color: Colors.white,
                                        size: 30,
                                      ),
                                    ),
                                  ),
                                  // Duration Badge
                                  Positioned(
                                    bottom: 8,
                                    right: 8,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.7),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        video['duration']!,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),

                      // Bookmarks Tab
                      const Center(child: Text('Bookmarks')),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatColumn(String value, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isLogout = false,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isLogout
                      ? const Color(0xFFFF6B6B).withOpacity(0.1)
                      : Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: isLogout ? const Color(0xFFFF6B6B) : Colors.orange,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                label,
                style: TextStyle(
                  color: isLogout ? const Color(0xFFFF6B6B) : Colors.black87,
                  fontSize: 16,
                  fontWeight: isLogout ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
