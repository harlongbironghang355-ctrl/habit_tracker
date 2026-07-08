import 'package:flutter/material.dart';

import '../../../core/constants/habit_color.dart';


class AddHabitScreen extends StatefulWidget {

  final Map<String, Color> selectedHabits;


  const AddHabitScreen({

    super.key,

    required this.selectedHabits,

  });



  @override
  State<AddHabitScreen> createState() =>
      _AddHabitScreenState();

}



class _AddHabitScreenState
    extends State<AddHabitScreen> {


  final TextEditingController _habitController =
      TextEditingController();



  final Map<String, Color> _habitColors =
      HabitColors.colors;



  String selectedColorName = "Amber";


  Color selectedColor =
      Colors.amber;





  void saveHabit() {


    final habit =
        _habitController.text.trim();



    if(habit.isEmpty){

      return;

    }



    if(widget.selectedHabits.containsKey(habit)){


      ScaffoldMessenger.of(context).showSnackBar(

        const SnackBar(

          content:
          Text(
            "Habit already exists",
          ),

        ),

      );


      return;

    }





    widget.selectedHabits[habit] =
        selectedColor;



    Navigator.pop(

      context,

      {

        "habit": habit,

        "color": selectedColor,

      },

    );


  }







  @override
  Widget build(BuildContext context) {


    return Scaffold(



      appBar: AppBar(

        backgroundColor:
        Colors.blue.shade700,


        title: const Text(

          "Add Habit",

          style:
          TextStyle(

            color: Colors.white,

          ),

        ),

      ),





      body: Padding(

        padding:
        const EdgeInsets.all(16),



        child: Column(


          children: [




            TextField(

              controller:
              _habitController,


              decoration:
              const InputDecoration(

                labelText:
                "Habit Name",

                border:
                OutlineInputBorder(),

              ),

            ),




            const SizedBox(height:20),





            DropdownButtonFormField<String>(


              value:
              selectedColorName,



              decoration:
              const InputDecoration(

                labelText:
                "Habit Color",

                border:
                OutlineInputBorder(),

              ),




              items:
              _habitColors.keys.map((name){



                return DropdownMenuItem<String>(


                  value:name,



                  child:Row(

                    children:[


                      CircleAvatar(

                        radius:10,

                        backgroundColor:
                        _habitColors[name],

                      ),



                      const SizedBox(
                        width:10,
                      ),



                      Text(name),


                    ],

                  ),


                );



              }).toList(),





              onChanged:(value){


                if(value == null)
                  return;


                setState((){


                  selectedColorName =
                      value;



                  selectedColor =
                      _habitColors[value]!;



                });


              },


            ),





            const SizedBox(height:20),





            SizedBox(

              width:
              double.infinity,



              child:
              ElevatedButton(


                onPressed:
                saveHabit,



                style:
                ElevatedButton.styleFrom(

                  backgroundColor:
                  Colors.blue.shade700,

                ),



                child:
                const Text(

                  "Save Habit",

                  style:
                  TextStyle(

                    color:
                    Colors.white,

                  ),

                ),


              ),

            ),





            const SizedBox(height:20),





            const Align(

              alignment:
              Alignment.centerLeft,


              child:
              Text(

                "Added Habits",

                style:
                TextStyle(

                  fontSize:18,

                  fontWeight:
                  FontWeight.bold,

                ),

              ),

            ),





            const SizedBox(height:10),





            Expanded(


              child:

              widget.selectedHabits.isEmpty


              ?

              const Center(

                child:
                Text(
                  "No habits added",
                ),

              )



              :

              ListView.builder(


                itemCount:
                widget.selectedHabits.length,



                itemBuilder:(context,index){



                  final habit =
                  widget.selectedHabits.keys.elementAt(index);



                  final color =
                  widget.selectedHabits[habit]!;





                  return Card(


                    margin:
                    const EdgeInsets.symmetric(

                      vertical:6,

                    ),



                    child:
                    ListTile(


                      leading:
                      CircleAvatar(

                        radius:10,

                        backgroundColor:
                        color,

                      ),




                      title:
                      Text(

                        habit,

                        style:
                        TextStyle(

                          color:
                          color,

                          fontWeight:
                          FontWeight.bold,

                        ),

                      ),




                      trailing:
                      IconButton(


                        icon:
                        const Icon(

                          Icons.delete,

                          color:
                          Colors.red,

                        ),



                        onPressed:(){



                          setState((){


                            widget.selectedHabits
                                .remove(habit);



                          });



                        },

                      ),



                    ),



                  );



                },

              ),


            ),


          ],


        ),

      ),


    );


  }





  @override
  void dispose(){


    _habitController.dispose();


    super.dispose();

  }


}