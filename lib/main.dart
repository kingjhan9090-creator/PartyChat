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
      'popular_rooms': 'Popular Rooms ðŸ”¥',
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
      'chat_play_make_friends': 'Chat â€¢ Play â€¢ Make Friends',
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
      'settings': 'Ø³ÛŒÙ¹Ù†Ú¯Ø²',
      'language': 'Ø²Ø¨Ø§Ù†',
      'privacy': 'Ù¾Ø±Ø§Ø¦ÛŒÙˆÛŒØ³ÛŒ',
      'notifications': 'Ù†ÙˆÙ¹ÛŒÙÚ©ÛŒØ´Ù†Ø²',
      'messages': 'Ù¾ÛŒØºØ§Ù…Ø§Øª',
      'announcements': 'Ø§Ø¹Ù„Ø§Ù†Ø§Øª',
      'friends': 'Ø¯ÙˆØ³Øª',
      'gifts': 'ØªØ­Ø§Ø¦Ù',
      'blocked_users': 'Ø¨Ù„Ø§Ú© ØµØ§Ø±ÙÛŒÙ†',
      'home': 'ÛÙˆÙ…',
      'rooms': 'Ø±ÙˆÙ…Ø²',
      'games': 'Ú¯ÛŒÙ…Ø²',
      'wallet': 'ÙˆØ§Ù„ÛŒÙ¹',
      'profile': 'Ù¾Ø±ÙˆÙØ§Ø¦Ù„',
      'join': 'Ø´Ø§Ù…Ù„ ÛÙˆÚº',
      'login': 'Ù„Ø§Ú¯ Ø§ÙÙ†',
      'create_account': 'Ø§Ú©Ø§Ø¤Ù†Ù¹ Ø¨Ù†Ø§Ø¦ÛŒÚº',
      'get_started': 'Ø´Ø±ÙˆØ¹ Ú©Ø±ÛŒÚº',
      'username': 'ÛŒÙˆØ²Ø±Ù†ÛŒÙ…',
      'email': 'Ø§ÛŒ Ù…ÛŒÙ„',
      'password': 'Ù¾Ø§Ø³ ÙˆØ±Úˆ',
      'welcome': 'Ø®ÙˆØ´ Ø¢Ù…Ø¯ÛŒØ¯',
      'welcome_back': 'Ø¯ÙˆØ¨Ø§Ø±Û Ø®ÙˆØ´ Ø¢Ù…Ø¯ÛŒØ¯',
      'chat_rooms': 'Ú†ÛŒÙ¹ Ø±ÙˆÙ…Ø²',
      'popular_rooms': 'Ù…Ù‚Ø¨ÙˆÙ„ Ø±ÙˆÙ…Ø² ðŸ”¥',
      'your_balance': 'Ø¢Ù¾ Ú©Ø§ Ø¨ÛŒÙ„Ù†Ø³',
      'diamonds': 'ÚˆØ§Ø¦Ù…Ù†ÚˆØ²',
      'online': 'Ø¢Ù† Ù„Ø§Ø¦Ù†',
      'account': 'Ø§Ú©Ø§Ø¤Ù†Ù¹',
      'help_center': 'ÛÛŒÙ„Ù¾ Ø³ÛŒÙ†Ù¹Ø±',
      'logout': 'Ù„Ø§Ú¯ Ø¢Ø¤Ù¹',
      'privacy_settings': 'Ù¾Ø±Ø§Ø¦ÛŒÙˆÛŒØ³ÛŒ',
      'friend_requests': 'Ø¯ÙˆØ³ØªÛŒ Ú©ÛŒ Ø¯Ø±Ø®ÙˆØ§Ø³ØªÛŒÚº',
      'room_invites': 'Ø±ÙˆÙ… Ø¯Ø¹ÙˆØªÛŒÚº',
      'friend_messages': 'Ø¯ÙˆØ³ØªÙˆÚº Ú©Û’ Ù¾ÛŒØºØ§Ù…Ø§Øª',
      'my_gifts': 'Ù…ÛŒØ±Û’ ØªØ­Ø§Ø¦Ù',
      'transaction_history': 'Ù¹Ø±Ø§Ù†Ø²ÛŒÚ©Ø´Ù† ÛØ³Ù¹Ø±ÛŒ',
      'coins': 'Ú©ÙˆØ§Ø¦Ù†Ø²',
      'recharge': 'Ø±ÛŒÚ†Ø§Ø±Ø¬',
      'welcome_to_partychat': 'PartyChat Ù…ÛŒÚº Ø®ÙˆØ´ Ø¢Ù…Ø¯ÛŒØ¯',
      'chat_play_make_friends': 'Ú†ÛŒÙ¹ â€¢ Ú©Ú¾ÛŒÙ„ÛŒÚº â€¢ Ø¯ÙˆØ³Øª Ø¨Ù†Ø§Ø¦ÛŒÚº',
      'change_profile_photo': 'Ù¾Ø±ÙˆÙØ§Ø¦Ù„ ÙÙˆÙ¹Ùˆ ØªØ¨Ø¯ÛŒÙ„ Ú©Ø±ÛŒÚº',
      'choose_avatar': 'Ø§ÙˆØªØ§Ø± Ù…Ù†ØªØ®Ø¨ Ú©Ø±ÛŒÚº',
      'change_username': 'ÛŒÙˆØ²Ø±Ù†ÛŒÙ… ØªØ¨Ø¯ÛŒÙ„ Ú©Ø±ÛŒÚº',
      'save': 'Ù…Ø­ÙÙˆØ¸ Ú©Ø±ÛŒÚº',
      'cancel': 'Ù…Ù†Ø³ÙˆØ®',
      'play_now': 'Ø§Ø¨Ú¾ÛŒ Ú©Ú¾ÛŒÙ„ÛŒÚº',
      'my_wallet': 'Ù…ÛŒØ±Ø§ ÙˆØ§Ù„ÛŒÙ¹',
      'vip_level': 'VIP Ù„ÛŒÙˆÙ„ 3',
      'online_status': 'Ø¢Ù† Ù„Ø§Ø¦Ù† Ø§Ø³Ù¹ÛŒÙ¹Ø³',
      'room_activity': 'Ø±ÙˆÙ… Ø§ÛŒÚ©Ù¹ÛŒÙˆÛŒÙ¹ÛŒ',
      'private_account': 'Ù¾Ø±Ø§Ø¦ÛŒÙˆÛŒÙ¹ Ø§Ú©Ø§Ø¤Ù†Ù¹',
    },
    'Hindi': {
      'settings': 'à¤¸à¥‡à¤Ÿà¤¿à¤‚à¤—à¥à¤¸',
      'language': 'à¤­à¤¾à¤·à¤¾',
      'privacy': 'à¤ªà¥à¤°à¤¾à¤‡à¤µà¥‡à¤¸à¥€',
      'notifications': 'à¤¨à¥‹à¤Ÿà¤¿à¤«à¤¿à¤•à¥‡à¤¶à¤¨',
      'messages': 'à¤®à¥ˆà¤¸à¥‡à¤œ',
      'announcements': 'à¤˜à¥‹à¤·à¤£à¤¾à¤à¤‚',
      'friends': 'à¤¦à¥‹à¤¸à¥à¤¤',
      'gifts': 'à¤—à¤¿à¤«à¥à¤Ÿà¥à¤¸',
      'blocked_users': 'à¤¬à¥à¤²à¥‰à¤• à¤•à¤¿à¤ à¤—à¤ à¤¯à¥‚à¤œà¤¼à¤°à¥à¤¸',
      'home': 'à¤¹à¥‹à¤®',
      'rooms': 'à¤°à¥‚à¤®à¥à¤¸',
      'games': 'à¤—à¥‡à¤®à¥à¤¸',
      'wallet': 'à¤µà¥‰à¤²à¥‡à¤Ÿ',
      'profile': 'à¤ªà¥à¤°à¥‹à¤«à¤¾à¤‡à¤²',
      'join': 'à¤œà¥à¤¡à¤¼à¥‡à¤‚',
      'login': 'à¤²à¥‰à¤—à¤¿à¤¨',
      'create_account': 'à¤…à¤•à¤¾à¤‰à¤‚à¤Ÿ à¤¬à¤¨à¤¾à¤à¤‚',
      'get_started': 'à¤¶à¥à¤°à¥‚ à¤•à¤°à¥‡à¤‚',
      'username': 'à¤¯à¥‚à¤œà¤¼à¤°à¤¨à¥‡à¤®',
      'email': 'à¤ˆà¤®à¥‡à¤²',
      'password': 'à¤ªà¤¾à¤¸à¤µà¤°à¥à¤¡',
      'welcome': 'à¤¸à¥à¤µà¤¾à¤—à¤¤ à¤¹à¥ˆ',
      'welcome_back': 'à¤µà¤¾à¤ªà¤¸à¥€ à¤ªà¤° à¤¸à¥à¤µà¤¾à¤—à¤¤ à¤¹à¥ˆ',
      'chat_rooms': 'à¤šà¥ˆà¤Ÿ à¤°à¥‚à¤®à¥à¤¸',
      'popular_rooms': 'à¤²à¥‹à¤•à¤ªà¥à¤°à¤¿à¤¯ à¤°à¥‚à¤®à¥à¤¸ ðŸ”¥',
      'your_balance': 'à¤†à¤ªà¤•à¤¾ à¤¬à¥ˆà¤²à¥‡à¤‚à¤¸',
      'diamonds': 'à¤¡à¤¾à¤¯à¤®à¤‚à¤¡à¥à¤¸',
      'online': 'à¤‘à¤¨à¤²à¤¾à¤‡à¤¨',
      'account': 'à¤…à¤•à¤¾à¤‰à¤‚à¤Ÿ',
      'help_center': 'à¤¹à¥‡à¤²à¥à¤ª à¤¸à¥‡à¤‚à¤Ÿà¤°',
      'logout': 'à¤²à¥‰à¤—à¤†à¤‰à¤Ÿ',
      'privacy_settings': 'à¤ªà¥à¤°à¤¾à¤‡à¤µà¥‡à¤¸à¥€',
      'friend_requests': 'à¤«à¥à¤°à¥‡à¤‚à¤¡ à¤°à¤¿à¤•à¥à¤µà¥‡à¤¸à¥à¤Ÿ',
      'room_invites': 'à¤°à¥‚à¤® à¤‡à¤¨à¤µà¤¾à¤‡à¤Ÿ',
      'friend_messages': 'à¤«à¥à¤°à¥‡à¤‚à¤¡ à¤®à¥ˆà¤¸à¥‡à¤œ',
      'my_gifts': 'à¤®à¥‡à¤°à¥‡ à¤—à¤¿à¤«à¥à¤Ÿà¥à¤¸',
      'transaction_history': 'à¤Ÿà¥à¤°à¤¾à¤‚à¤œà¥ˆà¤•à¥à¤¶à¤¨ à¤¹à¤¿à¤¸à¥à¤Ÿà¥à¤°à¥€',
      'coins': 'à¤•à¥‰à¤‡à¤¨à¥à¤¸',
      'recharge': 'à¤°à¤¿à¤šà¤¾à¤°à¥à¤œ',
      'welcome_to_partychat': 'PartyChat à¤®à¥‡à¤‚ à¤†à¤ªà¤•à¤¾ à¤¸à¥à¤µà¤¾à¤—à¤¤ à¤¹à¥ˆ',
      'chat_play_make_friends': 'à¤šà¥ˆà¤Ÿ â€¢ à¤–à¥‡à¤²à¥‡à¤‚ â€¢ à¤¦à¥‹à¤¸à¥à¤¤ à¤¬à¤¨à¤¾à¤à¤‚',
      'change_profile_photo': 'à¤ªà¥à¤°à¥‹à¤«à¤¾à¤‡à¤² à¤«à¥‹à¤Ÿà¥‹ à¤¬à¤¦à¤²à¥‡à¤‚',
      'choose_avatar': 'à¤…à¤µà¤¤à¤¾à¤° à¤šà¥à¤¨à¥‡à¤‚',
      'change_username': 'à¤¯à¥‚à¤œà¤¼à¤°à¤¨à¥‡à¤® à¤¬à¤¦à¤²à¥‡à¤‚',
      'save': 'à¤¸à¥‡à¤µ',
      'cancel': 'à¤•à¥ˆà¤‚à¤¸à¤²',
      'play_now': 'à¤…à¤­à¥€ à¤–à¥‡à¤²à¥‡à¤‚',
      'my_wallet': 'à¤®à¥‡à¤°à¤¾ à¤µà¥‰à¤²à¥‡à¤Ÿ',
      'vip_level': 'VIP à¤²à¥‡à¤µà¤² 3',
      'online_status': 'à¤‘à¤¨à¤²à¤¾à¤‡à¤¨ à¤¸à¥à¤Ÿà¥‡à¤Ÿà¤¸',
      'room_activity': 'à¤°à¥‚à¤® à¤à¤•à¥à¤Ÿà¤¿à¤µà¤¿à¤Ÿà¥€',
      'private_account': 'à¤ªà¥à¤°à¤¾à¤‡à¤µà¥‡à¤Ÿ à¤…à¤•à¤¾à¤‰à¤‚à¤Ÿ',
    },
    'Arabic': {
      'settings': 'Ø§Ù„Ø¥Ø¹Ø¯Ø§Ø¯Ø§Øª',
      'language': 'Ø§Ù„Ù„ØºØ©',
      'privacy': 'Ø§Ù„Ø®ØµÙˆØµÙŠØ©',
      'notifications': 'Ø§Ù„Ø¥Ø´Ø¹Ø§Ø±Ø§Øª',
      'messages': 'Ø§Ù„Ø±Ø³Ø§Ø¦Ù„',
      'announcements': 'Ø§Ù„Ø¥Ø¹Ù„Ø§Ù†Ø§Øª',
      'friends': 'Ø§Ù„Ø£ØµØ¯Ù‚Ø§Ø¡',
      'gifts': 'Ø§Ù„Ù‡Ø¯Ø§ÙŠØ§',
      'blocked_users': 'Ø§Ù„Ù…Ø³ØªØ®Ø¯Ù…ÙˆÙ† Ø§Ù„Ù…Ø­Ø¸ÙˆØ±ÙˆÙ†',
      'home': 'Ø§Ù„Ø±Ø¦ÙŠØ³ÙŠØ©',
      'rooms': 'Ø§Ù„ØºØ±Ù',
      'games': 'Ø§Ù„Ø£Ù„Ø¹Ø§Ø¨',
      'wallet': 'Ø§Ù„Ù…Ø­ÙØ¸Ø©',
      'profile': 'Ø§Ù„Ù…Ù„Ù Ø§Ù„Ø´Ø®ØµÙŠ',
      'join': 'Ø§Ù†Ø¶Ù…Ø§Ù…',
      'login': 'ØªØ³Ø¬ÙŠÙ„ Ø§Ù„Ø¯Ø®ÙˆÙ„',
      'create_account': 'Ø¥Ù†Ø´Ø§Ø¡ Ø­Ø³Ø§Ø¨',
      'get_started': 'Ø§Ø¨Ø¯Ø£',
      'username': 'Ø§Ø³Ù… Ø§Ù„Ù…Ø³ØªØ®Ø¯Ù…',
      'email': 'Ø§Ù„Ø¨Ø±ÙŠØ¯ Ø§Ù„Ø¥Ù„ÙƒØªØ±ÙˆÙ†ÙŠ',
      'password': 'ÙƒÙ„Ù…Ø© Ø§Ù„Ù…Ø±ÙˆØ±',
      'welcome': 'Ù…Ø±Ø­Ø¨Ø§Ù‹',
      'welcome_back': 'Ù…Ø±Ø­Ø¨Ø§Ù‹ Ø¨Ø¹ÙˆØ¯ØªÙƒ',
      'chat_rooms': 'ØºØ±Ù Ø§Ù„Ø¯Ø±Ø¯Ø´Ø©',
      'popular_rooms': 'Ø§Ù„ØºØ±Ù Ø§Ù„Ø´Ø§Ø¦Ø¹Ø© ðŸ”¥',
      'your_balance': 'Ø±ØµÙŠØ¯Ùƒ',
      'diamonds': 'Ø§Ù„Ù…Ø§Ø³',
      'online': 'Ù…ØªØµÙ„',
      'account': 'Ø§Ù„Ø­Ø³Ø§Ø¨',
      'help_center': 'Ù…Ø±ÙƒØ² Ø§Ù„Ù…Ø³Ø§Ø¹Ø¯Ø©',
      'logout': 'ØªØ³Ø¬ÙŠÙ„ Ø§Ù„Ø®Ø±ÙˆØ¬',
      'privacy_settings': 'Ø§Ù„Ø®ØµÙˆØµÙŠØ©',
      'friend_requests': 'Ø·Ù„Ø¨Ø§Øª Ø§Ù„ØµØ¯Ø§Ù‚Ø©',
      'room_invites': 'Ø¯Ø¹ÙˆØ§Øª Ø§Ù„ØºØ±Ù',
      'friend_messages': 'Ø±Ø³Ø§Ø¦Ù„ Ø§Ù„Ø£ØµØ¯Ù‚Ø§Ø¡',
      'my_gifts': 'Ù‡Ø¯Ø§ÙŠØ§ÙŠ',
      'transaction_history': 'Ø³Ø¬Ù„ Ø§Ù„Ù…Ø¹Ø§Ù…Ù„Ø§Øª',
      'coins': 'Ø§Ù„Ø¹Ù…Ù„Ø§Øª',
      'recharge': 'Ø¥Ø¹Ø§Ø¯Ø© Ø§Ù„Ø´Ø­Ù†',
      'welcome_to_partychat': 'Ù…Ø±Ø­Ø¨Ø§Ù‹ Ø¨Ùƒ ÙÙŠ PartyChat',
      'chat_play_make_friends': 'Ø¯Ø±Ø¯Ø´ â€¢ Ø§Ù„Ø¹Ø¨ â€¢ ÙƒÙˆÙ‘Ù† ØµØ¯Ø§Ù‚Ø§Øª',
      'change_profile_photo': 'ØªØºÙŠÙŠØ± ØµÙˆØ±Ø© Ø§Ù„Ù…Ù„Ù Ø§Ù„Ø´Ø®ØµÙŠ',
      'choose_avatar': 'Ø§Ø®ØªØ± Ø§Ù„ØµÙˆØ±Ø© Ø§Ù„Ø±Ù…Ø²ÙŠØ©',
      'change_username': 'ØªØºÙŠÙŠØ± Ø§Ø³Ù… Ø§Ù„Ù…Ø³ØªØ®Ø¯Ù…',
      'save': 'Ø­ÙØ¸',
      'cancel': 'Ø¥Ù„ØºØ§Ø¡',
      'play_now': 'Ø§Ù„Ø¹Ø¨ Ø§Ù„Ø¢Ù†',
      'my_wallet': 'Ù…Ø­ÙØ¸ØªÙŠ',
      'vip_level': 'VIP Ø§Ù„Ù…Ø³ØªÙˆÙ‰ 3',
      'online_status': 'Ø­Ø§Ù„Ø© Ø§Ù„Ø§ØªØµØ§Ù„',
      'room_activity': 'Ù†Ø´Ø§Ø· Ø§Ù„ØºØ±ÙØ©',
      'private_account': 'Ø­Ø³Ø§Ø¨ Ø®Ø§Øµ',
    },
    'Bengali': {
      'settings': 'à¦¸à§‡à¦Ÿà¦¿à¦‚à¦¸',
      'language': 'à¦­à¦¾à¦·à¦¾',
      'privacy': 'à¦—à§‹à¦ªà¦¨à§€à¦¯à¦¼à¦¤à¦¾',
      'notifications': 'à¦¨à§‹à¦Ÿà¦¿à¦«à¦¿à¦•à§‡à¦¶à¦¨',
      'messages': 'à¦¬à¦¾à¦°à§à¦¤à¦¾',
      'announcements': 'à¦˜à§‹à¦·à¦£à¦¾',
      'friends': 'à¦¬à¦¨à§à¦§à§à¦°à¦¾',
      'gifts': 'à¦‰à¦ªà¦¹à¦¾à¦°',
      'blocked_users': 'à¦¬à§à¦²à¦• à¦•à¦°à¦¾ à¦¬à§à¦¯à¦¬à¦¹à¦¾à¦°à¦•à¦¾à¦°à§€',
      'home': 'à¦¹à§‹à¦®',
      'rooms': 'à¦°à§à¦®',
      'games': 'à¦—à§‡à¦®à¦¸',
      'wallet': 'à¦“à¦¯à¦¼à¦¾à¦²à§‡à¦Ÿ',
      'profile': 'à¦ªà§à¦°à§‹à¦«à¦¾à¦‡à¦²',
      'join': 'à¦¯à§‹à¦— à¦¦à¦¿à¦¨',
      'login': 'à¦²à¦—à¦‡à¦¨',
      'create_account': 'à¦…à§à¦¯à¦¾à¦•à¦¾à¦‰à¦¨à§à¦Ÿ à¦¤à§ˆà¦°à¦¿ à¦•à¦°à§à¦¨',
      'get_started': 'à¦¶à§à¦°à§ à¦•à¦°à§à¦¨',
      'username': 'à¦‡à¦‰à¦œà¦¾à¦°à¦¨à§‡à¦®',
      'email': 'à¦‡à¦®à§‡à¦‡à¦²',
      'password': 'à¦ªà¦¾à¦¸à¦“à¦¯à¦¼à¦¾à¦°à§à¦¡',
      'welcome': 'à¦¸à§à¦¬à¦¾à¦—à¦¤à¦®',
      'welcome_back': 'à¦†à¦¬à¦¾à¦° à¦¸à§à¦¬à¦¾à¦—à¦¤à¦®',
      'chat_rooms': 'à¦šà§à¦¯à¦¾à¦Ÿ à¦°à§à¦®',
      'popular_rooms': 'à¦œà¦¨à¦ªà§à¦°à¦¿à¦¯à¦¼ à¦°à§à¦® ðŸ”¥',
      'your_balance': 'à¦†à¦ªà¦¨à¦¾à¦° à¦¬à§à¦¯à¦¾à¦²à§‡à¦¨à§à¦¸',
      'diamonds': 'à¦¡à¦¾à¦¯à¦¼à¦®à¦¨à§à¦¡',
      'online': 'à¦…à¦¨à¦²à¦¾à¦‡à¦¨',
      'account': 'à¦…à§à¦¯à¦¾à¦•à¦¾à¦‰à¦¨à§à¦Ÿ',
      'help_center': 'à¦¹à§‡à¦²à§à¦ª à¦¸à§‡à¦¨à§à¦Ÿà¦¾à¦°',
      'logout': 'à¦²à¦—à¦†à¦‰à¦Ÿ',
      'privacy_settings': 'à¦—à§‹à¦ªà¦¨à§€à¦¯à¦¼à¦¤à¦¾',
      'friend_requests': 'à¦¬à¦¨à§à¦§à§à¦¤à§à¦¬à§‡à¦° à¦…à¦¨à§à¦°à§‹à¦§',
      'room_invites': 'à¦°à§à¦® à¦†à¦®à¦¨à§à¦¤à§à¦°à¦£',
      'friend_messages': 'à¦¬à¦¨à§à¦§à§à¦° à¦¬à¦¾à¦°à§à¦¤à¦¾',
      'my_gifts': 'à¦†à¦®à¦¾à¦° à¦‰à¦ªà¦¹à¦¾à¦°',
      'transaction_history': 'à¦²à§‡à¦¨à¦¦à§‡à¦¨à§‡à¦° à¦‡à¦¤à¦¿à¦¹à¦¾à¦¸',
      'coins': 'à¦•à¦¯à¦¼à§‡à¦¨',
      'recharge': 'à¦°à¦¿à¦šà¦¾à¦°à§à¦œ',
      'welcome_to_partychat': 'PartyChat-à¦ à¦¸à§à¦¬à¦¾à¦—à¦¤à¦®',
      'chat_play_make_friends': 'à¦šà§à¦¯à¦¾à¦Ÿ â€¢ à¦–à§‡à¦²à§à¦¨ â€¢ à¦¬à¦¨à§à¦§à§ à¦¬à¦¾à¦¨à¦¾à¦¨',
      'change_profile_photo': 'à¦ªà§à¦°à§‹à¦«à¦¾à¦‡à¦² à¦›à¦¬à¦¿ à¦ªà¦°à¦¿à¦¬à¦°à§à¦¤à¦¨ à¦•à¦°à§à¦¨',
      'choose_avatar': 'à¦…à§à¦¯à¦¾à¦­à¦¾à¦Ÿà¦¾à¦° à¦¨à¦¿à¦°à§à¦¬à¦¾à¦šà¦¨ à¦•à¦°à§à¦¨',
      'change_username': 'à¦‡à¦‰à¦œà¦¾à¦°à¦¨à§‡à¦® à¦ªà¦°à¦¿à¦¬à¦°à§à¦¤à¦¨ à¦•à¦°à§à¦¨',
      'save': 'à¦¸à¦‚à¦°à¦•à§à¦·à¦£',
      'cancel': 'à¦¬à¦¾à¦¤à¦¿à¦²',
      'play_now': 'à¦à¦–à¦¨ à¦–à§‡à¦²à§à¦¨',
      'my_wallet': 'à¦†à¦®à¦¾à¦° à¦“à¦¯à¦¼à¦¾à¦²à§‡à¦Ÿ',
      'vip_level': 'VIP à¦²à§‡à¦­à§‡à¦² 3',
      'online_status': 'à¦…à¦¨à¦²à¦¾à¦‡à¦¨ à¦¸à§à¦Ÿà§à¦¯à¦¾à¦Ÿà¦¾à¦¸',
      'room_activity': 'à¦°à§à¦® à¦•à¦¾à¦°à§à¦¯à¦•à¦²à¦¾à¦ª',
      'private_account': 'à¦ªà§à¦°à¦¾à¦‡à¦­à§‡à¦Ÿ à¦…à§à¦¯à¦¾à¦•à¦¾à¦‰à¦¨à§à¦Ÿ',
    },
    'Turkish': {
      'settings': 'Ayarlar',
      'language': 'Dil',
      'privacy': 'Gizlilik',
      'notifications': 'Bildirimler',
      'messages': 'Mesajlar',
      'announcements': 'Duyurular',
      'friends': 'ArkadaÅŸlar',
      'gifts': 'Hediyeler',
      'blocked_users': 'Engellenen KullanÄ±cÄ±lar',
      'home': 'Ana Sayfa',
      'rooms': 'Odalar',
      'games': 'Oyunlar',
      'wallet': 'CÃ¼zdan',
      'profile': 'Profil',
      'join': 'KatÄ±l',
      'login': 'GiriÅŸ',
      'create_account': 'Hesap OluÅŸtur',
      'get_started': 'BaÅŸla',
      'username': 'KullanÄ±cÄ± AdÄ±',
      'email': 'E-posta',
      'password': 'Åžifre',
      'welcome': 'HoÅŸ Geldiniz',
      'welcome_back': 'Tekrar hoÅŸ geldiniz',
      'chat_rooms': 'Sohbet OdalarÄ±',
      'popular_rooms': 'PopÃ¼ler Odalar ðŸ”¥',
      'your_balance': 'Bakiyeniz',
      'diamonds': 'Elmaslar',
      'online': 'Ã§evrimiÃ§i',
      'account': 'Hesap',
      'help_center': 'YardÄ±m Merkezi',
      'logout': 'Ã‡Ä±kÄ±ÅŸ',
      'privacy_settings': 'Gizlilik',
      'friend_requests': 'ArkadaÅŸlÄ±k Ä°stekleri',
      'room_invites': 'Oda Davetleri',
      'friend_messages': 'ArkadaÅŸ MesajlarÄ±',
      'my_gifts': 'Hediyelerim',
      'transaction_history': 'Ä°ÅŸlem GeÃ§miÅŸi',
      'coins': 'Paralar',
      'recharge': 'YÃ¼kle',
      'welcome_to_partychat': 'PartyChat\'e HoÅŸ Geldiniz',
      'chat_play_make_friends': 'Sohbet â€¢ Oyna â€¢ ArkadaÅŸ Edin',
      'change_profile_photo': 'Profil FotoÄŸrafÄ±nÄ± DeÄŸiÅŸtir',
      'choose_avatar': 'Avatar SeÃ§',
      'change_username': 'KullanÄ±cÄ± AdÄ±nÄ± DeÄŸiÅŸtir',
      'save': 'Kaydet',
      'cancel': 'Ä°ptal',
      'play_now': 'Åžimdi Oyna',
      'my_wallet': 'CÃ¼zdanÄ±m',
      'vip_level': 'VIP Seviye 3',
      'online_status': 'Ã‡evrimiÃ§i Durumu',
      'room_activity': 'Oda Aktivitesi',
      'private_account': 'Ã–zel Hesap',
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
      'popular_rooms': 'Ruang Populer ðŸ”¥',
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
      'chat_play_make_friends': 'Chat â€¢ Main â€¢ Cari Teman',
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
      'login': 'Iniciar sesiÃ³n',
      'create_account': 'Crear cuenta',
      'get_started': 'Comenzar',
      'username': 'Nombre de usuario',
      'email': 'Correo electrÃ³nico',
      'password': 'ContraseÃ±a',
      'welcome': 'Bienvenido',
      'welcome_back': 'Bienvenido de nuevo',
      'chat_rooms': 'Salas de chat',
      'popular_rooms': 'Salas populares ðŸ”¥',
      'your_balance': 'Tu saldo',
      'diamonds': 'Diamantes',
      'online': 'en lÃ­nea',
      'account': 'Cuenta',
      'help_center': 'Centro de ayuda',
      'logout': 'Cerrar sesiÃ³n',
      'privacy_settings': 'Privacidad',
      'friend_requests': 'Solicitudes de amistad',
      'room_invites': 'Invitaciones de sala',
      'friend_messages': 'Mensajes de amigos',
      'my_gifts': 'Mis regalos',
      'transaction_history': 'Historial de transacciones',
      'coins': 'Monedas',
      'recharge': 'Recargar',
      'welcome_to_partychat': 'Bienvenido a PartyChat',
      'chat_play_make_friends': 'Chatea â€¢ Juega â€¢ Haz amigos',
      'change_profile_photo': 'Cambiar foto de perfil',
      'choose_avatar': 'Elegir avatar',
      'change_username': 'Cambiar nombre de usuario',
      'save': 'Guardar',
      'cancel': 'Cancelar',
      'play_now': 'Jugar ahora',
      'my_wallet': 'Mi billetera',
      'vip_level': 'Nivel VIP 3',
      'online_status': 'Estado en lÃ­nea',
      'room_activity': 'Actividad de sala',
      'private_account': 'Cuenta privada',
    },
    'French': {
      'settings': 'ParamÃ¨tres',
      'language': 'Langue',
      'privacy': 'ConfidentialitÃ©',
      'notifications': 'Notifications',
      'messages': 'Messages',
      'announcements': 'Annonces',
      'friends': 'Amis',
      'gifts': 'Cadeaux',
      'blocked_users': 'Utilisateurs bloquÃ©s',
      'home': 'Accueil',
      'rooms': 'Salons',
      'games': 'Jeux',
      'wallet': 'Portefeuille',
      'profile': 'Profil',
      'join': 'Rejoindre',
      'login': 'Connexion',
      'create_account': 'CrÃ©er un compte',
      'get_started': 'Commencer',
      'username': 'Nom dâ€™utilisateur',
      'email': 'E-mail',
      'password': 'Mot de passe',
      'welcome': 'Bienvenue',
      'welcome_back': 'Bon retour',
      'chat_rooms': 'Salons de discussion',
      'popular_rooms': 'Salons populaires ðŸ”¥',
      'your_balance': 'Votre solde',
      'diamonds': 'Diamants',
      'online': 'en ligne',
      'account': 'Compte',
      'help_center': 'Centre dâ€™aide',
      'logout': 'DÃ©connexion',
      'privacy_settings': 'ConfidentialitÃ©',
      'friend_requests': 'Demandes dâ€™amis',
      'room_invites': 'Invitations de salon',
      'friend_messages': 'Messages des amis',
      'my_gifts': 'Mes cadeaux',
      'transaction_history': 'Historique des transactions',
      'coins': 'PiÃ¨ces',
      'recharge': 'Recharger',
      'welcome_to_partychat': 'Bienvenue sur PartyChat',
      'chat_play_make_friends': 'Discutez â€¢ Jouez â€¢ Faites des amis',
      'change_profile_photo': 'Changer la photo de profil',
      'choose_avatar': 'Choisir un avatar',
      'change_username': 'Changer le nom dâ€™utilisateur',
      'save': 'Enregistrer',
      'cancel': 'Annuler',
      'play_now': 'Jouer maintenant',
      'my_wallet': 'Mon portefeuille',
      'vip_level': 'Niveau VIP 3',
      'online_status': 'Statut en ligne',
      'room_activity': 'ActivitÃ© du salon',
      'private_account': 'Compte privÃ©',
    },
    'Chinese': {
      'settings': 'è®¾ç½®',
      'language': 'è¯­è¨€',
      'privacy': 'éšç§',
      'notifications': 'é€šçŸ¥',
      'messages': 'æ¶ˆæ¯',
      'announcements': 'å…¬å‘Š',
      'friends': 'å¥½å‹',
      'gifts': 'ç¤¼ç‰©',
      'blocked_users': 'å·²å±è”½ç”¨æˆ·',
      'home': 'é¦–é¡µ',
      'rooms': 'æˆ¿é—´',
      'games': 'æ¸¸æˆ',
      'wallet': 'é’±åŒ…',
      'profile': 'ä¸ªäººèµ„æ–™',
      'join': 'åŠ å…¥',
      'login': 'ç™»å½•',
      'create_account': 'åˆ›å»ºè´¦å·',
      'get_started': 'å¼€å§‹',
      'username': 'ç”¨æˆ·å',
      'email': 'é‚®ç®±',
      'password': 'å¯†ç ',
      'welcome': 'æ¬¢è¿Ž',
      'welcome_back': 'æ¬¢è¿Žå›žæ¥',
      'chat_rooms': 'èŠå¤©æˆ¿é—´',
      'popular_rooms': 'çƒ­é—¨æˆ¿é—´ ðŸ”¥',
      'your_balance': 'æ‚¨çš„ä½™é¢',
      'diamonds': 'é’»çŸ³',
      'online': 'åœ¨çº¿',
      'account': 'è´¦å·',
      'help_center': 'å¸®åŠ©ä¸­å¿ƒ',
      'logout': 'é€€å‡ºç™»å½•',
      'privacy_settings': 'éšç§',
      'friend_requests': 'å¥½å‹è¯·æ±‚',
      'room_invites': 'æˆ¿é—´é‚€è¯·',
      'friend_messages': 'å¥½å‹æ¶ˆæ¯',
      'my_gifts': 'æˆ‘çš„ç¤¼ç‰©',
      'transaction_history': 'äº¤æ˜“è®°å½•',
      'coins': 'é‡‘å¸',
      'recharge': 'å……å€¼',
      'welcome_to_partychat': 'æ¬¢è¿Žæ¥åˆ° PartyChat',
      'chat_play_make_friends': 'èŠå¤© â€¢ æ¸¸æˆ â€¢ äº¤æœ‹å‹',
      'change_profile_photo': 'æ›´æ¢å¤´åƒç…§ç‰‡',
      'choose_avatar': 'é€‰æ‹©å¤´åƒ',
      'change_username': 'æ›´æ”¹ç”¨æˆ·å',
      'save': 'ä¿å­˜',
      'cancel': 'å–æ¶ˆ',
      'play_now': 'ç«‹å³æ¸¸æˆ',
      'my_wallet': 'æˆ‘çš„é’±åŒ…',
      'vip_level': 'VIP ç­‰çº§ 3',
      'online_status': 'åœ¨çº¿çŠ¶æ€',
      'room_activity': 'æˆ¿é—´åŠ¨æ€',
      'private_account': 'ç§äººè´¦å·',
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

class PartyChatData {
  static FirebaseFirestore get db => FirebaseFirestore.instance;

  static DocumentReference<Map<String, dynamic>> userDoc(String uid) =>
      db.collection('users').doc(uid);

  static CollectionReference<Map<String, dynamic>> friends(String uid) =>
      userDoc(uid).collection('friends');

  static CollectionReference<Map<String, dynamic>> blocked(String uid) =>
      userDoc(uid).collection('blockedUsers');

  static Future<Map<String, dynamic>?> userData(String uid) async {
    final snap = await userDoc(uid).get();
    return snap.data();
  }

  static Future<bool> isBlockedEither(String a, String b) async {
    final aBlocksB = await blocked(a).doc(b).get();
    if (aBlocksB.exists) return true;
    final bBlocksA = await blocked(b).doc(a).get();
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
    await friends(uid).doc(otherUid).delete();
    await friends(otherUid).doc(uid).delete();
    await userDoc(otherUid).collection('friendRequests').doc(uid).delete();
    await userDoc(uid).collection('friendRequests').doc(otherUid).delete();
  }

  static Future<void> unblockUser(String uid, String otherUid) async {
    await blocked(uid).doc(otherUid).delete();
  }

  static Future<void> sendFriendRequest({
    required String fromUid,
    required String toUid,
  }) async {
    if (fromUid == toUid) return;
    if (await isBlockedEither(fromUid, toUid)) {
      throw Exception('Is user ke saath blocked relation hai.');
    }

    final existingFriend = await friends(fromUid).doc(toUid).get();
    if (existingFriend.exists) {
      throw Exception('Ye user already friend hai.');
    }

    final requestRef = userDoc(toUid).collection('friendRequests').doc(fromUid);
    final existingRequest = await requestRef.get();
    if (existingRequest.exists) {
      throw Exception('Friend request pehle hi bheji ja chuki hai.');
    }

    final fromData = await userData(fromUid) ?? {};
    await requestRef.set({
      'requesterUid': fromUid,
      'name': fromData['name'] ?? 'Party User',
      'email': fromData['email'] ?? '',
      'photoURL': fromData['photoURL'] ?? '',
      'avatar': fromData['avatar'] ?? '',
      'status': 'pending',
      'createdAt': FieldValue.serverTimestamp(),
    });

    await ProfileUnreadService.createNotification(
      uid: toUid,
      type: 'friendRequests',
      title: 'New Friend Request',
      message: '${fromData['name'] ?? 'Someone'} ne aapko friend request bheji.',
      actorUid: fromUid,
      actorName: fromData['name'] ?? 'Party User',
      actorPhoto: fromData['photoURL'] ?? '',
    );
  }

  static Future<void> acceptFriendRequest({
    required String uid,
    required String requesterUid,
  }) async {
    if (await isBlockedEither(uid, requesterUid)) {
      throw Exception('Blocked user ko friend nahi bana sakte.');
    }

    final me = await userData(uid) ?? {};
    final other = await userData(requesterUid) ?? {};
    final batch = db.batch();

    batch.set(friends(uid).doc(requesterUid), {
      'uid': requesterUid,
      'name': other['name'] ?? 'Party User',
      'email': other['email'] ?? '',
      'photoURL': other['photoURL'] ?? '',
      'avatar': other['avatar'] ?? '',
      'createdAt': FieldValue.serverTimestamp(),
    });
    batch.set(friends(requesterUid).doc(uid), {
      'uid': uid,
      'name': me['name'] ?? 'Party User',
      'email': me['email'] ?? '',
      'photoURL': me['photoURL'] ?? '',
      'avatar': me['avatar'] ?? '',
      'createdAt': FieldValue.serverTimestamp(),
    });
    batch.delete(userDoc(uid).collection('friendRequests').doc(requesterUid));
    await batch.commit();

    await ProfileUnreadService.createNotification(
      uid: requesterUid,
      type: 'friends',
      title: 'Friend Request Accepted',
      message: '${me['name'] ?? 'Party User'} ne aapki request accept kar li.',
      actorUid: uid,
      actorName: me['name'] ?? 'Party User',
      actorPhoto: me['photoURL'] ?? '',
    );
  }

  static Future<void> rejectFriendRequest({
    required String uid,
    required String requesterUid,
  }) async {
    await userDoc(uid).collection('friendRequests').doc(requesterUid).delete();
  }

  static String chatId(String a, String b) {
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
    if (await isBlockedEither(fromUid, toUid)) {
      throw Exception('Message blocked hai.');
    }

    final id = chatId(fromUid, toUid);
    final fromData = await userData(fromUid) ?? {};
    final chat = db.collection('chats').doc(id);

    await chat.collection('messages').add({
      'senderUid': fromUid,
      'receiverUid': toUid,
      'text': clean,
      'createdAt': FieldValue.serverTimestamp(),
      'isRead': false,
    });

    final summary = {
      'chatId': id,
      'otherUid': fromUid,
      'lastMessage': clean,
      'lastMessageAt': FieldValue.serverTimestamp(),
    };
    await userDoc(toUid).collection('chats').doc(id).set({
      ...summary,
      'otherUid': fromUid,
    }, SetOptions(merge: true));
    await userDoc(fromUid).collection('chats').doc(id).set({
      ...summary,
      'otherUid': toUid,
    }, SetOptions(merge: true));

    await ProfileUnreadService.createNotification(
      uid: toUid,
      type: 'friendMessages',
      title: 'New Message',
      message: '${fromData['name'] ?? 'Friend'}: $clean',
      actorUid: fromUid,
      actorName: fromData['name'] ?? 'Party User',
      actorPhoto: fromData['photoURL'] ?? '',
      chatId: id,
    );
  }

  static Future<void> sendGift({
    required String fromUid,
    required String toUid,
    required String giftName,
    required int cost,
  }) async {
    if (fromUid == toUid) throw Exception('Khud ko gift nahi bhej sakte.');
    if (await isBlockedEither(fromUid, toUid)) {
      throw Exception('Gift blocked hai.');
    }

    final senderRef = userDoc(fromUid);
    final receiverRef = userDoc(toUid);
    final senderData = await senderRef.get();
    final receiverData = await receiverRef.get();
    final sender = senderData.data() ?? {};
    final receiver = receiverData.data() ?? {};
    final coins = (sender['coins'] is num) ? (sender['coins'] as num).toInt() : 0;

    if (coins < cost) {
      throw Exception('Coins kam hain.');
    }

    final giftRef = receiverRef.collection('gifts').doc();
    final sentRef = senderRef.collection('sentGifts').doc();
    final batch = db.batch();

    batch.update(senderRef, {'coins': coins - cost});
    final giftData = {
      'giftName': giftName,
      'cost': cost,
      'senderUid': fromUid,
      'senderName': sender['name'] ?? 'Party User',
      'receiverUid': toUid,
      'receiverName': receiver['name'] ?? 'Party User',
      'createdAt': FieldValue.serverTimestamp(),
    };
    batch.set(giftRef, giftData);
    batch.set(sentRef, giftData);
    batch.set(
      senderRef.collection('transactions').doc(),
      {
        'type': 'gift_sent',
        'amount': -cost,
        'giftName': giftName,
        'createdAt': FieldValue.serverTimestamp(),
      },
    );
    await batch.commit();

    await ProfileUnreadService.createNotification(
      uid: toUid,
      type: 'gifts',
      title: 'New Gift ðŸŽ',
      message: '${sender['name'] ?? 'Party User'} ne $giftName bheja.',
      actorUid: fromUid,
      actorName: sender['name'] ?? 'Party User',
      actorPhoto: sender['photoURL'] ?? '',
    );
    await ProfileUnreadService.createNotification(
      uid: fromUid,
      type: 'myGifts',
      title: 'Gift Sent ðŸŽ',
      message: 'Aapne $giftName successfully bheja.',
      actorUid: toUid,
      actorName: receiver['name'] ?? 'Party User',
      actorPhoto: receiver['photoURL'] ?? '',
    );
  }

  static Future<void> sendRoomInvite({
    required String fromUid,
    required String toUid,
    required String roomId,
    required String roomTitle,
  }) async {
    if (await isBlockedEither(fromUid, toUid)) {
      throw Exception('Invite blocked hai.');
    }
    final fromData = await userData(fromUid) ?? {};
    final inviteRef = userDoc(toUid).collection('roomInvites').doc();
    await inviteRef.set({
      'roomId': roomId,
      'roomTitle': roomTitle,
      'inviterUid': fromUid,
      'inviterName': fromData['name'] ?? 'Party User',
      'inviterPhoto': fromData['photoURL'] ?? '',
      'status': 'pending',
      'createdAt': FieldValue.serverTimestamp(),
    });
    await ProfileUnreadService.createNotification(
      uid: toUid,
      type: 'roomInvites',
      title: 'Room Invite',
      message: '${fromData['name'] ?? 'Party User'} ne aapko room invite bheja.',
      actorUid: fromUid,
      actorName: fromData['name'] ?? 'Party User',
      actorPhoto: fromData['photoURL'] ?? '',
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
            'Email aur password required hain.',
          ),
        ),
      );
      return;
    }

    if (signup && (name.length < 3 || name.length > 20)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Username 3 se 20 characters ka hona chahiye.',
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
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 100),
        children: [
          Row(children: [
            const CircleAvatar(radius: 25, backgroundColor: Color(0xFF57307A), child: Icon(Icons.person)),
            const SizedBox(width: 12),
            const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Hello, Party User ðŸ‘‹', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
              Text('Welcome back', style: TextStyle(color: Colors.white60)),
            ])),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: const Color(0xFF211331), borderRadius: BorderRadius.circular(14), border: Border.all(color: const Color(0xFF7138FF))),
              child: const Icon(Icons.notifications_none),
            ),
          ]),
          const SizedBox(height: 18),
          _NeonPanel(
            padding: const EdgeInsets.all(20),
            child: Row(children: [
              const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Your Balance', style: TextStyle(color: Colors.white70)),
                SizedBox(height: 4),
                Text('12,580 ðŸª™', style: TextStyle(fontSize: 29, fontWeight: FontWeight.w900)),
                SizedBox(height: 5),
                Text('ðŸ’Ž 2,450 Diamonds', style: TextStyle(color: Color(0xFFD9C9FF))),
              ])),
              const Icon(Icons.diamond, size: 48, color: Color(0xFFB65CFF)),
            ]),
          ),
          const SizedBox(height: 22),
          Row(children: [const Expanded(child: Text('Popular Rooms ðŸ”¥', style: TextStyle(fontSize: 21, fontWeight: FontWeight.w900))), Text('See All â€º', style: TextStyle(color: Color(0xFFFF5DE0), fontWeight: FontWeight.w700))]),
          const SizedBox(height: 12),
          const RoomTile('Friends Forever ðŸ’œ', '2.4K online', Icons.people, subtitle: 'Chat â€¢ Friends â€¢ Fun'),
          const RoomTile('Gaming Zone ðŸŽ®', '1.8K online', Icons.games, subtitle: 'Games â€¢ Challenge â€¢ Win'),
          const RoomTile('Music Lovers ðŸŽµ', '1.2K online', Icons.music_note, subtitle: 'Music â€¢ Vibes â€¢ Party'),
          const SizedBox(height: 10),
          _NeonPanel(
            padding: EdgeInsets.zero,
            child: SizedBox(height: 120, child: Center(child: Text('GOOD VIBES\nONLY â™¥', textAlign: TextAlign.center, style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Color(0xFFF0B9FF), letterSpacing: 2)))),
          ),
        ],
      ),
    );
  }
}

