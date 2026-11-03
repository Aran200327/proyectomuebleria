import 'package:flutter/material.dart';
import 'package:proyectomuebleria/datos.dart';
import 'package:proyectomuebleria/tema.dart';

class VistaPanel extends StatelessWidget {
  final String nombre;
  final bool esDuena;
  final void Function(int) irA;

  const VistaPanel({
    super.key,
    required this.nombre,
    required this.esDuena,
    required this.irA,
  });
  @override
  Widget build(BuildContext context) {
    final bajos = insumos.where((i) => i.bajo).toList();
    final enProceso = pedidos.where((p) => p.etapa < 4).toList();
    int entraron = 0;
    int salieron = 0;
    for (final a in areas) {
      entraron += entranEn(a);
      salieron += salenEn(a);
    }

    //alerta
    Widget alerta() {
      if (bajos.isEmpty) return const SizedBox();
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: kRojoFondo,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: kRojoBorde, width: 1.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.warning_amber_rounded, color: kRojo),
                const SizedBox(width: 8),
                Expanded(
                  child: Text('Pedir material para ${bajos.first.area}',
                      style: texto(18, color: kRojo, peso: FontWeight.w800)),
                ),
              ],
            ),
            const SizedBox(height: 8),
            for (final i in bajos)
              Text('${i.nombre}: quedan ${i.cantidad} ${i.unidad} (mínimo ${i.minimo})',
                  style: texto(15)),
            const SizedBox(height: 14),
            FilledButton(
              onPressed: () => irA(3), // Panel → Inventario
              style: FilledButton.styleFrom(
                backgroundColor: kBeige,
                foregroundColor: kTexto,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              child: Text('Ver inventario', style: texto(15, peso: FontWeight.w800)),
            ),
          ],
        ),
      );
    }

    Widget dato(String nombreDato, String valor, int vista) {
      return GestureDetector(
        onTap: () => irA(vista),
        child: tarjeta(
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(nombreDato.toUpperCase(),
                  style: texto(12, color: kTextoSuave, peso: FontWeight.w700)),
              const Spacer(),
              Text(valor, style: titulo(40, color: kCafe)),
            ],
          ),
          relleno: 16,
        ),
      );
    }

    //pedidos en produ
    Widget carrusel() {
      return SizedBox(
        height: 215,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            for (final p in enProceso)
              GestureDetector(
                onTap: () => irA(1),
                child: Container(
                  width: 150,
                  margin: const EdgeInsets.only(right: 14),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: kTarjeta,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: kBorde, width: 1.5),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Center(child: Image.asset(p.mueble.ruta, fit: BoxFit.contain)),
                      ),
                      const SizedBox(height: 8),
                      Text(p.mueble.nombre,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: texto(14, peso: FontWeight.w800)),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                        decoration: BoxDecoration(
                          color: coloresEtapa[p.etapa],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(etapas[p.etapa],
                            style: texto(12, peso: FontWeight.w800)),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      );
    }

    Widget cifra(String nombreCifra, int valor, {Color color = kTexto}) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(nombreCifra, style: texto(14, color: kTextoSuave)),
          Text('$valor', style: texto(32, color: color, peso: FontWeight.w800)),
        ],
      );
    }

    Widget tarjetaArea(int i) {
      String area = areas[i];
      int entran = entranEn(area);
      int salen = salenEn(area);
      return GestureDetector(
        onTap: () => irA(2),
        child: Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: coloresEtapa[i],
            borderRadius: BorderRadius.circular(26),
            border: Border.all(color: kBorde, width: 1.5),
            boxShadow: const [
              BoxShadow(color: Color(0xFFDDCBBB), offset: Offset(0, 6)),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(area, style: titulo(26)),
              Text(descripcionArea[i].split(' · ').first,
                  style: texto(14, color: kTextoSuave)),
              const SizedBox(height: 16),
              Row(
                children: [
                  cifra('Entran', entran),
                  const SizedBox(width: 30),
                  cifra('Salen', salen),
                  const SizedBox(width: 30),
                  cifra('Pendientes', entran - salen, color: kCafe),
                ],
              ),
            ],
          ),
        ),
      );
    }
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text('Hola, $nombre', style: titulo(30)),
        const SizedBox(height: 2),
        Text(
          esDuena
              ? 'Dueña · acceso completo · $hoyLargo'
              : 'Encargada · $hoyLargo',
          style: texto(15, color: kTextoSuave),
        ),
        const SizedBox(height: 20),
        alerta(),
        const SizedBox(height: 18),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 14,
          mainAxisSpacing: 14,
          childAspectRatio: 1.25,
          children: [
            dato('Pedidos en proceso', '${enProceso.length}', 1),
            dato('Piezas entraron hoy', '$entraron', 2),
            dato('Piezas salieron hoy', '$salieron', 2),
            dato('Alertas de material', '${bajos.length}', 3),
          ],
        ),
        seccion('Pedidos en producción'),
        carrusel(),
        seccion('Áreas'),
        for (int i = 0; i < areas.length; i++) tarjetaArea(i),
        // Solo la dueña ve el reporte
        if (esDuena) ...[
          const SizedBox(height: 4),
          boton('Ver reporte completo', () => irA(4),
              icono: Icons.bar_chart_rounded),
        ],
        const SizedBox(height: 12),
      ],
    );
  }
}