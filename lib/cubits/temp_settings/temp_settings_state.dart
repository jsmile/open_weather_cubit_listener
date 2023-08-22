part of 'temp_settings_cubit.dart';

enum TempUnit { celcius, fahrenheit }

class TempSettingsState extends Equatable {
  final TempUnit tempUnit;

  const TempSettingsState({this.tempUnit = TempUnit.celcius});

  factory TempSettingsState.initial() {
    return const TempSettingsState();
  }

  TempSettingsState copyWith({
    TempUnit? tempUnit,
  }) {
    return TempSettingsState(
      tempUnit: tempUnit ?? this.tempUnit,
    );
  }

  @override
  List<Object> get props => [tempUnit];

  @override
  String toString() => 'TempSettingsState(tempUnit: $tempUnit)';
}
