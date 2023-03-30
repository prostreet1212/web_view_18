import 'package:flutter/material.dart';
import '../model/bookmark.dart';

class BookmarkScreen extends StatelessWidget {
  const BookmarkScreen({Key? key, required this.bookmarks}) : super(key: key);
  final List<Bookmark> bookmarks;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookmarks'),
      ),
      body: ListView.separated(
        itemCount: bookmarks.length,
        itemBuilder: (context, i) {
          return ListTile(
            leading: Image.network(
              '${bookmarks[i].icon!.url}',
              height: 35,
            ),
            title: Text(bookmarks[i].title.toString()),
            subtitle: Text(bookmarks[i].url.toString()),
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
