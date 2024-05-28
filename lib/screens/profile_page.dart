import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/users.dart';
import 'package:shop_app/provider/globalProvider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Future<List<UserModel>> _usersFuture;

  @override
  void initState() {
    super.initState();
    _usersFuture = _getUsers();
  }

  Future<List<UserModel>> _getUsers() async {
    try {
      String res =
          await DefaultAssetBundle.of(context).loadString("assets/users.json");
      List<UserModel> data = UserModel.fromList(jsonDecode(res));

      Provider.of<Global_provider>(context, listen: false).setUsers(data);
      return data;
    } catch (e) {
      print('Error loading users: $e');
      rethrow;
    }
  }

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _pwdController = TextEditingController();

  var emailValue = "";
  var pwdValue = "";

  @override
  void dispose() {
    _emailController.dispose();
    _pwdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<UserModel>>(
      future: _usersFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('An error occurred: ${snapshot.error}'),
          );
        } else if (snapshot.hasData) {
          return Consumer<Global_provider>(
            builder: (context, provider, child) {
              return Scaffold(
                appBar: AppBar(
                  title: const Text('My profile'),
                ),
                body: SafeArea(
                    child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 80,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(children: [
                            Image.asset('assets/images/login1.png', width: 100),
                          ]),
                          Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    provider.user?.name?.firstname ?? "No name",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 30,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    provider.user?.name?.lastname ?? "",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 30,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(provider.user?.email ?? "no email"),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      const MenuItem(text: "My orders"),
                      const MenuItem(text: "Shipping addresses"),
                      const MenuItem(text: "Payment methods"),
                      const MenuItem(text: "Promotion code"),
                      const MenuItem(text: "My reviews"),
                      const MenuItem(text: "Settings"),
                    ],
                  ),
                )),
              );
            },
          );
        } else {
          return const Center(
            child: Text('No data available'),
          );
        }
      },
    );
  }
}

class MenuItem extends StatefulWidget {
  final String text;
  const MenuItem({Key? key, required this.text}) : super(key: key);

  @override
  State<MenuItem> createState() => _MenuItemState();
}

class _MenuItemState extends State<MenuItem> {
  bool isExpanded = false;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.only(left: 60),
          width: 600,
          child: Text(
            widget.text,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        IconButton(
          icon: isExpanded
              ? const Icon(Icons.expand_less_outlined)
              : const Icon(Icons.expand_more_outlined),
          onPressed: () {
            setState(() {
              isExpanded = !isExpanded;
            });
          },
        ),
      ],
    );
  }
}
