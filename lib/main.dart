import 'package:flutter/material.dart';
import 'package:ebook_reader/view/home.dart';

void main() {
  runApp(
      MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Leitor de eBooks',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            primaryColor: Colors.amber,
          ),
          home: const Home()
      )
  );
}