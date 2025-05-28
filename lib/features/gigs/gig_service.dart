import 'package:cloud_firestore/cloud_firestore.dart';

import 'gig_model.dart';

class GigService {
  final CollectionReference _gigsCollection =
  FirebaseFirestore.instance.collection('gigs');

  // Add a new gig
  Future<String> addGig(Gig gig) async {
    try {
      DocumentReference docRef = await _gigsCollection.add(gig.toMap());
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to add gig: $e');
    }
  }

  // Update an existing gig
  Future<void> updateGig(Gig gig) async {
    try {
      await _gigsCollection.doc(gig.id).update(gig.toMap());
    } catch (e) {
      throw Exception('Failed to update gig: $e');
    }
  }

  // Delete a gig
  Future<void> deleteGig(String gigId) async {
    try {
      await _gigsCollection.doc(gigId).delete();
    } catch (e) {
      throw Exception('Failed to delete gig: $e');
    }
  }

  // Get all gigs for a specific seller
  Future<List<Gig>> getGigsBySeller(String sellerId) async {
    try {
      QuerySnapshot querySnapshot = await _gigsCollection
          .where('sellerId', isEqualTo: sellerId)
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => Gig.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      throw Exception('Failed to get gigs: $e');
    }
  }

  // Get a single gig by ID
  Future<Gig> getGigById(String gigId) async {
    try {
      DocumentSnapshot doc = await _gigsCollection.doc(gigId).get();
      if (doc.exists) {
        return Gig.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      } else {
        throw Exception('Gig not found');
      }
    } catch (e) {
      throw Exception('Failed to get gig: $e');
    }
  }
}
