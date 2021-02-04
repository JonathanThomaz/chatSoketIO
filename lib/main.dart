import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import './pages/AllChatsPage.dart';
import './models/ChatModel.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModel(
      model: ChatModel(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: AllChatsPage(),
      ),
    );
  }
}
