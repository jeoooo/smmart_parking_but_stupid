import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import '../theme.dart';

// ---------------------------------------------------------------------------
// Mock QR Code — draws a realistic-looking QR pattern using CustomPaint
// ---------------------------------------------------------------------------

class MockQRCode extends StatelessWidget {
  final String data;
  final double size;

  const MockQRCode({super.key, required this.data, this.size = 200});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      padding: EdgeInsets.all(size * 0.06),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.colBorder),
      ),
      child: CustomPaint(painter: _QRPainter(data: data)),
    );
  }
}

class _QRPainter extends CustomPainter {
  final String data;
  static const int _n = 21; // QR version 1

  _QRPainter({required this.data});

  @override
  void paint(Canvas canvas, Size size) {
    final cell = size.width / (_n + 2);
    final off = cell;
    final dark = Paint()..color = const Color(0xFF1B1B1F);
    canvas.drawRect(
        Rect.fromLTWH(0, 0, size.width, size.height), Paint()..color = Colors.white);

    final g = List.generate(_n, (_) => List.generate(_n, (_) => false));
    _finder(g, 0, 0);
    _finder(g, 0, _n - 7);
    _finder(g, _n - 7, 0);

    for (int i = 8; i < _n - 8; i++) {
      g[6][i] = i.isEven;
      g[i][6] = i.isEven;
    }

    int seed = 5381;
    for (int i = 0; i < data.length; i++) {
      seed = ((seed << 5) + seed) + data.codeUnitAt(i);
      seed &= 0x7FFFFFFF;
    }
    for (int r = 0; r < _n; r++) {
      for (int c = 0; c < _n; c++) {
        if (_reserved(r, c)) continue;
        seed = ((seed * 1103515245) + 12345) & 0x7FFFFFFF;
        g[r][c] = seed % 3 != 0;
      }
    }

    for (int r = 0; r < _n; r++) {
      for (int c = 0; c < _n; c++) {
        if (g[r][c]) {
          canvas.drawRect(
              Rect.fromLTWH(off + c * cell, off + r * cell, cell, cell), dark);
        }
      }
    }
  }

  void _finder(List<List<bool>> g, int sr, int sc) {
    for (int r = 0; r < 7; r++) {
      for (int c = 0; c < 7; c++) {
        g[sr + r][sc + c] = r == 0 ||
            r == 6 ||
            c == 0 ||
            c == 6 ||
            (r >= 2 && r <= 4 && c >= 2 && c <= 4);
      }
    }
  }

  bool _reserved(int r, int c) {
    if (r < 8 && c < 8) return true;
    if (r < 8 && c >= _n - 8) return true;
    if (r >= _n - 8 && c < 8) return true;
    if (r == 6 || c == 6) return true;
    return false;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ---------------------------------------------------------------------------
// Previews
// ---------------------------------------------------------------------------

@Preview(name: 'MockQRCode \u00B7 Default (200)')
Widget previewDefault() => Theme(
      data: AppTheme.theme,
      child: const MockQRCode(data: 'SP-20260310-0847'),
    );

@Preview(name: 'MockQRCode \u00B7 Small (120)')
Widget previewSmall() => Theme(
      data: AppTheme.theme,
      child: const MockQRCode(data: 'TXN1739001234567890', size: 120),
    );

@Preview(name: 'MockQRCode \u00B7 Dark')
Widget previewDark() => Theme(
      data: AppTheme.darkTheme,
      child: const MockQRCode(data: 'SP-20260310-0847'),
    );
