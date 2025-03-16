import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../theme/app_theme.dart';

class PlaceholderImage extends StatelessWidget {
  final double width;
  final double height;
  
  const PlaceholderImage({
    super.key, 
    this.width = 200, 
    this.height = 200,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Light glow effect
        Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: primaryYellow.withOpacity(0.1), // Reduced from 0.2
                blurRadius: 15, // Reduced from 20
                spreadRadius: 1, // Reduced from 2
              ),
            ],
          ),
        ),
        // SVG image
        SvgPicture.asset(
          'assets/images/placeholder.svg',
          width: width,
          height: height,
        ),
      ],
    );
  }
}
