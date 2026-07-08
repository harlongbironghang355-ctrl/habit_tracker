import 'package:flutter/material.dart';

class DetailScreen extends StatelessWidget {

  final String title;
  final String description;
  final Color color;


  const DetailScreen({
    super.key,
    required this.title,
    required this.description,
    required this.color,
  });



  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(

        backgroundColor: color,

        title:
        const Text(
          'Habit Detail',
          style:
          TextStyle(color: Colors.white),
        ),

      ),



      body: Padding(

        padding:
        const EdgeInsets.all(20),


        child: Column(

          crossAxisAlignment:
          CrossAxisAlignment.start,


          children: [


            Container(

              width: double.infinity,

              padding:
              const EdgeInsets.all(20),


              decoration:
              BoxDecoration(

                color: color,

                borderRadius:
                BorderRadius.circular(15),

              ),



              child:
              Text(

                title.toUpperCase(),

                style:
                const TextStyle(

                  color: Colors.white,

                  fontSize: 26,

                  fontWeight:
                  FontWeight.bold,

                ),

              ),

            ),




            const SizedBox(height:30),




            const Text(

              'Description',

              style:
              TextStyle(

                fontSize:20,

                fontWeight:
                FontWeight.bold,

              ),

            ),




            const SizedBox(height:10),




            Text(

              description,

              style:
              const TextStyle(

                fontSize:18,

              ),

            ),




            const Spacer(),




            SizedBox(

              width:
              double.infinity,


              child:
              ElevatedButton(


                onPressed:
                (){

                  Navigator.pop(context);

                },



                child:
                const Text(
                    'Back to List'
                ),

              ),

            )



          ],

        ),

      ),

    );

  }

}