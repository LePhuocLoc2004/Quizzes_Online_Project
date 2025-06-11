import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  String username;

  ProfilePage({super.key, required this.username});

  @override
  State<StatefulWidget> createState() {
    return ProfilePageState();
  }
}

class ProfilePageState extends State<ProfilePage> {
  var username = TextEditingController(text: "");
  var password = TextEditingController(text: "");
  var fullName = TextEditingController(text: "");

  @override
  void initState() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Profile ",
          style: TextStyle(
              color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            TextFormField(
              controller: username,
              decoration: const InputDecoration(
                hintText: "Username",
                icon: Icon(Icons.account_box),
              ),
              keyboardType: TextInputType.text,
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 10),
            ),
            TextFormField(
              controller: password,
              decoration: const InputDecoration(
                hintText: "Password",
                icon: Icon(Icons.password),
              ),
              keyboardType: TextInputType.text,
              obscureText: true,
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 10),
            ),
            TextFormField(
              controller: fullName,
              decoration: const InputDecoration(
                hintText: "Password",
                icon: Icon(Icons.near_me),
              ),
              keyboardType: TextInputType.text,
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 10),
            ),
            Row(
              children: [
                Expanded(
                    child: ElevatedButton(
                  onPressed: () => Update(),
                  child: const Text("Update"),
                ))
              ],
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 10),
            ),
          ],
        ),
      ),
    );
  }

  void Update() {}
}
