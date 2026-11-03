import 'package:flutter/material.dart';
import 'package:proyectomuebleria/datos.dart';
import 'package:proyectomuebleria/tema.dart';

class VistaAreas extends StatefulWidget {
  const VistaAreas({super.key});
  @override
  State<VistaAreas> createState() => _VistaAreasState();
}

class _VistaAreasState extends State<VistaAreas> {
  int area = 0;
  String trabajador = 'Don Pepe';
  int entran = 0;
  int salen = 0;
  final nota = TextEditingController();
  final nuevo = TextEditingController();
  @override
  void dispose() {
    nota.dispose();
    nuevo.dispose();
    super.dispose();
  }
  void cambiarArea(int i) {
    setState(() {
      area = i;
      trabajador = trabajadoresDe(areas[i]).first.nombre;
      entran = 0;
      salen = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final lista_ = trabajadoresDe(areas[area]);
    final Color colorArea = coloresEtapa[area];

    Widget botonesArea() {
      return Wrap(
        spacing: 10,
        runSpacing: 10,
        children: [
          for (int i = 0; i < areas.length; i++)
            chip(areas[i], area == i, () => cambiarArea(i), color: coloresEtapa[i]),
        ],
      );
    }

    // form
    Widget formulario() {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: colorArea,
          borderRadius: BorderRadius.circular(26),
          boxShadow: const [
            BoxShadow(color: Color(0xFFDDCBBB), offset: Offset(0, 6)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(area == 0 ? 'Registrar entrada de maquila' : 'Registrar trabajo',
                style: titulo(22)),
            const SizedBox(height: 14),
            campoFijo('Fecha', hoy),
            const SizedBox(height: 14),
            Text('Trabajador',
                style: texto(14, color: kTextoSuave, peso: FontWeight.w700)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final t in lista_)
                  chip(t.nombre, trabajador == t.nombre,
                          () => setState(() => trabajador = t.nombre),
                      color: kTarjeta),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: contador('Piezas que entran', entran,
                          (v) => setState(() => entran = v)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: contador('Piezas que salen', salen,
                          (v) => setState(() => salen = v)),
                ),
              ],
            ),
            const SizedBox(height: 14),
            campo('Nota (opcional)', hint: 'Nota', controlador: nota),
            const SizedBox(height: 16),
            boton('Guardar', () {
              final t = lista_.firstWhere((x) => x.nombre == trabajador);
              setState(() {
                t.entran += entran;
                t.salen += salen;
                entran = 0;
                salen = 0;
                nota.clear();
              });
              aviso(context, 'Registro guardado para ${t.nombre}');
            }),
            const Divider(height: 30, color: kBorde),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: nuevo,
                    style: texto(16, peso: FontWeight.w600),
                    decoration: decoracion('Agregar trabajador'),
                  ),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  height: 52,
                  width: 52,
                  child: FilledButton(
                    onPressed: () {
                      final n = nuevo.text.trim();
                      if (n.isEmpty) return;
                      setState(() {
                        trabajadores.add(Trabajador(n, areas[area], 0, 0));
                        trabajador = n;
                        nuevo.clear();
                      });
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: kBeige,
                      foregroundColor: kTexto,
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                    ),
                    child: const Icon(Icons.add),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }

    //resumen diario
    Widget resumen() {
      return tarjeta(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Resumen del día', style: titulo(22)),
            const SizedBox(height: 14),
            for (final t in lista_) ...[
              Row(
                children: [
                  Text(t.nombre, style: texto(16, peso: FontWeight.w800)),
                  const Spacer(),
                  Text('Entran ${t.entran} · Salen ${t.salen} · ',
                      style: texto(13, color: kTextoSuave)),
                  Text('Pend. ${t.pendientes}',
                      style: texto(13, color: kCafe, peso: FontWeight.w800)),
                ],
              ),
              const SizedBox(height: 6),
              barra(t.entran == 0 ? 0 : t.salen / t.entran),
              const SizedBox(height: 14),
            ],
          ],
        ),
      );
    }

    //registros
    Widget registros() {
      final conTrabajo = lista_.where((t) => t.entran > 0).toList();
      Widget fila(String a, String b, String c, {bool encabezado = false}) {
        final estilo = encabezado
            ? texto(14, color: kCafe, peso: FontWeight.w800)
            : texto(15);
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              Expanded(flex: 4, child: Text(a, style: estilo)),
              Expanded(flex: 2, child: Text(b, style: estilo)),
              Expanded(flex: 2, child: Text(c, style: estilo)),
            ],
          ),
        );
      }
      return tarjeta(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Registros', style: titulo(22)),
            const SizedBox(height: 10),
            fila('Trabajador', 'Entran', 'Salen', encabezado: true),
            for (final t in conTrabajo) ...[
              const Divider(height: 1, color: kBorde),
              fila(t.nombre, '${t.entran}', '${t.salen}'),
            ],
          ],
        ),
      );
    }
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text('Áreas y trabajadores', style: titulo(30)),
        const SizedBox(height: 2),
        Text('Cuántas piezas le entran y cuántas le salen a cada quien',
            style: texto(15, color: kTextoSuave)),
        const SizedBox(height: 18),
        botonesArea(),
        const SizedBox(height: 10),
        Text(descripcionArea[area], style: texto(15, color: kTextoSuave)),
        const SizedBox(height: 16),
        formulario(),
        const SizedBox(height: 20),
        resumen(),
        const SizedBox(height: 20),
        registros(),
        const SizedBox(height: 12),
      ],
    );
  }
}