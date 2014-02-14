--
-- PostgreSQL database dump
--

-- Dumped from database version 9.3.2
-- Dumped by pg_dump version 9.3.2
-- Started on 2014-02-14 22:08:29

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- TOC entry 6 (class 2615 OID 25871)
-- Name: mobile; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA mobile;


ALTER SCHEMA mobile OWNER TO postgres;

SET search_path = mobile, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- TOC entry 194 (class 1259 OID 25900)
-- Name: ap; Type: TABLE; Schema: mobile; Owner: postgres; Tablespace: 
--

CREATE TABLE ap (
    ap_id integer NOT NULL,
    lounge_id integer NOT NULL,
    code character varying(50) NOT NULL,
    x_position real NOT NULL,
    y_position real NOT NULL,
    z_position real NOT NULL,
    type character varying(50) NOT NULL,
    mac macaddr NOT NULL,
    ssid character varying(50) NOT NULL
);


ALTER TABLE mobile.ap OWNER TO postgres;

--
-- TOC entry 3349 (class 0 OID 0)
-- Dependencies: 194
-- Name: COLUMN ap.x_position; Type: COMMENT; Schema: mobile; Owner: postgres
--

COMMENT ON COLUMN ap.x_position IS 'relativní x pozice ap v hale (vyjádření v jednotkové stupnici)';


--
-- TOC entry 3350 (class 0 OID 0)
-- Dependencies: 194
-- Name: COLUMN ap.y_position; Type: COMMENT; Schema: mobile; Owner: postgres
--

COMMENT ON COLUMN ap.y_position IS 'relativní y pozice ap v hale (vyjádření v jednotkové stupnici)';


--
-- TOC entry 3351 (class 0 OID 0)
-- Dependencies: 194
-- Name: COLUMN ap.z_position; Type: COMMENT; Schema: mobile; Owner: postgres
--

COMMENT ON COLUMN ap.z_position IS 'relativní z pozice ap v hale (vyjádření v jednotkové stupnici)';


--
-- TOC entry 193 (class 1259 OID 25898)
-- Name: ap_ap_id_seq; Type: SEQUENCE; Schema: mobile; Owner: postgres
--

CREATE SEQUENCE ap_ap_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE mobile.ap_ap_id_seq OWNER TO postgres;

--
-- TOC entry 3352 (class 0 OID 0)
-- Dependencies: 193
-- Name: ap_ap_id_seq; Type: SEQUENCE OWNED BY; Schema: mobile; Owner: postgres
--

ALTER SEQUENCE ap_ap_id_seq OWNED BY ap.ap_id;


--
-- TOC entry 196 (class 1259 OID 25908)
-- Name: ap_boost; Type: TABLE; Schema: mobile; Owner: postgres; Tablespace: 
--

CREATE TABLE ap_boost (
    ap_boost_id integer NOT NULL,
    ap_id integer NOT NULL,
    heading real NOT NULL,
    multiplier real NOT NULL
);


ALTER TABLE mobile.ap_boost OWNER TO postgres;

--
-- TOC entry 3353 (class 0 OID 0)
-- Dependencies: 196
-- Name: COLUMN ap_boost.heading; Type: COMMENT; Schema: mobile; Owner: postgres
--

COMMENT ON COLUMN ap_boost.heading IS 'světová strana s upravenou sílou signálu';


--
-- TOC entry 3354 (class 0 OID 0)
-- Dependencies: 196
-- Name: COLUMN ap_boost.multiplier; Type: COMMENT; Schema: mobile; Owner: postgres
--

COMMENT ON COLUMN ap_boost.multiplier IS 'násobitel síly signálu';


--
-- TOC entry 195 (class 1259 OID 25906)
-- Name: ap_boost_ap_boost_id_seq; Type: SEQUENCE; Schema: mobile; Owner: postgres
--

CREATE SEQUENCE ap_boost_ap_boost_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE mobile.ap_boost_ap_boost_id_seq OWNER TO postgres;

--
-- TOC entry 3355 (class 0 OID 0)
-- Dependencies: 195
-- Name: ap_boost_ap_boost_id_seq; Type: SEQUENCE OWNED BY; Schema: mobile; Owner: postgres
--

ALTER SEQUENCE ap_boost_ap_boost_id_seq OWNED BY ap_boost.ap_boost_id;


--
-- TOC entry 192 (class 1259 OID 25874)
-- Name: ap_log; Type: TABLE; Schema: mobile; Owner: postgres; Tablespace: 
--

CREATE TABLE ap_log (
    ap_log_id integer NOT NULL,
    ap_code character varying(50) NOT NULL,
    date_access timestamp without time zone NOT NULL,
    role character varying(50) NOT NULL,
    mac_hash character varying(50) NOT NULL,
    type character varying(50) NOT NULL
);


ALTER TABLE mobile.ap_log OWNER TO postgres;

--
-- TOC entry 3356 (class 0 OID 0)
-- Dependencies: 192
-- Name: COLUMN ap_log.ap_code; Type: COMMENT; Schema: mobile; Owner: postgres
--

COMMENT ON COLUMN ap_log.ap_code IS 'kód ap wifi routeru';


--
-- TOC entry 3357 (class 0 OID 0)
-- Dependencies: 192
-- Name: COLUMN ap_log.date_access; Type: COMMENT; Schema: mobile; Owner: postgres
--

COMMENT ON COLUMN ap_log.date_access IS 'datum pořízení logu';


--
-- TOC entry 3358 (class 0 OID 0)
-- Dependencies: 192
-- Name: COLUMN ap_log.role; Type: COMMENT; Schema: mobile; Owner: postgres
--

