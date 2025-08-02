import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ResetPasswordWebPage extends StatefulWidget {
  final Uri url;

  const ResetPasswordWebPage({Key? key, required this.url}) : super(key: key);

  @override
  State<ResetPasswordWebPage> createState() => _ResetPasswordWebPageState();
}

class _ResetPasswordWebPageState extends State<ResetPasswordWebPage> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel(
        'FlutterChannel',
        onMessageReceived: (JavaScriptMessage message) {
          if (message.message == 'close') {
            Navigator.of(context).pop(); // Revenir à la page précédente
          }
        },
      )
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (_) {
            setState(() => _isLoading = false);
          },
        ),
      )
      ..loadRequest(widget.url);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Réinitialisation du mot de passe'),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
