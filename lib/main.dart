import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
      'join': '加入',
      'login': '登录',
      'create_account': '创建账号',
      'get_started': '开始',
      'username': '用户名',
      'email': '邮箱',
      'password': '密码',
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
   APP
   ============================================================ */

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
            scaffoldBackgroundColor: const Color(0xFF08070F),
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF8D3DFF),
              brightness: Brightness.dark,
            ),
            useMaterial3: true,
          ),
          home: const SplashPage(),
        );
      },
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

    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;

      final user = FirebaseAuth.instance.currentUser;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) =>
              user != null ? const MainPage() : const WelcomePage(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: AppLanguage.current,
      builder: (context, language, child) {
        return Scaffold(
          body: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircleAvatar(
                  radius: 62,
                  child: Icon(
                    Icons.groups_rounded,
                    size: 70,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'PartyChat',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  AppLanguage.text('chat_play_make_friends'),
                ),
              ],
            ),
          ),
        );
      },
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
    return ValueListenableBuilder<String>(
      valueListenable: AppLanguage.current,
      builder: (context, language, child) {
        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const Spacer(),
                  const CircleAvatar(
                    radius: 60,
                    child: Icon(
                      Icons.groups_rounded,
                      size: 68,
                    ),
                  ),
                  const SizedBox(height: 22),
                  Text(
                    AppLanguage.text('welcome_to_partychat'),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    AppLanguage.text('chat_play_make_friends'),
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 17,
                    ),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: FilledButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const LoginPage(),
                          ),
                        );
                      },
                      child: Text(
                        AppLanguage.text('get_started'),
                        style: const TextStyle(fontSize: 17),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const LoginPage(),
                          ),
                        );
                      },
                      child: Text(
                        AppLanguage.text('login'),
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                ],
              ),
            ),
          ),
        );
      },
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
          content: Text('Email aur password required hain.'),
        ),
      );
      return;
    }

    if (signup && (name.length < 3 || name.length > 12)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Username 3 se 12 characters ka hona chahiye.',
          ),
        ),
      );
      return;
    }

    try {
      UserCredential credential;

      if (signup) {
        credential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        final user = credential.user;

        if (user != null) {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .set(
            {
              'name': name,
              'email': email,
              'language': AppLanguage.current.value,
              'coins': 12580,
              'diamonds': 2450,
              'createdAt': FieldValue.serverTimestamp(),
            },
            SetOptions(merge: true),
          );
        }
      } else {
        credential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        await AppLanguage.load();
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
    return ValueListenableBuilder<String>(
      valueListenable: AppLanguage.current,
      builder: (context, language, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              signup
                  ? AppLanguage.text('create_account')
                  : AppLanguage.text('login'),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 25),
                const Icon(
                  Icons.account_circle,
                  size: 90,
                ),
                const SizedBox(height: 25),
                Text(
                  signup
                      ? AppLanguage.text('create_account')
                      : AppLanguage.text('welcome_back'),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 25),
                if (signup)
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: AppLanguage.text('username'),
                      prefixIcon: const Icon(Icons.person),
                      border: const OutlineInputBorder(),
                    ),
                  ),
                if (signup) const SizedBox(height: 14),
                TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: AppLanguage.text('email'),
                    prefixIcon: const Icon(Icons.email),
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: passwordController,
                  obscureText: obscurePassword,
                  decoration: InputDecoration(
                    labelText: AppLanguage.text('password'),
                    prefixIcon: const Icon(Icons.lock),
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        obscurePassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          obscurePassword = !obscurePassword;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 52,
                  child: FilledButton(
                    onPressed: continueToApp,
                    child: Text(
                      signup
                          ? AppLanguage.text('create_account')
                          : AppLanguage.text('login'),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                TextButton(
                  onPressed: () {
                    setState(() {
                      signup = !signup;
                    });
                  },
                  child: Text(
                    signup
                        ? '${AppLanguage.text('account')}? ${AppLanguage.text('login')}'
                        : '${AppLanguage.text('create_account')}?',
                  ),
                ),
              ],
            ),
          ),
        );
      },
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

  final pages = const [
    HomeTab(),
    RoomsTab(),
    GamesTab(),
    WalletTab(),
    ProfileTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: AppLanguage.current,
      builder: (context, language, child) {
        return Scaffold(
          body: SafeArea(
            child: pages[selected],
          ),
          bottomNavigationBar: NavigationBar(
            selectedIndex: selected,
            onDestinationSelected: (value) {
              setState(() {
                selected = value;
              });
            },
            destinations: [
              NavigationDestination(
                icon: const Icon(Icons.home_outlined),
                selectedIcon: const Icon(Icons.home),
                label: AppLanguage.text('home'),
              ),
              NavigationDestination(
                icon: const Icon(Icons.forum_outlined),
                selectedIcon: const Icon(Icons.forum),
                label: AppLanguage.text('rooms'),
              ),
              NavigationDestination(
                icon: const Icon(Icons.sports_esports_outlined),
                selectedIcon: const Icon(Icons.sports_esports),
                label: AppLanguage.text('games'),
              ),
              NavigationDestination(
                icon: const Icon(Icons.account_balance_wallet_outlined),
                selectedIcon:
                    const Icon(Icons.account_balance_wallet),
                label: AppLanguage.text('wallet'),
              ),
              NavigationDestination(
                icon: const Icon(Icons.person_outline),
                selectedIcon: const Icon(Icons.person),
                label: AppLanguage.text('profile'),
              ),
            ],
          ),
        );
      },
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
    return ValueListenableBuilder<String>(
      valueListenable: AppLanguage.current,
      builder: (context, language, child) {
        return ListView(
          padding: const EdgeInsets.all(18),
          children: [
            Row(
              children: [
                const CircleAvatar(
                  radius: 25,
                  child: Icon(Icons.person),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Hello, Party User 👋',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        AppLanguage.text('welcome_back'),
                        style: const TextStyle(
                          color: Colors.white54,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.notifications_none),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF7130B7),
                    Color(0xFFB22C8D),
                  ],
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLanguage.text('your_balance'),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    '12,580 🪙',
                    style: TextStyle(
                      fontSize: 27,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Text(
                    '💎 2,450 ${AppLanguage.text('diamonds')}',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              AppLanguage.text('popular_rooms'),
              style: const TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const RoomTile(
              'Friends Forever 💜',
              '2.4K online',
              Icons.people,
            ),
            const RoomTile(
              'Gaming Zone 🎮',
              '1.8K online',
              Icons.games,
            ),
            const RoomTile(
              'Music Lovers 🎵',
              '1.2K online',
              Icons.music_note,
            ),
          ],
        );
      },
    );
  }
}

/* ============================================================
   ROOMS
   ============================================================ */

class RoomsTab extends StatelessWidget {
  const RoomsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: AppLanguage.current,
      builder: (context, language, child) {
        return ListView(
          padding: const EdgeInsets.all(18),
          children: [
            Text(
              AppLanguage.text('chat_rooms'),
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 18),
            const RoomTile(
              'Friends Forever 💜',
              '2.4K online',
              Icons.people,
            ),
            const RoomTile(
              'Gaming Zone 🎮',
              '1.8K online',
              Icons.games,
            ),
            const RoomTile(
              'Music Lovers 🎵',
              '1.2K online',
              Icons.music_note,
            ),
            const RoomTile(
              'Fun Room 😊',
              '980 online',
              Icons.celebration,
            ),
          ],
        );
      },
    );
  }
}

