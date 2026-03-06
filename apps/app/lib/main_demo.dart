import 'package:app/main.dart' as runner;
import 'package:config/config.dart';

Future<void> main() async {
  Flavor.status = FlavorStatus.demo;

  await runner.main();
}
