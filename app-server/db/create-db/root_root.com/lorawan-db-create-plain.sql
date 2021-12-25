--
-- PostgreSQL database dump
--

-- Dumped from database version 12.8
-- Dumped by pg_dump version 12.9

-- Started on 2021-12-25 17:01:26 UTC

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
-- TOC entry 2 (class 3079 OID 16973)
-- Name: timescaledb; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS timescaledb WITH SCHEMA public;


--
-- TOC entry 3614 (class 0 OID 0)
-- Dependencies: 2
-- Name: EXTENSION timescaledb; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION timescaledb IS 'Enables scalable inserts and complex queries for time-series data';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 260 (class 1259 OID 34588)
-- Name: ADMIN; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public."ADMIN" (
    profile_id integer NOT NULL,
    title character varying NOT NULL
);


ALTER TABLE public."ADMIN" OWNER TO root;

--
-- TOC entry 266 (class 1259 OID 34656)
-- Name: BELONG_TO; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public."BELONG_TO" (
    widget_id integer NOT NULL,
    sensor_id integer NOT NULL
);


ALTER TABLE public."BELONG_TO" OWNER TO root;

--
-- TOC entry 263 (class 1259 OID 34616)
-- Name: BOARD; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public."BOARD" (
    board_id integer NOT NULL,
    display_name character varying NOT NULL,
    profile_id integer NOT NULL
);


ALTER TABLE public."BOARD" OWNER TO root;

--
-- TOC entry 262 (class 1259 OID 34614)
-- Name: BOARD_board_id_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE public."BOARD_board_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."BOARD_board_id_seq" OWNER TO root;

--
-- TOC entry 3615 (class 0 OID 0)
-- Dependencies: 262
-- Name: BOARD_board_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE public."BOARD_board_id_seq" OWNED BY public."BOARD".board_id;


--
-- TOC entry 261 (class 1259 OID 34601)
-- Name: CUSTOMER; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public."CUSTOMER" (
    profile_id integer NOT NULL,
    display_name character varying NOT NULL
);


ALTER TABLE public."CUSTOMER" OWNER TO root;

