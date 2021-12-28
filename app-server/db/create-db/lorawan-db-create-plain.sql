--
-- PostgreSQL database dump
--

-- Dumped from database version 12.9
-- Dumped by pg_dump version 12.9

-- Started on 2021-12-28 14:21:43 UTC

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
-- TOC entry 2 (class 3079 OID 16972)
-- Name: timescaledb; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS timescaledb WITH SCHEMA public;


--
-- TOC entry 3593 (class 0 OID 0)
-- Dependencies: 2
-- Name: EXTENSION timescaledb; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION timescaledb IS 'Enables scalable inserts and complex queries for time-series data';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 255 (class 1259 OID 18386)
-- Name: ADMIN; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."ADMIN" (
    profile_id integer NOT NULL,
    title character varying NOT NULL
);


--
-- TOC entry 264 (class 1259 OID 18440)
-- Name: BELONG_TO; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."BELONG_TO" (
    widget_id integer NOT NULL,
    sensor_id integer NOT NULL
);


--
-- TOC entry 261 (class 1259 OID 18420)
-- Name: BOARD; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."BOARD" (
    _id integer NOT NULL,
    display_name character varying NOT NULL,
    profile_id integer NOT NULL
);


--
-- TOC entry 260 (class 1259 OID 18418)
-- Name: BOARD__id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public."BOARD__id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3594 (class 0 OID 0)
-- Dependencies: 260
-- Name: BOARD__id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public."BOARD__id_seq" OWNED BY public."BOARD"._id;


--
-- TOC entry 256 (class 1259 OID 18394)
-- Name: CUSTOMER; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."CUSTOMER" (
    profile_id integer NOT NULL
);


