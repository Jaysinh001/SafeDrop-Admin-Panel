import 'package:safedropadminpanel/views/crm_layout.dart';
import 'package:safedropadminpanel/views/home/contact_list_widget.dart';
import 'package:flutter/src/widgets/framework.dart';

class PendingWithdrawalsPage extends CrmLayout {
  const PendingWithdrawalsPage({super.key});

  @override
  // TODO: implement isContentScroll
  bool get isContentScroll => false;

  @override
  String breakTabTitle(BuildContext context) {
    // TODO: implement breakTabTitle
    return 'Pending Withdrawals';
  }

  @override
  Widget contentDesktopWidget(BuildContext context) {
    return ContactListWidget(
      showTitle: false,
      showPage: true,
      json: 'assets/crm/contactlistall.json',
    );
  }
}