class RoomTile extends StatelessWidget {
  final String title;
  final String online;
  final IconData icon;

  const RoomTile(
    this.title,
    this.online,
    this.icon, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: const Color(0xFF15131F),
        borderRadius: BorderRadius.circular(17),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            child: Icon(icon),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  online,
                  style: const TextStyle(
                    color: Colors.greenAccent,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          FilledButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => RoomPage(
                    title: title,
                    online: online,
                  ),
                ),
              );
            },
            child: Text(
              AppLanguage.text('join'),
            ),
          ),
        ],
      ),
    );
  }
}

/* ============================================================
   ROOM + MIC GLOW
   ============================================================ */

class RoomPage extends StatefulWidget {
  final String title;
  final String online;

  late final String userId =
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
  bool isSpeaking = false;

  StreamSubscription<double>?
      soundLevelSubscription;

  bool speakerOn = true;

  final messageController =
      TextEditingController();

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
          color: micOn
              ? Colors.white
              : Colors.grey.shade800,
          boxShadow: isSpeaking
              ? [
                  BoxShadow(
                    color:
                        Colors.white.withOpacity(0.9),
                    blurRadius: 22,
                    spreadRadius: 7,
                  ),
                  BoxShadow(
                    color:
                        Colors.white.withOpacity(0.35),
                    blurRadius: 40,
                    spreadRadius: 12,
                  ),
                ]
              : [],
        ),
        child: Icon(
          micOn ? Icons.mic : Icons.mic_off,
          color:
              micOn ? Colors.black : Colors.white,
          size: 29,
        ),
      ),
    );
  }

  void startMicGlow(String userId) {
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

  void toggleMic() {
    micOn = !micOn;

    ZegoUIKit().turnMicrophoneOn(
      micOn,
      userID: widget.userId,
    );

    if (micOn) {
      startMicGlow(widget.userId);
    } else {
      soundLevelSubscription?.cancel();

      setState(() {
        isSpeaking = false;
      });
    }
  }

  void sendMessage() {
    final text =
        messageController.text.trim();

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
    final String roomId = widget.title
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
            userName: 'Party User',
            roomID: roomId,
            config:
                ZegoUIKitPrebuiltLiveAudioRoomConfig
                    .host(),
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

/* ============================================================
   GAMES
   ============================================================ */

class GamesTab extends StatelessWidget {
  const GamesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: AppLanguage.current,
      builder: (context, language, child) {
        return GridView.count(
          padding: const EdgeInsets.all(18),
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          children: const [
            GameCard('Ludo', Icons.casino),
            GameCard('Carrom', Icons.sports),
            GameCard('8 Ball Pool', Icons.sports_bar),
            GameCard('Quiz', Icons.quiz),
            GameCard(
              'Bubble Shooter',
              Icons.bubble_chart,
            ),
            GameCard(
              'More Games',
              Icons.apps,
            ),
          ],
        );
      },
    );
  }
}

