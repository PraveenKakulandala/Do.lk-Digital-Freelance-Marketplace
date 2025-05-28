import 'package:flutter/material.dart';
import 'order.dart'; // Make sure you have this import
import 'customer_seller_profile_view.dart'; // Import the seller profile view

class GigViewScreen extends StatelessWidget {
  final Map<String, dynamic> gigData;

  const GigViewScreen({super.key, required this.gigData});

  // Helper function to get image based on category
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
    final Color primaryGreen = const Color(0xFF26C000);
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
              color: const Color(0xFF00B31E),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 1),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Text(
                    'Order Details',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),
          ],
        ),
      ),
      body: StatefulBuilder(
        builder: (context, setState) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Gig Image - Category Specific
                Image.asset(
                  _getCategoryImage(gigData['category'] ?? 'Logo Design'),
                  width: double.infinity,
                  height: 250,
                  fit: BoxFit.cover,
                ),

                // Seller Profile - Now clickable
                ListTile(
                  leading: GestureDetector(
                    onTap: () {
                      // Navigate to seller profile view
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CustomerSellerProfileView(
                            sellerData: {
                              'name': gigData['sellerName'] ?? 'Seller',
                              'title': gigData['sellerTitle'] ?? 'Service Provider',
                              'image': gigData['sellerImage'] ?? 'assets/profile_placeholder.png',
                              'rating': gigData['rating'] ?? 5.0,
                              // Add more seller details as needed
                            },
                          ),
                        ),
                      );
                    },
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(
                        gigData['sellerImage'] ?? 'assets/profile_placeholder.png',
                      ),
                      onBackgroundImageError: (exception, stackTrace) =>
                      const Icon(Icons.person, color: Colors.grey),
                    ),
                  ),
                  title: Row(
                    children: [
                      Text(gigData['sellerName'] ?? 'Seller'),
                      const SizedBox(width: 4),
                      const Icon(Icons.verified, color: Colors.blue, size: 16),
                    ],
                  ),
                  subtitle: Text(gigData['sellerTitle'] ?? 'Service Provider'),
                ),

                // Description
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Text(
                    gigData['description'] ?? 'No description available',
                    style: const TextStyle(fontSize: 14),
                  ),
                ),

                // Rating and Price
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 20),
                      Text(' ${gigData['rating']?.toStringAsFixed(1) ?? '5.0'}'),
                      const SizedBox(width: 16),
                      const Icon(Icons.attach_money, color: Colors.green, size: 20),
                      Text(' From \$${packages[0]['price'].toStringAsFixed(2)}'),
                    ],
                  ),
                ),

                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Divider(height: 1),
                ),

                // Price Packages
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Select Package',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),

                // Price Buttons
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12),
                  child: Row(
                    children: List.generate(packages.length, (i) {
                      return Expanded(
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _selectedPriceIndex == i
                                  ? primaryGreen
                                  : Colors.grey[300],
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            onPressed: () {
                              setState(() => _selectedPriceIndex = i);
                            },
                            child: Text(
                              '\$${packages[i]['price'].toStringAsFixed(0)}',
                              style: TextStyle(
                                color: _selectedPriceIndex == i
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),

                // Package Details
                Container(
                  margin: const EdgeInsets.all(12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: primaryGreen.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${packages[_selectedPriceIndex]['title']} - \$${packages[_selectedPriceIndex]['price'].toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(packages[_selectedPriceIndex]['description']),
                      const SizedBox(height: 10),
                      ...List.generate(
                        packages[_selectedPriceIndex]['details'].length,
                            (i) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.check_circle_outline,
                                color: Colors.green,
                                size: 18,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  packages[_selectedPriceIndex]['details'][i],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Chat with Seller Button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: primaryGreen),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        // TODO: Implement chat functionality
                        // You'll need to navigate to a chat screen with the seller
                        // Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen(sellerId: gigData['sellerId'])));
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.chat, color: primaryGreen),
                          const SizedBox(width: 8),
                          Text(
                            'Chat with Seller',
                            style: TextStyle(
                              color: primaryGreen,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Order Button with dynamic price
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryGreen,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        // Navigate to OrderPage with selected package and gig data
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OrderScreen(
                              gigData: gigData,
                              selectedPackage: packages[_selectedPriceIndex],
                            ),
                          ),
                        );
                      },
                      child: Text(
                        'Continue (\$${packages[_selectedPriceIndex]['price'].toStringAsFixed(2)})',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),
              ],
            ),
          );
        },
      ),
    );
  }
}