COMMENT ON COLUMN ap_log.role IS 'Role ve které zařízení vystupuje. Zatím pouze Client';


--
-- TOC entry 3359 (class 0 OID 0)
-- Dependencies: 192
-- Name: COLUMN ap_log.mac_hash; Type: COMMENT; Schema: mobile; Owner: postgres
--

COMMENT ON COLUMN ap_log.mac_hash IS 'zahashovaná mac adresa zařízení';


--
-- TOC entry 3360 (class 0 OID 0)
-- Dependencies: 192
-- Name: COLUMN ap_log.type; Type: COMMENT; Schema: mobile; Owner: postgres
--

COMMENT ON COLUMN ap_log.type IS 'typ záznamu. připojen, odpojen z ap';


--
-- TOC entry 191 (class 1259 OID 25872)
-- Name: ap_log_ap_log_id_seq; Type: SEQUENCE; Schema: mobile; Owner: postgres
--

CREATE SEQUENCE ap_log_ap_log_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE mobile.ap_log_ap_log_id_seq OWNER TO postgres;

--
-- TOC entry 3361 (class 0 OID 0)
-- Dependencies: 191
-- Name: ap_log_ap_log_id_seq; Type: SEQUENCE OWNED BY; Schema: mobile; Owner: postgres
--

ALTER SEQUENCE ap_log_ap_log_id_seq OWNED BY ap_log.ap_log_id;


--
-- TOC entry 198 (class 1259 OID 25914)
-- Name: compass_log; Type: TABLE; Schema: mobile; Owner: postgres; Tablespace: 
--

CREATE TABLE compass_log (
    compass_log_id integer NOT NULL,
    device_id integer NOT NULL,
    heading real NOT NULL,
    accuracy real NOT NULL,
    date_recorded timestamp without time zone NOT NULL
);


ALTER TABLE mobile.compass_log OWNER TO postgres;

--
-- TOC entry 3362 (class 0 OID 0)
-- Dependencies: 198
-- Name: COLUMN compass_log.heading; Type: COMMENT; Schema: mobile; Owner: postgres
--

COMMENT ON COLUMN compass_log.heading IS 'natočení vůči severu';


--
-- TOC entry 3363 (class 0 OID 0)
-- Dependencies: 198
-- Name: COLUMN compass_log.accuracy; Type: COMMENT; Schema: mobile; Owner: postgres
--

COMMENT ON COLUMN compass_log.accuracy IS 'přesnost';


--
-- TOC entry 197 (class 1259 OID 25912)
-- Name: compass_log_compass_log_id_seq; Type: SEQUENCE; Schema: mobile; Owner: postgres
--

CREATE SEQUENCE compass_log_compass_log_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE mobile.compass_log_compass_log_id_seq OWNER TO postgres;

--
-- TOC entry 3364 (class 0 OID 0)
-- Dependencies: 197
-- Name: compass_log_compass_log_id_seq; Type: SEQUENCE OWNED BY; Schema: mobile; Owner: postgres
--

ALTER SEQUENCE compass_log_compass_log_id_seq OWNED BY compass_log.compass_log_id;


--
-- TOC entry 200 (class 1259 OID 25920)
-- Name: connectivity_log; Type: TABLE; Schema: mobile; Owner: postgres; Tablespace: 
--

CREATE TABLE connectivity_log (
    connectivity_log_id integer NOT NULL,
    device_id integer NOT NULL,
    type character varying(50) NOT NULL,
    value character varying(50) NOT NULL,
    date_recorded timestamp without time zone NOT NULL
);


ALTER TABLE mobile.connectivity_log OWNER TO postgres;

--
-- TOC entry 199 (class 1259 OID 25918)
-- Name: connectivity_log_connectivity_log_id_seq; Type: SEQUENCE; Schema: mobile; Owner: postgres
--

CREATE SEQUENCE connectivity_log_connectivity_log_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE mobile.connectivity_log_connectivity_log_id_seq OWNER TO postgres;

--
-- TOC entry 3365 (class 0 OID 0)
-- Dependencies: 199
-- Name: connectivity_log_connectivity_log_id_seq; Type: SEQUENCE OWNED BY; Schema: mobile; Owner: postgres
--

ALTER SEQUENCE connectivity_log_connectivity_log_id_seq OWNED BY connectivity_log.connectivity_log_id;


--
-- TOC entry 202 (class 1259 OID 25926)
-- Name: contact; Type: TABLE; Schema: mobile; Owner: postgres; Tablespace: 
--

CREATE TABLE contact (
    contact_id integer NOT NULL,
    name character varying(50) NOT NULL,
    phone_number character varying(50)
);


ALTER TABLE mobile.contact OWNER TO postgres;

--
-- TOC entry 201 (class 1259 OID 25924)
-- Name: contact_contact_id_seq; Type: SEQUENCE; Schema: mobile; Owner: postgres
--

CREATE SEQUENCE contact_contact_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE mobile.contact_contact_id_seq OWNER TO postgres;

--
-- TOC entry 3366 (class 0 OID 0)
-- Dependencies: 201
-- Name: contact_contact_id_seq; Type: SEQUENCE OWNED BY; Schema: mobile; Owner: postgres
--

ALTER SEQUENCE contact_contact_id_seq OWNED BY contact.contact_id;


--
-- TOC entry 204 (class 1259 OID 25932)
-- Name: device; Type: TABLE; Schema: mobile; Owner: postgres; Tablespace: 
--

CREATE TABLE device (
    device_id integer NOT NULL,
    mac macaddr NOT NULL,
    mac_hash character varying(50) NOT NULL,
    uuid character varying(50) NOT NULL,
    imei character varying(50) NOT NULL,
    platform character varying(50) NOT NULL,
    model character varying(50) NOT NULL
);


