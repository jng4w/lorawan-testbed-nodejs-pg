PGDMP     ;                      z         
   lorawan-db    12.9    12.9 6    �           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            �           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            �           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            �           1262    18164 
   lorawan-db    DATABASE     |   CREATE DATABASE "lorawan-db" WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'en_US.utf8' LC_CTYPE = 'en_US.utf8';
    DROP DATABASE "lorawan-db";
                root    false            s          0    17454    cache_inval_bgw_job 
   TABLE DATA           9   COPY _timescaledb_cache.cache_inval_bgw_job  FROM stdin;
    _timescaledb_cache          root    false    244   �3       r          0    17457    cache_inval_extension 
   TABLE DATA           ;   COPY _timescaledb_cache.cache_inval_extension  FROM stdin;
    _timescaledb_cache          root    false    245   4       q          0    17451    cache_inval_hypertable 
   TABLE DATA           <   COPY _timescaledb_cache.cache_inval_hypertable  FROM stdin;
    _timescaledb_cache          root    false    243   4       Z          0    16990 
   hypertable 
   TABLE DATA             COPY _timescaledb_catalog.hypertable (id, schema_name, table_name, associated_schema_name, associated_table_prefix, num_dimensions, chunk_sizing_func_schema, chunk_sizing_func_name, chunk_target_size, compression_state, compressed_hypertable_id, replication_factor) FROM stdin;
    _timescaledb_catalog          root    false    212   <4       a          0    17075    chunk 
   TABLE DATA              COPY _timescaledb_catalog.chunk (id, hypertable_id, schema_name, table_name, compressed_chunk_id, dropped, status) FROM stdin;
    _timescaledb_catalog          root    false    221   Y4       ]          0    17040 	   dimension 
   TABLE DATA           �   COPY _timescaledb_catalog.dimension (id, hypertable_id, column_name, column_type, aligned, num_slices, partitioning_func_schema, partitioning_func, interval_length, integer_now_func_schema, integer_now_func) FROM stdin;
    _timescaledb_catalog          root    false    217   v4       _          0    17059    dimension_slice 
   TABLE DATA           a   COPY _timescaledb_catalog.dimension_slice (id, dimension_id, range_start, range_end) FROM stdin;
    _timescaledb_catalog          root    false    219   �4       c          0    17097    chunk_constraint 
   TABLE DATA           �   COPY _timescaledb_catalog.chunk_constraint (chunk_id, dimension_slice_id, constraint_name, hypertable_constraint_name) FROM stdin;
    _timescaledb_catalog          root    false    222   �4       f          0    17131    chunk_data_node 
   TABLE DATA           [   COPY _timescaledb_catalog.chunk_data_node (chunk_id, node_chunk_id, node_name) FROM stdin;
    _timescaledb_catalog          root    false    225   �4       e          0    17115    chunk_index 
   TABLE DATA           o   COPY _timescaledb_catalog.chunk_index (chunk_id, index_name, hypertable_id, hypertable_index_name) FROM stdin;
    _timescaledb_catalog          root    false    224   �4       o          0    17267    compression_chunk_size 
   TABLE DATA             COPY _timescaledb_catalog.compression_chunk_size (chunk_id, compressed_chunk_id, uncompressed_heap_size, uncompressed_toast_size, uncompressed_index_size, compressed_heap_size, compressed_toast_size, compressed_index_size, numrows_pre_compression, numrows_post_compression) FROM stdin;
    _timescaledb_catalog          root    false    237   5       j          0    17196    continuous_agg 
   TABLE DATA           �   COPY _timescaledb_catalog.continuous_agg (mat_hypertable_id, raw_hypertable_id, user_view_schema, user_view_name, partial_view_schema, partial_view_name, bucket_width, direct_view_schema, direct_view_name, materialized_only) FROM stdin;
    _timescaledb_catalog          root    false    231   $5       l          0    17227 +   continuous_aggs_hypertable_invalidation_log 
   TABLE DATA           �   COPY _timescaledb_catalog.continuous_aggs_hypertable_invalidation_log (hypertable_id, lowest_modified_value, greatest_modified_value) FROM stdin;
    _timescaledb_catalog          root    false    233   A5       k          0    17217 &   continuous_aggs_invalidation_threshold 
   TABLE DATA           h   COPY _timescaledb_catalog.continuous_aggs_invalidation_threshold (hypertable_id, watermark) FROM stdin;
    _timescaledb_catalog          root    false    232   ^5       m          0    17231 0   continuous_aggs_materialization_invalidation_log 
   TABLE DATA           �   COPY _timescaledb_catalog.continuous_aggs_materialization_invalidation_log (materialization_id, lowest_modified_value, greatest_modified_value) FROM stdin;
    _timescaledb_catalog          root    false    234   {5       n          0    17248    hypertable_compression 
   TABLE DATA           �   COPY _timescaledb_catalog.hypertable_compression (hypertable_id, attname, compression_algorithm_id, segmentby_column_index, orderby_column_index, orderby_asc, orderby_nullsfirst) FROM stdin;
    _timescaledb_catalog          root    false    236   �5       [          0    17011    hypertable_data_node 
   TABLE DATA           x   COPY _timescaledb_catalog.hypertable_data_node (hypertable_id, node_hypertable_id, node_name, block_chunks) FROM stdin;
    _timescaledb_catalog          root    false    213   �5       i          0    17188    metadata 
   TABLE DATA           R   COPY _timescaledb_catalog.metadata (key, value, include_in_telemetry) FROM stdin;
    _timescaledb_catalog          root    false    230   �5       p          0    17282 
   remote_txn 
   TABLE DATA           Y   COPY _timescaledb_catalog.remote_txn (data_node_name, remote_transaction_id) FROM stdin;
    _timescaledb_catalog          root    false    238   $6       \          0    17025 
   tablespace 
   TABLE DATA           V   COPY _timescaledb_catalog.tablespace (id, hypertable_id, tablespace_name) FROM stdin;
    _timescaledb_catalog          root    false    215   A6       h          0    17145    bgw_job 
   TABLE DATA           �   COPY _timescaledb_config.bgw_job (id, application_name, schedule_interval, max_runtime, max_retries, retry_period, proc_schema, proc_name, owner, scheduled, hypertable_id, config) FROM stdin;
    _timescaledb_config          root    false    227   ^6       �          0    18260    PROFILE 
   TABLE DATA           [   COPY public."PROFILE" (password, type, _id, display_name, phone_number, email) FROM stdin;
    public          root    false    270   {6       �          0    18205    ADMIN 
   TABLE DATA           -   COPY public."ADMIN" (profile_id) FROM stdin;
    public          root    false    255   7       �          0    18219    CUSTOMER 
   TABLE DATA           0   COPY public."CUSTOMER" (profile_id) FROM stdin;
    public          root    false    259   $7       �          0    18211    BOARD 
   TABLE DATA           @   COPY public."BOARD" (_id, display_name, profile_id) FROM stdin;
    public          root    false    257   C7       �          0    18222    DEV_TYPE 
   TABLE DATA           D   COPY public."DEV_TYPE" (_id, dev_type, dev_type_config) FROM stdin;
    public          root    false    260   `7       �          0    18230    ENDDEV 
   TABLE DATA           �   COPY public."ENDDEV" (_id, display_name, dev_id, dev_addr, join_eui, dev_eui, dev_brand, dev_model, dev_band, dev_type_id) FROM stdin;
    public          root    false    262   �7       �          0    18268    SENSOR 
   TABLE DATA           >   COPY public."SENSOR" (enddev_id, _id, sensor_key) FROM stdin;
    public          root    false    272   �8       �          0    18282    WIDGET_TYPE 
   TABLE DATA           7   COPY public."WIDGET_TYPE" (_id, ui_config) FROM stdin;
    public          root    false    275   @9       �          0    18276    WIDGET 
   TABLE DATA           \   COPY public."WIDGET" (_id, display_name, config_dict, board_id, widget_type_id) FROM stdin;
    public          root    false    274   ]9       �          0    18208 	   BELONG_TO 
   TABLE DATA           ;   COPY public."BELONG_TO" (widget_id, sensor_id) FROM stdin;
    public          root    false    256   z9       �          0    18236    ENDDEV_PAYLOAD 
   TABLE DATA           X   COPY public."ENDDEV_PAYLOAD" (_id, recv_timestamp, payload_data, enddev_id) FROM stdin;
    public          root    false    263   �9       �          0    18246    NOTIFICATION 
   TABLE DATA           P   COPY public."NOTIFICATION" (_id, title, content, updated_timestamp) FROM stdin;
    public          root    false    266   �9       �          0    18254    NOTIFY 
   TABLE DATA           7   COPY public."NOTIFY" (profile_id, noti_id) FROM stdin;
    public          root    false    268   �9       �          0    18257    OWN 
   TABLE DATA           6   COPY public."OWN" (profile_id, enddev_id) FROM stdin;
    public          root    false    269   �9       �           0    0    chunk_constraint_name    SEQUENCE SET     R   SELECT pg_catalog.setval('_timescaledb_catalog.chunk_constraint_name', 1, false);
          _timescaledb_catalog          root    false    223            �           0    0    chunk_id_seq    SEQUENCE SET     I   SELECT pg_catalog.setval('_timescaledb_catalog.chunk_id_seq', 1, false);
          _timescaledb_catalog          root    false    220            �           0    0    dimension_id_seq    SEQUENCE SET     L   SELECT pg_catalog.setval('_timescaledb_catalog.dimension_id_seq', 5, true);
          _timescaledb_catalog          root    false    216            �           0    0    dimension_slice_id_seq    SEQUENCE SET     S   SELECT pg_catalog.setval('_timescaledb_catalog.dimension_slice_id_seq', 1, false);
          _timescaledb_catalog          root    false    218            �           0    0    hypertable_id_seq    SEQUENCE SET     M   SELECT pg_catalog.setval('_timescaledb_catalog.hypertable_id_seq', 5, true);
          _timescaledb_catalog          root    false    211            �           0    0    bgw_job_id_seq    SEQUENCE SET     M   SELECT pg_catalog.setval('_timescaledb_config.bgw_job_id_seq', 1000, false);
          _timescaledb_config          root    false    226            �           0    0    BOARD__id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public."BOARD__id_seq"', 1, false);
          public          root    false    258            �           0    0    DEVTYPE__id_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('public."DEVTYPE__id_seq"', 4, true);
          public          root    false    261            �           0    0    ENDDEV_PAYLOAD__id_seq    SEQUENCE SET     H   SELECT pg_catalog.setval('public."ENDDEV_PAYLOAD__id_seq"', 155, true);
          public          root    false    264            �           0    0    ENDDEV__id_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('public."ENDDEV__id_seq"', 28, true);
          public          root    false    265            �           0    0    NOTIFICATION__id_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public."NOTIFICATION__id_seq"', 1, false);
          public          root    false    267            �           0    0    PROFILE__id_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('public."PROFILE__id_seq"', 5, true);
          public          root    false    271            �           0    0    SENSOR__id_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('public."SENSOR__id_seq"', 53, true);
          public          root    false    273            �           0    0    WIDGET_TYPE__id_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('public."WIDGET_TYPE__id_seq"', 1, false);
          public          root    false    276            �           0    0    WIDGET__id_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('public."WIDGET__id_seq"', 1, false);
          public          root    false    277            s      x������ � �      r      x������ � �      q      x������ � �      Z      x������ � �      a      x������ � �      ]      x������ � �      _      x������ � �      c      x������ � �      f      x������ � �      e      x������ � �      o      x������ � �      j      x������ � �      l      x������ � �      k      x������ � �      m      x������ � �      n      x������ � �      [      x������ � �      i   B   x�K�(�/*IM�/-�L�4O100IN1�M�L3�5�47�M4�0�575O1JN364KK�,����� �      p      x������ � �      \      x������ � �      h      x������ � �      �   |   x�S1JT10S�6vK�,,�7*)4��0�LM5IM54t7����H��+��)u.-�0�q�,*�t��u�4�����4�4071�006����K�K/�L�34pH�M���K������� 
q"l      �      x������ � �      �      x�3����� v �      �      x������ � �      �   4   x�3��16���2���131�9�<�]�-@<N�`W��=... �
h      �   �   x�u��n� E��/��a�r,�ȶRE��Tj�|l�iI�Y^]��� ���ؤ��{gZ�&�z�b�]��g �<W��i<����ӱ��k@�P#ˉɴ�|���'��/�|�d���/�rfh�� ���6L?r�����ć��T}"^��XS@}��ƴ%��31k���ES`U�jl��@y���Vg"��Ź�SWG�$���Z� �φ�      �   �   x�U���0���c��G�&x��ń���H�!�����r��M'S�d2��_ň��������s�"�U�[+�t�GƶS���%�E|�T�}��l>��ܦ5�e��5'5`�\�)�.k����2vB.�W[��DM��^���4�y�m��� N7T�      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �     