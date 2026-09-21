import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';
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
            scaffoldBackgroundColor: const Color(0xFF05030B),
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF7B35FF),
              brightness: Brightness.dark,
            ).copyWith(
              primary: const Color(0xFFC05CFF),
              secondary: const Color(0xFFFF2BD6),
              surface: const Color(0xFF10091D),
            ),
            navigationBarTheme: const NavigationBarThemeData(
              backgroundColor: Color(0xFF0C0915),
              indicatorColor: Color(0xFF7138A5),
              height: 78,
              labelTextStyle: WidgetStatePropertyAll(
                TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
              ),
            ),
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.transparent,
              elevation: 0,
              centerTitle: false,
            ),
            inputDecorationTheme: InputDecorationTheme(
              filled: true,
              fillColor: const Color(0xFF0F0B1A),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(18)),
                borderSide: BorderSide(color: Color(0xFF5B2A92)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(18)),
                borderSide: BorderSide(color: Color(0xFF3C2160)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(18)),
                borderSide: BorderSide(color: Color(0xFFB65CFF), width: 1.5),
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

  const _NeonBackground({
    required this.child,
    this.scrollable = false,
  });

  @override
  Widget build(BuildContext context) {
    final content = Container(
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.topRight,
          radius: 1.25,
          colors: [
            Color(0xFF1A0A31),
            Color(0xFF080510),
            Color(0xFF05030B),
          ],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -120,
            left: -100,
            child: _GlowOrb(
              size: 260,
              color: const Color(0xFF7A2CFF),
            ),
          ),
          Positioned(
            bottom: -150,
            right: -100,
            child: _GlowOrb(
              size: 300,
              color: const Color(0xFFFF21D4),
            ),
          ),
          child,
        ],
      ),
    );

    return scrollable ? content : content;
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
          color: color.withOpacity(0.11),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.20),
              blurRadius: 115,
              spreadRadius: 25,
            ),
          ],
        ),
      ),
    );
  }
}

class _NeonPanel extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius;

  const _NeonPanel({
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.radius = 20,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF211033), Color(0xFF0B0713)],
        ),
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: const Color(0xFF9B4DFF), width: 1.2),
        boxShadow: const [
          BoxShadow(
            color: Color(0x774F00FF),
            blurRadius: 20,
            spreadRadius: 1,
          ),
        ],
      ),
      child: child,
    );
  }
}

