import 'package:bus_tracker_admin/views/bus_screen.dart';
import 'package:bus_tracker_admin/views/drivers_screen.dart';
import 'package:bus_tracker_admin/views/subscriptions_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Widget> screens = [DriversScreen(), BusScreen(), SubscriptionsScreen()];
  int currentScreen = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        onTap: (clickedItem) {
          setState(() {
            currentScreen = clickedItem;
          });
        },
        currentIndex: currentScreen,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Drivers"),
          BottomNavigationBarItem(icon: Icon(Icons.bus_alert), label: "Bus"),
          BottomNavigationBarItem(
              icon: Icon(Icons.card_membership), label: "Subscriptions"),
        ],
      ),
      body: screens[currentScreen],
    );
  }
}
