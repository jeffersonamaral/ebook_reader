import 'package:flutter/material.dart';
import 'package:ebook_reader/view/home.dart';
import 'package:ebook_reader/util/utilities.dart';

void main() async {
  toggleDebug(false);

  runApp(
      MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Leitor de eBooks',
          theme: ThemeData(
            primaryColor: Colors.blue,
            primarySwatch: Colors.blueGrey,
            textSelectionTheme: const TextSelectionThemeData(
                selectionColor: Colors.blue,
            ),
          ),
          home: const Home()
      )
  );
}