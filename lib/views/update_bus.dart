// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import 'package:bus_tracker_admin/core/const.dart';

class UpdateBusScreen extends StatefulWidget {
  final Map<String, dynamic> bus;
  UpdateBusScreen({
    Key? key,
    required this.bus,
  }) : super(key: key);

  @override
  State<UpdateBusScreen> createState() => _AddBusScreenState();
}

class _AddBusScreenState extends State<UpdateBusScreen> {
  getBus() async {
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

  getDriver() async {
    final result = await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.bus["driverId"])
        .get();

    setState(() {
      currentDriver = result.data()!;
      print(currentDriver);
    });
  }

  Map? currentDriver = {};
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
    idController.text = widget.bus["busId"];
    numberOfSeatsController.text = widget.bus["numberOfSeats"].toString();
    numberOfStates.text = widget.bus["busRoute"].length.toString();
    busDriver = widget.bus["driverId"];
    numberOfFields = widget.bus["busRoute"].length;
    states = List.generate(numberOfFields, (index) {
      final route = widget.bus["busRoute"][index];
      return TextEditingController(text: route["city"]);
    });
    setState(() {});
    getBus();
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
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
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
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
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
                        value: widget.bus["driverId"],
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
                        final newNumberOfFields = int.parse(number);
                        // Efficiently update states:
                        states =
                            _updateStates(numberOfFields, newNumberOfFields);
                        numberOfFields = newNumberOfFields;
                        setState(() {});
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
                              return DropdownButtonFormField<String>(
                                  value: widget.bus != null
                                      ? states.length >
                                              widget.bus["busRoute"].length
                                          ? null
                                          : widget.bus["busRoute"][index]
                                              ["city"]
                                      : null, //,
                                  items: List.generate(
                                      tunisiaStatesMap.length,
                                      (index) => DropdownMenuItem<String>(
                                          value: tunisiaStatesMap[index]
                                              ["value"]!,
                                          child: Text(tunisiaStatesMap[index]
                                              ["state"]!))),
                                  onChanged: (value) {
                                    states[index].text = value!;
                                  });
                            })
                        : SizedBox(),
                    const SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          MaterialButton(
            color: Colors.black,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            onPressed: () async {
              await FirebaseFirestore.instance
                  .collection("bus")
                  .doc(idController.text)
                  .update({
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
                  content: Text("Bus updated Successfully"),
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
                "Update",
                style: TextStyle(color: Colors.white),
              )),
            ),
          )
        ],
      )),
    );
  }

  List<TextEditingController> _updateStates(int oldCount, int newCount) {
    final List<TextEditingController> updatedStates = [];
    if (newCount > oldCount) {
      // Add new controllers for additional fields
      updatedStates.addAll(states);
      updatedStates.addAll(
          List.generate(newCount - oldCount, (i) => TextEditingController()));
    } else {
      updatedStates.addAll(states.sublist(0, newCount));
    }
    return updatedStates;
  }
}
