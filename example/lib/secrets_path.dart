import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

Future<String> getSecretsFilePath([String filename = 'secrets.db']) async {
  final appDir = await getApplicationDocumentsDirectory();
  return path.join(appDir.path, filename);
}
