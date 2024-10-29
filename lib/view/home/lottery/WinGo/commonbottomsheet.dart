import 'dart:convert';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:nera/main.dart';
import 'package:nera/model/user_model.dart';
import 'package:nera/res/aap_colors.dart';
import 'package:nera/res/api_urls.dart';
import 'package:nera/res/helper/api_helper.dart';
import 'package:nera/res/provider/profile_provider.dart';
import 'package:nera/res/provider/user_view_provider.dart';
import 'package:nera/utils/utils.dart';
import 'package:nera/view/home/lottery/WinGo/win_go_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;


class CommonBottomSheet extends StatefulWidget {
  final List<Color>? colors;
  final String colorName;
  final String predictionType;
  final int gameid;
  const CommonBottomSheet({
    super.key,
    this.colors,
    required this.colorName,
    required this.predictionType,
    required this.gameid,
  });

  @override
  State<CommonBottomSheet> createState() => _CommonBottomSheetState();
}

class _CommonBottomSheetState extends State<CommonBottomSheet> {
  @override
  void initState() {

    amount.text = selectedIndex.toString();
    // TODO: implement initState
    super.initState();
  }
  int value = 1;
  int selectedAmount = 1;
  bool rememberPass = true;
  void increment() {
    setState(() {
      selectedMultiplier = selectedMultiplier + 1;
      deductAmount();
    });
  }

  void decrement() {
    setState(() {
      if (selectedMultiplier > 0) {
        selectedMultiplier = selectedMultiplier - 1;
        deductAmount();
      }
    });
  }

  void selectam(int amount) {
    setState(() {
      selectedAmount = amount;
      value = 1;
    });
    deductAmount();
  }

  List<int> multipliers = [1, 5, 10, 20, 50, 100];
  int selectedMultiplier = 1; // Default multipli

  void updateMultiplier(int multiplier) {
    setState(() {
      selectedMultiplier = multiplier;
      deductAmount();
    });
  }

  void deductAmount() {
    if (wallbal! >= selectedAmount * selectedMultiplier) {
      walletApi = wallbal;
    }
    int amountToDeduct = selectedAmount * selectedMultiplier;
    if (walletApi! >= amountToDeduct) {
      setState(() {
        amount.text = amountToDeduct.toString();
        walletApi = (walletApi! - amountToDeduct).toInt();
      });
    } else {
      Utils.flushBarErrorMessage('Insufficient funds', context, Colors.white);
    }
  }

  List<int> list = [
    1,
    10,
    100,
    1000,
  ];

  int? walletApi;
  int? wallbal;

  int selectedIndex = 1;

  TextEditingController amount = TextEditingController();

