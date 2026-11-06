import 'package:flutter/material.dart';
import 'package:proyectomuebleria/tema.dart';

class OlvidasteTuPinDialog extends StatelessWidget {
  const OlvidasteTuPinDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (_) => const OlvidasteTuPinDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: kTarjeta,
      title: Text('¿Olvidaste tu PIN?', style: titulo(22)),
      content: Text(
        'Pide a Esthefany (la dueña) que restablezca tu PIN.',
        style: texto(16, color: kTextoSuave),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            'Entendido',
            style: texto(16, color: kCafe, peso: FontWeight.w800),
          ),
        ),
      ],
    );
  }
}