ALTER TABLE mobile.device OWNER TO postgres;

--
-- TOC entry 205 (class 1259 OID 25937)
-- Name: device_contact; Type: TABLE; Schema: mobile; Owner: postgres; Tablespace: 
--

CREATE TABLE device_contact (
    device_id integer NOT NULL,
    contact_id integer NOT NULL
);


ALTER TABLE mobile.device_contact OWNER TO postgres;

--
-- TOC entry 203 (class 1259 OID 25930)
-- Name: device_device_id_seq; Type: SEQUENCE; Schema: mobile; Owner: postgres
--

CREATE SEQUENCE device_device_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE mobile.device_device_id_seq OWNER TO postgres;

--
-- TOC entry 3367 (class 0 OID 0)
-- Dependencies: 203
-- Name: device_device_id_seq; Type: SEQUENCE OWNED BY; Schema: mobile; Owner: postgres
--

ALTER SEQUENCE device_device_id_seq OWNED BY device.device_id;


--
-- TOC entry 206 (class 1259 OID 25940)
-- Name: device_use_contact; Type: TABLE; Schema: mobile; Owner: postgres; Tablespace: 
--

CREATE TABLE device_use_contact (
    device_id integer NOT NULL,
    contact_id integer NOT NULL
);


ALTER TABLE mobile.device_use_contact OWNER TO postgres;

--
-- TOC entry 208 (class 1259 OID 25945)
-- Name: gps_log; Type: TABLE; Schema: mobile; Owner: postgres; Tablespace: 
--

CREATE TABLE gps_log (
    gps_log_id integer NOT NULL,
    device_id integer NOT NULL,
    longitude double precision NOT NULL,
    latitude double precision NOT NULL,
    altitude double precision NOT NULL,
    accuracy real NOT NULL,
    altitude_accuracy real NOT NULL,
    speed real NOT NULL,
    heading real NOT NULL,
    date_recorded timestamp without time zone NOT NULL
);


ALTER TABLE mobile.gps_log OWNER TO postgres;

--
-- TOC entry 207 (class 1259 OID 25943)
-- Name: gps_log_gps_log_id_seq; Type: SEQUENCE; Schema: mobile; Owner: postgres
--

CREATE SEQUENCE gps_log_gps_log_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE mobile.gps_log_gps_log_id_seq OWNER TO postgres;

--
-- TOC entry 3368 (class 0 OID 0)
-- Dependencies: 207
-- Name: gps_log_gps_log_id_seq; Type: SEQUENCE OWNED BY; Schema: mobile; Owner: postgres
--

ALTER SEQUENCE gps_log_gps_log_id_seq OWNED BY gps_log.gps_log_id;


--
-- TOC entry 210 (class 1259 OID 25951)
-- Name: identity; Type: TABLE; Schema: mobile; Owner: postgres; Tablespace: 
--

CREATE TABLE identity (
    identity_id integer NOT NULL,
    first_name character varying(50) NOT NULL,
    last_name character varying(50) NOT NULL
);


ALTER TABLE mobile.identity OWNER TO postgres;

--
-- TOC entry 211 (class 1259 OID 25955)
-- Name: identity_has_device; Type: TABLE; Schema: mobile; Owner: postgres; Tablespace: 
--

CREATE TABLE identity_has_device (
    identity_id integer NOT NULL,
    device_id integer NOT NULL
);


ALTER TABLE mobile.identity_has_device OWNER TO postgres;

--
-- TOC entry 209 (class 1259 OID 25949)
-- Name: identity_identity_id_seq; Type: SEQUENCE; Schema: mobile; Owner: postgres
--

CREATE SEQUENCE identity_identity_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE mobile.identity_identity_id_seq OWNER TO postgres;

--
-- TOC entry 3369 (class 0 OID 0)
-- Dependencies: 209
-- Name: identity_identity_id_seq; Type: SEQUENCE OWNED BY; Schema: mobile; Owner: postgres
--

ALTER SEQUENCE identity_identity_id_seq OWNED BY identity.identity_id;


--
-- TOC entry 213 (class 1259 OID 25960)
-- Name: image; Type: TABLE; Schema: mobile; Owner: postgres; Tablespace: 
--

CREATE TABLE image (
    image_id integer NOT NULL,
    file_path character varying(255),
    base64 text,
    width integer,
    height integer,
    mime_type character varying(50)
);


ALTER TABLE mobile.image OWNER TO postgres;

--
-- TOC entry 3370 (class 0 OID 0)
-- Dependencies: 213
-- Name: COLUMN image.file_path; Type: COMMENT; Schema: mobile; Owner: postgres
--

COMMENT ON COLUMN image.file_path IS 'relativní či absolutní cesta nebo uri';


--
-- TOC entry 3371 (class 0 OID 0)
-- Dependencies: 213
-- Name: COLUMN image.base64; Type: COMMENT; Schema: mobile; Owner: postgres
--

COMMENT ON COLUMN image.base64 IS 'vyjádření obrázku v kódování base64';


--
-- TOC entry 3372 (class 0 OID 0)
-- Dependencies: 213
-- Name: COLUMN image.width; Type: COMMENT; Schema: mobile; Owner: postgres
--

COMMENT ON COLUMN image.width IS 'px';


--
-- TOC entry 3373 (class 0 OID 0)
-- Dependencies: 213
-- Name: COLUMN image.height; Type: COMMENT; Schema: mobile; Owner: postgres
--

COMMENT ON COLUMN image.height IS 'px';


--
-- TOC entry 212 (class 1259 OID 25958)
-- Name: image_image_id_seq; Type: SEQUENCE; Schema: mobile; Owner: postgres
--

