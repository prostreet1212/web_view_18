import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import '../model/bookmark.dart';
import '../screens/history_screen.dart';
import '../screens/bookmark_screen.dart';
import 'package:collection/collection.dart';

class BrowserAppBar extends StatelessWidget {
  const BrowserAppBar(
      {Key? key,
      required this.webViewController,
      required this.bookmarkList,
      required this.urlTextController,
      required this.pageIsLoaded,
      required this.customSetState})
      : super(key: key);

  final InAppWebViewController? webViewController;
  final List<Bookmark> bookmarkList;
  final TextEditingController urlTextController;
  final bool pageIsLoaded;
  final Function customSetState;

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
              return (IconButton(
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
                          customSetState();
                        }
                      }
                    : null,
              ));
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
