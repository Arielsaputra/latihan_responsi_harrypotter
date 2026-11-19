import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/custom_snackbar.dart';
import 'character_view.dart';

// Halaman Login Aplikasi Harry Potter
class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  // Controller untuk mengambil input teks dari TextField
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Akun hardcoded sesuai ketentuan responsi
  // Username: admin, Password: admin
  final String _hardcodedUsername = 'admin';
  final String _hardcodedPassword = 'admin';

  // State untuk melihat/menyembunyikan password
  bool _obscurePassword = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Fungsi untuk memproses login
  Future<void> _handleLogin() async {
    final String inputUsername = _usernameController.text.trim();
    final String inputPassword = _passwordController.text.trim();

    // Validasi input tidak boleh kosong
    if (inputUsername.isEmpty || inputPassword.isEmpty) {
      CustomSnackBar.showError(
        context: context,
        title: 'Failed!',
        message: 'Username and password cannot be empty',
      );
      return;
    }

    // Pengecekan logika login (Hardcoded)
    if (inputUsername == _hardcodedUsername && inputPassword == _hardcodedPassword) {
      // Simpan session login ke SharedPreferences
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('is_logged_in', true);
      await prefs.setString('username', inputUsername);

      if (!mounted) return;

      // Tampilkan snackbar sukses sesuai contoh screenshot (Warna Hijau)
      CustomSnackBar.showSuccess(
        context: context,
        title: 'Success!',
        message: 'Logged in Successfully',
      );

      // Pindah ke halaman Character View dan hapus history route login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const CharacterView()),
      );
    } else {
      if (!mounted) return;

      // Tampilkan snackbar gagal jika username atau password salah (Warna Merah)
      CustomSnackBar.showError(
        context: context,
        title: 'Failed!',
        message: 'Invalid username or password',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Judul Halaman
              const Text(
                'Login',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 24),

              // Form Input Username
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                  hintText: 'admin',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Form Input Password
              TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: 'Password',
                  hintText: 'admin',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  // Tombol toggle tampilkan password
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_off : Icons.visibility,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Tombol Login
              SizedBox(
                width: double.infinity,
                height: 44,
                child: OutlinedButton(
                  onPressed: _handleLogin,
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    side: BorderSide(color: Colors.grey.shade400),
                  ),
                  child: const Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),
              // Hint info untuk penguji / praktikan
              Text(
                'Hint: Gunakan username "admin" dan password "admin"',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
