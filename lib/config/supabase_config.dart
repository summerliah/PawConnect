import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  // TODO: Replace these with your actual Supabase project credentials
  static const String supabaseUrl = 'https://cesilsdabvuzscvahogs.supabase.co';
  static const String supabaseAnonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImNlc2lsc2RhYnZ1enNjdmFob2dzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTU2NTYyNDksImV4cCI6MjA3MTIzMjI0OX0.46YOmf0WUFEL5QIeJSlCcjY4IMvLjIEOb1XTiE-9kyo';

  static SupabaseClient get client => Supabase.instance.client;
}

// Global getter for easy access to Supabase client
final supabase = SupabaseConfig.client;
