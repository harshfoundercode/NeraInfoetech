// ignore_for_file: depend_on_referenced_packages, library_private_types_in_public_api, camel_case_types, non_constant_identifier_names, use_build_context_synchronously, unrelated_type_equality_checks
import 'dart:async';
import 'dart:convert';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:nera/main.dart';
import 'package:nera/model/result_game_history.dart';
import 'package:nera/res/components/audio.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:nera/generated/assets.dart';
import 'package:nera/model/bettingHistory_Model.dart';
import 'package:nera/model/user_model.dart';
import 'package:nera/res/aap_colors.dart';
import 'package:nera/res/api_urls.dart';
import 'package:nera/res/components/app_bar.dart';
import 'package:nera/res/components/app_btn.dart';
import 'package:nera/res/provider/profile_provider.dart';
import 'package:nera/view/account/howtoplay.dart';
import 'package:nera/view/account/service_center/custmor_service.dart';
import 'package:nera/view/auth/constant_wallet.dart';
import 'package:nera/view/home/lottery/WinGo/commonbottomsheet.dart';
import 'package:nera/res/components/text_widget.dart';
import 'package:nera/res/helper/api_helper.dart';
import 'package:nera/res/provider/user_view_provider.dart';
import 'package:nera/view/home/lottery/WinGo/dummy_grid.dart';
import 'package:nera/view/home/lottery/WinGo/my_history_detail.dart';
import 'package:nera/view/home/lottery/WinGo/win_loss_popup/loss_popup.dart';
import 'package:nera/view/home/lottery/WinGo/win_loss_popup/win_popup.dart';
import 'package:provider/provider.dart';



class WinGoScreen extends StatefulWidget {
  const WinGoScreen({super.key});

  @override
  _WinGoScreenState createState() => _WinGoScreenState();
}

