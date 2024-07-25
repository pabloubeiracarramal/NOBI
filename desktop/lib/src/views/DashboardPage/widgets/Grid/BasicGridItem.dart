import 'package:flutter/material.dart';

class BasicGridItem extends StatelessWidget {
  final String label;

  const BasicGridItem({Key? key, required this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      color: Colors.blue,
      child: Text(label, style: TextStyle(color: Colors.white)),
    );
  }
}
