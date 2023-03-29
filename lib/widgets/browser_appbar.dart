import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import '../model/bookmark.dart';
import '../screens/HistoryScreen.dart';
import '../screens/bookmark_screen.dart';
import 'package:collection/collection.dart';


class BrowserAppBar extends StatefulWidget {
   BrowserAppBar({Key? key,required this.webViewController,required this.bookmarkList,required this.urlTextController,required this.pageIsLoaded}) : super(key: key);
  InAppWebViewController? webViewController;
   List<Bookmark> bookmarkList;
   TextEditingController urlTextController;
   bool pageIsLoaded;

  @override
  State<BrowserAppBar> createState() => _BrowserAppBarState();
}

class _BrowserAppBarState extends State<BrowserAppBar> {
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
                        bookmarks: widget.bookmarkList,
                      )));
            },
          ),
          Stack(
            alignment: Alignment.center,
            children: <Widget>[
              IconButton(
                icon: const Icon(Icons.history),
                onPressed: () async {
                  WebHistory? history =
                  await widget.webViewController?.getCopyBackForwardList();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HistoryScreen(
                        history: history,
                      ),
                    ),
                  );
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
              widget.webViewController?.getTitle() ?? Future.value(''),
              widget.webViewController?.getFavicons() ??
                  Future.value([Favicon(url: Uri.parse(''))]),
            ]),
            builder: (context, AsyncSnapshot<List> snapshot) {
              //String url=snapshot.data?[0].toString()??'';
              //print('$url == ${urlTextController.text}');

              return (/*url.contains(urlTextController.text))*/
                  IconButton(
                    icon: Icon(
                      /*bookmarkList.firstWhere(
                      (val) => val.url == urlTextController.text) !=
                  null*/
                      //bookmarkList.keys.contains(urlTextController.text)
                      /* bookmarkList
                      .map((item) => item.url)
                      .contains(urlTextController.text)*/
                        widget.bookmarkList.firstWhereOrNull((val) =>
                        val.url == widget.urlTextController.text) !=
                            null
                            ? Icons.star
                            : Icons.star_border),
                    onPressed: widget.pageIsLoaded
                        ? () async {
                      String title1 = snapshot.data?[0].toString() ?? '';
                      List<Favicon> icon1 = snapshot.data?[1] ??
                          [Favicon(url: Uri.parse(''))];
                      if (widget.urlTextController.text.isNotEmpty) {
                        /* if (bookmarksList.contains(urlTextController.text)) {
                      bookmarksList.remove(urlTextController.text);
                    } else {
                      bookmarksList.add(urlTextController.text);
                      String? title= await webViewController?.getTitle();
                      print('титульник ${title}');
                    }*/

                        if (widget.bookmarkList.firstWhereOrNull((val) =>
                        val.url == widget.urlTextController.text) !=
                            null
                        /* bookmarkList
                      .map((item) => item.url)
                      .contains(urlTextController.text)*/

                        ) {
                          widget.bookmarkList.removeWhere((element) =>
                          element.url == widget.urlTextController.text);
                        } else {
                          /*String? title = await webViewController?.getTitle();
                    List<Favicon>? icon =
                    await webViewController?.getFavicons();
                    Favicon icon1=icon![0];
                    print('иконка: ${icon1.url}');*/
                          String url = widget.urlTextController.text;
                          widget.bookmarkList
                              .add(Bookmark(title1, url, icon1[0]));
                        }

                        /*if (bookmarkList.keys.contains(urlTextController.text)) {
                          bookmarkList.remove(urlTextController.text);
                        } else {
                          bookmarkList
                              .addEntries({urlTextController.text: title}.entries);
                          print('aaa ${bookmarkList[urlTextController.text]}');
                        }*/
                        setState(() {});
                      }
                    }
                        : null,
                  ));
            }),
        IconButton(
          icon: const Icon(Icons.home),
          onPressed: () async {
            WebHistory? history =
            await widget.webViewController?.getCopyBackForwardList();
            //print('История ${history!.list![0]}');
            widget.webViewController?.goTo(historyItem: history!.list![0]);
          },
        )
      ],
    );
  }
}
