import 'package:assignmenttask/features/PendingTasks/presentation/screens/pending_tasks.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  int _selectedIndex = 0;
  static const List<Widget> _screenLists = [PendingTasks(), Text("Hi")];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amberAccent,
        title: const Text("Task App"),
      ),
      bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.pending_actions,
                  color: Colors.red,
                ),
                label: "Pending Tasks"),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.check_circle,
                  color: Colors.green,
                ),
                label: "Completed Tasks"),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.black,
          unselectedLabelStyle: const TextStyle(color: Colors.black),
          selectedLabelStyle: const TextStyle(color: Colors.black),
          onTap: _setSelectedIndex),
      body: Container(
        child: _screenLists[_selectedIndex],
      ),
    );
  }

  //evennt handler for handling bottom nav bar tab switches
  void _setSelectedIndex(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
