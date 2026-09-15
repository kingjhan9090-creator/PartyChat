import 'dart:async';
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

class PartyChatApp extends StatelessWidget {
  const PartyChatApp({super.key});

  @override
  Widget build(BuildContext context) {
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
  }
}

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
      builder: (_) => user != null
          ? const MainPage()
          : const WelcomePage(),
    ),
  );
});
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 62,
              child: Icon(Icons.groups_rounded, size: 70),
            ),
            SizedBox(height: 20),
            Text(
              'PartyChat',
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.w900),
            ),
            SizedBox(height: 8),
            Text('Chat • Play • Make Friends'),
          ],
        ),
      ),
    );
  }
}

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(),
              const CircleAvatar(
                radius: 60,
                child: Icon(Icons.groups_rounded, size: 68),
              ),
              const SizedBox(height: 22),
              const Text(
                'Welcome to PartyChat',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 12),
              const Text(
                'Chat • Play • Make Friends',
                style: TextStyle(color: Colors.white70, fontSize: 17),
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
                  child: const Text(
                    'Get Started',
                    style: TextStyle(fontSize: 17),
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
                  child: const Text('Login'),
                ),
              ),
              const SizedBox(height: 25),
            ],
          ),
        ),
      ),
    );
  }
}

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
  try {
    if (signup) {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
    } else {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
    }

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const MainPage()),
    );
    } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(e.toString())),
    );
  }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(signup ? 'Create Account' : 'Login')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 25),
            const Icon(Icons.account_circle, size: 90),
            const SizedBox(height: 25),
            Text(
              signup ? 'Create your PartyChat account' : 'Welcome back!',
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
                decoration: const InputDecoration(
                  labelText: 'Username',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
              ),
            if (signup) const SizedBox(height: 14),
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: passwordController,
              obscureText: obscurePassword,
              decoration: InputDecoration(
                labelText: 'Password',
                prefixIcon: Icon(Icons.lock),
                border: OutlineInputBorder(),
                  suffixIcon: IconButton(
  icon: Icon(
    obscurePassword ? Icons.visibility : Icons.visibility_off,
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
                child: Text(signup ? 'Create Account' : 'Login'),
              ),
            ),
            const SizedBox(height: 15),
            TextButton(
              onPressed: () {
                setState(() => signup = !signup);
              },
              child: Text(
                signup
                    ? 'Already have an account? Login'
                    : 'New user? Create Account',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

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
    return Scaffold(
      body: SafeArea(child: pages[selected]),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selected,
        onDestinationSelected: (value) {
          setState(() => selected = value);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.forum_outlined),
            selectedIcon: Icon(Icons.forum),
            label: 'Rooms',
          ),
          NavigationDestination(
            icon: Icon(Icons.sports_esports_outlined),
            selectedIcon: Icon(Icons.sports_esports),
            label: 'Games',
          ),
          NavigationDestination(
            icon: Icon(Icons.account_balance_wallet_outlined),
            selectedIcon: Icon(Icons.account_balance_wallet),
            label: 'Wallet',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(18),
      children: [
        const Row(
          children: [
            CircleAvatar(
              radius: 25,
              child: Icon(Icons.person),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hello, Party User 👋',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Welcome back',
                    style: TextStyle(color: Colors.white54),
                  ),
                ],
              ),
            ),
            Icon(Icons.notifications_none),
          ],
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF7130B7), Color(0xFFB22C8D)],
            ),
            borderRadius: BorderRadius.all(Radius.circular(24)),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Your Balance'),
              SizedBox(height: 5),
              Text(
                '12,580 🪙',
                style: TextStyle(
                  fontSize: 27,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Text('💎 2,450 Diamonds'),
            ],
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'Popular Rooms 🔥',
          style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        const RoomTile('Friends Forever 💜', '2.4K online', Icons.people),
        const RoomTile('Gaming Zone 🎮', '1.8K online', Icons.games),
        const RoomTile('Music Lovers 🎵', '1.2K online', Icons.music_note),
      ],
    );
  }
}

class RoomsTab extends StatelessWidget {
  const RoomsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(18),
      children: const [
        Text(
          'Chat Rooms',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900),
        ),
        SizedBox(height: 18),
        RoomTile('Friends Forever 💜', '2.4K online', Icons.people),
        RoomTile('Gaming Zone 🎮', '1.8K online', Icons.games),
        RoomTile('Music Lovers 🎵', '1.2K online', Icons.music_note),
        RoomTile('Fun Room 😊', '980 online', Icons.celebration),
      ],
    );
  }
}

