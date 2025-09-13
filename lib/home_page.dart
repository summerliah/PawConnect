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
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    print("HomePage initState called - Loading started"); 
    // Give more time for everything to load properly
    Future.delayed(Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        print("Loading complete - Interactions now enabled");
      }
    });
  }

  void _onItemTapped(int index) {
    print('=== NAVIGATION DEBUG ===');
    print('Bottom navigation tapped: $index');
    print('Current index: $_currentIndex');
    print('Is loading: $_isLoading');
    print('Widget mounted: $mounted');
    print('========================');
    
    // Only allow navigation if not loading and widget is mounted
    if (!_isLoading && mounted) {
      setState(() {
        _currentIndex = index;
      });
      print('Navigation successful to index: $index');
    } else {
      print('Navigation blocked - Loading: $_isLoading, Mounted: $mounted');
    }
  }

  Widget _buildHomeFeed() {
    return SafeArea(
      child: Column(
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
                // PAW CONNECT Logo
                const Row(
                  children: [
                    Text(
                      "PAW",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFFFAA00),
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(Icons.pets, size: 24, color: Colors.teal),
                    SizedBox(width: 4),
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
                        onPressed: () {
                          print('=== SEARCH BUTTON DEBUG ===');
                          print('Is loading: $_isLoading');
                          print('Mounted: $mounted');
                          print('Current index: $_currentIndex');
                          print('========================');
                          
                          if (!_isLoading) {
                            // TODO: Implement search functionality
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Search coming soon!')),
                            );
                          } else {
                            print('Search blocked - still loading');
                          }
                        },
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
                        onPressed: () {
                          print('=== ADD BUTTON DEBUG ===');
                          print('Is loading: $_isLoading');
                          print('Mounted: $mounted');
                          print('Current index: $_currentIndex');
                          print('======================');
                          
                          if (!_isLoading) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => PostPage()),
                            );
                          } else {
                            print('Add button blocked - still loading');
                          }
                        },
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
                  child: GestureDetector(
                    onTap: () {
                      print('Post creation area tapped'); // Debug output
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PostPage()),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Text(
                        "Post your Pets Activities",
                        style: TextStyle(color: Colors.grey[600]),
                      ),
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
                    onPressed: () {
                      print('Camera button pressed'); // Debug output
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CameraPage()),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // Feed Posts
          Expanded(
            child: _isLoading
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          color: Color(0xFFFFA500),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Loading your pet feed...',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: [
                      _buildPost(
                        username: "Dog",
                        location: "Bacoor Cavite",
                        time: "1 h",
                        isFollowing: true,
                        imageUrl: "assets/dog.png", // Use local asset instead
                        likes: "Liked by Cat and 155 others",
                        comments: "4 comments",
                      ),
                      const SizedBox(height: 16),
                      _buildPost(
                        username: "Cat",
                        location: "Dasma Cavite",
                        time: "1 h",
                        isFollowing: true,
                        imageUrl: "assets/cat.png", // Use local asset instead
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
    // Add null safety checks and debug info
    print('Building post for: $username');
    print('ImageUrl: $imageUrl');
    print('Location: $location');
    print('Time: $time');
    
    // Provide fallback values for any potential null values
    final safeUsername = username.isEmpty ? 'Unknown User' : username;
    final safeLocation = location.isEmpty ? 'Unknown Location' : location;
    final safeTime = time.isEmpty ? 'Unknown Time' : time;
    final safeImageUrl = imageUrl.isEmpty ? 'assets/cat.png' : imageUrl;
    final safeLikes = likes.isEmpty ? 'No likes yet' : likes;
    final safeComments = comments.isEmpty ? 'No comments' : comments;
    
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
                Expanded(
                  child: GestureDetector(
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
                              color: safeUsername == "Dog"
                                  ? Colors.orange[300]!
                                  : Colors.grey[300]!,
                              width: 2,
                            ),
                          ),
                          child: Icon(
                            Icons.pets,
                            color: safeUsername == "Dog"
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
                                safeUsername,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                "$safeTime $safeLocation",
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
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Following user...')),
                            );
                          },
                          borderRadius: BorderRadius.circular(20),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 6),
                            child: const Text(
                              "Follow",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
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
              child: safeImageUrl.startsWith('assets/')
                  ? Image.asset(
                      safeImageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[300],
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.pets, size: 50, color: Colors.grey),
                              const SizedBox(height: 8),
                              Text(
                                'Pet photo',
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                            ],
                          ),
                        );
                      },
                    )
                  : Image.network(
                      safeImageUrl,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          color: Colors.grey[200],
                          child: Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                              color: Color(0xFFFFA500),
                            ),
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[300],
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.pets, size: 50, color: Colors.grey),
                              const SizedBox(height: 8),
                              Text(
                                'Pet photo',
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                            ],
                          ),
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
                Material(
                  color: Colors.transparent,
                  child: IconButton(
                    icon: Icon(Icons.favorite_border,
                        color: Colors.grey[600], size: 22),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Liked!')),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Material(
                  color: Colors.transparent,
                  child: IconButton(
                    icon: Icon(Icons.mode_comment_outlined,
                        color: Colors.grey[600], size: 22),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Comments coming soon!')),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Material(
                  color: Colors.transparent,
                  child: IconButton(
                    icon: Icon(Icons.share_outlined,
                        color: Colors.grey[600], size: 22),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Share coming soon!')),
                      );
                    },
                  ),
                ),
                const Spacer(),
                Material(
                  color: Colors.transparent,
                  child: IconButton(
                    icon: Icon(Icons.bookmark_border,
                        color: Colors.grey[600], size: 22),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Saved to bookmarks!')),
                      );
                    },
                  ),
                ),
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
                  safeLikes,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
                Text(
                  safeComments,
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
    print('=== BUILD CALLED ===');
    print('Current index: $_currentIndex');
    print('Is loading: $_isLoading');
    print('==================');
    
    return Scaffold(
      backgroundColor: const Color(0xFFFFF4E6),
      body: IgnorePointer(
        ignoring: _isLoading,
        child: IndexedStack(
          index: _currentIndex,
          children: [
            _buildHomeFeed(),
            const CameraPage(),
            ProfilePage(
              isOwnProfile: true,
              onBackPressed: () {
                // Switch back to home tab when back button is pressed
                _onItemTapped(0);
              },
            ),
          ],
        ),
      ),
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
        child: IgnorePointer(
          ignoring: _isLoading,
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
      ),
    );
  }
}
