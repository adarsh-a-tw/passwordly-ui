abstract class DeviceInfo {}

class AndroidDeviceInfo extends DeviceInfo {
  final String abi;

  AndroidDeviceInfo(this.abi);
}

class IosDeviceInfo extends DeviceInfo {
  IosDeviceInfo();
}
