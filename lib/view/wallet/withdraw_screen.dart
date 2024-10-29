import 'dart:convert';
import 'package:nera/generated/assets.dart';
import 'package:nera/main.dart';
import 'package:nera/model/addaccount_view_model.dart';
import 'package:nera/model/deposit_model_new.dart';
import 'package:nera/model/user_model.dart';
import 'package:nera/res/aap_colors.dart';
import 'package:nera/res/api_urls.dart';
import 'package:nera/res/components/app_bar.dart';
import 'package:nera/res/components/app_btn.dart';
import 'package:nera/res/components/rich_text.dart';
import 'package:nera/res/components/text_field.dart';
import 'package:nera/res/components/text_widget.dart';
import 'package:nera/res/helper/api_helper.dart';
import 'package:nera/res/provider/profile_provider.dart';
import 'package:nera/res/provider/user_view_provider.dart';
import 'package:nera/utils/routes/routes_name.dart';
import 'package:nera/utils/utils.dart';
import 'package:nera/view/wallet/account_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:nera/view/wallet/withdrawal_history.dart';

class WithdrawScreen extends StatefulWidget {
  const WithdrawScreen({super.key});

  @override
  State<WithdrawScreen> createState() => _WithdrawScreenState();
}

class _WithdrawScreenState extends State<WithdrawScreen> {
  bool isExpanded = false;
  bool rememberPass = false;

  @override
  void initState() {
    addAccountView();
    invitationRuleApi();

    depositTypeSelect();
    super.initState();
  }

  TextEditingController withdrawCon = TextEditingController();

  BaseApiHelper baseApiHelper = BaseApiHelper();

  int? responseStatuscode;
  int selectedIndex = 0;
  int payUsing = 1;

  TextEditingController usdtCon = TextEditingController();
  TextEditingController walletaddress = TextEditingController();
  String selectedusdt = '';
  String selectedwalletadd = '';
  int result = 0;
  String resultt = "";
  String selectedOptionTwo = "";
  Color buttonColor = Colors.grey;


