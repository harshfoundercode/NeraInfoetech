// import 'dart:async';
// import 'package:flutter/foundation.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:nera/generated/assets.dart';
// import 'package:nera/main.dart';
// import 'package:nera/res/aap_colors.dart';
// import 'package:nera/res/components/text_widget.dart';
// import 'package:nera/res/provider/services/splash_service.dart';
// import 'package:flutter/material.dart';
//
// import '../utils/routes/routes_name.dart';
//
// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});
//
//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }
//
// class _SplashScreenState extends State<SplashScreen> {
//   SplashServices splashServices = SplashServices();
//
//   @override
//   void initState(){
//     tanisha();
//     super.initState();
//
//   }
//   tanisha() async {
//     final prefs = await SharedPreferences.getInstance();
//     final userid=prefs.getString("token")??'0';
//     if (kDebugMode) {
//       print(userid);
//       print("userid");
//
//     }
//     userid !='0'? Timer(const Duration(seconds: 4),
//             ()=>  Navigator.pushNamed(context, RoutesName.bottomNavBar))
//     :        Navigator.pushNamed(context, RoutesName.loginScreen);
//
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         height: height,
//         width: width,
//         decoration: const BoxDecoration(
//           gradient: AppColors.primaryUnselectedGradient,
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Container(
//               height: height * 0.3,
//               width: width * 0.7,
//               decoration: const BoxDecoration(
//                 image: DecorationImage(
//                   image: AssetImage(Assets.imagesSplashImage),
//                   fit: BoxFit.fill,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20),
//             textWidget(
//               text: 'Withdraw fast, safe and stable',
//               fontSize: 16,
//               fontWeight: FontWeight.w600,
//               color: AppColors.primaryTextColor,
//             ),
//             const SizedBox(height: 5),
//             Image.asset(Assets.imagesAppBarSecond, height: 180),
//           ],
//         ),
//       ),
//     );
//   }
// }
