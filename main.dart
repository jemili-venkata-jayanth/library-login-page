import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Colors taken from the college logo
class AppColors {
  static const navy = Color(0xFF24523A);
  static const blue = Color(0xFF3F8A63);
  static const magenta = Color(0xFF2F7A55);
  static const gear = Color(0xFFB3363F);
  static const paper = Color(0xFFF8FBF8);
  static const ink = Color(0xFF1F2B24);
  static const muted = Color(0xFF66756B);
  static const line = Color(0xFFDCE8E0);
}

void main() => runApp(const LibraryApp());

class LibraryApp extends StatelessWidget {
  const LibraryApp({super.key});

  @override
  Widget build(BuildContext context) {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.blue,
        primary: AppColors.blue,
        secondary: AppColors.magenta,
      ),
      scaffoldBackgroundColor: AppColors.paper,
    );
    return MaterialApp(
      title: 'TEC Library',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.light,
      theme: base.copyWith(textTheme: GoogleFonts.figtreeTextTheme(base.textTheme)),
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _idCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _hidePass = true;
  bool _remember = false;
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _idCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    setState(() => _error = null);
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);

    // Replace this block with your real authentication call
    // (for example Firebase Auth or your own API).
    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;
    setState(() => _loading = false);
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const HomePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, c) {
          final wide = c.maxWidth >= 900;
          if (wide) {
            return Row(
              children: [
                Expanded(flex: 5, child: _BrandPanel(wide: true)),
                Expanded(
                  flex: 4,
                  child: Center(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(40),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 400),
                        child: _form(),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
          return SingleChildScrollView(
            child: Column(
              children: [
                _BrandPanel(wide: false),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 28, 24, 40),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 440),
                    child: _form(),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _form() {
    final t = Theme.of(context).textTheme;
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Sign in',
            style: GoogleFonts.fraunces(
              fontSize: 36,
              fontWeight: FontWeight.w600,
              color: AppColors.navy,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Use your college email and password to open the library.',
            style: t.bodyMedium?.copyWith(color: AppColors.muted, height: 1.5),
          ),
          const SizedBox(height: 32),
          TextFormField(
            controller: _idCtrl,
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.emailAddress,
            autofillHints: const [AutofillHints.email],
            decoration: _decoration('Email address', Icons.mail_outline),
            validator: (v) {
              final value = v?.trim() ?? '';
              if (value.isEmpty) return 'Enter your email address';
              if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value)) {
                return 'Enter a valid email address';
              }
              return null;
            },
          ),
          const SizedBox(height: 18),
          TextFormField(
            controller: _passCtrl,
            obscureText: _hidePass,
            autofillHints: const [AutofillHints.password],
            onFieldSubmitted: (_) => _signIn(),
            decoration: _decoration('Password', Icons.lock_outline).copyWith(
              suffixIcon: IconButton(
                tooltip: _hidePass ? 'Show password' : 'Hide password',
                icon: Icon(_hidePass ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                onPressed: () => setState(() => _hidePass = !_hidePass),
              ),
            ),
            validator: (v) =>
                (v == null || v.length < 6) ? 'Password must be at least 6 characters' : null,
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Checkbox(
                value: _remember,
                activeColor: AppColors.blue,
                onChanged: (v) => setState(() => _remember = v ?? false),
              ),
              Text('Keep me signed in', style: t.bodyMedium?.copyWith(color: AppColors.ink)),
              const Spacer(),
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(foregroundColor: AppColors.magenta),
                child: const Text('Forgot password?'),
              ),
            ],
          ),
          if (_error != null) ...[
            const SizedBox(height: 8),
            Text(_error!, style: t.bodySmall?.copyWith(color: AppColors.gear)),
          ],
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: FilledButton(
              onPressed: _loading ? null : _signIn,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.blue,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              child: _loading
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white),
                    )
                  : const Text('Sign in'),
            ),
          ),
          const SizedBox(height: 24),
          Center(
            child: Text(
              'New student or staff? Ask the library desk to activate your account.',
              textAlign: TextAlign.center,
              style: t.bodySmall?.copyWith(color: AppColors.muted, height: 1.5),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _decoration(String label, IconData icon) {
    OutlineInputBorder border(Color c, [double w = 1]) => OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: c, width: w),
        );
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: AppColors.muted),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      enabledBorder: border(AppColors.line),
      focusedBorder: border(AppColors.blue, 2),
      errorBorder: border(AppColors.gear),
      focusedErrorBorder: border(AppColors.gear, 2),
      floatingLabelStyle: const TextStyle(color: AppColors.blue),
    );
  }
}

