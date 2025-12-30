import 'package:flutter/material.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});
  static const routeName = 'LandingPage';
  static const routePath = '/LandingPage';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('LandingPage')),
      body: SafeArea(child: SingleChildScrollView(child: Column(children: []))),
    );
  }
}
