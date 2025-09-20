enum StorageOption {
  box,
  xs,
  s,
  m,
  l;

  String get displayName {
    switch (this) {
      case StorageOption.box:
        return '박스';
      case StorageOption.xs:
        return 'XS';
      case StorageOption.s:
        return 'S';
      case StorageOption.m:
        return 'M';
      case StorageOption.l:
        return 'L';
    }
  }

  double get width {
    switch (this) {
      case StorageOption.box:
        return 30;
      case StorageOption.xs:
        return 40;
      case StorageOption.s:
        return 50;
      case StorageOption.m:
        return 70;
      case StorageOption.l:
        return 100;
    }
  }

  double get depth {
    switch (this) {
      case StorageOption.box:
        return 30;
      case StorageOption.xs:
        return 40;
      case StorageOption.s:
        return 50;
      case StorageOption.m:
        return 70;
      case StorageOption.l:
        return 100;
    }
  }

  double get height {
    switch (this) {
      case StorageOption.box:
        return 30;
      case StorageOption.xs:
        return 40;
      case StorageOption.s:
        return 60;
      case StorageOption.m:
        return 80;
      case StorageOption.l:
        return 120;
    }
  }

  double get volume => width * depth * height;

  String get dimensionText => '${width.toInt()}×${depth.toInt()}×${height.toInt()}cm';

  int get recommendedPrice {
    switch (this) {
      case StorageOption.box:
        return 15000;
      case StorageOption.xs:
        return 20000;
      case StorageOption.s:
        return 30000;
      case StorageOption.m:
        return 45000;
      case StorageOption.l:
        return 70000;
    }
  }
}