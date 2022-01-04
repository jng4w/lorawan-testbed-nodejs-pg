-- create function check_profile_exist (
-- 	email_or_phone character varying
-- )
-- 	returning character varying
--     LANGUAGE plpgsql
--     AS $$

-- DECLARE 
-- 	tmp integer;
-- BEGIN
-- 	SELECT count(*) INTO tmp FROM profile WHERE email = email_or_phone;
--     IF tmp = 1:
--         RETURNING
--     ELSIF tmp = 0:
--         SELECT count(*) INTO tmp FROM profile WHERE phone_number = email_or_phone;
    
            
-- END;
-- $$