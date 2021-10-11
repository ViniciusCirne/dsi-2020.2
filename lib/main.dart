import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'dart:async';

void main() async{
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Band Name Survey',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Possible Band Names'),
    );
  }
}

class MyHomePage extends StatelessWidget{
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  Widget _buildListItem(BuildContext context, DocumentSnapshot document) {
    return ListTile(
      title: Row(
        children: [
          Expanded(
            child: Text(
              document['nome'],
              style: Theme.of(context).textTheme.headline1
            )
          ),
          Container(
            decoration: const BoxDecoration(
              color: Color(0xffddddff),
            ),
          padding: const EdgeInsets.all(10.0),
          child: Text(
            document['votos'].toString(),
            style: Theme.of(context).textTheme.headline3
          )
          )
        ],
      ),
      onTap: () {
        Firestore.instance.runTransaction((transaction) async {
          DocumentSnapshot freshSnap =
              await transaction.get(document, reference);
          await transaction.update(freshSnap, reference, {
            'votos': freshSnap['votos'] + 1,
          });
        });
      },
    );
  }

  @override

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: StreamBuilder(
        stream: Firestore.instance.collection('bandnames').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Text ('Carregando...');
          return ListView.builder(
            itemExtent: 80.0,
            itemCount: snapshot.data.documents.lenght,
            itemBuilder: (context, index) =>
                _buildListItem(context, snapshot.data.documents[index]),
          );
        }
      )
    );
  }
}