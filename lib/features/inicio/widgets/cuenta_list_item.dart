import 'package:flutter/material.dart';
import 'package:proyectomuebleria/datos.dart';
import 'package:proyectomuebleria/tema.dart';
import 'package:proyectomuebleria/features/login/login_page.dart';

class CuentaListItem extends StatelessWidget {
  const CuentaListItem({required this.cuenta, super.key});

  final Cuenta cuenta;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Material(
        color: kBeige,
        borderRadius: BorderRadius.circular(24),
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => LoginPage(nombre: cuenta.nombre),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: kCafe,
                  child: Text(
                    cuenta.nombre[0],
                    style: titulo(24, color: Colors.white),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        cuenta.nombre,
                        overflow: TextOverflow.ellipsis,
                        style: texto(21, peso: FontWeight.w800),
                      ),
                      Text(
                        cuenta.rol,
                        style: texto(
                          14,
                          color: kTextoSuave,
                          peso: FontWeight.w600,
                        ),
                      ),
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
}