  List<Winlist> listwe = [
    Winlist(1, "Win Go", "1 Min", 60),
    Winlist(2, "Win Go", "3 Min", 180),
    Winlist(3, "Win Go", "5 Min", 300),
    Winlist(4, "Win Go", "10 Min", 600),
    Winlist(6, "Trx Win Go", "1 Min", 60),
    Winlist(7, "Trx Win Go", "3 Min", 180),
    Winlist(8, "Trx Win Go", "5 Min", 300),
    Winlist(9, "Trx Win Go", "10 Min", 600),
  ];
  String gametitle = 'Wingo';
  String subtitle = '1 Min';
  @override
  Widget build(BuildContext context) {
    final userData = context.read<ProfileProvider>();

    walletApi = (userData.totalWallet == null
            ? 0
            : double.parse(userData.totalWallet.toString()))
        .toInt();
    wallbal = (userData.totalWallet == null
            ? 0
            : double.parse(userData.totalWallet.toString()))
        .toInt();


    LinearGradient gradient = LinearGradient(
        colors: widget.colors ?? [Colors.white, Colors.black],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        tileMode: TileMode.mirror);
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          decoration: const BoxDecoration(
            color: AppColors.scaffolddark,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),
          ),
          height: height * 0.59,
          width: width,
          child: Column(
            children: [
              Container(
                height: height * 0.05,
                width: width,
                decoration: const BoxDecoration(
                  color: AppColors.filledColor,
                  // widget.colors == null ? Colors.white : widget.colors!.first,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  widget.gameid == 1
                      ? 'Win Go 1 Min'
                      : widget.gameid == 2
                          ? 'Win Go 3 Min'
                          : widget.gameid == 3
                              ? 'Win Go 5 Min'
                              :widget.gameid == 4?
                                "Win Go 10 Min"
                      :widget.gameid == 6?
                  " Trx Win Go 1 Min"
                      :widget.gameid == 7?
                  " Trx Win Go 3 Min"
                      :widget.gameid == 8?
                  "Trx Win Go 5 Min":
                  "Trx Win Go 10 Min",
                  style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: Colors.white),
                ),
              ),
              Stack(
                alignment: Alignment.topCenter,
                children: [
                  SizedBox(
                      width: width,
                      child: SizedBox(
                        width: 200,
                        height: 200,
                        child: widget.predictionType == "1"
                            ? ShaderMask(
                                shaderCallback: (Rect bounds) {
                                  return gradient.createShader(bounds);
                                },
                                blendMode: BlendMode.srcATop,
                                child: CustomPaint(
                                  painter: _InvertedTrianglePainterSingle(),
                                ),
                              )
                            : Stack(
                                alignment: Alignment.center,
                                children: [
                                  SizedBox(
                                    height: 200,
                                    width: width,
                                    child: ShaderMask(
                                      shaderCallback: (Rect bounds) {
                                        return gradient.createShader(bounds);
                                      },
                                      blendMode: BlendMode.srcATop,
                                      child: CustomPaint(
                                        painter:
                                            _InvertedTrianglePainterSingle(),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    left: 0,
                                    top: 35,
                                    bottom: 65,
                                    child: Transform.rotate(
                                      angle: -0.18,
                                      child: SizedBox(
                                        height: 200,
                                        width: width,
                                        child: CustomPaint(
                                          painter:
                                              _InvertedTrianglePainterDouble(
                                                  widget.colors),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                      )),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Select :  ${widget.colorName}",
                        style:
                            const TextStyle(color: Colors.white,fontWeight: FontWeight.w800, fontSize: 20),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      Container(
                        padding: const EdgeInsets.fromLTRB(25, 10, 0, 5),
                        width: width,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Balance",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: AppColors.iconsColor,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                              width: width,
                              height: 30,
                              child: Center(
                                child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    shrinkWrap: true,
                                    itemCount: list.length,
                                    itemBuilder: (BuildContext, int index) {
                                      return InkWell(
                                          onTap: () {
                                            setState(() {
                                              selectedIndex = list[index];
                                            });
                                            selectam(selectedIndex);
                                          },
                                          child: Container(
                                              width: width*0.2,
                                              decoration: BoxDecoration(
                                                  color:
                                                      selectedIndex == list[index]
                                                          ? AppColors
                                                              .gradientFirstColor
                                                          : AppColors.filledColor,
                                                  borderRadius:
                                                      BorderRadius.circular(5)),
                                              margin:
                                                  const EdgeInsets.only(right: 5),
                                              padding: const EdgeInsets.all(5),
                                              child: Center(
                                                child: Text(
                                                  list[index].toString(),
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight: FontWeight.w900,
                                                      color: selectedIndex ==
                                                              list[index]
                                                          ? Colors.white
                                                          : AppColors
                                                              .gradientFirstColor),
                                                ),
                                              )));
                                    }),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.fromLTRB(25, 15, 18, 5),
                        width: width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Quantity",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: AppColors.iconsColor,
                              ),
                            ),
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  InkWell(
                                    onTap: decrement,
                                    child: Container(
                                      width: 35,
                                      alignment: Alignment.center,
                                      margin: const EdgeInsets.only(right: 5),
                                      padding: const EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                          color: AppColors.gradientFirstColor,
                                          borderRadius:
                                              BorderRadius.circular(26)),
                                      child: const Text("—",
                                          style: TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.w900,
                                              color: Colors.white)),
                                    ),
                                  ),
                                  Container(
                                      height: 35,
                                      alignment: Alignment.center,
                                      padding: const EdgeInsets.all(4),
                                      width: 75,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: AppColors.filledColor,
                                      ),
                                      child: TextField(
                                        controller: amount,
                                        // readOnly: true,
                                        keyboardType: TextInputType.number,
                                        textAlign: TextAlign.center,
                                        decoration: const InputDecoration(
                                            border: InputBorder.none),
                                        style: const TextStyle(
                                            fontSize: 18,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w900),
                                      )),
                                  InkWell(
                                    onTap: increment,
                                    child: Container(
                                      width: 35,
                                      alignment: Alignment.center,
                                      margin: const EdgeInsets.only(left: 5),
                                      padding: const EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                          color: AppColors.gradientFirstColor,
                                          borderRadius:
                                              BorderRadius.circular(26)),
                                      child: const Text("+",
                                          style: TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.w900,
                                              color: Colors.white)),
                                    ),
                                  ),
                                ]),
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 35,
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: multipliers.length,
                  itemBuilder: (context, index) {
                    return Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              selectedMultiplier = multipliers[index];
                            });
                            updateMultiplier(selectedMultiplier);
                          },
                          child: Container(
                            width: 50,
                            decoration: BoxDecoration(
                              color:  selectedMultiplier == multipliers[index]
                                        ? AppColors
                                        .gradientFirstColor
                                        : AppColors.filledColor,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Center(
                              child: Text(
                        'X${multipliers[index]}',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w900,
                                      color: selectedMultiplier == multipliers[index]
                                          ? Colors.white
                                          : AppColors
                                          .gradientFirstColor)
                      ),
                            ),

                          ),
                        )

                        );
                  },
                ),
              ),
              const SizedBox(
                height: 15,
              ),
               Row(
                children: [
                  const SizedBox(
                    width: 10,
                  ),
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
                  const Text(" I agree", style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w300,
                      color:  Colors.white
                      ) ),
                  const SizedBox(
                    width: 15,
                  ),
                  const Text(
                    "《Pre-sale rules》",
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.gradientFirstColor
                      )
                  )
                ],
              ),
              const Spacer(),
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        print('yyyybbbbbbbbbbb');
                      });
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      alignment: Alignment.center,
                      color: AppColors.filledColor,
                      width: width / 3,
                      height: 45,
                      child: const Text(
                        "Cancel",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                     Colorbet( amount.text,
                          widget.predictionType, widget.gameid.toString());

                    },
                    child: Center(
                      child: Container(
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          gradient: AppColors.loginSecondryGrad
                        ),
                        width: width / 1.5,
                        height: 45,
                        child: Text(
                          "Total amount ${amount.text}",
                          style: const TextStyle(
                              color: Colors.white, fontSize: 20),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  BaseApiHelper baseApiHelper = BaseApiHelper();
  UserViewProvider userProvider = UserViewProvider();
   Colorbet( String amount, String number,String gameid) async {
    UserModel user = await userProvider.getUser();
    String token = user.id.toString();

    final response = await http.post(
      Uri.parse(ApiUrl.bettingApi),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body:jsonEncode(<String, String>{
        "userid":token,
        "game_id":gameid,
        "number":number,
        "amount":amount
      }),
    );
    print(gameid);
    print(number);
    print(amount);
    print("fghjbnghbnjm");
    print("numberrrrrrrrrrr");
    print("amounttgbdfgvb");

    if (response.statusCode == 200) {

      final Map<String, dynamic> responseData = jsonDecode(response.body);

      context.read<ProfileProvider>().fetchProfileData();
      Navigator.pop(context);

      return Fluttertoast.showToast(msg: responseData['message']);
    } else {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      return Fluttertoast.showToast(msg: responseData['message']);
    }
  }

}
class _InvertedTrianglePainterSingle extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.fill;

    final Path path = Path();
    path.moveTo(size.width / -1.8, 0);
    path.lineTo(size.width * 1.5, 0);
    path.lineTo(size.width / 2, size.height / 2.8);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class _InvertedTrianglePainterDouble extends CustomPainter {
  final List<Color>? color;

  _InvertedTrianglePainterDouble(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint1 = Paint()
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round
      ..color = color!.last
      ..style = PaintingStyle.fill;

    final Path path1 = Path();
    path1.moveTo(size.width / 5, -5);
    path1.lineTo(size.width * 15, 0);
    path1.lineTo(size.width / 2, size.height / 2.8);

    canvas.drawPath(path1, paint1);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
