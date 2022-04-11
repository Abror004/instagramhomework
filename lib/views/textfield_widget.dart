import 'package:flutter/material.dart';

Container textField({required String hintText, bool? isHidden, required TextEditingController controller,Function()? function})  {
  return Container(
    decoration: BoxDecoration(
      color: Colors.black26.withOpacity(0.2),
      borderRadius: BorderRadius.circular(7.5),
    ),
    child: TextField(
      style: const TextStyle(fontSize: 16, color: Colors.black),
      controller: controller,
      obscureText: isHidden ?? false,
      decoration: InputDecoration(
        border: InputBorder.none,
        filled: true,
        fillColor: Colors.white54.withOpacity(0.5),
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.black.withOpacity(0.5),fontSize: 17),
        prefixIcon: IconButton(
          onPressed: () {},
          icon: Icon(Icons.search,color: Colors.black.withOpacity(0.5),),
        ),
      ),
      onEditingComplete: function,
    ),
  );
}