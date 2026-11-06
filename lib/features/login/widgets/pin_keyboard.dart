import 'package:flutter/material.dart';
import 'package:proyectomuebleria/tema.dart';

class TecladoPin extends StatelessWidget {
  const TecladoPin({
    required this.alTocar,
    required this.alBorrar,
    super.key,
  });

  /// Se llama cada vez que el usuario toca una tecla numérica.
  /// Recibe un solo dígito ('0'–'9'), no el PIN completo.
  final void Function(String digito) alTocar;

  final VoidCallback alBorrar;

  static const _numeros = ['1', '2', '3', '4', '5', '6', '7', '8', '9'];

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.4,
      children: [
        for (final number in _numeros)
          _NumberKey(number: number, onPressed: alTocar),
        const SizedBox.shrink(),
        _NumberKey(number: '0', onPressed: alTocar),
        _PinKey(
          onPressed: alBorrar,
          child: const Icon(
            Icons.backspace_outlined,
            size: 26,
            semanticLabel: 'Borrar',
          ),
        ),
      ],
    );
  }
}

class _NumberKey extends StatelessWidget {
  const _NumberKey({required this.number, required this.onPressed});

  final String number;
  final void Function(String digito) onPressed;

  @override
  Widget build(BuildContext context) {
    return _PinKey(
      onPressed: () => onPressed(number),
      child: Text(number, style: texto(28, peso: FontWeight.w800)),
    );
  }
}

class _PinKey extends StatelessWidget {
  const _PinKey({required this.child, required this.onPressed});

  final Widget child;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: kBeige,
        foregroundColor: kTexto,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
      child: child,
    );
  }
}
