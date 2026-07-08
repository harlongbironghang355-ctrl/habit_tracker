import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login_screen.dart';
import '../../habits/screens/habit_tracker_screen.dart';

import '../../../core/services/country_service.dart';
import '../../../core/constants/habit_lists.dart';


class RegisterScreen extends StatefulWidget {

  const RegisterScreen({super.key});


  @override
  State<RegisterScreen> createState() =>
      _RegisterScreenState();

}



class _RegisterScreenState extends State<RegisterScreen> {


  final TextEditingController _nameController =
      TextEditingController();


  final TextEditingController _usernameController =
      TextEditingController();


  final TextEditingController _emailController =
      TextEditingController();


  final TextEditingController _passwordController =
      TextEditingController();



  double _age = 25;


  List<String> countries = [];


  String? _country;


  bool isLoadingCountries = true;



  List<String> selectedHabits = [];





  @override
  void initState() {

    super.initState();

    loadCountries();

  }





  Future<void> loadCountries() async {


    try {

      final result =
          await CountryService.fetchCountries();


      if(!mounted) return;


      setState(() {

        countries = result;

        isLoadingCountries = false;

      });


    } catch(e){


      if(!mounted) return;


      setState(() {

        isLoadingCountries = false;

      });


    }

  }







  void _showToast(String message){


    Fluttertoast.showToast(

      msg: message,

      backgroundColor: Colors.red,

      textColor: Colors.white,

    );


  }







  bool validateForm(){


    return _nameController.text.trim().isNotEmpty &&

    _usernameController.text.trim().isNotEmpty &&

    _emailController.text.trim().isNotEmpty &&

    _passwordController.text.trim().isNotEmpty;


  }







  Future<void> saveUserData() async {


    final prefs =
        await SharedPreferences.getInstance();



    final username =
        _usernameController.text.trim();



    // Remove previous account data

    await prefs.remove(
      "selectedHabitsMap",
    );


    await prefs.remove(
      "weeklyData",
    );





    await prefs.setString(

      "name",

      _nameController.text.trim(),

    );





    // Save username

    await prefs.setString(

      "username",

      username,

    );




    // Login uses this

    await prefs.setString(

      "savedUsername",

      username,

    );





    await prefs.setString(

      "email",

      _emailController.text.trim(),

    );





    await prefs.setString(

      "password",

      _passwordController.text.trim(),

    );





    await prefs.setDouble(

      "age",

      _age,

    );





    await prefs.setString(

      "country",

      _country ?? "",

    );





    // Save habits

    await prefs.setStringList(

      "selectedHabits",

      selectedHabits,

    );





    // Empty report for new account

    await prefs.setString(

      "weeklyData",

      "{}",

    );



  }








  Future<void> _register() async {


    if(!validateForm()){

      _showToast(
        "Please fill all fields",
      );

      return;

    }





    if(selectedHabits.isEmpty){


      _showToast(
        "Select at least one habit",
      );


      return;

    }






    await saveUserData();






    if(!mounted) return;






    Navigator.pushReplacement(


      context,


      MaterialPageRoute(


        builder:(context)=>


        HabitTrackerScreen(


          username:
              _usernameController.text.trim(),



          selectedHabits:
              selectedHabits,



        ),


      ),


    );



  }









  Widget _buildInput(

    TextEditingController controller,

    String hint,

    IconData icon,{

    bool obscure=false,

  }){


    return Container(


      margin:
          const EdgeInsets.only(bottom:12),



      child: TextField(


        controller:controller,


        obscureText:obscure,



        decoration:InputDecoration(


          prefixIcon:
              Icon(
                icon,
                color:Colors.blue,
              ),



          hintText:hint,



          filled:true,


          fillColor:
              Colors.white,



          border:
              OutlineInputBorder(


            borderRadius:
                BorderRadius.circular(30),


            borderSide:
                BorderSide.none,


          ),


        ),


      ),


    );


  }









  @override
  Widget build(BuildContext context) {


    return Scaffold(


      body:Container(


        width:double.infinity,



        decoration:BoxDecoration(


          gradient:LinearGradient(


            colors:[

              Colors.blue.shade700,

              Colors.blue.shade900,

            ],


            begin:Alignment.topCenter,


            end:Alignment.bottomCenter,


          ),


        ),




        child:SingleChildScrollView(


          padding:
              const EdgeInsets.all(20),




          child:Column(


            children:[



              const SizedBox(
                height:60,
              ),




              const Text(

                "Create Account",

                style:TextStyle(

                  color:Colors.white,

                  fontSize:32,

                  fontWeight:
                      FontWeight.bold,

                ),

              ),




              const SizedBox(
                height:30,
              ),




              _buildInput(
                _nameController,
                "Name",
                Icons.person,
              ),



              _buildInput(
                _usernameController,
                "Username",
                Icons.person_outline,
              ),



              _buildInput(
                _emailController,
                "Email",
                Icons.email,
              ),



              _buildInput(
                _passwordController,
                "Password",
                Icons.lock,
                obscure:true,
              ),






              Text(

                "Age: ${_age.round()}",

                style:
                    const TextStyle(
                      color:Colors.white,
                    ),

              ),






              Slider(

                value:_age,

                min:18,

                max:100,


                activeColor:
                    Colors.white,


                onChanged:(value){

                  setState((){

                    _age=value;

                  });

                },


              ),






              isLoadingCountries

              ? const CircularProgressIndicator(
                  color:Colors.white,
                )

              :

              Container(


                padding:
                    const EdgeInsets.symmetric(
                      horizontal:16,
                    ),


                decoration:BoxDecoration(

                  color:Colors.white,

                  borderRadius:
                      BorderRadius.circular(30),

                ),




                child:DropdownButtonFormField<String>(


                  value:
                      countries.contains(_country)
                      ? _country
                      : null,



                  decoration:
                      const InputDecoration(
                        border:InputBorder.none,
                      ),




                  hint:
                      const Text(
                        "Select Country",
                      ),




                  items:
                      countries.map((country){


                    return DropdownMenuItem(

                      value:country,

                      child:
                          Text(country),

                    );


                  }).toList(),




                  onChanged:(value){

                    setState((){

                      _country=value;

                    });

                  },


                ),


              ),







              const SizedBox(
                height:20,
              ),





              Wrap(


                spacing:8,


                children:

                HabitList.availableHabits.map((habit){



                  final selected =
                      selectedHabits.contains(habit);




                  return ChoiceChip(


                    label:
                        Text(habit),



                    selected:selected,



                    onSelected:(value){


                      setState((){


                        if(value){

                          selectedHabits.add(habit);

                        }

                        else{

                          selectedHabits.remove(habit);

                        }


                      });


                    },


                  );


                }).toList(),



              ),








              const SizedBox(
                height:25,
              ),





              SizedBox(


                width:double.infinity,



                child:ElevatedButton(


                  onPressed:_register,



                  child:
                      const Text(
                        "Register",
                      ),


                ),


              ),





              TextButton(


                onPressed:(){


                  Navigator.pushReplacement(


                    context,


                    MaterialPageRoute(


                      builder:(_)=>
                          const LoginScreen(),


                    ),


                  );


                },



                child:
                    const Text(
                      "Already have account? Login",
                      style:TextStyle(
                        color:Colors.white,
                      ),
                    ),


              ),



            ],


          ),


        ),


      ),


    );


  }







  @override
  void dispose(){

    _nameController.dispose();

    _usernameController.dispose();

    _emailController.dispose();

    _passwordController.dispose();


    super.dispose();

  }


}