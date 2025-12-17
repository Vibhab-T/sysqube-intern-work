import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingWidget extends StatelessWidget {
  final double height;
  final Color? color;

  const LoadingWidget({
    super.key,
    this.height = 200,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final spinnerColor = color ?? (isDark ? Colors.white : Colors.blue);

    return SizedBox(
      height: height,
      child: Center(
        child: SpinKitCircle(
          color: spinnerColor,
          size: 50.0,
        ),
      ),
    );
  }
}
