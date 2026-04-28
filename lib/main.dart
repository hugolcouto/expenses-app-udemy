import 'dart:math';

import 'package:expenses/components/graph.dart';
import 'package:expenses/components/transaction_form.dart';
import 'package:expenses/components/transaction_list.dart';
import 'package:expenses/models/transaction.dart';
import 'package:expenses/theme.dart';
import 'package:flutter/material.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ExpensesApp(),
      theme: AppTheme.light(),
      // theme: ThemeData(
      //   useMaterial3: true,
      //   fontFamily: "Quicksand",
      //   appBarTheme: AppBarTheme(
      //     backgroundColor: Colors.teal,
      //     foregroundColor: Colors.red,
      //     titleTextStyle: TextStyle(
      //       fontFamily: "Quicksand",
      //       fontSize: 25,
      //       fontWeight: FontWeight(700),
      //       color: Theme.of(context).primaryColor,
      //     ),
      //   ),
      //   colorScheme: ColorScheme.fromSeed(
      //     seedColor: Colors.red,
      //     primary: Colors.teal,
      //     secondary: Colors.red,
      //   ),
      // ),
    );
  }
}

class ExpensesApp extends StatefulWidget {
  const ExpensesApp({super.key});

  @override
  State<ExpensesApp> createState() => _ExpensesAppState();
}

class _ExpensesAppState extends State<ExpensesApp> {
  final List<Transaction> _transactions = [];

  void _addTransaction(String title, double value) {
    final newTransaction = Transaction(
      id: Random().nextDouble().toString(),
      title: title,
      value: value,
      date: DateTime.now(),
    );

    setState(() {
      _transactions.add(newTransaction);
    });

    Navigator.of(context).pop();
  }

  void _openTransactionFormModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return TransactionForm(onSubmit: _addTransaction);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Despesas Pessoais", style: TextStyle(color: Colors.white)),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          IconButton(
            onPressed: () => _openTransactionFormModal(context),
            icon: Icon(Icons.add),
            color: Colors.white,
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Graph(),
          TransactionList(transactions: _transactions),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openTransactionFormModal(context),
        backgroundColor: Theme.of(context).primaryColor,
        child: Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
