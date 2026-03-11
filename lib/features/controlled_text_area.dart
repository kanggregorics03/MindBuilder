import 'package:flutter/material.dart';

class ControlledTextArea extends StatefulWidget {
  const ControlledTextArea({
    super.key,
    required this.value,
    required this.onChanged,
    required this.labelText,
    required this.hintText,
    this.minLines = 3,
    this.maxLines = 5,
  });

  final String value;
  final ValueChanged<String> onChanged;
  final String labelText;
  final String hintText;
  final int minLines;
  final int maxLines;

  @override
  State<ControlledTextArea> createState() => _ControlledTextAreaState();
}

class _ControlledTextAreaState extends State<ControlledTextArea> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
  }

  @override
  void didUpdateWidget(covariant ControlledTextArea oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value == widget.value || _controller.text == widget.value) {
      return;
    }

    _controller.value = TextEditingValue(
      text: widget.value,
      selection: TextSelection.collapsed(offset: widget.value.length),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      minLines: widget.minLines,
      maxLines: widget.maxLines,
      onChanged: widget.onChanged,
      decoration: InputDecoration(
        labelText: widget.labelText,
        hintText: widget.hintText,
        border: const OutlineInputBorder(),
      ),
    );
  }
}