class RoomsTab extends StatelessWidget {
  const RoomsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return _NeonBackground(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(18, 20, 18, 100),
        children: [
          const Text('Rooms', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900)),
          const SizedBox(height: 14),
          TextField(decoration: InputDecoration(prefixIcon: const Icon(Icons.search), hintText: 'Search rooms...', suffixIcon: const Icon(Icons.tune))),
          const SizedBox(height: 14),
          SingleChildScrollView(scrollDirection: Axis.horizontal, child: Row(children: [
            _chip('All', true), _chip('Friends', false), _chip('Gaming', false), _chip('Music', false), _chip('Fun', false),
          ])),
          const SizedBox(height: 16),
          const RoomTile('Friends Forever ðŸ’œ', '2.4K online', Icons.people, subtitle: 'Make new friends & enjoy chat'),
          const RoomTile('Gaming Zone ðŸŽ®', '1.8K online', Icons.games, subtitle: 'Play games & win rewards'),
          const RoomTile('Music Lovers ðŸŽµ', '1.2K online', Icons.music_note, subtitle: 'Music, Vibes & Party'),
          const RoomTile('Chill Zone ðŸŒ™', '980 online', Icons.nightlight_round, subtitle: 'Relax â€¢ Talk â€¢ Be Yourself'),
          const RoomTile('Love Corner ðŸ’•', '756 online', Icons.favorite, subtitle: 'Sweet talks & more'),
        ],
      ),
    );
  }

  Widget _chip(String text, bool selected) {
    return Container(margin: const EdgeInsets.only(right: 8), padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 9), decoration: BoxDecoration(gradient: selected ? const LinearGradient(colors: [Color(0xFF7338FF), Color(0xFFE52DD4)]) : null, color: selected ? null : const Color(0xFF171125), borderRadius: BorderRadius.circular(20), border: Border.all(color: const Color(0xFF51317B))), child: Text(text, style: const TextStyle(fontWeight: FontWeight.w800)));
  }
}

