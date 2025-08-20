import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/models/sim_card_model.dart';

class SimService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ดึง SIM Cards ทั้งหมด
  Future<List<SimCard>> getSimCards() async {
    try {
      final snapshot = await _db
          .collection('sim_cards')
          .where('status', isEqualTo: SimCardStatus.available.name)
          .get();

      return snapshot.docs
          .map((doc) => SimCard.fromJson({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch SIM cards: $e');
    }
  }

  // ดึง SIM Cards ตาม Type
  Future<List<SimCard>> getSimCardsByType(SimCardType type) async {
    try {
      final snapshot = await _db
          .collection('sim_cards')
          .where('type', isEqualTo: type.name)
          .where('status', isEqualTo: SimCardStatus.available.name)
          .get();

      return snapshot.docs
          .map((doc) => SimCard.fromJson({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch SIM cards by type: $e');
    }
  }

  // ดึง Data Packages
  Future<List<DataPackage>> getDataPackages() async {
    try {
      final snapshot = await _db.collection('data_packages').get();

      return snapshot.docs
          .map((doc) => DataPackage.fromJson({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch data packages: $e');
    }
  }

  // ค้นหา SIM Cards
  Future<List<SimCard>> searchSimCards(String query) async {
    try {
      final snapshot = await _db
          .collection('sim_cards')
          .where('status', isEqualTo: SimCardStatus.available.name)
          .get();

      final allSims = snapshot.docs
          .map((doc) => SimCard.fromJson({...doc.data(), 'id': doc.id}))
          .toList();

      // Filter by search query
      return allSims.where((sim) {
        final phoneNumber = sim.phoneNumber.toLowerCase();
        final packageName = (sim.packageName ?? '').toLowerCase();
        final searchQuery = query.toLowerCase();

        return phoneNumber.contains(searchQuery) ||
            packageName.contains(searchQuery);
      }).toList();
    } catch (e) {
      throw Exception('Failed to search SIM cards: $e');
    }
  }

  // จอง SIM Card
  Future<void> reserveSimCard(String simId, String userId) async {
    try {
      await _db.collection('sim_cards').doc(simId).update({
        'status': SimCardStatus.reserved.name,
        'userId': userId,
        'reservedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to reserve SIM card: $e');
    }
  }

  // ยกเลิกการจอง SIM Card
  Future<void> cancelReservation(String simId) async {
    try {
      await _db.collection('sim_cards').doc(simId).update({
        'status': SimCardStatus.available.name,
        'userId': null,
        'reservedAt': null,
      });
    } catch (e) {
      throw Exception('Failed to cancel reservation: $e');
    }
  }
}
