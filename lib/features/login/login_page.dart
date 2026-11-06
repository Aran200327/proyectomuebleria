import 'package:flutter/material.dart';
import 'package:proyectomuebleria/common/widgets/marco.dart';
import 'package:proyectomuebleria/features/login/constants/constants.dart';
import 'package:proyectomuebleria/features/login/widgets/olvidaste_tu_pin_dialog.dart';
import 'package:proyectomuebleria/features/login/widgets/pin_keyboard.dart';
import 'package:proyectomuebleria/features/login/widgets/pin_label.dart';
import 'package:proyectomuebleria/menu.dart';
import 'package:proyectomuebleria/tema.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({required this.nombre, super.key});

  /// Nombre de la cuenta que eligió la persona en la pantalla anterior.
  final String nombre;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _pin = '';

  void tocar(String number) {
    if (_pin.length >= LoginConstants.pinLength) return;

    setState(() => _pin += number);

    if (_pin.length == LoginConstants.pinLength) _validarPin();
  }

  void borrar() {
    if (_pin.isEmpty) return;
    setState(() => _pin = _pin.substring(0, _pin.length - 1));
  }

  void cambiarDePersona() => Navigator.of(context).pop();

  void _olvidasteTuPin() => OlvidasteTuPinDialog.show(context);

  void _validarPin() {
    if (_pin == LoginConstants.demoPin) {
      _entrarAlHome();
    } else {
      _mostrarPinIncorrecto();
      setState(() => _pin = '');
    }
  }

  void _entrarAlHome() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute<void>(builder: (_) => Menu(nombre: widget.nombre)),
      (_) => false,
    );
  }

  void _mostrarPinIncorrecto() {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            'PIN incorrecto',
            style: texto(15, color: Colors.white, peso: FontWeight.w600),
          ),
          backgroundColor: kRojo,
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Marco(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Diana', style: titulo(36, color: kCafe)),
          const SizedBox(height: 4),
          Text(
            'Hola ${widget.nombre}, escribe tu PIN',
            textAlign: TextAlign.center,
            style: texto(17, color: kTextoSuave),
          ),
          const SizedBox(height: 26),
          PinLabel(digitosEscritos: _pin.length),
          const SizedBox(height: 28),
          TecladoPin(alTocar: tocar, alBorrar: borrar),
          const SizedBox(height: 12),
          TextButton(
            onPressed: cambiarDePersona,
            child: Text(
              'Cambiar de persona',
              style: texto(16, color: kTextoSuave, peso: FontWeight.w600),
            ),
          ),
          TextButton(
            onPressed: _olvidasteTuPin,
            child: Text(
              '¿Olvidaste tu PIN?',
              style: texto(16, color: kCafe, peso: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}
