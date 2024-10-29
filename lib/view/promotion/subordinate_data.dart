import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nera/main.dart';
import 'package:nera/model/subordinateDataModel.dart';
import 'package:nera/model/tier_model.dart';
import 'package:nera/model/user_model.dart';
import 'package:nera/res/aap_colors.dart';
import 'package:nera/res/components/app_bar.dart';
import 'package:nera/res/components/app_btn.dart';
import 'package:nera/res/components/clipboard.dart';
import 'package:nera/res/components/text_field.dart';
import 'package:nera/res/components/text_widget.dart';
import 'package:nera/res/api_urls.dart';
import 'package:http/http.dart' as http;
import 'package:nera/res/provider/user_view_provider.dart';

class SubOrdinateDataScreen extends StatefulWidget {
  const SubOrdinateDataScreen( {super.key});

  @override
  State<SubOrdinateDataScreen> createState() => _SubOrdinateDataScreenState();
}

class _SubOrdinateDataScreenState extends State<SubOrdinateDataScreen> {
  TextEditingController searchCon = TextEditingController();

  @override
  void initState() {
    TierData();
    SubData();
    // TODO: implement initState
    super.initState();
  }

  int?responseStatuscode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffolddark,
      appBar: GradientAppBar(
          title: textWidget(
              text: 'Subordinate Data', fontSize: 25, color: Colors.white),
          leading: const AppBackBtn(),
          centerTitle: true,
          gradient: AppColors.primaryUnselectedGradient),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(top: height * 0.2),
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 15, 10, 15),
                  child: Container(
                    width: width * 0.9,
                    decoration: BoxDecoration(
                        gradient: AppColors.loginSecondryGrad,
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              addTextColumn(
                                  depositnumber==null?"0":depositnumber.toString(), 'Deposit Number', Colors.white),
                              addTextColumn(
                                  numberofbettor==null?"0":numberofbettor.toString(), 'Number of bettor', Colors.white),
                              addTextColumn(
                                  noofirstdeposit==null?"0":noofirstdeposit.toString(),
                                  'Number of People making\n            first deposit',
                                  Colors.white),
                            ],
                          ),
                          Column(
                            children: [
                              addTextColumn(
                                  depositAmount==null?"0":depositAmount.toString(), 'Deposit Amount', Colors.white),
                              addTextColumn(totalbet==null?"0":totalbet.toString(), 'Total bet', Colors.white),
                              addTextColumn(
                                  firstdepositamount==null?"0":firstdepositamount.toString(),
                                  'first deposit amount',
                                  Colors.white),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: height * 0.04,
                      )
                    ]),
                  ),
                ),
                ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: sundataitem.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.all(10),
                        height: height * 0.25,
                        width: width * 0.93,
                        decoration: BoxDecoration(
                            color: AppColors.secondaryContainerTextColor,
                            borderRadius: BorderRadius.circular(5)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Row(
                              children: [
                                textWidget(
                                    text: '  UID:${sundataitem[index].u_id}',
                                    fontSize: 18,
                                    color: AppColors.primaryTextColor),
                                IconButton(
                                    onPressed: () {
                                      copyToClipboard(sundataitem[index].u_id.toString(),context);
                                    },
                                    icon: const Icon(
                                      Icons.copy,
                                      size: 20,
                                      color: AppColors.primaryTextColor,
                                    )),
                              ],
                            ),
                            Container(
                              width: width * 0.9,
                              height: 0.5,
                              color: AppColors.gradientFirstColor,
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  textWidget(
                                      text: 'Level',
                                      fontSize: 16,
                                      color: AppColors.primaryTextColor),
                                  textWidget(
                                      text:selectedTierIndex==-1? '  All':'Tier ${selectedTierIndex+1}',
                                      fontSize: 16,
                                      color: AppColors.primaryTextColor),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  textWidget(
                                      text: 'Deposit amount',
                                      fontSize: 16,
                                      color: AppColors.primaryTextColor),
                                  textWidget(
                                      text: "₹${sundataitem[index].total_cash}",
                                      fontSize: 16,
                                      color: AppColors.gradientFirstColor),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  textWidget(
                                      text: 'Bet amount',
                                      fontSize: 18,
                                      color: AppColors.primaryTextColor),
                                  textWidget(
                                      text: "₹${sundataitem[index].bet_amount}",
                                      fontSize: 18,
                                      color: AppColors.gradientFirstColor),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  textWidget(
                                      text: 'Commission',
                                      fontSize: 18,
                                      color: AppColors.primaryTextColor),
                                  textWidget(
                                      text:sundataitem[index].commission.toString(),
                                      fontSize: 18,
                                      color: AppColors.gradientFirstColor),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  textWidget(
                                      text: 'Date',
                                      fontSize: 18,
                                      color: AppColors.primaryTextColor),
                                  textWidget(
                                      text:sundataitem[index].yesterday_date.toString(),
                                      fontSize: 18,
                                      color: AppColors.gradientFirstColor),
                                ],
                              ),
                            ),

                          ],
                        ),
                      );
                    }),
              ],
            ),
          ),
          SizedBox(
            width: width,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 15, 10, 0),
                  child: CustomTextField(
                    fieldRadius: BorderRadius.circular(10),
                    fillColor: Colors.white.withOpacity(0.01),
                    controller: searchCon,
                    onChanged: (val){

                    },
                    maxLines: 1,
                    hintText: 'Search subordinate UID',
                    suffixIcon: InkWell(
                      onTap: () {
                        // search(searchCon.text);
                        searchData(searchCon.text);
                        print("gsuyATdf8u");
                        print(searchCon.text);
                      },
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(5, 5, 10, 5),
                        child: Container(
                          alignment: Alignment.center,
                          height: height * 0.03,
                          width: width * 0.2,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            gradient: AppColors.loginSecondryGrad,
                          ),
                          child: const Icon(
                            Icons.search,
                            size: 35,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 15, 10, 15),
                  child: Container(
                    height: height * 0.065,

                    decoration: BoxDecoration(
                        color: AppColors.secondaryContainerTextColor,
                        borderRadius: BorderRadius.circular(5)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(width: 20,),
                        Center(
                          child: textWidget(
                              text:selectedTierIndex==-1? '  All':'Tier ${selectedTierIndex+1}',
                              fontSize: 18,
                              color: AppColors.primaryTextColor),
                        ),
                        IconButton(
                            onPressed: () {
                              showSubordinateFilterBottomSheet(context);

                            },
                            icon: const Icon(
                                Icons.keyboard_arrow_down_outlined,
                                color: AppColors.primaryTextColor)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  int selectedTierIndex = 0;


  String type='all';

  showSubordinateFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      backgroundColor:AppColors.secondaryContainerTextColor,
      shape: const RoundedRectangleBorder(
          borderRadius:   BorderRadius.only(
              topRight: Radius.circular(10), topLeft: Radius.circular(10))
      ),
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20),

          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: textWidget(
                        text: 'Cancel', fontSize: 16, color: Colors.grey),
                  ),
                  TextButton(
                    onPressed: () {
                      //
                      Navigator.pop(context,selectedTierIndex);
                      TierData();
                      SubData();
                    },
                    child: textWidget(
                        text: 'Confirm', fontSize: 16, color: Colors.blue),
                  ),
                ],
              ),
              Expanded(
                child: CupertinoPicker(
                    selectionOverlay:
                    const CupertinoPickerDefaultSelectionOverlay(
                      background: CupertinoDynamicColor.withBrightness(
                        color: Colors.transparent,
                        darkColor: Colors.transparent,
                      ),
                    ),
                    scrollController: FixedExtentScrollController(
                      initialItem: selectedTierIndex,
                    ),
                    itemExtent: 50,
                    onSelectedItemChanged: (tierIndex) {
                      setState(() {
                        selectedTierIndex = tierIndex; // Update selected index
                        type=tierIndex==0?'all':'Tier $tierIndex';
                        // dataindex=type=='all'?tieritem.length-1:int.parse(type.split('').last.toString());
                        print(tierIndex);
                        print("tierIndex");
                      });

                    },
                    children: [
                      for (var datas in tieritem)
                        Text(datas.name,style: TextStyle(color: Colors.white),)
                    ]
                ),
              ),
            ],
          ),
        );
      },
    ).then((value) {
      if (value != null) {

        print('Selected Tier: $value');
      }
    });
  }

  addTextColumn(String number, String subtext, Color textColor) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Column(
        children: [
          Text(
            number,
            style: TextStyle(
                fontSize: 15, fontWeight: FontWeight.w700, color: textColor),
          ),
          Text(
            subtext,
            style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryTextColor),
          ),
        ],
      ),
    );
  }



  List<TierModel> tieritem = [];
  Future<void> TierData() async {
    final response = await http.get(Uri.parse(ApiUrl.TierApi),);
    if (kDebugMode) {
      print(ApiUrl.TierApi);
      print('TierApi');
    }

    setState(() {
      responseStatuscode = response.statusCode;
    });

    if (response.statusCode==200) {
      final List<dynamic> responseData = json.decode(response.body)['data'];
      print(responseData);
      print("ewnrofbeortg");
      setState(() {
        tieritem = responseData.map((item) => TierModel.fromJson(item)).toList();
      });

    }
    else if(response.statusCode==400){
      if (kDebugMode) {
        print('Data not found');
      }
    }
    else {
      setState(() {
        tieritem = [];
      });
      throw Exception('Failed to load data');
    }
  }


  UserViewProvider userProvider = UserViewProvider();

  int ? depositnumber;
  String ? depositAmount;
  int ? numberofbettor;
  int ? totalbet;
  int ? noofirstdeposit;
  int ? firstdepositamount;

  List<SubordinateModel> sundataitem = [];
  Future<void> SubData() async {

    print("dwesbgfig");
    UserModel user = await userProvider.getUser();
    String token = user.id.toString();

    final response = await http.get(Uri.parse("${ApiUrl.SubdataApi}$token&tier=${selectedTierIndex+1}"),);
    if (kDebugMode) {
      print("${ApiUrl.SubdataApi}$token&tier=${selectedTierIndex+1}");
      print('subdadxxutswfdu');
    }

    setState(() {
      responseStatuscode = response.statusCode;
    });


    if (response.statusCode==200) {
      final List<dynamic> responseData = json.decode(response.body)['subordinates_data'];
      print(responseData);
      print("iugdiugtswd");
      setState(() {
        sundataitem = responseData.map((item) => SubordinateModel.fromJson(item)).toList();
        noofirstdeposit = json.decode(response.body)['first deposit '];
        depositnumber = json.decode(response.body)['number of deposit'];
        depositAmount = json.decode(response.body)['payin amount'];
        numberofbettor = json.decode(response.body)['number of bettor'];
        totalbet = json.decode(response.body)['bet amount'];
        firstdepositamount = json.decode(response.body)['first deposit amount'];

      });

    }
    else if(response.statusCode==400){
      if (kDebugMode) {
        print('Data not found');
      }
    }
    else {
      setState(() {
        sundataitem = [];
      });
      throw Exception('Failed to load data');
    }
  }


  Future<void> searchData(String search) async {
    print("Starting searchData function");

    try {
      UserModel user = await userProvider.getUser();
      String token = user.id.toString();

      final response = await http.get(
        Uri.parse("${ApiUrl.SubdataApi}$token&tier=${selectedTierIndex+1}&u_id=$search"),
      );

      if (kDebugMode) {
        print("${ApiUrl.SubdataApi}$token&tier=${selectedTierIndex+1}&u_id=$search");
        print("HTTP GET request sent");
      }

      setState(() {
        responseStatuscode = response.statusCode;
      });

      if (response.statusCode == 200) {
        List<SubordinateModel> searchResult = sundataitem.where((data) => data.u_id.toString().contains(search)).toList();
        print(searchResult);
        print("Search results filtered");

        setState(() {
          sundataitem = searchResult;
          print(sundataitem);
        });
      } else if (response.statusCode == 400) {
        if (kDebugMode) {
          print("Data not found");
        }
      } else {
        setState(() {
          sundataitem = [];
        });
        throw Exception("Failed to load data");
      }
    } catch (error) {
      if (kDebugMode) {
        print("Error in searchData function: $error");
      }
      throw Exception("Error in searchData function: $error");
    }
  }
}


