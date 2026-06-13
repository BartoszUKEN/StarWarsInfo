import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'ulubione.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'postacieInfo.dart';

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
              title: const Text("Postacie", style: TextStyle(color: Colors.white)),
              iconTheme: const IconThemeData(color: Colors.white),
            ),
            body: laduje
                ? const Center(child: CircularProgressIndicator(color: Colors.white))
                : ListView.separated(
                    itemCount: postacie.length,
                    separatorBuilder: (context, index) => const Divider(
                      color: Colors.white24,
                      indent: 20,
                      endIndent: 20,
                    ),
                    itemBuilder: (context, index) {
                      final postac = postacie[index];
                      String imie = postac['name'];
                      String dom = postac['house'] ?? 'Brak';
                      bool zyje = postac['alive'] ?? false;
                      String zdjecie = postac['image'] ?? '';

                      return ListTile(
                        leading: Container(
                          width: 50,
                          height: 70,
                          decoration: BoxDecoration(
                            color: Colors.white10,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: zdjecie.isNotEmpty
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(zdjecie, fit: BoxFit.cover),
                                )
                              : const Icon(Icons.person, color: Colors.white),
                        ),
                        title: Text(imie, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        subtitle: Text("Dom: $dom  |  ${zyje ? 'Żyje' : 'Nie żyje'}", style: const TextStyle(color: Colors.white70)),
                        trailing: Consumer<UlubioneModel>(builder: (context, fav, _) {
                          final isFav = fav.czyUlubionaPostac(imie);
                          return IconButton(
                            icon: Icon(isFav ? Icons.favorite : Icons.favorite_border, color: Colors.white),
                            onPressed: () => fav.przelaczUlubionaPostac(postac),
                          );
                        }),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PostacieInfoScreen(postac: postac),
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