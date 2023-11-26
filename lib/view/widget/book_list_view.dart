import 'dart:io';

import 'package:dio/dio.dart';
import 'package:ebook_reader/model/book_model.dart';
import 'package:ebook_reader/util/types.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:vocsy_epub_viewer/epub_viewer.dart';

class BookListView extends StatefulWidget {

  final List<BookModel>? _data;

  final List<BookModel>? _favorites;

  late BookCallback _favoriteCallback;

  BookListView(this._data, this._favorites, {super.key, required BookCallback onFavorite }) {
    _favoriteCallback = onFavorite;

    /*
    this._data?.forEach((element) {
      if (this._favorites!.any((e) => e.name == element.name)) {
        element.favorite = true;
      }
    });
    */
  }

  @override
  _BookListViewState createState() => _BookListViewState();

}

class _BookListViewState extends State<BookListView> {

  bool loading = false;
  Dio dio = Dio();
  String filePath = "";

  Future<void> download(String url, String identifier, String bookTitle) async {
    if (Platform.isAndroid || Platform.isIOS) {
      await startDownload(url, identifier, bookTitle);
    } else {
      loading = false;
    }
  }

  Future<void> startDownload(String url, String identifier, String bookTitle) async {
    Directory appDocDir = await getApplicationDocumentsDirectory();

    String path = '${appDocDir.path}/$identifier.epub';
    File file = File(path);

    if (!File(path).existsSync()) {
      await file.create();
      await dio.download(
        url,
        path,
        deleteOnError: true,
        onReceiveProgress: (receivedBytes, totalBytes) {
          setState(() {
            loading = true;
          });
        },
      ).whenComplete(() {
        setState(() {
          loading = false;
          filePath = path;
        });

        openBook(bookTitle);
      });
    } else {
      setState(() {
        loading = false;
        filePath = path;
      });

      openBook(bookTitle);
    }
  }

  void openBook(String bookTitle) {
    VocsyEpub.setConfig(
      themeColor: Theme.of(context).primaryColor,
      identifier: bookTitle,
      scrollDirection: EpubScrollDirection.HORIZONTAL,
      nightMode: true
    );

    VocsyEpub.open(
      filePath
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        padding: const EdgeInsets.all(10),
        physics: const BouncingScrollPhysics(),
        itemCount: widget._data?.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey)
            ),
            child: InkWell(
              onTap: () async {
                download(
                    widget._data![index].downloadUrl,
                    widget._data![index].id.toString(),
                    widget._data![index].title);
              },
              child: ListTile(
                title: Center(
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black)
                        ),
                        child: Stack(
                          children: [
                            Image.network(widget._data![index].coverUrl),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  widget._favoriteCallback(widget._data![index]);
                                  widget._data![index].favorite = !widget._data![index].favorite;

                                  // FIXME implementar salvar como favorito
                                });
                              },
                              child: widget._data![index].favorite == true
                                ? const Icon(Icons.bookmark, color: Colors.red,)
                                : const Icon(Icons.bookmark_border, color: Colors.black,)
                            )
                          ],
                        ),
                      ),
                      Text(widget._data![index].title,
                        style: const TextStyle(
                            fontSize: 15
                        ),
                      ),
                      Text(widget._data![index].author,
                        style: const TextStyle(
                            fontSize: 15,
                            fontStyle: FontStyle.italic
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ),
          );
        }
    );
  }
}