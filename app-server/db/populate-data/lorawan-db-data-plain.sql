--
-- PostgreSQL database dump
--

-- Dumped from database version 12.9
-- Dumped by pg_dump version 12.9

-- Started on 2021-12-28 14:22:52 UTC

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 3302 (class 0 OID 17455)
-- Dependencies: 242
-- Data for Name: cache_inval_bgw_job; Type: TABLE DATA; Schema: _timescaledb_cache; Owner: -
--

COPY _timescaledb_cache.cache_inval_bgw_job  FROM stdin;
\.


--
-- TOC entry 3301 (class 0 OID 17458)
-- Dependencies: 243
-- Data for Name: cache_inval_extension; Type: TABLE DATA; Schema: _timescaledb_cache; Owner: -
--

COPY _timescaledb_cache.cache_inval_extension  FROM stdin;
\.


--
-- TOC entry 3300 (class 0 OID 17452)
-- Dependencies: 241
-- Data for Name: cache_inval_hypertable; Type: TABLE DATA; Schema: _timescaledb_cache; Owner: -
--

COPY _timescaledb_cache.cache_inval_hypertable  FROM stdin;
\.


--
-- TOC entry 3277 (class 0 OID 16990)
-- Dependencies: 210
-- Data for Name: hypertable; Type: TABLE DATA; Schema: _timescaledb_catalog; Owner: -
--

COPY _timescaledb_catalog.hypertable (id, schema_name, table_name, associated_schema_name, associated_table_prefix, num_dimensions, chunk_sizing_func_schema, chunk_sizing_func_name, chunk_target_size, compression_state, compressed_hypertable_id, replication_factor) FROM stdin;
\.


--
-- TOC entry 3284 (class 0 OID 17076)
-- Dependencies: 219
-- Data for Name: chunk; Type: TABLE DATA; Schema: _timescaledb_catalog; Owner: -
--

COPY _timescaledb_catalog.chunk (id, hypertable_id, schema_name, table_name, compressed_chunk_id, dropped, status) FROM stdin;
\.


--
-- TOC entry 3280 (class 0 OID 17041)
-- Dependencies: 215
-- Data for Name: dimension; Type: TABLE DATA; Schema: _timescaledb_catalog; Owner: -
--

COPY _timescaledb_catalog.dimension (id, hypertable_id, column_name, column_type, aligned, num_slices, partitioning_func_schema, partitioning_func, interval_length, integer_now_func_schema, integer_now_func) FROM stdin;
\.


--
-- TOC entry 3282 (class 0 OID 17060)
-- Dependencies: 217
-- Data for Name: dimension_slice; Type: TABLE DATA; Schema: _timescaledb_catalog; Owner: -
--

COPY _timescaledb_catalog.dimension_slice (id, dimension_id, range_start, range_end) FROM stdin;
\.


--
-- TOC entry 3286 (class 0 OID 17098)
-- Dependencies: 220
-- Data for Name: chunk_constraint; Type: TABLE DATA; Schema: _timescaledb_catalog; Owner: -
--

COPY _timescaledb_catalog.chunk_constraint (chunk_id, dimension_slice_id, constraint_name, hypertable_constraint_name) FROM stdin;
\.


--
-- TOC entry 3289 (class 0 OID 17132)
-- Dependencies: 223
-- Data for Name: chunk_data_node; Type: TABLE DATA; Schema: _timescaledb_catalog; Owner: -
--

COPY _timescaledb_catalog.chunk_data_node (chunk_id, node_chunk_id, node_name) FROM stdin;
\.


--
-- TOC entry 3288 (class 0 OID 17116)
-- Dependencies: 222
-- Data for Name: chunk_index; Type: TABLE DATA; Schema: _timescaledb_catalog; Owner: -
--

COPY _timescaledb_catalog.chunk_index (chunk_id, index_name, hypertable_id, hypertable_index_name) FROM stdin;
\.


--
-- TOC entry 3298 (class 0 OID 17268)
-- Dependencies: 235
-- Data for Name: compression_chunk_size; Type: TABLE DATA; Schema: _timescaledb_catalog; Owner: -
--

COPY _timescaledb_catalog.compression_chunk_size (chunk_id, compressed_chunk_id, uncompressed_heap_size, uncompressed_toast_size, uncompressed_index_size, compressed_heap_size, compressed_toast_size, compressed_index_size, numrows_pre_compression, numrows_post_compression) FROM stdin;
\.


--
-- TOC entry 3293 (class 0 OID 17197)
-- Dependencies: 229
-- Data for Name: continuous_agg; Type: TABLE DATA; Schema: _timescaledb_catalog; Owner: -
--

COPY _timescaledb_catalog.continuous_agg (mat_hypertable_id, raw_hypertable_id, user_view_schema, user_view_name, partial_view_schema, partial_view_name, bucket_width, direct_view_schema, direct_view_name, materialized_only) FROM stdin;
\.


