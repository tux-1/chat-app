import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final void Function(String?)? onSaved;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final int? maxLength;
  final String? Function(String?)? validator;
  final String? labelText;
  final bool obscureText;
  final TextEditingController? controller;
  const CustomTextField(
      {super.key,
      this.controller,
      this.onSaved,
      this.keyboardType = TextInputType.emailAddress,
      this.textInputAction = TextInputAction.next,
      this.maxLength,
      this.validator,
      this.labelText,
      this.obscureText = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10, top: 5),
      child: TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        controller: controller,
        validator: validator,
        onSaved: onSaved,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        maxLines: 1,
        obscureText: obscureText,
        maxLength: maxLength,
        onTapOutside: (event) => FocusScope.of(context).unfocus(),
        decoration: InputDecoration(
          labelText: labelText,
          counterText: "",
          contentPadding:
              const EdgeInsets.symmetric(vertical: 1, horizontal: 20),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(7),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(7),
          ),
        ),
      ),
    );
  }
}
