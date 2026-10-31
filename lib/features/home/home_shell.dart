import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../core/widgets/lookin_widgets.dart';
import '../../main.dart';
import '../camera_presence/camera_screen.dart';
import '../history/history_screen.dart';
import '../profile/profile_screens.dart';
import '../request/request_screen.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _selectedIndex = 0;
  late Timer _clockTimer;
  DateTime _now = DateTime.now();
  bool _clockedIn = true;
  bool _clockedOut = false;

  @override
  void initState() {
    super.initState();
    _clockTimer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => setState(() => _now = DateTime.now()),
    );
  }

  @override
  void dispose() {
    _clockTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      _HomeTab(
        now: _now,
        clockedIn: _clockedIn,
        clockedOut: _clockedOut,
        onClock: (isClockIn) async {
          final recorded = await Navigator.of(context).push<bool>(
            MaterialPageRoute<bool>(
              builder: (_) => CameraScreen(isClockIn: isClockIn),
            ),
          );
          if (recorded == true && mounted) {
            setState(() {
              if (isClockIn) {
                _clockedIn = true;
              } else {
                _clockedOut = true;
              }
            });
          }
        },
        onRequest: () => setState(() => _selectedIndex = 2),
      ),
      const HistoryScreen(),
      const RequestScreen(),
      const ProfileScreen(),
    ];
    return Scaffold(
      body: SafeArea(
        child: IndexedStack(index: _selectedIndex, children: pages),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) =>
            setState(() => _selectedIndex = index),
        backgroundColor: Colors.white,
        indicatorColor: const Color(0xFFD9F2F1),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Home'),
          NavigationDestination(
            icon: Icon(Icons.calendar_month_outlined),
            label: 'Riwayat',
          ),
          NavigationDestination(
            icon: Icon(Icons.assignment_outlined),
            label: 'Pengajuan',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}

class _HomeTab extends StatelessWidget {
  const _HomeTab({
    required this.now,
    required this.clockedIn,
    required this.clockedOut,
    required this.onClock,
    required this.onRequest,
  });

  final DateTime now;
  final bool clockedIn;
  final bool clockedOut;
  final ValueChanged<bool> onClock;
  final VoidCallback onRequest;

  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
    children: [
      Row(
        children: [
          const LookInLogo(compact: true),
          const Spacer(),
          IconButton(
            tooltip: 'Notifikasi',
            onPressed: () {},
            icon: const Icon(Icons.notifications_none_rounded),
          ),
        ],
      ),
      const SizedBox(height: 18),
      Row(
        children: [
          const CircleAvatar(
            radius: 27,
            backgroundColor: Color(0xFFDDECF6),
            child: Icon(Icons.person, color: lookInTeal, size: 30),
          ),
          const SizedBox(width: 12),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Selamat pagi, Papoi',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
              Text(
                'Kepala Divisi',
                style: TextStyle(fontSize: 12, color: Color(0xFF718096)),
              ),
            ],
          ),
        ],
      ),
      const SizedBox(height: 22),
      _ClockCard(now: now),
      const SizedBox(height: 14),
      Row(
        children: [
          Expanded(
            child: _AttendanceButton(
              title: 'Clock In',
              icon: Icons.login_rounded,
              color: const Color(0xFF16A765),
              onPressed: () => onClock(true),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _AttendanceButton(
              title: 'Clock Out',
              icon: Icons.logout_rounded,
              color: const Color(0xFFEF4444),
              onPressed: () => onClock(false),
            ),
          ),
        ],
      ),
      const SizedBox(height: 24),
      const SectionTitle('Akses Cepat'),
      const SizedBox(height: 12),
      Row(
        children: [
          _QuickAction(
            label: 'Cuti',
            icon: Icons.beach_access_outlined,
            color: const Color(0xFFEAF2FF),
            onTap: onRequest,
          ),
          _QuickAction(
            label: 'Izin',
            icon: Icons.note_alt_outlined,
            color: const Color(0xFFEAF8F6),
            onTap: onRequest,
          ),
          _QuickAction(
            label: 'Sakit',
            icon: Icons.medical_services_outlined,
            color: const Color(0xFFFFF1F0),
            onTap: onRequest,
          ),
          _QuickAction(
            label: 'Lembur',
            icon: Icons.more_time_rounded,
            color: const Color(0xFFFFF7E6),
            onTap: onRequest,
          ),
        ],
      ),
      const SizedBox(height: 24),
      const SectionTitle('Aktivitas Hari Ini'),
      const SizedBox(height: 12),
      SurfaceCard(
        child: Column(
          children: [
            _ActivityRow(
              label: 'Jam Masuk',
              value: clockedIn ? '08:15 AM' : '--:--',
              icon: Icons.login_rounded,
              color: const Color(0xFF18A768),
            ),
            const Divider(height: 24),
            _ActivityRow(
              label: 'Jam Pulang',
              value: clockedOut ? DateFormat('hh:mm a').format(now) : '--:--',
              icon: Icons.logout_rounded,
              color: const Color(0xFFEF4444),
            ),
          ],
        ),
      ),
      const SizedBox(height: 18),
      SurfaceCard(
        color: const Color(0xFFEAF6FF),
        child: const Row(
          children: [
            Icon(Icons.tips_and_updates_outlined, color: lookInBlue),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                'Jangan lupa melakukan clock out sebelum meninggalkan kantor.',
                style: TextStyle(fontSize: 12, color: Color(0xFF334155)),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

class _ClockCard extends StatelessWidget {
  const _ClockCard({required this.now});
  final DateTime now;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        colors: [Color(0xFF008B9B), Color(0xFF13A9A7)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(22),
    ),
    child: Column(
      children: [
        Text(
          DateFormat('EEEE, dd MMMM yyyy', 'id_ID').format(now),
          style: const TextStyle(color: Colors.white70, fontSize: 13),
        ),
        const SizedBox(height: 4),
        Text(
          DateFormat('HH:mm:ss').format(now),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 42,
            height: 1.3,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
          ),
        ),
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.location_on_outlined, color: Colors.white70, size: 15),
            SizedBox(width: 4),
            Text(
              'Kantor Yogyakarta',
              style: TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ],
        ),
      ],
    ),
  );
}

class _AttendanceButton extends StatelessWidget {
  const _AttendanceButton({
    required this.title,
    required this.icon,
    required this.color,
    required this.onPressed,
  });
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => Material(
    color: Colors.white,
    borderRadius: BorderRadius.circular(18),
    child: InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(18),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          children: [
            CircleAvatar(
              radius: 23,
              backgroundColor: color.withValues(alpha: .12),
              child: Icon(icon, color: color),
            ),
            const SizedBox(height: 7),
            Text(title, style: TextStyle(color: color, fontSize: 12)),
          ],
        ),
      ),
    ),
  );
}

class _QuickAction extends StatelessWidget {
  const _QuickAction({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Expanded(
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Column(
        children: [
          Container(
            height: 58,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(child: Icon(icon, color: lookInTeal, size: 25)),
          ),
          const SizedBox(height: 7),
          Text(label, style: const TextStyle(fontSize: 11)),
        ],
      ),
    ),
  );
}

class _ActivityRow extends StatelessWidget {
  const _ActivityRow({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      CircleAvatar(
        radius: 17,
        backgroundColor: color.withValues(alpha: .12),
        child: Icon(icon, color: color, size: 17),
      ),
      const SizedBox(width: 12),
      Expanded(
        child: Text(label, style: const TextStyle(color: Color(0xFF64748B))),
      ),
      Text(
        value,
        style: const TextStyle(fontWeight: FontWeight.w700, color: lookInBlue),
      ),
    ],
  );
}
