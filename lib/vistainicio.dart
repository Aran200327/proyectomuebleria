import 'package:flutter/material.dart';
import 'package:proyectomuebleria/datos.dart';
import 'package:proyectomuebleria/tema.dart';
import 'package:proyectomuebleria/vistapin.dart';

class VistaInicio extends StatelessWidget {
  const VistaInicio({super.key});
  @override
  Widget build(BuildContext context) {
    Widget persona(Cuenta cuenta) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Material(
          color: kBeige,
          borderRadius: BorderRadius.circular(24),
          child: InkWell(
            borderRadius: BorderRadius.circular(24),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => VistaPin(nombre: cuenta.nombre),
              ));
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: kCafe,
                    child: Text(cuenta.nombre[0],
                        style: titulo(24, color: Colors.white)),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(cuenta.nombre,
                            overflow: TextOverflow.ellipsis,
                            style: texto(21, peso: FontWeight.w800)),
                        Text(cuenta.rol,
                            style: texto(14, color: kTextoSuave, peso: FontWeight.w600)),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right, color: kCafe),
                ],
              ),
            ),
          ),
        ),
      );
    }
    return Marco(
      hijo: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(' Diana', style: titulo(40, color: kCafe)),
          Text('MUEBLERÍA',
              style: texto(13, color: kTextoSuave, peso: FontWeight.w700)
                  .copyWith(letterSpacing: 5)),
          const SizedBox(height: 18),
          Text('¿Quién eres?', style: texto(19, color: kTextoSuave)),
          const SizedBox(height: 24),
          for (final c in cuentas) persona(c),
        ],
      ),
    );
  }
}