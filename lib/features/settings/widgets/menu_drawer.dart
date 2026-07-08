import 'package:flutter/material.dart';

import '../screens/configure_screen.dart';
import '../screens/personal_info_screen.dart';
import '../screens/reports_screen.dart';
import '../screens/notifications_screen.dart';
import '../../auth/screens/logout_screen.dart';


class MenuDrawer extends StatelessWidget {

  final Function(String)? onUsernameChanged;


  const MenuDrawer({
    super.key,
    this.onUsernameChanged,
  });



  @override
  Widget build(BuildContext context) {

    return Drawer(

      child: ListView(

        padding: EdgeInsets.zero,

        children: [

          const DrawerHeader(

            decoration: BoxDecoration(
              color: Colors.blue,
            ),

            child: Align(

              alignment: Alignment.bottomLeft,

              child: Text(

                "Menu",

                style: TextStyle(

                  color: Colors.white,

                  fontSize: 30,

                  fontWeight: FontWeight.bold,

                ),

              ),

            ),

          ),



          // Configure

          ListTile(

            leading: const Icon(Icons.settings),

            title: const Text("Configure"),


            onTap: () {

              Navigator.pop(context);


              Navigator.push(

                context,

                MaterialPageRoute(

                  builder: (_) =>
                      const ConfigureScreen(),

                ),

              );

            },

          ),





          // Personal Info

          ListTile(

            leading: const Icon(Icons.person),

            title: const Text("Personal Info"),


            onTap: () async {


              Navigator.pop(context);



              final updatedUsername =
                  await Navigator.push(

                context,

                MaterialPageRoute(

                  builder: (_) =>
                      const PersonalInfoScreen(),

                ),

              );



              if(updatedUsername != null &&
                  onUsernameChanged != null) {


                onUsernameChanged!(
                  updatedUsername,
                );


              }


            },

          ),





          // Reports

          ListTile(

            leading: const Icon(Icons.bar_chart),

            title: const Text("Reports"),


            onTap: () {


              Navigator.pop(context);


              Navigator.push(

                context,

                MaterialPageRoute(

                  builder: (_) =>
                      const ReportsScreen(),

                ),

              );


            },

          ),





          // Notifications

          ListTile(

            leading: const Icon(Icons.notifications),

            title: const Text("Notifications"),


            onTap: () {


              Navigator.pop(context);


              Navigator.push(

                context,

                MaterialPageRoute(

                  builder: (_) =>
                    NotificationsScreen(),

                ),

              );


            },

          ),






          const Divider(),






          // Logout

          ListTile(

            leading: const Icon(

              Icons.logout,

              color: Colors.red,

            ),


            title: const Text(

              "Sign Out",

              style: TextStyle(

                color: Colors.red,

              ),

            ),



            onTap: () {


              Navigator.pop(context);



              Navigator.push(

                context,

                MaterialPageRoute(

                  builder: (_) =>
                      const LogoutScreen(),

                ),

              );


            },

          ),


        ],

      ),

    );

  }

}