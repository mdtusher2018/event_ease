import 'package:event_ease/features/auth/presentation/screen/common/nav_screen.dart';
import 'package:event_ease/features/auth/presentation/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentWebViewScreen extends StatelessWidget {
  final String url;

  const PaymentWebViewScreen({Key? key, required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Complete Payment"),backgroundColor: AppColors.white,surfaceTintColor: Colors.transparent,),
      body: WebViewWidget(controller: WebViewController(onPermissionRequest: (request) {
        request.grant();
      },)
  ..setJavaScriptMode(JavaScriptMode.unrestricted)
  ..setNavigationDelegate(
    NavigationDelegate(
      onProgress: (int progress) {
        // Update loading bar.
      },
      onPageStarted: (String url) {},
      onPageFinished: (String url) {},
      onHttpError: (HttpResponseError error) {},
      onWebResourceError: (WebResourceError error) {},
      onNavigationRequest: (NavigationRequest request) {
        if (request.url.startsWith('https://pianofesta.it/pagamento-completato')) {
                Get.offAll(NavScreen());
          Get.snackbar("Sucessfull", "payment sucessfull");
        }
        return NavigationDecision.navigate;
      },
    ),
  )
  ..loadRequest(Uri.parse(url))),
    );
  }
}
