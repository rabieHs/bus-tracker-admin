import 'package:bus_tracker_admin/core/const.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class AddBusScreen extends StatefulWidget {
  AddBusScreen({super.key});

  @override
  State<AddBusScreen> createState() => _AddBusScreenState();
}

class _AddBusScreenState extends State<AddBusScreen> {
  getDriver() async {
    final result = await FirebaseFirestore.instance
        .collection("users")
        .where("type", isEqualTo: "driver")
        .get();
    final List<Map> drivers = result.docs.map((doc) {
      return doc.data();
    }).toList();
    setState(() {
      driversList = drivers;
    });
  }

  List<Map> driversList = [];
  final idController = TextEditingController();

  final numberOfSeatsController = TextEditingController();

  final numberOfStates = TextEditingController();

  int numberOfFields = 0;
  List<TextEditingController> states = [];
  String busDriver = "";
  @override
  void initState() {
    getDriver();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          "Add New Bus",
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
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "Create New Bus Form",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 50,
                ),
                TextField(
                  controller: idController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), labelText: "bus ID"),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  keyboardType: TextInputType.number,
                  controller: numberOfSeatsController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "number of seats"),
                ),
                const SizedBox(
                  height: 30,
                ),
                DropdownButtonFormField<String>(
                    items: List.generate(
                        driversList.length,
                        (index) => DropdownMenuItem(
                              child: Text(driversList[index]["name"]),
                              value: driversList[index]["id"],
                            )),
                    onChanged: (value) {
                      busDriver = value!;
                    }),
                const SizedBox(
                  height: 30,
                ),
                TextField(
                  onSubmitted: (number) {
                    print(number);
                    setState(() {
                      numberOfFields = int.parse(number);
                      states = List.generate(int.parse(number),
                          (index) => TextEditingController());
                    });
                  },
                  controller: numberOfStates,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "number of states"),
                ),
                const SizedBox(
                  height: 30,
                ),
                numberOfFields != 0
                    ? ListView.builder(
                        shrinkWrap: true,
                        itemCount: numberOfFields,
                        itemBuilder: (context, index) {
                          return DropdownButtonFormField(
                              items: List.generate(
                                  tunisiaStatesMap.length,
                                  (index) => DropdownMenuItem<String>(
                                      value: tunisiaStatesMap[index]["value"]!,
                                      child: Text(
                                          tunisiaStatesMap[index]["state"]!))),
                              onChanged: (value) {
                                states[index].text = value!;
                              });
                        })
                    : SizedBox(),
                const SizedBox(
                  height: 30,
                ),
                MaterialButton(
                  color: Colors.black,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  onPressed: () async {
                    await FirebaseFirestore.instance
                        .collection("bus")
                        .doc(idController.text)
                        .set({
                      "driverName": "",
                      "driverId": busDriver,
                      "busId": idController.text,
                      "numberOfSeats": numberOfSeatsController.text,
                      "currentCity": "",
                      "availableSeats": int.parse(numberOfSeatsController.text),
                      "busRoute": List.generate(
                          numberOfFields,
                          (index) => {
                                "city": states[index].text,
                                "time": "12-04-2024 19:22"
                              }).toList(),
                    }).whenComplete(() {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Bus Created Successfully"),
                        backgroundColor: Colors.green,
                      ));
                      Navigator.pop(context);
                    });
                  },
                  child: Container(
                    height: 60,
                    width: 150,
                    child: const Center(
                        child: Text(
                      "Create",
                      style: TextStyle(color: Colors.white),
                    )),
                  ),
                )
              ],
            ),
          ),
        ),
      )),
    );
  }
}
