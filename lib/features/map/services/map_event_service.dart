import 'package:pingme_manager/features/map/models/map_event_model.dart';
import 'package:pingme_manager/features/map/repository/map_event_repository.dart';
import 'package:pingme_manager/features/map/services/dto/create_event_request.dart';

class MapEventService {
  final MapEventRepository _mapEventRepo = MapEventRepository();

  Future<List<MapEventModel>> getAllEvent() async {
    try {
      final response = await _mapEventRepo.getAllEvents();
      if (response.success && response.data != null) {
        if (response.data is List) {
          return (response.data as List)
              .map((e) => MapEventModel.fromJson(e))
              .toList();
        } else {
          throw Exception(
            response.message ?? 'Invalid data format: data is not a list',
          );
        }
      }
      throw Exception(response.message ?? 'Failed to load events');
    } catch (e) {
      throw Exception('ERROR: $e.toString()');
    }
  }

  Future<MapEventModel> createEvent(CreateEventRequest event) async {
    try {
      final response = await _mapEventRepo.createEvent(event.toJson());
      if (response.success && response.data != null) {
        return MapEventModel.fromJson(response.data);
      }
      throw Exception(response.message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<bool> deleteEvent(String eventId) async {
    try {
      final response = await _mapEventRepo.deleteEvent(eventId);
      return response.success;
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
