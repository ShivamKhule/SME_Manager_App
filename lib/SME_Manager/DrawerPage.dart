import 'package:firebase_connect/SME_Manager/LoginPage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'AuthScreen.dart';
import 'HomePage.dart';

class Drawerpage extends StatefulWidget {
  const Drawerpage({super.key});

  @override
  State createState() => _DrawerPageState();
}

class _DrawerPageState extends State {
  void toggleView() async {
    setState(() {
      isLogin = !isLogin;
    });
  }

  ListTile buildDrawerItem(IconData icon, String title, {Widget? page,
      IconData? add, Color? color}) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(
        title,
        style: GoogleFonts.merienda(color: color, fontWeight: FontWeight.w700,),
      ),
      trailing: GestureDetector(
        onTap: () {},
        child: Icon(add,
        color: Colors.black87,
        ),
      ),
      onTap: () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => page!,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: 300,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.black87,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 30,
                  child: Icon(Icons.business, size: 30, color: Colors.purple),
                ),
                SizedBox(height: 10),
                Text(
                  'CompanyName',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ],
            ),
          ),
          buildDrawerItem(Icons.home, 'Home', color: Colors.blueAccent, page: const Homepage()),
          buildDrawerItem(Icons.people, 'Parties', color: Colors.blueAccent, add: Icons.add),
          buildDrawerItem(Icons.category, 'Products', color: Colors.blueAccent, add: Icons.add),
          buildDrawerItem(Icons.shopping_cart, 'Sale', color: Colors.blueAccent, add: Icons.add),
          buildDrawerItem(Icons.shopping_bag, 'Purchase', color: Colors.blueAccent, add: Icons.add),
          buildDrawerItem(Icons.business_center, 'Expense', color: Colors.blueAccent,
              add: Icons.add),
          buildDrawerItem(Icons.bar_chart, 'Reports', color: Colors.blueAccent),
          const Divider(),
          buildDrawerItem(
              Icons.production_quantity_limits, 'Other Products', color: Colors.blueAccent),
          buildDrawerItem(Icons.settings, 'Settings', color: Colors.blueAccent),
          buildDrawerItem(
              Icons.logout, 'Log Out', page: LoginPage(toggleView: toggleView), color: Colors.red,),
        ],
      ),
    );
  }
}


/*
@override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kalika Industries'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.black87,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 30,
                    child: Icon(Icons.business, size: 30, color: Colors.purple),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Kalika Industries',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ],
              ),
            ),
            buildDrawerItem(Icons.home, 'Home', context),
            buildDrawerItem(Icons.people, 'Parties', context),
            buildDrawerItem(Icons.category, 'Items', context),
            buildDrawerItem(Icons.shopping_cart, 'Sale', context),
            buildDrawerItem(Icons.shopping_bag, 'Purchase & Expense', context),
            buildDrawerItem(Icons.business_center, 'Grow Your Business', context),
            buildDrawerItem(Icons.account_balance_wallet, 'Cash & Bank', context),
            buildDrawerItem(Icons.bar_chart, 'Reports', context),
            const Divider(),
            buildDrawerItem(Icons.sync, 'Sync, Share & Backups', context),
            buildDrawerItem(Icons.attach_money, 'Apply For Loan', context),
            buildDrawerItem(Icons.production_quantity_limits, 'Other Products', context),
            buildDrawerItem(Icons.settings, 'Settings', context),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text('Sync Off: 7350035551', style: TextStyle(fontSize: 14, color: Colors.grey)),
            ),
          ],
        ),
      ),
      body: const Center(
        child: Text('Dashboard Content'),
      ),
    );
  }

  ListTile buildDrawerItem(IconData icon, String title, BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(
        title,
        style: TextStyle(color: Colors.white),
      ),
      onTap: () {
        Navigator.pop(context); // Close the drawer
      },
    );
  }

  */