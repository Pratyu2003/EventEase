import 'package:flutter/material.dart';
import 'package:google_fonts/src/asset_manifest.dart';

class profileScreen extends StatelessWidget {
  const profileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Text("Create Profile"),
        ),
      ),
    );
  }
}
