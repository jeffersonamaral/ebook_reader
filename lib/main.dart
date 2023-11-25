import 'package:flutter/material.dart';
import 'package:ebook_reader/view/home.dart';
import 'package:ebook_reader/util/utilities.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

void main() async {
  toggleDebug(false);

  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize(debug: true, ignoreSsl: true);

  runApp(
      MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Leitor de eBooks',
          theme: ThemeData(
            primaryColor: Colors.white,
            primarySwatch: Colors.blueGrey,
            textSelectionTheme: const TextSelectionThemeData(
                selectionColor: Colors.blue
            ),
          ),
          home: const Home()
      )
  );
}