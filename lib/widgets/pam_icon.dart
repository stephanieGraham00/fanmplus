import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PamIcon extends StatelessWidget {
  final String name;
  final double size;
  final Color? color;

  const PamIcon({super.key, required this.name, this.size = 24, this.color});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/icons/cute_$name.svg',
      width: size,
      height: size,
      colorFilter:
          color != null ? ColorFilter.mode(color!, BlendMode.srcIn) : null,
    );
  }
}
