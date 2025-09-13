-- Create OTP table for password reset codes
CREATE TABLE IF NOT EXISTS password_reset_otps (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    email VARCHAR(255) NOT NULL,
    otp_code VARCHAR(6) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    expires_at TIMESTAMP WITH TIME ZONE DEFAULT (NOW() + INTERVAL '10 minutes'),
    used BOOLEAN DEFAULT FALSE,
    attempts INTEGER DEFAULT 0
);

-- Create index for faster lookups
CREATE INDEX IF NOT EXISTS idx_password_reset_otps_email ON password_reset_otps(email);
CREATE INDEX IF NOT EXISTS idx_password_reset_otps_code ON password_reset_otps(otp_code);

-- Enable Row Level Security
ALTER TABLE password_reset_otps ENABLE ROW LEVEL SECURITY;

-- Create policy to allow service role to manage OTP codes
CREATE POLICY "Service role can manage OTP codes" ON password_reset_otps
    FOR ALL USING (auth.role() = 'service_role');

-- Function to clean up expired OTP codes
CREATE OR REPLACE FUNCTION cleanup_expired_otps()
RETURNS void AS $$
BEGIN
    DELETE FROM password_reset_otps 
    WHERE expires_at < NOW() OR used = TRUE;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function to generate and store OTP
CREATE OR REPLACE FUNCTION generate_password_reset_otp(user_email VARCHAR)
RETURNS VARCHAR AS $$
DECLARE
    new_otp VARCHAR(6);
BEGIN
    -- Generate 6-digit OTP
    new_otp := LPAD(FLOOR(RANDOM() * 1000000)::TEXT, 6, '0');
    
    -- Clean up old OTPs for this email
    DELETE FROM password_reset_otps WHERE email = user_email;
    
    -- Insert new OTP
    INSERT INTO password_reset_otps (email, otp_code)
    VALUES (user_email, new_otp);
    
    RETURN new_otp;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function to verify OTP
CREATE OR REPLACE FUNCTION verify_password_reset_otp(user_email VARCHAR, input_otp VARCHAR)
RETURNS BOOLEAN AS $$
DECLARE
    otp_record RECORD;
BEGIN
    -- Find valid OTP
    SELECT * INTO otp_record
    FROM password_reset_otps
    WHERE email = user_email 
    AND otp_code = input_otp 
    AND expires_at > NOW() 
    AND used = FALSE
    AND attempts < 5;
    
    IF NOT FOUND THEN
        -- Increment attempts if OTP exists but is wrong
        UPDATE password_reset_otps 
        SET attempts = attempts + 1 
        WHERE email = user_email AND otp_code = input_otp;
        RETURN FALSE;
    END IF;
    
    -- Mark OTP as used
    UPDATE password_reset_otps 
    SET used = TRUE 
    WHERE id = otp_record.id;
    
    RETURN TRUE;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
