import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/supabase_config.dart';

class DatabaseService {
  // Profile operations
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

  static Future<void> updateProfile({
    required String userId,
    String? firstName,
    String? lastName,
    String? bio,
    String? avatarUrl,
    String? gender,
    DateTime? dateOfBirth,
  }) async {
    try {
      await supabase.from('profiles').update({
        if (firstName != null) 'first_name': firstName,
        if (lastName != null) 'last_name': lastName,
        if (bio != null) 'bio': bio,
        if (avatarUrl != null) 'avatar_url': avatarUrl,
        if (gender != null) 'gender': gender,
        if (dateOfBirth != null) 'date_of_birth': dateOfBirth.toIso8601String(),
      }).eq('id', userId);
    } catch (e) {
      throw Exception('Failed to update profile: $e');
    }
  }

  // Pet operations
  static Future<List<Map<String, dynamic>>> getUserPets(String userId) async {
    try {
      final response = await supabase
          .from('pets')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Error getting pets: $e');
      return [];
    }
  }

  static Future<Map<String, dynamic>?> createPet({
    required String userId,
    required String name,
    String? species,
    String? breed,
    String? bio,
    String? avatarUrl,
  }) async {
    try {
      final response = await supabase.from('pets').insert({
        'user_id': userId,
        'name': name,
        'species': species,
        'breed': breed,
        'bio': bio,
        'avatar_url': avatarUrl,
      }).select().single();
      return response;
    } catch (e) {
      throw Exception('Failed to create pet: $e');
    }
  }

  // Post operations
  static Future<List<Map<String, dynamic>>> getPosts({int limit = 20}) async {
    try {
      final response = await supabase
          .from('posts')
          .select('''
            *,
            profiles:user_id (
              id,
              first_name,
              last_name,
              avatar_url
            ),
            pets:pet_id (
              id,
              name,
              avatar_url
            ),
            media (*),
            likes (count),
            comments (count)
          ''')
          .order('created_at', ascending: false)
          .limit(limit);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Error getting posts: $e');
      return [];
    }
  }

  static Future<Map<String, dynamic>?> createPost({
    required String userId,
    String? petId,
    required String content,
    List<String>? mediaUrls,
  }) async {
    try {
      final response = await supabase.from('posts').insert({
        'user_id': userId,
        'pet_id': petId,
        'content': content,
      }).select().single();

      // Add media if provided
      if (mediaUrls != null && mediaUrls.isNotEmpty) {
        final mediaData = mediaUrls.map((url) => {
              'post_id': response['id'],
              'url': url,
              'type': url.toLowerCase().contains('.mp4') ? 'video' : 'photo',
            }).toList();

        await supabase.from('media').insert(mediaData);
      }

      return response;
    } catch (e) {
      throw Exception('Failed to create post: $e');
    }
  }

  // Like operations
  static Future<void> likePost(String userId, String postId) async {
    try {
      await supabase.from('likes').insert({
        'user_id': userId,
        'post_id': postId,
      });
    } catch (e) {
      throw Exception('Failed to like post: $e');
    }
  }

  static Future<void> unlikePost(String userId, String postId) async {
    try {
      await supabase
          .from('likes')
          .delete()
          .eq('user_id', userId)
          .eq('post_id', postId);
    } catch (e) {
      throw Exception('Failed to unlike post: $e');
    }
  }

  // Follow operations
  static Future<void> followUser(String userId, String targetUserId) async {
    try {
      await supabase.from('followers').insert({
        'user_id': targetUserId,
        'follower_id': userId,
      });
    } catch (e) {
      throw Exception('Failed to follow user: $e');
    }
  }

  static Future<void> unfollowUser(String userId, String targetUserId) async {
    try {
      await supabase
          .from('followers')
          .delete()
          .eq('user_id', targetUserId)
          .eq('follower_id', userId);
    } catch (e) {
      throw Exception('Failed to unfollow user: $e');
    }
  }

  // Bookmark operations
  static Future<void> bookmarkPost(String userId, String postId) async {
    try {
      await supabase.from('bookmarks').insert({
        'user_id': userId,
        'post_id': postId,
      });
    } catch (e) {
      throw Exception('Failed to bookmark post: $e');
    }
  }

  static Future<void> removeBookmark(String userId, String postId) async {
    try {
      await supabase
          .from('bookmarks')
          .delete()
          .eq('user_id', userId)
          .eq('post_id', postId);
    } catch (e) {
      throw Exception('Failed to remove bookmark: $e');
    }
  }

  // Comment operations
  static Future<List<Map<String, dynamic>>> getPostComments(String postId) async {
    try {
      final response = await supabase
          .from('comments')
          .select('''
            *,
            profiles:user_id (
              id,
              first_name,
              last_name,
              avatar_url
            )
          ''')
          .eq('post_id', postId)
          .order('created_at', ascending: true);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Error getting comments: $e');
      return [];
    }
  }

  static Future<Map<String, dynamic>?> createComment({
    required String userId,
    required String postId,
    required String content,
  }) async {
    try {
      final response = await supabase.from('comments').insert({
        'user_id': userId,
        'post_id': postId,
        'content': content,
      }).select().single();
      return response;
    } catch (e) {
      throw Exception('Failed to create comment: $e');
    }
  }
}
