import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zego_uikit/zego_uikit.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/zego_uikit_prebuilt_live_audio_room.dart';

const int zegoAppId = int.fromEnvironment('ZEGO_APP_ID');
const String zegoAppSign = String.fromEnvironment('ZEGO_APP_SIGN');

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp();
  } catch (e) {
    debugPrint('Firebase initialization failed: $e');
  }

  runApp(const PartyChatApp());
}

/* ============================================================
   LANGUAGE SYSTEM
   ============================================================ */

class AppLanguage {
  static final ValueNotifier<String> current =
      ValueNotifier<String>('English');

  static const List<String> languages = [
    'English',
    'Urdu',
    'Hindi',
    'Arabic',
    'Bengali',
    'Turkish',
    'Indonesian',
    'Spanish',
    'French',
    'Chinese',
  ];

  static const Map<String, Map<String, String>> translations = {
    'English': {
      'settings': 'Settings',
      'language': 'Language',
      'privacy': 'Privacy',
      'notifications': 'Notifications',
      'messages': 'Messages',
      'announcements': 'Announcements',
      'friends': 'Friends',
      'gifts': 'Gifts',
      'blocked_users': 'Blocked Users',
      'home': 'Home',
      'rooms': 'Rooms',
      'games': 'Games',
      'wallet': 'Wallet',
      'profile': 'Profile',
      'join': 'Join',
      'login': 'Login',
      'create_account': 'Create Account',
      'get_started': 'Get Started',
      'username': 'Username',
      'email': 'Email',
      'password': 'Password',
      'welcome': 'Welcome',
      'welcome_back': 'Welcome back',
      'chat_rooms': 'Chat Rooms',
      'popular_rooms': 'Popular Rooms 🔥',
      'your_balance': 'Your Balance',
      'diamonds': 'Diamonds',
      'online': 'online',
      'account': 'Account',
      'help_center': 'Help Center',
      'logout': 'Logout',
      'privacy_settings': 'Privacy',
      'friend_requests': 'Friend Requests',
      'room_invites': 'Room Invites',
      'friend_messages': 'Friend Messages',
      'my_gifts': 'My Gifts',
      'transaction_history': 'Transaction History',
      'coins': 'Coins',
      'recharge': 'Recharge',
      'welcome_to_partychat': 'Welcome to PartyChat',
      'chat_play_make_friends': 'Chat • Play • Make Friends',
      'change_profile_photo': 'Change Profile Photo',
      'choose_avatar': 'Choose Avatar',
      'change_username': 'Change Username',
      'save': 'Save',
      'cancel': 'Cancel',
      'play_now': 'Play Now',
      'my_wallet': 'My Wallet',
      'vip_level': 'VIP Level 3',
      'online_status': 'Online Status',
      'room_activity': 'Room Activity Visibility',
      'private_account': 'Private Account',
    },

    'Urdu': {
      'settings': 'سیٹنگز',
      'language': 'زبان',
      'privacy': 'پرائیویسی',
      'notifications': 'نوٹیفکیشنز',
      'messages': 'پیغامات',
      'announcements': 'اعلانات',
      'friends': 'دوست',
      'gifts': 'تحائف',
      'blocked_users': 'بلاک صارفین',
      'home': 'ہوم',
      'rooms': 'رومز',
      'games': 'گیمز',
      'wallet': 'والیٹ',
      'profile': 'پروفائل',
      'join': 'شامل ہوں',
      'login': 'لاگ اِن',
      'create_account': 'اکاؤنٹ بنائیں',
      'get_started': 'شروع کریں',
      'username': 'یوزرنیم',
      'email': 'ای میل',
      'password': 'پاس ورڈ',
      'welcome': 'خوش آمدید',
      'welcome_back': 'دوبارہ خوش آمدید',
      'chat_rooms': 'چیٹ رومز',
      'popular_rooms': 'مقبول رومز 🔥',
      'your_balance': 'آپ کا بیلنس',
      'diamonds': 'ڈائمنڈز',
      'online': 'آن لائن',
      'account': 'اکاؤنٹ',
      'help_center': 'ہیلپ سینٹر',
      'logout': 'لاگ آؤٹ',
      'privacy_settings': 'پرائیویسی',
      'friend_requests': 'دوستی کی درخواستیں',
      'room_invites': 'روم دعوتیں',
      'friend_messages': 'دوستوں کے پیغامات',
      'my_gifts': 'میرے تحائف',
      'transaction_history': 'ٹرانزیکشن ہسٹری',
      'coins': 'کوائنز',
      'recharge': 'ریچارج',
      'welcome_to_partychat': 'PartyChat میں خوش آمدید',
      'chat_play_make_friends': 'چیٹ • کھیلیں • دوست بنائیں',
      'change_profile_photo': 'پروفائل فوٹو تبدیل کریں',
      'choose_avatar': 'اوتار منتخب کریں',
      'change_username': 'یوزرنیم تبدیل کریں',
      'save': 'محفوظ کریں',
      'cancel': 'منسوخ',
      'play_now': 'ابھی کھیلیں',
      'my_wallet': 'میرا والیٹ',
      'vip_level': 'VIP لیول 3',
      'online_status': 'آن لائن اسٹیٹس',
      'room_activity': 'روم ایکٹیویٹی',
      'private_account': 'پرائیویٹ اکاؤنٹ',
    },

    'Hindi': {
      'settings': 'सेटिंग्स',
      'language': 'भाषा',
      'privacy': 'प्राइवेसी',
      'notifications': 'नोटिफिकेशन',
      'messages': 'मैसेज',
      'announcements': 'घोषणाएं',
      'friends': 'दोस्त',
      'gifts': 'गिफ्ट्स',
      'blocked_users': 'ब्लॉक किए गए यूज़र्स',
      'home': 'होम',
      'rooms': 'रूम्स',
      'games': 'गेम्स',
      'wallet': 'वॉलेट',
      'profile': 'प्रोफाइल',
      'join': 'जुड़ें',
      'login': 'लॉगिन',
      'create_account': 'अकाउंट बनाएं',
      'get_started': 'शुरू करें',
      'username': 'यूज़रनेम',
      'email': 'ईमेल',
      'password': 'पासवर्ड',
      'welcome': 'स्वागत है',
      'welcome_back': 'वापसी पर स्वागत है',
      'chat_rooms': 'चैट रूम्स',
      'popular_rooms': 'लोकप्रिय रूम्स 🔥',
      'your_balance': 'आपका बैलेंस',
      'diamonds': 'डायमंड्स',
      'online': 'ऑनलाइन',
      'account': 'अकाउंट',
      'help_center': 'हेल्प सेंटर',
      'logout': 'लॉगआउट',
      'privacy_settings': 'प्राइवेसी',
      'friend_requests': 'फ्रेंड रिक्वेस्ट',
      'room_invites': 'रूम इनवाइट',
      'friend_messages': 'फ्रेंड मैसेज',
      'my_gifts': 'मेरे गिफ्ट्स',
      'transaction_history': 'ट्रांजैक्शन हिस्ट्री',
      'coins': 'कॉइन्स',
      'recharge': 'रिचार्ज',
      'welcome_to_partychat': 'PartyChat में आपका स्वागत है',
      'chat_play_make_friends': 'चैट • खेलें • दोस्त बनाएं',
      'change_profile_photo': 'प्रोफाइल फोटो बदलें',
      'choose_avatar': 'अवतार चुनें',
      'change_username': 'यूज़रनेम बदलें',
      'save': 'सेव',
      'cancel': 'कैंसल',
      'play_now': 'अभी खेलें',
      'my_wallet': 'मेरा वॉलेट',
      'vip_level': 'VIP लेवल 3',
      'online_status': 'ऑनलाइन स्टेटस',
      'room_activity': 'रूम एक्टिविटी',
      'private_account': 'प्राइवेट अकाउंट',
    },

    'Arabic': {
      'settings': 'الإعدادات',
      'language': 'اللغة',
      'privacy': 'الخصوصية',
      'notifications': 'الإشعارات',
      'messages': 'الرسائل',
      'announcements': 'الإعلانات',
      'friends': 'الأصدقاء',
      'gifts': 'الهدايا',
      'blocked_users': 'المستخدمون المحظورون',
      'home': 'الرئيسية',
      'rooms': 'الغرف',
      'games': 'الألعاب',
      'wallet': 'المحفظة',
      'profile': 'الملف الشخصي',
      'join': 'انضمام',
      'login': 'تسجيل الدخول',
      'create_account': 'إنشاء حساب',
      'get_started': 'ابدأ',
      'username': 'اسم المستخدم',
      'email': 'البريد الإلكتروني',
      'password': 'كلمة المرور',
      'welcome': 'مرحباً',
      'welcome_back': 'مرحباً بعودتك',
      'chat_rooms': 'غرف الدردشة',
      'popular_rooms': 'الغرف الشائعة 🔥',
      'your_balance': 'رصيدك',
      'diamonds': 'الماس',
      'online': 'متصل',
      'account': 'الحساب',
      'help_center': 'مركز المساعدة',
      'logout': 'تسجيل الخروج',
      'privacy_settings': 'الخصوصية',
      'friend_requests': 'طلبات الصداقة',
      'room_invites': 'دعوات الغرف',
      'friend_messages': 'رسائل الأصدقاء',
      'my_gifts': 'هداياي',
      'transaction_history': 'سجل المعاملات',
      'coins': 'العملات',
      'recharge': 'إعادة الشحن',
      'welcome_to_partychat': 'مرحباً بك في PartyChat',
      'chat_play_make_friends': 'دردش • العب • كوّن صداقات',
      'change_profile_photo': 'تغيير صورة الملف الشخصي',
      'choose_avatar': 'اختر الصورة الرمزية',
      'change_username': 'تغيير اسم المستخدم',
      'save': 'حفظ',
      'cancel': 'إلغاء',
      'play_now': 'العب الآن',
      'my_wallet': 'محفظتي',
      'vip_level': 'VIP المستوى 3',
      'online_status': 'حالة الاتصال',
      'room_activity': 'نشاط الغرفة',
      'private_account': 'حساب خاص',
    },

    'Bengali': {
      'settings': 'সেটিংস',
      'language': 'ভাষা',
      'privacy': 'গোপনীয়তা',
      'notifications': 'নোটিফিকেশন',
      'messages': 'বার্তা',
      'announcements': 'ঘোষণা',
      'friends': 'বন্ধুরা',
      'gifts': 'উপহার',
      'blocked_users': 'ব্লক করা ব্যবহারকারী',
      'home': 'হোম',
      'rooms': 'রুম',
      'games': 'গেমস',
      'wallet': 'ওয়ালেট',
      'profile': 'প্রোফাইল',
      'join': 'যোগ দিন',
      'login': 'লগইন',
      'create_account': 'অ্যাকাউন্ট তৈরি করুন',
      'get_started': 'শুরু করুন',
      'username': 'ইউজারনেম',
      'email': 'ইমেইল',
      'password': 'পাসওয়ার্ড',
      'welcome': 'স্বাগতম',
      'welcome_back': 'আবার স্বাগতম',
      'chat_rooms': 'চ্যাট রুম',
      'popular_rooms': 'জনপ্রিয় রুম 🔥',
      'your_balance': 'আপনার ব্যালেন্স',
      'diamonds': 'ডায়মন্ড',
      'online': 'অনলাইন',
      'account': 'অ্যাকাউন্ট',
      'help_center': 'হেল্প সেন্টার',
      'logout': 'লগআউট',
      'privacy_settings': 'গোপনীয়তা',
      'friend_requests': 'বন্ধুত্বের অনুরোধ',
      'room_invites': 'রুম আমন্ত্রণ',
      'friend_messages': 'বন্ধুর বার্তা',
      'my_gifts': 'আমার উপহার',
      'transaction_history': 'লেনদেনের ইতিহাস',
      'coins': 'কয়েন',
      'recharge': 'রিচার্জ',
      'welcome_to_partychat': 'PartyChat-এ স্বাগতম',
      'chat_play_make_friends': 'চ্যাট • খেলুন • বন্ধু বানান',
      'change_profile_photo': 'প্রোফাইল ছবি পরিবর্তন করুন',
      'choose_avatar': 'অ্যাভাটার নির্বাচন করুন',
      'change_username': 'ইউজারনেম পরিবর্তন করুন',
      'save': 'সংরক্ষণ',
      'cancel': 'বাতিল',
      'play_now': 'এখন খেলুন',
      'my_wallet': 'আমার ওয়ালেট',
      'vip_level': 'VIP লেভেল 3',
      'online_status': 'অনলাইন স্ট্যাটাস',
      'room_activity': 'রুম অ্যাক্টিভিটি',
      'private_account': 'প্রাইভেট অ্যাকাউন্ট',
    },




  State<RoomPage> createState() => _RoomPageState();
}

class _RoomPageState extends State<RoomPage> {
  bool micOn = false;
  bool isSpeaking = false;
  bool speakerOn = true;

