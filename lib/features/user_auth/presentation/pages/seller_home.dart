import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:untitled12/features/user_auth/presentation/pages/seller_chat.dart';
import 'seller_manage.dart';
import 'profile_seller.dart';

class SellerHomePage extends StatefulWidget {
  const SellerHomePage({super.key});

  @override
  State<SellerHomePage> createState() => _SellerHomePageState();
}

class _SellerHomePageState extends State<SellerHomePage> {
  int _selectedIndex = 0;
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
      // Already on home page
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SellerChatScreen()),
        );
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
          'Seller Dashboard',
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

        padding:
        const EdgeInsets.all(16),

        child: Column(

          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Stats Cards
            const SizedBox(height: 12),
            Row(
              children: [
                _buildStatCard('Total Gigs', gigs.length.toString(), Icons.work),
                const SizedBox(width: 12),
                _buildStatCard('Orders', '24', Icons.shopping_cart),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildStatCard('Earnings', '\$1,240', Icons.attach_money),
                const SizedBox(width: 12),
                _buildStatCard('Rating', '4.9 ★', Icons.star),
              ],
            ),





            const SizedBox(height: 24),




          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: 70,

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

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFBEECB8),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.green),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }


}
