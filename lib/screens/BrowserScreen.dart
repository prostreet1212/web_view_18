import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class BrowserScreen extends StatefulWidget {
  const BrowserScreen({Key? key}) : super(key: key);

  @override
  State<BrowserScreen> createState() => _BrowserScreenState();
}

class _BrowserScreenState extends State<BrowserScreen> {

  TextEditingController urlTextController=TextEditingController();
  InAppWebViewController? webViewController;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('InAppWebView'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: null,
              ),
              IconButton(
                icon: Icon(Icons.arrow_forward),
                onPressed: null,
              ),
              IconButton(
                icon: Icon(Icons.refresh),
                onPressed: null,
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
                      contentPadding: EdgeInsets.all(12)
                    ),
                  ),
                ),
              )
            ],
          ),
          //LinearProgressIndicator(),
          Expanded(
            child: InAppWebView(
              initialUrlRequest: URLRequest(url: Uri.parse("http://kdrc.ru/")),
              onWebViewCreated: (controller) {
                webViewController=controller;
              },
            ),
          )
        ],
      ),
    );
  }
}
