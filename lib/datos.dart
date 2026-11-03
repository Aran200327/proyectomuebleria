//CATALOGO
class Mueble {
  final String nombre;
  final String linea;
  final String foto;
  final bool infantil;
  const Mueble(this.nombre, this.linea, this.foto, {this.infantil = false});

  String get ruta => 'assets/img/$foto.jpg';
}

const catalogo = [
  Mueble('Hidalgo Normal', 'Diana', 'hidalgo_normal'),
  Mueble('Cómoda Diana', 'Diana', 'comoda_diana'),
  Mueble('Gemelo Diana', 'Diana', 'gemelo_diana'),
  Mueble('Alacena Mayleth', 'Diana', 'alacena_mayleth'),
  Mueble('Zapatero Diana', 'Diana', 'zapatero_diana'),
  Mueble('Ropero AVI con maleta', 'Diana', 'ropero_avi'),
  Mueble('Centro de entretenimiento', 'Diana', 'centro_entretenimiento'),
  Mueble('King Kong 3P con maleta', 'Diana', 'king_kong_3p'),
  Mueble('Cajonera 5 cajones', 'Diana', 'cajonera_5'),
  Mueble('Cajonera 10 cajones', 'Diana', 'cajonera_10'),
  Mueble('Tocador Vanity Diana', 'Diana', 'tocador_vanity'),
  Mueble('Tocador Luna Larga', 'Diana', 'tocador_luna_larga'),
  Mueble('Zapatero Diana infantil', 'Diana', 'zapatero_infantil', infantil: true),
  Mueble('Cómoda infantil', 'Diana', 'comoda_infantil', infantil: true),
  Mueble('Cómoda cajonera infantil', 'Diana', 'comoda_cajonera_infantil', infantil: true),
  Mueble('Juvenil infantil', 'Diana', 'juvenil_infantil', infantil: true),
  Mueble('Hidalgo Luna Oculta', 'Tradicional', 'hidalgo_luna_oculta'),
  Mueble('Sabanero', 'Tradicional', 'sabanero'),
  Mueble('Maletero 6 cajones', 'Tradicional', 'maletero_6'),
  Mueble('Buró', 'Tradicional', 'buro'),
  Mueble('Comedor silla tapizada', 'Tradicional', 'comedor'),
  Mueble('Cocina integral', 'Tradicional', 'cocina_integral'),
];

const coloresAdulto = ['Chocolate', 'Nogal', 'Blanco', 'Vino'];
const coloresInfantil = ['Rosa', 'Azul'];

Mueble buscarMueble(String nombre) =>
    catalogo.firstWhere((m) => m.nombre == nombre);

const hoy = '03/11/2026';
const hoyLargo = '3 de noviembre de 2026';

const etapas = ['Armado', 'Agua', 'Barnizado', 'Adornado', 'Listo'];
const areas = ['Armado', 'Agua', 'Barnizado', 'Adornado'];
const descripcionArea = [
  'Se reparte entre trabajadores · Entradas de maquila',
  'Tinta al agua',
  'Pintura y barniz',
  'Estampado tipo caricatura',
];

// CUENTAS
class Cuenta {
  final String nombre;
  final String rol;
  Cuenta(this.nombre, this.rol);
}

final cuentas = [
  Cuenta('Esthefany', 'Dueña'),
  Cuenta('Karyme', 'Encargada'),
  Cuenta('Encargada 3', 'Encargada'),
];

bool esDuena(String nombre) =>
    cuentas.any((c) => c.nombre == nombre && c.rol == 'Dueña');

// PEDIDOS
class Pedido {
  final String folio;
  final String fecha;
  final String cliente;
  final Mueble mueble;
  final int piezas;
  final String color;
  int etapa;
  Pedido(this.folio, this.fecha, this.cliente, this.mueble, this.piezas,
      this.color, this.etapa);
}