class RoomTile extends StatelessWidget {
  final String title;
  final String online;
  final IconData icon;

  const RoomTile(this.title, this.online, this.icon, {super.key});

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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
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
            child: const Text('Join'),
          ),
        ],
      ),
    );
  }
}
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
  StreamSubscription<double>? soundLevelSubscription;
  bool speakerOn = true;
  final messageController = TextEditingController();
  final List<String> messages = [];
    Widget _buildMicButton() {
  return GestureDetector(
    onTap: toggleMic,
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: micOn ? Colors.white : Colors.grey.shade800,
        boxShadow: isSpeaking
            ? [
                BoxShadow(
                  color: Colors.white.withOpacity(0.9),
                  blurRadius: 22,
                  spreadRadius: 7,
                ),
              ]
            : [],
      ),
      child: Icon(
        micOn ? Icons.mic : Icons.mic_off,
        color: micOn ? Colors.black : Colors.white,
        size: 28,
      ),
    ),
  );
    }
    void startMicGlow(String userId) {
  soundLevelSubscription?.cancel();

  soundLevelSubscription =
      ZegoUIKit().getSoundLevelStream(widget.userId).listen((level) {
    if (!micOn) return;

    final speaking = level > 20;

    if (speaking != isSpeaking) {
      setState(() {
        isSpeaking = speaking;
      });
    }
  });
    }

  @override
  void dispose() {soundLevelSubscription?.cancel();
    messageController.dispose();
    super.dispose();
  }

  void sendMessage() {
    final text = messageController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      messages.add(text);
      messageController.clear();
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

    
  @override
Widget build(BuildContext context) {
  final String roomId =
      widget.title.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '_');

  

 return Stack(
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
      bottom: 24,
      left: 0,
      right: 0,
      child: Center(
        child: _buildMicButton(),
      ),
    ),
  ],

);
}
}   
  
class GamesTab extends StatelessWidget {
  const GamesTab({super.key});

  @override
  Widget build(BuildContext context) {
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
        GameCard('Bubble Shooter', Icons.bubble_chart),
        GameCard('More Games', Icons.apps),
      ],
    );
  }
}

class GameCard extends StatelessWidget {
  final String title;
  final IconData icon;

  const GameCard(this.title, this.icon, {super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF29203E), Color(0xFF3A1836)],
        ),
        borderRadius: BorderRadius.all(Radius.circular(21)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 45,
            color: const Color(0xFFFFD15C),
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          const Text(
            'Play Now',
            style: TextStyle(color: Colors.white54),
          ),
        ],
      ),
    );
  }
}
 
class WalletTab extends StatelessWidget {
  const WalletTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(18),
      children: [
        const Text(
          'My Wallet',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 18),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF5522A1), Color(0xFFB12C8C)],
            ),
            borderRadius: BorderRadius.circular(24),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Coins'),
              Text(
                '12,580 🪙',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                ),
              ),
              SizedBox(height: 8),
              Text('2,450 💎 Diamonds'),
            ],
          ),
        ),
        const SizedBox(height: 15),
        FilledButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.add),
          label: const Text('Recharge'),
        ),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.history),
          label: const Text('Transaction History'),
        ),
      ],
    );
  }
}

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final userDoc = FirebaseFirestore.instance
    .collection('users')
    .doc(user?.uid);
      final userId = user?.uid;
      
      if (userId == null) {
  return const Center(
    child: Text('Please login first'),
  );
      }
    return ListView(
      padding: const EdgeInsets.all(18),
      children:  [
        Text(
          'Profile',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900),
        ),
        SizedBox(height: 22),
        Center(
  child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
    stream: userDoc.snapshots(),
    builder: (context, snapshot) {
      final data = snapshot.data?.data();
      final photoURL = data?['photoURL'] as String?;

      return CircleAvatar(
        radius: 52,
        backgroundImage: (photoURL != null && photoURL.isNotEmpty)
            ? NetworkImage(photoURL)
            : null,
        child: (photoURL == null || photoURL.isEmpty)
            ? const Icon(Icons.person, size: 52)
            : null,
      );
    },
  ),
),
 SizedBox(height: 10),
          const SizedBox(height: 12),

