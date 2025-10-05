// =============================================================================
// LOADING VIEW
// =============================================================================

import 'package:flutter/material.dart';

class LoadingView extends StatelessWidget {
  final String? title;
  const LoadingView({super.key, this.title});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text(title ?? 'Loading ...'),
        ],
      ),
    );
  }
}
