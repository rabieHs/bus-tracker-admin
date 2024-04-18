import 'package:bus_tracker_admin/views/add_driver_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DriversScreen extends StatefulWidget {
  const DriversScreen({super.key});

  @override
  State<DriversScreen> createState() => _DriversScreenState();
}

class _DriversScreenState extends State<DriversScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => AddDriverScreen()));
        },
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        title: Text(
          "Drivers",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
      ),

      //foction==> run==> rsult ==>interface exp : text : ListView : loading
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("users")
              .where("type", isEqualTo: "driver")
              .snapshots(),
          builder: (context, result) {
            if (result.hasError) {
              return Center(
                child: Text("Error getting Drivers"),
              );
            }
            if (result.data == null || !result.hasData) {
              // loading
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              // List<Map> list = [];
              // for(int i =0; i<result.data!.docs.length; i++  ){
              //    list.add(result.data!.docs[i].data());
              //  }
              //collection   documents
              //
              //      data each document
              final List<Map<String, dynamic>> driversList =
                  result.data!.docs.map((document) {
                return document.data();
              }).toList();
              return ListView.builder(
                  itemCount: driversList.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: Icon(Icons.person),
                      title: Text(driversList[index]["name"]),
                      subtitle: Text(driversList[index]["email"]),
                    );
                  });
            }
          }),
    );
  }
}
