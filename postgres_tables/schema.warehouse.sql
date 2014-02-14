--
-- PostgreSQL database dump
--

-- Dumped from database version 9.3.2
-- Dumped by pg_dump version 9.3.2
-- Started on 2014-02-14 22:09:11

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- TOC entry 7 (class 2615 OID 2200)
-- Name: warehouse; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA warehouse;


ALTER SCHEMA warehouse OWNER TO postgres;

--
-- TOC entry 3292 (class 0 OID 0)
-- Dependencies: 7
-- Name: SCHEMA warehouse; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA warehouse IS 'standard public schema';


SET search_path = warehouse, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- TOC entry 176 (class 1259 OID 16417)
-- Name: availability; Type: TABLE; Schema: warehouse; Owner: postgres; Tablespace: 
--

CREATE TABLE availability (
    availability_id integer NOT NULL,
    connected bit(1) NOT NULL,
    date_recorded timestamp without time zone NOT NULL,
    customer_id integer NOT NULL
);


ALTER TABLE warehouse.availability OWNER TO postgres;

--
-- TOC entry 175 (class 1259 OID 16415)
-- Name: availability_availability_id_seq; Type: SEQUENCE; Schema: warehouse; Owner: postgres
--

CREATE SEQUENCE availability_availability_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE warehouse.availability_availability_id_seq OWNER TO postgres;

--
-- TOC entry 3294 (class 0 OID 0)
-- Dependencies: 175
-- Name: availability_availability_id_seq; Type: SEQUENCE OWNED BY; Schema: warehouse; Owner: postgres
--

ALTER SEQUENCE availability_availability_id_seq OWNED BY availability.availability_id;


--
-- TOC entry 172 (class 1259 OID 16396)
-- Name: customer; Type: TABLE; Schema: warehouse; Owner: postgres; Tablespace: 
--

CREATE TABLE customer (
    customer_id integer NOT NULL,
    first_name character varying NOT NULL,
    last_name character varying NOT NULL
);


ALTER TABLE warehouse.customer OWNER TO postgres;

--
-- TOC entry 177 (class 1259 OID 16421)
-- Name: customer_contact; Type: TABLE; Schema: warehouse; Owner: postgres; Tablespace: 
--

CREATE TABLE customer_contact (
    contact_customer_id integer NOT NULL,
    display_name character varying NOT NULL,
    phone_number character varying NOT NULL,
    customer_id integer NOT NULL
);


ALTER TABLE warehouse.customer_contact OWNER TO postgres;

--
-- TOC entry 171 (class 1259 OID 16394)
-- Name: customer_customer_id_seq; Type: SEQUENCE; Schema: warehouse; Owner: postgres
--

CREATE SEQUENCE customer_customer_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE warehouse.customer_customer_id_seq OWNER TO postgres;

--
-- TOC entry 3295 (class 0 OID 0)
-- Dependencies: 171
-- Name: customer_customer_id_seq; Type: SEQUENCE OWNED BY; Schema: warehouse; Owner: postgres
--

ALTER SEQUENCE customer_customer_id_seq OWNED BY customer.customer_id;


--
-- TOC entry 174 (class 1259 OID 16405)
-- Name: position; Type: TABLE; Schema: warehouse; Owner: postgres; Tablespace: 
--

CREATE TABLE "position" (
    position_id integer NOT NULL,
    longitude double precision NOT NULL,
    latitude double precision NOT NULL,
    altitude double precision NOT NULL,
    accuracy real,
    date_recorded timestamp without time zone NOT NULL,
    customer_id integer NOT NULL,
    altitude_accuracy real,
    heading real,
    heading_accouracy real
);


ALTER TABLE warehouse."position" OWNER TO postgres;

--
-- TOC entry 173 (class 1259 OID 16403)
-- Name: position_position_id_seq; Type: SEQUENCE; Schema: warehouse; Owner: postgres
--

CREATE SEQUENCE position_position_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE warehouse.position_position_id_seq OWNER TO postgres;

