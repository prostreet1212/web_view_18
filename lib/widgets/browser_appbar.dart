import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import '../model/bookmark.dart';
import '../screens/history_screen.dart';
import '../screens/bookmark_screen.dart';
import 'package:collection/collection.dart';



class BrowserAppBar extends StatelessWidget {
   BrowserAppBar(
      {Key? key,
        required this.webViewController,
        //required this.bookmarkList,
        required this.urlTextController,
        required this.pageIsLoaded,
        required this.customSetState
      })
      : super(key: key);

  final InAppWebViewController? webViewController;
  //List<Bookmark> bookmarkList;
  final TextEditingController urlTextController;
  final bool pageIsLoaded;
  final Function customSetState;

  List<Bookmark> bookmarkList = [];
  StreamController<List<Bookmark>> bookmarkStream =
  StreamController<List<Bookmark>>.broadcast();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      centerTitle: true,
      titleSpacing: 0.0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          IconButton(
            icon: const Icon(Icons.bookmark),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BookmarkScreen(
                    bookmarks: bookmarkList,
                  ),
                ),
              );
            },
          ),
          Stack(
            alignment: Alignment.center,
            children: <Widget>[
              IconButton(
                icon: const Icon(Icons.history),
                onPressed: () async {
                  WebHistory? history =
                  await webViewController?.getCopyBackForwardList();
                  if (context.mounted) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HistoryScreen(
                          history: history,
                        ),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
          const Expanded(
            child: Center(child: Text('InAppWebView')),
          )
        ],
      ),
      actions: [
        FutureBuilder(
            future: Future.wait([
              webViewController?.getTitle() ?? Future.value(''),
              webViewController?.getFavicons() ??
                  Future.value([Favicon(url: Uri.parse(''))]),
            ]),
            builder: (context, AsyncSnapshot<List> snapshot) {
              return StreamBuilder<List<Bookmark>>(
                stream: bookmarkStream.stream,
                  //initialData: [],
                  builder: (context,snap){
                    print('REBUILD');
                    bookmarkList=snap.data??[];
                  return IconButton(
                    icon: Icon(bookmarkList.firstWhereOrNull(
                            (val) => val.url == urlTextController.text) !=
                        null
                        ? Icons.star
                        : Icons.star_border),
                    onPressed: pageIsLoaded
                        ? () async {
                      String title1 = snapshot.data?[0].toString() ?? '';
                      List<Favicon> icon1 =
                          snapshot.data?[1] ?? [Favicon(url: Uri.parse(''))];
                      if (urlTextController.text.isNotEmpty) {
                        if (bookmarkList.firstWhereOrNull(
                                (val) => val.url == urlTextController.text) !=
                            null) {
                          bookmarkList.removeWhere((element) =>
                          element.url == urlTextController.text);
                        } else {
                          String url = urlTextController.text;
                          bookmarkList.add(Bookmark(title1, url, icon1[0]));
                        }
                        //customSetState();
                        //bookmarkList=books;
                        bookmarkStream.sink.add(bookmarkList);
                        //customSetState();
                      }
                    }
                        : null,
                  );
                  });
            }),
        IconButton(
          icon: const Icon(Icons.home),
          onPressed: () async {
            WebHistory? history =
            await webViewController?.getCopyBackForwardList();
            webViewController?.goTo(historyItem: history!.list![0]);
          },
        )
      ],
    );
  }
}



/*
class BrowserAppBar extends StatelessWidget {
  BrowserAppBar(
      {Key? key,
      required this.webViewController,
      //required this.bookmarkList,
      required this.urlTextController,
      required this.pageIsLoaded,
      required this.customSetState})
      : super(key: key);

  final InAppWebViewController? webViewController;
  //List<Bookmark> bookmarkList;
  final TextEditingController urlTextController;
  final bool pageIsLoaded;
  final Function customSetState;

  StreamController<List<Bookmark>> controller =
      StreamController<List<Bookmark>>();
   List<Bookmark> bookmarkList = [];

  StreamController<List<Bookmark>> _passVisibility =
      StreamController<List<Bookmark>>.broadcast();

  @override
  Widget build(BuildContext context) {
//_passVisibility.sink.add(bookmarkList);

    return AppBar(
      automaticallyImplyLeading: false,
      centerTitle: true,
      titleSpacing: 0.0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          IconButton(
            icon: const Icon(Icons.bookmark),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BookmarkScreen(
                    bookmarks: bookmarkList,
                  ),
                ),
              );
            },
          ),
          Stack(
            alignment: Alignment.center,
            children: <Widget>[
              IconButton(
                icon: const Icon(Icons.history),
                onPressed: () async {
                  WebHistory? history =
                      await webViewController?.getCopyBackForwardList();
                  if (context.mounted) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HistoryScreen(
                          history: history,
                        ),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
          const Expanded(
            child: Center(child: Text('InAppWebView')),
          )
        ],
      ),
      actions: [
        StreamBuilder<List<Bookmark>>(
            stream: _passVisibility.stream??Stream.value([]),
            initialData: [],
            builder: (context, snapshot1) {
              print('rebuild');

              /*if(snapshot1.connectionState==ConnectionState.active)*/ {

                return IconButton(
                  icon: Icon(snapshot1.data?.firstWhereOrNull(
                              (val) => val.url == urlTextController.text) !=
                          null
                      ? Icons.star
                      : Icons.star_border),
                  onPressed: pageIsLoaded
                      ? () async {
                          /*String title1 = snapshot.data?[0].toString() ?? '';
              List<Favicon> icon1 =
                  snapshot.data?[1] ?? [Favicon(url: Uri.parse(''))];*/

                          if (urlTextController.text.isNotEmpty) {
                            List<Bookmark> books = snapshot1.data ?? [];
                            if (books.firstWhereOrNull((val) =>
                                    val.url == urlTextController.text) !=
                                null) {
                              books.removeWhere((element) =>
                                  element.url == urlTextController.text);
                            } else {
                              String url = urlTextController.text;
                              books.add(Bookmark(
                                  'title1',
                                  url,
                                  Favicon(
                                      url: Uri.parse(
                                          'https://cdn-icons-png.flaticon.com/512/2991/2991148.png'))));
                              //bookmarkList.add(Bookmark('title1', url, null));
                              //snapshot1.data!=[];
                            }
                            //customSetState();
                           // _passVisibility.sink;
                            bookmarkList=books;
                            _passVisibility.sink.add(bookmarkList);
                          }

                        }
                      : null,
                );
              }
            }),
        /*FutureBuilder(
            future: Future.wait([
              webViewController?.getTitle() ?? Future.value(''),
              webViewController?.getFavicons() ??
                  Future.value([Favicon(url: Uri.parse(''))]),
            ]),
            builder: (context, AsyncSnapshot<List> snapshot) {
              return
            }),*/
        IconButton(
          icon: const Icon(Icons.home),
          onPressed: () async {
            WebHistory? history =
                await webViewController?.getCopyBackForwardList();
            webViewController?.goTo(historyItem: history!.list![0]);
          },
        )
      ],
    );
  }
}*/


