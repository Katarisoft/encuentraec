import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:exploraec/bienvenida_claude_design.dart';

void main() {
  runApp(const ExploraEcApp());
}

// Colores del sistema de diseño "Andean Explorer" (Stitch).
const Color _fondo = Color(0xFFFAF8FF);
const Color _primario = Color(0xFF059669);
const Color _secundario = Color(0xFF0D9488);
const Color _textoPrincipal = Color(0xFF131B2E);
const Color _textoSecundario = Color(0xFF3D4A42);

class ExploraEcApp extends StatelessWidget {
  const ExploraEcApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ExploraEC',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: _primario,
          primary: _primario,
          secondary: _secundario,
          surface: _fondo,
        ),
        scaffoldBackgroundColor: _fondo,
        textTheme: GoogleFonts.plusJakartaSansTextTheme(),
      ),
      home: const BienvenidaScreen(),
    );
  }
}

class BienvenidaScreen extends StatelessWidget {
  const BienvenidaScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _fondo,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            children: [
              const Spacer(),
              Container(
                width: 96,
                height: 96,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [_primario, _secundario],
                  ),
                ),
                child: const Icon(Icons.explore, size: 48, color: Colors.white),
              ),
              const SizedBox(height: 40),
              Text(
                'ExploraEC',
                textAlign: TextAlign.center,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 40,
                  height: 48 / 40,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.8,
                  color: _textoPrincipal,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Descubre los mejores lugares cerca de ti',
                textAlign: TextAlign.center,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 16,
                  height: 26 / 16,
                  color: _textoSecundario,
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _primario,
                    foregroundColor: Colors.white,
                    elevation: 6,
                    shadowColor: _primario.withValues(alpha: 0.35),
                    shape: const StadiumBorder(),
                    textStyle: GoogleFonts.plusJakartaSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.16,
                    ),
                  ),
                  child: const Text('Empezar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
