import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UstawieniaModel extends ChangeNotifier {
  bool _ciemnyTryb = false;
  static const _kluczCiemnyTryb = 'ciemnyTryb';

  UstawieniaModel() {
    _wczytajUstawienia();
  }

  Future<void> _wczytajUstawienia() async {
    final prefs = await SharedPreferences.getInstance();
    _ciemnyTryb = prefs.getBool(_kluczCiemnyTryb) ?? false;
    notifyListeners();
  }

  bool get ciemnyTryb => _ciemnyTryb;

  Future<void> przelaczTryb() async {
    _ciemnyTryb = !_ciemnyTryb;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kluczCiemnyTryb, _ciemnyTryb);
    notifyListeners();
  }

  Future<void> ustawTryb(bool value) async {
    _ciemnyTryb = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kluczCiemnyTryb, _ciemnyTryb);
    notifyListeners();
  }
}
