import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/pays.dart';

class CountryDetailPage extends StatelessWidget {
  final Pays pays;

  const CountryDetailPage({super.key, required this.pays});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(pays.nom)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Grand drapeau
            Center(child: _buildLargeFlag(pays)),
            const SizedBox(height: 20),

            // Informations
            _buildInfoRow("Capitale", pays.capitale),
            _buildInfoRow("Population", pays.population),
            _buildInfoRow("Superficie", pays.superficie),
            _buildInfoRow("Langue officielle", pays.langues),
          ],
        ),
      ),
    );
  }

  Widget _buildLargeFlag(Pays pays) {
    String? imageUrl;
    if (pays.codePays != null && pays.codePays!.isNotEmpty) {
      imageUrl = "https://flagcdn.com/w320/${pays.codePays!.toLowerCase()}.png";
    } else if (pays.drapeauUrl != null && pays.drapeauUrl!.isNotEmpty) {
      imageUrl = pays.drapeauUrl;
    }

    if (imageUrl != null) {
      return CachedNetworkImage(
        imageUrl: imageUrl,
        placeholder: (context, url) => const CircularProgressIndicator(),
        errorWidget: (context, url, error) =>
            Image.asset('assets/Tunisia_Big.png'), // Fallback to asset
        height: 200,
        fit: BoxFit.cover,
      );
    } else {
      // Fallback if no URL
      return Image.asset(
        'assets/Tunisia_Big.png',
        height: 200,
        fit: BoxFit.cover,
      );
    }
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$label : ",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 18))),
        ],
      ),
    );
  }
}
