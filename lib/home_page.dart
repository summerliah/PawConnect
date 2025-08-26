import 'package:flutter/material.dart';
import 'post_page.dart';
import 'profile_page.dart';
import 'camera_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Widget _buildHomeFeed() {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF4E6), // light pink/beige background
      body: Column(
        children: [
          // Top Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              color: Color(0xFFFFF4E6),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // PA CONNECT Logo
                const Row(
                  children: [
                    Text(
                      "PA",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFFFAA00),
                      ),
                    ),
                    Icon(Icons.pets, size: 24, color: Colors.teal),
                    Text(
                      "CONNECT",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFFFAA00),
                      ),
                    ),
                  ],
                ),
                // Navigation Icons
                Row(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: Icon(Icons.search, color: Colors.grey[600]),
                        onPressed: () {},
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: Icon(Icons.add, color: Colors.grey[600]),
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Post Creation Area
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFFFE4BC),
              borderRadius: BorderRadius.circular(25),
            ),
            child: Row(
              children: [
                // Paw Icon
                Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.pets, color: Colors.orange[300], size: 24),
                ),
                const SizedBox(width: 12),
                // Input Field
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Post your Pets Activities",
                      border: InputBorder.none,
                      hintStyle: TextStyle(color: Colors.grey[600]),
                    ),
                  ),
                ),
                // Camera Icon
                Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: Icon(Icons.camera_alt,
                        color: Colors.grey[600], size: 20),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ),

          // Feed Posts
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildPost(
                  username: "Dog",
                  location: "Bacoor Cavite",
                  time: "1 h",
                  isFollowing: true,
                  imageUrl:
                      "https://images.unsplash.com/photo-1552053831-71594a27632d?w=400",
                  likes: "Liked by Cat and 155 others",
                  comments: "4 comments",
                ),
                const SizedBox(height: 16),
                _buildPost(
                  username: "Cat",
                  location: "Dasma Cavite",
                  time: "1 h",
                  isFollowing: true,
                  imageUrl:
                      "https://images.unsplash.com/photo-1514888286974-6c03e2ca1dba?w=400",
                  likes: "Liked by Dog and 155 others",
                  comments: "4 comments",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPost({
    required String username,
    required String location,
    required String time,
    required bool isFollowing,
    required String imageUrl,
    required String likes,
    required String comments,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Post Header
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // Profile Picture and Info - Made Tappable
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfilePage(isOwnProfile: false),
                      ),
                    );
                  },
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: username == "Dog"
                                ? Colors.orange[300]!
                                : Colors.grey[300]!,
                            width: 2,
                          ),
                        ),
                        child: Icon(
                          Icons.pets,
                          color: username == "Dog"
                              ? Colors.orange[300]
                              : Colors.grey[400],
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      // User Info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              username,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              "$time $location",
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // Follow Button and Options
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF4CAF50),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.green.withOpacity(0.2),
                            spreadRadius: 1,
                            blurRadius: 3,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: const Text(
                        "Follow",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.more_vert, color: Colors.grey),
                  ],
                ),
              ],
            ),
          ),
          // Post Image
          Container(
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[300],
                    child:
                        const Icon(Icons.image, size: 50, color: Colors.grey),
                  );
                },
              ),
            ),
          ),
          // Interaction Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Icon(Icons.favorite_border, color: Colors.grey[600], size: 22),
                const SizedBox(width: 20),
                Icon(Icons.mode_comment_outlined,
                    color: Colors.grey[600], size: 22),
                const SizedBox(width: 20),
                Icon(Icons.share_outlined, color: Colors.grey[600], size: 22),
                const Spacer(),
                Icon(Icons.bookmark_border, color: Colors.grey[600], size: 22),
              ],
            ),
          ),
          // Engagement Info
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  likes,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
                Text(
                  comments,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      _buildHomeFeed(),
      const CameraPage(),
      const ProfilePage(
          isOwnProfile: true), // Specify that this is the user's own profile
    ];

    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFFFF4E6),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 3,
            ),
          ],
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _currentIndex == 0 ? Colors.green : Colors.transparent,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.home,
                  color: _currentIndex == 0 ? Colors.white : Colors.grey,
                ),
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.camera_alt,
                  color: _currentIndex == 1 ? Colors.green : Colors.grey),
              label: 'Camera',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person,
                  color: _currentIndex == 2 ? Colors.green : Colors.grey),
              label: 'Profile',
            ),
          ],
          currentIndex: _currentIndex,
          selectedItemColor: Colors.green,
          unselectedItemColor: Colors.grey,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
