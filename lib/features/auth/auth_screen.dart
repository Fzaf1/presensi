import 'package:flutter/material.dart';

import '../../core/widgets/lookin_widgets.dart';
import '../../main.dart';
import '../home/home_shell.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isSignUp = false;
  bool _hidePassword = true;
  bool _acceptedCaptcha = false;
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _nameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(builder: (_) => const HomeShell()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isSignUp = _isSignUp;
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    height: 250,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFFDDF3FF), Color(0xFFF6FBFF)],
                      ),
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.elliptical(240, 38),
                      ),
                    ),
                    child: const Center(child: LookInLogo()),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 28, 24, 30),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            isSignUp ? 'Buat Akun' : 'Selamat Datang',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            isSignUp
                                ? 'Daftar untuk mulai menggunakan LookIn'
                                : 'Masuk untuk melanjutkan ke akun Anda',
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Color(0xFF718096)),
                          ),
                          const SizedBox(height: 24),
                          _authField(
                            controller: _emailController,
                            label: 'Email',
                            icon: Icons.email_outlined,
                            validator: (value) {
                              if (value == null || !value.contains('@')) {
                                return 'Masukkan alamat email yang valid';
                              }
                              return null;
                            },
                          ),
                          if (isSignUp) ...[
                            const SizedBox(height: 12),
                            _authField(
                              controller: _nameController,
                              label: 'Username',
                              icon: Icons.person_outline,
                              validator: (value) =>
                                  value == null || value.trim().isEmpty
                                  ? 'Username wajib diisi'
                                  : null,
                            ),
                          ],
                          const SizedBox(height: 12),
                          _authField(
                            controller: _passwordController,
                            label: 'Password',
                            icon: Icons.lock_outline,
                            obscure: _hidePassword,
                            suffix: IconButton(
                              tooltip: _hidePassword
                                  ? 'Tampilkan kata sandi'
                                  : 'Sembunyikan kata sandi',
                              onPressed: () => setState(
                                () => _hidePassword = !_hidePassword,
                              ),
                              icon: Icon(
                                _hidePassword
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                              ),
                            ),
                            validator: (value) =>
                                value == null || value.length < 6
                                ? 'Kata sandi minimal 6 karakter'
                                : null,
                          ),
                          if (isSignUp) ...[
                            const SizedBox(height: 12),
                            _authField(
                              label: 'Konfirmasi Password',
                              icon: Icons.lock_outline,
                              obscure: _hidePassword,
                              validator: (value) =>
                                  value != _passwordController.text
                                  ? 'Konfirmasi kata sandi tidak sama'
                                  : null,
                            ),
                            CheckboxListTile(
                              contentPadding: EdgeInsets.zero,
                              value: _acceptedCaptcha,
                              onChanged: (value) => setState(
                                () => _acceptedCaptcha = value ?? false,
                              ),
                              title: const Text(
                                "I'm not a robot",
                                style: TextStyle(fontSize: 13),
                              ),
                              secondary: const Icon(
                                Icons.verified_user_outlined,
                                color: Color(0xFF64748B),
                              ),
                              controlAffinity: ListTileControlAffinity.leading,
                            ),
                          ] else
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () => _showMessage(
                                  'Tautan pemulihan akan dikirim ke email Anda.',
                                ),
                                child: const Text('Lupa Password?'),
                              ),
                            ),
                          const SizedBox(height: 12),
                          PrimaryButton(
                            label: isSignUp ? 'REGISTRASI' : 'MASUK',
                            onPressed: () {
                              if (isSignUp && !_acceptedCaptcha) {
                                _showMessage(
                                  'Centang verifikasi terlebih dahulu.',
                                );
                                return;
                              }
                              _submit();
                            },
                          ),
                          if (!isSignUp) ...[
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              child: Text(
                                'atau lanjutkan dengan',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Color(0xFF718096)),
                              ),
                            ),
                            OutlinedButton.icon(
                              onPressed: () => _showMessage(
                                'Google Sign-In siap dihubungkan ke Firebase.',
                              ),
                              icon: const Icon(
                                Icons.g_mobiledata,
                                size: 28,
                                color: lookInBlue,
                              ),
                              label: const Text('Lanjutkan dengan Google'),
                              style: OutlinedButton.styleFrom(
                                minimumSize: const Size.fromHeight(50),
                                foregroundColor: const Color(0xFF334155),
                                side: const BorderSide(
                                  color: Color(0xFFE2E8F0),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                            ),
                          ],
                          TextButton(
                            onPressed: () => setState(() {
                              _isSignUp = !_isSignUp;
                              _formKey.currentState?.reset();
                            }),
                            child: Text(
                              isSignUp
                                  ? 'Sudah memiliki akun? Masuk'
                                  : 'Belum memiliki akun? Registrasi',
                            ),
                          ),
                        ],
                      ),
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

  Widget _authField({
    required String label,
    required IconData icon,
    TextEditingController? controller,
    bool obscure = false,
    Widget? suffix,
    String? Function(String?)? validator,
  }) => TextFormField(
    controller: controller,
    obscureText: obscure,
    validator: validator,
    decoration: InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, size: 20),
      suffixIcon: suffix,
    ),
  );

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }
}
