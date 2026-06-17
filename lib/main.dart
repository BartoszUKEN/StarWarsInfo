import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';
import 'baza_danych.dart';
import 'postacie.dart';
import 'zaklecia.dart';
import 'ulubione.dart';
import 'ulubione_screen.dart';
import 'ustawienia.dart';
import 'ustawienia_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    await Firebase.initializeApp();

    FlutterError.onError = (errorDetails) {
      FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
    };
    
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };

    await FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true);
  } catch (e) {
    debugPrint("$e");
  }

  final db = BazaDanych();
  await db.init();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => UlubioneModel()),
      ChangeNotifierProvider(create: (_) => UstawieniaModel()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final ustawienia = Provider.of<UstawieniaModel>(context);
    final theme = ustawienia.ciemnyTryb
        ? ThemeData.dark().copyWith(
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[800],
                foregroundColor: Colors.white,
              ),
            ),
          )
        : ThemeData.light();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: theme,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int licznikPostaci = 0;
  int licznikZaklec = 0;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    try {
      final postacieOdpowiedz = await http.get(Uri.parse('https://hp-api.onrender.com/api/characters'));
      final zakleciaOdpowiedz = await http.get(Uri.parse('https://hp-api.onrender.com/api/spells'));

      if (postacieOdpowiedz.statusCode == 200 && zakleciaOdpowiedz.statusCode == 200) {
        if (!mounted) return;
        setState(() {
          licznikPostaci = json.decode(postacieOdpowiedz.body).length;
          licznikZaklec = json.decode(zakleciaOdpowiedz.body).length;
        });
      }
    } catch (e) {
      debugPrint("$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("Harry Potter Informacje", style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => UstawieniaScreen(onRefresh: _loadStats)),
            ),
          )
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/hogwart.jpg"),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(Colors.black45, BlendMode.darken),
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 200),
            const Text(
              "Witaj w Szkole Magii i Czarodziejstwa",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            
            SizedBox(
              width: 250,
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            FirebaseAnalytics.instance.logEvent(name: 'otwarcie_ekranu_postaci');
                            Navigator.push(context, MaterialPageRoute(builder: (_) => const PostacieScreen()));
                          }, 
                          child: const Text("Postacie")
                        )
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            FirebaseAnalytics.instance.logEvent(name: 'otwarcie_ekranu_zaklecia');
                            Navigator.push(context, MaterialPageRoute(builder: (_) => const ZakleciaScreen()));
                          }, 
                          child: const Text("Zaklęcia")
                        )
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        FirebaseAnalytics.instance.logEvent(name: 'otwarcie_ekranu_ulubione');
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const UlubioneScreen()));
                      }, 
                      child: const Text("Ulubione")
                    ),
                  ),
                ],
              ),
            ),

            const Expanded(child: SizedBox()),
            const Text("Liczba dostępnych danych:", style: TextStyle(color: Colors.white, fontSize: 18)),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildStatCard("Postacie", licznikPostaci),
                const SizedBox(width: 20),
                _buildStatCard("Zaklęcia", licznikZaklec),
              ],
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, int count) {
    return Consumer<UstawieniaModel>(builder: (context, ustaw, _) {
      final cardColor = ustaw.ciemnyTryb ? Colors.grey[800] : Colors.white.withAlpha(204);
      final textColor = ustaw.ciemnyTryb ? Colors.white : Colors.black;
      return Card(
        color: cardColor,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              Text(label, style: TextStyle(color: textColor)),
              Text(count == 0 ? "..." : "$count", style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 20)),
            ],
          ),
        ),
      );
    });
  }
}