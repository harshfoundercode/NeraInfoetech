import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class QRCodeScreen extends StatefulWidget {
  String url;
  QRCodeScreen({super.key, required this.url});

  @override
  _QRCodeScreenState createState() => _QRCodeScreenState();
}

class _QRCodeScreenState extends State<QRCodeScreen> {
  bool _isLoading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Code'),
      ),
      body: Stack(
        children: <Widget>[
          InAppWebView(
            initialUrlRequest: URLRequest(
              url: Uri.parse(widget.url),
            ),
            onLoadStop: (controller, url) async {
              setState(() {
                _isLoading = false;
              });
            },
            onLoadError: (controller, url, code, message) {
              print('WebView error: $message');
              setState(() {
                _isLoading = false;
              });
            },
          ),
          _isLoading
              ? Center(
            child: CircularProgressIndicator(),
          )
              : Container(),
        ],
      ),
    );
  }
}
