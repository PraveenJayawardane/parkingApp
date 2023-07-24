import 'package:flutter/material.dart';
import 'package:parkfinda_mobile/widgets/atoms/app_label.dart';
class BookingEmptyScreen extends StatelessWidget {
  const BookingEmptyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset("assets/images/booking_empty_img.png"),
        SizedBox(height: 40,),
        AppLabel(text: "Booking Not Found",fontSize: 18,),
        SizedBox(height: 16,),
        AppLabel(text: "Active bookings will appear here",fontSize: 18,),

      ],
    );
  }
}
