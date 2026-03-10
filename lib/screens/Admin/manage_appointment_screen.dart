
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:get/get.dart';
// import 'package:clinic_web/screens/drawer_screen.dart';
import 'package:clinic_web/model/form_field_model.dart';
import 'package:clinic_web/widgets/custom_text_field.dart';
import 'package:flutter/foundation.dart';
class AdminAppointments extends StatefulWidget {
  const AdminAppointments({super.key});

  @override
  _AdminAppointmentsState createState() => _AdminAppointmentsState();
}

class _AdminAppointmentsState extends State<AdminAppointments> {
  String _selectedStatus = 'pending';

  Future<void> _approveAppointment(DocumentSnapshot appointment) async {
    final data = appointment.data() as Map<String, dynamic>;
    await appointment.reference.update({
      'status': 'accepted',
      'adminNote': 'Approved',
    });
    print('Approved appointment: ${appointment.id}, data: $data, new status: accepted');
await FirebaseFirestore.instance.collection('notifications').add({
  'userId': data['userId'] ?? 'guest',
  'title': 'Appointment Approved',
  'body': 'Your appointment for ${data['issue'] ?? 'consultation'}'
      '${data['date'] != null ? ' on ${data['date'].toDate()}' : ''}'
      '${data['timeSlot'] != null ? ' at ${data['timeSlot']}' : ''} is confirmed.',
      'Last Menses: ${data['lastMensesDate'] != null ? data['lastMensesDate'].toDate() : 'N/A'}'
  'type': 'appointment',
  'timestamp': FieldValue.serverTimestamp(),
});
    ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(
    content: const Text('Appointment approved'),
    backgroundColor: Colors.green,
    duration: const Duration(seconds: 5),
    behavior: SnackBarBehavior.floating,
    margin: const EdgeInsets.all(10),
  ),
);
  }
  Future<void> _rejectAppointment(DocumentSnapshot appointment) async {
    final data = appointment.data() as Map<String, dynamic>;
    final note = await _showNoteDialog(context);
    if (note != null && note!.isNotEmpty) {
      await appointment.reference.update({
        'status': 'rejected',
        'adminNote': note,
      });
      print('Rejected appointment: ${appointment.id}, data: $data, new status: rejected, note: $note');

      await FirebaseFirestore.instance.collection('notifications').add({
        'userId': data['userId'] ?? 'guest',
        'title': 'Appointment Rejected',
        'body': 'Your appointment was rejected: $note',
        'Last Menses: ${data['lastMensesDate'] != null ? data['lastMensesDate'].toDate() : 'N/A'}'
        // ' | Cycle Length: ${data['cycleLength'] ?? 'N/A'} days' 
        'type': 'appointment',
        'timestamp': FieldValue.serverTimestamp(),
      });
       ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(
    content: const Text('Appointment rejected'),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
    
        margin: const EdgeInsets.all(10),
        duration: const Duration(seconds: 3),
  )
      );
    }
  }

  Future<String?> _showNoteDialog(BuildContext context) async {
    final TextEditingController noteController = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text('Reject Reason *'),
        content: CustomTextField(model: FormFieldModel(label: "Mandatory Description", hint: "Enter description"), controller: noteController,maxLines: 3,),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel',  style: TextStyle(color: Colors.blue),),
          ),
          TextButton(
            onPressed: () {
              final note = noteController.text;
              if (note.isNotEmpty) {
                Navigator.pop(context, note);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Reason is required'),
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: Colors.red,
                    margin: const EdgeInsets.all(10),
                    duration: const Duration(seconds: 3),
                  ),
                );
              }
            },
            child: const Text('Reject',style: TextStyle(color: Colors.blue),),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: kIsWeb ?
      null 
      : AppBar(
        title: const Text('Manage Appointments',style: TextStyle(
          color: Colors.white
        ),),
        centerTitle: true,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      // drawer: const DrawerScreen(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatusCard('pending', Colors.orange),
                _buildStatusCard('accepted', Colors.green),
                _buildStatusCard('rejected', Colors.red),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('appointments')
                  .where('status', isEqualTo: _selectedStatus.toLowerCase())
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                final appointments = snapshot.data?.docs ?? [];
                if (appointments.isEmpty) {
                  return const Center(child: Text('No appointments available.'));
                }
                return ListView.builder(
                  itemCount: appointments.length,
                  itemBuilder: (context, index) {
                    final appointment = appointments[index];
                    final data = appointment.data() as Map<String, dynamic>;
                    return Card(
                      color: Colors.white,
                      elevation: 2,
                      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      child: Padding(
  padding: const EdgeInsets.all(12),
  child: Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [

    
      CircleAvatar(
        radius: 22,
        backgroundColor: Colors.blue.shade100,
        child: Text(
          (data['name'] ?? 'U')[0].toUpperCase(),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.blue,
          ),
        ),
      ),

      const SizedBox(width: 12),

    
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

    
            Text(
              data['name'] ?? 'Unknown',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 6),

            Text(
              "Date: ${data['date']?.toDate()?.toString().split(' ')[0] ?? 'Not specified'}",
              style: const TextStyle(fontSize: 13),
            ),

            Text(
              "Time: ${data['timeSlot'] ?? 'Not specified'}",
              style: const TextStyle(fontSize: 13),
            ),

            Text(
              "Issue: ${data['issue'] ?? ''}",
              style: const TextStyle(fontSize: 13),
            ),

            Text(
              "Last Menses: ${data['mensesDate'] != null ? data['mensesDate'].toDate().toString().split(' ')[0] : 'N/A'}",
              style: const TextStyle(fontSize: 13),
            ),

            if (_selectedStatus != 'pending')
              Text(
                "Note: ${data['adminNote'] ?? ''}",
                style: const TextStyle(fontSize: 13),
              ),
          ],
        ),
      ),

    
      if (_selectedStatus == 'pending')
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.check_circle, color: Colors.green),
              onPressed: () => _approveAppointment(appointment),
            ),
            IconButton(
              icon: const Icon(Icons.cancel, color: Colors.red),
              onPressed: () => _rejectAppointment(appointment),
            ),
          ],
        ),
    ],
  ),
),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard(String status, Color color) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedStatus = status.toLowerCase();
        });
      },
      child: Card(
        color: _selectedStatus == status.toLowerCase() ? color : Colors.grey[300],
        child: Container(
          width: 100,
          padding: const EdgeInsets.all(10),
          child: Center(
            child: Text(
              status,
              style: TextStyle(
                color: _selectedStatus == status.toLowerCase() ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}