class _BrandPanel extends StatelessWidget {
  const _BrandPanel({required this.wide});
  final bool wide;

  @override
  Widget build(BuildContext context) {
    final logoSize = wide ? 280.0 : 150.0;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: wide ? 48 : 32, horizontal: 32),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFE8F5EC), Color(0xFFCFE9D8)],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: wide ? MainAxisSize.max : MainAxisSize.min,
        children: [
          Container(
            width: logoSize + 40,
            height: logoSize + 40,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.12),
                  blurRadius: 40,
                  offset: const Offset(0, 16),
                ),
              ],
            ),
            child: ClipOval(
              child: Image.asset('assets/images/clg_logo.jpg', fit: BoxFit.contain),
            ),
          ),
          SizedBox(height: wide ? 40 : 22),
          Text(
            'College Library',
            textAlign: TextAlign.center,
            style: GoogleFonts.fraunces(
              fontSize: wide ? 40 : 28,
              fontWeight: FontWeight.w600,
              color: AppColors.navy,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tirumala Engineering College',
            textAlign: TextAlign.center,
            style: GoogleFonts.figtree(
              fontSize: wide ? 18 : 15,
              color: AppColors.muted,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Home, menu, branch and semester pages
// ---------------------------------------------------------------------------
const branches = ['CSE', 'AIML', 'AIDS', 'IT', 'EEE', 'ECE', 'Civil', 'Mechanical'];
const semesters = ['1-1', '1-2', '2-1', '2-2', '3-1', '3-2', '4-1', '4-2'];
const _tint = Color(0xFFE8F5EC);

class Book {
  const Book(this.title, this.author, this.branch, this.color);
  final String title, author, branch;
  final Color color;
}

const books = [
  Book('Introduction to Algorithms', 'Thomas H. Cormen', 'CSE', Color(0xFF3F8A63)),
  Book('Database System Concepts', 'Abraham Silberschatz', 'IT', Color(0xFF2F6F57)),
  Book('Operating System Concepts', 'Abraham Silberschatz', 'CSE', Color(0xFF4F8F5E)),
  Book('Computer Networks', 'Andrew S. Tanenbaum', 'ECE', Color(0xFF3C7F7A)),
  Book('Higher Engineering Mathematics', 'B. S. Grewal', 'AIML', Color(0xFF567F3F)),
  Book('Fundamentals of Electric Circuits', 'Charles K. Alexander', 'EEE', Color(0xFF2E7D6B)),
  Book('Strength of Materials', 'R. K. Bansal', 'Civil', Color(0xFF5B8F6E)),
  Book('Engineering Thermodynamics', 'P. K. Nag', 'Mechanical', Color(0xFF3D7A55)),
];

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _q = '';

  void _open(Widget page) => Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));

  void _menuTap(String item) {
    Navigator.pop(context); // close drawer
    switch (item) {
      case 'Previous papers':
        _open(PickerPage(
          title: 'Previous papers',
          subtitle: 'Select your branch',
          items: branches,
          next: (b) => PickerPage(
            title: '$b previous papers',
            subtitle: 'Select a semester',
            items: semesters,
            next: (s) => EmptyPage(title: '$b $s papers'),
          ),
        ));
      case 'Subjects':
      case 'Class materials':
        _open(PickerPage(
          title: item,
          subtitle: 'Select your branch',
          items: branches,
          next: (b) => EmptyPage(title: '$b ${item.toLowerCase()}'),
        ));
      default:
        _open(EmptyPage(title: item));
    }
  }

  @override
  Widget build(BuildContext context) {
    final q = _q.toLowerCase();
    final shown = books
        .where((b) => '${b.title} ${b.author} ${b.branch}'.toLowerCase().contains(q))
        .toList();
    const menu = {
      'Favourites': Icons.favorite_border,
      'Rented books': Icons.menu_book_outlined,
      'Class materials': Icons.folder_outlined,
      'Previous papers': Icons.description_outlined,
      'Subjects': Icons.library_books_outlined,
    };
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        titleSpacing: 0,
        title: Padding(
          padding: const EdgeInsets.only(right: 16),
          child: TextField(
            onChanged: (v) => setState(() => _q = v),
            decoration: InputDecoration(
              hintText: 'Search books or branches',
              prefixIcon: const Icon(Icons.search, color: AppColors.muted),
              filled: true,
              fillColor: _tint,
              contentPadding: const EdgeInsets.symmetric(vertical: 0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(28),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
      ),
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                color: _tint,
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipOval(
                      child: Image.asset('assets/images/clg_logo.jpg', width: 72, height: 72, fit: BoxFit.cover),
                    ),
                    const SizedBox(height: 14),
                    Text('College Library',
                        style: GoogleFonts.fraunces(fontSize: 22, fontWeight: FontWeight.w600, color: AppColors.navy)),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              for (final e in menu.entries)
                ListTile(
                  leading: Icon(e.value, color: AppColors.blue),
                  title: Text(e.key),
                  onTap: () => _menuTap(e.key),
                ),
              const Spacer(),
              ListTile(
                leading: const Icon(Icons.logout, color: AppColors.muted),
                title: const Text('Sign out'),
                onTap: () => Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const LoginPage()),
                  (r) => false,
                ),
              ),
            ],
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text('Browse by branch', style: _heading),
          const SizedBox(height: 12),
          SizedBox(
            height: 42,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: branches.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, i) => ActionChip(
                label: Text(branches[i]),
                backgroundColor: _tint,
                side: BorderSide.none,
                onPressed: () => _open(EmptyPage(title: '${branches[i]} subjects')),
              ),
            ),
          ),
          const SizedBox(height: 26),
          Text(_q.isEmpty ? 'Popular books' : 'Search results', style: _heading),
          const SizedBox(height: 14),
          if (shown.isEmpty)
            const Padding(padding: EdgeInsets.all(24), child: Text('No book matches your search.'))
          else
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: shown.length,
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 190,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.6,
              ),
              itemBuilder: (_, i) => _BookCard(book: shown[i], onTap: () => _showBook(shown[i])),
            ),
        ],
      ),
    );
  }

  TextStyle get _heading =>
      GoogleFonts.fraunces(fontSize: 24, fontWeight: FontWeight.w600, color: AppColors.navy);

  void _showBook(Book b) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(b.title, style: _heading),
            const SizedBox(height: 6),
            Text('${b.author}  |  ${b.branch}', style: const TextStyle(color: AppColors.muted)),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: FilledButton(
                style: FilledButton.styleFrom(backgroundColor: AppColors.blue),
                onPressed: () => Navigator.pop(context),
                child: const Text('Rent this book'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BookCard extends StatelessWidget {
  const _BookCard({required this.book, required this.onTap});
  final Book book;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: book.color,
                borderRadius: BorderRadius.circular(14),
              ),
              alignment: Alignment.bottomLeft,
              child: Text(
                book.branch,
                style: GoogleFonts.fraunces(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(book.title,
              maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 2),
          Text(book.author,
              maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 13, color: AppColors.muted)),
        ],
      ),
    );
  }
}

