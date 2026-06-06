import 'package:flutter/material.dart';

import '../core/constants/app_dimens.dart';

/// Envolve o conteúdo limitando sua largura máxima e centralizando-o,
/// garantindo boa responsividade em tablets e web sem espalhar os
/// elementos em telas largas.
class ResponsiveContent extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;

  const ResponsiveContent({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppDimens.md),
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: AppDimens.maxContentWidth),
        child: Padding(padding: padding, child: child),
      ),
    );
  }
}