  StreamSubscription<double>? soundLevelSubscription;

  final TextEditingController messageController =
      TextEditingController();

  final List<String> messages = [];

  @override
  void dispose() {
    soundLevelSubscription?.cancel();
    messageController.dispose();
    super.dispose();
  }

  Future<void> toggleMic() async {
    setState(() {
      micOn = !micOn;

      if (!micOn) {
        isSpeaking = false;
      }
    });

    try {
      await ZegoUIKit().turnMicrophoneOn(
        micOn,
        userID: widget.userId,
      );

      if (micOn) {
        startMicGlow(widget.userId);
      } else {
        await soundLevelSubscription?.cancel();
        soundLevelSubscription = null;
      }
    } catch (e) {
      debugPrint('Mic error: $e');
    }
  }

  void startMicGlow(String userId) {
    soundLevelSubscription?.cancel();

    soundLevelSubscription =
        ZegoUIKit().getSoundLevelStream(userId).listen(
      (level) {
        if (!mounted || !micOn) return;

        final speaking = level > 20;

        if (speaking != isSpeaking) {
          setState(() {
            isSpeaking = speaking;
          });
        }
      },
      onError: (error) {
        debugPrint('Sound level error: $error');
      },
    );
  }

  void sendMessage() {
    final text = messageController.text.trim();

    if (text.isEmpty) return;

    setState(() {
      messages.add(text);
      messageController.clear();
    });
  }

