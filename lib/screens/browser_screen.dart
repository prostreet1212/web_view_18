import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:web_view_18/widgets/browser_appbar.dart';



class BrowserScreen extends StatefulWidget {
  const BrowserScreen({Key? key}) : super(key: key);

  @override
  State<BrowserScreen> createState() => _BrowserScreenState();
}

class _BrowserScreenState extends State<BrowserScreen> {
  final TextEditingController urlTextController = TextEditingController();
  final String? title = '';
  Favicon? icon;
   InAppWebViewController? webViewController;
   bool pageIsLoaded = false;

  double progress = 0;

   void customSetState() {
    setState(() {});
  }

  //final List<Bookmark> bookmarkList = [];

  final InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
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
    urlTextController.text = 'https://www.google.com';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size(double.infinity, 60),
          child: BrowserAppBar(
            webViewController: webViewController,
            //bookmarkList: bookmarkList,
            urlTextController: urlTextController,
            pageIsLoaded: pageIsLoaded,
            customSetState: customSetState,
          ),
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
                        pageIsLoaded = false;
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
