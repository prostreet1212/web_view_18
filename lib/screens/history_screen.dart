import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({Key? key, required this.history}) : super(key: key);
  final WebHistory? history;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
      ),
      body: ListView.separated(
        itemCount: history!.list!.length,
        itemBuilder: (context, i) {
          return ListTile(
            title: Text(history!.list![i].title.toString()),
            subtitle: Text(history!.list![i].url.toString()),
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return const Divider(
            thickness: 5,
          );
        },
      ),
    );
  }
}
