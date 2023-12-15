import 'package:flutter/material.dart';
import 'package:flutter_application/feature/splash/splash_provider.dart';
import 'package:flutter_application/product/constants/index.dart';
import 'package:flutter_application/product/widget/text/wavy_text.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kartal/kartal.dart';

class SplashVieww extends ConsumerStatefulWidget {
  const SplashVieww({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SplashViewwState();
}

class _SplashViewwState extends ConsumerState<SplashVieww> {
  final splashProvider =
      StateNotifierProvider<SplashProvider, SplashState>((ref) {
    return SplashProvider();
  });
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ''.ext.version;
    ref.listen(splashProvider, (previous, next) {
      if (next.isRequiredForceUpdate ?? false) {
        showAboutDialog(context: context);
        return;
      }

      if (next.isRedirectHome != null) {
        if (next.isRedirectHome!) {
          //true
        } else {
          //false
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.softPeach,
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ImageConstants.children.toImg,
          const WavyBoldText(title: StringConstants.appName)
        ],
      )),
    );
  }
}
