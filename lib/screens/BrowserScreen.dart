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
    urlTextController.text = 'https://flutter.dev';
    super.initState();
  }

  @override
  Widget build(BuildContext context) async{
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('InAppWebView'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: await  webViewController!.canGoBack()?() {
                    //webViewController!.goBack();
                  }:null,
                ),
                IconButton(
                  icon: Icon(Icons.arrow_forward),
                  onPressed: null,
                ),
                IconButton(
                  icon: Icon(Icons.refresh),
                  onPressed: () {
                    webViewController!.loadUrl(
                        urlRequest:
                            URLRequest(url: Uri.parse(urlTextController.text)));
                  },
                ),
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
            //LinearProgressIndicator(),
            Expanded(
              child: InAppWebView(
                initialUrlRequest: URLRequest(
                  url: Uri.parse("http://kdrc.ru/"),
                ),
                initialOptions: options,
                onWebViewCreated: (controller) {
                  webViewController = controller;
                },
              ),
            )
          ],
        ),
      ),
      onWillPop: () async {
        if(await webViewController!.canGoBack()){
          webViewController!.goBack();
          return false;
        }else{
          return true;
        }
      },
    );
  }
}