class _NeonAction extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final IconData? icon;

  const _NeonAction({
    required this.label,
    required this.onPressed,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: const LinearGradient(
          colors: [Color(0xFF6E2DFF), Color(0xFFFF20D0)],
        ),
        boxShadow: const [
          BoxShadow(color: Color(0x884F00FF), blurRadius: 20, spreadRadius: 1),
        ],
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
                  Icon(icon, size: 18),
                  const SizedBox(width: 7),
                ],
                Text(
                  label,
                  style: const TextStyle(fontWeight: FontWeight.w800),
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
        MaterialPageRoute(
          builder: (_) =>
              user != null ? const MainPage() : const WelcomePage(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _NeonBackground(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 132,
                  height: 132,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [Color(0xFF7B35FF), Color(0xFFFF2BD6)],
                    ),
                    boxShadow: const [
                      BoxShadow(color: Color(0xAA8C2DFF), blurRadius: 45, spreadRadius: 8),
                    ],
                  ),
                  child: const Icon(Icons.auto_awesome, size: 68, color: Colors.white),
                ),
                const SizedBox(height: 28),
                RichText(
                  text: const TextSpan(
                    style: TextStyle(fontSize: 42, fontWeight: FontWeight.w900),
                    children: [
                      TextSpan(text: 'Party', style: TextStyle(color: Colors.white)),
                      TextSpan(text: 'Chat', style: TextStyle(color: Color(0xFFFF38D7))),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  AppLanguage.text('chat_play_make_friends'),
                  style: const TextStyle(color: Colors.white70, fontSize: 16),
                ),
                const SizedBox(height: 18),
                const Text('GOOD VIBES ONLY', style: TextStyle(letterSpacing: 4, color: Color(0xFFD8B7FF), fontWeight: FontWeight.w700)),
              ],
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
            padding: const EdgeInsets.fromLTRB(24, 40, 24, 24),
            child: Column(
              children: [
                const Spacer(),
                Container(
                  width: 112,
                  height: 112,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(colors: [Color(0xFF7338FF), Color(0xFFFF2BD6)]),
                    boxShadow: const [BoxShadow(color: Color(0xAA9B35FF), blurRadius: 42, spreadRadius: 6)],
                  ),
                  child: const Icon(Icons.groups_rounded, size: 60),
                ),
                const SizedBox(height: 26),
                RichText(
                  text: const TextSpan(
                    style: TextStyle(fontSize: 34, fontWeight: FontWeight.w900),
                    children: [
                      TextSpan(text: 'Party', style: TextStyle(color: Colors.white)),
                      TextSpan(text: 'Chat', style: TextStyle(color: Color(0xFFFF39D5))),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Text(AppLanguage.text('welcome_to_partychat'), textAlign: TextAlign.center, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
                const SizedBox(height: 8),
                Text(AppLanguage.text('chat_play_make_friends'), textAlign: TextAlign.center, style: const TextStyle(color: Colors.white60, fontSize: 16)),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: _NeonAction(
                    label: AppLanguage.text('get_started'),
                    icon: Icons.arrow_forward_rounded,
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginPage())),
                  ),
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                      side: const BorderSide(color: Color(0xFFB65CFF)),
                    ),
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginPage())),
                    child: Text(AppLanguage.text('login'), style: const TextStyle(fontWeight: FontWeight.w800)),
                  ),
                ),
                const SizedBox(height: 20),
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
  final random = Random();
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
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 30,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 30),
              const Icon(
                Icons.chat_bubble_rounded,
                size: 75,
              ),
              const SizedBox(height: 14),
              const Text(
                'PartyChat',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Welcome to PartyChat',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              Row(
                children: [
                  Expanded(
                    child: FilledButton(
                      onPressed: () {
                        setState(() {
                          signup = false;
                        });
                      },
                      child: const Text('Login'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() {
                          signup = true;
                        });
                      },
                      child: const Text('Sign Up'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                height: 52,
                child: OutlinedButton.icon(
                  onPressed: continueWithGoogle,
                  icon: const Icon(
                    Icons.g_mobiledata,
                    size: 30,
                  ),
                  label: const Text(
                    'Continue with Google',
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 52,
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.facebook),
                  label: const Text(
                    'Continue with Facebook',
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 52,
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.close),
                  label: const Text(
                    'Continue with Twitter / X',
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 52,
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.phone_android),
                  label: const Text(
                    'Continue with Mobile Number',
                  ),
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
              const SizedBox(height: 18),
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
              const SizedBox(height: 12),
              TextButton(
                onPressed: () {
                  setState(() {
                    signup = true;
                  });
                },
                child: const Text(
                  'Create New Account',
                ),
              ),
            ],
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

  final pages = const [HomeTab(), RoomsTab(), GamesTab(), WalletTab(), ProfileTab()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: SafeArea(bottom: false, child: pages[selected]),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selected,
        onDestinationSelected: (value) => setState(() => selected = value),
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

/* ============================================================
   HOME
   ============================================================ */

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return _NeonBackground(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(18, 20, 18, 100),
        children: [
          const Text(
            'Home',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 20),
          _HomeBigBox(
            title: 'New Update',
            icon: Icons.campaign_rounded,
            subtitle: 'See what is new in PartyChat',
          ),
          const SizedBox(height: 14),
          _HomeBigBox(
            title: 'Event',
            icon: Icons.celebration_rounded,
            subtitle: 'Join the latest PartyChat event',
          ),
          const SizedBox(height: 14),
          _HomeBigBox(
            title: 'Free Reward',
            icon: Icons.card_giftcard_rounded,
            subtitle: 'Collect your free daily reward',
          ),
          const SizedBox(height: 14),
          _HomeBigBox(
            title: 'Daily Task',
            icon: Icons.task_alt_rounded,
            subtitle: 'Complete today\'s tasks',
          ),
        ],
      ),
    );
  }
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
          colors: [Color(0xFF211331), Color(0xFF100B1A)],
        ),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFF7138FF), width: 1.2),
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
                colors: [Color(0xFF7138FF), Color(0xFFE52DD4)],
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
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Rooms',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              IconButton(
                tooltip: 'Search',
                icon: const Icon(Icons.search_rounded, size: 28),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const PartyChatSearchPage(),
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 12),
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
                          colors: [Color(0xFF7138FF), Color(0xFFE52DD4)],
                        )
                      : null,
                  color: selected ? null : const Color(0xFF171125),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: const Color(0xFF7138FF)),
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
                  color: selected ? const Color(0xFF2B1940) : const Color(0xFF120D1C),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: selected ? const Color(0xFFE52DD4) : const Color(0xFF493060),
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
                    color: const Color(0xFF7138FF),
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
                        color: Color(0xFFD65CFF),
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
              color: const Color(0xFFD65CFF),
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
                    color: Color(0xFFD65CFF),
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
        border: Border.all(color: const Color(0xFF7138FF)),
        boxShadow: const [BoxShadow(color: Color(0x331C00FF), blurRadius: 12)],
      ),
      child: Row(children: [
        Container(width: 52, height: 52, decoration: BoxDecoration(shape: BoxShape.circle, gradient: const LinearGradient(colors: [Color(0xFF7138FF), Color(0xFFE52DD4)]), boxShadow: const [BoxShadow(color: Color(0x665B1CFF), blurRadius: 14)]), child: Icon(icon, color: Colors.white)),
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
          color: micOn
              ? Colors.white
              : Colors.grey.shade800,
          boxShadow: isSpeaking
              ? [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.9),
                    blurRadius: 22,
                    spreadRadius: 7,
                  ),
                  BoxShadow(
                    color: Colors.white.withOpacity(0.35),
                    blurRadius: 40,
                    spreadRadius: 12,
                  ),
                ]
              : [],
        ),
        child: Icon(
          micOn ? Icons.mic : Icons.mic_off,
          color: micOn ? Colors.black : Colors.white,
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
            userName: 'Party User',
            roomID: roomId,
            config: ZegoUIKitPrebuiltLiveAudioRoomConfig.host(),
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
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
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
      'tag': 'BOARD',
      'image':
          'https://commons.wikimedia.org/wiki/Special:FilePath/Ludo_board(1).png',
    },
    {
      'title': 'Carrom',
      'tag': 'CLASSIC',
      'image':
          'https://commons.wikimedia.org/wiki/Special:FilePath/Carrom_board.jpg',
    },
    {
      'title': '8 Ball Pool',
      'tag': 'POOL',
      'image':
          'https://opengameart.org/sites/default/files/pool_table_complete_12-02-2016.png',
    },
    {
      'title': 'Quiz',
      'tag': 'TRIVIA',
      'image':
          'https://commons.wikimedia.org/wiki/Special:FilePath/Quiz_competition_image.jpg',
    },
    {
      'title': 'Bubble Shooter',
      'tag': 'ARCADE',
      'image':
          'https://commons.wikimedia.org/wiki/Special:FilePath/Bubbles_game.JPG',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return _NeonBackground(
      child: GridView.builder(
        padding: const EdgeInsets.fromLTRB(16, 18, 16, 100),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: .82,
        ),
        itemCount: games.length,
        itemBuilder: (context, index) {
          final game = games[index];
          return GameCard(
            title: game['title']!,
            tag: game['tag']!,
            imageUrl: game['image']!,
          );
        },
      ),
    );
  }
}

