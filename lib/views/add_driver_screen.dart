import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddDriverScreen extends StatelessWidget {
  AddDriverScreen({super.key});
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          "Add Driver",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Center(
          child: Container(
        height: MediaQuery.of(context).size.height * 0.7,
        width: MediaQuery.of(context).size.width * 0.4,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(width: 3)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Create New Driver Account",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 50,
              ),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(), labelText: "driver name"),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(), labelText: "driver email"),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                obscureText: true,
                controller: passwordController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(), labelText: "driver password"),
              ),
              SizedBox(
                height: 30,
              ),
              MaterialButton(
                color: Colors.black,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                onPressed: () async {
                  final email = emailController.text;
                  final name = nameController.text;
                  final password = passwordController.text;

                  await FirebaseAuth.instance
                      .createUserWithEmailAndPassword(
                          email: email, password: password)
                      .then((resut) async {
                    final userId = resut.user!.uid;

                    if (userId != null) {
                      await FirebaseFirestore.instance
                          .collection("users")
                          .doc(userId)
                          .set({
                        "name": name,
                        "email": email,
                        "id": userId,
                        "type": "driver",
                      }).whenComplete(() {
                        //message
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("Driver Created Successfully"),
                          backgroundColor: Colors.green,
                        ));
                        Navigator.pop(context);
                      });
                    }
                  });
                },
                child: Container(
                  height: 60,
                  width: 150,
                  child: Center(
                      child: Text(
                    "Create",
                    style: TextStyle(color: Colors.white),
                  )),
                ),
              )
            ],
          ),
        ),
      )),
    );
  }
}
