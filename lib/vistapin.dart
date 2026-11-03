import 'package:flutter/material.dart';
import 'package:proyectomuebleria/menu.dart';
import 'package:proyectomuebleria/tema.dart';

class VistaPin extends StatefulWidget {
  final String nombre;
  const VistaPin({super.key, required this.nombre});
  @override
  State<VistaPin> createState() => _VistaPinState();
}

class _VistaPinState extends State<VistaPin> {
  String pin = '';
  void tocarNumero(String numero) {
    if (pin.length >= 4) return;
    setState(() {
      pin += numero;
    });
    if (pin.length == 4) revisarPin();
  }
  void borrar() {
    if (pin.isEmpty) return;
    setState(() {
      pin = pin.substring(0, pin.length - 1);
    });
  }
  //validar pin
  void revisarPin() {
    if (pin == '1234') {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => Menu(nombre: widget.nombre)),
            (_) => false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('PIN incorrecto',
              style: texto(15, color: Colors.white, peso: FontWeight.w600)),
          backgroundColor: kRojo,
          behavior: SnackBarBehavior.floating,
        ),
      );
      setState(() {
        pin = '';
      });
    }
  }
  void olvidePin() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: kTarjeta,
        title: Text('¿Olvidaste tu PIN?', style: titulo(22)),
        content: Text(
          'Pide a Esthefany (la dueña) que restablezca tu PIN.',
          style: texto(16, color: kTextoSuave),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Entendido',
                style: texto(16, color: kCafe, peso: FontWeight.w800)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget circulos() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (int i = 0; i < 4; i++)
            Container(
              width: 24,
              height: 24,
              margin: const EdgeInsets.symmetric(horizontal: 9),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: i < pin.length ? kCafe : kFondo,
                border: Border.all(color: kBeige, width: 2),
              ),
            ),
        ],
      );
    }

    Widget tecla(Widget contenido, VoidCallback alTocar) {
      return ElevatedButton(
        onPressed: alTocar,
        style: ElevatedButton.styleFrom(
          backgroundColor: kBeige,
          foregroundColor: kTexto,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        ),
        child: contenido,
      );
    }

    Widget numero(String n) {
      return tecla(
        Text(n, style: texto(28, peso: FontWeight.w800)),
            () => tocarNumero(n),
      );
    }

    return Marco(
      hijo: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Diana', style: titulo(36, color: kCafe)),
          const SizedBox(height: 4),
          Text('Hola ${widget.nombre}, escribe tu PIN',
              textAlign: TextAlign.center,
              style: texto(17, color: kTextoSuave)),
          const SizedBox(height: 26),
          circulos(),
          const SizedBox(height: 28),
          GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.4,
            children: [
              for (final n in ['1', '2', '3', '4', '5', '6', '7', '8', '9']) numero(n),
              const SizedBox(),
              numero('0'),
              tecla(const Icon(Icons.backspace_outlined, size: 26), borrar),
            ],
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: () => Navigator.of(context).pop(), // regresa al inicio
            child: Text('Cambiar de persona',
                style: texto(16, color: kTextoSuave, peso: FontWeight.w600)),
          ),
          TextButton(
            onPressed: olvidePin,
            child: Text('¿Olvidaste tu PIN?',
                style: texto(16, color: kCafe, peso: FontWeight.w700)),
          ),
        ],
      ),
    );
  }
}