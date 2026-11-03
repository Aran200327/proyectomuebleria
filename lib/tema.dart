import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const kFondo = Color(0xFFFAF3EE);
const kBeige = Color(0xFFE8D5C4);
const kBorde = Color(0xFFE2D4C7);
const kCafe = Color(0xFF7C5438);
const kTexto = Color(0xFF2C1E12);
const kTextoSuave = Color(0xFF7A6555);
const kTarjeta = Color(0xFFFFFCF9);
const kRojo = Color(0xFFC8382B);
const kRojoFondo = Color(0xFFF5E1DC);
const kRojoBorde = Color(0xFFE8A59B);
const kVerde = Color(0xFF3E8E4F);

//areas
const coloresEtapa = [
  Color(0xFFEFCB9B),
  Color(0xFFB0DAEB),
  Color(0xFFB5DBBD),
  Color(0xFFF4C6DB),
  Color(0xFFE8D5C4),
];

//color muebles
Color colorDe(String nombre) => switch (nombre) {
  'Chocolate' => const Color(0xFF4B2E22),
  'Nogal' => const Color(0xFF8A5A2B),
  'Blanco' => const Color(0xFFFFFFFF),
  'Vino' => const Color(0xFF6F1D2B),
  'Rosa' => const Color(0xFFF08DB5),
  'Azul' => const Color(0xFF4DB3DA),
  _ => kCafe,
};

TextStyle titulo(double size, {Color color = kTexto}) => GoogleFonts.fraunces(
  fontSize: size,
  fontWeight: FontWeight.w700,
  color: color,
);

TextStyle texto(double size,
    {Color color = kTexto, FontWeight peso = FontWeight.w400}) =>
    GoogleFonts.nunito(fontSize: size, fontWeight: peso, color: color);

ThemeData temaApp() => ThemeData(
  useMaterial3: true,
  scaffoldBackgroundColor: kFondo,
  colorScheme: ColorScheme.fromSeed(seedColor: kCafe, surface: kFondo),
  //textTheme: GoogleFonts.nunitoTextTheme(),
);

Widget tarjeta(Widget hijo,
    {Color color = kTarjeta, double relleno = 18, Color borde = kBorde}) {
  return Container(
    width: double.infinity,
    padding: EdgeInsets.all(relleno),
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(24),
      border: Border.all(color: borde, width: 1.5),
      boxShadow: const [
        BoxShadow(color: Color(0x147C5438), blurRadius: 14, offset: Offset(0, 6)),
      ],
    ),
    child: hijo,
  );
}

Widget seccion(String titulo_) => Padding(
  padding: const EdgeInsets.only(top: 28, bottom: 14),
  child: Text(titulo_, style: titulo(24)),
);

InputDecoration decoracion(String hint) => InputDecoration(
  hintText: hint,
  hintStyle: texto(16, color: kTextoSuave),
  counterText: '',
  filled: true,
  fillColor: kTarjeta,
  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(16),
    borderSide: const BorderSide(color: kBorde, width: 1.5),
  ),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(16),
    borderSide: const BorderSide(color: kBorde, width: 1.5),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(16),
    borderSide: const BorderSide(color: kCafe, width: 2),
  ),
);

Widget etiqueta(String txt, Widget campo_) => Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Text(txt, style: texto(14, color: kTextoSuave, peso: FontWeight.w700)),
    const SizedBox(height: 6),
    campo_,
  ],
);

Widget campo(String nombre,
    {String hint = '',
      TextEditingController? controlador,
      bool oculto = false,
      bool numerico = false,
      int? maximo}) {
  return etiqueta(
    nombre,
    TextField(
      controller: controlador,
      obscureText: oculto,
      maxLength: maximo,
      keyboardType: numerico ? TextInputType.number : TextInputType.text,
      style: texto(16, peso: FontWeight.w600),
      decoration: decoracion(hint),
    ),
  );
}

Widget campoFijo(String nombre, String valor) => etiqueta(
  nombre,
  Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    decoration: BoxDecoration(
      color: kTarjeta,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: kBorde, width: 1.5),
    ),
    child: Text(valor, style: texto(16, peso: FontWeight.w600)),
  ),
);

