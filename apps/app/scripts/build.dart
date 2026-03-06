// ignore_for_file: avoid_print

import 'dart:io';

import 'package:path/path.dart' as p;

void main(List<String> args) async {
  String buildType = 'apk';

  if (args.isNotEmpty && (args[0] == 'apk' || args[0] == 'aab')) {
    buildType = args[0];
  }

  final file = File('pubspec.yaml');

  if (!file.existsSync()) {
    print('pubspec.yaml не найден');
    exit(1);
  }

  final lines = await file.readAsLines();
  final updatedLines = <String>[];

  final versionRegExp = RegExp(r'version:\s*(\d+\.\d+\.\d+)\+(\d+)');

  String appVersion = '';

  for (final line in lines) {
    final match = versionRegExp.firstMatch(line);
    if (match != null) {
      final version = match.group(1)!;
      final buildNumber = int.parse(match.group(2)!);
      final newBuildNumber = buildNumber + 1;
      final newLine = 'version: $version+$newBuildNumber';

      appVersion = '$version+$newBuildNumber';
      updatedLines.add(newLine);
      print('✅ Обновлено: $newLine');
    } else {
      updatedLines.add(line);
    }
  }

  await file.writeAsString(updatedLines.join('\n'));

  await _build('development', buildType);
  await _build('staging', buildType);
  await _build('production', buildType);

  await _rename(appVersion, buildType);
}

Future<void> _build(String type, String buildType) async {
  print(
    'Начало сборки flutter ${['build', buildType, '--release', '--flavor=$type', '--target=lib/main_$type.dart'].join(' ')}',
  );

  final process = await Process.start('flutter', [
    'build',
    buildType,
    '--release',
    '--flavor=$type',
    '--target=lib/main_$type.dart',
  ], runInShell: true);

  // Читаем stdout
  process.stdout.transform(const SystemEncoding().decoder).listen((data) {
    stdout.write(data); // Показываем в терминале
  });

  // Читаем stderr
  process.stderr.transform(const SystemEncoding().decoder).listen((data) {
    stderr.write(data); // Показываем в терминале
  });

  final exitCode = await process.exitCode;
  if (exitCode == 0) {
    print('\n✅ Сборка $type завершена успешно.');
  } else {
    print('\n❌ Сборка $type завершилась с ошибкой. Код: $exitCode');
  }
}

Future<void> _rename(String appVersion, String buildType) async {
  if (buildType == 'apk') {
    await _renameAPK(appVersion);
  }

  if (buildType == 'aab') {
    await _renameAAB(appVersion);
  }
}

Future<void> _renameAPK(String appVersion) async {
  final apkFolderPath = p.join(
    Directory.current.path,
    'build',
    'app',
    'outputs',
    'flutter-apk',
  );

  final prodBuildPath = p.join(apkFolderPath, 'app-production-release.apk');
  final stageBuildPath = p.join(apkFolderPath, 'app-staging-release.apk');
  final devBuildPath = p.join(apkFolderPath, 'app-development-release.apk');

  if (File(prodBuildPath).existsSync()) {
    await File(
      prodBuildPath,
    ).rename(p.join(apkFolderPath, 'app_prod_release_$appVersion.apk'));
  }

  if (File(devBuildPath).existsSync()) {
    await File(
      devBuildPath,
    ).rename(p.join(apkFolderPath, 'app_dev_release_$appVersion.apk'));
  }

  if (File(stageBuildPath).existsSync()) {
    await File(
      stageBuildPath,
    ).rename(p.join(apkFolderPath, 'app_test_release_$appVersion.apk'));
  }

  print('✅ Файлы успешно переименованы!');
}

Future<void> _renameAAB(String appVersion) async {
  final aabFolderPath = p.join(
    Directory.current.path,
    'build',
    'app',
    'outputs',
    'bundle',
  );

  final prodBuildPath = p.join(
    aabFolderPath,
    'prodRelease',
    'app-production-release.aab',
  );
  final devBuildPath = p.join(
    aabFolderPath,
    'devRelease',
    'app-development-release.aab',
  );

  if (File(prodBuildPath).existsSync()) {
    await File(prodBuildPath).rename(
      p.join(aabFolderPath, 'prodRelease', 'app_prod_release_$appVersion.aab'),
    );
  }

  if (File(devBuildPath).existsSync()) {
    await File(devBuildPath).rename(
      p.join(aabFolderPath, 'devRelease', 'app_dev_release_$appVersion.aab'),
    );
  }

  print('✅ Файлы успешно переименованы!');
}
