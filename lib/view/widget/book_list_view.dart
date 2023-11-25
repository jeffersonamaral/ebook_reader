import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ebook_reader/model/book_model.dart';
import 'package:ebook_reader/util/types.dart';

class BookListView extends StatefulWidget {

  final List<BookModel>? _data;

  final List<BookModel>? _favorites;

  late BookCallback _favoriteCallback;

  BookListView(this._data, this._favorites, {super.key,  required BookCallback onFavorite }) {
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
                border: Border.all(color: Colors.black)
            ),
            child: InkWell(
              onTap: () {},
              child: ListTile(
                title: Center(
                  child: Column(
                    children: [
                      Image.network(widget._data![index].coverUrl),
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