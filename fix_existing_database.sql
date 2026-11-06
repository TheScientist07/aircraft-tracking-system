-- Run this ONLY if your Railway database already has the old tables and data.
-- It adds the one column the new version needs and sets the new admin password.
ALTER TABLE aircraft ADD COLUMN next_inspection varchar(100) DEFAULT NULL;
UPDATE users SET password_hash = '$2a$10$4HyDxvCnCGTt1WA7fbM/i.Wne6gD03FTrdMt0Hhg53udifa7CTwTS' WHERE email = 'admin@system.com';
