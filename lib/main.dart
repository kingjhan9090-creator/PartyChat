
import 'package:flutter/material.dart';

void main() => runApp(const PartyChatApp());

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
      if (mounted) Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => const WelcomePage()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft, end: Alignment.bottomRight,
            colors: [Color(0xFF12082A), Color(0xFF08070F), Color(0xFF24052D)],
          ),
        ),
        child: Center(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Container(
              width: 125, height: 125,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [Color(0xFFB85CFF), Color(0xFFFFC52F)],
                ),
                boxShadow: const [BoxShadow(
                  color: Color(0x889B42FF), blurRadius: 35, spreadRadius: 8)],
              ),
              child: const Icon(Icons.groups_rounded, size: 72, color: Colors.white),
            ),
            const SizedBox(height: 22),
            const Text('PartyChat',
              style: TextStyle(fontSize: 42, fontWeight: FontWeight.w900)),
            const SizedBox(height: 8),
            const Text('Chat • Play • Make Friends • Earn',
              style: TextStyle(color: Colors.white70)),
          ]),
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
          child: Column(children: [
            const Spacer(),
            Container(
              width: 120, height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [Color(0xFF8B38FF), Color(0xFFFFC52F)]),
                ),
                child: const Icon(Icons.groups_rounded, size: 68),
              ),
            ),
            const SizedBox(height: 22),
            const Text('Welcome to PartyChat',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 31, fontWeight: FontWeight.w900)),
            const SizedBox(height: 12),
            const Text('دوست بنائیں • گیم کھیلیں • بات کریں',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, color: Colors.white70)),
            const Spacer(),
            SizedBox(width: double.infinity, height: 54,
              child: FilledButton(
                onPressed: () => Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (_) => const MainPage())),
                child: const Text('Get Started  →',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
              )),
            const SizedBox(height: 12),
            SizedBox(width: double.infinity, height: 54,
              child: OutlinedButton(
                onPressed: () => Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (_) => const MainPage())),
                child: const Text('Login'))),
            const SizedBox(height: 24),
          ]),
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
  final pages = const [HomeTab(), RoomsTab(), GamesTab(), WalletTab(), ProfileTab()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: pages[selected]),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selected,
        onDestinationSelected: (v) => setState(() => selected = v),
        backgroundColor: const Color(0xFF11101A),
        indicatorColor: const Color(0xFF7134BA),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.forum_outlined), selectedIcon: Icon(Icons.forum), label: 'Rooms'),
          NavigationDestination(icon: Icon(Icons.sports_esports_outlined), selectedIcon: Icon(Icons.sports_esports), label: 'Games'),
          NavigationDestination(icon: Icon(Icons.account_balance_wallet_outlined), selectedIcon: Icon(Icons.account_balance_wallet), label: 'Wallet'),
          NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});
  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.fromLTRB(18, 16, 18, 25),
    children: [
      Row(children: [
        const CircleAvatar(radius: 25, child: Icon(Icons.person)),
        const SizedBox(width: 11),
        const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Hello, Party User 👋', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Text('Welcome back', style: TextStyle(color: Colors.white54)),
        ])),
        IconButton(onPressed: () {}, icon: const Icon(Icons.notifications_none)),
      ]),
      const SizedBox(height: 18),
      Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [Color(0xFF7130B7), Color(0xFFB22C8D)]),
          borderRadius: BorderRadius.circular(24),
        ),
        child: const Row(children: [
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Your Balance', style: TextStyle(color: Colors.white70)),
            SizedBox(height: 5),
            Text('12,580 🪙', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900)),
            SizedBox(height: 3),
            Text('💎 2,450 Diamonds'),
          ])),
          Icon(Icons.workspace_premium, size: 55, color: Color(0xFFFFD15C)),
        ]),
      ),
      const SizedBox(height: 20),
      Row(children: [
        Expanded(child: ActionCard('Chat Rooms', Icons.forum, const Color(0xFFB22B96))),
        const SizedBox(width: 10),
        Expanded(child: ActionCard('Mini Games', Icons.sports_esports, const Color(0xFF247EEA))),
      ]),
      const SizedBox(height: 10),
      Row(children: [
        Expanded(child: ActionCard('Lucky Draw', Icons.card_giftcard, const Color(0xFFE38D16))),
        const SizedBox(width: 10),
        Expanded(child: ActionCard('Wallet', Icons.account_balance_wallet, const Color(0xFF18A96D))),
      ]),
      const SizedBox(height: 22),
      const Text('Popular Rooms 🔥', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
      const SizedBox(height: 10),
      const RoomTile('Friends Forever 💜', '2.4K online', Icons.people),
      const RoomTile('Gaming Zone 🎮', '1.8K online', Icons.sports_esports),
      const RoomTile('Music Lovers 🎵', '1.2K online', Icons.music_note),
    ],
  );
}

