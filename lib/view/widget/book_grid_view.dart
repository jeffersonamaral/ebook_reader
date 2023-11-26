import 'dart:io';

import 'package:dio/dio.dart';
import 'package:ebook_reader/model/book_model.dart';
import 'package:ebook_reader/util/types.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:vocsy_epub_viewer/epub_viewer.dart';

class BookGridView extends StatefulWidget {

  final List<BookModel>? _data;

  final List<BookModel>? _favorites;

  BookCallback? _favoriteCallback;

  final bool withFavoritiesButton;

  BookGridView(this._data, this._favorites,
      {super.key,
        required BookCallback? onFavorite,
        boolwithFavoritiesButton = true,
        required this.withFavoritiesButton }) {
    _favoriteCallback = onFavorite;

    _data?.forEach((element) {
      if (_favorites!.any((e) => e.id == element.id)) {
        element.favorite = true;
      }
    });
  }

  @override
  _BookGridViewState createState() => _BookGridViewState();

}

class _BookGridViewState extends State<BookGridView> {

  bool _loading = false;
  Dio _dio = Dio();
  String _filePath = "";

  Future<void> download(String url, String identifier, String bookTitle) async {
    if (Platform.isAndroid || Platform.isIOS) {
      Directory appDocDir = await getApplicationDocumentsDirectory();

      String path = '${appDocDir.path}/$identifier.epub';
      File file = File(path);

      if (!File(path).existsSync()) {
        await file.create();
        await _dio.download(
          url,
          path,
          deleteOnError: true,
          onReceiveProgress: (receivedBytes, totalBytes) {
            setState(() {
              _loading = true;
            });
          },
        ).whenComplete(() {
          setState(() {
            _loading = false;
            _filePath = path;
          });

          openBook(bookTitle);
        });
      } else {
        setState(() {
          _loading = false;
          _filePath = path;
        });

        openBook(bookTitle);
      }
    } else {
      _loading = false;
    }
  }

  void openBook(String bookTitle) {
    VocsyEpub.setConfig(
      themeColor: Theme.of(context).primaryColor,
      identifier: bookTitle,
      scrollDirection: EpubScrollDirection.HORIZONTAL,
      nightMode: MediaQuery.of(context).platformBrightness == Brightness.dark
    );

    VocsyEpub.open(
      _filePath
    );
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        padding: const EdgeInsets.all(10),
        physics: const BouncingScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 2,
          mainAxisSpacing: 5
        ),
        controller: ScrollController(keepScrollOffset: false),
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: widget._data?.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(bottom: 5),
            /*
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey)
            ),
            */
            child: InkWell(
              onTap: () async {
                download(
                    widget._data![index].downloadUrl,
                    widget._data![index].id.toString(),
                    widget._data![index].title);
              },
              child: ListTile(
                title: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black)
                        ),
                        child: Stack(
                          children: [
                            Image.network(widget._data![index].coverUrl),
                             Positioned.fill(
                              child: widget.withFavoritiesButton ? Align(
                                  alignment: Alignment.topRight,
                                  child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          widget._favoriteCallback!(widget._data![index]);
                                          widget._data![index].favorite = !widget._data![index].favorite;
                                        });
                                      },
                                      child: widget._data![index].favorite == true
                                          ? Icon(Icons.bookmark,
                                          color: Colors.red,
                                          size: IconTheme.of(context).size! * 2
                                      )
                                          : Icon(Icons.bookmark_border,
                                          color: Colors.black,
                                          size: IconTheme.of(context).size! * 2
                                      )
                                  )
                              ) : Container(),
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
              )
            ),
          );
        }
    );
  }
}