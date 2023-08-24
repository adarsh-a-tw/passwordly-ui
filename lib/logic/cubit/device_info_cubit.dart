import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:passwordly/data/models/device_info.dart';
import 'package:device_info_plus/device_info_plus.dart' as device_info_plus;
import 'package:meta/meta.dart';

part 'device_info_state.dart';

class DeviceInfoCubit extends Cubit<DeviceInfoState> {
  final device_info_plus.DeviceInfoPlugin deviceInfo =
      device_info_plus.DeviceInfoPlugin();
  DeviceInfoCubit() : super(DeviceInfoLoading());

  Future<void> getDeviceInfo() async {
    if (Platform.isIOS) {
      emit(DeviceInfoSuccess(IosDeviceInfo()));
      return;
    }
    final device_info_plus.AndroidDeviceInfo androidInfo =
        await deviceInfo.androidInfo;
    emit(DeviceInfoSuccess(AndroidDeviceInfo(androidInfo.supportedAbis[0])));
  }
}
