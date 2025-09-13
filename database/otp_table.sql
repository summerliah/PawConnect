-- Create OTP table in your existing Supabase database
-- Run this SQL in your Supabase SQL Editor

CREATE TABLE password_reset_otps (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  email TEXT NOT NULL,
  otp_code TEXT NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  expires_at TIMESTAMP WITH TIME ZONE DEFAULT (NOW() + INTERVAL '10 minutes'),
  used BOOLEAN DEFAULT FALSE,
  UNIQUE(email, otp_code)
);

-- Add index for faster lookups
CREATE INDEX idx_otp_email ON password_reset_otps(email);
CREATE INDEX idx_otp_expires ON password_reset_otps(expires_at);

-- Add RLS (Row Level Security) policies
ALTER TABLE password_reset_otps ENABLE ROW LEVEL SECURITY;

-- Policy to allow inserting OTP codes
CREATE POLICY "Allow insert OTP" ON password_reset_otps
  FOR INSERT WITH CHECK (true);

-- Policy to allow reading OTP codes
CREATE POLICY "Allow read OTP" ON password_reset_otps
  FOR SELECT USING (true);

-- Policy to allow updating OTP codes (marking as used)
CREATE POLICY "Allow update OTP" ON password_reset_otps
  FOR UPDATE USING (true);
