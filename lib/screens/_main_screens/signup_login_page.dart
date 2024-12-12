import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:user_repository/user_repository.dart';
import 'package:provider/provider.dart';

class SignupLoginPage extends StatefulWidget {
  const SignupLoginPage({super.key});

  @override
  State<SignupLoginPage> createState() => _SignupLoginPageState();
}

class _SignupLoginPageState extends State<SignupLoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isLogin = true;
  bool _isLoading = false;
  String? _errorMessage;
  late final FirebaseUserRepo userRepo;

  @override
  void initState() {
    super.initState();
    userRepo = Provider.of<FirebaseUserRepo>(context, listen: false);
  }

  Future<void> _submit() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        setState(() {
          _isLoading = true;
          _errorMessage = null;
        });

        if (isLogin) {
          await userRepo.signInWithEmailAndPassword(
            email: _emailController.text,
            password: _passwordController.text,
          );
        } else {
          final user = MyUser(
            email: _emailController.text,
            uid: '',
            name: _nameController.text,
            hasActiveCart: false,
          );
          await userRepo.signUp(
              myuser: user, password: _passwordController.text);
        }
        Navigator.pushReplacementNamed(context, '/'); // Adjust route as needed
      } catch (e) {
        setState(() => _errorMessage = userRepo.mapErrorToMessage(e));
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  Future<void> _signInWithGoogle() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
      final userRepo = Provider.of<FirebaseUserRepo>(context, listen: false);
      await userRepo.signInWithGoogle();
      Navigator.pushReplacementNamed(context, '/'); // Adjust route as needed
    } catch (e) {
      setState(() => _errorMessage = userRepo.mapErrorToMessage(e));
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 30),
              Image.asset(
                'assets/images/ShopEase(1).png',
                height: 120,
              ),
              const SizedBox(height: 10),
              Text(
                isLogin ? 'Login' : 'Sign Up',
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Text(
                    _errorMessage!,
                    style:
                        const TextStyle(color: Colors.redAccent, fontSize: 16),
                  ),
                )
              else
                const SizedBox(
                  height: 10,
                ),
              Center(
                child: Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  margin: const EdgeInsets.only(top: 15.0),
                  color:
                      const Color.fromARGB(255, 255, 233, 233).withOpacity(0.9),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              labelText: 'Email',
                              labelStyle:
                                  const TextStyle(color: Colors.black87),
                              filled: true,
                              fillColor: Colors.white,
                              prefixIcon: const Icon(Icons.email),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
                              }
                              if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                  .hasMatch(value)) {
                                return 'Enter a valid email address';
                              }
                              return null;
                            },
                          ),
                          if (!isLogin) ...[
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _nameController,
                              decoration: InputDecoration(
                                labelText: 'Name',
                                labelStyle:
                                    const TextStyle(color: Colors.black87),
                                filled: true,
                                fillColor: Colors.white,
                                prefixIcon: const Icon(Icons.person),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              keyboardType: TextInputType.name,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your name';
                                }
                                return null;
                              },
                            ),
                          ],
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _passwordController,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              labelStyle:
                                  const TextStyle(color: Colors.black87),
                              filled: true,
                              fillColor: Colors.white,
                              prefixIcon: const Icon(Icons.lock),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            obscureText: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
                              }
                              if (value.length < 6) {
                                return 'Password must be at least 6 characters long';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton(
                              onPressed: _submit,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                padding: const EdgeInsets.symmetric(
                                    vertical: 14.0, horizontal: 80.0),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                                elevation: 5,
                              ),
                              child: _isLoading != true
                                  ? Text(
                                      isLogin ? 'Login' : 'Sign Up',
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    )
                                  : const SizedBox(
                                      width: 22.0, // adjust width as needed
                                      height: 22.0, // adjust height as needed
                                      child: CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.white),
                                        color: Colors.white,
                                      ),
                                    )),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                isLogin
                                    ? 'Don’t have an account?'
                                    : 'Already have an account?',
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.black87),
                              ),
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    _errorMessage = null;
                                    _formKey.currentState?.reset();
                                    _emailController.clear();
                                    _passwordController.clear();
                                    if (!isLogin) {
                                      _nameController.clear();
                                    }
                                    isLogin = !isLogin;
                                  });
                                },
                                child: Text(
                                  isLogin ? 'Sign Up' : 'Login',
                                  style: const TextStyle(
                                      fontSize: 16, color: Colors.black54),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                child: Text('or continue with', style: TextStyle(fontSize: 16)),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(width: 10),
                  IconButton(
                    icon: SvgPicture.asset('assets/icon/google.svg'),
            iconSize: 100,
                    onPressed: () async {
                      await _signInWithGoogle();
                    },
                    style: ElevatedButton.styleFrom(
                      alignment: Alignment.center,
                      foregroundColor: Colors.black,
                      surfaceTintColor:
                          const Color.fromARGB(255, 213, 213, 213),
                      backgroundColor: Colors.grey[100],
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 10.0),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      elevation: 5,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
