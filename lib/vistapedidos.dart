import 'package:flutter/material.dart';
import 'package:proyectomuebleria/datos.dart';
import 'package:proyectomuebleria/tema.dart';

class VistaPedidos extends StatefulWidget {
  final void Function(int) irA;
  const VistaPedidos({super.key, required this.irA});

  @override
  State<VistaPedidos> createState() => _VistaPedidosState();
}

class _VistaPedidosState extends State<VistaPedidos> {
  final cliente = TextEditingController();
  String mueble = catalogo.first.nombre;
  String color = coloresAdulto.first;
  int piezas = 1;
  String filtro = 'Todos';
  @override
  void dispose() {
    cliente.dispose();
    super.dispose();
  }
  List<String> coloresDisponibles() {
    return buscarMueble(mueble).infantil ? coloresInfantil : coloresAdulto;
  }
  void registrar() {
    String nombreCliente = cliente.text.trim();
    if (nombreCliente.isEmpty) nombreCliente = 'Cliente nuevo';
    setState(() {
      pedidos.insert(
        0,
        Pedido('P-${101 + pedidos.length}', '2026-11-03', nombreCliente,
            buscarMueble(mueble), piezas, color, 0),
      );
      cliente.clear();
      piezas = 1;
      filtro = 'Todos';
    });
    aviso(context, 'Pedido registrado: entra a Armado');
  }

  @override
  Widget build(BuildContext context) {
    Widget formulario() {
      return tarjeta(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            campo('Cliente', hint: 'Nombre del cliente', controlador: cliente),
            const SizedBox(height: 14),
            lista('Mueble', [for (final m in catalogo) m.nombre], mueble, (v) {
              setState(() {
                mueble = v;
                if (!coloresDisponibles().contains(color)) {
                  color = coloresDisponibles().first;
                }
              });
            }),
            const SizedBox(height: 4),
            Text('Línea ${buscarMueble(mueble).linea}',
                style: texto(13, color: kTextoSuave)),
            const SizedBox(height: 10),
            lista('Color', coloresDisponibles(), color, (v) {
              setState(() => color = v);
            }),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: contador('Piezas', piezas, (v) {
                    setState(() => piezas = v);
                  }, minimo: 1),
                ),
                const SizedBox(width: 12),
                Expanded(child: campoFijo('Fecha', hoy)),
              ],
            ),
            const SizedBox(height: 18),
            boton('Registrar pedido', registrar, icono: Icons.add),
          ],
        ),
      );
    }

    //filtros
    Widget filtros() {
      return Wrap(
        spacing: 10,
        runSpacing: 10,
        children: [
          for (final f in ['Todos', ...etapas])
            chip(f, filtro == f, () => setState(() => filtro = f)),
        ],
      );
    }

    //etapas procesos
    Widget etapasDelPedido(Pedido p) {
      return Column(
        children: [
          Row(
            children: [
              for (int i = 0; i < etapas.length; i++)
                Expanded(
                  child: Container(
                    height: 7,
                    margin: EdgeInsets.only(right: i == etapas.length - 1 ? 0 : 5),
                    decoration: BoxDecoration(
                      color: i <= p.etapa ? kCafe : kBeige,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (int i = 0; i < etapas.length; i++)
                Text(etapas[i],
                    style: texto(11,
                        color: i == p.etapa ? kCafe : kTextoSuave,
                        peso: i == p.etapa ? FontWeight.w800 : FontWeight.w500)),
            ],
          ),
        ],
      );
    }

    Widget tarjetaPedido(Pedido p) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: tarjeta(
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  foto(p.mueble.ruta, 78),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${p.folio} · ${p.fecha}',
                            style: texto(13, color: kTextoSuave)),
                        const SizedBox(height: 2),
                        Text('${p.piezas} × ${p.mueble.nombre}',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: texto(18, peso: FontWeight.w800)),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Flexible(
                              child: Text(p.cliente,
                                  overflow: TextOverflow.ellipsis,
                                  style: texto(14, color: kTextoSuave)),
                            ),
                            const SizedBox(width: 8),
                            puntoColor(p.color),
                            const SizedBox(width: 4),
                            Text(p.color,
                                style: texto(14, color: kCafe, peso: FontWeight.w800)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              etapasDelPedido(p),
              const SizedBox(height: 14),
              if (p.etapa < 4)
                boton('Pasar a ${etapas[p.etapa + 1]} →', () {
                  setState(() => p.etapa++);
                }, relleno: false)
              else
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: kBeige,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.check_circle, color: kVerde, size: 20),
                      const SizedBox(width: 8),
                      Text('Listo para entregar',
                          style: texto(16, peso: FontWeight.w800)),
                    ],
                  ),
                ),
            ],
          ),
        ),
      );
    }

    final visibles = pedidos
        .where((p) => filtro == 'Todos' || etapas[p.etapa] == filtro)
        .toList();
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text('Registro de pedidos', style: titulo(30)),
        const SizedBox(height: 2),
        Text('Cada pedido nuevo entra a Armado y avanza por las áreas',
            style: texto(15, color: kTextoSuave)),
        const SizedBox(height: 20),
        formulario(),
        const SizedBox(height: 22),
        filtros(),
        const SizedBox(height: 18),
        if (visibles.isEmpty)
          tarjeta(Text('No hay pedidos en esta etapa',
              textAlign: TextAlign.center,
              style: texto(16, color: kTextoSuave)))
        else
          for (final p in visibles) tarjetaPedido(p),
        boton('Ver áreas y trabajadores', () => widget.irA(2),
            relleno: false, icono: Icons.groups_outlined),
        const SizedBox(height: 12),
      ],
    );
  }
}