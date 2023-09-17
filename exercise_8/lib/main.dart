import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => FavoritesModel(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Lista de Tarefas'),
        ),
        body: FavoritesList(),
        floatingActionButton: AddToFavoritesButton(),
      ),
    );
  }
}

class FavoritesModel extends ChangeNotifier {
  List<String> _tasks = [];

  List<String> get tasks => _tasks;

  Future<void> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final savedTasks = prefs.getStringList('tasks') ?? [];
    _tasks = savedTasks;
    notifyListeners();
  }

  Future<void> addToFavorites(String item) async {
    _tasks.add(item);
    notifyListeners();
    await _saveFavorites();
  }

  Future<void> removeFromFavorites(String item) async {
    _tasks.remove(item);
    notifyListeners();
    await _saveFavorites();
  }

  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('tasks', _tasks);
  }
}

class FavoritesList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final favoritesModel = Provider.of<FavoritesModel>(context);
    favoritesModel.loadFavorites(); 

    return ListView.builder(
      itemCount: favoritesModel.tasks.length,
      itemBuilder: (context, index) {
        final item = favoritesModel.tasks[index];
        return ListTile(
          title: Text(item),
          trailing: IconButton(
            icon: Icon(Icons.remove),
            onPressed: () {
              favoritesModel.removeFromFavorites(item);
            },
          ),
        );
      },
    );
  }
}

class AddToFavoritesButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final favoritesModel = Provider.of<FavoritesModel>(context);

    return FloatingActionButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) {
            final TextEditingController controller = TextEditingController();
            return AlertDialog(
              title: Text('Adicionar à lista de tarefas'),
              content: TextField(
                controller: controller,
                decoration: InputDecoration(labelText: 'Item'),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('Cancelar'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text('Adicionar'),
                  onPressed: () {
                    favoritesModel.addToFavorites(controller.text);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
      child: Icon(Icons.add),
    );
  }
}