  void showInviteFriendDialog() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const RoomInviteFriendsPage(),
      ),
    );
  }

  Widget _buildMicButton() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      width: 58,
      height: 58,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: micOn
            ? Colors.white
            : Colors.grey.shade800,
        boxShadow: isSpeaking
            ? [
                BoxShadow(
                  color: Colors.white.withOpacity(.90),
                  blurRadius: 22,
                  spreadRadius: 7,
                ),
              ]
            : [],
      ),
      child: IconButton(
        onPressed: toggleMic,
        icon: Icon(
          micOn ? Icons.mic : Icons.mic_off,
          color: micOn ? Colors.black : Colors.white,
          size: 27,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.title),
            Text(
              widget.online,
              style: const TextStyle(
                fontSize: 11,
                color: Colors.greenAccent,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: showInviteFriendDialog,
            icon: const Icon(Icons.person_add_alt_1),
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircleAvatar(
                        radius: 42,
                        child: Icon(
                          Icons.groups,
                          size: 45,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        widget.title,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        widget.online,
                        style: const TextStyle(
                          color: Colors.white54,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              if (messages.isNotEmpty)
                SizedBox(
                  height: 130,
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                    ),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      return Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.only(
                            bottom: 6,
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF191624),
                            borderRadius:
                                BorderRadius.circular(15),
                          ),
                          child: Text(messages[index]),
                        ),
                      );
                    },
                  ),
                ),

              SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    12,
                    8,
                    12,
                    12,
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          setState(() {
                            speakerOn = !speakerOn;
                          });
                        },
                        icon: Icon(
                          speakerOn
                              ? Icons.volume_up
                              : Icons.volume_off,
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          controller: messageController,
                          textInputAction:
                              TextInputAction.send,
                          onSubmitted: (_) => sendMessage(),
                          decoration: InputDecoration(
                            hintText: 'Type a message...',
                            filled: true,
                            fillColor:
                                const Color(0xFF17151F),
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(25),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      _buildMicButton(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/* ============================================================
   GAMES
   ============================================================ */

class GamesTab extends StatelessWidget {
  const GamesTab({super.key});

  @override
  Widget build(BuildContext context) {
    final games = [
      ['Ludo', Icons.casino],
      ['Carrom', Icons.sports_handball],
      ['8 Ball Pool', Icons.sports_baseball],
      ['Quiz', Icons.quiz],
      ['Bubble Shooter', Icons.bubble_chart],
    ];

    return ListView(
      padding: const EdgeInsets.all(18),
      children: [
        Text(
          AppLanguage.text('games'),
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 18),
        ...games.map(
          (game) => GameCard(
            title: game[0] as String,
            icon: game[1] as IconData,
          ),
        ),
      ],
    );
  }
}

class GameCard extends StatelessWidget {
  final String title;
  final IconData icon;

  const GameCard({
    super.key,
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF15131F),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 27,
            child: Icon(icon),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          FilledButton(
            onPressed: () {},
            child: Text(
              AppLanguage.text('play_now'),
            ),
          ),
        ],
      ),
    );
  }
}

/* ============================================================
   WALLET
   ============================================================ */

