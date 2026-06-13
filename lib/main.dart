import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'postacie.dart';
import 'zaklecia.dart';
import 'ulubione.dart';
import 'ulubione_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(ChangeNotifierProvider(create: (_) => UlubioneModel(), child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
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
    final postacieOdpowiedz = await http.get(Uri.parse('https://hp-api.onrender.com/api/characters'));
    final zakleciaOdpowiedz = await http.get(Uri.parse('https://hp-api.onrender.com/api/spells'));

    if (postacieOdpowiedz.statusCode == 200 && zakleciaOdpowiedz.statusCode == 200) {
      setState(() {
        licznikPostaci = json.decode(postacieOdpowiedz.body).length;
        licznikZaklec = json.decode(zakleciaOdpowiedz.body).length;
      });
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
        actions: [IconButton(icon: const Icon(Icons.settings, color: Colors.white), onPressed: () {})],
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
                      Expanded(child: ElevatedButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PostacieScreen())), child: const Text("Postacie"))),
                      const SizedBox(width: 15),
                      Expanded(child: ElevatedButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ZakleciaScreen())), child: const Text("Zaklęcia"))),
                    ],
                  ),
                  const SizedBox(height: 15),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const UlubioneScreen())), child: const Text("Ulubione")),
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
    return Card(
      color: Colors.white.withAlpha(204),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Text(label),
            Text(count == 0 ? "..." : "$count", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
          ],
        ),
      ),
    );
  }
}