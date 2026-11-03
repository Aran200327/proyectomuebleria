import 'package:flutter/material.dart';
import 'package:proyectomuebleria/datos.dart';
import 'package:proyectomuebleria/tema.dart';

class VistaInventario extends StatefulWidget {
  final bool esDuena;
  final void Function(int) irA;
  const VistaInventario({super.key, required this.esDuena, required this.irA});
  @override
  State<VistaInventario> createState() => _VistaInventarioState();
}

class _VistaInventarioState extends State<VistaInventario> {
  bool entrada = true; // true = Entrada, false = Salida
  String material = insumos.first.nombre;
  int cantidad = 1;
  final nota = TextEditingController();
  @override
  void dispose() {
    nota.dispose();
    super.dispose();
  }
  @override

  Widget build(BuildContext context) {
    //form movimiento
    Widget formulario() {
      Widget opcion(String txt, IconData icono, bool esEntrada) {
        final activa = entrada == esEntrada;
        return Expanded(
          child: GestureDetector(
            onTap: () => setState(() => entrada = esEntrada),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: activa ? kCafe : kBeige,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icono, size: 18, color: activa ? Colors.white : kTexto),
                  const SizedBox(width: 6),
                  Text(txt,
                      style: texto(16,
                          peso: FontWeight.w800,
                          color: activa ? Colors.white : kTexto)),
                ],
              ),
            ),
          ),
        );
      }

      return tarjeta(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Anotar movimiento', style: titulo(22)),
            const SizedBox(height: 14),
            Row(
              children: [
                opcion('Entrada', Icons.arrow_downward, true),
                const SizedBox(width: 12),
                opcion('Salida', Icons.arrow_upward, false),
              ],
            ),
            const SizedBox(height: 14),
            lista('Material', [for (final i in insumos) i.nombre], material,
                    (v) => setState(() => material = v)),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: contador('Cantidad', cantidad,
                          (v) => setState(() => cantidad = v),
                      minimo: 1),
                ),
                const SizedBox(width: 12),
                Expanded(child: campoFijo('Fecha', hoy)),
              ],
            ),
            const SizedBox(height: 14),
            campo('Nota o proveedor', hint: 'Nota / proveedor', controlador: nota),
            const SizedBox(height: 16),
            boton('Guardar en libro', () {
              aviso(context,
                  '${entrada ? 'Entrada' : 'Salida'} guardada: $cantidad × $material');
              setState(() {
                cantidad = 1;
                nota.clear();
              });
            }),
          ],
        ),
      );
    }

    //mueble ya listo
    Widget muebleTerminado(Terminado t) {
      final m = buscarMueble(t.mueble);
      final bajo = t.piezas < t.minimo;
      return Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: tarjeta(
          Row(
            children: [
              foto(m.ruta, 76),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(t.mueble,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: texto(17, peso: FontWeight.w800)),
                    Text('Línea ${m.linea}', style: texto(13, color: kTextoSuave)),
                    const SizedBox(height: 4),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text('${t.piezas}',
                            style: titulo(32, color: bajo ? kRojo : kCafe)),
                        const SizedBox(width: 6),
                        Text('piezas', style: texto(15, color: kTextoSuave)),
                      ],
                    ),
                  ],
                ),
              ),
              Text('mín. ${t.minimo}', style: texto(13, color: kTextoSuave)),
            ],
          ),
          relleno: 14,
        ),
      );
    }

    //material
    Widget tarjetaInsumo(Insumo i) {
      return Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: i.bajo ? kRojoFondo : kTarjeta,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: i.bajo ? kRojoBorde : kBorde, width: 1.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(i.nombre, style: texto(17, peso: FontWeight.w800)),
                ),
                Text(i.area, style: texto(13, color: kTextoSuave)),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text('${i.cantidad}', style: titulo(30, color: kCafe)),
                const SizedBox(width: 6),
                Text(i.unidad, style: texto(15, color: kTextoSuave)),
                const Spacer(),
                Text('mín. ${i.minimo}', style: texto(13, color: kTextoSuave)),
              ],
            ),
            if (i.bajo)
              Row(
                children: [
                  const Icon(Icons.warning_amber_rounded, color: kRojo, size: 18),
                  const SizedBox(width: 6),
                  Text('Pedir material para ${i.area}',
                      style: texto(14, color: kRojo, peso: FontWeight.w800)),
                ],
              ),
          ],
        ),
      );
    }

    //mueble por area
    Widget mueblesPorArea() {
      return tarjeta(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Muebles en cada área', style: titulo(22)),
            const SizedBox(height: 12),
            for (int i = 0; i < areas.length; i++)
              for (final p in pedidos.where((p) => p.etapa == i))
                Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: coloresEtapa[i],
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(areas[i], style: texto(16, peso: FontWeight.w800)),
                            Text(p.mueble.nombre,
                                overflow: TextOverflow.ellipsis,
                                style: texto(14, color: kTextoSuave)),
                          ],
                        ),
                      ),
                      Text('${p.piezas} pzas',
                          style: texto(15, peso: FontWeight.w800)),
                    ],
                  ),
                ),
          ],
        ),
      );
    }

    //inventario
    Widget libro() {
      Widget encabezado(String txt, int flex, {TextAlign alinear = TextAlign.left}) {
        return Expanded(
          flex: flex,
          child: Text(txt,
              textAlign: alinear,
              style: texto(13, color: kCafe, peso: FontWeight.w800)),
        );
      }
      return tarjeta(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Libro de inventario', style: titulo(22)),
            const SizedBox(height: 14),
            Row(
              children: [
                encabezado('Fecha / Material', 5),
                encabezado('Cant.', 2, alinear: TextAlign.center),
                encabezado('Encargada', 3),
              ],
            ),
            for (final m in movimientos) ...[
              const Divider(height: 22, color: kBorde),
              Row(
                children: [
                  Expanded(
                    flex: 5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(m.fecha, style: texto(12, color: kTextoSuave)),
                        Text(m.material, style: texto(14, peso: FontWeight.w700)),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(m.cantidad,
                        textAlign: TextAlign.center,
                        style: texto(17,
                            peso: FontWeight.w800,
                            color: m.cantidad.startsWith('+') ? kVerde : kRojo)),
                  ),
                  Expanded(flex: 3, child: Text(m.encargada, style: texto(14))),
                ],
              ),
            ],
          ],
        ),
      );
    }
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text('Inventario', style: titulo(30)),
        const SizedBox(height: 2),
        Text('Libro diario de entradas y salidas',
            style: texto(15, color: kTextoSuave)),
        const SizedBox(height: 20),
        formulario(),
        seccion('Muebles terminados'),
        for (final t in terminados) muebleTerminado(t),
        seccion('Materiales'),
        for (final i in insumos) tarjetaInsumo(i),
        const SizedBox(height: 16),
        mueblesPorArea(),
        const SizedBox(height: 20),
        libro(),
        if (widget.esDuena) ...[
          const SizedBox(height: 20),
          boton('Ver reporte de producción', () => widget.irA(4),
              icono: Icons.bar_chart_rounded),
        ],
        const SizedBox(height: 12),
      ],
    );
  }
}