final pedidos = [
  Pedido('P-101', '2026-11-01', 'Mueblería Sol', buscarMueble('Cómoda infantil'), 24, 'Rosa', 0),
  Pedido('P-102', '2026-10-29', 'Casa Linda', buscarMueble('Buró'), 12, 'Chocolate', 1),
  Pedido('P-103', '2026-10-26', 'Juguetes MX', buscarMueble('Zapatero Diana infantil'), 10, 'Rosa', 3),
  Pedido('P-104', '2026-10-24', 'Muebles del Centro', buscarMueble('Hidalgo Normal'), 8, 'Nogal', 2),
  Pedido('P-105', '2026-10-20', 'Casa Linda', buscarMueble('Tocador Vanity Diana'), 6, 'Blanco', 4),
];

//TRABAJADORES
class Trabajador {
  final String nombre;
  final String area;
  int entran;
  int salen;
  Trabajador(this.nombre, this.area, this.entran, this.salen);
  int get pendientes => entran - salen;
}

final trabajadores = [
  Trabajador('Don Pepe', 'Armado', 20, 15),
  Trabajador('Juan', 'Armado', 10, 10),
  Trabajador('Raúl', 'Armado', 8, 5),
  Trabajador('Toño', 'Armado', 0, 0),
  Trabajador('Lupita', 'Agua', 15, 12),
  Trabajador('Beto', 'Barnizado', 12, 9),
  Trabajador('Ana', 'Adornado', 11, 9),
  Trabajador('Mari', 'Adornado', 4, 4),
];

List<Trabajador> trabajadoresDe(String area) =>
    trabajadores.where((t) => t.area == area).toList();

int entranEn(String area) =>
    trabajadoresDe(area).fold(0, (suma, t) => suma + t.entran);

int salenEn(String area) =>
    trabajadoresDe(area).fold(0, (suma, t) => suma + t.salen);

//INVENTARIO
class Insumo {
  final String nombre;
  final String area;
  final int cantidad;
  final String unidad;
  final int minimo;
  const Insumo(this.nombre, this.area, this.cantidad, this.unidad, this.minimo);
  bool get bajo => cantidad < minimo;
}

const insumos = [
  Insumo('Barniz transparente', 'Barnizado', 6, 'litros', 10),
  Insumo('Thinner', 'Barnizado', 18, 'litros', 8),
  Insumo('Lija 220', 'Barnizado', 25, 'pliegos', 30),
  Insumo('Tinta al agua chocolate', 'Agua', 9, 'litros', 5),
  Insumo('Tinta al agua nogal', 'Agua', 7, 'litros', 5),
  Insumo('Pegamento blanco', 'Armado', 14, 'kg', 6),
  Insumo('Clavos 1"', 'Armado', 7, 'cajas', 4),
  Insumo('Calcas caricatura', 'Adornado', 120, 'piezas', 50),
];

//MUEBLES LISTOS
class Terminado {
  final String mueble;
  final int piezas;
  final int minimo;
  const Terminado(this.mueble, this.piezas, this.minimo);
}

const terminados = [
  Terminado('Cómoda infantil', 40, 10),
  Terminado('Buró', 14, 6),
  Terminado('Tocador Vanity Diana', 6, 4),
  Terminado('Cocina integral', 3, 2),
];

//ENTARDAS Y SALIDAS
class Movimiento {
  final String fecha;
  final String material;
  final String cantidad;
  final String encargada;
  const Movimiento(this.fecha, this.material, this.cantidad, this.encargada);
}

const movimientos = [
  Movimiento('2026-11-02', 'Barniz transparente', '-2', 'Karyme'),
  Movimiento('2026-10-30', 'Pegamento blanco', '+10', 'Esthefany'),
  Movimiento('2026-10-29', 'Lija 220', '-15', 'Karyme'),
  Movimiento('2026-10-28', 'Tinta al agua chocolate', '+6', 'Esthefany'),
];
