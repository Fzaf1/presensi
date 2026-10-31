import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'features/auth/auth_screen.dart';

const lookInTeal = Color(0xFF008B9B);
const lookInBlue = Color(0xFF2563EB);
const lookInNavy = Color(0xFF120E38);
const lookInBackground = Color(0xFFF3F8FC);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID');
  runApp(const LookInApp());
}

class LookInApp extends StatelessWidget {
  const LookInApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LookIn',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: lookInBackground,
        colorScheme: ColorScheme.fromSeed(seedColor: lookInTeal),
        fontFamily: GoogleFonts.poppins().fontFamily,
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 15,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: lookInTeal, width: 1.5),
          ),
        ),
      ),
      home: const AuthScreen(),
    );
  }
}
