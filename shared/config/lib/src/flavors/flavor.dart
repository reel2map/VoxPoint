enum FlavorStatus {
  development,
  testing,
  demo,
  production;

  bool get isDev => this == development;
}

class Flavor {
  static FlavorStatus status = FlavorStatus.development;
}
