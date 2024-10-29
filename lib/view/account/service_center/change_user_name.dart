import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nera/generated/assets.dart';
import 'package:nera/main.dart';
import 'package:nera/model/user_model.dart';
import 'package:nera/res/aap_colors.dart';
import 'package:nera/res/api_urls.dart';
import 'package:nera/res/components/app_btn.dart';
import 'package:nera/res/components/text_field.dart';
import 'package:nera/res/helper/api_helper.dart';
import 'package:nera/res/provider/profile_provider.dart';
import 'package:nera/res/provider/user_view_provider.dart';
import 'package:nera/utils/utils.dart';
import 'package:http/http.dart'as http;

class NickNamePopUp extends StatefulWidget {
  const NickNamePopUp({super.key});

  @override
  State<NickNamePopUp> createState() => _NickNamePopUpState();
}



class _NickNamePopUpState extends State<NickNamePopUp> {

  TextEditingController nameCon = TextEditingController();

  @override
  Widget build(BuildContext context) {

    return Dialog(
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Center(
        child: ListView(
         // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: height*0.2,),
            Container(
              height: height*0.5,
              decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(15)
              ),
              width: width,
              child: Column(
                children: [
                  SizedBox(
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(height: 1,width: width*0.07,color: Colors.white,),
                        const Text('Change NickName',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500,fontSize: 18),),
                        Container(height: 1,width: width*0.07,color: Colors.white,)
                      ],
                    ),
                  ),
                  Container(
                    height: 250,
                    width: width*0.7,
                    decoration: BoxDecoration(
                        color: AppColors.filledColor,
                        borderRadius: BorderRadius.circular(15)
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: height*0.06,),
                        Row(
                          children: [
                            Container(
                              height: 30,
                              width: width*0.13,
                              decoration:  const BoxDecoration(
                                  image: DecorationImage(image: AssetImage(Assets.iconsDialogNickname))
                              ),
                            ),
                            const Text("Nickname",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize:16,
                                    fontWeight: FontWeight.w400)),
                          ],
                        ),
                        SizedBox(height: height*0.02,),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 15, 20, 0),
                          child: CustomTextField(
                            fillColor: Colors.grey.withOpacity(0.2),
                            controller: nameCon,
                            filled: true,
                            focusColor: Colors.white,
                            maxLines: 1,
                            hintText: context.watch<ProfileProvider>().userName.toString(),
                          ),
                        ),

                const Spacer(),
                        AppBtn(
                          height: 50,
                          title: 'Submit',
                          fontSize: 20,
                          titleColor: AppColors.primaryTextColor,
                          hideBorder: true,
                          onTap: () {
                            avtarChangeApi(nameCon.text);
                          },
                          gradient: AppColors.loginSecondryGrad,
                        ),
                        SizedBox(height: height*0.02,)
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Center(
              child: IconButton(onPressed: () {
                Navigator.pop(context);
              }, icon: const Icon(Icons.cancel_outlined,size: 35,color: Colors.white,),),
            )
          ],
        ),
      ),
    );
  }
  BaseApiHelper baseApiHelper = BaseApiHelper();

  UserViewProvider userProvider = UserViewProvider();
  avtarChangeApi( String nickname) async {
    UserModel user = await userProvider.getUser();
    String token = user.id.toString();
    final response = await http.post(
      Uri.parse(ApiUrl.UpdateAvtarApi),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "id": token,
        "username": nickname,
      }),
    );
    var data = jsonDecode(response.body);
    print(data);
    if (data["status"] == 200) {
      context.read<ProfileProvider>().fetchProfileData();
      Navigator.pop(context);
      return Utils.flushBarSuccessMessage(data['message'], context, Colors.black);
    } else if (data["status"] == 401) {
      Utils.flushBarErrorMessage(data['message'], context, Colors.black);
    } else {
      Utils.flushBarErrorMessage(data['message'], context, Colors.black);
    }
  }
}