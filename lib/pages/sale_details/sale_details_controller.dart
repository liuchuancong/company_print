import 'dart:io';
import 'dart:developer';
import 'package:pdf/pdf.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:date_format/date_format.dart';
import 'package:company_print/utils/utils.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:company_print/common/index.dart';
import 'package:path_provider/path_provider.dart';
import 'package:chinese_number/chinese_number.dart';
import 'package:company_print/utils/event_bus.dart';
import 'package:company_print/utils/snackbar_util.dart';
import 'package:company_print/pages/pdf_view/pdf_view.dart';
import 'package:company_print/utils/file_recover_utils.dart';
import 'package:flutter_media_store/flutter_media_store.dart';
import 'package:company_print/database/models/sales_order.dart';
import 'package:company_print/pages/dishes/dishes_controller.dart';
import 'package:company_print/pages/sale_details/sale_details_page.dart';
import 'package:company_print/pages/sale_details/mutiple_order_items.dart';

enum DishesSelectType {
  dishes,
  customer,
}

class SaleDetailsController extends GetxController {
  SaleDetailsController(this.orderId);

  final int orderId;
  final AppDatabase database = DatabaseManager.instance.appDatabase;
  final List<OrderItem> orderItems = <OrderItem>[].obs;
  var isLoading = false.obs; // 加载状态标记
  var totalSaleDetails = 0.obs;
  DishesSelectType dishesSelectType = DishesSelectType.dishes;
  var rowsPerPage = PaginatedDataTable.defaultRowsPerPage.obs;
  var currentPage = 0.obs;
  var sortAscending = false.obs;
  var sortColumnIndex = 1.obs;
  var initialRow = 0.obs;
  var nodes = <CategoryTreeNode>[].obs;
  var dishUtils = <DishUnit>[].obs;
  final PaginatorController paginatorController = PaginatorController();
  SaleDetailsDataSource? dataSource;

  var getTotalOrderPrice = '0'.obs;
  var getAdvancePayment = '0'.obs;
  var getOrderCount = '0'.obs;

  int printSelected = 3;
  var salesOrderCalculationType = SalesOrderCalculationType.round.obs;
  @override
  void onInit() {
    super.onInit();
    dataSource = SaleDetailsDataSource(this);
    getOrderDetetail();
    checkPrint();
  }

  String getSortName() {
    final sortNames = [
      '',
      'itemName',
      'totalPrice',
      'advancePayment',
      'purchaseQuantity',
      'presetPrice',
      'purchaseUnit',
      'actualQuantity',
      'actualPrice',
      'actualUnit',
      'itemShortName',
      // 如果有其他需要排序的字段，可以继续添加
    ];
    return sortNames[sortColumnIndex.value];
  }

  checkPrint() {
    final controller = Get.find<SettingsService>();
    if (controller.printTitle.isEmpty) {
      log('打印标题为空，请到设置中设置打印标题', name: 'checkPrint');
      SmartDialog.showToast('如需打印，请到设置中设置打印标题', displayTime: const Duration(seconds: 3));
    }
  }

  Future<void> loadData(int pageIndex) async {
    isLoading(true);
    final offset = currentPage.value * rowsPerPage.value;
    try {
      final results = await database.orderItemsDao.getPaginatedOrderItemsByOrderId(
        orderId,
        offset,
        rowsPerPage.value,
        orderByField: getSortName(),
        ascending: sortAscending.value,
      );
      orderItems.assignAll(results);
    } catch (e) {
      log(e.toString(), name: 'loadData');
    }
    isLoading(false);
  }

  Future<void> loadTotalData() async {
    isLoading(true);
    try {
      final count = await database.orderItemsDao.getAllOrderItemsByOrderId(orderId);
      totalSaleDetails.value = count.length;
    } catch (e) {
      log(e.toString(), name: 'loadTotalData');
    }
    isLoading(false);
  }

  sort(int columnIndex, bool ascending) {
    sortAscending(ascending);
    sortColumnIndex(columnIndex);
    dataSource?.sort();
  }

  void handlePageChanged(int? rowIndex) {
    if (rowIndex != null) {
      final newPageIndex = rowIndex ~/ rowsPerPage.value; // 将行索引转换为页码
      loadData(newPageIndex);
    }
  }

