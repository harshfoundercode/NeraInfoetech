// ignore_for_file: constant_identifier_names

class ApiUrl {
  static const String uploadimage = "${baseUrl}admin/uploads/";
  // static const String baseUrl = 'https://root.winzy.app/';
  static const String baseUrl = 'https://nera.foundercode.org/';
  static const String configModel = "${baseUrl}api/";

  static const String login = "${configModel}login";
  static const String register = "${configModel}register";
  static const String profile = "${configModel}profile?id=";
  static const String allTranscationType = "${configModel}transaction_history_list";
  static const String allTranscation = "${configModel}transaction_history?userid=";
  static const String depositWithdrawlStatusList = "${configModel}Status_list";

  static const String depositHistory = "${configModel}deposit_history?user_id=";

  static const String withdrawHistory = "${configModel}withdraw_history?user_id=";
  static const String indianPayDeposit = "${configModel}userpayin";
  static const String addacount = "${configModel}add_account";
  static const String addAccountView = "${configModel}Account_view?user_id=";
  static const String withdrawl = "${configModel}withdraw";
  static const String giftHistory = "${configModel}claim_list?userid=";
  static const String privacypolicy = "${configModel}privacy_policy";
  static const String customerService = "${configModel}customer_service";
  static const String changeAvtarList = "${configModel}image_all";
  static const String UpdateAvtarApi = "${configModel}update_avatar";
  static const String changePasswordApi = "${configModel}changePassword";
  static const String banner = "${configModel}slider_image_view";
  static const String mainWalletTransfer = "${configModel}main_wallet_transfer";
  static const String activityRewards = "${configModel}activity_rewards?userid=";
  static const String activityRewardsHistory = "${configModel}activity_rewards_history?userid=";
  static const String invitationBonusList = "${configModel}invitation_bonus_list?userid=";
  static const String invitationRecords = "${configModel}Invitation_records?userid=";
  static const String extraDeposit = "${configModel}extra_first_deposit_bonus?userid=";
  static const String attendanceList = "${configModel}attendance_List?userid=";
  static const String attendanceHistory = "${configModel}attendance_history?userid=";
  static const String attendanceClaim = "${configModel}attendance_claim";
  static const String promotionScreen = "${configModel}agency-promotion-data-";
  static const String newSubordinateTabApi = "${configModel}new-subordinate?id=";
  static const String TierApi = "${configModel}tier";
  static const String SubdataApi = "${configModel}subordinate-data?id=";
  static const String CommissionDetailApi = "${configModel}commission_details?userid=";
  static const String allRules = "${configModel}all_rules?type=";
  static const String bettingRebateApi = "${configModel}betting_rebate_history?userid=";


  static const String aviatorBet = "${configModel}aviator_bet?uid=";
  static const String aviatorBetCancel = "${configModel}aviator_bet_cancel?userid=";
  static const String aviatorBetCashOut = "${configModel}aviator_cashout?salt=";
  static const String aviatorResult = "${configModel}aviator_last_five_result";
  static const String aviatorBetHistory = "${configModel}aviator_history?uid=";


  static const String resultList = "${configModel}results?game_id=";
  static const String betHistory = "${configModel}bet_history?userid=";
  static const String bettingApi = "${configModel}bet";
  static const String game_win = "${configModel}win_amount?userid=";
  static const String dragonBet = "${configModel}dragon_bet";


  static const String promotionCount = "${configModel}promotion_dashboard_count?id=";
  static const String walletdash = "${configModel}wallet_dashboard?id=";
  static const String aboutus = "${configModel}about_us?";
  static const String HowtoplayApi = "${baseUrl}admin/index.php/Mobile_app/howtoplay?game_id=";
  static const String beginnerapi = "${configModel}beginner_guied_line";
  static const String notificationapi = "${configModel}notification";
  static const String giftcardapi = "${configModel}giftCartApply?";
  static const String coinsapi = "${configModel}coins";
  static const String mlm = "${configModel}level_getuserbyrefid?id=";
  static const String feedback = "${configModel}feedback";
  static const String versionlink = "${configModel}version_apk_link";
  static const String profileUpdate = "${configModel}update_profile";

  static const String getwayList = "${configModel}pay_modes";
  static const String planMlm = "${configModel}mlm_plan";
  static const String termscon = "${configModel}terms_condition";
  static const String contact = "${configModel}contact_us";
  static const String AttendenceGet = "${configModel}attendance?";
  static const String attendenceDays = "${configModel}attendance_claim?userid=";
  static const String MLM_PLAN = "${configModel}level_getuserbyrefid?id=";
  static const String walletHistory = "${configModel}wallet_history?userid=";
  static const String paymentCheckStatus = "${configModel}payment_verified_done?orderid=";
  static const String extradepositPayment = "${configModel}extra_first_deposit?";


  static const String sendotp = "https://otp.fctechteam.org/send_otp.php?";
  static const String verifyotp = "https://otp.fctechteam.org/verifyotp.php?mobile=";
  static const String forgetPasswordUrl = "https://root.winzy.com/api/updatePassword";

  static const String usdtdeposit = "https://winzy.live/admin/api/pending_payment.php";

  ///plinko
  static const String plinkoBet = "${configModel}plinko_bet";
  static const String plinkoList = "${configModel}plinko_index_list?type=";
  static const String plinkoMultiplier = "${configModel}plinko_multiplier";
  static const String plinkoBetHistory = "${configModel}plinko_result?";


  ///mine
  static const String MineBetHistory = "${configModel}mine_result?";
  static const String MineBet = "${configModel}mine_bet";
  static const String MineCashOut = "${configModel}mine_cashout";
}



