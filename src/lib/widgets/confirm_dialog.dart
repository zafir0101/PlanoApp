import 'package:flutter/material.dart';

import '../theme.dart';

void showConfirmDialog(
  BuildContext context, {
  required String promptText,
  String description = "Essa ação não pode ser desfeita",
  String confirmText = "Continuar",
  required VoidCallback onConfirm,
  VoidCallback? onCancel,
}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialog(
      titlePadding: const EdgeInsets.fromLTRB(24, 30, 24, 0),
      contentPadding: const EdgeInsets.fromLTRB(24, 12, 24, 4),
      actionsPadding: const EdgeInsets.fromLTRB(24, 12, 24, 12),
      content: Text(
        description,
        style: const TextStyle(color: PlanoColors.textSecondary, fontSize: 12),
      ),
      title: Text(
        promptText,
        style: const TextStyle(fontSize: 16, color: PlanoColors.textPrimary),
      ),
      actions: [
        TextButton(
          onPressed: () {
            onConfirm();
            Navigator.pop(context);
          }, //onConfirm,
          child: Text(
            confirmText,
            textAlign: TextAlign.end,
            style: const TextStyle(fontWeight: FontWeight.w400),
          ),
        ),
        TextButton(
          onPressed: () {
            if (onCancel != null) onCancel();
            Navigator.pop(context);
          },
          child: const Text(
            "Cancelar",
            textAlign: TextAlign.end,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        )
      ],
    ),
  );
}