CREATE SEQUENCE image_image_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE mobile.image_image_id_seq OWNER TO postgres;

--
-- TOC entry 3374 (class 0 OID 0)
-- Dependencies: 212
-- Name: image_image_id_seq; Type: SEQUENCE OWNED BY; Schema: mobile; Owner: postgres
--

ALTER SEQUENCE image_image_id_seq OWNED BY image.image_id;


--
-- TOC entry 215 (class 1259 OID 25969)
-- Name: lounge; Type: TABLE; Schema: mobile; Owner: postgres; Tablespace: 
--

CREATE TABLE lounge (
    lounge_id integer NOT NULL,
    name character varying(50),
    code character varying(50) NOT NULL,
    type character varying(50) NOT NULL,
    x_length real,
    y_length real,
    z_length real,
    heading real,
    latitude double precision,
    longitude double precision,
    altitude double precision,
    aspect_ratio real NOT NULL,
    image_id integer,
    floor integer
);


ALTER TABLE mobile.lounge OWNER TO postgres;

--
-- TOC entry 3375 (class 0 OID 0)
-- Dependencies: 215
-- Name: COLUMN lounge.x_length; Type: COMMENT; Schema: mobile; Owner: postgres
--

COMMENT ON COLUMN lounge.x_length IS 'šířka haly v metrech';


--
-- TOC entry 3376 (class 0 OID 0)
-- Dependencies: 215
-- Name: COLUMN lounge.y_length; Type: COMMENT; Schema: mobile; Owner: postgres
--

COMMENT ON COLUMN lounge.y_length IS 'délka haly v metrech';


--
-- TOC entry 3377 (class 0 OID 0)
-- Dependencies: 215
-- Name: COLUMN lounge.z_length; Type: COMMENT; Schema: mobile; Owner: postgres
--

COMMENT ON COLUMN lounge.z_length IS 'výška haly v metrech';


--
-- TOC entry 3378 (class 0 OID 0)
-- Dependencies: 215
-- Name: COLUMN lounge.heading; Type: COMMENT; Schema: mobile; Owner: postgres
--

COMMENT ON COLUMN lounge.heading IS 'natočení haly vůči severu v radiánech';


--
-- TOC entry 3379 (class 0 OID 0)
-- Dependencies: 215
-- Name: COLUMN lounge.latitude; Type: COMMENT; Schema: mobile; Owner: postgres
--

COMMENT ON COLUMN lounge.latitude IS 'zeměpisná šířka středu haly';


--
-- TOC entry 3380 (class 0 OID 0)
-- Dependencies: 215
-- Name: COLUMN lounge.longitude; Type: COMMENT; Schema: mobile; Owner: postgres
--

COMMENT ON COLUMN lounge.longitude IS 'zeměpisná délka středu haly';


--
-- TOC entry 3381 (class 0 OID 0)
-- Dependencies: 215
-- Name: COLUMN lounge.altitude; Type: COMMENT; Schema: mobile; Owner: postgres
--

COMMENT ON COLUMN lounge.altitude IS 'zeměpisná výška středu haly';


--
-- TOC entry 3382 (class 0 OID 0)
-- Dependencies: 215
-- Name: COLUMN lounge.aspect_ratio; Type: COMMENT; Schema: mobile; Owner: postgres
--

COMMENT ON COLUMN lounge.aspect_ratio IS 'poměr stran x/y (duplikace z x_length/y_length pokud jsou zadané)';


--
-- TOC entry 3383 (class 0 OID 0)
-- Dependencies: 215
-- Name: COLUMN lounge.image_id; Type: COMMENT; Schema: mobile; Owner: postgres
--

COMMENT ON COLUMN lounge.image_id IS 'obrázek půdorysu haly';


--
-- TOC entry 3384 (class 0 OID 0)
-- Dependencies: 215
-- Name: COLUMN lounge.floor; Type: COMMENT; Schema: mobile; Owner: postgres
--

COMMENT ON COLUMN lounge.floor IS 'patro haly v budově';


--
-- TOC entry 214 (class 1259 OID 25967)
-- Name: lounge_lounge_id_seq; Type: SEQUENCE; Schema: mobile; Owner: postgres
--

CREATE SEQUENCE lounge_lounge_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE mobile.lounge_lounge_id_seq OWNER TO postgres;

--
-- TOC entry 3385 (class 0 OID 0)
-- Dependencies: 214
-- Name: lounge_lounge_id_seq; Type: SEQUENCE OWNED BY; Schema: mobile; Owner: postgres
--

ALTER SEQUENCE lounge_lounge_id_seq OWNED BY lounge.lounge_id;


--
-- TOC entry 217 (class 1259 OID 25975)
-- Name: wifi_log; Type: TABLE; Schema: mobile; Owner: postgres; Tablespace: 
--

CREATE TABLE wifi_log (
    wifi_log_id integer NOT NULL,
    device_id integer NOT NULL,
    date_recorded timestamp without time zone NOT NULL
);


ALTER TABLE mobile.wifi_log OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 25981)
-- Name: wifi_log_ap; Type: TABLE; Schema: mobile; Owner: postgres; Tablespace: 
--

CREATE TABLE wifi_log_ap (
    wifi_log_ap_id integer NOT NULL,
    wifi_log_id integer NOT NULL,
    mac macaddr NOT NULL,
    ssid character varying(50) NOT NULL,
    signal_strength real NOT NULL
);


ALTER TABLE mobile.wifi_log_ap OWNER TO postgres;

--
-- TOC entry 3386 (class 0 OID 0)
-- Dependencies: 219
-- Name: COLUMN wifi_log_ap.signal_strength; Type: COMMENT; Schema: mobile; Owner: postgres
--

