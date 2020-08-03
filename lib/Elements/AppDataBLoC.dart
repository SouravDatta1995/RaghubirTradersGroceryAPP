import 'dart:async';

class AppDataBLoC {
  static final AppDataBLoC _appDataBLoC = new AppDataBLoC._internal();
  int _num = 0;
  final cartNum = StreamController<int>();
  factory AppDataBLoC() {
    return _appDataBLoC;
  }
  AppDataBLoC._internal() {
    cartNum.add(0);
  }
  dispose() {
    cartNum.close();
  }

  cartNumAdd(int val) {
    _num += val;
    //print(val.toString() + _num.toString());
    cartNum.add(_num);
  }
}

final appData = AppDataBLoC();
