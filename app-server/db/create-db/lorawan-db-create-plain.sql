--
-- PostgreSQL database dump
--

-- Dumped from database version 12.8
-- Dumped by pg_dump version 12.9

-- Started on 2022-01-02 09:08:58 UTC

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
-- TOC entry 3639 (class 0 OID 0)
-- Dependencies: 2
-- Name: EXTENSION timescaledb; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION timescaledb IS 'Enables scalable inserts and complex queries for time-series data';


--
-- TOC entry 3 (class 3079 OID 34999)
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;


--
-- TOC entry 3640 (class 0 OID 0)
-- Dependencies: 3
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


--
-- TOC entry 517 (class 1255 OID 42978)
-- Name: insert_board(character varying, integer); Type: PROCEDURE; Schema: public; Owner: -
--

CREATE PROCEDURE public.insert_board(new_display_name character varying, ref_profile_id integer)
    LANGUAGE plpgsql
    AS $$

BEGIN
INSERT INTO public."BOARD"(
	display_name, profile_id)
	VALUES (new_display_name, ref_profile_id);

END;
$$;


--
-- TOC entry 516 (class 1255 OID 34998)
-- Name: insert_profile(character varying, character varying, character varying, character varying, character varying); Type: PROCEDURE; Schema: public; Owner: -
--

CREATE PROCEDURE public.insert_profile(new_email character varying, new_phone_number character varying, new_password character varying, new_type character varying, new_display_name character varying)
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


--
-- TOC entry 518 (class 1255 OID 42979)
-- Name: insert_widget(character varying, jsonb, integer); Type: PROCEDURE; Schema: public; Owner: -
--

CREATE PROCEDURE public.insert_widget(new_display_name character varying, new_config_dict jsonb, ref_board_id integer)
    LANGUAGE plpgsql
    AS $$

BEGIN
INSERT INTO public."WIDGET"(
	display_name, config_dict, profile_id)
	VALUES (new_display_name, new_config_dict, ref_profile_id);

END;
$$;


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 254 (class 1259 OID 34787)
-- Name: ADMIN; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."ADMIN" (
    profile_id integer NOT NULL
);


--
-- TOC entry 255 (class 1259 OID 34793)
-- Name: BELONG_TO; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."BELONG_TO" (
    widget_id integer NOT NULL,
    sensor_id integer NOT NULL
);


--
-- TOC entry 256 (class 1259 OID 34796)
-- Name: BOARD; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."BOARD" (
    _id integer NOT NULL,
    display_name character varying NOT NULL,
    profile_id integer NOT NULL
);


--
-- TOC entry 257 (class 1259 OID 34802)
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
-- TOC entry 3641 (class 0 OID 0)
-- Dependencies: 257
-- Name: BOARD__id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public."BOARD__id_seq" OWNED BY public."BOARD"._id;


--
-- TOC entry 258 (class 1259 OID 34804)
-- Name: CUSTOMER; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."CUSTOMER" (
    profile_id integer NOT NULL
);


--
-- TOC entry 274 (class 1259 OID 43014)
-- Name: DEVTYPE; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."DEVTYPE" (
    _id integer NOT NULL,
    dev_type character varying NOT NULL,
    dev_type_config jsonb[]
);


--
-- TOC entry 273 (class 1259 OID 43012)
-- Name: DEVTYPE__id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public."DEVTYPE__id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3642 (class 0 OID 0)
-- Dependencies: 273
-- Name: DEVTYPE__id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public."DEVTYPE__id_seq" OWNED BY public."DEVTYPE"._id;


