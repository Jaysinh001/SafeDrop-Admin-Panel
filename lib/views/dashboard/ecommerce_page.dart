import 'package:flutter/material.dart';

import '../layout.dart';
import 'analytics_widget.dart';
import 'channel_widget.dart';
import 'grid_card.dart';
import 'revenue_widget.dart';

class EcommercePage extends LayoutWidget {
  const EcommercePage({super.key});

  @override
  String breakTabTitle(BuildContext context) {
    // TODO: implement breakTabTitle
    return 'Ecommerce';
  }

  @override
  Widget contentDesktopWidget(BuildContext context) {
    return const Column(
      children: [
        GridCard(),
        SizedBox(height: 16),
        RevenueWidget(),
        SizedBox(height: 16),
        AnalyticsWidget(),
        SizedBox(height: 16),
        ChannelWidget(),
      ],
    );
  }
}
