import 'package:bus_tracker_admin/views/add_bus_screen.dart';
import 'package:bus_tracker_admin/views/update_bus.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BusScreen extends StatefulWidget {
  const BusScreen({super.key});

  @override
  State<BusScreen> createState() => _BusScreenState();
}

class _BusScreenState extends State<BusScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => AddBusScreen()));
        },
        child: Icon(Icons.add),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("bus").snapshots(),
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
              final List<Map<String, dynamic>> driversList =
                  result.data!.docs.map((document) {
                return document.data();
              }).toList();

              return ListView.builder(
                  itemCount: driversList.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                UpdateBusScreen(bus: driversList[index])));
                      },
                      leading: Icon(Icons.person),
                      title: Text(driversList[index]["busId"]),
                      subtitle: Text(driversList[index]["numberOfSeats"]),
                    );
                  });
            }
          }),
    );
  }
}
