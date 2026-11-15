import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// One labelled text field of a [showFormDialog].
class FormFieldSpec {
  final String label;
  final String initial;
  final bool obscure;
  final TextInputType keyboard;

  const FormFieldSpec(
    this.label, {
    this.initial = '',
    this.obscure = false,
    this.keyboard = TextInputType.text,
  });
}

/// Shows a dialog with [fields] and returns their values in order, or null
/// if the user cancelled. Every field except those in [optional] must be
/// filled. The dialog scrolls, so it works with the keyboard open.
Future<List<String>?> showFormDialog(
  BuildContext context, {
  required String title,
  required List<FormFieldSpec> fields,
  String confirmLabel = 'Save',
  Set<int> optional = const {},
}) {
  return showDialog<List<String>>(
    context: context,
    builder: (_) => _FormDialog(
      title: title,
      fields: fields,
      confirmLabel: confirmLabel,
      optional: optional,
    ),
  );
}

class _FormDialog extends StatefulWidget {
  final String title;
  final List<FormFieldSpec> fields;
  final String confirmLabel;
  final Set<int> optional;

  const _FormDialog({
    required this.title,
    required this.fields,
    required this.confirmLabel,
    required this.optional,
  });

  @override
  State<_FormDialog> createState() => _FormDialogState();
}

class _FormDialogState extends State<_FormDialog> {
  late final List<TextEditingController> _ctrls = [
    for (final f in widget.fields) TextEditingController(text: f.initial),
  ];
  String? _error;

  @override
  void dispose() {
    for (final c in _ctrls) {
      c.dispose();
    }
    super.dispose();
  }

  void _submit() {
    for (var i = 0; i < _ctrls.length; i++) {
      if (!widget.optional.contains(i) && _ctrls[i].text.trim().isEmpty) {
        setState(() => _error = '${widget.fields[i].label} is required.');
        return;
      }
    }
    Navigator.of(context).pop([for (final c in _ctrls) c.text.trim()]);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: SizedBox(
        width: 420,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (var i = 0; i < widget.fields.length; i++)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: TextField(
                    controller: _ctrls[i],
                    obscureText: widget.fields[i].obscure,
                    keyboardType: widget.fields[i].keyboard,
                    decoration: InputDecoration(
                      labelText: widget.fields[i].label +
                          (widget.optional.contains(i) ? ' (optional)' : ''),
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ),
              if (_error != null)
                Text(_error!, style: const TextStyle(color: AppColors.danger)),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _submit,
          style: FilledButton.styleFrom(backgroundColor: AppColors.purple),
          child: Text(widget.confirmLabel),
        ),
      ],
    );
  }
}

/// Asks "are you sure?"; true only when the user confirms.
Future<bool> confirmAction(
  BuildContext context, {
  required String title,
  required String message,
  String confirmLabel = 'Delete',
}) async {
  final ok = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(false),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(ctx).pop(true),
          style: FilledButton.styleFrom(backgroundColor: AppColors.danger),
          child: Text(confirmLabel),
        ),
      ],
    ),
  );
  return ok ?? false;
}

void showMessage(BuildContext context, String message, {bool error = false}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(message),
    backgroundColor: error ? AppColors.errorSnack : AppColors.purple,
  ));
}
