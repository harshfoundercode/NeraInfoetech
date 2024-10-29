import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nera/generated/assets.dart';
import 'package:nera/main.dart';
import 'package:nera/model/Slider_model.dart';
import 'package:nera/res/aap_colors.dart';
import 'package:nera/res/api_urls.dart';
import 'package:nera/res/components/app_bar.dart';
import 'package:nera/res/components/text_widget.dart';
import 'package:nera/view/account/gifts.dart';
import 'package:nera/view/activity/Invitationbonus.dart';
import 'package:nera/view/activity/activity_award.dart';
import 'package:nera/view/activity/activity_details.dart';
import 'package:nera/view/activity/attendence_bonus.dart';
import 'package:nera/view/activity/betting_rebats.dart';

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key});

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {


  @override
  void initState() {
    activitySliderList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> items = [
      {
        'text': 'Activity Award',
        'icon': Assets.iconsActivityIcon1,
        'gradient': AppColors.orangeColorGradient,
        'onTap': () {
          Navigator.push(context, MaterialPageRoute(builder: (context)=>const ActivityAward()));
        },
      },
      {
        'text': 'Invitation bonus',
        'icon': Assets.iconsActivityIcon2,
        'gradient': AppColors.blueGradient,
        'onTap': () {
          Navigator.push(context, MaterialPageRoute(builder: (context)=>const InvitationBonus()));
        },
      },
      {
        'text': 'Betting rebate',
        'icon': Assets.iconsActivityIcon3,
        'gradient': const LinearGradient(
          colors: [Colors.orange, Colors.red],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        'onTap': () {
        Navigator.push(context, MaterialPageRoute(builder: (context)=>const BettingRebates()));
        },
      },
      // {
      //   'text': 'New member\ngift package',
      //   'icon': Assets.iconsActivityIcon4,
      //   'gradient': const LinearGradient(
      //     colors: [Colors.yellow, Colors.amber],
      //     begin: Alignment.topLeft,
      //     end: Alignment.bottomRight,
      //   ),
      //   'onTap': () {
      //     // Define the behavior for tapping the 'New member gift package' item
      //     // For example:
      //     print('New member gift package tapped!');
      //   },
      // },
    ];
    return Scaffold(
      backgroundColor: AppColors.scaffolddark,
      appBar: GradientAppBar(
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
          centerTitle: true,
          gradient: AppColors.primaryGradient),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration:
                  const BoxDecoration(gradient: AppColors.primaryGradient),
              child: ListTile(
                title: textWidget(
                    text: 'Activity',
                    fontWeight: FontWeight.w900,
                    fontSize: 20,
                    color: AppColors.primaryTextColor),
              ),
            ),
            Container(
              decoration:
                  const BoxDecoration(gradient: AppColors.primaryGradient),
              child: ListTile(
                subtitle: textWidget(
                    text:
                        'Please remember to follow the event page\nWe will launch user feedback activities from time to time',
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                    color: AppColors.primaryTextColor),
              ),
            ),
            const SizedBox(height: 9),
            SizedBox(
              height: height*0.15,
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 0.0,
                  mainAxisSpacing: 1.0,
                ),
                shrinkWrap: true,
                itemCount: items.length,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  return Center(
                    child: InkWell(

                        onTap: () {
                          // Call the onTap function associated with the item
                          if (items[index]['onTap'] != null) {
                            items[index]['onTap']();
                          }

                      },
                      child: Column(
                        children: [
                          Container(
                            height: height * 0.08,
                            width: width * 0.15,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                gradient: items[index]['gradient']),
                            child: Center(
                              child: Image.asset(
                                items[index]['icon'],
                                color: Colors.white,
                                scale: 1.8,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            items[index]['text'],
                            style: const TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 10,
                                color: AppColors.dividerColor),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  redeemWidget(() {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const GiftsPage()));
                  }, Assets.imagesGiftRedeem, 'Gifts',
                      'Enter the redemption code to receive gift rewards'),
                  redeemWidget(() {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AttendenceBonus()));
                  }, Assets.imagesSignInBanner, 'Attendance bonus',
                      'The more consecutive days you sign in, the higher the reward will be.'),
                ],
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: sliderData.length,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>ActivityDetails(bannerdata:sliderData[index])));
                  },
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                    child: Card(
                      color: AppColors.filledColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: SizedBox(
                        height: 200,
                        child: Column(
                          children: [
                            Container(
                              height: 150,
                              width: width,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10)),
                                image: DecorationImage(
                                  image: NetworkImage(
                                      sliderData[index].image.toString()),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            SizedBox(
                              height: 20,
                              width: width,
                              child: Text(
                                sliderData[index].name.toString(),
                                style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  int? responseStatuscode;
  List<SliderModel> sliderData = [];

  Future<void> activitySliderList() async {
    final response = await http.get(
      Uri.parse(ApiUrl.banner),
    );
    if (kDebugMode) {
      print(ApiUrl.banner);
      print('banner');
    }
    setState(() {
      responseStatuscode = response.statusCode;
    });
    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body)['data'];
      setState(() {
        sliderData =
            responseData.map((item) => SliderModel.fromJson(item)).toList();
        // selectedIndex = items.isNotEmpty ? 0:-1; //
      });
    } else if (response.statusCode == 400) {
      if (kDebugMode) {
        print('Data not found');
      }
    } else {
      setState(() {
        sliderData = [];
      });
      throw Exception('Failed to load data');
    }
  }

  Widget redeemWidget(
      Function()? onTap, String image, String title, String subTitle) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height * 0.3,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: AppColors.primaryUnselectedGradient,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: height * 0.17,
              width: width * 0.45,
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                image:
                    DecorationImage(image: AssetImage(image), fit: BoxFit.fill),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: textWidget(
                  text: title,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Colors.white),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: SizedBox(
                width: width * 0.4,
                child: textWidget(
                    text: subTitle,
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                    color: AppColors.primaryTextColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
