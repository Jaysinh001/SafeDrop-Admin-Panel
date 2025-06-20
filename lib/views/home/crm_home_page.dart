import '../../../config/theme/crm_colors.dart';
import 'package:safedropadminpanel/views/crm_layout.dart';
import 'package:safedropadminpanel/views/home/contact_list_widget.dart';
import 'package:flareline_uikit/components/card/common_card.dart';
import 'package:flareline_uikit/components/charts/circular_chart.dart';
import 'package:flareline_uikit/components/charts/line_chart.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../config/components/card_data_widget.dart';

class CrmHomePage extends CrmLayout {
  const CrmHomePage({super.key});

  @override
  String breakTabTitle(BuildContext context) {
    // TODO: implement breakTabTitle
    return 'Dashboard';
  }

  @override
  Widget contentMobileWidget(BuildContext context) {
    // TODO: implement contentMobileWidget
    return Column(
      children: [
        _topToolsWidget(),
        const SizedBox(height: 20),
        SizedBox(height: 400, child: _lineChart()),
        SizedBox(height: 20),
        SizedBox(height: 400, child: _circleBarWidget()),
        const SizedBox(height: 20),
        SizedBox(height: 500, child: ContactListWidget()),
      ],
    );
  }

  @override
  Widget contentDesktopWidget(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 650,
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: Column(
                  children: [
                    _topToolsWidgetDesk(),
                    const SizedBox(height: 20),
                    Expanded(child: _lineChart()),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: SizedBox(width: 400, child: _circleBarWidget()),
                flex: 1,
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(height: 500, child: ContactListWidget()),
      ],
    );
  }

  CommonCard _circleBarWidget() {
    return CommonCard(
      child: CircularhartWidget(
        title: 'Sorce Of Purchases',
        position: LegendPosition.bottom,
        orientation: LegendItemOrientation.vertical,
        palette: const [
          CrmColors.orange,
          CrmColors.secondary,
          CrmColors.primary,
        ],
        chartData: const [
          {'x': 'Social Media', 'y': 33},
          {'x': 'Direct Search', 'y': 33},
          {'x': 'Others', 'y': 34},
        ],
      ),
    );
  }

  Widget _lineChart() {
    return CommonCard(
      child: LineChartWidget(
        isDropdownToggle: true,
        title: 'Sales Figures',
        dropdownItems: const ['Daily', 'Weekly', 'Monthly'],
        datas: const [
          {
            'name': 'Marketing Sales',
            'color': Color(0xFFFE8111),
            'data': [
              {'x': 'Jan', 'y': 25},
              {'x': 'Fed', 'y': 75},
              {'x': 'Mar', 'y': 28},
              {'x': 'Apr', 'y': 32},
              {'x': 'May', 'y': 40},
              {'x': 'Jun', 'y': 48},
              {'x': 'Jul', 'y': 44},
              {'x': 'Aug', 'y': 42},
              {'x': 'Sep', 'y': 70},
              {'x': 'Oct', 'y': 65},
              {'x': 'Nov', 'y': 55},
              {'x': 'Dec', 'y': 78},
            ],
          },
          {
            'name': 'Cases Sales',
            'color': Color(0xFF01B7F9),
            'data': [
              {'x': 'Jan', 'y': 70},
              {'x': 'Fed', 'y': 30},
              {'x': 'Mar', 'y': 66},
              {'x': 'Apr', 'y': 44},
              {'x': 'May', 'y': 55},
              {'x': 'Jun', 'y': 51},
              {'x': 'Jul', 'y': 44},
              {'x': 'Aug', 'y': 30},
              {'x': 'Sep', 'y': 100},
              {'x': 'Oct', 'y': 87},
              {'x': 'Nov', 'y': 77},
              {'x': 'Dec', 'y': 20},
            ],
          },
        ],
      ),
    );
  }

  final List<Map<String, dynamic>> datas = const [
    {
      'imageAsset': 'assets/crm/airbnb.png',
      'title': 'Airbnb',
      'desc': 'Travel and tourism',
      'price': '\$33.2k',
      'percent': '37%',
      'isGrow': true,
      'engagementColor': CrmColors.secondary,
      'engagementPercent': 55,
    },
    {
      'imageAsset': 'assets/crm/mailchimp.png',
      'title': 'MailChimp',
      'desc': 'Email Marketing Company',
      'price': '\$3.2k',
      'percent': '23%',
      'isGrow': false,
      'engagementColor': CrmColors.red,
      'engagementPercent': 15,
    },
    {
      'imageAsset': 'assets/crm/hubspot.png',
      'title': 'Hubspot',
      'desc': 'CRM Software',
      'price': '\$50.2k',
      'percent': '45%',
      'isGrow': true,
      'engagementColor': CrmColors.orange,
      'engagementPercent': 75,
    },
  ];

  Widget _topToolsWidget() {
    List<Widget> widgets = [];
    for (int i = 0; i < datas.length; i++) {
      dynamic item = datas[i];
      widgets.add(
        CardDataWidget(
          imageAsset: item['imageAsset'],
          title: item['title'],
          desc: item['desc'],
          price: item['price'],
          percent: item['percent'],
          isGrow: item['isGrow'],
          engagementColor: item['engagementColor'],
          engagementPercent: item['engagementPercent'],
        ),
      );
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [Wrap(children: widgets, spacing: 20, runSpacing: 20)],
    );
  }

  Widget _topToolsWidgetDesk() {
    List<Widget> widgets = [];
    for (int i = 0; i < datas.length; i++) {
      dynamic item = datas[i];
      widgets.add(
        Expanded(
          child: Container(
            child: CardDataWidget(
              imageAsset: item['imageAsset'],
              title: item['title'],
              desc: item['desc'],
              price: item['price'],
              percent: item['percent'],
              isGrow: item['isGrow'],
              engagementColor: item['engagementColor'],
              engagementPercent: item['engagementPercent'],
            ),
          ),
        ),
      );
      if (i < datas.length - 1) {
        widgets.add(SizedBox(width: 20));
      }
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [Row(children: widgets)],
    );
  }
}
