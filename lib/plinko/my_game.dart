// ignore_for_file: must_be_immutable

import 'dart:convert';
import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nera/model/user_model.dart';
import 'package:nera/res/provider/user_view_provider.dart';
import 'package:provider/provider.dart';
import 'package:nera/generated/assets.dart';
import 'package:nera/main.dart';
import 'package:nera/model/plinko_list_model.dart';
import 'package:nera/model/plinko_result.dart';
import 'package:nera/plinko/lesson_02/objects/ball_dynamic.dart';
import 'package:nera/plinko/routes.dart';
import 'package:nera/plinko/utils/Plinko_Pop_up.dart';
import 'package:nera/res/aap_colors.dart';
import 'package:nera/res/api_urls.dart';
import 'package:nera/res/components/app_btn.dart';
import 'package:nera/res/provider/profile_provider.dart';
import 'package:nera/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'lesson_02/objects/balance_hud.dart';
import 'package:http/http.dart' as http;

final screenSize = Vector2(1300, 2000);

final worldSize = Vector2(12.8, 20.0);

class MyGame extends Forge2DGame with KeyboardEvents {
  // Keep track of the number of bodies in the world.
  final totalBodies = TextComponent(position: Vector2(5, 790))
    ..positionType = PositionType.viewport;

  final totalBalance = TextComponent(position: Vector2(5, 690))
    ..positionType = PositionType.viewport;

  // Keep track of the frames per second
  final fps = FpsTextComponent(position: Vector2(5, 765));

  // Scale the screenSize by 100 and set the gravity of 15
  MyGame() : super(zoom: 100, gravity: Vector2(0, 40));

  // late final Hud hud;
  late MyTextBox hud;

  @override
  Future<void> onLoad() async {
    // Set the FixedResolutionViewport
    camera.viewport = FixedResolutionViewport(screenSize);

    // Adds a black background to the viewport
    add(_Background(size: screenSize)..positionType = PositionType.viewport);

    // add(fps);
    // add(totalBodies);
    // add(totalBalance);
  }

  @override
  void update(double dt) {
    super.update(dt);
    totalBodies.text = 'Bodies: ${world.bodies.length}';
    totalBalance.text = 'Balance: ${world.bodies.length}';
  }

  @override
  KeyEventResult onKeyEvent(RawKeyEvent event, Set keysPressed) {
    if (event is RawKeyDownEvent) {
      if (keysPressed.contains(LogicalKeyboardKey.escape)) {
        navigatorKey.currentState
            ?.pushNamedAndRemoveUntil(Routes.menu, (r) => false);
        return KeyEventResult.handled;
      }
    }
    return KeyEventResult.ignored;
  }

  @override
  Color backgroundColor() {
    return const Color(0xFF117ea7);
  }

  void onTapDown() {
    final randomColor = Color((Random().nextDouble() * 0xFFFFFF).toInt() << 0)
        .withOpacity(1.0); // Generate a random color
    add(BallDynamic(randomColor));
    // Provide the random color to BallDynamic constructor
  }
}

// Helper component that paints a black background
class _Background extends PositionComponent {
  _Background({super.size});

  @override
  void render(Canvas canvas) {
    final Rect rect = Rect.fromLTWH(0, 0, size.x, size.y);
    final Paint customPaint = Paint()
      ..shader = const LinearGradient(
        colors: [
          Color(0xFF117ea7),
          Color(0xFF19a99f),
          Color(0xFF117ea7),
        ],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ).createShader(rect);
    canvas.drawRect(rect, customPaint);
  }
}

///

class MyGameWidget extends StatefulWidget {
  final MyGame game;

  const MyGameWidget({super.key, required this.game});

  @override
  State<MyGameWidget> createState() => _MyGameWidgetState();
}

class _MyGameWidgetState extends State<MyGameWidget> {
  int selectedBalls = 1;

  List<String> number = [
    '0.29x',
    '1.39x',
    '2.43x',
    '3.42x',
    '4.39x',
    '5.45x',
    '6.39x',
    '7.52x',
    '8.38x',
    '9.37x',
    '10.39x',
    '11.5x',
    '12.5x',
  ];

  String gameId = "11";

