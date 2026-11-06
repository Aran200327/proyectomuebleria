import 'package:flutter/material.dart';
import 'package:proyectomuebleria/features/login/constants/constants.dart';
import 'package:proyectomuebleria/tema.dart';

class PinLabel extends StatelessWidget {
  const PinLabel({
    required this.digitosEscritos,
    this.digitosTotales = LoginConstants.pinLength,
    super.key,
  });

  /// Cuantos círculos se han pintado
  final int digitosEscritos;

  /// Cuántos círculos dibujar en total.
  final int digitosTotales;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 0; i < digitosTotales; i++)
          _PinDot(isFilled: i < digitosEscritos),
      ],
    );
  }
}

class _PinDot extends StatelessWidget {
  const _PinDot({required this.isFilled});

  final bool isFilled;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      width: 24,
      height: 24,
      margin: const EdgeInsets.symmetric(horizontal: 9),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isFilled ? kCafe : kFondo,
        border: Border.all(color: kBeige, width: 2),
      ),
    );
  }
}
