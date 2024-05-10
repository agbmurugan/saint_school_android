import 'package:flutter/material.dart';

import '../theme.dart';

class CustomDropdownField<T> extends StatelessWidget {
  const CustomDropdownField({
    Key? key,
    this.obscureText,
    required this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    required this.items,
    this.onChanged,
    this.value,
  }) : super(key: key);

  final bool? obscureText;
  final String hintText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final List<DropdownMenuItem<T>>? items;
  final void Function(T?)? onChanged;
  final T? value;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: DropdownButtonFormField<T>(
          items: items,
          onChanged: onChanged,
          value: value,
          decoration: InputDecoration(
              hintText: hintText,
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: lightColorScheme.secondary,
                  width: 1,
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(4.0),
                  topRight: Radius.circular(4.0),
                ),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: lightColorScheme.secondary,
                  width: 2,
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(4.0),
                  topRight: Radius.circular(4.0),
                ),
              ),
              prefixIcon: prefixIcon,
              suffixIcon: suffixIcon),
        ),
      ),
    );
  }
}
