/// Valores fijos que usa la pantalla de login.
///
/// Tenerlos en un solo lugar evita "números mágicos" repetidos en los widgets.
abstract class LoginConstants {
  /// Cantidad de dígitos que tiene un PIN.
  static const pinLength = 4;

  /// PIN de demostración.
  ///
  /// En una app real el PIN NUNCA va en el código.
  static const demoPin = '1234';
}
