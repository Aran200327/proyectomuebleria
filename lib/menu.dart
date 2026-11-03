import 'package:flutter/material.dart';
import 'package:proyectomuebleria/datos.dart';
import 'package:proyectomuebleria/tema.dart';
import 'package:proyectomuebleria/vistaareas.dart';
import 'package:proyectomuebleria/vistacuentas.dart';
import 'package:proyectomuebleria/vistainicio.dart';
import 'package:proyectomuebleria/vistainventario.dart';
import 'package:proyectomuebleria/vistapanel.dart';
import 'package:proyectomuebleria/vistapedidos.dart';
import 'package:proyectomuebleria/vistareportes.dart';

class Menu extends StatefulWidget {
  final String nombre; // quién entró
  const Menu({super.key, required this.nombre});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  int vistaSeleccionada = 0;
  void cambiarVista(int index) {
    setState(() {
      vistaSeleccionada = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    //permisos
    bool duena = esDuena(widget.nombre);
    int alertas = insumos.where((i) => i.bajo).length;
    List<Widget> listaVistas = [
      VistaPanel(nombre: widget.nombre, esDuena: duena, irA: cambiarVista),
      VistaPedidos(irA: cambiarVista),
      const VistaAreas(),
      VistaInventario(esDuena: duena, irA: cambiarVista),
      if (duena) VistaReportes(irA: cambiarVista),
    ];

    //parte de arriba
    PreferredSizeWidget encabezado() {
      return AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: kBeige,
        surfaceTintColor: kBeige,
        toolbarHeight: 68,
        titleSpacing: 20,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Mueblería Diana', style: titulo(26, color: kCafe)),
            Text('Control de producción',
                style: texto(13, color: kTextoSuave, peso: FontWeight.w600)),
          ],
        ),
        actions: [
          InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => VistaCuentas(nombre: widget.nombre),
              ));
            },
            child: Padding(
              padding: const EdgeInsets.all(6),
              child: Row(
                children: [
                  Text(widget.nombre, style: texto(15, peso: FontWeight.w700)),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: kCafe,
                    child: Text(widget.nombre[0],
                        style: titulo(15, color: Colors.white)),
                  ),
                ],
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const VistaInicio()),
                    (_) => false,
              );
            },
            child: Text('Salir',
                style: texto(15, color: kTexto, peso: FontWeight.w700)),
          ),
          const SizedBox(width: 6),
        ],
      );
    }

    //menú inferior
    Widget menuInferior() {
      return Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: kBorde)),
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: vistaSeleccionada,
          onTap: cambiarVista,
          backgroundColor: kTarjeta,
          elevation: 0,
          selectedItemColor: kCafe,
          unselectedItemColor: kTextoSuave,
          selectedLabelStyle: texto(12, peso: FontWeight.w800),
          unselectedLabelStyle: texto(12, peso: FontWeight.w600),
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.grid_view_rounded),
              label: 'Panel',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.inventory_2_outlined),
              label: 'Pedidos',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.groups_outlined),
              label: 'Áreas',
            ),
            BottomNavigationBarItem(
              icon: Badge(
                isLabelVisible: alertas > 0,
                label: Text('$alertas'),
                backgroundColor: kRojo,
                child: const Icon(Icons.view_in_ar_outlined),
              ),
              label: 'Inventario',
            ),
            if (duena)
              const BottomNavigationBarItem(
                icon: Icon(Icons.bar_chart_rounded),
                label: 'Reporte',
              ),
          ],
        ),
      );
    }
    return Scaffold(
      appBar: encabezado(),
      body: listaVistas.elementAt(vistaSeleccionada),
      bottomNavigationBar: menuInferior(),
    );
  }
}