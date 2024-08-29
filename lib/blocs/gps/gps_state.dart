part of 'gps_bloc.dart';

class GpsState extends Equatable {
  final bool isGpsEnabled;
  final bool isGpsPermissionGranted;
  final bool isReady;

  bool get isAllGranted => isGpsEnabled && isGpsPermissionGranted;

  const GpsState(
      {required this.isGpsEnabled,
      required this.isGpsPermissionGranted,
      required this.isReady});

  GpsState copyWith({
    bool? isGpsEnabled,
    bool? isGpsPermissionGranted,
    bool? isReady,
  }) =>
      GpsState(
          isGpsEnabled: isGpsEnabled ?? this.isGpsEnabled,
          isGpsPermissionGranted:
              isGpsPermissionGranted ?? this.isGpsPermissionGranted,
          isReady: isReady ?? this.isReady);

  @override
  List<Object> get props => [isGpsEnabled, isGpsPermissionGranted, isReady];
}
