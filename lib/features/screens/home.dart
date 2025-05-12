import 'dart:io';

import 'package:co_work_connect/core/widgets/place_cart.dart';
import 'package:co_work_connect/features/data/models/user_model.dart';
import 'package:co_work_connect/features/data/service/local_storage_service.dart';
import 'package:co_work_connect/features/screens/my_booking_page.dart';
import 'package:co_work_connect/features/places.dart';
import 'package:co_work_connect/features/screens/login.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  UserModel? currentUser;

  @override
  void initState() {
    super.initState();
    loadCurrentUser();
  }

  void loadCurrentUser() async {
    final user = await LocalUserStorageService.getLoggedInUser();
    setState(() {
      currentUser = user;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          CircleAvatar(
            radius: 25,
            backgroundColor: Colors.white,
            backgroundImage:
                currentUser != null && currentUser!.photoPath != null
                    ? FileImage(File(currentUser!.photoPath!))
                    : AssetImage('assets/avatar.png') as ImageProvider,
          ),
          SizedBox(width: 20,)
        ],
      ),
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Color(0xFFF83758)),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    backgroundImage:
                        currentUser != null && currentUser!.photoPath != null
                            ? FileImage(File(currentUser!.photoPath!))
                            : AssetImage('assets/avatar.png') as ImageProvider,
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child:
                        currentUser == null
                            ? Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            )
                            : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  currentUser!.username,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 19,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  currentUser!.email,
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                  ),
                ],
              ),
            ),

            // My Bookings CARD/Tile
            ListTile(
              leading: Icon(
                Icons.book_online,
                color: Color(0xFFF83758),
                size: 28,
              ),
              title: Text("My Bookings", style: TextStyle(fontSize: 17)),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => MyBookingsPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.logout, color: Colors.grey[700], size: 28),
              title: Text("Logout", style: TextStyle(fontSize: 17)),
              onTap: () {
                Navigator.pop(context);
                LocalUserStorageService.logout();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
            ),
          ],
        ),
      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: SearchBar(
              hintText: 'Search for a place',
              onChanged: (value) {},
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Text(
              'All place for you',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 15),
          Expanded(
            child: SizedBox(
              height: 100,
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 2,
                ),
                scrollDirection: Axis.vertical,
                itemCount: places.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [PlaceCart(placeModel: places[index])],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