Widget lista(String nombre, List<String> opciones, String valor,
    void Function(String) alCambiar) {
  return etiqueta(
    nombre,
    Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: kTarjeta,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: kBorde, width: 1.5),
      ),
      child: DropdownButton<String>(
        value: valor,
        isExpanded: true,
        underline: const SizedBox(),
        dropdownColor: kTarjeta,
        borderRadius: BorderRadius.circular(16),
        icon: const Icon(Icons.unfold_more, color: kTextoSuave),
        style: texto(16, peso: FontWeight.w600),
        items: [
          for (final o in opciones)
            DropdownMenuItem(value: o, child: Text(o, overflow: TextOverflow.ellipsis)),
        ],
        onChanged: (v) {
          if (v != null) alCambiar(v);
        },
      ),
    ),
  );
}

Widget contador(String nombre, int valor, void Function(int) alCambiar,
    {int minimo = 0}) {
  return etiqueta(
    nombre,
    Container(
      decoration: BoxDecoration(
        color: kTarjeta,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: kBorde, width: 1.5),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.remove, color: kCafe),
            onPressed: () => alCambiar(valor > minimo ? valor - 1 : minimo),
          ),
          Expanded(
            child: Text('$valor',
                textAlign: TextAlign.center,
                style: texto(18, peso: FontWeight.w800)),
          ),
          IconButton(
            icon: const Icon(Icons.add, color: kCafe),
            onPressed: () => alCambiar(valor + 1),
          ),
        ],
      ),
    ),
  );
}

Widget boton(String txt, VoidCallback alTocar,
    {bool relleno = true, IconData? icono}) {
  return SizedBox(
    width: double.infinity,
    child: FilledButton(
      onPressed: alTocar,
      style: FilledButton.styleFrom(
        backgroundColor: relleno ? kCafe : kBeige,
        foregroundColor: relleno ? Colors.white : kTexto,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icono != null) ...[Icon(icono, size: 20), const SizedBox(width: 8)],
          Flexible(
            child: Text(txt,
                overflow: TextOverflow.ellipsis,
                style: texto(17,
                    peso: FontWeight.w800,
                    color: relleno ? Colors.white : kTexto)),
          ),
        ],
      ),
    ),
  );
}

Widget chip(String txt, bool activo, VoidCallback alTocar, {Color? color}) {
  final neutro = color == null;
  return GestureDetector(
    onTap: alTocar,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      decoration: BoxDecoration(
        color: neutro ? (activo ? kCafe : kBeige) : color,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: (!neutro && activo) ? kCafe : Colors.transparent,
          width: 2,
        ),
      ),
      child: Text(
        txt,
        style: texto(
          15,
          peso: activo ? FontWeight.w800 : FontWeight.w600,
          color: (neutro && activo) ? Colors.white : (activo ? kTexto : kTextoSuave),
        ),
      ),
    ),
  );
}

//pics muebles
Widget foto(String ruta, double tam) => Container(
  width: tam,
  height: tam,
  padding: const EdgeInsets.all(4),
  decoration: BoxDecoration(
    color: kTarjeta,
    borderRadius: BorderRadius.circular(16),
    border: Border.all(color: kBorde),
  ),
  child: Image.asset(ruta, fit: BoxFit.contain),
);

Widget puntoColor(String nombre) => Container(
  width: 12,
  height: 12,
  decoration: BoxDecoration(
    color: colorDe(nombre),
    shape: BoxShape.circle,
    border: Border.all(color: kBorde),
  ),
);

Widget barra(double valor) => ClipRRect(
  borderRadius: BorderRadius.circular(10),
  child: LinearProgressIndicator(
    value: valor,
    minHeight: 10,
    backgroundColor: kBeige,
    color: kCafe,
  ),
);

void aviso(BuildContext context, String mensaje) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(mensaje, style: texto(15, color: Colors.white, peso: FontWeight.w600)),
      backgroundColor: kCafe,
      behavior: SnackBarBehavior.floating,
    ),
  );
}

class Marco extends StatelessWidget {
  final Widget hijo;
  const Marco({super.key, required this.hijo});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          margin: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: kBeige,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: kTarjeta,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: const [
                    BoxShadow(
                        color: Color(0x267C5438),
                        blurRadius: 24,
                        offset: Offset(0, 10)),
                  ],
                ),
                child: hijo,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
