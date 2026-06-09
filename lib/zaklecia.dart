import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ZakleciaScreen extends StatefulWidget {
  const ZakleciaScreen({super.key});

  @override
  State<ZakleciaScreen> createState() => _ZakleciaScreenState();
}

class _ZakleciaScreenState extends State<ZakleciaScreen> {
  List zaklecia = [];
  bool laduje = true;

  Future<void> pobierzZaklecia() async {
    try {
      final odpowiedz = await http.get(Uri.parse('https://hp-api.onrender.com/api/spells'));

      if (odpowiedz.statusCode == 200) {
        setState(() {
          zaklecia = json.decode(odpowiedz.body);
          laduje = false;
        });
      }
    } catch (e) {
      setState(() => laduje = false);
    }
  }

  @override
  void initState() {
    super.initState();
    pobierzZaklecia();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Lista Zaklęć")),
      body: laduje
          ? const Center(child: CircularProgressIndicator())
          : ListView.separated(
              itemCount: zaklecia.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final czar = zaklecia[index];
                
                return ListTile(
                  leading: const Icon(Icons.auto_fix_high),
                  title: Text(czar['name']),
                );
              },
            ),
    );
  }
}