import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';
import 'package:company_print/database/db.dart';

class CardOrder extends StatelessWidget {
  const CardOrder({
    super.key,
    required this.order,
    required this.index,
    required this.onEdit,
    required this.onDelete,
    required this.onTap,
    required this.complete,
  });
  final Order order;
  final int index;
  final Function(Order) onEdit;
  final Function(Order) onDelete;
  final Function(Order) onTap;
  final Function(Order) complete;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap(order);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white, // 背景颜色
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2), // 阴影颜色
              spreadRadius: 2, // 扩展半径
              blurRadius: 7, // 模糊半径
              offset: const Offset(0, 1), // 偏移量 (x, y)
            ),
          ],
          borderRadius: BorderRadius.circular(10), // 圆角
        ),
        child: Card(
          elevation: 1,
          margin: const EdgeInsets.all(0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                children: [
                  Positioned(
                    left: 4,
                    top: 8,
                    child: OrderChip(
                      icon: Icons.monetization_on_outlined,
                      count: '${index + 1}',
                    ),
                  ),
                  Positioned(
                    right: 4,
                    top: 8,
                    child: GestureDetector(
                      onTap: () => complete(order),
                      child: CountChip(
                        icon: Icons.monetization_on_outlined,
                        count: order.isPaid ? '已结算' : '未结算',
                        isPaid: order.isPaid,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 50),
                    height: 260,
                    child: Column(
                      children: [
                        Divider(
                          color: Theme.of(context).primaryColor.withAlpha(50),
                        ),
                        Expanded(
                          child: ListTile(
                            dense: true,
                            contentPadding: const EdgeInsets.only(left: 8, right: 10),
                            title: Text(
                              '客户名称: ${order.customerName!}',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            subtitle: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '备注: ${order.remark}',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  '司机: ${order.driverName}',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  '创建时间: ${formatDate(order.createdAt, [
                                        yyyy,
                                        '-',
                                        mm,
                                        '-',
                                        dd,
                                        ' ',
                                        HH,
                                        ':',
                                        nn,
                                        ':',
                                        ss
                                      ])}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                '合计: ${order.totalPrice} 元',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Expanded(
                                  child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  FilledButton(
                                    onPressed: () {
                                      onDelete(order);
                                    },
                                    style: ButtonStyle(
                                      backgroundColor: WidgetStateProperty.all(Colors.red),
                                    ),
                                    child: const Text('删除'),
                                  ),
                                  const SizedBox(width: 10),
                                  FilledButton(
                                    onPressed: () {
                                      onEdit(order);
                                    },
                                    child: const Text('编辑'),
                                  ),
                                ],
                              )),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class CountChip extends StatelessWidget {
  const CountChip({
    super.key,
    required this.icon,
    required this.count,
    this.isPaid = false,
    this.color = Colors.black,
  });

  final IconData icon;
  final String count;
  final bool isPaid;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: const StadiumBorder(),
      color: isPaid ? Colors.red.withValues(alpha: 0.8) : color.withValues(alpha: 0.8),
      shadowColor: Colors.transparent,
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.only(left: 8, right: 8, top: 3, bottom: 3),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: Colors.white.withValues(alpha: 0.8),
              size: 16,
            ),
            Text(
              count,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontSize: 15,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class OrderChip extends StatelessWidget {
  const OrderChip({
    super.key,
    required this.icon,
    required this.count,
    this.color = Colors.black,
  });

  final IconData icon;
  final String count;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Theme.of(context).primaryColor,
      child: Text(
        count,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.white.withValues(alpha: 0.8),
              fontSize: 15,
            ),
      ),
    );
  }
}