  void handleRowsPerPageChanged(int? newValue) {
    if (newValue != null) {
      rowsPerPage(newValue);
      dataSource?.refreshDatasource();
    }
  }

  void showPreviewOrderDialog(OrderItem customer) {
    Utils.showMapAlertDialog({
      '商品名称': customer.itemName!,
      '商品简介': customer.itemShortName ?? '',
      '购买数量': customer.purchaseQuantity.toString(),
      '购买单价': customer.presetPrice.toString(),
      '购买单位': customer.purchaseUnit.toString(),
      '实际数量': customer.actualQuantity.toString(),
      '实际单价': customer.actualPrice.toString(),
      '实际单位': customer.actualUnit ?? '',
      '创建时间': formatDate(customer.createdAt, [yyyy, '-', mm, '-', dd, ' ', HH, ':', nn, ':', ss]),
    });
  }

  void showCreateOrderDialog() {
    Get.to(() => EditOrderItemsPage(
          controller: this,
          onConfirm: (orderItem) async {
            await addOrderOrderItem(orderItem);
            setOrderCalculationType(salesOrderCalculationType.value.index);
          },
        ));
  }

  void showMutipleOrderItemPage() {
    dishesSelectType = DishesSelectType.dishes;
    Get.to(() => MutipleOrderItemPage(
        controller: this,
        onConfirm: (List<OrderItem> newOrderItems) {
          handleMutipleOrderItem(newOrderItems);
        }));
  }

  void showMutipleCustomerOrderItemPage() {
    dishesSelectType = DishesSelectType.customer;
    Get.to(() => MutipleOrderItemPage(
        controller: this,
        onConfirm: (List<OrderItem> newOrderItems) {
          handleMutipleOrderItem(newOrderItems);
        }));
  }

  void handleMutipleOrderItem(List<OrderItem> newOrderItems) async {
    dishesSelectType = DishesSelectType.dishes;
    for (var orderItem in newOrderItems) {
      await addOrderOrderItem(orderItem);
    }
    setOrderCalculationType(salesOrderCalculationType.value.index);
  }

  void showEditOrderDialog(OrderItem customerOrderItem) {
    Get.to(() => EditOrderItemsPage(
          controller: this,
          orderItem: customerOrderItem,
          onConfirm: (orderItem) async {
            await updateOrderOrderItem(orderItem);
          },
        ));
  }

  Future<void> addOrderOrderItem(OrderItem order) async {
    await database.orderItemsDao.insertOrderItem(order);
  }

  Future<void> updateOrderOrderItem(OrderItem order) async {
    await database.orderItemsDao.updateOrderItem(order);
    setOrderCalculationType(salesOrderCalculationType.value.index);
  }

  void showDeleteOrderOrderDialog(int id) async {
    var result = await Utils.showAlertDialog("确定要删除吗？", title: "删除");
    if (result == true) {
      deleteOrderOrderItem(id);
    }
  }

  Future<void> deleteOrderOrderItem(int id) async {
    await database.orderItemsDao.deleteOrderItem(id);
    setOrderCalculationType(salesOrderCalculationType.value.index);
  }

  Future<void> setOrderCalculationType(int index) async {
    if (index == 0) {
      salesOrderCalculationType.value = SalesOrderCalculationType.round;
    } else {
      salesOrderCalculationType.value = SalesOrderCalculationType.decimal;
    }
    await database.orderItemsDao.updateAllOrderOrderPrice(orderId, salesOrderCalculationType.value);
    dataSource?.refreshDatasource();
    EventBus.instance.emit('refreshOrderList', true);
    getOrderDetetail();
  }

  void getOrderDetetail() async {
    final getTotalOrderPriceResult = await database.orderItemsDao.getTotalOrderPrice(orderId);
    final getAdvancePaymentResult = await database.orderItemsDao.getAdvancePayment(orderId);
    final getOrderCountResult = await database.orderItemsDao.getItemCount(orderId);
    if (salesOrderCalculationType.value == SalesOrderCalculationType.round) {
      getTotalOrderPrice.value = Utils.getDoubleStringRound(getTotalOrderPriceResult);
      getAdvancePayment.value = Utils.getDoubleStringRound(getAdvancePaymentResult);
    } else {
      getTotalOrderPrice.value = Utils.getDoubleStringDecimal(getTotalOrderPriceResult);
      getAdvancePayment.value = Utils.getDoubleStringDecimal(getAdvancePaymentResult);
    }
    getOrderCount.value = Utils.getDoubleStringRound(getOrderCountResult);
  }

