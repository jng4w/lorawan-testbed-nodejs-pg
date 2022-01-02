CREATE EXTENSION pgcrypto;
-----------------------------------------------------


-----------------------------------------------------
-- ADD NEW PROFILE
CREATE PROCEDURE insert_profile
(new_email character varying, new_phone_number character varying, 
new_password character varying, new_type character varying, 
new_display_name character varying)
AS $$
DECLARE new_id integer;
BEGIN
INSERT INTO public."PROFILE"(
	email, phone_number, password, type, display_name)
	VALUES (new_email, new_phone_number, crypt(new_password, gen_salt('bf')), new_type, new_display_name)
    RETURNING _id INTO new_id;
    
IF new_type = 'ADMIN' THEN
    INSERT INTO public."ADMIN"(
        profile_id)
        VALUES (new_id);
ELSIF new_type = 'CUSTOMER' THEN
    INSERT INTO public."CUSTOMER"(
        profile_id)
        VALUES (new_id);
END IF;
END;
$$
LANGUAGE PLPGSQL;

-----------------------------------------------------


-----------------------------------------------------
-- ADD NEW BOARD
CREATE PROCEDURE insert_board
(new_display_name character varying, ref_profile_id integer)
AS $$

BEGIN
INSERT INTO public."BOARD"(
	display_name, profile_id)
	VALUES (new_display_name, ref_profile_id);

END;
$$
LANGUAGE PLPGSQL;
-----------------------------------------------------


-----------------------------------------------------
-- ADD NEW WIDGET
CREATE PROCEDURE insert_widget
(new_display_name character varying, new_config_dict jsonb, ref_board_id integer)
AS $$

BEGIN
INSERT INTO public."WIDGET"(
	display_name, config_dict, profile_id)
	VALUES (new_display_name, new_config_dict, ref_profile_id);

END;
$$
LANGUAGE PLPGSQL;
-----------------------------------------------------

-- have not done
-----------------------------------------------------
-- ADD NEW ENDDEV
CREATE PROCEDURE insert_enddev
(new_display_name character varying, new_dev_id character varying, new_dev_addr character varying, 
new_join_eui character varying, new_dev_eui character varying, new_dev_type character varying, 
new_dev_brand character varying, new_dev_model character varying, new_dev_band character varying)

DECLARE new_id integer;
AS $$

BEGIN
INSERT INTO public."ENDDEV"(
	display_name, dev_id, dev_addr, join_eui, dev_eui, dev_type, dev_brand, dev_model, dev_band)
	VALUES (new_display_name, new_dev_id, new_dev_addr, new_join_eui, new_dev_eui, new_dev_type, new_dev_brand, new_dev_model, new_dev_band)
    RETURNING _id INTO new_id;

END;
$$
LANGUAGE PLPGSQL;
-----------------------------------------------------


-----------------------------------------------------
-- ADD NEW SENSOR
CREATE PROCEDURE insert_sensor
(new_sensor_key character varying, ref_enddev_id integer)

DECLARE new_id integer;
AS $$

BEGIN
INSERT INTO public."SENSOR"(
	sensor_key, enddev_id)
	VALUES (new_sensor_key, ref_endddev_id)
    RETURNING _id INTO new_id;

END;
$$
LANGUAGE PLPGSQL;
-----------------------------------------------------


-----------------------------------------------------
-- ADD NEW ENDDEV_PAYLOAD
CREATE PROCEDURE insert_enddev_payload
(new_recv_timestamp timestamp without time zone, new_payload_data jsonb, ref_enddev_id integer)

DECLARE new_id integer;
AS $$

BEGIN
INSERT INTO public."ENDDEV_PAYLOAD"(
	recv_timestamp, payload_data, enddev_id)
	VALUES (new_recv_timestamp, new_payload_data, ref_endddev_id)
    RETURNING _id INTO new_id;

END;
$$
LANGUAGE PLPGSQL;
-----------------------------------------------------


-----------------------------------------------------
-- ADD SENSOR TO WIDGET
CREATE PROCEDURE insert_sensor_to_widget
(ref_widget_id integer, ref_sensor_id integer)

DECLARE new_id integer;
AS $$

BEGIN
INSERT INTO public."BELONG_TO"(
	widget_id, sensor_id)
	VALUES (ref_widget_id, ref_sensor_id)
    RETURNING _id INTO new_id;

END;
$$
LANGUAGE PLPGSQL;
-----------------------------------------------------


-----------------------------------------------------
-- ADD UNIT
CREATE PROCEDURE insert_unit
(ref_sensor_key character varying, ref_dev_type character varying, new_unit character varying)

DECLARE new_id integer;
AS $$

BEGIN
INSERT INTO public."UNIT"(
	widget_id, sensor_id)
	VALUES (ref_widget_id, ref_sensor_id)
    RETURNING _id INTO new_id;

END;
$$
LANGUAGE PLPGSQL;
-----------------------------------------------------


-----------------------------------------------------
-- process new payload
CREATE PROCEDURE public.process_new_payload(new_metadata json, new_payload json)
    LANGUAGE plpgsql
    AS $$

DECLARE 
	enddev_id integer;
	_key text;

BEGIN
INSERT INTO public."ENDDEV_PAYLOAD" (recv_timestamp, payload_data, enddev_id)
VALUES (new_payload->'recv_timestamp', 
	new_payload->'payload_data', 
	(SELECT _id FROM public."ENDDEV" WHERE dev_id = new_metadata->'dev_identifiers'->'dev_id') 
);

-- there is no enddev exists -> insert new enddev
EXCEPTION
INSERT INTO public."ENDDEV" (display_name, dev_id, dev_addr, join_eui, dev_eui, dev_type, dev_brand, dev_model, dev_band)
VALUES (new_metadata->'dev_identifiers'->'dev_id', 
	new_metadata->'dev_identifiers'->'dev_id', 
	new_metadata->'dev_identifiers'->'dev_addr',
	new_metadata->'dev_identifiers'->'join_eui', 
	new_metadata->'dev_identifiers'->'dev_eui', 
	(SELECT _id FROM public."DEVTYPE" WHERE dev_type = new_metadata->'dev_version'->'dev_type'), 
	new_metadata->'dev_version'->'dev_brand', 
	new_metadata->'dev_version'->'dev_model', 
	new_metadata->'dev_version'->'dev_band'
) RETURNING _id INTO enddev_id;

-- insert new sensor
FOR _key IN 
	SELECT key FROM json_each(new_payload)
LOOP
	INSERT INTO public."SENSOR" (sensor_key, enddev_id)\
                VALUES (_key, enddev_id);
END LOOP;

END;
$$;

