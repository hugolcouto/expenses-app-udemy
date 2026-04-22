import 'package:flutter/material.dart';

class Graph extends StatelessWidget {
  const Graph({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        color: Theme.of(context).primaryColor,
        elevation: 3,
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            'Gráfico',
            style: Theme.of(context).appBarTheme.titleTextStyle,
          ),
        ),
      ),
    );
  }
}
