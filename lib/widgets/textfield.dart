import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

import '../constants/colors.dart';

class CustomTextField extends StatefulWidget {
  final bool isEnabled;
  final bool obscureText;
  final Widget? suffix;
  final Widget? prefix;
  final String placeholder;
  final String? initialValue;
  final TextInputType type;
  final Color? bgColor;
  final BorderRadius? borderRadius;
  final void Function(String)? onChanged;
  final void Function()? onTap;
  final int? maxLine;
  final bool autofocus;
  final List<TextInputFormatter>? formatters;
  final TextEditingController? controller;

  const CustomTextField(
      {Key? key,
      this.initialValue,
      this.isEnabled = true,
      this.obscureText = false,
      this.prefix,
      this.suffix,
      this.placeholder = "",
      this.type = TextInputType.text,
      this.borderRadius,
      this.onChanged,
      this.onTap,
      this.maxLine = 1,
      this.formatters,
      this.controller,
      this.bgColor,
      this.autofocus = false})
      : super(key: key);

  @override
  createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  var _controller = TextEditingController();
  final _focusNode = FocusNode();
  var _isFocused = false;
  var _value = "";

  _clearText() {
    _controller.text = "";
  }

  _onChange(value) {
    setState(() => {_value = value});
    if (widget.onChanged != null) {
      widget.onChanged!(value);
    }
  }

  _controllerListener() {
    _onChange(_controller.text);
  }

  _onFocusChange() {
    setState(() => {_isFocused = _focusNode.hasFocus});
  }

  Widget _clearWidget() {
    return _value.isNotEmpty && _isFocused
        ? InkWell(
            onTap: _clearText,
            child: SvgPicture.asset(
              "assets/images/text_field_orange.svg",
              height: 14,
              width: 14,
            ))
        : const SizedBox();
  }

  @override
  void initState() {
    super.initState();
    if (widget.controller != null) {
      _controller = widget.controller!;
    }
    if (widget.initialValue != null) {
      _controller.text = widget.initialValue!;
    }
    _controller.addListener(_controllerListener);
    _focusNode.addListener(_onFocusChange);
  }

  @override
  Widget build(BuildContext context) {
    var colors = getThemeColors();
    return Container(
      width: double.maxFinite,
      decoration: BoxDecoration(
        color: widget.bgColor ?? colors.PRIMARY,
        borderRadius: widget.borderRadius ?? BorderRadius.circular(24),
        border: Border.all(color: colors.PRIMARY, width: 2),
      ),
      child: TextField(
        autofocus: widget.autofocus,
        obscureText: widget.obscureText,
        enabled: widget.isEnabled,
        controller: _controller,
        focusNode: _focusNode,
        maxLines: widget.maxLine,
        inputFormatters: widget.formatters,
        onChanged: _onChange,
        onTap: widget.onTap,
        keyboardType: widget.type,
        style: Theme.of(context).textTheme.bodyMedium,
        cursorColor: colors.SURFACE_HIGH,
        decoration: InputDecoration(
          suffix: widget.suffix ?? _clearWidget(),
          prefix: widget.prefix,
          floatingLabelBehavior: FloatingLabelBehavior.never,
          contentPadding:
              const EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 12),
          labelText: widget.placeholder,
          labelStyle: Theme.of(context)
              .textTheme
              .bodyMedium!
              .copyWith(color: colors.SURFACE_HIGH.withOpacity(0.5)),
          hintText: widget.placeholder,
          hintStyle: Theme.of(context)
              .textTheme
              .bodyMedium!
              .copyWith(color: colors.SURFACE_HIGH.withOpacity(0.5)),
          enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent)),
          errorBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent)),
          disabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent)),
          border: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent)),
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent)),
        ),
      ),
    );
  }
}
