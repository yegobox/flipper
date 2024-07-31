import 'package:flipper_models/realm_model_export.dart';
import 'package:flutter/material.dart';

class OrderItem {
  final String name;
  final int quantity;

  OrderItem({required this.name, required this.quantity});
}

class Order {
  final int id;
  final String customer;
  final List<OrderItem> items;
  final double total;
  bool isApproved;

  Order({
    required this.id,
    required this.customer,
    required this.items,
    required this.total,
    this.isApproved = false,
  });

  int get totalQuantity => items.fold(0, (sum, item) => sum + item.quantity);
}

class IncomingOrdersWidget extends StatefulWidget {
  const IncomingOrdersWidget({Key? key}) : super(key: key);

  @override
  _IncomingOrdersWidgetState createState() => _IncomingOrdersWidgetState();
}

class _IncomingOrdersWidgetState extends State<IncomingOrdersWidget> {
  final List<Order> orders = [
    Order(
        id: 1,
        customer: "Alice Johnson",
        items: [
          OrderItem(name: "Laptop", quantity: 1),
          OrderItem(name: "Mouse", quantity: 2)
        ],
        total: 1299.99),
    Order(
        id: 2,
        customer: "Bob Smith",
        items: [
          OrderItem(name: "Headphones", quantity: 1),
          OrderItem(name: "Keyboard", quantity: 1)
        ],
        total: 199.98),
    Order(
        id: 3,
        customer: "Charlie Brown",
        items: [
          OrderItem(name: "Monitor", quantity: 2),
          OrderItem(name: "Webcam", quantity: 1)
        ],
        total: 449.97),
    Order(
        id: 4,
        customer: "Diana Prince",
        items: [
          OrderItem(name: "Smartphone", quantity: 1),
          OrderItem(name: "Case", quantity: 2)
        ],
        total: 899.99),
    Order(
        id: 5,
        customer: "Ethan Hunt",
        items: [
          OrderItem(name: "Tablet", quantity: 1),
          OrderItem(name: "Stylus", quantity: 3)
        ],
        total: 599.98),
  ];

  void _approveOrder(int id) {
    setState(() {
      final orderIndex = orders.indexWhere((order) => order.id == id);
      if (orderIndex != -1) {
        orders[orderIndex].isApproved = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text('Incoming Orders',
            style:
                TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16.0),
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          return Card(
            elevation: 4,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            margin: EdgeInsets.only(bottom: 16.0),
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Order #${order.id}',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[700]),
                      ),
                      Text(
                        order.total.toRwf(),
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.green[700]),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    '${order.customer}',
                    style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                  ),
                  SizedBox(height: 12.0),
                  Text(
                    'Items:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 4.0),
                  ...order.items.map((item) => Padding(
                        padding: EdgeInsets.symmetric(vertical: 2.0),
                        child: Row(
                          children: [
                            Icon(Icons.circle,
                                size: 8, color: Colors.blue[700]),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                  '${item.name} (Qty: ${item.quantity})',
                                  style: TextStyle(fontSize: 14)),
                            ),
                          ],
                        ),
                      )),
                  SizedBox(height: 8.0),
                  Text(
                    'Total Quantity: ${order.totalQuantity}',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.blue[700]),
                  ),
                  SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: order.isApproved
                              ? Colors.green[100]
                              : Colors.orange[100],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          order.isApproved ? 'Approved' : 'Pending',
                          style: TextStyle(
                            color: order.isApproved
                                ? Colors.green[700]
                                : Colors.orange[700],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      if (!order.isApproved)
                        ElevatedButton(
                          onPressed: () => _approveOrder(order.id),
                          child: Text(
                            'Approve Order',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          style: ButtonStyle(
                            backgroundColor:
                                WidgetStateProperty.all(Colors.blue[700]),
                            foregroundColor:
                                WidgetStateProperty.all(Colors.white),
                            shape: WidgetStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                            ),
                            padding: WidgetStateProperty.all(
                              EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 12),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
