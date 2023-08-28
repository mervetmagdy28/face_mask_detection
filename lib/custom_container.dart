import 'package:flutter/material.dart';

import 'main.dart';

class CustomContainer extends StatelessWidget {
  const CustomContainer({super.key, required this.text,required this.onPressed});
  final String text;
  final Function() onPressed;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width*.9,
      height: MediaQuery.of(context).size.height*.05,
      decoration: BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.circular(10)
      ),
      child: TextButton(
          onPressed: onPressed,
          child: Text(text,style: const TextStyle(color:Colors.white),)),
    );
  }
}
