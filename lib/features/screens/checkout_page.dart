// ignore_for_file: use_build_context_synchronously
import 'package:co_work_connect/core/widgets/custom_general_button.dart';
import 'package:co_work_connect/features/data/models/place_model.dart';
import 'package:co_work_connect/features/data/service/local_storage_service.dart';
import 'package:co_work_connect/features/screens/home.dart';
import 'package:flutter/material.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key, required this.placeModel});
  final PlaceModel placeModel;

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  int selectedPayment = 0;

  final paymentMethods = [
    {"icon": "assets/visa.png", "name": "VISA", "number": "******2109"},
    {"icon": "assets/paypal.png", "name": "PayPal", "number": "******2109"},
    {
      "icon": "assets/mastercard.png",
      "name": "MasterCard",
      "number": "******2109",
    },
    {"icon": "assets/apple.png", "name": "ApplePay", "number": "******2109"},
  ];
  void showBookedDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 35, horizontal: 25),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        height: 100,
                        child: Image.asset('assets/booking_success.png'),
                      ),
                      Icon(Icons.check, color: Colors.white, size: 48),
                    ],
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    "Booked",
                    style: TextStyle(
                      color: Color(0xFFF83758),
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 22),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "Checkout",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Order",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  Text(
                    "\$ ${widget.placeModel.price}",
                    style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Addational money",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  Text(
                    "\$ 0",
                    style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Total",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "\$ ${widget.placeModel.price}",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const Divider(height: 30),
              const Text(
                "Payment",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 15),
              ...List.generate(paymentMethods.length, (index) {
                final method = paymentMethods[index];
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedPayment = index;
                    });
                  },
                  child: Container(
                    height: 56,
                    margin: const EdgeInsets.only(bottom: 14),
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color:
                            selectedPayment == index
                                ? Colors.redAccent
                                : Colors.grey.shade200,
                        width: selectedPayment == index ? 2 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Image.asset(method["icon"]!, width: 35, height: 35),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            method["name"]!,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        Text(
                          method["number"]!,
                          style: TextStyle(
                            color: Colors.grey[800],
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
              const Spacer(),
              CustomGeneralButton(
                text: "Continue",
                onTap: () async {
                  await LocalStorageService.bookSpace(widget.placeModel);

                  showBookedDialog(context);
                  Future.delayed(const Duration(seconds: 2), () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => Home()),
                    );
                  });
                },
              ),
              const SizedBox(height: 15),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}