class _WinGoScreenState extends State<WinGoScreen>
    with SingleTickerProviderStateMixin {
  late int selectedCatIndex;

  @override
  void initState() {
    Audio.audioPlayers;
    startCountdown();
    gameHistoryResult();
    BettingHistory();
    invitationRuleApi();
    // context.read<ProfileProvider>().totalWallet;

    const ConstantWallet();
    print("ConstantWallet");
    print(ConstantWallet);
    super.initState();
    selectedCatIndex = 0;
  }

  int selectedContainerIndex = -1;

  List<BetNumbers> betNumbers = [
    BetNumbers(Assets.images0, Colors.red, Colors.purple, "0"),
    BetNumbers(Assets.images1, Colors.green, Colors.green, "1"),
    BetNumbers(Assets.images2, Colors.red, Colors.red, "2"),
    BetNumbers(Assets.images3, Colors.green, Colors.green, "3"),
    BetNumbers(Assets.images4, Colors.red, Colors.red, "4"),
    BetNumbers(Assets.images5, Colors.red, Colors.purple, "5"),
    BetNumbers(Assets.images6, Colors.red, Colors.red, "6"),
    BetNumbers(Assets.images7, Colors.green, Colors.green, "7"),
    BetNumbers(Assets.images8, Colors.red, Colors.red, "8"),
    BetNumbers(Assets.images9, Colors.green, Colors.green, "9"),
  ];

  List<Winlist> list = [
    Winlist(1, "Win Go", "1 Min", 60),
    Winlist(2, "Win Go", "3 Min", 180),
    Winlist(3, "Win Go", "5 Min", 300),
    Winlist(4, "Win Go", "10 Min", 600),
  ];

  int countdownSeconds = 60;
  int gameseconds = 60;
  String gametitle = 'Wingo';
  String subtitle = '1 Min';
  Timer? countdownTimer;

  Future<void> startCountdown() async {
    DateTime now = DateTime.now().toUtc();
    int minutes = now.minute;
    int minsec = minutes * 60;
    int initialSeconds = 60;
    if (gameseconds == 60) {
      initialSeconds = gameseconds - now.second;
    } else if (gameseconds == 180) {
      for (var i = 0; i < 20; i++) {
        if (minsec >= 180) {
          minsec = minsec - 180;
        } else {
          initialSeconds = gameseconds - minsec - now.second;
        }
        if (kDebugMode) {
          print(initialSeconds);
        }
      }
    } else if (gameseconds == 300) {
      for (var i = 0; i < 12; i++) {
        if (minsec >= 300) {
          minsec = minsec - 300;
        } else {
          initialSeconds = gameseconds - minsec - now.second;
        }
      }
    } else if (gameseconds == 600) {
      for (var i = 0; i < 6; i++) {
        if (minsec >= 600) {
          minsec = minsec - 600;
        } else {
          initialSeconds = gameseconds -
              minsec -
              now.second; // Calculate initial remaining seconds
        }
      }
    }
    setState(() {
      countdownSeconds = initialSeconds;
    });
    countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      gameconcept(countdownSeconds);
      updateUI(timer);
    });
  }

  void updateUI(Timer timer) {
    setState(() {
      if (countdownSeconds == 5) {
      } else if (countdownSeconds == 0) {
        countdownSeconds = gameseconds;
        game_winPopup();

        const ConstantWallet();
       // context.read<ProfileProvider>().setIntialUser();
       context.read<ProfileProvider>().fetchProfileData();
       // context.read<ProfileProvider>().totalWallet;

        gameHistoryResult();
        BettingHistory();

      }
      countdownSeconds = (countdownSeconds - 1);
    });
  }

  int? responseStatuscode;

  @override
  void dispose() {
    countdownSeconds.toString();
    Audio.audioPlayers.stop();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.scaffolddark,
        resizeToAvoidBottomInset: true,
        appBar: GradientAppBar(
          leading: const AppBackBtn(),
          title:Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 70,
                backgroundColor: Colors.transparent,
                backgroundImage: AssetImage(Assets.imagesAppBarSecond),
              ),
            ],
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>const CustomerCareService()));
                },
                child: SizedBox(
                  height: 30,
                  width: 30,
                  child: Image.asset(
                    Assets.iconsKefu,
                    scale: 1.8,
                  ),
                ),
              ),
            )
          ],
          centerTitle: true,
          gradient: AppColors.primaryUnselectedGradient,
        ),
        body: SingleChildScrollView(
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Column(
                children: [
                  const SizedBox(height: 20),
                   const ConstantWallet(),
                  Container(
                    height: height*0.07,
                    margin: const EdgeInsets.only(right: 10, left: 10,top: 5,bottom: 5),
                    decoration: BoxDecoration( color:AppColors.filledColor,borderRadius: BorderRadius.circular(20)),
                    child: Row(
                      children: [
                        Image.asset(
                          Assets.iconsMicphone,
                          height: 30,
                        ),
                        SizedBox(width: width*0.01),
                        _rotate(),
                        Image.asset(
                          Assets.iconsNotification,
                          height: 30,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: height * 0.18,
                    margin: const EdgeInsets.only(left: 10, right: 10),
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryUnselectedGradient,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(list.length, (index) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedCatIndex = index;
                              subtitle = list[index].subtitle;
                              gameseconds = list[index].time;
                              gameid = list[index].gameid;
                            });
                            countdownTimer!.cancel();
                            startCountdown();
                            offsetResult = 0;
                            gameHistoryResult();
                            BettingHistory();
                          },
                          child: Container(
                            height: height * 0.28,
                            width: width * 0.23,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  width: 1.5,
                                  color: selectedCatIndex == index
                                      ? Colors.grey.withOpacity(0.2)
                                      : Colors.transparent),
                              gradient: selectedCatIndex == index
                                  ? AppColors.boxGradient
                                  : const LinearGradient(
                                      colors: [
                                        Colors.transparent,
                                        Colors.transparent
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              children: [
                                selectedCatIndex == index
                                    ? Image.asset(Assets.iconsTimeColor,
                                        height: 70)
                                    : Image.asset(Assets.iconsTime, height: 70),
                                textWidget(
                                    text: list[index].title,
                                    color: selectedCatIndex == index
                                        ? AppColors.primaryTextColor
                                        : AppColors.gradientFirstColor,
                                    fontSize: 14),
                                textWidget(
                                    text: list[index].subtitle,
                                    color: selectedCatIndex == index
                                        ? AppColors.primaryTextColor
                                        : AppColors.gradientFirstColor,
                                    fontSize: 14),
                              ],
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 10, right: 10),
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(Assets.imagesBgCutRed),
                            fit: BoxFit.fill)),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: () {
                                showDialog(
                                  barrierDismissible: false,
                                    context: context,
                                    builder: (BuildContext context) => const HowToPlay(type: '8',));

                                // Navigator.push(context, MaterialPageRoute(builder: (context)=> HowtoplayScreen()));
                              },
                              child: Container(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  height: 26,
                                  width: width * 0.35,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      border: Border.all(
                                          color: AppColors.primaryTextColor)),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        Assets.iconsHowtoplay,
                                        height: 16,
                                      ),
                                      const Text(
                                        ' How to Play',
                                        style: TextStyle(
                                            color: AppColors.primaryTextColor),
                                      ),
                                    ],
                                  )),
                            ),
                            SizedBox(
                              height: height * 0.01,
                            ),
                            Text(
                              'Win Go $subtitle',
                              style: const TextStyle(
                                  color: AppColors.primaryTextColor),
                            ),
                            gameResult.isEmpty
                                ? Container()
                                : SizedBox(
                              width: 130,
                                  height: 25,
                                  child: ListView.builder(
                              scrollDirection: Axis.horizontal, // Ensure it scrolls horizontally
                              itemCount: 5, // Assuming you have 5 items
                              itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Image(
                                      image: AssetImage(
                                        betNumbers[int.parse(gameResult[index].number.toString())].photo.toString(),
                                      ),
                                      height: 25,
                                    ),
                                  );
                              },
                            ),
                                ),

                          ],
                        ),
                        const Spacer(),
                        Column(
                          children: [
                            const Text(
                              'Time Remaining',
                              style: TextStyle(
                                  color: AppColors.primaryTextColor,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            buildTime1(countdownSeconds),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              period.toString(),
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.gradientFirstColor),
                            ),

                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  create == false
                      ? Container(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  InkWell(
                                    onTap: () async {
                                      showModalBottomSheet(
                                          isScrollControlled: true,
                                          shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.only(
                                                  topRight: Radius.circular(25),
                                                  topLeft:
                                                      Radius.circular(25))),
                                          context: (context),
                                          builder: (context) {
                                            return CommonBottomSheet(
                                                colors: const [
                                                  AppColors.filledColor,
                                                  AppColors.filledColor,
                                                ],
                                                colorName: "Green",
                                                predictionType: "10",
                                                gameid: gameid);
                                          });
                                      await Future.delayed(
                                          const Duration(seconds: 5));
                                      BettingHistory();
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      height: 40,
                                      width: width * 0.28,
                                      decoration: const BoxDecoration(
                                          color: Colors.green,
                                          borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(10),
                                              bottomLeft: Radius.circular(10))),
                                      child: textWidget(
                                          text: 'Green',
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.primaryTextColor),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      showModalBottomSheet(
                                          isScrollControlled: true,
                                          shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.only(
                                                  topRight: Radius.circular(25),
                                                  topLeft:
                                                      Radius.circular(25))),
                                          context: (context),
                                          builder: (context) {
                                            return CommonBottomSheet(
                                              colors: const [
                                                AppColors.filledColor,
                                                AppColors.filledColor,
                                              ],
                                              colorName: "White",
                                              predictionType: "20",
                                              gameid: gameid,
                                            );
                                          });
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      height: 40,
                                      width: width * 0.28,
                                      decoration: const BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      child: textWidget(
                                          text: 'White',
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.TextBlack),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      showModalBottomSheet(
                                          isScrollControlled: true,
                                          shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.only(
                                                  topRight: Radius.circular(25),
                                                  topLeft:
                                                      Radius.circular(25))),
                                          context: (context),
                                          builder: (context) {
                                            return CommonBottomSheet(
                                              colors: const [
                                                AppColors.filledColor,
                                                AppColors.filledColor,
                                              ],
                                              colorName: "Orange",
                                              predictionType: "30",
                                              gameid: gameid,
                                            );
                                          });
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      height: 40,
                                      width: width * 0.28,
                                      decoration: const BoxDecoration(
                                          color: AppColors.orangeColor,
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(10),
                                              bottomRight:
                                                  Radius.circular(10))),
                                      child: textWidget(
                                          text: 'Orange',
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.primaryTextColor),
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Container(
                                margin:
                                    const EdgeInsets.only(left: 10, right: 10),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 10),
                                decoration: const BoxDecoration(
                                    gradient:
                                        AppColors.primaryUnselectedGradient,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                child: GridView.builder(
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 5,
                                    crossAxisSpacing: 8.0,
                                    mainAxisSpacing: 8.0,
                                  ),
                                  shrinkWrap: true,
                                  itemCount: 10,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return InkWell(
                                      onTap: () {
                                        showModalBottomSheet(
                                            isScrollControlled: true,
                                            shape: const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.only(
                                                    topRight:
                                                        Radius.circular(25),
                                                    topLeft:
                                                        Radius.circular(25))),
                                            context: (context),
                                            builder: (context) {
                                              return CommonBottomSheet(
                                                colors: const [
                                                  AppColors.filledColor,
                                                  AppColors.filledColor,

                                                  // betNumbers[index].colortwo
                                                ],
                                                colorName: betNumbers[index]
                                                    .number
                                                    .toString(),
                                                predictionType:
                                                    betNumbers[index]
                                                        .number
                                                        .toString(),
                                                gameid: gameid,
                                              );
                                            });
                                      },
                                      child: Image(
                                        image: AssetImage(
                                            betNumbers[index].photo.toString()),
                                        height: height / 15,
                                      ),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      showModalBottomSheet(
                                          isScrollControlled: true,
                                          shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.only(
                                                  topRight: Radius.circular(25),
                                                  topLeft:
                                                      Radius.circular(25))),
                                          context: (context),
                                          builder: (context) {
                                            return CommonBottomSheet(
                                              colors: const [
                                                AppColors.filledColor,
                                                AppColors.filledColor,
                                              ],
                                              colorName: "Big",
                                              predictionType: "40",
                                              gameid: gameid,
                                            );
                                          });
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      height: 40,
                                      width: width * 0.35,
                                      decoration: const BoxDecoration(
                                          gradient: AppColors.btnYellowGradient,
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(50),
                                              bottomLeft: Radius.circular(50))),
                                      child: textWidget(
                                          text: 'Big',
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.primaryTextColor),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      showModalBottomSheet(
                                          isScrollControlled: true,
                                          shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.only(
                                                  topRight: Radius.circular(25),
                                                  topLeft:
                                                      Radius.circular(25))),
                                          context: (context),
                                          builder: (context) {
                                            return CommonBottomSheet(
                                              colors: const [
                                                AppColors.filledColor,
                                                AppColors.filledColor,
                                              ],
                                              colorName: "Small",
                                              predictionType: "50",
                                              gameid: gameid,
                                            );
                                          });
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      height: 40,
                                      width: width * 0.35,
                                      decoration: const BoxDecoration(
                                          gradient: AppColors.btnBlueGradient,
                                          borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(50),
                                              bottomRight:
                                                  Radius.circular(50))),
                                      child: textWidget(
                                          text: 'Small',
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.primaryTextColor),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                      : Stack(
                          children: [
                            const DummyGrid(),
                            Container(
                              height: 250,
                              color: Colors.black26,
                              child: buildTime5sec(countdownSeconds),
                            ),
                          ],
                        ),
                  const SizedBox(height: 15),
                  WinGoResult()
                ],
              ),
            ],
          ),
        ));
  }

  bool create = false;
  int period = 0;
  int gameid = 1;
  int pageNumber = 1;
  int selectedTabIndex = 0;

  Widget _rotate(){
    return Column(
      mainAxisSize: MainAxisSize.max,
      children:[
        DefaultTextStyle(
          style: const TextStyle(
              fontSize: 12,
              color: Colors.white
          ),
          child: SizedBox(
            width: width*0.75,
            child: AnimatedTextKit(
              repeatForever: true,
              isRepeatingAnimation: true,
              animatedTexts: invitationRuleList.isEmpty ?[RotateAnimatedText("")]:invitationRuleList.map((rule) => RotateAnimatedText(rule)).toList(),
            ),
          ),
        ),
      ],
    );


  }

  List<String> invitationRuleList = [];
  Future<void> invitationRuleApi() async {

    final response = await http.get(Uri.parse('${ApiUrl.allRules}6'),);
    if (kDebugMode) {
      print('${ApiUrl.allRules}6');
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
/// new api

  List<ResultGameHistory> gameResult = [];
  Future<void> gameHistoryResult() async {
    final response = await http.get(Uri.parse('${ApiUrl.resultList}$gameid&limit=10&offset=$offsetResult'),);
    if (kDebugMode) {
      print(ApiUrl.changeAvtarList);
      print('changeAvtarList');

    }
    if (response.statusCode==200) {
      final List<dynamic> responseData = json.decode(response.body)['data'];
      setState(() {
        gameResult = responseData.map((item) => ResultGameHistory.fromJson(item)).toList();
        period=int.parse(responseData[0]['gamesno'].toString()) + 1;
      });

    }
    else if(response.statusCode==400){
      if (kDebugMode) {
        print('Data not found');
      }
    }
    else {
      setState(() {
        gameResult = [];
      });
      throw Exception('Failed to load data');
    }
  }

  List<BettingHistoryModel> items = [];
  Future<void> BettingHistory() async {
    UserModel user = await userProvider.getUser();
    String token = user.id.toString();
    final response = await http.get(
      Uri.parse('${ApiUrl.betHistory}$token&game_id=$gameid&limit=10&offset=$offsetResult'),
    );
    if (kDebugMode) {
      print('${ApiUrl.betHistory}$token&game_id=$gameid&limit=10&offset=$offsetResult');
      print('betHistory+token');
    }

    setState(() {
      responseStatuscode = response.statusCode;
    });

    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body)['data'];
      setState(() {
        items = responseData
            .map((item) => BettingHistoryModel.fromJson(item))
            .toList();
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

  Widget WinGoResult() {
    setState(() {});

    return gameResult != []
        ? Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  buildTabContainer(
                    'Game History',
                    0,
                    width,
                    Colors.red,
                  ),
                  buildTabContainer('Chart', 1, width, Colors.red),
                  buildTabContainer('My History', 2, width, Colors.red),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              selectedTabIndex == 0
                  ? Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          margin: const EdgeInsets.only(left: 10, right: 10),
                          decoration: const BoxDecoration(
                              gradient: AppColors.primaryUnselectedGradient,
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(10),
                                  topLeft: Radius.circular(10))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                alignment: Alignment.center,
                                width: width * 0.3,
                                child: textWidget(
                                    text: 'Period',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w900,
                                    color: AppColors.primaryTextColor),
                              ),
                              Container(
                                alignment: Alignment.center,
                                width: width * 0.21,
                                child: textWidget(
                                    text: 'Number',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w900,
                                    color: AppColors.primaryTextColor),
                              ),
                              Container(
                                alignment: Alignment.center,
                                width: width * 0.21,
                                child: textWidget(
                                    text: 'Big Small',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w900,
                                    color: AppColors.primaryTextColor),
                              ),
                              Container(
                                alignment: Alignment.center,
                                width: width * 0.21,
                                child: textWidget(
                                    text: 'Color',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w900,
                                    color: AppColors.primaryTextColor),
                              ),
                            ],
                          ),
                        ),
                        ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: gameResult.length,
                          itemBuilder: (context, index) {
                            List<Color> colors;

                            if (gameResult[index].number == '0') {
                              colors = [
                                AppColors.orangeColor,
                                AppColors.primaryTextColor,
                              ];
                            } else if (gameResult[index].number == '5') {
                              colors = [
                                const Color(0xFF40ad72),
                                AppColors.primaryTextColor,
                              ];
                            } else {
                              int number = int.parse(
                                  gameResult[index].number.toString());
                              colors = number.isOdd
                                  ? [
                                      const Color(0xFF40ad72),
                                      const Color(0xFF40ad72),
                                    ]
                                  : [
                                      AppColors.orangeColor,
                                      AppColors.orangeColor,
                                    ];
                            }

                            Color getCircleAvatarColor(int number) {
                              return number.isOdd
                                  ? const Color(0xFF40ad72)
                                  : AppColors.orangeColor;
                            }

                            return Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      alignment: Alignment.center,
                                      height: height * 0.06,
                                      width: width * 0.3,
                                      child: textWidget(
                                          text: gameResult[index].gamesno.toString(),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          maxLines: 1,
                                          color: AppColors.primaryTextColor),
                                    ),
                                    Container(
                                      alignment: Alignment.center,
                                      width: width * 0.21,
                                      height: height * 0.06,
                                      child: gameResult[index].number ==
                                              5
                                          ? Container(
                                              height: 25,
                                              width: 25,
                                              margin: const EdgeInsets.all(2),
                                              alignment: Alignment.center,
                                              decoration: const BoxDecoration(
                                                  image: DecorationImage(
                                                      image: AssetImage(
                                                Assets.icons5text,
                                              ))),
                                            )
                                          : gameResult[index].number == 0
                                              ? Container(
                                                  height: 25,
                                                  width: 25,
                                                  margin:
                                                      const EdgeInsets.all(2),
                                                  alignment: Alignment.center,
                                                  decoration:
                                                      const BoxDecoration(
                                                          image: DecorationImage(
                                                              image: AssetImage(
                                                    Assets.icons0text,
                                                  ))),
                                                )
                                              : GradientTextview(
                                        gameResult[index]
                                                      .number
                                                      .toString(),
                                                  style: const TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.w900,
                                                  ),
                                                  gradient: LinearGradient(
                                                    colors: colors,
                                                    stops: const [0.5, 0.5],
                                                    begin: Alignment.topCenter,
                                                    end: Alignment.bottomCenter,
                                                    tileMode: TileMode.mirror,
                                                  ),
                                                ),
                                    ),
                                    Container(
                                      alignment: Alignment.center,
                                      width: width * 0.21,
                                      height: height * 0.06,
                                      child: GradientTextview(
                                        int.parse(gameResult[index]
                                                    .number
                                                    .toString()) <
                                                5
                                            ? 'Small'
                                            : 'Big',
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w900),
                                        gradient: LinearGradient(
                                          colors: int.parse(
                                              gameResult[index]
                                                          .number
                                                          .toString()) <
                                                  5
                                              ? [
                                                  AppColors.methodblue,
                                                  AppColors.methodblue
                                                ]
                                              : [
                                                  AppColors.goldencolor,
                                                  AppColors.goldencolor
                                                ],
                                          stops: const [0.5, 0.5],
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          tileMode: TileMode.mirror,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: height * 0.06,
                                      width: width * 0.21,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          CircleAvatar(
                                            radius: 6,
                                            backgroundColor:
                                                getCircleAvatarColor(int.parse(
                                                    gameResult[index].number.toString())),
                                          ),
                                          if (int.parse(gameResult[index]
                                                      .number
                                                      .toString()) ==
                                                  5 ||
                                              int.parse(gameResult[index]
                                                      .number
                                                      .toString()) ==
                                                  0)
                                            Container(
                                              height: 12,
                                              width: 12,
                                              margin: const EdgeInsets.all(2),
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  border: Border.all(
                                                    width: 2,
                                                    color: getCircleAvatarColor(
                                                        int.parse(
                                                            gameResult[index]
                                                                .number.toString())),
                                                  )),
                                            )

                                          // CircleAvatar(
                                          //   radius: 6,
                                          //   backgroundColor:
                                          //  AppColors.primaryTextColor ,
                                          // )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                    width: width,
                                    color: Colors.grey,
                                    height: 0.5),
                              ],
                            );
                          },
                        ),
                        SizedBox(height: height * 0.02),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: limitResult == 0
                                  ? () {}
                                  : () {
                                setState(() {
                                  pageNumber--;
                                  limitResult = limitResult - 10;
                                  offsetResult = offsetResult - 10;
                                });
                                setState(() {});
                                gameHistoryResult();
                              },
                              child: Container(
                                height: height * 0.06,
                                width: width * 0.10,
                                decoration: BoxDecoration(
                                  gradient: AppColors.loginSecondryGrad,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(
                                  Icons.navigate_before,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            textWidget(
                              text: '$pageNumber',
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primaryTextColor,
                              maxLines: 1,
                            ),
                            const SizedBox(width: 16),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  limitResult = limitResult + 10;
                                  offsetResult = offsetResult + 10;
                                  pageNumber++;
                                });
                                setState(() {});
                                gameHistoryResult();
                              },
                              child: Container(
                                height: height * 0.06,
                                width: width * 0.10,
                                decoration: BoxDecoration(
                                  gradient: AppColors.loginSecondryGrad,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(Icons.navigate_next,
                                    color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10)
                      ],
                    )
                  : selectedTabIndex == 1
                      ? ChartScreen()
                      : responseStatuscode == 400
                          ? const Notfounddata()
                          : items.isEmpty
                              ? const Center(child: CircularProgressIndicator())
                              : Container(
                                  width: width,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 15, horizontal: 15),
                                  margin: const EdgeInsets.only(
                                      left: 10, right: 10),
                                  decoration: const BoxDecoration(
                                      gradient:
                                          AppColors.primaryUnselectedGradient,
                                      borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(10),
                                          topLeft: Radius.circular(10))),
                                  child: Column(
                                    children: [
                                      Align(
                                        alignment: Alignment.bottomRight,
                                        child: InkWell(
                                          onTap: (){
                                            Navigator.push(context, MaterialPageRoute(builder: (context)=>const MyHistoryDetails()));
                                          },
                                          child: Container(
                                            height: height * 0.06,
                                            width: width * 0.25,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                border: Border.all(
                                                    color: AppColors.gradientFirstColor)),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                const Text(
                                                  'Detail',
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.w700,
                                                      color: AppColors
                                                          .primaryTextColor),
                                                ),
                                                SizedBox(
                                                    height: height * 0.04,
                                                    width: width * 0.09,
                                                    child: const Image(
                                                        image: AssetImage(Assets
                                                            .iconsMoreBtn))),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      ListView.builder(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: items.length,
                                        itemBuilder: (context, index) {
                                          List<Color> colors;

                                          if (items[index].number ==
                                              0) {
                                            colors = [
                                              AppColors.orangeColor,
                                              AppColors.primaryTextColor,
                                            ];
                                          } else if (items[index]
                                              .number ==
                                              5) {
                                            colors = [
                                              const Color(0xFF40ad72),
                                              AppColors.primaryTextColor,
                                            ];
                                          } else if (items[index]
                                              .number ==
                                              10) {
                                            colors = [
                                              const Color(0xFF40ad72),
                                              const Color(0xFF40ad72),
                                            ];
                                          }
                                          else if (items[index]
                                              .number ==
                                              20) {
                                            colors = [
                                              AppColors.primaryTextColor,
                                              AppColors.primaryTextColor,
                                            ];
                                          }
                                          else if (items[index]
                                              .number ==
                                              30) {
                                            colors = [
                                              AppColors.orangeColor,
                                              AppColors.orangeColor,
                                            ];
                                          }

                                          else if (items[index].number ==
                                              40) {
                                            colors = [
                                              AppColors.goldencolor,
                                              AppColors.goldencolor,
                                            ];
                                          } else if (items[index]
                                              .number ==
                                              50) {
                                            colors = [
                                              const Color(0xff6eb4ff),
                                              const Color(0xff6eb4ff)
                                            ];
                                          }
                                          else {
                                            int number = int.parse(
                                                items[index]
                                                    .number
                                                    .toString());
                                            colors = number.isOdd
                                                ? [
                                              const Color(0xFF40ad72),
                                              const Color(0xFF40ad72),
                                            ]
                                                : [
                                              AppColors.orangeColor,
                                              AppColors.orangeColor,
                                            ];
                                          }



                                          return ExpansionTile(
                                            leading: Container(
                                              height: height * 0.06,
                                              width: width * 0.12,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  // color: Colors.grey
                                                  gradient: LinearGradient(
                                                      stops: const [
                                                        0.5,
                                                        0.5
                                                      ],
                                                      colors:colors,
                                                      begin: Alignment.topLeft,
                                                      end: Alignment
                                                          .bottomRight)),
                                              child:  Center(
                                                child: Text(items[index]
                                                    .number==40?'Big':items[index]
                                                    .number==50?'Small':
                                                items[index]
                                                    .number==10?'G':
                                                items[index]
                                                    .number==20?'W':
                                                items[index]
                                                    .number==30?'O':
                                                  items[index]
                                                      .number
                                                      .toString(),
                                                  style: TextStyle(
                                                      fontSize: items[index]
                                                          .number==40?10:items[index]
                                                          .number==50?10:20,
                                                      fontWeight: FontWeight.w800,
                                                      color: Colors.black),
                                                ),
                                              )
                                            ),
                                            title:  Text(
                                              items[index].gamesno.toString(),
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w800,
                                                  color: Colors.white),
                                            ),
                                            subtitle:  Text(
                                                items[index].createdAt.toString(),
                                                style: const TextStyle(
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.w700,
                                                    color: Colors.grey)),
                                            trailing: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Container(
                                                  height: height * 0.042,
                                                  width: width * 0.2,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      border: Border.all(
                                                          color: items[index].status==0? AppColors.primaryTextColor:items[index].status==2?
                                                          AppColors
                                                              .secondaryTextColor: Colors.green)),
                                                  child: Center(
                                                    child:  Text(
                                                      items[index].status==2?'Failed':items[index].status==0?'Pending':'Succeed',
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          color:
                                                          items[index].status==0?Colors.white:
                                                          items[index].status==2?
                                                          AppColors
                                                              .secondaryTextColor: Colors.green),
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                  items[index].status==0?'--':
                                                    items[index].status==2?'- ₹${items[index].amount.toStringAsFixed(2)}':'+ ₹${items[index].winAmount.toStringAsFixed(2)}',
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color: items[index].status==0?Colors.white:items[index].status==2?
                                                      AppColors
                                                          .secondaryTextColor: Colors.green),
                                                ),
                                              ],
                                            ),
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.symmetric(
                                                    horizontal: 16.0),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    const SizedBox(
                                                      height: 15,
                                                    ),
                                                    const Align(
                                                        alignment:
                                                            Alignment.topLeft,
                                                        child: Text(
                                                          'Details',
                                                          style: TextStyle(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w900,
                                                              color:
                                                                  Colors.white),
                                                        )),
                                                    const SizedBox(height: 8.0),
                                                    Container(
                                                      height: height * 0.08,
                                                      width: width,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          color: AppColors
                                                              .FirstColor),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            const Text(
                                                              'order number',
                                                              style: TextStyle(
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                            const SizedBox(
                                                                height: 4.0),
                                                            Text(
                                                                items[index].orderId.toString(),
                                                              style: const TextStyle(
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                  color: Colors
                                                                      .white),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    historyDetails(
                                                        'Period',
                                                        items[index].gamesno.toString(),
                                                        Colors.white),
                                                    historyDetails(
                                                        'Purchase amount',
                                                        items[index].amount.toString(),
                                                        Colors.white),
                                                    historyDetails(
                                                        'Amount after tax',
                                                        items[index].tradeAmount.toString(),
                                                        Colors.red),
                                                    historyDetails('Tax',
                                                        items[index].commission.toString(), Colors.white),
                                                    historyWinDetails(
                                                        'Result',
                                                        items[index].winNumber==null? '--':
                                                        '${items[index].winNumber}, ',
                                                        items[index].winNumber==5?'Green White,':
                                                        items[index].winNumber==0?'orange white,':
                                                        items[index].winNumber==null? '':
                                                        items[index].winNumber.isOdd?
                                                        'green,':'orange,',
                                                        items[index].winNumber==null? '':
                                                        items[index].winNumber<5?
                                                        'small':'Big',
                                                        Colors.white,
                                                        items[index].winNumber==null?Colors.orange:
                                                        items[index].winNumber.isOdd?
                                                        Colors.green:Colors.orange,
                                                        items[index].winNumber==null?Colors.orange:
                                                        items[index].winNumber<5?
                                                        Colors.yellow:Colors.blue),
                                                    historyDetails('Select',
                                                        items[index].number==50?'small':items[index].number==40?'big':
                                                        items[index].number==10?'Green':items[index].number==20?'White':
                                                        items[index].number==30?'Orange':
                                                        items[index].number.toString(), Colors.white),
                                                    historyDetails('Status',
                                                        items[index].status==0?'Unpaid':
                                                        items[index].status==2?
                                                        'Failed':'Succeed', items[index].status==0?Colors.white:items[index].status==2?Colors.red:Colors.green),
                                                    historyDetails('Win/Loss',
                                                        items[index].status==0?'--': '₹${items[index].winAmount.toStringAsFixed(2)}', items[index].status==0?Colors.white:items[index].status==2? Colors.red:Colors.green),
                                                    historyDetails(
                                                        'Order time',
                                                        items[index].createdAt.toString(),
                                                        Colors.white),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                      responseStatuscode == 400?Container():
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          GestureDetector(
                                            onTap: limitResult == 0
                                                ? () {}
                                                : () {
                                              setState(() {
                                                pageNumber--;
                                                limitResult = limitResult - 10;
                                                offsetResult = offsetResult - 10;
                                              });
                                              setState(() {});
                                              BettingHistory();
                                            },
                                            child: Container(
                                              height: height * 0.06,
                                              width: width * 0.10,
                                              decoration: BoxDecoration(
                                                gradient: AppColors.loginSecondryGrad,
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              child: const Icon(
                                                Icons.navigate_before,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 16),
                                          textWidget(
                                            text: '$pageNumber/${items.length}',
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.primaryTextColor,
                                            maxLines: 1,
                                          ),
                                          const SizedBox(width: 16),
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                limitResult = limitResult + 10;
                                                offsetResult = offsetResult + 10;
                                                pageNumber++;
                                              });
                                              setState(() {});
                                              BettingHistory();
                                            },
                                            child: Container(
                                              height: height * 0.06,
                                              width: width * 0.10,
                                              decoration: BoxDecoration(
                                                gradient: AppColors.loginSecondryGrad,
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              child: const Icon(Icons.navigate_next,
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                )
            ],
          )
        : Container();
  }

  int limitResult = 0;
  int offsetResult = 0;

  game_winPopup() async {
    UserModel user = await userProvider.getUser();
    String userid = user.id.toString();
    final response = await http.get(
        Uri.parse('${ApiUrl.game_win}$userid&game_id=$gameid&gamesno=$period'));

    var data = jsonDecode(response.body);
    if (kDebugMode) {
      print('${ApiUrl.game_win}$userid&game_id=$gameid&gamesno=$period');
      print('nbnbnbnbn');
      print(data);
      print('data');
    }
    if (data["status"] == 200) {
      context.read<ProfileProvider>().fetchProfileData();

      var totalamount = data["totalamount"];
      var win = data["win"];
      var gamesno = data["gamesno"];
      var gameid = data["gameid"];
      var number = data["number"];
      var result = data["result"];
      result == "lose"
          ?   showDialog(
        context: context,
        builder: (BuildContext context) {
          return LossPopupPage(
            subtext: number.toString(),
            subtext1: totalamount.toString(),
            subtext2: win.toString(),
            subtext3: gamesno.toString(),
            subtext4: gameid.toString(),
          ); // Call the Popup widget
        },
      )

          :  showDialog(
        context: context,
        builder: (BuildContext context) {
          return WinPopupPage(
            subtext: number.toString(),
            subtext1: totalamount.toString(),
            subtext2: win.toString(),
            subtext3: gamesno.toString(),
            subtext4: gameid.toString(),
          ); // Call the Popup widget
        },
      );
    } else {
      context.read<ProfileProvider>().fetchProfileData();
      setState(() {
      });
    }
  }

  void showPopup(BuildContext context, String totalamount, String win,
      String gamesno, String gameids) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(14))),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              textWidget(
                text: "Win Go :",
                fontSize: 12,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
              textWidget(
                text: gameids == '1'
                    ? '1 Min'
                    : gameids == '2'
                        ? '3 Min'
                        : gameids == '3'
                            ? '5 Min'
                            : '10 Min',
                fontSize: 14,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ],
          ),
          content: SizedBox(
            height: 180,
            child: Column(
              children: [
                ListTile(
                  leading: textWidget(
                    text: "Game S.No.:",
                    fontSize: 12,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                  trailing: textWidget(
                    text: gamesno,
                    fontSize: 12,
                    color: AppColors.secondaryTextColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ListTile(
                  leading: textWidget(
                    text: "Total Bet Amount:",
                    fontSize: 12,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                  trailing: textWidget(
                    text: totalamount,
                    fontSize: 12,
                    color: AppColors.secondaryTextColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ListTile(
                  leading: textWidget(
                    text: "Total Win Amount:",
                    fontSize: 12,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                  trailing: textWidget(
                    text: win,
                    fontSize: 12,
                    color: AppColors.secondaryTextColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  ///chart page
  Widget ChartScreen() {
    setState(() {});

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 15),
          margin: const EdgeInsets.only(left: 10, right: 10),
          decoration: const BoxDecoration(
              color: AppColors.percentageColor,
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(10), topLeft: Radius.circular(10))),
          child: Row(
            //  mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                alignment: Alignment.center,
                width: width * 0.3,
                child: textWidget(
                    text: 'Period',
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                    color: AppColors.primaryTextColor),
              ),
              const SizedBox(
                width: 40,
              ),
              Container(
                alignment: Alignment.center,
                width: width * 0.21,
                child: textWidget(
                    text: 'Number',
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                    color: AppColors.primaryTextColor),
              ),
            ],
          ),
        ),
        Column(
          children: List.generate(
            gameResult.length,
                (index) {
              return Container(
                margin: const EdgeInsets.only(left: 10, right: 10),
                height: 30,
                width: width * 0.97,
                decoration: const BoxDecoration(color: AppColors.FirstColor),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    textWidget(
                        text: gameResult[index].gamesno.toString(),
                        color: Colors.white),
                    Row(
                        children: generateNumberWidgets(
                            int.parse(gameResult[index].number.toString()))),
                    Container(
                      height: 20,
                      width: 20,
                      margin: const EdgeInsets.all(2),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        //border: Border.all(width: 1,color: ),
                        shape: BoxShape.circle,
                        gradient: int.parse(gameResult[index].number.toString()) < 5
                            ? AppColors.btnBlueGradient
                            : AppColors.btnYellowGradient,
                      ),
                      child: textWidget(
                        text: int.parse(gameResult[index].number.toString()) < 5
                            ? 'S'
                            : 'B',
                        color: AppColors.primaryTextColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        SizedBox(
          height: height * 0.02,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: limitResult == 0
                  ? () {}
                  : () {
                setState(() {
                  pageNumber--;
                  limitResult = limitResult - 10;
                  offsetResult = offsetResult - 10;
                });
                setState(() {});
                gameHistoryResult();
              },
              child: Container(
                height: height * 0.06,
                width: width * 0.10,
                decoration: BoxDecoration(
                  gradient: AppColors.goldenGradientDir,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.navigate_before,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 16),
            textWidget(
              text: '$pageNumber',
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.secondaryTextColor,
              maxLines: 1,
            ),
            const SizedBox(width: 16),
            GestureDetector(
              onTap: () {
                setState(() {
                  limitResult = limitResult + 10;
                  offsetResult = offsetResult + 10;
                  pageNumber++;
                });
                setState(() {});
                gameHistoryResult();
              },
              child: Container(
                height: height * 0.06,
                width: width * 0.10,
                decoration: BoxDecoration(
                  gradient: AppColors.goldenGradientDir,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.navigate_next, color: Colors.white),
              ),
            ),
          ],
        ),
      ],
    );
  }

  historyDetails(String title, String subtitle, Color subColor) {
    return Column(
      children: [
        const SizedBox(height: 8.0),
        Container(
          height: height * 0.05,
          width: width,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: AppColors.FirstColor),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Colors.white),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: subColor),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  historyWinDetails(String title, String subtitle, String subtitle1,
      String subtitle2, Color subColor, Color subColor1, Color subColor2) {
    return Column(
      children: [
        const SizedBox(height: 8.0),
        Container(
          height: height * 0.05,
          width: width,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: AppColors.FirstColor),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Colors.white),
                ),
                Row(
                  children: [
                    Text(
                      subtitle,
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: subColor),
                    ),
                    Text(
                      subtitle1,
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: subColor1),
                    ),
                    Text(
                      subtitle2,
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: subColor2),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ],
    );
  }


  Widget buildTabContainer(
      String label, int index, double width, Color selectedTextColor) {
    return InkWell(
      onTap: () {
        setState(() {
          selectedTabIndex = index;
        });
        BettingHistory();
      },
      child: Container(
        height: 40,
        width: width / 3.3,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            gradient: selectedTabIndex == index
                ? AppColors.loginSecondryGrad
                : AppColors.primaryUnselectedGradient,
            borderRadius: BorderRadius.circular(8)),
        child: Text(
          label,
          style: TextStyle(
            fontSize: width / 24,
            fontWeight:
                selectedTabIndex == index ? FontWeight.bold : FontWeight.w500,
            color: selectedTabIndex == index
                ? AppColors.primaryTextColor
                : AppColors.primaryTextColor,
          ),
        ),
      ),
    );
  }

  UserViewProvider userProvider = UserViewProvider();



  BaseApiHelper baseApiHelper = BaseApiHelper();




  gameconcept(int countdownSeconds) {
    if (countdownSeconds == 6) {
      setState(() {
        create = true;
      });
      if (kDebugMode) {
        print('5 sec left');
      }
    } else if (countdownSeconds == 0) {
      setState(() {
        create = false;
      });
      if (kDebugMode) {
        print('0 sec left');
      }
    } else {}
  }

}

Widget buildTime1(int time) {
  Duration myDuration = Duration(seconds: time);
  String strDigits(int n) => n.toString().padLeft(2, '0');
  final minutes = strDigits(myDuration.inMinutes.remainder(11));
  final seconds = strDigits(myDuration.inSeconds.remainder(60));
  if (time == 5) {
    Audio.WingoTimerone();
  } else if (time >= 1 && time <= 4) {
    Audio.WingoTimertwo();
  }

  return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
    buildTimeCard2(time: minutes[0].toString(), header: 'MINUTES'),
    const SizedBox(width: 3),
    buildTimeCard1(time: minutes[1].toString(), header: 'MINUTES'),
    const SizedBox(width: 3),
    buildTimeCard1(time: ':', header: 'MINUTES'),
    const SizedBox(width: 3),
    buildTimeCard1(time: seconds[0].toString(), header: 'SECONDS'),
    const SizedBox(width: 3),
    buildTimeCard3(time: seconds[1].toString(), header: 'SECONDS'),
  ]);
}

Widget buildTimeCard3({required String time, required String header}) => Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin:
                  Alignment.bottomRight, // Adjusted to start from bottom right
              end: Alignment.topLeft, // Adjusted to end at top left
              colors: [
                Colors.transparent,
                Color(0xFF759FDE), // Hex color equivalent to #759FDE
              ],
              stops: [
                0.12,
                0.13333
              ], // Adjust these stops according to your design
            ),
          ),
          child: Text(
            time,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontSize: 15,
            ),
          ),
        )
      ],
    );