--
-- TOC entry 3295 (class 0 OID 17228)
-- Dependencies: 231
-- Data for Name: continuous_aggs_hypertable_invalidation_log; Type: TABLE DATA; Schema: _timescaledb_catalog; Owner: -
--

COPY _timescaledb_catalog.continuous_aggs_hypertable_invalidation_log (hypertable_id, lowest_modified_value, greatest_modified_value) FROM stdin;
\.


--
-- TOC entry 3294 (class 0 OID 17218)
-- Dependencies: 230
-- Data for Name: continuous_aggs_invalidation_threshold; Type: TABLE DATA; Schema: _timescaledb_catalog; Owner: -
--

COPY _timescaledb_catalog.continuous_aggs_invalidation_threshold (hypertable_id, watermark) FROM stdin;
\.


--
-- TOC entry 3296 (class 0 OID 17232)
-- Dependencies: 232
-- Data for Name: continuous_aggs_materialization_invalidation_log; Type: TABLE DATA; Schema: _timescaledb_catalog; Owner: -
--

COPY _timescaledb_catalog.continuous_aggs_materialization_invalidation_log (materialization_id, lowest_modified_value, greatest_modified_value) FROM stdin;
\.


--
-- TOC entry 3297 (class 0 OID 17249)
-- Dependencies: 234
-- Data for Name: hypertable_compression; Type: TABLE DATA; Schema: _timescaledb_catalog; Owner: -
--

COPY _timescaledb_catalog.hypertable_compression (hypertable_id, attname, compression_algorithm_id, segmentby_column_index, orderby_column_index, orderby_asc, orderby_nullsfirst) FROM stdin;
\.


--
-- TOC entry 3278 (class 0 OID 17012)
-- Dependencies: 211
-- Data for Name: hypertable_data_node; Type: TABLE DATA; Schema: _timescaledb_catalog; Owner: -
--

COPY _timescaledb_catalog.hypertable_data_node (hypertable_id, node_hypertable_id, node_name, block_chunks) FROM stdin;
\.


--
-- TOC entry 3292 (class 0 OID 17189)
-- Dependencies: 228
-- Data for Name: metadata; Type: TABLE DATA; Schema: _timescaledb_catalog; Owner: -
--

COPY _timescaledb_catalog.metadata (key, value, include_in_telemetry) FROM stdin;
exported_uuid	24ed79bf-68b8-4f81-b5e0-4a038e4236aa	t
\.


--
-- TOC entry 3299 (class 0 OID 17283)
-- Dependencies: 236
-- Data for Name: remote_txn; Type: TABLE DATA; Schema: _timescaledb_catalog; Owner: -
--

COPY _timescaledb_catalog.remote_txn (data_node_name, remote_transaction_id) FROM stdin;
\.


--
-- TOC entry 3279 (class 0 OID 17026)
-- Dependencies: 213
-- Data for Name: tablespace; Type: TABLE DATA; Schema: _timescaledb_catalog; Owner: -
--

COPY _timescaledb_catalog.tablespace (id, hypertable_id, tablespace_name) FROM stdin;
\.


--
-- TOC entry 3291 (class 0 OID 17146)
-- Dependencies: 225
-- Data for Name: bgw_job; Type: TABLE DATA; Schema: _timescaledb_config; Owner: -
--

COPY _timescaledb_config.bgw_job (id, application_name, schedule_interval, max_runtime, max_retries, retry_period, proc_schema, proc_name, owner, scheduled, hypertable_id, config) FROM stdin;
\.


--
-- TOC entry 3588 (class 0 OID 18367)
-- Dependencies: 253
-- Data for Name: PROFILE; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public."PROFILE" (email, phone_number, password, type, _id, display_name) FROM stdin;
\.


--
-- TOC entry 3590 (class 0 OID 18386)
-- Dependencies: 255
-- Data for Name: ADMIN; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public."ADMIN" (profile_id, title) FROM stdin;
\.


--
-- TOC entry 3591 (class 0 OID 18394)
-- Dependencies: 256
-- Data for Name: CUSTOMER; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public."CUSTOMER" (profile_id) FROM stdin;
\.


--
-- TOC entry 3596 (class 0 OID 18420)
-- Dependencies: 261
-- Data for Name: BOARD; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public."BOARD" (_id, display_name, profile_id) FROM stdin;
\.


--
-- TOC entry 3601 (class 0 OID 18447)
-- Dependencies: 266
-- Data for Name: ENDDEV; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public."ENDDEV" (_id, display_name, dev_id, dev_addr, join_eui, dev_eui, dev_type, dev_brand, dev_model, dev_band) FROM stdin;
\.


--
-- TOC entry 3603 (class 0 OID 18458)
-- Dependencies: 268
-- Data for Name: SENSOR; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public."SENSOR" (enddev_id, _id, sensor_key) FROM stdin;
\.


--
-- TOC entry 3598 (class 0 OID 18431)
-- Dependencies: 263
-- Data for Name: WIDGET; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public."WIDGET" (_id, display_name, config_dict, board_id) FROM stdin;
\.


