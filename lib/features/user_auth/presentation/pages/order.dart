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
       body: StatefulBuilder(
        builder: (context, setState) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Gig Image Card with Profile
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  elevation: 6,
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 98, 238, 121),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        Container(
                          width: 160,
                          height: 140,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            image: DecorationImage(
                              image: AssetImage(
                                  _getCategoryImage(gigData['category'] ?? '')),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 30,
                                    backgroundImage: NetworkImage(
                                      gigData['sellerImage'] ??
                                          'assets/profile_placeholder.png',
                                    ),
                                    onBackgroundImageError: (, _) =>
                                    const Icon(Icons.person),
                                  ),
                                  const SizedBox(width: 12),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            gigData['sellerName'] ?? 'Seller',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                          const SizedBox(width: 5),
                                          const Icon(
                                            Icons.verified,
                                            size: 18,
                                            color: Colors.blue,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 1),
                                      Text(
                                        gigData['sellerTitle'] ??
                                            'Service Provider',
                                        style: const TextStyle(
                                          color: Colors.black87,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Text(
                                gigData['category'] ?? 'Service',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(height: 1),
                              Text(
                                gigData['description'] ??
                                    'No description available',
                                style: const TextStyle(
                                  color: Colors.black87,
                                  fontSize: 12,
                                  height: 1.4,
                                ),
                                maxLines: 5,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),
                  // Rating and Price
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 24),
                        const SizedBox(height: 4),
                        Text(
                          gigData['rating']?.toStringAsFixed(1) ?? '5.0',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        const Icon(Icons.attach_money,
                            color: Colors.green, size: 24),
                        const SizedBox(height: 4),
                        Text(
                          'From \$${packages[0]['price'].toStringAsFixed(2)}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        const Icon(Icons.timer, color: Colors.blue, size: 24),
                        const SizedBox(height: 4),
                        Text(
                          gigData['deliveryTime'] ?? '3 Days',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 20),
                const Divider(height: 1, thickness: 1),
                const SizedBox(height: 20),

                // Price Packages Section
                const Text(
                  'Select Package',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),

                // Price Buttons
                Row(
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
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
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
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),

                const SizedBox(height: 20),
                  // Package Details Card
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(
                      color: Colors.black,
                      width: 1.8,
                    ),
                  ),
                  elevation: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 16),
                        decoration: const BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12),
                          ),
                        ),
                        child: Text(
                          packages[_selectedPriceIndex]['title'],
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  packages[_selectedPriceIndex]['title'],
                                  style: TextStyle(
                                    color: primaryGreen,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                Text(
                                  '\$${packages[_selectedPriceIndex]['price'].toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            ...List.generate(
                              packages[_selectedPriceIndex]['details'].length,
                                  (i) => Padding(
                                padding: const EdgeInsets.symmetric(vertical: 4),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Icon(Icons.check_circle,
                                        size: 18, color: Colors.green),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        packages[_selectedPriceIndex]['details'][i],
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // Order Button with dynamic price
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
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
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryGreen,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Continue (\$${packages[_selectedPriceIndex]['price'].toStringAsFixed(2)})',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
class OrderScreen extends StatelessWidget {
  final Map<String, dynamic> gigData;
  final Map<String, dynamic> selectedPackage;

  const OrderScreen({
    super.key,
    required this.gigData,
    required this.selectedPackage,
  });

  @override
  Widget build(BuildContext context) {
    final double totalAmount = (selectedPackage['price'] + 10).toDouble();

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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Progress indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildStep(true),
                _buildLine(),
                _buildStep(false),
                _buildLine(),
                _buildStep(false),
              ],
            ),
            const SizedBox(height: 20),

            // Add the profile card here
            _buildTopProfileCard(),
            const SizedBox(height: 20),

            // Order details card
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: const BorderSide(
                  color: Colors.black,
                  width: 1.8,
                ),
              ),
              elevation: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 16),
                    decoration: const BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Order details',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              selectedPackage['title'],
                              style: TextStyle(
                                color: const Color(0xFF00B31E),
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              '\$${selectedPackage['price'].toStringAsFixed(2)}',
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ...selectedPackage['details'].map<Widget>((detail) =>
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(Icons.check_circle,
                                      size: 18, color: Colors.green),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      detail,
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ).toList(),
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 16),
                    color: Colors.black,
                    child: const Text(
                      'Order summary',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        _buildPriceRow('Subtotal',
                            '\$${selectedPackage['price'].toStringAsFixed(2)}'),
                        _buildPriceRow('Service Fee', '\$10'),
                        _buildPriceRowWithLine(
                          'Total',
                          '\$${(totalAmount).toStringAsFixed(2)}',
                          isTotal: true,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),


