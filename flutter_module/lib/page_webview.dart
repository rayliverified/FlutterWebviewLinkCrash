import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebviewPage extends StatefulWidget {
  final String url;

  WebviewPage({Key key, this.url}) : super(key: key);

  @override
  _WebviewPageState createState() => _WebviewPageState();
}

class _WebviewPageState extends State<WebviewPage> {
  BuildContext context;
  UniqueKey webViewKey;
  WebViewController webViewController;

  String url;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    this.context = context;
    this.url = widget.url;
    webViewKey = UniqueKey();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      webViewController?.loadUrl(url);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void setLoading(bool loading) {
    this.loading = loading;
    print("Loading $loading");
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            WebView(
              key: webViewKey,
              onPageStarted: (_) => setLoading(true),
              onPageFinished: (_) => setLoading(false),
              onWebViewCreated: (controller) {
                print("Set Webview Controller");
                webViewController = controller;
              },
              initialUrl: url,
              javascriptMode: JavascriptMode.unrestricted,
              initialMediaPlaybackPolicy: AutoMediaPlaybackPolicy.always_allow,
              navigationDelegate: (NavigationRequest request) {
                String url = request.url;
                return NavigationDecision.navigate;
              },
            ),
            Center(
              child: Visibility(
                  visible: loading, child: CupertinoActivityIndicator()),
            ),
          ],
        ),
      ),
    );
  }
}
