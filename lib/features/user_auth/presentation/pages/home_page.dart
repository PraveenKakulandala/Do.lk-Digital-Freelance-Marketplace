import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:untitled12/features/user_auth/presentation/pages/chat_screen.dart';
import 'package:untitled12/features/user_auth/presentation/pages/profile_screen.dart';
import 'package:untitled12/features/user_auth/presentation/pages/gig-view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(HomePage());
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "do.lk App",
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
      routes: {
        '/chat': (context) => const ChatScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/gig-view': (context) {
          final gigData = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
          return GigViewScreen(gigData: gigData);
        },
      },
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isFavorited = false;
  int _selectedIndex = 0;
  String? _selectedCategory;
  bool _showCategoryView = false;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        if (_showCategoryView) {
          setState(() {
            _showCategoryView = false;
            _selectedCategory = null;
          });
        }
        break;
      case 1:
        Navigator.pushNamed(context, '/chat');
        break;
      case 2:
        Navigator.pushNamed(context, '/search');
        break;
      case 3:
        Navigator.pushNamed(context, '/orders');
        break;
      case 4:
        Navigator.pushNamed(context, '/profile');
        break;
    }
  }

  String _getCategoryImage(String category) {
    switch (category.toLowerCase()) {
      case 'logo design':
        return 'assets/gig2.png';
      case 'ai artist':
        return 'assets/gig3.png';
      case 'writing':
        return 'assets/gig4.png';
      case 'web development':
        return 'assets/gig5.png';
      case 'video editing':
        return 'assets/gig1.png';
      default:
        return 'assets/gig1.png';
    }
  }

  Widget _buildCategoryView() {
    return Column(
      children: [
        AppBar(
          backgroundColor: const Color.fromARGB(221, 13, 216, 23),
          elevation: 2,
          shadowColor: Colors.black,
          titleSpacing: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              setState(() {
                _showCategoryView = false;
                _selectedCategory = null;
              });
            },
          ),
          title: Text(
            _selectedCategory ?? 'Category',
            style: const TextStyle(color: Colors.white),
          ),
        ),
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('gigs')
                .where('category', isEqualTo: _selectedCategory)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Center(child: Text('Something went wrong'));
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(child: Text('No gigs in this category'));
              }

              return ListView(
                children: snapshot.data!.docs.map((doc) {
                  Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
                  return _buildGigCard(data);
                }).toList(),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMainView() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/search');
              },
              child: Material(
                elevation: 1,
                borderRadius: BorderRadius.circular(30),
                shadowColor: Colors.black,
                child: AbsorbPointer(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search...',
                      hintStyle: const TextStyle(
                        fontSize: 12,
                        fontFamily: 'Outfit',
                      ),
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                      contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Categories',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                fontFamily: 'Outfit',
              ),
            ),
          ),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedCategory = 'Logo Design';
                      _showCategoryView = true;
                    });
                  },
                  child: buildCard('assets/c1.png', 'Logo Design'),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedCategory = 'AI Artists';
                      _showCategoryView = true;
                    });
                  },
                  child: buildCard('assets/c2.png', 'AI Artists'),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedCategory = 'Video Editing';
                      _showCategoryView = true;
                    });
                  },
                  child: buildCard('assets/c3.png', 'Video Editing'),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedCategory = 'Web Development';
                      _showCategoryView = true;
                    });
                  },
                  child: buildCard('assets/c4.png', 'Web Development'),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedCategory = 'Writing';
                      _showCategoryView = true;
                    });
                  },
                  child: buildCard('assets/c5.png', 'Writing'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Recommended Services',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                fontFamily: 'Outfit',
              ),
            ),
          ),
          const SizedBox(height: 15),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('gigs').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Center(child: Text('Something went wrong'));
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text('No gigs available'),
                );
              }

              return Column(
                children: snapshot.data!.docs.map((doc) {
                  Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
                  return _buildGigCard(data);
                }).toList(),
              );
            },
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildGigCard(Map<String, dynamic> gigData) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/gig-view',
          arguments: gigData,
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Material(
          elevation: 5,
          borderRadius: BorderRadius.circular(12),
          shadowColor: Colors.black.withOpacity(0.3),
          child: Container(
            height: 120,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: gigData['imageUrl'] != null
                        ? Image.network(
                      gigData['imageUrl'],
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          Image.asset(_getCategoryImage(gigData['category'] ?? ''),
                              width: 100, height: 100),
                    )
                        : Image.asset(
                      _getCategoryImage(gigData['category'] ?? ''),
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          gigData['sellerName'] ?? 'Seller',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Outfit',
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          gigData['title'] ?? 'Service Title',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                            fontFamily: 'Outfit',
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                  size: 16,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  gigData['rating']?.toStringAsFixed(1) ?? '0.0',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[700],
                                    fontFamily: 'Outfit',
                                  ),
                                ),
                              ],
                            ),
                            RichText(
                              text: TextSpan(
                                style: TextStyle(
                                  fontSize: 12,
                                  color: const Color.fromARGB(255, 0, 0, 0),
                                  fontFamily: 'Outfit',
                                ),
                                children: [
                                  const TextSpan(text: 'From '),
                                  TextSpan(
                                    text: '\$${gigData['price']?.toStringAsFixed(2) ?? '0.00'}',
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavBarItem(IconData icon, int index) {
    return IconButton(
      icon: Icon(
        icon,
        color: _selectedIndex == index ? Colors.green : Colors.grey,
        size: 30,
      ),
      onPressed: () {
        _onItemTapped(index);
      },
    );
  }

  Widget buildCard(String imagePath, String title) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Card(
          color: const Color.fromARGB(230, 243, 243, 243),
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            width: 150,
            height: 150,
            padding: const EdgeInsets.all(8),
            child: Center(
              child: Image.asset(
                imagePath,
                width: 80,
                height: 80,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: const TextStyle(
            fontFamily: 'Outfit',
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _showCategoryView ? null : AppBar(
        backgroundColor: const Color.fromARGB(221, 13, 216, 23),
        elevation: 2,
        shadowColor: Colors.black,
        titleSpacing: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            'assets/Short White.png',
            width: 40,
            height: 40,
          ),
        ),
        title: const Text(''),
      ),
      body: _showCategoryView ? _buildCategoryView() : _buildMainView(),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: 70,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(40),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavBarItem(Icons.home, 0),
              _buildNavBarItem(Icons.chat, 1),
              _buildNavBarItem(Icons.search, 2),
              _buildNavBarItem(Icons.shopping_bag, 3),
              _buildNavBarItem(Icons.person, 4),
            ],
          ),
        ),
      ),
    );
  }
}