class GameCard extends StatelessWidget {
  final String title;
  final String tag;
  final String imageUrl;

  const GameCard({
    super.key,
    required this.title,
    required this.tag,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF7138FF), width: 1.1),
        boxShadow: const [
          BoxShadow(
            color: Color(0x551F00FF),
            blurRadius: 18,
            spreadRadius: 1,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(19),
        child: Material(
          color: const Color(0xFF0E0918),
          child: InkWell(
            onTap: () {},
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color(0xFF31145E),
                            Color(0xFF120A20),
                          ],
                        ),
                      ),
                      child: Icon(
                        Icons.sports_esports,
                        size: 54,
                        color: Colors.white70,
                      ),
                    );
                  },
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return const DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color(0xFF25103F),
                            Color(0xFF0E0918),
                          ],
                        ),
                      ),
                      child: Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    );
                  },
                ),
                const DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0x12000000),
                        Color(0x33000000),
                        Color(0xEE05030B),
                      ],
                      stops: [0.0, 0.48, 1.0],
                    ),
                  ),
                ),
                Positioned(
                  top: 10,
                  left: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xCC080510),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: const Color(0xFFB65CFF),
                      ),
                    ),
                    child: Text(
                      tag,
                      style: const TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.1,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 12,
                  right: 12,
                  bottom: 12,
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      Container(
                        width: 36,
                        height: 36,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [
                              Color(0xFF7138FF),
                              Color(0xFFE52DD4),
                            ],
                          ),
                        ),
                        child: const Icon(
                          Icons.play_arrow_rounded,
                          color: Colors.white,
                          size: 22,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
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
              Text('2,450', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: Color(0xFF29B6F6))),
              SizedBox(width: 6),
              Text('Diamonds', style: TextStyle(fontSize: 17, color: Color(0xFF29B6F6))),
            ]),
          ])),
          const SizedBox(height: 14),
          SizedBox(width: double.infinity, child: _NeonAction(label: '＋  Recharge', onPressed: () {})),
          const SizedBox(height: 10),
          OutlinedButton.icon(style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)), side: const BorderSide(color: Color(0xFFB65CFF))), onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TransactionHistoryPage())), icon: const Icon(Icons.history), label: const Text('Transaction History', style: TextStyle(fontWeight: FontWeight.w800))),
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
    return _NeonPanel(padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 6), child: Column(children: [Icon(icon, color: const Color(0xFFE3B7FF)), const SizedBox(height: 6), Text(label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700))]));
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

  final random = Random();
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
        leading: Icon(icon, color: const Color(0xFFE2C2FF)),
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
          Row(children: [const Icon(Icons.person_rounded, size: 30, color: Color(0xFFE3B7FF)), const SizedBox(width: 10), const Expanded(child: Text('Profile', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900))), IconButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsPage())), icon: const Icon(Icons.settings))]),
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
                      decoration: const BoxDecoration(shape: BoxShape.circle, gradient: LinearGradient(colors: [Color(0xFFFF3ED7), Color(0xFF7A35FF)])),
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

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('Please login first.')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLanguage.text('friend_requests')),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: PartyChatData.friendRequestsStream(user.uid),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('Could not load friend requests.'),
            );
          }

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;

          if (docs.isEmpty) {
            return const Center(child: Text('No friend requests yet.'));
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final request = docs[index].data();
              final requesterUid =
                  request['requesterUid']?.toString() ??
                  request['uid']?.toString() ??
                  docs[index].id;

              return FutureBuilder<Map<String, dynamic>?>(
                future: PartyChatData.userData(requesterUid),
                builder: (context, userSnapshot) {
                  final latest = userSnapshot.data ?? request;
                  final name =
                      latest['name']?.toString() ?? 'Party User';
                  final photo =
                      latest['photoURL']?.toString() ?? '';
                  final avatar =
                      latest['avatar']?.toString() ?? '';

                  return ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => SimpleUserProfilePage(
                            uid: requesterUid,
                            name: name,
                            photoUrl: photo,
                            avatar: avatar,
                          ),
                        ),
                      );
                    },
                    leading: _NetworkOrAvatar(
                      photoUrl: photo,
                      avatar: avatar,
                    ),
                    title: Text(
                      name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    trailing: Wrap(
                      children: [
                        IconButton(
                          tooltip: 'Accept',
                          icon: const Icon(
                            Icons.check_circle,
                            color: Colors.green,
                          ),
                          onPressed: () async {
                            try {
                              await PartyChatData.acceptFriendRequest(
                                uid: user.uid,
                                requesterUid: requesterUid,
                              );
                            } catch (e) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(e.toString())),
                                );
                              }
                            }
                          },
                        ),
                        IconButton(
                          tooltip: 'Reject',
                          icon: const Icon(
                            Icons.cancel,
                            color: Colors.redAccent,
                          ),
                          onPressed: () async {
                            try {
                              await PartyChatData.rejectFriendRequest(
                                uid: user.uid,
                                requesterUid: requesterUid,
                              );
                            } catch (e) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(e.toString())),
                                );
                              }
                            }
                          },
                        ),
                      ],
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
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final docs = snapshot.data!.docs;
          if (docs.isEmpty) return const Center(child: Text('No room invites yet.'));
          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final doc = docs[index];
              final d = doc.data();
              return ListTile(
                leading: const CircleAvatar(child: Icon(Icons.meeting_room)),
                title: Text(d['roomTitle'] ?? 'PartyChat Room'),
                subtitle: Text('${d['inviterName'] ?? 'Someone'} ne invite kiya.'),
                trailing: FilledButton(
                  onPressed: () async {
                    await doc.reference.update({'status': 'accepted'});
                    if (!context.mounted) return;
                    Navigator.push(context, MaterialPageRoute(
                      builder: (_) => RoomPage(
                        title: d['roomTitle'] ?? 'PartyChat Room',
                        online: 'Live',
                      ),
                    ));
                  },
                  child: const Text('Join'),
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
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
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
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
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
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
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

/* ============================================================
   USER SEARCH + MINI PROFILE
   ============================================================ */

class PartyChatSearchPage extends StatefulWidget {
  const PartyChatSearchPage({super.key});

  @override
  State<PartyChatSearchPage> createState() => _PartyChatSearchPageState();
}

class _PartyChatSearchPageState extends State<PartyChatSearchPage> {
  final controller = TextEditingController();
  String? mode;
  bool searching = false;
  List<Map<String, dynamic>> userResults = [];
  List<Map<String, String>> roomResults = [];
  final Set<String> pendingRequests = <String>{};

  static const List<Map<String, String>> rooms = [
    {
      'title': 'Friends Forever 💜',
      'online': '2.4K online',
      'subtitle': 'Make new friends & enjoy chat',
    },
    {
      'title': 'Gaming Zone 🎮',
      'online': '1.8K online',
      'subtitle': 'Play games & enjoy together',
    },
    {
      'title': 'Music Lovers 🎵',
      'online': '1.2K online',
      'subtitle': 'Music • Vibes • Party',
    },
    {
      'title': 'Chill Zone 🌙',
      'online': '980 online',
      'subtitle': 'Relax • Talk • Be Yourself',
    },
  ];

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  String get hint {
    if (mode == 'uid') return 'Enter UID';
    if (mode == 'name') return 'Enter Name';
    return 'Enter Room Name';
  }

  Future<void> _search() async {
    final query = controller.text.trim().toLowerCase();
    if (query.isEmpty) return;

    setState(() {
      searching = true;
      userResults = [];
      roomResults = [];
    });

    try {
      if (mode == 'uid') {
        final user = await PartyChatData.findUserByUid(query);
        if (user != null) {
          userResults = [user];
        }
      } else if (mode == 'name') {
        final users = await PartyChatData.searchUsersByName(query);
        userResults = users.where((user) {
          final name = user['name']?.toString().toLowerCase() ?? '';
          return name.contains(query);
        }).toList();
      } else {
        roomResults = rooms.where((room) {
          final title = room['title']!.toLowerCase();
          return title.contains(query);
        }).toList();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    } finally {
      if (mounted) {
        setState(() => searching = false);
      }
    }
  }

  void _selectUser(Map<String, dynamic> data) {
    final uid = data['uid']?.toString() ?? '';
    if (uid.isEmpty) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => SimpleUserProfilePage(
          uid: uid,
          name: data['name']?.toString() ?? 'Party User',
          photoUrl: data['photoURL']?.toString() ?? '',
          avatar: data['avatar']?.toString() ?? '',
        ),
      ),
    );
  }

  void _selectRoom(Map<String, String> room) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => RoomPage(
          title: room['title'] ?? 'Room',
          online: room['online'] ?? '',
        ),
      ),
    );
  }

  Widget _searchButton({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1D1230), Color(0xFF0D0917)],
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF7138FF)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 5,
        ),
        leading: Container(
          width: 44,
          height: 44,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [Color(0xFF7138FF), Color(0xFFE52DD4)],
            ),
          ),
          child: Icon(icon, color: Colors.white),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w900),
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => setState(() {
          mode = value;
          controller.clear();
          userResults = [];
          roomResults = [];
        }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
        actions: [
          if (mode != null)
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => setState(() {
                mode = null;
                controller.clear();
                userResults = [];
                roomResults = [];
              }),
            ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
          child: mode == null
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Search',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Choose one search type',
                      style: TextStyle(color: Colors.white54),
                    ),
                    const SizedBox(height: 20),
                    _searchButton(
                      icon: Icons.badge_outlined,
                      title: 'UID Search',
                      value: 'uid',
                    ),
                    _searchButton(
                      icon: Icons.person_search,
                      title: 'Name Search',
                      value: 'name',
                    ),
                    _searchButton(
                      icon: Icons.meeting_room_outlined,
                      title: 'Room Search',
                      value: 'room',
                    ),
                  ],
                )
              : Column(
                  children: [
                    TextField(
                      controller: controller,
                      autofocus: true,
                      textInputAction: TextInputAction.search,
                      onSubmitted: (_) => _search(),
                      decoration: InputDecoration(
                        hintText: hint,
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.arrow_forward_rounded),
                          onPressed: _search,
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Expanded(
                      child: searching
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : _buildResults(),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildResults() {
    if (mode == 'room') {
      if (roomResults.isEmpty) {
        return const Center(child: Text('No matching rooms found.'));
      }

      return ListView.builder(
        itemCount: roomResults.length,
        itemBuilder: (context, index) {
          final room = roomResults[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF171126), Color(0xFF0D0917)],
              ),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFF7138FF)),
            ),
            child: ListTile(
              onTap: () => _selectRoom(room),
              leading: const CircleAvatar(
                backgroundColor: Color(0xFF7138FF),
                child: Icon(Icons.meeting_room, color: Colors.white),
              ),
              title: Text(
                room['title'] ?? 'Room',
                style: const TextStyle(fontWeight: FontWeight.w900),
              ),
              subtitle: Text(
                room['online'] ?? '',
                style: const TextStyle(color: Color(0xFF43F5B0)),
              ),
              trailing: const Icon(Icons.chevron_right),
            ),
          );
        },
      );
    }

    if (userResults.isEmpty) {
      return const Center(child: Text('No matching users found.'));
    }

    final currentUid = FirebaseAuth.instance.currentUser?.uid;

    return ListView.builder(
      itemCount: userResults.length,
      itemBuilder: (context, index) {
        final data = userResults[index];
        final uid = data['uid']?.toString() ?? '';
        if (uid == currentUid) return const SizedBox.shrink();

        final name = data['name']?.toString() ?? 'Party User';
        final photo = data['photoURL']?.toString() ?? '';
        final avatar = data['avatar']?.toString() ?? '';

        return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          future: currentUid == null
              ? null
              : PartyChatData.friendRequests(currentUid).doc(uid).get(),
          builder: (context, snapshot) {
            final pending =
                pendingRequests.contains(uid) ||
                (snapshot.data?.exists ?? false);

            return ListTile(
              onTap: () => _selectUser(data),
              leading: _NetworkOrAvatar(
                photoUrl: photo,
                avatar: avatar,
              ),
              title: Text(
                name,
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
              subtitle: Text(
                'UID: ${data['userId'] ?? uid}',
                style: const TextStyle(color: Colors.white54),
              ),
              trailing: IconButton(
                icon: Icon(
                  pending
                      ? Icons.check_circle_rounded
                      : Icons.person_add_rounded,
                  color: pending
                      ? Colors.greenAccent
                      : Colors.white,
                ),
                onPressed: pending || currentUid == null
                    ? null
                    : () async {
                        try {
                          await PartyChatData.sendFriendRequest(
                            fromUid: currentUid,
                            toUid: uid,
                          );
                          if (mounted) {
                            setState(() => pendingRequests.add(uid));
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Friend request sent successfully.',
                                ),
                              ),
                            );
                          }
                        } catch (e) {
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(e.toString())),
                            );
                          }
                        }
                      },
              ),
            );
          },
        );
      },
    );
  }
}