COMMENT ON COLUMN wifi_log_ap.signal_strength IS 'síla signálu v dBm, 100% = -35, 1% = -95';


--
-- TOC entry 218 (class 1259 OID 25979)
-- Name: wifi_log_ap_wifi_log_ap_id_seq; Type: SEQUENCE; Schema: mobile; Owner: postgres
--

CREATE SEQUENCE wifi_log_ap_wifi_log_ap_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE mobile.wifi_log_ap_wifi_log_ap_id_seq OWNER TO postgres;

--
-- TOC entry 3387 (class 0 OID 0)
-- Dependencies: 218
-- Name: wifi_log_ap_wifi_log_ap_id_seq; Type: SEQUENCE OWNED BY; Schema: mobile; Owner: postgres
--

ALTER SEQUENCE wifi_log_ap_wifi_log_ap_id_seq OWNED BY wifi_log_ap.wifi_log_ap_id;


--
-- TOC entry 216 (class 1259 OID 25973)
-- Name: wifi_log_wifi_log_id_seq; Type: SEQUENCE; Schema: mobile; Owner: postgres
--

CREATE SEQUENCE wifi_log_wifi_log_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE mobile.wifi_log_wifi_log_id_seq OWNER TO postgres;

--
-- TOC entry 3388 (class 0 OID 0)
-- Dependencies: 216
-- Name: wifi_log_wifi_log_id_seq; Type: SEQUENCE OWNED BY; Schema: mobile; Owner: postgres
--

ALTER SEQUENCE wifi_log_wifi_log_id_seq OWNED BY wifi_log.wifi_log_id;


--
-- TOC entry 3139 (class 2604 OID 25903)
-- Name: ap_id; Type: DEFAULT; Schema: mobile; Owner: postgres
--

ALTER TABLE ONLY ap ALTER COLUMN ap_id SET DEFAULT nextval('ap_ap_id_seq'::regclass);


--
-- TOC entry 3140 (class 2604 OID 25911)
-- Name: ap_boost_id; Type: DEFAULT; Schema: mobile; Owner: postgres
--

ALTER TABLE ONLY ap_boost ALTER COLUMN ap_boost_id SET DEFAULT nextval('ap_boost_ap_boost_id_seq'::regclass);


--
-- TOC entry 3138 (class 2604 OID 25877)
-- Name: ap_log_id; Type: DEFAULT; Schema: mobile; Owner: postgres
--

ALTER TABLE ONLY ap_log ALTER COLUMN ap_log_id SET DEFAULT nextval('ap_log_ap_log_id_seq'::regclass);


--
-- TOC entry 3141 (class 2604 OID 25917)
-- Name: compass_log_id; Type: DEFAULT; Schema: mobile; Owner: postgres
--

ALTER TABLE ONLY compass_log ALTER COLUMN compass_log_id SET DEFAULT nextval('compass_log_compass_log_id_seq'::regclass);


--
-- TOC entry 3142 (class 2604 OID 25923)
-- Name: connectivity_log_id; Type: DEFAULT; Schema: mobile; Owner: postgres
--

ALTER TABLE ONLY connectivity_log ALTER COLUMN connectivity_log_id SET DEFAULT nextval('connectivity_log_connectivity_log_id_seq'::regclass);


--
-- TOC entry 3143 (class 2604 OID 25929)
-- Name: contact_id; Type: DEFAULT; Schema: mobile; Owner: postgres
--

ALTER TABLE ONLY contact ALTER COLUMN contact_id SET DEFAULT nextval('contact_contact_id_seq'::regclass);


--
-- TOC entry 3144 (class 2604 OID 25935)
-- Name: device_id; Type: DEFAULT; Schema: mobile; Owner: postgres
--

ALTER TABLE ONLY device ALTER COLUMN device_id SET DEFAULT nextval('device_device_id_seq'::regclass);


--
-- TOC entry 3145 (class 2604 OID 25948)
-- Name: gps_log_id; Type: DEFAULT; Schema: mobile; Owner: postgres
--

ALTER TABLE ONLY gps_log ALTER COLUMN gps_log_id SET DEFAULT nextval('gps_log_gps_log_id_seq'::regclass);


--
-- TOC entry 3146 (class 2604 OID 25954)
-- Name: identity_id; Type: DEFAULT; Schema: mobile; Owner: postgres
--

ALTER TABLE ONLY identity ALTER COLUMN identity_id SET DEFAULT nextval('identity_identity_id_seq'::regclass);


--
-- TOC entry 3147 (class 2604 OID 25963)
-- Name: image_id; Type: DEFAULT; Schema: mobile; Owner: postgres
--

ALTER TABLE ONLY image ALTER COLUMN image_id SET DEFAULT nextval('image_image_id_seq'::regclass);


--
-- TOC entry 3148 (class 2604 OID 25972)
-- Name: lounge_id; Type: DEFAULT; Schema: mobile; Owner: postgres
--

ALTER TABLE ONLY lounge ALTER COLUMN lounge_id SET DEFAULT nextval('lounge_lounge_id_seq'::regclass);


--
-- TOC entry 3149 (class 2604 OID 25978)
-- Name: wifi_log_id; Type: DEFAULT; Schema: mobile; Owner: postgres
--

ALTER TABLE ONLY wifi_log ALTER COLUMN wifi_log_id SET DEFAULT nextval('wifi_log_wifi_log_id_seq'::regclass);


--
-- TOC entry 3150 (class 2604 OID 25984)
-- Name: wifi_log_ap_id; Type: DEFAULT; Schema: mobile; Owner: postgres
--