--
-- TOC entry 3599 (class 0 OID 18440)
-- Dependencies: 264
-- Data for Name: BELONG_TO; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public."BELONG_TO" (widget_id, sensor_id) FROM stdin;
\.


--
-- TOC entry 3608 (class 0 OID 18485)
-- Dependencies: 273
-- Data for Name: ENDDEV_PAYLOAD; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public."ENDDEV_PAYLOAD" (_id, recv_timestamp, payload_data, enddev_id) FROM stdin;
\.


--
-- TOC entry 3606 (class 0 OID 18474)
-- Dependencies: 271
-- Data for Name: UNIT; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public."UNIT" (_id, sensor_key, dev_type, uint) FROM stdin;
\.


--
-- TOC entry 3604 (class 0 OID 18467)
-- Dependencies: 269
-- Data for Name: HAS_UNIT; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public."HAS_UNIT" (sensor_id, unit_id) FROM stdin;
\.


--
-- TOC entry 3593 (class 0 OID 18404)
-- Dependencies: 258
-- Data for Name: NOTIFICATION; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public."NOTIFICATION" (_id, title, content, updated_timestamp) FROM stdin;
\.


--
-- TOC entry 3594 (class 0 OID 18413)
-- Dependencies: 259
-- Data for Name: NOTIFY; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public."NOTIFY" (profile_id, noti_id) FROM stdin;
\.


--
-- TOC entry 3609 (class 0 OID 18497)
-- Dependencies: 274
-- Data for Name: OWN; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public."OWN" (profile_id, enddev_id) FROM stdin;
\.


--
-- TOC entry 3615 (class 0 OID 0)
-- Dependencies: 221
-- Name: chunk_constraint_name; Type: SEQUENCE SET; Schema: _timescaledb_catalog; Owner: -
--

SELECT pg_catalog.setval('_timescaledb_catalog.chunk_constraint_name', 1, false);


--
-- TOC entry 3616 (class 0 OID 0)
-- Dependencies: 218
-- Name: chunk_id_seq; Type: SEQUENCE SET; Schema: _timescaledb_catalog; Owner: -
--

SELECT pg_catalog.setval('_timescaledb_catalog.chunk_id_seq', 1, false);


--
-- TOC entry 3617 (class 0 OID 0)
-- Dependencies: 214
-- Name: dimension_id_seq; Type: SEQUENCE SET; Schema: _timescaledb_catalog; Owner: -
--

SELECT pg_catalog.setval('_timescaledb_catalog.dimension_id_seq', 1, false);


--
-- TOC entry 3618 (class 0 OID 0)
-- Dependencies: 216
-- Name: dimension_slice_id_seq; Type: SEQUENCE SET; Schema: _timescaledb_catalog; Owner: -
--

SELECT pg_catalog.setval('_timescaledb_catalog.dimension_slice_id_seq', 1, false);


--
-- TOC entry 3619 (class 0 OID 0)
-- Dependencies: 209
-- Name: hypertable_id_seq; Type: SEQUENCE SET; Schema: _timescaledb_catalog; Owner: -
--

SELECT pg_catalog.setval('_timescaledb_catalog.hypertable_id_seq', 1, false);


--
-- TOC entry 3620 (class 0 OID 0)
-- Dependencies: 224
-- Name: bgw_job_id_seq; Type: SEQUENCE SET; Schema: _timescaledb_config; Owner: -
--

SELECT pg_catalog.setval('_timescaledb_config.bgw_job_id_seq', 1000, false);


--
-- TOC entry 3621 (class 0 OID 0)
-- Dependencies: 260
-- Name: BOARD__id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public."BOARD__id_seq"', 1, false);


--
-- TOC entry 3622 (class 0 OID 0)
-- Dependencies: 272
-- Name: ENDDEV_PAYLOAD__id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public."ENDDEV_PAYLOAD__id_seq"', 1, false);


--
-- TOC entry 3623 (class 0 OID 0)
-- Dependencies: 265
-- Name: ENDDEV__id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public."ENDDEV__id_seq"', 1, false);


--
-- TOC entry 3624 (class 0 OID 0)
-- Dependencies: 257
-- Name: NOTIFICATION__id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public."NOTIFICATION__id_seq"', 1, false);


--
-- TOC entry 3625 (class 0 OID 0)
-- Dependencies: 254
-- Name: PROFILE__id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public."PROFILE__id_seq"', 1, false);


--
-- TOC entry 3626 (class 0 OID 0)
-- Dependencies: 267
-- Name: SENSOR__id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public."SENSOR__id_seq"', 1, false);


--
-- TOC entry 3627 (class 0 OID 0)
-- Dependencies: 270
-- Name: UNIT__id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public."UNIT__id_seq"', 1, false);


--
-- TOC entry 3628 (class 0 OID 0)
-- Dependencies: 262
-- Name: WIDGET__id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public."WIDGET__id_seq"', 1, false);


-- Completed on 2021-12-28 14:22:52 UTC

--
-- PostgreSQL database dump complete
--

