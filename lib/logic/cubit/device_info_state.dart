part of 'device_info_cubit.dart';

@immutable
abstract class DeviceInfoState {}

class DeviceInfoLoading extends DeviceInfoState {}

class DeviceInfoSuccess extends DeviceInfoState {
  final DeviceInfo deviceInfo;

  DeviceInfoSuccess(this.deviceInfo);
}