ALTER TABLE ONLY wifi_log_ap ALTER COLUMN wifi_log_ap_id SET DEFAULT nextval('wifi_log_ap_wifi_log_ap_id_seq'::regclass);


--
-- TOC entry 3158 (class 2606 OID 25988)
-- Name: ap_ap_id; Type: CONSTRAINT; Schema: mobile; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY ap
    ADD CONSTRAINT ap_ap_id PRIMARY KEY (ap_id);


--
-- TOC entry 3165 (class 2606 OID 26005)
-- Name: ap_boost_ap_boost_id; Type: CONSTRAINT; Schema: mobile; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY ap_boost
    ADD CONSTRAINT ap_boost_ap_boost_id PRIMARY KEY (ap_boost_id);


--
-- TOC entry 3160 (class 2606 OID 25990)
-- Name: ap_code; Type: CONSTRAINT; Schema: mobile; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY ap
    ADD CONSTRAINT ap_code UNIQUE (code);


--
-- TOC entry 3153 (class 2606 OID 25986)
-- Name: ap_log_ap_code_date_access_role_mac_hash_type; Type: CONSTRAINT; Schema: mobile; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY ap_log
    ADD CONSTRAINT ap_log_ap_code_date_access_role_mac_hash_type UNIQUE (ap_code, date_access, role, mac_hash, type);


--
-- TOC entry 3155 (class 2606 OID 25884)
-- Name: ap_log_ap_log_id; Type: CONSTRAINT; Schema: mobile; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY ap_log
    ADD CONSTRAINT ap_log_ap_log_id PRIMARY KEY (ap_log_id);


--
-- TOC entry 3163 (class 2606 OID 25992)
-- Name: ap_mac; Type: CONSTRAINT; Schema: mobile; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY ap
    ADD CONSTRAINT ap_mac UNIQUE (mac);


--
-- TOC entry 3168 (class 2606 OID 26015)
-- Name: compass_log_compass_log_id; Type: CONSTRAINT; Schema: mobile; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY compass_log
    ADD CONSTRAINT compass_log_compass_log_id PRIMARY KEY (compass_log_id);


--
-- TOC entry 3171 (class 2606 OID 26025)
-- Name: connectivity_log_connectivity_log_id; Type: CONSTRAINT; Schema: mobile; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY connectivity_log
    ADD CONSTRAINT connectivity_log_connectivity_log_id PRIMARY KEY (connectivity_log_id);


--
-- TOC entry 3174 (class 2606 OID 26033)
-- Name: contact_contact_id; Type: CONSTRAINT; Schema: mobile; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY contact
    ADD CONSTRAINT contact_contact_id PRIMARY KEY (contact_id);


--
-- TOC entry 3176 (class 2606 OID 26035)
-- Name: contact_phone_number; Type: CONSTRAINT; Schema: mobile; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY contact
    ADD CONSTRAINT contact_phone_number UNIQUE (phone_number);


--
-- TOC entry 3188 (class 2606 OID 26043)
-- Name: device_contact_device_id_contact_id; Type: CONSTRAINT; Schema: mobile; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY device_contact
    ADD CONSTRAINT device_contact_device_id_contact_id PRIMARY KEY (device_id, contact_id);


--
-- TOC entry 3178 (class 2606 OID 26018)
-- Name: device_device_id; Type: CONSTRAINT; Schema: mobile; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY device
    ADD CONSTRAINT device_device_id PRIMARY KEY (device_id);


--
-- TOC entry 3180 (class 2606 OID 26041)
-- Name: device_imei; Type: CONSTRAINT; Schema: mobile; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY device
    ADD CONSTRAINT device_imei UNIQUE (imei);


--
-- TOC entry 3182 (class 2606 OID 26037)
-- Name: device_mac_hash; Type: CONSTRAINT; Schema: mobile; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY device
    ADD CONSTRAINT device_mac_hash UNIQUE (mac_hash);


--
-- TOC entry 3192 (class 2606 OID 26057)
-- Name: device_use_contact_device_id_contact_id; Type: CONSTRAINT; Schema: mobile; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY device_use_contact
    ADD CONSTRAINT device_use_contact_device_id_contact_id PRIMARY KEY (device_id, contact_id);


--
-- TOC entry 3184 (class 2606 OID 26039)
-- Name: device_uuid; Type: CONSTRAINT; Schema: mobile; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY device
    ADD CONSTRAINT device_uuid UNIQUE (uuid);


--
-- TOC entry 3195 (class 2606 OID 26071)
-- Name: gps_log_gps_log_id; Type: CONSTRAINT; Schema: mobile; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY gps_log
    ADD CONSTRAINT gps_log_gps_log_id PRIMARY KEY (gps_log_id);


--
-- TOC entry 3201 (class 2606 OID 26081)
-- Name: identity_has_device_identity_id_device_id; Type: CONSTRAINT; Schema: mobile; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY identity_has_device
    ADD CONSTRAINT identity_has_device_identity_id_device_id PRIMARY KEY (identity_id, device_id);


--
-- TOC entry 3197 (class 2606 OID 26079)
-- Name: identity_identity_id; Type: CONSTRAINT; Schema: mobile; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY identity
    ADD CONSTRAINT identity_identity_id PRIMARY KEY (identity_id);


--
-- TOC entry 3203 (class 2606 OID 26095)
-- Name: image_image_id; Type: CONSTRAINT; Schema: mobile; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY image
    ADD CONSTRAINT image_image_id PRIMARY KEY (image_id);


--
-- TOC entry 3205 (class 2606 OID 25997)
-- Name: lounge_code; Type: CONSTRAINT; Schema: mobile; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY lounge
    ADD CONSTRAINT lounge_code UNIQUE (code);


