import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class SlotService {

  static Future<void> applyClinicSettingsChange({
    Function(int currentDay, int totalDays)? onProgress,
  }) async {

    final db = FirebaseFirestore.instance;

    /// 1️⃣ Read clinic settings
    final settingsDoc =
        await db.collection('clinic_settings').doc('main').get();

    final settings = settingsDoc.data() ?? {};

    final String start = settings['startTime'] ?? "09:00";
    final String end = settings['endTime'] ?? "17:00";
    final int duration = settings['slotDuration'] ?? 20;
    final int generateDays = settings['generateDays'] ?? 30;

    final today = DateTime.now();
    final lastAllowedDate = today.add(Duration(days: generateDays));

    /// 2️⃣ DELETE future unbooked slots
    final snap = await db
        .collection('clinic_slots')
        .where('booked', isEqualTo: false)
        .get();

    WriteBatch batch = db.batch();

    for (final doc in snap.docs) {

      final slotDate =
          DateFormat('yyyy-MM-dd').parse(doc['date']);

      if (slotDate.isAfter(today) &&
          slotDate.isBefore(lastAllowedDate)) {
        batch.delete(doc.reference);
      }
    }

    await batch.commit();

    /// 3️⃣ GENERATE slots
    for (int i = 0; i < generateDays; i++) {

      final day = today.add(Duration(days: i));

      await _generateSlotsForDay(
        day: day,
        start: start,
        end: end,
        duration: duration,
      );

      /// Progress callback
      if (onProgress != null) {
        onProgress(i + 1, generateDays);
      }
    }
  }

  static Future<void> _generateSlotsForDay({
    required DateTime day,
    required String start,
    required String end,
    required int duration,
  }) async {

    final db = FirebaseFirestore.instance;

    DateTime cursor = DateTime(
      day.year,
      day.month,
      day.day,
      int.parse(start.split(':')[0]),
      int.parse(start.split(':')[1]),
    );

    final endTime = DateTime(
      day.year,
      day.month,
      day.day,
      int.parse(end.split(':')[0]),
      int.parse(end.split(':')[1]),
    );

    WriteBatch batch = db.batch();

    while (cursor.isBefore(endTime)) {

      final next = cursor.add(Duration(minutes: duration));

      final id =
          '${DateFormat('yyyy-MM-dd').format(day)}_${DateFormat('HH:mm').format(cursor)}';

      final ref = db.collection('clinic_slots').doc(id);

      final exists = await ref.get();

      if (!exists.exists) {

        batch.set(ref, {
          'date': DateFormat('yyyy-MM-dd').format(day),
          'startTime': DateFormat('HH:mm').format(cursor),
          'endTime': DateFormat('HH:mm').format(next),
          'booked': false,
          'blocked': false,
          'createdAt': FieldValue.serverTimestamp(),
        });

      }

      cursor = next;
    }

    await batch.commit();
  }
}