import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/cart_item_model.dart';
import 'package:shop_app/models/favoriteItem.dart';
import 'package:shop_app/models/users.dart';
import 'package:shop_app/provider/globalProvider.dart';
import 'package:shop_app/repository/repository.dart';
import 'package:shop_app/screens/home_page.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _pwdController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _pwdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Login',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFFBFACE2),
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Welcome back!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF655DBB),
              ),
            ),
            const Text(
              'Login with your credentials!',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF3E54AC),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 300,
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        hintText: 'Enter your email',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email!';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _pwdController,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        hintText: 'Enter your password',
                        border: OutlineInputBorder(),
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        } else if (value.length < 6) {
                          // Minimum password length check
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 40),
                    TextButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          final email = _emailController.text;
                          final password = _pwdController.text;
                          moveToHome(context, email, password);
                        }
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: const Color(0xFF3E54AC),
                        minimumSize: const Size(350, 70),
                      ),
                      child: const Text(
                        'Login',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Don\'t have an account?',
                          style: TextStyle(color: Colors.grey),
                        ),
                        TextButton(
                          onPressed: () {
                            // Navigate to sign up page
                            // Navigator.pushNamed(context, '/signup');
                          },
                          child: const Text(
                            'Sign Up',
                            style: TextStyle(
                              color: Color(0xFF3E54AC),
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 120),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void moveToHome(BuildContext context, String email, String pwd) async {
    try {
      String res =
          await DefaultAssetBundle.of(context).loadString("assets/users.json");
      List<UserModel> data = UserModel.fromList(jsonDecode(res));
      Provider.of<Global_provider>(context, listen: false).setUsers(data);

      String? token = await Provider.of<MyRepository>(context, listen: false)
          .login(email, pwd);
      print(token);
      Provider.of<Global_provider>(context, listen: false)
          .login(email: email, pwd: pwd);
      print(Provider.of<Global_provider>(context, listen: false).user?.id);
      await Provider.of<Global_provider>(context, listen: false)
          .saveToken(token);
      CartResponse cart = await Provider.of<MyRepository>(context,
              listen: false)
          .fetchCartItems(
              Provider.of<Global_provider>(context, listen: false).user!.id!);
      Provider.of<Global_provider>(context, listen: false).setCartItems(cart);

      FavoriteItem favoriteItem =
          await Provider.of<MyRepository>(context, listen: false)
              .getFavoriteItems(int.parse(
                  Provider.of<Global_provider>(context, listen: false)
                      .user!
                      .id
                      .toString()));
      await Provider.of<Global_provider>(context, listen: false)
          .saveFav(favoriteItem);

      print(Provider.of<Global_provider>(context, listen: false).favorite);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } catch (e) {
      print('Login failed: token is null');
      rethrow;
    }
  }
}
