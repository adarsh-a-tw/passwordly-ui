import 'package:flutter/material.dart';

class PrimaryLoadingButton extends StatefulWidget {
  const PrimaryLoadingButton({super.key, required this.title, this.onPressed});

  final String title;
  final Future<void> Function()? onPressed;

  @override
  State<PrimaryLoadingButton> createState() => _PrimaryLoadingButtonState();
}

class _PrimaryLoadingButtonState extends State<PrimaryLoadingButton> {
  bool _isLoading = false;

  void _onPressEvent() async {
    if (widget.onPressed != null) {
      setState(() {
        _isLoading = true;
      });
      await widget.onPressed!();
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: !_isLoading && widget.onPressed != null ? _onPressEvent : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      child: Container(
        width: double.infinity,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(
          vertical: 16.0,
        ),
        child: Stack(
          alignment: Alignment.centerLeft,
          children: [
            Expanded(
              child: Center(
                child: Text(
                  widget.title,
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            if (_isLoading)
              const SizedBox(
                width: 16.0,
                height: 16.0,
                child: CircularProgressIndicator(),
              )
          ],
        ),
      ),
    );
  }
}
