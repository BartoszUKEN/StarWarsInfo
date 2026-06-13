import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'ustawienia.dart';

class ZakleciaInfoScreen extends StatelessWidget {
  final Map zaklecie;

  const ZakleciaInfoScreen({super.key, required this.zaklecie});

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
              title: Text(zaklecie['name'], style: const TextStyle(color: Colors.white)),
              iconTheme: const IconThemeData(color: Colors.white),
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    const Icon(Icons.auto_fix_high, size: 80, color: Colors.white),
                    const SizedBox(height: 20),
                    Consumer<UstawieniaModel>(builder: (context, ustaw, _) {
                      final cardColor = ustaw.ciemnyTryb ? Colors.grey[800] : Colors.white.withAlpha(204);
                      final textColor = ustaw.ciemnyTryb ? Colors.white : Colors.black;
                      final subtitleColor = ustaw.ciemnyTryb ? Colors.white70 : Colors.black54;
                      return Card(
                        color: cardColor,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            children: [
                              Text(
                                "Opis zaklęcia",
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: textColor),
                              ),
                              const SizedBox(height: 15),
                              Text(
                                zaklecie['description'] ?? 'Brak opisu dla tego zaklęcia.',
                                style: TextStyle(fontSize: 16, color: subtitleColor),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}