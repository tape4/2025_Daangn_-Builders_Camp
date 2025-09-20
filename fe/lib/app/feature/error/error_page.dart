import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class ErrorPage extends StatelessWidget {
  const ErrorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: ShadCard(
          title: Text('Something went wrong'),
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.error, size: 64, color: Colors.red),
                SizedBox(height: 16),
                Text('Please try again later.'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
