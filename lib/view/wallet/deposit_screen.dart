// ignore_for_file: deprecated_member_use

import 'dart:convert';
import 'package:nera/generated/assets.dart';
import 'package:nera/main.dart';
import 'package:nera/model/addaccount_view_model.dart';
import 'package:nera/model/deposit_model_new.dart';
import 'package:nera/model/user_model.dart';
import 'package:nera/res/aap_colors.dart';
import 'package:nera/res/components/app_bar.dart';
import 'package:nera/res/components/app_btn.dart';
import 'package:nera/res/components/audio.dart';
import 'package:nera/res/components/text_field.dart';
import 'package:nera/res/components/text_widget.dart';
import 'package:nera/res/helper/api_helper.dart';
import 'package:nera/res/provider/profile_provider.dart';
import 'package:nera/res/provider/user_view_provider.dart';
import 'package:nera/utils/utils.dart';
import 'package:nera/view/wallet/deposit_history.dart';
import 'package:nera/view/wallet/depositweb.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../res/api_urls.dart';
import 'package:http/http.dart' as http;

class GridChange {
  String title;
  String images;
  GridChange(this.title, this.images);
}

class DepositScreen extends StatefulWidget {
  final AddacountViewModel? account;
  const DepositScreen({super.key, this.account});

  @override
  State<DepositScreen> createState() => _DepositScreenState();
}

class _DepositScreenState extends State<DepositScreen> {
  bool loading = false;

  @override
  void initState() {
    Audio.depositmusic();
    getwaySelect();
    invitationRuleApi();
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    Audio.audioPlayers;
    // TODO: implement dispose
    super.dispose();
  }

  int selectedIndex = 1;
  int selectedIndexx = 1;

  int result = 0;
  String resultt = "";

  TextEditingController depositCon = TextEditingController();
  TextEditingController usdtCon = TextEditingController();
  String selectedDeposit = '';
  String selectedusdt = '';

  BaseApiHelper baseApiHelper = BaseApiHelper();

  List<int> listt = [

    200,
    500,
    1000,
    2000,
    5000,
    10000
  ];

