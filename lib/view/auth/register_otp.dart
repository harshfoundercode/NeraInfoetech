import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:nera/generated/assets.dart';
import 'package:nera/main.dart';
import 'package:nera/res/aap_colors.dart';
import 'package:nera/res/api_urls.dart';
import 'package:nera/res/components/app_bar.dart';
import 'package:nera/res/components/app_btn.dart';
import 'package:nera/res/components/text_field.dart';
import 'package:nera/res/components/text_widget.dart';
import 'package:nera/res/provider/auth_provider.dart';
import 'package:nera/utils/routes/routes_name.dart';
import 'package:nera/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../res/components/rich_text.dart';
import 'package:http/http.dart' as http;

class RegisterScreenOtp extends StatefulWidget {
  const RegisterScreenOtp({super.key});

  @override
  State<RegisterScreenOtp> createState() => _RegisterScreenOtpState();
}

class _RegisterScreenOtpState extends State<RegisterScreenOtp> {
  bool hideSetPassword = true;
  bool hideConfirmPassword = true;
  bool readAndAgreePolicy = false;
  bool showContainer = false;
  bool show = false;
  bool isPhoneNumberValid = false;

  TextEditingController phoneCon = TextEditingController();
  TextEditingController setPasswordCon = TextEditingController();
  TextEditingController confirmPasswordCon = TextEditingController();
  TextEditingController refercodee = TextEditingController();
  TextEditingController emailCon = TextEditingController();
  TextEditingController OtpCon = TextEditingController();

  final _formKey = GlobalKey<FormState>();



  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<UserAuthProvider>(context);

