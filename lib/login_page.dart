import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Added Import
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _phoneController = TextEditingController();
  bool _agreed = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  bool _isSigningInWithGoogle = false; // To prevent multiple clicks

  void _handleContinue() {
    print("Continue with phone: ${_phoneController.text}");
  }

  // currently working
  Future<void> _handleGoogleSignIn() async {
    if (_isSigningInWithGoogle) return; // Prevent multiple sign-in attempts

    // Basic check for terms agreement (optional for Google Sign In, but consistent)
    if (!_agreed) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please agree to the Terms & Conditions and Privacy Policy before signing in.',
          ),
        ),
      );
      return;
    }

    setState(() {
      _isSigningInWithGoogle = true;
    });

    try {
      // Trigger the Google Authentication flow.
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      // If the user canceled the sign-in
      if (googleUser == null) {
        print('Google Sign In cancelled by user.');
        // No error, just user cancellation. Stay on the login page.
      } else {
        // Obtain the auth details from the request.
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        // Create a new credential for Firebase
        final OAuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        // Sign in to Firebase with the Google credential.
        final UserCredential userCredential = await _auth.signInWithCredential(
          credential,
        );
        final User? user = userCredential.user;

        if (user != null) {
          print('Successfully signed in with Google: ${user.displayName}');
          // IMPORTANT: Navigation should be handled by AuthWrapper listening to authStateChanges
          // No explicit Navigator.pushReplacement here.
        } else {
          print('Google Sign in succeeded but failed to get Firebase user.');
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Failed to retrieve user data after Google Sign In.',
                ),
              ),
            );
          }
        }
      }
    } on FirebaseAuthException catch (e) {
      print(
        'FirebaseAuthException during Google Sign In: ${e.code} - ${e.message}',
      );
      String errorMessage =
          'An error occurred during Google Sign In. Please try again.';
      if (e.code == 'account-exists-with-different-credential') {
        errorMessage =
            'An account already exists with the same email address but different sign-in credentials. Try signing in using a provider associated with this email address.';
      } else if (e.code == 'network-request-failed') {
        errorMessage =
            'Network error during Google Sign In. Please check your connection.';
      }
      // Add more specific error handling if needed

      if (mounted) {
        // Check if the widget is still in the tree
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(errorMessage)));
      }
    } catch (e) {
      print('An unexpected error occurred during Google Sign In: $e');
      if (mounted) {
        // Check if the widget is still in the tree
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('An unexpected error occurred. Please try again.'),
          ),
        );
      }
    } finally {
      // Ensure the widget is still mounted before calling setState
      if (mounted) {
        setState(() {
          _isSigningInWithGoogle = false; // Allow clicking again
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Skip Button
              Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: () {},
                  child: const Text(
                    "Skip",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Main Content
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Welcome!",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "Login or Sign up to continue",
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),

                        const SizedBox(height: 32),

                        // Phone Input
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                border: Border.all(color: Colors.grey.shade300),
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(8),
                                  bottomLeft: Radius.circular(8),
                                ),
                              ),
                              child: const Text(
                                "+91",
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                            Expanded(
                              child: TextField(
                                controller: _phoneController,
                                keyboardType: TextInputType.phone,
                                decoration: InputDecoration(
                                  hintText: "Enter your mobile number",
                                  filled: true,
                                  fillColor: Colors.grey[100],
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: const BorderRadius.only(
                                      topRight: Radius.circular(8),
                                      bottomRight: Radius.circular(8),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue.shade600,
                            minimumSize: const Size.fromHeight(50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: _handleContinue,
                          child: const Text("Continue"),
                        ),

                        const SizedBox(height: 24),

                        // Divider
                        Row(
                          children: const [
                            Expanded(child: Divider()),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12),
                              child: Text(
                                "or",
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                            Expanded(child: Divider()),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // Google Sign-In Button
                        OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: Colors.grey.shade300),
                            minimumSize: const Size.fromHeight(50),
                          ),
                          icon: SvgPicture.network(
                            'https://simpleicons.org/icons/google.svg',
                            width: 24,
                            height: 24,
                            semanticsLabel: 'Google Icon',
                          ),
                          label: const Text("Use Google Account"),
                          onPressed: _handleGoogleSignIn,
                        ),

                        const SizedBox(height: 24),

                        // Terms and Conditions
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Checkbox(
                              value: _agreed,
                              onChanged:
                                  (val) =>
                                      setState(() => _agreed = val ?? false),
                              visualDensity: VisualDensity.compact,
                            ),
                            Expanded(
                              child: RichText(
                                text: TextSpan(
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey,
                                  ),
                                  children: [
                                    const TextSpan(
                                      text: "By continuing you agree to our ",
                                    ),
                                    TextSpan(
                                      text: "Terms & Conditions",
                                      style: const TextStyle(
                                        color: Colors.blue,
                                      ),
                                    ),
                                    const TextSpan(text: " and "),
                                    TextSpan(
                                      text: "Privacy Policy",
                                      style: const TextStyle(
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
