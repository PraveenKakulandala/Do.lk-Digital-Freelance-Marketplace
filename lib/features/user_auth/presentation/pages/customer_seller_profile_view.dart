import 'package:flutter/material.dart';
import 'rating.dart'; // Make sure this file exists and is imported correctly

class CustomerSellerProfileView extends StatelessWidget {
  final Map<String, dynamic> sellerData;

  const CustomerSellerProfileView({super.key, required this.sellerData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(221, 255, 255, 255),
        elevation: 2,
        shadowColor: Colors.black,
        titleSpacing: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset('assets/Short Green.png', width: 40, height: 40),
        ),
        title: const Text(''),
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: 180,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/bg.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: 50,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(
                      sellerData['image'] ?? 'assets/profile_placeholder.png',
                    ),
                    onBackgroundImageError: (exception, stackTrace) =>
                    const Icon(Icons.person, size: 50, color: Colors.grey),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Contact',
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Hi, I'm ${sellerData['name'] ?? 'Seller'}!",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
              child: Text(
                sellerData['bio'] ?? "I'm a professional service provider...",
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),
            _infoCard(sellerData),
            const SizedBox(height: 20),
            _ratingCard(context, sellerData),
            const SizedBox(height: 90), // for spacing above bottom nav
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(23.0),
        child: Container(
          height: 50,
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
              _buildIconWithSpacing(Icons.home, 0, false),
              _buildIconWithSpacing(Icons.chat, 1, false),
              _buildIconWithSpacing(Icons.search, 2, false),
              _buildIconWithSpacing(Icons.shopping_bag, 3, false),
              _buildIconWithSpacing(Icons.person, 4, true),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIconWithSpacing(IconData iconData, int index, bool isSelected) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          iconData,
          color: isSelected ? Colors.green : Colors.grey,
          size: 30,
        ),
        const SizedBox(height: 5),
        Container(
          height: 0,
          width: 0,
          decoration: BoxDecoration(
            color: isSelected ? Colors.green : Colors.transparent,
            shape: BoxShape.circle,
          ),
        ),
      ],
    );
  }

  Widget _infoCard(Map<String, dynamic> sellerData) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          const Text(
            'Seller Information',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          _InfoRow(label: 'Username', value: sellerData['name'] ?? 'Seller'),
          _InfoRow(
              label: 'Status',
              value: sellerData['isVerified'] == true
                  ? 'Verified'
                  : 'Not Verified'),
          _InfoRow(
              label: 'From', value: sellerData['location'] ?? 'Not specified'),
          _InfoRow(
              label: 'Language',
              value: sellerData['languages']?.join(', ') ?? 'English'),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              // Handle view certificates
            },
            style: const ButtonStyle(
              backgroundColor: MaterialStatePropertyAll(Colors.green),
            ),
            child: const Text('View Certificates'),
          ),
        ],
      ),
    );
  }

  Widget _ratingCard(BuildContext context, Map<String, dynamic> sellerData) {
    final rating = sellerData['rating'] ?? 4.9;
    final communicationRating = sellerData['communicationRating'] ?? rating;
    final qualityRating = sellerData['qualityRating'] ?? rating;
    final valueRating = sellerData['valueRating'] ?? rating;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          const Text(
            'Rating',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          _RatingRow(label: 'Overall rating', rating: rating),
          _RatingRow(
              label: 'Seller communication level', rating: communicationRating),
          _RatingRow(label: 'Quality of deliver', rating: qualityRating),
          _RatingRow(label: 'Value of delivery', rating: valueRating),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      RatingScreen(sellerData: sellerData),
                ),
              );
            },
            style: const ButtonStyle(
              backgroundColor: MaterialStatePropertyAll(Colors.green),
            ),
            child: const Text('Review'),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(value),
        ],
      ),
    );
  }
}

class _RatingRow extends StatelessWidget {
  final String label;
  final double rating;

  const _RatingRow({required this.label, required this.rating});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Row(
            children: List.generate(
              5,
                  (index) => Icon(
                Icons.star,
                size: 18,
                color:
                index < rating.round() ? Colors.green : Colors.grey.shade300,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
