import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:untitled12/features/user_auth/presentation/pages/seller_manage.dart';
import 'seller_home.dart';
import 'profile_seller.dart';

class SellerChatScreen extends StatefulWidget {
  const SellerChatScreen({super.key});

  @override
  State<SellerChatScreen> createState() => _SellerChatScreenState();
}

class _SellerChatScreenState extends State<SellerChatScreen> {
  int _selectedIndex = 1;
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
          gigs = querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
        });
      }
    } catch (e) {
      print("Error fetching gigs: $e");
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

        break;
      case 3:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SellerManagePage()),
        );
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
      body: Column(
        children: [

          // Profile Card - Left Aligned
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Circular image with black border
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.black,
                          width: 2,
                        ),
                      ),
                      child: const CircleAvatar(
                        radius: 30,
                        backgroundImage: AssetImage('assets/seller1.png'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Name and position
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Text(
                                'Kasun',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Outfit',
                                ),
                              ),
                              const SizedBox(width: 4),
                              Icon(
                                Icons.verified,
                                color: Colors.black,
                                size: 18,
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Logo Designer',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color.fromARGB(255, 0, 0, 0),
                              fontFamily: 'Outfit',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Rest of your chat content
        ],
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

}