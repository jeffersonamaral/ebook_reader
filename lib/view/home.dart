import 'package:async/async.dart';
import 'package:flutter/material.dart';

import '../model/book_model.dart';
import '../controller/book_controller.dart';
import 'widget/book_list_view.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {

  String _title = 'Livros';

  late TabController _tabController;

  final AsyncMemoizer _memoizerBooks = AsyncMemoizer();

  final AsyncMemoizer _memoizerFavorities = AsyncMemoizer();

  final BookController _bookController = BookController();

  @override
  bool get wantKeepAlive => true;

  List<BookModel> _books = [];

  Future<dynamic> _loadBooks() async {
    return _memoizerBooks.runOnce(() {
      return _bookController.loadBooks();
    });
  }

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, vsync: this)
      ..addListener(() {
        setState(() {
          switch (_tabController.index) {
            case 0:
              _title = 'Livros';
              break;
            case 1:
              _title = 'Favoritos';
              break;
          }
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.blueAccent,
          title: Text(_title),
          bottom: PreferredSize(
              preferredSize: const Size(double.infinity, kToolbarHeight),
              child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      TabBar(
                        controller: _tabController,
                        tabs: const [
                          Tab(text: 'Livros'),
                          Tab(text: 'Favoritos'),
                        ],
                      )
                    ],
                  )))),
      body: TabBarView(
        controller: _tabController,
        children: [
          FutureBuilder<dynamic>(
              future: _loadBooks(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.none
                    || snapshot.connectionState == ConnectionState.active
                    || snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  if (snapshot.hasData) {
                    if (snapshot.hasError) {
                      return Center(
                        child: Text('Ocorreu um erro: ${snapshot.error}'),
                      );
                    } else {
                      List<BookModel> books = snapshot.data!;

                      /*
                      books.forEach((element) {
                        if (_favorites.contains(element)) {
                          element.favorite = true;
                        }
                      });
                      */

                      return BookListView(snapshot.data, null /*_favorites*/, onFavorite: (model) {
                        /*
                        if (model.favorite) {
                          _favoriteController.delete(model);
                        } else {
                          _favoriteController.save(model);
                        }
                        */
                      });
                    }
                  } else {
                    return const Center(
                      child: Text('Nenhum dado foi encontrado.'),
                    );
                  }
                }
              }
          ),
          const Center(child: Text('Listagem de Favoritos')),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();

    super.dispose();
  }
}
