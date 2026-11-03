import 'package:flutter/material.dart';
import 'package:proyectomuebleria/datos.dart';
import 'package:proyectomuebleria/tema.dart';

class VistaCuentas extends StatefulWidget {
  final String nombre;
  const VistaCuentas({super.key, required this.nombre});
  @override
  State<VistaCuentas> createState() => _VistaCuentasState();
}

class _VistaCuentasState extends State<VistaCuentas> {
  final actual = TextEditingController();
  final nuevoPin = TextEditingController();
  final repite = TextEditingController();
  final nueva = TextEditingController();
  @override
  void dispose() {
    actual.dispose();
    nuevoPin.dispose();
    repite.dispose();
    nueva.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final duena = esDuena(widget.nombre);
    final rol = cuentas.firstWhere((c) => c.nombre == widget.nombre).rol;

    //cambiar pin
    Widget cambiarPin() {
      return tarjeta(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Cambiar mi PIN', style: titulo(22)),
            const SizedBox(height: 14),
            campo('PIN actual', controlador: actual, oculto: true, numerico: true, maximo: 4),
            const SizedBox(height: 14),
            campo('PIN nuevo', controlador: nuevoPin, oculto: true, numerico: true, maximo: 4),
            const SizedBox(height: 14),
            campo('Repite el PIN nuevo', controlador: repite, oculto: true, numerico: true, maximo: 4),
            const SizedBox(height: 18),
            boton('Guardar PIN', () {
              actual.clear();
              nuevoPin.clear();
              repite.clear();
              aviso(context, 'PIN actualizado');
            }),
          ],
        ),
      );
    }

    Widget filaCuenta(Cuenta c) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: kCafe,
                  child: Text(c.nombre[0], style: titulo(17, color: Colors.white)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(c.nombre,
                          overflow: TextOverflow.ellipsis,
                          style: texto(17, peso: FontWeight.w800)),
                      Text(c.rol, style: texto(13, color: kTextoSuave)),
                    ],
                  ),
                ),
              ],
            ),
            if (c.rol != 'Dueña')
              Padding(
                padding: const EdgeInsets.only(left: 52, top: 10),
                child: Row(
                  children: [
                    TextButton(
                      onPressed: () => aviso(context, 'PIN de ${c.nombre} restablecido'),
                      style: TextButton.styleFrom(backgroundColor: kBeige),
                      child: Text('Restablecer PIN',
                          style: texto(13, color: kTexto, peso: FontWeight.w800)),
                    ),
                    const SizedBox(width: 8),
                    TextButton(
                      onPressed: () => setState(() => cuentas.remove(c)),
                      style: TextButton.styleFrom(backgroundColor: kBeige),
                      child: Text('Quitar',
                          style: texto(13, color: kRojo, peso: FontWeight.w800)),
                    ),
                  ],
                ),
              ),
          ],
        ),
      );
    }

    //apartado y permisos dueña
    Widget encargadas() {
      return tarjeta(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Encargadas', style: titulo(22)),
            const SizedBox(height: 6),
            for (int i = 0; i < cuentas.length; i++) ...[
              if (i > 0) const Divider(height: 1, color: kBorde),
              filaCuenta(cuentas[i]),
            ],
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: nueva,
                    style: texto(16, peso: FontWeight.w600),
                    decoration: decoracion('Nombre de la nueva encargada'),
                  ),
                ),
                const SizedBox(width: 10),
                FilledButton(
                  onPressed: () {
                    final n = nueva.text.trim();
                    if (n.isEmpty) return;
                    setState(() {
                      cuentas.add(Cuenta(n, 'Encargada'));
                      nueva.clear();
                    });
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: kCafe,
                    minimumSize: const Size(0, 52),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: Text('Agregar',
                      style: texto(15, color: Colors.white, peso: FontWeight.w800)),
                ),
              ],
            ),
          ],
        ),
      );
    }

    //alertas
    Widget soloDuena() {
      return tarjeta(
        Row(
          children: [
            const Icon(Icons.lock_outline, color: kCafe),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Solo Esthefany (la dueña) puede agregar, quitar o restablecer el PIN de las encargadas.',
                style: texto(15, color: kTextoSuave),
              ),
            ),
          ],
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kBeige,
        surfaceTintColor: kBeige,
        iconTheme: const IconThemeData(color: kCafe),
        title: Text('Mi cuenta', style: titulo(22, color: kCafe)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text('Mi cuenta', style: titulo(30)),
          const SizedBox(height: 2),
          Text('${widget.nombre} · $rol', style: texto(15, color: kTextoSuave)),
          const SizedBox(height: 20),
          cambiarPin(),
          const SizedBox(height: 20),
          if (duena) encargadas() else soloDuena(),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}