--
-- TOC entry 3296 (class 0 OID 0)
-- Dependencies: 173
-- Name: position_position_id_seq; Type: SEQUENCE OWNED BY; Schema: warehouse; Owner: postgres
--

ALTER SEQUENCE position_position_id_seq OWNED BY "position".position_id;


--
-- TOC entry 3160 (class 2604 OID 26186)
-- Name: availability_id; Type: DEFAULT; Schema: warehouse; Owner: postgres
--

ALTER TABLE ONLY availability ALTER COLUMN availability_id SET DEFAULT nextval('availability_availability_id_seq'::regclass);


--
-- TOC entry 3158 (class 2604 OID 26210)
-- Name: customer_id; Type: DEFAULT; Schema: warehouse; Owner: postgres
--

ALTER TABLE ONLY customer ALTER COLUMN customer_id SET DEFAULT nextval('customer_customer_id_seq'::regclass);


--
-- TOC entry 3159 (class 2604 OID 26214)
-- Name: position_id; Type: DEFAULT; Schema: warehouse; Owner: postgres
--

ALTER TABLE ONLY "position" ALTER COLUMN position_id SET DEFAULT nextval('position_position_id_seq'::regclass);


--
-- TOC entry 3167 (class 2606 OID 26185)
-- Name: availability_availability_id; Type: CONSTRAINT; Schema: warehouse; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY availability
    ADD CONSTRAINT availability_availability_id PRIMARY KEY (availability_id);


--
-- TOC entry 3169 (class 2606 OID 16451)
-- Name: customer_contact_contact_customer_id_customer_id; Type: CONSTRAINT; Schema: warehouse; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY customer_contact
    ADD CONSTRAINT customer_contact_contact_customer_id_customer_id PRIMARY KEY (contact_customer_id, customer_id);


--
-- TOC entry 3163 (class 2606 OID 26189)
-- Name: customer_customer_id; Type: CONSTRAINT; Schema: warehouse; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY customer
    ADD CONSTRAINT customer_customer_id PRIMARY KEY (customer_id);


--
-- TOC entry 3165 (class 2606 OID 26213)
-- Name: position_position_id; Type: CONSTRAINT; Schema: warehouse; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY "position"
    ADD CONSTRAINT position_position_id PRIMARY KEY (position_id);


--
-- TOC entry 3171 (class 2606 OID 26205)
-- Name: availability_customer_id_fkey; Type: FK CONSTRAINT; Schema: warehouse; Owner: postgres
--

ALTER TABLE ONLY availability
    ADD CONSTRAINT availability_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES customer(customer_id);


--
-- TOC entry 3173 (class 2606 OID 26195)
-- Name: customer_contact_contact_customer_id_fkey; Type: FK CONSTRAINT; Schema: warehouse; Owner: postgres
--

ALTER TABLE ONLY customer_contact
    ADD CONSTRAINT customer_contact_contact_customer_id_fkey FOREIGN KEY (contact_customer_id) REFERENCES customer(customer_id);


--
-- TOC entry 3172 (class 2606 OID 26190)
-- Name: customer_contact_customer_id_fkey; Type: FK CONSTRAINT; Schema: warehouse; Owner: postgres
--

ALTER TABLE ONLY customer_contact
    ADD CONSTRAINT customer_contact_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES customer(customer_id);


--
-- TOC entry 3170 (class 2606 OID 26200)
-- Name: position_customer_id_fkey; Type: FK CONSTRAINT; Schema: warehouse; Owner: postgres
--

ALTER TABLE ONLY "position"
    ADD CONSTRAINT position_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES customer(customer_id);


--
-- TOC entry 3293 (class 0 OID 0)
-- Dependencies: 7
-- Name: warehouse; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA warehouse FROM PUBLIC;
REVOKE ALL ON SCHEMA warehouse FROM postgres;
GRANT ALL ON SCHEMA warehouse TO postgres;
GRANT ALL ON SCHEMA warehouse TO PUBLIC;


-- Completed on 2014-02-14 22:09:11

--
-- PostgreSQL database dump complete
--

