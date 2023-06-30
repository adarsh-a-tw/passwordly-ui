import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:passwordly/utils/passwordly_scaffold_messenger.dart';

class SecretDisplayView extends StatefulWidget {
  final String title;
  final String text;
  final bool needsSecurity;
  const SecretDisplayView({
    super.key,
    required this.title,
    required this.text,
    this.needsSecurity = false,
  });

  @override
  State<SecretDisplayView> createState() => _SecretDisplayViewState();
}

class _SecretDisplayViewState extends State<SecretDisplayView> {
  bool _isTextObscured = true;
  final String kObscuredText = "*" * 20;

  void _copyToClipboard() async {
    await Clipboard.setData(ClipboardData(text: widget.text));
    if (context.mounted) {
      PasswordlyScaffoldMessenger.showSnackBar(
          context, "${widget.title} copied.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).colorScheme.secondaryContainer,
        ),
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                ),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  widget.needsSecurity && _isTextObscured
                      ? kObscuredText
                      : widget.text,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
            const Spacer(),
            if (widget.needsSecurity)
              InkWell(
                customBorder: const CircleBorder(),
                onTapDown: (details) {
                  setState(() {
                    _isTextObscured = false;
                  });
                },
                onTapUp: (details) => {
                  setState(() {
                    _isTextObscured = true;
                  })
                },
                child: Ink(
                  width: 40,
                  height: 40,
                  child: Icon(
                    _isTextObscured ? Icons.lock_outline : Icons.lock_open,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
              ),
            if (widget.needsSecurity)
              const SizedBox(
                width: 16,
              ),
            IconButton(
              onPressed: _copyToClipboard,
              icon: Icon(
                Icons.copy,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            )
          ],
        ),
      ),
    );
  }
}