  @override
  Widget build(BuildContext context) {
    final double aspectRatio = width / height;
    final userData = context.watch<ProfileProvider>();

    int? responseStatuscode;

    return Scaffold(
      backgroundColor: AppColors.scaffolddark,
      appBar: GradientAppBar(
          leading: Padding(
            padding: const EdgeInsets.fromLTRB(15, 5, 5, 5),
            child: GestureDetector(
                onTap: () {
                  Audio.audioPlayers.stop();
                  Navigator.pop(context);
                },
                child: const Icon(
                  Icons.arrow_back_ios_new_sharp,
                  color: Colors.white,
                )),
          ),
          centerTitle: true,
          title: textWidget(
              text: 'Deposit',
            fontWeight: FontWeight.w900,
            fontSize: 20,
            color: AppColors.primaryTextColor,),
          actions: [InkWell(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>const DepositHistory()));
            },
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: textWidget(
                  text: 'Deposit history',
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: AppColors.primaryTextColor,),
              ),
            ),
          ),],
          gradient: AppColors.primaryUnselectedGradient),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              Container(
                height: height * 0.22,
                width: width,
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: const DecorationImage(
                        image: AssetImage(Assets.imagesCardImage),
                        fit: BoxFit.fill)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Row(
                          children: [
                            Image.asset(Assets.iconsDepoWallet, height: 30),
                            const SizedBox(width: 15),
                            textWidget(
                                text: 'Balance',
                                fontSize: 20,
                                color: Colors.white),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const SizedBox(width: 15),
                            const Icon(
                              Icons.currency_rupee,
                                color: AppColors.primaryTextColor
                            ),
                            textWidget(
                              text: userData.totalWallet.toStringAsFixed(2),
                              fontWeight: FontWeight.w900,
                              fontSize: 25,
                              color: AppColors.primaryTextColor,
                            ),
                            const SizedBox(width: 15),
                            InkWell(
                                onTap: () {
                                  context.read<ProfileProvider>().fetchProfileData();
                                  Utils.flushBarSuccessMessage('Wallet refresh ✔', context, Colors.white);

                                },
                                child: Image.asset(
                                  Assets.iconsTotalBal,
                                  height: 30,
                                )),
                          ],
                        ),
                      ],
                    ),

                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              responseStatuscode == 400
                  ? const Notfounddata()
                  : items.isEmpty
                      ? Container()
                      : GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisSpacing: 5,
                            crossAxisSpacing: 8,
                            childAspectRatio: 1,
                          ),
                          itemCount: items.length,
                          itemBuilder: (BuildContext context, int index) {
                            final currentId =
                                int.parse(items[index].id.toString());

                            return InkWell(
                              onTap: () {
                                setState(() {
                                  selectedIndex = currentId;
                                  if (kDebugMode) {
                                    print(selectedIndex);
                                    print('rrrrrrrrrrrrrrrrr');
                                  }
                                });
                                Audio.audioPlayers.play();
                              },
                              child: Card(
                                elevation: selectedIndex == currentId ? 2 : 5,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: selectedIndex == currentId
                                        ? AppColors.loginSecondryGrad
                                        : AppColors.primaryUnselectedGradient,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      items[index].image != null
                                          ? Image.network(
                                              items[index].image.toString(),
                                              height: 45,
                                            )
                                          : const Placeholder(
                                              fallbackHeight: 45,
                                            ),
                                      textWidget(
                                          text: items[index].name.toString(),
                                          fontSize: 13,
                                          color: selectedIndex == currentId
                                              ? AppColors.primaryTextColor
                                              : AppColors.iconsColor,
                                          fontWeight: FontWeight.w900),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),

              const SizedBox(
                height: 20,
              ),


              selectedIndex == 1 || selectedIndex == 2
                      ? Container(
                          height: height * 0.33,
                          width: width,
                          padding: const EdgeInsets.only(
                              top: 15, left: 15, right: 15),
                          decoration: BoxDecoration(
                              gradient: AppColors.primaryUnselectedGradient,
                              borderRadius:
                                  BorderRadiusDirectional.circular(15)),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Image.asset(
                                    Assets.iconsSaveWallet,
                                    height: height * 0.05,
                                  ),
                                  const SizedBox(width: 15),
                                  textWidget(
                                      text: 'Deposit amount',
                                      fontSize: 20,
                                      fontWeight: FontWeight.w900,
                                      color: AppColors.primaryTextColor),
                                ],
                              ),
                              SizedBox(height: height*0.01,),
                              SizedBox(
                                width: width,
                                height: height*0.123,
                                child: GridView.builder(
                                  gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    crossAxisSpacing: 3,
                                    mainAxisSpacing: 3,
                                    childAspectRatio: aspectRatio * 4.8

                                  ),
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: listt.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    return InkWell(
                                      onTap: () {
                                        setState(() {
                                          selectedIndexx = listt[index];
                                          depositCon.text = listt[index].toString();
                                        });
                                      },
                                      child: Center(
                                        child: Container(
                                          height: height*0.05  ,
                                          decoration: BoxDecoration(
                                            color: selectedIndexx == listt[index]
                                                ? AppColors.gradientFirstColor
                                                : AppColors.filledColor,
                                            borderRadius: BorderRadius.circular(5),
                                          ),
                                          padding: const EdgeInsets.all(5),
                                          child: Center(
                                            child: Text(
                                              listt[index].toString(),
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w900,
                                                color: selectedIndexx == listt[index]
                                                    ? Colors.white
                                                    : AppColors.gradientFirstColor,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(height: 10),
                              CustomTextField(
                                fillColor: AppColors.scaffolddark,
                                hintText: 'Please enter the amount',
                                fieldRadius: const BorderRadius.only(topLeft: Radius.circular(30),bottomLeft: Radius.circular(30)),
                                textColor: Colors.white,
                                keyboardType: TextInputType.number,
                                fontWeight: FontWeight.w600,
                                controller: depositCon,
                                onChanged: (value) {
                                  selectedIndexx != depositCon;
                                  selectedIndexx = -1;
                                },
                                prefixIcon: SizedBox(
                                  width: 70,
                                  child: Row(
                                    children: [
                                      const SizedBox(width: 10),
                                      const Icon(Icons.currency_rupee,
                                          color: AppColors.gradientFirstColor),
                                      const SizedBox(width: 10),
                                      Container(
                                          height: 30,
                                          color: Colors.grey,
                                          width: 2)
                                    ],
                                  ),
                                ),
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      depositCon.clear();
                                      selectedIndexx = -1;
                                      selectedDeposit = '';
                                    });
                                  },
                                  icon: const Icon(Icons.cancel_outlined,
                                      color: AppColors.iconColor),
                                ),
                              ),
                            ],
                          ),
                        )
                      :
                      selectedIndex == 3?
                      Container(
                        width: width,
                        padding:  const EdgeInsets.only(top: 15, left: 15, right: 15),
                        decoration: BoxDecoration(
                            gradient: AppColors.primaryUnselectedGradient,
                            borderRadius: BorderRadiusDirectional.circular(10)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Image.asset(Assets.imagesUsdtIcon,height: height*0.05,),
                                const SizedBox(width: 15),
                                textWidget(
                                    text: 'USDT amount',
                                    fontSize: 20,
                                    fontWeight: FontWeight.w900,
                                    color: AppColors.primaryTextColor
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            CustomTextField(
                              fillColor: AppColors.scaffolddark,
                              hintText: 'Please usdt amount',
                              fieldRadius: const BorderRadius.only(topLeft: Radius.circular(30),bottomLeft: Radius.circular(30)),
                              textColor: Colors.white,
                              keyboardType: TextInputType.number,
                              fontWeight: FontWeight.w600,
                              controller: usdtCon,
                              onChanged: (value) {
                                setState(() {
                                  double amount = double.tryParse(value) ?? 0;
                                  resultt = (amount * 91).toStringAsFixed(2);

                                });

                              },
                              prefixIcon: SizedBox(
                                width: 70,
                                child: Row(
                                  children: [
                                    const SizedBox(width: 10),
                                    Image.asset(Assets.imagesUsdtIcon,height: height*0.03,),
                                    const SizedBox(width: 10),
                                    Container(height: 30, color: Colors.white, width: 2)
                                  ],
                                ),
                              ),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    usdtCon.clear();
                                    selectedusdt = '';
                                    resultt="";
                                  });
                                },
                                icon: const Icon(Icons.cancel_outlined,
                                    color: AppColors.iconColor),
                              ),
                            ),
                            SizedBox(height: height*0.01),
                            Text(
                              'Total amount in Rupees: ${resultt.isNotEmpty ? "$resultt Rs" : "0 Rs"}',
                              style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.primaryTextColor),
                            ),
                            SizedBox(height: height*0.02),
                          ],
                        ),
                      ):
                   Container(),

              const SizedBox(height: 20),

              ///button
             loading == false && selectedIndex == 1
                      ? AppBtn(
                          onTap: () {
                            // IndianOnlinePay(depositCon.text, context);

                          },
                          hideBorder: true,
                          title: 'App Pay Deposit',
                          gradient: AppColors.loginSecondryGrad,
                        )
                      : loading == false && selectedIndex == 2
                          ? AppBtn(
                              onTap: () {
                                // IndianPay(depositCon.text, context);
                                indianPay(depositCon.text, context);
                              },
                              hideBorder: true,
                              title: 'Web Pay Deposit',
                              gradient: AppColors.loginSecondryGrad,
                            )
                          : Center(
                              child: Container(
                                height: 45,
                                width: 43,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        AppColors.gradientFirstColor,
                                        AppColors.gradientSecondColor,
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(30.0)),
                                padding: const EdgeInsets.all(12),
                                child: const CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 4,
                                ),
                              ),
                            ),
              const SizedBox(
                height: 20,
              ),



              const SizedBox(height: 20),
              Container(
                width: width,
                padding: const EdgeInsets.only(top: 15, left: 15, right: 15,bottom: 15),
                decoration: BoxDecoration(
                    color: AppColors.percentageColor,
                    borderRadius: BorderRadiusDirectional.circular(10)),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Image.asset(Assets.iconsRecIns,scale: 1.5,),
                        const SizedBox(width: 15),
                        textWidget(
                            text: 'Recharge instructions',
                            fontSize: 20,
                            color: AppColors.primaryTextColor,
                            fontWeight: FontWeight.w900),
                      ],
                    ),
                    const SizedBox(height: 10,),
                    Container(
                      decoration: BoxDecoration(
                          color: AppColors.percentageColor,
                          border: Border.all(color: AppColors.gradientFirstColor),
                          borderRadius: BorderRadiusDirectional.circular(10)),
                      child: Column(
                        children: [
                          ListView.builder(
                              shrinkWrap: true,
                              itemCount: invitationRuleList.length,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return instruction(invitationRuleList[index]);
                              }),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }



  List<String> invitationRuleList = [];
  Future<void> invitationRuleApi() async {

    final response = await http.get(Uri.parse('${ApiUrl.allRules}3'),);
    if (kDebugMode) {
      print('${ApiUrl.allRules}3');
      print('allRules');
    }


    if (response.statusCode==200) {
      final List<dynamic> responseData = json.decode(response.body)['data'];

      setState(() {
        invitationRuleList = json.decode(responseData[0]['list']).cast<String>();
      });

    }
    else if(response.statusCode==400){
      if (kDebugMode) {
        print('Data not found');
      }
    }
    else {
      setState(() {
        invitationRuleList = [];
      });
      throw Exception('Failed to load data');
    }
  }


  int minimumamount = 100;

  ///gateway select api
  List<GetwayModel> items = [];

  Future<void> getwaySelect() async {


    final response = await http.get(
      // Uri.parse(ApiUrl.getwayList+token),
      Uri.parse(ApiUrl.getwayList),
    );
    if (kDebugMode) {
      print(ApiUrl.getwayList);
      print('getwayList+token');
    }
    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body)['data'];
      setState(() {
        minimumamount = json.decode(response.body)['minimum'];
        items = responseData.map((item) => GetwayModel.fromJson(item)).toList();
        // selectedIndex = items.isNotEmpty ? 0:-1; //
      });
    } else if (response.statusCode == 400) {
      if (kDebugMode) {
        print('Data not found');
      }
    } else {
      setState(() {
        items = [];
      });
      throw Exception('Failed to load data');
    }
  }

  UserViewProvider userProvider = UserViewProvider();

  String userstatus = "";

  // IndianOnlinePay(String depositCon, context) async {
  //   print("wegfi8ew");
  //   setState(() {
  //     loading = true;
  //   });
  //   UserModel user = await userProvider.getUser();
  //   String token = user.id.toString();
  //   if (kDebugMode) {
  //     print(ApiUrl.indianOnlinePayDeposit);
  //     print("ApiUrl.indianOnlinePayDeposit");
  //   }
  //   final response = await http.post(
  //     Uri.parse(ApiUrl.indianOnlinePayDeposit),
  //     headers: <String, String>{
  //       "Content-Type": "application/json; charset=UTF-8",
  //     },
  //     body: jsonEncode(<String, String>{
  //       "user_id": token,
  //       "cash": depositCon,
  //       "type": selectedIndex.toString()
  //     }),
  //   );
  //   final data = jsonDecode(response.body);
  //   if (kDebugMode) {
  //     print(data);
  //     print("jdguywfud");
  //   }
  //   if (data["status"] == 'SUCCESS') {
  //     setState(() {
  //       loading = false;
  //     });
  //     var url = data['intent'].toString();
  //     var qrurl = data['qrcode'].toString();
  //     if (kIsWeb) {
  //
  //       _launchURL(qrurl);
  //       // Navigator.push(context, MaterialPageRoute(builder: (context)=>QRCodeScreen(url: qrurl)));
  //       print(qrurl);
  //       print("qrurl");
  //     } else {
  //       _launchURL(url);
  //     }
  //   } else if(data["status"] == 'FAIL') {
  //     setState(() {
  //       loading = false;
  //     });
  //
  //     Utils.flushBarErrorMessage(data["message"], context, Colors.white);
  //   } else{
  //     setState(() {
  //       loading = false;
  //     });
  //
  //     Utils.flushBarErrorMessage(data["message"], context, Colors.white);
  //   }
  // }

  indianPay(String depositCon, context) async {
    setState(() {
      loading = true;
    });
    UserModel user = await userProvider.getUser();
    String token = user.id.toString();
    if (kDebugMode) {
      print(ApiUrl.indianPayDeposit);
      print("ApiUrl.indianPayDeposit");
    }
    final response = await http.post(
      Uri.parse(ApiUrl.indianPayDeposit),
      headers: <String, String>{
        "Content-Type": "application/json; charset=UTF-8",
      },
      body: jsonEncode(<String, String>{
        "user_id": token,
        "cash": depositCon,
        "type": selectedIndex.toString()
      }),
    );
    final data = jsonDecode(response.body);
    if (kDebugMode) {
      print(data);
      print("jdguywfud");
    }
    if (data["status"] == 'SUCCESS') {
      setState(() {
        loading = false;
      });
      var url = data['payment_link'].toString();
      if (kDebugMode) {
        print(url);
        print('ssssss');
      }
      if (kIsWeb) {
        _launchURL(context,url);
      } else {
     //   _launchURL(url);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => QRCodeScreen(
                      url: url,
                    )));
      }
    } else if(data["status"] == 400) {
      setState(() {
        loading = false;
      });

      Utils.flushBarErrorMessage(data["error"], context, Colors.white);
    } else{
      setState(() {
        loading = false;
      });

      Utils.flushBarErrorMessage(data["message"], context, Colors.white);
    }
  }


  _launchURL(context,String urlget) async {
    var url = urlget;
    if (await canLaunch(url)) {

      await launch(url);

    } else {
      Utils.flushBarErrorMessage("Could not launch $url", context, Colors.white);
      throw 'Could not launch $url';
    }
  }



  paymentstatus(String userstatus, context) async {
    if (kDebugMode) {
      print(ApiUrl.paymentCheckStatus + userstatus);
      print("ApiUrl.paymentCheckStatus+userstatus");
    }

    final response = await http.get(
      Uri.parse(ApiUrl.paymentCheckStatus + userstatus),
    );
    final data = jsonDecode(response.body);
    if (data["status"] == "200") {
      Utils.flushBarSuccessMessage(data["msg"], context, Colors.white);
    } else {
      Utils.flushBarErrorMessage(data["msg"], context, Colors.white);
    }
  }
}

class Notfounddata extends StatelessWidget {
  const Notfounddata({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: height * 0.07),
        const Text(
          "Data not found",
        )
      ],
    );
  }
}

Widget instruction(String title) {
  return ListTile(
    leading: Transform.rotate(
      angle: 45 * 3.1415927 / 180,
      child: Container(
        height: 10,
        width: 10,
        color: AppColors.gradientFirstColor,
      ),
    ),
    title: textWidget(
      text: title,
      fontSize: 14,
        color: AppColors.primaryTextColor
    ),
  );
}

class DepositModel {
  final String value;
  final String title;

  DepositModel({
    required this.value,
    required this.title,
  });
}
