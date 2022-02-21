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
CREATE PROCEDURE public.process_new_payload(
	new_recv_timestamp timestamp without time zone, 
	new_payload_data jsonb,
	new_dev_id character varying,
	new_dev_eui character varying,
	new_dev_addr character varying,
	new_join_eui character varying,
	new_dev_type character varying,
	new_dev_brand character varying,
	new_dev_model character varying,
	new_dev_band character varying
	)
    LANGUAGE plpgsql
    AS $$



DECLARE 
	_enddev_id integer;
    _dev_type_id integer;

BEGIN
	INSERT INTO public."ENDDEV_PAYLOAD" (recv_timestamp, payload_data, enddev_id)
	VALUES (new_recv_timestamp, 
		new_payload_data, 
		(SELECT _id FROM public."ENDDEV" WHERE dev_id = new_dev_id) 
	);

EXCEPTION
	-- there is no enddev exists -> insert new enddev
	WHEN not_null_violation THEN
		SELECT _id INTO _dev_type_id FROM public."DEV_TYPE" WHERE dev_type = new_dev_type;
		INSERT INTO public."ENDDEV" (display_name, dev_id, dev_addr, join_eui, dev_eui, dev_type_id, dev_brand, dev_model, dev_band)
		VALUES (new_dev_id, 
			new_dev_id, 
			new_dev_addr,
			new_join_eui, 
			new_dev_eui, 
			_dev_type_id,
			new_dev_brand, 
			new_dev_model, 
			new_dev_band
		) RETURNING _id INTO _enddev_id;

		-- insert new sensor
		INSERT INTO public."SENSOR" (sensor_key, sensor_type, enddev_id)
		SELECT jsonb_array_elements(dev_type_config->'sensor_list')->>'key' AS sensor_key,
			'sensor' AS sensor_type,
			_enddev_id AS enddev_id
		FROM public."DEV_TYPE" 
		WHERE _id = _dev_type_id;

		-- insert new controller
		INSERT INTO public."SENSOR" (sensor_key, sensor_type, enddev_id)
		SELECT jsonb_array_elements(dev_type_config->'controller_list')->>'key' AS sensor_key,
			'controller' AS sensor_type,
			_enddev_id AS enddev_id
		FROM public."DEV_TYPE" 
		WHERE _id = _dev_type_id;

		-- if come to here -> enddev is inserted -> insert payload again
		INSERT INTO public."ENDDEV_PAYLOAD" (recv_timestamp, payload_data, enddev_id)
		VALUES (new_recv_timestamp, 
			new_payload_data, 
			_enddev_id
		);
END;
$$;
-----------------------------------------------------


-----------------------------------------------------
-- ADD DEV TO CUSTOMER
CREATE PROCEDURE insert_device_to_customer
(ref_profile_id IN integer, ref_enddev_id INOUT character varying)
AS $$
DECLARE ref_id integer;


BEGIN
SELECT COALESCE(_id, 0) INTO ref_id
	FROM public."ENDDEV"
	WHERE dev_id = ref_enddev_id;

INSERT INTO public."OWN"(
	profile_id, enddev_id)
	VALUES (ref_profile_id, ref_id);
	
END;
$$
LANGUAGE PLPGSQL;
-----------------------------------------------------


-----------------------------------------------------
-- ADD WIDGET TO BOARD
CREATE PROCEDURE insert_widget_to_board
(new_display_name character varying, new_config_dict jsonb, ref_board_id integer, 
ref_widget_type_id integer, ref_device_id character varying, ref_sensor_key character varying)
AS $$
DECLARE 
	ref_sensor_id integer;
	ref_widget_id integer;
	tmp_device_id character varying[] := string_to_array(ref_device_id,',');
	tmp_sensor_key character varying[] := string_to_array(ref_sensor_key,',');

BEGIN
INSERT INTO public."WIDGET"(
	display_name, config_dict, board_id, widget_type_id)
	VALUES (new_display_name, new_config_dict, ref_board_id, ref_widget_type_id)
	RETURNING _id into ref_widget_id;

FOR i IN array_lower(tmp_device_id, 1) .. array_upper(tmp_device_id, 1)
LOOP
	SELECT S._id into ref_sensor_id FROM
		public."ENDDEV" as E, public."SENSOR" as S
	WHERE
		E._id = S.enddev_id and
		E.dev_id = tmp_device_id[i] and
		S.sensor_key = tmp_sensor_key[i];
	
	INSERT INTO public."BELONG_TO"(
		widget_id, sensor_id)
		VALUES (ref_widget_id, ref_sensor_id);
END LOOP;
END;
$$
LANGUAGE PLPGSQL;

