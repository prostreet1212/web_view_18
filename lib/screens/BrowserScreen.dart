import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class BrowserScreen extends StatefulWidget {
  const BrowserScreen({Key? key}) : super(key: key);

  @override
  State<BrowserScreen> createState() => _BrowserScreenState();
}

class _BrowserScreenState extends State<BrowserScreen> {
  TextEditingController urlTextController = TextEditingController();
  InAppWebViewController? webViewController;

  //String url = 'https://www.google.com';
  double progress = 0;
  final bookmarksList = <String>{};
  Map<String, String?> map2 = {};

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
        appBar: AppBar(
          title: const Text('InAppWebView'),
          leading:  IconButton(
            icon: Icon(Icons.bookmark),
            onPressed: ()  {
            },
          ),
          actions: [
            IconButton(
              icon: Icon(map2.keys.contains(urlTextController.text)?Icons.star:Icons.star_border),
              onPressed: ()  async{
                if (urlTextController.text.isNotEmpty) {
                   /* if (bookmarksList.contains(urlTextController.text)) {
                      bookmarksList.remove(urlTextController.text);
                    } else {
                      bookmarksList.add(urlTextController.text);
                      String? title= await webViewController?.getTitle();
                      print('титульник ${title}');
                    }*/
                  if(map2.keys.contains(urlTextController.text)){
                    map2.remove(urlTextController.text);
                  }else{
                    String? title= await webViewController?.getTitle();
                    map2.addEntries({urlTextController.text: title}.entries);
                    print('aaa ${map2[urlTextController.text]}');
                  }
                    setState(() {});
                }
              },
            ),
            IconButton(
              icon: Icon(Icons.home),
              onPressed: () async {
                WebHistory? history =
                    await webViewController?.getCopyBackForwardList();
                print('История ${history!.list![0]}');
                webViewController?.goTo(historyItem: history.list![0]);
              },
            )
          ],
        ),
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
                        icon: Icon(Icons.arrow_back),
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
                        icon: Icon(Icons.arrow_forward),
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
                    padding: EdgeInsets.all(12),
                    child: TextField(
                      controller: urlTextController,
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey[300],
                          hintText: 'Введите url',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: BorderSide(
                              width: 0,
                              style: BorderStyle.none,
                            ),
                          ),
                          contentPadding: EdgeInsets.all(12)),
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
                      urlTextController.text = url.toString();
                    });
                  }
                },
                onProgressChanged: (controller, progress) {
                  setState(() {
                    this.progress = progress / 100;
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
