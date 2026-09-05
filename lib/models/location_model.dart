class LocationModel {
  final double latitude;
  final double longitude;
  final String address;
  final String? city;
  final String? state;
  final String? postalCode;

  const LocationModel({
    required this.latitude,
    required this.longitude,
    required this.address,
    this.city,
    this.state,
    this.postalCode,
  });

  Map<String, dynamic> toMap() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'city': city,
      'state': state,
      'postalCode': postalCode,
    };
  }

  factory LocationModel.fromMap(Map<String, dynamic> map) {
    return LocationModel(
      latitude: (map['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (map['longitude'] as num?)?.toDouble() ?? 0.0,
      address: map['address'] as String? ?? 'Nagpur, Maharashtra',
      city: map['city'] as String?,
      state: map['state'] as String?,
      postalCode: map['postalCode'] as String?,
    );
  }
}
