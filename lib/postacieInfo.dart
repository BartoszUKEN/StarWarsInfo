import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'ustawienia.dart';

class PostacieInfoScreen extends StatelessWidget {
  final Map postac;

  const PostacieInfoScreen({super.key, required this.postac});

  @override
  Widget build(BuildContext context) {
    String translateGender(String gender) {
      if (gender.toLowerCase() == 'male') return 'Mężczyzna';
      if (gender.toLowerCase() == 'female') return 'Kobieta';
      return gender;
    }

    final String house = (postac['house']?.isNotEmpty == true) ? postac['house'] : 'Nieznane';
    final String ancestry = (postac['ancestry']?.isNotEmpty == true) ? postac['ancestry'] : 'Nieznane';
    final String species = (postac['species']?.isNotEmpty == true) ? postac['species'] : 'Nieznane';
    final String gender = (postac['gender']?.isNotEmpty == true) ? translateGender(postac['gender']) : 'Nieznane';
    final String dateOfBirth = (postac['dateOfBirth']?.isNotEmpty == true) ? postac['dateOfBirth'] : 'Nieznane';
    final String patronus = (postac['patronus']?.isNotEmpty == true) ? postac['patronus'] : 'Nieznane';
    final String status = (postac['alive'] == true) ? 'Żyje' : 'Nie żyje';
    
    final wand = postac['wand'] ?? {};
    final String wood = (wand['wood']?.isNotEmpty == true) ? wand['wood'] : 'Nieznane';
    final String core = (wand['core']?.isNotEmpty == true) ? wand['core'] : 'Nieznane';

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
              title: Text(postac['name'], style: const TextStyle(color: Colors.white)),
              iconTheme: const IconThemeData(color: Colors.white),
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
              child: Column(
                children: [
                  const SizedBox(height: 60),
                  if (postac['image'] != null && postac['image'].isNotEmpty)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.network(postac['image'], height: 250, fit: BoxFit.cover),
                    ),
                  const SizedBox(height: 20),
                  _buildSectionTitle("Podstawowe informacje"),
                  _buildInfoCard([
                    _buildListTile(Icons.home, "Dom", house),
                    _buildListTile(Icons.person_outline, "Płeć", gender),
                    _buildListTile(Icons.pets, "Gatunek", species),
                    _buildListTile(Icons.favorite, "Status", status),
                  ]),
                  const SizedBox(height: 20),
                  _buildSectionTitle("Szczegóły magiczne"),
                  _buildInfoCard([
                    _buildListTile(Icons.cake, "Data urodzenia", dateOfBirth),
                    _buildListTile(Icons.bloodtype, "Rodowód", ancestry),
                    _buildListTile(Icons.auto_fix_high, "Patronus", patronus),
                    _buildListTile(Icons.brush, "Różdżka", "Drewno: $wood | Rdzeń: $core"),
                  ]),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        title, 
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)
      ),
    );
  }

  Widget _buildInfoCard(List<Widget> children) {
    return Consumer<UstawieniaModel>(builder: (context, ustaw, _) {
      final cardColor = ustaw.ciemnyTryb ? Colors.grey[800] : Colors.white.withAlpha(204);
      return Card(
        color: cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Column(children: children),
      );
    });
  }

  Widget _buildListTile(IconData icon, String title, String subtitle) {
    return Consumer<UstawieniaModel>(builder: (context, ustaw, _) {
      final iconColor = ustaw.ciemnyTryb ? Colors.white70 : Colors.black87;
      final titleColor = ustaw.ciemnyTryb ? Colors.white : Colors.black87;
      final subtitleColor = ustaw.ciemnyTryb ? Colors.white70 : Colors.black54;
      return ListTile(
        leading: Icon(icon, color: iconColor),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: titleColor)),
        subtitle: Text(subtitle, style: TextStyle(color: subtitleColor)),
      );
    });
  }
}