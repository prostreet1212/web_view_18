import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:web_view_18/model/bookmark.dart';
import 'package:collection/collection.dart';
import 'package:web_view_18/screens/bookmark_screen.dart';
import 'package:web_view_18/screens/history_screen.dart';
import 'package:web_view_18/widgets/browser_appbar.dart';

class BrowserScreen extends StatefulWidget {
  const BrowserScreen({Key? key}) : super(key: key);

  @override
  State<BrowserScreen> createState() => _BrowserScreenState();
}

class _BrowserScreenState extends State<BrowserScreen> {
  TextEditingController urlTextController = TextEditingController();
  String? title = '';
  Favicon? icon;
  InAppWebViewController? webViewController;
  bool pageIsLoaded = false;

  double progress = 0;

  //final Map<String, String?> bookmarkList = {};
  List<Bookmark> bookmarkList = [];

  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
          useShouldOverrideUrlLoading: true,
          mediaPlaybackRequiresUserGesture: false,
          allowFileAccessFromFileURLs: true,
          javaScriptEnabled: true),
      android: AndroidInAppWebViewOptions(
        useHybridComposition: true,
      ),
      ios: IOSInAppWebViewOptions(
        allowsInlineMediaPlayback: true,
      ));

  @override
  void initState() {
    //urlTextController.text = url;
    urlTextController.text = 'https://www.google.com';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: PreferredSize(child: BrowserAppBar(
          webViewController: webViewController,
          bookmarkList: bookmarkList,
          urlTextController: urlTextController,
          pageIsLoaded: pageIsLoaded,),
          preferredSize: Size(double.infinity, 60),),
        /*AppBar(
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
                          await webViewController?.getCopyBackForwardList();
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
                  webViewController?.getTitle() ?? Future.value(''),
                  webViewController?.getFavicons() ??
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
                        bookmarkList.firstWhereOrNull((val) =>
                                    val.url == urlTextController.text) !=
                                null
                            ? Icons.star
                            : Icons.star_border),
                    onPressed: pageIsLoaded
                        ? () async {
                            String title1 = snapshot.data?[0].toString() ?? '';
                            List<Favicon> icon1 = snapshot.data?[1] ??
                                [Favicon(url: Uri.parse(''))];
                            if (urlTextController.text.isNotEmpty) {
                              /* if (bookmarksList.contains(urlTextController.text)) {
                      bookmarksList.remove(urlTextController.text);
                    } else {
                      bookmarksList.add(urlTextController.text);
                      String? title= await webViewController?.getTitle();
                      print('титульник ${title}');
                    }*/

                              if (bookmarkList.firstWhereOrNull((val) =>
                                          val.url == urlTextController.text) !=
                                      null
                                  /* bookmarkList
                      .map((item) => item.url)
                      .contains(urlTextController.text)*/

                                  ) {
                                bookmarkList.removeWhere((element) =>
                                    element.url == urlTextController.text);
                              } else {
                                /*String? title = await webViewController?.getTitle();
                    List<Favicon>? icon =
                    await webViewController?.getFavicons();
                    Favicon icon1=icon![0];
                    print('иконка: ${icon1.url}');*/
                                String url = urlTextController.text;
                                bookmarkList
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
                    await webViewController?.getCopyBackForwardList();
                //print('История ${history!.list![0]}');
                webViewController?.goTo(historyItem: history!.list![0]);
              },
            )
          ],
        ),*/
        body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Row(
            children: [
              FutureBuilder(
                  future:
                  webViewController?.canGoBack() ?? Future.value(false),
                  builder: (context, snapshot) {
                    final canGoBack =
                    snapshot.hasData ? snapshot.data! : false;
                    return IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: !canGoBack
                          ? null
                          : () {
                        webViewController?.goBack();
                      },
                    );
                  }),
              FutureBuilder(
                  future: webViewController?.canGoForward() ??
                      Future.value(false),
                  builder: (context, snapshot) {
                    final canGoForward =
                    snapshot.hasData ? snapshot.data! : false;
                    return IconButton(
                      icon: const Icon(Icons.arrow_forward),
                      onPressed: !canGoForward
                          ? null
                          : () {
                        webViewController?.goForward();
                      },
                    );
                  }),
              FutureBuilder(
                  future:
                  webViewController?.isLoading() ?? Future.value(false),
                  builder: (context, snapshot) {
                    bool isLoading =
                    snapshot.hasData ? snapshot.data! : false;
                    return IconButton(
                      icon: Icon(isLoading ? Icons.clear : Icons.refresh),
                      onPressed: () {
                        if (!isLoading) {
                          webViewController!.loadUrl(
                              urlRequest: URLRequest(
                                  url: Uri.parse(urlTextController.text)));
                        } else {
                          webViewController!.stopLoading();
                        }
                      },
                    );
                  }),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: TextField(
                    controller: urlTextController,
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey[300],
                        hintText: 'Введите url',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: const BorderSide(
                            width: 0,
                            style: BorderStyle.none,
                          ),
                        ),
                        contentPadding: const EdgeInsets.all(12)),
                    onChanged: (text) {
                      setState(() {});
                    },
                  ),
                ),
              )
            ],
          ),
          progress < 1.0
              ? LinearProgressIndicator(
            value: progress,
          )
              : Container(
            height: 4,
          ),
          Expanded(
            child: InAppWebView(
              initialUrlRequest: URLRequest(
                url: Uri.parse(urlTextController.text),
              ),
              initialOptions: options,
              onWebViewCreated: (controller) async {
                webViewController = controller;
              },
              onLoadStart: (controller, url) {
                if (url != null) {
                  setState(() {
                    urlTextController.text = url.toString();
                    pageIsLoaded = false;
                  });
                }
              },
              onProgressChanged: (controller, progress) {
                setState(() {
                  this.progress = progress / 100;
                });
              },
              onUpdateVisitedHistory: (controller, url, isReload) {
                if (url != null) {
                  /*title=await webViewController?.getTitle();
                    icon=(await webViewController?.getFavicons())![0];*/
                  setState(() {
                    urlTextController.text = url.toString();
                    pageIsLoaded = false;
                  });
                }
              },
              onLoadStop: (controller, url) {
                setState(() {
                  pageIsLoaded = true;
                });
              },
              shouldOverrideUrlLoading:
                  (controller, shouldOverrideUrlLoadingRequest) async {
                setState(() {
                  pageIsLoaded = false;
                });
                return NavigationActionPolicy.ALLOW;
              },
              onLoadError: (controller, url, code, message) {
                setState(() {
                  pageIsLoaded = false;
                });
              },
            ),
          )
        ],
      ),
    ),
    onWillPop: () async {
    if (await webViewController!.canGoBack()) {
    webViewController!.goBack();
    return false;
    } else {
    return true;
    }
    },
    );
  }
}
