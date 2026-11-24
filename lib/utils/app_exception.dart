/// A hiba fajtaja, ebbol dont a UI a megjelenitett uzenetrol.
enum AppErrorType {
  noConnection,
  timeout,
  server,
  invalidData,
  storage,
  unknown
}

/// Az adatreteg altal visszaadott hiba. A repository az eredeti (pl. Dio)
/// kiveteleket erre alakitja, igy a felsobb retegek nem fuggnek a HTTP
/// klienstol.
class AppException implements Exception {
  const AppException(this.type, [this.details]);

  final AppErrorType type;

  /// Fejlesztoi reszletek naplozashoz, a felhasznalonak nem mutatjuk.
  final String? details;

  /// Hasznos-e ujraprobalni a kerest (pl. halozati hibanal igen).
  bool get isRetryable =>
      type == AppErrorType.noConnection ||
      type == AppErrorType.timeout ||
      type == AppErrorType.server;

  @override
  String toString() =>
      'AppException($type${details == null ? '' : ': $details'})';
}
