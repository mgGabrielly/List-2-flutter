import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
  List<String> _task = [];

  List<String> get task => _task;

  void addToFavorites(String item) {
    _task.add(item);
    notifyListeners();
  }

  void removeFromFavorites(String item) {
    _task.remove(item);
    notifyListeners();
  }
}

class FavoritesList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final favoritesModel = Provider.of<FavoritesModel>(context);

    return ListView.builder(
      itemCount: favoritesModel.task.length,
      itemBuilder: (context, index) {
        final item = favoritesModel.task[index];
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
