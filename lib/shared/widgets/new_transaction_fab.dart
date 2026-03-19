import 'package:flutter/material.dart';
import 'new_transaction_modal.dart';

class NewTransactionFab extends StatelessWidget {
  const NewTransactionFab({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => showNewTransactionModal(context),
      child: const Icon(Icons.add),
    );
  }
}
