part of 'settings_cubit.dart';

/// Extends Equatable so BlocBuilder only rebuilds on an actual value change.
class SettingsState extends Equatable {
  const SettingsState({
    this.tempUnit = TempUnit.celsius,
    this.speedUnit = SpeedUnit.kph,
  });

  final TempUnit tempUnit;
  final SpeedUnit speedUnit;

  SettingsState copyWith({TempUnit? tempUnit, SpeedUnit? speedUnit}) {
    return SettingsState(
      tempUnit: tempUnit ?? this.tempUnit,
      speedUnit: speedUnit ?? this.speedUnit,
    );
  }

  @override
  List<Object?> get props => [tempUnit, speedUnit];
}