Widget buildTimeCard2({required String time, required String header}) => Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.containerBgColor,
                Color(0xFF759FDE), // Hex color equivalent to #759FDE
              ],
              stops: [
                0.1333,
                0.12,
              ], // Adjust these stops according to your design
            ),
          ),
          child: Text(
            time,
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.black, fontSize: 15),
          ),
        ),
      ],
    );
Widget buildTimeCard1({required String time, required String header}) => Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF759FDE), Color(0xFF759FDE)],
            ),
          ),
          child: Text(
            time,
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.black, fontSize: 15),
          ),
        ),
      ],
    );

Widget buildTime5sec(int time) {
  Duration myDuration = Duration(seconds: time);
  String strDigits(int n) => n.toString().padLeft(2, '0');
  final seconds = strDigits(myDuration.inSeconds.remainder(60));

  return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
    buildTimeCard5sec(time: seconds[0].toString(), header: 'SECONDS'),
    const SizedBox(width: 15),
    buildTimeCard5sec(time: seconds[1].toString(), header: 'SECONDS'),
  ]);
}

Widget buildTimeCard5sec({required String time, required String header}) =>
    Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
              gradient: AppColors.loginSecondryGrad,
              borderRadius: BorderRadius.circular(10)),
          child: Text(
            time,
            style: const TextStyle(
                fontWeight: FontWeight.w800,
                color: AppColors.primaryTextColor,
                fontSize: 100),
          ),
        )
      ],
    );

