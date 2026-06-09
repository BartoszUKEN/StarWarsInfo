import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PostacieScreen extends StatefulWidget {
  const PostacieScreen({super.key});

  @override
  State<PostacieScreen> createState() => _PostacieScreenState();
}

class _PostacieScreenState extends State<PostacieScreen> {
  List postacie = [];
  bool laduje = true;

  Future<void> pobierzDane() async {
    final url = Uri.parse('https://hp-api.onrender.com/api/characters');
    final odpowiedz = await http.get(url);

    if (odpowiedz.statusCode == 200) {
      setState(() {
        postacie = json.decode(odpowiedz.body);
        laduje = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    pobierzDane();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Postacie z Harry'ego Pottera")),
      body: laduje 
        ? const Center(child: CircularProgressIndicator()) 
        : ListView.builder(
            itemCount: postacie.length,
            itemBuilder: (context, index) {
              final postac = postacie[index];
              
              String imie = postac['name'];
              String dom = postac['house'] ?? 'Brak';
              bool zyje = postac['alive'] ?? false;
              String zdjecie = postac['image'] ?? '';

              return ListTile(
                leading: SizedBox(
                  width: 50,
                  height: 70,
                  child: zdjecie.isNotEmpty 
                      ? Image.network(zdjecie, fit: BoxFit.cover)
                      : const Icon(Icons.person, size: 40),
                ),
                title: Text(imie),
                subtitle: Text("Dom: $dom   |  ${zyje ? 'Żyje' : 'Nie żyje'}"),
              );
            },
          ),
    );
  }
}