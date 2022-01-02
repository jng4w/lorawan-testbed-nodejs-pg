PGDMP             	             z         
   lorawan-db    12.8    12.9 R    4           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            5           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            6           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            7           1262    34786 
   lorawan-db    DATABASE     |   CREATE DATABASE "lorawan-db" WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'en_US.utf8' LC_CTYPE = 'en_US.utf8';
    DROP DATABASE "lorawan-db";
                root    false                        3079    16973    timescaledb 	   EXTENSION     ?   CREATE EXTENSION IF NOT EXISTS timescaledb WITH SCHEMA public;
    DROP EXTENSION timescaledb;
                   false            8           0    0    EXTENSION timescaledb    COMMENT     i   COMMENT ON EXTENSION timescaledb IS 'Enables scalable inserts and complex queries for time-series data';
                        false    2                        3079    34999    pgcrypto 	   EXTENSION     <   CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;
    DROP EXTENSION pgcrypto;
                   false            9           0    0    EXTENSION pgcrypto    COMMENT     <   COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';
                        false    3                       1255    42978 (   insert_board(character varying, integer) 	   PROCEDURE     �   CREATE PROCEDURE public.insert_board(new_display_name character varying, ref_profile_id integer)
    LANGUAGE plpgsql
    AS $$

BEGIN
INSERT INTO public."BOARD"(
	display_name, profile_id)
	VALUES (new_display_name, ref_profile_id);

END;
$$;
 `   DROP PROCEDURE public.insert_board(new_display_name character varying, ref_profile_id integer);
       public          root    false                       1255    34998 m   insert_profile(character varying, character varying, character varying, character varying, character varying) 	   PROCEDURE     �  CREATE PROCEDURE public.insert_profile(new_email character varying, new_phone_number character varying, new_password character varying, new_type character varying, new_display_name character varying)
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
 �   DROP PROCEDURE public.insert_profile(new_email character varying, new_phone_number character varying, new_password character varying, new_type character varying, new_display_name character varying);
       public          root    false                       1255    42979 0   insert_widget(character varying, jsonb, integer) 	   PROCEDURE     )  CREATE PROCEDURE public.insert_widget(new_display_name character varying, new_config_dict jsonb, ref_board_id integer)
    LANGUAGE plpgsql
    AS $$

BEGIN
INSERT INTO public."WIDGET"(
	display_name, config_dict, profile_id)
	VALUES (new_display_name, new_config_dict, ref_profile_id);

END;
$$;
 v   DROP PROCEDURE public.insert_widget(new_display_name character varying, new_config_dict jsonb, ref_board_id integer);
       public          root    false            �            1259    34787    ADMIN    TABLE     A   CREATE TABLE public."ADMIN" (
    profile_id integer NOT NULL
);
    DROP TABLE public."ADMIN";
       public         heap    root    false            �            1259    34793 	   BELONG_TO    TABLE     d   CREATE TABLE public."BELONG_TO" (
    widget_id integer NOT NULL,
    sensor_id integer NOT NULL
);
    DROP TABLE public."BELONG_TO";
       public         heap    root    false                        1259    34796    BOARD    TABLE     �   CREATE TABLE public."BOARD" (
    _id integer NOT NULL,
    display_name character varying NOT NULL,
    profile_id integer NOT NULL
);
    DROP TABLE public."BOARD";
       public         heap    root    false                       1259    34802    BOARD__id_seq    SEQUENCE     �   CREATE SEQUENCE public."BOARD__id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE public."BOARD__id_seq";
       public          root    false    256            :           0    0    BOARD__id_seq    SEQUENCE OWNED BY     C   ALTER SEQUENCE public."BOARD__id_seq" OWNED BY public."BOARD"._id;
          public          root    false    257                       1259    34804    CUSTOMER    TABLE     D   CREATE TABLE public."CUSTOMER" (
    profile_id integer NOT NULL
);
    DROP TABLE public."CUSTOMER";
       public         heap    root    false                       1259    43014    DEVTYPE    TABLE     �   CREATE TABLE public."DEVTYPE" (
    _id integer NOT NULL,
    dev_type character varying NOT NULL,
    dev_type_config jsonb[]
);
    DROP TABLE public."DEVTYPE";
       public         heap    root    false                       1259    43012    DEVTYPE__id_seq    SEQUENCE     �   CREATE SEQUENCE public."DEVTYPE__id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE public."DEVTYPE__id_seq";
       public          root    false    274            ;           0    0    DEVTYPE__id_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE public."DEVTYPE__id_seq" OWNED BY public."DEVTYPE"._id;
          public          root    false    273                       1259    34807    ENDDEV    TABLE     �  CREATE TABLE public."ENDDEV" (
    _id integer NOT NULL,
    display_name character varying NOT NULL,
    dev_id character varying NOT NULL,
    dev_addr character varying NOT NULL,
    join_eui character varying NOT NULL,
    dev_eui character varying NOT NULL,
    dev_brand character varying NOT NULL,
    dev_model character varying NOT NULL,
    dev_band character varying NOT NULL,
    dev_type_id integer NOT NULL
);
    DROP TABLE public."ENDDEV";
       public         heap    root    false                       1259    34813    ENDDEV_PAYLOAD    TABLE     �   CREATE TABLE public."ENDDEV_PAYLOAD" (
    _id integer NOT NULL,
    recv_timestamp timestamp without time zone NOT NULL,
    payload_data jsonb NOT NULL,
    enddev_id integer NOT NULL
);
 $   DROP TABLE public."ENDDEV_PAYLOAD";
       public         heap    root    false                       1259    34819    ENDDEV_PAYLOAD__id_seq    SEQUENCE     �   CREATE SEQUENCE public."ENDDEV_PAYLOAD__id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 /   DROP SEQUENCE public."ENDDEV_PAYLOAD__id_seq";
       public          root    false    260            <           0    0    ENDDEV_PAYLOAD__id_seq    SEQUENCE OWNED BY     U   ALTER SEQUENCE public."ENDDEV_PAYLOAD__id_seq" OWNED BY public."ENDDEV_PAYLOAD"._id;
          public          root    false    261                       1259    34821    ENDDEV__id_seq    SEQUENCE     �   CREATE SEQUENCE public."ENDDEV__id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 '   DROP SEQUENCE public."ENDDEV__id_seq";
       public          root    false    259            =           0    0    ENDDEV__id_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE public."ENDDEV__id_seq" OWNED BY public."ENDDEV"._id;
          public          root    false    262                       1259    34826    NOTIFICATION    TABLE     �   CREATE TABLE public."NOTIFICATION" (
    _id integer NOT NULL,
    title character varying NOT NULL,
    content character varying NOT NULL,
    updated_timestamp timestamp without time zone NOT NULL
);
 "   DROP TABLE public."NOTIFICATION";
       public         heap    root    false                       1259    34832    NOTIFICATION__id_seq    SEQUENCE     �   CREATE SEQUENCE public."NOTIFICATION__id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 -   DROP SEQUENCE public."NOTIFICATION__id_seq";
       public          root    false    263            >           0    0    NOTIFICATION__id_seq    SEQUENCE OWNED BY     Q   ALTER SEQUENCE public."NOTIFICATION__id_seq" OWNED BY public."NOTIFICATION"._id;
          public          root    false    264            	           1259    34834    NOTIFY    TABLE     `   CREATE TABLE public."NOTIFY" (
    profile_id integer NOT NULL,
    noti_id integer NOT NULL
);
    DROP TABLE public."NOTIFY";
       public         heap    root    false            
           1259    34837    OWN    TABLE     _   CREATE TABLE public."OWN" (
    profile_id integer NOT NULL,
    enddev_id integer NOT NULL
);
    DROP TABLE public."OWN";
       public         heap    root    false                       1259    34840    PROFILE    TABLE     �   CREATE TABLE public."PROFILE" (
    email character varying,
    phone_number character varying,
    password character varying NOT NULL,
    type character varying NOT NULL,
    _id integer NOT NULL,
    display_name character varying NOT NULL
);
    DROP TABLE public."PROFILE";
       public         heap    root    false                       1259    34846    PROFILE__id_seq    SEQUENCE     �   CREATE SEQUENCE public."PROFILE__id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE public."PROFILE__id_seq";
       public          root    false    267            ?           0    0    PROFILE__id_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE public."PROFILE__id_seq" OWNED BY public."PROFILE"._id;
          public          root    false    268                       1259    34848    SENSOR    TABLE     �   CREATE TABLE public."SENSOR" (
    enddev_id integer NOT NULL,
    _id integer NOT NULL,
    sensor_key character varying NOT NULL
);
    DROP TABLE public."SENSOR";
       public         heap    root    false                       1259    34854    SENSOR__id_seq    SEQUENCE     �   CREATE SEQUENCE public."SENSOR__id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 '   DROP SEQUENCE public."SENSOR__id_seq";
       public          root    false    269            @           0    0    SENSOR__id_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE public."SENSOR__id_seq" OWNED BY public."SENSOR"._id;
          public          root    false    270                       1259    34864    WIDGET    TABLE     �   CREATE TABLE public."WIDGET" (
    _id integer NOT NULL,
    display_name character varying NOT NULL,
    config_dict jsonb,
    board_id integer NOT NULL,
    widget_type_id integer NOT NULL
);
    DROP TABLE public."WIDGET";
       public         heap    root    false                       1259    43032    WIDGET_TYPE    TABLE     U   CREATE TABLE public."WIDGET_TYPE" (
    _id integer NOT NULL,
    ui_config jsonb
);
 !   DROP TABLE public."WIDGET_TYPE";
       public         heap    root    false                       1259    43030    WIDGET_TYPE__id_seq    SEQUENCE     �   CREATE SEQUENCE public."WIDGET_TYPE__id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ,   DROP SEQUENCE public."WIDGET_TYPE__id_seq";
       public          root    false    276            A           0    0    WIDGET_TYPE__id_seq    SEQUENCE OWNED BY     O   ALTER SEQUENCE public."WIDGET_TYPE__id_seq" OWNED BY public."WIDGET_TYPE"._id;
          public          root    false    275                       1259    34870    WIDGET__id_seq    SEQUENCE     �   CREATE SEQUENCE public."WIDGET__id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 '   DROP SEQUENCE public."WIDGET__id_seq";
       public          root    false    271            B           0    0    WIDGET__id_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE public."WIDGET__id_seq" OWNED BY public."WIDGET"._id;
          public          root    false    272            )           2604    34872 	   BOARD _id    DEFAULT     j   ALTER TABLE ONLY public."BOARD" ALTER COLUMN _id SET DEFAULT nextval('public."BOARD__id_seq"'::regclass);
 :   ALTER TABLE public."BOARD" ALTER COLUMN _id DROP DEFAULT;
       public          root    false    257    256            0           2604    43017    DEVTYPE _id    DEFAULT     n   ALTER TABLE ONLY public."DEVTYPE" ALTER COLUMN _id SET DEFAULT nextval('public."DEVTYPE__id_seq"'::regclass);
 <   ALTER TABLE public."DEVTYPE" ALTER COLUMN _id DROP DEFAULT;
       public          root    false    274    273    274            *           2604    34873 
   ENDDEV _id    DEFAULT     l   ALTER TABLE ONLY public."ENDDEV" ALTER COLUMN _id SET DEFAULT nextval('public."ENDDEV__id_seq"'::regclass);
 ;   ALTER TABLE public."ENDDEV" ALTER COLUMN _id DROP DEFAULT;
       public          root    false    262    259            +           2604    34874    ENDDEV_PAYLOAD _id    DEFAULT     |   ALTER TABLE ONLY public."ENDDEV_PAYLOAD" ALTER COLUMN _id SET DEFAULT nextval('public."ENDDEV_PAYLOAD__id_seq"'::regclass);
 C   ALTER TABLE public."ENDDEV_PAYLOAD" ALTER COLUMN _id DROP DEFAULT;
       public          root    false    261    260            ,           2604    34875    NOTIFICATION _id    DEFAULT     x   ALTER TABLE ONLY public."NOTIFICATION" ALTER COLUMN _id SET DEFAULT nextval('public."NOTIFICATION__id_seq"'::regclass);
 A   ALTER TABLE public."NOTIFICATION" ALTER COLUMN _id DROP DEFAULT;
       public          root    false    264    263            -           2604    34876    PROFILE _id    DEFAULT     n   ALTER TABLE ONLY public."PROFILE" ALTER COLUMN _id SET DEFAULT nextval('public."PROFILE__id_seq"'::regclass);
 <   ALTER TABLE public."PROFILE" ALTER COLUMN _id DROP DEFAULT;
       public          root    false    268    267            .           2604    34877 
   SENSOR _id    DEFAULT     l   ALTER TABLE ONLY public."SENSOR" ALTER COLUMN _id SET DEFAULT nextval('public."SENSOR__id_seq"'::regclass);
 ;   ALTER TABLE public."SENSOR" ALTER COLUMN _id DROP DEFAULT;
       public          root    false    270    269            /           2604    34879 
   WIDGET _id    DEFAULT     l   ALTER TABLE ONLY public."WIDGET" ALTER COLUMN _id SET DEFAULT nextval('public."WIDGET__id_seq"'::regclass);
 ;   ALTER TABLE public."WIDGET" ALTER COLUMN _id DROP DEFAULT;
       public          root    false    272    271            1           2604    43035    WIDGET_TYPE _id    DEFAULT     v   ALTER TABLE ONLY public."WIDGET_TYPE" ALTER COLUMN _id SET DEFAULT nextval('public."WIDGET_TYPE__id_seq"'::regclass);
 @   ALTER TABLE public."WIDGET_TYPE" ALTER COLUMN _id DROP DEFAULT;
       public          root    false    276    275    276            |           2606    34881    ADMIN ADMIN_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public."ADMIN"
    ADD CONSTRAINT "ADMIN_pkey" PRIMARY KEY (profile_id);
 >   ALTER TABLE ONLY public."ADMIN" DROP CONSTRAINT "ADMIN_pkey";
       public            root    false    254            ~           2606    34883    BELONG_TO BELONG_TO_pkey 
   CONSTRAINT     l   ALTER TABLE ONLY public."BELONG_TO"
    ADD CONSTRAINT "BELONG_TO_pkey" PRIMARY KEY (widget_id, sensor_id);
 F   ALTER TABLE ONLY public."BELONG_TO" DROP CONSTRAINT "BELONG_TO_pkey";
       public            root    false    255    255            �           2606    34885    BOARD BOARD_pkey 
   CONSTRAINT     S   ALTER TABLE ONLY public."BOARD"
    ADD CONSTRAINT "BOARD_pkey" PRIMARY KEY (_id);
 >   ALTER TABLE ONLY public."BOARD" DROP CONSTRAINT "BOARD_pkey";
       public            root    false    256            �           2606    34887    CUSTOMER CUSTOMER_pkey 
   CONSTRAINT     `   ALTER TABLE ONLY public."CUSTOMER"
    ADD CONSTRAINT "CUSTOMER_pkey" PRIMARY KEY (profile_id);
 D   ALTER TABLE ONLY public."CUSTOMER" DROP CONSTRAINT "CUSTOMER_pkey";
       public            root    false    258            �           2606    43024    DEVTYPE DEVTYPE_dev_type_key 
   CONSTRAINT     _   ALTER TABLE ONLY public."DEVTYPE"
    ADD CONSTRAINT "DEVTYPE_dev_type_key" UNIQUE (dev_type);
 J   ALTER TABLE ONLY public."DEVTYPE" DROP CONSTRAINT "DEVTYPE_dev_type_key";
       public            root    false    274            �           2606    43022    DEVTYPE DEVTYPE_pkey 
   CONSTRAINT     W   ALTER TABLE ONLY public."DEVTYPE"
    ADD CONSTRAINT "DEVTYPE_pkey" PRIMARY KEY (_id);
 B   ALTER TABLE ONLY public."DEVTYPE" DROP CONSTRAINT "DEVTYPE_pkey";
       public            root    false    274            �           2606    34889 "   ENDDEV_PAYLOAD ENDDEV_PAYLOAD_pkey 
   CONSTRAINT     e   ALTER TABLE ONLY public."ENDDEV_PAYLOAD"
    ADD CONSTRAINT "ENDDEV_PAYLOAD_pkey" PRIMARY KEY (_id);
 P   ALTER TABLE ONLY public."ENDDEV_PAYLOAD" DROP CONSTRAINT "ENDDEV_PAYLOAD_pkey";
       public            root    false    260            �           2606    34891    ENDDEV ENDDEV_dev_id_key 
   CONSTRAINT     Y   ALTER TABLE ONLY public."ENDDEV"
    ADD CONSTRAINT "ENDDEV_dev_id_key" UNIQUE (dev_id);
 F   ALTER TABLE ONLY public."ENDDEV" DROP CONSTRAINT "ENDDEV_dev_id_key";
       public            root    false    259            �           2606    34893    ENDDEV ENDDEV_pkey 
   CONSTRAINT     U   ALTER TABLE ONLY public."ENDDEV"
    ADD CONSTRAINT "ENDDEV_pkey" PRIMARY KEY (_id);
 @   ALTER TABLE ONLY public."ENDDEV" DROP CONSTRAINT "ENDDEV_pkey";
       public            root    false    259            �           2606    34897    NOTIFICATION NOTIFICATION_pkey 
   CONSTRAINT     a   ALTER TABLE ONLY public."NOTIFICATION"
    ADD CONSTRAINT "NOTIFICATION_pkey" PRIMARY KEY (_id);
 L   ALTER TABLE ONLY public."NOTIFICATION" DROP CONSTRAINT "NOTIFICATION_pkey";
       public            root    false    263            �           2606    34899    NOTIFY NOTIFY_pkey 
   CONSTRAINT     e   ALTER TABLE ONLY public."NOTIFY"
    ADD CONSTRAINT "NOTIFY_pkey" PRIMARY KEY (profile_id, noti_id);
 @   ALTER TABLE ONLY public."NOTIFY" DROP CONSTRAINT "NOTIFY_pkey";
       public            root    false    265    265            �           2606    34901    OWN OWN_pkey 
   CONSTRAINT     a   ALTER TABLE ONLY public."OWN"
    ADD CONSTRAINT "OWN_pkey" PRIMARY KEY (profile_id, enddev_id);
 :   ALTER TABLE ONLY public."OWN" DROP CONSTRAINT "OWN_pkey";
       public            root    false    266    266            �           2606    34903    PROFILE PROFILE_pkey 
   CONSTRAINT     W   ALTER TABLE ONLY public."PROFILE"
    ADD CONSTRAINT "PROFILE_pkey" PRIMARY KEY (_id);
 B   ALTER TABLE ONLY public."PROFILE" DROP CONSTRAINT "PROFILE_pkey";
       public            root    false    267            �           2606    34905    SENSOR SENSOR_pkey 
   CONSTRAINT     U   ALTER TABLE ONLY public."SENSOR"
    ADD CONSTRAINT "SENSOR_pkey" PRIMARY KEY (_id);
 @   ALTER TABLE ONLY public."SENSOR" DROP CONSTRAINT "SENSOR_pkey";
       public            root    false    269            �           2606    43040    WIDGET_TYPE WIDGET_TYPE_pkey 
   CONSTRAINT     _   ALTER TABLE ONLY public."WIDGET_TYPE"
    ADD CONSTRAINT "WIDGET_TYPE_pkey" PRIMARY KEY (_id);
 J   ALTER TABLE ONLY public."WIDGET_TYPE" DROP CONSTRAINT "WIDGET_TYPE_pkey";
       public            root    false    276            �           2606    34909    WIDGET WIDGET_pkey 
   CONSTRAINT     U   ALTER TABLE ONLY public."WIDGET"
    ADD CONSTRAINT "WIDGET_pkey" PRIMARY KEY (_id);
 @   ALTER TABLE ONLY public."WIDGET" DROP CONSTRAINT "WIDGET_pkey";
       public            root    false    271            �           2606    34910    ADMIN ADMIN_profile_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."ADMIN"
    ADD CONSTRAINT "ADMIN_profile_id_fkey" FOREIGN KEY (profile_id) REFERENCES public."PROFILE"(_id) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;
 I   ALTER TABLE ONLY public."ADMIN" DROP CONSTRAINT "ADMIN_profile_id_fkey";
       public          root    false    267    254    3472            �           2606    34915 "   BELONG_TO BELONG_TO_sensor_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."BELONG_TO"
    ADD CONSTRAINT "BELONG_TO_sensor_id_fkey" FOREIGN KEY (sensor_id) REFERENCES public."SENSOR"(_id) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;
 P   ALTER TABLE ONLY public."BELONG_TO" DROP CONSTRAINT "BELONG_TO_sensor_id_fkey";
       public          root    false    255    3474    269            �           2606    34920 "   BELONG_TO BELONG_TO_widget_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."BELONG_TO"
    ADD CONSTRAINT "BELONG_TO_widget_id_fkey" FOREIGN KEY (widget_id) REFERENCES public."WIDGET"(_id) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;
 P   ALTER TABLE ONLY public."BELONG_TO" DROP CONSTRAINT "BELONG_TO_widget_id_fkey";
       public          root    false    271    255    3476            �           2606    34925    BOARD BOARD_profile_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."BOARD"
    ADD CONSTRAINT "BOARD_profile_id_fkey" FOREIGN KEY (profile_id) REFERENCES public."CUSTOMER"(profile_id) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;
 I   ALTER TABLE ONLY public."BOARD" DROP CONSTRAINT "BOARD_profile_id_fkey";
       public          root    false    3458    256    258            �           2606    34930 !   CUSTOMER CUSTOMER_profile_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."CUSTOMER"
    ADD CONSTRAINT "CUSTOMER_profile_id_fkey" FOREIGN KEY (profile_id) REFERENCES public."PROFILE"(_id) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;
 O   ALTER TABLE ONLY public."CUSTOMER" DROP CONSTRAINT "CUSTOMER_profile_id_fkey";
       public          root    false    258    267    3472            �           2606    34935 ,   ENDDEV_PAYLOAD ENDDEV_PAYLOAD_enddev_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."ENDDEV_PAYLOAD"
    ADD CONSTRAINT "ENDDEV_PAYLOAD_enddev_id_fkey" FOREIGN KEY (enddev_id) REFERENCES public."ENDDEV"(_id) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;
 Z   ALTER TABLE ONLY public."ENDDEV_PAYLOAD" DROP CONSTRAINT "ENDDEV_PAYLOAD_enddev_id_fkey";
       public          root    false    260    3462    259            �           2606    43025    ENDDEV ENDDEV_dev_type_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."ENDDEV"
    ADD CONSTRAINT "ENDDEV_dev_type_id_fkey" FOREIGN KEY (dev_type_id) REFERENCES public."DEVTYPE"(_id) NOT VALID;
 L   ALTER TABLE ONLY public."ENDDEV" DROP CONSTRAINT "ENDDEV_dev_type_id_fkey";
       public          root    false    274    259    3480            �           2606    34950    NOTIFY NOTIFY_noti_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."NOTIFY"
    ADD CONSTRAINT "NOTIFY_noti_id_fkey" FOREIGN KEY (noti_id) REFERENCES public."NOTIFICATION"(_id) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;
 H   ALTER TABLE ONLY public."NOTIFY" DROP CONSTRAINT "NOTIFY_noti_id_fkey";
       public          root    false    3466    263    265            �           2606    34955    NOTIFY NOTIFY_profile_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."NOTIFY"
    ADD CONSTRAINT "NOTIFY_profile_id_fkey" FOREIGN KEY (profile_id) REFERENCES public."PROFILE"(_id) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;
 K   ALTER TABLE ONLY public."NOTIFY" DROP CONSTRAINT "NOTIFY_profile_id_fkey";
       public          root    false    265    3472    267            �           2606    34960    OWN OWN_enddev_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."OWN"
    ADD CONSTRAINT "OWN_enddev_id_fkey" FOREIGN KEY (enddev_id) REFERENCES public."ENDDEV"(_id) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;
 D   ALTER TABLE ONLY public."OWN" DROP CONSTRAINT "OWN_enddev_id_fkey";
       public          root    false    259    3462    266            �           2606    34965    OWN OWN_profile_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."OWN"
    ADD CONSTRAINT "OWN_profile_id_fkey" FOREIGN KEY (profile_id) REFERENCES public."CUSTOMER"(profile_id) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;
 E   ALTER TABLE ONLY public."OWN" DROP CONSTRAINT "OWN_profile_id_fkey";
       public          root    false    266    258    3458            �           2606    34970    SENSOR SENSOR_enddev_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."SENSOR"
    ADD CONSTRAINT "SENSOR_enddev_id_fkey" FOREIGN KEY (enddev_id) REFERENCES public."ENDDEV"(_id) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;
 J   ALTER TABLE ONLY public."SENSOR" DROP CONSTRAINT "SENSOR_enddev_id_fkey";
       public          root    false    259    269    3462            �           2606    34975    WIDGET WIDGET_board_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."WIDGET"
    ADD CONSTRAINT "WIDGET_board_id_fkey" FOREIGN KEY (board_id) REFERENCES public."BOARD"(_id) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;
 I   ALTER TABLE ONLY public."WIDGET" DROP CONSTRAINT "WIDGET_board_id_fkey";
       public          root    false    256    3456    271            �           2606    43041 !   WIDGET WIDGET_widget_type_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."WIDGET"
    ADD CONSTRAINT "WIDGET_widget_type_id_fkey" FOREIGN KEY (widget_type_id) REFERENCES public."WIDGET_TYPE"(_id) NOT VALID;
 O   ALTER TABLE ONLY public."WIDGET" DROP CONSTRAINT "WIDGET_widget_type_id_fkey";
       public          root    false    271    3482    276           