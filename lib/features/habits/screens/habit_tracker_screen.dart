import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'add_habit_screen.dart';
import '../../settings/widgets/menu_drawer.dart';
import '../../../core/constants/habit_color.dart';

class HabitTrackerScreen extends StatefulWidget {
  final String username;
  final List<String> selectedHabits;

  const HabitTrackerScreen({
    super.key,
    required this.username,
    required this.selectedHabits,
  });

  @override
  State<HabitTrackerScreen> createState() =>
      _HabitTrackerScreenState();
}

class _HabitTrackerScreenState
    extends State<HabitTrackerScreen> {

  Map<String, Color> selectedHabitsMap = {};
  Map<String, Color> completedHabitsMap = {};

  String name = '';

  Future<void> saveWeeklyProgress(
    String habit,
    bool completed,
  ) async {

    final prefs =
        await SharedPreferences.getInstance();


    String? savedData =
        prefs.getString("weeklyProgress");


    Map<String, dynamic> weeklyData = {};


    if(savedData != null){

      weeklyData =
          jsonDecode(savedData);

    }



    if(!weeklyData.containsKey(habit)){

      weeklyData[habit] = {

        "Mon":0,
        "Tue":0,
        "Wed":0,
        "Thu":0,
        "Fri":0,
        "Sat":0,
        "Sun":0,

      };

    }



    String today = getToday();



    weeklyData[habit][today] =
        completed ? 1 : 0;



    await prefs.setString(
      "weeklyProgress",
      jsonEncode(weeklyData),
    );

  }



  String getToday(){

    switch(DateTime.now().weekday){

      case 1:
        return "Mon";

      case 2:
        return "Tue";

      case 3:
        return "Wed";

      case 4:
        return "Thu";

      case 5:
        return "Fri";

      case 6:
        return "Sat";

      default:
        return "Sun";

    }

  }

  final List<Color> habitColorList =
      HabitColors.colors.values.toList();

  @override
  void initState() {
    super.initState();

    name = widget.username;

    for (int i = 0; i < widget.selectedHabits.length; i++) {
      selectedHabitsMap[widget.selectedHabits[i]] =
          habitColorList[i % habitColorList.length];
    }
  }

  void moveToDone(String habit) {

    setState(() {

      completedHabitsMap[habit] =
          selectedHabitsMap[habit]!;


      selectedHabitsMap.remove(habit);

    });


    saveWeeklyProgress(
      habit,
      true,
    );

  }

  void moveToTodo(String habit) {

    setState(() {

      selectedHabitsMap[habit] =
          completedHabitsMap[habit]!;


      completedHabitsMap.remove(habit);

    });


    saveWeeklyProgress(
      habit,
      false,
    );

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MenuDrawer(),

      appBar: AppBar(
        backgroundColor: Colors.blue.shade700,
        title: Text(
          name,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: Column(
        children: [

          const Text(
            "To Do 📝",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          Expanded(
            child: ListView.builder(
              itemCount: selectedHabitsMap.length,
              itemBuilder: (context, index) {
                String habit =
                    selectedHabitsMap.keys.elementAt(index);

                return Dismissible(
                  key: Key(habit),
                  direction: DismissDirection.horizontal,

                  background: Container(
                    color: Colors.green,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20),
                    alignment: Alignment.centerLeft,
                    child: const Row(
                      children: [
                        Icon(Icons.check_circle,
                            color: Colors.white),
                        SizedBox(width: 10),
                        Text(
                          "DONE",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),

                  secondaryBackground: Container(
                    color: Colors.red,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20),
                    alignment: Alignment.centerRight,
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "DELETE",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(width: 10),
                        Icon(Icons.delete,
                            color: Colors.white),
                      ],
                    ),
                  ),

                  onDismissed: (direction) {
                    if (direction ==
                        DismissDirection.startToEnd) {
                      moveToDone(habit);
                    } else {
                      setState(() {
                        selectedHabitsMap.remove(habit);
                      });
                    }
                  },

                  child: Card(
                    color: selectedHabitsMap[habit],
                    child: ListTile(
                      title: Text(
                        habit.toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          const Divider(),

          const Text(
            "Done ✅🎉",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          Expanded(
            child: ListView.builder(
              itemCount: completedHabitsMap.length,
              itemBuilder: (context, index) {
                String habit =
                    completedHabitsMap.keys.elementAt(index);

                return Dismissible(
                  key: Key(habit),
                  direction: DismissDirection.horizontal,

                  background: Container(
                    color: Colors.orange,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20),
                    alignment: Alignment.centerLeft,
                    child: const Row(
                      children: [
                        Icon(Icons.undo,
                            color: Colors.white),
                        SizedBox(width: 10),
                        Text(
                          "UNDO",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),

                  secondaryBackground: Container(
                    color: Colors.red,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20),
                    alignment: Alignment.centerRight,
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "DELETE",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(width: 10),
                        Icon(Icons.delete,
                            color: Colors.white),
                      ],
                    ),
                  ),

                  onDismissed: (direction) {
                    if (direction ==
                        DismissDirection.startToEnd) {
                      moveToTodo(habit);
                    } else {
                      setState(() {
                        completedHabitsMap.remove(habit);
                      });
                    }
                  },

                  child: Card(
                    color: completedHabitsMap[habit],
                    child: ListTile(
                      title: Text(
                        habit.toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      trailing: const Icon(
                        Icons.check_circle,
                        color: Colors.green,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue.shade700,
        child: const Icon(Icons.add),

        onPressed: () async {
          final Map<String, dynamic>? newHabit =
              await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddHabitScreen(
                  selectedHabits: selectedHabitsMap,
              ),
            ),
          );

          if (newHabit != null) {
            setState(() {
              selectedHabitsMap[
                  newHabit['habit'] as String] =
                  newHabit['color'] as Color;
            });
          }
        },
      ),
    );
  }
}