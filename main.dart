import 'dart:math';
import 'package:flutter/material.dart';

void main() => runApp(const FolioApp());

class FolioApp extends StatelessWidget {
  const FolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Folio',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, fontFamily: 'Inter'),
      home: const LoginPage(),
    );
  }
}

// ---- Palette ----
const pine = Color(0xFF1B2A22);
const pine2 = Color(0xFF2F4A3D);
const cream = Color(0xFFF5F1E6);
const brass = Color(0xFFC89B5C);
const ink = Color(0xFF2B2A26);
const inkSoft = Color(0xFF6B6A62);

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _remember = false;
  bool _obscure = true;
  String? _status; // 'ok' | 'error' | null

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    // Demo-only check. Replace with a real auth call in production.
    setState(() {
      _status =
          (_passwordCtrl.text.length >= 4) ? 'ok' : 'error';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: pine,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 920),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final wide = constraints.maxWidth > 720;
                  return Container(
                    decoration: BoxDecoration(
                      color: cream,
                      borderRadius: BorderRadius.circular(6),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(.35),
                          blurRadius: 60,
                          offset: const Offset(0, 30),
                        ),
                      ],
                    ),
                    child: wide
                        ? IntrinsicHeight(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Expanded(child: _Shelf()),
                                Expanded(child: _LoginForm(state: this)),
                              ],
                            ),
                          )
                        : _LoginForm(state: this),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ---- Left panel: decorative bookshelf ----
class _Shelf extends StatelessWidget {
  static const _colors = [
    brass,
    Color(0xFF8B4A3E),
    Color(0xFF4C6B54),
    Color(0xFFD9C27E),
    Color(0xFF5A4A6B),
    Color(0xFFB5654A),
    Color(0xFF3F5A4C),
  ];

  @override
  Widget build(BuildContext context) {
    final rnd = Random(7); // fixed seed so it doesn't reshuffle on rebuild
    return Container(
      color: pine2,
      padding: const EdgeInsets.fromLTRB(28, 36, 28, 36),
      child: Stack(
        children: [
          const Align(
            alignment: Alignment.topLeft,
            child: Text(
              'Folio',
              style: TextStyle(
                fontFamily: 'serif',
                fontWeight: FontWeight.w600,
                fontSize: 22,
                color: cream,
                letterSpacing: .3,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 56),
              child: SizedBox(
                height: 240,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: List.generate(14, (i) {
                    final h = 60 + rnd.nextDouble() * 160;
                    return Expanded(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        height: h,
                        decoration: BoxDecoration(
                          color: _colors[i % _colors.length],
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(2),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
          ),
          const Align(
            alignment: Alignment.bottomLeft,
            child: Text(
              "Every book you've borrowed, renewed, or meant to finish "
              '— in one place.',
              style: TextStyle(
                fontFamily: 'serif',
                fontStyle: FontStyle.italic,
                fontSize: 15,
                height: 1.5,
                color: cream,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---- Right panel: the actual form ----
class _LoginForm extends StatelessWidget {
  final _LoginPageState state;
  const _LoginForm({required this.state});

  InputDecoration _decoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: const Color(0xFFFFFEFB),
      contentPadding: const EdgeInsets.symmetric(horizontal: 13, vertical: 13),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: const BorderSide(color: Color(0xFFDDD7C8)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: const BorderSide(color: Color(0xFFDDD7C8)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: const BorderSide(color: brass, width: 1.4),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(44, 52, 44, 52),
      child: Form(
        key: state._formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Welcome back',
              style: TextStyle(
                fontFamily: 'serif',
                fontWeight: FontWeight.w600,
                fontSize: 28,
                color: ink,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Sign in to see your borrowed books and holds.',
              style: TextStyle(fontSize: 14.5, color: inkSoft),
            ),
            const SizedBox(height: 26),

            if (state._status == 'error')
              _Banner(
                text: "That email and password don't match our records.",
                bg: const Color(0xFFF7E4E1),
                fg: const Color(0xFF8A3B2C),
              ),
            if (state._status == 'ok')
              _Banner(
                text: 'Signed in — redirecting to your shelf.',
                bg: const Color(0xFFE1EBE3),
                fg: pine2,
              ),
            if (state._status != null) const SizedBox(height: 16),

            TextFormField(
              controller: state._emailCtrl,
              keyboardType: TextInputType.emailAddress,
              decoration: _decoration('Email'),
              validator: (v) =>
                  (v == null || !v.contains('@')) ? 'Enter a valid email' : null,
            ),
            const SizedBox(height: 18),
            StatefulBuilder(
              builder: (context, setLocal) {
                return TextFormField(
                  controller: state._passwordCtrl,
                  obscureText: state._obscure,
                  decoration: _decoration('Password').copyWith(
                    suffixIcon: IconButton(
                      icon: Icon(
                        state._obscure
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        size: 20,
                        color: inkSoft,
                      ),
                      onPressed: () =>
                          setLocal(() => state._obscure = !state._obscure),
                    ),
                  ),
                  validator: (v) => (v == null || v.length < 4)
                      ? 'At least 4 characters'
                      : null,
                );
              },
            ),
            const SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                StatefulBuilder(
                  builder: (context, setLocal) {
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          height: 22,
                          width: 22,
                          child: Checkbox(
                            value: state._remember,
                            activeColor: pine2,
                            onChanged: (v) =>
                                setLocal(() => state._remember = v ?? false),
                          ),
                        ),
                        const SizedBox(width: 7),
                        const Text('Keep me signed in',
                            style: TextStyle(fontSize: 13, color: inkSoft)),
                      ],
                    );
                  },
                ),
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text('Forgot password?',
                      style: TextStyle(fontSize: 13, color: pine2)),
                ),
              ],
            ),
            const SizedBox(height: 22),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: state._submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: pine,
                  foregroundColor: cream,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  elevation: 0,
                ).copyWith(
                  overlayColor:
                      WidgetStateProperty.all(pine2.withOpacity(.4)),
                ),
                child: const Text('Sign in',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14.5)),
              ),
            ),
            const SizedBox(height: 22),

            Center(
              child: RichText(
                text: TextSpan(
                  style: const TextStyle(fontSize: 13.5, color: inkSoft),
                  children: [
                    const TextSpan(text: 'New to Folio? '),
                    TextSpan(
                      text: 'Create an account',
                      style: const TextStyle(
                        color: brass,
                        fontWeight: FontWeight.w600,
                      ),
                      recognizer: null,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Banner extends StatelessWidget {
  final String text;
  final Color bg;
  final Color fg;
  const _Banner({required this.text, required this.bg, required this.fg});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(4)),
      child: Text(text, style: TextStyle(fontSize: 13, color: fg)),
    );
  }
}
