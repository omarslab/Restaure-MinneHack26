import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/models.dart';

class LoginDialog extends StatefulWidget {
  const LoginDialog({super.key, required this.onSubmit});

  final void Function(UserProfile user) onSubmit;

  @override
  State<LoginDialog> createState() => _LoginDialogState();
}

class _LoginDialogState extends State<LoginDialog> {
  bool _isSignUp = false;
  bool _loading = false;

  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }
  //creates profile from Firebase
  UserProfile _profileFromFirebaseUser(User u, {String? fallbackName}) {
    return UserProfile(
      id: u.uid,
      name: u.displayName ?? fallbackName ?? 'User',
      email: u.email ?? '',
      points: 0,
      joinedDate: u.metadata.creationTime ?? DateTime.now(),
    );
  }

  Future<void> _submit() async {
    final email = _email.text.trim();
    final password = _password.text;

    if (email.isEmpty || password.isEmpty) {
      _showError('Enter email and password.');
      return;
    }
    if (_isSignUp && _name.text.trim().isEmpty) {
      _showError('Enter your name.');
      return;
    }

    setState(() => _loading = true);

    try {
      UserCredential cred;
      //call firebase for signup/login
      if (_isSignUp) {
        cred = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        await cred.user?.updateDisplayName(_name.text.trim());
        await cred.user?.reload();
      } else {
        // Checks to see if the login the user entered is correct
        cred = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      }
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        _showError('Login failed. Try again.');
        return;
      }
      // Sends it back to the app
      widget.onSubmit(
        _profileFromFirebaseUser(
          user,
          fallbackName: _isSignUp ? _name.text.trim() : null,
        ),
      );
      // if wrong, throw error
      if (mounted) Navigator.of(context).pop();
    } on FirebaseAuthException 
    catch (e) {
      _showError(e.message ?? 'Auth error.');
    } 
    catch (_) {
      _showError('Something went wrong. Try again.');
    } 
    finally {
      
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Popup dialog UI
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
      padding: const EdgeInsets.all(20),
      child: SingleChildScrollView(
      child: Column(
          mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _isSignUp ? 'Create Account' : 'Log In',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 16),
              // if you don't have an account
              if (_isSignUp) ...[
                TextField(
                  controller: _name,
                  enabled: !_loading,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 12),
              ],
              //log in email
              TextField(
                controller: _email,
                enabled: !_loading,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                labelText: 'Email',
                prefixIcon: const Icon(Icons.mail_outline),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 12),
              //log in password
              TextField(
                controller: _password,
                enabled: !_loading,
                obscureText: true,
                decoration: InputDecoration(
                labelText: 'Password',
                prefixIcon: const Icon(Icons.lock_outline),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 16),
              // submit button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _loading ? null : _submit,
                  style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD97706),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _loading
                      ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(_isSignUp ? 'Sign Up' : 'Log In'),
                ),
              ),

              const SizedBox(height: 12),

              TextButton(
                onPressed: _loading ? null : () => setState(() => _isSignUp = !_isSignUp),
                child: Text(
                _isSignUp ? 'Already have an account? Log in' : 'Don\'t have an account? Sign up',
                style: const TextStyle(color: Color(0xFFD97706)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