  String getOrderCalculationType(dynamic price) {
    if (salesOrderCalculationType.value == SalesOrderCalculationType.round) {
      return Utils.getDoubleStringRound(price);
    } else {
      return Utils.getDoubleStringDecimal(price);
    }
  }

  Future<bool> getPermission() async {
    if (Platform.isWindows) {
      return true;
    }
    final result = await FileRecoverUtils().requestStoragePermission();
    if (!result) {
      SnackBarUtil.error('请先授予读写文件权限');
    }
    return result;
  }

  /// Save file to MediaStore
  Future<void> saveFile({
    required Uint8List fileData,
    required String rootFolderName,
    required String folderName,
    required String fileName,
  }) async {
    final flutterMediaStorePlugin = FlutterMediaStore();
    try {
      // Save the file using the plugin and handle success/error via callbacks
      await flutterMediaStorePlugin.saveFile(
        fileData: fileData,
        mimeType: 'application/pdf',
        rootFolderName: rootFolderName,
        folderName: folderName,
        fileName: fileName,
        onSuccess: (String uri, String filePath) {
          Get.to(() => PdfView(
                path: filePath,
              ));

          SnackBarUtil.success('文件已保存到$filePath');
        },
        onError: (String error) {
          SnackBarUtil.error('文件保存失败: $error');
        },
      );
    } catch (e) {
      log(e.toString(), name: 'saveFile');
      SnackBarUtil.error('文件保存失败');
    }
  }