  @override
  Widget build(BuildContext context) {
    final userData = context.watch<ProfileProvider>();
    double withdrawAmount = double.tryParse(withdrawCon.text) ?? 0;

    return Scaffold(
        backgroundColor: AppColors.scaffolddark,
        appBar: GradientAppBar(
            leading: Padding(
              padding: const EdgeInsets.fromLTRB(15, 5, 5, 5),
              child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(
                    Icons.arrow_back_ios_new_sharp,
                    color: Colors.white,
                  )),
            ),
            centerTitle: true,
            title: textWidget(
              text: 'Withdraw',
              fontWeight: FontWeight.w900,
              fontSize: 20,
              color: AppColors.primaryTextColor,
            ),
            actions: [
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const WithdrawHistory()));
                },
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: textWidget(
                      text: 'Withdraw history',
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: AppColors.primaryTextColor,
                    ),
                  ),
                ),
              ),
            ],
            gradient: AppColors.primaryUnselectedGradient),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                              const Icon(Icons.currency_rupee,
                                  color: AppColors.primaryTextColor),
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
                const SizedBox(height: 20),
                const Text(
                  "Pay using:",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 5,
                    crossAxisSpacing: 8,
                    childAspectRatio: 1,
                  ),
                  itemCount: depositType.length,
                  itemBuilder: (BuildContext context, int index) {
                    final currentId = int.parse(depositType[index].id.toString());

                    return InkWell(
                      onTap: () {
                        setState(() {
                          payUsing = currentId;
                          if (kDebugMode) {
                            print(payUsing);
                            print('rrrrrrrrrrrrrrrrr');
                          }
                        });
                      },
                      child: Card(
                        elevation: payUsing == currentId ? 2 : 5,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: payUsing == currentId
                                ? AppColors.loginSecondryGrad
                                : AppColors.primaryUnselectedGradient,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              depositType[index].image != null
                                  ? Image.network(
                                      depositType[index].image.toString(),
                                      height: 45,
                                    )
                                  : const Placeholder(
                                      fallbackHeight: 45,
                                    ),
                              textWidget(
                                  text: depositType[index].name.toString(),
                                  fontSize: 13,
                                  color: payUsing == currentId
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
                const SizedBox(height: 10),
                 payUsing == 1||payUsing == 2
                        ? Column(
                            children: [
                              responseStatuscode == 400
                                  ?  Container()
                                  : items.isEmpty
                                      ? Container()
                                      : ListView.builder(
                                          itemCount: items.length,
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            final currentId = int.parse(
                                                items[index].id.toString());
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      2, 2, 2, 5),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    image: const DecorationImage(
                                                        image: AssetImage(
                                                          Assets.imagesBankcard,
                                                        ),
                                                        fit: BoxFit.fill),
                                                    color: AppColors
                                                        .percentageColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                child: ListTile(
                                                    leading: GestureDetector(
                                                      onTap: () {
                                                        setState(() {
                                                          selectedIndex =
                                                              currentId;
                                                          withdrawacid =
                                                              items[index]
                                                                  .id
                                                                  .toString();
                                                        });
                                                      },
                                                      child: Container(
                                                        height: 30,
                                                        width: 30,
                                                        alignment:
                                                            Alignment.center,
                                                        decoration:
                                                            selectedIndex ==
                                                                    currentId
                                                                ? BoxDecoration(
                                                                    image: const DecorationImage(
                                                                        image: AssetImage(
                                                                            Assets.iconsCorrect)),
                                                                    border: Border.all(
                                                                        color: Colors
                                                                            .transparent),
                                                                    borderRadius:
                                                                        BorderRadiusDirectional.circular(
                                                                            50),
                                                                  )
                                                                : BoxDecoration(
                                                                    border: Border.all(
                                                                        color: AppColors
                                                                            .gradientFirstColor),
                                                                    borderRadius:
                                                                        BorderRadiusDirectional.circular(
                                                                            50),
                                                                  ),
                                                      ),
                                                    ),
                                                    title: textWidget(
                                                        text: items[index]
                                                            .name
                                                            .toString(),
                                                        fontSize: width * 0.04,
                                                        color: Colors.white),
                                                    subtitle: textWidget(
                                                        text: items[index]
                                                            .accountNumber
                                                            .toString(),
                                                        fontSize: width * 0.034,
                                                        color: Colors.white),
                                                    trailing: IconButton(
                                                      icon: const Icon(
                                                        Icons
                                                            .arrow_forward_ios_outlined,
                                                        color: Colors.white,
                                                      ),
                                                      onPressed: () {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (context) =>
                                                                    AccountView(
                                                                        data: items[
                                                                            index])));
                                                      },
                                                    )),
                                              ),
                                            );
                                          }),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, RoutesName.addBankAccount);
                                },
                                child: Card(
                                  elevation: 4,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Container(
                                    width: width,
                                    padding: const EdgeInsets.fromLTRB(
                                        15, 15, 15, 15),
                                    decoration: BoxDecoration(
                                        gradient:
                                            AppColors.primaryUnselectedGradient,
                                        borderRadius:
                                            BorderRadiusDirectional.circular(
                                                10)),
                                    child: Column(
                                      children: [
                                        const SizedBox(width: 15),
                                        Image.asset(
                                          Assets.iconsAddBank,
                                          height: 60,
                                        ),
                                        const SizedBox(width: 15),
                                        textWidget(
                                            text: 'Add a bank account number',
                                            color: AppColors.primaryTextColor,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w900),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              Container(
                                width: width,
                                padding: const EdgeInsets.only(
                                    top: 15, left: 15, right: 15),
                                decoration: BoxDecoration(
                                    gradient:
                                        AppColors.primaryUnselectedGradient,
                                    borderRadius:
                                        BorderRadiusDirectional.circular(15)),
                                child: Column(
                                  children: [
                                    const SizedBox(width: 15),
                                    textWidget(
                                        text:
                                            'Need to add beneficiary information to be able to withdraw money',
                                        color: AppColors.primaryTextColor,
                                        fontWeight: FontWeight.w900),
                                    const SizedBox(height: 10),
                                    CustomTextField(
                                      hintText: 'Please enter the amount',
                                      fieldRadius: BorderRadius.circular(30),
                                      textColor: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      controller: withdrawCon,
                                      keyboardType: TextInputType.number,
                                      prefixIcon: SizedBox(
                                        width: 70,
                                        child: Row(
                                          children: [
                                            const SizedBox(width: 10),
                                            const Icon(
                                              Icons.currency_rupee,
                                              color:
                                                  AppColors.gradientFirstColor,
                                              size: 25,
                                            ),
                                            const SizedBox(width: 10),
                                            Container(
                                                height: 30,
                                                color: Colors.white,
                                                width: 2)
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      children: [
                                        textWidget(
                                            text: 'Withdrawal balance    ',
                                            fontSize: 14,
                                            fontWeight: FontWeight.w900,
                                            color: AppColors.dividerColor),
                                        Row(
                                          children: [
                                            const Icon(Icons.currency_rupee,
                                                size: 16,
                                                color: AppColors
                                                    .gradientFirstColor),
                                            textWidget(
                                                text: userData.mainWallet
                                                    .toStringAsFixed(2),
                                                //==''?'0.0':(int.parse(withdrawCon.text)*0.96).toStringAsFixed(2),
                                                fontSize: 16,
                                                color: AppColors
                                                    .gradientFirstColor),
                                          ],
                                        )
                                      ],
                                    ),
                                    const SizedBox(height: 5),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        textWidget(
                                            text: 'Withdrawal amount received',
                                            fontSize: 14,
                                            fontWeight: FontWeight.w900,
                                            color: AppColors.dividerColor),
                                        Row(
                                          children: [
                                            const Icon(Icons.currency_rupee,
                                                size: 20,
                                                color: AppColors
                                                    .gradientFirstColor),
                                            textWidget(
                                                text: withdrawCon.text == ''
                                                    ? '0.0'
                                                    : withdrawCon.text
                                                        .toString(),
                                                // (int.parse(withdrawCon.text)*0.96).toStringAsFixed(2),
                                                fontSize: 18,
                                                color: AppColors
                                                    .gradientFirstColor),
                                          ],
                                        )
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    withdrawAmount >= double.parse(userData.minimumWithdraw.toString()) && withdrawAmount <= userData.mainWallet
                                        ? AppBtn(
                                      onTap: () {
                                        withdrawalMoney(context,withdrawCon.text);

                                      },
                                      hideBorder: true,
                                      title: 'Withdraw',
                                      fontWeight: FontWeight.w900,
                                      fontSize: 18,
                                      gradient: AppColors.loginSecondryGrad,
                                    )
                                        : AppBtn(
                                        onTap: () {
                                          if(withdrawCon.text.isEmpty){
                                            Utils.flushBarErrorMessage("Please enter amount", context, Colors.white);
                                          }
                                        },
                                        hideBorder: true,
                                        title: 'Withdraw',
                                        fontWeight: FontWeight.w900,
                                        fontSize: 18,
                                        gradient: AppColors.primaryappbargrey),

                                    // AppBtn(
                                    //   onTap: () {
                                    //     withdrawalMoney(context,withdrawCon.text);
                                    //   },
                                    //   hideBorder: true,
                                    //   title: 'Withdraw',
                                    //   fontWeight: FontWeight.w900,
                                    //   fontSize: 18,
                                    //   gradient: AppColors.loginSecondryGrad,
                                    // ),
                                    const SizedBox(height: 40),
                                    Container(
                                      width: width * 0.85,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color:
                                                  AppColors.gradientFirstColor,
                                              width: 1),
                                          borderRadius:
                                              BorderRadiusDirectional.circular(
                                                  15)),
                                      child: Column(
                                        children: [
                                          instruction(
                                              'Need to bet ',
                                              '₹${userData.recharge.toStringAsFixed(2)}',
                                              ' to be able to withdraw',
                                              Colors.white,
                                              AppColors.gradientFirstColor,
                                              Colors.white),
                                          ListView.builder(
                                              shrinkWrap: true,
                                              itemCount:
                                                  invitationRuleList.length,
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              itemBuilder: (context, index) {
                                                return instruction1(
                                                    invitationRuleList[index]);
                                              }),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),
                            ],
                          )
                        : Column(
                            children: [
                              Container(
                                width: width,
                                padding: const EdgeInsets.only(
                                    top: 15, left: 15, right: 15),
                                decoration: BoxDecoration(
                                    gradient: AppColors.secondaryappbar,
                                    borderRadius:
                                        BorderRadiusDirectional.circular(15)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Image.asset(
                                          Assets.imagesUsdtIcon,
                                          height: height * 0.05,
                                        ),
                                        const SizedBox(width: 15),
                                        textWidget(
                                            text: 'USDT amount',
                                            fontSize: 20,
                                            fontWeight: FontWeight.w900,
                                            color: AppColors.goldencolorthree),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    CustomTextField(
                                      fillColor: AppColors.scaffolddark,
                                      hintText: 'Please usdt amount',
                                      fieldRadius: BorderRadius.circular(30),
                                      textColor: Colors.white,
                                      keyboardType: TextInputType.number,
                                      fontWeight: FontWeight.w600,
                                      controller: usdtCon,
                                      onChanged: (value) {
                                        setState(() {
                                          double amount =
                                              double.tryParse(value) ?? 0;
                                          resultt =
                                              (amount / 92).toStringAsFixed(2);
                                        });
                                      },
                                      prefixIcon: SizedBox(
                                        width: 70,
                                        child: Row(
                                          children: [
                                            const SizedBox(width: 10),
                                            Image.asset(
                                              Assets.imagesUsdtIcon,
                                              height: height * 0.03,
                                            ),
                                            const SizedBox(width: 10),
                                            Container(
                                                height: 30,
                                                color: Colors.white,
                                                width: 2)
                                          ],
                                        ),
                                      ),
                                      suffixIcon: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            usdtCon.clear();
                                            selectedusdt = '';
                                            resultt = "";
                                          });
                                        },
                                        icon: const Icon(Icons.cancel_outlined,
                                            color: AppColors.iconColor),
                                      ),
                                    ),
                                    SizedBox(height: height * 0.01),
                                    Text(
                                      'Total amount recieved in USDT: ${resultt.isNotEmpty ? resultt : "0 "}',
                                      style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w900,
                                          color: AppColors.goldencolorthree),
                                    ),
                                    SizedBox(height: height * 0.01),
                                    CustomTextField(
                                      fillColor: AppColors.scaffolddark,
                                      hintText: 'USDT wallet address',
                                      fieldRadius: BorderRadius.circular(30),
                                      textColor: Colors.white,
                                      keyboardType: TextInputType.emailAddress,
                                      fontWeight: FontWeight.w600,
                                      controller: walletaddress,
                                      prefixIcon: SizedBox(
                                        width: 70,
                                        child: Row(
                                          children: [
                                            const SizedBox(width: 10),
                                            Image.asset(
                                              Assets.imagesUsdtIcon,
                                              height: height * 0.03,
                                            ),
                                            const SizedBox(width: 10),
                                            Container(
                                                height: 30,
                                                color: Colors.white,
                                                width: 2)
                                          ],
                                        ),
                                      ),
                                      suffixIcon: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            walletaddress.clear();
                                            selectedwalletadd = '';
                                            resultt = "";
                                          });
                                        },
                                        icon: const Icon(Icons.cancel_outlined,
                                            color: AppColors.iconColor),
                                      ),
                                    ),
                                    SizedBox(height: height * 0.02),
                                    const SizedBox(height: 10),
                                    AppBtn(
                                      onTap: () {
                                        withdrawalMoney(context,
                                          usdtCon.text
                                        );
                                      },
                                      hideBorder: true,
                                      title: 'W i t h d r a w',
                                      fontWeight: FontWeight.w900,
                                      fontSize: 18,
                                      gradient: AppColors.primaryappbargrey,
                                    ),
                                    const SizedBox(height: 40),
                                  ],
                                ),
                              ),
                            ],
                          ),
              ],
            ),
          ),
        ));
  }

  ///withdraw api
  String withdrawacid = '';
  UserViewProvider userProvider = UserViewProvider();
  withdrawalMoney(context,
    String money,
  ) async {
    UserModel user = await userProvider.getUser();
    String token = user.id.toString();

    final response = await http.post(
      Uri.parse(
        ApiUrl.withdrawl,
      ),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "user_id": token,
        "account_id": withdrawacid,
        "type": payUsing.toString(),
        "amount": money,
      }),
    );

    var data = jsonDecode(response.body);
    if (data["status"] == 200) {
      Navigator.pop(context);
      return Utils.flushBarSuccessMessage(data['message'], context, Colors.black);
    } else if (data["status"] == "401") {
    } else {
      Utils.flushBarErrorMessage(data['message'], context, Colors.black);
    }
  }

  ///view account
  List<AddacountViewModel> items = [];

  Future<void> addAccountView() async {
    UserModel user = await userProvider.getUser();
    String token = user.id.toString();

    final response = await http.get(
      Uri.parse(ApiUrl.addAccountView + token),
    );
    if (kDebugMode) {
      print(ApiUrl.addAccountView + token);
      print('addAccount_View+token');
    }
    setState(() {
      responseStatuscode = response.statusCode;
    });

    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body)['data'];
      setState(() {
        items = responseData
            .map((item) => AddacountViewModel.fromJson(item))
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


  ///select deposit type
  int minimumamount = 100;

  List<GetwayModel> depositType = [];

  Future<void> depositTypeSelect() async {
    final response = await http.get(Uri.parse(ApiUrl.getwayList),
    );

    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body)['data'];
      setState(() {
        minimumamount = json.decode(response.body)['minimum'];

        depositType = responseData.map((item) => GetwayModel.fromJson(item)).toList();
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

  List<String> invitationRuleList = [];

  Future<void> invitationRuleApi() async {
    final response = await http.get(
      Uri.parse('${ApiUrl.allRules}2'),
    );
    if (kDebugMode) {
      print('${ApiUrl.allRules}2');
      print('allRules');
    }

    setState(() {
      responseStatuscode = response.statusCode;
    });

    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body)['data'];

      setState(() {
        invitationRuleList =
            json.decode(responseData[0]['list']).cast<String>();
      });
    } else if (response.statusCode == 400) {
      if (kDebugMode) {
        print('Data not found');
      }
    } else {
      setState(() {
        invitationRuleList = [];
      });
      throw Exception('Failed to load data');
    }
  }

  instruction1(String title) {
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
          text: title, fontSize: 14, color: AppColors.primaryTextColor),
    );
  }

  Widget instruction(
    String titleFirst,
    String titleSecond,
    String titleThird,
    Color? firstColor,
    Color? secondColor,
    Color? thirdColor,
  ) {
    return ListTile(
        leading: Transform.rotate(
          angle: 45 * 3.1415927 / 180,
          child: Container(
            height: 10,
            width: 10,
            color: AppColors.gradientFirstColor,
          ),
        ),
        title: CustomRichText(
          textSpans: [
            CustomTextSpan(
              text: titleFirst,
              textColor: firstColor,
              fontSize: 12,
            ),
            CustomTextSpan(
                text: titleSecond, textColor: secondColor, fontSize: 12),
            CustomTextSpan(
                text: titleThird, textColor: thirdColor, fontSize: 12)
          ],
        ));
  }
}

class Notfounddata extends StatelessWidget {
  const Notfounddata({super.key});

  @override
  Widget build(BuildContext context) {
    final heights = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image(
          image: const AssetImage(Assets.imagesNoDataAvailable),
          height: heights / 3,
          width: width / 2,
        ),
        SizedBox(height: heights * 0.04),
        const Text(
          "Data not found",
        )
      ],
    );
  }
}
