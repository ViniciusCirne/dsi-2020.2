import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Startup Name Generator',
      theme: ThemeData(
        primaryColor: Colors.white,
      ),
      home: RandomWords(),
    );
  }
}

class RandomWords extends StatefulWidget {
  @override
  _RandomWordsState createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[];
  final _saved = <WordPair>{};
  final _biggerFont = const TextStyle(fontSize: 18);
  late WordPair wordP;
  late String firstW;
  late String secondW;

  @override
  Widget build(BuildContext context) {
    return Scaffold (
      appBar: AppBar(
        title: Text('Startup Name Generator'),
        actions: [
          IconButton(icon: Icon(Icons.list), onPressed: _pushSaved),
        ],
      ),
      body: _buildSuggestions(),
    );
  }
  Widget _buildRow(WordPair pair) {
    final alreadySaved = _saved.contains(pair);
    return ListTile(
      title: Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
      trailing: IconButton(
        icon: alreadySaved ? Icon(Icons.favorite) : Icon(Icons.favorite_border),
        color: alreadySaved ? Colors.pinkAccent : null,
        onPressed: () {
          setState(() {
            if (alreadySaved) {
              //Icon(Icons.favorite_border, color: null,);
              _saved.remove(pair);
            } else {
              //Icon(Icons.favorite, color: Colors.pinkAccent,);
              _saved.add(pair);
            }
          });
        },
      ),
      onTap: () {
        _updateList(pair, _suggestions.indexOf(pair));
      }
    );
  }

  Widget _buildSuggestions() {
    return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemBuilder: (BuildContext _context, int i) {
          if (i.isOdd) {
            return Divider();
          }
          final int index = i ~/ 2;
          if (index >= _suggestions.length) {
            _suggestions.addAll(generateWordPairs().take(10));
          }
          return Dismissible(
            child: _buildRow(_suggestions[index]),
            key: ValueKey(_suggestions[index]),
            background: Container(
            color: Colors.red,
            ),
            onDismissed: (DismissDirection direction){
              _removeSaved(_suggestions[index]);
              setState(() {
                _suggestions.removeAt(index);
              });
            }
          );
        }
    );
  }
  void _removeSaved(WordPair pair){
    _saved.remove(pair);
  }

  void _pushSaved() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          final tiles = _saved.map(
                (WordPair pair) {
              return ListTile(
                title: Text(
                  pair.asPascalCase,
                  style: _biggerFont,
                ),
              );
            },
          );
          final divided = tiles.isNotEmpty
              ? ListTile.divideTiles(context: context, tiles: tiles).toList()
              : <Widget>[];

          return Scaffold(
            appBar: AppBar(
              title: Text('Saved Suggestions'),
            ),
            body: ListView(children: divided),
          );
        },
      ),
    );
  }
  void _updateList(WordPair pair, int index) {
    String firstW = "";
    String secondW = "";

    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Edit Item'),
            ),
            body: Column(
              children: [
                TextField(
                  onChanged: (text){
                    firstW = text;
                  },
                  decoration: const InputDecoration(
                      labelText: 'First Word',
                      border: OutlineInputBorder()
                    ),
                ),
                TextField(
                  onChanged: (text){
                    secondW = text;
                  },
                  decoration: const InputDecoration(
                      labelText: 'Second Word',
                      border: OutlineInputBorder()
                  ),
                ),
                ElevatedButton(
                    child: Text('Confirm'),
                    onPressed: () {
                     _suggestions.remove(pair);
                     saveW(_suggestions.indexOf(pair), firstW, secondW);
                     Navigator.of(context).pop();
                  }

                )
              ],
            )
          );
        },
      ),
    );
  }

  void saveW (int index, String first, String second){
    setState((){
      wordP = WordPair(first, second);
      _suggestions.insert(index, wordP);
    });
  }
}


