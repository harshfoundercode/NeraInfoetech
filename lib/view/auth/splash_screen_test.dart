import 'dart:async';

import 'package:nera/generated/assets.dart';
import 'package:nera/res/aap_colors.dart';
import 'package:nera/res/components/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/routes/routes_name.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    harsh();
  }

  harsh() async {
    final prefs = await SharedPreferences.getInstance();
    final userid = prefs.getString("token") ?? '0';

    Timer(
        const Duration(seconds: 3),
            () => userid != '0'
            ? Navigator.pushNamed(context, RoutesName.bottomNavBar)
            : Navigator.pushNamed(context, RoutesName.loginScreen));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: Container(
              height: double.infinity,
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: AppColors.primaryUnselectedGradient,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 250,
                    width: 300,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(Assets.imagesSplashImage),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  textWidget(
                    text: 'Withdraw fast, safe and stable',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryTextColor,
                  ),
                ],
              ),
            )));
  }
}
