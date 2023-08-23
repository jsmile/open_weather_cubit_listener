import 'package:equatable/equatable.dart';

// openweather에서 제공하는 api 결과값을 직접 받는 model
class DirectGeocoding extends Equatable {
  final String name;
  final double lat;
  final double lon;
  final String country; // 국가코드
  final String state; //국가명

  const DirectGeocoding({
    required this.name,
    required this.lat,
    required this.lon,
    required this.country,
    required this.state,
  });

  factory DirectGeocoding.fromJson(List<dynamic> json) {
    final Map<String, dynamic> data = json[0];

    return DirectGeocoding(
        name: data['name'],
        lat: data['lat'],
        lon: data['lon'],
        country: data['country'],
        state: data['state'] ?? '');
  }

  @override
  List<Object> get props {
    return [
      name,
      lat,
      lon,
      country,
      state,
    ];
  }

  @override
  String toString() {
    return 'DirectGocoing(name: $name, lat: $lat, lng: $lon, country: $country, state: $state)';
  }
}
