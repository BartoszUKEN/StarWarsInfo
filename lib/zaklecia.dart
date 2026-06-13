import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'zakleciaInfo.dart';
import 'ulubione.dart';

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
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/hogwart.jpg"),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(Colors.black45, BlendMode.darken),
              ),
            ),
          ),
          Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: const Text("Lista Zaklęć", style: TextStyle(color: Colors.white)),
              iconTheme: const IconThemeData(color: Colors.white),
            ),
            body: laduje
                ? const Center(child: CircularProgressIndicator(color: Colors.white))
                : ListView.separated(
                    itemCount: zaklecia.length,
                    separatorBuilder: (context, index) => const Divider(
                      color: Colors.white24,
                      indent: 20,
                      endIndent: 20,
                    ),
                    itemBuilder: (context, index) {
                      final czar = zaklecia[index];

                      return ListTile(
                        leading: const Icon(Icons.auto_fix_high, color: Colors.white),
                        title: Text(
                          czar['name'],
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        trailing: Consumer<UlubioneModel>(builder: (context, fav, _) {
                          final isFav = fav.czyUlubioneZaklecie(czar['name']);
                          return IconButton(
                            icon: Icon(isFav ? Icons.favorite : Icons.favorite_border, color: Colors.white),
                            onPressed: () async => await fav.przelaczUlubioneZaklecie(czar),
                          );
                        }),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ZakleciaInfoScreen(zaklecie: czar),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}