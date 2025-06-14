import 'dart:convert';

import '../../../config/theme/crm_colors.dart';
import 'package:flareline_uikit/components/forms/search_widget.dart';
import 'package:flareline_uikit/components/forms/select_widget.dart';
import 'package:flareline_uikit/components/image/image_widget.dart';
import 'package:flareline_uikit/components/tables/table_widget.dart';
import 'package:flareline_uikit/entity/table_data_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:popover/popover.dart';
import 'package:responsive_builder/responsive_builder.dart';

class ContactListWidget extends TableWidget<ContactListViewModel> {
  final bool? showTitle;
  final bool? showPage;
  final String? json;

  ContactListWidget({super.key, this.showTitle, this.showPage, this.json});

  @override
  // TODO: implement showPaging
  bool get showPaging => (showPage ?? false);

  @override
  // TODO: implement showCheckboxColumn
  bool get showCheckboxColumn => false;

  @override
  // TODO: implement rowHeight
  double get rowHeight => 80;

  @override
  String? title(BuildContext context) {
    // TODO: implement title
    return (showTitle ?? true) ? 'Contact List' : null;
  }

  @override
  Widget? toolsWidget(BuildContext context, ContactListViewModel viewModel) {
    return SizedBox(
      height: 60,
      child: Row(
        children: [
          ScreenTypeLayout.builder(
            desktop:
                (context) => const SizedBox(width: 280, child: SearchWidget()),
            mobile: (context) => SizedBox.shrink(),
            tablet: (context) => SizedBox.shrink(),
          ),
          const Spacer(),
          SizedBox(
            width: 200,
            child: SelectWidget(
              selectionList: const ['Alphabetic Order', 'Shawn', 'affwaw'],
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool isColumnVisible(String columnName, bool isMobile) {
    // TODO: implement isColumnVisible
    if (!isMobile) {
      return true;
    }

    if ('First Name' == columnName || 'Action' == columnName) {
      return true;
    }
    return false;
  }

  @override
  // TODO: implement actionColumnWidth
  double get actionColumnWidth => 80;

  @override
  Widget? customWidgetsBuilder(
    BuildContext context,
    TableDataRowsTableDataRows columnData,
    ContactListViewModel viewModel,
  ) {
    if ('firstName' == columnData.columnName) {
      return Row(
        children: [
          ImageWidget(
            imageUrl: columnData.data['avatar'],
            width: 60,
            height: 60,
            isCircle: true,
          ),
          const SizedBox(width: 10),
          Text(columnData.data['name']),
        ],
      );
    }

    if ('status' == columnData.columnName) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color:
              columnData.text == 'Active'
                  ? const Color(0xFFF6FFF5)
                  : const Color(0xFFF2F6FF),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
        child: Text(
          columnData.text ?? '',
          style: TextStyle(
            color:
                columnData.text == 'Active'
                    ? CrmColors.green
                    : CrmColors.paragraph,
          ),
        ),
      );
    }
    return null;
  }

  @override
  Widget? actionWidgetsBuilder(
    BuildContext context,
    TableDataRowsTableDataRows columnData,
    ContactListViewModel viewModel,
  ) {
    return const Row(
      mainAxisSize: MainAxisSize.min,
      children: [MoreActionWidget()],
    );
  }

  @override
  ContactListViewModel viewModelBuilder(BuildContext context) {
    return ContactListViewModel(context, json);
  }
}

class MoreActionWidget extends StatelessWidget {
  const MoreActionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        width: 40,
        height: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(color: CrmColors.border, width: 1),
        ),
        child: const Icon(Icons.more_horiz, size: 20),
      ),
      onTap: () {
        showPopover(
          context: context,
          bodyBuilder: (context) => const ListItems(),
          onPop: () => print('Popover was popped!'),
          direction: PopoverDirection.left,
          width: 150,
          height: 140,
          arrowHeight: 15,
          arrowWidth: 30,
        );
      },
    );
  }
}

class ListItems extends StatelessWidget {
  const ListItems({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView(
        padding: const EdgeInsets.all(8),
        children: [
          InkWell(
            onTap: () {},
            child: Container(
              height: 50,
              color: CrmColors.green.withOpacity(0.5),
              child: const Center(child: Text('Approve')),
            ),
          ),
          const Divider(),
          InkWell(
            child: Container(
              height: 50,
              color: CrmColors.orange.withOpacity(0.5),
              child: const Center(child: Text('Reject')),
            ),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

class ContactListViewModel extends BaseTableProvider {
  String? jsonFile;

  ContactListViewModel(super.context, this.jsonFile);

  @override
  loadData(BuildContext context) async {
    String res = await rootBundle.loadString(
      jsonFile ?? 'assets/crm/contactlist.json',
    );

    Map<String, dynamic> map = json.decode(res);
    TableDataEntity tableDataEntity = TableDataEntity.fromJson(map);
    this.tableDataEntity = tableDataEntity;
  }
}
