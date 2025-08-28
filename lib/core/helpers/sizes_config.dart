import 'package:flutter/widgets.dart';

enum DeviceType { mobile, tablet, desktop }

class SizesConfig {
  final BuildContext context;
  late final double _width;

  SizesConfig(this.context) {
    _width = MediaQuery.sizeOf(context).width;
  }

  DeviceType get deviceType {
    if (_width >= 1024) {
      return DeviceType.desktop;
    } else if (_width >= 600) {
      return DeviceType.tablet;
    } else {
      return DeviceType.mobile;
    }
  }

  bool get isMobile => deviceType == DeviceType.mobile;
  bool get isTablet => deviceType == DeviceType.tablet;
  bool get isDesktop => deviceType == DeviceType.desktop;

  double get screenWidth => _width;
  double get screenHeight => MediaQuery.sizeOf(context).height;
}
