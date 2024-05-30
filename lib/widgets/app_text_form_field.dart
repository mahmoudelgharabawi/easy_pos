import 'package:flutter/material.dart';

class AppTextFormField extends StatelessWidget {
  final String? labelText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  const AppTextFormField(
      {this.labelText, this.controller, this.validator, super.key});

  InputBorder get textFieldBorder => OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
      );

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      controller: controller,
      decoration: InputDecoration(
        border: textFieldBorder,
        focusedBorder: textFieldBorder.copyWith(
          borderSide: BorderSide(
            width: 2,
            color: Theme.of(context).primaryColor,
          ),
        ),
        enabledBorder: textFieldBorder,
        errorBorder: textFieldBorder.copyWith(
          borderSide: BorderSide(
            width: 2,
            color: Theme.of(context).colorScheme.error,
          ),
        ),
        labelText: labelText,
      ),
    );
  }
}