--
-- TOC entry 3208 (class 2606 OID 25995)
-- Name: lounge_lounge_id; Type: CONSTRAINT; Schema: mobile; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY lounge
    ADD CONSTRAINT lounge_lounge_id PRIMARY KEY (lounge_id);


--
-- TOC entry 3215 (class 2606 OID 26116)
-- Name: wifi_log_ap_wifi_log_ap_id; Type: CONSTRAINT; Schema: mobile; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY wifi_log_ap
    ADD CONSTRAINT wifi_log_ap_wifi_log_ap_id PRIMARY KEY (wifi_log_ap_id);


--
-- TOC entry 3211 (class 2606 OID 26108)
-- Name: wifi_log_wifi_log_id; Type: CONSTRAINT; Schema: mobile; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY wifi_log
    ADD CONSTRAINT wifi_log_wifi_log_id PRIMARY KEY (wifi_log_id);


--
-- TOC entry 3166 (class 1259 OID 26006)
-- Name: ap_boost_ap_id; Type: INDEX; Schema: mobile; Owner: postgres; Tablespace: 
--

CREATE INDEX ap_boost_ap_id ON ap_boost USING btree (ap_id);


--
-- TOC entry 3151 (class 1259 OID 26012)
-- Name: ap_log_ap_code; Type: INDEX; Schema: mobile; Owner: postgres; Tablespace: 
--

CREATE INDEX ap_log_ap_code ON ap_log USING btree (ap_code);


--
-- TOC entry 3156 (class 1259 OID 26013)
-- Name: ap_log_mac_hash; Type: INDEX; Schema: mobile; Owner: postgres; Tablespace: 
--

CREATE INDEX ap_log_mac_hash ON ap_log USING btree (mac_hash);


--
-- TOC entry 3161 (class 1259 OID 25993)
-- Name: ap_lounge_id; Type: INDEX; Schema: mobile; Owner: postgres; Tablespace: 
--

CREATE INDEX ap_lounge_id ON ap USING btree (lounge_id);


--
-- TOC entry 3169 (class 1259 OID 26016)
-- Name: compass_log_device_id; Type: INDEX; Schema: mobile; Owner: postgres; Tablespace: 
--

CREATE INDEX compass_log_device_id ON compass_log USING btree (device_id);


--
-- TOC entry 3172 (class 1259 OID 26026)
-- Name: connectivity_log_device_id; Type: INDEX; Schema: mobile; Owner: postgres; Tablespace: 
--

CREATE INDEX connectivity_log_device_id ON connectivity_log USING btree (device_id);


--
-- TOC entry 3185 (class 1259 OID 26045)
-- Name: device_contact_contact_id; Type: INDEX; Schema: mobile; Owner: postgres; Tablespace: 
--

CREATE INDEX device_contact_contact_id ON device_contact USING btree (contact_id);


--
-- TOC entry 3186 (class 1259 OID 26044)
-- Name: device_contact_device_id; Type: INDEX; Schema: mobile; Owner: postgres; Tablespace: 
--

CREATE INDEX device_contact_device_id ON device_contact USING btree (device_id);


--
-- TOC entry 3189 (class 1259 OID 26059)
-- Name: device_use_contact_contact_id; Type: INDEX; Schema: mobile; Owner: postgres; Tablespace: 
--

CREATE INDEX device_use_contact_contact_id ON device_use_contact USING btree (contact_id);


--
-- TOC entry 3190 (class 1259 OID 26058)
-- Name: device_use_contact_device_id; Type: INDEX; Schema: mobile; Owner: postgres; Tablespace: 
--

CREATE INDEX device_use_contact_device_id ON device_use_contact USING btree (device_id);


--
-- TOC entry 3193 (class 1259 OID 26072)
-- Name: gps_log_device_id; Type: INDEX; Schema: mobile; Owner: postgres; Tablespace: 
--

CREATE INDEX gps_log_device_id ON gps_log USING btree (device_id);


--
-- TOC entry 3198 (class 1259 OID 26083)
-- Name: identity_has_device_device_id; Type: INDEX; Schema: mobile; Owner: postgres; Tablespace: 
--

CREATE INDEX identity_has_device_device_id ON identity_has_device USING btree (device_id);


--
-- TOC entry 3199 (class 1259 OID 26082)
-- Name: identity_has_device_identity_id; Type: INDEX; Schema: mobile; Owner: postgres; Tablespace: 
--

CREATE INDEX identity_has_device_identity_id ON identity_has_device USING btree (identity_id);


--
-- TOC entry 3206 (class 1259 OID 26101)
-- Name: lounge_image_id; Type: INDEX; Schema: mobile; Owner: postgres; Tablespace: 
--

CREATE INDEX lounge_image_id ON lounge USING btree (image_id);


--
-- TOC entry 3212 (class 1259 OID 26118)
-- Name: wifi_log_ap_mac; Type: INDEX; Schema: mobile; Owner: postgres; Tablespace: 
--

CREATE INDEX wifi_log_ap_mac ON wifi_log_ap USING btree (mac);


--
-- TOC entry 3213 (class 1259 OID 26119)
-- Name: wifi_log_ap_ssid; Type: INDEX; Schema: mobile; Owner: postgres; Tablespace: 
--

CREATE INDEX wifi_log_ap_ssid ON wifi_log_ap USING btree (ssid);


--
-- TOC entry 3216 (class 1259 OID 26117)
-- Name: wifi_log_ap_wifi_log_id; Type: INDEX; Schema: mobile; Owner: postgres; Tablespace: 
--

CREATE INDEX wifi_log_ap_wifi_log_id ON wifi_log_ap USING btree (wifi_log_id);


