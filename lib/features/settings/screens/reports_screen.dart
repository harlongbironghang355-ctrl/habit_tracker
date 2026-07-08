import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ReportsScreen extends StatefulWidget {

  const ReportsScreen({
    super.key,
  });


  @override
  State<ReportsScreen> createState() =>
      _ReportsScreenState();

}




class _ReportsScreenState
    extends State<ReportsScreen> {


  Map<String, List<int>> weeklyData = {};



  final List<String> daysOfWeek = [

    "Mon",
    "Tue",
    "Wed",
    "Thu",
    "Fri",
    "Sat",
    "Sun",

  ];




  @override
  void initState() {

    super.initState();

    loadReport();

  }






  Future<void> loadReport() async {


    final prefs =
        await SharedPreferences.getInstance();



    String? data =
        prefs.getString(
          "weeklyProgress",
        );



    print("REPORT DATA: $data");



    if(data == null || data.isEmpty){


      setState(() {

        weeklyData = {};

      });


      return;

    }






    Map<String,dynamic> decoded =
        jsonDecode(data);




    Map<String,List<int>> result = {};




    decoded.forEach((habit,value){



      if(value is Map){



        result[habit] =

            daysOfWeek.map<int>((day){


              return int.tryParse(

                value[day]
                    .toString(),

              ) ?? 0;


            }).toList();



      }



    });






    setState(() {

      weeklyData = result;

    });



  }









  int calculateOverallProgress(){


    int total = 0;

    int completed = 0;



    for(var habit in weeklyData.values){


      total += habit.length;


      completed += habit
          .where((e)=>e == 1)
          .length;


    }




    if(total == 0){

      return 0;

    }



    return ((completed / total) * 100)
        .round();



  }







  int totalCompleted(){


    int count = 0;



    for(var habit in weeklyData.values){


      count += habit
          .where((e)=>e == 1)
          .length;


    }



    return count;


  }









  @override
  Widget build(BuildContext context){


    return Scaffold(



      appBar: AppBar(

        backgroundColor:
        Colors.blue.shade700,


        title: const Text(

          "Weekly Report",

          style: TextStyle(

            color: Colors.white,

            fontWeight: FontWeight.bold,

          ),

        ),

      ),





      body:


      weeklyData.isEmpty


          ?


      const Center(

        child: Text(

          "No data available",

          style: TextStyle(

            color: Colors.grey,

            fontSize: 16,

          ),

        ),

      )



          :


      SingleChildScrollView(


        child: Column(


          children: [



            Padding(

              padding:
              const EdgeInsets.all(16),


              child: Row(

                children: [



                  Expanded(

                    child: Card(

                      elevation: 3,

                      child: Padding(

                        padding:
                        const EdgeInsets.all(16),


                        child: Column(

                          children: [


                            const Icon(

                              Icons.bar_chart,

                              size:35,

                            ),



                            const SizedBox(
                              height:10,
                            ),



                            Text(

                              "${calculateOverallProgress()}%",

                              style:
                              const TextStyle(

                                fontSize:28,

                                fontWeight:
                                FontWeight.bold,

                              ),

                            ),



                            const Text(
                              "Weekly Score",
                            ),


                          ],

                        ),

                      ),

                    ),

                  ),




                  const SizedBox(
                    width:10,
                  ),




                  Expanded(

                    child: Card(

                      elevation:3,

                      child: Padding(

                        padding:
                        const EdgeInsets.all(16),


                        child: Column(

                          children: [


                            const Icon(

                              Icons.check_circle,

                              size:35,

                            ),



                            const SizedBox(
                              height:10,
                            ),



                            Text(

                              "${totalCompleted()}",

                              style:
                              const TextStyle(

                                fontSize:28,

                                fontWeight:
                                FontWeight.bold,

                              ),

                            ),



                            const Text(
                              "Completed",
                            ),


                          ],

                        ),

                      ),

                    ),

                  ),


                ],

              ),

            ),






            SingleChildScrollView(

              scrollDirection:
              Axis.horizontal,


              child: DataTable(

                columns:
                buildColumns(),



                rows:
                buildRows(),


              ),

            ),



          ],

        ),

      ),



    );


  }









  List<DataColumn> buildColumns(){


    return [



      const DataColumn(

        label: Text(

          "Habit",

          style: TextStyle(

            fontWeight:
            FontWeight.bold,

          ),

        ),

      ),





      ...daysOfWeek.map(

            (day)=>DataColumn(

          label: Text(

            day,

            style:
            const TextStyle(

              fontWeight:
              FontWeight.bold,

            ),

          ),

        ),

      ),





      const DataColumn(

        label: Text(

          "Progress",

          style:
          TextStyle(

            fontWeight:
            FontWeight.bold,

          ),

        ),

      ),



    ];

  }









  List<DataRow> buildRows(){


    return weeklyData.keys.map((habit){



      List<int> data =
          weeklyData[habit]!;




      int completed =

      data.where(
              (e)=>e == 1
      ).length;




      int percentage =

      ((completed / 7) * 100)
          .round();





      return DataRow(

        cells: [



          DataCell(

            Text(

              habit.toUpperCase(),

              style:
              const TextStyle(

                fontWeight:
                FontWeight.bold,

              ),

            ),

          ),





          ...List.generate(7,(index){



            bool done =
                data[index] == 1;



            return DataCell(

              Icon(

                done

                    ?
                Icons.check_circle

                    :
                Icons.cancel,


                color:

                done

                    ?
                Colors.green

                    :
                Colors.red,


              ),

            );


          }),





          DataCell(

            Text(

              "$percentage%",

              style:
              const TextStyle(

                fontWeight:
                FontWeight.bold,

              ),

            ),

          ),



        ],

      );



    }).toList();


  }



}