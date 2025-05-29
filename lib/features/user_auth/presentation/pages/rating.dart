import 'package:flutter/material.dart';

class RatingScreen extends StatefulWidget {
  final Map<String, dynamic> sellerData;

  const RatingScreen({super.key, required this.sellerData});

  @override
  State<RatingScreen> createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  int _selectedRating = 0;
  final TextEditingController _reviewController = TextEditingController();
  final List<Map<String, dynamic>> _reviews = [
    {
      'rating': 4.9,
      'author': 'TechVisionCo',
      'comment': 'Super fast delivery and great communication. Kasun was patient with my revisions and delivered exactly what I needed.',
    },
    {
      'rating': 5.0,
      'author': 'DigitalDreams',
      'comment': 'Excellent service! The seller went above and beyond to meet my requirements. Highly recommended!',
    },
    {
      'rating': 4.5,
      'author': 'WebWizards',
      'comment': 'Good quality work with quick turnaround. Would definitely work with again.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            'assets/Short Green.png',
            fit: BoxFit.contain,
            height: 40,
            width: 40,
            alignment: Alignment.topLeft,
          ),
        ),
        elevation: 4,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 40,
              width: double.infinity,
              color: const Color.fromRGBO(23, 186, 1, 1.0),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  const Center(
                    child: Text(
                      'Leave a Review',
                      style: TextStyle(
                        fontSize: 15,
                        fontFamily: 'Outfit',
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Existing Reviews Section
                  const Text(
                    '3 Reviews',
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Outfit',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ..._reviews.map((review) => Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(183, 234, 176, 1.0),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          spreadRadius: 0,
                          blurRadius: 10,
                          offset: const Offset(0, 0),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            ...List.generate(5, (index) => Icon(
                              Icons.star,
                              color: index < review['rating'] ? Colors.green : Colors.grey,
                              size: 16,
                            )),
                            const SizedBox(width: 4),
                            Text(
                              review['rating'].toString(),
                              style: const TextStyle(
                                color: Colors.green,
                                fontFamily: 'Outfit',
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'By: ${review['author']}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Outfit',
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          review['comment'],
                          style: const TextStyle(
                            fontSize: 12,
                            height: 1.4,
                            fontFamily: 'Outfit',
                          ),
                        ),
                      ],
                    ),
                  )).toList(),

                  const SizedBox(height: 20),

                  // Your Review Section
                  Text(
                    "Review for ${widget.sellerData['name'] ?? 'Seller'}",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Outfit',
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Star Rating
                  const Text(
                    "Your Rating:",
                    style: TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return IconButton(
                        icon: Icon(
                          Icons.star,
                          size: 30,
                          color: index < _selectedRating ? Colors.amber : Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            _selectedRating = index + 1;
                          });
                        },
                      );
                    }),
                  ),
                  const SizedBox(height: 20),

                  // Review Text Field
                  const Text(
                    "Your Review:",
                    style: TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 0,
                          blurRadius: 5,
                          offset: const Offset(0, 0),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _reviewController,
                      maxLines: 5,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'Write your review here...',
                        hintStyle: TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Submit Button
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        if (_selectedRating == 0) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Please select a rating')),
                          );
                          return;
                        }

                        if (_reviewController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Please write a review')),
                          );
                          return;
                        }

                        setState(() {
                          _reviews.insert(0, {
                            'rating': _selectedRating.toDouble(),
                            'author': 'You',
                            'comment': _reviewController.text,
                          });
                          _selectedRating = 0;
                          _reviewController.clear();
                        });

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Review submitted!')),
                        );
                      },
                      child: Container(
                        height: 40,
                        width: 150,
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(23, 186, 1, 1.0),
                          borderRadius: BorderRadius.circular(7),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              spreadRadius: 0,
                              blurRadius: 5,
                              offset: const Offset(0, 0),
                            ),
                          ],
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Submit',
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'Outfit',
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

    );
  }
}

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(40),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 0),
          ),
        ],
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
}