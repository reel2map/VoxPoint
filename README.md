dart pub global activate melos

melos bootstrap

Полный перезапуск

```bash
rm -r **/.dart_tool && rm -r **/pubspec.lock && rm -r **/*.g.dart && rm -r **/*.freezed.dart && rm -r **/*.gr.dart && melos bootstrap
```
Android build
```bash
flutter build apk --release --flavor=development --target=lib/main_development.dart
flutter build apk --release --flavor=staging --target=lib/main_staging.dart
flutter build apk --release --flavor=production --target=lib/main_production.dart
```

```bash
flutter build appbundle --release --flavor=development --target=lib/main_development.dart
flutter build appbundle --release --flavor=staging --target=lib/main_staging.dart
flutter build appbundle --release --flavor=production --target=lib/main_production.dart
```