  void decrementCounter() {
    setState(() {
      if (selectedIndex >= initValue) {
        selectedIndex -= initValue;
        amount.text = selectedIndex.toString();
      }
    });
  }

  int selectedIndex = 10;

  TextEditingController amount = TextEditingController();

  @override
  void initState() {
    amount.text = selectedIndex.toString();
    super.initState();
    plinkoRedList();
    plinkoYellowList();
    plinkoGreenList();
    fetchPlinkoBethistory();
    fetchPlinkoBethistoryTwo();
  }

  var initValue = 0;

  void incrementCounter() {
    setState(() {
      selectedIndex += initValue;
      amount.text = selectedIndex.toString();
    });
  }

  List<int> list = [
    10,
    20,
    50,
    100,
    200,
    500,
    1000,
    5000,
  ];

  int _selectedIndexxx = -1;

  @override
  void dispose() {
    amount.dispose();
    super.dispose();
  }

  bool isExpanded = false;
  bool tapValue = false;

  bool loaderOne = false;
  bool loaderTwo = false;
  bool loaderThree = false;

  int? responseStatuscode;

  String exitIndex = "1";

  Future<bool> _onWillPop() async {
    if (exitIndex == "0") {
      return false;
    } else {
      return true;
    }
  }



  @override
  Widget build(BuildContext context) {


    return Consumer<ProfileProvider>(
        builder: (context,profileProvider,child) {
          final userData = profileProvider;
          double walletValue = double.tryParse(userData.totalWallet.toString()) ?? 0.0;
          return WillPopScope(
            onWillPop: _onWillPop,
            child: Scaffold(
              backgroundColor: const Color(0xFF107baa),
              extendBodyBehindAppBar: true,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,

                leading: exitIndex == "0"
                    ? IconButton(
                      onPressed: () {
                        if (walletValue == 0) {
                          Navigator.pop(context);
                          Utils.flushBarSuccessMessage(
                            "Wallet is empty. Exiting!",
                            context,
                            Colors.red,
                          );
                        } else {
                          // If wallet is not 0, show the warning message
                          Utils.flushBarSuccessMessage(
                            "Please complete your bet, otherwise money will be deducted!",
                            context,
                            AppColors.primaryTextColor,
                          );
                        }
                      },
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: AppColors.primaryTextColor,
                        size: 15,
                      ),
                    )
                    : const AppBackBtn(),
                title: const Text(
                  'PLINKO',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                    color: Colors.white,
                  ),
                ),
                centerTitle: true,
                actions: [
                  Row(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Icon(Icons.currency_rupee_outlined, size: 15, color: Colors.white),
                          Text(
                            userData.totalWallet.toString(),
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 10),
                          InkWell(
                            onTap: () {
                              setState(() {
                                Provider.of<ProfileProvider>(context, listen: false).fetchProfileData();
                                Utils.flushBarSuccessMessage('Wallet refreshed ✔', context, Colors.white);
                              });
                            },
                            child: Image.asset(Assets.iconsTotalBal, height: 20),
                          ),
                        ],
                      ),
                      InkWell(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return const PlinkoPopUpPage();
                            },
                          );
                        },
                        child: Container(
                          margin: EdgeInsets.zero,
                          alignment: Alignment.center,
                          height: height * 0.03,
                          width: width * 0.10,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                blurRadius: 5,
                                spreadRadius: 2,
                                offset: const Offset(0, 3),
                              ),
                            ],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Image.asset(Assets.iconsBetHistory),
                        ),
                      ),
                      const SizedBox(width: 10),
                    ],
                  ),
                ],
              ),

              // appBar: GradientAppBar(
              //   gradient: AppColors.appBarGradient,
              //   leading: exitIndex == "0"
              //       ? Row(
              //     children: [
              //       IconButton(
              //         onPressed: () {
              //           Utils.flushBarSuccessMessage(
              //             "Please complete your bet otherwise money will be deducted! ",
              //             context,
              //             AppColors.primaryTextColor,
              //           );
              //         },
              //         icon: const Icon(
              //           Icons.arrow_back_ios,
              //           color: AppColors.primaryTextColor,
              //           size: 15,
              //         ),
              //       ),
              //       Container(
              //         height: height * 0.05,
              //         width: width * 0.14,
              //         decoration: const BoxDecoration(
              //           image: DecorationImage(
              //             image: AssetImage(Assets.assetsApplogo),
              //             fit: BoxFit.fill,
              //           ),
              //         ),
              //       ),
              //     ],
              //   )
              //       : Row(
              //     children: [
              //       const AppBackBtn(),
              //       Container(
              //         height: height * 0.05,
              //         width: width * 0.14,
              //         decoration: const BoxDecoration(
              //           image: DecorationImage(
              //             image: AssetImage(Assets.assetsApplogo),
              //             fit: BoxFit.fill,
              //           ),
              //         ),
              //       ),
              //     ],
              //   ),
              //   leadingWidth: width * 0.27,
              //   title: const Text(
              //     'PLINKO',
              //     style: TextStyle(
              //       fontWeight: FontWeight.bold,
              //       fontSize: 17,
              //       color: Colors.white,
              //     ),
              //   ),
              //   centerTitle: true,
              //   actions: [
              //     Row(
              //       children: [
              //         Row(
              //           mainAxisAlignment: MainAxisAlignment.start,
              //           children: [
              //             const Icon(Icons.currency_rupee_outlined, size: 15, color: Colors.white),
              //             Text(
              //               userData!.wallet.toString(),
              //               style: const TextStyle(
              //                 fontSize: 15,
              //                 color: Colors.white,
              //                 fontWeight: FontWeight.w600,
              //               ),
              //             ),
              //             const SizedBox(width: 10),
              //             InkWell(
              //               onTap: () {
              //                 // Check wallet value before allowing wallet refresh
              //                 if (userData!.wallet > 0) {
              //                   setState(() {
              //                     Provider.of<ProfileProvider>(context, listen: false).fetchProfileData();
              //                     Utils.flushBarSuccessMessage('Wallet refresh ✔', context, Colors.white);
              //                   });
              //                 } else {
              //                   // Show message if wallet is zero
              //                   Utils.flushBarSuccessMessage('Wallet is empty. Please add funds!', context, Colors.red);
              //                 }
              //               },
              //               child: Image.asset(Assets.iconsTotalBal, height: 20),
              //             ),
              //           ],
              //         ),
              //         InkWell(
              //           onTap: () {
              //             if (userData!.wallet > 0) {
              //               showDialog(
              //                 context: context,
              //                 builder: (BuildContext context) {
              //                   return const PlinkoPopUpPage();
              //                 },
              //               );
              //             } else {
              //               // Show message if wallet is zero
              //               Utils.flushBarSuccessMessage(
              //                 'Insufficient wallet balance to place a bet!',
              //                 context,
              //                 Colors.red,
              //               );
              //             }
              //           },
              //           child: Container(
              //             margin: EdgeInsets.zero,
              //             alignment: Alignment.center,
              //             height: height * 0.03,
              //             width: width * 0.10,
              //             decoration: BoxDecoration(
              //               boxShadow: [
              //                 BoxShadow(
              //                   color: Colors.grey.withOpacity(0.3),
              //                   blurRadius: 5,
              //                   spreadRadius: 2,
              //                   offset: const Offset(0, 3),
              //                 ),
              //               ],
              //               borderRadius: BorderRadius.circular(20),
              //             ),
              //             child: Image.asset(Assets.iconsBetHistory),
              //           ),
              //         ),
              //         const SizedBox(width: 10),
              //       ],
              //     ),
              //   ],
              // ),

              bottomNavigationBar: Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 30),
                child: Container(
                  height: height * 0.2,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF095273),
                        Color(0xFF117e67),
                        Color(0xFF095273),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  // Colors.transparent,
                  child: Column(
                    children: [
                      SizedBox(
                        height: height * 0.02,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            width: width * 0.8,
                            height: height * 0.07,
                            decoration: BoxDecoration(
                                color: const Color(0xFF097c7f),
                                // Colors.greenAccent,
                                borderRadius: BorderRadius.circular(35)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    const Text(
                                      '                 Bet',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Container(
                                            height: height * 0.03,
                                            alignment: Alignment.center,
                                            padding: const EdgeInsets.all(4),
                                            width: width * 0.3,
                                            decoration: BoxDecoration(
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey.withOpacity(0.3),
                                                  blurRadius: 5,
                                                  spreadRadius: 2,
                                                  offset: const Offset(0, 3),
                                                ),
                                              ],
                                              color: const Color(0xFF015759),
                                              borderRadius: BorderRadius.circular(20),
                                              border: Border.all(
                                                  width: 1, color: Colors.black),
                                            ),
                                            child: Text(
                                              '$selectedIndex ₹',
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 12),
                                            )),
                                      ],
                                    ),
                                    const SizedBox()
                                  ],
                                ),
                                InkWell(
                                  onTap: decrementCounter,
                                  child: Container(
                                      margin: EdgeInsets.zero,
                                      alignment: Alignment.center,
                                      height: 35,
                                      width: 35,
                                      decoration: BoxDecoration(
                                          color: Colors.teal,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey.withOpacity(0.3),
                                              blurRadius: 5,
                                              spreadRadius: 2,
                                              offset: const Offset(0,
                                                  3), // Adjust the shadow's position here
                                            ),
                                          ],
                                          borderRadius: BorderRadius.circular(20),
                                          border: Border.all(color: Colors.black)),
                                      child: const Icon(
                                        Icons.remove,
                                        size: 20,
                                        color: Colors.white,
                                      )),
                                ),
                                InkWell(
                                  onTap: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) => betPopUp());
                                  },
                                  child: Container(
                                      margin: EdgeInsets.zero,
                                      alignment: Alignment.center,
                                      height: 35,
                                      width: 35,
                                      decoration: BoxDecoration(
                                          color: Colors.teal,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey.withOpacity(0.3),
                                              blurRadius: 5,
                                              spreadRadius: 2,
                                              offset: const Offset(0,
                                                  3), // Adjust the shadow's position here
                                            ),
                                          ],
                                          borderRadius: BorderRadius.circular(20),
                                          border: Border.all(color: Colors.black)),
                                      child: Image.asset(
                                        'assetss/images/coin/stack.png',
                                        height: 20,
                                      )),
                                ),
                                InkWell(
                                  onTap: () {
                                    incrementCounter();
                                  },
                                  child: Container(
                                      margin: EdgeInsets.zero,
                                      alignment: Alignment.center,
                                      height: 35,
                                      width: 35,
                                      decoration: BoxDecoration(
                                          color: Colors.teal,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey.withOpacity(0.3),
                                              blurRadius: 5,
                                              spreadRadius: 2,
                                              offset: const Offset(0,
                                                  3), // Adjust the shadow's position here
                                            ),
                                          ],
                                          borderRadius: BorderRadius.circular(20),
                                          border: Border.all(color: Colors.black)),
                                      child: const Text(
                                        '+',
                                        style: TextStyle(
                                            fontSize: 20, color: Colors.white),
                                      )),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: height * 0.02,
                      ),

                      SizedBox(
                        width: width * 0.9,
                        height: height * 0.07,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            // GREEN Button
                            exitIndex == "1"
                                ? loaderOne == false
                                ? InkWell(
                              onTap: () async {
                                if (walletValue == 0) {
                                  Utils.flushBarSuccessMessage(
                                    'Insufficient wallet balance to place a bet!',
                                    context,
                                    Colors.red,
                                  );
                                } else {
                                  setState(() {
                                    tapValue = !tapValue;
                                    _selectedIndexxx = 1;  // Set selected index for green
                                    plinkoBet(amount.text, _selectedIndexxx.toString());
                                  });
                                }
                              },
                              child: Container(
                                alignment: Alignment.center,
                                height: height * 0.05,
                                width: width * 0.2,
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xff337a04),
                                      Color(0xff52960c),
                                      Color(0xff337a04),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.topRight,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.3),
                                      blurRadius: 5,
                                      spreadRadius: 2,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: _selectedIndexxx == 0 ? Colors.teal : Colors.black,
                                  ),
                                ),
                                child: const Text(
                                  'GREEN',
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            )
                                : const Center(child: CircularProgressIndicator())
                                : const Icon(
                              Icons.lock,
                              color: AppColors.primaryTextColor,
                            ),

                            // YELLOW Button
                            exitIndex == "1"
                                ? loaderTwo == false
                                ? InkWell(
                              onTap: () async {
                                if (walletValue == 0) {
                                  Utils.flushBarSuccessMessage(
                                    'Insufficient wallet balance to place a bet!',
                                    context,
                                    Colors.red,
                                  );
                                } else {
                                  setState(() {
                                    tapValue = !tapValue;
                                    _selectedIndexxx = 2;  // Set selected index for yellow
                                    plinkoBet(amount.text, _selectedIndexxx.toString());
                                  });
                                }
                              },
                              child: Container(
                                alignment: Alignment.center,
                                height: height * 0.05,
                                width: width * 0.2,
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFFc56f00),
                                      Color(0xFFca8605),
                                      Color(0xFFc56f00),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.topRight,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.3),
                                      blurRadius: 5,
                                      spreadRadius: 2,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: _selectedIndexxx == 1 ? Colors.teal : Colors.black,
                                  ),
                                ),
                                child: const Text(
                                  'YELLOW',
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            )
                                : const Center(child: CircularProgressIndicator())
                                : const Icon(Icons.lock, color: AppColors.primaryTextColor),

                            // RED Button
                            exitIndex == "1"
                                ? loaderThree == false
                                ? InkWell(
                              onTap: () async {
                                if (walletValue == 0) {
                                  Utils.flushBarSuccessMessage(
                                    'Insufficient wallet balance to place a bet!',
                                    context,
                                    Colors.red,
                                  );
                                } else {
                                  setState(() {
                                    tapValue = !tapValue;
                                    _selectedIndexxx = 3;  // Set selected index for red
                                    plinkoBet(amount.text, _selectedIndexxx.toString());
                                  });
                                }
                              },
                              child: Container(
                                alignment: Alignment.center,
                                height: height * 0.05,
                                width: width * 0.2,
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFFb80118),
                                      Color(0xFFdd0016),
                                      Color(0xFFb80118),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.topRight,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.3),
                                      blurRadius: 5,
                                      spreadRadius: 2,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: _selectedIndexxx == 2 ? Colors.teal : Colors.black,
                                  ),
                                ),
                                child: const Text(
                                  'RED',
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            )
                                : const Center(child: CircularProgressIndicator())
                                : const Icon(Icons.lock, color: AppColors.primaryTextColor),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              body: Stack(
                children: [
                  GameWidget(
                    // addRepaintBoundary: true,
                    game: widget.game,
                  ),
                  // Text('${contact.bodyB.position}'),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 90, 0, 0),
                    child: expansionWidget(),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: height * 0.7, left: width * 0.02),
                    child: Center(
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemCount: plinkoRedItem.length,
                          itemBuilder: (context, index) {
                            return Center(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 1),
                                child: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xFFb80118),
                                        Color(0xFFdd0016),
                                        Color(0xFFb80118),
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.topRight,
                                    ),
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(
                                      width: 2,
                                      color: _selectedIndexxx == 3
                                          ? const Color(0xffff1f1f)
                                          : Colors.transparent,
                                    ),
                                  ),
                                  margin: const EdgeInsets.all(1),
                                  width: width * 0.11,
                                  height: height * 0.02,
                                  child: Text(
                                    plinkoRedItem[index].multiplier.toString(),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                      fontSize: 7,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: height * 0.65, left: width * 0.02),
                    child: Center(
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemCount: plinkoYellowItem.length,
                          itemBuilder: (context, index) {
                            return Center(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 1),
                                child: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xFFc56f00),
                                        Color(0xFFca8605),
                                        Color(0xFFc56f00),
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.topRight,
                                    ),
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(
                                      width: 2,
                                      color: _selectedIndexxx == 2
                                          ? const Color(0xfffff026)
                                          : Colors.transparent,
                                    ),
                                  ),
                                  // color:const Color(0xFFc56f00),
                                  margin: const EdgeInsets.all(1),
                                  width: width * 0.11,
                                  height: height * 0.02,
                                  child: Text(
                                    plinkoYellowItem[index].multiplier.toString(),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                      fontSize: 7,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: height * 0.6, left: width * 0.02),
                    child: Center(
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemCount: plinkoGreenItem.length,
                          itemBuilder: (context, index) {
                            return Center(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 1),
                                child: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xff337a04),
                                        Color(0xff52960c),
                                        Color(0xff337a04),
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.topRight,
                                    ),
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(
                                      width: 2,
                                      color: _selectedIndexxx == 1
                                          ? const Color(0xff80ff00)
                                          : Colors.transparent,
                                    ),
                                  ),
                                  // color:const Color(0xFFc56f00),
                                  margin: const EdgeInsets.all(1),
                                  width: width * 0.11,
                                  height: height * 0.02,
                                  child: Text(
                                    plinkoGreenItem[index].multiplier.toString(),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                      fontSize: 7,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
    );
  }

  Widget betPopUp() {
    return Dialog(
      child: Container(
        height: 270,
        width: 300,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF117ea7),
              Color(0xFF19a99f),
              Color(0xFF117ea7),
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Text(
              'Bet',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 15),
            ),
            Container(
                height: 240,
                width: 300,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF117ea7),
                      Color(0xFF19a99f),
                      Color(0xFF117ea7),
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
                child: GridView.builder(
                    padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
                    gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, // Number of columns
                        crossAxisSpacing: 10, // Spacing between columns
                        mainAxisSpacing: 15, // Spacing between rows
                        childAspectRatio: 3.5),
                    itemCount: list.length,
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        onTap: () {
                          setState(() {
                            initValue = list[index];
                            selectedIndex = initValue;
                            amount.text = initValue.toString();
                          });
                          Navigator.pop(context);
                        },
                        child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: selectedIndex == list[index]
                                    ? const Color(0xFF017c80)
                                    : const Color(0xFF006366),
                                border: Border.all(color: Colors.black),
                                borderRadius: BorderRadius.circular(50)),
                            child: Text(list[index].toString(),
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Colors.white,
                                ))),
                      );
                    })),
          ],
        ),
      ),
    );
  }

  Widget expansionWidget() {
    return Container(
      height: isExpanded ? height * 0.2 : height * 0.09,
      width: width,
      decoration: BoxDecoration(
          color: const Color(0xFF0d6e70),
          borderRadius: BorderRadius.circular(25)),
      child: ExpansionTile(
        title: isExpanded
            ? Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Last Results:",
                style: TextStyle(
                    fontSize: 13,
                    color: Colors.white,
                    fontWeight: FontWeight.w500)),
            GridView.builder(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
              shrinkWrap: true,
              itemCount: fetchPlinkoBetTwo.length,
              gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                crossAxisSpacing: 2,
                childAspectRatio: 2,
                mainAxisSpacing: 2,
              ),
              itemBuilder: (BuildContext context, int index) {
                const double price = 2; //number[index].price
                Color textColor;
                if (price > 1 && price < 2) {
                  textColor = Colors.blue;
                } else if (price >= 2 && price < 10) {
                  textColor = Colors.purple;
                } else {
                  textColor = Colors.pink;
                }
                return Container(
                  height: height * 0.02,
                  padding: const EdgeInsets.only(left: 8, right: 8),
                  decoration: BoxDecoration(
                    gradient: fetchPlinkoBetTwo[index].type == 1
                        ? const LinearGradient(
                      colors: [
                        Colors.green,
                        Colors.green,
                        Colors.green,
                      ],
                    )
                        : fetchPlinkoBetTwo[index].type == 2
                        ? const LinearGradient(
                      colors: [
                        Color(0xFFc56f00),
                        Color(0xFFca8605),
                        Color(0xFFc56f00),
                      ],
                    )
                        : const LinearGradient(
                      colors: [
                        Color(0xFFb80118),
                        Color(0xFFdd0016),
                        Color(0xFFb80118),
                      ],
                    ),
                    borderRadius:
                    const BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Center(
                    child: Text(
                      fetchPlinkoBetTwo[index]
                          .multipler
                          .toString(), //${number[index].price.toStringAsFixed(2)}
                      style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                );
              },
            ),
          ],
        )
            : SizedBox(
          height: height * 0.038,
          width: width,
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: fetchPlinkoBet.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int index) {
                const double price = 1; //number[index].price
                Color textColor;
                if (price > 1 && price < 2) {
                  textColor = Colors.blue;
                } else if (price >= 2 && price < 10) {
                  textColor = Colors.purple;
                } else {
                  textColor = Colors.pink;
                }
                return Padding(
                  padding: const EdgeInsets.fromLTRB(3, 5, 3, 5),
                  child: Container(
                    width: width * 0.08, //529f05 //479103
                    decoration: BoxDecoration(
                      gradient: fetchPlinkoBet[index].type == 1
                          ? const LinearGradient(
                        colors: [
                          Colors.green,
                          Colors.green,
                          Colors.green,
                        ],
                      )
                          : fetchPlinkoBet[index].type == 2
                          ? const LinearGradient(
                        colors: [
                          Color(0xFFc56f00),
                          Color(0xFFca8605),
                          Color(0xFFc56f00),
                        ],
                      )
                          : const LinearGradient(
                        colors: [
                          Color(0xFFb80118),
                          Color(0xFFdd0016),
                          Color(0xFFb80118),
                        ],
                      ),
                      borderRadius:
                      const BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Center(
                      child: Text(
                        fetchPlinkoBet[index]
                            .multipler
                            .toString(), //${number[index].price.toStringAsFixed(2)}
                        style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                );
              }),
        ),
        onExpansionChanged: (value) {
          setState(() {
            fetchPlinkoBethistoryTwo();

            isExpanded = value;
          });
        },
        trailing: Container(
          alignment: Alignment.center,
          height: height * 0.04,
          width: width * 0.15,
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.1),
            border: Border.all(color: Colors.black.withOpacity(0.5)),
            borderRadius: const BorderRadius.all(Radius.circular(25)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.history,
                size: 18,
                color: Colors.white,
              ),
              Icon(
                isExpanded
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down,
                size: 30,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }

  plinkoBet(String amount, String type) async {
    setState(() {
      if (type == '1') {
        loaderOne = true;
        exitIndex = "1";
      } else if (type == '2') {
        loaderTwo = true;
        exitIndex = "1";
      } else {
        loaderThree = true;
        exitIndex = "1";
      }
    });
    UserViewProvider userProvider = UserViewProvider();

    UserModel user = await userProvider.getUser();
    String userId = user.id.toString();

    final response = await http.post(
      Uri.parse(ApiUrl.plinkoBet),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "userid": userId.toString(),
        "game_id": gameId,
        "amount": amount,
        "type": type
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      for (int i = 0; i < selectedBalls; i++) {
        await Future.delayed(const Duration(seconds: 1));
        widget.game.onTapDown();
      }
      setState(() {
        exitIndex = responseData['data']['status'];
        print("exitIndex:$exitIndex");
        //  context.read<ProfileProvider>().fetchProfileData();

        if (type == '1') {
          loaderOne = false;
          exitIndex = "0";
        } else if (type == '2') {
          loaderTwo = false;
          exitIndex = "0";
        } else {
          loaderThree = false;
          exitIndex = "0";
        }
      });

      Fluttertoast.showToast(msg: responseData['message']);
      await Future.delayed(const Duration(seconds: 15), () {
        fetchPlinkoBethistory();
        setState(() {
          exitIndex = "1";
          Provider.of<ProfileProvider>(context, listen: false).fetchProfileData();
        });
      });
    } else {
      //setRegLoading(false);
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      setState(() {
        if (type == '1') {
          loaderOne = false;
          exitIndex = "0";
        } else if (type == '2') {
          loaderTwo = false;
          exitIndex = "0";
        } else {
          loaderThree = false;
          exitIndex = "0";
        }
      });
      return Fluttertoast.showToast(msg: responseData['message']);
    }
  }

  List<PlinkoIndexModal> plinkoRedItem = [];
  Future<void> plinkoRedList() async {
    final response = await http.get(
      Uri.parse("${ApiUrl.plinkoList}3"),
    );
    if (kDebugMode) {
      print("${ApiUrl.plinkoList}3");
      print('CCyou');
    }

    setState(() {
      responseStatuscode = response.statusCode;
    });

    if (response.statusCode == 200) {
      Provider.of<ProfileProvider>(context, listen: false).fetchProfileData();
      final List<dynamic> responseData = json.decode(response.body)['data'];
      setState(() {
        plinkoRedItem = responseData
            .map((item) => PlinkoIndexModal.fromJson(item))
            .toList();
      });
    } else if (response.statusCode == 400) {
      if (kDebugMode) {
        print('Data not found');
      }
    } else {
      setState(() {
        plinkoRedItem = [];
      });
      throw Exception('Failed to load data');
    }
  }

  List<PlinkoIndexModal> plinkoYellowItem = [];
  Future<void> plinkoYellowList() async {
    final response = await http.get(
      Uri.parse("${ApiUrl.plinkoList}2"),
    );
    if (kDebugMode) {
      print("${ApiUrl.plinkoList}2");
      print('plinkoList');
    }

    setState(() {
      responseStatuscode = response.statusCode;
    });

    if (response.statusCode == 200) {
      Provider.of<ProfileProvider>(context, listen: false).fetchProfileData();
      final List<dynamic> responseData = json.decode(response.body)['data'];
      setState(() {
        plinkoYellowItem = responseData
            .map((item) => PlinkoIndexModal.fromJson(item))
            .toList();
      });
    } else if (response.statusCode == 400) {
      if (kDebugMode) {
        print('Data not found');
      }
    } else {
      setState(() {
        plinkoYellowItem = [];
      });
      throw Exception('Failed to load data');
    }
  }

  List<PlinkoIndexModal> plinkoGreenItem = [];
  Future<void> plinkoGreenList() async {
    final response = await http.get(
      Uri.parse("${ApiUrl.plinkoList}1"),
    );
    if (kDebugMode) {
      print("${ApiUrl.plinkoList}1");
      print('plinkoList');
    }

    setState(() {
      responseStatuscode = response.statusCode;
    });

    if (response.statusCode == 200) {
      Provider.of<ProfileProvider>(context, listen: false).fetchProfileData();
      final List<dynamic> responseData = json.decode(response.body)['data'];
      setState(() {
        plinkoGreenItem = responseData
            .map((item) => PlinkoIndexModal.fromJson(item))
            .toList();
      });
    } else if (response.statusCode == 400) {
      if (kDebugMode) {
        print('Data not found');
      }
    } else {
      setState(() {
        plinkoGreenItem = [];
      });
      throw Exception('Failed to load data');
    }
  }

  List<PlinkoBetHistory> fetchPlinkoBet = [];
  Future<void> fetchPlinkoBethistory() async {
    UserViewProvider userProvider = UserViewProvider();

    UserModel user = await userProvider.getUser();
    String userId = user.id.toString();

    final response = await http.get(
      Uri.parse("${ApiUrl.plinkoBetHistory}userid=$userId&limit=7"),
    );

    setState(() {
      responseStatuscode = response.statusCode;
    });

    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body)['data'];
      setState(() {
        Provider.of<ProfileProvider>(context, listen: false).fetchProfileData();
        fetchPlinkoBet = responseData
            .map((item) => PlinkoBetHistory.fromJson(item))
            .toList();
      });
    } else if (response.statusCode == 400) {
      if (kDebugMode) {
        print('Data not found');
      }
    } else {
      setState(() {
        fetchPlinkoBet = [];
      });
      throw Exception('Failed to load data');
    }
  }

  List<PlinkoBetHistory> fetchPlinkoBetTwo = [];
  Future<void> fetchPlinkoBethistoryTwo() async {
    UserViewProvider userProvider = UserViewProvider();

    UserModel user = await userProvider.getUser();
    String userId = user.id.toString();
    final response = await http.get(
      Uri.parse("${ApiUrl.plinkoBetHistory}userid=$userId&limit=15"),
    );

    setState(() {
      responseStatuscode = response.statusCode;
    });

    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body)['data'];
      setState(() {
        fetchPlinkoBetTwo = responseData
            .map((item) => PlinkoBetHistory.fromJson(item))
            .toList();
      });
    } else if (response.statusCode == 400) {
      if (kDebugMode) {
        print('Data not found');
      }
    } else {
      setState(() {
        fetchPlinkoBetTwo = [];
      });
      throw Exception('Failed to load data');
    }
  }
}