--
-- TOC entry 3209 (class 1259 OID 26109)
-- Name: wifi_log_device_id; Type: INDEX; Schema: mobile; Owner: postgres; Tablespace: 
--

CREATE INDEX wifi_log_device_id ON wifi_log USING btree (device_id);


--
-- TOC entry 3218 (class 2606 OID 26007)
-- Name: ap_boost_ap_id_fkey; Type: FK CONSTRAINT; Schema: mobile; Owner: postgres
--

ALTER TABLE ONLY ap_boost
    ADD CONSTRAINT ap_boost_ap_id_fkey FOREIGN KEY (ap_id) REFERENCES ap(ap_id);


--
-- TOC entry 3217 (class 2606 OID 25999)
-- Name: ap_lounge_id_fkey; Type: FK CONSTRAINT; Schema: mobile; Owner: postgres
--

ALTER TABLE ONLY ap
    ADD CONSTRAINT ap_lounge_id_fkey FOREIGN KEY (lounge_id) REFERENCES lounge(lounge_id);


--
-- TOC entry 3219 (class 2606 OID 26019)
-- Name: compass_log_device_id_fkey; Type: FK CONSTRAINT; Schema: mobile; Owner: postgres
--

ALTER TABLE ONLY compass_log
    ADD CONSTRAINT compass_log_device_id_fkey FOREIGN KEY (device_id) REFERENCES device(device_id);


--
-- TOC entry 3220 (class 2606 OID 26027)
-- Name: connectivity_log_device_id_fkey; Type: FK CONSTRAINT; Schema: mobile; Owner: postgres
--

ALTER TABLE ONLY connectivity_log
    ADD CONSTRAINT connectivity_log_device_id_fkey FOREIGN KEY (device_id) REFERENCES device(device_id);


--
-- TOC entry 3222 (class 2606 OID 26051)
-- Name: device_contact_contact_id_fkey; Type: FK CONSTRAINT; Schema: mobile; Owner: postgres
--

ALTER TABLE ONLY device_contact
    ADD CONSTRAINT device_contact_contact_id_fkey FOREIGN KEY (contact_id) REFERENCES contact(contact_id);


--
-- TOC entry 3221 (class 2606 OID 26046)
-- Name: device_contact_device_id_fkey; Type: FK CONSTRAINT; Schema: mobile; Owner: postgres
--

ALTER TABLE ONLY device_contact
    ADD CONSTRAINT device_contact_device_id_fkey FOREIGN KEY (device_id) REFERENCES device(device_id);


--
-- TOC entry 3224 (class 2606 OID 26065)
-- Name: device_use_contact_contact_id_fkey; Type: FK CONSTRAINT; Schema: mobile; Owner: postgres
--

ALTER TABLE ONLY device_use_contact
    ADD CONSTRAINT device_use_contact_contact_id_fkey FOREIGN KEY (contact_id) REFERENCES contact(contact_id);


--
-- TOC entry 3223 (class 2606 OID 26060)
-- Name: device_use_contact_device_id_fkey; Type: FK CONSTRAINT; Schema: mobile; Owner: postgres
--

ALTER TABLE ONLY device_use_contact
    ADD CONSTRAINT device_use_contact_device_id_fkey FOREIGN KEY (device_id) REFERENCES device(device_id);


--
-- TOC entry 3225 (class 2606 OID 26073)
-- Name: gps_log_device_id_fkey; Type: FK CONSTRAINT; Schema: mobile; Owner: postgres
--

ALTER TABLE ONLY gps_log
    ADD CONSTRAINT gps_log_device_id_fkey FOREIGN KEY (device_id) REFERENCES device(device_id);


--
-- TOC entry 3227 (class 2606 OID 26089)
-- Name: identity_has_device_device_id_fkey; Type: FK CONSTRAINT; Schema: mobile; Owner: postgres
--

ALTER TABLE ONLY identity_has_device
    ADD CONSTRAINT identity_has_device_device_id_fkey FOREIGN KEY (device_id) REFERENCES device(device_id);


--
-- TOC entry 3226 (class 2606 OID 26084)
-- Name: identity_has_device_identity_id_fkey; Type: FK CONSTRAINT; Schema: mobile; Owner: postgres
--

ALTER TABLE ONLY identity_has_device
    ADD CONSTRAINT identity_has_device_identity_id_fkey FOREIGN KEY (identity_id) REFERENCES identity(identity_id);


--
-- TOC entry 3228 (class 2606 OID 26102)
-- Name: lounge_image_id_fkey; Type: FK CONSTRAINT; Schema: mobile; Owner: postgres
--

ALTER TABLE ONLY lounge
    ADD CONSTRAINT lounge_image_id_fkey FOREIGN KEY (image_id) REFERENCES image(image_id);


--
-- TOC entry 3230 (class 2606 OID 26120)
-- Name: wifi_log_ap_wifi_log_id_fkey; Type: FK CONSTRAINT; Schema: mobile; Owner: postgres
--

ALTER TABLE ONLY wifi_log_ap
    ADD CONSTRAINT wifi_log_ap_wifi_log_id_fkey FOREIGN KEY (wifi_log_id) REFERENCES wifi_log(wifi_log_id);


--
-- TOC entry 3229 (class 2606 OID 26110)
-- Name: wifi_log_device_id_fkey; Type: FK CONSTRAINT; Schema: mobile; Owner: postgres
--

ALTER TABLE ONLY wifi_log
    ADD CONSTRAINT wifi_log_device_id_fkey FOREIGN KEY (device_id) REFERENCES device(device_id);


-- Completed on 2014-02-14 22:08:30

--
-- PostgreSQL database dump complete
--

