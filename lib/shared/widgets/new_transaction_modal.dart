import 'package:flutter/material.dart';

void showNewTransactionModal(BuildContext context) {
  final isDesktop = MediaQuery.sizeOf(context).width >= 800;

  if (isDesktop) {
    showDialog(
      context: context,
      builder: (context) => const _NewTransactionDialog(),
    );
  } else {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => const _NewTransactionSheet(),
    );
  }
}

class _NewTransactionDialog extends StatelessWidget {
  const _NewTransactionDialog();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'New Transaction',
        style: Theme.of(context).textTheme.titleLarge,
      ),
      content: SizedBox(
        width: 400,
        child: Text(
          'Coming soon',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
      ],
    );
  }
}

class _NewTransactionSheet extends StatelessWidget {
  const _NewTransactionSheet();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'New Transaction',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text('Coming soon', style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
