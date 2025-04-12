import 'package:flutter/material.dart';

class details extends StatefulWidget {
  const details({super.key, required this.id});
 final String id;

  @override
  State<details> createState() => _detailsState();
}

class _detailsState extends State<details> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(
        title: Text("rrr"),
      ),
    );
  }
}