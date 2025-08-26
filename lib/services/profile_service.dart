import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/supabase_config.dart';

class ProfileService {
  // Update profile with missing data
  static Future<void> updateProfile({
    required String userId,
    String? firstName,
    String? lastName,
    String? gender,
    DateTime? dateOfBirth,
    String? avatarUrl,
    String? bio,
  }) async {
    try {
      final updates = <String, dynamic>{};
      
      if (firstName != null && firstName.isNotEmpty) updates['first_name'] = firstName;
      if (lastName != null && lastName.isNotEmpty) updates['last_name'] = lastName;
      if (gender != null && gender.isNotEmpty) updates['gender'] = gender;
      if (dateOfBirth != null) updates['date_of_birth'] = dateOfBirth.toIso8601String().split('T')[0];
      if (avatarUrl != null && avatarUrl.isNotEmpty) updates['avatar_url'] = avatarUrl;
      if (bio != null && bio.isNotEmpty) updates['bio'] = bio;

      if (updates.isNotEmpty) {
        await supabase.from('profiles').upsert({
          'id': userId,
          ...updates,
        });
      }
    } catch (e) {
      throw Exception('Failed to update profile: $e');
    }
  }

  // Get user profile
  static Future<Map<String, dynamic>?> getProfile(String userId) async {
    try {
      final response = await supabase
          .from('profiles')
          .select()
          .eq('id', userId)
          .single();
      return response;
    } catch (e) {
      print('Error getting profile: $e');
      return null;
    }
  }

  // Fix existing profiles that have missing data
  static Future<void> fixMissingProfileData() async {
    try {
      // This can be called to update profiles that have NULL values
      final user = supabase.auth.currentUser;
      if (user != null) {
        final metaData = user.userMetadata;
        await updateProfile(
          userId: user.id,
          firstName: metaData?['first_name'],
          lastName: metaData?['last_name'],
          gender: metaData?['gender'],
          dateOfBirth: metaData?['date_of_birth'] != null 
              ? DateTime.tryParse(metaData!['date_of_birth']) 
              : null,
        );
      }
    } catch (e) {
      print('Error fixing profile data: $e');
    }
  }
}
