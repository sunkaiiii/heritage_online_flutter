import 'package:flutter/material.dart';

/// 搜索框组件
class SearchField extends StatefulWidget {
  final String value;
  final ValueChanged<String> onChanged;
  final String label;
  final String placeholder;
  final ValueChanged<String>? onSearch;

  const SearchField({
    super.key,
    required this.value,
    required this.onChanged,
    required this.label,
    required this.placeholder,
    this.onSearch,
  });

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
  }

  @override
  void didUpdateWidget(SearchField oldWidget) {
    super.didUpdateWidget(oldWidget);
    // 外部 value 变化时同步更新 controller
    if (widget.value != oldWidget.value &&
        widget.value != _controller.text) {
      _controller.text = widget.value;
    }
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
      onChanged: widget.onChanged,
      decoration: InputDecoration(
        labelText: widget.label,
        hintText: widget.placeholder,
        prefixIcon: const Icon(Icons.search),
        suffixIcon: _controller.text.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  _controller.clear();
                  widget.onChanged('');
                },
              )
            : null,
      ),
      textInputAction: TextInputAction.search,
      onSubmitted: widget.onSearch,
    );
  }
}
