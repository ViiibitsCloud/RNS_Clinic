// import 'package:clinic_web/screens/Admin/manage_appointment_screen.dart';
// import 'package:clinic_web/screens/Admin/manage_camp_screen.dart';
// import 'package:clinic_web/screens/Admin/manage_news.dart';
// import 'package:clinic_web/screens/Admin/manage_order_screen.dart';
// import 'package:clinic_web/screens/Admin/manage_products_screen.dart';
// import 'package:clinic_web/screens/profile_screen.dart';
// import 'package:clinic_web/widgets/admin_layout.dart';
// import 'package:flutter/material.dart';
// // import '../widgets/admin_layout.dart';
// // import 'add_teacher_screen.dart';
// // import 'manage_students_screen.dart';
// // import 'manage_fees_screen.dart';
// // import 'attendance_reports_screen.dart';
// // import 'announcements_screen.dart';

// class DashboardScreen extends StatefulWidget {
//   const DashboardScreen({super.key});

//   @override
//   State<DashboardScreen> createState() => _DashboardScreenState();
// }

// class _DashboardScreenState extends State<DashboardScreen> {
//   int _selectedIndex = 0;

//   final List<String> _titles = [
//     'Overview',
//     'Manage Appointments',
//     'Manage News',
//     'Manage Camps',
//     'Manage Products',
//     'Manage Orders',
//     'Manage Clinic Settings',
//     'Manage Slots',
//     'Profile',
//   ];

//   final List<Widget> _screens = [
//     const OverviewTab(),
//     const AdminAppointments(),
//     const ManageNews(),
//     const ManageCamps(),
//     const ManageProducts(),
//     const ManageOrders(),
    
//     const ProfileScreen()
    
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return AdminLayout(
//       title: _titles[_selectedIndex],
//       selectedIndex: _selectedIndex,
//       onItemSelected: (index) {
//         setState(() => _selectedIndex = index);
//       },
//       child: _screens[_selectedIndex],
//     );
//   }
// }

// class OverviewTab extends StatelessWidget {
//   const OverviewTab({super.key});

//   Widget _statCard({
//     required String title,
//     required String value,
//     required String subtitle,
//     required Color color,
//     required String percent,
//   }) {
//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: color.withOpacity(0.08),
//         borderRadius: BorderRadius.circular(18),
//         border: Border.all(color: color.withOpacity(0.2)),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(title,
//                   style: TextStyle(
//                       color: color,
//                       fontWeight: FontWeight.w600,
//                       fontSize: 14)),
//               Container(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//                 decoration: BoxDecoration(
//                   color: Colors.green.withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 child: Text(
//                   percent,
//                   style: const TextStyle(
//                       color: Colors.green,
//                       fontSize: 12,
//                       fontWeight: FontWeight.bold),
//                 ),
//               )
//             ],
//           ),
//           const SizedBox(height: 15),
//           Text(value,
//               style: const TextStyle(
//                   fontSize: 26, fontWeight: FontWeight.bold)),
//           const SizedBox(height: 5),
//           Text(subtitle,
//               style: const TextStyle(color: Colors.grey, fontSize: 13)),
//         ],
//       ),
//     );
//   }

//   Widget _scheduleCard() {
//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//               blurRadius: 10,
//               color: Colors.black.withOpacity(0.05),
//               offset: const Offset(0, 5))
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: const [
//           Text("Today's Schedule",
//               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
//           SizedBox(height: 20),
//           ListTile(
//             contentPadding: EdgeInsets.zero,
//             title: Text("Staff Meeting"),
//             subtitle: Text("10:00 AM - Conference Hall"),
//             trailing: Chip(
//               label: Text("Upcoming"),
//               backgroundColor: Colors.orangeAccent,
//             ),
//           ),
//           ListTile(
//             contentPadding: EdgeInsets.zero,
//             title: Text("Parent-Teacher Meeting"),
//             subtitle: Text("11:30 AM - Room 101"),
//             trailing: Chip(
//               label: Text("Upcoming"),
//               backgroundColor: Colors.orangeAccent,
//             ),
//           ),
//           ListTile(
//             contentPadding: EdgeInsets.zero,
//             title: Text("Fee Review"),
//             subtitle: Text("12:30 PM - Admin Office"),
//             trailing: Chip(
//               label: Text("Upcoming"),
//               backgroundColor: Colors.orangeAccent,
//             ),
//           ),
//           ListTile(
//             contentPadding: EdgeInsets.zero,
//             title: Text("Student Council Meeting"),
//             subtitle: Text("2:00 PM - Auditorium"),
//             trailing: Chip(
//               label: Text("Upcoming"),
//               backgroundColor: Colors.orangeAccent,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _overviewChart() {
//     return Container(
//       height: 300,
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//               blurRadius: 10,
//               color: Colors.black.withOpacity(0.05),
//               offset: const Offset(0, 5))
//         ],
//       ),
//       child: Column(
//         children: [
//           const Align(
//             alignment: Alignment.topLeft,
//             child: Text(
//               "Weekly Attendance Chart Placeholder",
//               style: TextStyle(color: Colors.grey),
//             ),
//           ),
//           const Spacer(),
//           const Icon(Icons.bar_chart, size: 80, color: Colors.grey),
//           const Spacer(),
//           const Text(
//             "Attendance trends will be displayed here.",
//             style: TextStyle(color: Colors.grey),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(30),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           /// Greeting Header
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               const Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text("Good Morning, Admin 👋",
//                       style:
//                           TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
//                   SizedBox(height: 5),
//                   Text("Here's what's happening in your Clinic today.",
//                       style: TextStyle(color: Colors.grey)),
//                 ],
//               ),
//               Row(
//                 children: [
//                   ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.blueAccent,
//                         shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12))),
//                     onPressed: () {},
//                     child: const Text("Export Report", style: TextStyle(color: Colors.white)),
//                   ),
//                   const SizedBox(width: 15),
//                   ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.purple,
//                         shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12))),
//                     onPressed: () {
//                       // Navigate to Add Student Screen
                     
//                     },
//                     child: const Text("Add Student +", style: TextStyle(color: Colors.white)),
//                   ),
//                 ],
//               )
//             ],
//           ),

//           const SizedBox(height: 30),

//           /// Stats Row
//           Row(
//             children: [
//               Expanded(
//                 child: _statCard(
//                   title: "TOTAL STUDENTS",
//                   value: "1,240",
//                   subtitle: "Enrolled",
//                   color: Colors.blue,
//                   percent: "+12%",
//                 ),
//               ),
//               const SizedBox(width: 20),
//               Expanded(
//                 child: _statCard(
//                   title: "TOTAL TEACHERS",
//                   value: "42",
//                   subtitle: "Active Staff",
//                   color: Colors.purple,
//                   percent: "+5%",
//                 ),
//               ),
//               const SizedBox(width: 20),
//               Expanded(
//                 child: _statCard(
//                   title: "PENDING FEES",
//                   value: "₹2,40,000",
//                   subtitle: "Outstanding",
//                   color: Colors.orange,
//                   percent: "-2%",
//                 ),
//               ),
//               const SizedBox(width: 20),
//               Expanded(
//                 child: _statCard(
//                   title: "ATTENDANCE RATE",
//                   value: "94.5%",
//                   subtitle: "This Week",
//                   color: Colors.green,
//                   percent: "+1.2%",
//                 ),
//               ),
//             ],
//           ),

//           const SizedBox(height: 30),

//           Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Expanded(flex: 3, child: _overviewChart()),
//               const SizedBox(width: 20),
//               Expanded(flex: 2, child: _scheduleCard()),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

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