PGDMP                         y            lorawan-database    12.8    12.9 y               0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false                       0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false                       0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false                       1262    34534    lorawan-database    DATABASE     �   CREATE DATABASE "lorawan-database" WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'en_US.utf8' LC_CTYPE = 'en_US.utf8';
 "   DROP DATABASE "lorawan-database";
                root    false                        3079    16973    timescaledb 	   EXTENSION     ?   CREATE EXTENSION IF NOT EXISTS timescaledb WITH SCHEMA public;
    DROP EXTENSION timescaledb;
                   false                       0    0    EXTENSION timescaledb    COMMENT     i   COMMENT ON EXTENSION timescaledb IS 'Enables scalable inserts and complex queries for time-series data';
                        false    2                       1259    34588    ADMIN    TABLE     g   CREATE TABLE public."ADMIN" (
    profile_id integer NOT NULL,
    title character varying NOT NULL
);
    DROP TABLE public."ADMIN";
       public         heap    root    false            
           1259    34656 	   BELONG_TO    TABLE     d   CREATE TABLE public."BELONG_TO" (
    widget_id integer NOT NULL,
    sensor_id integer NOT NULL
);
    DROP TABLE public."BELONG_TO";
       public         heap    root    false                       1259    34616    BOARD    TABLE     �   CREATE TABLE public."BOARD" (
    board_id integer NOT NULL,
    display_name character varying NOT NULL,
    profile_id integer NOT NULL
);
    DROP TABLE public."BOARD";
       public         heap    root    false                       1259    34614    BOARD_board_id_seq    SEQUENCE     �   CREATE SEQUENCE public."BOARD_board_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public."BOARD_board_id_seq";
       public          root    false    263                        0    0    BOARD_board_id_seq    SEQUENCE OWNED BY     M   ALTER SEQUENCE public."BOARD_board_id_seq" OWNED BY public."BOARD".board_id;
          public          root    false    262                       1259    34601    CUSTOMER    TABLE     q   CREATE TABLE public."CUSTOMER" (
    profile_id integer NOT NULL,
    display_name character varying NOT NULL
);
    DROP TABLE public."CUSTOMER";
       public         heap    root    false                       1259    34559    ENDDEV    TABLE     �  CREATE TABLE public."ENDDEV" (
    dev_id integer NOT NULL,
    display_name character varying NOT NULL,
    dev_addr character varying NOT NULL,
    join_eui character varying NOT NULL,
    dev_eui character varying NOT NULL,
    dev_type character varying NOT NULL,
    dev_brand character varying NOT NULL,
    dev_model character varying NOT NULL,
    dev_band character varying NOT NULL
);
    DROP TABLE public."ENDDEV";
       public         heap    root    false                       1259    34690    ENDDEV_PAYLOAD    TABLE     �   CREATE TABLE public."ENDDEV_PAYLOAD" (
    payload_id integer NOT NULL,
    "timestamp" time without time zone NOT NULL,
    payload_data jsonb NOT NULL,
    dev_id integer NOT NULL
);
 $   DROP TABLE public."ENDDEV_PAYLOAD";
       public         heap    root    false                       1259    34688    ENDDEV_PAYLOAD_payload_id_seq    SEQUENCE     �   CREATE SEQUENCE public."ENDDEV_PAYLOAD_payload_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 6   DROP SEQUENCE public."ENDDEV_PAYLOAD_payload_id_seq";
       public          root    false    273            !           0    0    ENDDEV_PAYLOAD_payload_id_seq    SEQUENCE OWNED BY     c   ALTER SEQUENCE public."ENDDEV_PAYLOAD_payload_id_seq" OWNED BY public."ENDDEV_PAYLOAD".payload_id;
          public          root    false    272                       1259    34557    ENDDEV_dev_id_seq    SEQUENCE     �   CREATE SEQUENCE public."ENDDEV_dev_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE public."ENDDEV_dev_id_seq";
       public          root    false    258            "           0    0    ENDDEV_dev_id_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE public."ENDDEV_dev_id_seq" OWNED BY public."ENDDEV".dev_id;
          public          root    false    257                       1259    34672    HAS_UNIT    TABLE     a   CREATE TABLE public."HAS_UNIT" (
    sensor_id integer NOT NULL,
    unit_id integer NOT NULL
);
    DROP TABLE public."HAS_UNIT";
       public         heap    root    false            �            1259    34537    NOTIFICATION    TABLE     �   CREATE TABLE public."NOTIFICATION" (
    noti_id integer NOT NULL,
    title character varying NOT NULL,
    content character varying NOT NULL,
    updated_time time without time zone NOT NULL
);
 "   DROP TABLE public."NOTIFICATION";
       public         heap    root    false                       1259    34573    NOTIFY    TABLE     `   CREATE TABLE public."NOTIFY" (
    profile_id integer NOT NULL,
    noti_id integer NOT NULL
);
    DROP TABLE public."NOTIFY";
       public         heap    root    false                       1259    34699    OWN    TABLE     \   CREATE TABLE public."OWN" (
    profile_id integer NOT NULL,
    dev_id integer NOT NULL
);
    DROP TABLE public."OWN";
       public         heap    root    false                        1259    34548    PROFILE    TABLE     �   CREATE TABLE public."PROFILE" (
    profile_id integer NOT NULL,
    phone_number character varying,
    email character varying,
    password character varying NOT NULL,
    type character varying NOT NULL
);
    DROP TABLE public."PROFILE";
       public         heap    root    false            �            1259    34546    PROFILE_profile_id_seq    SEQUENCE     �   CREATE SEQUENCE public."PROFILE_profile_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 /   DROP SEQUENCE public."PROFILE_profile_id_seq";
       public          root    false    256            #           0    0    PROFILE_profile_id_seq    SEQUENCE OWNED BY     U   ALTER SEQUENCE public."PROFILE_profile_id_seq" OWNED BY public."PROFILE".profile_id;
          public          root    false    255                       1259    34663    SENSOR    TABLE     �   CREATE TABLE public."SENSOR" (
    dev_id integer NOT NULL,
    sensor_id integer NOT NULL,
    sensor_key character varying NOT NULL
);
    DROP TABLE public."SENSOR";
       public         heap    root    false                       1259    34661    SENSOR_sensor_id_seq    SEQUENCE     �   CREATE SEQUENCE public."SENSOR_sensor_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 -   DROP SEQUENCE public."SENSOR_sensor_id_seq";
       public          root    false    268            $           0    0    SENSOR_sensor_id_seq    SEQUENCE OWNED BY     Q   ALTER SEQUENCE public."SENSOR_sensor_id_seq" OWNED BY public."SENSOR".sensor_id;
          public          root    false    267                       1259    34679    UNIT    TABLE     �   CREATE TABLE public."UNIT" (
    unit_id integer NOT NULL,
    sensor_key character varying NOT NULL,
    dev_type character varying NOT NULL,
    unit character varying NOT NULL
);
    DROP TABLE public."UNIT";
       public         heap    root    false                       1259    34677    UNIT_unit_id_seq    SEQUENCE     �   CREATE SEQUENCE public."UNIT_unit_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public."UNIT_unit_id_seq";
       public          root    false    271            %           0    0    UNIT_unit_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public."UNIT_unit_id_seq" OWNED BY public."UNIT".unit_id;
          public          root    false    270            	           1259    34632    WIDGET    TABLE     �   CREATE TABLE public."WIDGET" (
    widget_id integer NOT NULL,
    display_name character varying NOT NULL,
    config_dict jsonb NOT NULL,
    board_id integer NOT NULL
);
    DROP TABLE public."WIDGET";
       public         heap    root    false                       1259    34630    WIDGET_widget_id_seq    SEQUENCE     �   CREATE SEQUENCE public."WIDGET_widget_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 -   DROP SEQUENCE public."WIDGET_widget_id_seq";
       public          root    false    265            &           0    0    WIDGET_widget_id_seq    SEQUENCE OWNED BY     Q   ALTER SEQUENCE public."WIDGET_widget_id_seq" OWNED BY public."WIDGET".widget_id;
          public          root    false    264            �            1259    34535    notification_noti_id_seq    SEQUENCE     �   CREATE SEQUENCE public.notification_noti_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 /   DROP SEQUENCE public.notification_noti_id_seq;
       public          root    false    254            '           0    0    notification_noti_id_seq    SEQUENCE OWNED BY     W   ALTER SEQUENCE public.notification_noti_id_seq OWNED BY public."NOTIFICATION".noti_id;
          public          root    false    253                       2604    34619    BOARD board_id    DEFAULT     t   ALTER TABLE ONLY public."BOARD" ALTER COLUMN board_id SET DEFAULT nextval('public."BOARD_board_id_seq"'::regclass);
 ?   ALTER TABLE public."BOARD" ALTER COLUMN board_id DROP DEFAULT;
       public          root    false    263    262    263                       2604    34562    ENDDEV dev_id    DEFAULT     r   ALTER TABLE ONLY public."ENDDEV" ALTER COLUMN dev_id SET DEFAULT nextval('public."ENDDEV_dev_id_seq"'::regclass);
 >   ALTER TABLE public."ENDDEV" ALTER COLUMN dev_id DROP DEFAULT;
       public          root    false    257    258    258                       2604    34693    ENDDEV_PAYLOAD payload_id    DEFAULT     �   ALTER TABLE ONLY public."ENDDEV_PAYLOAD" ALTER COLUMN payload_id SET DEFAULT nextval('public."ENDDEV_PAYLOAD_payload_id_seq"'::regclass);
 J   ALTER TABLE public."ENDDEV_PAYLOAD" ALTER COLUMN payload_id DROP DEFAULT;
       public          root    false    273    272    273            �           2604    34540    NOTIFICATION noti_id    DEFAULT     ~   ALTER TABLE ONLY public."NOTIFICATION" ALTER COLUMN noti_id SET DEFAULT nextval('public.notification_noti_id_seq'::regclass);
 E   ALTER TABLE public."NOTIFICATION" ALTER COLUMN noti_id DROP DEFAULT;
       public          root    false    254    253    254                        2604    34551    PROFILE profile_id    DEFAULT     |   ALTER TABLE ONLY public."PROFILE" ALTER COLUMN profile_id SET DEFAULT nextval('public."PROFILE_profile_id_seq"'::regclass);
 C   ALTER TABLE public."PROFILE" ALTER COLUMN profile_id DROP DEFAULT;
       public          root    false    255    256    256                       2604    34666    SENSOR sensor_id    DEFAULT     x   ALTER TABLE ONLY public."SENSOR" ALTER COLUMN sensor_id SET DEFAULT nextval('public."SENSOR_sensor_id_seq"'::regclass);
 A   ALTER TABLE public."SENSOR" ALTER COLUMN sensor_id DROP DEFAULT;
       public          root    false    267    268    268                       2604    34682    UNIT unit_id    DEFAULT     p   ALTER TABLE ONLY public."UNIT" ALTER COLUMN unit_id SET DEFAULT nextval('public."UNIT_unit_id_seq"'::regclass);
 =   ALTER TABLE public."UNIT" ALTER COLUMN unit_id DROP DEFAULT;
       public          root    false    270    271    271                       2604    34635    WIDGET widget_id    DEFAULT     x   ALTER TABLE ONLY public."WIDGET" ALTER COLUMN widget_id SET DEFAULT nextval('public."WIDGET_widget_id_seq"'::regclass);
 A   ALTER TABLE public."WIDGET" ALTER COLUMN widget_id DROP DEFAULT;
       public          root    false    264    265    265            �          0    17456    cache_inval_bgw_job 
   TABLE DATA           9   COPY _timescaledb_cache.cache_inval_bgw_job  FROM stdin;
    _timescaledb_cache          root    false    242   g�       �          0    17459    cache_inval_extension 
   TABLE DATA           ;   COPY _timescaledb_cache.cache_inval_extension  FROM stdin;
    _timescaledb_cache          root    false    243   ��       �          0    17453    cache_inval_hypertable 
   TABLE DATA           <   COPY _timescaledb_cache.cache_inval_hypertable  FROM stdin;
    _timescaledb_cache          root    false    241   ��       �          0    16991 
   hypertable 
   TABLE DATA             COPY _timescaledb_catalog.hypertable (id, schema_name, table_name, associated_schema_name, associated_table_prefix, num_dimensions, chunk_sizing_func_schema, chunk_sizing_func_name, chunk_target_size, compression_state, compressed_hypertable_id, replication_factor) FROM stdin;
    _timescaledb_catalog          root    false    210   ��       �          0    17077    chunk 
   TABLE DATA              COPY _timescaledb_catalog.chunk (id, hypertable_id, schema_name, table_name, compressed_chunk_id, dropped, status) FROM stdin;
    _timescaledb_catalog          root    false    219   ی       �          0    17042 	   dimension 
   TABLE DATA           �   COPY _timescaledb_catalog.dimension (id, hypertable_id, column_name, column_type, aligned, num_slices, partitioning_func_schema, partitioning_func, interval_length, integer_now_func_schema, integer_now_func) FROM stdin;
    _timescaledb_catalog          root    false    215   ��       �          0    17061    dimension_slice 
   TABLE DATA           a   COPY _timescaledb_catalog.dimension_slice (id, dimension_id, range_start, range_end) FROM stdin;
    _timescaledb_catalog          root    false    217   �       �          0    17099    chunk_constraint 
   TABLE DATA           �   COPY _timescaledb_catalog.chunk_constraint (chunk_id, dimension_slice_id, constraint_name, hypertable_constraint_name) FROM stdin;
    _timescaledb_catalog          root    false    220   2�       �          0    17133    chunk_data_node 
   TABLE DATA           [   COPY _timescaledb_catalog.chunk_data_node (chunk_id, node_chunk_id, node_name) FROM stdin;
    _timescaledb_catalog          root    false    223   O�       �          0    17117    chunk_index 
   TABLE DATA           o   COPY _timescaledb_catalog.chunk_index (chunk_id, index_name, hypertable_id, hypertable_index_name) FROM stdin;
    _timescaledb_catalog          root    false    222   l�       �          0    17269    compression_chunk_size 
   TABLE DATA             COPY _timescaledb_catalog.compression_chunk_size (chunk_id, compressed_chunk_id, uncompressed_heap_size, uncompressed_toast_size, uncompressed_index_size, compressed_heap_size, compressed_toast_size, compressed_index_size, numrows_pre_compression, numrows_post_compression) FROM stdin;
    _timescaledb_catalog          root    false    235   ��       �          0    17198    continuous_agg 
   TABLE DATA           �   COPY _timescaledb_catalog.continuous_agg (mat_hypertable_id, raw_hypertable_id, user_view_schema, user_view_name, partial_view_schema, partial_view_name, bucket_width, direct_view_schema, direct_view_name, materialized_only) FROM stdin;
    _timescaledb_catalog          root    false    229   ��       �          0    17229 +   continuous_aggs_hypertable_invalidation_log 
   TABLE DATA           �   COPY _timescaledb_catalog.continuous_aggs_hypertable_invalidation_log (hypertable_id, lowest_modified_value, greatest_modified_value) FROM stdin;
    _timescaledb_catalog          root    false    231   Í       �          0    17219 &   continuous_aggs_invalidation_threshold 
   TABLE DATA           h   COPY _timescaledb_catalog.continuous_aggs_invalidation_threshold (hypertable_id, watermark) FROM stdin;
    _timescaledb_catalog          root    false    230   ��       �          0    17233 0   continuous_aggs_materialization_invalidation_log 
   TABLE DATA           �   COPY _timescaledb_catalog.continuous_aggs_materialization_invalidation_log (materialization_id, lowest_modified_value, greatest_modified_value) FROM stdin;
    _timescaledb_catalog          root    false    232   ��       �          0    17250    hypertable_compression 
   TABLE DATA           �   COPY _timescaledb_catalog.hypertable_compression (hypertable_id, attname, compression_algorithm_id, segmentby_column_index, orderby_column_index, orderby_asc, orderby_nullsfirst) FROM stdin;
    _timescaledb_catalog          root    false    234   �       �          0    17012    hypertable_data_node 
   TABLE DATA           x   COPY _timescaledb_catalog.hypertable_data_node (hypertable_id, node_hypertable_id, node_name, block_chunks) FROM stdin;
    _timescaledb_catalog          root    false    211   7�       �          0    17190    metadata 
   TABLE DATA           R   COPY _timescaledb_catalog.metadata (key, value, include_in_telemetry) FROM stdin;
    _timescaledb_catalog          root    false    228   T�       �          0    17284 
   remote_txn 
   TABLE DATA           Y   COPY _timescaledb_catalog.remote_txn (data_node_name, remote_transaction_id) FROM stdin;
    _timescaledb_catalog          root    false    236   ��       �          0    17026 
   tablespace 
   TABLE DATA           V   COPY _timescaledb_catalog.tablespace (id, hypertable_id, tablespace_name) FROM stdin;
    _timescaledb_catalog          root    false    213   Î       �          0    17147    bgw_job 
   TABLE DATA           �   COPY _timescaledb_config.bgw_job (id, application_name, schedule_interval, max_runtime, max_retries, retry_period, proc_schema, proc_name, owner, scheduled, hypertable_id, config) FROM stdin;
    _timescaledb_config          root    false    225   ��       
          0    34588    ADMIN 
   TABLE DATA           4   COPY public."ADMIN" (profile_id, title) FROM stdin;
    public          root    false    260   ��                 0    34656 	   BELONG_TO 
   TABLE DATA           ;   COPY public."BELONG_TO" (widget_id, sensor_id) FROM stdin;
    public          root    false    266   �                 0    34616    BOARD 
   TABLE DATA           E   COPY public."BOARD" (board_id, display_name, profile_id) FROM stdin;
    public          root    false    263   7�                 0    34601    CUSTOMER 
   TABLE DATA           >   COPY public."CUSTOMER" (profile_id, display_name) FROM stdin;
    public          root    false    261   T�                 0    34559    ENDDEV 
   TABLE DATA              COPY public."ENDDEV" (dev_id, display_name, dev_addr, join_eui, dev_eui, dev_type, dev_brand, dev_model, dev_band) FROM stdin;
    public          root    false    258   q�                 0    34690    ENDDEV_PAYLOAD 
   TABLE DATA           Y   COPY public."ENDDEV_PAYLOAD" (payload_id, "timestamp", payload_data, dev_id) FROM stdin;
    public          root    false    273   ��                 0    34672    HAS_UNIT 
   TABLE DATA           8   COPY public."HAS_UNIT" (sensor_id, unit_id) FROM stdin;
    public          root    false    269   ��                 0    34537    NOTIFICATION 
   TABLE DATA           O   COPY public."NOTIFICATION" (noti_id, title, content, updated_time) FROM stdin;
    public          root    false    254   ȏ       	          0    34573    NOTIFY 
   TABLE DATA           7   COPY public."NOTIFY" (profile_id, noti_id) FROM stdin;
    public          root    false    259   �                 0    34699    OWN 
   TABLE DATA           3   COPY public."OWN" (profile_id, dev_id) FROM stdin;
    public          root    false    274   �                 0    34548    PROFILE 
   TABLE DATA           T   COPY public."PROFILE" (profile_id, phone_number, email, password, type) FROM stdin;
    public          root    false    256   �                 0    34663    SENSOR 
   TABLE DATA           A   COPY public."SENSOR" (dev_id, sensor_id, sensor_key) FROM stdin;
    public          root    false    268   <�                 0    34679    UNIT 
   TABLE DATA           E   COPY public."UNIT" (unit_id, sensor_key, dev_type, unit) FROM stdin;
    public          root    false    271   Y�                 0    34632    WIDGET 
   TABLE DATA           R   COPY public."WIDGET" (widget_id, display_name, config_dict, board_id) FROM stdin;
    public          root    false    265   v�       (           0    0    chunk_constraint_name    SEQUENCE SET     R   SELECT pg_catalog.setval('_timescaledb_catalog.chunk_constraint_name', 1, false);
          _timescaledb_catalog          root    false    221            )           0    0    chunk_id_seq    SEQUENCE SET     I   SELECT pg_catalog.setval('_timescaledb_catalog.chunk_id_seq', 1, false);
          _timescaledb_catalog          root    false    218            *           0    0    dimension_id_seq    SEQUENCE SET     M   SELECT pg_catalog.setval('_timescaledb_catalog.dimension_id_seq', 1, false);
          _timescaledb_catalog          root    false    214            +           0    0    dimension_slice_id_seq    SEQUENCE SET     S   SELECT pg_catalog.setval('_timescaledb_catalog.dimension_slice_id_seq', 1, false);
          _timescaledb_catalog          root    false    216            ,           0    0    hypertable_id_seq    SEQUENCE SET     N   SELECT pg_catalog.setval('_timescaledb_catalog.hypertable_id_seq', 1, false);
          _timescaledb_catalog          root    false    209            -           0    0    bgw_job_id_seq    SEQUENCE SET     M   SELECT pg_catalog.setval('_timescaledb_config.bgw_job_id_seq', 1000, false);
          _timescaledb_config          root    false    224            .           0    0    BOARD_board_id_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public."BOARD_board_id_seq"', 1, false);
          public          root    false    262            /           0    0    ENDDEV_PAYLOAD_payload_id_seq    SEQUENCE SET     N   SELECT pg_catalog.setval('public."ENDDEV_PAYLOAD_payload_id_seq"', 1, false);
          public          root    false    272            0           0    0    ENDDEV_dev_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public."ENDDEV_dev_id_seq"', 1, false);
          public          root    false    257            1           0    0    PROFILE_profile_id_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('public."PROFILE_profile_id_seq"', 1, false);
          public          root    false    255            2           0    0    SENSOR_sensor_id_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public."SENSOR_sensor_id_seq"', 1, false);
          public          root    false    267            3           0    0    UNIT_unit_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public."UNIT_unit_id_seq"', 1, false);
          public          root    false    270            4           0    0    WIDGET_widget_id_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public."WIDGET_widget_id_seq"', 1, false);
          public          root    false    264            5           0    0    notification_noti_id_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('public.notification_noti_id_seq', 1, false);
          public          root    false    253            Y           2606    34595    ADMIN ADMIN_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public."ADMIN"
    ADD CONSTRAINT "ADMIN_pkey" PRIMARY KEY (profile_id);
 >   ALTER TABLE ONLY public."ADMIN" DROP CONSTRAINT "ADMIN_pkey";
       public            root    false    260            a           2606    34660    BELONG_TO BELONG_TO_pkey 
   CONSTRAINT     l   ALTER TABLE ONLY public."BELONG_TO"
    ADD CONSTRAINT "BELONG_TO_pkey" PRIMARY KEY (widget_id, sensor_id);
 F   ALTER TABLE ONLY public."BELONG_TO" DROP CONSTRAINT "BELONG_TO_pkey";
       public            root    false    266    266            ]           2606    34624    BOARD BOARD_pkey 
   CONSTRAINT     X   ALTER TABLE ONLY public."BOARD"
    ADD CONSTRAINT "BOARD_pkey" PRIMARY KEY (board_id);
 >   ALTER TABLE ONLY public."BOARD" DROP CONSTRAINT "BOARD_pkey";
       public            root    false    263            [           2606    34608    CUSTOMER CUSTOMER_pkey 
   CONSTRAINT     `   ALTER TABLE ONLY public."CUSTOMER"
    ADD CONSTRAINT "CUSTOMER_pkey" PRIMARY KEY (profile_id);
 D   ALTER TABLE ONLY public."CUSTOMER" DROP CONSTRAINT "CUSTOMER_pkey";
       public            root    false    261            i           2606    34698 "   ENDDEV_PAYLOAD ENDDEV_PAYLOAD_pkey 
   CONSTRAINT     l   ALTER TABLE ONLY public."ENDDEV_PAYLOAD"
    ADD CONSTRAINT "ENDDEV_PAYLOAD_pkey" PRIMARY KEY (payload_id);
 P   ALTER TABLE ONLY public."ENDDEV_PAYLOAD" DROP CONSTRAINT "ENDDEV_PAYLOAD_pkey";
       public            root    false    273            U           2606    34567    ENDDEV ENDDEV_pkey 
   CONSTRAINT     X   ALTER TABLE ONLY public."ENDDEV"
    ADD CONSTRAINT "ENDDEV_pkey" PRIMARY KEY (dev_id);
 @   ALTER TABLE ONLY public."ENDDEV" DROP CONSTRAINT "ENDDEV_pkey";
       public            root    false    258            e           2606    34676    HAS_UNIT HAS_UNIT_pkey 
   CONSTRAINT     h   ALTER TABLE ONLY public."HAS_UNIT"
    ADD CONSTRAINT "HAS_UNIT_pkey" PRIMARY KEY (sensor_id, unit_id);
 D   ALTER TABLE ONLY public."HAS_UNIT" DROP CONSTRAINT "HAS_UNIT_pkey";
       public            root    false    269    269            W           2606    34577    NOTIFY NOTIFY_pkey 
   CONSTRAINT     e   ALTER TABLE ONLY public."NOTIFY"
    ADD CONSTRAINT "NOTIFY_pkey" PRIMARY KEY (profile_id, noti_id);
 @   ALTER TABLE ONLY public."NOTIFY" DROP CONSTRAINT "NOTIFY_pkey";
       public            root    false    259    259            k           2606    34703    OWN OWN_pkey 
   CONSTRAINT     ^   ALTER TABLE ONLY public."OWN"
    ADD CONSTRAINT "OWN_pkey" PRIMARY KEY (profile_id, dev_id);
 :   ALTER TABLE ONLY public."OWN" DROP CONSTRAINT "OWN_pkey";
       public            root    false    274    274            S           2606    34556    PROFILE PROFILE_pkey 
   CONSTRAINT     ^   ALTER TABLE ONLY public."PROFILE"
    ADD CONSTRAINT "PROFILE_pkey" PRIMARY KEY (profile_id);
 B   ALTER TABLE ONLY public."PROFILE" DROP CONSTRAINT "PROFILE_pkey";
       public            root    false    256            c           2606    34671    SENSOR SENSOR_pkey 
   CONSTRAINT     [   ALTER TABLE ONLY public."SENSOR"
    ADD CONSTRAINT "SENSOR_pkey" PRIMARY KEY (sensor_id);
 @   ALTER TABLE ONLY public."SENSOR" DROP CONSTRAINT "SENSOR_pkey";
       public            root    false    268            g           2606    34687    UNIT UNIT_pkey 
   CONSTRAINT     U   ALTER TABLE ONLY public."UNIT"
    ADD CONSTRAINT "UNIT_pkey" PRIMARY KEY (unit_id);
 <   ALTER TABLE ONLY public."UNIT" DROP CONSTRAINT "UNIT_pkey";
       public            root    false    271            _           2606    34640    WIDGET WIDGET_pkey 
   CONSTRAINT     [   ALTER TABLE ONLY public."WIDGET"
    ADD CONSTRAINT "WIDGET_pkey" PRIMARY KEY (widget_id);
 @   ALTER TABLE ONLY public."WIDGET" DROP CONSTRAINT "WIDGET_pkey";
       public            root    false    265            Q           2606    34545    NOTIFICATION notification_pkey 
   CONSTRAINT     c   ALTER TABLE ONLY public."NOTIFICATION"
    ADD CONSTRAINT notification_pkey PRIMARY KEY (noti_id);
 J   ALTER TABLE ONLY public."NOTIFICATION" DROP CONSTRAINT notification_pkey;
       public            root    false    254            n           2606    34704    ADMIN ADMIN_profile_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."ADMIN"
    ADD CONSTRAINT "ADMIN_profile_id_fkey" FOREIGN KEY (profile_id) REFERENCES public."PROFILE"(profile_id) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;
 I   ALTER TABLE ONLY public."ADMIN" DROP CONSTRAINT "ADMIN_profile_id_fkey";
       public          root    false    260    256    3411            r           2606    34724 "   BELONG_TO BELONG_TO_sensor_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."BELONG_TO"
    ADD CONSTRAINT "BELONG_TO_sensor_id_fkey" FOREIGN KEY (sensor_id) REFERENCES public."SENSOR"(sensor_id) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;
 P   ALTER TABLE ONLY public."BELONG_TO" DROP CONSTRAINT "BELONG_TO_sensor_id_fkey";
       public          root    false    3427    266    268            s           2606    34719 "   BELONG_TO BELONG_TO_widget_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."BELONG_TO"
    ADD CONSTRAINT "BELONG_TO_widget_id_fkey" FOREIGN KEY (widget_id) REFERENCES public."WIDGET"(widget_id) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;
 P   ALTER TABLE ONLY public."BELONG_TO" DROP CONSTRAINT "BELONG_TO_widget_id_fkey";
       public          root    false    265    3423    266            p           2606    34729    BOARD BOARD_profile_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."BOARD"
    ADD CONSTRAINT "BOARD_profile_id_fkey" FOREIGN KEY (profile_id) REFERENCES public."CUSTOMER"(profile_id) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;
 I   ALTER TABLE ONLY public."BOARD" DROP CONSTRAINT "BOARD_profile_id_fkey";
       public          root    false    3419    263    261            o           2606    34734 !   CUSTOMER CUSTOMER_profile_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."CUSTOMER"
    ADD CONSTRAINT "CUSTOMER_profile_id_fkey" FOREIGN KEY (profile_id) REFERENCES public."PROFILE"(profile_id) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;
 O   ALTER TABLE ONLY public."CUSTOMER" DROP CONSTRAINT "CUSTOMER_profile_id_fkey";
       public          root    false    261    3411    256            w           2606    34739 )   ENDDEV_PAYLOAD ENDDEV_PAYLOAD_dev_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."ENDDEV_PAYLOAD"
    ADD CONSTRAINT "ENDDEV_PAYLOAD_dev_id_fkey" FOREIGN KEY (dev_id) REFERENCES public."ENDDEV"(dev_id) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;
 W   ALTER TABLE ONLY public."ENDDEV_PAYLOAD" DROP CONSTRAINT "ENDDEV_PAYLOAD_dev_id_fkey";
       public          root    false    273    3413    258            u           2606    34744     HAS_UNIT HAS_UNIT_sensor_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."HAS_UNIT"
    ADD CONSTRAINT "HAS_UNIT_sensor_id_fkey" FOREIGN KEY (sensor_id) REFERENCES public."SENSOR"(sensor_id) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;
 N   ALTER TABLE ONLY public."HAS_UNIT" DROP CONSTRAINT "HAS_UNIT_sensor_id_fkey";
       public          root    false    269    3427    268            v           2606    34749    HAS_UNIT HAS_UNIT_unit_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."HAS_UNIT"
    ADD CONSTRAINT "HAS_UNIT_unit_id_fkey" FOREIGN KEY (unit_id) REFERENCES public."UNIT"(unit_id) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;
 L   ALTER TABLE ONLY public."HAS_UNIT" DROP CONSTRAINT "HAS_UNIT_unit_id_fkey";
       public          root    false    3431    271    269            l           2606    34759    NOTIFY NOTIFY_noti_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."NOTIFY"
    ADD CONSTRAINT "NOTIFY_noti_id_fkey" FOREIGN KEY (noti_id) REFERENCES public."NOTIFICATION"(noti_id) NOT VALID;
 H   ALTER TABLE ONLY public."NOTIFY" DROP CONSTRAINT "NOTIFY_noti_id_fkey";
       public          root    false    254    3409    259            m           2606    34754    NOTIFY NOTIFY_profile_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."NOTIFY"
    ADD CONSTRAINT "NOTIFY_profile_id_fkey" FOREIGN KEY (profile_id) REFERENCES public."PROFILE"(profile_id) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;
 K   ALTER TABLE ONLY public."NOTIFY" DROP CONSTRAINT "NOTIFY_profile_id_fkey";
       public          root    false    259    3411    256            x           2606    34769    OWN OWN_dev_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."OWN"
    ADD CONSTRAINT "OWN_dev_id_fkey" FOREIGN KEY (dev_id) REFERENCES public."ENDDEV"(dev_id) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;
 A   ALTER TABLE ONLY public."OWN" DROP CONSTRAINT "OWN_dev_id_fkey";
       public          root    false    274    258    3413            y           2606    34764    OWN OWN_profile_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."OWN"
    ADD CONSTRAINT "OWN_profile_id_fkey" FOREIGN KEY (profile_id) REFERENCES public."CUSTOMER"(profile_id) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;
 E   ALTER TABLE ONLY public."OWN" DROP CONSTRAINT "OWN_profile_id_fkey";
       public          root    false    261    3419    274            t           2606    34774    SENSOR SENSOR_dev_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."SENSOR"
    ADD CONSTRAINT "SENSOR_dev_id_fkey" FOREIGN KEY (dev_id) REFERENCES public."ENDDEV"(dev_id) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;
 G   ALTER TABLE ONLY public."SENSOR" DROP CONSTRAINT "SENSOR_dev_id_fkey";
       public          root    false    3413    258    268            q           2606    34641    WIDGET WIDGET_board_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."WIDGET"
    ADD CONSTRAINT "WIDGET_board_id_fkey" FOREIGN KEY (board_id) REFERENCES public."BOARD"(board_id) ON UPDATE CASCADE ON DELETE CASCADE;
 I   ALTER TABLE ONLY public."WIDGET" DROP CONSTRAINT "WIDGET_board_id_fkey";
       public          root    false    263    3421    265            �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �   B   x�K�(�/*IM�/-�L�L23�4022�M404�5I2KԵ4�H�5O�L47I�0M10�,����� +�      �      x������ � �      �      x������ � �      �      x������ � �      
      x������ � �            x������ � �            x������ � �            x������ � �            x������ � �            x������ � �            x������ � �            x������ � �      	      x������ � �            x������ � �            x������ � �            x������ � �            x������ � �            x������ � �     