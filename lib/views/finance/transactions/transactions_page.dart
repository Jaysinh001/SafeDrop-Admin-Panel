import 'package:get/get.dart';
import 'package:safedropadminpanel/views/contacts/add_contact_page.dart';
import 'package:safedropadminpanel/views/crm_layout.dart';
import 'package:flareline_uikit/components/buttons/button_widget.dart';
import 'package:flareline_uikit/components/forms/search_widget.dart';
import 'package:flareline_uikit/components/forms/select_widget.dart';
import 'package:flareline_uikit/components/tables/table_widget.dart';
import 'package:flareline_uikit/components/tags/tag_widget.dart';
import 'package:flareline_uikit/entity/table_data_entity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:safedropadminpanel/views/finance/transactions/transactions_controller.dart';

class TransactionsPage extends CrmLayout {
  const TransactionsPage({super.key});

  @override
  // TODO: implement isContentScroll
  bool get isContentScroll => false;

  @override
  String breakTabTitle(BuildContext context) {
    // TODO: implement breakTabTitle
    return 'Transaction History';
  }

  @override
  Widget breakTabRightWidget(BuildContext context) {
    // TODO: implement rightContentWidget
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 150,
          child: SelectWidget(
            selectionList: const ['This Month', 'This Week', 'This Year'],
          ),
        ),
        const SizedBox(width: 20),
        SizedBox(width: 150, child: AddContactPage()),
      ],
    );
  }

  @override
  Widget contentDesktopWidget(BuildContext context) {
    return TransactionsTableWidget();
  }
}

class TransactionsTableWidget extends TableWidget<TransactionsViewModel> {
  TransactionsTableWidget({super.key});

  final controller = Get.put(TransactionsController());

  @override
  // TODO: implement showCheckboxColumn
  bool get showCheckboxColumn => false;
  // bool get showCheckboxColumn => true;

  @override
  Widget toolsWidget(BuildContext context, TransactionsViewModel viewModel) {
    return SizedBox(
      height: 50,
      child: Row(
        children: [
          ScreenTypeLayout.builder(
            desktop:
                (context) => const SizedBox(width: 280, child: SearchWidget()),
            mobile: (context) => SizedBox.shrink(),
            tablet: (context) => SizedBox.shrink(),
          ),
          const Spacer(),
          _pageWidget(context, viewModel),
        ],
      ),
    );
  }

  @override
  bool isColumnVisible(String columnName, bool isMobile) {
    if (!isMobile) {
      return true;
    }
    if (isMobile) {
      if ('Student Name' == columnName || 'Status' == columnName) {
        return true;
      }
    }
    return false;
  }

  @override
  Widget? customWidgetsBuilder(
    BuildContext context,
    TableDataRowsTableDataRows columnData,
    TransactionsViewModel viewModel,
  ) {
    if (columnData.columnName == 'status') {
      return Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            decoration: BoxDecoration(
              color: const Color(0xFFF6FFF5),
              borderRadius: BorderRadius.circular(4),
            ),
            child: TagWidget(
              color: const Color(0xFF5ABE1C),
              text: columnData.text ?? '',
            ),
          ),
        ],
      );
    }
    return null;
  }

  _pageWidget(BuildContext context, TransactionsViewModel viewModel) {
    return Row(
      children: [
        const Text('Showing'),
        const SizedBox(width: 5),
        SizedBox(
          width: 80,
          height: 30,
          child: SelectWidget(
            selectionList: const ['10', '20', '50'],
            onDropdownChanged: (value) {
              viewModel.pageSize = int.parse(value);
            },
          ),
        ),
        const SizedBox(width: 5),
        const Text('of'),
        const SizedBox(width: 5),
        Text(
          '${controller.noOfEntries}',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 5),
        const Text('of'),
        const SizedBox(width: 5),
        const Text('Results'),
      ],
    );
  }

  @override
  TransactionsViewModel viewModelBuilder(BuildContext context) {
    return TransactionsViewModel(context);
  }
}

class TransactionsViewModel extends BaseTableProvider {
  @override
  String get TAG => 'TransactionsViewModel';

  final controller = Get.put(TransactionsController());

  TransactionsViewModel(super.context);

  @override
  Future loadData(BuildContext context) async {
    final response = await controller.getTransectionHistory();

    //column names
    const headers = [
      "Student Name",
      "Transaction Id",
      "Amount",
      // "Phone No",
      "Billing Reason",
      "Status",
    ];

    List rows = [];

    //can change 50 to no.of items from items(☝️)
    for (int i = 0; i < response!.length; i++) {
      List<List<Map<String, dynamic>>> list = [];

      List<Map<String, dynamic>> row = [];
      // var id = i;
      var item = {
        // replace with below item
        'studentName': response[i].studentId,
        'transactionID': response[i].transactionRef,
        'amount': response[i].amount,
        // 'phone': '(201) 555-0124',
        'billingReason': response[i].bankDetailsId,
        'status': response[i].status,
      };

      // var response = {
      //   'studentName': items.studentName,
      //   'transactionID': items.transactionID,
      //   'amount': items.amount,
      //   // 'phone': items.phone,
      //   'billingReason': items.billingReason,
      //   'status': items.status,
      // };

      row.add(getItemValue('studentName', item));
      row.add(getItemValue('transactionID', item));
      row.add(getItemValue('amount', item));
      // row.add(getItemValue('phoneNo', item));
      row.add(getItemValue('billingReason', item));
      row.add(getItemValue('status', item, dataType: CellDataType.CUSTOM.type));
      list.add(row);

      rows.addAll(list);
    }

    Map<String, dynamic> map = {'headers': headers, 'rows': rows};
    TableDataEntity data = TableDataEntity.fromJson(map);
    tableDataEntity = data;
  }
}
