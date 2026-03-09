
import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {

  static final supabase = Supabase.instance.client;

  static Future<String?> uploadImage({
    required File image,
    required String bucket,
    required String folder,
  }) async {
    try {
      final fileExt = image.path.split('.').last;

      final fileName =
          '${DateTime.now().millisecondsSinceEpoch}.$fileExt';

      final filePath = '$folder/$fileName';

      await supabase.storage
          .from(bucket)
          .upload(filePath, image);

      final url =
          supabase.storage.from(bucket).getPublicUrl(filePath);

      return url;

    } catch (e) {
      print("Upload failed: $e");
      return null;
    }
  }

  static Future<void> deleteFileByUrl(String url) async {
    try {
      final uri = Uri.parse(url);

      final path = uri.pathSegments
          .skipWhile((e) => e != 'object')
          .skip(1)
          .join('/');

      final bucket =
          uri.pathSegments[uri.pathSegments.indexOf('object') + 1];

      await supabase.storage.from(bucket).remove([path]);

    } catch (e) {
      print("Delete failed: $e");
    }
  }
}