import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/pays.dart';
import '../services/appwrite_service.dart';
import 'country_detail_page.dart';
import 'about_page.dart';
import 'welcome_page.dart';

class CountriesPage extends StatefulWidget {
  const CountriesPage({super.key});

  @override
  State<CountriesPage> createState() => _CountriesPageState();
}

class _CountriesPageState extends State<CountriesPage> {
  final AppwriteService _appwriteService = AppwriteService();
  late Future<List<Pays>> _paysFuture;

  @override
  void initState() {
    super.initState();
    _paysFuture = _appwriteService.getPays();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Liste des Pays")),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(Icons.public, size: 50, color: Colors.white),
                  SizedBox(height: 10),
                  Text(
                    'Menu',
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Accueil'),
              onTap: () {
                Navigator.pop(context); // Close drawer
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const WelcomePage()),
                  (route) => false,
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('À propos'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AboutPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text('Quitter'),
              onTap: () {
                SystemNavigator.pop();
              },
            ),
          ],
        ),
      ),
      body: FutureBuilder<List<Pays>>(
        future: _paysFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Erreur: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Aucun pays trouvé."));
          }

          final paysList = snapshot.data!;

          return ListView.builder(
            itemCount: paysList.length,
            itemBuilder: (context, index) {
              final pays = paysList[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: ListTile(
                  leading: _buildFlag(pays),
                  title: Text(
                    pays.nom,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CountryDetailPage(pays: pays),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildFlag(Pays pays) {
    String? imageUrl;
    if (pays.codePays != null && pays.codePays!.isNotEmpty) {
      imageUrl = "https://flagcdn.com/w80/${pays.codePays!.toLowerCase()}.png";
    } else if (pays.drapeauUrl != null && pays.drapeauUrl!.isNotEmpty) {
      imageUrl = pays.drapeauUrl;
    }

    if (imageUrl != null) {
      return SizedBox(
        width: 50,
        height: 30,
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          placeholder: (context, url) => const CircularProgressIndicator(),
          errorWidget: (context, url, error) => const Icon(Icons.flag),
          fit: BoxFit.cover,
        ),
      );
    } else {
      return const Icon(Icons.flag, size: 40);
    }
  }
}
