class LocationSelection {
  final double lat;
  final double lon;
  final String? addressLabel;

  const LocationSelection({
    required this.lat,
    required this.lon,
    this.addressLabel,
  });

  String get coordinateLabel =>
      '${lat.toStringAsFixed(5)}, ${lon.toStringAsFixed(5)}';

  LocationSelection copyWith({
    double? lat,
    double? lon,
    String? addressLabel,
    bool clearAddress = false,
  }) {
    return LocationSelection(
      lat: lat ?? this.lat,
      lon: lon ?? this.lon,
      addressLabel: clearAddress ? null : (addressLabel ?? this.addressLabel),
    );
  }
}
