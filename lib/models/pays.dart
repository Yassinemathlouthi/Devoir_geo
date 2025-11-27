class Pays {
  final String id;
  final String nom;
  final String capitale;
  final String population;
  final String superficie;
  final String langues;
  final String? codePays;
  final String? drapeauUrl;

  Pays({
    required this.id,
    required this.nom,
    required this.capitale,
    required this.population,
    required this.superficie,
    required this.langues,
    this.codePays,
    this.drapeauUrl,
  });

  factory Pays.fromMap(Map<String, dynamic> map, String id) {
    return Pays(
      id: id,
      nom: map['nom'] ?? 'Inconnu',
      capitale: map['capitale'] ?? 'Inconnue',
      population: map['population']?.toString() ?? 'Inconnue',
      superficie: map['superficie']?.toString() ?? 'Inconnue',
      langues: map['langues'] ?? map['langue'] ?? 'Inconnue',
      codePays: map['code_pays'],
      drapeauUrl: map['drapeau_url'],
    );
  }
}