class SimpleUserProfilePage extends StatelessWidget {
  final String uid;
  final String name;
  final String photoUrl;
  final String avatar;

  const SimpleUserProfilePage({
    super.key,
    required this.uid,
    required this.name,
    this.photoUrl = '',
    this.avatar = '',
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: PartyChatData.userData(uid),
        builder: (context, snapshot) {
          final data = snapshot.data ?? {};
          final currentName = data['name']?.toString() ?? name;
          final currentPhoto =
              data['photoURL']?.toString() ?? photoUrl;
          final currentAvatar =
              data['avatar']?.toString() ?? avatar;
          final publicUid =
              data['userId']?.toString() ?? uid;

          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _NetworkOrAvatar(
                    photoUrl: currentPhoto,
                    avatar: currentAvatar,
                    radius: 64,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    currentName,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'UID: $publicUid',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white60,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
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
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('Please login first.')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLanguage.text('friends')),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: PartyChatData.friendsStream(user.uid),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('Could not load friends.'),
            );
          }

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;

          if (docs.isEmpty) {
            return const Center(child: Text('No friends yet.'));
          }

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data();
              final uid =
                  data['uid']?.toString() ?? docs[index].id;
              final name =
                  data['name']?.toString() ?? 'Friend';
              final photo =
                  data['photoURL']?.toString() ?? '';
              final avatar =
                  data['avatar']?.toString() ?? '';

              return ListTile(
                leading: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => SimpleUserProfilePage(
                          uid: uid,
                          name: name,
                          photoUrl: photo,
                          avatar: avatar,
                        ),
                      ),
                    );
                  },
                  child: _NetworkOrAvatar(
                    photoUrl: photo,
                    avatar: avatar,
                  ),
                ),
                title: Text(name),
                trailing: Wrap(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.message),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ChatPage(
                              otherUid: uid,
                              otherName: name,
                            ),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.card_giftcard),
                      onPressed: () => _giftDialog(
                        context,
                        user.uid,
                        uid,
                        name,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.block),
                      onPressed: () => _block(
                        context,
                        user.uid,
                        uid,
                        data,
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _giftDialog(
    BuildContext context,
    String fromUid,
    String toUid,
    String name,
  ) async {
    final gifts = [
      {'name': 'Rose 🌹', 'cost': 10},
      {'name': 'Heart ❤️', 'cost': 50},
      {'name': 'Crown 👑', 'cost': 100},
      {'name': 'Diamond 💎', 'cost': 500},
    ];

    await showModalBottomSheet(
      context: context,
      builder: (sheetContext) {
        return SafeArea(
          child: ListView(
            shrinkWrap: true,
            children: gifts.map((gift) {
              return ListTile(
                leading: const Icon(Icons.card_giftcard),
                title: Text('${gift['name']}'),
                subtitle: Text('${gift['cost']} coins'),
                onTap: () async {
                  Navigator.pop(sheetContext);
                  try {
                    await PartyChatData.sendGift(
                      fromUid: fromUid,
                      toUid: toUid,
                      giftName: gift['name'].toString(),
                      cost: gift['cost'] as int,
                    );
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Gift sent to $name.'),
                        ),
                      );
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(e.toString())),
                      );
                    }
                  }
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  Future<void> _block(
    BuildContext context,
    String uid,
    String otherUid,
    Map<String, dynamic> data,
  ) async {
    try {
      await PartyChatData.blockUser(
        uid: uid,
        otherUid: otherUid,
        otherData: data,
      );
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User blocked.')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
  }
}

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
                if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                final docs = snapshot.data!.docs;
                if (docs.isEmpty) return const Center(child: Text('Say hello 👋'));
                return ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final d = docs[index].data();
                    final mine = d['senderUid'] == user.uid;
                    return Align(
                      alignment: mine ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          color: mine ? const Color(0xFF8D3DFF) : const Color(0xFF201C2C),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(d['text'] ?? ''),
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
  final String? avatar;
  final double radius;

  const _NetworkOrAvatar({
    required this.photoUrl,
    required this.avatar,
    this.radius = 20,
  });

  @override
  Widget build(BuildContext context) {
    if (photoUrl != null && photoUrl!.isNotEmpty) {
      return CircleAvatar(
        radius: radius,
        backgroundImage: NetworkImage(photoUrl!),
      );
    }
    return CircleAvatar(
      radius: radius,
      child: const Icon(Icons.person),
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
                child: Center(child: CircularProgressIndicator()),
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
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
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

class HelpCenterPage extends StatelessWidget {
  const HelpCenterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLanguage.text('help_center'),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: const [
          ListTile(
            leading: Icon(Icons.help_outline),
            title: Text('PartyChat Help Center'),
            subtitle: Text(
              'Help and support features will be connected here.',
            ),
          ),
          SizedBox(height: 10),
          ListTile(
            leading: Icon(Icons.support_agent),
            title: Text('Contact Support'),
            subtitle: Text(
              'Support contact system will be added later.',
            ),
          ),
        ],
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
