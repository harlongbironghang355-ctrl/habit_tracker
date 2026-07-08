import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/services/country_service.dart';

class PersonalInfoScreen extends StatefulWidget {
  const PersonalInfoScreen({super.key});

  @override
  State<PersonalInfoScreen> createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  final TextEditingController _nameController =
      TextEditingController();

  final TextEditingController _usernameController =
      TextEditingController();

  double _age = 25;

  String? _country;

  List<String> countries = [];

  bool isLoadingCountries = true;


  @override
  void initState() {
    super.initState();

    loadUserData();
    loadCountries();
  }


  Future<void> loadCountries() async {

    try {

      final result = await CountryService.fetchCountries();


      if (!mounted) return;


      setState(() {

        countries = result;

        isLoadingCountries = false;


        // If saved country exists keep it
        // otherwise select first country

        if (_country == null && countries.isNotEmpty) {
          _country = countries.first;
        }

      });


      debugPrint(
        "COUNTRIES LOADED: ${countries.length}",
      );


    } catch (e) {


      debugPrint(
        "COUNTRY ERROR: $e",
      );


      if (!mounted) return;


      setState(() {

        isLoadingCountries = false;

      });


      Fluttertoast.showToast(
        msg: "Failed to load countries",
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );

    }

  }



  Future<void> loadUserData() async {

    final prefs =
        await SharedPreferences.getInstance();


    if (!mounted) return;


    setState(() {

      _nameController.text =
          prefs.getString('name') ?? "";


      _usernameController.text =
          prefs.getString('username') ?? "";


      _age =
          prefs.getDouble('age') ?? 25;


      final savedCountry =
          prefs.getString('country');


      if (savedCountry != null &&
          savedCountry.isNotEmpty) {

        _country = savedCountry;

      }

    });

  }



  Future<void> saveUserData() async {
  final prefs = await SharedPreferences.getInstance();

  await prefs.setString(
    "name",
    _nameController.text.trim(),
  );

  await prefs.setString(
    "username",
    _usernameController.text.trim(),
  );

  await prefs.setDouble(
    "age",
    _age,
  );

  await prefs.setString(
    "country",
    _country ?? "",
  );


  Fluttertoast.showToast(
    msg: "Profile updated successfully",
    backgroundColor: Colors.green,
    textColor: Colors.white,
  );


  if (!mounted) return;


  // Send updated username back
  Navigator.pop(
    context,
    _usernameController.text.trim(),
  );
}
  



  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(

        title: const Text(
          "Personal Info",
        ),

        backgroundColor:
            Colors.blue.shade700,

      ),


      body: SingleChildScrollView(

        padding:
            const EdgeInsets.all(20),


        child: Column(

          children: [


            _buildTextField(
              controller: _nameController,
              label: "Name",
              icon: Icons.person,
            ),


            const SizedBox(height: 15),


            _buildTextField(
              controller: _usernameController,
              label: "Username",
              icon: Icons.alternate_email,
            ),



            const SizedBox(height: 20),



            Text(
              "Age: ${_age.round()}",
              style: TextStyle(
                fontSize: 18,
                color: Colors.blue.shade700,
              ),
            ),



            Slider(

              value: _age,

              min: 18,

              max: 100,


              onChanged: (value) {

                setState(() {

                  _age = value;

                });

              },

            ),



            const SizedBox(height: 20),



            // COUNTRY DROPDOWN

            isLoadingCountries

            ? const CircularProgressIndicator()


            :

            Container(

              padding:
                  const EdgeInsets.symmetric(
                    horizontal: 15,
                  ),


              decoration: BoxDecoration(

                color: Colors.white,

                borderRadius:
                    BorderRadius.circular(15),


                border: Border.all(
                  color: Colors.blue.shade700,
                ),

              ),



              child: DropdownButton<String>(


                value:

                    countries.contains(_country)

                    ? _country

                    : null,


                hint: const Text(
                  "Select Country",
                ),



                isExpanded: true,


                underline:
                    const SizedBox(),



                items:

                    countries.map((country) {


                  return DropdownMenuItem<String>(


                    value: country,


                    child: Text(country),


                  );


                }).toList(),



                onChanged: (value) {


                  setState(() {

                    _country = value;

                  });


                },

              ),

            ),



            const SizedBox(height: 30),



            SizedBox(

              width: double.infinity,


              child: ElevatedButton(

                onPressed: saveUserData,


                style:
                    ElevatedButton.styleFrom(

                  backgroundColor:
                      Colors.blue.shade700,

                  padding:
                      const EdgeInsets.symmetric(
                        vertical: 15,
                      ),

                  shape:
                      RoundedRectangleBorder(

                    borderRadius:
                        BorderRadius.circular(30),

                  ),

                ),


                child: const Text(

                  "Save Changes",

                  style: TextStyle(

                    color: Colors.white,

                    fontSize: 18,

                  ),

                ),

              ),

            ),

          ],

        ),

      ),

    );

  }




  Widget _buildTextField({

    required TextEditingController controller,

    required String label,

    required IconData icon,

  }) {

    return TextField(

      controller: controller,


      decoration: InputDecoration(

        labelText: label,


        prefixIcon: Icon(
          icon,
          color: Colors.blue,
        ),


        border:
            OutlineInputBorder(

          borderRadius:
              BorderRadius.circular(15),

        ),

      ),

    );

  }




  @override
  void dispose() {

    _nameController.dispose();

    _usernameController.dispose();

    super.dispose();

  }

}