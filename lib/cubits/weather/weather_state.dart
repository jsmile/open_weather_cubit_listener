part of 'weather_cubit.dart';

// Weather API 호출 상태에 따라 작업이 필요할 수 있으므로 enum 으로 정의함.
enum WeatherStatus { initial, loading, loaded, failure }

class WeatherState extends Equatable {
  final WeatherStatus status;
  final Weather weather;
  final CustomError error;

  const WeatherState({
    required this.status,
    required this.weather,
    required this.error,
  });

  factory WeatherState.initial() {
    return WeatherState(
      status: WeatherStatus.initial,
      weather: Weather.initial(),
      error: const CustomError(),
    );
  }

  WeatherState copyWith({
    WeatherStatus? status,
    Weather? weather,
    CustomError? error,
  }) {
    return WeatherState(
      status: status ?? this.status,
      weather: weather ?? this.weather,
      error: error ?? this.error,
    );
  }

  @override
  List<Object> get props => [status, weather, error];

  @override
  String toString() =>
      'WeatherState(status: $status, weather: $weather, error: $error)';
}
