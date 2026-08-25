import 'package:flutter/material.dart';
import '../models/user.dart';
import '../controllers/movie_controller.dart';
import '../controllers/favorite_controller.dart';
import 'search_page.dart';
import 'favorites_page.dart';

class HomePage extends StatefulWidget {
  final User user;

  const HomePage({Key? key, required this.user}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  
  late MovieController _movieController;
  late FavoriteController _favoriteController;

  @override
  void initState() {
    super.initState();
    _movieController = MovieController();
    _favoriteController = FavoriteController(userId: widget.user.id);
    _favoriteController.loadFavorites();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = [
      SearchPage(movieController: _movieController, favoriteController: _favoriteController),
      FavoritesPage(favoriteController: _favoriteController),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Olá, ${widget.user.username}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/');
            },
          )
        ],
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Pesquisar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favoritos',
          ),
        ],
      ),
    );
  }
}