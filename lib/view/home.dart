import 'package:async/async.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {

  late TabController _tabController;

  final AsyncMemoizer _memoizerBooks = AsyncMemoizer();

  final AsyncMemoizer _memoizerFavorities = AsyncMemoizer();

  @override
  bool get wantKeepAlive => true;

  String _title = 'Livros';

  @override
  void initState() {
    super.initState();

    _tabController = TabController(
        length: 2,
        vsync: this
    )..addListener(() {
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
                  )
              )
          )
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          Center(child: Text('Listagem de Livros')),
          Center(child: Text('Listagem de Favoritos')),
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