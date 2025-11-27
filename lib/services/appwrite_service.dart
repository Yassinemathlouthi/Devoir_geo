import 'package:appwrite/appwrite.dart';
import '../models/pays.dart';

class AppwriteService {
  static const String endpoint =
      'https://cloud.appwrite.io/v1';
  static const String projectId = '6928047500199505f6e7';
  static const String databaseId = '692805150011f8997a10';
  static const String collectionId = 'grot';

  final Client client = Client();
  late final Databases databases;

  AppwriteService() {
    client.setEndpoint(endpoint).setProject(projectId);
    databases = Databases(client);
  }

  Future<List<Pays>> getPays() async {
    try {
      final response = await databases.listDocuments(
        databaseId: databaseId,
        collectionId: collectionId,
      );

      return response.documents.map((doc) {
        return Pays.fromMap(doc.data, doc.$id);
      }).toList();
    } catch (e) {
      print('Error fetching countries: $e');
      throw e;
    }
  }
}
