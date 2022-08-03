import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:
            //splash screen
            Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: Colors.orange,
      child: Center(
          child: SizedBox(
        width: MediaQuery.of(context).size.width / 5,
        child: Image(
          image: defaultTargetPlatform == TargetPlatform.android ||
                  defaultTargetPlatform == TargetPlatform.iOS
              ? const AssetImage("images/appicon.png")
              : const AssetImage("../../images/appicon.png"),
        ),
      )),
    ));
  }
}
