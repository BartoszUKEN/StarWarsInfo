import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'ulubione.dart';
import 'ustawienia.dart';
import 'postacieInfo.dart';
import 'zakleciaInfo.dart';

class UlubioneScreen extends StatelessWidget {
  const UlubioneScreen({super.key});

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
              title: const Text('Ulubione', style: TextStyle(color: Colors.white)),
              iconTheme: const IconThemeData(color: Colors.white),
            ),
            body: Consumer<UlubioneModel>(builder: (context, fav, _) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(child: const Text('Postacie', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white))),
                    const SizedBox(height: 8),
                          if (fav.ulubionePostacie.isEmpty)
                            const Center(child: Text('Brak ulubionych postaci', style: TextStyle(color: Colors.white70))),
                          ...fav.ulubionePostacie.map((c) => Consumer<UstawieniaModel>(builder: (context, ustaw, _) {
                      final cardColor = ustaw.ciemnyTryb ? Colors.grey[800] : Colors.white.withAlpha(204);
                      final textColor = ustaw.ciemnyTryb ? Colors.white : Colors.black;
                      final iconColor = ustaw.ciemnyTryb ? Colors.white70 : Colors.black54;
                      return SizedBox(
                        width: double.infinity,
                        child: Card(
                          color: cardColor,
                          child: ListTile(
                                  title: Text(c['name'] ?? '', style: TextStyle(color: textColor)),
                                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => PostacieInfoScreen(postac: c))),
                                  trailing: IconButton(
                                    icon: Icon(Icons.delete, color: iconColor),
                                    onPressed: () async => await fav.przelaczUlubionaPostac(c),
                                  ),
                          ),
                        ),
                      );
                    })),
                    const SizedBox(height: 16),
                    Center(child: const Text('Zaklęcia', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white))),
                    const SizedBox(height: 8),
                    if (fav.ulubioneZaklecia.isEmpty)
                      const Center(child: Text('Brak ulubionych zaklęć', style: TextStyle(color: Colors.white70))),
                    ...fav.ulubioneZaklecia.map((s) => Consumer<UstawieniaModel>(builder: (context, ustaw, _) {
                      final cardColor = ustaw.ciemnyTryb ? Colors.grey[800] : Colors.white.withAlpha(204);
                      final textColor = ustaw.ciemnyTryb ? Colors.white : Colors.black;
                      final iconColor = ustaw.ciemnyTryb ? Colors.white70 : Colors.black54;
                      return SizedBox(
                        width: double.infinity,
                        child: Card(
                          color: cardColor,
                          child: ListTile(
                            title: Text(s['name'] ?? '', style: TextStyle(color: textColor)),
                            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ZakleciaInfoScreen(zaklecie: s))),
                            trailing: IconButton(
                              icon: Icon(Icons.delete, color: iconColor),
                              onPressed: () async => await fav.przelaczUlubioneZaklecie(s),
                            ),
                          ),
                        ),
                      );
                    })),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
