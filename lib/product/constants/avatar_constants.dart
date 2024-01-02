import 'package:flutter/material.dart';

enum AvatarConstants {
  avatar1,
  avatar2,
  avatar3,
  avatar4,
  avatar5,
  avatar6,
  avatar7,
  avatar8,
  avatar9,
}

extension AvatarConstantsExtension on AvatarConstants {
  String get value {
    switch (this) {
      case AvatarConstants.avatar1:
        return 'https://cdn-icons-png.flaticon.com/128/1677/1677572.png?semt=ais';
      case AvatarConstants.avatar2:
        return 'https://cdn-icons-png.flaticon.com/128/2314/2314889.png?semt=ais';
      case AvatarConstants.avatar3:
        return 'https://cdn-icons-png.flaticon.com/128/1912/1912042.png?semt=ais';
      case AvatarConstants.avatar4:
        return 'https://cdn-icons-png.flaticon.com/128/2314/2314888.png?semt=ais';
      case AvatarConstants.avatar5:
        return 'https://cdn-icons-png.flaticon.com/128/2059/2059570.png?semt=ais';
      case AvatarConstants.avatar6:
        return 'https://cdn-icons-png.flaticon.com/128/1880/1880999.png?semt=ais';
      case AvatarConstants.avatar7:
        return 'https://cdn-icons-png.flaticon.com/128/1880/1880993.png?semt=ais';
      case AvatarConstants.avatar8:
        return 'https://cdn-icons-png.flaticon.com/128/2059/2059598.png?semt=ais';
      case AvatarConstants.avatar9:
        return 'https://cdn-icons-png.flaticon.com/128/1154/1154440.png?semt=ais';
    }
  }

  static String getAvatarUrl(int index) {
    switch (index) {
      case 0:
        return AvatarConstants.avatar1.value;
      case 1:
        return AvatarConstants.avatar2.value;
      case 2:
        return AvatarConstants.avatar3.value;
      case 3:
        return AvatarConstants.avatar4.value;
      case 4:
        return AvatarConstants.avatar5.value;
      case 5:
        return AvatarConstants.avatar6.value;
      case 6:
        return AvatarConstants.avatar7.value;
      case 7:
        return AvatarConstants.avatar8.value;
      case 8:
        return AvatarConstants.avatar9.value;
      default:
        return ''; // Uygun bir varsayılan değeri ekleyebilirsiniz.
    }
  }
}