class WalletTab extends StatelessWidget {
  const WalletTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(18),
      children: [
        Text(
          AppLanguage.text('my_wallet'),
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: const Color(0xFF171421),
            borderRadius: BorderRadius.circular(22),
          ),
          child: Column(
            children: [
              const Icon(
                Icons.account_balance_wallet,
                size: 55,
              ),
              const SizedBox(height: 14),
              Text(
                AppLanguage.text('coins'),
                style: const TextStyle(
                  color: Colors.white60,
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                '12,580',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                '💎 2,450 ${AppLanguage.text('diamonds')}',
                style: const TextStyle(
                  fontSize: 17,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        SizedBox(
          height: 52,
          child: FilledButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.add),
            label: Text(
              AppLanguage.text('recharge'),
            ),
          ),
        ),
      ],
    );
  }
}

/* ============================================================
   PROFILE
   ============================================================ */

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  Future<void> changeUsername(
    BuildContext context,
    String currentName,
  ) async {
    final controller = TextEditingController(
      text: currentName,
    );

    final result = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(
            AppLanguage.text('change_username'),
          ),
          content: TextField(
            controller: controller,
            maxLength: 20,
            decoration: const InputDecoration(
              hintText: '3–20 characters',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: Text(
                AppLanguage.text('cancel'),
              ),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  controller.text.trim(),
                );
              },
              child: Text(
                AppLanguage.text('save'),
              ),
            ),
          ],
        );
      },
    );

    controller.dispose();

    if (result == null || result.isEmpty) return;

    if (result.length < 3 || result.length > 20) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Username 3 se 20 characters ka hona chahiye.',
          ),
        ),
      );
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final userRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid);

    final snapshot = await userRef.get();

    final lastChange =
        snapshot.data()?['lastNameChangeAt'];

    if (lastChange is Timestamp) {
      final difference =
          DateTime.now().difference(lastChange.toDate());

      if (difference.inHours < 24) {
        final remaining =
            const Duration(hours: 24) - difference;

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Username dobara change karne ke liye '
              '${remaining.inHours} ghante wait karein.',
            ),
          ),
        );
        return;
      }
    }

    await userRef.set(
      {
        'name': result,
        'lastNameChangeAt':
            FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );

    await user.updateDisplayName(result);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Username successfully change ho gaya.',
        ),
      ),
    );
  }

  Future<void> pickProfilePhoto() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final picker = ImagePicker();

    final image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
      maxWidth: 900,
    );

    if (image == null) return;

    final bytes = await image.readAsBytes();
    final encodedPhoto = base64Encode(bytes);

    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .set(
      {
        'photoBase64': encodedPhoto,
        'photoURL': '',
        'avatar': '',
        'updatedAt': FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Profile photo update ho gayi.',
        ),
      ),
    );
  }

  Future<void> chooseAvatar() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final avatars = [
      '😀',
      '😎',
      '🥳',
      '🤩',
      '😇',
      '🦁',
      '🐯',
      '🐼',
      '🦊',
      '🐸',
      '🐵',
      '🐨',
    ];

    final selected = await showModalBottomSheet<String>(
      context: context,
      builder: (context) {
        return GridView.builder(
          padding: const EdgeInsets.all(20),
          gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisSpacing: 15,
            crossAxisSpacing: 15,
          ),
          itemCount: avatars.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                Navigator.pop(
                  context,
                  avatars[index],
                );
              },
              child: Center(
                child: Text(
                  avatars[index],
                  style: const TextStyle(
                    fontSize: 42,
                  ),
                ),
              ),
            );
          },
        );
      },
    );

    if (selected == null) return;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .set(
      {
        'avatar': selected,
        'photoBase64': '',
        'photoURL': '',
        'updatedAt': FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );
  }

  void showProfileImage(
    BuildContext context,
    String? base64Photo,
    String avatar,
    String photoURL,
  ) {
    if (base64Photo != null && base64Photo.isNotEmpty) {
      try {
        final bytes = base64Decode(base64Photo);

        showDialog(
          context: context,
          builder: (_) {
            return Dialog(
              backgroundColor: Colors.transparent,
              child: InteractiveViewer(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.memory(
                    bytes,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            );
          },
        );
        return;
      } catch (_) {}
    }

    if (photoURL.isNotEmpty) {
      showDialog(
        context: context,
        builder: (_) {
          return Dialog(
            backgroundColor: Colors.transparent,
            child: InteractiveViewer(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  photoURL,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          );
        },
      );
      return;
    }

    if (avatar.isNotEmpty) {
      showDialog(
        context: context,
        builder: (_) {
          return Dialog(
            child: Padding(
              padding: const EdgeInsets.all(35),
              child: Text(
                avatar,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 100,
                ),
              ),
            ),
          );
        },
      );
    }
  }

  Widget buildProfileAvatar(
    BuildContext context,
    Map<String, dynamic> data,
  ) {
    final base64Photo =
        data['photoBase64'] as String? ?? '';

    final photoURL =
        data['photoURL'] as String? ?? '';

    final avatar =
        data['avatar'] as String? ?? '';

    if (base64Photo.isNotEmpty) {
      try {
        return Image.memory(
          base64Decode(base64Photo),
          width: 86,
          height: 86,
          fit: BoxFit.cover,
        );
      } catch (_) {}
    }

    if (photoURL.isNotEmpty) {
      return Image.network(
        photoURL,
        width: 86,
        height: 86,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) {
          return const Icon(
            Icons.person,
            size: 45,
          );
        },
      );
    }

    if (avatar.isNotEmpty) {
      return Text(
        avatar,
        style: const TextStyle(
          fontSize: 48,
        ),
      );
    }

    return const Icon(
      Icons.person,
      size: 45,
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Center(
        child: Text('Please login again.'),
      );
    }

    final userDoc = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid);

    return StreamBuilder<
        DocumentSnapshot<Map<String, dynamic>>>(
      stream: userDoc.snapshots(),
      builder: (context, snapshot) {
        final data = snapshot.data?.data() ?? {};

        final name =
            data['name'] as String? ??
                user.displayName ??
                'Party User';

        final email =
            data['email'] as String? ??
                user.email ??
                '';

        final base64Photo =
            data['photoBase64'] as String? ?? '';

        final avatar =
            data['avatar'] as String? ?? '';

        final photoURL =
            data['photoURL'] as String? ?? '';

        return StreamBuilder<
            DocumentSnapshot<Map<String, dynamic>>>(
          stream: ProfileUnreadService.ref(
            user.uid,
          ).snapshots(),
          builder: (context, unreadSnapshot) {
            final unread =
                unreadSnapshot.data?.data() ?? {};

            return ListView(
              padding: const EdgeInsets.all(18),
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        showProfileImage(
                          context,
                          base64Photo,
                          avatar,
                          photoURL,
                        );
                      },
                      child: CircleAvatar(
                        radius: 43,
                        child: ClipOval(
                          child: buildProfileAvatar(
                            context,
                            data,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            email,
                            style: const TextStyle(
                              color: Colors.white54,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            AppLanguage.text('vip_level'),
                            style: const TextStyle(
                              color: Colors.amber,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: pickProfilePhoto,
                        icon: const Icon(
                          Icons.photo_library,
                        ),
                        label: Text(
                          AppLanguage.text(
                            'change_profile_photo',
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    OutlinedButton(
                      onPressed: chooseAvatar,
                      child: Text(
                        AppLanguage.text(
                          'choose_avatar',
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      changeUsername(
                        context,
                        name,
                      );
                    },
                    icon: const Icon(Icons.edit),
                    label: Text(
                      AppLanguage.text(
                        'change_username',
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                ProfileMenuItem(
                  icon: Icons.person_add_alt_1,
                  title: AppLanguage.text(
                    'friend_requests',
                  ),
                  count: unread['friendRequests'] ?? 0,
                  onTap: () {
                    ProfileUnreadService.markRead(
                      user.uid,
                      'friendRequests',
                    );

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            const FriendRequestsPage(),
                      ),
                    );
                  },
                ),

                ProfileMenuItem(
                  icon: Icons.mail_outline,
                  title: AppLanguage.text(
                    'room_invites',
                  ),
                  count: unread['roomInvites'] ?? 0,
                  onTap: () {
                    ProfileUnreadService.markRead(
                      user.uid,
                      'roomInvites',
                    );

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            const RoomInvitesPage(),
                      ),
                    );
                  },
                ),

                ProfileMenuItem(
                  icon: Icons.chat_outlined,
                  title: AppLanguage.text(
                    'friend_messages',
                  ),
                  count: unread['friendMessages'] ?? 0,
                  onTap: () {
                    ProfileUnreadService.markRead(
                      user.uid,
                      'friendMessages',
                    );

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            const FriendMessagesPage(),
                      ),
                    );
                  },
                ),

                ProfileMenuItem(
                  icon: Icons.card_giftcard,
                  title: AppLanguage.text('gifts'),
                  count: unread['gifts'] ?? 0,
                  onTap: () {
                    ProfileUnreadService.markRead(
                      user.uid,
                      'gifts',
                    );

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            const GiftsPage(),
                      ),
                    );
                  },
                ),

                ProfileMenuItem(
                  icon: Icons.notifications_none,
                  title: AppLanguage.text(
                    'notifications',
                  ),
                  count: unread['notifications'] ?? 0,
                  onTap: () {
                    ProfileUnreadService.markRead(
                      user.uid,
                      'notifications',
                    );

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            const NotificationsPage(),
                      ),
                    );
                  },
                ),

                ProfileMenuItem(
                  icon: Icons.redeem,
                  title: AppLanguage.text(
                    'my_gifts',
                  ),
                  count: unread['myGifts'] ?? 0,
                  onTap: () {
                    ProfileUnreadService.markRead(
                      user.uid,
                      'myGifts',
                    );

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            const MyGiftsPage(),
                      ),
                    );
                  },
                ),

                ProfileMenuItem(
                  icon: Icons.people_outline,
                  title: AppLanguage.text(
                    'friends',
                  ),
                  count: unread['friends'] ?? 0,
                  onTap: () {
                    ProfileUnreadService.markRead(
                      user.uid,
                      'friends',
                    );

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            const FriendsPage(),
                      ),
                    );
                  },
                ),

                ProfileMenuItem(
                  icon: Icons.settings_outlined,
                  title: AppLanguage.text('settings'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            const SettingsPage(),
                      ),
                    );
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final dynamic count;
  final VoidCallback onTap;

  const ProfileMenuItem({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.count = 0,
  });

  @override
  Widget build(BuildContext context) {
    int unreadCount = 0;

    if (count is int) {
      unreadCount = count;
    } else if (count is num) {
      unreadCount = count.toInt();
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF15131F),
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon),
        title: Text(title),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (unreadCount > 0)
              Container(
                constraints: const BoxConstraints(
                  minWidth: 20,
                  minHeight: 20,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 6,
                  vertical: 2,
                ),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  unreadCount > 99
                      ? '99+'
                      : unreadCount.toString(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            const SizedBox(width: 5),
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }
}



// =========================
// PROFILE PAGES
// =========================

class FriendRequestsPage extends StatelessWidget {
  const FriendRequestsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid == null) {
      return const Scaffold(
        body: Center(child: Text('Login required')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Friend Requests')),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('friendRequests')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data?.docs ?? [];

          if (docs.isEmpty) {
            return const Center(
              child: Text(
                'No friend requests',
                style: TextStyle(color: Colors.white70),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final doc = docs[index];
              final data = doc.data();

              final requesterUid =
                  (data['fromUid'] ?? data['uid'] ?? doc.id).toString();

              final name =
                  (data['fromName'] ?? data['name'] ?? 'Party User').toString();

              final photo =
                  (data['fromPhoto'] ?? data['photoURL'] ?? '').toString();

              return Card(
                color: const Color(0xFF15121F),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      _NetworkOrAvatar(
                        photo: photo,
                        name: name,
                        radius: 25,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        tooltip: 'Accept',
                        onPressed: () async {
                          await PartyChatData.acceptFriendRequest(
                            myUid: uid,
                            otherUid: requesterUid,
                          );

                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Friend request accepted'),
                              ),
                            );
                          }
                        },
                        icon: const Icon(
                          Icons.check_circle,
                          color: Colors.greenAccent,
                        ),
                      ),
                      IconButton(
                        tooltip: 'Reject',
                        onPressed: () async {
                          await PartyChatData.rejectFriendRequest(
                            myUid: uid,
                            otherUid: requesterUid,
                          );
                        },
                        icon: const Icon(
                          Icons.cancel,
                          color: Colors.redAccent,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}


// =========================
// ROOM INVITES
// =========================

class RoomInvitesPage extends StatelessWidget {
  const RoomInvitesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid == null) {
      return const Scaffold(
        body: Center(child: Text('Login required')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Room Invites')),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('roomInvites')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data?.docs ?? [];

          if (docs.isEmpty) {
            return const Center(
              child: Text(
                'No room invites',
                style: TextStyle(color: Colors.white70),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final doc = docs[index];
              final data = doc.data();

              final roomId = (data['roomId'] ?? '').toString();
              final roomName =
                  (data['roomName'] ?? 'PartyChat Room').toString();
              final fromName =
                  (data['fromName'] ?? 'Party User').toString();

              return Card(
                color: const Color(0xFF15121F),
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Color(0xFF8D3DFF),
                    child: Icon(
                      Icons.meeting_room,
                      color: Colors.white,
                    ),
                  ),
                  title: Text(
                    roomName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    '$fromName invited you',
                    style: const TextStyle(color: Colors.white60),
                  ),
                  trailing: ElevatedButton(
                    onPressed: roomId.isEmpty
                        ? null
                        : () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => RoomPage(
                                  title: roomName,
                                  online: 0,
                                ),
                              ),
                            );
                          },
                    child: const Text('Join'),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}


// =========================
// FRIEND MESSAGES
// =========================

class FriendMessagesPage extends StatelessWidget {
  const FriendMessagesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid == null) {
      return const Scaffold(
        body: Center(child: Text('Login required')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Friend Messages')),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('chats')
            .orderBy('updatedAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data?.docs ?? [];

          if (docs.isEmpty) {
            return const Center(
              child: Text(
                'No messages',
                style: TextStyle(color: Colors.white70),
              ),
            );
          }

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data();

              final friendUid =
                  (data['friendUid'] ?? data['otherUid'] ?? '').toString();

              final name =
                  (data['friendName'] ?? data['name'] ?? 'Party User')
                      .toString();

              final lastMessage =
                  (data['lastMessage'] ?? '').toString();

              final photo =
                  (data['photoURL'] ?? data['photoUrl'] ?? '').toString();

              return ListTile(
                leading: _NetworkOrAvatar(
                  photo: photo,
                  name: name,
                  radius: 24,
                ),
                title: Text(
                  name,
                  style: const TextStyle(color: Colors.white),
                ),
                subtitle: Text(
                  lastMessage,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white60),
                ),
                onTap: friendUid.isEmpty
                    ? null
                    : () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ChatPage(
                              otherUid: friendUid,
                              otherName: name,
                              otherPhoto: photo,
                            ),
                          ),
                        );
                      },
              );
            },
          );
        },
      ),
    );
  }
}


// =========================
// GIFTS PAGE
// =========================

class GiftsPage extends StatelessWidget {
  const GiftsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid == null) {
      return const Scaffold(
        body: Center(child: Text('Login required')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Gifts')),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('gifts')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data?.docs ?? [];

          if (docs.isEmpty) {
            return const Center(
              child: Text(
                'No gifts received',
                style: TextStyle(color: Colors.white70),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data();

              final fromName =
                  (data['fromName'] ?? 'Party User').toString();

              final gift =
                  (data['giftName'] ?? data['gift'] ?? 'Gift').toString();

              final amount =
                  (data['amount'] ?? 0).toString();

              return Card(
                color: const Color(0xFF15121F),
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Color(0xFF8D3DFF),
                    child: Icon(
                      Icons.card_giftcard,
                      color: Colors.white,
                    ),
                  ),
                  title: Text(
                    '$gift × $amount',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    'From $fromName',
                    style: const TextStyle(color: Colors.white60),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}


// =========================
// MY GIFTS
// =========================

class MyGiftsPage extends StatelessWidget {
  const MyGiftsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid == null) {
      return const Scaffold(
        body: Center(child: Text('Login required')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('My Gifts')),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('sentGifts')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data?.docs ?? [];

          if (docs.isEmpty) {
            return const Center(
              child: Text(
                'No gifts sent',
                style: TextStyle(color: Colors.white70),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data();

              final toName =
                  (data['toName'] ?? 'Party User').toString();

              final gift =
                  (data['giftName'] ?? data['gift'] ?? 'Gift').toString();

              final amount =
                  (data['amount'] ?? 0).toString();

              return Card(
                color: const Color(0xFF15121F),
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Color(0xFF8D3DFF),
                    child: Icon(
                      Icons.card_giftcard,
                      color: Colors.white,
                    ),
                  ),
                  title: Text(
                    '$gift × $amount',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    'To $toName',
                    style: const TextStyle(color: Colors.white60),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}


// =========================
// FRIENDS PAGE
// =========================

class FriendsPage extends StatefulWidget {
  const FriendsPage({super.key});

  @override
  State<FriendsPage> createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  final searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid == null) {
      return const Scaffold(
        body: Center(child: Text('Login required')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Friends')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: searchController,
              onSubmitted: (_) => setState(() {}),
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search username',
                hintStyle: const TextStyle(color: Colors.white54),
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  onPressed: () => setState(() {}),
                  icon: const Icon(Icons.search),
                ),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(uid)
                  .collection('friends')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final docs = snapshot.data?.docs ?? [];

                if (docs.isEmpty) {
                  return const Center(
                    child: Text(
                      'No friends yet',
                      style: TextStyle(color: Colors.white70),
                    ),
                  );
                }

                final query =
                    searchController.text.trim().toLowerCase();

                final filtered = docs.where((doc) {
                  final data = doc.data();
                  final name =
                      (data['name'] ?? data['friendName'] ?? '')
                          .toString()
                          .toLowerCase();
                  return query.isEmpty || name.contains(query);
                }).toList();

                return ListView.builder(
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final doc = filtered[index];
                    final data = doc.data();

                    final friendUid =
                        (data['friendUid'] ?? doc.id).toString();

                    final name =
                        (data['name'] ?? data['friendName'] ?? 'Party User')
                            .toString();

                    final photo =
                        (data['photoURL'] ?? data['photoUrl'] ?? '')
                            .toString();

                    return ListTile(
                      leading: _NetworkOrAvatar(
                        photo: photo,
                        name: name,
                        radius: 25,
                      ),
                      title: Text(
                        name,
                        style: const TextStyle(color: Colors.white),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.chat),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ChatPage(
                                    otherUid: friendUid,
                                    otherName: name,
                                    otherPhoto: photo,
                                  ),
                                ),
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.card_giftcard),
                            onPressed: () {
                              _showGiftDialog(
                                context,
                                friendUid,
                                name,
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.block,
                              color: Colors.redAccent,
                            ),
                            onPressed: () async {
                              await PartyChatData.blockUser(
                                uid,
                                friendUid,
                              );

                              if (context.mounted) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(
                                  const SnackBar(
                                    content: Text('User blocked'),
                                  ),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showGiftDialog(
    BuildContext context,
    String recipientUid,
    String recipientName,
  ) async {
    final amountController = TextEditingController(text: '10');

    await showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Send Gift'),
          content: TextField(
            controller: amountController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Coins',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final amount =
                    int.tryParse(amountController.text.trim()) ?? 0;

                if (amount <= 0) return;

                await PartyChatData.sendGift(
                  recipientUid: recipientUid,
                  recipientName: recipientName,
                  amount: amount,
                  giftName: 'Gift',
                );

                if (dialogContext.mounted) {
                  Navigator.pop(dialogContext);
                }
              },
              child: const Text('Send'),
            ),
          ],
        );
      },
    );

    amountController.dispose();
  }
}


// =========================
// CHAT PAGE
// =========================

class ChatPage extends StatefulWidget {
  final String otherUid;
  final String otherName;
  final String otherPhoto;

  const ChatPage({
    super.key,
    required this.otherUid,
    required this.otherName,
    this.otherPhoto = '',
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid == null) {
      return const Scaffold(
        body: Center(child: Text('Login required')),
      );
    }

    final chatId = PartyChatData.chatId(uid, widget.otherUid);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            _NetworkOrAvatar(
              photo: widget.otherPhoto,
              name: widget.otherName,
              radius: 18,
            ),
            const SizedBox(width: 10),
            Text(widget.otherName),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance
                  .collection('chats')
                  .doc(chatId)
                  .collection('messages')
                  .orderBy('createdAt')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final docs = snapshot.data?.docs ?? [];

                return ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final data = docs[index].data();

                    final fromUid =
                        (data['fromUid'] ?? '').toString();

                    final message =
                        (data['message'] ?? '').toString();

                    final mine = fromUid == uid;

                    return Align(
                      alignment: mine
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        margin:
                            const EdgeInsets.symmetric(vertical: 4),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: mine
                              ? const Color(0xFF8D3DFF)
                              : const Color(0xFF201B2D),
                          borderRadius:
                              BorderRadius.circular(18),
                        ),
                        child: Text(
                          message,
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        hintText: 'Message...',
                      ),
                      onSubmitted: (_) => _send(),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: _send,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _send() async {
    final text = controller.text.trim();

    if (text.isEmpty) return;

    controller.clear();

    await PartyChatData.sendMessage(
      recipientUid: widget.otherUid,
      recipientName: widget.otherName,
      message: text,
    );
  }
}


// =========================
// NETWORK AVATAR
// =========================

class _NetworkOrAvatar extends StatelessWidget {
  final String photo;
  final String name;
  final double radius;

  const _NetworkOrAvatar({
    required this.photo,
    required this.name,
    this.radius = 25,
  });

  @override
  Widget build(BuildContext context) {
    if (photo.isNotEmpty) {
      return CircleAvatar(
        radius: radius,
        backgroundImage: NetworkImage(photo),
      );
    }

    return CircleAvatar(
      radius: radius,
      backgroundColor: const Color(0xFF8D3DFF),
      child: Text(
        name.isNotEmpty ? name[0].toUpperCase() : 'P',
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}


// =========================
// ROOM INVITE FRIENDS
// =========================

class RoomInviteFriendsPage extends StatelessWidget {
  final String roomId;
  final String roomName;

  const RoomInviteFriendsPage({
    super.key,
    required this.roomId,
    required this.roomName,
  });

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid == null) {
      return const Scaffold(
        body: Center(child: Text('Login required')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Invite Friends')),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('friends')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final docs = snapshot.data?.docs ?? [];

          if (docs.isEmpty) {
            return const Center(
              child: Text(
                'No friends to invite',
                style: TextStyle(color: Colors.white70),
              ),
            );
          }

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data();

              final friendUid =
                  (data['friendUid'] ?? docs[index].id).toString();

              final name =
                  (data['name'] ?? data['friendName'] ?? 'Party User')
                      .toString();

              final photo =
                  (data['photoURL'] ?? data['photoUrl'] ?? '').toString();

              return ListTile(
                leading: _NetworkOrAvatar(
                  photo: photo,
                  name: name,
                  radius: 24,
                ),
                title: Text(
                  name,
                  style: const TextStyle(color: Colors.white),
                ),
                trailing: ElevatedButton(
                  onPressed: () async {
                    await PartyChatData.sendRoomInvite(
                      recipientUid: friendUid,
                      roomId: roomId,
                      roomName: roomName,
                    );

                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('$name invited'),
                        ),
                      );
                    }
                  },
                  child: const Text('Invite'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}


// =========================
// BLOCKED USERS
// =========================

class BlockedUsersPage extends StatelessWidget {
  const BlockedUsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid == null) {
      return const Scaffold(
        body: Center(child: Text('Login required')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Blocked Users')),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('blockedUsers')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final docs = snapshot.data?.docs ?? [];

          if (docs.isEmpty) {
            return const Center(
              child: Text(
                'No blocked users',
                style: TextStyle(color: Colors.white70),
              ),
            );
          }

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final doc = docs[index];
              final data = doc.data();

              final name =
                  (data['name'] ?? 'Party User').toString();

              final photo =
                  (data['photoURL'] ?? '').toString();

              return ListTile(
                leading: _NetworkOrAvatar(
                  photo: photo,
                  name: name,
                  radius: 24,
                ),
                title: Text(
                  name,
                  style: const TextStyle(color: Colors.white),
                ),
                trailing: TextButton(
                  onPressed: () async {
                    await PartyChatData.unblockUser(
                      uid,
                      doc.id,
                    );
                  },
                  child: const Text('Unblock'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}


// =========================
// NOTIFICATIONS PAGE
// =========================

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() =>
      _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  bool messagesEnabled = true;
  bool announcementsEnabled = true;

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid == null) {
      return const Scaffold(
        body: Center(child: Text('Login required')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: Column(
        children: [
          SwitchListTile(
            title: const Text(
              'Messages',
              style: TextStyle(color: Colors.white),
            ),
            subtitle: const Text(
              'Receive friend message notifications',
              style: TextStyle(color: Colors.white60),
            ),
            value: messagesEnabled,
            onChanged: (value) {
              setState(() {
                messagesEnabled = value;
              });
            },
          ),
          SwitchListTile(
            title: const Text(
              'Announcements',
              style: TextStyle(color: Colors.white),
            ),
            subtitle: const Text(
              'Receive PartyChat announcements',
              style: TextStyle(color: Colors.white60),
            ),
            value: announcementsEnabled,
            onChanged: (value) {
              setState(() {
                announcementsEnabled = value;
              });
            },
          ),
          const Divider(),
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(uid)
                  .collection('notifications')
                  .orderBy('createdAt', descending: true)
                  .limit(100)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final docs = snapshot.data?.docs ?? [];

                if (docs.isEmpty) {
                  return const Center(
                    child: Text(
                      'No notifications',
                      style: TextStyle(color: Colors.white70),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final doc = docs[index];
                    final data = doc.data();

                    final title =
                        (data['title'] ?? 'Notification').toString();

                    final message =
                        (data['message'] ?? '').toString();

                    final isRead =
                        data['isRead'] == true;

                    return ListTile(
                      tileColor: isRead
                          ? null
                          : const Color(0xFF191526),
                      leading: Icon(
                        isRead
                            ? Icons.notifications_none
                            : Icons.notifications_active,
                        color: isRead
                            ? Colors.white54
                            : const Color(0xFFB56BFF),
                      ),
                      title: Text(
                        title,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: isRead
                              ? FontWeight.normal
                              : FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        message,
                        style: const TextStyle(
                          color: Colors.white60,
                        ),
                      ),
                      onTap: () async {
                        await doc.reference.update({
                          'isRead': true,
                        });
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}


// =========================
// PARTYCHAT DATA / FIRESTORE
// =========================

class PartyChatData {
  static final FirebaseFirestore db =
      FirebaseFirestore.instance;

  static Future<Map<String, dynamic>> userData(
    String uid,
  ) async {
    final snap = await db.collection('users').doc(uid).get();
    return snap.data() ?? {};
  }

  static String chatId(
    String uid1,
    String uid2,
  ) {
    final ids = [uid1, uid2]..sort();
    return '${ids[0]}_${ids[1]}';
  }

  static Future<bool> isBlockedEither(
    String uid1,
    String uid2,
  ) async {
    final a = await db
        .collection('users')
        .doc(uid1)
        .collection('blockedUsers')
        .doc(uid2)
        .get();

    if (a.exists) return true;

    final b = await db
        .collection('users')
        .doc(uid2)
        .collection('blockedUsers')
        .doc(uid1)
        .get();

    return b.exists;
  }

  static Future<void> blockUser(
    String myUid,
    String otherUid,
  ) async {
    final other = await userData(otherUid);

    await db
        .collection('users')
        .doc(myUid)
        .collection('blockedUsers')
        .doc(otherUid)
        .set({
      'uid': otherUid,
      'name': other['name'] ?? 'Party User',
      'photoURL': other['photoURL'] ?? '',
      'createdAt': FieldValue.serverTimestamp(),
    });

    await db
        .collection('users')
        .doc(myUid)
        .collection('friends')
        .doc(otherUid)
        .delete();
  }

  static Future<void> unblockUser(
    String myUid,
    String otherUid,
  ) async {
    await db
        .collection('users')
        .doc(myUid)
        .collection('blockedUsers')
        .doc(otherUid)
        .delete();
  }

  static Future<void> sendFriendRequest({
    required String recipientUid,
  }) async {
    final current = FirebaseAuth.instance.currentUser;

    if (current == null) return;
    if (current.uid == recipientUid) return;

    if (await isBlockedEither(current.uid, recipientUid)) {
      return;
    }

    final me = await userData(current.uid);

    await db
        .collection('users')
        .doc(recipientUid)
        .collection('friendRequests')
        .doc(current.uid)
        .set({
      'fromUid': current.uid,
      'fromName': me['name'] ?? current.displayName ?? 'Party User',
      'fromPhoto': me['photoURL'] ?? current.photoURL ?? '',
      'createdAt': FieldValue.serverTimestamp(),
    });

    await ProfileUnreadService.createNotification(
      recipientUid: recipientUid,
      badgeKey: 'friendRequests',
      title: 'Friend Request',
      message:
          '${me['name'] ?? 'Someone'} sent you a friend request.',
      actorUid: current.uid,
      actorName: me['name'] ?? 'Party User',
      actorPhoto: me['photoURL'] ?? '',
    );
  }

  static Future<void> acceptFriendRequest({
    required String myUid,
    required String otherUid,
  }) async {
    final me = await userData(myUid);
    final other = await userData(otherUid);

    final batch = db.batch();

    final myFriend = db
        .collection('users')
        .doc(myUid)
        .collection('friends')
        .doc(otherUid);

    final otherFriend = db
        .collection('users')
        .doc(otherUid)
        .collection('friends')
        .doc(myUid);

    batch.set(myFriend, {
      'friendUid': otherUid,
      'name': other['name'] ?? 'Party User',
      'photoURL': other['photoURL'] ?? '',
      'createdAt': FieldValue.serverTimestamp(),
    });

    batch.set(otherFriend, {
      'friendUid': myUid,
      'name': me['name'] ?? 'Party User',
      'photoURL': me['photoURL'] ?? '',
      'createdAt': FieldValue.serverTimestamp(),
    });

    batch.delete(
      db
          .collection('users')
          .doc(myUid)
          .collection('friendRequests')
          .doc(otherUid),
    );

    await batch.commit();

    await ProfileUnreadService.createNotification(
      recipientUid: otherUid,
      badgeKey: 'friends',
      title: 'New Friend',
      message: '${me['name'] ?? 'Party User'} accepted your request.',
      actorUid: myUid,
      actorName: me['name'] ?? 'Party User',
      actorPhoto: me['photoURL'] ?? '',
    );
  }

  static Future<void> rejectFriendRequest({
    required String myUid,
    required String otherUid,
  }) async {
    await db
        .collection('users')
        .doc(myUid)
        .collection('friendRequests')
        .doc(otherUid)
        .delete();

    await ProfileUnreadService.markCategoryRead(
      myUid,
      'friendRequests',
    );
  }

  static Future<void> sendMessage({
    required String recipientUid,
    required String recipientName,
    required String message,
  }) async {
    final current = FirebaseAuth.instance.currentUser;

    if (current == null || message.trim().isEmpty) return;

    if (await isBlockedEither(current.uid, recipientUid)) {
      return;
    }

    final me = await userData(current.uid);
    final id = chatId(current.uid, recipientUid);

    final messageRef = db
        .collection('chats')
        .doc(id)
        .collection('messages')
        .doc();

    final now = FieldValue.serverTimestamp();

    await messageRef.set({
      'fromUid': current.uid,
      'toUid': recipientUid,
      'message': message.trim(),
      'createdAt': now,
    });

    await db
        .collection('users')
        .doc(current.uid)
        .collection('chats')
        .doc(id)
        .set({
      'friendUid': recipientUid,
      'friendName': recipientName,
      'lastMessage': message.trim(),
      'updatedAt': now,
    }, SetOptions(merge: true));

    await db
        .collection('users')
        .doc(recipientUid)
        .collection('chats')
        .doc(id)
        .set({
      'friendUid': current.uid,
      'friendName': me['name'] ?? 'Party User',
      'lastMessage': message.trim(),
      'updatedAt': now,
    }, SetOptions(merge: true));

    await ProfileUnreadService.createNotification(
      recipientUid: recipientUid,
      badgeKey: 'friendMessages',
      title: 'New Message',
      message:
          '${me['name'] ?? 'Party User'} sent you a message.',
      actorUid: current.uid,
      actorName: me['name'] ?? 'Party User',
      actorPhoto: me['photoURL'] ?? '',
      chatId: id,
    );
  }

  static Future<void> sendGift({
    required String recipientUid,
    required String recipientName,
    required int amount,
    required String giftName,
  }) async {
    final current = FirebaseAuth.instance.currentUser;

    if (current == null || amount <= 0) return;

    if (await isBlockedEither(current.uid, recipientUid)) {
      return;
    }

    final me = await userData(current.uid);
    final coins = (me['coins'] is num)
        ? (me['coins'] as num).toInt()
        : 0;

    if (coins < amount) {
      throw Exception('Not enough coins');
    }

    await db.collection('users').doc(current.uid).update({
      'coins': coins - amount,
    });

    final giftData = {
      'fromUid': current.uid,
      'fromName': me['name'] ?? 'Party User',
      'toUid': recipientUid,
      'toName': recipientName,
      'giftName': giftName,
      'amount': amount,
      'createdAt': FieldValue.serverTimestamp(),
    };

    await db
        .collection('users')
        .doc(recipientUid)
        .collection('gifts')
        .add(giftData);

    await db
        .collection('users')
        .doc(current.uid)
        .collection('sentGifts')
        .add(giftData);

    await db.collection('users').doc(recipientUid).set({
      'diamonds': FieldValue.increment(amount),
    }, SetOptions(merge: true));

    await db
        .collection('users')
        .doc(current.uid)
        .collection('transactions')
        .add({
      'type': 'gift',
      'amount': amount,
      'description': 'Gift sent to $recipientName',
      'createdAt': FieldValue.serverTimestamp(),
    });

    await ProfileUnreadService.createNotification(
      recipientUid: recipientUid,
      badgeKey: 'gifts',
      title: 'New Gift',
      message:
          '${me['name'] ?? 'Party User'} sent you $giftName.',
      actorUid: current.uid,
      actorName: me['name'] ?? 'Party User',
      actorPhoto: me['photoURL'] ?? '',
    );

    await ProfileUnreadService.createNotification(
      recipientUid: current.uid,
      badgeKey: 'myGifts',
      title: 'Gift Sent',
      message:
          'You sent $giftName to $recipientName.',
      actorUid: recipientUid,
      actorName: recipientName,
    );
  }

  static Future<void> sendRoomInvite({
    required String recipientUid,
    required String roomId,
    required String roomName,
  }) async {
    final current = FirebaseAuth.instance.currentUser;

    if (current == null) return;

    if (await isBlockedEither(current.uid, recipientUid)) {
      return;
    }

    final me = await userData(current.uid);

    await db
        .collection('users')
        .doc(recipientUid)
        .collection('roomInvites')
        .add({
      'roomId': roomId,
      'roomName': roomName,
      'fromUid': current.uid,
      'fromName': me['name'] ?? 'Party User',
      'createdAt': FieldValue.serverTimestamp(),
    });

    await ProfileUnreadService.createNotification(
      recipientUid: recipientUid,
      badgeKey: 'roomInvites',
      title: 'Room Invite',
      message:
          '${me['name'] ?? 'Party User'} invited you to $roomName.',
      actorUid: current.uid,
      actorName: me['name'] ?? 'Party User',
      actorPhoto: me['photoURL'] ?? '',
      roomId: roomId,
    );
  }
}


// =========================
// UNREAD PROFILE BADGES
// =========================

class ProfileUnreadService {
  static final FirebaseFirestore db =
      FirebaseFirestore.instance;

  static const List<String> keys = [
    'friendRequests',
    'roomInvites',
    'friendMessages',
    'gifts',
    'notifications',
    'myGifts',
    'friends',
  ];

  static DocumentReference<Map<String, dynamic>> stateRef(
    String uid,
  ) {
    return db
        .collection('users')
        .doc(uid)
        .collection('notificationState')
        .doc('profile');
  }

  static Future<void> createNotification({
    required String recipientUid,
    required String badgeKey,
    required String title,
    required String message,
    String? actorUid,
    String? actorName,
    String? actorPhoto,
    String? roomId,
    String? chatId,
  }) async {
    final notificationRef = db
        .collection('users')
        .doc(recipientUid)
        .collection('notifications')
        .doc();

    final state = stateRef(recipientUid);

    final data = <String, dynamic>{
      'type': badgeKey,
      'badgeKey': badgeKey,
      'title': title,
      'message': message,
      'isRead': false,
      'createdAt': FieldValue.serverTimestamp(),
    };

    if (actorUid != null) {
      data['actorUid'] = actorUid;
    }

    if (actorName != null) {
      data['actorName'] = actorName;
    }

    if (actorPhoto != null) {
      data['actorPhoto'] = actorPhoto;
    }

    if (roomId != null) {
      data['roomId'] = roomId;
    }

    if (chatId != null) {
      data['chatId'] = chatId;
    }

    final batch = db.batch();

    batch.set(notificationRef, data);

    batch.set(
      state,
      {
        badgeKey: FieldValue.increment(1),
      },
      SetOptions(merge: true),
    );

    await batch.commit();
  }

  static Future<void> markCategoryRead(
    String uid,
    String key,
  ) async {
    if (!keys.contains(key)) return;

    await stateRef(uid).set(
      {
        key: 0,
      },
      SetOptions(merge: true),
    );

    final docs = await db
        .collection('users')
        .doc(uid)
        .collection('notifications')
        .where('badgeKey', isEqualTo: key)
        .where('isRead', isEqualTo: false)
        .limit(100)
        .get();

    if (docs.docs.isEmpty) return;

    final batch = db.batch();

    for (final doc in docs.docs) {
      batch.update(
        doc.reference,
        {
          'isRead': true,
        },
      );
    }

    await batch.commit();
  }
}


// =========================
// END OF PARTYCHAT
// =========================

  
