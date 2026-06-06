import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../core/constants/app_dimens.dart';
import '../core/utils/formatters.dart';
import '../data/models/nasa_power_response.dart';

/// Grafico de linha reutilizavel, desenhado com [CustomPaint] (sem
/// dependencias externas). Plota uma metrica da serie de satelite ao
/// longo do tempo, com area preenchida, eixo e rotulos de min/max.
class ClimaChart extends StatelessWidget {
  final List<RegistroDiario> serie;
  final double? Function(RegistroDiario) seletor;
  final Color cor;
  final String titulo;

  const ClimaChart({
    super.key,
    required this.serie,
    required this.seletor,
    required this.cor,
    required this.titulo,
  });

  @override
  Widget build(BuildContext context) {
    final valores = serie.map(seletor).toList();
    final temDados = valores.any((v) => v != null);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(titulo, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: AppDimens.md),
            SizedBox(
              height: 160,
              width: double.infinity,
              child: temDados
                  ? CustomPaint(
                      painter: _LineChartPainter(valores: valores, cor: cor),
                    )
                  : const Center(
                      child: Text(
                        'Sem dados para o periodo.',
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                    ),
            ),
            if (temDados && serie.isNotEmpty) ...[
              const SizedBox(height: AppDimens.sm),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    Formatters.diaMes(serie.first.data),
                    style: const TextStyle(
                        color: AppColors.textSecondary, fontSize: 11),
                  ),
                  Text(
                    Formatters.diaMes(serie.last.data),
                    style: const TextStyle(
                        color: AppColors.textSecondary, fontSize: 11),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _LineChartPainter extends CustomPainter {
  final List<double?> valores;
  final Color cor;

  _LineChartPainter({required this.valores, required this.cor});

  @override
  void paint(Canvas canvas, Size size) {
    final validos = valores.whereType<double>().toList();
    if (validos.isEmpty) return;

    var min = validos.reduce((a, b) => a < b ? a : b);
    var max = validos.reduce((a, b) => a > b ? a : b);
    if (min == max) {
      // Evita divisao por zero quando todos os valores sao iguais.
      min -= 1;
      max += 1;
    }
    final intervalo = max - min;

    const padLeft = 4.0;
    const padBottom = 4.0;
    final largura = size.width - padLeft;
    final altura = size.height - padBottom;

    double x(int i) => padLeft + (largura * i / (valores.length - 1));
    double y(double v) => altura - ((v - min) / intervalo) * altura;

    // Linha de base.
    final baselinePaint = Paint()
      ..color = AppColors.divider
      ..strokeWidth = 1;
    canvas.drawLine(
      Offset(padLeft, altura),
      Offset(size.width, altura),
      baselinePaint,
    );

    // Constroi o caminho da linha (ignorando lacunas).
    final linePath = Path();
    var iniciado = false;
    Offset? primeiro;
    Offset? ultimo;
    for (var i = 0; i < valores.length; i++) {
      final v = valores[i];
      if (v == null) continue;
      final ponto = Offset(x(i), y(v));
      if (!iniciado) {
        linePath.moveTo(ponto.dx, ponto.dy);
        primeiro = ponto;
        iniciado = true;
      } else {
        linePath.lineTo(ponto.dx, ponto.dy);
      }
      ultimo = ponto;
    }

    // Area preenchida sob a linha.
    if (primeiro != null && ultimo != null) {
      final areaPath = Path.from(linePath)
        ..lineTo(ultimo.dx, altura)
        ..lineTo(primeiro.dx, altura)
        ..close();
      canvas.drawPath(
        areaPath,
        Paint()..color = cor.withOpacity(0.12),
      );
    }

    // Linha principal.
    canvas.drawPath(
      linePath,
      Paint()
        ..color = cor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );

    // Rotulos de min e max.
    _texto(canvas, max.toStringAsFixed(0), const Offset(0, 0));
    _texto(canvas, min.toStringAsFixed(0), Offset(0, altura - 14));
  }

  void _texto(Canvas canvas, String s, Offset pos) {
    final tp = TextPainter(
      text: TextSpan(
        text: s,
        style: const TextStyle(color: AppColors.textSecondary, fontSize: 10),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, pos);
  }

  @override
  bool shouldRepaint(covariant _LineChartPainter old) =>
      old.valores != valores || old.cor != cor;
}