--
-- TOC entry 259 (class 1259 OID 34807)
-- Name: ENDDEV; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."ENDDEV" (
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


--
-- TOC entry 260 (class 1259 OID 34813)
-- Name: ENDDEV_PAYLOAD; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."ENDDEV_PAYLOAD" (
    _id integer NOT NULL,
    recv_timestamp timestamp without time zone NOT NULL,
    payload_data jsonb NOT NULL,
    enddev_id integer NOT NULL
);


--
-- TOC entry 261 (class 1259 OID 34819)
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
-- TOC entry 3643 (class 0 OID 0)
-- Dependencies: 261
-- Name: ENDDEV_PAYLOAD__id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public."ENDDEV_PAYLOAD__id_seq" OWNED BY public."ENDDEV_PAYLOAD"._id;


--
-- TOC entry 262 (class 1259 OID 34821)
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
-- TOC entry 3644 (class 0 OID 0)
-- Dependencies: 262
-- Name: ENDDEV__id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public."ENDDEV__id_seq" OWNED BY public."ENDDEV"._id;


--
-- TOC entry 263 (class 1259 OID 34826)
-- Name: NOTIFICATION; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."NOTIFICATION" (
    _id integer NOT NULL,
    title character varying NOT NULL,
    content character varying NOT NULL,
    updated_timestamp timestamp without time zone NOT NULL
);


--
-- TOC entry 264 (class 1259 OID 34832)
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
-- TOC entry 3645 (class 0 OID 0)
-- Dependencies: 264
-- Name: NOTIFICATION__id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public."NOTIFICATION__id_seq" OWNED BY public."NOTIFICATION"._id;


--
-- TOC entry 265 (class 1259 OID 34834)
-- Name: NOTIFY; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."NOTIFY" (
    profile_id integer NOT NULL,
    noti_id integer NOT NULL
);


--
-- TOC entry 266 (class 1259 OID 34837)
-- Name: OWN; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."OWN" (
    profile_id integer NOT NULL,
    enddev_id integer NOT NULL
);


--
-- TOC entry 267 (class 1259 OID 34840)
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
-- TOC entry 268 (class 1259 OID 34846)
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
-- TOC entry 3646 (class 0 OID 0)
-- Dependencies: 268
-- Name: PROFILE__id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public."PROFILE__id_seq" OWNED BY public."PROFILE"._id;


--
-- TOC entry 269 (class 1259 OID 34848)
-- Name: SENSOR; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."SENSOR" (
    enddev_id integer NOT NULL,
    _id integer NOT NULL,
    sensor_key character varying NOT NULL
);


--
-- TOC entry 270 (class 1259 OID 34854)
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
-- TOC entry 3647 (class 0 OID 0)
-- Dependencies: 270
-- Name: SENSOR__id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public."SENSOR__id_seq" OWNED BY public."SENSOR"._id;


--
-- TOC entry 271 (class 1259 OID 34864)
-- Name: WIDGET; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."WIDGET" (
    _id integer NOT NULL,
    display_name character varying NOT NULL,
    config_dict jsonb,
    board_id integer NOT NULL,
    widget_type_id integer NOT NULL
);


--
-- TOC entry 276 (class 1259 OID 43032)
-- Name: WIDGET_TYPE; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."WIDGET_TYPE" (
    _id integer NOT NULL,
    ui_config jsonb
);


--
-- TOC entry 275 (class 1259 OID 43030)
-- Name: WIDGET_TYPE__id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public."WIDGET_TYPE__id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3648 (class 0 OID 0)
-- Dependencies: 275
-- Name: WIDGET_TYPE__id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public."WIDGET_TYPE__id_seq" OWNED BY public."WIDGET_TYPE"._id;


--
-- TOC entry 272 (class 1259 OID 34870)
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
-- TOC entry 3649 (class 0 OID 0)
-- Dependencies: 272
-- Name: WIDGET__id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public."WIDGET__id_seq" OWNED BY public."WIDGET"._id;


--
-- TOC entry 3369 (class 2604 OID 34872)
-- Name: BOARD _id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."BOARD" ALTER COLUMN _id SET DEFAULT nextval('public."BOARD__id_seq"'::regclass);


--
-- TOC entry 3376 (class 2604 OID 43017)
-- Name: DEVTYPE _id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."DEVTYPE" ALTER COLUMN _id SET DEFAULT nextval('public."DEVTYPE__id_seq"'::regclass);


--
-- TOC entry 3370 (class 2604 OID 34873)
-- Name: ENDDEV _id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."ENDDEV" ALTER COLUMN _id SET DEFAULT nextval('public."ENDDEV__id_seq"'::regclass);


--
-- TOC entry 3371 (class 2604 OID 34874)
-- Name: ENDDEV_PAYLOAD _id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."ENDDEV_PAYLOAD" ALTER COLUMN _id SET DEFAULT nextval('public."ENDDEV_PAYLOAD__id_seq"'::regclass);


--
-- TOC entry 3372 (class 2604 OID 34875)
-- Name: NOTIFICATION _id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."NOTIFICATION" ALTER COLUMN _id SET DEFAULT nextval('public."NOTIFICATION__id_seq"'::regclass);


--
-- TOC entry 3373 (class 2604 OID 34876)
-- Name: PROFILE _id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."PROFILE" ALTER COLUMN _id SET DEFAULT nextval('public."PROFILE__id_seq"'::regclass);


--
-- TOC entry 3374 (class 2604 OID 34877)
-- Name: SENSOR _id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."SENSOR" ALTER COLUMN _id SET DEFAULT nextval('public."SENSOR__id_seq"'::regclass);


--
-- TOC entry 3375 (class 2604 OID 34879)
-- Name: WIDGET _id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."WIDGET" ALTER COLUMN _id SET DEFAULT nextval('public."WIDGET__id_seq"'::regclass);


--
-- TOC entry 3377 (class 2604 OID 43035)
-- Name: WIDGET_TYPE _id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."WIDGET_TYPE" ALTER COLUMN _id SET DEFAULT nextval('public."WIDGET_TYPE__id_seq"'::regclass);


--
-- TOC entry 3452 (class 2606 OID 34881)
-- Name: ADMIN ADMIN_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."ADMIN"
    ADD CONSTRAINT "ADMIN_pkey" PRIMARY KEY (profile_id);


--
-- TOC entry 3454 (class 2606 OID 34883)
-- Name: BELONG_TO BELONG_TO_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."BELONG_TO"
    ADD CONSTRAINT "BELONG_TO_pkey" PRIMARY KEY (widget_id, sensor_id);


--
-- TOC entry 3456 (class 2606 OID 34885)
-- Name: BOARD BOARD_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."BOARD"
    ADD CONSTRAINT "BOARD_pkey" PRIMARY KEY (_id);


--
-- TOC entry 3458 (class 2606 OID 34887)
-- Name: CUSTOMER CUSTOMER_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."CUSTOMER"
    ADD CONSTRAINT "CUSTOMER_pkey" PRIMARY KEY (profile_id);


--
-- TOC entry 3478 (class 2606 OID 43024)
-- Name: DEVTYPE DEVTYPE_dev_type_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."DEVTYPE"
    ADD CONSTRAINT "DEVTYPE_dev_type_key" UNIQUE (dev_type);


--
-- TOC entry 3480 (class 2606 OID 43022)
-- Name: DEVTYPE DEVTYPE_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."DEVTYPE"
    ADD CONSTRAINT "DEVTYPE_pkey" PRIMARY KEY (_id);


--
-- TOC entry 3464 (class 2606 OID 34889)
-- Name: ENDDEV_PAYLOAD ENDDEV_PAYLOAD_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."ENDDEV_PAYLOAD"
    ADD CONSTRAINT "ENDDEV_PAYLOAD_pkey" PRIMARY KEY (_id);


--
-- TOC entry 3460 (class 2606 OID 34891)
-- Name: ENDDEV ENDDEV_dev_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."ENDDEV"
    ADD CONSTRAINT "ENDDEV_dev_id_key" UNIQUE (dev_id);


--
-- TOC entry 3462 (class 2606 OID 34893)
-- Name: ENDDEV ENDDEV_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."ENDDEV"
    ADD CONSTRAINT "ENDDEV_pkey" PRIMARY KEY (_id);


--
-- TOC entry 3466 (class 2606 OID 34897)
-- Name: NOTIFICATION NOTIFICATION_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."NOTIFICATION"
    ADD CONSTRAINT "NOTIFICATION_pkey" PRIMARY KEY (_id);


--
-- TOC entry 3468 (class 2606 OID 34899)
-- Name: NOTIFY NOTIFY_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."NOTIFY"
    ADD CONSTRAINT "NOTIFY_pkey" PRIMARY KEY (profile_id, noti_id);


--
-- TOC entry 3470 (class 2606 OID 34901)
-- Name: OWN OWN_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."OWN"
    ADD CONSTRAINT "OWN_pkey" PRIMARY KEY (profile_id, enddev_id);


--
-- TOC entry 3472 (class 2606 OID 34903)
-- Name: PROFILE PROFILE_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."PROFILE"
    ADD CONSTRAINT "PROFILE_pkey" PRIMARY KEY (_id);


--
-- TOC entry 3474 (class 2606 OID 34905)
-- Name: SENSOR SENSOR_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."SENSOR"
    ADD CONSTRAINT "SENSOR_pkey" PRIMARY KEY (_id);


--
-- TOC entry 3482 (class 2606 OID 43040)
-- Name: WIDGET_TYPE WIDGET_TYPE_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."WIDGET_TYPE"
    ADD CONSTRAINT "WIDGET_TYPE_pkey" PRIMARY KEY (_id);


--
-- TOC entry 3476 (class 2606 OID 34909)
-- Name: WIDGET WIDGET_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."WIDGET"
    ADD CONSTRAINT "WIDGET_pkey" PRIMARY KEY (_id);


--
-- TOC entry 3483 (class 2606 OID 34910)
-- Name: ADMIN ADMIN_profile_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."ADMIN"
    ADD CONSTRAINT "ADMIN_profile_id_fkey" FOREIGN KEY (profile_id) REFERENCES public."PROFILE"(_id) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;


--
-- TOC entry 3484 (class 2606 OID 34915)
-- Name: BELONG_TO BELONG_TO_sensor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."BELONG_TO"
    ADD CONSTRAINT "BELONG_TO_sensor_id_fkey" FOREIGN KEY (sensor_id) REFERENCES public."SENSOR"(_id) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;


--
-- TOC entry 3485 (class 2606 OID 34920)
-- Name: BELONG_TO BELONG_TO_widget_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."BELONG_TO"
    ADD CONSTRAINT "BELONG_TO_widget_id_fkey" FOREIGN KEY (widget_id) REFERENCES public."WIDGET"(_id) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;


--
-- TOC entry 3486 (class 2606 OID 34925)
-- Name: BOARD BOARD_profile_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."BOARD"
    ADD CONSTRAINT "BOARD_profile_id_fkey" FOREIGN KEY (profile_id) REFERENCES public."CUSTOMER"(profile_id) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;


--
-- TOC entry 3487 (class 2606 OID 34930)
-- Name: CUSTOMER CUSTOMER_profile_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."CUSTOMER"
    ADD CONSTRAINT "CUSTOMER_profile_id_fkey" FOREIGN KEY (profile_id) REFERENCES public."PROFILE"(_id) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;


--
-- TOC entry 3489 (class 2606 OID 34935)
-- Name: ENDDEV_PAYLOAD ENDDEV_PAYLOAD_enddev_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."ENDDEV_PAYLOAD"
    ADD CONSTRAINT "ENDDEV_PAYLOAD_enddev_id_fkey" FOREIGN KEY (enddev_id) REFERENCES public."ENDDEV"(_id) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;


--
-- TOC entry 3488 (class 2606 OID 43025)
-- Name: ENDDEV ENDDEV_dev_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."ENDDEV"
    ADD CONSTRAINT "ENDDEV_dev_type_id_fkey" FOREIGN KEY (dev_type_id) REFERENCES public."DEVTYPE"(_id) NOT VALID;


--
-- TOC entry 3490 (class 2606 OID 34950)
-- Name: NOTIFY NOTIFY_noti_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."NOTIFY"
    ADD CONSTRAINT "NOTIFY_noti_id_fkey" FOREIGN KEY (noti_id) REFERENCES public."NOTIFICATION"(_id) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;


--
-- TOC entry 3491 (class 2606 OID 34955)
-- Name: NOTIFY NOTIFY_profile_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."NOTIFY"
    ADD CONSTRAINT "NOTIFY_profile_id_fkey" FOREIGN KEY (profile_id) REFERENCES public."PROFILE"(_id) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;


--
-- TOC entry 3492 (class 2606 OID 34960)
-- Name: OWN OWN_enddev_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."OWN"
    ADD CONSTRAINT "OWN_enddev_id_fkey" FOREIGN KEY (enddev_id) REFERENCES public."ENDDEV"(_id) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;


--
-- TOC entry 3493 (class 2606 OID 34965)
-- Name: OWN OWN_profile_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."OWN"
    ADD CONSTRAINT "OWN_profile_id_fkey" FOREIGN KEY (profile_id) REFERENCES public."CUSTOMER"(profile_id) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;


--
-- TOC entry 3494 (class 2606 OID 34970)
-- Name: SENSOR SENSOR_enddev_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."SENSOR"
    ADD CONSTRAINT "SENSOR_enddev_id_fkey" FOREIGN KEY (enddev_id) REFERENCES public."ENDDEV"(_id) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;


--
-- TOC entry 3495 (class 2606 OID 34975)
-- Name: WIDGET WIDGET_board_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."WIDGET"
    ADD CONSTRAINT "WIDGET_board_id_fkey" FOREIGN KEY (board_id) REFERENCES public."BOARD"(_id) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;


--
-- TOC entry 3496 (class 2606 OID 43041)
-- Name: WIDGET WIDGET_widget_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."WIDGET"
    ADD CONSTRAINT "WIDGET_widget_type_id_fkey" FOREIGN KEY (widget_type_id) REFERENCES public."WIDGET_TYPE"(_id) NOT VALID;


-- Completed on 2022-01-02 09:08:58 UTC

--
-- PostgreSQL database dump complete
--

