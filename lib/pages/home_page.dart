import 'package:chat_app/pages/auth/login_page.dart';
import 'package:chat_app/pages/profile_page.dart';
import 'package:chat_app/pages/search_page.dart';
import 'package:chat_app/widgets/widgets.dart';
import 'package:flutter/material.dart';

import '../helper/helper_function.dart';
import '../service/auth_services.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String userName="";
  String email ="";
  AuthService authService = AuthService();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    gettingUserData();
  }

  gettingUserData() async{
    await HelperFunctions.getUserEmailFromSF().then((value){
      setState(() {
        email=value!;
      });
    });
    await HelperFunctions.getUserNameFromSF().then((val){
      setState(() {
        userName = val!;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: () {nextScreen(context, const SearchPage());}, icon: const Icon(
    Icons.search,
    ))
        ],
        elevation: 0,
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text(
          "Groups",
          style: TextStyle(
            color: Colors.white,fontWeight: FontWeight.bold,fontSize: 27
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 50),
          children: <Widget>[
            Icon(
              Icons.account_box_rounded,
              size: 150,
              color: Colors.grey,
            ),
            const SizedBox(height:15),
            Text(userName,
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height:30),
            const Divider(height:2),
            ListTile(
              onTap: () {},
              selectedColor: Theme.of(context).primaryColor,
              selected: true,
              contentPadding:
              const EdgeInsets.symmetric(horizontal:20, vertical:5),
              leading: const Icon(Icons.group),
              title: const Text(
                "Groups",
                style: TextStyle(color: Colors.black),
              ),
            ),
            ListTile(
              onTap: () {
                nextScreen(context, const ProfilePage());
              },

              contentPadding:
              const EdgeInsets.symmetric(horizontal:20, vertical:5),
              leading: const Icon(Icons.account_circle_sharp),
              title: const Text(
                "Profile",
                style: TextStyle(color: Colors.black),
              ),
            ),
            ListTile(
              onTap: () async{
                showDialog(context: context, builder: (context){
                  return AlertDialog(
                    title: const Text("Log out"),
                    content: const Text("Are you sure you want to logout?"),
                    actions: [
                      IconButton(onPressed: (){
                        Navigator.pop(context);
                      }, icon: const Icon(Icons.cancel, color: Colors.red ),
                      ),
                      IconButton(onPressed: () async{
                        await authService.signOut();
                        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=> const LoginPage()),
                                (route) => false);
                      }, icon: const Icon(Icons.done_sharp, color: Colors.greenAccent ),
                      )
                    ],
                  );
                });

              },

              contentPadding:
              const EdgeInsets.symmetric(horizontal:20, vertical:5),
              leading: const Icon(Icons.exit_to_app_rounded),
              title: const Text(
                "Log out",
                style: TextStyle(color: Colors.black),
              ),
            ),
          ]
        )
      ),
    );
  }
}
