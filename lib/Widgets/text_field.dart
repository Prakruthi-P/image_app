
import 'package:flutter/material.dart';

class TextFiled extends StatefulWidget {


  final TextEditingController controller;
  final String hintText;
  final bool isPassword;
  final Icon icon;
  final FormFieldSetter<String>? onSaved;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onFieldSubmitted;
  final TextInputType? inputType;
   const TextFiled({
    super.key,
    required this.controller,
    required this.hintText,
     this.isPassword=false,
     required this.icon,
     this.onSaved,
     this.validator,
     this.onFieldSubmitted,
     this.inputType,

  });

  @override
  State<TextFiled> createState() => _TextFiledState();
}

class _TextFiledState extends State<TextFiled> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    bool _hasFocus = false;
    return Focus(
      onFocusChange: (hasFocus) {
        setState(() {
          _hasFocus = hasFocus;
        });
      },
      child: Container(
        width: 300,
        height: 50,
        padding: EdgeInsets.symmetric(horizontal: 20,vertical: 0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius:BorderRadius.circular(20),
          border: Border.all(
            color: _hasFocus ? Colors.blue : Colors.white, // Change border color when focused
            width: 2.0,
          ),
        ),
        child: Row(
          children: [
            if (widget.icon != null) widget.icon,
            SizedBox(width: 10,),
            Expanded(
              child: TextFormField(
                cursorWidth: 1,
                onSaved: widget.onSaved,
                validator: widget.validator,
                onFieldSubmitted: widget.onFieldSubmitted,
                controller: widget.controller,
                keyboardType: widget.inputType,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: widget.hintText,
                ),
                obscureText: widget.isPassword?_obscureText:false,
              ),
            ),
            if (widget.isPassword)
              IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              ),

          ],
        ),
      ),
    );
  }
}