--
-- TOC entry 258 (class 1259 OID 34559)
-- Name: ENDDEV; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public."ENDDEV" (
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


ALTER TABLE public."ENDDEV" OWNER TO root;

--
-- TOC entry 273 (class 1259 OID 34690)
-- Name: ENDDEV_PAYLOAD; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public."ENDDEV_PAYLOAD" (
    payload_id integer NOT NULL,
    "timestamp" time without time zone NOT NULL,
    payload_data jsonb NOT NULL,
    dev_id integer NOT NULL
);


ALTER TABLE public."ENDDEV_PAYLOAD" OWNER TO root;

--
-- TOC entry 272 (class 1259 OID 34688)
-- Name: ENDDEV_PAYLOAD_payload_id_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE public."ENDDEV_PAYLOAD_payload_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."ENDDEV_PAYLOAD_payload_id_seq" OWNER TO root;

--
-- TOC entry 3616 (class 0 OID 0)
-- Dependencies: 272
-- Name: ENDDEV_PAYLOAD_payload_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE public."ENDDEV_PAYLOAD_payload_id_seq" OWNED BY public."ENDDEV_PAYLOAD".payload_id;


--
-- TOC entry 257 (class 1259 OID 34557)
-- Name: ENDDEV_dev_id_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE public."ENDDEV_dev_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."ENDDEV_dev_id_seq" OWNER TO root;

--
-- TOC entry 3617 (class 0 OID 0)
-- Dependencies: 257
-- Name: ENDDEV_dev_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE public."ENDDEV_dev_id_seq" OWNED BY public."ENDDEV".dev_id;


--
-- TOC entry 269 (class 1259 OID 34672)
-- Name: HAS_UNIT; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public."HAS_UNIT" (
    sensor_id integer NOT NULL,
    unit_id integer NOT NULL
);


ALTER TABLE public."HAS_UNIT" OWNER TO root;

--
-- TOC entry 254 (class 1259 OID 34537)
-- Name: NOTIFICATION; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public."NOTIFICATION" (
    noti_id integer NOT NULL,
    title character varying NOT NULL,
    content character varying NOT NULL,
    updated_time time without time zone NOT NULL
);


ALTER TABLE public."NOTIFICATION" OWNER TO root;

--
-- TOC entry 259 (class 1259 OID 34573)
-- Name: NOTIFY; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public."NOTIFY" (
    profile_id integer NOT NULL,
    noti_id integer NOT NULL
);


ALTER TABLE public."NOTIFY" OWNER TO root;

--
-- TOC entry 274 (class 1259 OID 34699)
-- Name: OWN; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public."OWN" (
    profile_id integer NOT NULL,
    dev_id integer NOT NULL
);


ALTER TABLE public."OWN" OWNER TO root;

--
-- TOC entry 256 (class 1259 OID 34548)
-- Name: PROFILE; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public."PROFILE" (
    profile_id integer NOT NULL,
    phone_number character varying,
    email character varying,
    password character varying NOT NULL,
    type character varying NOT NULL
);


ALTER TABLE public."PROFILE" OWNER TO root;

--
-- TOC entry 255 (class 1259 OID 34546)
-- Name: PROFILE_profile_id_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE public."PROFILE_profile_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."PROFILE_profile_id_seq" OWNER TO root;

--
-- TOC entry 3618 (class 0 OID 0)
-- Dependencies: 255
-- Name: PROFILE_profile_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE public."PROFILE_profile_id_seq" OWNED BY public."PROFILE".profile_id;


--
-- TOC entry 268 (class 1259 OID 34663)
-- Name: SENSOR; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public."SENSOR" (
    dev_id integer NOT NULL,
    sensor_id integer NOT NULL,
    sensor_key character varying NOT NULL
);


ALTER TABLE public."SENSOR" OWNER TO root;

--
-- TOC entry 267 (class 1259 OID 34661)
-- Name: SENSOR_sensor_id_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE public."SENSOR_sensor_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."SENSOR_sensor_id_seq" OWNER TO root;

--
-- TOC entry 3619 (class 0 OID 0)
-- Dependencies: 267
-- Name: SENSOR_sensor_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE public."SENSOR_sensor_id_seq" OWNED BY public."SENSOR".sensor_id;


--
-- TOC entry 271 (class 1259 OID 34679)
-- Name: UNIT; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public."UNIT" (
    unit_id integer NOT NULL,
    sensor_key character varying NOT NULL,
    dev_type character varying NOT NULL,
    unit character varying NOT NULL
);


ALTER TABLE public."UNIT" OWNER TO root;

--
-- TOC entry 270 (class 1259 OID 34677)
-- Name: UNIT_unit_id_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE public."UNIT_unit_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."UNIT_unit_id_seq" OWNER TO root;

--
-- TOC entry 3620 (class 0 OID 0)
-- Dependencies: 270
-- Name: UNIT_unit_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE public."UNIT_unit_id_seq" OWNED BY public."UNIT".unit_id;


--
-- TOC entry 265 (class 1259 OID 34632)
-- Name: WIDGET; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public."WIDGET" (
    widget_id integer NOT NULL,
    display_name character varying NOT NULL,
    config_dict jsonb NOT NULL,
    board_id integer NOT NULL
);


ALTER TABLE public."WIDGET" OWNER TO root;

--
-- TOC entry 264 (class 1259 OID 34630)
-- Name: WIDGET_widget_id_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE public."WIDGET_widget_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."WIDGET_widget_id_seq" OWNER TO root;

--
-- TOC entry 3621 (class 0 OID 0)
-- Dependencies: 264
-- Name: WIDGET_widget_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE public."WIDGET_widget_id_seq" OWNED BY public."WIDGET".widget_id;


--
-- TOC entry 253 (class 1259 OID 34535)
-- Name: notification_noti_id_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE public.notification_noti_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.notification_noti_id_seq OWNER TO root;

--
-- TOC entry 3622 (class 0 OID 0)
-- Dependencies: 253
-- Name: notification_noti_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE public.notification_noti_id_seq OWNED BY public."NOTIFICATION".noti_id;


--
-- TOC entry 3330 (class 2604 OID 34619)
-- Name: BOARD board_id; Type: DEFAULT; Schema: public; Owner: root
--

ALTER TABLE ONLY public."BOARD" ALTER COLUMN board_id SET DEFAULT nextval('public."BOARD_board_id_seq"'::regclass);


--
-- TOC entry 3329 (class 2604 OID 34562)
-- Name: ENDDEV dev_id; Type: DEFAULT; Schema: public; Owner: root
--

ALTER TABLE ONLY public."ENDDEV" ALTER COLUMN dev_id SET DEFAULT nextval('public."ENDDEV_dev_id_seq"'::regclass);


--
-- TOC entry 3334 (class 2604 OID 34693)
-- Name: ENDDEV_PAYLOAD payload_id; Type: DEFAULT; Schema: public; Owner: root
--

ALTER TABLE ONLY public."ENDDEV_PAYLOAD" ALTER COLUMN payload_id SET DEFAULT nextval('public."ENDDEV_PAYLOAD_payload_id_seq"'::regclass);


--
-- TOC entry 3327 (class 2604 OID 34540)
-- Name: NOTIFICATION noti_id; Type: DEFAULT; Schema: public; Owner: root
--

ALTER TABLE ONLY public."NOTIFICATION" ALTER COLUMN noti_id SET DEFAULT nextval('public.notification_noti_id_seq'::regclass);


--
-- TOC entry 3328 (class 2604 OID 34551)
-- Name: PROFILE profile_id; Type: DEFAULT; Schema: public; Owner: root
--

ALTER TABLE ONLY public."PROFILE" ALTER COLUMN profile_id SET DEFAULT nextval('public."PROFILE_profile_id_seq"'::regclass);


--
-- TOC entry 3332 (class 2604 OID 34666)
-- Name: SENSOR sensor_id; Type: DEFAULT; Schema: public; Owner: root
--

ALTER TABLE ONLY public."SENSOR" ALTER COLUMN sensor_id SET DEFAULT nextval('public."SENSOR_sensor_id_seq"'::regclass);


--
-- TOC entry 3333 (class 2604 OID 34682)
-- Name: UNIT unit_id; Type: DEFAULT; Schema: public; Owner: root
--

ALTER TABLE ONLY public."UNIT" ALTER COLUMN unit_id SET DEFAULT nextval('public."UNIT_unit_id_seq"'::regclass);


--
-- TOC entry 3331 (class 2604 OID 34635)
-- Name: WIDGET widget_id; Type: DEFAULT; Schema: public; Owner: root
--

ALTER TABLE ONLY public."WIDGET" ALTER COLUMN widget_id SET DEFAULT nextval('public."WIDGET_widget_id_seq"'::regclass);


--
-- TOC entry 3301 (class 0 OID 17456)
-- Dependencies: 242
-- Data for Name: cache_inval_bgw_job; Type: TABLE DATA; Schema: _timescaledb_cache; Owner: root
--

COPY _timescaledb_cache.cache_inval_bgw_job  FROM stdin;
\.


--
-- TOC entry 3300 (class 0 OID 17459)
-- Dependencies: 243
-- Data for Name: cache_inval_extension; Type: TABLE DATA; Schema: _timescaledb_cache; Owner: root
--

COPY _timescaledb_cache.cache_inval_extension  FROM stdin;
\.


--
-- TOC entry 3299 (class 0 OID 17453)
-- Dependencies: 241
-- Data for Name: cache_inval_hypertable; Type: TABLE DATA; Schema: _timescaledb_cache; Owner: root
--

COPY _timescaledb_cache.cache_inval_hypertable  FROM stdin;
\.


--
-- TOC entry 3276 (class 0 OID 16991)
-- Dependencies: 210
-- Data for Name: hypertable; Type: TABLE DATA; Schema: _timescaledb_catalog; Owner: root
--

COPY _timescaledb_catalog.hypertable (id, schema_name, table_name, associated_schema_name, associated_table_prefix, num_dimensions, chunk_sizing_func_schema, chunk_sizing_func_name, chunk_target_size, compression_state, compressed_hypertable_id, replication_factor) FROM stdin;
\.


--
-- TOC entry 3283 (class 0 OID 17077)
-- Dependencies: 219
-- Data for Name: chunk; Type: TABLE DATA; Schema: _timescaledb_catalog; Owner: root
--

COPY _timescaledb_catalog.chunk (id, hypertable_id, schema_name, table_name, compressed_chunk_id, dropped, status) FROM stdin;
\.


--
-- TOC entry 3279 (class 0 OID 17042)
-- Dependencies: 215
-- Data for Name: dimension; Type: TABLE DATA; Schema: _timescaledb_catalog; Owner: root
--

COPY _timescaledb_catalog.dimension (id, hypertable_id, column_name, column_type, aligned, num_slices, partitioning_func_schema, partitioning_func, interval_length, integer_now_func_schema, integer_now_func) FROM stdin;
\.


--
-- TOC entry 3281 (class 0 OID 17061)
-- Dependencies: 217
-- Data for Name: dimension_slice; Type: TABLE DATA; Schema: _timescaledb_catalog; Owner: root
--

COPY _timescaledb_catalog.dimension_slice (id, dimension_id, range_start, range_end) FROM stdin;
\.


--
-- TOC entry 3285 (class 0 OID 17099)
-- Dependencies: 220
-- Data for Name: chunk_constraint; Type: TABLE DATA; Schema: _timescaledb_catalog; Owner: root
--

COPY _timescaledb_catalog.chunk_constraint (chunk_id, dimension_slice_id, constraint_name, hypertable_constraint_name) FROM stdin;
\.


--
-- TOC entry 3288 (class 0 OID 17133)
-- Dependencies: 223
-- Data for Name: chunk_data_node; Type: TABLE DATA; Schema: _timescaledb_catalog; Owner: root
--

COPY _timescaledb_catalog.chunk_data_node (chunk_id, node_chunk_id, node_name) FROM stdin;
\.


--
-- TOC entry 3287 (class 0 OID 17117)
-- Dependencies: 222
-- Data for Name: chunk_index; Type: TABLE DATA; Schema: _timescaledb_catalog; Owner: root
--

COPY _timescaledb_catalog.chunk_index (chunk_id, index_name, hypertable_id, hypertable_index_name) FROM stdin;
\.


--
-- TOC entry 3297 (class 0 OID 17269)
-- Dependencies: 235
-- Data for Name: compression_chunk_size; Type: TABLE DATA; Schema: _timescaledb_catalog; Owner: root
--

COPY _timescaledb_catalog.compression_chunk_size (chunk_id, compressed_chunk_id, uncompressed_heap_size, uncompressed_toast_size, uncompressed_index_size, compressed_heap_size, compressed_toast_size, compressed_index_size, numrows_pre_compression, numrows_post_compression) FROM stdin;
\.


--
-- TOC entry 3292 (class 0 OID 17198)
-- Dependencies: 229
-- Data for Name: continuous_agg; Type: TABLE DATA; Schema: _timescaledb_catalog; Owner: root
--

COPY _timescaledb_catalog.continuous_agg (mat_hypertable_id, raw_hypertable_id, user_view_schema, user_view_name, partial_view_schema, partial_view_name, bucket_width, direct_view_schema, direct_view_name, materialized_only) FROM stdin;
\.


--
-- TOC entry 3294 (class 0 OID 17229)
-- Dependencies: 231
-- Data for Name: continuous_aggs_hypertable_invalidation_log; Type: TABLE DATA; Schema: _timescaledb_catalog; Owner: root
--

COPY _timescaledb_catalog.continuous_aggs_hypertable_invalidation_log (hypertable_id, lowest_modified_value, greatest_modified_value) FROM stdin;
\.


--
-- TOC entry 3293 (class 0 OID 17219)
-- Dependencies: 230
-- Data for Name: continuous_aggs_invalidation_threshold; Type: TABLE DATA; Schema: _timescaledb_catalog; Owner: root
--

COPY _timescaledb_catalog.continuous_aggs_invalidation_threshold (hypertable_id, watermark) FROM stdin;
\.


--
-- TOC entry 3295 (class 0 OID 17233)
-- Dependencies: 232
-- Data for Name: continuous_aggs_materialization_invalidation_log; Type: TABLE DATA; Schema: _timescaledb_catalog; Owner: root
--

COPY _timescaledb_catalog.continuous_aggs_materialization_invalidation_log (materialization_id, lowest_modified_value, greatest_modified_value) FROM stdin;
\.


--
-- TOC entry 3296 (class 0 OID 17250)
-- Dependencies: 234
-- Data for Name: hypertable_compression; Type: TABLE DATA; Schema: _timescaledb_catalog; Owner: root
--

COPY _timescaledb_catalog.hypertable_compression (hypertable_id, attname, compression_algorithm_id, segmentby_column_index, orderby_column_index, orderby_asc, orderby_nullsfirst) FROM stdin;
\.


--
-- TOC entry 3277 (class 0 OID 17012)
-- Dependencies: 211
-- Data for Name: hypertable_data_node; Type: TABLE DATA; Schema: _timescaledb_catalog; Owner: root
--

COPY _timescaledb_catalog.hypertable_data_node (hypertable_id, node_hypertable_id, node_name, block_chunks) FROM stdin;
\.


--
-- TOC entry 3291 (class 0 OID 17190)
-- Dependencies: 228
-- Data for Name: metadata; Type: TABLE DATA; Schema: _timescaledb_catalog; Owner: root
--

COPY _timescaledb_catalog.metadata (key, value, include_in_telemetry) FROM stdin;
exported_uuid	b6690225-a012-4b6a-978c-7c9a74c85d03	t
\.


--
-- TOC entry 3298 (class 0 OID 17284)
-- Dependencies: 236
-- Data for Name: remote_txn; Type: TABLE DATA; Schema: _timescaledb_catalog; Owner: root
--

COPY _timescaledb_catalog.remote_txn (data_node_name, remote_transaction_id) FROM stdin;
\.


--
-- TOC entry 3278 (class 0 OID 17026)
-- Dependencies: 213
-- Data for Name: tablespace; Type: TABLE DATA; Schema: _timescaledb_catalog; Owner: root
--

COPY _timescaledb_catalog.tablespace (id, hypertable_id, tablespace_name) FROM stdin;
\.


--
-- TOC entry 3290 (class 0 OID 17147)
-- Dependencies: 225
-- Data for Name: bgw_job; Type: TABLE DATA; Schema: _timescaledb_config; Owner: root
--

COPY _timescaledb_config.bgw_job (id, application_name, schedule_interval, max_runtime, max_retries, retry_period, proc_schema, proc_name, owner, scheduled, hypertable_id, config) FROM stdin;
\.


--
-- TOC entry 3594 (class 0 OID 34588)
-- Dependencies: 260
-- Data for Name: ADMIN; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public."ADMIN" (profile_id, title) FROM stdin;
\.


--
-- TOC entry 3600 (class 0 OID 34656)
-- Dependencies: 266
-- Data for Name: BELONG_TO; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public."BELONG_TO" (widget_id, sensor_id) FROM stdin;
\.


--
-- TOC entry 3597 (class 0 OID 34616)
-- Dependencies: 263
-- Data for Name: BOARD; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public."BOARD" (board_id, display_name, profile_id) FROM stdin;
\.


--
-- TOC entry 3595 (class 0 OID 34601)
-- Dependencies: 261
-- Data for Name: CUSTOMER; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public."CUSTOMER" (profile_id, display_name) FROM stdin;
\.


--
-- TOC entry 3592 (class 0 OID 34559)
-- Dependencies: 258
-- Data for Name: ENDDEV; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public."ENDDEV" (dev_id, display_name, dev_addr, join_eui, dev_eui, dev_type, dev_brand, dev_model, dev_band) FROM stdin;
\.


--
-- TOC entry 3607 (class 0 OID 34690)
-- Dependencies: 273
-- Data for Name: ENDDEV_PAYLOAD; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public."ENDDEV_PAYLOAD" (payload_id, "timestamp", payload_data, dev_id) FROM stdin;
\.


--
-- TOC entry 3603 (class 0 OID 34672)
-- Dependencies: 269
-- Data for Name: HAS_UNIT; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public."HAS_UNIT" (sensor_id, unit_id) FROM stdin;
\.


--
-- TOC entry 3588 (class 0 OID 34537)
-- Dependencies: 254
-- Data for Name: NOTIFICATION; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public."NOTIFICATION" (noti_id, title, content, updated_time) FROM stdin;
\.


--
-- TOC entry 3593 (class 0 OID 34573)
-- Dependencies: 259
-- Data for Name: NOTIFY; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public."NOTIFY" (profile_id, noti_id) FROM stdin;
\.


--
-- TOC entry 3608 (class 0 OID 34699)
-- Dependencies: 274
-- Data for Name: OWN; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public."OWN" (profile_id, dev_id) FROM stdin;
\.


--
-- TOC entry 3590 (class 0 OID 34548)
-- Dependencies: 256
-- Data for Name: PROFILE; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public."PROFILE" (profile_id, phone_number, email, password, type) FROM stdin;
\.


--
-- TOC entry 3602 (class 0 OID 34663)
-- Dependencies: 268
-- Data for Name: SENSOR; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public."SENSOR" (dev_id, sensor_id, sensor_key) FROM stdin;
\.


--
-- TOC entry 3605 (class 0 OID 34679)
-- Dependencies: 271
-- Data for Name: UNIT; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public."UNIT" (unit_id, sensor_key, dev_type, unit) FROM stdin;
\.


--
-- TOC entry 3599 (class 0 OID 34632)
-- Dependencies: 265
-- Data for Name: WIDGET; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public."WIDGET" (widget_id, display_name, config_dict, board_id) FROM stdin;
\.


--
-- TOC entry 3623 (class 0 OID 0)
-- Dependencies: 221
-- Name: chunk_constraint_name; Type: SEQUENCE SET; Schema: _timescaledb_catalog; Owner: root
--

SELECT pg_catalog.setval('_timescaledb_catalog.chunk_constraint_name', 1, false);


--
-- TOC entry 3624 (class 0 OID 0)
-- Dependencies: 218
-- Name: chunk_id_seq; Type: SEQUENCE SET; Schema: _timescaledb_catalog; Owner: root
--

SELECT pg_catalog.setval('_timescaledb_catalog.chunk_id_seq', 1, false);


--
-- TOC entry 3625 (class 0 OID 0)
-- Dependencies: 214
-- Name: dimension_id_seq; Type: SEQUENCE SET; Schema: _timescaledb_catalog; Owner: root
--

SELECT pg_catalog.setval('_timescaledb_catalog.dimension_id_seq', 1, false);


--
-- TOC entry 3626 (class 0 OID 0)
-- Dependencies: 216
-- Name: dimension_slice_id_seq; Type: SEQUENCE SET; Schema: _timescaledb_catalog; Owner: root
--

SELECT pg_catalog.setval('_timescaledb_catalog.dimension_slice_id_seq', 1, false);


--
-- TOC entry 3627 (class 0 OID 0)
-- Dependencies: 209
-- Name: hypertable_id_seq; Type: SEQUENCE SET; Schema: _timescaledb_catalog; Owner: root
--

SELECT pg_catalog.setval('_timescaledb_catalog.hypertable_id_seq', 1, false);


--
-- TOC entry 3628 (class 0 OID 0)
-- Dependencies: 224
-- Name: bgw_job_id_seq; Type: SEQUENCE SET; Schema: _timescaledb_config; Owner: root
--

SELECT pg_catalog.setval('_timescaledb_config.bgw_job_id_seq', 1000, false);


--
-- TOC entry 3629 (class 0 OID 0)
-- Dependencies: 262
-- Name: BOARD_board_id_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('public."BOARD_board_id_seq"', 1, false);


--
-- TOC entry 3630 (class 0 OID 0)
-- Dependencies: 272
-- Name: ENDDEV_PAYLOAD_payload_id_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('public."ENDDEV_PAYLOAD_payload_id_seq"', 1, false);


--
-- TOC entry 3631 (class 0 OID 0)
-- Dependencies: 257
-- Name: ENDDEV_dev_id_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('public."ENDDEV_dev_id_seq"', 1, false);


--
-- TOC entry 3632 (class 0 OID 0)
-- Dependencies: 255
-- Name: PROFILE_profile_id_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('public."PROFILE_profile_id_seq"', 1, false);


--
-- TOC entry 3633 (class 0 OID 0)
-- Dependencies: 267
-- Name: SENSOR_sensor_id_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('public."SENSOR_sensor_id_seq"', 1, false);


--
-- TOC entry 3634 (class 0 OID 0)
-- Dependencies: 270
-- Name: UNIT_unit_id_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('public."UNIT_unit_id_seq"', 1, false);


--
-- TOC entry 3635 (class 0 OID 0)
-- Dependencies: 264
-- Name: WIDGET_widget_id_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('public."WIDGET_widget_id_seq"', 1, false);


--
-- TOC entry 3636 (class 0 OID 0)
-- Dependencies: 253
-- Name: notification_noti_id_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('public.notification_noti_id_seq', 1, false);


--
-- TOC entry 3417 (class 2606 OID 34595)
-- Name: ADMIN ADMIN_pkey; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public."ADMIN"
    ADD CONSTRAINT "ADMIN_pkey" PRIMARY KEY (profile_id);


--
-- TOC entry 3425 (class 2606 OID 34660)
-- Name: BELONG_TO BELONG_TO_pkey; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public."BELONG_TO"
    ADD CONSTRAINT "BELONG_TO_pkey" PRIMARY KEY (widget_id, sensor_id);


--
-- TOC entry 3421 (class 2606 OID 34624)
-- Name: BOARD BOARD_pkey; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public."BOARD"
    ADD CONSTRAINT "BOARD_pkey" PRIMARY KEY (board_id);


--
-- TOC entry 3419 (class 2606 OID 34608)
-- Name: CUSTOMER CUSTOMER_pkey; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public."CUSTOMER"
    ADD CONSTRAINT "CUSTOMER_pkey" PRIMARY KEY (profile_id);


--
-- TOC entry 3433 (class 2606 OID 34698)
-- Name: ENDDEV_PAYLOAD ENDDEV_PAYLOAD_pkey; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public."ENDDEV_PAYLOAD"
    ADD CONSTRAINT "ENDDEV_PAYLOAD_pkey" PRIMARY KEY (payload_id);


--
-- TOC entry 3413 (class 2606 OID 34567)
-- Name: ENDDEV ENDDEV_pkey; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public."ENDDEV"
    ADD CONSTRAINT "ENDDEV_pkey" PRIMARY KEY (dev_id);


--
-- TOC entry 3429 (class 2606 OID 34676)
-- Name: HAS_UNIT HAS_UNIT_pkey; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public."HAS_UNIT"
    ADD CONSTRAINT "HAS_UNIT_pkey" PRIMARY KEY (sensor_id, unit_id);


--
-- TOC entry 3415 (class 2606 OID 34577)
-- Name: NOTIFY NOTIFY_pkey; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public."NOTIFY"
    ADD CONSTRAINT "NOTIFY_pkey" PRIMARY KEY (profile_id, noti_id);


--
-- TOC entry 3435 (class 2606 OID 34703)
-- Name: OWN OWN_pkey; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public."OWN"
    ADD CONSTRAINT "OWN_pkey" PRIMARY KEY (profile_id, dev_id);


--
-- TOC entry 3411 (class 2606 OID 34556)
-- Name: PROFILE PROFILE_pkey; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public."PROFILE"
    ADD CONSTRAINT "PROFILE_pkey" PRIMARY KEY (profile_id);


--
-- TOC entry 3427 (class 2606 OID 34671)
-- Name: SENSOR SENSOR_pkey; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public."SENSOR"
    ADD CONSTRAINT "SENSOR_pkey" PRIMARY KEY (sensor_id);


--
-- TOC entry 3431 (class 2606 OID 34687)
-- Name: UNIT UNIT_pkey; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public."UNIT"
    ADD CONSTRAINT "UNIT_pkey" PRIMARY KEY (unit_id);


--
-- TOC entry 3423 (class 2606 OID 34640)
-- Name: WIDGET WIDGET_pkey; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public."WIDGET"
    ADD CONSTRAINT "WIDGET_pkey" PRIMARY KEY (widget_id);


--
-- TOC entry 3409 (class 2606 OID 34545)
-- Name: NOTIFICATION notification_pkey; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public."NOTIFICATION"
    ADD CONSTRAINT notification_pkey PRIMARY KEY (noti_id);


--
-- TOC entry 3438 (class 2606 OID 34704)
-- Name: ADMIN ADMIN_profile_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public."ADMIN"
    ADD CONSTRAINT "ADMIN_profile_id_fkey" FOREIGN KEY (profile_id) REFERENCES public."PROFILE"(profile_id) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;


--
-- TOC entry 3442 (class 2606 OID 34724)
-- Name: BELONG_TO BELONG_TO_sensor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public."BELONG_TO"
    ADD CONSTRAINT "BELONG_TO_sensor_id_fkey" FOREIGN KEY (sensor_id) REFERENCES public."SENSOR"(sensor_id) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;


--
-- TOC entry 3443 (class 2606 OID 34719)
-- Name: BELONG_TO BELONG_TO_widget_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public."BELONG_TO"
    ADD CONSTRAINT "BELONG_TO_widget_id_fkey" FOREIGN KEY (widget_id) REFERENCES public."WIDGET"(widget_id) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;


--
-- TOC entry 3440 (class 2606 OID 34729)
-- Name: BOARD BOARD_profile_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public."BOARD"
    ADD CONSTRAINT "BOARD_profile_id_fkey" FOREIGN KEY (profile_id) REFERENCES public."CUSTOMER"(profile_id) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;


--
-- TOC entry 3439 (class 2606 OID 34734)
-- Name: CUSTOMER CUSTOMER_profile_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public."CUSTOMER"
    ADD CONSTRAINT "CUSTOMER_profile_id_fkey" FOREIGN KEY (profile_id) REFERENCES public."PROFILE"(profile_id) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;


--
-- TOC entry 3447 (class 2606 OID 34739)
-- Name: ENDDEV_PAYLOAD ENDDEV_PAYLOAD_dev_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public."ENDDEV_PAYLOAD"
    ADD CONSTRAINT "ENDDEV_PAYLOAD_dev_id_fkey" FOREIGN KEY (dev_id) REFERENCES public."ENDDEV"(dev_id) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;


--
-- TOC entry 3445 (class 2606 OID 34744)
-- Name: HAS_UNIT HAS_UNIT_sensor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public."HAS_UNIT"
    ADD CONSTRAINT "HAS_UNIT_sensor_id_fkey" FOREIGN KEY (sensor_id) REFERENCES public."SENSOR"(sensor_id) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;


--
-- TOC entry 3446 (class 2606 OID 34749)
-- Name: HAS_UNIT HAS_UNIT_unit_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public."HAS_UNIT"
    ADD CONSTRAINT "HAS_UNIT_unit_id_fkey" FOREIGN KEY (unit_id) REFERENCES public."UNIT"(unit_id) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;


--
-- TOC entry 3436 (class 2606 OID 34759)
-- Name: NOTIFY NOTIFY_noti_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public."NOTIFY"
    ADD CONSTRAINT "NOTIFY_noti_id_fkey" FOREIGN KEY (noti_id) REFERENCES public."NOTIFICATION"(noti_id) NOT VALID;


--
-- TOC entry 3437 (class 2606 OID 34754)
-- Name: NOTIFY NOTIFY_profile_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public."NOTIFY"
    ADD CONSTRAINT "NOTIFY_profile_id_fkey" FOREIGN KEY (profile_id) REFERENCES public."PROFILE"(profile_id) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;


--
-- TOC entry 3448 (class 2606 OID 34769)
-- Name: OWN OWN_dev_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public."OWN"
    ADD CONSTRAINT "OWN_dev_id_fkey" FOREIGN KEY (dev_id) REFERENCES public."ENDDEV"(dev_id) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;


--
-- TOC entry 3449 (class 2606 OID 34764)
-- Name: OWN OWN_profile_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public."OWN"
    ADD CONSTRAINT "OWN_profile_id_fkey" FOREIGN KEY (profile_id) REFERENCES public."CUSTOMER"(profile_id) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;


--
-- TOC entry 3444 (class 2606 OID 34774)
-- Name: SENSOR SENSOR_dev_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public."SENSOR"
    ADD CONSTRAINT "SENSOR_dev_id_fkey" FOREIGN KEY (dev_id) REFERENCES public."ENDDEV"(dev_id) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;


--
-- TOC entry 3441 (class 2606 OID 34641)
-- Name: WIDGET WIDGET_board_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public."WIDGET"
    ADD CONSTRAINT "WIDGET_board_id_fkey" FOREIGN KEY (board_id) REFERENCES public."BOARD"(board_id) ON UPDATE CASCADE ON DELETE CASCADE;


-- Completed on 2021-12-25 17:01:27 UTC

--
-- PostgreSQL database dump complete
--

