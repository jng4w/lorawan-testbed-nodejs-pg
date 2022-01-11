-----------------------------------------------------


-----------------------------------------------------
-- Auto generate board when inserting device
CREATE FUNCTION generate_dashboard() RETURNS trigger AS $gen_dash$
	DECLARE 
		new_enddev_name character varying;
		new_board_id integer;
		new_widget_id integer;
		sensor_data record;
    BEGIN
		SELECT E.display_name INTO new_enddev_name
		FROM
			public."CUSTOMER" as C, public."OWN" as O, public."ENDDEV" as E
		WHERE
			C.profile_id = O.profile_id AND
			O.enddev_id = E._id AND
			O.profile_id = NEW.profile_id AND
			O.enddev_id = NEW.enddev_id;
	
		INSERT INTO public."BOARD"(
		display_name, profile_id)
		VALUES (new_enddev_name, NEW.profile_id)
		RETURNING _id INTO new_board_id;
	
		FOR sensor_data IN SELECT sensor_key, _id
				FROM
					public."SENSOR" as S
				WHERE
					S.enddev_id = NEW.enddev_id
		LOOP
			INSERT INTO public."WIDGET"(
			 display_name, config_dict, board_id, widget_type_id)
			VALUES ( sensor_data.sensor_key, 
					'{"view":{
						"color": "primary"
					}}', 
					new_board_id, 
					1)
			RETURNING _id INTO new_widget_id;

			INSERT INTO public."BELONG_TO"(
			 widget_id, sensor_id)
			VALUES ( new_widget_id, sensor_data._id);
		END LOOP;
		RETURN NULL;
    END;

$gen_dash$ LANGUAGE plpgsql;

CREATE TRIGGER generate_dashboard AFTER INSERT ON public."OWN"
    FOR EACH ROW EXECUTE FUNCTION generate_dashboard();