import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // User Data 읽기
  Future<Map<String, dynamic>> fetchUserData(String userId) async {
    try {
      final snapshot =
      await _firestore.collection('USER').doc(userId).get();

      if (snapshot.exists) {
        return snapshot.data()!;
      } else {
        throw Exception("User not found");
      }
    } catch (e) {
      print("User data fetch error: $e");
      return {};
    }
  }

  // Fridge Data 읽기
  Future<Map<String, dynamic>> fetchFridgeData(String fridgeSerial) async {
    try {
      final snapshot =
      await _firestore.collection('FRIDGE').doc(fridgeSerial).get();

      if (snapshot.exists) {
        return snapshot.data()!;
      } else {
        throw Exception("Fridge not found");
      }
    } catch (e) {
      print("Fridge data fetch error: $e");
      return {};
    }
  }

  // Smart Shelf Data 읽기 (변수명 변경 적용)
  Future<List<Map<String, dynamic>>> fetchSmartShelvesData(
      String fridgeSerial) async {
    try {
      final snapshot = await _firestore
          .collection('SMART_SHELF')
          .where('fridge_serial', isEqualTo: fridgeSerial)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          "ShelfSerial": data['smart_shelf_serial'],
          "shelfLocation": data['smart_shelf_location'],
          "fridgeSerial": data['fridge_serial'],
          "shelfRegDate": data['smart_shelf_register_date'],
        };
      }).toList();
    } catch (e) {
      print("Smart shelf data fetch error: $e");
      return [];
    }
  }

  // Food Management Data 읽기 (변수명 변경 적용)
  Future<List<Map<String, dynamic>>> fetchFoodManagementData(
      String shelfSerial) async {
    try {
      final snapshot = await _firestore
          .collection('FOOD_MANAGEMENT')
          .where('smart_shelf_serial', isEqualTo: shelfSerial)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          "foodManageSerial": data['food_management_serial'],
          "ShelfSerial": data['smart_shelf_serial'],
          "foodName": data['food_name'],
          "foodWeight": data['food_weight'],
          "foodLocation": data['food_location'],
          "foodRegDate": data['food_register_date'],
          "expirDate": data['food_expiration_date'],
          "unusedNotifPeriod": data['food_unused_notif_period'],
          "foodIsNotif": data['food_is_notif'],
          "weightUpdateTime": data['food_weight_update_time'],
        };
      }).toList();
    } catch (e) {
      print("Food management data fetch error: $e");
      return [];
    }
  }

  // Food Management Log Data 읽기
  Future<List<Map<String, dynamic>>> fetchFoodManagementLogData(
      String shelfSerial) async {
    try {
      final snapshot = await _firestore
          .collection('FOOD_MANAGEMENT_LOG')
          .where('smart_shelf_serial', isEqualTo: shelfSerial)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          "foodManageLogNo": data['food_management_log_no'], // 매핑된 변수
          "foodSerial": data['food_management_serial'], // 매핑된 변수
          "shelfSerial": data['smart_shelf_serial'], // 매핑된 변수
          "foodWeight": data['food_weight'], // 매핑된 변수
          "foodLocation": data['food_location'], // 매핑된 변수
          "expirDate": data['food_expiration_date'], // 매핑된 변수
          "foodIsDel": data['food_is_delete'], // 매핑된 변수
          "unusedNotifPeriod": data['food_unused_notif_period'], // 매핑된 변수
          "eventTime": data['event_datetime'], // 매핑된 변수
        };
      }).toList();
    } catch (e) {
      print("Food management log fetch error: $e");
      return [];
    }
  }
}