class TimeDigit extends StatelessWidget {
  final int value;
  const TimeDigit({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      padding: const EdgeInsets.all(5),
      child: Text(
        value.toString(),
        style: const TextStyle(
          color: Colors.red,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}



class BetNumbers {
  String photo;
  final Color colorone;
  final Color colortwo;
  String number;
  BetNumbers(this.photo, this.colorone, this.colortwo, this.number);
}



class Notfounddata extends StatelessWidget {
  const Notfounddata({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image(
          image: const AssetImage(Assets.imagesNoDataAvailable),
          height: height / 3,
          width: width / 2,
        ),
        SizedBox(height: height * 0.07),
        const Text(
          "Data not found",
        )
      ],
    );
  }
}

List<Widget> generateNumberWidgets(int parse) {
  return List.generate(10, (index) {
    List<Color> colors = [
      AppColors.FirstColor,
      AppColors.FirstColor,
    ];

    if (index == parse && parse == 5) {
      colors = [
        const Color(0xFF40ad72),
        AppColors.primaryTextColor,
      ];
      return Container(
        height: 20,
        width: 20,
        margin: const EdgeInsets.all(2),
        alignment: Alignment.center,
        decoration: const BoxDecoration(
            image: DecorationImage(image: AssetImage(Assets.icons5color))),
      );
    } else if (index == parse && parse == 0) {
      colors = [
        const Color(0xFF40ad72),
        AppColors.primaryTextColor,
      ];
      return Container(
        height: 20,
        width: 20,
        margin: const EdgeInsets.all(2),
        alignment: Alignment.center,
        decoration: const BoxDecoration(
            image: DecorationImage(image: AssetImage(Assets.icons0color))),
      );
    } else {
      if (index == parse) {
        if (parse == 0) {
          colors = [
            AppColors.orangeColor,
            AppColors.primaryTextColor,
          ];
        } else {
          colors = parse % 2 == 0
              ? [
                  AppColors.orangeColor,
                  AppColors.orangeColor,
                ]
              : [
                  const Color(0xFF40ad72),
                  const Color(0xFF40ad72),
                ];
        }
      }

      return Container(
        height: 20,
        width: 20,
        margin: const EdgeInsets.all(2),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
              color: index == parse
                  ? Colors.transparent
                  : AppColors.gradientFirstColor),
          gradient: LinearGradient(
              colors: colors,
              stops: const [0.5, 0.5],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              tileMode: TileMode.mirror),
        ),
        child: textWidget(
          text: '$index',
          fontWeight: FontWeight.w600,
          color: index == parse
              ? AppColors.primaryTextColor
              : AppColors.gradientFirstColor,
        ),
      );
    }
  });
}


class GradientTextview extends StatelessWidget {
  const GradientTextview(
    this.text, {
    super.key,
    required this.gradient,
    this.style,
  });

  final String text;
  final TextStyle? style;
  final Gradient gradient;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => gradient.createShader(
        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
      ),
      child: Text(text, style: style),
    );
  }
}


class Winlist {
  int gameid;
  String title;
  String subtitle;
  int time;

  Winlist(this.gameid,this.title, this.subtitle,this.time);
}