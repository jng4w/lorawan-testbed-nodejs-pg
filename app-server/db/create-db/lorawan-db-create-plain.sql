--
-- PostgreSQL database dump
--

-- Dumped from database version 12.8
-- Dumped by pg_dump version 12.9

-- Started on 2021-12-25 15:04:26 UTC

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

SET default_tablespace = '';

SET default_table_access_method = heap;

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
-- TOC entry 3371 (class 0 OID 0)
-- Dependencies: 264
-- Name: WIDGET_widget_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE public."WIDGET_widget_id_seq" OWNED BY public."WIDGET".widget_id;


--
-- TOC entry 3223 (class 2604 OID 34635)
-- Name: WIDGET widget_id; Type: DEFAULT; Schema: public; Owner: root
--

ALTER TABLE ONLY public."WIDGET" ALTER COLUMN widget_id SET DEFAULT nextval('public."WIDGET_widget_id_seq"'::regclass);


--
-- TOC entry 3365 (class 0 OID 34632)
-- Dependencies: 265
-- Data for Name: WIDGET; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public."WIDGET" (widget_id, display_name, config_dict, board_id) FROM stdin;
\.


--
-- TOC entry 3372 (class 0 OID 0)
-- Dependencies: 264
-- Name: WIDGET_widget_id_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('public."WIDGET_widget_id_seq"', 1, false);


--
-- TOC entry 3225 (class 2606 OID 34640)
-- Name: WIDGET WIDGET_pkey; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public."WIDGET"
    ADD CONSTRAINT "WIDGET_pkey" PRIMARY KEY (widget_id);


--
-- TOC entry 3226 (class 2606 OID 34641)
-- Name: WIDGET WIDGET_board_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public."WIDGET"
    ADD CONSTRAINT "WIDGET_board_id_fkey" FOREIGN KEY (board_id) REFERENCES public."BOARD"(board_id) ON UPDATE CASCADE ON DELETE CASCADE;


-- Completed on 2021-12-25 15:04:26 UTC

--
-- PostgreSQL database dump complete
--