ElevatedButton.icon(
  onPressed: () async {
  final picker = ImagePicker();

  final image = await picker.pickImage(
    source: ImageSource.gallery,
  );

  if (image == null) return;

  if (!context.mounted) return;

  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text('Photo select ho gayi 👍'),
    ),
  );
},
  icon: const Icon(Icons.camera_alt),
  label: const Text('Change Profile Photo'),
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

  final avatarImages = {
    'avatar1': 'assets/avatar1_pakistan_female-2.png',
    'avatar2': 'assets/avatar2_uae_male.png',
    'avatar3': 'assets/avatar3_uk_male.png',
    'avatar4': 'assets/avatar4_russia_female.png',
    'avatar5': 'assets/avatar5_saudi_female.png',
    'avatar6': 'assets/avatar6_turkey_male.png',
    'avatar7': 'assets/avatar7_india_female.png',
    'avatar8': 'assets/avatar8_usa_male.png',
  };

  String? selected = await showDialog<String>(
    context: context,
    builder: (context) {
      String? tempSelected;

      return StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: const Text('Choose Avatar'),
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
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: tempSelected == avatar
                            ? Colors.white
                            : Colors.grey,
                        width: tempSelected == avatar ? 3 : 1,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.all(4),
                    child: Image.asset(
                      avatarImages[avatar]!,
                      fit: BoxFit.contain,
                    ),
                  ),
                );
              },
            ),
        

  if (selected == null) return;

  await userDoc.set({
    'avatar': selected,
    'photoURL': '',
  }, SetOptions(merge: true));

  if (!context.mounted) return;

  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text('Avatar save ho gaya 👍'),
    ),
  );
},
icon: const Icon(Icons.face),
label: const Text('Choose Avatar'),
),

Center(
  child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
    stream: userDoc.snapshots(),
    builder: (context, snapshot) {
      final data = snapshot.data?.data();
      final name = data?['name'] as String? ?? 'PartyChat User';

      return Text(
        '$name 👑',
        style: const TextStyle(
          fontSize: 21,
          fontWeight: FontWeight.bold,
        ),
      );
    },
  ),
),
        Center(
          child: Text(
            'VIP Level 3',
            style: TextStyle(color: Color(0xFFFFD15C)),
          ),
        ),

          const SizedBox(height: 15),

Center(
  child: ElevatedButton.icon(
    onPressed: () {
  final controller = TextEditingController();

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Change Username'),
      content: TextField(
  controller: controller,
  maxLength: 12,
  decoration: const InputDecoration(
    hintText: 'Enter new username',
  ),
),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () async {
  final newName = controller.text.trim();

  if (newName.isEmpty || newName.length < 3 || newName.length > 12) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Username 3 se 12 characters ka hona chahiye.'),
      ),
    );
    return;
  }

  debugPrint('SAVE USERNAME: $newName');
    final data = (await userDoc.get()).data();
final lastChange = data?['lastNameChangeAt'];

if (lastChange != null) {
  final lastTime = (lastChange as Timestamp).toDate();
  final difference = DateTime.now().difference(lastTime);

  if (difference.inHours < 24) {
    final remaining = 24 - difference.inHours;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Username dobara change karne ke liye $remaining hours wait karein.',
        ),
      ),
    );
    return;
  }
}
  debugPrint('USER UID: ${user?.uid}');
  debugPrint('ABOUT TO SAVE USERNAME');

  try {
    await userDoc.set({
      'name': newName,
      'lastNameChangeAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    if (context.mounted) {
      Navigator.pop(context);
    }
  } catch (e) {
    debugPrint('USERNAME SAVE FAILED: $e');

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Username save nahi hua: $e')),
      );
    }
  }
},
child: const Text('Save'),
        ),
      ],
    ),
  );
},
      
    icon: const Icon(Icons.edit),
    label: const Text('Change Username'),
  ),
),
        SizedBox(height: 20),
        ListTile(
          leading: Icon(Icons.card_giftcard),
          title: Text('My Gifts'),
          trailing: Icon(Icons.chevron_right),
        ),
        ListTile(
          leading: Icon(Icons.people),
          title: Text('Friends'),
          trailing: Icon(Icons.chevron_right),
        ),
  ListTile(
  leading: const Icon(Icons.settings),
  title: const Text('Settings'),
  trailing: const Icon(Icons.chevron_right),
  onTap: () {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Settings'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.notifications),
              title: Text('Notifications'),
            ),
            ListTile(
              leading: Icon(Icons.lock),
              title: Text('Privacy'),
            ),
            ListTile(
              leading: Icon(Icons.language),
              title: Text('Language'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  },
),
      ],
    );
  }
}
