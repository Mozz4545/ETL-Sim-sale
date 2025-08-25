import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/sim_card_model.dart';

/// Service class สำหรับจัดการข้อมูล SIM cards และ data packages จาก Firestore
///
/// Functions:
/// - ดึงข้อมูล SIM cards ทั้งหมด
/// - กรองตาม type และสถานะ
/// - ค้นหาด้วยหมายเลข
/// - จัดการสถานะ SIM (available/reserved)
class SimService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ดึง SIM Cards ทั้งหมด
  Future<List<SimCard>> getSimCards() async {
    try {
      final snapshot = await _firestore
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
      final snapshot = await _firestore
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
      final snapshot = await _firestore.collection('data_packages').get();

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
      final snapshot = await _firestore
          .collection('sim_cards')
          .where('status', isEqualTo: SimCardStatus.available.name)
          .get();

      final allCards = snapshot.docs
          .map((doc) => SimCard.fromJson({...doc.data(), 'id': doc.id}))
          .toList();

      // Filter locally by phone number
      return allCards.where((card) {
        return card.phoneNumber.toLowerCase().contains(query.toLowerCase());
      }).toList();
    } catch (e) {
      throw Exception('Failed to search SIM cards: $e');
    }
  }

  // จอง SIM Card
  Future<void> reserveSimCard(String simId, String userId) async {
    try {
      await _firestore.collection('sim_cards').doc(simId).update({
        'status': SimCardStatus.reserved.name,
        'reserved_by': userId,
        'reserved_at': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to reserve SIM card: $e');
    }
  }

  // ยกเลิกการจอง
  Future<void> cancelReservation(String simId) async {
    try {
      await _firestore.collection('sim_cards').doc(simId).update({
        'status': SimCardStatus.available.name,
        'reserved_by': FieldValue.delete(),
        'reserved_at': FieldValue.delete(),
      });
    } catch (e) {
      throw Exception('Failed to cancel reservation: $e');
    }
  }

  // เพิ่ม SIM Card ใหม่ (สำหรับ admin)
  Future<void> addSimCard(SimCard simCard) async {
    try {
      await _firestore.collection('sim_cards').add(simCard.toJson());
    } catch (e) {
      throw Exception('Failed to add SIM card: $e');
    }
  }

  // อัพเดท SIM Card
  Future<void> updateSimCard(String simId, SimCard simCard) async {
    try {
      await _firestore
          .collection('sim_cards')
          .doc(simId)
          .update(simCard.toJson());
    } catch (e) {
      throw Exception('Failed to update SIM card: $e');
    }
  }

  // ลบ SIM Card
  Future<void> deleteSimCard(String simId) async {
    try {
      await _firestore.collection('sim_cards').doc(simId).delete();
    } catch (e) {
      throw Exception('Failed to delete SIM card: $e');
    }
  }
}
