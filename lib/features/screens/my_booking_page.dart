import 'package:co_work_connect/core/widgets/custom_general_button.dart';
import 'package:flutter/material.dart';
import 'package:co_work_connect/features/data/models/place_model.dart';
import 'package:co_work_connect/features/data/service/local_storage_service.dart';

class MyBookingsPage extends StatefulWidget {
  const MyBookingsPage({super.key});

  @override
  State<MyBookingsPage> createState() => _MyBookingsPageState();
}

class _MyBookingsPageState extends State<MyBookingsPage> {
  late Future<List<PlaceModel>> bookedPlacesFuture;

  @override
  void initState() {
    super.initState();
    bookedPlacesFuture = LocalStorageService.getBookedPlaces();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Bookings'), centerTitle: true),
      body: FutureBuilder<List<PlaceModel>>(
        future: bookedPlacesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error loading bookings"));
          } else if (snapshot.data == null || snapshot.data!.isEmpty) {
            return Center(child: Text("No bookings yet"));
          } else {
            final bookedPlaces = snapshot.data!;
            return ListView.builder(
              itemCount: bookedPlaces.length,
              itemBuilder: (context, index) {
                final place = bookedPlaces[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  child: Material(
                    elevation: 3,
                    borderRadius: BorderRadius.circular(18),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        color: Colors.white,
                      ),
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(18),
                              topRight: Radius.circular(18),
                            ),
                            child: Image.network(
                              place.imageUrl,
                              width: double.infinity,
                              height: 140,
                              fit: BoxFit.cover,
                              errorBuilder:
                                  (c, e, s) => Container(
                                    height: 140,
                                    color: Colors.grey[200],
                                    child: Icon(
                                      Icons.broken_image,
                                      size: 60,
                                      color: Colors.grey,
                                    ),
                                  ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 2,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  place.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.location_on,
                                      color: Color(0xFFF83758),
                                      size: 15,
                                    ),
                                    SizedBox(width: 4),
                                    Flexible(
                                      child: Text(
                                        place.address,
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.grey[600],
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                SizedBox(
                                  height: 50,
                                  child: CustomGeneralButton(
                                    text: 'Cancel Booking',
                                    onTap: () async {
                                      await LocalStorageService.unBookSpace(
                                        place.name,
                                      );
                                      setState(() {
                                        bookedPlacesFuture =
                                            LocalStorageService.getBookedPlaces();
                                      });
                                    },
                                  ),
                                ),
                                const SizedBox(height: 6),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
