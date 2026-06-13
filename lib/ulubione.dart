import 'package:flutter/foundation.dart';
import 'baza_danych.dart';

class UlubioneModel extends ChangeNotifier {
  final List<Map> ulubionePostacie = [];
  final List<Map> ulubioneZaklecia = [];

  UlubioneModel() {
    _init();
  }

  Future<void> _init() async {
    await BazaDanych().init();
    final postacie = await BazaDanych().getAllPostacie();
    final zaklecia = await BazaDanych().getAllZaklecia();
    ulubionePostacie.addAll(postacie);
    ulubioneZaklecia.addAll(zaklecia);
    notifyListeners();
  }

  bool czyUlubionaPostac(String name) {
    return ulubionePostacie.any((c) => c['name'] == name);
  }

  Future<void> przelaczUlubionaPostac(Map character) async {
    final name = character['name'];
    if (czyUlubionaPostac(name)) {
      ulubionePostacie.removeWhere((c) => c['name'] == name);
      await BazaDanych().removePostac(name);
    } else {
      ulubionePostacie.add(character);
      await BazaDanych().insertPostac(character);
    }
    notifyListeners();
  }

  bool czyUlubioneZaklecie(String name) {
    return ulubioneZaklecia.any((s) => s['name'] == name);
  }

  Future<void> przelaczUlubioneZaklecie(Map spell) async {
    final name = spell['name'];
    if (czyUlubioneZaklecie(name)) {
      ulubioneZaklecia.removeWhere((s) => s['name'] == name);
      await BazaDanych().removeZaklecie(name);
    } else {
      ulubioneZaklecia.add(spell);
      await BazaDanych().insertZaklecie(spell);
    }
    notifyListeners();
  }
}
