import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:untitled12/features/user_auth/presentation/pages/seller_chat.dart';
import 'seller_home.dart';
import 'profile_seller.dart';
import 'package:untitled12/features/user_auth/presentation/pages/create_gig.dart';

class SellerManagePage extends StatefulWidget {
  const SellerManagePage({super.key});

  @override
  State<SellerManagePage> createState() => _SellerManagePageState();
}

class _SellerManagePageState extends State<SellerManagePage> {
  int _selectedIndex = 3;
  List<Map<String, dynamic>> gigs = [];

  @override
  void initState() {
    super.initState();
    _fetchGigs();
  }

  Future<void> _fetchGigs() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('gigs')
            .where('sellerId', isEqualTo: user.uid)
            .get();

        setState(() {
          gigs = querySnapshot.docs.map((doc) {
            Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
            data['id'] = doc.id; // Store document ID for future reference
            return data;
          }).toList();
        });
      }
    } catch (e) {
      print("Error fetching gigs: $e");
    }
  }

  Future<void> _deleteGig(String gigId) async {
    try {
      await FirebaseFirestore.instance.collection('gigs').doc(gigId).delete();
      _fetchGigs(); // Refresh the list after deletion
    } catch (e) {
      print("Error deleting gig: $e");
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SellerHomePage()),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SellerChatScreen()),
        );
        break;
      case 3:
      // Already on this page
        break;
      case 4:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ProfileSellerPage()),
        );
        break;
    }
  }

  Widget _buildIconWithSpacing(IconData iconData, int index) {
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            iconData,
            color: _selectedIndex == index ? Colors.green : Colors.grey,
            size: 30,
          ),
          const SizedBox(height: 5),
          Container(
            height: 6,
            width: 6,
            decoration: BoxDecoration(
              color: _selectedIndex == index ? Colors.green : Colors.transparent,
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
    );
  }

  // Helper function to get the appropriate image based on category
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
        return 'assets/gig1.png'; // Default image
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(221, 13, 216, 23),
        elevation: 2,
        shadowColor: Colors.black,
        titleSpacing: 0,
        title: const Text(
          'Manage Gigs',
          style: TextStyle(color: Colors.white),
        ),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            'assets/Short White.png',
            width: 40,
            height: 40,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                children: [
                  const Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Active Gigs",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Display gigs from Firestore
                  if (gigs.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        "You don't have any gigs yet.",
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  else
                    Column(
                      children: gigs.map((gig) => _buildGigCard(gig)).toList(),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Material(
                elevation: 2,
                borderRadius: BorderRadius.circular(12),
                shadowColor: Colors.black,
                child: Container(
                  height: 129,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 155, 242, 166),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const CreateGigScreen()),
                            ).then((_) => _fetchGigs()); // Refresh gigs after returning
                          },
                          icon: const Icon(Icons.add),
                          iconSize: 30,
                          color: const Color.fromARGB(255, 54, 28, 8),
                        ),
                        const Text(
                          "Create new Gig",
                          style: TextStyle(
                              fontSize: 8,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 3, 3, 3),
                              fontFamily: "Outfit"),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
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
              _buildIconWithSpacing(Icons.home, 0),
              _buildIconWithSpacing(Icons.chat, 1),
              _buildIconWithSpacing(Icons.shopping_bag, 3),
              _buildIconWithSpacing(Icons.person, 4),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGigCard(Map<String, dynamic> gig) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Material(
        elevation: 2,
        borderRadius: BorderRadius.circular(12),
        shadowColor: Colors.black,
        child: Container(
          height: 129,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: gig['imageUrl'] != null
                      ? Image.network(
                    gig['imageUrl'],
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  )
                      : Image.asset(
                    _getCategoryImage(gig['category'] ?? ''),
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            gig['title'] ?? 'Untitled Gig',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              fontFamily: "outfit",
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const Spacer(),
                          IconButton(
                            onPressed: () => _deleteGig(gig['id']),
                            icon: const Icon(Icons.delete),
                            color: Colors.red,
                            iconSize: 15,
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Container(
                            width: 160,
                            height: 25,
                            decoration: const BoxDecoration(color: Colors.white),
                            child: Text(
                              gig['description'] ?? 'No description',
                              style: const TextStyle(
                                fontFamily: "Outfit",
                                fontSize: 8,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: 15,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                gig['rating']?.toStringAsFixed(1) ?? '0.0',
                                style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 3, 3, 3),
                                    fontFamily: "Outfit"),
                              ),
                              Text(
                                "(${gig['reviewCount'] ?? '0'})",
                                style: const TextStyle(
                                    fontSize: 7,
                                    color: Color.fromARGB(255, 3, 3, 3),
                                    fontFamily: "Outfit"),
                              ),
                            ],
                          ),
                          const Spacer(),
                          const Text(
                            "From",
                            style: TextStyle(
                                fontSize: 7,
                                color: Color.fromARGB(255, 3, 3, 3),
                                fontFamily: "Outfit"),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "\$${gig['price']?.toStringAsFixed(2) ?? '0.00'}",
                            style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 3, 3, 3),
                                fontFamily: "Outfit"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