    String argument = ModalRoute.of(context)!.settings.arguments.toString();
    return Scaffold(
      backgroundColor: AppColors.scaffolddark,
      appBar: GradientAppBar(
        centerTitle: true,
        title: CircleAvatar(
          radius: 70,
          backgroundColor: Colors.transparent,
          backgroundImage: AssetImage(Assets.imagesAppBarSecond),
        ),
        leading:argument == '0' ? Container() : const AppBackBtn(),
        gradient: AppColors.primaryUnselectedGradient),
      body: ScrollConfiguration(
        behavior: const ScrollBehavior().copyWith(overscroll: false),
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Container(
                  decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
                  child: ListTile(
                    title: textWidget(
                        text: 'Register',
                        fontWeight: FontWeight.w600,
                        fontSize: 22,
                        color: AppColors.primaryTextColor),
                    subtitle: textWidget(
                        text: 'Please register by phone number or email',
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                        color: AppColors.primaryTextColor),
                  ),
                ),

                Container(
                  width: double.infinity,
                  height: 90,
                  decoration: const BoxDecoration(gradient: AppColors.loginSecondryGrad),

                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(Assets.iconsPhoneTabColor,scale: 1.5,),
                      const SizedBox(width: 2),
                      textWidget(
                          text: 'Register your phone',
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: AppColors.primaryTextColor)
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 15, 20, 0),
                  child: Row(
                    children: [
                      Image.asset(
                        Assets.iconsInvitionCode,
                        height: 30,
                      ),
                      const SizedBox(width: 20),
                      textWidget(
                          text: 'Enter Referral Code',
                          fontWeight: FontWeight.w400,
                          fontSize: 18,
                          color: AppColors.primaryTextColor)
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 5, 20, 0),
                  child: CustomTextField(
                    controller: refercodee,
                    maxLines: 1,
                    hintText: 'Please Enter Referral code',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 5, 20, 0),
                  child: Row(
                    children: [
                      Image.asset(
                        Assets.iconsPhone,
                        height: 30,

                      ),
                      const SizedBox(width: 20),
                      textWidget(
                          text: 'Phone Number',
                          fontWeight: FontWeight.w400,
                          fontSize: 18,
                          color: AppColors.primaryTextColor)
                    ],
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                    child: Row(
                      children: [
                        const SizedBox(
                          width: 100,
                          child: CustomTextField(
                            enabled: false,
                            hintText: '+91',
                            suffixIcon: RotatedBox(
                                quarterTurns: 45,
                                child: Icon(Icons.arrow_forward_ios_outlined,
                                    size: 20)),
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                            child: CustomTextField(
                              onChanged: (v) {
                                if (v.length == 10) {
                                  setState(() {
                                    isPhoneNumberValid = true;
                                  });
                                } else {
                                  setState(() {
                                    isPhoneNumberValid = false;
                                  });
                                }
                              },
                              keyboardType: TextInputType.phone,
                              controller: phoneCon,
                              maxLength: 10,
                              hintText: 'Please enter the phone number',
                              style: const TextStyle(color: Colors.white),
                            )),
                      ],
                    )),
                if (showContainer==true)
                  Column(
                    children: [
                      Padding(
                          padding: const EdgeInsets.fromLTRB(20, 15, 20, 0),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.verified,
                                color: AppColors.gradientFirstColor,
                              ),
                              const SizedBox(width: 20),
                              textWidget(
                                  text: 'OTP',
                                  fontWeight: FontWeight.w400,
                                  fontSize: 18,
                                  color: AppColors.secondaryTextColor)
                            ],
                          )),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 15, 20, 0),
                        child: CustomTextField(
                          controller: OtpCon,
                          maxLines: 1,
                          hintText: 'Verification code',
                          onChanged: (v) async {
                            if(v.length==4){
                              otpMatch(OtpCon.text,phoneCon.text);
                            }else{
                              print("not done");
                            }
                          },
                        ),
                      ),
                    ],
                  ),


                if (showContainer==false && isPhoneNumberValid==true )
                  AppBtn(
                    width: width*0.35,
                    height: height*0.053,
                    onTap: () {
                      if (isPhoneNumberValid) {
                        setState(() {
                          showContainer = phoneCon.text.length==10;
                        });
                        otpurl(phoneCon.text);
                      } else {
                        print("Please enter a valid 10-digit phone number");
                      }

                    },
                    title: 'Send OTP',
                    titleColor: Colors.white,
                  ),


                Padding(
                    padding: const EdgeInsets.fromLTRB(20, 15, 20, 0),
                    child: Row(
                      children: [
                        Image.asset(Assets.iconsEmailTab,height: 30,),
                        const SizedBox(width: 20),
                        textWidget(
                            text: 'Email',
                            fontWeight: FontWeight.w400,
                            fontSize: 18,
                            color: AppColors.primaryTextColor)
                      ],
                    )),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 5, 20, 0),
                  child: CustomTextField(
                    controller: emailCon,
                    maxLines: 1,
                    hintText: 'please input your email',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 5, 20, 0),
                  child: Row(
                    children: [
                      Image.asset(
                        Assets.iconsPassword,
                        height: 30,
                      ),
                      const SizedBox(width: 20),
                      textWidget(
                          text: 'Set password',
                          fontWeight: FontWeight.w400,
                          fontSize: 18,
                          color: AppColors.primaryTextColor)
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 5, 20, 0),
                  child: CustomTextField(
                    obscureText: hideSetPassword,
                    controller: setPasswordCon,
                    style: const TextStyle(color: Colors.white),
                    maxLines: 1,
                    hintText: 'Please enter Set password',
                    suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            hideSetPassword = !hideSetPassword;
                          });
                        },
                        icon: Image.asset(hideSetPassword
                            ? Assets.iconsEyeClose
                            : Assets.iconsEyeOpen)),

                  ),
                ),
                // Padding(
                //   padding: const EdgeInsets.fromLTRB(20, 5, 20, 0),
                //   child: Row(
                //     children: [
                //       Image.asset(
                //         Assets.iconsPassword,
                //         height: 30,
                //       ),
                //       const SizedBox(width: 20),
                //       textWidget(
                //           text: 'Confirm password',
                //           fontWeight: FontWeight.w400,
                //           fontSize: 18,
                //           color: AppColors.primaryTextColor)
                //     ],
                //   ),
                // ),
                // Padding(
                //   padding: const EdgeInsets.fromLTRB(20, 5, 20, 0),
                //   child: CustomTextField(
                //
                //     obscureText: hideConfirmPassword,
                //     controller: confirmPasswordCon,
                //     maxLines: 1,
                //     style: const TextStyle(color: Colors.white),
                //     hintText: 'Please Enter Confirm password',
                //     suffixIcon: IconButton(
                //         onPressed: () {
                //           setState(() {
                //             hideConfirmPassword = !hideConfirmPassword;
                //           });
                //         },
                //         icon: Image.asset(hideConfirmPassword
                //             ? Assets.iconsEyeClose
                //             : Assets.iconsEyeOpen)),
                //   ),
                // ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 5, 20, 0),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            readAndAgreePolicy = !readAndAgreePolicy;
                          });
                        },
                        child: Container(
                            height: 25,
                            width: 25,
                            alignment: Alignment.center,
                            decoration: readAndAgreePolicy
                                ? BoxDecoration(
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
                            child: readAndAgreePolicy ?const Icon(Icons.check,color: Colors.white,):null

                        ),
                      ),
                      const SizedBox(width: 10),
                      CustomRichText(
                        textSpans: [
                          CustomTextSpan(
                            text: "I have read and agree",
                            textColor: Colors.white,
                            fontSize: 13,
                            spanTap: () {
                              setState(() {
                                readAndAgreePolicy = !readAndAgreePolicy;
                              });
                            },
                          ),
                          CustomTextSpan(
                            text: "【Privacy Agreement】",
                            textColor:AppColors.gradientFirstColor,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            spanTap: () {},
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 15, 20, 0),
                  child: AppBtn(
                      title: 'Register',
                      fontSize: 20,
                      loading: authProvider.regLoading,
                      onTap: () {
                        if(phoneCon.text.isEmpty || phoneCon.text.length!=10){
                          Utils.flushBarErrorMessage("Enter phone number", context, Colors.red);
                        }else if(setPasswordCon.text.isEmpty){
                          Utils.flushBarErrorMessage("Set your password", context, Colors.red);
                        }  else if(emailCon.text.isEmpty){
                          Utils.flushBarErrorMessage("Confirm your email", context, Colors.red);
                        }else if(OtpCon.text.isEmpty){
                          Utils.flushBarErrorMessage("Confirm your otp", context, Colors.red);
                        }
                        else {
                          authProvider.userRegister(
                              context,
                              phoneCon.text,
                              setPasswordCon.text,
                              refercodee.text,
                              emailCon.text
                          );
                        }},
                      hideBorder: true,
                      gradient: AppColors.loginSecondryGrad
                    // gradient: activeButton
                    //     ? AppColors.primaryGradient
                    //     : AppColors.inactiveGradient,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 15, 20, 0),
                  child: AppBtn(
                    onTap: () {
                      Navigator.pushNamed(context, RoutesName.loginScreen);
                    },
                    gradient: AppColors.secondaryGradient,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        textWidget(
                            text: 'I have an account',
                            fontSize: 16,
                            color: AppColors.secondaryTextColor,
                            fontWeight: FontWeight.w600),
                        const SizedBox(width: 15),
                        textWidget(
                            text: 'Login',
                            fontSize: 22,
                            color: AppColors.gradientFirstColor,
                            fontWeight: FontWeight.w600)
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  otpurl(String phonenumber) async {
    final response = await http.get(
      Uri.parse('${ApiUrl.sendotp}mode=live&digit=4&mobile=$phonenumber'),
    );


    var data = jsonDecode(response.body);

    if(data["status"]=="200"){
      setState(() {
        show=true;
      });
      // otpMatch(myControllers.map((e) => e.text).join(),phoneCon.text);
      Utils.flushBarSuccessMessage(data["msg"], context, Colors.white);
    }else {
      Utils.flushBarSuccessMessage(data["msg"], context, Colors.white);

    }
  }

  otpMatch(String myControllers,String Phone) async {

    final response = await http.get(Uri.parse('${ApiUrl.verifyotp}$Phone&otp=$myControllers'));

    if (kDebugMode) {
      print("sdghkhfd");
    }

    var data = jsonDecode(response.body);
    if(data["status"]=="200"){
      setState(() {
        show = true;
      });
      Utils.flushBarSuccessMessage(data["msg"], context, Colors.white);
      // Navigator.pushReplacementNamed(context,  RoutesName.bottomNavBar);
    }else {
      setState(() {
        show = false;
      });
      Utils.flushBarSuccessMessage(data["msg"], context, Colors.white);

    }
  }
}