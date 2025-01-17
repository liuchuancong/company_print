import 'package:flutter/material.dart';

class DriverListCursor extends StatelessWidget {
  final double size;

  final String title;

  final double arrowSize = 30;

  const DriverListCursor({
    super.key,
    required this.size,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        _buildTitle(),
        Positioned(
          right: -arrowSize * 0.5 - 2.5,
          top: (size - arrowSize) * 0.5,
          child: _buildArrow(),
        ),
      ],
    );
  }

  Widget _buildArrow() {
    Widget resultWidget = Icon(
      Icons.arrow_right,
      color: Colors.black54,
      size: arrowSize,
    );
    return resultWidget;
  }

  Widget _buildTitle() {
    Widget resultWidget = Text(
      title,
      style: const TextStyle(color: Colors.white, fontSize: 32),
    );
    resultWidget = Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(5),
      ),
      child: resultWidget,
    );
    return resultWidget;
  }
}
