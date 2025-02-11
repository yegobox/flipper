import 'package:flutter/material.dart';

// Models
class DeliveryTask {
  final String id;
  final String pickupName;
  final String pickupAddress;
  final String customerName;
  final String customerAddress;

  DeliveryTask({
    required this.id,
    required this.pickupName,
    required this.pickupAddress,
    required this.customerName,
    required this.customerAddress,
  });
}

class DeliveryDriverApp extends StatelessWidget {
  const DeliveryDriverApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Delivery Driver App',
      theme: ThemeData(
        primaryColor: Colors.black,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      home: const DriverHome(),
    );
  }
}

class DriverHome extends StatefulWidget {
  const DriverHome({Key? key}) : super(key: key);

  @override
  State<DriverHome> createState() => _DriverHomeState();
}

class _DriverHomeState extends State<DriverHome> {
  bool isOnline = false;
  List<DeliveryTask> upcomingDeliveries = [
    DeliveryTask(
      id: '1',
      pickupName: 'Electronics Store',
      pickupAddress: '123 Main St',
      customerName: 'John Doe',
      customerAddress: '456 Oak Ave',
    ),
    DeliveryTask(
      id: '2',
      pickupName: 'Book Store',
      pickupAddress: '789 Pine St',
      customerName: 'Jane Smith',
      customerAddress: '321 Elm St',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildStatusBar(),
            Expanded(
              child: isOnline ? _buildDeliveryQueue() : const OfflineScreen(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.grey[200],
            child: Icon(Icons.person, color: Colors.grey[600]),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'John Driver',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  isOnline ? 'Online' : 'Offline',
                  style: TextStyle(
                    color: isOnline ? Colors.green : Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: isOnline,
            onChanged: (value) {
              setState(() => isOnline = value);
            },
            activeColor: Colors.green,
          ),
        ],
      ),
    );
  }

  Widget _buildDeliveryQueue() {
    return Column(
      children: [
        _buildCurrentDelivery(),
        Expanded(child: _buildUpcomingDeliveries()),
      ],
    );
  }

  Widget _buildCurrentDelivery() {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Row(
              children: [
                const Icon(Icons.access_time, color: Colors.blue),
                const SizedBox(width: 8),
                Text(
                  'Current Pickup',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[900],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildLocationRow(
                  icon: Icons.store,
                  title: upcomingDeliveries[0].pickupName,
                  subtitle: upcomingDeliveries[0].pickupAddress,
                  isPickup: true,
                ),
                const SizedBox(height: 16),
                _buildLocationRow(
                  icon: Icons.location_on,
                  title: upcomingDeliveries[0].customerName,
                  subtitle: upcomingDeliveries[0].customerAddress,
                  isPickup: false,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('Confirm Pickup'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationRow({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isPickup,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isPickup ? Colors.blue[50] : Colors.green[50],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: isPickup ? Colors.blue : Colors.green,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                subtitle,
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildUpcomingDeliveries() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Upcoming Deliveries',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              itemCount:
                  upcomingDeliveries.length - 1, // Excluding current delivery
              itemBuilder: (context, index) {
                final delivery = upcomingDeliveries[index + 1];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    title: Text(
                      'Order #${delivery.id}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        Text('Pickup: ${delivery.pickupName}'),
                        Text('Deliver to: ${delivery.customerName}'),
                      ],
                    ),
                    trailing: const Icon(Icons.chevron_right),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class OfflineScreen extends StatelessWidget {
  const OfflineScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.delivery_dining,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          const Text(
            'You are offline',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Go online to start receiving deliveries',
            style: TextStyle(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}
