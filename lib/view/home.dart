import 'package:async/async.dart';
import 'package:ebook_reader/controller/favorite_controller.dart';
import 'package:ebook_reader/model/favorite_model.dart';
import 'package:flutter/material.dart';

import '../controller/book_controller.dart';
import '../model/book_model.dart';
import '../model/favorite_repository.dart';
import 'widget/book_grid_view.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {

  String _title = 'Livros';

  late TabController _tabController;

  final AsyncMemoizer _memoizerBooks = AsyncMemoizer();

  final BookController _bookController = BookController();

  final FavoriteController _favoriteController = FavoriteController(FavoriteRepository());

  @override
  bool get wantKeepAlive => true;

  List<BookModel> _favorites = [];

  Future<dynamic> _loadBooks() async {
    return _memoizerBooks.runOnce(() {
      return _bookController.loadBooks();
    });
  }

  void _loadFavorites() async {
    _favorites.clear();
    _favorites = await _favoriteController.findAll();
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

    _loadFavorites();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: Text(_title,
            style: const TextStyle(
              color: Colors.white
            ),
          ),
          bottom: PreferredSize(
              preferredSize: const Size(double.infinity, kToolbarHeight),
              child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      TabBar(
                        controller: _tabController,
                        tabs: const [
                          Tab(text: 'Livros', icon: Icon(Icons.book)),
                          Tab(text: 'Favoritos', icon: Icon(Icons.bookmark),),
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

                      books.forEach((element) {
                        if (_favorites.contains(element)) {
                          element.favorite = true;
                        }
                      });

                      return BookGridView(snapshot.data, _favorites,
                          withFavoritiesButton: true,
                          onFavorite: (model) {
                        if (model.favorite) {
                          _favoriteController.delete(FavoriteModel.fromMap(model.toMap()));
                        } else {
                          _favoriteController.save(FavoriteModel.fromMap(model.toMap()));
                        }
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
          FutureBuilder<dynamic>(
              future: _favoriteController.findAll(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.none
                    || snapshot.connectionState == ConnectionState.active
                    || snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  if (snapshot.hasData && snapshot.data.length > 0) {
                    if (snapshot.hasError) {
                      return Center(
                        child: Text('Ocorreu um erro: ${snapshot.error}'),
                      );
                    } else {
                      return BookGridView(snapshot.data, _favorites,
                        withFavoritiesButton: false,
                        onFavorite: null,
                      );
                    }
                  } else {
                    return const Center(
                      child: Text('Nenhum dado foi encontrado.'),
                    );
                  }
                }
              }
          ),
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