class ActionCard extends StatelessWidget {
  final String title; final IconData icon; final Color color;
  const ActionCard(this.title, this.icon, this.color, {super.key});
  @override
  Widget build(BuildContext context) => Container(
    height: 112,
    decoration: BoxDecoration(
      color: color, borderRadius: BorderRadius.circular(20),
      boxShadow: const [BoxShadow(color: Colors.black38, blurRadius: 12, offset: Offset(0, 5))],
    ),
    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Icon(icon, size: 35), const SizedBox(height: 7),
      Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
    ]),
  );
}

class RoomTile extends StatelessWidget {
  final String title, online; final IconData icon;
  const RoomTile(this.title, this.online, this.icon, {super.key});
  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 9),
    padding: const EdgeInsets.all(13),
    decoration: BoxDecoration(color: const Color(0xFF15131F), borderRadius: BorderRadius.circular(17)),
    child: Row(children: [
      CircleAvatar(radius: 24, child: Icon(icon)),
      const SizedBox(width: 12),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(online, style: const TextStyle(color: Colors.greenAccent, fontSize: 12)),
      ])),
      FilledButton(onPressed: () {}, child: const Text('Join')),
    ]),
  );
}

class RoomsTab extends StatelessWidget {
  const RoomsTab({super.key});
  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.all(18),
    children: const [
      Text('Chat Rooms', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900)),
      SizedBox(height: 17),
      RoomTile('Friends Forever 💜', '2.4K online', Icons.people),
      RoomTile('Gaming Zone 🎮', '1.8K online', Icons.sports_esports),
      RoomTile('Music Lovers 🎵', '1.2K online', Icons.music_note),
      RoomTile('Fun & Masti 😊', '980 online', Icons.celebration),
      RoomTile('Girls Only 👑', '760 online', Icons.favorite),
    ],
  );
}

class GamesTab extends StatelessWidget {
  const GamesTab({super.key});
  @override
  Widget build(BuildContext context) => GridView.count(
    padding: const EdgeInsets.all(18), crossAxisCount: 2,
    crossAxisSpacing: 12, mainAxisSpacing: 12,
    children: const [
      GameCard('Bubble Shooter', Icons.bubble_chart),
      GameCard('Carrom', Icons.sports),
      GameCard('8 Ball Pool', Icons.sports_bar),
      GameCard('Quiz', Icons.quiz),
      GameCard('Ludo', Icons.casino),
      GameCard('More Games', Icons.apps),
    ],
  );
}

class GameCard extends StatelessWidget {
  final String title; final IconData icon;
  const GameCard(this.title, this.icon, {super.key});
  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      gradient: const LinearGradient(colors: [Color(0xFF29203E), Color(0xFF3A1836)]),
      borderRadius: BorderRadius.circular(21),
      border: Border.all(color: Colors.white10),
    ),
    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Icon(icon, size: 45, color: const Color(0xFFFFD15C)),
      const SizedBox(height: 10),
      Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      const SizedBox(height: 5),
      const Text('Play Now', style: TextStyle(color: Colors.white54, fontSize: 12)),
    ]),
  );
}

class WalletTab extends StatelessWidget {
  const WalletTab({super.key});
  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.all(18),
    children: [
      const Text('My Wallet', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900)),
      const SizedBox(height: 18),
      Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [Color(0xFF5522A1), Color(0xFFB12C8C)]),
          borderRadius: BorderRadius.circular(24),
        ),
        child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Coins', style: TextStyle(color: Colors.white70)),
          Text('12,580 🪙', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900)),
          SizedBox(height: 8),
          Text('2,450 💎 Diamonds'),
        ]),
      ),
      const SizedBox(height: 15),
      FilledButton.icon(onPressed: () {}, icon: const Icon(Icons.add), label: const Text('Recharge')),
      const SizedBox(height: 8),
      OutlinedButton.icon(onPressed: () {}, icon: const Icon(Icons.history), label: const Text('Transaction History')),
    ],
  );
}

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});
  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.all(18),
    children: [
      const Text('Profile', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900)),
      const SizedBox(height: 22),
      const Center(child: CircleAvatar(radius: 52, child: Icon(Icons.person, size: 52))),
      const SizedBox(height: 10),
      const Center(child: Text('PartyChat User 👑', style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold))),
      const Center(child: Text('VIP Level 3', style: TextStyle(color: Color(0xFFFFD15C)))),
      const SizedBox(height: 20),
      const ListTile(leading: Icon(Icons.card_giftcard), title: Text('My Gifts'), trailing: Icon(Icons.chevron_right)),
      const ListTile(leading: Icon(Icons.people), title: Text('Friends'), trailing: Icon(Icons.chevron_right)),
      const ListTile(leading: Icon(Icons.settings), title: Text('Settings'), trailing: Icon(Icons.chevron_right)),
    ],
  );
}
