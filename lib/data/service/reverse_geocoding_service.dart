import 'package:geocoding/geocoding.dart';

class ReverseGeocodingService {
  Future<String?> getAddressLabel({
    required double latitude,
    required double longitude,
  }) async {
    final placemarks = await placemarkFromCoordinates(latitude, longitude);
    if (placemarks.isEmpty) return null;

    final place = placemarks.first;
    final parts =
        <String?>[
              place.street,
              place.subLocality,
              place.locality,
              place.administrativeArea,
              place.country,
            ]
            .whereType<String>()
            .map((part) => part.trim())
            .where((part) => part.isNotEmpty)
            .toSet()
            .toList();

    if (parts.isEmpty) return null;
    return parts.join(', ');
  }
}
