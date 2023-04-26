part of 'gps_bloc.dart';

abstract class GpsEvent extends Equatable {
  const GpsEvent();

  @override
  List<Object> get props => [];
}

class GpsAndPermissionEvent extends GpsEvent {
  final bool isGpsEnabled;
  final bool isGpsPermissionGranted;
  final bool isReady;

  const GpsAndPermissionEvent(
      {required this.isGpsEnabled,
      required this.isGpsPermissionGranted,
      required this.isReady});
}
