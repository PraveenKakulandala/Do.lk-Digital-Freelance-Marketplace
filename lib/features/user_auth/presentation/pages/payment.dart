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

   Widget _buildStep(bool isActive) {
    return CircleAvatar(
      radius: 10,
      backgroundColor: isActive
          ? const Color(0xFF00B31E)
          : const Color.fromARGB(255, 186, 237, 175),
    );
  }

  Widget _buildLine() {
    return Container(
      width: 70,
      height: 2,
      color: const Color.fromARGB(255, 16, 234, 20),
    );
  }

  Widget _buildOrderSummaryCard() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Colors.black, width: 1.8),
      ),
      elevation: 2,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: const BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: const Center(
              child: Text(
                'Order Summary',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Package:'),
                    Text(
                      widget.package['title'],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Subtotal:'),
                    Text('\$${widget.package['price'].toStringAsFixed(2)}'),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text('Service Fee:'),
                    Text('\$10.00'),
                  ],
                ),
                const Divider(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      '\$${widget.totalAmount.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Color(0xFF00B31E),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildPaymentOptionsCard() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Colors.black, width: 1.8),
      ),
      elevation: 2,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: const BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: const Center(
              child: Text(
                'Add Payment Method',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          _buildRadioTile('Credit or Debit', 'assets/contactless.png'),
          _buildRadioTile('Paypal', 'assets/paypal.png'),
          _buildRadioTile('Google', 'assets/google.png'),
          _buildRadioTile('Crypto', 'assets/cryptocurrency.png'),
        ],
      ),
    );
  }

  Widget _buildRadioTile(String value, String imageAsset) {
    return RadioListTile<String>(
      value: value,
      groupValue: selectedPayment,
      onChanged: (val) => setState(() => selectedPayment = val!),
      title: Row(
        children: [
          Image.asset(
            imageAsset,
            width: 30,
            height: 30,
          ),
          const SizedBox(width: 8),
          Text(value),
        ],
      ),
      activeColor: const Color(0xFF00B31E),
    );
  }

  Widget _buildWarningText() {
    return const Text(
      'Please review your selected payment method before proceeding. Ensure all details are correct to avoid any delays. Once confirmed, the payment will be processed securely.',
      style: TextStyle(fontSize: 13, color: Colors.black87, height: 1.5),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildConfirmButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          _showFakePaymentGateway(context);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF00B31E),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: const Text(
          'Order',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  void _showFakePaymentGateway(BuildContext context) {
    if (selectedPayment == 'Credit or Debit') {
      _showCreditCardEntry(context);
    } else {
      _showAlternativePaymentMethod(context);
    }
  }

  void _showCreditCardEntry(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Enter Card Details',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const Divider(),
            const SizedBox(height: 20),
            _buildCreditCardWidget(),
            const SizedBox(height: 30),
            _buildCardForm(),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _processPayment(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00B31E),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'PAY \$${widget.totalAmount.toStringAsFixed(2)}',
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
      ),
    );
  }
