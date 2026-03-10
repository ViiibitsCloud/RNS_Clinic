

import 'package:clinic_web/screens/Admin/clinic_settings_screen.dart';
import 'package:clinic_web/screens/Admin/manage_appointment_screen.dart';
import 'package:clinic_web/screens/Admin/manage_camp_screen.dart';
import 'package:clinic_web/screens/Admin/manage_news.dart';
import 'package:clinic_web/screens/Admin/manage_order_screen.dart';
import 'package:clinic_web/screens/Admin/manage_products_screen.dart';
import 'package:clinic_web/screens/Admin/manage_slots.dart';
import 'package:clinic_web/screens/profile_screen.dart';
import 'package:clinic_web/widgets/admin_layout.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  final List<String> _titles = [
    'Overview',
    'Manage Appointments',
    'Manage News',
    'Manage Camps',
    'Manage Products',
    'Manage Orders',
    'Clinic Settings',
    'Manage Slots',
    'Profile',
  ];

  final List<Widget> _screens = [
    const OverviewTab(),
    const AdminAppointments(),
    const ManageNews(),
    const ManageCamps(),
    // const ManageProducts(),
    const ManageOrders(),
    const ManageClinicSettings(),
      const ManageSlots(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return AdminLayout(
      title: _titles[_selectedIndex],
      selectedIndex: _selectedIndex,
      onItemSelected: (index) {
        setState(() => _selectedIndex = index);
      },
      child: _screens[_selectedIndex],
    );
  }
}

class OverviewTab extends StatelessWidget {
  const OverviewTab({super.key});

  Future<int> _countCollection(String collection) async {
    final snapshot =
        await FirebaseFirestore.instance.collection(collection).get();
    return snapshot.docs.length;
  }

  Widget _statCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withOpacity(.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: color.withOpacity(.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildStats() {
    return FutureBuilder(
      future: Future.wait([
        FirebaseFirestore.instance.collection('appointments').get(),
        FirebaseFirestore.instance.collection('products').get(),
        FirebaseFirestore.instance.collection('orders').get(),
        FirebaseFirestore.instance.collection('camps').get(),
      ]),
      builder: (context, AsyncSnapshot<List<QuerySnapshot>> snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final appointments = snapshot.data![0].docs.length;
        final products = snapshot.data![1].docs.length;
        final orders = snapshot.data![2].docs.length;
        final camps = snapshot.data![3].docs.length;

        return GridView.count(
          crossAxisCount: 4,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            _statCard(
              title: "Appointments",
              value: appointments.toString(),
              icon: Icons.calendar_today,
              color: Colors.blue,
            ),
            _statCard(
              title: "Products",
              value: products.toString(),
              icon: Icons.inventory,
              color: Colors.green,
            ),
            _statCard(
              title: "Orders",
              value: orders.toString(),
              icon: Icons.shopping_cart,
              color: Colors.orange,
            ),
            _statCard(
              title: "Health Camps",
              value: camps.toString(),
              icon: Icons.local_hospital,
              color: Colors.purple,
            ),
          ],
        );
      },
    );
  }

  Widget _recentAppointments() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('appointments')
          .orderBy('date', descending: true)
          .limit(5)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final appointments = snapshot.data!.docs;

        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                blurRadius: 10,
                color: Colors.black.withOpacity(.05),
                offset: const Offset(0, 5),
              )
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Recent Appointments",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ListView.builder(
                shrinkWrap: true,
                itemCount: appointments.length,
                itemBuilder: (context, index) {
                  final data =
                      appointments[index].data() as Map<String, dynamic>;

                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.blue.shade100,
                      child: Text(
                        (data['name'] ?? "U")[0],
                        style: const TextStyle(color: Colors.blue),
                      ),
                    ),
                    title: Text(data['name'] ?? "Unknown"),
                    subtitle: Text(
                        "${data['issue'] ?? ''} • ${data['timeSlot'] ?? ''}"),
                    trailing: Chip(
                      label: Text(
                        data['status'] ?? 'pending',
                        style: const TextStyle(color: Colors.white),
                      ),
                      backgroundColor: data['status'] == 'accepted'
                          ? Colors.green
                          : data['status'] == 'rejected'
                              ? Colors.red
                              : Colors.orange,
                    ),
                  );
                },
              )
            ],
          ),
        );
      },
    );
  }

  Widget _clinicInfoCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
              blurRadius: 10,
              color: Colors.black.withOpacity(.05),
              offset: const Offset(0, 5))
        ],
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Clinic Overview",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          SizedBox(height: 16),
          Text("Welcome to the Clinic Admin Dashboard."),
          SizedBox(height: 10),
          Text("Here you can manage appointments, camps, products, orders and news."),
          SizedBox(height: 10),
          Text("Use the sidebar to navigate through different management modules."),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Dashboard Overview",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 30),

          _buildStats(),

          const SizedBox(height: 30),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 3, child: _recentAppointments()),
              const SizedBox(width: 20),
              Expanded(flex: 2, child: _clinicInfoCard()),
            ],
          )
        ],
      ),
    );
  }
}