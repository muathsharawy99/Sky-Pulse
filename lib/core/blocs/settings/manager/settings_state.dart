import 'package:equatable/equatable.dart';
import 'package:weather_app/core/shared/enums/speed_unit.dart';
import 'package:weather_app/core/shared/enums/temp_unit.dart';

class SettingsState extends Equatable {
  const SettingsState({
    this.tempUnit = TempUnit.celsius,
    this.speedUnit = SpeedUnit.kph,
  });

  final TempUnit tempUnit;
  final SpeedUnit speedUnit;

  SettingsState copyWith({TempUnit? tempUnit, SpeedUnit? speedUnit}) =>
      SettingsState(
        tempUnit: tempUnit ?? this.tempUnit,
        speedUnit: speedUnit ?? this.speedUnit,
      );

  @override
  List<Object?> get props => [tempUnit, speedUnit];
}
