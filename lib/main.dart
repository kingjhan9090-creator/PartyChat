    import 'dart:async';
    import 'dart:convert';
    import 'dart:math' as math;

    import 'package:flutter/material.dart';
    import 'package:firebase_core/firebase_core.dart';
    import 'package:firebase_auth/firebase_auth.dart';
    import 'package:google_sign_in/google_sign_in.dart';
    import 'package:cloud_firestore/cloud_firestore.dart';
    import 'package:firebase_storage/firebase_storage.dart';
    import 'package:image_picker/image_picker.dart';
    import 'package:flutter/services.dart';
    import 'package:zego_uikit/zego_uikit.dart';
    import 'package:zego_uikit_prebuilt_live_audio_room/zego_uikit_prebuilt_live_audio_room.dart';

    const int zegoAppId = int.fromEnvironment('ZEGO_APP_ID');
    const String zegoAppSign = String.fromEnvironment('ZEGO_APP_SIGN');

class PartyLoading extends StatefulWidget {
  const PartyLoading({super.key});

  @override
  State<PartyLoading> createState() => _PartyLoadingState();
}

class _PartyLoadingState extends State<PartyLoading>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF050307),
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 74,
            height: 74,
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Stack(
                  alignment: Alignment.center,
                  children: List.generate(12, (index) {
                    final angle =
                        (index * 3.14159265359 * 2 / 12) -
                        (_controller.value * 3.14159265359 * 2);

                    final x = 25 * math.cos(angle);
                    final y = 25 * math.sin(angle);

                    final opacity =
                        0.25 + (0.75 * ((index + 1) / 12));

                    final isGold = index % 3 == 0;

                    return Transform.translate(
                      offset: Offset(x, y),
                      child: Opacity(
                        opacity: opacity.clamp(0.0, 1.0),
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isGold
                                ? const Color(0xFFFFC928)
                                : const Color(0xFFB65CFF),
                            boxShadow: [
                              BoxShadow(
                                color: isGold
                                    ? const Color(0xFFFFC928)
                                    : const Color(0xFFB65CFF),
                                blurRadius: 10,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                );
              },
            ),
          ),
          const SizedBox(height: 18),
          const Text(
            'LOADING...',
            style: TextStyle(
              color: Color(0xFFFFC928),
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 3,
            ),
          ),
        ],
      ),
    );
  }
}




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
          'room_activity': 'রুম কার্যকলাপ',
          'private_account': 'প্রাইভেট অ্যাকাউন্ট',
        },
        'Turkish': {
          'settings': 'Ayarlar',
          'language': 'Dil',
          'privacy': 'Gizlilik',
          'notifications': 'Bildirimler',
          'messages': 'Mesajlar',
          'announcements': 'Duyurular',
          'friends': 'Arkadaşlar',
          'gifts': 'Hediyeler',
          'blocked_users': 'Engellenen Kullanıcılar',
          'home': 'Ana Sayfa',
          'rooms': 'Odalar',
          'games': 'Oyunlar',
          'wallet': 'Cüzdan',
          'profile': 'Profil',
          'join': 'Katıl',
          'login': 'Giriş',
          'create_account': 'Hesap Oluştur',
          'get_started': 'Başla',
          'username': 'Kullanıcı Adı',
          'email': 'E-posta',
          'password': 'Şifre',
          'welcome': 'Hoş Geldiniz',
          'welcome_back': 'Tekrar hoş geldiniz',
          'chat_rooms': 'Sohbet Odaları',
          'popular_rooms': 'Popüler Odalar 🔥',
          'your_balance': 'Bakiyeniz',
          'diamonds': 'Elmaslar',
          'online': 'çevrimiçi',
          'account': 'Hesap',
          'help_center': 'Yardım Merkezi',
          'logout': 'Çıkış',
          'privacy_settings': 'Gizlilik',
          'friend_requests': 'Arkadaşlık İstekleri',
          'room_invites': 'Oda Davetleri',
          'friend_messages': 'Arkadaş Mesajları',
          'my_gifts': 'Hediyelerim',
          'transaction_history': 'İşlem Geçmişi',
          'coins': 'Paralar',
          'recharge': 'Yükle',
          'welcome_to_partychat': 'PartyChat\'e Hoş Geldiniz',
          'chat_play_make_friends': 'Sohbet • Oyna • Arkadaş Edin',
          'change_profile_photo': 'Profil Fotoğrafını Değiştir',
          'choose_avatar': 'Avatar Seç',
          'change_username': 'Kullanıcı Adını Değiştir',
          'save': 'Kaydet',
          'cancel': 'İptal',
          'play_now': 'Şimdi Oyna',
          'my_wallet': 'Cüzdanım',
          'vip_level': 'VIP Seviye 3',
          'online_status': 'Çevrimiçi Durumu',
          'room_activity': 'Oda Aktivitesi',
          'private_account': 'Özel Hesap',
        },
        'Indonesian': {
          'settings': 'Pengaturan',
          'language': 'Bahasa',
          'privacy': 'Privasi',
          'notifications': 'Notifikasi',
          'messages': 'Pesan',
          'announcements': 'Pengumuman',
          'friends': 'Teman',
          'gifts': 'Hadiah',
          'blocked_users': 'Pengguna Diblokir',
          'home': 'Beranda',
          'rooms': 'Ruang',
          'games': 'Game',
          'wallet': 'Dompet',
          'profile': 'Profil',
          'join': 'Gabung',
          'login': 'Masuk',
          'create_account': 'Buat Akun',
          'get_started': 'Mulai',
          'username': 'Nama Pengguna',
          'email': 'Email',
          'password': 'Kata Sandi',
          'welcome': 'Selamat Datang',
          'welcome_back': 'Selamat datang kembali',
          'chat_rooms': 'Ruang Chat',
          'popular_rooms': 'Ruang Populer 🔥',
          'your_balance': 'Saldo Anda',
          'diamonds': 'Berlian',
          'online': 'online',
          'account': 'Akun',
          'help_center': 'Pusat Bantuan',
          'logout': 'Keluar',
          'privacy_settings': 'Privasi',
          'friend_requests': 'Permintaan Teman',
          'room_invites': 'Undangan Ruang',
          'friend_messages': 'Pesan Teman',
          'my_gifts': 'Hadiah Saya',
          'transaction_history': 'Riwayat Transaksi',
          'coins': 'Koin',
          'recharge': 'Isi Ulang',
          'welcome_to_partychat': 'Selamat Datang di PartyChat',
          'chat_play_make_friends': 'Chat • Main • Cari Teman',
          'change_profile_photo': 'Ubah Foto Profil',
          'choose_avatar': 'Pilih Avatar',
          'change_username': 'Ubah Nama Pengguna',
          'save': 'Simpan',
          'cancel': 'Batal',
          'play_now': 'Main Sekarang',
          'my_wallet': 'Dompet Saya',
          'vip_level': 'VIP Level 3',
          'online_status': 'Status Online',
          'room_activity': 'Aktivitas Ruang',
          'private_account': 'Akun Privat',
        },
        'Spanish': {
          'settings': 'Ajustes',
          'language': 'Idioma',
          'privacy': 'Privacidad',
          'notifications': 'Notificaciones',
          'messages': 'Mensajes',
          'announcements': 'Anuncios',
          'friends': 'Amigos',
          'gifts': 'Regalos',
          'blocked_users': 'Usuarios bloqueados',
          'home': 'Inicio',
          'rooms': 'Salas',
          'games': 'Juegos',
          'wallet': 'Billetera',
          'profile': 'Perfil',
          'join': 'Unirse',
          'login': 'Iniciar sesión',
          'create_account': 'Crear cuenta',
          'get_started': 'Comenzar',
          'username': 'Nombre de usuario',
          'email': 'Correo electrónico',
          'password': 'Contraseña',
          'welcome': 'Bienvenido',
          'welcome_back': 'Bienvenido de nuevo',
          'chat_rooms': 'Salas de chat',
          'popular_rooms': 'Salas populares 🔥',
          'your_balance': 'Tu saldo',
          'diamonds': 'Diamantes',
          'online': 'en línea',
          'account': 'Cuenta',
          'help_center': 'Centro de ayuda',
          'logout': 'Cerrar sesión',
          'privacy_settings': 'Privacidad',
          'friend_requests': 'Solicitudes de amistad',
          'room_invites': 'Invitaciones de sala',
          'friend_messages': 'Mensajes de amigos',
          'my_gifts': 'Mis regalos',
          'transaction_history': 'Historial de transacciones',
          'coins': 'Monedas',
          'recharge': 'Recargar',
          'welcome_to_partychat': 'Bienvenido a PartyChat',
          'chat_play_make_friends': 'Chatea • Juega • Haz amigos',
          'change_profile_photo': 'Cambiar foto de perfil',
          'choose_avatar': 'Elegir avatar',
          'change_username': 'Cambiar nombre de usuario',
          'save': 'Guardar',
          'cancel': 'Cancelar',
          'play_now': 'Jugar ahora',
          'my_wallet': 'Mi billetera',
          'vip_level': 'Nivel VIP 3',
          'online_status': 'Estado en línea',
          'room_activity': 'Actividad de sala',
          'private_account': 'Cuenta privada',
        },
        'French': {
          'settings': 'Paramètres',
          'language': 'Langue',
          'privacy': 'Confidentialité',
          'notifications': 'Notifications',
          'messages': 'Messages',
          'announcements': 'Annonces',
          'friends': 'Amis',
          'gifts': 'Cadeaux',
          'blocked_users': 'Utilisateurs bloqués',
          'home': 'Accueil',
          'rooms': 'Salons',
          'games': 'Jeux',
          'wallet': 'Portefeuille',
          'profile': 'Profil',
          'join': 'Rejoindre',
          'login': 'Connexion',
          'create_account': 'Créer un compte',
          'get_started': 'Commencer',
          'username': 'Nom d’utilisateur',
          'email': 'E-mail',
          'password': 'Mot de passe',
          'welcome': 'Bienvenue',
          'welcome_back': 'Bon retour',
          'chat_rooms': 'Salons de discussion',
          'popular_rooms': 'Salons populaires 🔥',
          'your_balance': 'Votre solde',
          'diamonds': 'Diamants',
          'online': 'en ligne',
          'account': 'Compte',
          'help_center': 'Centre d’aide',
          'logout': 'Déconnexion',
          'privacy_settings': 'Confidentialité',
          'friend_requests': 'Demandes d’amis',
          'room_invites': 'Invitations de salon',
          'friend_messages': 'Messages des amis',
          'my_gifts': 'Mes cadeaux',
          'transaction_history': 'Historique des transactions',
          'coins': 'Pièces',
          'recharge': 'Recharger',
          'welcome_to_partychat': 'Bienvenue sur PartyChat',
          'chat_play_make_friends': 'Discutez • Jouez • Faites des amis',
          'change_profile_photo': 'Changer la photo de profil',
          'choose_avatar': 'Choisir un avatar',
          'change_username': 'Changer le nom d’utilisateur',
          'save': 'Enregistrer',
          'cancel': 'Annuler',
          'play_now': 'Jouer maintenant',
          'my_wallet': 'Mon portefeuille',
          'vip_level': 'Niveau VIP 3',
          'online_status': 'Statut en ligne',
          'room_activity': 'Activité du salon',
          'private_account': 'Compte privé',
        },
        'Chinese': {
          'settings': '设置',
          'language': '语言',
          'privacy': '隐私',
          'notifications': '通知',
          'messages': '消息',
          'announcements': '公告',
          'friends': '好友',
          'gifts': '礼物',
          'blocked_users': '已屏蔽用户',
          'home': '首页',
          'rooms': '房间',
          'games': '游戏',
          'wallet': '钱包',
          'profile': '个人资料',
          'join': 'åŠ 入',
          'login': '登录',
          'create_account': '创建账号',
          'get_started': '开始',
          'username': '用户名',
          'email': '邮箱',
          'password': 'å¯†ç ',
          'welcome': '欢迎',
          'welcome_back': '欢迎回来',
          'chat_rooms': '聊天房间',
          'popular_rooms': '热门房间 🔥',
          'your_balance': '您的余额',
          'diamonds': '钻石',
          'online': '在线',
          'account': '账号',
          'help_center': '帮助中心',
          'logout': '退出登录',
          'privacy_settings': '隐私',
          'friend_requests': '好友请求',
          'room_invites': '房间邀请',
          'friend_messages': '好友消息',
          'my_gifts': '我的礼物',
          'transaction_history': '交易记录',
          'coins': '金币',
          'recharge': '充值',
          'welcome_to_partychat': '欢迎来到 PartyChat',
          'chat_play_make_friends': '聊天 • 游戏 • 交朋友',
          'change_profile_photo': '更换头像照片',
          'choose_avatar': '选择头像',
          'change_username': '更改用户名',
          'save': '保存',
          'cancel': '取消',
          'play_now': '立即游戏',
          'my_wallet': '我的钱包',
          'vip_level': 'VIP 等级 3',
          'online_status': '在线状态',
          'room_activity': '房间动态',
          'private_account': '私人账号',
        },
      };

      static String text(String key) {
        return translations[current.value]?[key] ??
            translations['English']?[key] ??
            key;
      }

      static Future<void> load() async {
        final user = FirebaseAuth.instance.currentUser;
        if (user == null) return;

        try {
          final doc = await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get();

          final savedLanguage = doc.data()?['language'];

          if (savedLanguage != null &&
              languages.contains(savedLanguage)) {
            current.value = savedLanguage;
          }
        } catch (e) {
          debugPrint('Language load failed: $e');
        }
      }

      static Future<void> change(String language) async {
        if (!languages.contains(language)) return;

        current.value = language;

        final user = FirebaseAuth.instance.currentUser;
        if (user == null) return;

        try {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .set(
            {'language': language},
            SetOptions(merge: true),
          );
        } catch (e) {
          debugPrint('Language save failed: $e');
        }
      }
    }

    /* ============================================================
       PROFILE UNREAD SYSTEM
       ============================================================ */

    class ProfileUnreadService {
      static const List<String> keys = [
        'friendRequests',
        'roomInvites',
        'friendMessages',
        'gifts',
        'notifications',
        'myGifts',
        'friends',
      ];

      static DocumentReference<Map<String, dynamic>> ref(String uid) {
        return FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('notificationState')
            .doc('profile');
      }

      static Future<void> ensure(String uid) async {
        try {
          final snapshot = await ref(uid).get();
          if (!snapshot.exists) {
            await ref(uid).set({
              for (final key in keys) key: 0,
            });
          }
        } catch (e) {
          debugPrint('Unread state create failed: $e');
        }
      }

      static Future<void> markRead(String uid, String key) async {
        if (!keys.contains(key)) return;
        try {
          await ref(uid).set({key: 0}, SetOptions(merge: true));
          final notifications = FirebaseFirestore.instance
              .collection('users')
              .doc(uid)
              .collection('notifications');
          final snap = await notifications.get();
          final batch = FirebaseFirestore.instance.batch();
          for (final doc in snap.docs) {
            if (doc.data()['isRead'] == false &&
                doc.data()['badgeKey'] == key) {
              batch.update(doc.reference, {
                'isRead': true,
                'readAt': FieldValue.serverTimestamp(),
              });
            }
          }
          await batch.commit();
        } catch (e) {
          debugPrint('Unread mark read failed: $e');
        }
      }

      static Future<void> increment(String uid, String key, {int by = 1}) async {
        if (!keys.contains(key)) return;
        try {
          await ensure(uid);
          await ref(uid).set(
            {key: FieldValue.increment(by)},
            SetOptions(merge: true),
          );
        } catch (e) {
          debugPrint('Unread increment failed: $e');
        }
      }

      static Future<void> createNotification({
        required String uid,
        required String type,
        required String title,
        required String message,
        String? actorUid,
        String? actorName,
        String? actorPhoto,
        String? roomId,
        String? chatId,
      }) async {
        if (!keys.contains(type)) return;
        final userNotifications = FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('notifications');

        final data = <String, dynamic>{
          'type': type,
          'badgeKey': type,
          'title': title,
          'message': message,
          'isRead': false,
          'createdAt': FieldValue.serverTimestamp(),
        };
        if (actorUid != null) data['actorUid'] = actorUid;
        if (actorName != null) data['actorName'] = actorName;
        if (actorPhoto != null) data['actorPhoto'] = actorPhoto;
        if (roomId != null) data['roomId'] = roomId;
        if (chatId != null) data['chatId'] = chatId;

        await userNotifications.add(data);
        await increment(uid, type);
      }
    }




    /* ============================================================
       PARTY CHAT DATA
       ============================================================ */

    class PartyChatData {
      static FirebaseFirestore get db =>
          FirebaseFirestore.instance;

      static DocumentReference<Map<String, dynamic>> userDoc(
        String uid,
      ) =>
          db.collection('users').doc(uid);

      static CollectionReference<Map<String, dynamic>> friends(
        String uid,
      ) =>
          userDoc(uid).collection('friends');

      static CollectionReference<Map<String, dynamic>> blocked(
        String uid,
      ) =>
          userDoc(uid).collection('blockedUsers');

      static CollectionReference<Map<String, dynamic>> friendRequests(
        String uid,
      ) =>
          userDoc(uid).collection('friendRequests');

      static Future<Map<String, dynamic>?> userData(
        String uid,
      ) async {
        final snap = await userDoc(uid).get();

        if (!snap.exists) return null;

        return snap.data();
      }

      /* ============================================================
         FIND USER BY UID / USER ID
         ============================================================ */

      static Future<Map<String, dynamic>?> findUserByUid(
        String search,
      ) async {
        final value = search.trim();

        if (value.isEmpty) return null;

        final directDoc = await userDoc(value).get();

        if (directDoc.exists) {
          final data = directDoc.data();

          if (data != null) {
            return {
              'uid': directDoc.id,
              ...data,
            };
          }
        }

        final snapshot = await db
            .collection('users')
            .where('userId', isEqualTo: value)
            .limit(1)
            .get();

        if (snapshot.docs.isEmpty) {
          return null;
        }

        final doc = snapshot.docs.first;

        return {
          'uid': doc.id,
          ...doc.data(),
        };
      }

      /* ============================================================
         SEARCH USER BY NAME / UID
         ============================================================ */

      static Future<List<Map<String, dynamic>>> searchUsersByName(
        String searchText,
      ) async {
        final search = searchText.trim().toLowerCase();

        if (search.isEmpty) return [];

        final snapshot = await db
            .collection('users')
            .limit(100)
            .get();

        return snapshot.docs
            .where((doc) {
              final data = doc.data();

              final name =
                  (data['name'] ?? '').toString().toLowerCase();

              final userId =
                  (data['userId'] ?? '').toString().toLowerCase();

              final documentId =
                  doc.id.toLowerCase();

              return name.contains(search) ||
                  userId.contains(search) ||
                  documentId.contains(search);
            })
            .map((doc) {
              return {
                'uid': doc.id,
                ...doc.data(),
              };
            })
            .toList();
      }

      /* ============================================================
         FIND USER
         ============================================================ */

      static Future<Map<String, dynamic>?> findUser(
        String search,
      ) async {
        final value = search.trim();

        if (value.isEmpty) return null;

        final uidUser = await findUserByUid(value);

        if (uidUser != null) {
          return uidUser;
        }

        final users = await searchUsersByName(value);

        if (users.isEmpty) {
          return null;
        }

        return users.first;
      }

      /* ============================================================
         BLOCK SYSTEM
         ============================================================ */

      static Future<bool> isBlockedEither(
        String a,
        String b,
      ) async {
        final aBlocksB =
            await blocked(a).doc(b).get();

        if (aBlocksB.exists) {
          return true;
        }

        final bBlocksA =
            await blocked(b).doc(a).get();

        return bBlocksA.exists;
      }

      static Future<void> blockUser({
        required String uid,
        required String otherUid,
        required Map<String, dynamic> otherData,
      }) async {
        await blocked(uid).doc(otherUid).set({
          'name': otherData['name'] ?? 'Party User',
          'email': otherData['email'] ?? '',
          'photoURL': otherData['photoURL'] ?? '',
          'photoBase64': otherData['photoBase64'] ?? '',
          'avatar': otherData['avatar'] ?? '',
          'createdAt': FieldValue.serverTimestamp(),
        });

        await friends(uid)
            .doc(otherUid)
            .delete();

        await friends(otherUid)
            .doc(uid)
            .delete();

        await friendRequests(otherUid)
            .doc(uid)
            .delete();

        await friendRequests(uid)
            .doc(otherUid)
            .delete();
      }

      static Future<void> unblockUser(
        String uid,
        String otherUid,
      ) async {
        await blocked(uid)
            .doc(otherUid)
            .delete();
      }

      /* ============================================================
         SEND FRIEND REQUEST
         ============================================================ */

      static Future<void> sendFriendRequest({
        required String fromUid,
        required String toUid,
      }) async {
        final senderUid = fromUid.trim();
        final receiverUid = toUid.trim();

        if (senderUid.isEmpty ||
            receiverUid.isEmpty) {
          throw Exception(
            'Invalid user ID.',
          );
        }

        if (senderUid == receiverUid) {
          throw Exception(
            'You cannot send a friend request to yourself.',
          );
        }

        final receiver =
            await userDoc(receiverUid).get();

        if (!receiver.exists) {
          throw Exception(
            'User not found.',
          );
        }

        if (await isBlockedEither(
          senderUid,
          receiverUid,
        )) {
          throw Exception(
            'This user is blocked.',
          );
        }

        final existingFriend =
            await friends(senderUid)
                .doc(receiverUid)
                .get();

        if (existingFriend.exists) {
          throw Exception(
            'This user is already your friend.',
          );
        }

        final existingRequest =
            await friendRequests(receiverUid)
                .doc(senderUid)
                .get();

        if (existingRequest.exists) {
          throw Exception(
            'Friend request has already been sent.',
          );
        }

        final reverseRequest =
            await friendRequests(senderUid)
                .doc(receiverUid)
                .get();

        if (reverseRequest.exists) {
          throw Exception(
            'This user has already sent you a friend request.',
          );
        }

        final fromData =
            await userData(senderUid) ?? {};

        await friendRequests(receiverUid)
            .doc(senderUid)
            .set({
          'requesterUid': senderUid,
          'uid': senderUid,
          'name':
              fromData['name'] ?? 'Party User',
          'email':
              fromData['email'] ?? '',
          'photoURL':
              fromData['photoURL'] ?? '',
          'photoBase64':
              fromData['photoBase64'] ?? '',
          'avatar':
              fromData['avatar'] ?? '',
          'status': 'pending',
          'createdAt':
              FieldValue.serverTimestamp(),
        });

        await ProfileUnreadService.createNotification(
          uid: receiverUid,
          type: 'friendRequests',
          title: 'New Friend Request',
          message:
              '${fromData['name'] ?? 'Someone'} sent you a friend request.',
          actorUid: senderUid,
          actorName:
              fromData['name'] ?? 'Party User',
          actorPhoto:
              fromData['photoURL'] ?? '',
        );
      }

      /* ============================================================
         ACCEPT FRIEND REQUEST
         ============================================================ */

      static Future<void> acceptFriendRequest({
        required String uid,
        required String requesterUid,
      }) async {
        if (await isBlockedEither(
          uid,
          requesterUid,
        )) {
          throw Exception(
            'You cannot add a blocked user as a friend.',
          );
        }

        final me =
            await userData(uid) ?? {};

        final other =
            await userData(requesterUid) ?? {};

        final batch = db.batch();

        final myFriendRef =
            friends(uid).doc(requesterUid);

        final otherFriendRef =
            friends(requesterUid).doc(uid);

        batch.set(
          myFriendRef,
          {
            'uid': requesterUid,
            'name':
                other['name'] ?? 'Party User',
            'email':
                other['email'] ?? '',
            'photoURL':
                other['photoURL'] ?? '',
            'photoBase64':
                other['photoBase64'] ?? '',
            'avatar':
                other['avatar'] ?? '',
            'createdAt':
                FieldValue.serverTimestamp(),
          },
        );

        batch.set(
          otherFriendRef,
          {
            'uid': uid,
            'name':
                me['name'] ?? 'Party User',
            'email':
                me['email'] ?? '',
            'photoURL':
                me['photoURL'] ?? '',
            'photoBase64':
                me['photoBase64'] ?? '',
            'avatar':
                me['avatar'] ?? '',
            'createdAt':
                FieldValue.serverTimestamp(),
          },
        );

        batch.delete(
          friendRequests(uid)
              .doc(requesterUid),
        );

        await batch.commit();

        await ProfileUnreadService.createNotification(
          uid: requesterUid,
          type: 'friends',
          title: 'Friend Request Accepted',
          message:
              '${me['name'] ?? 'Party User'} accepted your friend request.',
          actorUid: uid,
          actorName:
              me['name'] ?? 'Party User',
          actorPhoto:
              me['photoURL'] ?? '',
        );
      }

      /* ============================================================
         REJECT FRIEND REQUEST
         ============================================================ */

      static Future<void> rejectFriendRequest({
        required String uid,
        required String requesterUid,
      }) async {
        await friendRequests(uid)
            .doc(requesterUid)
            .delete();
      }

      /* ============================================================
         REMOVE FRIEND
         ============================================================ */

      static Future<void> removeFriend({
        required String uid,
        required String otherUid,
      }) async {
        final batch = db.batch();

        batch.delete(
          friends(uid).doc(otherUid),
        );

        batch.delete(
          friends(otherUid).doc(uid),
        );

        await batch.commit();
      }

      /* ============================================================
         FRIEND REQUEST STREAM
         ============================================================ */

      static Stream<QuerySnapshot<Map<String, dynamic>>>
          friendRequestsStream(
        String uid,
      ) {
        return friendRequests(uid)
            .where(
              'status',
              isEqualTo: 'pending',
            )
            .snapshots();
      }

      /* ============================================================
         FRIENDS STREAM
         ============================================================ */

      static Stream<QuerySnapshot<Map<String, dynamic>>>
          friendsStream(
        String uid,
      ) {
        return friends(uid).snapshots();
      }

      /* ============================================================
         PRIVATE CHAT
         ============================================================ */

      static String chatId(
        String a,
        String b,
      ) {
        final ids = [a, b]..sort();

        return '${ids[0]}_${ids[1]}';
      }

      static Future<void> sendMessage({
        required String fromUid,
        required String toUid,
        required String text,
      }) async {
        final clean = text.trim();

        if (clean.isEmpty) return;

        if (await isBlockedEither(
          fromUid,
          toUid,
        )) {
          throw Exception(
            'Messaging is blocked.',
          );
        }

        final id =
            chatId(fromUid, toUid);

        final fromData =
            await userData(fromUid) ?? {};

        final chat =
            db.collection('chats').doc(id);

        await chat
            .collection('messages')
            .add({
          'senderUid': fromUid,
          'receiverUid': toUid,
          'text': clean,
          'createdAt':
              FieldValue.serverTimestamp(),
          'isRead': false,
        });

        await userDoc(toUid)
            .collection('chats')
            .doc(id)
            .set(
          {
            'chatId': id,
            'otherUid': fromUid,
            'lastMessage': clean,
            'lastMessageAt':
                FieldValue.serverTimestamp(),
          },
          SetOptions(merge: true),
        );

        await userDoc(fromUid)
            .collection('chats')
            .doc(id)
            .set(
          {
            'chatId': id,
            'otherUid': toUid,
            'lastMessage': clean,
            'lastMessageAt':
                FieldValue.serverTimestamp(),
          },
          SetOptions(merge: true),
        );

        await ProfileUnreadService.createNotification(
          uid: toUid,
          type: 'friendMessages',
          title: 'New Message',
          message:
              '${fromData['name'] ?? 'Friend'}: $clean',
          actorUid: fromUid,
          actorName:
              fromData['name'] ?? 'Party User',
          actorPhoto:
              fromData['photoURL'] ?? '',
          chatId: id,
        );
      }

      /* ============================================================
         GIFTS
         ============================================================ */

      static Future<void> sendGift({
        required String fromUid,
        required String toUid,
        required String giftName,
        required int cost,
      }) async {
        if (fromUid == toUid) {
          throw Exception(
            'You cannot send a gift to yourself.',
          );
        }

        if (await isBlockedEither(
          fromUid,
          toUid,
        )) {
          throw Exception(
            'Gifts are blocked.',
          );
        }

        final senderRef =
            userDoc(fromUid);

        final receiverRef =
            userDoc(toUid);

        final senderData =
            await senderRef.get();

        final receiverData =
            await receiverRef.get();

        final sender =
            senderData.data() ?? {};

        final receiver =
            receiverData.data() ?? {};

        final coins =
            sender['coins'] is num
                ? (sender['coins'] as num).toInt()
                : 0;

        if (coins < cost) {
          throw Exception(
            'Not enough coins.',
          );
        }

        final giftRef =
            receiverRef
                .collection('gifts')
                .doc();

        final sentRef =
            senderRef
                .collection('sentGifts')
                .doc();

        final batch = db.batch();

        batch.update(
          senderRef,
          {
            'coins': coins - cost,
          },
        );

        final giftData = {
          'giftName': giftName,
          'cost': cost,
          'senderUid': fromUid,
          'senderName':
              sender['name'] ?? 'Party User',
          'receiverUid': toUid,
          'receiverName':
              receiver['name'] ?? 'Party User',
          'createdAt':
              FieldValue.serverTimestamp(),
        };

        batch.set(
          giftRef,
          giftData,
        );

        batch.set(
          sentRef,
          giftData,
        );

        batch.set(
          senderRef
              .collection('transactions')
              .doc(),
          {
            'type': 'gift_sent',
            'amount': -cost,
            'giftName': giftName,
            'createdAt':
                FieldValue.serverTimestamp(),
          },
        );

        await batch.commit();

        await ProfileUnreadService.createNotification(
          uid: toUid,
          type: 'gifts',
          title: 'New Gift 🎁',
          message:
              '${sender['name'] ?? 'Party User'} sent you $giftName.',
          actorUid: fromUid,
          actorName:
              sender['name'] ?? 'Party User',
          actorPhoto:
              sender['photoURL'] ?? '',
        );

        await ProfileUnreadService.createNotification(
          uid: fromUid,
          type: 'myGifts',
          title: 'Gift Sent 🎁',
          message:
              'You sent $giftName successfully.',
          actorUid: toUid,
          actorName:
              receiver['name'] ?? 'Party User',
          actorPhoto:
              receiver['photoURL'] ?? '',
        );
      }

      /* ============================================================
         ROOM INVITE
         ============================================================ */

      static Future<void> sendRoomInvite({
        required String fromUid,
        required String toUid,
        required String roomId,
        required String roomTitle,
      }) async {
        if (await isBlockedEither(
          fromUid,
          toUid,
        )) {
          throw Exception(
            'Invites are blocked.',
          );
        }

        final fromData =
            await userData(fromUid) ?? {};

        final inviteRef =
            userDoc(toUid)
                .collection('roomInvites')
                .doc();

        await inviteRef.set({
          'roomId': roomId,
          'roomTitle': roomTitle,
          'inviterUid': fromUid,
          'inviterName':
              fromData['name'] ?? 'Party User',
          'inviterPhoto':
              fromData['photoURL'] ?? '',
          'inviterPhotoBase64':
              fromData['photoBase64'] ?? '',
          'status': 'pending',
          'createdAt':
              FieldValue.serverTimestamp(),
        });

        await ProfileUnreadService.createNotification(
          uid: toUid,
          type: 'roomInvites',
          title: 'Room Invite',
          message:
              '${fromData['name'] ?? 'Party User'} sent you a room invitation.',
          actorUid: fromUid,
          actorName:
              fromData['name'] ?? 'Party User',
          actorPhoto:
              fromData['photoURL'] ?? '',
          roomId: roomId,
        );
      }
    }







        
          
    /* ============================================================
       APP
       ============================================================ */

    class PartyColors {
      static const black = Color(0xFF050307);
      static const black2 = Color(0xFF0C0814);
      static const panel = Color(0xFF151020);
      static const panel2 = Color(0xFF20152F);
      static const purple = Color(0xFF7A2CFF);
      static const purpleBright = Color(0xFFB65CFF);
      static const purpleDark = Color(0xFF42137D);
      static const gold = Color(0xFFFFC928);
      static const goldBright = Color(0xFFFFE47A);
      static const goldDark = Color(0xFFB97900);
      static const text = Color(0xFFFFFBF1);
      static const muted = Color(0xFFB8AEC6);
    }

    class PartyLogo extends StatelessWidget {
      final double size;
      final bool wordmark;
      const PartyLogo({super.key, this.size = 110, this.wordmark = true});

      @override
      Widget build(BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(width: size, height: size, child: CustomPaint(painter: _PartyLogoPainter())),
            if (wordmark) ...[
              const SizedBox(height: 10),
              RichText(
                text: const TextSpan(
                  style: TextStyle(fontSize: 31, fontWeight: FontWeight.w900),
                  children: [
                    TextSpan(text: 'Party', style: TextStyle(color: PartyColors.gold)),
                    TextSpan(text: 'Chat', style: TextStyle(color: PartyColors.purpleBright)),
                  ],
                ),
              ),
            ],
          ],
        );
      }
    }

    class _PartyLogoPainter extends CustomPainter {
      @override
      void paint(Canvas canvas, Size size) {
        final c = size.center(Offset.zero);
        final scale = size.width / 120.0;
        canvas.save();
        canvas.translate(c.dx, c.dy);
        canvas.scale(scale);

        final glow = Paint()
          ..color = PartyColors.gold.withOpacity(.18)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 14);
        canvas.drawCircle(Offset.zero, 39, glow);

        final crown = Paint()..color = PartyColors.gold..style = PaintingStyle.fill;
        final crownPath = Path()
          ..moveTo(-30, -28)..lineTo(-21, -6)..lineTo(-8, -27)..lineTo(0, -4)
          ..lineTo(10, -27)..lineTo(21, -6)..lineTo(30, -28)..lineTo(24, 2)
          ..lineTo(-24, 2)..close();
        canvas.drawPath(crownPath, crown);

        final bubble = Paint()..color = PartyColors.black..style = PaintingStyle.fill;
        final bubbleBorder = Paint()
          ..color = PartyColors.gold
          ..style = PaintingStyle.stroke
          ..strokeWidth = 5;
        final r = RRect.fromRectAndRadius(
          const Rect.fromLTWH(-39, -9, 78, 58),
          const Radius.circular(25),
        );
        canvas.drawRRect(r, bubble);
        canvas.drawRRect(r, bubbleBorder);

        final dot = Paint()..color = PartyColors.gold;
        canvas.drawCircle(const Offset(-16, 19), 5, dot);
        canvas.drawCircle(const Offset(0, 19), 5, dot);
        canvas.drawCircle(const Offset(16, 19), 5, dot);
        canvas.restore();
      }

      @override
      bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
    }

    class PartyAvatarShowcase extends StatelessWidget {
      const PartyAvatarShowcase({super.key});

      Widget avatar(String asset, double size) {
        return Container(
          width: size + 8,
          height: size + 8,
          padding: const EdgeInsets.all(3),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(colors: [PartyColors.gold, PartyColors.purpleBright]),
            boxShadow: [BoxShadow(color: Color(0x66B65CFF), blurRadius: 18, spreadRadius: 2)],
          ),
          child: ClipOval(child: Image.asset(asset, fit: BoxFit.cover)),
        );
      }

      @override
      Widget build(BuildContext context) {
        return SizedBox(
          height: 205,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Positioned(bottom: 0, left: 18, child: avatar('assets/avatar1_pakistan_female-2.png', 92)),
              Positioned(bottom: 0, right: 18, child: avatar('assets/avatar4_russia_female.png', 92)),
              Positioned(bottom: 3, child: avatar('assets/avatar2_uae_male.png', 132)),
            ],
          ),
        );
      }
    }

    String partyMessageTime(dynamic value) {
      if (value is Timestamp) {
        final d = value.toDate().toLocal();
        final hour = d.hour % 12 == 0 ? 12 : d.hour % 12;
        final minute = d.minute.toString().padLeft(2, '0');
        final suffix = d.hour >= 12 ? 'PM' : 'AM';
        return '$hour:$minute $suffix';
      }
      return '--:--';
    }

    class PartyChatApp extends StatefulWidget {
      const PartyChatApp({super.key});

      @override
      State<PartyChatApp> createState() => _PartyChatAppState();
    }

    class _PartyChatAppState extends State<PartyChatApp> {
      @override
      void initState() {
        super.initState();

        AppLanguage.current.addListener(_languageChanged);
        AppLanguage.load();
      }

      void _languageChanged() {
        if (mounted) {
          setState(() {});
        }
      }

      @override
      void dispose() {
        AppLanguage.current.removeListener(_languageChanged);
        super.dispose();
      }

      @override
      Widget build(BuildContext context) {
        return ValueListenableBuilder<String>(
          valueListenable: AppLanguage.current,
          builder: (context, language, child) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'PartyChat',
              theme: ThemeData(
                brightness: Brightness.dark,
                scaffoldBackgroundColor: PartyColors.black,
                canvasColor: PartyColors.black,
                colorScheme: const ColorScheme.dark(
                  primary: PartyColors.gold,
                  secondary: PartyColors.purpleBright,
                  surface: PartyColors.panel,
                  onPrimary: Colors.black,
                  onSecondary: Colors.white,
                ),
                navigationBarTheme: NavigationBarThemeData(
                  backgroundColor: PartyColors.black2,
                  indicatorColor: PartyColors.purpleDark,
                  height: 76,
                  iconTheme: WidgetStateProperty.resolveWith((states) => IconThemeData(
                    color: states.contains(WidgetState.selected) ? PartyColors.gold : Colors.white70,
                  )),
                  labelTextStyle: WidgetStateProperty.resolveWith((states) => TextStyle(
                    color: states.contains(WidgetState.selected) ? PartyColors.gold : Colors.white70,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                  )),
                ),
                appBarTheme: const AppBarTheme(
                  backgroundColor: PartyColors.black,
                  elevation: 0,
                  centerTitle: false,
                  foregroundColor: PartyColors.text,
                  titleTextStyle: TextStyle(color: PartyColors.text, fontSize: 20, fontWeight: FontWeight.w900),
                ),
                inputDecorationTheme: InputDecorationTheme(
                  filled: true,
                  fillColor: PartyColors.black2,
                  labelStyle: const TextStyle(color: Colors.white70),
                  hintStyle: const TextStyle(color: Colors.white54),
                  prefixIconColor: PartyColors.gold,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(18)),
                    borderSide: BorderSide(color: PartyColors.purpleDark),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(18)),
                    borderSide: BorderSide(color: Color(0xFF46345D)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(18)),
                    borderSide: BorderSide(color: PartyColors.gold, width: 1.6),
                  ),
                ),
                filledButtonTheme: FilledButtonThemeData(
                  style: FilledButton.styleFrom(
                    backgroundColor: PartyColors.gold,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                    textStyle: const TextStyle(fontWeight: FontWeight.w900),
                  ),
                ),
                useMaterial3: true,
              ),
              home: const SplashPage(),
            );
          },
        );
      }
    }

    class _NeonBackground extends StatelessWidget {
      final Widget child;
      final bool scrollable;
      const _NeonBackground({required this.child, this.scrollable = false});

      @override
      Widget build(BuildContext context) {
        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [PartyColors.black, Color(0xFF090512), PartyColors.black],
            ),
          ),
          child: Stack(
            children: [
              Positioned(top: -100, left: -110, child: _GlowOrb(size: 300, color: PartyColors.purple)),
              Positioned(top: 40, right: -150, child: _GlowOrb(size: 340, color: PartyColors.gold)),
              Positioned(bottom: -170, left: -80, child: _GlowOrb(size: 330, color: PartyColors.purpleBright)),
              Positioned(bottom: -130, right: -120, child: _GlowOrb(size: 280, color: PartyColors.goldDark)),
              child,
            ],
          ),
        );
      }
    }

    class _GlowOrb extends StatelessWidget {
      final double size;
      final Color color;
      const _GlowOrb({required this.size, required this.color});

      @override
      Widget build(BuildContext context) {
        return IgnorePointer(
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withOpacity(.035),
              boxShadow: [BoxShadow(color: color.withOpacity(.16), blurRadius: 115, spreadRadius: 25)],
            ),
          ),
        );
      }
    }

    class _NeonPanel extends StatelessWidget {
      final Widget child;
      final EdgeInsetsGeometry padding;
      final double radius;
      const _NeonPanel({required this.child, this.padding = const EdgeInsets.all(16), this.radius = 20});

      @override
      Widget build(BuildContext context) {
        return Container(
          padding: padding,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [PartyColors.panel2, PartyColors.black2],
            ),
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(color: PartyColors.gold.withOpacity(.62), width: 1.1),
            boxShadow: const [BoxShadow(color: Color(0x553F00A8), blurRadius: 22, spreadRadius: 1)],
          ),
          child: child,
        );
      }
    }

    class _NeonAction extends StatelessWidget {
      final String label;
      final VoidCallback onPressed;
      final IconData? icon;
      const _NeonAction({required this.label, required this.onPressed, this.icon});

      @override
      Widget build(BuildContext context) {
        return Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(18)),
            gradient: LinearGradient(colors: [PartyColors.gold, PartyColors.goldBright]),
            boxShadow: [BoxShadow(color: Color(0x66FFB800), blurRadius: 18, spreadRadius: 1)],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(18),
              onTap: onPressed,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (icon != null) ...[
                      Icon(icon, size: 18, color: Colors.black),
                      const SizedBox(width: 7),
                    ],
                    Text(label, style: const TextStyle(fontWeight: FontWeight.w900, color: Colors.black)),
                  ],
                ),
              ),
            ),
          ),
        );
      }
    }

    /* ============================================================
       SPLASH
       ============================================================ */

    class SplashPage extends StatefulWidget {
      const SplashPage({super.key});
      @override
      State<SplashPage> createState() => _SplashPageState();
    }

    class _SplashPageState extends State<SplashPage> {
      @override
      void initState() {
        super.initState();
        Future.delayed(const Duration(seconds: 2), () async {
          if (!mounted) return;
          final user = FirebaseAuth.instance.currentUser;
          if (user != null) {
            await AppLanguage.load();
            await ProfileUnreadService.ensure(user.uid);
          }
          if (!mounted) return;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => user != null ? const MainPage() : const WelcomePage()),
          );
        });
      }

      @override
      Widget build(BuildContext context) {
        return Scaffold(
          body: _NeonBackground(
            child: SafeArea(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const PartyLogo(size: 128),
                      const SizedBox(height: 10),
                      Text(
                        AppLanguage.text('chat_play_make_friends'),
                        style: const TextStyle(color: PartyColors.text, fontSize: 15, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'GOOD VIBES ONLY',
                        style: TextStyle(
                          letterSpacing: 4,
                          color: PartyColors.goldBright,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 28),
                      SizedBox(
                        width: 140,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: const LinearProgressIndicator(
                            minHeight: 5,
                            backgroundColor: PartyColors.purpleDark,
                            valueColor: AlwaysStoppedAnimation<Color>(PartyColors.gold),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'LOADING...',
                        style: TextStyle(letterSpacing: 3.2, color: PartyColors.goldBright, fontWeight: FontWeight.w800, fontSize: 11),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }
    }

    /* ============================================================
       WELCOME
       ============================================================ */

    class WelcomePage extends StatelessWidget {
      const WelcomePage({super.key});

      @override
      Widget build(BuildContext context) {
        return Scaffold(
          body: _NeonBackground(
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(22, 30, 22, 22),
                child: Column(
                  children: [
                    const Spacer(flex: 2),
                    const PartyLogo(size: 88),
                    const SizedBox(height: 14),
                    const PartyAvatarShowcase(),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: _NeonAction(
                        label: AppLanguage.text('get_started'),
                        icon: Icons.arrow_forward_rounded,
                        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginPage())),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                          side: const BorderSide(color: PartyColors.gold, width: 1.3),
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginPage())),
                        child: Text(AppLanguage.text('login'), style: const TextStyle(fontWeight: FontWeight.w900)),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(AppLanguage.text('welcome_to_partychat'), style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    Text(AppLanguage.text('chat_play_make_friends'), style: const TextStyle(color: PartyColors.purpleBright, fontSize: 13)),
                    const Spacer(),
                  ],
                ),
              ),
            ),
          ),
        );
      }
    }

    /* ============================================================
       LOGIN
       ============================================================ */

    class LoginPage extends StatefulWidget {
      const LoginPage({super.key});

      @override
      State<LoginPage> createState() => _LoginPageState();
    }

    class _LoginPageState extends State<LoginPage> {
      bool signup = false;
      Future<String> generateUniqueUserId() async {
      final random = math.Random();
      final usersRef = FirebaseFirestore.instance.collection('users');

      while (true) {
        final userId =
            (100000 + random.nextInt(900000)).toString();

        final existing = await usersRef
            .where('userId', isEqualTo: userId)
            .limit(1)
            .get();

        if (existing.docs.isEmpty) {
          return userId;
        }
      }
      }
      bool obscurePassword = true;

      final nameController = TextEditingController();
      final emailController = TextEditingController();
      final passwordController = TextEditingController();

      @override
      void dispose() {
        nameController.dispose();
        emailController.dispose();
        passwordController.dispose();
        super.dispose();
      }

      Future<void> continueToApp() async {
        final email = emailController.text.trim();
        final password = passwordController.text.trim();
        final name = nameController.text.trim();

        if (email.isEmpty || password.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Email and password are required.',
              ),
            ),
          );
          return;
        }

        if (signup && (name.length < 3 || name.length > 20)) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Username must be 3 to 20 characters long.',
              ),
            ),
          );
          return;
        }

        try {
          UserCredential credential;

          if (signup) {
            credential = await FirebaseAuth.instance
                .createUserWithEmailAndPassword(
              email: email,
              password: password,
            );

            final user = credential.user;

            if (user != null) {
              final userId = await generateUniqueUserId();
              await user.updateDisplayName(name);

              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(user.uid)
                  .set(
                {
                  'name': name,
                  'email': email,
                  'userId': userId,
                  'photoURL': '',
                  'language': AppLanguage.current.value,
                  'coins': 12580,
                  'diamonds': 2450,
                  'createdAt': FieldValue.serverTimestamp(),
                },
                SetOptions(merge: true),
              );

              await ProfileUnreadService.ensure(user.uid);
            }
          } else {
            credential = await FirebaseAuth.instance
                .signInWithEmailAndPassword(
              email: email,
              password: password,
            );

            await AppLanguage.load();

            final user = credential.user;
            if (user != null) {
              await ProfileUnreadService.ensure(user.uid);
            }
          }

          if (!mounted) return;

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => const MainPage(),
            ),
          );
        } catch (e) {
          if (!mounted) return;

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(e.toString()),
            ),
          );
        }
      }

      Future<void> continueWithGoogle() async {
        try {
          final GoogleSignInAccount? googleUser =
              await GoogleSignIn(
            serverClientId:
                '921954130312-51u4nsu0f1eqsssei3ph1o12hkunfomu.apps.googleusercontent.com',
          ).signIn();

          if (googleUser == null) return;

          final GoogleSignInAuthentication googleAuth =
              await googleUser.authentication;

          final credential = GoogleAuthProvider.credential(
            accessToken: googleAuth.accessToken,
            idToken: googleAuth.idToken,
          );

          final userCredential =
              await FirebaseAuth.instance.signInWithCredential(
            credential,
          );

          final user = userCredential.user;

          if (user != null) {
            await FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .set(
              {
                'name': user.displayName ?? '',
                'email': user.email ?? '',
                'photoURL': user.photoURL ?? '',
                'language': AppLanguage.current.value,
                'createdAt': FieldValue.serverTimestamp(),
              },
              SetOptions(merge: true),
            );

            await ProfileUnreadService.ensure(user.uid);
          }

          if (!mounted) return;

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => const MainPage(),
            ),
          );
        } catch (e) {
          if (!mounted) return;

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(e.toString()),
            ),
          );
        }
      }

      @override
      Widget build(BuildContext context) {
        return Scaffold(
          body: _NeonBackground(
            child: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(22, 22, 22, 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 10),
                    const Center(child: PartyLogo(size: 76)),
                    const SizedBox(height: 12),
                    const Center(
                      child: Text(
                        'Welcome to PartyChat',
                        style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w600),
                      ),
                    ),
                    const SizedBox(height: 22),
                    Row(
                      children: [
                        Expanded(
                          child: FilledButton(
                            onPressed: () => setState(() => signup = false),
                            child: const Text('Login'),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: PartyColors.purpleBright),
                              foregroundColor: Colors.white,
                            ),
                            onPressed: () => setState(() => signup = true),
                            child: const Text('Sign Up'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      height: 52,
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: PartyColors.gold),
                          foregroundColor: PartyColors.text,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                        ),
                        onPressed: continueWithGoogle,
                        icon: const Icon(Icons.g_mobiledata, size: 30, color: PartyColors.gold),
                        label: const Text('Continue with Google'),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 52,
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: PartyColors.purpleDark),
                          foregroundColor: PartyColors.text,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                        ),
                        onPressed: () {},
                        icon: const Icon(Icons.facebook, color: PartyColors.purpleBright),
                        label: const Text('Continue with Facebook'),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 52,
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: PartyColors.purpleDark),
                          foregroundColor: PartyColors.text,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                        ),
                        onPressed: () {},
                        icon: const Icon(Icons.close, color: PartyColors.gold),
                        label: const Text('Continue with Twitter / X'),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 52,
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: PartyColors.purpleDark),
                          foregroundColor: PartyColors.text,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                        ),
                        onPressed: () {},
                        icon: const Icon(Icons.phone_android, color: PartyColors.gold),
                        label: const Text('Continue with Mobile Number'),
                      ),
                    ),
                    const SizedBox(height: 20),
                    if (signup)
                      TextField(
                        controller: nameController,
                        maxLength: 20,
                        decoration: InputDecoration(
                          labelText: AppLanguage.text('username'),
                          prefixIcon: const Icon(Icons.person),
                        ),
                      ),
                    if (signup) const SizedBox(height: 14),
                    TextField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: AppLanguage.text('email'),
                        prefixIcon: const Icon(Icons.email),
                      ),
                    ),
                    const SizedBox(height: 14),
                    TextField(
                      controller: passwordController,
                      obscureText: obscurePassword,
                      decoration: InputDecoration(
                        labelText: AppLanguage.text('password'),
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(obscurePassword ? Icons.visibility : Icons.visibility_off),
                          onPressed: () => setState(() => obscurePassword = !obscurePassword),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    SizedBox(
                      height: 52,
                      child: _NeonAction(
                        label: signup ? AppLanguage.text('create_account') : AppLanguage.text('login'),
                        onPressed: continueToApp,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: () => setState(() => signup = true),
                      child: const Text('Create New Account', style: TextStyle(color: PartyColors.goldBright, fontWeight: FontWeight.w700)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }
    }

    /* ============================================================
       MAIN PAGE
       ============================================================ */

    class MainPage extends StatefulWidget {
      const MainPage({super.key});
      @override
      State<MainPage> createState() => _MainPageState();
    }

    class _MainPageState extends State<MainPage> {
      int selected = 0;
      bool switchingTab = false;
      Timer? _tabTimer;
      final pages = const [HomeTab(), RoomsTab(), GamesTab(), WalletTab(), ProfileTab()];

      @override
      void dispose() {
        _tabTimer?.cancel();
        super.dispose();
      }

      void _selectTab(int value) {
        if (value == selected || switchingTab) return;
        setState(() => switchingTab = true);
        _tabTimer?.cancel();
        _tabTimer = Timer(const Duration(seconds: 1), () {
          if (!mounted) return;
          setState(() {
            selected = value;
            switchingTab = false;
          });
        });
      }

      @override
      Widget build(BuildContext context) {
        return Scaffold(
          extendBody: true,
          body: Stack(
            children: [
              SafeArea(bottom: false, child: pages[selected]),
              IgnorePointer(
                ignoring: !switchingTab,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 160),
                  opacity: switchingTab ? 1 : 0,
                  child: const Align(alignment: Alignment.topCenter, child: _PartyTabLoadingBar()),
                ),
              ),
            ],
          ),
          bottomNavigationBar: NavigationBar(
            selectedIndex: selected,
            onDestinationSelected: _selectTab,
            destinations: [
              NavigationDestination(icon: const Icon(Icons.home_outlined), selectedIcon: const Icon(Icons.home), label: AppLanguage.text('home')),
              NavigationDestination(icon: const Icon(Icons.forum_outlined), selectedIcon: const Icon(Icons.forum), label: AppLanguage.text('rooms')),
              NavigationDestination(icon: const Icon(Icons.sports_esports_outlined), selectedIcon: const Icon(Icons.sports_esports), label: AppLanguage.text('games')),
              NavigationDestination(icon: const Icon(Icons.account_balance_wallet_outlined), selectedIcon: const Icon(Icons.account_balance_wallet), label: AppLanguage.text('wallet')),
              NavigationDestination(icon: const Icon(Icons.person_outline), selectedIcon: const Icon(Icons.person), label: AppLanguage.text('profile')),
            ],
          ),
        );
      }
    }

    class _PartyTabLoadingBar extends StatefulWidget {
      const _PartyTabLoadingBar();
      @override
      State<_PartyTabLoadingBar> createState() => _PartyTabLoadingBarState();
    }

    class _PartyTabLoadingBarState extends State<_PartyTabLoadingBar> with SingleTickerProviderStateMixin {
      late final AnimationController _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 850))..repeat(reverse: true);
      @override
      void dispose() { _controller.dispose(); super.dispose(); }
      @override
      Widget build(BuildContext context) {
        return SizedBox(
          height: 4,
          width: double.infinity,
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) => FractionallySizedBox(
              alignment: Alignment(-1 + (_controller.value * 2), 0),
              widthFactor: .42,
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(colors: [PartyColors.purpleBright, Color(0xFFFFC83D), PartyColors.purpleBright]),
                  boxShadow: [BoxShadow(color: Color(0x99FFC83D), blurRadius: 12, spreadRadius: 1)],
                ),
              ),
            ),
          ),
        );
      }
    }

    /* ============================================================
       HOME
       ============================================================ */

    class HomeTab extends StatelessWidget {
      const HomeTab({super.key});
      @override
      Widget build(BuildContext context) {
        final uid = FirebaseAuth.instance.currentUser?.uid;
        return _NeonBackground(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 100),
            children: [
              if (uid != null)
                StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                  stream: FirebaseFirestore.instance.collection('users').doc(uid).snapshots(),
                  builder: (context, snapshot) => _HomeHeader(data: snapshot.data?.data() ?? <String, dynamic>{}),
                )
              else
                const _HomeHeader(data: <String, dynamic>{}),
              const SizedBox(height: 18),
              const _HomeBalanceRow(),
              const SizedBox(height: 20),
              _HomeBigBox(title: 'New Update', icon: Icons.campaign_rounded, subtitle: 'See what is new in PartyChat'),
              const SizedBox(height: 14),
              _HomeBigBox(title: 'Event', icon: Icons.celebration_rounded, subtitle: 'Join the latest PartyChat event'),
              const SizedBox(height: 14),
              _HomeBigBox(title: 'Free Reward', icon: Icons.card_giftcard_rounded, subtitle: 'Collect your free daily reward'),
              const SizedBox(height: 14),
              _HomeBigBox(title: 'Daily Task', icon: Icons.task_alt_rounded, subtitle: 'Complete today\'s tasks'),
            ],
          ),
        );
      }
    }

    class _HomeHeader extends StatelessWidget {
      final Map<String, dynamic> data;
      const _HomeHeader({required this.data});
      @override
      Widget build(BuildContext context) {
        return Row(
          children: [
            const Expanded(child: Text('Home', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900))),
            _NetworkOrAvatar(photoUrl: data['photoURL'] as String?, photoBase64: data['photoBase64'] as String?, avatar: data['avatar'] as String?, radius: 22),
          ],
        );
      }
    }

    class _HomeBalanceRow extends StatelessWidget {
      const _HomeBalanceRow();
      Widget _box(IconData icon, String value, String label, Color color) => Expanded(
        child: Container(
          height: 46,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(color: const Color(0xFF0D0A12), borderRadius: BorderRadius.circular(14), border: Border.all(color: color.withOpacity(.55))),
          child: Row(children: [
            Icon(icon, size: 18, color: color), const SizedBox(width: 7),
            Expanded(child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(value, style: TextStyle(fontWeight: FontWeight.w900, color: color)),
              Text(label, style: const TextStyle(fontSize: 10, color: Colors.white54)),
            ])),
          ]),
        ),
      );
      @override
      Widget build(BuildContext context) => Row(children: [_box(Icons.monetization_on_rounded, '12,580', 'Coins', const Color(0xFFFFC83D)), const SizedBox(width: 10), _box(Icons.diamond_rounded, '2,450', 'Diamonds', const Color(0xFFB78CFF))]);
    }

    class _HomeBigBox extends StatelessWidget {
      final String title;
      final String subtitle;
      final IconData icon;

      const _HomeBigBox({
        required this.title,
        required this.subtitle,
        required this.icon,
      });

      @override
      Widget build(BuildContext context) {
        return Container(
          width: double.infinity,
          height: 128,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF1C1628), Color(0xFF100B1A)],
            ),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: const Color(0xFF7B3FF2), width: 1.2),
            boxShadow: const [
              BoxShadow(color: Color(0x443F00FF), blurRadius: 18, spreadRadius: 1),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 66,
                height: 66,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [Color(0xFF7B3FF2), Color(0xFFD6A84F)],
                  ),
                  boxShadow: const [
                    BoxShadow(color: Color(0x665B1CFF), blurRadius: 18),
                  ],
                ),
                child: Icon(icon, color: Colors.white, size: 32),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 7),
                    Text(
                      subtitle,
                      style: const TextStyle(color: Colors.white60, fontSize: 13),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios_rounded,
                  color: Colors.white70, size: 18),
            ],
          ),
        );
      }
    }

    class RoomsTab extends StatefulWidget {
      const RoomsTab({super.key});

      @override
      State<RoomsTab> createState() => _RoomsTabState();
    }

    class _RoomsTabState extends State<RoomsTab> {
      int selectedMainTab = 0;
      int selectedMyRoomTab = 0;

      static const mainTabs = [
        'All Room',
        'Popular Room',
        'New Room',
        'My Room',
      ];

      static const myRoomTabs = [
        'Recently Joined',
        'Joined',
        'With Friend',
      ];

      @override
      Widget build(BuildContext context) {
        return _NeonBackground(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(18, 20, 18, 100),
            children: [
              const Text(
                'Rooms',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 14),
              GestureDetector(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PartyChatSearchPage())),
                child: Container(
                  height: 54,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0D0A12),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: const Color(0xFF7B3FF2), width: 1.1),
                  ),
                  child: const Row(children: [
                    Icon(Icons.search_rounded, color: Color(0xFFFFC83D)),
                    SizedBox(width: 10),
                    Expanded(child: Text('Search users or rooms', style: TextStyle(color: Colors.white54, fontSize: 15))),
                  ]),
                ),
              ),
              const SizedBox(height: 18),
              _buildMainTabs(),
              if (selectedMainTab == 3) ...[
                const SizedBox(height: 14),
                _buildMyRoomTabs(),
              ],
              const SizedBox(height: 22),
              _buildRoomContent(),
            ],
          ),
        );
      }

      Widget _buildMainTabs() {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(mainTabs.length, (index) {
              final selected = selectedMainTab == index;
              return Padding(
                padding: EdgeInsets.only(right: index == mainTabs.length - 1 ? 0 : 8),
                child: GestureDetector(
                  onTap: () => setState(() => selectedMainTab = index),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 13),
                    decoration: BoxDecoration(
                      gradient: selected
                          ? const LinearGradient(
                              colors: [Color(0xFF7B3FF2), Color(0xFFD6A84F)],
                            )
                          : null,
                      color: selected ? null : const Color(0xFF171125),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: const Color(0xFF7B3FF2)),
                    ),
                    child: Text(
                      mainTabs[index],
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        );
      }

      Widget _buildMyRoomTabs() {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(myRoomTabs.length, (index) {
              final selected = selectedMyRoomTab == index;
              return Padding(
                padding: EdgeInsets.only(right: index == myRoomTabs.length - 1 ? 0 : 8),
                child: GestureDetector(
                  onTap: () => setState(() => selectedMyRoomTab = index),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 11),
                    decoration: BoxDecoration(
                      color: selected ? const Color(0xFF241A33) : const Color(0xFF120D1C),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: selected ? const Color(0xFFD6A84F) : const Color(0xFF40344F),
                      ),
                    ),
                    child: Text(
                      myRoomTabs[index],
                                       style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: selected ? Colors.white : Colors.white70,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        );
      }

      Widget _buildRoomContent() {
        if (selectedMainTab == 0) {
          return const Column(
            children: [
              RoomTile('Friends Forever 💜', '2.4K online', Icons.people,
                  subtitle: 'Make new friends & enjoy chat'),
              RoomTile('Gaming Zone 🎮', '1.8K online', Icons.games,
                  subtitle: 'Play games & enjoy together'),
              RoomTile('Music Lovers 🎵', '1.2K online', Icons.music_note,
                  subtitle: 'Music • Vibes • Party'),
              RoomTile('Chill Zone 🌙', '980 online', Icons.nightlight_round,
                  subtitle: 'Relax • Talk • Be Yourself'),
            ],
          );
        }

        if (selectedMainTab == 1) {
          return const Column(
            children: [
              RoomTile('Friends Forever 💜', '2.4K online', Icons.people,
                  subtitle: 'Popular • Active • Gifting'),
              RoomTile('Gaming Zone 🎮', '1.8K online', Icons.games,
                  subtitle: 'Popular gaming room'),
              RoomTile('Music Lovers 🎵', '1.2K online', Icons.music_note,
                  subtitle: 'Music • Vibes • Party'),
            ],
          );
        }

        if (selectedMainTab == 2) {
          return const Column(
            children: [
              RoomTile('New Friends 🌟', '320 online', Icons.auto_awesome,
                  subtitle: 'New room • Meet new people'),
              RoomTile('Fresh Talk 💬', '210 online', Icons.chat_bubble,
                  subtitle: 'New room • Start chatting'),
              RoomTile('New Vibes 🎵', '145 online', Icons.music_note,
                  subtitle: 'New room • Music & chat'),
            ],
          );
        }

        if (selectedMyRoomTab == 0) {
          return const Column(
            children: [
              RoomTile('Recently Joined', 'Room history', Icons.history,
                  subtitle: 'Your recently joined rooms'),
            ],
          );
        }

        if (selectedMyRoomTab == 1) {
          return const Column(
            children: [
              RoomTile('Joined Rooms', 'Your rooms', Icons.meeting_room,
                  subtitle: 'Rooms you have joined'),
            ],
          );
        }

        return const Column(
          children: [
            RoomTile('With Friend', 'Friends rooms', Icons.people_alt,
                subtitle: 'Rooms you joined with friends'),
          ],
        );
      }
    }


    class SimpleUserProfilePage extends StatelessWidget {
      final String uid;
      const SimpleUserProfilePage({super.key, required this.uid});
      @override
      Widget build(BuildContext context) {
        return Scaffold(
          backgroundColor: PartyColors.black,
          appBar: AppBar(),
          body: _NeonBackground(
            child: FutureBuilder<Map<String, dynamic>?>(
              future: PartyChatData.userData(uid),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Center(child: SizedBox(width: 110, child: LinearProgressIndicator(minHeight: 3)));
                final data = snapshot.data ?? <String, dynamic>{};
                final name = data['name']?.toString() ?? 'Party User';
                final publicId = data['userId']?.toString() ?? uid;
                return Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
                  _NetworkOrAvatar(photoUrl: data['photoURL'] as String?, photoBase64: data['photoBase64'] as String?, avatar: data['avatar'] as String?, radius: 72),
                  const SizedBox(height: 20),
                  Text(name, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 8),
                  Text('UID: $publicId', style: const TextStyle(color: Colors.white60, fontSize: 15)),
                ]));
              },
            ),
          ),
        );
      }
    }

    class PartyChatSearchPage extends StatefulWidget {
      const PartyChatSearchPage({super.key});
      @override
      State<PartyChatSearchPage> createState() => _PartyChatSearchPageState();
    }

    class _PartyChatSearchPageState extends State<PartyChatSearchPage> {
      final controller = TextEditingController();
      final focusNode = FocusNode();
      List<Map<String, dynamic>> userResults = [];
      List<Map<String, String>> roomResults = [];
      bool searching = false;
      String lastQuery = '';

      static const rooms = [
        {'title': 'Friends Forever 💜', 'online': '2.4K online'},
        {'title': 'Gaming Zone 🎮', 'online': '1.8K online'},
        {'title': 'Music Lovers 🎵', 'online': '1.2K online'},
        {'title': 'Chill Zone 🌙', 'online': '980 online'},
        {'title': 'New Friends 🌟', 'online': '320 online'},
        {'title': 'Fresh Talk 💬', 'online': '210 online'},
        {'title': 'New Vibes 🎵', 'online': '145 online'},
      ];

      @override
      void initState() {
        super.initState();
        WidgetsBinding.instance.addPostFrameCallback((_) { if (mounted) focusNode.requestFocus(); });
      }
      @override
      void dispose() { controller.dispose(); focusNode.dispose(); super.dispose(); }

      Future<void> _search(String raw) async {
        final query = raw.trim();
        if (query.isEmpty) {
          setState(() { lastQuery = ''; userResults = []; roomResults = []; searching = false; });
          return;
        }
        setState(() { searching = true; lastQuery = query; });
        final uid = FirebaseAuth.instance.currentUser?.uid;
        Map<String, dynamic>? exactUser;
        try { exactUser = await PartyChatData.findUserByUid(query); } catch (_) {}
        List<Map<String, dynamic>> nameMatches = [];
        try { nameMatches = await PartyChatData.searchUsersByName(query); } catch (_) {}
        final q = query.toLowerCase();
        final roomsFound = rooms.where((room) => room['title']!.toLowerCase().contains(q)).toList();
        final users = <Map<String, dynamic>>[];
        if (exactUser != null) {
          users.add(exactUser);
        } else if (!roomsFound.any((room) => room['title']!.toLowerCase() == q)) {
          for (final item in nameMatches) {
            final name = (item['name'] ?? '').toString().toLowerCase();
            if (!name.contains(q)) continue;
            final id = item['uid']?.toString();
            if (id != null && users.every((x) => x['uid']?.toString() != id)) users.add(item);
          }
        }
        if (uid != null) users.removeWhere((item) => item['uid']?.toString() == uid);
        if (!mounted || query != lastQuery) return;
        setState(() { userResults = users; roomResults = roomsFound; searching = false; });
      }

      Future<bool> _requestPending(String myUid, String otherUid) async {
        if ((await PartyChatData.friends(myUid).doc(otherUid).get()).exists) return true;
        if ((await PartyChatData.friendRequests(myUid).doc(otherUid).get()).exists) return true;
        return (await PartyChatData.friendRequests(otherUid).doc(myUid).get()).exists;
      }

      @override
      Widget build(BuildContext context) {
        return Scaffold(
          backgroundColor: PartyColors.black,
          body: _NeonBackground(child: ListView(padding: const EdgeInsets.fromLTRB(18, 16, 18, 30), children: [
            TextField(
              controller: controller,
              focusNode: focusNode,
              textInputAction: TextInputAction.search,
              onSubmitted: _search,
              onChanged: (value) { if (value.trim().isEmpty) _search(''); },
              decoration: InputDecoration(
                hintText: 'Search by UID, name or room name',
                prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFFFFC83D)),
                suffixIcon: IconButton(icon: const Icon(Icons.arrow_forward_rounded, color: Color(0xFFFFC83D)), onPressed: () => _search(controller.text)),
              ),
            ),
            const SizedBox(height: 18),
            if (searching) const SizedBox(width: double.infinity, child: LinearProgressIndicator(minHeight: 3)),
            if (!searching && lastQuery.isNotEmpty && userResults.isEmpty && roomResults.isEmpty)
              const Padding(padding: EdgeInsets.only(top: 80), child: Center(child: Text('No matching result.', style: TextStyle(color: Colors.white54)))),
            if (userResults.isNotEmpty) ...[
              const Text('Users', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
              const SizedBox(height: 8),
              ...userResults.map((data) {
                final otherUid = data['uid']?.toString() ?? '';
                final name = data['name']?.toString() ?? 'Party User';
                final publicId = data['userId']?.toString() ?? otherUid;
                final myUid = FirebaseAuth.instance.currentUser?.uid;
                return Card(
                  color: const Color(0xFF0D0A12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18), side: const BorderSide(color: Color(0xFF3B2A55))),
                  child: ListTile(
                    leading: GestureDetector(
                      onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => SimpleUserProfilePage(uid: otherUid))),
                      child: _NetworkOrAvatar(photoUrl: data['photoURL'] as String?, photoBase64: data['photoBase64'] as String?, avatar: data['avatar'] as String?, radius: 24),
                    ),
                    title: Text(name, style: const TextStyle(fontWeight: FontWeight.w800)),
                    subtitle: Text('ID: $publicId'),
                    trailing: myUid == null ? null : FutureBuilder<bool>(
                      future: _requestPending(myUid, otherUid),
                      builder: (context, snapshot) {
  final pending = snapshot.data ?? false;

  return IconButton(
    icon: Icon(
      pending
          ? Icons.check_circle_rounded
          : Icons.person_add_alt_1_rounded,
      color: pending
          ? const Color(0xFFFFC83D)
          : PartyColors.purpleBright,
    ),
    onPressed: pending
        ? null
        : () async {
            try {
              await PartyChatData.sendFriendRequest(
                fromUid: myUid,
                toUid: otherUid,
              );

              if (context.mounted) {
                setState(() {});
              }
            } catch (e) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(e.toString()),
                  ),
                );
              }
            }
          },
        );
      },
    ),
    
                    onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => SimpleUserProfilePage(uid: otherUid))),
                  ),
                );
              }),
            ],
            if (roomResults.isNotEmpty) ...[
              const SizedBox(height: 16),
              const Text('Rooms', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
              const SizedBox(height: 8),
              ...roomResults.map((room) => Card(
                color: const Color(0xFF0D0A12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18), side: const BorderSide(color: Color(0xFF3B2A55))),
                child: ListTile(
                  leading: const CircleAvatar(backgroundColor: Color(0xFF241A33), child: Icon(Icons.meeting_room_rounded, color: Color(0xFFFFC83D))),
                  title: Text(room['title']!, style: const TextStyle(fontWeight: FontWeight.w800)),
                  subtitle: Text(room['online']!),
                  trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Color(0xFFFFC83D)),
                  onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => RoomPage(title: room['title']!, online: room['online']!))),
                ),
              )),
            ],
          ])),
        );
      }
    }

    // ============================================================
    // POPULAR ROOMS PAGE
    // ============================================================

    class PopularRoomsPage extends StatelessWidget {
      const PopularRoomsPage({super.key});

      @override
      Widget build(BuildContext context) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Popular Rooms'),
          ),
          body: _NeonBackground(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(18, 20, 18, 30),
              children: const [
                RoomTile(
                  'Friends Forever 💜',
                  '2.4K online',
                  Icons.people,
                  subtitle: 'Popular • Active • Gifting',
                ),
                RoomTile(
                  'Gaming Zone 🎮',
                  '1.8K online',
                  Icons.games,
                  subtitle: 'Popular gaming room',
                ),
                RoomTile(
                  'Music Lovers 🎵',
                  '1.2K online',
                  Icons.music_note,
                  subtitle: 'Music • Vibes • Party',
                ),
              ],
            ),
          ),
        );
      }
    }


    // ============================================================
    // NEW ROOMS PAGE
    // ============================================================

    class NewRoomsPage extends StatelessWidget {
      const NewRoomsPage({super.key});

      @override
      Widget build(BuildContext context) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('New Rooms'),
          ),
          body: _NeonBackground(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(18, 20, 18, 30),
              children: const [
                RoomTile(
                  'New Friends Room',
                  '24 online',
                  Icons.people_outline,
                  subtitle: 'New room',
                ),
                RoomTile(
                  'New Gaming Room',
                  '18 online',
                  Icons.games_outlined,
                  subtitle: 'New room',
                ),
                RoomTile(
                  'New Music Room',
                  '12 online',
                  Icons.music_note,
                  subtitle: 'New room',
                ),
              ],
            ),
          ),
        );
      }
    }


    // ============================================================
    // YOUR ROOM PAGE
    // ============================================================

    class YourRoomPage extends StatelessWidget {
      const YourRoomPage({super.key});

      @override
      Widget build(BuildContext context) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Your Room'),
          ),
          body: _NeonBackground(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(18, 20, 18, 30),
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _yourRoomTab(
                        context,
                        'My Room',
                        Icons.home_work,
                        const MyRoomPage(),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _yourRoomTab(
                        context,
                        'Recently Joined',
                        Icons.history,
                        const RecentlyJoinedRoomsPage(),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                Row(
                  children: [
                    Expanded(
                      child: _yourRoomTab(
                        context,
                        'Joined Rooms',
                        Icons.login,
                        const JoinedRoomsPage(),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _yourRoomTab(
                        context,
                        'With Friends',
                        Icons.people,
                        const FriendRoomsPage(),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                const Text(
                  'My Room',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                  ),
                ),

                const SizedBox(height: 12),

                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const MyRoomPage(),
                      ),
                    );
                  },
                  child: Container(
                    height: 170,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF171126),
                          Color(0xFF0D0917),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(
                        color: const Color(0xFF7B3FF2),
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x553F00FF),
                          blurRadius: 20,
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.meeting_room,
                            size: 52,
                            color: Color(0xFFFFC83D),
                          ),
                          SizedBox(height: 12),
                          Text(
                            'My Room',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Open your room',
                            style: TextStyle(
                              color: Colors.white54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }

      Widget _yourRoomTab(
        BuildContext context,
        String title,
        IconData icon,
        Widget page,
      ) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => page,
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 14,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFF171125),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xFF51317B),
              ),
            ),
            child: Column(
              children: [
                Icon(
                  icon,
                  color: const Color(0xFFFFC83D),
                  size: 23,
                ),
                const SizedBox(height: 6),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        );
      }
    }


    // ============================================================
    // MY ROOM
    // ============================================================

    class MyRoomPage extends StatelessWidget {
      const MyRoomPage({super.key});

      @override
      Widget build(BuildContext context) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('My Room'),
          ),
          body: _NeonBackground(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: _NeonPanel(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.meeting_room,
                        size: 60,
                        color: Color(0xFFFFC83D),
                      ),
                      const SizedBox(height: 15),
                      const Text(
                        'My Room',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Your created room will appear here.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white54,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }
    }


    // ============================================================
    // RECENTLY JOINED
    // ============================================================

    class RecentlyJoinedRoomsPage extends StatelessWidget {
      const RecentlyJoinedRoomsPage({super.key});

      @override
      Widget build(BuildContext context) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Recently Joined'),
          ),
          body: _NeonBackground(
            child: ListView(
              padding: const EdgeInsets.all(18),
              children: const [
                RoomTile(
                  'Friends Forever 💜',
                  '2.4K online',
                  Icons.people,
                  subtitle: 'Recently joined',
                ),
              ],
            ),
          ),
        );
      }
    }


    // ============================================================
    // JOINED ROOMS
    // ============================================================

    class JoinedRoomsPage extends StatelessWidget {
      const JoinedRoomsPage({super.key});

      @override
      Widget build(BuildContext context) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Joined Rooms'),
          ),
          body: _NeonBackground(
            child: ListView(
              padding: const EdgeInsets.all(18),
              children: const [
                RoomTile(
                  'Gaming Zone 🎮',
                  '1.8K online',
                  Icons.games,
                  subtitle: 'Joined room',
                ),
              ],
            ),
          ),
        );
      }
    }


    // ============================================================
    // WITH FRIENDS
    // ============================================================

    class FriendRoomsPage extends StatelessWidget {
      const FriendRoomsPage({super.key});

      @override
      Widget build(BuildContext context) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('With Friends'),
          ),
          body: _NeonBackground(
            child: ListView(
              padding: const EdgeInsets.all(18),
              children: const [
                RoomTile(
                  'Friends Forever 💜',
                  '2.4K online',
                  Icons.people,
                  subtitle: 'Your friends are here',
                ),
              ],
            ),
          ),
        );
      }
    }

    class RoomTile extends StatelessWidget {
      final String title;
      final String online;
      final IconData icon;
      final String subtitle;

      const RoomTile(this.title, this.online, this.icon, {super.key, this.subtitle = 'Chat • Friends • Fun'});

      @override
      Widget build(BuildContext context) {
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(11),
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [Color(0xFF171126), Color(0xFF0D0917)]),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFF7B3FF2)),
            boxShadow: const [BoxShadow(color: Color(0x331C00FF), blurRadius: 12)],
          ),
          child: Row(children: [
            Container(width: 52, height: 52, decoration: BoxDecoration(shape: BoxShape.circle, gradient: const LinearGradient(colors: [Color(0xFF7B3FF2), Color(0xFFD6A84F)]), boxShadow: const [BoxShadow(color: Color(0x665B1CFF), blurRadius: 14)]), child: Icon(icon, color: Colors.white)),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.w900)),
              Text(online, style: const TextStyle(color: Color(0xFF43F5B0), fontSize: 12, fontWeight: FontWeight.w700)),
              Text(subtitle, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white54, fontSize: 11)),
            ])),
            _NeonAction(label: AppLanguage.text('join'), onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => RoomPage(title: title, online: online)))),
          ]),
        );
      }
    }

    /* ============================================================
       ROOM + MIC GLOW
       ============================================================ */

    class RoomPage extends StatefulWidget {
      final String title;
      final String online;

      late final String userId = FirebaseAuth.instance.currentUser?.uid ??
          'party_user_${DateTime.now().millisecondsSinceEpoch}';

      RoomPage({
        super.key,
        required this.title,
        required this.online,
      });

      @override
      State<RoomPage> createState() => _RoomPageState();
    }

    class _RoomPageState extends State<RoomPage> {
      bool micOn = false;
      String roomUserName = 'Party User';
      String? roomPhotoUrl;

      @override
      void initState() {
        super.initState();
        _loadRoomProfile();
      }

      Future<void> _loadRoomProfile() async {
        final uid = FirebaseAuth.instance.currentUser?.uid;
        if (uid == null) return;
        final data = await PartyChatData.userData(uid);
        if (!mounted || data == null) return;
        setState(() {
          roomUserName = data['name']?.toString() ?? 'Party User';
          roomPhotoUrl = data['photoURL']?.toString();
        });
      }

      bool isSpeaking = false;
      bool speakerOn = true;

      StreamSubscription<double>? soundLevelSubscription;

      final messageController = TextEditingController();
      final List<String> messages = [];

      Widget _buildMicButton() {
        return GestureDetector(
          onTap: toggleMic,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: micOn ? PartyColors.gold : PartyColors.panel,
              boxShadow: isSpeaking
                  ? [
                      BoxShadow(
                        color: PartyColors.gold.withOpacity(0.9),
                        blurRadius: 22,
                        spreadRadius: 7,
                      ),
                      BoxShadow(
                        color: PartyColors.purpleBright.withOpacity(0.35),
                        blurRadius: 40,
                        spreadRadius: 12,
                      ),
                    ]
                  : [],
            ),
            child: Icon(
              micOn ? Icons.mic : Icons.mic_off,
              color: micOn ? Colors.black : PartyColors.text,
              size: 29,
            ),
          ),
        );
      }

      void startMicGlow() {
        soundLevelSubscription?.cancel();

        soundLevelSubscription = ZegoUIKit()
            .getSoundLevelStream(widget.userId)
            .listen((level) {
          if (!micOn) return;

          final speaking = level > 20;

          if (speaking != isSpeaking && mounted) {
            setState(() {
              isSpeaking = speaking;
            });
          }
        });
      }

      Future<void> toggleMic() async {
        final next = !micOn;

        if (mounted) {
          setState(() {
            micOn = next;

            if (!next) {
              isSpeaking = false;
            }
          });
        }

        try {
          ZegoUIKit().turnMicrophoneOn(
            next,
            userID: widget.userId,
          );
        } catch (e) {
          debugPrint('Microphone change failed: $e');
        }

        if (next) {
          startMicGlow();
        } else {
          await soundLevelSubscription?.cancel();
          soundLevelSubscription = null;
        }
      }

      void sendMessage() {
        final text = messageController.text.trim();

        if (text.isEmpty) return;

        setState(() {
          messages.add(text);
          messageController.clear();
        });
      }
      @override
      void dispose() {
        soundLevelSubscription?.cancel();
        messageController.dispose();
        super.dispose();
      }

      @override
      Widget build(BuildContext context) {
        final roomId = widget.title
            .toLowerCase()
            .replaceAll(
              RegExp(r'[^a-z0-9]+'),
              '_',
            );

        return Scaffold(
      body: Stack(
        children: [
          ZegoUIKitPrebuiltLiveAudioRoom(
            appID: zegoAppId,
            appSign: zegoAppSign,
            userID: widget.userId,
            userName: roomUserName,
            roomID: roomId,
            config: (ZegoUIKitPrebuiltLiveAudioRoomConfig.host()
              ..seat.avatarBuilder = (context, size, user, extraInfo) =>
                  _ZegoFirebaseAvatar(
                    userId: user?.id ?? '',
                    size: size,
                  )),
          ),
          Positioned(
            top: 42,
            right: 12,
            child: SafeArea(
              child: IconButton.filled(
                tooltip: 'Invite Friend',
                icon: const Icon(Icons.person_add),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => RoomInviteFriendsPage(
                        roomId: roomId,
                        roomTitle: widget.title,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
              Positioned(
                bottom: 24,
                left: 0,
                right: 0,
                child: Center(
                  child: _buildMicButton(),
                ),
              ),
            ],
          ),
        );
      }
    }

    class _ZegoFirebaseAvatar extends StatelessWidget {
      final String userId;
      final Size size;
      const _ZegoFirebaseAvatar({required this.userId, required this.size});
      @override
      Widget build(BuildContext context) {
        if (userId.isEmpty) {
          return Container(
            width: size.width,
            height: size.height,
            padding: const EdgeInsets.all(2.5),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(colors: [PartyColors.gold, PartyColors.purpleBright]),
            ),
            child: const CircleAvatar(
              backgroundColor: PartyColors.panel,
              child: Icon(Icons.person_rounded, color: PartyColors.gold),
            ),
          );
        }
        return FutureBuilder<Map<String, dynamic>?>(
          future: PartyChatData.userData(userId),
          builder: (context, snapshot) {
            final data = snapshot.data ?? <String, dynamic>{};
            final b64 = data['photoBase64']?.toString();
            final url = data['photoURL']?.toString();
            ImageProvider<Object>? image;
            if (b64 != null && b64.isNotEmpty) { try { image = MemoryImage(base64Decode(b64)); } catch (_) {} }
            if (image == null && url != null && url.isNotEmpty) image = NetworkImage(url);
            return Container(
              width: size.width,
              height: size.height,
              padding: const EdgeInsets.all(2.5),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(colors: [PartyColors.gold, PartyColors.purpleBright]),
                boxShadow: [BoxShadow(color: Color(0x554F00FF), blurRadius: 12, spreadRadius: 1)],
              ),
              child: CircleAvatar(
                backgroundColor: PartyColors.panel,
                backgroundImage: image,
                child: image == null ? const Icon(Icons.person_rounded, color: PartyColors.gold) : null,
              ),
            );
          },
        );
      }
    }

    class RoomInviteFriendsPage extends StatelessWidget {
      final String roomId;
      final String roomTitle;

      const RoomInviteFriendsPage({
        super.key,
        required this.roomId,
        required this.roomTitle,
      });

      @override
      Widget build(BuildContext context) {
        final user = FirebaseAuth.instance.currentUser;
        if (user == null) return const Scaffold(body: Center(child: Text('Please login first.')));
        final ref = FirebaseFirestore.instance.collection('users').doc(user.uid).collection('friends');

        return Scaffold(
          appBar: AppBar(title: const Text('Invite Friends')),
          body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: ref.snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return const Center(child: LinearProgressIndicator(minHeight: 3));
              final docs = snapshot.data!.docs;
              if (docs.isEmpty) return const Center(child: Text('Add friends first.'));
              return ListView.builder(
                itemCount: docs.length,
                itemBuilder: (context, index) {
                  final d = docs[index].data();
                  final uid = d['uid'] ?? docs[index].id;
                  return ListTile(
                    leading: _NetworkOrAvatar(
                      photoUrl: d['photoURL'] as String?,
                      avatar: d['avatar'] as String?,
                    ),
                    title: Text(d['name'] ?? 'Friend'),
                    trailing: FilledButton(
                      onPressed: () async {
                        try {
                          await PartyChatData.sendRoomInvite(
                            fromUid: user.uid,
                            toUid: uid,
                            roomId: roomId,
                            roomTitle: roomTitle,
                          );
                          if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Room invitation sent successfully.')),
                          );
                        } catch (e) {
                          if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('$e')),
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

    /* ============================================================
       GAMES
       ============================================================ */
    // Game thumbnails currently use Wikimedia Commons files through Special:FilePath URLs.
    // For a production/offline Play Store build, these images should later be bundled locally
    // in assets/ with the required license/attribution information.


    class GamesTab extends StatelessWidget {
      const GamesTab({super.key});

      static const List<Map<String, String>> games = [
        {
          'title': 'Ludo',
          'image': 'https://commons.wikimedia.org/wiki/Special:FilePath/Ludo_board_game.jpg',
        },
        {
          'title': 'Carrom',
          'image': 'https://commons.wikimedia.org/wiki/Special:FilePath/Carrom_board.jpg',
        },
        {
          'title': '8 Ball Pool',
          'image': 'https://commons.wikimedia.org/wiki/Special:FilePath/8ballpool.jpg',
        },
        {
          'title': 'Quiz',
          'image': 'https://commons.wikimedia.org/wiki/Special:FilePath/Quiz_competition_image.jpg',
        },
        {
          'title': 'Bubble Shooter',
          'image': 'https://commons.wikimedia.org/wiki/Special:FilePath/Bubbles_game.JPG',
        },
        {
          'title': 'Chess',
          'image': 'https://commons.wikimedia.org/wiki/Special:FilePath/Chess_board.png',
        },
      ];

      @override
      Widget build(BuildContext context) {
        return _NeonBackground(
          child: GridView.builder(
            padding: const EdgeInsets.fromLTRB(18, 22, 18, 100),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: .88,
            ),
            itemCount: games.length,
            itemBuilder: (context, index) {
              final game = games[index];
              return GameCard(
                title: game['title']!,
                imageUrl: game['image']!,
              );
            },
          ),
        );
      }
    }

    class GameCard extends StatelessWidget {
      final String title;
      final String imageUrl;

      const GameCard({
        super.key,
        required this.title,
        required this.imageUrl,
      });

      @override
      Widget build(BuildContext context) {
        return _NeonPanel(
          padding: EdgeInsets.zero,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Color(0xFF7B3FF2),
                                  Color(0xFFD6A84F),
                                ],
                              ),
                            ),
                            child: const Icon(
                              Icons.sports_esports,
                              size: 48,
                              color: Colors.white,
                            ),
                          );
                        },
                        loadingBuilder: (context, child, progress) {
                          if (progress == null) return child;
                          return Container(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Color(0xFF21182F),
                                  Color(0xFF120A20),
                                ],
                              ),
                            ),
                            child: const Center(
                              child: LinearProgressIndicator(minHeight: 3),
                            ),
                          );
                        },
                      ),
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(10, 24, 10, 10),
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Color(0xCC05030B),
                              ],
                            ),
                          ),
                          child: Text(
                            title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 9, 10, 11),
                  child: Text(
                    AppLanguage.text('play_now'),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Color(0xFFD8C2FF),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }
    }

    class WalletTab extends StatelessWidget {
      const WalletTab({super.key});

      @override
      Widget build(BuildContext context) {
        return _NeonBackground(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(18, 22, 18, 100),
            children: [
              const Text('My Wallet', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900)),
              const SizedBox(height: 16),
              _NeonPanel(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('Coins', style: TextStyle(color: Colors.white70)),
                const SizedBox(height: 3),
                Row(children: [
                  const Text('12,580', style: TextStyle(fontSize: 34, fontWeight: FontWeight.w900, color: Color(0xFFFFC107))),
                  const SizedBox(width: 8),
                  const Icon(Icons.monetization_on, color: Color(0xFFFFC107), size: 28),
                ]),
                const SizedBox(height: 6),
                const Row(children: [
                  Text('2,450', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: Color(0xFFB78CFF))),
                  SizedBox(width: 6),
                  Text('Diamonds', style: TextStyle(fontSize: 17, color: Color(0xFFB78CFF))),
                ]),
              ])),
              const SizedBox(height: 14),
              SizedBox(width: double.infinity, child: _NeonAction(label: '＋  Recharge', onPressed: () {})),
              const SizedBox(height: 10),
              OutlinedButton.icon(style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)), side: const BorderSide(color: Color(0xFFFFC83D))), onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TransactionHistoryPage())), icon: const Icon(Icons.history), label: const Text('Transaction History', style: TextStyle(fontWeight: FontWeight.w800))),
              const SizedBox(height: 18),
              const Text('Quick Actions', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
              const SizedBox(height: 10),
              Row(children: [
                Expanded(child: _walletAction(Icons.add_card, 'Top Up')),
                const SizedBox(width: 8),
                Expanded(child: _walletAction(Icons.history, 'History')),
              ]),
            ],
          ),
        );
      }

      Widget _walletAction(IconData icon, String label) {
        return _NeonPanel(padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 6), child: Column(children: [Icon(icon, color: const Color(0xFFD8C2FF)), const SizedBox(height: 6), Text(label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700))]));
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
      final avatarImages = const {
        'avatar1': 'assets/avatar1_pakistan_female-2.png',
        'avatar2': 'assets/avatar2_uae_male.png',
        'avatar3': 'assets/avatar3_uk_male.png',
        'avatar4': 'assets/avatar4_russia_female.png',
        'avatar5': 'assets/avatar5_saudi_female.png',
        'avatar6': 'assets/avatar6_turkey_male.png',
        'avatar7': 'assets/avatar7_india_female.png',
        'avatar8': 'assets/avatar8_usa_male.png',
      };

      @override
    void initState() {
      super.initState();

      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        ProfileUnreadService.ensure(user.uid);
        ensureUserId();
      }
    }

    Future<void> ensureUserId() async {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final userDoc =
          FirebaseFirestore.instance.collection('users').doc(user.uid);

      final snapshot = await userDoc.get();
      final data = snapshot.data();

      if (data == null || data['userId'] != null) return;

      final random = math.Random();
      final newUserId =
          (100000 + random.nextInt(900000)).toString();

      await userDoc.set(
        {'userId': newUserId},
        SetOptions(merge: true),
      );
    }

      
      ImageProvider<Object>? _imageProvider(
        Map<String, dynamic>? data,
      ) {
        final photoBase64 = data?['photoBase64'] as String?;
        final photoURL = data?['photoURL'] as String?;
        final avatar = data?['avatar'] as String?;

        if (photoBase64 != null && photoBase64.isNotEmpty) {
          try {
            return MemoryImage(
              base64Decode(photoBase64),
            );
          } catch (_) {}
        }

        if (photoURL != null && photoURL.isNotEmpty) {
          return NetworkImage(photoURL);
        }

        if (avatar != null && avatarImages[avatar] != null) {
          return AssetImage(avatarImages[avatar]!);
        }

        return null;
      }

      Future<void> _showPhotoZoom(
        BuildContext context,
        ImageProvider<Object> image,
      ) async {
        await showDialog(
          context: context,
          barrierColor: Colors.black.withOpacity(0.9),
          builder: (_) {
            return Dialog(
              backgroundColor: Colors.transparent,
              insetPadding: const EdgeInsets.all(10),
              child: InteractiveViewer(
                minScale: 1,
                maxScale: 5,
                child: Image(
                  image: image,
                  fit: BoxFit.contain,
                ),
              ),
            );
          },
        );
      }

      Future<void> _pickGallery(
        BuildContext context,
        DocumentReference<Map<String, dynamic>> userDoc,
      ) async {
        final picker = ImagePicker();

        final image = await picker.pickImage(
          source: ImageSource.gallery,
          imageQuality: 20,
          maxWidth: 256,
          maxHeight: 256,
        );

        if (image == null) return;

        final bytes = await image.readAsBytes();

        if (bytes.length > 500000) {
          if (!context.mounted) return;

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Photo is too large. Please select a smaller photo.',
              ),
            ),
          );
          return;
        }

        final encodedPhoto = base64Encode(bytes);

        try {
          await userDoc.set(
            {
              'photoBase64': encodedPhoto,
              'photoURL': '',
              'avatar': '',
            },
            SetOptions(merge: true),
          );

          if (!context.mounted) return;

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Profile photo saved successfully.',
              ),
            ),
          );
        } catch (e) {
          if (!context.mounted) return;

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Photo could not be saved: $e',
              ),
            ),
          );
        }
      }

      Future<void> _chooseAvatar(
     
        BuildContext context,
        DocumentReference<Map<String, dynamic>> userDoc,
      ) async {
        final avatars = avatarImages.keys.toList();

        final selected = await showDialog<String>(
          context: context,
          builder: (dialogContext) {
            String? tempSelected;

            return StatefulBuilder(
              builder: (
                context,
                setDialogState,
              ) {
                return AlertDialog(
                  title: Text(
                    AppLanguage.text('choose_avatar'),
                  ),
                  content: GridView.builder(
                    shrinkWrap: true,
                    itemCount: avatars.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemBuilder: (context, index) {
                      final avatar = avatars[index];

                      return GestureDetector(
                        onTap: () {
                          setDialogState(() {
                            tempSelected = avatar;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: tempSelected == avatar
                                  ? Colors.white
                                  : Colors.grey,
                              width:
                                  tempSelected == avatar ? 3 : 1,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Image.asset(
                            avatarImages[avatar]!,
                            fit: BoxFit.contain,
                          ),
                        ),
                      );
                    },
                  ),
                  actions: [
                    ElevatedButton(
                      onPressed: tempSelected == null
                          ? null
                          : () {
                              Navigator.pop(
                                dialogContext,
                                tempSelected,
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
          },
        );

        if (selected == null) return;

        try {
          await userDoc.set(
            {
              'avatar': selected,
              'photoURL': '',
              'photoBase64': '',
            },
            SetOptions(merge: true),
          );

          if (!context.mounted) return;

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Avatar saved successfully.',
              ),
            ),
          );
        } catch (e) {
          if (!context.mounted) return;

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Avatar could not be saved: $e',
              ),
            ),
          );
        }
      }

      Future<void> _changeUsername(
        BuildContext context,
        DocumentReference<Map<String, dynamic>> userDoc,
      ) async {
        final controller = TextEditingController();

        await showDialog(
          context: context,
          builder: (dialogContext) {
            return AlertDialog(
              title: Text(
                AppLanguage.text('change_username'),
              ),
              content: TextField(
                controller: controller,
                maxLength: 20,
                decoration: InputDecoration(
                  hintText: AppLanguage.text('username'),
                  helperText: '3–20 characters',
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
                ElevatedButton(
                  onPressed: () async {
                    final newName = controller.text.trim();

                    if (newName.length < 3 ||
                        newName.length > 20) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Username must be 3 to 20 characters long.',
                          ),
                        ),
                      );
                      return;
                    }

                    try {
                      final data =
                          (await userDoc.get()).data();

                      final lastChange =
                          data?['lastNameChangeAt'];

                      if (lastChange is Timestamp) {
                        final difference = DateTime.now().difference(
                          lastChange.toDate(),
                        );

                        if (difference < const Duration(hours: 24)) {
                          final remaining = const Duration(hours: 24)
                                  .inMinutes -
                              difference.inMinutes;

                          final hours = remaining ~/ 60;
                          final minutes = remaining % 60;

                          if (!context.mounted) return;

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Please wait $hours hours $minutes minutes before changing your username again.',
                              ),
                            ),
                          );
                          return;
                        }
                      }

                      await userDoc.set(
                        {
                          'name': newName,
                          'lastNameChangeAt':
                              FieldValue.serverTimestamp(),
                        },
                        SetOptions(merge: true),
                      );

                      final user =
                          FirebaseAuth.instance.currentUser;

                      if (user != null) {
                        await user.updateDisplayName(newName);
                      }

                      if (!dialogContext.mounted) return;

                      Navigator.pop(dialogContext);

                      if (!context.mounted) return;

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Username saved successfully.',
                          ),
                        ),
                      );
                    } catch (e) {
                      if (!context.mounted) return;

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Username could not be saved: $e',
                          ),
                        ),
                      );
                    }
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
      }

      Future<void> _openProfilePage(
        BuildContext context,
        String unreadKey,
        Widget page,
      ) async {
        final user = FirebaseAuth.instance.currentUser;

        if (user != null) {
          await ProfileUnreadService.markRead(
            user.uid,
            unreadKey,
          );
        }

        if (!context.mounted) return;

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => page,
          ),
        );
      }

      Widget _profileNavigationTile({
        required BuildContext context,
        required IconData icon,
        required String titleKey,
        required String unreadKey,
        required int unread,
        required Widget page,
      }) {
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 2),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: const Color(0xFF0F0B19)),
          child: ListTile(
            leading: Icon(icon, color: const Color(0xFFD8C2FF)),
            title: Text(AppLanguage.text(titleKey), style: const TextStyle(fontWeight: FontWeight.w700)),
            trailing: Row(mainAxisSize: MainAxisSize.min, children: [
              if (unread > 0) Container(constraints: const BoxConstraints(minWidth: 22, minHeight: 22), padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle), alignment: Alignment.center, child: Text(unread > 99 ? '99+' : '$unread', style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold))),
              const SizedBox(width: 6), const Icon(Icons.chevron_right),
            ]),
            onTap: () => _openProfilePage(context, unreadKey, page),
          ),
        );
      }

      @override
      Widget build(BuildContext context) {
        final user = FirebaseAuth.instance.currentUser;
        if (user == null) return Center(child: Text('${AppLanguage.text('login')} first'));

        final userDoc = FirebaseFirestore.instance.collection('users').doc(user.uid);
        final unreadDoc = ProfileUnreadService.ref(user.uid);

        return _NeonBackground(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(18, 20, 18, 100),
            children: [
              Row(children: [const Icon(Icons.person_rounded, size: 30, color: Color(0xFFD8C2FF)), const SizedBox(width: 10), const Expanded(child: Text('Profile', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900))), IconButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsPage())), icon: const Icon(Icons.settings))]),
              const SizedBox(height: 10),
              _NeonPanel(
                child: Column(children: [
                  StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                    stream: userDoc.snapshots(),
                    builder: (context, snapshot) {
                      final data = snapshot.data?.data();
                      final image = _imageProvider(data);
                      return GestureDetector(
                        onTap: image == null ? null : () => _showPhotoZoom(context, image),
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(shape: BoxShape.circle, gradient: LinearGradient(colors: [PartyColors.gold, PartyColors.purple])),
                          child: CircleAvatar(radius: 48, backgroundImage: image, child: image == null ? const Icon(Icons.person, size: 50) : null),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                    stream: userDoc.snapshots(),
                    builder: (context, snapshot) {
                      final data = snapshot.data?.data();
                      final name = data?['name'] as String? ?? user.displayName ?? 'PartyChat User';
                     return Column(
      children: [
        Text(
          '$name 👑',
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'ID: ${data?['userId'] ?? '------'}',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 5),
            GestureDetector(
              onTap: () async {
                final id = data?['userId']?.toString();

                if (id == null || id.isEmpty) return;

                await Clipboard.setData(
                  ClipboardData(text: id),
                );

                if (!context.mounted) return;

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('User ID copied'),
                  ),
                );
              },
              child: const Icon(
                Icons.copy,
                size: 16,
                color: Colors.white70,
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        const Text(
          'VIP Level 3',
          style: TextStyle(
            color: Color(0xFFFFD15C),
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
                    },
                  ),
                  const SizedBox(height: 14),
                  Wrap(spacing: 10, runSpacing: 10, alignment: WrapAlignment.center, children: [
                    _NeonAction(label: 'Change Username', icon: Icons.edit, onPressed: () => _changeUsername(context, userDoc)),
                    _NeonAction(label: 'Photo', icon: Icons.camera_alt, onPressed: () => _pickGallery(context, userDoc)),
                    _NeonAction(label: 'Avatar', icon: Icons.face, onPressed: () => _chooseAvatar(context, userDoc)),
                  ]),
                ]),
              ),
              const SizedBox(height: 18),
              StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                stream: unreadDoc.snapshots(),
                builder: (context, unreadSnapshot) {
                  final unreadData = unreadSnapshot.data?.data() ?? {};
                  int count(String key) => (unreadData[key] as num?)?.toInt() ?? 0;
                  return _NeonPanel(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Column(children: [
                      _profileNavigationTile(context: context, icon: Icons.person_add, titleKey: 'friend_requests', unreadKey: 'friendRequests', unread: count('friendRequests'), page: const FriendRequestsPage()),
                      _profileNavigationTile(context: context, icon: Icons.meeting_room, titleKey: 'room_invites', unreadKey: 'roomInvites', unread: count('roomInvites'), page: const RoomInvitesPage()),
                      _profileNavigationTile(context: context, icon: Icons.message, titleKey: 'friend_messages', unreadKey: 'friendMessages', unread: count('friendMessages'), page: const FriendMessagesPage()),
                      _profileNavigationTile(context: context, icon: Icons.card_giftcard, titleKey: 'gifts', unreadKey: 'gifts', unread: count('gifts'), page: const GiftsPage()),
                      _profileNavigationTile(context: context, icon: Icons.notifications, titleKey: 'notifications', unreadKey: 'notifications', unread: count('notifications'), page: const NotificationsPage()),
                      _profileNavigationTile(context: context, icon: Icons.card_giftcard, titleKey: 'my_gifts', unreadKey: 'myGifts', unread: count('myGifts'), page: const MyGiftsPage()),
                      _profileNavigationTile(context: context, icon: Icons.people, titleKey: 'friends', unreadKey: 'friends', unread: count('friends'), page: const FriendsPage()),
                      ListTile(leading: const Icon(Icons.settings), title: Text(AppLanguage.text('settings')), trailing: const Icon(Icons.chevron_right), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsPage()))),
                    ]),
                  );
                },
              ),
            ],
          ),
        );
      }
    }

    /* ============================================================
       FRIEND REQUESTS
       ============================================================ */

    class FriendRequestsPage extends StatelessWidget {
      const FriendRequestsPage({super.key});
      @override
      Widget build(BuildContext context) {
        final user = FirebaseAuth.instance.currentUser;
        if (user == null) return const Scaffold(body: Center(child: Text('Please login first.')));
        return Scaffold(
          appBar: AppBar(title: Text(AppLanguage.text('friend_requests'))),
          body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: PartyChatData.friendRequestsStream(user.uid),
            builder: (context, snapshot) {
              if (snapshot.hasError) return const Center(child: Text('Could not load friend requests.'));
              if (!snapshot.hasData) return const Center(child: SizedBox(width: 110, child: LinearProgressIndicator(minHeight: 3)));
              final docs = snapshot.data!.docs;
              if (docs.isEmpty) return const Center(child: Text('No friend requests yet.'));
              return ListView.separated(
                padding: const EdgeInsets.all(12), itemCount: docs.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final request = docs[index].data();
                  final requesterUid = request['uid']?.toString() ?? docs[index].id;
                  return FutureBuilder<Map<String, dynamic>?>(
                    future: PartyChatData.userData(requesterUid),
                    builder: (context, profileSnapshot) {
                      final data = profileSnapshot.data ?? request;
                      final name = data['name']?.toString() ?? 'Party User';
                      return Card(
                        color: const Color(0xFF0D0A12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18), side: const BorderSide(color: Color(0xFF3B2A55))),
                        child: ListTile(
                          leading: GestureDetector(
                            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => SimpleUserProfilePage(uid: requesterUid))),
                            child: _NetworkOrAvatar(photoUrl: data['photoURL'] as String?, photoBase64: data['photoBase64'] as String?, avatar: data['avatar'] as String?, radius: 24),
                          ),
                          title: Text(name, style: const TextStyle(fontWeight: FontWeight.w800)),
                          trailing: Wrap(children: [
                            IconButton(icon: const Icon(Icons.check_circle_rounded, color: Color(0xFFFFC83D)), onPressed: () async { try { await PartyChatData.acceptFriendRequest(uid: user.uid, requesterUid: requesterUid); } catch (e) { if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString()))); } }),
                            IconButton(icon: const Icon(Icons.cancel_rounded, color: PartyColors.purpleBright), onPressed: () async { try { await PartyChatData.rejectFriendRequest(uid: user.uid, requesterUid: requesterUid); } catch (e) { if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString()))); } }),
                          ]),
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => SimpleUserProfilePage(uid: requesterUid))),
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

    /* ============================================================
       ROOM INVITES
       ============================================================ */

    class RoomInvitesPage extends StatelessWidget {
      const RoomInvitesPage({super.key});

      @override
      Widget build(BuildContext context) {
        final user = FirebaseAuth.instance.currentUser;
        if (user == null) return const Scaffold(body: Center(child: Text('Please login first.')));
        final ref = FirebaseFirestore.instance.collection('users').doc(user.uid).collection('roomInvites');

        return Scaffold(
          appBar: AppBar(title: Text(AppLanguage.text('room_invites'))),
          body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: ref.orderBy('createdAt', descending: true).snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) return const Center(child: Text('Could not load room invites.'));
              if (!snapshot.hasData) return const Center(child: LinearProgressIndicator(minHeight: 3));
              final docs = snapshot.data!.docs;
              if (docs.isEmpty) return const Center(child: Text('No room invites yet.'));
              return ListView.builder(
                itemCount: docs.length,
                itemBuilder: (context, index) {
                  final doc = docs[index];
                  final d = doc.data();
                  final inviterUid = d['inviterUid']?.toString();
                  return FutureBuilder<Map<String, dynamic>?>(
                    future: inviterUid == null ? Future.value(null) : PartyChatData.userData(inviterUid),
                    builder: (context, profileSnapshot) {
                      final profile = profileSnapshot.data ?? d;
                      return ListTile(
                        leading: _NetworkOrAvatar(
                          photoUrl: profile['photoURL'] as String? ?? d['inviterPhoto'] as String?,
                          photoBase64: profile['photoBase64'] as String? ?? d['inviterPhotoBase64'] as String?,
                          avatar: profile['avatar'] as String?,
                          radius: 24,
                        ),
                        title: Text(d['roomTitle'] ?? 'PartyChat Room'),
                        subtitle: Text('${profile['name'] ?? d['inviterName'] ?? 'Someone'} ne invite kiya.'),
                        trailing: FilledButton(
                          onPressed: () async {
                            await doc.reference.update({'status': 'accepted'});
                            if (!context.mounted) return;
                            Navigator.push(context, MaterialPageRoute(builder: (_) => RoomPage(title: d['roomTitle'] ?? 'PartyChat Room', online: 'Live')));
                          },
                          child: const Text('Join'),
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

    /* ============================================================
       FRIEND MESSAGES
       ============================================================ */

    class FriendMessagesPage extends StatelessWidget {
      const FriendMessagesPage({super.key});

      @override
      Widget build(BuildContext context) {
        final user = FirebaseAuth.instance.currentUser;
        if (user == null) return const Scaffold(body: Center(child: Text('Please login first.')));
        final ref = FirebaseFirestore.instance.collection('users').doc(user.uid).collection('chats');

        return Scaffold(
          appBar: AppBar(title: Text(AppLanguage.text('friend_messages'))),
          body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: ref.orderBy('lastMessageAt', descending: true).snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) return const Center(child: Text('Could not load chats.'));
              if (!snapshot.hasData) return const Center(child: LinearProgressIndicator(minHeight: 3));
              final docs = snapshot.data!.docs;
              if (docs.isEmpty) return const Center(child: Text('No messages yet.'));
              return ListView.builder(
                itemCount: docs.length,
                itemBuilder: (context, index) {
                  final d = docs[index].data();
                  final otherUid = d['otherUid'] as String? ?? '';
                  return FutureBuilder<Map<String, dynamic>?>(
                    future: PartyChatData.userData(otherUid),
                    builder: (context, userSnap) {
                      final other = userSnap.data ?? {};
                      return ListTile(
                        leading: _NetworkOrAvatar(
                          photoUrl: other['photoURL'] as String?,
                          avatar: other['avatar'] as String?,
                        ),
                        title: Text(other['name'] ?? 'Friend'),
                        subtitle: Text(d['lastMessage'] ?? ''),
                        onTap: () => Navigator.push(context, MaterialPageRoute(
                          builder: (_) => ChatPage(
                            otherUid: otherUid,
                            otherName: other['name'] ?? 'Friend',
                          ),
                        )),
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

    /* ============================================================
       GIFTS
       ============================================================ */

    class GiftsPage extends StatelessWidget {
      const GiftsPage({super.key});

      @override
      Widget build(BuildContext context) {
        final user = FirebaseAuth.instance.currentUser;
        if (user == null) return const Scaffold(body: Center(child: Text('Please login first.')));
        final ref = FirebaseFirestore.instance.collection('users').doc(user.uid).collection('gifts');

        return Scaffold(
          appBar: AppBar(title: Text(AppLanguage.text('gifts'))),
          body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: ref.orderBy('createdAt', descending: true).snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) return const Center(child: Text('Could not load gifts.'));
              if (!snapshot.hasData) return const Center(child: LinearProgressIndicator(minHeight: 3));
              final docs = snapshot.data!.docs;
              if (docs.isEmpty) return const Center(child: Text('No gifts yet.'));
              return ListView.builder(
                itemCount: docs.length,
                itemBuilder: (context, index) {
                  final d = docs[index].data();
                  return ListTile(
                    leading: const CircleAvatar(child: Icon(Icons.card_giftcard)),
                    title: Text(d['giftName'] ?? 'Gift'),
                    subtitle: Text('From: ${d['senderName'] ?? 'Party User'} • ${d['cost'] ?? 0} coins'),
                  );
                },
              );
            },
          ),
        );
      }
    }

    /* ============================================================
       MY GIFTS
       ============================================================ */

    class MyGiftsPage extends StatelessWidget {
      const MyGiftsPage({super.key});

      @override
      Widget build(BuildContext context) {
        final user = FirebaseAuth.instance.currentUser;
        if (user == null) return const Scaffold(body: Center(child: Text('Please login first.')));
        final ref = FirebaseFirestore.instance.collection('users').doc(user.uid).collection('sentGifts');

        return Scaffold(
          appBar: AppBar(title: Text(AppLanguage.text('my_gifts'))),
          body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: ref.orderBy('createdAt', descending: true).snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) return const Center(child: Text('Could not load gifts.'));
              if (!snapshot.hasData) return const Center(child: LinearProgressIndicator(minHeight: 3));
              final docs = snapshot.data!.docs;
              if (docs.isEmpty) return const Center(child: Text('Your sent gifts will appear here.'));
              return ListView.builder(
                itemCount: docs.length,
                itemBuilder: (context, index) {
                  final d = docs[index].data();
                  return ListTile(
                    leading: const CircleAvatar(child: Icon(Icons.card_giftcard)),
                    title: Text(d['giftName'] ?? 'Gift'),
                    subtitle: Text('To: ${d['receiverName'] ?? 'Party User'} • ${d['cost'] ?? 0} coins'),
                  );
                },
              );
            },
          ),

        );
      }
    }




    /* ============================================================
       FRIENDS + FIND FRIENDS
       ============================================================ */

    class FriendsPage extends StatefulWidget {
      const FriendsPage({super.key});
      @override
      State<FriendsPage> createState() => _FriendsPageState();
    }

    class _FriendsPageState extends State<FriendsPage> {
      @override
      Widget build(BuildContext context) {
        final user = FirebaseAuth.instance.currentUser;
        if (user == null) return const Scaffold(body: Center(child: Text('Please login first.')));
        return Scaffold(
          appBar: AppBar(title: Text(AppLanguage.text('friends'))),
          body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: PartyChatData.friendsStream(user.uid),
            builder: (context, snapshot) {
              if (snapshot.hasError) return const Center(child: Text('Could not load friends.'));
              if (!snapshot.hasData) return const Center(child: SizedBox(width: 110, child: LinearProgressIndicator(minHeight: 3)));
              final docs = snapshot.data!.docs;
              if (docs.isEmpty) return const Center(child: Text('No friends yet.'));
              return ListView.separated(
                padding: const EdgeInsets.all(12),
                itemCount: docs.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final data = docs[index].data();
                  final uid = data['uid']?.toString() ?? docs[index].id;
                  final name = data['name']?.toString() ?? 'Friend';
                  return Card(
                    color: const Color(0xFF0D0A12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18), side: const BorderSide(color: Color(0xFF3B2A55))),
                    child: ListTile(
                      leading: GestureDetector(
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => SimpleUserProfilePage(uid: uid))),
                        child: _NetworkOrAvatar(photoUrl: data['photoURL'] as String?, photoBase64: data['photoBase64'] as String?, avatar: data['avatar'] as String?, radius: 24),
                      ),
                      title: Text(name, style: const TextStyle(fontWeight: FontWeight.w800)),
                      trailing: Wrap(children: [
                        IconButton(icon: const Icon(Icons.message_rounded, color: Color(0xFFFFC83D)), onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ChatPage(otherUid: uid, otherName: name)))),
                        IconButton(icon: const Icon(Icons.card_giftcard_rounded, color: PartyColors.purpleBright), onPressed: () => _giftDialog(context, user.uid, uid, name)),
                        IconButton(icon: const Icon(Icons.block_rounded, color: Colors.white60), onPressed: () => _block(context, user.uid, uid, data)),
                      ]),
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => SimpleUserProfilePage(uid: uid))),
                    ),
                  );
                },
              );
            },
          ),
        );
      }

      Future<void> _giftDialog(BuildContext context, String fromUid, String toUid, String name) async {
        final gifts = [{'name':'Rose 🌹','cost':10},{'name':'Heart ❤️','cost':50},{'name':'Crown 👑','cost':100},{'name':'Diamond 💎','cost':500}];
        await showModalBottomSheet(
          context: context,
          backgroundColor: const Color(0xFF0D0A12),
          builder: (_) => SafeArea(child: Column(mainAxisSize: MainAxisSize.min, children: [
            Padding(padding: const EdgeInsets.all(16), child: Text('Gift for $name', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
            ...gifts.map((gift) => ListTile(title: Text(gift['name'] as String), trailing: Text('${gift['cost']} coins'), onTap: () async {
              try {
                await PartyChatData.sendGift(fromUid: fromUid, toUid: toUid, giftName: gift['name'] as String, cost: gift['cost'] as int);
                if (context.mounted) { Navigator.pop(context); ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Gift sent successfully.'))); }
              } catch (e) { if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString()))); }
            })),
          ])),
        );
      }

      Future<void> _block(BuildContext context, String uid, String otherUid, Map<String, dynamic> data) async {
        try { await PartyChatData.blockUser(uid: uid, otherUid: otherUid, otherData: data); if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('User blocked successfully.'))); }
        catch (e) { if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString()))); }
      }
    }

    /* ============================================================
       CHAT
       ============================================================ */

    class ChatPage extends StatefulWidget {
      final String otherUid;
      final String otherName;

      const ChatPage({
        super.key,
        required this.otherUid,
        required this.otherName,
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
        final user = FirebaseAuth.instance.currentUser;
        if (user == null) return const Scaffold(body: Center(child: Text('Please login first.')));
        final id = PartyChatData.chatId(user.uid, widget.otherUid);
        final ref = FirebaseFirestore.instance.collection('chats').doc(id).collection('messages');

        return Scaffold(
          appBar: AppBar(title: Text(widget.otherName)),
          body: Column(
            children: [
              Expanded(
                child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: ref.orderBy('createdAt', descending: false).snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) return const Center(child: Text('Could not load messages.'));
                    if (!snapshot.hasData) return const Center(child: LinearProgressIndicator(minHeight: 3));
                    final docs = snapshot.data!.docs;
                    if (docs.isEmpty) return const Center(child: Text('Say hello 👋'));
                    return ListView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: docs.length,
                      itemBuilder: (context, index) {
                        final d = docs[index].data();
                        final mine = d['senderUid'] == user.uid;
                        final time = partyMessageTime(d['createdAt']);
                        return Align(
                          alignment: mine ? Alignment.centerRight : Alignment.centerLeft,
                          child: Container(
                            constraints: const BoxConstraints(maxWidth: 310),
                            margin: const EdgeInsets.only(bottom: 9),
                            padding: const EdgeInsets.fromLTRB(14, 10, 14, 7),
                            decoration: BoxDecoration(
                              gradient: mine
                                  ? const LinearGradient(colors: [PartyColors.purple, PartyColors.purpleBright])
                                  : const LinearGradient(colors: [PartyColors.panel, PartyColors.black2]),
                              border: Border.all(
                                color: mine
                                    ? PartyColors.purpleBright.withOpacity(.55)
                                    : PartyColors.gold.withOpacity(.25),
                              ),
                              borderRadius: BorderRadius.only(
                                topLeft: const Radius.circular(17),
                                topRight: const Radius.circular(17),
                                bottomLeft: Radius.circular(mine ? 17 : 5),
                                bottomRight: Radius.circular(mine ? 5 : 17),
                              ),
                              boxShadow: const [BoxShadow(color: Color(0x331D0060), blurRadius: 12)],
                            ),
                            child: Column(
                              crossAxisAlignment: mine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                              children: [
                                Text(d['text'] ?? '', style: const TextStyle(color: Colors.white, fontSize: 15)),
                                const SizedBox(height: 4),
                                Text(
                                  time,
                                  style: TextStyle(
                                    color: mine ? Colors.white70 : PartyColors.goldBright,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
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
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: controller,
                          decoration: const InputDecoration(
                            hintText: 'Message...',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.send),
                        onPressed: () async {
                          final text = controller.text.trim();
                          if (text.isEmpty) return;
                          try {
                            await PartyChatData.sendMessage(
                              fromUid: user.uid,
                              toUid: widget.otherUid,
                              text: text,
                            );
                            controller.clear();
                          } catch (e) {
                            if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }
    }

    /* ============================================================
       SIMPLE IMAGE HELPER
       ============================================================ */

    class _NetworkOrAvatar extends StatelessWidget {
      final String? photoUrl;
      final String? photoBase64;
      final String? avatar;
      final double radius;
      const _NetworkOrAvatar({required this.photoUrl, required this.avatar, this.photoBase64, this.radius = 20});
      @override
      Widget build(BuildContext context) {
        ImageProvider<Object>? image;
        if (photoBase64 != null && photoBase64!.isNotEmpty) { try { image = MemoryImage(base64Decode(photoBase64!)); } catch (_) {} }
        if (image == null && photoUrl != null && photoUrl!.isNotEmpty) image = NetworkImage(photoUrl!);
        if (image != null) return CircleAvatar(radius: radius, backgroundImage: image);
        return CircleAvatar(radius: radius, backgroundColor: const Color(0xFF241A33), child: Icon(Icons.person_rounded, color: const Color(0xFFFFC83D), size: radius * .9));
      }
    }

    /* ============================================================
       SETTINGS
       ============================================================ */

    class SettingsPage extends StatelessWidget {
      const SettingsPage({super.key});

      @override
      Widget build(BuildContext context) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              AppLanguage.text('settings'),
            ),
          ),
          body: ListView(
            children: [
              ListTile(
                leading: const Icon(Icons.lock),
                title: Text(

                  AppLanguage.text('privacy'),
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const PrivacyPage(),
                    ),
                  );
                },
              ),

              ListTile(
                leading: const Icon(Icons.language),
                title: Text(
                  AppLanguage.text('language'),
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const LanguagePage(),
                    ),
                  );
                },
              ),

              ListTile(
                leading: const Icon(Icons.person),
                title: Text(
                  AppLanguage.text('account'),
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const AccountPage(),
                    ),
                  );
                },
              ),

              ListTile(
                leading: const Icon(Icons.block),
                title: Text(
                  AppLanguage.text('blocked_users'),
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          const BlockedUsersPage(),
                    ),
                  );
                },
              ),

              ListTile(
                leading: const Icon(Icons.help_outline),
                title: Text(
                  AppLanguage.text('help_center'),
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          const HelpCenterPage(),
                    ),
                  );
                },
              ),

              const Divider(),

              ListTile(
                leading: const Icon(Icons.logout),
                title: Text(
                  AppLanguage.text('logout'),
                ),
                onTap: () async {
                  try {
                    await FirebaseAuth.instance.signOut();
                  } catch (e) {
                    debugPrint(
                      'Logout failed: $e',
                    );
                  }

                  if (!context.mounted) return;

                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const WelcomePage(),
                    ),
                    (route) => false,
                  );
                },
              ),
            ],
          ),
        );
      }
    }

    /* ============================================================
       ACCOUNT
       ============================================================ */

    class AccountPage extends StatelessWidget {
      const AccountPage({super.key});

      @override
      Widget build(BuildContext context) {
        final user = FirebaseAuth.instance.currentUser;

        if (user == null) {
          return Scaffold(
            appBar: AppBar(
                        title: Text(
                AppLanguage.text('account'),
              ),
            ),
            body: const Center(
              child: Text(
                'Please login first.',
              ),
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(
              AppLanguage.text('account'),
            ),
          ),
          body: ListView(
            children: [
              ListTile(
                leading: const Icon(Icons.email),
                title: const Text('Email'),
                subtitle: Text(
                  user.email ?? 'Not available',
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  _showEmailDialog(
                    context,
                    user,
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.phone),
                title: const Text('Mobile Number'),
                subtitle: const Text('Not linked'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  _showComingSoon(
                    context,
                    'Mobile Number',
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.facebook),
                title: const Text('Facebook'),
                subtitle: const Text('Not connected'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  _showComingSoon(
                    context,
                    'Facebook',
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.alternate_email),
                title: const Text('Twitter'),
                subtitle: const Text('Not connected'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  _showComingSoon(
                    context,
                    'Twitter',
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.security),
                title: const Text(
                  'Password & Security',
                ),
                subtitle: const Text(
                  'Manage your password and security',
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  _showComingSoon(
                    context,
                    'Password & Security',
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.devices),
                title: const Text(
                  'Login Devices',
                ),
                subtitle: const Text(
                  'Manage devices signed in to your account',
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  _showComingSoon(
                    context,
                    'Login Devices',
                  );
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(
                  Icons.delete_forever,
                  color: Colors.red,
                ),
                title: const Text(
                  'Delete Account',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: const Text(
                  'Permanently delete your PartyChat account',
                ),
                onTap: () {
                  _showDeleteAccountDialog(
                    context,
                    user,
                  );
                },
              ),
            ],
          ),
        );
      }

      static Future<void> _showEmailDialog(
        BuildContext context,
        User user,
      ) async {
        final controller = TextEditingController(
          text: user.email ?? '',
        );

        await showDialog(
          context: context,
          builder: (dialogContext) {
            return AlertDialog(
              title: const Text('Email'),
              content: TextField(
                controller: controller,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(dialogContext);
                  },
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: () async {
                    final email =
                        controller.text.trim();

                    if (email.isEmpty) return;

                    try {
                      await user.verifyBeforeUpdateEmail(
                        email,
                      );

                      if (!dialogContext.mounted) return;

                      Navigator.pop(dialogContext);

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Verification email sent. Please verify your new email.',
                          ),
                        ),
                      );
                    } catch (e) {
                      if (!dialogContext.mounted) return;

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Could not change email: $e',
                          ),
                        ),
                      );
                    }
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );

        controller.dispose();
      }

      static void _showComingSoon(
        BuildContext context,
        String feature,
      ) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '$feature setup will be completed next.',
            ),
          ),
        );
      }

      static Future<void> _showDeleteAccountDialog(
        BuildContext context,
        User user,
      ) async {
        final confirmController =
            TextEditingController();

        await showDialog(
          context: context,
          builder: (dialogContext) {
            return AlertDialog(
              title: const Text(
                'Delete Account?',
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'This will permanently delete your PartyChat account. '
                    'This action cannot be undone.',
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller: confirmController,
                    decoration: const InputDecoration(
                      labelText: 'Type DELETE to confirm',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(dialogContext);
                  },
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  onPressed: () async {
                    if (confirmController.text.trim() !=
                        'DELETE') {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Please type DELETE to confirm.',
                          ),
                        ),
                      );
                      return;
                    }

                    try {
                      await FirebaseFirestore.instance
                          .collection('users')
                          .doc(user.uid)
                          .delete();

                      await user.delete();

                      if (!dialogContext.mounted) return;

                      Navigator.pop(dialogContext);

                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              const WelcomePage(),
                        ),
                        (route) => false,
                      );
                    } catch (e) {
                      if (!dialogContext.mounted) return;

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Account deletion failed: $e',
                          ),
                        ),
                      );
                    }
                  },
                  child: const Text('Delete'),
                ),
              ],
            );
          },
        );

        confirmController.dispose();
      }
    }

    /* ============================================================
       PRIVACY
       ============================================================ */

    class PrivacyPage extends StatefulWidget {
      const PrivacyPage({super.key});

      @override
      State<PrivacyPage> createState() =>
          _PrivacyPageState();
    }

    class _PrivacyPageState
        extends State<PrivacyPage> {
      User? get user =>
          FirebaseAuth.instance.currentUser;

      String profileVisibility = 'Everyone';
      String photoVisibility = 'Everyone';
      String messagePermission = 'Everyone';
      String giftPermission = 'Everyone';

      bool onlineStatus = true;
      bool roomActivity = true;
      bool privateAccount = false;

      @override
      void initState() {
        super.initState();
        _loadPrivacySettings();
      }

      Future<void> _loadPrivacySettings() async {
        final currentUser = user;

        if (currentUser == null) return;

        try {
          final doc = await FirebaseFirestore.instance
              .collection('users')
              .doc(currentUser.uid)
              .get();

          if (!doc.exists) return;

          final data = doc.data()!;

          if (!mounted) return;

          setState(() {
            profileVisibility =
                data['profileVisibility'] ?? 'Everyone';

            photoVisibility =
                data['photoVisibility'] ?? 'Everyone';

            messagePermission =
                data['messagePermission'] ?? 'Everyone';

            giftPermission =
                data['giftPermission'] ?? 'Everyone';

            onlineStatus =
                data['onlineStatus'] ?? true;

            roomActivity =
                data['roomActivity'] ?? true;

            privateAccount =
                data['privateAccount'] ?? false;
          });
        } catch (e) {
          debugPrint(
            'Privacy load failed: $e',
          );
        }
      }

      Future<void> _saveField(
        String field,
        dynamic value,
      ) async {
        final currentUser = user;

        if (currentUser == null) return;

        await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .set(
          {field: value},
          SetOptions(merge: true),
        );
      }

      @override
      Widget build(BuildContext context) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              AppLanguage.text('privacy'),
            ),
          ),
          body: ListView(
            children: [
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text(
                  'Who can view my profile',
                ),
                subtitle: Text(profileVisibility),
                trailing: const Icon(
                  Icons.chevron_right,
                ),
                onTap: () {
                  _chooseOption(
                    context,
                    'Who can view my profile',
                    [
                      'Everyone',
                      'Friends Only',
                      'Nobody',
                    ],
                    profileVisibility,
                    (value) async {
                      setState(() {
                        profileVisibility = value;
                      });

                      await _saveField(
                        'profileVisibility',
                        value,
                      );
                    },
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo),
                title: const Text(
                  'Who can view my profile photo',
                ),
                subtitle: Text(photoVisibility),
                trailing: const Icon(
                  Icons.chevron_right,
                ),
                onTap: () {
                  _chooseOption(
                    context,
                    'Who can view my profile photo',
                    [
                      'Everyone',
                      'Friends Only',
                      'Nobody',
                    ],
                    photoVisibility,
                    (value) async {
                      setState(() {
                        photoVisibility = value;
                      });

                      await _saveField(
                        'photoVisibility',
                        value,
                      );
                    },
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.message),
                title: const Text(
                  'Who can message me',
                ),
                subtitle: Text(messagePermission),
                trailing: const Icon(
                  Icons.chevron_right,
                ),
                onTap: () {
                  _chooseOption(
                    context,
                    'Who can message me',
                    [
                      'Everyone',
                      'Friends Only',
                      'Nobody',
                    ],
                    messagePermission,
                    (value) async {
                      setState(() {
                        messagePermission = value;
                      });

                      await _saveField(
                        'messagePermission',
                        value,
                      );
                    },
                  );
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.card_giftcard,
                ),
                title: const Text(
                  'Who can send me gifts',
                ),
                subtitle: Text(giftPermission),
                trailing: const Icon(
                  Icons.chevron_right,
                ),
                onTap: () {
                  _chooseOption(
                    context,
                    'Who can send me gifts',
                    [
                      'Everyone',
                      'Friends Only',
                      'Nobody',
                    ],
                    giftPermission,
                    (value) async {
                      setState(() {
                        giftPermission = value;
                      });

                      await _saveField(
                        'giftPermission',
                        value,
                      );
                    },
                  );
                },
              ),
              SwitchListTile(
                secondary: const Icon(Icons.circle),
                title: Text(
                  AppLanguage.text('online_status'),
                ),
                subtitle: const Text(
                  'Show when I am online',
                ),
                value: onlineStatus,
                onChanged: (value) async {
                  setState(() {
                    onlineStatus = value;
                  });

                  await _saveField(
                    'onlineStatus',
                    value,
                  );
                },
              ),
              SwitchListTile(
                secondary: const Icon(
                  Icons.meeting_room,
                ),
                title: Text(
                  AppLanguage.text('room_activity'),
                ),
                subtitle: const Text(
                  'Show my room activity to others',
                ),
                value: roomActivity,
                onChanged: (value) async {
                  setState(() {
                    roomActivity = value;
                  });

                  await _saveField(
                    'roomActivity',
                    value,
                  );
                },
              ),
              SwitchListTile(
                secondary: const Icon(Icons.lock),
                title: Text(
                  AppLanguage.text('private_account'),
                ),
                subtitle: const Text(
                  'Only approved people can interact with me',
                ),
                value: privateAccount,
                onChanged: (value) async {
                  setState(() {
                    privateAccount = value;
                  });

                  await _saveField(
                    'privateAccount',
                    value,
                  );
                },
              ),

              // Blocked Users intentionally removed.
            ],
          ),
        );
      }

      void _chooseOption(
        BuildContext context,
        String title,
        List<String> options,
        String currentValue,
        ValueChanged<String> onSelected,
      ) {
        showModalBottomSheet(
          context: context,
          builder: (sheetContext) {
            return SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ...options.map(
                    (option) => ListTile(
                      title: Text(option),
                      trailing: option == currentValue
                          ? const Icon(Icons.check)
                          : null,
                      onTap: () {
                        onSelected(option);
                        Navigator.pop(sheetContext);
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      }
    }

    /* ============================================================
       LANGUAGE PAGE
       ============================================================ */

    class LanguagePage extends StatelessWidget {
      const LanguagePage({super.key});

      @override
      Widget build(BuildContext context) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              AppLanguage.text('language'),
            ),
          ),
          body: ValueListenableBuilder<String>(
            valueListenable: AppLanguage.current,
            builder: (context, selectedLanguage, child) {
              return ListView.builder(
                itemCount: AppLanguage.languages.length,
                itemBuilder: (context, index) {
                  final language =
                      AppLanguage.languages[index];

                  return ListTile(
                    title: Text(language),
                    trailing:
                        language == selectedLanguage
                            ? const Icon(Icons.check)
                            : null,
                    onTap: () async {
                      await AppLanguage.change(
                        language,
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

    /* ============================================================
       NOTIFICATIONS
       ============================================================ */

    class NotificationsPage extends StatefulWidget {
      const NotificationsPage({super.key});

      @override
      State<NotificationsPage> createState() => _NotificationsPageState();
    }

    class _NotificationsPageState extends State<NotificationsPage> {
      bool messages = true;
      bool announcements = true;

      Future<void> _markAllRead() async {
        final user = FirebaseAuth.instance.currentUser;
        if (user == null) return;
        await ProfileUnreadService.markRead(user.uid, 'notifications');
      }

      @override
      Widget build(BuildContext context) {
        final user = FirebaseAuth.instance.currentUser;
        if (user == null) return const Scaffold(body: Center(child: Text('Please login first.')));
        final ref = FirebaseFirestore.instance.collection('users').doc(user.uid).collection('notifications');

        return Scaffold(
          appBar: AppBar(
            title: Text(AppLanguage.text('notifications')),
            actions: [
              TextButton(onPressed: _markAllRead, child: const Text('Read all')),
            ],
          ),
          body: ListView(
            children: [
              SwitchListTile(
                title: Text(AppLanguage.text('messages')),
                subtitle: const Text('Message notifications on/off'),
                value: messages,
                onChanged: (v) => setState(() => messages = v),
              ),
              SwitchListTile(
                title: Text(AppLanguage.text('announcements')),
                subtitle: const Text('PartyChat announcements on/off'),
                value: announcements,
                onChanged: (v) => setState(() => announcements = v),
              ),
              const Divider(),
              StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: ref.orderBy('createdAt', descending: true).snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) return const Padding(
                    padding: EdgeInsets.all(20),
                    child: Text('Could not load notifications.'),
                  );
                  if (!snapshot.hasData) return const Padding(
                    padding: EdgeInsets.all(20),
                    child: Center(child: LinearProgressIndicator(minHeight: 3)),
                  );
                  final docs = snapshot.data!.docs;
                  if (docs.isEmpty) return const Padding(
                    padding: EdgeInsets.all(20),
                    child: Center(child: Text('No notifications yet.')),
                  );
                  return Column(
                    children: docs.map((doc) {
                      final d = doc.data();
                      final read = d['isRead'] == true;
                      return ListTile(
                        tileColor: read ? null : const Color(0xFF15111F),
                        leading: Icon(
                          read ? Icons.notifications_none : Icons.notifications_active,
                        ),
                        title: Text(d['title'] ?? 'Notification'),
                        subtitle: Text(d['message'] ?? ''),
                        trailing: read ? null : const CircleAvatar(
                          radius: 5,
                          backgroundColor: Colors.red,
                        ),
                        onTap: () async {
                          await doc.reference.update({
                            'isRead': true,
                            'readAt': FieldValue.serverTimestamp(),
                          });
                          await ProfileUnreadService.markRead(user.uid, d['badgeKey'] ?? 'notifications');
                        },
                      );
                    }).toList(),
                  );
                },
              ),
            ],
          ),
        );
      }
    }

    /* ============================================================
       BLOCKED USERS
       ============================================================ */

    class BlockedUsersPage extends StatelessWidget {
      const BlockedUsersPage({super.key});

      @override
      Widget build(BuildContext context) {
        final user = FirebaseAuth.instance.currentUser;
        if (user == null) return const Scaffold(body: Center(child: Text('Please login first.')));
        final ref = FirebaseFirestore.instance.collection('users').doc(user.uid).collection('blockedUsers');

        return Scaffold(
          appBar: AppBar(title: Text(AppLanguage.text('blocked_users'))),
          body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: ref.snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) return const Center(child: Text('Could not load blocked users.'));
              if (!snapshot.hasData) return const Center(child: LinearProgressIndicator(minHeight: 3));
              final docs = snapshot.data!.docs;
              if (docs.isEmpty) return const Center(child: Text('No blocked users.'));
              return ListView.builder(
                itemCount: docs.length,
                itemBuilder: (context, index) {
                  final doc = docs[index];
                  final d = doc.data();
                  return ListTile(
                    leading: _NetworkOrAvatar(
                      photoUrl: d['photoURL'] as String?,
                      avatar: d['avatar'] as String?,
                    ),
                    title: Text(d['name'] ?? 'Blocked User'),
                    subtitle: Text(d['email'] ?? ''),
                    trailing: OutlinedButton(
                      onPressed: () async {
                        await PartyChatData.unblockUser(user.uid, doc.id);
                        if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('User unblock kar diya.')),
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

    /* ============================================================
   HELP CENTER
   ============================================================ */

class HelpCenterPage extends StatefulWidget {
  const HelpCenterPage({super.key});

  @override
  State<HelpCenterPage> createState() => _HelpCenterPageState();
}

class _HelpCenterPageState extends State<HelpCenterPage> {
  final searchController = TextEditingController();

  final categories = const [
    'Account & Login',
    'Friends & Chat',
    'Rooms',
    'Gifts',
    'Wallet & Payments',
    'Privacy & Security',
    'Report a Problem',
  ];

  final faqs = const [
    {
      'question': 'How do I change my profile name?',
      'answer':
          'Open Profile, tap your name and follow the name change option.',
      'category': 'Account & Login',
    },
    {
      'question': 'How do I send a friend request?',
      'answer':
          'Search for a user and tap the Add Friend button.',
      'category': 'Friends & Chat',
    },
    {
      'question': 'How do I join a room?',
      'answer':
          'Open Rooms and select the room you want to join.',
      'category': 'Rooms',
    },
    {
      'question': 'How do I send a gift?',
      'answer':
          'Open a room, select a user and choose a gift from the gift panel.',
      'category': 'Gifts',
    },
    {
      'question': 'How do I recharge my wallet?',
      'answer':
          'Open Wallet and choose the available recharge option.',
      'category': 'Wallet & Payments',
    },
    {
      'question': 'How do I protect my account?',
      'answer':
          'Use a strong password and review your privacy and security settings.',
      'category': 'Privacy & Security',
    },
    {
      'question': 'How do I report a problem?',
      'answer':
          'Open Contact Support and submit your problem to PartyChat Support.',
      'category': 'Report a Problem',
    },
  ];

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> _createTicket() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please login first.'),
        ),
      );
      return;
    }

    final subjectController = TextEditingController();
    final messageController = TextEditingController();

    XFile? selectedImage;
    bool uploading = false;

    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            Future<void> pickScreenshot() async {
              final picker = ImagePicker();

              final image = await picker.pickImage(
                source: ImageSource.gallery,
                imageQuality: 80,
                maxWidth: 1600,
              );

              if (image != null) {
                setDialogState(() {
                  selectedImage = image;
                });
              }
            }

            Future<void> submitTicket() async {
              final subject =
                  subjectController.text.trim();

              final message =
                  messageController.text.trim();

              if (subject.isEmpty || message.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Please enter a subject and describe your problem.',
                    ),
                  ),
                );
                return;
              }

              setDialogState(() {
                uploading = true;
              });

              try {
                final ticketRef = FirebaseFirestore.instance
                    .collection('supportTickets')
                    .doc();

                String screenshotUrl = '';

                if (selectedImage != null) {
                  final fileName =
                      '${DateTime.now().millisecondsSinceEpoch}.jpg';

                  final storageRef =
                      FirebaseStorage.instance
                          .ref()
                          .child('supportScreenshots')
                          .child(user.uid)
                          .child(ticketRef.id)
                          .child(fileName);

                  await storageRef.putData(
                    await selectedImage!.readAsBytes(),
                    SettableMetadata(
                      contentType: 'image/jpeg',
                    ),
                  );

                  screenshotUrl =
                      await storageRef.getDownloadURL();
                }

                await ticketRef.set({
                  'userId': user.uid,
                  'userEmail': user.email ?? '',
                  'subject': subject,
                  'message': message,
                  'screenshotUrl': screenshotUrl,
                  'status': 'Open',
                  'createdAt':
                      FieldValue.serverTimestamp(),
                  'updatedAt':
                      FieldValue.serverTimestamp(),
                });

                if (dialogContext.mounted) {
                  Navigator.pop(
                    dialogContext,
                    true,
                  );
                }
              } catch (e) {
                setDialogState(() {
                  uploading = false;
                });

                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Ticket upload failed: $e',
                      ),
                    ),
                  );
                }
              }
            }

            return AlertDialog(
              title: const Text(
                'Contact Support',
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: subjectController,
                      enabled: !uploading,
                      decoration: const InputDecoration(
                        labelText: 'Subject',
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: messageController,
                      enabled: !uploading,
                      maxLines: 5,
                      decoration: const InputDecoration(
                        labelText: 'Describe your problem',
                      ),
                    ),
                    const SizedBox(height: 14),
                    OutlinedButton.icon(
                      onPressed:
                          uploading ? null : pickScreenshot,
                      icon: const Icon(
                        Icons.image_outlined,
                      ),
                      label: Text(
                        selectedImage == null
                            ? 'Attach Screenshot'
                            : 'Screenshot Selected',
                      ),
                    ),
                    if (selectedImage != null)
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 8),
                        child: Text(
                          selectedImage!.name,
                          maxLines: 1,
                          overflow:
                              TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: PartyColors.gold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: uploading
                      ? null
                      : () => Navigator.pop(
                            dialogContext,
                            false,
                          ),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed:
                      uploading ? null : submitTicket,
                  child: uploading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child:
                              CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        )
                      : const Text('Submit'),
                ),
              ],
            );
          },
        );
      },
    );

    subjectController.dispose();
    messageController.dispose();

    if (result == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Support request submitted successfully.',
          ),
        ),
      );
    }
  }

  void _showFaq(
    BuildContext context,
    String question,
    String answer,
  ) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text(question),
          content: Text(answer),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _showCategory(String category) {
    final categoryFaqs = faqs.where(
      (faq) => faq['category'] == category,
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(16),
            shrinkWrap: true,
            children: [
              Text(
                category,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              ...categoryFaqs.map(
                (faq) => Card(
                  child: ListTile(
                    leading: const Icon(
                      Icons.question_answer_outlined,
                    ),
                    title: Text(faq['question']!),
                    trailing: const Icon(
                      Icons.chevron_right,
                    ),
                    onTap: () {
                      Navigator.pop(context);

                      _showFaq(
                        this.context,
                        faq['question']!,
                        faq['answer']!,
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final query =
        searchController.text.trim().toLowerCase();

    final filteredFaqs = faqs.where((faq) {
      if (query.isEmpty) {
        return true;
      }

      return faq['question']!
              .toLowerCase()
              .contains(query) ||
          faq['answer']!
              .toLowerCase()
              .contains(query) ||
          faq['category']!
              .toLowerCase()
              .contains(query);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLanguage.text('help_center'),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: searchController,
            decoration: InputDecoration(
              hintText: 'Search help',
              prefixIcon: const Icon(
                Icons.search,
              ),
              suffixIcon: searchController.text.isEmpty
                  ? null
                  : IconButton(
                      onPressed: () {
                        searchController.clear();
                        setState(() {});
                      },
                      icon: const Icon(
                        Icons.clear,
                      ),
                    ),
            ),
            onChanged: (_) {
              setState(() {});
            },
          ),
          const SizedBox(height: 20),
          const Text(
            'Help Categories',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          ...categories.map(
            (category) => Card(
              child: ListTile(
                leading: const Icon(
                  Icons.help_outline,
                ),
                title: Text(category),
                trailing: const Icon(
                  Icons.chevron_right,
                ),
                onTap: () {
                  _showCategory(category);
                },
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Frequently Asked Questions',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          if (filteredFaqs.isEmpty)
            const Padding(
              padding: EdgeInsets.all(16),
              child: Center(
                child: Text(
                  'No help articles found.',
                ),
              ),
            ),
          ...filteredFaqs.map(
            (faq) => Card(
              child: ListTile(
                leading: const Icon(
                  Icons.question_answer_outlined,
                ),
                title: Text(faq['question']!),
                trailing: const Icon(
                  Icons.chevron_right,
                ),
                onTap: () {
                  _showFaq(
                    context,
                    faq['question']!,
                    faq['answer']!,
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 20),
          Card(
            child: ListTile(
              leading: const Icon(
                Icons.support_agent,
              ),
              title: const Text(
                'Contact Support',
              ),
              subtitle: const Text(
                'Create a support request',
              ),
              trailing: const Icon(
                Icons.chevron_right,
              ),
              onTap: _createTicket,
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(
                Icons.receipt_long,
              ),
              title: const Text(
                'My Requests',
              ),
              subtitle: const Text(
                'View your support requests',
              ),
              trailing: const Icon(
                Icons.chevron_right,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        const MySupportRequestsPage(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}


/* ============================================================
       MY SUPPORT REQUESTS
       ============================================================ */





class MySupportRequestsPage extends StatelessWidget {
  const MySupportRequestsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('My Requests'),
        ),
        body: const Center(
          child: Text('Please login first.'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Requests'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('supportTickets')
            .where('userId', isEqualTo: user.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Failed to load requests.\n${snapshot.error}',
                textAlign: TextAlign.center,
              ),
            );
          }

          final docs = snapshot.data?.docs ?? [];

          if (docs.isEmpty) {
            return const Center(
              child: Text(
                'No support requests yet.',
              ),
            );
          }

          docs.sort((a, b) {
            final aData = a.data() as Map<String, dynamic>;
            final bData = b.data() as Map<String, dynamic>;

            final aTime = aData['createdAt'];
            final bTime = bData['createdAt'];

            if (aTime is Timestamp && bTime is Timestamp) {
              return bTime.compareTo(aTime);
            }

            return 0;
          });

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final doc = docs[index];
              final data = doc.data() as Map<String, dynamic>;

              final subject =
                  data['subject']?.toString() ?? 'Support Request';

              final message =
                  data['message']?.toString() ?? '';

              final status =
                  data['status']?.toString() ?? 'Open';

              final createdAt = data['createdAt'];

              String dateText = '';

              if (createdAt is Timestamp) {
                final date = createdAt.toDate().toLocal();

                dateText =
                    '${date.day}/${date.month}/${date.year} '
                    '${date.hour.toString().padLeft(2, '0')}:'
                    '${date.minute.toString().padLeft(2, '0')}';
              }

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading: CircleAvatar(
                    backgroundColor: PartyColors.purpleDark,
                    child: const Icon(
                      Icons.support_agent,
                      color: PartyColors.gold,
                    ),
                  ),
                  title: Text(
                    subject,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(
                          message,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          status,
                          style: TextStyle(
                            color: status == 'Resolved'
                                ? PartyColors.gold
                                : PartyColors.purpleBright,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (dateText.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            dateText,
                            style: const TextStyle(
                              color: PartyColors.muted,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  trailing: const Icon(
                    Icons.chevron_right,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => SupportTicketPage(
                          ticketId: doc.id,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}




/* ============================================================
       SUPPORT TICKET
       ============================================================ */

class SupportTicketPage extends StatefulWidget {
  final String ticketId;

  const SupportTicketPage({
    super.key,
    required this.ticketId,
  });

  @override
  State<SupportTicketPage> createState() =>
      _SupportTicketPageState();
}

class _SupportTicketPageState extends State<SupportTicketPage> {
  final replyController = TextEditingController();
  bool sending = false;

  @override
  void dispose() {
    replyController.dispose();
    super.dispose();
  }

  Future<void> _sendReply() async {
    final message = replyController.text.trim();

    if (message.isEmpty || sending) return;

    setState(() {
      sending = true;
    });

    try {
      await FirebaseFirestore.instance
          .collection('supportTickets')
          .doc(widget.ticketId)
          .collection('messages')
          .add({
        'senderId': FirebaseAuth.instance.currentUser?.uid ?? '',
        'senderType': 'user',
        'message': message,
        'createdAt': FieldValue.serverTimestamp(),
      });

      await FirebaseFirestore.instance
          .collection('supportTickets')
          .doc(widget.ticketId)
          .update({
        'updatedAt': FieldValue.serverTimestamp(),
      });

      replyController.clear();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Reply send nahi ho saki: $e'),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          sending = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Support Request'),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('supportTickets')
            .doc(widget.ticketId)
            .snapshots(),
        builder: (context, ticketSnapshot) {
          if (ticketSnapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!ticketSnapshot.hasData ||
              !ticketSnapshot.data!.exists) {
            return const Center(
              child: Text('Support request not found.'),
            );
          }

          final ticket =
              ticketSnapshot.data!.data()
                  as Map<String, dynamic>;

          final subject =
              ticket['subject']?.toString() ?? 'Support Request';

          final message =
              ticket['message']?.toString() ?? '';

          final status =
              ticket['status']?.toString() ?? 'Open';

          return Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Text(
                              subject,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(message),
                            const SizedBox(height: 14),
                            Text(
                              'Status: $status',
                              style: const TextStyle(
                                color: PartyColors.gold,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Conversation',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('supportTickets')
                          .doc(widget.ticketId)
                          .collection('messages')
                          .orderBy('createdAt')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const SizedBox();
                        }

                        final messages = snapshot.data!.docs;

                        if (messages.isEmpty) {
                          return const Padding(
                            padding: EdgeInsets.all(12),
                            child: Text(
                              'No replies yet.',
                            ),
                          );
                        }

                        return Column(
                          children: messages.map((doc) {
                            final data = doc.data()
                                as Map<String, dynamic>;

                            final isUser =
                                data['senderType'] == 'user';

                            return Align(
                              alignment: isUser
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                              child: Container(
                                margin:
                                    const EdgeInsets.only(
                                  bottom: 8,
                                ),
                                padding:
                                    const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: isUser
                                      ? PartyColors.purpleDark
                                      : PartyColors.panel,
                                  borderRadius:
                                      BorderRadius.circular(14),
                                  border: Border.all(
                                    color: isUser
                                        ? PartyColors.purpleBright
                                        : PartyColors.goldDark,
                                  ),
                                ),
                                child: Text(
                                  data['message']
                                          ?.toString() ??
                                      '',
                                ),
                              ),
                            );
                          }).toList(),
                        );
                      },
                    ),
                  ],
                ),
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: replyController,
                          maxLines: 3,
                          decoration: const InputDecoration(
                            hintText: 'Write a reply...',
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        onPressed:
                            sending ? null : _sendReply,
                        icon: sending
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child:
                                    CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(
                                Icons.send,
                                color: PartyColors.gold,
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}



/* ============================================================
       ADMIN SUPPORT PANEL
       ============================================================ */


class AdminSupportPanelPage extends StatelessWidget {
  const AdminSupportPanelPage({super.key});

  Future<void> _updateStatus(
    String ticketId,
    String status,
  ) async {
    await FirebaseFirestore.instance
        .collection('supportTickets')
        .doc(ticketId)
        .update({
      'status': status,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Support Requests'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('supportTickets')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Failed to load requests.\n${snapshot.error}',
                textAlign: TextAlign.center,
              ),
            );
          }

          final tickets = snapshot.data?.docs ?? [];

          if (tickets.isEmpty) {
            return const Center(
              child: Text('No support requests.'),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: tickets.length,
            itemBuilder: (context, index) {
              final doc = tickets[index];
              final data =
                  doc.data() as Map<String, dynamic>;

              final subject =
                  data['subject']?.toString() ??
                      'Support Request';

              final message =
                  data['message']?.toString() ?? '';

              final email =
                  data['userEmail']?.toString() ?? '';

              final status =
                  data['status']?.toString() ?? 'Open';

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        subject,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        email,
                        style: const TextStyle(
                          color: PartyColors.muted,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        message,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const Text('Status: '),
                          Text(
                            status,
                            style: const TextStyle(
                              color: PartyColors.gold,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          PopupMenuButton<String>(
                            onSelected: (value) async {
                              try {
                                await _updateStatus(
                                  doc.id,
                                  value,
                                );

                                if (context.mounted) {
                                  ScaffoldMessenger.of(
                                    context,
                                  ).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Status changed to $value',
                                      ),
                                    ),
                                  );
                                }
                              } catch (e) {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(
                                    context,
                                  ).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Status update failed: $e',
                                      ),
                                    ),
                                  );
                                }
                              }
                            },
                            itemBuilder: (context) => const [
                              PopupMenuItem(
                                value: 'Open',
                                child: Text('Open'),
                              ),
                              PopupMenuItem(
                                value: 'In Progress',
                                child: Text('In Progress'),
                              ),
                              PopupMenuItem(
                                value: 'Resolved',
                                child: Text('Resolved'),
                              ),
                            ],
                            child: const Icon(
                              Icons.more_vert,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    SupportTicketPage(
                                  ticketId: doc.id,
                                ),
                              ),
                            );
                          },
                          icon: const Icon(
                            Icons.chat_outlined,
                          ),
                          label: const Text(
                            'Open Request',
                          ),
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



    /* ============================================================
       TRANSACTION HISTORY
       ============================================================ */

    class TransactionHistoryPage
        extends StatelessWidget {
      const TransactionHistoryPage({
        super.key,
      });

      @override
      Widget build(BuildContext context) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              AppLanguage.text(
                'transaction_history',
              ),
            ),
          ),
          body: const Center(
            child: Text(
              'No transactions yet.',
            ),
          ),
        );
      }
    }
