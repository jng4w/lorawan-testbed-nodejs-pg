PGDMP         3                z         
   lorawan-db    12.10    12.9 ?               0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false                       0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false                       0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false                       1262    18215 
   lorawan-db    DATABASE     |   CREATE DATABASE "lorawan-db" WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'en_US.utf8' LC_CTYPE = 'en_US.utf8';
    DROP DATABASE "lorawan-db";
                root    false                        3079    16988    timescaledb 	   EXTENSION     ?   CREATE EXTENSION IF NOT EXISTS timescaledb WITH SCHEMA public;
    DROP EXTENSION timescaledb;
                   false                       0    0    EXTENSION timescaledb    COMMENT     i   COMMENT ON EXTENSION timescaledb IS 'Enables scalable inserts and complex queries for time-series data';
                        false    4                        3079    18216    citext 	   EXTENSION     :   CREATE EXTENSION IF NOT EXISTS citext WITH SCHEMA public;
    DROP EXTENSION citext;
                   false                       0    0    EXTENSION citext    COMMENT     S   COMMENT ON EXTENSION citext IS 'data type for case-insensitive character strings';
                        false    2                        3079    18321    pgcrypto 	   EXTENSION     <   CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;
    DROP EXTENSION pgcrypto;
                   false                       0    0    EXTENSION pgcrypto    COMMENT     <   COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';
                        false    3            _           1247    18359    email    DOMAIN     ?   CREATE DOMAIN public.email AS public.citext
	CONSTRAINT email_check CHECK ((VALUE OPERATOR(public.~) '^[a-zA-Z0-9.!#$%&''*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$'::public.citext));
    DROP DOMAIN public.email;
       public          root    false    2    2    2    2    2    2    2    2    2    2    2    2    2    2    2    2    2    2    2    2    2    2    2    2    2    2    2    2    2    2    2    2    2    2            c           1247    18362    phone    DOMAIN     ?   CREATE DOMAIN public.phone AS public.citext
	CONSTRAINT phone_check CHECK ((VALUE OPERATOR(public.~) '^[0-9]{10,11}$'::public.citext));
    DROP DOMAIN public.phone;
       public          root    false    2    2    2    2    2    2    2    2    2    2    2    2    2    2    2    2    2    2    2    2    2    2    2    2    2    2    2    2    2    2    2    2    2    2            =           1255    18364    generate_dashboard()    FUNCTION     ?  CREATE FUNCTION public.generate_dashboard() RETURNS trigger
    LANGUAGE plpgsql
    AS $$DECLARE 
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
					'{
                          "type": "Card",
                          "numberOfDataSource": {
                            "maxNumber": 1,
                            "defaultNumber": 1
                          },
                          "view": {
                              "Icon": null,
                              "Color of card": "primary"
                          }
                      }', 
					new_board_id, 
					1)
			RETURNING _id INTO new_widget_id;

			INSERT INTO public."BELONG_TO"(
			 widget_id, sensor_id)
			VALUES ( new_widget_id, sensor_data._id);
		END LOOP;
		RETURN NULL;
    END;$$;
 +   DROP FUNCTION public.generate_dashboard();
       public          root    false            >           1255    18365 (   insert_board(character varying, integer) 	   PROCEDURE     ?   CREATE PROCEDURE public.insert_board(new_display_name character varying, ref_profile_id integer)
    LANGUAGE plpgsql
    AS $$

BEGIN
INSERT INTO public."BOARD"(
	display_name, profile_id)
	VALUES (new_display_name, ref_profile_id);

END;
$$;
 `   DROP PROCEDURE public.insert_board(new_display_name character varying, ref_profile_id integer);
       public          root    false            ?           1255    18366 5   insert_device_to_customer(integer, character varying) 	   PROCEDURE     i  CREATE PROCEDURE public.insert_device_to_customer(ref_profile_id integer, INOUT ref_enddev_id character varying)
    LANGUAGE plpgsql
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
$$;
 p   DROP PROCEDURE public.insert_device_to_customer(ref_profile_id integer, INOUT ref_enddev_id character varying);
       public          root    false            @           1255    18367 m   insert_profile(character varying, character varying, character varying, character varying, character varying) 	   PROCEDURE     ?  CREATE PROCEDURE public.insert_profile(new_email character varying, new_phone_number character varying, new_password character varying, new_type character varying, new_display_name character varying)
    LANGUAGE plpgsql
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
$$;
 ?   DROP PROCEDURE public.insert_profile(new_email character varying, new_phone_number character varying, new_password character varying, new_type character varying, new_display_name character varying);
       public          root    false            A           1255    18368 0   insert_widget(character varying, jsonb, integer) 	   PROCEDURE     )  CREATE PROCEDURE public.insert_widget(new_display_name character varying, new_config_dict jsonb, ref_board_id integer)
    LANGUAGE plpgsql
    AS $$

BEGIN
INSERT INTO public."WIDGET"(
	display_name, config_dict, profile_id)
	VALUES (new_display_name, new_config_dict, ref_profile_id);

END;
$$;
 v   DROP PROCEDURE public.insert_widget(new_display_name character varying, new_config_dict jsonb, ref_board_id integer);
       public          root    false            B           1255    18369 h   insert_widget_to_board(character varying, jsonb, integer, integer, character varying, character varying) 	   PROCEDURE       CREATE PROCEDURE public.insert_widget_to_board(new_display_name character varying, new_config_dict jsonb, ref_board_id integer, ref_widget_type_id integer, ref_device_id character varying, ref_sensor_key character varying)
    LANGUAGE plpgsql
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
$$;
 ?   DROP PROCEDURE public.insert_widget_to_board(new_display_name character varying, new_config_dict jsonb, ref_board_id integer, ref_widget_type_id integer, ref_device_id character varying, ref_sensor_key character varying);
       public          root    false            C           1255    18370 ?   process_new_payload(timestamp without time zone, jsonb, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying) 	   PROCEDURE     l  CREATE PROCEDURE public.process_new_payload(new_recv_timestamp timestamp without time zone, new_payload_data jsonb, new_dev_id character varying, new_dev_eui character varying, new_dev_addr character varying, new_join_eui character varying, new_dev_type character varying, new_dev_brand character varying, new_dev_model character varying, new_dev_band character varying)
    LANGUAGE plpgsql
    AS $$DECLARE 
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
		INSERT INTO public."SENSOR" (sensor_key, sensor_config, sensor_type, enddev_id)
		SELECT jsonb_array_elements(dev_type_config->'sensor_list')->>'key' AS sensor_key,
				jsonb_array_elements(dev_type_config->'sensor_list') AS sensor_config,
			'sensor' AS sensor_type,
			_enddev_id AS enddev_id
		FROM public."DEV_TYPE" 
		WHERE _id = _dev_type_id;

		-- insert new controller
		INSERT INTO public."SENSOR" (sensor_key, sensor_config, sensor_type, enddev_id)
		SELECT jsonb_array_elements(dev_type_config->'controller_list')->>'key' AS sensor_key,
				jsonb_array_elements(dev_type_config->'controller_list') AS sensor_config,
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
END;$$;
 r  DROP PROCEDURE public.process_new_payload(new_recv_timestamp timestamp without time zone, new_payload_data jsonb, new_dev_id character varying, new_dev_eui character varying, new_dev_addr character varying, new_join_eui character varying, new_dev_type character varying, new_dev_brand character varying, new_dev_model character varying, new_dev_band character varying);
       public          root    false                        1259    18371    ENDDEV_PAYLOAD    TABLE     ?   CREATE TABLE public."ENDDEV_PAYLOAD" (
    recv_timestamp timestamp without time zone NOT NULL,
    payload_data jsonb NOT NULL,
    enddev_id integer NOT NULL
);
 $   DROP TABLE public."ENDDEV_PAYLOAD";
       public         heap    root    false                       1259    18377    _hyper_6_1_chunk    TABLE       CREATE TABLE _timescaledb_internal._hyper_6_1_chunk (
    CONSTRAINT constraint_1 CHECK (((recv_timestamp >= '2021-12-30 00:00:00'::timestamp without time zone) AND (recv_timestamp < '2022-01-06 00:00:00'::timestamp without time zone)))
)
INHERITS (public."ENDDEV_PAYLOAD");
 3   DROP TABLE _timescaledb_internal._hyper_6_1_chunk;
       _timescaledb_internal         heap    root    false    256    4                       1259    18384    _hyper_6_2_chunk    TABLE       CREATE TABLE _timescaledb_internal._hyper_6_2_chunk (
    CONSTRAINT constraint_2 CHECK (((recv_timestamp >= '2022-01-06 00:00:00'::timestamp without time zone) AND (recv_timestamp < '2022-01-13 00:00:00'::timestamp without time zone)))
)
INHERITS (public."ENDDEV_PAYLOAD");
 3   DROP TABLE _timescaledb_internal._hyper_6_2_chunk;
       _timescaledb_internal         heap    root    false    256    4                       1259    18391    _hyper_6_3_chunk    TABLE       CREATE TABLE _timescaledb_internal._hyper_6_3_chunk (
    CONSTRAINT constraint_3 CHECK (((recv_timestamp >= '2022-01-13 00:00:00'::timestamp without time zone) AND (recv_timestamp < '2022-01-20 00:00:00'::timestamp without time zone)))
)
INHERITS (public."ENDDEV_PAYLOAD");
 3   DROP TABLE _timescaledb_internal._hyper_6_3_chunk;
       _timescaledb_internal         heap    root    false    4    256                       1259    18398    _hyper_6_4_chunk    TABLE       CREATE TABLE _timescaledb_internal._hyper_6_4_chunk (
    CONSTRAINT constraint_4 CHECK (((recv_timestamp >= '2022-01-20 00:00:00'::timestamp without time zone) AND (recv_timestamp < '2022-01-27 00:00:00'::timestamp without time zone)))
)
INHERITS (public."ENDDEV_PAYLOAD");
 3   DROP TABLE _timescaledb_internal._hyper_6_4_chunk;
       _timescaledb_internal         heap    root    false    256    4                       1259    18405    _hyper_6_5_chunk    TABLE       CREATE TABLE _timescaledb_internal._hyper_6_5_chunk (
    CONSTRAINT constraint_5 CHECK (((recv_timestamp >= '2022-01-27 00:00:00'::timestamp without time zone) AND (recv_timestamp < '2022-02-03 00:00:00'::timestamp without time zone)))
)
INHERITS (public."ENDDEV_PAYLOAD");
 3   DROP TABLE _timescaledb_internal._hyper_6_5_chunk;
       _timescaledb_internal         heap    root    false    4    256                       1259    18412    _hyper_6_6_chunk    TABLE       CREATE TABLE _timescaledb_internal._hyper_6_6_chunk (
    CONSTRAINT constraint_6 CHECK (((recv_timestamp >= '2022-02-03 00:00:00'::timestamp without time zone) AND (recv_timestamp < '2022-02-10 00:00:00'::timestamp without time zone)))
)
INHERITS (public."ENDDEV_PAYLOAD");
 3   DROP TABLE _timescaledb_internal._hyper_6_6_chunk;
       _timescaledb_internal         heap    root    false    4    256                       1259    18419    _hyper_6_7_chunk    TABLE       CREATE TABLE _timescaledb_internal._hyper_6_7_chunk (
    CONSTRAINT constraint_7 CHECK (((recv_timestamp >= '2022-02-10 00:00:00'::timestamp without time zone) AND (recv_timestamp < '2022-02-17 00:00:00'::timestamp without time zone)))
)
INHERITS (public."ENDDEV_PAYLOAD");
 3   DROP TABLE _timescaledb_internal._hyper_6_7_chunk;
       _timescaledb_internal         heap    root    false    256    4                       1259    18426    _hyper_6_8_chunk    TABLE       CREATE TABLE _timescaledb_internal._hyper_6_8_chunk (
    CONSTRAINT constraint_8 CHECK (((recv_timestamp >= '2022-02-17 00:00:00'::timestamp without time zone) AND (recv_timestamp < '2022-02-24 00:00:00'::timestamp without time zone)))
)
INHERITS (public."ENDDEV_PAYLOAD");
 3   DROP TABLE _timescaledb_internal._hyper_6_8_chunk;
       _timescaledb_internal         heap    root    false    256    4                       1259    18656    _hyper_6_9_chunk    TABLE       CREATE TABLE _timescaledb_internal._hyper_6_9_chunk (
    CONSTRAINT constraint_9 CHECK (((recv_timestamp >= '2022-02-24 00:00:00'::timestamp without time zone) AND (recv_timestamp < '2022-03-03 00:00:00'::timestamp without time zone)))
)
INHERITS (public."ENDDEV_PAYLOAD");
 3   DROP TABLE _timescaledb_internal._hyper_6_9_chunk;
       _timescaledb_internal         heap    root    false    4    256            	           1259    18433    ADMIN    TABLE     A   CREATE TABLE public."ADMIN" (
    profile_id integer NOT NULL
);
    DROP TABLE public."ADMIN";
       public         heap    root    false            
           1259    18436 	   BELONG_TO    TABLE     d   CREATE TABLE public."BELONG_TO" (
    widget_id integer NOT NULL,
    sensor_id integer NOT NULL
);
    DROP TABLE public."BELONG_TO";
       public         heap    root    false                       1259    18439    BOARD    TABLE     ?   CREATE TABLE public."BOARD" (
    _id integer NOT NULL,
    display_name character varying NOT NULL,
    profile_id integer NOT NULL
);
    DROP TABLE public."BOARD";
       public         heap    root    false                       1259    18445    BOARD__id_seq    SEQUENCE     ?   CREATE SEQUENCE public."BOARD__id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE public."BOARD__id_seq";
       public          root    false    267                       0    0    BOARD__id_seq    SEQUENCE OWNED BY     C   ALTER SEQUENCE public."BOARD__id_seq" OWNED BY public."BOARD"._id;
          public          root    false    268                       1259    18447    CUSTOMER    TABLE     D   CREATE TABLE public."CUSTOMER" (
    profile_id integer NOT NULL
);
    DROP TABLE public."CUSTOMER";
       public         heap    root    false                       1259    18450    DEV_TYPE    TABLE     ?   CREATE TABLE public."DEV_TYPE" (
    _id integer NOT NULL,
    dev_type character varying NOT NULL,
    dev_type_config jsonb
);
    DROP TABLE public."DEV_TYPE";
       public         heap    root    false                       1259    18456    DEVTYPE__id_seq    SEQUENCE     ?   CREATE SEQUENCE public."DEVTYPE__id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE public."DEVTYPE__id_seq";
       public          root    false    270                       0    0    DEVTYPE__id_seq    SEQUENCE OWNED BY     H   ALTER SEQUENCE public."DEVTYPE__id_seq" OWNED BY public."DEV_TYPE"._id;
          public          root    false    271                       1259    18458    ENDDEV    TABLE     ?  CREATE TABLE public."ENDDEV" (
    _id integer NOT NULL,
    display_name character varying NOT NULL,
    dev_id character varying NOT NULL,
    dev_addr character varying NOT NULL,
    join_eui character varying NOT NULL,
    dev_eui character varying NOT NULL,
    dev_brand character varying NOT NULL,
    dev_model character varying NOT NULL,
    dev_band character varying NOT NULL,
    dev_type_id integer
);
    DROP TABLE public."ENDDEV";
       public         heap    root    false                       1259    18464    ENDDEV__id_seq    SEQUENCE     ?   CREATE SEQUENCE public."ENDDEV__id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 '   DROP SEQUENCE public."ENDDEV__id_seq";
       public          root    false    272                       0    0    ENDDEV__id_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE public."ENDDEV__id_seq" OWNED BY public."ENDDEV"._id;
          public          root    false    273                       1259    18466    NOTIFICATION    TABLE     ?   CREATE TABLE public."NOTIFICATION" (
    _id integer NOT NULL,
    title character varying NOT NULL,
    content character varying NOT NULL,
    updated_timestamp timestamp without time zone NOT NULL
);
 "   DROP TABLE public."NOTIFICATION";
       public         heap    root    false                       1259    18472    NOTIFICATION__id_seq    SEQUENCE     ?   CREATE SEQUENCE public."NOTIFICATION__id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 -   DROP SEQUENCE public."NOTIFICATION__id_seq";
       public          root    false    274                       0    0    NOTIFICATION__id_seq    SEQUENCE OWNED BY     Q   ALTER SEQUENCE public."NOTIFICATION__id_seq" OWNED BY public."NOTIFICATION"._id;
          public          root    false    275                       1259    18474    NOTIFY    TABLE     `   CREATE TABLE public."NOTIFY" (
    profile_id integer NOT NULL,
    noti_id integer NOT NULL
);
    DROP TABLE public."NOTIFY";
       public         heap    root    false                       1259    18477    OWN    TABLE     _   CREATE TABLE public."OWN" (
    profile_id integer NOT NULL,
    enddev_id integer NOT NULL
);
    DROP TABLE public."OWN";
       public         heap    root    false                       1259    18480    PROFILE    TABLE        CREATE TABLE public."PROFILE" (
    password character varying NOT NULL,
    type character varying NOT NULL,
    _id integer NOT NULL,
    display_name character varying NOT NULL,
    phone_number public.phone NOT NULL,
    email public.email NOT NULL
);
    DROP TABLE public."PROFILE";
       public         heap    root    false    1119    1123                       1259    18486    PROFILE__id_seq    SEQUENCE     ?   CREATE SEQUENCE public."PROFILE__id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE public."PROFILE__id_seq";
       public          root    false    278                        0    0    PROFILE__id_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE public."PROFILE__id_seq" OWNED BY public."PROFILE"._id;
          public          root    false    279                       1259    18488    SENSOR    TABLE     ?   CREATE TABLE public."SENSOR" (
    enddev_id integer NOT NULL,
    _id integer NOT NULL,
    sensor_key character varying NOT NULL,
    sensor_type character varying NOT NULL,
    sensor_config jsonb
);
    DROP TABLE public."SENSOR";
       public         heap    root    false                       1259    18494    SENSOR__id_seq    SEQUENCE     ?   CREATE SEQUENCE public."SENSOR__id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 '   DROP SEQUENCE public."SENSOR__id_seq";
       public          root    false    280            !           0    0    SENSOR__id_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE public."SENSOR__id_seq" OWNED BY public."SENSOR"._id;
          public          root    false    281                       1259    18496    WIDGET    TABLE     ?   CREATE TABLE public."WIDGET" (
    _id integer NOT NULL,
    display_name character varying NOT NULL,
    config_dict jsonb,
    board_id integer NOT NULL,
    widget_type_id integer NOT NULL
);
    DROP TABLE public."WIDGET";
       public         heap    root    false                       1259    18502    WIDGET_TYPE    TABLE     u   CREATE TABLE public."WIDGET_TYPE" (
    _id integer NOT NULL,
    ui_config jsonb,
    category character varying
);
 !   DROP TABLE public."WIDGET_TYPE";
       public         heap    root    false                       1259    18508    WIDGET_TYPE__id_seq    SEQUENCE     ?   CREATE SEQUENCE public."WIDGET_TYPE__id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ,   DROP SEQUENCE public."WIDGET_TYPE__id_seq";
       public          root    false    283            "           0    0    WIDGET_TYPE__id_seq    SEQUENCE OWNED BY     O   ALTER SEQUENCE public."WIDGET_TYPE__id_seq" OWNED BY public."WIDGET_TYPE"._id;
          public          root    false    284                       1259    18510    WIDGET__id_seq    SEQUENCE     ?   CREATE SEQUENCE public."WIDGET__id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 '   DROP SEQUENCE public."WIDGET__id_seq";
       public          root    false    282            #           0    0    WIDGET__id_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE public."WIDGET__id_seq" OWNED BY public."WIDGET"._id;
          public          root    false    285            ?           2604    18664 	   BOARD _id    DEFAULT     j   ALTER TABLE ONLY public."BOARD" ALTER COLUMN _id SET DEFAULT nextval('public."BOARD__id_seq"'::regclass);
 :   ALTER TABLE public."BOARD" ALTER COLUMN _id DROP DEFAULT;
       public          root    false    268    267            ?           2604    18665    DEV_TYPE _id    DEFAULT     o   ALTER TABLE ONLY public."DEV_TYPE" ALTER COLUMN _id SET DEFAULT nextval('public."DEVTYPE__id_seq"'::regclass);
 =   ALTER TABLE public."DEV_TYPE" ALTER COLUMN _id DROP DEFAULT;
       public          root    false    271    270            ?           2604    18666 
   ENDDEV _id    DEFAULT     l   ALTER TABLE ONLY public."ENDDEV" ALTER COLUMN _id SET DEFAULT nextval('public."ENDDEV__id_seq"'::regclass);
 ;   ALTER TABLE public."ENDDEV" ALTER COLUMN _id DROP DEFAULT;
       public          root    false    273    272            ?           2604    18667    NOTIFICATION _id    DEFAULT     x   ALTER TABLE ONLY public."NOTIFICATION" ALTER COLUMN _id SET DEFAULT nextval('public."NOTIFICATION__id_seq"'::regclass);
 A   ALTER TABLE public."NOTIFICATION" ALTER COLUMN _id DROP DEFAULT;
       public          root    false    275    274            ?           2604    18668    PROFILE _id    DEFAULT     n   ALTER TABLE ONLY public."PROFILE" ALTER COLUMN _id SET DEFAULT nextval('public."PROFILE__id_seq"'::regclass);
 <   ALTER TABLE public."PROFILE" ALTER COLUMN _id DROP DEFAULT;
       public          root    false    279    278            ?           2604    18669 
   SENSOR _id    DEFAULT     l   ALTER TABLE ONLY public."SENSOR" ALTER COLUMN _id SET DEFAULT nextval('public."SENSOR__id_seq"'::regclass);
 ;   ALTER TABLE public."SENSOR" ALTER COLUMN _id DROP DEFAULT;
       public          root    false    281    280            ?           2604    18670 
   WIDGET _id    DEFAULT     l   ALTER TABLE ONLY public."WIDGET" ALTER COLUMN _id SET DEFAULT nextval('public."WIDGET__id_seq"'::regclass);
 ;   ALTER TABLE public."WIDGET" ALTER COLUMN _id DROP DEFAULT;
       public          root    false    285    282            ?           2604    18671    WIDGET_TYPE _id    DEFAULT     v   ALTER TABLE ONLY public."WIDGET_TYPE" ALTER COLUMN _id SET DEFAULT nextval('public."WIDGET_TYPE__id_seq"'::regclass);
 @   ALTER TABLE public."WIDGET_TYPE" ALTER COLUMN _id DROP DEFAULT;
       public          root    false    284    283            ?          0    17338    cache_inval_bgw_job 
   TABLE DATA           9   COPY _timescaledb_cache.cache_inval_bgw_job  FROM stdin;
    _timescaledb_cache          root    false    243   O?       ?          0    17341    cache_inval_extension 
   TABLE DATA           ;   COPY _timescaledb_cache.cache_inval_extension  FROM stdin;
    _timescaledb_cache          root    false    244   l?       ?          0    17335    cache_inval_hypertable 
   TABLE DATA           <   COPY _timescaledb_cache.cache_inval_hypertable  FROM stdin;
    _timescaledb_cache          root    false    242   ??       ?          0    17007 
   hypertable 
   TABLE DATA             COPY _timescaledb_catalog.hypertable (id, schema_name, table_name, associated_schema_name, associated_table_prefix, num_dimensions, chunk_sizing_func_schema, chunk_sizing_func_name, chunk_target_size, compression_state, compressed_hypertable_id, replication_factor) FROM stdin;
    _timescaledb_catalog          root    false    212   ??       ?          0    17092    chunk 
   TABLE DATA              COPY _timescaledb_catalog.chunk (id, hypertable_id, schema_name, table_name, compressed_chunk_id, dropped, status) FROM stdin;
    _timescaledb_catalog          root    false    221          ?          0    17057 	   dimension 
   TABLE DATA           ?   COPY _timescaledb_catalog.dimension (id, hypertable_id, column_name, column_type, aligned, num_slices, partitioning_func_schema, partitioning_func, interval_length, integer_now_func_schema, integer_now_func) FROM stdin;
    _timescaledb_catalog          root    false    217   ?       ?          0    17076    dimension_slice 
   TABLE DATA           a   COPY _timescaledb_catalog.dimension_slice (id, dimension_id, range_start, range_end) FROM stdin;
    _timescaledb_catalog          root    false    219   ?       ?          0    17114    chunk_constraint 
   TABLE DATA           ?   COPY _timescaledb_catalog.chunk_constraint (chunk_id, dimension_slice_id, constraint_name, hypertable_constraint_name) FROM stdin;
    _timescaledb_catalog          root    false    222   d      ?          0    17148    chunk_data_node 
   TABLE DATA           [   COPY _timescaledb_catalog.chunk_data_node (chunk_id, node_chunk_id, node_name) FROM stdin;
    _timescaledb_catalog          root    false    225         ?          0    17132    chunk_index 
   TABLE DATA           o   COPY _timescaledb_catalog.chunk_index (chunk_id, index_name, hypertable_id, hypertable_index_name) FROM stdin;
    _timescaledb_catalog          root    false    224   5      ?          0    17297    compression_chunk_size 
   TABLE DATA             COPY _timescaledb_catalog.compression_chunk_size (chunk_id, compressed_chunk_id, uncompressed_heap_size, uncompressed_toast_size, uncompressed_index_size, compressed_heap_size, compressed_toast_size, compressed_index_size, numrows_pre_compression, numrows_post_compression) FROM stdin;
    _timescaledb_catalog          root    false    238   ?      ?          0    17213    continuous_agg 
   TABLE DATA           ?   COPY _timescaledb_catalog.continuous_agg (mat_hypertable_id, raw_hypertable_id, user_view_schema, user_view_name, partial_view_schema, partial_view_name, bucket_width, direct_view_schema, direct_view_name, materialized_only) FROM stdin;
    _timescaledb_catalog          root    false    231         ?          0    17234    continuous_aggs_bucket_function 
   TABLE DATA           ?   COPY _timescaledb_catalog.continuous_aggs_bucket_function (mat_hypertable_id, experimental, name, bucket_width, origin, timezone) FROM stdin;
    _timescaledb_catalog          root    false    232          ?          0    17257 +   continuous_aggs_hypertable_invalidation_log 
   TABLE DATA           ?   COPY _timescaledb_catalog.continuous_aggs_hypertable_invalidation_log (hypertable_id, lowest_modified_value, greatest_modified_value) FROM stdin;
    _timescaledb_catalog          root    false    234   =      ?          0    17247 &   continuous_aggs_invalidation_threshold 
   TABLE DATA           h   COPY _timescaledb_catalog.continuous_aggs_invalidation_threshold (hypertable_id, watermark) FROM stdin;
    _timescaledb_catalog          root    false    233   Z      ?          0    17261 0   continuous_aggs_materialization_invalidation_log 
   TABLE DATA           ?   COPY _timescaledb_catalog.continuous_aggs_materialization_invalidation_log (materialization_id, lowest_modified_value, greatest_modified_value) FROM stdin;
    _timescaledb_catalog          root    false    235   w      ?          0    17278    hypertable_compression 
   TABLE DATA           ?   COPY _timescaledb_catalog.hypertable_compression (hypertable_id, attname, compression_algorithm_id, segmentby_column_index, orderby_column_index, orderby_asc, orderby_nullsfirst) FROM stdin;
    _timescaledb_catalog          root    false    237   ?      ?          0    17028    hypertable_data_node 
   TABLE DATA           x   COPY _timescaledb_catalog.hypertable_data_node (hypertable_id, node_hypertable_id, node_name, block_chunks) FROM stdin;
    _timescaledb_catalog          root    false    213   ?      ?          0    17205    metadata 
   TABLE DATA           R   COPY _timescaledb_catalog.metadata (key, value, include_in_telemetry) FROM stdin;
    _timescaledb_catalog          root    false    230   ?      ?          0    17312 
   remote_txn 
   TABLE DATA           Y   COPY _timescaledb_catalog.remote_txn (data_node_name, remote_transaction_id) FROM stdin;
    _timescaledb_catalog          root    false    239          ?          0    17042 
   tablespace 
   TABLE DATA           V   COPY _timescaledb_catalog.tablespace (id, hypertable_id, tablespace_name) FROM stdin;
    _timescaledb_catalog          root    false    215   =      ?          0    17162    bgw_job 
   TABLE DATA           ?   COPY _timescaledb_config.bgw_job (id, application_name, schedule_interval, max_runtime, max_retries, retry_period, proc_schema, proc_name, owner, scheduled, hypertable_id, config) FROM stdin;
    _timescaledb_config          root    false    227   Z      ?          0    18377    _hyper_6_1_chunk 
   TABLE DATA           b   COPY _timescaledb_internal._hyper_6_1_chunk (recv_timestamp, payload_data, enddev_id) FROM stdin;
    _timescaledb_internal          root    false    257   ?      ?          0    18384    _hyper_6_2_chunk 
   TABLE DATA           b   COPY _timescaledb_internal._hyper_6_2_chunk (recv_timestamp, payload_data, enddev_id) FROM stdin;
    _timescaledb_internal          root    false    258         ?          0    18391    _hyper_6_3_chunk 
   TABLE DATA           b   COPY _timescaledb_internal._hyper_6_3_chunk (recv_timestamp, payload_data, enddev_id) FROM stdin;
    _timescaledb_internal          root    false    259   )      ?          0    18398    _hyper_6_4_chunk 
   TABLE DATA           b   COPY _timescaledb_internal._hyper_6_4_chunk (recv_timestamp, payload_data, enddev_id) FROM stdin;
    _timescaledb_internal          root    false    260   F      ?          0    18405    _hyper_6_5_chunk 
   TABLE DATA           b   COPY _timescaledb_internal._hyper_6_5_chunk (recv_timestamp, payload_data, enddev_id) FROM stdin;
    _timescaledb_internal          root    false    261   c      ?          0    18412    _hyper_6_6_chunk 
   TABLE DATA           b   COPY _timescaledb_internal._hyper_6_6_chunk (recv_timestamp, payload_data, enddev_id) FROM stdin;
    _timescaledb_internal          root    false    262   ?      ?          0    18419    _hyper_6_7_chunk 
   TABLE DATA           b   COPY _timescaledb_internal._hyper_6_7_chunk (recv_timestamp, payload_data, enddev_id) FROM stdin;
    _timescaledb_internal          root    false    263   ?      ?          0    18426    _hyper_6_8_chunk 
   TABLE DATA           b   COPY _timescaledb_internal._hyper_6_8_chunk (recv_timestamp, payload_data, enddev_id) FROM stdin;
    _timescaledb_internal          root    false    264   ?                0    18656    _hyper_6_9_chunk 
   TABLE DATA           b   COPY _timescaledb_internal._hyper_6_9_chunk (recv_timestamp, payload_data, enddev_id) FROM stdin;
    _timescaledb_internal          root    false    286   `+      ?          0    18433    ADMIN 
   TABLE DATA           -   COPY public."ADMIN" (profile_id) FROM stdin;
    public          root    false    265   ?/      ?          0    18436 	   BELONG_TO 
   TABLE DATA           ;   COPY public."BELONG_TO" (widget_id, sensor_id) FROM stdin;
    public          root    false    266   ?/      ?          0    18439    BOARD 
   TABLE DATA           @   COPY public."BOARD" (_id, display_name, profile_id) FROM stdin;
    public          root    false    267   0                0    18447    CUSTOMER 
   TABLE DATA           0   COPY public."CUSTOMER" (profile_id) FROM stdin;
    public          root    false    269   j0                0    18450    DEV_TYPE 
   TABLE DATA           D   COPY public."DEV_TYPE" (_id, dev_type, dev_type_config) FROM stdin;
    public          root    false    270   ?0                0    18458    ENDDEV 
   TABLE DATA           ?   COPY public."ENDDEV" (_id, display_name, dev_id, dev_addr, join_eui, dev_eui, dev_brand, dev_model, dev_band, dev_type_id) FROM stdin;
    public          root    false    272   ?2      ?          0    18371    ENDDEV_PAYLOAD 
   TABLE DATA           S   COPY public."ENDDEV_PAYLOAD" (recv_timestamp, payload_data, enddev_id) FROM stdin;
    public          root    false    256   a3                0    18466    NOTIFICATION 
   TABLE DATA           P   COPY public."NOTIFICATION" (_id, title, content, updated_timestamp) FROM stdin;
    public          root    false    274   ~3                0    18474    NOTIFY 
   TABLE DATA           7   COPY public."NOTIFY" (profile_id, noti_id) FROM stdin;
    public          root    false    276   ?3      	          0    18477    OWN 
   TABLE DATA           6   COPY public."OWN" (profile_id, enddev_id) FROM stdin;
    public          root    false    277   ?3      
          0    18480    PROFILE 
   TABLE DATA           [   COPY public."PROFILE" (password, type, _id, display_name, phone_number, email) FROM stdin;
    public          root    false    278   ?3                0    18488    SENSOR 
   TABLE DATA           Z   COPY public."SENSOR" (enddev_id, _id, sensor_key, sensor_type, sensor_config) FROM stdin;
    public          root    false    280   5                0    18496    WIDGET 
   TABLE DATA           \   COPY public."WIDGET" (_id, display_name, config_dict, board_id, widget_type_id) FROM stdin;
    public          root    false    282   K7                0    18502    WIDGET_TYPE 
   TABLE DATA           A   COPY public."WIDGET_TYPE" (_id, ui_config, category) FROM stdin;
    public          root    false    283   9      $           0    0    chunk_constraint_name    SEQUENCE SET     Q   SELECT pg_catalog.setval('_timescaledb_catalog.chunk_constraint_name', 8, true);
          _timescaledb_catalog          root    false    223            %           0    0    chunk_id_seq    SEQUENCE SET     H   SELECT pg_catalog.setval('_timescaledb_catalog.chunk_id_seq', 8, true);
          _timescaledb_catalog          root    false    220            &           0    0    dimension_id_seq    SEQUENCE SET     L   SELECT pg_catalog.setval('_timescaledb_catalog.dimension_id_seq', 6, true);
          _timescaledb_catalog          root    false    216            '           0    0    dimension_slice_id_seq    SEQUENCE SET     R   SELECT pg_catalog.setval('_timescaledb_catalog.dimension_slice_id_seq', 8, true);
          _timescaledb_catalog          root    false    218            (           0    0    hypertable_id_seq    SEQUENCE SET     M   SELECT pg_catalog.setval('_timescaledb_catalog.hypertable_id_seq', 6, true);
          _timescaledb_catalog          root    false    211            )           0    0    bgw_job_id_seq    SEQUENCE SET     L   SELECT pg_catalog.setval('_timescaledb_config.bgw_job_id_seq', 1000, true);
          _timescaledb_config          root    false    226            *           0    0    BOARD__id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public."BOARD__id_seq"', 70, true);
          public          root    false    268            +           0    0    DEVTYPE__id_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('public."DEVTYPE__id_seq"', 5, true);
          public          root    false    271            ,           0    0    ENDDEV__id_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('public."ENDDEV__id_seq"', 75, true);
          public          root    false    273            -           0    0    NOTIFICATION__id_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public."NOTIFICATION__id_seq"', 1, false);
          public          root    false    275            .           0    0    PROFILE__id_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('public."PROFILE__id_seq"', 9, true);
          public          root    false    279            /           0    0    SENSOR__id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public."SENSOR__id_seq"', 217, true);
          public          root    false    281            0           0    0    WIDGET_TYPE__id_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public."WIDGET_TYPE__id_seq"', 8, true);
          public          root    false    284            1           0    0    WIDGET__id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public."WIDGET__id_seq"', 345, true);
          public          root    false    285            2           2606    18524    ADMIN ADMIN_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public."ADMIN"
    ADD CONSTRAINT "ADMIN_pkey" PRIMARY KEY (profile_id);
 >   ALTER TABLE ONLY public."ADMIN" DROP CONSTRAINT "ADMIN_pkey";
       public            root    false    265            4           2606    18526    BELONG_TO BELONG_TO_pkey 
   CONSTRAINT     l   ALTER TABLE ONLY public."BELONG_TO"
    ADD CONSTRAINT "BELONG_TO_pkey" PRIMARY KEY (widget_id, sensor_id);
 F   ALTER TABLE ONLY public."BELONG_TO" DROP CONSTRAINT "BELONG_TO_pkey";
       public            root    false    266    266            6           2606    18528    BOARD BOARD_pkey 
   CONSTRAINT     S   ALTER TABLE ONLY public."BOARD"
    ADD CONSTRAINT "BOARD_pkey" PRIMARY KEY (_id);
 >   ALTER TABLE ONLY public."BOARD" DROP CONSTRAINT "BOARD_pkey";
       public            root    false    267            8           2606    18530    CUSTOMER CUSTOMER_pkey 
   CONSTRAINT     `   ALTER TABLE ONLY public."CUSTOMER"
    ADD CONSTRAINT "CUSTOMER_pkey" PRIMARY KEY (profile_id);
 D   ALTER TABLE ONLY public."CUSTOMER" DROP CONSTRAINT "CUSTOMER_pkey";
       public            root    false    269            :           2606    18532    DEV_TYPE DEVTYPE_dev_type_key 
   CONSTRAINT     `   ALTER TABLE ONLY public."DEV_TYPE"
    ADD CONSTRAINT "DEVTYPE_dev_type_key" UNIQUE (dev_type);
 K   ALTER TABLE ONLY public."DEV_TYPE" DROP CONSTRAINT "DEVTYPE_dev_type_key";
       public            root    false    270            <           2606    18534    DEV_TYPE DEVTYPE_pkey 
   CONSTRAINT     X   ALTER TABLE ONLY public."DEV_TYPE"
    ADD CONSTRAINT "DEVTYPE_pkey" PRIMARY KEY (_id);
 C   ALTER TABLE ONLY public."DEV_TYPE" DROP CONSTRAINT "DEVTYPE_pkey";
       public            root    false    270            >           2606    18536    ENDDEV ENDDEV_dev_id_key 
   CONSTRAINT     Y   ALTER TABLE ONLY public."ENDDEV"
    ADD CONSTRAINT "ENDDEV_dev_id_key" UNIQUE (dev_id);
 F   ALTER TABLE ONLY public."ENDDEV" DROP CONSTRAINT "ENDDEV_dev_id_key";
       public            root    false    272            @           2606    18538    ENDDEV ENDDEV_pkey 
   CONSTRAINT     U   ALTER TABLE ONLY public."ENDDEV"
    ADD CONSTRAINT "ENDDEV_pkey" PRIMARY KEY (_id);
 @   ALTER TABLE ONLY public."ENDDEV" DROP CONSTRAINT "ENDDEV_pkey";
       public            root    false    272            B           2606    18540    NOTIFICATION NOTIFICATION_pkey 
   CONSTRAINT     a   ALTER TABLE ONLY public."NOTIFICATION"
    ADD CONSTRAINT "NOTIFICATION_pkey" PRIMARY KEY (_id);
 L   ALTER TABLE ONLY public."NOTIFICATION" DROP CONSTRAINT "NOTIFICATION_pkey";
       public            root    false    274            D           2606    18542    NOTIFY NOTIFY_pkey 
   CONSTRAINT     e   ALTER TABLE ONLY public."NOTIFY"
    ADD CONSTRAINT "NOTIFY_pkey" PRIMARY KEY (profile_id, noti_id);
 @   ALTER TABLE ONLY public."NOTIFY" DROP CONSTRAINT "NOTIFY_pkey";
       public            root    false    276    276            F           2606    18544    OWN OWN_pkey 
   CONSTRAINT     a   ALTER TABLE ONLY public."OWN"
    ADD CONSTRAINT "OWN_pkey" PRIMARY KEY (profile_id, enddev_id);
 :   ALTER TABLE ONLY public."OWN" DROP CONSTRAINT "OWN_pkey";
       public            root    false    277    277            H           2606    18546    PROFILE PROFILE_email_key 
   CONSTRAINT     Y   ALTER TABLE ONLY public."PROFILE"
    ADD CONSTRAINT "PROFILE_email_key" UNIQUE (email);
 G   ALTER TABLE ONLY public."PROFILE" DROP CONSTRAINT "PROFILE_email_key";
       public            root    false    278            J           2606    18548     PROFILE PROFILE_phone_number_key 
   CONSTRAINT     g   ALTER TABLE ONLY public."PROFILE"
    ADD CONSTRAINT "PROFILE_phone_number_key" UNIQUE (phone_number);
 N   ALTER TABLE ONLY public."PROFILE" DROP CONSTRAINT "PROFILE_phone_number_key";
       public            root    false    278            L           2606    18550    PROFILE PROFILE_pkey 
   CONSTRAINT     W   ALTER TABLE ONLY public."PROFILE"
    ADD CONSTRAINT "PROFILE_pkey" PRIMARY KEY (_id);
 B   ALTER TABLE ONLY public."PROFILE" DROP CONSTRAINT "PROFILE_pkey";
       public            root    false    278            N           2606    18552    SENSOR SENSOR_pkey 
   CONSTRAINT     U   ALTER TABLE ONLY public."SENSOR"
    ADD CONSTRAINT "SENSOR_pkey" PRIMARY KEY (_id);
 @   ALTER TABLE ONLY public."SENSOR" DROP CONSTRAINT "SENSOR_pkey";
       public            root    false    280            R           2606    18554    WIDGET_TYPE WIDGET_TYPE_pkey 
   CONSTRAINT     _   ALTER TABLE ONLY public."WIDGET_TYPE"
    ADD CONSTRAINT "WIDGET_TYPE_pkey" PRIMARY KEY (_id);
 J   ALTER TABLE ONLY public."WIDGET_TYPE" DROP CONSTRAINT "WIDGET_TYPE_pkey";
       public            root    false    283            P           2606    18556    WIDGET WIDGET_pkey 
   CONSTRAINT     U   ALTER TABLE ONLY public."WIDGET"
    ADD CONSTRAINT "WIDGET_pkey" PRIMARY KEY (_id);
 @   ALTER TABLE ONLY public."WIDGET" DROP CONSTRAINT "WIDGET_pkey";
       public            root    false    282            !           1259    18557 2   _hyper_6_1_chunk_ENDDEV_PAYLOAD_recv_timestamp_idx    INDEX     ?   CREATE INDEX "_hyper_6_1_chunk_ENDDEV_PAYLOAD_recv_timestamp_idx" ON _timescaledb_internal._hyper_6_1_chunk USING btree (recv_timestamp DESC);
 W   DROP INDEX _timescaledb_internal."_hyper_6_1_chunk_ENDDEV_PAYLOAD_recv_timestamp_idx";
       _timescaledb_internal            root    false    257            "           1259    18566 4   _hyper_6_1_chunk_ENDDEV_PAYLOAD_recv_timestamp_idx_1    INDEX     ?   CREATE INDEX "_hyper_6_1_chunk_ENDDEV_PAYLOAD_recv_timestamp_idx_1" ON _timescaledb_internal._hyper_6_1_chunk USING btree (recv_timestamp DESC);
 Y   DROP INDEX _timescaledb_internal."_hyper_6_1_chunk_ENDDEV_PAYLOAD_recv_timestamp_idx_1";
       _timescaledb_internal            root    false    257            #           1259    18558 2   _hyper_6_2_chunk_ENDDEV_PAYLOAD_recv_timestamp_idx    INDEX     ?   CREATE INDEX "_hyper_6_2_chunk_ENDDEV_PAYLOAD_recv_timestamp_idx" ON _timescaledb_internal._hyper_6_2_chunk USING btree (recv_timestamp DESC);
 W   DROP INDEX _timescaledb_internal."_hyper_6_2_chunk_ENDDEV_PAYLOAD_recv_timestamp_idx";
       _timescaledb_internal            root    false    258            $           1259    18567 4   _hyper_6_2_chunk_ENDDEV_PAYLOAD_recv_timestamp_idx_1    INDEX     ?   CREATE INDEX "_hyper_6_2_chunk_ENDDEV_PAYLOAD_recv_timestamp_idx_1" ON _timescaledb_internal._hyper_6_2_chunk USING btree (recv_timestamp DESC);
 Y   DROP INDEX _timescaledb_internal."_hyper_6_2_chunk_ENDDEV_PAYLOAD_recv_timestamp_idx_1";
       _timescaledb_internal            root    false    258            %           1259    18559 2   _hyper_6_3_chunk_ENDDEV_PAYLOAD_recv_timestamp_idx    INDEX     ?   CREATE INDEX "_hyper_6_3_chunk_ENDDEV_PAYLOAD_recv_timestamp_idx" ON _timescaledb_internal._hyper_6_3_chunk USING btree (recv_timestamp DESC);
 W   DROP INDEX _timescaledb_internal."_hyper_6_3_chunk_ENDDEV_PAYLOAD_recv_timestamp_idx";
       _timescaledb_internal            root    false    259            &           1259    18568 4   _hyper_6_3_chunk_ENDDEV_PAYLOAD_recv_timestamp_idx_1    INDEX     ?   CREATE INDEX "_hyper_6_3_chunk_ENDDEV_PAYLOAD_recv_timestamp_idx_1" ON _timescaledb_internal._hyper_6_3_chunk USING btree (recv_timestamp DESC);
 Y   DROP INDEX _timescaledb_internal."_hyper_6_3_chunk_ENDDEV_PAYLOAD_recv_timestamp_idx_1";
       _timescaledb_internal            root    false    259            '           1259    18560 2   _hyper_6_4_chunk_ENDDEV_PAYLOAD_recv_timestamp_idx    INDEX     ?   CREATE INDEX "_hyper_6_4_chunk_ENDDEV_PAYLOAD_recv_timestamp_idx" ON _timescaledb_internal._hyper_6_4_chunk USING btree (recv_timestamp DESC);
 W   DROP INDEX _timescaledb_internal."_hyper_6_4_chunk_ENDDEV_PAYLOAD_recv_timestamp_idx";
       _timescaledb_internal            root    false    260            (           1259    18569 4   _hyper_6_4_chunk_ENDDEV_PAYLOAD_recv_timestamp_idx_1    INDEX     ?   CREATE INDEX "_hyper_6_4_chunk_ENDDEV_PAYLOAD_recv_timestamp_idx_1" ON _timescaledb_internal._hyper_6_4_chunk USING btree (recv_timestamp DESC);
 Y   DROP INDEX _timescaledb_internal."_hyper_6_4_chunk_ENDDEV_PAYLOAD_recv_timestamp_idx_1";
       _timescaledb_internal            root    false    260            )           1259    18561 2   _hyper_6_5_chunk_ENDDEV_PAYLOAD_recv_timestamp_idx    INDEX     ?   CREATE INDEX "_hyper_6_5_chunk_ENDDEV_PAYLOAD_recv_timestamp_idx" ON _timescaledb_internal._hyper_6_5_chunk USING btree (recv_timestamp DESC);
 W   DROP INDEX _timescaledb_internal."_hyper_6_5_chunk_ENDDEV_PAYLOAD_recv_timestamp_idx";
       _timescaledb_internal            root    false    261            *           1259    18570 4   _hyper_6_5_chunk_ENDDEV_PAYLOAD_recv_timestamp_idx_1    INDEX     ?   CREATE INDEX "_hyper_6_5_chunk_ENDDEV_PAYLOAD_recv_timestamp_idx_1" ON _timescaledb_internal._hyper_6_5_chunk USING btree (recv_timestamp DESC);
 Y   DROP INDEX _timescaledb_internal."_hyper_6_5_chunk_ENDDEV_PAYLOAD_recv_timestamp_idx_1";
       _timescaledb_internal            root    false    261            +           1259    18562 2   _hyper_6_6_chunk_ENDDEV_PAYLOAD_recv_timestamp_idx    INDEX     ?   CREATE INDEX "_hyper_6_6_chunk_ENDDEV_PAYLOAD_recv_timestamp_idx" ON _timescaledb_internal._hyper_6_6_chunk USING btree (recv_timestamp DESC);
 W   DROP INDEX _timescaledb_internal."_hyper_6_6_chunk_ENDDEV_PAYLOAD_recv_timestamp_idx";
       _timescaledb_internal            root    false    262            ,           1259    18571 4   _hyper_6_6_chunk_ENDDEV_PAYLOAD_recv_timestamp_idx_1    INDEX     ?   CREATE INDEX "_hyper_6_6_chunk_ENDDEV_PAYLOAD_recv_timestamp_idx_1" ON _timescaledb_internal._hyper_6_6_chunk USING btree (recv_timestamp DESC);
 Y   DROP INDEX _timescaledb_internal."_hyper_6_6_chunk_ENDDEV_PAYLOAD_recv_timestamp_idx_1";
       _timescaledb_internal            root    false    262            -           1259    18563 2   _hyper_6_7_chunk_ENDDEV_PAYLOAD_recv_timestamp_idx    INDEX     ?   CREATE INDEX "_hyper_6_7_chunk_ENDDEV_PAYLOAD_recv_timestamp_idx" ON _timescaledb_internal._hyper_6_7_chunk USING btree (recv_timestamp DESC);
 W   DROP INDEX _timescaledb_internal."_hyper_6_7_chunk_ENDDEV_PAYLOAD_recv_timestamp_idx";
       _timescaledb_internal            root    false    263            .           1259    18572 4   _hyper_6_7_chunk_ENDDEV_PAYLOAD_recv_timestamp_idx_1    INDEX     ?   CREATE INDEX "_hyper_6_7_chunk_ENDDEV_PAYLOAD_recv_timestamp_idx_1" ON _timescaledb_internal._hyper_6_7_chunk USING btree (recv_timestamp DESC);
 Y   DROP INDEX _timescaledb_internal."_hyper_6_7_chunk_ENDDEV_PAYLOAD_recv_timestamp_idx_1";
       _timescaledb_internal            root    false    263            /           1259    18564 2   _hyper_6_8_chunk_ENDDEV_PAYLOAD_recv_timestamp_idx    INDEX     ?   CREATE INDEX "_hyper_6_8_chunk_ENDDEV_PAYLOAD_recv_timestamp_idx" ON _timescaledb_internal._hyper_6_8_chunk USING btree (recv_timestamp DESC);
 W   DROP INDEX _timescaledb_internal."_hyper_6_8_chunk_ENDDEV_PAYLOAD_recv_timestamp_idx";
       _timescaledb_internal            root    false    264            0           1259    18573 4   _hyper_6_8_chunk_ENDDEV_PAYLOAD_recv_timestamp_idx_1    INDEX     ?   CREATE INDEX "_hyper_6_8_chunk_ENDDEV_PAYLOAD_recv_timestamp_idx_1" ON _timescaledb_internal._hyper_6_8_chunk USING btree (recv_timestamp DESC);
 Y   DROP INDEX _timescaledb_internal."_hyper_6_8_chunk_ENDDEV_PAYLOAD_recv_timestamp_idx_1";
       _timescaledb_internal            root    false    264            S           1259    18663 2   _hyper_6_9_chunk_ENDDEV_PAYLOAD_recv_timestamp_idx    INDEX     ?   CREATE INDEX "_hyper_6_9_chunk_ENDDEV_PAYLOAD_recv_timestamp_idx" ON _timescaledb_internal._hyper_6_9_chunk USING btree (recv_timestamp DESC);
 W   DROP INDEX _timescaledb_internal."_hyper_6_9_chunk_ENDDEV_PAYLOAD_recv_timestamp_idx";
       _timescaledb_internal            root    false    286                        1259    18565 !   ENDDEV_PAYLOAD_recv_timestamp_idx    INDEX     o   CREATE INDEX "ENDDEV_PAYLOAD_recv_timestamp_idx" ON public."ENDDEV_PAYLOAD" USING btree (recv_timestamp DESC);
 7   DROP INDEX public."ENDDEV_PAYLOAD_recv_timestamp_idx";
       public            root    false    256            b           2620    18576 "   _hyper_6_1_chunk ts_insert_blocker    TRIGGER     ?   CREATE TRIGGER ts_insert_blocker BEFORE INSERT ON _timescaledb_internal._hyper_6_1_chunk FOR EACH ROW EXECUTE FUNCTION _timescaledb_internal.insert_blocker();
 J   DROP TRIGGER ts_insert_blocker ON _timescaledb_internal._hyper_6_1_chunk;
       _timescaledb_internal          root    false    257    4    4            c           2620    18577 "   _hyper_6_2_chunk ts_insert_blocker    TRIGGER     ?   CREATE TRIGGER ts_insert_blocker BEFORE INSERT ON _timescaledb_internal._hyper_6_2_chunk FOR EACH ROW EXECUTE FUNCTION _timescaledb_internal.insert_blocker();
 J   DROP TRIGGER ts_insert_blocker ON _timescaledb_internal._hyper_6_2_chunk;
       _timescaledb_internal          root    false    4    4    258            d           2620    18578 "   _hyper_6_3_chunk ts_insert_blocker    TRIGGER     ?   CREATE TRIGGER ts_insert_blocker BEFORE INSERT ON _timescaledb_internal._hyper_6_3_chunk FOR EACH ROW EXECUTE FUNCTION _timescaledb_internal.insert_blocker();
 J   DROP TRIGGER ts_insert_blocker ON _timescaledb_internal._hyper_6_3_chunk;
       _timescaledb_internal          root    false    259    4    4            e           2620    18579 "   _hyper_6_4_chunk ts_insert_blocker    TRIGGER     ?   CREATE TRIGGER ts_insert_blocker BEFORE INSERT ON _timescaledb_internal._hyper_6_4_chunk FOR EACH ROW EXECUTE FUNCTION _timescaledb_internal.insert_blocker();
 J   DROP TRIGGER ts_insert_blocker ON _timescaledb_internal._hyper_6_4_chunk;
       _timescaledb_internal          root    false    4    4    260            f           2620    18580 "   _hyper_6_5_chunk ts_insert_blocker    TRIGGER     ?   CREATE TRIGGER ts_insert_blocker BEFORE INSERT ON _timescaledb_internal._hyper_6_5_chunk FOR EACH ROW EXECUTE FUNCTION _timescaledb_internal.insert_blocker();
 J   DROP TRIGGER ts_insert_blocker ON _timescaledb_internal._hyper_6_5_chunk;
       _timescaledb_internal          root    false    261    4    4            g           2620    18581 "   _hyper_6_6_chunk ts_insert_blocker    TRIGGER     ?   CREATE TRIGGER ts_insert_blocker BEFORE INSERT ON _timescaledb_internal._hyper_6_6_chunk FOR EACH ROW EXECUTE FUNCTION _timescaledb_internal.insert_blocker();
 J   DROP TRIGGER ts_insert_blocker ON _timescaledb_internal._hyper_6_6_chunk;
       _timescaledb_internal          root    false    262    4    4            h           2620    18582 "   _hyper_6_7_chunk ts_insert_blocker    TRIGGER     ?   CREATE TRIGGER ts_insert_blocker BEFORE INSERT ON _timescaledb_internal._hyper_6_7_chunk FOR EACH ROW EXECUTE FUNCTION _timescaledb_internal.insert_blocker();
 J   DROP TRIGGER ts_insert_blocker ON _timescaledb_internal._hyper_6_7_chunk;
       _timescaledb_internal          root    false    263    4    4            i           2620    18583 "   _hyper_6_8_chunk ts_insert_blocker    TRIGGER     ?   CREATE TRIGGER ts_insert_blocker BEFORE INSERT ON _timescaledb_internal._hyper_6_8_chunk FOR EACH ROW EXECUTE FUNCTION _timescaledb_internal.insert_blocker();
 J   DROP TRIGGER ts_insert_blocker ON _timescaledb_internal._hyper_6_8_chunk;
       _timescaledb_internal          root    false    4    4    264            j           2620    18574    OWN generate_dashboard    TRIGGER     z   CREATE TRIGGER generate_dashboard AFTER INSERT ON public."OWN" FOR EACH ROW EXECUTE FUNCTION public.generate_dashboard();
 1   DROP TRIGGER generate_dashboard ON public."OWN";
       public          root    false    277    573            a           2620    18575     ENDDEV_PAYLOAD ts_insert_blocker    TRIGGER     ?   CREATE TRIGGER ts_insert_blocker BEFORE INSERT ON public."ENDDEV_PAYLOAD" FOR EACH ROW EXECUTE FUNCTION _timescaledb_internal.insert_blocker();
 ;   DROP TRIGGER ts_insert_blocker ON public."ENDDEV_PAYLOAD";
       public          root    false    256    4    4            T           2606    18584    ADMIN ADMIN_profile_id_fkey    FK CONSTRAINT     ?   ALTER TABLE ONLY public."ADMIN"
    ADD CONSTRAINT "ADMIN_profile_id_fkey" FOREIGN KEY (profile_id) REFERENCES public."PROFILE"(_id) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;
 I   ALTER TABLE ONLY public."ADMIN" DROP CONSTRAINT "ADMIN_profile_id_fkey";
       public          root    false    278    265    3660            U           2606    18589 "   BELONG_TO BELONG_TO_sensor_id_fkey    FK CONSTRAINT     ?   ALTER TABLE ONLY public."BELONG_TO"
    ADD CONSTRAINT "BELONG_TO_sensor_id_fkey" FOREIGN KEY (sensor_id) REFERENCES public."SENSOR"(_id) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;
 P   ALTER TABLE ONLY public."BELONG_TO" DROP CONSTRAINT "BELONG_TO_sensor_id_fkey";
       public          root    false    3662    280    266            V           2606    18594 "   BELONG_TO BELONG_TO_widget_id_fkey    FK CONSTRAINT     ?   ALTER TABLE ONLY public."BELONG_TO"
    ADD CONSTRAINT "BELONG_TO_widget_id_fkey" FOREIGN KEY (widget_id) REFERENCES public."WIDGET"(_id) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;
 P   ALTER TABLE ONLY public."BELONG_TO" DROP CONSTRAINT "BELONG_TO_widget_id_fkey";
       public          root    false    266    282    3664            W           2606    18599    BOARD BOARD_profile_id_fkey    FK CONSTRAINT     ?   ALTER TABLE ONLY public."BOARD"
    ADD CONSTRAINT "BOARD_profile_id_fkey" FOREIGN KEY (profile_id) REFERENCES public."CUSTOMER"(profile_id) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;
 I   ALTER TABLE ONLY public."BOARD" DROP CONSTRAINT "BOARD_profile_id_fkey";
       public          root    false    269    3640    267            X           2606    18604 !   CUSTOMER CUSTOMER_profile_id_fkey    FK CONSTRAINT     ?   ALTER TABLE ONLY public."CUSTOMER"
    ADD CONSTRAINT "CUSTOMER_profile_id_fkey" FOREIGN KEY (profile_id) REFERENCES public."PROFILE"(_id) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;
 O   ALTER TABLE ONLY public."CUSTOMER" DROP CONSTRAINT "CUSTOMER_profile_id_fkey";
       public          root    false    3660    269    278            Y           2606    18609    ENDDEV ENDDEV_dev_type_id_fkey    FK CONSTRAINT     ?   ALTER TABLE ONLY public."ENDDEV"
    ADD CONSTRAINT "ENDDEV_dev_type_id_fkey" FOREIGN KEY (dev_type_id) REFERENCES public."DEV_TYPE"(_id) NOT VALID;
 L   ALTER TABLE ONLY public."ENDDEV" DROP CONSTRAINT "ENDDEV_dev_type_id_fkey";
       public          root    false    3644    270    272            Z           2606    18614    NOTIFY NOTIFY_noti_id_fkey    FK CONSTRAINT     ?   ALTER TABLE ONLY public."NOTIFY"
    ADD CONSTRAINT "NOTIFY_noti_id_fkey" FOREIGN KEY (noti_id) REFERENCES public."NOTIFICATION"(_id) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;
 H   ALTER TABLE ONLY public."NOTIFY" DROP CONSTRAINT "NOTIFY_noti_id_fkey";
       public          root    false    274    276    3650            [           2606    18619    NOTIFY NOTIFY_profile_id_fkey    FK CONSTRAINT     ?   ALTER TABLE ONLY public."NOTIFY"
    ADD CONSTRAINT "NOTIFY_profile_id_fkey" FOREIGN KEY (profile_id) REFERENCES public."PROFILE"(_id) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;
 K   ALTER TABLE ONLY public."NOTIFY" DROP CONSTRAINT "NOTIFY_profile_id_fkey";
       public          root    false    278    3660    276            \           2606    18624    OWN OWN_enddev_id_fkey    FK CONSTRAINT     ?   ALTER TABLE ONLY public."OWN"
    ADD CONSTRAINT "OWN_enddev_id_fkey" FOREIGN KEY (enddev_id) REFERENCES public."ENDDEV"(_id) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;
 D   ALTER TABLE ONLY public."OWN" DROP CONSTRAINT "OWN_enddev_id_fkey";
       public          root    false    277    272    3648            ]           2606    18629    OWN OWN_profile_id_fkey    FK CONSTRAINT     ?   ALTER TABLE ONLY public."OWN"
    ADD CONSTRAINT "OWN_profile_id_fkey" FOREIGN KEY (profile_id) REFERENCES public."CUSTOMER"(profile_id) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;
 E   ALTER TABLE ONLY public."OWN" DROP CONSTRAINT "OWN_profile_id_fkey";
       public          root    false    3640    277    269            ^           2606    18634    SENSOR SENSOR_enddev_id_fkey    FK CONSTRAINT     ?   ALTER TABLE ONLY public."SENSOR"
    ADD CONSTRAINT "SENSOR_enddev_id_fkey" FOREIGN KEY (enddev_id) REFERENCES public."ENDDEV"(_id) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;
 J   ALTER TABLE ONLY public."SENSOR" DROP CONSTRAINT "SENSOR_enddev_id_fkey";
       public          root    false    272    280    3648            _           2606    18639    WIDGET WIDGET_board_id_fkey    FK CONSTRAINT     ?   ALTER TABLE ONLY public."WIDGET"
    ADD CONSTRAINT "WIDGET_board_id_fkey" FOREIGN KEY (board_id) REFERENCES public."BOARD"(_id) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;
 I   ALTER TABLE ONLY public."WIDGET" DROP CONSTRAINT "WIDGET_board_id_fkey";
       public          root    false    3638    282    267            `           2606    18644 !   WIDGET WIDGET_widget_type_id_fkey    FK CONSTRAINT     ?   ALTER TABLE ONLY public."WIDGET"
    ADD CONSTRAINT "WIDGET_widget_type_id_fkey" FOREIGN KEY (widget_type_id) REFERENCES public."WIDGET_TYPE"(_id) NOT VALID;
 O   ALTER TABLE ONLY public."WIDGET" DROP CONSTRAINT "WIDGET_widget_type_id_fkey";
       public          root    false    3666    283    282            ?      x?????? ? ?      ?      x?????? ? ?      ?      x?????? ? ?      ?   `   x?3?,(M??L?t?sqq?p???wt??/??M-NN?IMI???+I-?K???Ϩ,H-?7?4ġ ?O.?I,I?O?(?ˆH?%?0???b???? ??(      ?   j   x??˻?  ???(?]?	L.??Hb???W??? ??+>a?q[1?kY2??ݱ??????	v??䇤c??H?⇢C?C?a?a????t8~8:<?<s'??????      ?   A   x?3?4?,JM.?/??M-.I?-????3K2?KK@"
U?y??%?1~Pdf`ba !?=... s?'      ?   s   x?U?A? D?u8? v?]r?sL!ŝ??V˅K`<T??q?[? ????r?;S???4??lU':45AV=???!?Vu??Y??????C??3??
N x?Vu????"?
j=?      ?   ?   x??̻
?@E????󞔁??h%???AH@?????ne3?n6,??????mYw?????~???"??z<????4?Y&y<?/?^??4?3p??`?aO??_???*8"j8f%V?	IÉ0?$?
??΄d?UpA?p!̠H??4n?c?`?      ?      x?????? ? ?      ?   ?   x???M?@???̏	ƏQ?¸?l?!l@	CL??}˻?r????=?`??q??C?l??S???;?u??7?q???6??????&'?pJp?
gg?pNp?
{??*\\??%??*????d&-i?IKjfҒ????h&-i?IK?f?ѕ?a?k?8?p      ?      x?????? ? ?      ?      x?????? ? ?      ?      x?????? ? ?      ?      x?????? ? ?      ?      x?????? ? ?      ?      x?????? ? ?      ?      x?????? ? ?      ?      x?????? ? ?      ?   B   x?K?(?/*IM?/-?L?446?4726?5145?51?L?M4?0Ե0054K?H5M?H?,?????? ??      ?      x?????? ? ?      ?      x?????? ? ?      ?   ?   x?E??
1D??W,?U?+?b?r??l?m?7b7?y3?*????sZ:^??w?Cc?9?????{I+mK?g??P+!C??}??Ac???c???c?ڡ>??e?;??^?I?3?G5?????? N/0      ?      x?????? ? ?      ?      x?????? ? ?      ?      x?????? ? ?      ?      x?????? ? ?      ?      x?????? ? ?      ?      x?????? ? ?      ?      x?????? ? ?      ?      x??}M?%?m???ƻN$??G?2?@?3??,8?A⬂??H%?ڗd??U???yw???lV???!)p ?????ƥo?a|??R
???_???????|?Mx???7???????C????????????????U?????蛃*	??/?<????ER??????U?B"??X+?W??=???r?????SN???????u?\
S,XK?$?%?CI??W,苠???????????g7~???3?_?GvUvQd7-1???C?.?cx?I?m?3???Ъ?M??>֪Z
??FCC???wŢ??P1??<b?_ΥC?sI??????U4?W??_%'?o'?'xx"?CQ?????EMRYX^??????Z5??@"??//L$j&2?(a??o?cQq?)???????{????D/b?b?j????????@?E{?2???7t???՟?Fb?͍
Р?v???tU???1?;q?ۿu? ???T?)3|??)??L.P??!ƧG?
?w???t?)?Ǩ?Aʖ dބr#䪞?????t?%n?e??B}z????? ??`'?b?????rF????1?.?EfQ????uվ??S?ꒀ?M?0`??P5???r?6??"??VY??v??Nq?????n??}bJ?$??G??y?d?*kOٲ?̫?z??ѹ?g>??ך???ku????%?T?k?5?	8XÊ??wt??????za4???^??b	??[??w|?ś?*?r?j??m1?"P$ J&p???`?>???????cohW~x?VY?<????:?E?ђ,???.Dk ??u?K???W6?%[}J???Kyna!d?o?.?oX?h????լ"?h+Y?R?????גk6?(???%]?"?n???r?]li!?r??¬f?Ǌ???w?ι????=?:D?????p΃;??k&=?BJ??a?8G?
?.k?]???z????V???rPbfN??M?yF??Q???=??\6?[Y??0@.F??Y?j?0?*$~???8??,?????j???,??I??m?h;-?^ޯ?Zg ?s6?ڑV[RY?̛?M?????X1]?-$??K?<y২\?S?????O??k??8??^???y???Re0x1??v7?9???J?K??K	?	?ǫ9%Zp)???	3????ןÿ??Ah??&?)?XC?????h2f??1??,>?Y8Oi???d??y?ՙ3H???EV?b0g??M???3gՇ????Y?4àY??7(7Ωw?tPc9?W????0;SASU??H?F?_?o??????x???Q
?cd??????N?լ??e?`?? y??-??UC????ZK?&w悭??*7?.???+)>?U&?Z>c?$9?Y????????,B`??0HF??Y??M?#?r?\._?????D\?T??N?E?e??qm q???c.??ڳtQ?Y?u?d?fu=k?????/???G????	??D~ى?(Jf7^?$?w??A?a
5?0?_?????LԨ??H? ?V?????>??$$L.*&7i8r?1?q?pNT?8?{?????U/O?C???????(W??墭3EUu?]{?S??\ր9(????]?%??>M????F|G?_v??Ng?ri??!9P&????^4\?Bxlo7`?e???A?a.????*???C?7hʲa?L\u5?\?H	?Y????y?:??4?8????[?????F????????Y&??x N*?S?.?ÝϬ^ww?Y????Ρq?l?i&??ºIš?*.?(?ߐ5??֩?J*????jpqn?a^2????8tK?f?nrv??d<n)???TC?Uǁ??2?8??_????z???q???ܕ?c?????u???:9,?V?k67??e?r???%[??iqWg?j&Gϳ°?]?q???ւ?*??Fe@?L?/????i"<??A?9V?b?%?_J<l??U?9?t???(6???????8???3a?:^IJ#z??Ry^?u??W]??_}??D?1}????????FBJ?q?yL?n,0{??.?*?G?s??,%?O?A0u??0 ?p=?n???eu;I?X??Lǲ?&ǐ"??H?f'.Qd??N???wY?^	H?u??? ?p?Y???Λ??????8?H??t^?Ui?6?>?8??'?ә?!?i??lŉ??iZ??W ?\??ߩ?z????????wY????B/1??emV?lt]1;QymG?#	?qQ??	?l?:????DX|?K:??߾?#?ɑ??rc??4Is+??l??C?W\?09Qt???WE[ӳh:첚??x6p#MNs??蚳q0[?Z?蚼?5???y}???F?5???ڣ??EWG?x?.F?5{?%?j5???t֪y?f?5E?.?.ƫ?u(J??Ps???H *2@????X??cU?????D%x=t???1?9?^s??le-5?T?H?Y??S0Y?`???Ǵ
???լ:??U????z?|?1??nc?Gq|?xmu??xg?zTe?d?POC/?:??kfѫ???LN?@?j??X???
9kSd5?	?3l?׃?#?:?a?U[?:tY?^t??D؁nT]SM?L~_J?]hy?a??Z?ԁ(?̦????ō?ҭ?6"??"?^s?a>?Y????ER?M????փ4d?\k??dUK?z???????z???????-،?-GG???V.Yb}UV/?:Hi??CX??~uQ?-[*??ju?O?H????ꚱ?R?:?T??8W?y6]???UC??Ѷ????^uE?	?)?TUXWX?r^? ?QeC3?A??]?'2?oX?????????jU?ѝ?.Z???qޔޫ?1=R?k0?z?AG?????E?K?&?<??b
?n??؞Qs?}z$??	t?	????@)7?ȱ???任?!d+??E?e?e??^??cz$%χ?P???a]????3w?s5_2??M??M????р:w^5??%cr$EKW???`R?u?h????N???/&!?U?H/?????????Q?0??(`΍?m???jfQ?3?]j???H??6{?*ׁ?w?b??&????>L3%۸???@????;U?\??_ mVW-?V???@1D?e?^?l?ؒ?f??%???Q?]???	?}=?m {V??Ib&$[Ӝ*?瘐??I??N?'??8Ūk]&????]?՗ޠ?`??K??n'1??M?@?fv?⇝?CrM???Dܨ?u??>??NQ?I??r]?hZ?)*9~?̔LkTtY??V?SW?U?.W?3-?rr?Q5&?M?????a?#??0a?I?A???M?3???1g~y???W6?.??EMt$??e}n?ML?
2y??6??l?6?S#??|w????l?--??8???H?tQ?????`?fv????iv??Q?s??eF?#?V26??Y47ÕA??I?ft??fjm&t???ZD7?FR?<????/+??&?TY3?t????_??8?	?B????.d?̩???9 w?2@Ig??"L??????u????G?6[\?K???H?|??ID??:??}y?_;????J??V~?Ju?,?Z??v??3??K???}???,ȁ'????R???A?TC2??,??N?T?6?ͨ?????Xۆ_B?Vr?K?6gx?UC ?0?	?s?ə??ѕ?Ȋ????#Y?S?)TY???????ˢ?*\?;?r.?.d?L?%??]>??W?\???p?*?f???8n?si???]G?(
n??A6X0N
?;??Lw?????&_z???(Wy2.A???)??,??}?*?C?#?ݱ??u?`?Y??T8??Mk??ɺx?q%?r3??Uڪ?<cFgjLUe???]??LV??Kp>\?ץ?Ka?]0?f?j??	N?]?F?y???G?u?k????N?F?ɻ䐟:???x)O?3L?%??O?,v'?筀&???>??H??x??]q?a????VnD_mwS??zf?c?^?3?&??<?m???zgE??'?3/?6????n2/??)??t]?fvm????J??    ,??ɼ???=???\ҭ?B^u1?s|mWR?ß??墦?&?,??O2;???R?mp??=?ll?nv?j(?
?.???],|?????J{?gȂ???ݼS????2?;?????B?k?`??m?nswWM?W??e??q?s????!??¤ar?>??5ٲ&T?j?(~?N&????=:]|????I??l??,??6?|??Jߜ?y?C?TLAï_kVj?a?b`?N e????-8???z?
??Z?1.?&?ƭ9Շi1??ŬθvI? i6m?>???&+?agc?/???f*??~K>L
?l?2?#?C??tL??n?^@?%????c??	>O???a??
?y???绨????|?2k??+?:捡2?kPꪝ?9U???cM??$϶H???0?a?+????x????\Y??;T?b?Y??e?t=dс?Xl^??b:?>g????=?w?,m#?v?%?5?㮁V?,{?~-[6?KUU3.3?Z???+??Ct&????N??--??F?0??*襼??fA9i$t??e5<^??J?4?8XN?R\??????/+?B?Nsz?|??????d:??????Ua??Y?R=?߄=??????h?U?k`!5??|' ?t?qY4FY?;?>c?o?n??˼|wG؈?b?;N?i???,V?W?_?9??#?1I??}?D??_۬?&??I???S?I???)3?.???%u??l???U&e?K?4`r?Q?,??H͉u?3??ԑ??^3????y??[UU????ܰ.?i?:?S?M5?}o?b?_Uw;HOG??T??"??0k?ۢYt?????@?t??<???'?)ֵ?VF?-o??"??]?`b?u?N|???Z볪?Um×\?z1???????f?x?G???A|B??k
?'>5??A|?O?>OtU??D%1???e?Ϝ??.?0?-n???;?M?kӓ???s?9??IK?q???????}N劬&n???m_@???gŸe?$?b?????v?/?????_?C???\??}?ϭ?|p?;?>X=?????L%?t<? ??g??|)??C????sxbx?iP?n?oϬѱ????,bb?zg?^??'?lq??k0`?k????3SM@}?Yq3??Z???Z@a?.T?????Y"?C?6?s?????:?$??]??>?Ufq_Y?.?q????V?h???~???????????V??/??K?w???????;???Ǘ??????K?????????? ???ş????S??ˇ?.?'?QC?A??6??\?$v??/t"Ls???M?nG??>?K8?w???`?-???-???*??;Z^`'?ӜA'v?[?uF???E!9p_
b??]??:?Ȯ?
4??	<ߑ???͉8?yG???#?$?i?bgv[q"?J٪eO?E??:R?Y6E?????dƢ1??_?TlQ?F??dv?#5w???ny?|?a?֒? S
ӂ????@?Y?LC1?9g??L??j???]?tvk5?ʂ??-?Uq?T?:?!_???.1???u??vS0岥??G̫?8t,??3?j??/??%LZ??\?q1?\^?~?q?Ǚ??
?U??NV?Ʊ?ӎ?ީ&n??_^?qQ??A?}??m??X?I????pNU?~??e??EU????b:aw??NV?"k?ays??|c???*?Y^?a]+P,O-S?>?)??:YК?,??Jj}k?@?IV?I{޵79??w?]5 /?/??(???/??k[X?\?Z?!?e????'vǋ??'?j܉j??|Q??^P???<?r??C??=???5a3no8C???N?_ε???r?N??{?C?f?>????싚Sͱcl??:޺??Q???,z?c4o'_???nł?5ec]o?$?8_ȃ??1?W?^Tg(??h?&????P??7??<??????yJ???Z??$?IL޹u??5???q^N_6()X^?)ei?i????h????8??i?$?c??I??zm????	z??9~?#-A\?n=_}-r??8o[AORR??J ?~??'??W??m?~?Q?????.kn?I?Z?Bc?h1?9?`??<8X?n?9WsO?z?\)?W???s%4ǫ?#?T??n?\La=nx?s????????i??b???Ǟ?m?i?B?[??e?`?nx?? &~??M?????K?.?7?~A'?n?;?DwlN?,?y????M?ɀj?ܐpQ?9??1?k?&????:??$????ޖaCc???4p? ??3i?fy? .WJ\?m?`?a????????x?I???Y?]_s{Q??\
????z?AlW'???ݖ??x????^?R:??b??????ޣ??uč?U?Ϻ<_?????;?b?????ǭpPS???R?8w?e@?&R'6?݁??eP?d=?~??;?S?#.???='??0?????Św{?<7?;/mN,??ޒk?????ɍ???:??"?+?htĦ??Ꭼ?-???|q?????}5sf=_7Mc_?떻??n???F?AMX???8?)????'t?F@??Od-??_!L???? ?*l&c?Z??!eK????I?9???y?????m)?e}IA?????????v#?$2?x???l@DI[??r??CX???? +??e?;????ׄ?v?ȱ4???n?˵????L?CY7?_5??mPĬ??s??F???Ձg??N#??uV??V?
?W?Ҳe㢰?z ????Mo?J????Z???<?6??n??/ǣ?m?5??ϫ̋e?z????870????C4"h?ǯ	???G?Va???o??c7?7T?PN??k???????wt눋????u??8?IA\??`y?yQ?^5?!+?:/?s?????PUuv̊???x??7?ܰk?Z?*??^?]>\+?ݯ?r@@?U?$6?Qn??]/ػ&l???]͝#7+?n??산8?0?f????߀w??2?~???????a?jq?DJ|?ם??Q/T?0?(?????B?!?u?|R0?~(?|??I??? ???9???8^	?l8??ߠyR?UO?\/????7?????k???n ??//*????E?(l+`??????ϯr????o?xz~K????ep?_????????-?۴}???c!?g?
z?e`i?? ????g??Gs?y?????ɶ??YU.?W?E~??CzA?%}Ze??Y%?2?=$?j??㤽???U?????????󊂢9{?r%@?]g?ذڪ??.gq??u?j??XRu??? ?D6??zO????hp}?RV?Iǽ??ecs??^?X9"<cͮ唳???U??s??o1??3::0?uݱ?9?!Z7??ށ?\??uF? ?&?5??mg????{?Qx???e?L?????%??`??vt}?PLɯ?ST?Et?z~??-U?v?T?"???r?/?J)?????G-#??]?k??ǒ??vM?#???9f???j?M?zo?e??? ??e???a9'"[?Ta?"?? U?\?%???0??v?T
+????\g?Ydd??@?84^?t`??,?;^T???Ag?tif?z?V?{?ĚB|\?yi}?׵?0A????;??֣??{??[;???5P7?Cz>BG????`)tt?g?]x?#?ֳ"??o??{???r<=????Z?/eA??<???h=?A???ˋ16Qڄ?}\a?>Z?5?L?>?9oӁd?Ռs?
?(.4a????ik`ck0lQA?/??qտX??Br'???B??+?V?V????F?U?p??y?xy??m??5?????j^?j?}־(??=q?/?@|???????????8U}?ݧ??(??????)bo_?mw???z?bK???s?Hs ???o??<??;?r???;?D??vq[?c???ze?1???z????޿?I??l?^??(???Xޑ|???B??????
?6㤕F??A(???=??ec?D??.?????????T?j7?p?????????)|^CA}6h?O??????'??X??h???I???n??ָ??????|??4???m??Dm?h???g??̉???? ?Not??zb?[?C?O? ?  ????FCp?lѕ 1???5z}??֮?Dѡ%@?|???v?h??}??'?o?[????;"̱^??"?
??f?w?o1?->??8F˔?z?h?n??7??? ??3/y?f??[.??ڍ??c??*???=%V?Y??Sz^?O{?w???2wˑqC?&?LG`?70}t0&?.??S????M?>???{g?h7??® ???rGr?m~m@?i??6??#???fZ?4'L?ͯ???V??1?y?p0(?_L???4??b???U??J??F????}?\?N?/j?ؤ??4?????i4???Kb?~ւT??~>??jf??~m?l?╊T?7̕`?S????c????F?/?.???=vwt?j???k??*??O?F?70qi6????S?6?F??j?<???;|??T>???[~U?N???~??ŀ????{?f.?M??G??7`???~p??'?U?(|%
?Zo??p>???H???u?ڂ?O4?^m?????F?á?g+???S?ny??Eo??⏆ݟa?]????I??`i?<?(?)t>?#Y??F0nFք?1???P??dMV~A	 ??x??<?"????yS?zQ??a?cm???ﹼ???|G}u?????ٔJ?AeP֮?1>?sL?6>?=ҫ]	??c???h}??*f?0?K???+??8{???!j}???5??y???B?M??>\h[rr?????m????v??Gk׎?h??|?І?B?O?4 ?Y???Y˴??ObC?a???b	????X???n???m?ӌ?z??Q?hᨹ?sBgN[>`L۬e?N4Gv????_?3.}?<o????s?ҸrZ??G-?i??4n?\???w
?xHt?????\2<ypڇ 3>?(LcN??
lL???_??g?c7?{???+??AΉanyw?uȫ?=?????@??1T??7H?[?5?K?ܰ<y?p??o.?r?????_>^???f??y?n??????~ʇ?X??y??6??^	?6????m͈ys?n??/?(??<?D/????Km???+?;r>/??ѡ?=V??p?EPc????{z???q?r??r헟W?S??rz?=??=o?Wvo?oĒ???Z?5???+??v=?j?y?d^????K˽h?p?q?W?t?-?.v!j<???+%?y?????k??????{fє?y%????d?Wg?? =?kM$??dմ?X??b0?3?????u?1?Z????f????U??<?@?K???+?#?1??z??l???N?4?`??:?M???4?1??]??p'QrR???9)?b|j.?JVUc{????(??lൾ)?n?KZ??.@??`?-%?8?r???l???s5?
?m[wt뫙???>?
ۆ@Y?w??k????y?Eߠ??}?~??K?S?P?	????[???~??_?1?ψ           x??YM?7=???՜???]??C?%+%?HVZ?(,'????A??5=????8??<\??^=??@?)ݠ?!?c
)Ed???????????g~v??}x?????~?????????_T~?J???X?A ?1e9Ƣ	?!?9??#??I?(BZ??.?5???????f5
k??S??b!?XR????W???????_>??ؽ?«[Z,?-??[|??䫻_?-?^?<?G! `]=???w?????7߮2Ϋ˵SP$^?)??"?,?`?????^?l~??V??r??@???LK?T,?Nn?Ҡ>?ɉJR)??	a?S??:Փ?ӓ8z???L????@N???%?PV??"?Q?I?͎?f,?mT3B??n5?l??	r?	wp.?<?f?@????B???eU?????r???!?RNC?wߣ\??,???/????Sʱc???%V39-?(>{??v?(A<?jf??OѴ_?s?j??yu???G?(?aL?<l'?)?3?#k??^???0?͉~?iL?#G?y#?)?8??Fv???7?????x?d3???ʰǲa?7ŊvLhc?????h?u;?	??w????W%??d??B??K????bG?͑-"uT??j?KEJ?۳ܺiv?????8?h'?۱??o9\??]π??U#?????^?h?Z,i?ߪ4?;?`hBJY{?d?L??~??????tT????c?q?????]???i???A?	PՊ$s_O`??ʄ?N?;?dN?Q???$?jq??Po?ss#??'?,>`!?)???˨]Tu[5^?U?fTM??}b??W?s??1??c&??i??????$?ATbr?UvD??#??U??*??<?P?K*???(_?U?(w9???|?<C????E?x??t???jN5vu??H:??.骓g??I?9y?N?X?J]F??@bs????n???A??Xzx???X???&D,???y?ƙ1uq6d?<`hY\?/8<ۨ?K???y?CXg͂r?AIu?,Α^g??,?8?????????g?????      ?      x?????? ? ?      ?   N   x?̱?0????%?^??h?U?S?B}?CJ
7.?x?<???|???D>????B>??p?{#???      ?   V   x?M?;?  њ?E?`>?.6A???????]???y?L(?X???? ??Q?z??6?.?Lc?[?UF?h}??Ec?^C? >??7            x?3?????????? 	?m         ?  x???Oo?0???SD?vk?B?O?z???Тʥ?Nj????J?(?}6Y[?#ai???ǯ~?raE~|i[[P??d<!????v?F? /Sp62Ǻ ??????1??q=????Dl
?
?$dw6|¸?ǈ&iԚ?K?3???L?Y.8#=ox??V?????O2ԘE2A?\w?ձ<??p??%??????^???E??lhTWI?,82A2z3???}k񹣯??7????NJ?
Y?}P?e?Fc?Kܴ???GbZ?\K?u]kz?I???`րW????&?7鶿?Y?/?<??i?l???N??i?n?j??7c??????I???h???Ǣj??a?=u?9E#?Djh?iR??Ҭ
???׫+???*?=??V?K??N4d/3?M???@̖K??wR??ꫜ??=tOd?z??????V?T:???
??T???????U?2V??ZC?$????EԡD?G&?8?????-?n?s???8z؀???|{=??=?         ?   x?}??
?0?s?.M??z???????9?p07??9?????/? kޭ??$@V???3YJW??Հ??jH?<?>??????4??????bčZmϚ??r;L$????Ypc?'?d?i)\D??V˵??Ȇv?$V??=q????Gԫ?T???|;Lb????????WP?
T?Ӂs??>l?      ?      x?????? ? ?            x?????? ? ?            x?????? ? ?      	      x?3?47?????? Z      
     x?U??n?0  ?sy
?Y????0?F?g1f?R?҂?v?i????&31??|???Th???4?M???^'???)5hJ??<??V4r?y??'????&^'????	?y@ ??6??(?`?u?T 8bՎ??LV????????\?^ea89Ye?N??7??l?Q?ۑU3??x?????????]?? ?]D??m?rQh?????Z?:?91?^??<{?$L?n?x??לY[??g?????+?6?????1????a?Сe??L+d[p*????k?????n?         4  x?Ŗ]o?@???_a&ٻ?F??&??JW?fɲ??݆PAK:|d????;g?nha4?ޘ8????z?	Ҧ2n???q??ʂ8K:??????qa??<9,G????cx??C?`m?ۀ???b#?)=?t?????g??&?S??i??Fǩ??^3Fsu?yU?r??/`???y&£L3?
?>????:?u?<W£?c],???<v?<?Oضno?Td0*e$?Y??*M?Jk?(Z'1g	??֑/>x?????b?O??x??	?&?)rym?叅?{fAۄ,
 ?Y?????;???坳5l???5>ݟd????&P???ܨ[9???ëd??A?!?<??K?DN????h???9???({$-{ʻLݣ????L??D?o:???
m?(ڭGq$O?O?po?>?½i?*TM??z
??T????'{??"M??PG"I??3?$??5]??#5??? M???N?/
??0$?? ![QZ~?:??7??ZR?Ga?~^.???}+?H?I? x?]-?uW?X??]??Iw? ^?B?W??FQ??????^??17H         ?  x???AK?0?s?+J?"Mҵ???	?e??^???i;b??7??:a/?{[ڰ>|}?l2?s?n?{?޶:>??R?u|?/????{????h{c???3???MT?????e?⽿??̓????r???m?????;~????ި޸?k?=?2?G2????a@9???F7[Q???rU???6aw?}Z5?Z??x???8?]w??(a@?@ ?$I????Ɣ???Eգ???4????n?/?????sh?!????|.h?qD9?qH?0$??	M&??[???Z??TkB?8}Hu=?R?b??X??????֧??????.?/}T@????傯??r?????<??1TL%6??????
nV???F%=
nR)?]?Mj?Qp???ޤr???TA???50?	%
??&?'(?4A?e?A?$?	˔R??Lc????t4} ?Y=e         "  x?œ?N?0???SD9R7$G?@???^?&?I??w'i??JHeRo?m??l?I';???o?e???O?????;aM?;j>?d? ?/ܔZ7)??Ν??Bbn?%f?LD??uI@ۘ}2??1\?ɑ?`T4e?BzX/??Җ$??m?!LCO_??wUMg)???@?3?U+???Ύ????$t??????c}d???m?}?N/????n?`dO??H?U?s?Q^?~NWט?(?q?}???G?4??<?
???y?q?_.Ɯ?,=?&:?????z?$?7?ɜ     