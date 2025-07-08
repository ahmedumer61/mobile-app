import 'package:flutter/material.dart';
import 'package:fitness_app/common/colo_extension.dart';

class BlankView extends StatefulWidget {
  const BlankView({super.key});

  @override
  State<BlankView> createState() => _BlankViewState();
}

class _BlankViewState extends State<BlankView> {
  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;
    final block = media.width / 100;

    return Scaffold(
      backgroundColor: TColor.white,
      body: SafeArea(
        child: Center(
          child: Text(
            "Blank View",
            style: TextStyle(
              color: TColor.black,
              fontSize: block * 5, // Responsive font size
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
