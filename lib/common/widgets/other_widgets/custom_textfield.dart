import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final bool obscureText;
  final String labelText;
  final IconData visibleIcon;
  final IconData hiddenIcon;
  bool isObscured;
  final void Function() toggleVisibility;
  // final int maxLines;
   CustomTextField({
    Key? key,
    required this.controller,
    this.obscureText = false,
    required this.labelText,
    this.visibleIcon = Icons.visibility,
    this.hiddenIcon = Icons.visibility_off,
    this.isObscured = false,
    required this.toggleVisibility,
    // this.maxLines = 1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // return TextFormField(
    //   controller: controller,
    //   decoration: InputDecoration(
    //       hintText: hintText,
    //       border: const OutlineInputBorder(
    //           borderSide: BorderSide(
    //         color: Colors.black38,
    //       )),
    //       enabledBorder: const OutlineInputBorder(
    //           borderSide: BorderSide(
    //         color: Colors.black38,
    //       ))),
    //   validator: (val) {
    //     if (val == null || val.isEmpty) {
    //       return 'Enter your $hintText';
    //     }
    //     return null;
    //   },
    //   maxLines: maxLines,
    // );

     return TextFormField(
      controller: controller,
      obscureText: isObscured,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(),
        suffixIcon: IconButton(
          icon: Icon(
            isObscured ? hiddenIcon : visibleIcon,
          ),
          onPressed: toggleVisibility,
        ),
      ),
    );
  }
}
