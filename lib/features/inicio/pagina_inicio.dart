import 'package:flutter/material.dart';
import 'package:proyectomuebleria/common/widgets/marco.dart';
import 'package:proyectomuebleria/datos.dart';
import 'package:proyectomuebleria/features/inicio/widgets/cuenta_list_item.dart';
import 'package:proyectomuebleria/tema.dart';

class PaginaInicio extends StatelessWidget {
  const PaginaInicio({super.key});

  @override
  Widget build(BuildContext context) {
    return Marco(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(' Diana', style: titulo(40, color: kCafe)),
          Text(
            'MUEBLERÍA',
            style: texto(
              13,
              color: kTextoSuave,
              peso: FontWeight.w700,
            ).copyWith(letterSpacing: 5),
          ),
          const SizedBox(height: 18),
          Text('¿Quién eres?', style: texto(19, color: kTextoSuave)),
          const SizedBox(height: 24),
          SizedBox(
            height: MediaQuery.of(context).size.height / 3,
            child: ListView.builder(
              itemCount: cuentas.length,
              itemBuilder: (context, index) {
                final cuenta = cuentas[index];
                return CuentaListItem(cuenta: cuenta);
              },
            ),
          ),
        ],
      ),
    );
  }
}
