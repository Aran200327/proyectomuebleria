import 'dart:async';

import 'package:flutter/material.dart';
import 'package:proyectomuebleria/tema.dart';
import 'package:proyectomuebleria/vistainicio.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mueblería Diana',
      theme: temaApp(),
      home: const Splash(),
    );
  }
}

// carganding
class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const VistaInicio()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBeige,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            //logo
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: kTarjeta,
                shape: BoxShape.circle,
                boxShadow: const [
                  BoxShadow(
                      color: Color(0x337C5438),
                      blurRadius: 24,
                      offset: Offset(0, 10)),
                ],
              ),
              child: ClipOval(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Image.asset('assets/img/logo.jpeg', fit: BoxFit.contain),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text('Diana', style: titulo(48, color: kCafe)),
            const SizedBox(height: 4),
            Text(
              'MUEBLERÍA',
              style: texto(16, color: kTextoSuave, peso: FontWeight.w700)
                  .copyWith(letterSpacing: 6),
            ),
            const SizedBox(height: 40),
            const SizedBox(
              width: 28,
              height: 28,
              child: CircularProgressIndicator(color: kCafe, strokeWidth: 3),
            ),
          ],
        ),
      ),
    );
  }
}
