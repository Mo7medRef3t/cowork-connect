import 'package:co_work_connect/core/widgets/custom_general_button.dart';
import 'package:co_work_connect/features/screens/book_your_seat.dart';
import 'package:co_work_connect/features/data/models/place_model.dart';
import 'package:flutter/material.dart';

class CoWorkScreen extends StatelessWidget {
  final PlaceModel placeModel;

  const CoWorkScreen({super.key, required this.placeModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 300,
            width: double.infinity,
            child: Image.network(placeModel.imageUrl, fit: BoxFit.cover),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  placeModel.name,
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                Icon(Icons.location_on_outlined, size: 28),
              ],
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.white, Colors.grey],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: CustomGeneralButton(
                    text: "Book",
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => BookYourSeatPage(
                          placeModel: placeModel,
                        )),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