--
-- TOC entry 266 (class 1259 OID 18447)
-- Name: ENDDEV; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."ENDDEV" (
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


--
-- TOC entry 273 (class 1259 OID 18485)
-- Name: ENDDEV_PAYLOAD; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."ENDDEV_PAYLOAD" (
    _id integer NOT NULL,
    recv_timestamp timestamp without time zone NOT NULL,
    payload_data jsonb NOT NULL,
    enddev_id integer NOT NULL
);


--
-- TOC entry 272 (class 1259 OID 18483)
-- Name: ENDDEV_PAYLOAD__id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public."ENDDEV_PAYLOAD__id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3595 (class 0 OID 0)
-- Dependencies: 272
-- Name: ENDDEV_PAYLOAD__id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public."ENDDEV_PAYLOAD__id_seq" OWNED BY public."ENDDEV_PAYLOAD"._id;


--
-- TOC entry 265 (class 1259 OID 18445)
-- Name: ENDDEV__id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public."ENDDEV__id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3596 (class 0 OID 0)
-- Dependencies: 265
-- Name: ENDDEV__id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public."ENDDEV__id_seq" OWNED BY public."ENDDEV"._id;


--
-- TOC entry 269 (class 1259 OID 18467)
-- Name: HAS_UNIT; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."HAS_UNIT" (
    sensor_id integer NOT NULL,
    unit_id integer NOT NULL
);


--
-- TOC entry 258 (class 1259 OID 18404)
-- Name: NOTIFICATION; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."NOTIFICATION" (
    _id integer NOT NULL,
    title character varying NOT NULL,
    content character varying NOT NULL,
    updated_timestamp timestamp without time zone NOT NULL
);


--
-- TOC entry 257 (class 1259 OID 18402)
-- Name: NOTIFICATION__id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public."NOTIFICATION__id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3597 (class 0 OID 0)
-- Dependencies: 257
-- Name: NOTIFICATION__id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public."NOTIFICATION__id_seq" OWNED BY public."NOTIFICATION"._id;


--
-- TOC entry 259 (class 1259 OID 18413)
-- Name: NOTIFY; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."NOTIFY" (
    profile_id integer NOT NULL,
    noti_id integer NOT NULL
);


--
-- TOC entry 274 (class 1259 OID 18497)
-- Name: OWN; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."OWN" (
    profile_id integer NOT NULL,
    enddev_id integer NOT NULL
);


--
-- TOC entry 253 (class 1259 OID 18367)
-- Name: PROFILE; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."PROFILE" (
    email character varying,
    phone_number character varying,
    password character varying NOT NULL,
    type character varying NOT NULL,
    _id integer NOT NULL,
    display_name character varying NOT NULL
);


--
-- TOC entry 254 (class 1259 OID 18375)
-- Name: PROFILE__id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public."PROFILE__id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3598 (class 0 OID 0)
-- Dependencies: 254
-- Name: PROFILE__id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public."PROFILE__id_seq" OWNED BY public."PROFILE"._id;


--
-- TOC entry 268 (class 1259 OID 18458)
-- Name: SENSOR; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."SENSOR" (
    enddev_id integer NOT NULL,
    _id integer NOT NULL,
    sensor_key character varying NOT NULL
);


--
-- TOC entry 267 (class 1259 OID 18456)
-- Name: SENSOR__id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public."SENSOR__id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3599 (class 0 OID 0)
-- Dependencies: 267
-- Name: SENSOR__id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public."SENSOR__id_seq" OWNED BY public."SENSOR"._id;


--
-- TOC entry 271 (class 1259 OID 18474)
-- Name: UNIT; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."UNIT" (
    _id integer NOT NULL,
    sensor_key character varying NOT NULL,
    dev_type character varying NOT NULL,
    uint character varying NOT NULL
);


--
-- TOC entry 270 (class 1259 OID 18472)
-- Name: UNIT__id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public."UNIT__id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3600 (class 0 OID 0)
-- Dependencies: 270
-- Name: UNIT__id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public."UNIT__id_seq" OWNED BY public."UNIT"._id;


--
-- TOC entry 263 (class 1259 OID 18431)
-- Name: WIDGET; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."WIDGET" (
    _id integer NOT NULL,
    display_name character varying NOT NULL,
    config_dict jsonb,
    board_id integer NOT NULL
);


--
-- TOC entry 262 (class 1259 OID 18429)
-- Name: WIDGET__id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public."WIDGET__id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3601 (class 0 OID 0)
-- Dependencies: 262
-- Name: WIDGET__id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public."WIDGET__id_seq" OWNED BY public."WIDGET"._id;


--
-- TOC entry 3330 (class 2604 OID 18423)
-- Name: BOARD _id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."BOARD" ALTER COLUMN _id SET DEFAULT nextval('public."BOARD__id_seq"'::regclass);


--
-- TOC entry 3332 (class 2604 OID 18450)
-- Name: ENDDEV _id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."ENDDEV" ALTER COLUMN _id SET DEFAULT nextval('public."ENDDEV__id_seq"'::regclass);


--
-- TOC entry 3335 (class 2604 OID 18488)
-- Name: ENDDEV_PAYLOAD _id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."ENDDEV_PAYLOAD" ALTER COLUMN _id SET DEFAULT nextval('public."ENDDEV_PAYLOAD__id_seq"'::regclass);


--
-- TOC entry 3329 (class 2604 OID 18407)
-- Name: NOTIFICATION _id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."NOTIFICATION" ALTER COLUMN _id SET DEFAULT nextval('public."NOTIFICATION__id_seq"'::regclass);


--
-- TOC entry 3328 (class 2604 OID 18377)
-- Name: PROFILE _id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."PROFILE" ALTER COLUMN _id SET DEFAULT nextval('public."PROFILE__id_seq"'::regclass);


--
-- TOC entry 3333 (class 2604 OID 18461)
-- Name: SENSOR _id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."SENSOR" ALTER COLUMN _id SET DEFAULT nextval('public."SENSOR__id_seq"'::regclass);


--
-- TOC entry 3334 (class 2604 OID 18477)
-- Name: UNIT _id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."UNIT" ALTER COLUMN _id SET DEFAULT nextval('public."UNIT__id_seq"'::regclass);


--
-- TOC entry 3331 (class 2604 OID 18434)
-- Name: WIDGET _id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."WIDGET" ALTER COLUMN _id SET DEFAULT nextval('public."WIDGET__id_seq"'::regclass);


--
-- TOC entry 3412 (class 2606 OID 18393)
-- Name: ADMIN ADMIN_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."ADMIN"
    ADD CONSTRAINT "ADMIN_pkey" PRIMARY KEY (profile_id);


--
-- TOC entry 3424 (class 2606 OID 18444)
-- Name: BELONG_TO BELONG_TO_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."BELONG_TO"
    ADD CONSTRAINT "BELONG_TO_pkey" PRIMARY KEY (widget_id, sensor_id);


--
-- TOC entry 3420 (class 2606 OID 18428)
-- Name: BOARD BOARD_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."BOARD"
    ADD CONSTRAINT "BOARD_pkey" PRIMARY KEY (_id);


--
-- TOC entry 3414 (class 2606 OID 18401)
-- Name: CUSTOMER CUSTOMER_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."CUSTOMER"
    ADD CONSTRAINT "CUSTOMER_pkey" PRIMARY KEY (profile_id);


--
-- TOC entry 3434 (class 2606 OID 18493)
-- Name: ENDDEV_PAYLOAD ENDDEV_PAYLOAD_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."ENDDEV_PAYLOAD"
    ADD CONSTRAINT "ENDDEV_PAYLOAD_pkey" PRIMARY KEY (_id);


--
-- TOC entry 3426 (class 2606 OID 18455)
-- Name: ENDDEV ENDDEV_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."ENDDEV"
    ADD CONSTRAINT "ENDDEV_pkey" PRIMARY KEY (_id);


--
-- TOC entry 3430 (class 2606 OID 18471)
-- Name: HAS_UNIT HAS_UNIT_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."HAS_UNIT"
    ADD CONSTRAINT "HAS_UNIT_pkey" PRIMARY KEY (sensor_id, unit_id);


--
-- TOC entry 3416 (class 2606 OID 18412)
-- Name: NOTIFICATION NOTIFICATION_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."NOTIFICATION"
    ADD CONSTRAINT "NOTIFICATION_pkey" PRIMARY KEY (_id);


--
-- TOC entry 3418 (class 2606 OID 18417)
-- Name: NOTIFY NOTIFY_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."NOTIFY"
    ADD CONSTRAINT "NOTIFY_pkey" PRIMARY KEY (profile_id, noti_id);


--
-- TOC entry 3436 (class 2606 OID 18501)
-- Name: OWN OWN_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."OWN"
    ADD CONSTRAINT "OWN_pkey" PRIMARY KEY (profile_id, enddev_id);


--
-- TOC entry 3410 (class 2606 OID 18385)
-- Name: PROFILE PROFILE_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."PROFILE"
    ADD CONSTRAINT "PROFILE_pkey" PRIMARY KEY (_id);


--
-- TOC entry 3428 (class 2606 OID 18466)
-- Name: SENSOR SENSOR_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."SENSOR"
    ADD CONSTRAINT "SENSOR_pkey" PRIMARY KEY (_id);


--
-- TOC entry 3432 (class 2606 OID 18482)
-- Name: UNIT UNIT_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."UNIT"
    ADD CONSTRAINT "UNIT_pkey" PRIMARY KEY (_id);


--
-- TOC entry 3422 (class 2606 OID 18439)
-- Name: WIDGET WIDGET_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."WIDGET"
    ADD CONSTRAINT "WIDGET_pkey" PRIMARY KEY (_id);


--
-- TOC entry 3437 (class 2606 OID 18512)
-- Name: ADMIN ADMIN_profile_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."ADMIN"
    ADD CONSTRAINT "ADMIN_profile_id_fkey" FOREIGN KEY (profile_id) REFERENCES public."PROFILE"(_id) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;


--
-- TOC entry 3443 (class 2606 OID 18537)
-- Name: BELONG_TO BELONG_TO_sensor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."BELONG_TO"
    ADD CONSTRAINT "BELONG_TO_sensor_id_fkey" FOREIGN KEY (sensor_id) REFERENCES public."SENSOR"(_id) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;


--
-- TOC entry 3444 (class 2606 OID 18532)
-- Name: BELONG_TO BELONG_TO_widget_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."BELONG_TO"
    ADD CONSTRAINT "BELONG_TO_widget_id_fkey" FOREIGN KEY (widget_id) REFERENCES public."WIDGET"(_id) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;


--
-- TOC entry 3441 (class 2606 OID 18522)
-- Name: BOARD BOARD_profile_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."BOARD"
    ADD CONSTRAINT "BOARD_profile_id_fkey" FOREIGN KEY (profile_id) REFERENCES public."CUSTOMER"(profile_id) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;


--
-- TOC entry 3438 (class 2606 OID 18517)
-- Name: CUSTOMER CUSTOMER_profile_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."CUSTOMER"
    ADD CONSTRAINT "CUSTOMER_profile_id_fkey" FOREIGN KEY (profile_id) REFERENCES public."PROFILE"(_id) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;


--
-- TOC entry 3448 (class 2606 OID 18559)
-- Name: ENDDEV_PAYLOAD ENDDEV_PAYLOAD_enddev_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."ENDDEV_PAYLOAD"
    ADD CONSTRAINT "ENDDEV_PAYLOAD_enddev_id_fkey" FOREIGN KEY (enddev_id) REFERENCES public."ENDDEV"(_id) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;


--
-- TOC entry 3446 (class 2606 OID 18549)
-- Name: HAS_UNIT HAS_UNIT_sensor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."HAS_UNIT"
    ADD CONSTRAINT "HAS_UNIT_sensor_id_fkey" FOREIGN KEY (sensor_id) REFERENCES public."SENSOR"(_id) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;


--
-- TOC entry 3447 (class 2606 OID 18554)
-- Name: HAS_UNIT HAS_UNIT_unit_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."HAS_UNIT"
    ADD CONSTRAINT "HAS_UNIT_unit_id_fkey" FOREIGN KEY (unit_id) REFERENCES public."UNIT"(_id) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;


--
-- TOC entry 3439 (class 2606 OID 18507)
-- Name: NOTIFY NOTIFY_noti_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."NOTIFY"
    ADD CONSTRAINT "NOTIFY_noti_id_fkey" FOREIGN KEY (noti_id) REFERENCES public."NOTIFICATION"(_id) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;


--
-- TOC entry 3440 (class 2606 OID 18502)
-- Name: NOTIFY NOTIFY_profile_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."NOTIFY"
    ADD CONSTRAINT "NOTIFY_profile_id_fkey" FOREIGN KEY (profile_id) REFERENCES public."PROFILE"(_id) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;


--
-- TOC entry 3449 (class 2606 OID 18569)
-- Name: OWN OWN_enddev_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."OWN"
    ADD CONSTRAINT "OWN_enddev_id_fkey" FOREIGN KEY (enddev_id) REFERENCES public."ENDDEV"(_id) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;


--
-- TOC entry 3450 (class 2606 OID 18564)
-- Name: OWN OWN_profile_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."OWN"
    ADD CONSTRAINT "OWN_profile_id_fkey" FOREIGN KEY (profile_id) REFERENCES public."CUSTOMER"(profile_id) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;


--
-- TOC entry 3445 (class 2606 OID 18544)
-- Name: SENSOR SENSOR_enddev_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."SENSOR"
    ADD CONSTRAINT "SENSOR_enddev_id_fkey" FOREIGN KEY (enddev_id) REFERENCES public."ENDDEV"(_id) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;


--
-- TOC entry 3442 (class 2606 OID 18527)
-- Name: WIDGET WIDGET_board_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."WIDGET"
    ADD CONSTRAINT "WIDGET_board_id_fkey" FOREIGN KEY (board_id) REFERENCES public."BOARD"(_id) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;


-- Completed on 2021-12-28 14:21:43 UTC

--
-- PostgreSQL database dump complete
--

