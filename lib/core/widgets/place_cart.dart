import 'package:co_work_connect/features/data/models/place_model.dart';
import 'package:co_work_connect/features/screens/cowork_screen.dart';
import 'package:flutter/material.dart';

class PlaceCart extends StatelessWidget {
  const PlaceCart({super.key, this.placeModel});
  final PlaceModel? placeModel;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return CoWorkScreen(placeModel: placeModel!,);
            },
          ),
        );
      },
      child: Container(
        height: 200,
        width: 200,
        margin: const EdgeInsets.only(left: 10, right: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 5,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              height: 125,
              width: 180,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(placeModel!.imageUrl, fit: BoxFit.cover),
              ),
            ),
            Text(
              placeModel!.name,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              placeModel!.address,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 5.0, right: 5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '\$${placeModel!.price}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 16),
                      Text(
                        '${placeModel!.rating}',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
