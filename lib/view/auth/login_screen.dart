import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:nera/generated/assets.dart';
import 'package:nera/main.dart';
import 'package:nera/res/aap_colors.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:nera/res/components/app_bar.dart';
import 'package:nera/res/components/app_btn.dart';
import 'package:nera/res/components/text_field.dart';
import 'package:nera/res/components/text_widget.dart';
import 'package:nera/res/provider/auth_provider.dart';
import 'package:nera/utils/routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nera/utils/utils.dart';
import 'package:nera/view/account/service_center/custmor_service.dart';
import 'package:nera/view/auth/forget_password_otp.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final _formKey = GlobalKey<FormState>();

  bool selectedButton = true;
  bool hidePassword = true;
  bool rememberPass = false;
  // bool activeButton = true;
  TextEditingController phoneCon = TextEditingController();
  TextEditingController emailCon = TextEditingController();
  TextEditingController passwordCon = TextEditingController();
  TextEditingController passwordConn = TextEditingController();

  /// Check internet
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      // ignore: avoid_print
      print(e.toString());
      return;
    }

    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    setState(() {
      _connectionStatus = result;
    });
  }
  @override
  void initState() {
    initConnectivity();_connectivitySubscription = _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    super.initState();
  }


  Future<bool> _onWillPop() async {
    bool shouldExit = await Utils.showExitConfirmation(context) ?? false;
    return shouldExit;
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<UserAuthProvider>(context);
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: AppColors.scaffolddark,
        appBar: GradientAppBar(
            centerTitle: true,
            title: CircleAvatar(
              radius: 70,
              backgroundColor: Colors.transparent,
              backgroundImage: AssetImage(Assets.imagesAppBarSecond),
            ),
            // title: Image.asset(
            //   Assets.imagesAppBarSecond,
            //   height: height*0.05,
            //   width: width*0.6,
            // ),
            // leading: const AppBackBtn(),
            gradient: AppColors.primaryUnselectedGradient),
        body:
        _connectionStatus == ConnectivityResult.none
            ?Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Image(
                image: const AssetImage(Assets.imagesNoDataAvailable),
                height: MediaQuery.of(context).size.height / 3,
                width: MediaQuery.of(context).size.width / 2,
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(4.0),
              child: Text('There is no Internet connection'),
            ),
            const Padding(
              padding: EdgeInsets.all(4.0),
              child:
              Text('Please check your Internet connection'),
            ),
          ],
        ):

        ScrollConfiguration(
          behavior: const ScrollBehavior().copyWith(overscroll: false),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Container(
                    decoration:
                    const BoxDecoration(gradient: AppColors.primaryGradient),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 18.0),
                      child: ListTile(
                        title: Padding(
                          padding: const EdgeInsets.only(bottom: 18.0),
                          child: textWidget(
                              text: 'Log in',
                              fontWeight: FontWeight.w600,
                              fontSize: 22,
                              color: AppColors.primaryTextColor),
                        ),

                        subtitle: textWidget(
                            text: 'Please log in with your phone number or email\nIf you forget your password, please contact customer service',
                            fontWeight: FontWeight.w600,
                            fontSize: 10,
                            color: AppColors.primaryTextColor),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            selectedButton = !selectedButton;
                            // activeButton = !activeButton;
                          });
                        },
                        child: Container(
                          height: 90,
                          width: width/ 2 , // Adjust width dynamically
                          decoration: BoxDecoration(
                            gradient: selectedButton
                                ? AppColors.loginSecondryGrad
                                : AppColors.primaryUnselectedGradient,
                          ),
                          child: Center(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedButton = !selectedButton;
                                  // activeButton = !activeButton;
                                });
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  selectedButton
                                      ? Image.asset(Assets.iconsPhoneTabColor, scale: 1.5,)
                                      : Image.asset(Assets.iconsPhoneTab, scale: 1.5,),
                                  textWidget(
                                    text: 'Log in with phone',
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    color: selectedButton
                                        ? AppColors.primaryTextColor
                                        : AppColors.secondaryTextColor,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            selectedButton = !selectedButton;
                            // activeButton = !activeButton;
                          });
                        },
                        child: Container(
                          height: 90,
                          width: width/ 2 , // Adjust width dynamically
                          decoration: BoxDecoration(
                            gradient: !selectedButton
                                ? AppColors.loginSecondryGrad
                                : AppColors.primaryUnselectedGradient,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              !selectedButton
                                  ? Image.asset(Assets.iconsEmailTabColor, scale: 1.5,)
                                  : Image.asset(Assets.iconsEmailTab, scale: 1.5,),
                              textWidget(
                                text: 'Email Login',
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: !selectedButton
                                    ? AppColors.primaryTextColor
                                    : AppColors.secondaryTextColor,
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 15, 20, 0),
                    child: Row(
                      children: [
                        Image.asset(selectedButton

                            ? Assets.iconsPhone
                            : Assets.iconsEmailTab,scale: 1.5,),
                        const SizedBox(width: 20),
                        textWidget(
                            text: selectedButton ? 'Phone Number' : 'Mail',
                            fontWeight: FontWeight.w400,
                            fontSize: 18,
                            color: AppColors.primaryTextColor)
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 15, 20, 0),
                    child: selectedButton
                        ? Row(
                      children: [
                        const SizedBox(
                          width: 100,
                          child: CustomTextField(
                            enabled: false,
                            hintText: '+91',
                            hintColor: Colors.white,
                            suffixIcon: RotatedBox(
                                quarterTurns: 45,
                                child: Icon(Icons.arrow_forward_ios_outlined,
                                    size: 20,color: Colors.white,)),
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                            child: CustomTextField(
                              onChanged: (value) {
                                if (phoneCon.text.length == 10) {
                                  // setState(() {
                                  //   activeButton = !activeButton;
                                  // });
                                }
                              },
                              keyboardType: TextInputType.number,
                              controller: phoneCon,
                              maxLength: 10,
                              hintText: 'Please enter the phone number',
                            )),
                      ],
                    )
                        : CustomTextField(

                      onChanged: (value) {
                        if (emailCon.text.isNotEmpty) {
                          // setState(() {
                          //   activeButton = !activeButton;
                          // });
                        }
                      },
                      controller: emailCon,
                      maxLines: 1,
                      hintText: 'please input your email',
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 15, 20, 0),
                    child: Row(
                      children: [
                        Image.asset(Assets.iconsPassword,scale: 1.5,),
                        const SizedBox(width: 20),
                        textWidget(
                            text: 'Password',
                            fontWeight: FontWeight.w400,
                            fontSize: 18,
                            color: AppColors.primaryTextColor)
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 15, 20, 0),
                    child: CustomTextField(
                      obscureText: hidePassword,
                      controller: passwordCon,
                      maxLines: 1,
                      hintText: 'Please enter Password',
                      suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              hidePassword = !hidePassword;
                            });
                          },
                          icon: Image.asset(hidePassword
                              ? Assets.iconsEyeClose
                              : Assets.iconsEyeOpen,scale: 1.5,)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 15, 20, 0),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              rememberPass = !rememberPass;
                            });
                          },
                          child: Container(
                              height: 30,
                              width: 30,
                              alignment: Alignment.center,
                              decoration: rememberPass ?BoxDecoration(
                                color: AppColors.gradientFirstColor,
                                border: Border.all(
                                    color: AppColors.secondaryTextColor),

                                borderRadius: BorderRadiusDirectional.circular(50),

                              )
                                  :BoxDecoration(
                                border: Border.all(
                                    color: AppColors.secondaryTextColor),
                                borderRadius: BorderRadiusDirectional.circular(50),
                              ),
                              child: rememberPass ?const Icon(Icons.check,color: Colors.white,):null
                          ),
                        ),
                        const SizedBox(width: 20),
                        textWidget(text: 'Remember password', fontSize: 14, color: AppColors.primaryTextColor),
                      ],
                    ),
                  ),
                  Padding(
                    padding:  const EdgeInsets.fromLTRB(20, 15, 20, 0),
                    child: AppBtn(
                        loading: authProvider.loading,
                        title: 'Log in',
                        fontSize: 20,
                        onTap: () {
                          if (selectedButton==true) {
                            if (kDebugMode) {
                              print("object");
                            }
                            authProvider.userLogin(context, phoneCon.text, passwordCon.text);
                          } else {
                            authProvider.userLogin(context, emailCon.text, passwordCon.text);
                          }
                        },
                        hideBorder: true,
                        gradient: AppColors.buttonGradient
                      // gradient: activeButton
                      //     ? AppColors.primaryGradient
                      //     : AppColors.inactiveGradient,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 15, 20, 0),
                    child: AppBtn(
                      title: 'R e g i s t e r',
                      fontSize: 20,
                      titleColor: AppColors.gradientFirstColor,
                      onTap: () {
                        // Navigator.pushNamed(context, RoutesName.registerScreen,arguments: '1');
                        Navigator.pushNamed(context, RoutesName.registerScreenOtp,arguments: '1');
                      },
                      gradient: AppColors.secondaryGradient,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 30, 20, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: () {
                           Navigator.push(context, MaterialPageRoute(builder: (context)=>const ForgetPasswordScreen()));
                          },
                          child: Column(
                            children: [
                              Image.asset(Assets.iconsPassword, height: 50),
                              textWidget(
                                  text: 'Forgot password',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  color:AppColors.primaryTextColor)
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>const CustomerCareService()));

                          },
                          child: Column(
                            children: [
                              Image.asset(Assets.iconsCustomer, height: 50),
                              textWidget(
                                  text: 'Customer Service',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  color: AppColors.primaryTextColor)
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }




}

