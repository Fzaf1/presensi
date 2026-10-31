import 'package:flutter/material.dart';

import '../../core/widgets/lookin_widgets.dart';
import '../../main.dart';
import '../auth/auth_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
    children: [
      const LookInLogo(compact: true),
      const SizedBox(height: 28),
      Center(
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            const CircleAvatar(
              radius: 54,
              backgroundColor: Color(0xFFDDECF6),
              child: Icon(Icons.person, size: 66, color: lookInTeal),
            ),
            Positioned(
              right: -2,
              bottom: 3,
              child: CircleAvatar(
                radius: 18,
                backgroundColor: lookInTeal,
                child: IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: () => _message(context, 'Pilih foto profil'),
                  icon: const Icon(
                    Icons.camera_alt_outlined,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 12),
      const Text(
        'Papoi Gila',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 19, fontWeight: FontWeight.w700),
      ),
      const Text(
        'Kepala Divisi',
        textAlign: TextAlign.center,
        style: TextStyle(color: Color(0xFF718096), fontSize: 13),
      ),
      const SizedBox(height: 16),
      SizedBox(
        height: 48,
        child: FilledButton(
          onPressed: () =>
              _message(context, 'Form edit profil siap digunakan.'),
          style: FilledButton.styleFrom(
            backgroundColor: lookInBlue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          child: const Text('Edit Profil'),
        ),
      ),
      const SizedBox(height: 24),
      SurfaceCard(
        padding: EdgeInsets.zero,
        child: Column(
          children: [
            _ProfileMenuItem(
              title: 'My Profile',
              icon: Icons.person_outline,
              onTap: () => _open(context, const MyProfileScreen()),
            ),
            _ProfileMenuItem(
              title: 'Settings',
              icon: Icons.settings_outlined,
              onTap: () => _open(context, const SettingsScreen()),
            ),
            _ProfileMenuItem(
              title: 'Syarat & Ketentuan',
              icon: Icons.description_outlined,
              onTap: () => _open(
                context,
                const PolicyScreen(title: 'Syarat & Ketentuan'),
              ),
            ),
            _ProfileMenuItem(
              title: 'Kebijakan Privasi',
              icon: Icons.privacy_tip_outlined,
              onTap: () => _open(
                context,
                const PolicyScreen(title: 'Kebijakan Privasi'),
              ),
            ),
            _ProfileMenuItem(
              title: 'Log out',
              icon: Icons.logout_rounded,
              destructive: true,
              onTap: () => Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute<void>(builder: (_) => const AuthScreen()),
                (_) => false,
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

void _open(BuildContext context, Widget screen) =>
    Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => screen));

void _message(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}

class _ProfileMenuItem extends StatelessWidget {
  const _ProfileMenuItem({
    required this.title,
    required this.icon,
    required this.onTap,
    this.destructive = false,
  });
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final bool destructive;

  @override
  Widget build(BuildContext context) => Material(
    color: Colors.transparent,
    child: ListTile(
      leading: Icon(
        icon,
        size: 20,
        color: destructive ? const Color(0xFFDC2626) : const Color(0xFF64748B),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 13,
          color: destructive
              ? const Color(0xFFDC2626)
              : const Color(0xFF172033),
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: const Icon(Icons.chevron_right, color: Color(0xFF94A3B8)),
      onTap: onTap,
    ),
  );
}

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({super.key});

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  int _tab = 0;

  @override
  Widget build(BuildContext context) => LookInPage(
    title: 'My Profile',
    child: ListView(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: const Color(0xFFE9EDF2),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: ['Personal', 'Professional', 'Documents']
                .asMap()
                .entries
                .map((entry) {
                  final selected = entry.key == _tab;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _tab = entry.key),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 160),
                        padding: const EdgeInsets.symmetric(vertical: 11),
                        decoration: BoxDecoration(
                          color: selected ? lookInBlue : Colors.transparent,
                          borderRadius: BorderRadius.circular(11),
                        ),
                        child: Text(
                          entry.value,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 11,
                            color: selected ? Colors.white : Colors.black54,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  );
                })
                .toList(),
          ),
        ),
        const SizedBox(height: 18),
        if (_tab == 0)
          const _ProfileDetails(
            entries: {
              'Full Name': 'Papoi Gila',
              'Email Address': 'papoi.gila123@gmail.com',
              'Phone Number': '085111311334',
              'Address': 'Jl. Jombor no 43, Yogyakarta',
            },
          )
        else if (_tab == 1)
          const _ProfileDetails(
            entries: {
              'Employee ID': '7879987',
              'Designation': 'Lead UI/UX Designer',
              'Company Email Address': 'papoi.gila123@gmail.com',
              'Employee Type': 'Permanent',
              'Department': 'Design',
              'Reporting Manager': 'Robert Fox',
              'Company Experience': '2 Year 5 Months',
              'Office Time': '10:00 am to 07:00 pm',
            },
          )
        else
          Column(
            children: [
              for (final document in [
                'Offer Letter',
                'Appointment Letter',
                'Bond Agreement',
                'Appraisal Letter',
                'Salary Slip',
              ])
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: SurfaceCard(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 6,
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.description_outlined,
                          color: lookInBlue,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            document,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        ),
                        IconButton(
                          tooltip: 'Unduh $document',
                          onPressed: () => _message(
                            context,
                            'Dokumen $document belum tersedia.',
                          ),
                          icon: const Icon(Icons.download_outlined),
                        ),
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

class _ProfileDetails extends StatelessWidget {
  const _ProfileDetails({required this.entries});
  final Map<String, String> entries;

  @override
  Widget build(BuildContext context) => Column(
    children: entries.entries
        .map(
          (entry) => Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 13),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Color(0xFFE8EDF2))),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.key,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF94A3B8),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  entry.value,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF293548),
                  ),
                ),
              ],
            ),
          ),
        )
        .toList(),
  );
}

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _newPassword = TextEditingController();
  final _confirmPassword = TextEditingController();
  bool _hideNew = true;
  bool _hideConfirm = true;

  @override
  void dispose() {
    _newPassword.dispose();
    _confirmPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => LookInPage(
    title: 'Ubah Kata Sandi',
    child: Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      child: Column(
        children: [
          TextField(
            controller: _newPassword,
            obscureText: _hideNew,
            decoration: InputDecoration(
              labelText: 'Kata Sandi Baru',
              suffixIcon: IconButton(
                onPressed: () => setState(() => _hideNew = !_hideNew),
                icon: Icon(
                  _hideNew ? Icons.visibility_off_outlined : Icons.visibility,
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: _confirmPassword,
            obscureText: _hideConfirm,
            decoration: InputDecoration(
              labelText: 'Konfirmasi Kata Sandi',
              suffixIcon: IconButton(
                onPressed: () => setState(() => _hideConfirm = !_hideConfirm),
                icon: Icon(
                  _hideConfirm
                      ? Icons.visibility_off_outlined
                      : Icons.visibility,
                ),
              ),
            ),
          ),
          const Spacer(),
          PrimaryButton(
            label: 'Perbarui',
            color: lookInBlue,
            onPressed: () {
              final valid =
                  _newPassword.text.length >= 6 &&
                  _newPassword.text == _confirmPassword.text;
              _message(
                context,
                valid ? 'Kata sandi berhasil diperbarui.' : 'Pastikan kata sandi minimal 6 karakter dan konfirmasi sesuai.',
              );
            },
          ),
        ],
      ),
    ),
  );
}

class PolicyScreen extends StatelessWidget {
  const PolicyScreen({required this.title, super.key});
  final String title;

  @override
  Widget build(BuildContext context) => LookInPage(
    title: title,
    child: ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 30),
      children: [
        const Text(
          'Terakhir diperbarui: 02/10/2026',
          style: TextStyle(color: Color(0xFF94A3B8), fontSize: 11),
        ),
        const SizedBox(height: 14),
        const Text(
          'Harap baca informasi ini dengan saksama sebelum menggunakan aplikasi kami.',
          style: TextStyle(fontSize: 13, height: 1.6),
        ),
        const SizedBox(height: 18),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: lookInBlue,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'LookIn membantu karyawan dan perusahaan mengelola presensi, pengajuan, serta informasi kepegawaian. Informasi akun digunakan untuk menyediakan fitur aplikasi dan dikelola sesuai kebijakan perusahaan. Data presensi hanya digunakan untuk keperluan administrasi kehadiran. Pengguna bertanggung jawab menjaga kerahasiaan kredensial akun dan memastikan informasi yang diberikan tetap akurat. Akses ke data personal diberikan kepada pihak yang berwenang sesuai kebutuhan operasional.',
          style: TextStyle(fontSize: 12, height: 1.7, color: Color(0xFF475569)),
        ),
        const SizedBox(height: 16),
        const Text(
          'Penggunaan Layanan',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: lookInBlue,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Dengan menggunakan aplikasi, pengguna menyetujui penggunaan fitur sesuai kebijakan internal perusahaan. Jangan membagikan informasi login kepada orang lain. Untuk pertanyaan atau permintaan terkait data, hubungi administrator perusahaan.',
          style: TextStyle(fontSize: 12, height: 1.7, color: Color(0xFF475569)),
        ),
      ],
    ),
  );
}