class RoomTile extends StatelessWidget {
  final String title;
  final String online;
  final IconData icon;
  final String subtitle;

  const RoomTile(this.title, this.online, this.icon, {super.key, this.subtitle = 'Chat â€¢ Friends â€¢ Fun'});

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
          if (docs.isEmpty) return const Center(child: Text('Pehle friends add karein.'));
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
                        const SnackBar(content: Text('Room invite bhej diya ðŸ‘')),
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

class GamesTab extends StatelessWidget {
  const GamesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return _NeonBackground(
      child: GridView.count(
        padding: const EdgeInsets.fromLTRB(18, 22, 18, 100),
        crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: .93,
        children: const [
          GameCard('Ludo', Icons.casino), GameCard('Carrom', Icons.sports), GameCard('8 Ball Pool', Icons.sports_bar), GameCard('Quiz', Icons.quiz), GameCard('Bubble Shooter', Icons.bubble_chart), GameCard('More Games', Icons.apps),
        ],
      ),
    );
  }
}

class GameCard extends StatelessWidget {
  final String title;
  final IconData icon;
  const GameCard(this.title, this.icon, {super.key});

  @override
  Widget build(BuildContext context) {
    return _NeonPanel(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Container(width: 62, height: 62, decoration: BoxDecoration(borderRadius: BorderRadius.circular(18), gradient: const LinearGradient(colors: [Color(0xFF7138FF), Color(0xFFE52DD4)]), boxShadow: const [BoxShadow(color: Color(0x664F00FF), blurRadius: 18)]), child: Icon(icon, size: 34, color: const Color(0xFFFFD15C))),
        const SizedBox(height: 13),
        Text(title, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.w900)),
        const SizedBox(height: 7),
        Text(AppLanguage.text('play_now'), style: const TextStyle(color: Color(0xFFD6B9FF), fontWeight: FontWeight.w700)),
      ]),
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
            Row(children: [const Text('12,580', style: TextStyle(fontSize: 34, fontWeight: FontWeight.w900)), const SizedBox(width: 8), const Text('ðŸª™', style: TextStyle(fontSize: 28))]),
            const SizedBox(height: 6),
            const Text('2,450 ðŸ’Ž Diamonds', style: TextStyle(fontSize: 17, color: Color(0xFFE1D2FF))),
          ])),
          const SizedBox(height: 14),
          SizedBox(width: double.infinity, child: _NeonAction(label: 'ï¼‹  Recharge', onPressed: () {})),
          const SizedBox(height: 10),
          OutlinedButton.icon(style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)), side: const BorderSide(color: Color(0xFFB65CFF))), onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TransactionHistoryPage())), icon: const Icon(Icons.history), label: const Text('Transaction History', style: TextStyle(fontWeight: FontWeight.w800))),
          const SizedBox(height: 18),
          const Text('Quick Actions', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
          const SizedBox(height: 10),
          Row(children: [
            Expanded(child: _walletAction(Icons.add_card, 'Top Up')),
            const SizedBox(width: 8),
            Expanded(child: _walletAction(Icons.account_balance, 'Withdraw')),
            const SizedBox(width: 8),
            Expanded(child: _walletAction(Icons.card_giftcard, 'Rewards')),
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
    }
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
            'Photo size zyada hai. Choti photo select karein.',
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
            'Profile photo save ho gayi ðŸ‘',
          ),
        ),
      );
    } catch (e) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Photo save nahi hui: $e',
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
            'Avatar save ho gaya ðŸ‘',
          ),
        ),
      );
    } catch (e) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Avatar save nahi hua: $e',
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
              helperText: '3â€“20 characters',
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
                        'Username 3 se 20 characters ka hona chahiye.',
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
                            'Username dobara change karne ke liye $hours hours $minutes minutes wait karein.',
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
                        'Username save ho gaya ðŸ‘',
                      ),
                    ),
                  );
                } catch (e) {
                  if (!context.mounted) return;

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Username save nahi hua: $e',
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
    if (user == null) return const Scaffold(body: Center(child: Text('Please login first.')));

    final ref = FirebaseFirestore.instance
        .collection('users').doc(user.uid).collection('friendRequests');

    return Scaffold(
      appBar: AppBar(title: Text(AppLanguage.text('friend_requests'))),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: ref.orderBy('createdAt', descending: true).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return const Center(child: Text('Requests load nahi ho sakin.'));
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final docs = snapshot.data!.docs;
          if (docs.isEmpty) return const Center(child: Text('No friend requests yet.'));
          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final d = docs[index].data();
              final uid = d['requesterUid'] ?? docs[index].id;
              return ListTile(
                leading: _NetworkOrAvatar(
                  photoUrl: d['photoURL'] as String?,
                  avatar: d['avatar'] as String?,
                ),
                title: Text(d['name'] ?? 'Party User'),
                subtitle: const Text('Wants to be your friend'),
                trailing: Wrap(
                  children: [
                    IconButton(
                      tooltip: 'Accept',
                      icon: const Icon(Icons.check_circle, color: Colors.green),
                      onPressed: () async {
                        try {
                          await PartyChatData.acceptFriendRequest(uid: user.uid, requesterUid: uid);
                        } catch (e) {
                          if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
                        }
                      },
                    ),
                    IconButton(
                      tooltip: 'Reject',
                      icon: const Icon(Icons.cancel, color: Colors.red),
                      onPressed: () async {
                        await PartyChatData.rejectFriendRequest(uid: user.uid, requesterUid: uid);
                      },
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
          if (snapshot.hasError) return const Center(child: Text('Invites load nahi ho sakin.'));
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
          if (snapshot.hasError) return const Center(child: Text('Chats load nahi ho sakin.'));
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
          if (snapshot.hasError) return const Center(child: Text('Gifts load nahi ho sakin.'));
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
                subtitle: Text('From: ${d['senderName'] ?? 'Party User'} â€¢ ${d['cost'] ?? 0} coins'),
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
          if (snapshot.hasError) return const Center(child: Text('Gifts load nahi ho sakin.'));
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
                subtitle: Text('To: ${d['receiverName'] ?? 'Party User'} â€¢ ${d['cost'] ?? 0} coins'),
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
  final searchController = TextEditingController();
  String query = '';

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> _findFriends() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    final search = searchController.text.trim().toLowerCase();
    if (search.isEmpty) return;

    final snap = await FirebaseFirestore.instance.collection('users').limit(50).get();
    final matches = snap.docs.where((d) {
      if (d.id == user.uid) return false;
      final data = d.data();
      final name = (data['name'] ?? '').toString().toLowerCase();
      final email = (data['email'] ?? '').toString().toLowerCase();
      return name.contains(search) || email.contains(search);
    }).toList();

    if (!mounted) return;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => SafeArea(
        child: SizedBox(
          height: MediaQuery.of(context).size.height * .65,
          child: matches.isEmpty
              ? const Center(child: Text('Koi user nahi mila.'))
              : ListView.builder(
                  itemCount: matches.length,
                  itemBuilder: (context, index) {
                    final d = matches[index];
                    final data = d.data();
                    return ListTile(
                      leading: _NetworkOrAvatar(
                        photoUrl: data['photoURL'] as String?,
                        avatar: data['avatar'] as String?,
                      ),
                      title: Text(data['name'] ?? 'Party User'),
                      subtitle: Text(data['email'] ?? ''),
                      trailing: IconButton(
                        icon: const Icon(Icons.person_add),
                        onPressed: () async {
                          try {
                            await PartyChatData.sendFriendRequest(
                              fromUid: user.uid,
                              toUid: d.id,
                            );
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Friend request bhej di ðŸ‘')),
                              );
                            }
                          } catch (e) {
                            if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('$e')),
                            );
                          }
                        },
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return const Scaffold(body: Center(child: Text('Please login first.')));

    final friendsRef = FirebaseFirestore.instance.collection('users').doc(user.uid).collection('friends');

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLanguage.text('friends')),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add),
            tooltip: 'Find Friends',
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('Find Friends'),
                  content: TextField(
                    controller: searchController,
                    decoration: const InputDecoration(
                      hintText: 'Name ya email search karein',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (v) => query = v,
                  ),
                  actions: [
                    FilledButton(
                      onPressed: _findFriends,
                      child: const Text('Search'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: friendsRef.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return const Center(child: Text('Friends load nahi ho sake.'));
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final docs = snapshot.data!.docs;
          if (docs.isEmpty) return const Center(child: Text('No friends yet. Find friends with the + button.'));
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
                subtitle: Text(d['email'] ?? ''),
                trailing: Wrap(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.message),
                      onPressed: () => Navigator.push(context, MaterialPageRoute(
                        builder: (_) => ChatPage(
                          otherUid: uid,
                          otherName: d['name'] ?? 'Friend',
                        ),
                      )),
                    ),
                    IconButton(
                      icon: const Icon(Icons.card_giftcard),
                      onPressed: () => _giftDialog(context, user.uid, uid, d['name'] ?? 'Friend'),
                    ),
                    IconButton(
                      icon: const Icon(Icons.block),
                      onPressed: () => _block(context, user.uid, uid, d),
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

  Future<void> _giftDialog(BuildContext context, String fromUid, String toUid, String name) async {
    final gifts = [
      {'name': 'Rose ðŸŒ¹', 'cost': 10},
      {'name': 'Heart â¤ï¸', 'cost': 50},
      {'name': 'Crown ðŸ‘‘', 'cost': 100},
      {'name': 'Diamond ðŸ’Ž', 'cost': 500},
    ];
    await showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(padding: const EdgeInsets.all(16), child: Text('Gift for $name', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
            ...gifts.map((gift) => ListTile(
              title: Text(gift['name'] as String),
              trailing: Text('${gift['cost']} coins'),
              onTap: () async {
                try {
                  await PartyChatData.sendGift(
                    fromUid: fromUid,
                    toUid: toUid,
                    giftName: gift['name'] as String,
                    cost: gift['cost'] as int,
                  );
                  if (context.mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Gift bhej diya ðŸŽ')));
                  }
                } catch (e) {
                  if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
                }
              },
            )),
          ],
        ),
      ),
    );
  }

  Future<void> _block(BuildContext context, String uid, String otherUid, Map<String, dynamic> data) async {
    try {
      await PartyChatData.blockUser(uid: uid, otherUid: otherUid, otherData: data);
      if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('User block kar diya.')));
    } catch (e) {
      if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
    }
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
                if (snapshot.hasError) return const Center(child: Text('Messages load nahi ho sake.'));
                if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                final docs = snapshot.data!.docs;
                if (docs.isEmpty) return const Center(child: Text('Say hello ðŸ‘‹'));
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

  const _NetworkOrAvatar({
    required this.photoUrl,
    required this.avatar,
  });

  @override
  Widget build(BuildContext context) {
    if (photoUrl != null && photoUrl!.isNotEmpty) {
      return CircleAvatar(backgroundImage: NetworkImage(photoUrl!));
    }
    return const CircleAvatar(child: Icon(Icons.person));
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
                child: Text('Notifications load nahi ho sakin.'),
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
          if (snapshot.hasError) return const Center(child: Text('Blocked users load nahi ho sake.'));
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
