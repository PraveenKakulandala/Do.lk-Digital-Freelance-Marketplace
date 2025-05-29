import 'package:flutter/material.dart';
import 'payment.dart'; // Import the payment screen

class Order extends StatelessWidget {
  final Map<String, dynamic> gigData;

  const Order({super.key, required this.gigData});

  // Helper function to get image based on category
  String _getCategoryImage(String category) {
    switch (category.toLowerCase()) {
      case 'logo design':
        return 'assets/gig1.png';
      case 'ai artist':
        return 'assets/gig2.png';
      case 'writing':
        return 'assets/gig3.png';
      case 'web development':
        return 'assets/gig4.png';
      case 'video editing':
        return 'assets/gig5.png';
      default:
        return 'assets/gig1.png'; // Default image
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryGreen = const Color(0xFF00B31E);
    int _selectedPriceIndex = 1; // Default to middle package

    final List<Map<String, dynamic>> packages = [
      {
        'title': 'Basic Package',
        'price': gigData['basicPrice'] ?? 15,
        'description': gigData['basicDescription'] ?? 'Basic Service',
        'details': gigData['basicDetails'] ?? [
          'Basic features',
          'Delivery: 3 Days',
          'Limited revisions',
          'Standard formats',
        ],
      },
      {
        'title': 'Standard Package',
        'price': gigData['standardPrice'] ?? 25,
        'description': gigData['standardDescription'] ?? 'Standard Service',
        'details': gigData['standardDetails'] ?? [
          'Enhanced features',
          'Delivery: 4 Days',
          'Multiple revisions',
          'Additional formats',
        ],
      },
      {
        'title': 'Premium Package',
        'price': gigData['premiumPrice'] ?? 45,
        'description': gigData['premiumDescription'] ?? 'Premium Service',
        'details': gigData['premiumDetails'] ?? [
          'All features included',
          'Priority delivery',
          'Unlimited revisions',
          'All file formats',
          'Extra services',
        ],
      },
    ];
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(120),
        child: Column(
          children: [
            AppBar(
              backgroundColor: const Color.fromARGB(221, 255, 255, 255),
              elevation: 2,
              shadowColor: Colors.black,
              titleSpacing: 0,
              leading: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  'assets/Short Green.png',
                  width: 40,
                  height: 40,
                ),
              ),
            ),
            Container(
              color: primaryGreen,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 1),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Text(
                    gigData['category'] ?? 'Service Details',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 48), // For balance
                ],
              ),
            ),
          ],
        ),
      ),