class GameCard extends StatelessWidget {
  final String title;
  final IconData icon;

  const GameCard(
    this.title,
    this.icon, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF29203E),
            Color(0xFF3A1836),
          ],
        ),
        borderRadius: BorderRadius.circular(21),
      ),
      child: Column(
        mainAxisAlignment:
            MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 45,
            color: const Color(0xFFFFD15C),
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            AppLanguage.text('play_now'),
            style: const TextStyle(
              color: Colors.white54,
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
    return ValueListenableBuilder<String>(
      valueListenable: AppLanguage.current,
      builder: (context, language, child) {
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
            const SizedBox(height: 18),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF5522A1),
                    Color(0xFFB12C8C),
                  ],
                ),
                borderRadius:
                    BorderRadius.circular(24),
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLanguage.text('coins'),
                  ),
                  const Text(
                    '12,580 🪙',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '2,450 💎 ${AppLanguage.text('diamonds')}',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            FilledButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.add),
              label: Text(
                AppLanguage.text('recharge'),
              ),
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        const TransactionHistoryPage(),
                  ),
                );
              },
              icon: const Icon(Icons.history),
              label: Text(
                AppLanguage.text(
                  'transaction_history',
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

/* ============================================================
   PROFILE
   ============================================================ */

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    final user =
        FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Center(
        child: Text(
          '${AppLanguage.text('login')} first',
        ),
      );
    }

    final userDoc = FirebaseFirestore
        .instance
        .collection('users')
        .doc(user.uid);

    final avatarImages = {
      'avatar1':
          'assets/avatar1_pakistan_female-2.png',
      'avatar2':
          'assets/avatar2_uae_male.png',
      'avatar3':
          'assets/avatar3_uk_male.png',
      'avatar4':
          'assets/avatar4_russia_female.png',
      'avatar5':
          'assets/avatar5_saudi_female.png',
      'avatar6':
          'assets/avatar6_turkey_male.png',
      'avatar7':
          'assets/avatar7_india_female.png',
      'avatar8':
          'assets/avatar8_usa_male.png',
    };

    return ValueListenableBuilder<String>(
      valueListenable: AppLanguage.current,
      builder: (context, language, child) {
        return ListView(
          padding: const EdgeInsets.all(18),
          children: [
            Text(
              AppLanguage.text('profile'),
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 22),

            Center(
              child: StreamBuilder<
                  DocumentSnapshot<
                      Map<String, dynamic>>>(
                stream: userDoc.snapshots(),
                builder: (context, snapshot) {
                  final data =
                      snapshot.data?.data();

                  final photoURL =
                      data?['photoURL']
                          as String?;

                  final photoBase64 =
                      data?['photoBase64']
                          as String?;

                  final avatar =
                      data?['avatar']
                          as String?;

                  ImageProvider<Object>?
                      profileImage;

                  if (photoBase64 != null &&
                      photoBase64.isNotEmpty) {
                    try {
                      profileImage =
                          MemoryImage(
                        base64Decode(
                          photoBase64,
                        ),
                      );
                    } catch (_) {}
                  }

                  if (profileImage == null &&
                      photoURL != null &&
                      photoURL.isNotEmpty) {
                    profileImage =
                        NetworkImage(photoURL);
                  }

                  if (profileImage == null &&
                      avatar != null &&
                      avatarImages[avatar] !=
                          null) {
                    profileImage =
                        AssetImage(
                      avatarImages[avatar]!,
                    );
                  }

                  return CircleAvatar(
                    radius: 52,
                    backgroundImage:
                        profileImage,
                    child: profileImage == null
                        ? const Icon(
                            Icons.person,
                            size: 52,
                          )
                        : null,
                  );
                },
              ),
            ),

            const SizedBox(height: 12),

            ElevatedButton.icon(
              onPressed: () async {
                final picker =
                    ImagePicker();

                final image =
                    await picker.pickImage(
                  source:
                      ImageSource.gallery,
                  imageQuality: 20,
                  maxWidth: 256,
                  maxHeight: 256,
                );

                if (image == null) return;

                final bytes =
                    await image.readAsBytes();

                if (bytes.length > 500000) {
                  if (!context.mounted) {
                    return;
                  }

                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Photo size zyada hai. Choti photo select karein.',
                      ),
                    ),
                  );

                  return;
                }

                final encodedPhoto =
                    base64Encode(bytes);

                try {
                  await userDoc.set(
                    {
                      'photoBase64':
                          encodedPhoto,
                      'photoURL': '',
                      'avatar': '',
                    },
                    SetOptions(
                      merge: true,
                    ),
                  );

                  if (!context.mounted) {
                    return;
                  }

                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Profile photo save ho gayi 👍',
                      ),
                    ),
                  );
                } catch (e) {
                  if (!context.mounted) {
                    return;
                  }

                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Photo save nahi hui: $e',
                      ),
                    ),
                  );
                }
              },
              icon:
                  const Icon(Icons.camera_alt),
              label: Text(
                AppLanguage.text(
                  'change_profile_photo',
                ),
              ),
            ),

            const SizedBox(height: 12),

            ElevatedButton.icon(
              onPressed: () async {
                final avatars = [
                  'avatar1',
                  'avatar2',
                  'avatar3',
                  'avatar4',
                  'avatar5',
                  'avatar6',
                  'avatar7',
                  'avatar8',
                ];

                final selected =
                    await showDialog<String>(
                  context: context,
                  builder:
                      (dialogContext) {
                    String? tempSelected;

                    return StatefulBuilder(
                      builder: (
                        context,
                        setDialogState,
                      ) {
                        return AlertDialog(
                          title: Text(
                            AppLanguage.text(
                              'choose_avatar',
                            ),
                          ),
                          content:
                              GridView.builder(
                            shrinkWrap: true,
                            itemCount:
                                avatars.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount:
                                  4,
                              crossAxisSpacing:
                                  8,
                              mainAxisSpacing:
                                  8,
                            ),
                            itemBuilder:
                                (context,
                                    index) {
                              final avatar =
                                  avatars[index];

                              return GestureDetector(
                                onTap: () {
                                  setDialogState(
                                    () {
                                      tempSelected =
                                          avatar;
                                    },
                                  );
                                },
                                child:
                                    Container(
                                  padding:
                                      const EdgeInsets.all(
                                    4,
                                  ),
                                  decoration:
                                      BoxDecoration(
                                    border:
                                        Border.all(
                                      color: tempSelected ==
                                              avatar
                                          ? Colors
                                              .white
                                          : Colors
                                              .grey,
                                      width: tempSelected ==
                                              avatar
                                          ? 3
                                          : 1,
                                    ),
                                    borderRadius:
                                        BorderRadius
                                            .circular(
                                      8,
                                    ),
                                  ),
                                  child:
                                      Image.asset(
                                    avatarImages[
                                        avatar]!,
                                    fit: BoxFit
                                        .contain,
                                  ),
                                ),
                              );
                            },
                          ),
                          actions: [
                            ElevatedButton(
                              onPressed:
                                  tempSelected ==
                                          null
                                      ? null
                                      : () {
                                          Navigator.pop(
                                            dialogContext,
                                            tempSelected,
                                          );
                                        },
                              child: Text(
                                AppLanguage.text(
                                  'save',
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                );

                if (selected == null) {
                  return;
                }

                try {
                  await userDoc.set(
                    {
                      'avatar': selected,
                      'photoURL': '',
                      'photoBase64': '',
                    },
                    SetOptions(
                      merge: true,
                    ),
                  );

                  if (!context.mounted) {
                    return;
                  }

                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Avatar save ho gaya 👍',
                      ),
                    ),
                  );
                } catch (e) {
                  if (!context.mounted) {
                    return;
                  }

                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Avatar save nahi hua: $e',
                      ),
                    ),
                  );
                }
              },
              icon: const Icon(Icons.face),
              label: Text(
                AppLanguage.text(
                  'choose_avatar',
                ),
              ),
            ),

            const SizedBox(height: 12),

            Center(
              child: StreamBuilder<
                  DocumentSnapshot<
                      Map<String, dynamic>>>(
                stream: userDoc.snapshots(),
                builder: (context, snapshot) {
                  final data =
                      snapshot.data?.data();

                  final name =
                      data?['name']
                              as String? ??
                          'PartyChat User';

                  return Text(
                    '$name 👑',
                    style: const TextStyle(
                      fontSize: 21,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 4),

            Center(
              child: Text(
                AppLanguage.text('vip_level'),
                style: const TextStyle(
                  color:
                      Color(0xFFFFD15C),
                  fontWeight:
                      FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 20),

            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  final controller =
                      TextEditingController();

                  showDialog(
                    context: context,
                    builder:
                        (dialogContext) {
                      return AlertDialog(
                        title: Text(
                          AppLanguage.text(
                            'change_username',
                          ),
                        ),
                        content: TextField(
                          controller:
                              controller,
                          maxLength: 12,
                          decoration:
                              InputDecoration(
                            hintText:
                                AppLanguage.text(
                              'username',
                            ),
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(
                                dialogContext,
                              );
                            },
                            child: Text(
                              AppLanguage.text(
                                'cancel',
                              ),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              final newName =
                                  controller
                                      .text
                                      .trim();

                              if (newName.length <
                                      3 ||
                                  newName.length >
                                      12) {
                                ScaffoldMessenger
                                        .of(
                                      context,
                                    )
                                    .showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Username 3 se 12 characters ka hona chahiye.',
                                    ),
                                  ),
                                );
                                return;
                              }

                              try {
                                final data =
                                    (await userDoc
                                            .get())
                                        .data();

                                final lastChange =
                                    data?[
                                        'lastNameChangeAt'];

                                if (lastChange
                                    is Timestamp) {
                                  final difference =
                                      DateTime.now()
                                          .difference(
                                    lastChange
                                        .toDate(),
                                  );

                                  if (difference
                                          .inHours <
                                      24) {
                                    final remaining =
                                        24 -
                                            difference
                                                .inHours;

                                    if (!context
                                        .mounted) {
                                      return;
                                    }

                                    ScaffoldMessenger
                                            .of(
                                          context,
                                        )
                                        .showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Username dobara change karne ke liye $remaining hours wait karein.',
                                        ),
                                      ),
                                    );

                                    return;
                                  }
                                }

                                await userDoc.set(
                                  {
                                    'name':
                                        newName,
                                    'lastNameChangeAt':
                                        FieldValue
                                            .serverTimestamp(),
                                  },
                                  SetOptions(
                                    merge: true,
                                  ),
                                );

                                if (!dialogContext
                                    .mounted) {
                                  return;
                                }

                                Navigator.pop(
                                  dialogContext,
                                );

                                if (!context.mounted) {
                                  return;
                                }

                                ScaffoldMessenger
                                        .of(
                                      context,
                                    )
                                    .showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Username save ho gaya 👍',
                                    ),
                                  ),
                                );
                              } catch (e) {
                                if (!context
                                    .mounted) {
                                  return;
                                }

                                ScaffoldMessenger
                                        .of(
                                      context,
                                    )
                                    .showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Username save nahi hua: $e',
                                    ),
                                  ),
                                );
                              }
                            },
                            child: Text(
                              AppLanguage.text(
                                'save',
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
                icon:
                    const Icon(Icons.edit),
                label: Text(
                  AppLanguage.text(
                    'change_username',
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            _profileNavigationTile(
              context,
              Icons.person_add,
              'friend_requests',
              const FriendRequestsPage(),
            ),

            _profileNavigationTile(
              context,
              Icons.meeting_room,
              'room_invites',
              const RoomInvitesPage(),
            ),

            _profileNavigationTile(
              context,
              Icons.message,
              'friend_messages',
              const FriendMessagesPage(),
            ),

            _profileNavigationTile(
              context,
              Icons.card_giftcard,
              'gifts',
              const GiftsPage(),
            ),

            _profileNavigationTile(
              context,
              Icons.notifications,
              'notifications',
              const NotificationsPage(),
            ),

            _profileNavigationTile(
              context,
              Icons.card_giftcard,
              'my_gifts',
              const MyGiftsPage(),
            ),

            _profileNavigationTile(
              context,
              Icons.people,
              'friends',
              const FriendsPage(),
            ),

            _profileNavigationTile(
              context,
              Icons.settings,
              'settings',
              const SettingsPage(),
            ),

            const SizedBox(height: 20),

            Container(
              padding:
                  const EdgeInsets.all(18),
              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.circular(20),
                color:
                    const Color(0xFF15121F),
              ),
              child: Column(
                children: [
                  Text(
                    AppLanguage.text('coins'),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    '12,580 🪙',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight:
                          FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '2,450 💎 ${AppLanguage.text('diamonds')}',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 15),

            FilledButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.add),
              label: Text(
                AppLanguage.text(
                  'recharge',
                ),
              ),
            ),

            const SizedBox(height: 8),

            OutlinedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        const TransactionHistoryPage(),
                  ),
                );
              },
              icon: const Icon(Icons.history),
              label: Text(
                AppLanguage.text(
                  'transaction_history',
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _profileNavigationTile(
    BuildContext context,
    IconData icon,
    String key,
    Widget page,
  ) {
    return ListTile(
      leading: Icon(icon),
      title: Text(
        AppLanguage.text(key),
      ),
      trailing:
          const Icon(Icons.chevron_right),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => page,
          ),
        );
      },
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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLanguage.text(
            'friend_requests',
          ),
        ),
      ),
      body: const Center(
        child: Text(
          'No friend requests yet.',
          style: TextStyle(fontSize: 16),
        ),
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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLanguage.text(
            'room_invites',
          ),
        ),
      ),
      body: const Center(
        child: Text(
          'No room invites yet.',
          style: TextStyle(fontSize: 16),
        ),
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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLanguage.text(
            'friend_messages',
          ),
        ),
      ),
      body: const Center(
        child: Text(
          'No messages yet.',
          style: TextStyle(fontSize: 16),
        ),
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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLanguage.text('gifts'),
        ),
      ),
      body: const Center(
        child: Text(
          'No gifts yet.',
          style: TextStyle(fontSize: 16),
        ),
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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLanguage.text('my_gifts'),
        ),
      ),
      body: const Center(
        child: Text(
          'Your gifts will appear here.',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}

/* ============================================================
   FRIENDS
   ============================================================ */

class FriendsPage extends StatelessWidget {
  const FriendsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLanguage.text('friends'),
        ),
      ),
      body: const Center(
        child: Text(
          'No friends yet.',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}

/* ============================================================
   SETTINGS
   ============================================================ */

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: AppLanguage.current,
      builder: (context, language, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              AppLanguage.text('settings'),
            ),
          ),
          body: ListView(
            children: [
              ListTile(
                leading:
                    const Icon(Icons.notifications),
                title: Text(
                  AppLanguage.text(
                    'notifications',
                  ),
                ),
                trailing:
                    const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          const NotificationsPage(),
                    ),
                  );
                },
              ),
              ListTile(
                leading:
                    const Icon(Icons.lock),
                title: Text(
                  AppLanguage.text('privacy'),
                ),
                trailing:
                    const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          const PrivacyPage(),
                    ),
                  );
                },
              ),
              ListTile(
                leading:
                    const Icon(Icons.language),
                title: Text(
                  AppLanguage.text('language'),
                ),
                trailing:
                    const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          const LanguagePage(),
                    ),
                  );
                },
              ),
              ListTile(
                leading:
                    const Icon(Icons.person),
                title: Text(
                  AppLanguage.text('account'),
                ),
                trailing:
                    const Icon(Icons.chevron_right),
                onTap: () {},
              ),
              ListTile(
                leading:
                    const Icon(Icons.block),
                title: Text(
                  AppLanguage.text(
                    'blocked_users',
                  ),
                ),
                trailing:
                    const Icon(Icons.chevron_right),
                onTap: () {},
              ),
              ListTile(
                leading:
                    const Icon(Icons.help_outline),
                title: Text(
                  AppLanguage.text(
                    'help_center',
                  ),
                ),
                trailing:
                    const Icon(Icons.chevron_right),
                onTap: () {},
              ),
              const Divider(),
              ListTile(
                leading:
                    const Icon(Icons.logout),
                title: Text(
                  AppLanguage.text('logout'),
                ),
                onTap: () async {
                  await FirebaseAuth.instance
                      .signOut();

                  if (!context.mounted) return;

                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          const WelcomePage(),
                    ),
                    (route) => false,
                  );
                },
              ),
            ],
          ),
        );
      },
    );
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
  String get userId =>
      FirebaseAuth.instance.currentUser!.uid;

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
    try {
      final doc = await FirebaseFirestore
          .instance
          .collection('users')
          .doc(userId)
          .get();

      if (!doc.exists) return;

      final data = doc.data()!;

      if (!mounted) return;

      setState(() {
        profileVisibility =
            data['profileVisibility'] ??
                'Everyone';

        photoVisibility =
            data['photoVisibility'] ??
                'Everyone';

        messagePermission =
            data['messagePermission'] ??
                'Everyone';

        giftPermission =
            data['giftPermission'] ??
                'Everyone';

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
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .set(
      {field: value},
      SetOptions(merge: true),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: AppLanguage.current,
      builder: (context, language, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              AppLanguage.text('privacy'),
            ),
          ),
          body: ListView(
            children: [
              ListTile(
                leading:
                    const Icon(Icons.person),
                title: const Text(
                  'Who can view my profile',
                ),
                subtitle:
                    Text(profileVisibility),
                trailing:
                    const Icon(Icons.chevron_right),
                onTap: () {
                  _chooseOption(
                    'Who can view my profile',
                    [
                      'Everyone',
                      'Friends Only',
                      'Nobody',
                    ],
                    profileVisibility,
                    (value) async {
                      setState(() {
                        profileVisibility =
                            value;
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
                leading:
                    const Icon(Icons.photo),
                title: const Text(
                  'Who can view my profile photo',
                ),
                subtitle:
                    Text(photoVisibility),
                trailing:
                    const Icon(Icons.chevron_right),
                onTap: () {
                  _chooseOption(
                    'Who can view my profile photo',
                    [
                      'Everyone',
                      'Friends Only',
                      'Nobody',
                    ],
                    photoVisibility,
                    (value) async {
                      setState(() {
                        photoVisibility =
                            value;
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
                leading:
                    const Icon(Icons.message),
                title: const Text(
                  'Who can message me',
                ),
                subtitle:
                    Text(messagePermission),
                trailing:
                    const Icon(Icons.chevron_right),
                onTap: () {
                  _chooseOption(
                    'Who can message me',
                    [
                      'Everyone',
                      'Friends Only',
                      'Nobody',
                    ],
                    messagePermission,
                    (value) async {
                      setState(() {
                        messagePermission =
                            value;
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
                subtitle:
                    Text(giftPermission),
                trailing:
                    const Icon(Icons.chevron_right),
                onTap: () {
                  _chooseOption(
                    'Who can send me gifts',
                    [
                      'Everyone',
                      'Friends Only',
                      'Nobody',
                    ],
                    giftPermission,
                    (value) async {
                      setState(() {
                        giftPermission =
                            value;
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
                secondary:
                    const Icon(Icons.circle),
                title: Text(
                  AppLanguage.text(
                    'online_status',
                  ),
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
                  AppLanguage.text(
                    'room_activity',
                  ),
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
                secondary:
                    const Icon(Icons.lock),
                title: Text(
                  AppLanguage.text(
                    'private_account',
                  ),
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

              ListTile(
                leading:
                    const Icon(Icons.block),
                title: Text(
                  AppLanguage.text(
                    'blocked_users',
                  ),
                ),
                trailing:
                    const Icon(Icons.chevron_right),
                onTap: () {},
              ),
            ],
          ),
        );
      },
    );
  }

  void _chooseOption(
    String title,
    List<String> options,
    String currentValue,
    ValueChanged<String> onSelected,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding:
                    const EdgeInsets.all(16),
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
              ),
              ...options.map(
                (option) => ListTile(
                  title: Text(option),
                  trailing: option ==
                          currentValue
                      ? const Icon(Icons.check)
                      : null,
                  onTap: () {
                    onSelected(option);
                    Navigator.pop(context);
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

class LanguagePage extends StatefulWidget {
  const LanguagePage({super.key});

  @override
  State<LanguagePage> createState() =>
      _LanguagePageState();
}

class _LanguagePageState
    extends State<LanguagePage> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: AppLanguage.current,
      builder: (context, selectedLanguage, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              AppLanguage.text('language'),
            ),
          ),
          body: ListView.builder(
            itemCount:
                AppLanguage.languages.length,
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

                  if (!mounted) return;

                  setState(() {});
                },
              );
            },
          ),
        );
      },
    );
  }
}

/* ============================================================
   NOTIFICATIONS
   ============================================================ */

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() =>
      _NotificationsPageState();
}

class _NotificationsPageState
    extends State<NotificationsPage> {
  bool messages = true;
  bool announcements = true;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: AppLanguage.current,
      builder: (context, language, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              AppLanguage.text(
                'notifications',
              ),
            ),
          ),
          body: ListView(
            padding:
                const EdgeInsets.all(20),
            children: [
              const Text(
                'Choose what you want to be notified about.',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 20),
              _notificationTile(
                AppLanguage.text(
                  'messages',
                ),
                'Get notified when you receive a new message.',
                messages,
                (value) {
                  setState(() {
                    messages = value;
                  });
                },
              ),
              _notificationTile(
                AppLanguage.text(
                  'announcements',
                ),
                'Get notified about important updates and events from PartyChat.',
                announcements,
                (value) {
                  setState(() {
                    announcements = value;
                  });
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _notificationTile(
    String title,
    String subtitle,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return ListTile(
      contentPadding:
          const EdgeInsets.symmetric(
        vertical: 8,
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Padding(
        padding:
            const EdgeInsets.only(top: 5),
        child: Text(subtitle),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
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
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
