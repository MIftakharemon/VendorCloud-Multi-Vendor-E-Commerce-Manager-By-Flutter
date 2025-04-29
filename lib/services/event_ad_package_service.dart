
import 'package:get/get.dart';
import '../constants/network_constants.dart';
import '../services/base/auth_client.dart';
import '../services/shared_pref_service.dart';
import '../utils/exceptions/firebase_exceptions.dart';

class GenericRepository<T> extends GetxController {
  static GenericRepository get instance => Get.find();

  final SharedPrefService _prefService = SharedPrefService();
  final BaseClient _baseClient = BaseClient();

  final Function(Map<String, dynamic>) fromJson;
  final String endpoint;

  GenericRepository({required this.fromJson, required this.endpoint});

  Future<List<T>> fetchItems({int page = 1, int limit = 10}) async {
    try {
      final sessionId = await _prefService.getSessionId();
      final response = await _baseClient.get(
        endpoint,
        header: {'Cookie': "connect.sid=$sessionId"},
      ).catchError((e) => throw CustomApiException('Failed to load items'));

      if (response['body'] != null && response['body'].containsKey('data')) {
        final model = fromJson(response['body']);
        return model.data ?? [];
      }
    } catch (e) {
      throw 'Something went wrong while fetching items. Try again later.';
    }
    return [];
  }
}
