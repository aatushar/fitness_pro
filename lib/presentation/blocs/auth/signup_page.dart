import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_event.dart';
import '../../blocs/auth/auth_state.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _usernameCtrl  = TextEditingController();
  final _emailCtrl     = TextEditingController();
  final _passwordCtrl  = TextEditingController();
  String _selectedRole = 'manager';
  bool _obscurePass    = true;

  static const _roles = ['manager', 'trainer', 'member'];

  static const _purple     = Color(0xFF7C3AED);
  static const _purpleLight= Color(0xFF9F87F5);
  static const _bg         = Color(0xFF0D0D1A);
  static const _surface    = Color(0xFF13132A);
  static const _surfaceAct = Color(0xFF17173A);
  static const _border     = Color(0xFF2A2A4A);
  static const _borderAct  = Color(0xFF7C3AED);
  static const _textPrim   = Color(0xFFF0EDFF);
  static const _textMuted  = Color(0xFF6B6B8A);
  static const _labelColor = Color(0xFF7C6FCD);

  @override
  void dispose() {
    _usernameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  void _submit(BuildContext context) {
    context.read<AuthBloc>().add(SignupSubmitted(
      username: _usernameCtrl.text.trim(),
      email:    _emailCtrl.text.trim(),
      password: _passwordCtrl.text,
      role:     [_selectedRole],
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Account created!')),
            );
            // TODO: navigate to login or dashboard
          }
          if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // logo mark
                  Container(
                    width: 52, height: 52,
                    decoration: BoxDecoration(
                      color: _purple,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(Icons.fitness_center_rounded,
                        color: Colors.white, size: 26),
                  ),
                  const SizedBox(height: 20),
                  const Text('Create account',
                    style: TextStyle(
                      fontSize: 28, fontWeight: FontWeight.w700,
                      color: _textPrim, letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text('Join Fitness Pro — manage your gym smarter',
                    style: TextStyle(fontSize: 13, color: _textMuted),
                  ),
                  const SizedBox(height: 32),

                  _buildField(
                    label: 'USERNAME',
                    controller: _usernameCtrl,
                    icon: Icons.person_outline_rounded,
                    hint: 'e.g. alim',
                  ),
                  const SizedBox(height: 16),
                  _buildField(
                    label: 'EMAIL ADDRESS',
                    controller: _emailCtrl,
                    icon: Icons.mail_outline_rounded,
                    hint: 'you@example.com',
                    keyboard: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),
                  _buildField(
                    label: 'PASSWORD',
                    controller: _passwordCtrl,
                    icon: Icons.lock_outline_rounded,
                    hint: '••••••••',
                    obscure: _obscurePass,
                    suffix: IconButton(
                      icon: Icon(
                        _obscurePass
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: _textMuted, size: 18,
                      ),
                      onPressed: () => setState(() => _obscurePass = !_obscurePass),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // role picker
                  Text('SELECT ROLE',
                    style: TextStyle(
                      fontSize: 11, fontWeight: FontWeight.w600,
                      color: _labelColor, letterSpacing: 0.08,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: _roles.map((role) {
                      final selected = _selectedRole == role;
                      return Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _selectedRole = role),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            margin: const EdgeInsets.only(right: 8),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: selected ? const Color(0xFF1E1040) : _surface,
                              border: Border.all(
                                color: selected ? _borderAct : _border,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              role[0].toUpperCase() + role.substring(1),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: selected ? _purpleLight : _textMuted,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 28),

                  // submit button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: state is AuthLoading ? null : () => _submit(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _purple,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 0,
                      ),
                      child: state is AuthLoading
                          ? const SizedBox(
                        width: 20, height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2,
                        ),
                      )
                          : const Text('Create account',
                        style: TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  Row(children: [
                    const Expanded(child: Divider(color: Color(0xFF1E1E38))),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Text('already have an account?',
                        style: TextStyle(fontSize: 11, color: Color(0xFF3A3A5A)),
                      ),
                    ),
                    const Expanded(child: Divider(color: Color(0xFF1E1E38))),
                  ]),
                  const SizedBox(height: 16),

                  Center(
                    child: GestureDetector(
                      onTap: () {
                        // TODO: navigate to login
                      },
                      child: const Text('Sign in instead',
                        style: TextStyle(
                          fontSize: 13,
                          color: _purpleLight,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    required String hint,
    TextInputType keyboard = TextInputType.text,
    bool obscure = false,
    Widget? suffix,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
          style: const TextStyle(
            fontSize: 11, fontWeight: FontWeight.w600,
            color: _labelColor, letterSpacing: 0.08,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: keyboard,
          obscureText: obscure,
          style: const TextStyle(fontSize: 14, color: _textPrim),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: _textMuted, fontSize: 14),
            prefixIcon: Icon(icon, color: _textMuted, size: 18),
            suffixIcon: suffix,
            filled: true,
            fillColor: _surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: _border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: _border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: _borderAct),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16, vertical: 14,
            ),
          ),
        ),
      ],
    );
  }
}