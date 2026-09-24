import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Colores del sistema de diseño "Andean Explorer".
const Color _fondo = Color(0xFFFAF8FF);
const Color _primario = Color(0xFF059669);
const Color _primarioPresionado = Color(0xFF047857);
const Color _secundario = Color(0xFF0D9488);
const Color _halo = Color(0xFFE6F6EF);
const Color _textoPrincipal = Color(0xFF131B2E);
const Color _textoSecundario = Color(0xFF3D4A42);

class BienvenidaScreenClaudeDesign extends StatelessWidget {
  const BienvenidaScreenClaudeDesign({super.key, this.onEmpezar});

  /// Acción del botón "Empezar". Si es null, muestra un aviso breve.
  final VoidCallback? onEmpezar;

  void _empezar(BuildContext context) {
    if (onEmpezar != null) {
      onEmpezar!();
      return;
    }
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            'Buscando lugares cerca de ti…',
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
          backgroundColor: _textoPrincipal,
          behavior: SnackBarBehavior.floating,
          shape: const StadiumBorder(),
          margin: const EdgeInsets.fromLTRB(48, 0, 48, 96),
          duration: const Duration(milliseconds: 1800),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _fondo,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 28),
          child: Column(
            children: [
              Expanded(child: Center(child: _contenido())),
              _BotonEmpezar(onPressed: () => _empezar(context)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _contenido() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(
          width: 92,
          height: 92,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              OverflowBox(
                maxWidth: 320,
                maxHeight: 320,
                child: IgnorePointer(
                  child: CustomPaint(
                    size: Size(320, 320),
                    painter: _CurvasDeNivelPainter(),
                  ),
                ),
              ),
              _IconoBrujula(),
            ],
          ),
        ),
        const SizedBox(height: 36),
        Text.rich(
          const TextSpan(
            text: 'Explora',
            children: [
              TextSpan(text: 'EC', style: TextStyle(color: _primario)),
            ],
          ),
          textAlign: TextAlign.center,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 40,
            height: 48 / 40,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.8,
            color: _textoPrincipal,
          ),
        ),
        const SizedBox(height: 14),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 240),
          child: Text(
            'Descubre los mejores lugares cerca de ti',
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 16,
              height: 26 / 16,
              color: _textoSecundario,
            ),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          '0°13′S · 78°30′O · Quito',
          style: GoogleFonts.jetBrainsMono(
            fontSize: 11,
            letterSpacing: 0.44,
            color: _secundario,
          ),
        ),
      ],
    );
  }
}

class _IconoBrujula extends StatelessWidget {
  const _IconoBrujula();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 92,
      height: 92,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [_primario, _secundario],
        ),
        boxShadow: [
          const BoxShadow(color: _halo, spreadRadius: 10),
          BoxShadow(
            color: _primario.withValues(alpha: 0.45),
            blurRadius: 28,
            spreadRadius: -8,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: const Icon(Icons.explore_outlined, size: 48, color: Colors.white),
    );
  }
}

class _BotonEmpezar extends StatelessWidget {
  const _BotonEmpezar({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith(
            (states) => states.contains(WidgetState.pressed) ||
                    states.contains(WidgetState.hovered)
                ? _primarioPresionado
                : _primario,
          ),
          foregroundColor: const WidgetStatePropertyAll(Colors.white),
          elevation: const WidgetStatePropertyAll(8),
          shadowColor: WidgetStatePropertyAll(
            _primario.withValues(alpha: 0.5),
          ),
          shape: const WidgetStatePropertyAll(StadiumBorder()),
          textStyle: WidgetStatePropertyAll(
            GoogleFonts.plusJakartaSans(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.16,
            ),
          ),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Empezar'),
            SizedBox(width: 10),
            Icon(Icons.arrow_forward_rounded, size: 20),
          ],
        ),
      ),
    );
  }
}

/// Curvas de nivel tenues detrás del ícono, como en un mapa topográfico.
class _CurvasDeNivelPainter extends CustomPainter {
  const _CurvasDeNivelPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..color = _primario.withValues(alpha: 0.09);

    final centro = size.center(Offset.zero);
    const anillos = [
      (ancho: 300.0, alto: 290.0, dx: 0.0, dy: 4.0),
      (ancho: 230.0, alto: 220.0, dx: -2.0, dy: 6.0),
      (ancho: 160.0, alto: 156.0, dx: -4.0, dy: 8.0),
      (ancho: 100.0, alto: 96.0, dx: -6.0, dy: 10.0),
    ];

    canvas.save();
    canvas.translate(centro.dx, centro.dy);
    canvas.rotate(-0.18);
    for (final a in anillos) {
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(a.dx, a.dy),
          width: a.ancho,
          height: a.alto,
        ),
        paint,
      );
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
