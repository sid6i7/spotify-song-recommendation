import 'package:flutter/material.dart';
import 'package:web/widgets/homepage_form.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                child: Image.asset("images/spotify_bg.png"),
              ),
              const HomePageForm(),
            ],
          ),
        ),
      ),
    );
  }
}