  Future<void> generateAndPrintPdf() async {
    try {
      final List<OrderItem> products = await database.orderItemsDao.getAllOrderItemsByOrderId(orderId);
      final order = await database.ordersDao.getOrderById(orderId);
      final settings = Get.find<SettingsService>();
      if (settings.printTitle.value.isEmpty) {
        SmartDialog.showToast("请先设置打印标题");
        return;
      }
      if (products.isEmpty) {
        SmartDialog.showToast("请选择商品");
        return;
      }
      if (order != null) {
        final fontData = await rootBundle.load('assets/fonts/NotoSansSC-Regular.ttf');
        final ttf = pw.Font.ttf(fontData);
        final pdf = pw.Document(pageMode: PdfPageMode.outlines);

        // 每页的最大商品数量
        const itemsPerPage = 20; // 根据实际页面尺寸调整此值

        // 分页商品列表
        for (var i = 0; i < products.length; i += itemsPerPage) {
          final pageProducts =
              products.sublist(i, i + itemsPerPage > products.length ? products.length : i + itemsPerPage);
          pdf.addPage(pw.MultiPage(
            pageTheme: pw.PageTheme(
              pageFormat: PdfPageFormat.a4.copyWith(
                marginBottom: 12,
                marginLeft: 20,
                marginRight: 20,
                marginTop: 20,
              ),
              orientation: pw.PageOrientation.portrait,
              theme: pw.ThemeData.withFont(
                base: ttf,
                bold: ttf,
              ),
            ),
            build: (pw.Context context) => <pw.Widget>[
              pw.Center(
                child: pw.Text(
                  settings.printTitle.value,
                  style: pw.TextStyle(
                    fontSize: 15,
                    font: ttf,
                    fontWeight: pw.FontWeight.bold,
                    decoration: pw.TextDecoration.none,
                  ),
                ),
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.end,
                children: [
                  pw.Text(
                    "录单日期：${formatDate(DateTime.now(), [yyyy, '-', mm, '-', dd])}",
                    style: pw.TextStyle(
                      fontSize: 13,
                      font: ttf,
                      fontWeight: pw.FontWeight.bold,
                      decoration: pw.TextDecoration.none,
                    ),
                  ),
                ],
              ),
              if (settings.printIsShowCustomerInfo.value)
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.start,
                  children: [
                    pw.Expanded(
                      flex: 1, // 设置 flex 为 1 表示占据一半宽度
                      child: pw.Container(
                        child: pw.Text("购买单位：${order.customerName}", style: const pw.TextStyle(fontSize: 12)),
                      ),
                    ),
                    pw.Expanded(
                      flex: 1, // 设置 flex 为 1 表示占据一半宽度
                      child: pw.Container(
                        child: pw.Text("电话：${order.customerPhone}", style: const pw.TextStyle(fontSize: 12)),
                      ),
                    ),
                  ],
                ),
              if (settings.printIsShowCustomerInfo.value) pw.Padding(padding: const pw.EdgeInsets.all(2)),
              if (settings.printIsShowCustomerInfo.value)
                pw.Text(
                  "地址：${order.customerAddress}",
                  style: pw.TextStyle(
                    fontSize: 12,
                    font: ttf,
                  ),
                ),
              if (settings.printIsShowDriverInfo.value) pw.Padding(padding: const pw.EdgeInsets.all(2)),
              if (settings.printIsShowDriverInfo.value)
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.start,
                  children: [
                    pw.Expanded(
                      flex: 2, // 设置 flex 为 1 表示占据一半宽度
                      child: pw.Container(
                        child: pw.Text("司机：${order.driverName}", style: const pw.TextStyle(fontSize: 12)),
                      ),
                    ),
                    pw.Expanded(
                      flex: 2, // 设置 flex 为 1 表示占据一半宽度
                      child: pw.Container(
                        child: pw.Text("电话：${order.driverPhone}", style: const pw.TextStyle(fontSize: 12)),
                      ),
                    ),
                    pw.Expanded(
                      flex: 2, // 设置 flex 为 1 表示占据一半宽度
                      child: pw.Container(
                        child: pw.Text("车牌号：${order.vehiclePlateNumber}", style: const pw.TextStyle(fontSize: 12)),
                      ),
                    ),
                  ],
                ),
              if (settings.printIsShowPriceInfo.value) pw.Padding(padding: const pw.EdgeInsets.all(2)),
              if (settings.printIsShowPriceInfo.value)
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.start,
                  children: [
                    pw.Expanded(
                      flex: 1, // 设置 flex 为 1 表示占据一半宽度
                      child: pw.Container(
                        child: pw.Text("合计: ${getTotalOrderPrice.value} 元", style: const pw.TextStyle(fontSize: 12)),
                      ),
                    ),
                    pw.Expanded(
                      flex: 2, // 设置 flex 为 1 表示占据一半宽度
                      child: pw.Container(
                        child: pw.Text(
                            "大写：${int.parse(getTotalOrderPrice.value) == 0 ? '零圆整' : double.parse(getTotalOrderPrice.value).toSimplifiedChineseNumber()}元",
                            style: const pw.TextStyle(fontSize: 12)),
                      ),
                    ),
                  ],
                ),
              pw.Padding(padding: const pw.EdgeInsets.all(2)),
              pw.TableHelper.fromTextArray(
                headers: ['序号', '商品名称', '数量', '单价', '总价', '备注'],
                data: List.generate(pageProducts.length, (index) {
                  final product = pageProducts[index];
                  // 计算全局序号（基于整个列表）
                  final globalIndex = i + index + 1;
                  return [
                    globalIndex.toString(),
                    product.itemName,
                    product.actualQuantity,
                    Utils.concatenation(product.actualPrice, product.actualUnit),
                    getOrderCalculationType(product.totalPrice),
                    product.itemShortName,
                  ];
                }),
                headerStyle: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold, font: ttf),
                cellStyle: pw.TextStyle(fontSize: 10, font: ttf),
                cellPadding: const pw.EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                columnWidths: {
                  0: const pw.FlexColumnWidth(1),
                  1: const pw.FlexColumnWidth(2),
                  2: const pw.FlexColumnWidth(1),
                  3: const pw.FlexColumnWidth(2),
                  4: const pw.FlexColumnWidth(2),
                  5: const pw.FlexColumnWidth(3),
                },
                cellAlignments: {
                  0: pw.Alignment.center,
                  1: pw.Alignment.centerLeft,
                  2: pw.Alignment.center,
                  3: pw.Alignment.center,
                  4: pw.Alignment.center,
                  5: pw.Alignment.center,
                },
              ),
            ],
            footer: (pw.Context context) {
              if (!settings.printIsShowOwnerInfo.value) {
                return pw.Container(
                  alignment: pw.Alignment.centerRight,
                  child: pw.Text('第${context.pageNumber}页，共${context.pagesCount}页',
                      style: const pw.TextStyle(fontSize: 12)),
                );
              }
              return pw.Container(
                margin: const pw.EdgeInsets.only(top: 10),
                child: pw.Column(children: [
                  pw.Row(
                    children: [
                      pw.Container(
                        child: pw.Text("店面地址：${settings.myAddress}", style: const pw.TextStyle(fontSize: 12)),
                      )
                    ],
                  ),
                  pw.Row(
                    children: [
                      pw.Expanded(
                        flex: 3, // 设置 flex 为 1 表示占据一半宽度
                        child: pw.Container(
                          child: pw.Text("电话：${settings.myPhone}", style: const pw.TextStyle(fontSize: 12)),
                        ),
                      ),
                      pw.Expanded(
                        flex: 3, // 设置 flex 为 1 表示占据一半宽度
                        child: pw.Container(
                          child: pw.Text("联系人：${settings.myName}", style: const pw.TextStyle(fontSize: 12)),
                        ),
                      ),
                      pw.Expanded(
                        flex: 2, // 设置 flex 为 1 表示占据一半宽度
                        child: pw.Container(
                          alignment: pw.Alignment.centerRight,
                          child: pw.Text('第${context.pageNumber}页，共${context.pagesCount}页',
                              style: const pw.TextStyle(fontSize: 12)),
                        ),
                      ),
                    ],
                  )
                ]),
              );
            },
          ));
        }

        final DateFormat formatter = DateFormat("yyyy'年'MM'月'dd'日'HH'点'");
        final DateFormat dirFormatter = DateFormat("yyyy'年'MM'月'dd'日'");

        final dateStr = formatter.format(DateTime.now());
        Uint8List bytes = await pdf.save();
        if (printSelected == 1) {
          await Printing.sharePdf(bytes: bytes, filename: '${order.customerName}.pdf');
        } else if (printSelected == 0) {
          try {
            Directory? downloadsDir;
            final settings = Get.find<SettingsService>();
            if (settings.backupDirectory.value.isNotEmpty) {
              downloadsDir = Directory(settings.backupDirectory.value);
            } else {
              downloadsDir = await getDownloadsDirectory();
            }
            final file = File(
                '${downloadsDir?.path}${Platform.pathSeparator}${dirFormatter.format(DateTime.now())}${order.customerName}.pdf');

            if (Platform.isAndroid) {
              saveFile(
                fileData: bytes,
                rootFolderName: '小柳打印',
                folderName: dirFormatter.format(DateTime.now()),
                fileName: '${order.customerName}_$dateStr.pdf',
              );
            } else {
              await file.writeAsBytes(bytes);
              Get.to(() => PdfView(
                    path: file.path,
                  ));

              SnackBarUtil.success('文件已保存到${downloadsDir?.path}');
            }
          } catch (e) {
            SnackBarUtil.error('error: $e');
          }
        }
      }
    } catch (e) {
      log(e.toString(), name: 'generateAndPrintPdf');
    }
  }

  void showPreferResolutionSelectorDialog() async {
    final hasPermission = await getPermission();
    if (!hasPermission) {
      return;
    }
    printSelected = 3;
    showDialog(
      context: Get.context!,
      builder: (BuildContext context) {
        return SimpleDialog(title: const Text('打印'), children: [
          RadioListTile<dynamic>(
            activeColor: Theme.of(context).colorScheme.primary,
            groupValue: printSelected,
            value: 0,
            title: const Text('保存并预览'),
            onChanged: (value) {
              printSelected = 0;
              generateAndPrintPdf();
              Navigator.pop(context);
            },
          ),
          RadioListTile<dynamic>(
            activeColor: Theme.of(context).colorScheme.primary,
            groupValue: printSelected,
            value: 1,
            title: const Text('打印'),
            onChanged: (value) {
              printSelected = 1;
              generateAndPrintPdf();
              Navigator.pop(context);
            },
          ),
        ]);
      },
    );
  }
}
