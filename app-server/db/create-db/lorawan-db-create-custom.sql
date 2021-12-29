PGDMP     1                    y         
   lorawan-db    12.9    12.9 I               0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            	           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            
           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false                       1262    18358 
   lorawan-db    DATABASE     |   CREATE DATABASE "lorawan-db" WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'en_US.utf8' LC_CTYPE = 'en_US.utf8';
    DROP DATABASE "lorawan-db";
                root    false                        3079    16972    timescaledb 	   EXTENSION     ?   CREATE EXTENSION IF NOT EXISTS timescaledb WITH SCHEMA public;
    DROP EXTENSION timescaledb;
                   false                       0    0    EXTENSION timescaledb    COMMENT     i   COMMENT ON EXTENSION timescaledb IS 'Enables scalable inserts and complex queries for time-series data';
                        false    2            �            1259    18386    ADMIN    TABLE     g   CREATE TABLE public."ADMIN" (
    profile_id integer NOT NULL,
    title character varying NOT NULL
);
    DROP TABLE public."ADMIN";
       public         heap    root    false                       1259    18440 	   BELONG_TO    TABLE     d   CREATE TABLE public."BELONG_TO" (
    widget_id integer NOT NULL,
    sensor_id integer NOT NULL
);
    DROP TABLE public."BELONG_TO";
       public         heap    root    false                       1259    18420    BOARD    TABLE     �   CREATE TABLE public."BOARD" (
    _id integer NOT NULL,
    display_name character varying NOT NULL,
    profile_id integer NOT NULL
);
    DROP TABLE public."BOARD";
       public         heap    root    false                       1259    18418    BOARD__id_seq    SEQUENCE     �   CREATE SEQUENCE public."BOARD__id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE public."BOARD__id_seq";
       public          root    false    261                       0    0    BOARD__id_seq    SEQUENCE OWNED BY     C   ALTER SEQUENCE public."BOARD__id_seq" OWNED BY public."BOARD"._id;
          public          root    false    260                        1259    18394    CUSTOMER    TABLE     D   CREATE TABLE public."CUSTOMER" (
    profile_id integer NOT NULL
);
    DROP TABLE public."CUSTOMER";
       public         heap    root    false            
           1259    18447    ENDDEV    TABLE     �  CREATE TABLE public."ENDDEV" (
    _id integer NOT NULL,
    display_name character varying NOT NULL,
    dev_id character varying NOT NULL,
    dev_addr character varying NOT NULL,
    join_eui character varying NOT NULL,
    dev_eui character varying NOT NULL,
    dev_type character varying,
    dev_brand character varying NOT NULL,
    dev_model character varying NOT NULL,
    dev_band character varying NOT NULL
);
    DROP TABLE public."ENDDEV";
       public         heap    root    false                       1259    18485    ENDDEV_PAYLOAD    TABLE     �   CREATE TABLE public."ENDDEV_PAYLOAD" (
    _id integer NOT NULL,
    recv_timestamp timestamp without time zone NOT NULL,
    payload_data jsonb NOT NULL,
    enddev_id integer NOT NULL
);
 $   DROP TABLE public."ENDDEV_PAYLOAD";
       public         heap    root    false                       1259    18483    ENDDEV_PAYLOAD__id_seq    SEQUENCE     �   CREATE SEQUENCE public."ENDDEV_PAYLOAD__id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 /   DROP SEQUENCE public."ENDDEV_PAYLOAD__id_seq";
       public          root    false    273                       0    0    ENDDEV_PAYLOAD__id_seq    SEQUENCE OWNED BY     U   ALTER SEQUENCE public."ENDDEV_PAYLOAD__id_seq" OWNED BY public."ENDDEV_PAYLOAD"._id;
          public          root    false    272            	           1259    18445    ENDDEV__id_seq    SEQUENCE     �   CREATE SEQUENCE public."ENDDEV__id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 '   DROP SEQUENCE public."ENDDEV__id_seq";
       public          root    false    266                       0    0    ENDDEV__id_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE public."ENDDEV__id_seq" OWNED BY public."ENDDEV"._id;
          public          root    false    265                       1259    18467    HAS_UNIT    TABLE     a   CREATE TABLE public."HAS_UNIT" (
    sensor_id integer NOT NULL,
    unit_id integer NOT NULL
);
    DROP TABLE public."HAS_UNIT";
       public         heap    root    false                       1259    18404    NOTIFICATION    TABLE     �   CREATE TABLE public."NOTIFICATION" (
    _id integer NOT NULL,
    title character varying NOT NULL,
    content character varying NOT NULL,
    updated_timestamp timestamp without time zone NOT NULL
);
 "   DROP TABLE public."NOTIFICATION";
       public         heap    root    false                       1259    18402    NOTIFICATION__id_seq    SEQUENCE     �   CREATE SEQUENCE public."NOTIFICATION__id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 -   DROP SEQUENCE public."NOTIFICATION__id_seq";
       public          root    false    258                       0    0    NOTIFICATION__id_seq    SEQUENCE OWNED BY     Q   ALTER SEQUENCE public."NOTIFICATION__id_seq" OWNED BY public."NOTIFICATION"._id;
          public          root    false    257                       1259    18413    NOTIFY    TABLE     `   CREATE TABLE public."NOTIFY" (
    profile_id integer NOT NULL,
    noti_id integer NOT NULL
);
    DROP TABLE public."NOTIFY";
       public         heap    root    false                       1259    18497    OWN    TABLE     _   CREATE TABLE public."OWN" (
    profile_id integer NOT NULL,
    enddev_id integer NOT NULL
);
    DROP TABLE public."OWN";
       public         heap    root    false            �            1259    18367    PROFILE    TABLE     �   CREATE TABLE public."PROFILE" (
    email character varying,
    phone_number character varying,
    password character varying NOT NULL,
    type character varying NOT NULL,
    _id integer NOT NULL,
    display_name character varying NOT NULL
);
    DROP TABLE public."PROFILE";
       public         heap    root    false            �            1259    18375    PROFILE__id_seq    SEQUENCE     �   CREATE SEQUENCE public."PROFILE__id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE public."PROFILE__id_seq";
       public          root    false    253                       0    0    PROFILE__id_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE public."PROFILE__id_seq" OWNED BY public."PROFILE"._id;
          public          root    false    254                       1259    18458    SENSOR    TABLE     �   CREATE TABLE public."SENSOR" (
    enddev_id integer NOT NULL,
    _id integer NOT NULL,
    sensor_key character varying NOT NULL
);
    DROP TABLE public."SENSOR";
       public         heap    root    false                       1259    18456    SENSOR__id_seq    SEQUENCE     �   CREATE SEQUENCE public."SENSOR__id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 '   DROP SEQUENCE public."SENSOR__id_seq";
       public          root    false    268                       0    0    SENSOR__id_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE public."SENSOR__id_seq" OWNED BY public."SENSOR"._id;
          public          root    false    267                       1259    18474    UNIT    TABLE     �   CREATE TABLE public."UNIT" (
    _id integer NOT NULL,
    sensor_key character varying NOT NULL,
    dev_type character varying NOT NULL,
    unit character varying NOT NULL
);
    DROP TABLE public."UNIT";
       public         heap    root    false                       1259    18472    UNIT__id_seq    SEQUENCE     �   CREATE SEQUENCE public."UNIT__id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 %   DROP SEQUENCE public."UNIT__id_seq";
       public          root    false    271                       0    0    UNIT__id_seq    SEQUENCE OWNED BY     A   ALTER SEQUENCE public."UNIT__id_seq" OWNED BY public."UNIT"._id;
          public          root    false    270                       1259    18431    WIDGET    TABLE     �   CREATE TABLE public."WIDGET" (
    _id integer NOT NULL,
    display_name character varying NOT NULL,
    config_dict jsonb,
    board_id integer NOT NULL
);
    DROP TABLE public."WIDGET";
       public         heap    root    false                       1259    18429    WIDGET__id_seq    SEQUENCE     �   CREATE SEQUENCE public."WIDGET__id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 '   DROP SEQUENCE public."WIDGET__id_seq";
       public          root    false    263                       0    0    WIDGET__id_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE public."WIDGET__id_seq" OWNED BY public."WIDGET"._id;
          public          root    false    262                       2604    18423 	   BOARD _id    DEFAULT     j   ALTER TABLE ONLY public."BOARD" ALTER COLUMN _id SET DEFAULT nextval('public."BOARD__id_seq"'::regclass);
 :   ALTER TABLE public."BOARD" ALTER COLUMN _id DROP DEFAULT;
       public          root    false    260    261    261                       2604    18450 
   ENDDEV _id    DEFAULT     l   ALTER TABLE ONLY public."ENDDEV" ALTER COLUMN _id SET DEFAULT nextval('public."ENDDEV__id_seq"'::regclass);
 ;   ALTER TABLE public."ENDDEV" ALTER COLUMN _id DROP DEFAULT;
       public          root    false    265    266    266                       2604    18488    ENDDEV_PAYLOAD _id    DEFAULT     |   ALTER TABLE ONLY public."ENDDEV_PAYLOAD" ALTER COLUMN _id SET DEFAULT nextval('public."ENDDEV_PAYLOAD__id_seq"'::regclass);
 C   ALTER TABLE public."ENDDEV_PAYLOAD" ALTER COLUMN _id DROP DEFAULT;
       public          root    false    272    273    273                       2604    18407    NOTIFICATION _id    DEFAULT     x   ALTER TABLE ONLY public."NOTIFICATION" ALTER COLUMN _id SET DEFAULT nextval('public."NOTIFICATION__id_seq"'::regclass);
 A   ALTER TABLE public."NOTIFICATION" ALTER COLUMN _id DROP DEFAULT;
       public          root    false    257    258    258                        2604    18377    PROFILE _id    DEFAULT     n   ALTER TABLE ONLY public."PROFILE" ALTER COLUMN _id SET DEFAULT nextval('public."PROFILE__id_seq"'::regclass);
 <   ALTER TABLE public."PROFILE" ALTER COLUMN _id DROP DEFAULT;
       public          root    false    254    253                       2604    18461 
   SENSOR _id    DEFAULT     l   ALTER TABLE ONLY public."SENSOR" ALTER COLUMN _id SET DEFAULT nextval('public."SENSOR__id_seq"'::regclass);
 ;   ALTER TABLE public."SENSOR" ALTER COLUMN _id DROP DEFAULT;
       public          root    false    267    268    268                       2604    18477    UNIT _id    DEFAULT     h   ALTER TABLE ONLY public."UNIT" ALTER COLUMN _id SET DEFAULT nextval('public."UNIT__id_seq"'::regclass);
 9   ALTER TABLE public."UNIT" ALTER COLUMN _id DROP DEFAULT;
       public          root    false    271    270    271                       2604    18434 
   WIDGET _id    DEFAULT     l   ALTER TABLE ONLY public."WIDGET" ALTER COLUMN _id SET DEFAULT nextval('public."WIDGET__id_seq"'::regclass);
 ;   ALTER TABLE public."WIDGET" ALTER COLUMN _id DROP DEFAULT;
       public          root    false    262    263    263            T           2606    18393    ADMIN ADMIN_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public."ADMIN"
    ADD CONSTRAINT "ADMIN_pkey" PRIMARY KEY (profile_id);
 >   ALTER TABLE ONLY public."ADMIN" DROP CONSTRAINT "ADMIN_pkey";
       public            root    false    255            `           2606    18444    BELONG_TO BELONG_TO_pkey 
   CONSTRAINT     l   ALTER TABLE ONLY public."BELONG_TO"
    ADD CONSTRAINT "BELONG_TO_pkey" PRIMARY KEY (widget_id, sensor_id);
 F   ALTER TABLE ONLY public."BELONG_TO" DROP CONSTRAINT "BELONG_TO_pkey";
       public            root    false    264    264            \           2606    18428    BOARD BOARD_pkey 
   CONSTRAINT     S   ALTER TABLE ONLY public."BOARD"
    ADD CONSTRAINT "BOARD_pkey" PRIMARY KEY (_id);
 >   ALTER TABLE ONLY public."BOARD" DROP CONSTRAINT "BOARD_pkey";
       public            root    false    261            V           2606    18401    CUSTOMER CUSTOMER_pkey 
   CONSTRAINT     `   ALTER TABLE ONLY public."CUSTOMER"
    ADD CONSTRAINT "CUSTOMER_pkey" PRIMARY KEY (profile_id);
 D   ALTER TABLE ONLY public."CUSTOMER" DROP CONSTRAINT "CUSTOMER_pkey";
       public            root    false    256            l           2606    18493 "   ENDDEV_PAYLOAD ENDDEV_PAYLOAD_pkey 
   CONSTRAINT     e   ALTER TABLE ONLY public."ENDDEV_PAYLOAD"
    ADD CONSTRAINT "ENDDEV_PAYLOAD_pkey" PRIMARY KEY (_id);
 P   ALTER TABLE ONLY public."ENDDEV_PAYLOAD" DROP CONSTRAINT "ENDDEV_PAYLOAD_pkey";
       public            root    false    273            b           2606    18769    ENDDEV ENDDEV_dev_id_key 
   CONSTRAINT     Y   ALTER TABLE ONLY public."ENDDEV"
    ADD CONSTRAINT "ENDDEV_dev_id_key" UNIQUE (dev_id);
 F   ALTER TABLE ONLY public."ENDDEV" DROP CONSTRAINT "ENDDEV_dev_id_key";
       public            root    false    266            d           2606    18455    ENDDEV ENDDEV_pkey 
   CONSTRAINT     U   ALTER TABLE ONLY public."ENDDEV"
    ADD CONSTRAINT "ENDDEV_pkey" PRIMARY KEY (_id);
 @   ALTER TABLE ONLY public."ENDDEV" DROP CONSTRAINT "ENDDEV_pkey";
       public            root    false    266            h           2606    18471    HAS_UNIT HAS_UNIT_pkey 
   CONSTRAINT     h   ALTER TABLE ONLY public."HAS_UNIT"
    ADD CONSTRAINT "HAS_UNIT_pkey" PRIMARY KEY (sensor_id, unit_id);
 D   ALTER TABLE ONLY public."HAS_UNIT" DROP CONSTRAINT "HAS_UNIT_pkey";
       public            root    false    269    269            X           2606    18412    NOTIFICATION NOTIFICATION_pkey 
   CONSTRAINT     a   ALTER TABLE ONLY public."NOTIFICATION"
    ADD CONSTRAINT "NOTIFICATION_pkey" PRIMARY KEY (_id);
 L   ALTER TABLE ONLY public."NOTIFICATION" DROP CONSTRAINT "NOTIFICATION_pkey";
       public            root    false    258            Z           2606    18417    NOTIFY NOTIFY_pkey 
   CONSTRAINT     e   ALTER TABLE ONLY public."NOTIFY"
    ADD CONSTRAINT "NOTIFY_pkey" PRIMARY KEY (profile_id, noti_id);
 @   ALTER TABLE ONLY public."NOTIFY" DROP CONSTRAINT "NOTIFY_pkey";
       public            root    false    259    259            n           2606    18501    OWN OWN_pkey 
   CONSTRAINT     a   ALTER TABLE ONLY public."OWN"
    ADD CONSTRAINT "OWN_pkey" PRIMARY KEY (profile_id, enddev_id);
 :   ALTER TABLE ONLY public."OWN" DROP CONSTRAINT "OWN_pkey";
       public            root    false    274    274            R           2606    18385    PROFILE PROFILE_pkey 
   CONSTRAINT     W   ALTER TABLE ONLY public."PROFILE"
    ADD CONSTRAINT "PROFILE_pkey" PRIMARY KEY (_id);
 B   ALTER TABLE ONLY public."PROFILE" DROP CONSTRAINT "PROFILE_pkey";
       public            root    false    253            f           2606    18466    SENSOR SENSOR_pkey 
   CONSTRAINT     U   ALTER TABLE ONLY public."SENSOR"
    ADD CONSTRAINT "SENSOR_pkey" PRIMARY KEY (_id);
 @   ALTER TABLE ONLY public."SENSOR" DROP CONSTRAINT "SENSOR_pkey";
       public            root    false    268            j           2606    18482    UNIT UNIT_pkey 
   CONSTRAINT     Q   ALTER TABLE ONLY public."UNIT"
    ADD CONSTRAINT "UNIT_pkey" PRIMARY KEY (_id);
 <   ALTER TABLE ONLY public."UNIT" DROP CONSTRAINT "UNIT_pkey";
       public            root    false    271            ^           2606    18439    WIDGET WIDGET_pkey 
   CONSTRAINT     U   ALTER TABLE ONLY public."WIDGET"
    ADD CONSTRAINT "WIDGET_pkey" PRIMARY KEY (_id);
 @   ALTER TABLE ONLY public."WIDGET" DROP CONSTRAINT "WIDGET_pkey";
       public            root    false    263            o           2606    18512    ADMIN ADMIN_profile_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."ADMIN"
    ADD CONSTRAINT "ADMIN_profile_id_fkey" FOREIGN KEY (profile_id) REFERENCES public."PROFILE"(_id) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;
 I   ALTER TABLE ONLY public."ADMIN" DROP CONSTRAINT "ADMIN_profile_id_fkey";
       public          root    false    253    255    3410            u           2606    18537 "   BELONG_TO BELONG_TO_sensor_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."BELONG_TO"
    ADD CONSTRAINT "BELONG_TO_sensor_id_fkey" FOREIGN KEY (sensor_id) REFERENCES public."SENSOR"(_id) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;
 P   ALTER TABLE ONLY public."BELONG_TO" DROP CONSTRAINT "BELONG_TO_sensor_id_fkey";
       public          root    false    3430    264    268            v           2606    18532 "   BELONG_TO BELONG_TO_widget_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."BELONG_TO"
    ADD CONSTRAINT "BELONG_TO_widget_id_fkey" FOREIGN KEY (widget_id) REFERENCES public."WIDGET"(_id) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;
 P   ALTER TABLE ONLY public."BELONG_TO" DROP CONSTRAINT "BELONG_TO_widget_id_fkey";
       public          root    false    3422    264    263            s           2606    18522    BOARD BOARD_profile_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."BOARD"
    ADD CONSTRAINT "BOARD_profile_id_fkey" FOREIGN KEY (profile_id) REFERENCES public."CUSTOMER"(profile_id) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;
 I   ALTER TABLE ONLY public."BOARD" DROP CONSTRAINT "BOARD_profile_id_fkey";
       public          root    false    256    261    3414            p           2606    18517 !   CUSTOMER CUSTOMER_profile_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."CUSTOMER"
    ADD CONSTRAINT "CUSTOMER_profile_id_fkey" FOREIGN KEY (profile_id) REFERENCES public."PROFILE"(_id) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;
 O   ALTER TABLE ONLY public."CUSTOMER" DROP CONSTRAINT "CUSTOMER_profile_id_fkey";
       public          root    false    253    256    3410            z           2606    18559 ,   ENDDEV_PAYLOAD ENDDEV_PAYLOAD_enddev_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."ENDDEV_PAYLOAD"
    ADD CONSTRAINT "ENDDEV_PAYLOAD_enddev_id_fkey" FOREIGN KEY (enddev_id) REFERENCES public."ENDDEV"(_id) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;
 Z   ALTER TABLE ONLY public."ENDDEV_PAYLOAD" DROP CONSTRAINT "ENDDEV_PAYLOAD_enddev_id_fkey";
       public          root    false    273    266    3428            x           2606    18549     HAS_UNIT HAS_UNIT_sensor_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."HAS_UNIT"
    ADD CONSTRAINT "HAS_UNIT_sensor_id_fkey" FOREIGN KEY (sensor_id) REFERENCES public."SENSOR"(_id) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;
 N   ALTER TABLE ONLY public."HAS_UNIT" DROP CONSTRAINT "HAS_UNIT_sensor_id_fkey";
       public          root    false    268    3430    269            y           2606    18554    HAS_UNIT HAS_UNIT_unit_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."HAS_UNIT"
    ADD CONSTRAINT "HAS_UNIT_unit_id_fkey" FOREIGN KEY (unit_id) REFERENCES public."UNIT"(_id) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;
 L   ALTER TABLE ONLY public."HAS_UNIT" DROP CONSTRAINT "HAS_UNIT_unit_id_fkey";
       public          root    false    271    269    3434            q           2606    18507    NOTIFY NOTIFY_noti_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."NOTIFY"
    ADD CONSTRAINT "NOTIFY_noti_id_fkey" FOREIGN KEY (noti_id) REFERENCES public."NOTIFICATION"(_id) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;
 H   ALTER TABLE ONLY public."NOTIFY" DROP CONSTRAINT "NOTIFY_noti_id_fkey";
       public          root    false    258    259    3416            r           2606    18502    NOTIFY NOTIFY_profile_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."NOTIFY"
    ADD CONSTRAINT "NOTIFY_profile_id_fkey" FOREIGN KEY (profile_id) REFERENCES public."PROFILE"(_id) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;
 K   ALTER TABLE ONLY public."NOTIFY" DROP CONSTRAINT "NOTIFY_profile_id_fkey";
       public          root    false    253    3410    259            {           2606    18569    OWN OWN_enddev_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."OWN"
    ADD CONSTRAINT "OWN_enddev_id_fkey" FOREIGN KEY (enddev_id) REFERENCES public."ENDDEV"(_id) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;
 D   ALTER TABLE ONLY public."OWN" DROP CONSTRAINT "OWN_enddev_id_fkey";
       public          root    false    274    3428    266            |           2606    18564    OWN OWN_profile_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."OWN"
    ADD CONSTRAINT "OWN_profile_id_fkey" FOREIGN KEY (profile_id) REFERENCES public."CUSTOMER"(profile_id) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;
 E   ALTER TABLE ONLY public."OWN" DROP CONSTRAINT "OWN_profile_id_fkey";
       public          root    false    274    256    3414            w           2606    18544    SENSOR SENSOR_enddev_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."SENSOR"
    ADD CONSTRAINT "SENSOR_enddev_id_fkey" FOREIGN KEY (enddev_id) REFERENCES public."ENDDEV"(_id) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;
 J   ALTER TABLE ONLY public."SENSOR" DROP CONSTRAINT "SENSOR_enddev_id_fkey";
       public          root    false    266    268    3428            t           2606    18527    WIDGET WIDGET_board_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."WIDGET"
    ADD CONSTRAINT "WIDGET_board_id_fkey" FOREIGN KEY (board_id) REFERENCES public."BOARD"(_id) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;
 I   ALTER TABLE ONLY public."WIDGET" DROP CONSTRAINT "WIDGET_board_id_fkey";
       public          root    false    3420    261    263           