class _Grid extends StatelessWidget {
  const _Grid({required this.items, required this.onTap});
  final List<String> items;
  final void Function(String) onTap;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200,
        mainAxisSpacing: 14,
        crossAxisSpacing: 14,
        childAspectRatio: 1.5,
      ),
      itemBuilder: (_, i) => Material(
        color: _tint,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => onTap(items[i]),
          child: Center(
            child: Text(items[i],
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.navy)),
          ),
        ),
      ),
    );
  }
}

class PickerPage extends StatelessWidget {
  const PickerPage({super.key, required this.title, required this.subtitle, required this.items, required this.next});
  final String title, subtitle;
  final List<String> items;
  final Widget Function(String) next;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title), backgroundColor: Colors.white, surfaceTintColor: Colors.transparent),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(subtitle, style: const TextStyle(fontSize: 16, color: AppColors.muted)),
          const SizedBox(height: 18),
          _Grid(
            items: items,
            onTap: (v) => Navigator.of(context).push(MaterialPageRoute(builder: (_) => next(v))),
          ),
        ],
      ),
    );
  }
}

class EmptyPage extends StatelessWidget {
  const EmptyPage({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title), backgroundColor: Colors.white, surfaceTintColor: Colors.transparent),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.inbox_outlined, size: 56, color: AppColors.blue),
              SizedBox(height: 14),
              Text('Nothing here yet', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              SizedBox(height: 6),
              Text('Items added by the library will appear here.', style: TextStyle(color: AppColors.muted)),
            ],
          ),
        ),
      ),
    );
  }
}
