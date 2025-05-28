import 'package:flutter/material.dart';
import 'package:untitled12/features/user_auth/presentation/pages/home_page.dart';

class PaymentScreen extends StatefulWidget {
  final Map<String, dynamic> gigData;
  final Map<String, dynamic> package;
  final double totalAmount;

  const PaymentScreen({
    Key? key,
    required this.gigData,
    required this.package,
    required this.totalAmount,
  }) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String selectedPayment = 'Credit or Debit';
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
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
                    'Payment Method',
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
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Progress indicator moved up here
                Container(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: _buildProgressIndicator(),
                ),
                _buildTopProfileCard(),
                const SizedBox(height: 20),
                _buildOrderSummaryCard(),
                const SizedBox(height: 20),
                _buildPaymentOptionsCard(),
                const SizedBox(height: 20),
                _buildWarningText(),
                const SizedBox(height: 20),
                _buildConfirmButton(context),
              ],
            ),
          ),
          if (_isProcessing)
            Container(
              color: Colors.black54,
              child: const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF00B31E)),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTopProfileCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 6,
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 98, 238, 121),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
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
                          widget.gigData['sellerImage'] ?? 'assets/kasun.jpg',
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
                                widget.gigData['sellerName'] ?? 'Seller',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Color.fromARGB(255, 7, 7, 7),
                                ),
                              ),
                              const SizedBox(width: 5),
                              const Icon(Icons.verified, size: 18),
                            ],
                          ),
                          const SizedBox(height: 1),
                          Text(
                            widget.gigData['sellerTitle'] ?? 'Service Provider',
                            style: const TextStyle(
                              color: Color.fromARGB(179, 9, 9, 9),
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.gigData['category'] ?? 'Service',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: Color.fromARGB(255, 11, 10, 10),
                    ),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    widget.gigData['description'] ?? 'No description available',
                    style: const TextStyle(fontSize: 12, height: 1.4),
                    maxLines: 5,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildStep(true),
        _buildLine(),
        _buildStep(true),
        _buildLine(),
        _buildStep(false),
      ],
    );
  }
