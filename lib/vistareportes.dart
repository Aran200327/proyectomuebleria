import 'package:flutter/material.dart';
import 'package:proyectomuebleria/datos.dart';
import 'package:proyectomuebleria/tema.dart';

class VistaReportes extends StatefulWidget {
  final void Function(int) irA;
  const VistaReportes({super.key, required this.irA});

  @override
  State<VistaReportes> createState() => _VistaReportesState();
}

class _VistaReportesState extends State<VistaReportes> {
  int rango = 2;
  String area = 'Todas';
  static const rangos = [
    ('Hoy', '03/11/2026', '03/11/2026', '3 nov 2026'),
    ('Últimos 7 días', '27/10/2026', '03/11/2026', '27 oct — 3 nov 2026'),
    ('Últimos 30 días', '04/10/2026', '03/11/2026', '4 oct — 3 nov 2026'),
    ('Este año', '01/01/2026', '03/11/2026', '1 ene — 3 nov 2026'),
  ];

  List<MapEntry<String, int>> ranking(
      List<Pedido> lista, String Function(Pedido) clave) {
    final mapa = <String, int>{};
    for (final p in lista) {
      mapa[clave(p)] = (mapa[clave(p)] ?? 0) + p.piezas;
    }
    final resultado = mapa.entries.toList();
    resultado.sort((a, b) => b.value.compareTo(a.value));
    return resultado;
  }

  @override
  Widget build(BuildContext context) {
    final lista_ = area == 'Todas'
        ? pedidos
        : pedidos.where((p) => etapas[p.etapa] == area).toList();
    final areasVisibles = area == 'Todas' ? areas : [area];
    final trabajadoresVisibles =
    trabajadores.where((t) => areasVisibles.contains(t.area)).toList();

    int piezasPedidas = lista_.fold(0, (s, p) => s + p.piezas);
    int entraron = trabajadoresVisibles.fold(0, (s, t) => s + t.entran);
    int salieron = trabajadoresVisibles.fold(0, (s, t) => s + t.salen);

    Widget filtros() {
      return tarjeta(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                for (int i = 0; i < rangos.length; i++)
                  chip(rangos[i].$1, rango == i, () => setState(() => rango = i)),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: campoFijo('Desde', rangos[rango].$2)),
                const SizedBox(width: 12),
                Expanded(child: campoFijo('Hasta', rangos[rango].$3)),
              ],
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                chip('Todas', area == 'Todas', () => setState(() => area = 'Todas')),
                for (int i = 0; i < areas.length; i++)
                  chip(areas[i], area == areas[i],
                          () => setState(() => area = areas[i]),
                      color: coloresEtapa[i]),
              ],
            ),
            const SizedBox(height: 18),
            boton('Descargar PDF', () {
              aviso(context, 'Reporte generado: ${rangos[rango].$4}');
            }, icono: Icons.picture_as_pdf_outlined),
          ],
        ),
      );
    }

    Widget dato(String nombreDato, String valor) {
      return tarjeta(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(nombreDato.toUpperCase(),
                style: texto(12, color: kTextoSuave, peso: FontWeight.w700)),
            const Spacer(),
            Text(valor, style: titulo(36, color: kCafe)),
          ],
        ),
        relleno: 14,
      );
    }

    Widget listaRanking(String nombreLista, List<MapEntry<String, int>> datos) {
      int total = datos.fold(0, (s, e) => s + e.value);
      return Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: kTarjeta,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: kBorde, width: 1.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: kBeige,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Text(nombreLista, style: titulo(19)),
            ),
            if (datos.isEmpty)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text('Sin datos', style: texto(15, color: kTextoSuave)),
              ),
            for (int i = 0; i < datos.length; i++) ...[
              if (i > 0) const Divider(height: 1, color: kBorde),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 14,
                      backgroundColor: i == 0 ? kCafe : kBeige,
                      child: Text('${i + 1}',
                          style: texto(13,
                              peso: FontWeight.w800,
                              color: i == 0 ? Colors.white : kTexto)),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(datos[i].key,
                          overflow: TextOverflow.ellipsis, style: texto(15)),
                    ),
                    Text('${datos[i].value} pzs',
                        style: texto(15, peso: FontWeight.w800)),
                    SizedBox(
                      width: 52,
                      child: Text(
                        total == 0
                            ? '0%'
                            : '${(datos[i].value * 100 / total).round()}%',
                        textAlign: TextAlign.right,
                        style: texto(14, color: kTextoSuave),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      );
    }

    final porTrabajador = trabajadoresVisibles.where((t) => t.salen > 0).toList();
    porTrabajador.sort((a, b) => b.salen.compareTo(a.salen));

    Widget produccionPorArea() {
      return GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.3,
        children: [
          for (final a in areasVisibles)
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: coloresEtapa[areas.indexOf(a)],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(a, style: texto(17, peso: FontWeight.w800)),
                  const Spacer(),
                  Text('Entraron ${entranEn(a)}', style: texto(14)),
                  Text('Salieron ${salenEn(a)}',
                      style: texto(14, peso: FontWeight.w800)),
                ],
              ),
            ),
        ],
      );
    }

    Widget hoja() {
      return tarjeta(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: kBeige,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('DIANA · REPORTE',
                      style: texto(12, color: kTextoSuave, peso: FontWeight.w700)
                          .copyWith(letterSpacing: 1.5)),
                  const SizedBox(height: 4),
                  Text(area == 'Todas' ? 'Todas las áreas' : 'Área: $area',
                      style: titulo(26)),
                  const SizedBox(height: 2),
                  Text(rangos[rango].$4, style: texto(15)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.25,
              children: [
                dato('Pedidos', '${lista_.length}'),
                dato('Piezas pedidas', '$piezasPedidas'),
                dato('Piezas entraron', '$entraron'),
                dato('Piezas salieron', '$salieron'),
              ],
            ),
            const SizedBox(height: 18),
            listaRanking('Colores más vendidos', ranking(lista_, (p) => p.color)),
            listaRanking('Clientes con más venta', ranking(lista_, (p) => p.cliente)),
            listaRanking('Muebles', ranking(lista_, (p) => p.mueble.nombre)),
            listaRanking('Piezas terminadas por trabajador', [
              for (final t in porTrabajador) MapEntry('${t.nombre} · ${t.area}', t.salen),
            ]),
            Text('Producción por área', style: titulo(22)),
            const SizedBox(height: 12),
            produccionPorArea(),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: Text('Generado el 3 nov 2026',
                  style: texto(13, color: kTextoSuave)),
            ),
          ],
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text('Reportes', style: titulo(30)),
        const SizedBox(height: 2),
        Text('Elige las fechas y el área', style: texto(15, color: kTextoSuave)),
        const SizedBox(height: 20),
        filtros(),
        const SizedBox(height: 20),
        hoja(),
        const SizedBox(height: 20),
        boton('Ver inventario', () => widget.irA(3),
            relleno: false, icono: Icons.view_in_ar_outlined),
        const SizedBox(height: 12),
      ],
    );
  }
}