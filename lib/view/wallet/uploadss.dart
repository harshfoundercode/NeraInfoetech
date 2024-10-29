
import 'dart:convert';
import 'package:nera/generated/assets.dart';
import 'package:nera/main.dart';
import 'package:nera/model/user_model.dart';
import 'package:nera/res/aap_colors.dart';
import 'package:nera/res/api_urls.dart';
import 'package:nera/res/components/app_bar.dart';
import 'package:nera/res/components/app_btn.dart';
import 'package:nera/res/components/clipboard.dart';
import 'package:nera/res/components/image_picker.dart';
import 'package:nera/res/components/text_widget.dart';
import 'package:nera/res/provider/user_view_provider.dart';
import 'package:nera/utils/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class UploadScreenshots extends StatefulWidget {
  String amount;
  String cont;
  UploadScreenshots({super.key, required this.amount,required this.cont});

  @override
  State<UploadScreenshots> createState() => _UploadScreenshotsState();
}

class _UploadScreenshotsState extends State<UploadScreenshots> {

  @override
  void initState() {
    getImage();
    super.initState();
  }

  String imagePath="";
  String usdtcode = "";

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child:
      Scaffold(
        backgroundColor: AppColors.scaffolddark,
        appBar: GradientAppBar(
            leading: Padding(
              padding: const EdgeInsets.fromLTRB(15, 5, 5, 5),
              child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Image.asset(Assets.iconsArrowBack)),
            ),
            title: textWidget(
                text: 'Upload Screenshot', fontSize: 25, color: AppColors.primaryTextColor),
            gradient: AppColors.secondaryappbar),
        body: ListView(
          shrinkWrap: true,
          children: [
            SizedBox(height: height*0.02),
            Center(
              child: Text("Total amount:${widget.amount}", style: const TextStyle(
                  fontSize: 16, color: Colors.white
              ),),
            ),
            SizedBox(height: height*0.02),
            Center(
              child: SizedBox(
                height: height*0.50,
                    width: width*0.80,
                child:imagePath ==""?const SizedBox(): Image.network(imagePath),
              ),
            ),

            SizedBox(height: height * 0.04),
            Column(
              children: [
                const Text("Copy code:", style: TextStyle(
                    fontSize: 16, color: Colors.white
                ),),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                     Text(usdtcode=="null"?"":usdtcode.toString(), style: const TextStyle(
                        fontSize: 12, color: Colors.white
                    ),),
                    IconButton(onPressed: (){
                      copyToClipboard(usdtcode=="null"?"":usdtcode.toString(), context);
                    }, icon: const Icon(Icons.copy,color: Colors.white,size: 15,))
                  ],
                ),

              ],
            ),
            Center(
              child: AppBtn(
                width: width*0.44,
                onTap: (){
                  _settingModalBottomSheet(context);
                },
                title: "Upload Screenshot",
                gradient: AppColors.containerGradient,
              ),
            ),
            SizedBox(height: height*0.02,),
            SizedBox(
              height: 120,
              width: 200,
              child: myData != '0'
                  ? Image.memory(base64Decode(myData))
                  : Image.network(ApiUrl.uploadimage),
            ),
            SizedBox(height: height*0.02,),
            AppBtn(
              onTap: (){
                usdtPay(widget.cont,widget.amount,context);
              },
              title: "Confirm",
            ),
            SizedBox(height: height*0.03,)

          ],
        ),
      ),
    );
  }

  String myData = '0';
  void _updateImage(ImageSource imageSource) async {
    String? imageData = await ChooseImage.chooseImageAndConvertToString(imageSource);
    if (imageData != null) {
      setState(() {
        myData = imageData;
      });
    }
  }

  void _settingModalBottomSheet(context) {
    
    showModalBottomSheet(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15), topRight: Radius.circular(15)),
        ),
        context: context,
        builder: (BuildContext bc) {
          return SizedBox(
            height: height / 7,
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                  width / 12, 0, width / 12, height / 60),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: () {
                      _updateImage(ImageSource.camera);
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: height / 20,
                      width: width / 2.7,
                      decoration: BoxDecoration(
                        // color: Colors.blue,
                          border: Border.all(color: Colors.red, width: 2),
                          borderRadius: BorderRadius.circular(10)),
                      child: const Center(
                          child: Text(
                            "Camera",
                            style: TextStyle(color: Colors.red),
                          )),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      _updateImage(ImageSource.gallery);
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: height / 20,
                      width: width / 2.7,
                      decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10)),
                      child: const Center(
                          child: Text(
                            "Gallery",
                          )),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }


  UserViewProvider userProvider = UserViewProvider();

  usdtPay(String usdtamount, String amountINR, context) async {
    if (kDebugMode) {
      print("uhyfu");
    }
    UserModel user = await userProvider.getUser();
    String token = user.id.toString();
    if (kDebugMode) {
      print(token);
    }
    final response = await http.post(Uri.parse(ApiUrl.usdtdeposit),
        body: jsonEncode({
          "userid": token,
          "actual_amount": usdtamount,
          "amount":amountINR,
          "screenshot":myData
        })
    );
    if (kDebugMode) {
      print(ApiUrl.usdtdeposit);
      print("ApiUrl.usdtdeposit");
      print(usdtamount);
      print(amountINR);

    }
    if(response.statusCode==200){
      final data = jsonDecode(response.body);
      if (kDebugMode) {
        print(data);
        print("👍👍👍👍");
      }
      if(data["status"]==200){
        Navigator.pop(context);
        Utils.flushBarSuccessMessage(data["message"], context, Colors.white);

      }
      else {
        Utils.flushBarErrorMessage(data["message"], context, Colors.white);
      }
    }
    else{
      throw Exception("error");
    }

  }

  getImage()async{
    var res= await  http.get(Uri.parse("https://winzy.live/admin/index.php/Mahajongapi/usdt_slider"));
    var data = jsonDecode(res.body)["data"][0];
    setState(() {
      imagePath="https://admin.winzy.live/${data["image"]}";
      usdtcode="${data["usdtcode"]}";
    });
  }
}


