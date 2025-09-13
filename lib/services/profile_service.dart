import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';
import '../config/supabase_config.dart';
import '../models/profile_model.dart';

class ProfileService {
  // Get current user profile
  static Future<ProfileModel?> getCurrentUserProfile() async {
    try {
      final user = supabase.auth.currentUser;
      if (user == null) return null;

      return await getProfile(user.id);
    } catch (e) {
      print('Error getting current user profile: $e');
      return null;
    }
  }

  // Get user profile by ID
  static Future<ProfileModel?> getProfile(String userId) async {
    try {
      final response = await supabase
          .from('profiles')
          .select()
          .eq('id', userId)
          .single();

      return ProfileModel.fromJson(response);
    } catch (e) {
      print('Error getting profile: $e');
      return null;
    }
  }

  // Update profile
  static Future<bool> updateProfile({
    String? firstName,
    String? lastName,
    String? gender,
    DateTime? dateOfBirth,
    String? avatarUrl,
    String? bio,
  }) async {
    try {
      final user = supabase.auth.currentUser;
      if (user == null) throw Exception('User not authenticated');

      final updates = <String, dynamic>{
        'updated_at': DateTime.now().toIso8601String(),
      };
      
      if (firstName != null) updates['first_name'] = firstName;
      if (lastName != null) updates['last_name'] = lastName;
      if (gender != null) updates['gender'] = gender;
      if (dateOfBirth != null) updates['date_of_birth'] = dateOfBirth.toIso8601String().split('T')[0];
      if (avatarUrl != null) updates['avatar_url'] = avatarUrl;
      if (bio != null) updates['bio'] = bio;

      await supabase
          .from('profiles')
          .upsert({
            'id': user.id,
            ...updates,
          });

      return true;
    } catch (e) {
      print('Error updating profile: $e');
      return false;
    }
  }

  // Upload profile picture
  static Future<String?> uploadProfilePicture(XFile imageFile) async {
    try {
      final user = supabase.auth.currentUser;
      if (user == null) throw Exception('User not authenticated');

      final bytes = await imageFile.readAsBytes();
      final fileName = '${user.id}/profile_${DateTime.now().millisecondsSinceEpoch}.jpg';

      print('Attempting to upload to avatars bucket with fileName: $fileName');
      print('File size: ${bytes.length} bytes');

      // Upload to 'avatars' bucket
      final uploadResponse = await supabase.storage
          .from('avatars')
          .uploadBinary(
            fileName,
            bytes,
            fileOptions: const FileOptions(
              cacheControl: '3600',
              upsert: true,
            ),
          );

      print('Upload response: $uploadResponse');

      final publicUrl = supabase.storage
          .from('avatars')
          .getPublicUrl(fileName);

      print('Generated public URL: $publicUrl');

      // Update profile with new avatar URL
      await updateProfile(avatarUrl: publicUrl);

      return publicUrl;
    } catch (e) {
      print('Detailed error uploading profile picture: $e');
      print('Error type: ${e.runtimeType}');
      if (e is StorageException) {
        print('Storage error details - Message: ${e.message}, Status: ${e.statusCode}');
      }
      return null;
    }
  }

  // Get followers count
  static Future<int> getFollowersCount(String userId) async {
    try {
      final response = await supabase
          .from('followers')
          .select('id')
          .eq('user_id', userId);

      return response.length;
    } catch (e) {
      print('Error getting followers count: $e');
      return 0;
    }
  }

  // Get following count
  static Future<int> getFollowingCount(String userId) async {
    try {
      final response = await supabase
          .from('followers')
          .select('id')
          .eq('follower_id', userId);

      return response.length;
    } catch (e) {
      print('Error getting following count: $e');
      return 0;
    }
  }

  // Get posts count
  static Future<int> getPostsCount(String userId) async {
    try {
      final response = await supabase
          .from('posts')
          .select('id')
          .eq('user_id', userId);

      return response.length;
    } catch (e) {
      print('Error getting posts count: $e');
      return 0;
    }
  }

  // Check if following user
  static Future<bool> isFollowing(String userId) async {
    try {
      final currentUser = supabase.auth.currentUser;
      if (currentUser == null) return false;

      final response = await supabase
          .from('followers')
          .select('id')
          .eq('user_id', userId)
          .eq('follower_id', currentUser.id)
          .maybeSingle();

      return response != null;
    } catch (e) {
      print('Error checking follow status: $e');
      return false;
    }
  }

  // Follow/unfollow user
  static Future<bool> toggleFollow(String userId) async {
    try {
      final currentUser = supabase.auth.currentUser;
      if (currentUser == null) return false;

      final isCurrentlyFollowing = await isFollowing(userId);

      if (isCurrentlyFollowing) {
        // Unfollow
        await supabase
            .from('followers')
            .delete()
            .eq('user_id', userId)
            .eq('follower_id', currentUser.id);
      } else {
        // Follow
        await supabase
            .from('followers')
            .insert({
              'user_id': userId,
              'follower_id': currentUser.id,
            });
      }

      return !isCurrentlyFollowing;
    } catch (e) {
      print('Error toggling follow: $e');
      return false;
    }
  }

  // Get user's posts
  static Future<List<Map<String, dynamic>>> getUserPosts(String userId) async {
    try {
      final response = await supabase
          .from('posts')
          .select('''
            *,
            media (*)
          ''')
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Error getting user posts: $e');
      return [];
    }
  }

  // Create/update profile (for new users)
  static Future<bool> createProfile({
    required String userId,
    String? firstName,
    String? lastName,
    String? gender,
    DateTime? dateOfBirth,
    String? bio,
  }) async {
    try {
      await supabase.from('profiles').upsert({
        'id': userId,
        'first_name': firstName,
        'last_name': lastName,
        'gender': gender,
        'date_of_birth': dateOfBirth?.toIso8601String().split('T')[0],
        'bio': bio,
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      });

      return true;
    } catch (e) {
      print('Error creating profile: $e');
      return false;
    }
  }
}
