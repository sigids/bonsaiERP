--
-- PostgreSQL database dump
--

-- Dumped from database version 9.6.6
-- Dumped by pg_dump version 9.6.6

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: common; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA common;


--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: hstore; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS hstore WITH SCHEMA public;


--
-- Name: EXTENSION hstore; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION hstore IS 'data type for storing sets of (key, value) pairs';


--
-- Name: pg_trgm; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_trgm WITH SCHEMA public;


--
-- Name: EXTENSION pg_trgm; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pg_trgm IS 'text similarity measurement and index searching based on trigrams';


SET search_path = public, pg_catalog;

--
-- Name: array_intersection(anyarray, anyarray); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION array_intersection(anyarray, anyarray) RETURNS anyarray
    LANGUAGE sql
    AS $_$
SELECT ARRAY(
    SELECT $1[i]
    FROM generate_series( array_lower($1, 1), array_upper($1, 1) ) i
    WHERE ARRAY[$1[i]] && $2
);
$_$;


SET search_path = common, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: links; Type: TABLE; Schema: common; Owner: -
--

CREATE TABLE links (
    id integer NOT NULL,
    organisation_id integer,
    user_id integer,
    settings character varying,
    creator boolean DEFAULT false,
    master_account boolean DEFAULT false,
    role character varying(50),
    active boolean DEFAULT true,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    tenant character varying(100),
    api_token character varying
);


--
-- Name: links_id_seq; Type: SEQUENCE; Schema: common; Owner: -
--

CREATE SEQUENCE links_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: links_id_seq; Type: SEQUENCE OWNED BY; Schema: common; Owner: -
--

ALTER SEQUENCE links_id_seq OWNED BY links.id;


--
-- Name: organisations; Type: TABLE; Schema: common; Owner: -
--

CREATE TABLE organisations (
    id integer NOT NULL,
    country_id integer,
    name character varying(100),
    address character varying,
    address_alt character varying,
    phone character varying(40),
    phone_alt character varying(40),
    mobile character varying(40),
    email character varying,
    website character varying,
    user_id integer,
    due_date date,
    preferences text,
    time_zone character varying(100),
    tenant character varying(50),
    currency character varying(10),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    country_code character varying(5),
    inventory_active boolean DEFAULT true,
    settings jsonb,
    due_on date,
    plan character varying DEFAULT '2users'::character varying
);


--
-- Name: organisations_id_seq; Type: SEQUENCE; Schema: common; Owner: -
--

CREATE SEQUENCE organisations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: organisations_id_seq; Type: SEQUENCE OWNED BY; Schema: common; Owner: -
--

ALTER SEQUENCE organisations_id_seq OWNED BY organisations.id;


--
-- Name: users; Type: TABLE; Schema: common; Owner: -
--

CREATE TABLE users (
    id integer NOT NULL,
    email character varying NOT NULL,
    first_name character varying(80),
    last_name character varying(80),
    phone character varying(40),
    mobile character varying(40),
    website character varying(200),
    description character varying(255),
    encrypted_password character varying,
    password_salt character varying,
    confirmation_token character varying(60),
    confirmation_sent_at timestamp without time zone,
    confirmed_at timestamp without time zone,
    reset_password_token character varying,
    reset_password_sent_at timestamp without time zone,
    reseted_password_at timestamp without time zone,
    sign_in_count integer DEFAULT 0,
    last_sign_in_at timestamp without time zone,
    change_default_password boolean DEFAULT false,
    address character varying,
    active boolean DEFAULT true,
    auth_token character varying,
    rol character varying(50),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    old_emails text[] DEFAULT '{}'::text[],
    locale character varying DEFAULT 'en'::character varying
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: common; Owner: -
--

CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: common; Owner: -
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


SET search_path = public, pg_catalog;

--
-- Name: account_ledgers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE account_ledgers (
    id integer NOT NULL,
    reference text,
    currency character varying,
    account_id integer,
    account_balance numeric(14,2) DEFAULT 0.0,
    account_to_id integer,
    account_to_balance numeric(14,2) DEFAULT 0.0,
    date date,
    operation character varying(20),
    amount numeric(14,2) DEFAULT 0.0,
    exchange_rate numeric(14,4) DEFAULT 1.0,
    creator_id integer,
    approver_id integer,
    approver_datetime timestamp without time zone,
    nuller_id integer,
    nuller_datetime timestamp without time zone,
    inverse boolean DEFAULT false,
    has_error boolean DEFAULT false,
    error_messages character varying,
    status character varying(50) DEFAULT 'approved'::character varying,
    project_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    updater_id integer,
    name character varying,
    contact_id integer
);


--
-- Name: account_ledgers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE account_ledgers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: account_ledgers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE account_ledgers_id_seq OWNED BY account_ledgers.id;


--
-- Name: accounts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE accounts (
    id integer NOT NULL,
    name character varying,
    currency character varying(10),
    exchange_rate numeric(14,4) DEFAULT 1.0,
    amount numeric(14,2) DEFAULT 0.0,
    type character varying(30),
    contact_id integer,
    project_id integer,
    active boolean DEFAULT true,
    description text,
    date date,
    state character varying(30),
    has_error boolean DEFAULT false,
    error_messages character varying(400),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    tag_ids integer[] DEFAULT '{}'::integer[],
    updater_id integer,
    tax_percentage numeric(5,2) DEFAULT 0,
    tax_id integer,
    total numeric(14,2) DEFAULT 0,
    tax_in_out boolean DEFAULT false,
    extras jsonb,
    creator_id integer,
    approver_id integer,
    nuller_id integer,
    due_date date
);


--
-- Name: accounts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE accounts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: accounts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE accounts_id_seq OWNED BY accounts.id;


--
-- Name: attachments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE attachments (
    id integer NOT NULL,
    attachment_uid character varying,
    name character varying,
    attachable_id integer,
    attachable_type character varying,
    user_id integer,
    "position" integer DEFAULT 0,
    image boolean DEFAULT false,
    size integer,
    image_attributes json,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    publish boolean DEFAULT false
);


--
-- Name: attachments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE attachments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: attachments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE attachments_id_seq OWNED BY attachments.id;


--
-- Name: contacts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE contacts (
    id integer NOT NULL,
    matchcode character varying,
    first_name character varying(100),
    last_name character varying(100),
    organisation_name character varying(100),
    address character varying(250),
    phone character varying(40),
    mobile character varying(40),
    email character varying(200),
    tax_number character varying(30),
    aditional_info character varying(250),
    code character varying,
    type character varying,
    "position" character varying,
    active boolean DEFAULT true,
    staff boolean DEFAULT false,
    client boolean DEFAULT false,
    supplier boolean DEFAULT false,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    incomes_status character varying(300) DEFAULT '{}'::character varying,
    expenses_status character varying(300) DEFAULT '{}'::character varying,
    tag_ids integer[] DEFAULT '{}'::integer[]
);


--
-- Name: contacts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE contacts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: contacts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE contacts_id_seq OWNED BY contacts.id;


--
-- Name: histories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE histories (
    id integer NOT NULL,
    user_id integer,
    historiable_id integer,
    new_item boolean DEFAULT false,
    historiable_type character varying,
    history_data json DEFAULT '{}'::json,
    created_at timestamp without time zone,
    klass_type character varying,
    extras hstore,
    all_data json DEFAULT '{}'::json
);


--
-- Name: histories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE histories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: histories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE histories_id_seq OWNED BY histories.id;


--
-- Name: inventories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE inventories (
    id integer NOT NULL,
    contact_id integer,
    store_id integer,
    account_id integer,
    date date,
    ref_number character varying,
    operation character varying(10),
    description character varying,
    total numeric(14,2) DEFAULT 0,
    creator_id integer,
    transference_id integer,
    store_to_id integer,
    project_id integer,
    has_error boolean DEFAULT false,
    error_messages character varying,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    updater_id integer
);


--
-- Name: inventories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE inventories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: inventories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE inventories_id_seq OWNED BY inventories.id;


--
-- Name: inventory_details; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE inventory_details (
    id integer NOT NULL,
    inventory_id integer,
    item_id integer,
    store_id integer,
    quantity numeric(14,2) DEFAULT 0.0,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: inventory_details_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE inventory_details_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: inventory_details_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE inventory_details_id_seq OWNED BY inventory_details.id;


--
-- Name: items; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE items (
    id integer NOT NULL,
    unit_id integer,
    price numeric(14,2) DEFAULT 0.0,
    name character varying(255),
    description character varying,
    code character varying(100),
    for_sale boolean DEFAULT true,
    stockable boolean DEFAULT true,
    active boolean DEFAULT true,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    buy_price numeric(14,2) DEFAULT 0.0,
    unit_symbol character varying(20),
    unit_name character varying(255),
    tag_ids integer[] DEFAULT '{}'::integer[],
    updater_id integer,
    creator_id integer
);


--
-- Name: items_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE items_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE items_id_seq OWNED BY items.id;


--
-- Name: links; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE links (
    id integer NOT NULL,
    organisation_id integer,
    user_id integer,
    settings character varying,
    creator boolean DEFAULT false,
    master_account boolean DEFAULT false,
    role character varying(50),
    active boolean DEFAULT true,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    tenant character varying(100),
    api_token character varying
);


--
-- Name: links_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE links_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: links_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE links_id_seq OWNED BY links.id;


--
-- Name: movement_details; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE movement_details (
    id integer NOT NULL,
    account_id integer,
    item_id integer,
    quantity numeric(14,2) DEFAULT 0.0,
    price numeric(14,2) DEFAULT 0.0,
    description character varying,
    discount numeric(14,2) DEFAULT 0.0,
    balance numeric(14,2) DEFAULT 0.0,
    original_price numeric(14,2) DEFAULT 0.0,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: movement_details_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE movement_details_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: movement_details_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE movement_details_id_seq OWNED BY movement_details.id;


--
-- Name: organisations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE organisations (
    id integer NOT NULL,
    country_id integer,
    name character varying(100),
    address character varying,
    address_alt character varying,
    phone character varying(40),
    phone_alt character varying(40),
    mobile character varying(40),
    email character varying,
    website character varying,
    user_id integer,
    due_date date,
    preferences text,
    time_zone character varying(100),
    tenant character varying(50),
    currency character varying(10),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    country_code character varying(5),
    settings hstore DEFAULT '"inventory"=>"true"'::hstore
);


--
-- Name: organisations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE organisations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: organisations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE organisations_id_seq OWNED BY organisations.id;


--
-- Name: projects; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE projects (
    id integer NOT NULL,
    name character varying,
    active boolean DEFAULT true,
    date_start date,
    date_end date,
    description text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: projects_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE projects_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: projects_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE projects_id_seq OWNED BY projects.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE schema_migrations (
    version character varying NOT NULL
);


--
-- Name: stocks; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE stocks (
    id integer NOT NULL,
    store_id integer,
    item_id integer,
    unitary_cost numeric(14,2) DEFAULT 0.0,
    quantity numeric(14,2) DEFAULT 0.0,
    minimum numeric(14,2) DEFAULT 0.0,
    user_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    active boolean DEFAULT true
);


--
-- Name: stocks_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE stocks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: stocks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE stocks_id_seq OWNED BY stocks.id;


--
-- Name: stores; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE stores (
    id integer NOT NULL,
    name character varying,
    address character varying,
    phone character varying(40),
    active boolean DEFAULT true,
    description character varying,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: stores_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE stores_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: stores_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE stores_id_seq OWNED BY stores.id;


--
-- Name: tag_groups; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE tag_groups (
    id integer NOT NULL,
    name character varying,
    bgcolor character varying,
    tag_ids integer[] DEFAULT '{}'::integer[],
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: tag_groups_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE tag_groups_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tag_groups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE tag_groups_id_seq OWNED BY tag_groups.id;


--
-- Name: tags; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE tags (
    id integer NOT NULL,
    name character varying,
    bgcolor character varying(10),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: tags_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE tags_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tags_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE tags_id_seq OWNED BY tags.id;


--
-- Name: taxes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE taxes (
    id integer NOT NULL,
    name character varying(100),
    abreviation character varying(20),
    percentage numeric(5,2) DEFAULT 0.0,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: taxes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE taxes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: taxes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE taxes_id_seq OWNED BY taxes.id;


--
-- Name: units; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE units (
    id integer NOT NULL,
    name character varying(100),
    symbol character varying(20),
    "integer" boolean DEFAULT false,
    visible boolean DEFAULT true,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: units_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE units_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: units_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE units_id_seq OWNED BY units.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE users (
    id integer NOT NULL,
    email character varying NOT NULL,
    first_name character varying(80),
    last_name character varying(80),
    phone character varying(40),
    mobile character varying(40),
    website character varying(200),
    description character varying(255),
    encrypted_password character varying,
    password_salt character varying,
    confirmation_token character varying(60),
    confirmation_sent_at timestamp without time zone,
    confirmed_at timestamp without time zone,
    reset_password_token character varying,
    reset_password_sent_at timestamp without time zone,
    reseted_password_at timestamp without time zone,
    sign_in_count integer DEFAULT 0,
    last_sign_in_at timestamp without time zone,
    change_default_password boolean DEFAULT false,
    address character varying,
    active boolean DEFAULT true,
    auth_token character varying,
    rol character varying(50),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    old_emails text[] DEFAULT '{}'::text[],
    locale character varying DEFAULT 'en'::character varying
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


SET search_path = common, pg_catalog;

--
-- Name: links id; Type: DEFAULT; Schema: common; Owner: -
--

ALTER TABLE ONLY links ALTER COLUMN id SET DEFAULT nextval('links_id_seq'::regclass);


--
-- Name: organisations id; Type: DEFAULT; Schema: common; Owner: -
--

ALTER TABLE ONLY organisations ALTER COLUMN id SET DEFAULT nextval('organisations_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: common; Owner: -
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


SET search_path = public, pg_catalog;

--
-- Name: account_ledgers id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY account_ledgers ALTER COLUMN id SET DEFAULT nextval('account_ledgers_id_seq'::regclass);


--
-- Name: accounts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY accounts ALTER COLUMN id SET DEFAULT nextval('accounts_id_seq'::regclass);


--
-- Name: attachments id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY attachments ALTER COLUMN id SET DEFAULT nextval('attachments_id_seq'::regclass);


--
-- Name: contacts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY contacts ALTER COLUMN id SET DEFAULT nextval('contacts_id_seq'::regclass);


--
-- Name: histories id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY histories ALTER COLUMN id SET DEFAULT nextval('histories_id_seq'::regclass);


--
-- Name: inventories id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY inventories ALTER COLUMN id SET DEFAULT nextval('inventories_id_seq'::regclass);


--
-- Name: inventory_details id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY inventory_details ALTER COLUMN id SET DEFAULT nextval('inventory_details_id_seq'::regclass);


--
-- Name: items id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY items ALTER COLUMN id SET DEFAULT nextval('items_id_seq'::regclass);


--
-- Name: links id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY links ALTER COLUMN id SET DEFAULT nextval('links_id_seq'::regclass);


--
-- Name: movement_details id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY movement_details ALTER COLUMN id SET DEFAULT nextval('movement_details_id_seq'::regclass);


--
-- Name: organisations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY organisations ALTER COLUMN id SET DEFAULT nextval('organisations_id_seq'::regclass);


--
-- Name: projects id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY projects ALTER COLUMN id SET DEFAULT nextval('projects_id_seq'::regclass);


--
-- Name: stocks id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY stocks ALTER COLUMN id SET DEFAULT nextval('stocks_id_seq'::regclass);


--
-- Name: stores id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY stores ALTER COLUMN id SET DEFAULT nextval('stores_id_seq'::regclass);


--
-- Name: tag_groups id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY tag_groups ALTER COLUMN id SET DEFAULT nextval('tag_groups_id_seq'::regclass);


--
-- Name: tags id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY tags ALTER COLUMN id SET DEFAULT nextval('tags_id_seq'::regclass);


--
-- Name: taxes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY taxes ALTER COLUMN id SET DEFAULT nextval('taxes_id_seq'::regclass);


--
-- Name: units id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY units ALTER COLUMN id SET DEFAULT nextval('units_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


SET search_path = common, pg_catalog;

--
-- Name: links links_pkey; Type: CONSTRAINT; Schema: common; Owner: -
--

ALTER TABLE ONLY links
    ADD CONSTRAINT links_pkey PRIMARY KEY (id);


--
-- Name: organisations organisations_pkey; Type: CONSTRAINT; Schema: common; Owner: -
--

ALTER TABLE ONLY organisations
    ADD CONSTRAINT organisations_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: common; Owner: -
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


SET search_path = public, pg_catalog;

--
-- Name: account_ledgers account_ledgers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY account_ledgers
    ADD CONSTRAINT account_ledgers_pkey PRIMARY KEY (id);


--
-- Name: accounts accounts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY accounts
    ADD CONSTRAINT accounts_pkey PRIMARY KEY (id);


--
-- Name: attachments attachments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY attachments
    ADD CONSTRAINT attachments_pkey PRIMARY KEY (id);


--
-- Name: contacts contacts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contacts
    ADD CONSTRAINT contacts_pkey PRIMARY KEY (id);


--
-- Name: histories histories_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY histories
    ADD CONSTRAINT histories_pkey PRIMARY KEY (id);


--
-- Name: inventories inventories_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY inventories
    ADD CONSTRAINT inventories_pkey PRIMARY KEY (id);


--
-- Name: inventory_details inventory_details_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY inventory_details
    ADD CONSTRAINT inventory_details_pkey PRIMARY KEY (id);


--
-- Name: items items_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY items
    ADD CONSTRAINT items_pkey PRIMARY KEY (id);


--
-- Name: links links_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY links
    ADD CONSTRAINT links_pkey PRIMARY KEY (id);


--
-- Name: movement_details movement_details_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY movement_details
    ADD CONSTRAINT movement_details_pkey PRIMARY KEY (id);


--
-- Name: organisations organisations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY organisations
    ADD CONSTRAINT organisations_pkey PRIMARY KEY (id);


--
-- Name: projects projects_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY projects
    ADD CONSTRAINT projects_pkey PRIMARY KEY (id);


--
-- Name: stocks stocks_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY stocks
    ADD CONSTRAINT stocks_pkey PRIMARY KEY (id);


--
-- Name: stores stores_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY stores
    ADD CONSTRAINT stores_pkey PRIMARY KEY (id);


--
-- Name: tag_groups tag_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY tag_groups
    ADD CONSTRAINT tag_groups_pkey PRIMARY KEY (id);


--
-- Name: tags tags_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY tags
    ADD CONSTRAINT tags_pkey PRIMARY KEY (id);


--
-- Name: taxes taxes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY taxes
    ADD CONSTRAINT taxes_pkey PRIMARY KEY (id);


--
-- Name: units units_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY units
    ADD CONSTRAINT units_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


SET search_path = common, pg_catalog;

--
-- Name: index_links_on_api_token; Type: INDEX; Schema: common; Owner: -
--

CREATE UNIQUE INDEX index_links_on_api_token ON links USING btree (api_token);


--
-- Name: index_links_on_organisation_id; Type: INDEX; Schema: common; Owner: -
--

CREATE INDEX index_links_on_organisation_id ON links USING btree (organisation_id);


--
-- Name: index_links_on_tenant; Type: INDEX; Schema: common; Owner: -
--

CREATE INDEX index_links_on_tenant ON links USING btree (tenant);


--
-- Name: index_links_on_user_id; Type: INDEX; Schema: common; Owner: -
--

CREATE INDEX index_links_on_user_id ON links USING btree (user_id);


--
-- Name: index_organisations_on_country_code; Type: INDEX; Schema: common; Owner: -
--

CREATE INDEX index_organisations_on_country_code ON organisations USING btree (country_code);


--
-- Name: index_organisations_on_country_id; Type: INDEX; Schema: common; Owner: -
--

CREATE INDEX index_organisations_on_country_id ON organisations USING btree (country_id);


--
-- Name: index_organisations_on_currency; Type: INDEX; Schema: common; Owner: -
--

CREATE INDEX index_organisations_on_currency ON organisations USING btree (currency);


--
-- Name: index_organisations_on_due_date; Type: INDEX; Schema: common; Owner: -
--

CREATE INDEX index_organisations_on_due_date ON organisations USING btree (due_date);


--
-- Name: index_organisations_on_tenant; Type: INDEX; Schema: common; Owner: -
--

CREATE UNIQUE INDEX index_organisations_on_tenant ON organisations USING btree (tenant);


--
-- Name: index_users_on_auth_token; Type: INDEX; Schema: common; Owner: -
--

CREATE UNIQUE INDEX index_users_on_auth_token ON users USING btree (auth_token);


--
-- Name: index_users_on_confirmation_token; Type: INDEX; Schema: common; Owner: -
--

CREATE UNIQUE INDEX index_users_on_confirmation_token ON users USING btree (confirmation_token);


--
-- Name: index_users_on_email; Type: INDEX; Schema: common; Owner: -
--

CREATE UNIQUE INDEX index_users_on_email ON users USING btree (email);


--
-- Name: index_users_on_first_name; Type: INDEX; Schema: common; Owner: -
--

CREATE INDEX index_users_on_first_name ON users USING btree (first_name);


--
-- Name: index_users_on_last_name; Type: INDEX; Schema: common; Owner: -
--

CREATE INDEX index_users_on_last_name ON users USING btree (last_name);


SET search_path = public, pg_catalog;

--
-- Name: index_account_ledgers_on_account_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_account_ledgers_on_account_id ON account_ledgers USING btree (account_id);


--
-- Name: index_account_ledgers_on_account_to_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_account_ledgers_on_account_to_id ON account_ledgers USING btree (account_to_id);


--
-- Name: index_account_ledgers_on_contact_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_account_ledgers_on_contact_id ON account_ledgers USING btree (contact_id);


--
-- Name: index_account_ledgers_on_currency; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_account_ledgers_on_currency ON account_ledgers USING btree (currency);


--
-- Name: index_account_ledgers_on_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_account_ledgers_on_date ON account_ledgers USING btree (date);


--
-- Name: index_account_ledgers_on_has_error; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_account_ledgers_on_has_error ON account_ledgers USING btree (has_error);


--
-- Name: index_account_ledgers_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_account_ledgers_on_name ON account_ledgers USING btree (name);


--
-- Name: index_account_ledgers_on_operation; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_account_ledgers_on_operation ON account_ledgers USING btree (operation);


--
-- Name: index_account_ledgers_on_project_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_account_ledgers_on_project_id ON account_ledgers USING btree (project_id);


--
-- Name: index_account_ledgers_on_reference; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_account_ledgers_on_reference ON account_ledgers USING gin (reference gin_trgm_ops);


--
-- Name: index_account_ledgers_on_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_account_ledgers_on_status ON account_ledgers USING btree (status);


--
-- Name: index_account_ledgers_on_updater_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_account_ledgers_on_updater_id ON account_ledgers USING btree (updater_id);


--
-- Name: index_accounts_on_active; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_accounts_on_active ON accounts USING btree (active);


--
-- Name: index_accounts_on_amount; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_accounts_on_amount ON accounts USING btree (amount);


--
-- Name: index_accounts_on_approver_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_accounts_on_approver_id ON accounts USING btree (approver_id);


--
-- Name: index_accounts_on_contact_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_accounts_on_contact_id ON accounts USING btree (contact_id);


--
-- Name: index_accounts_on_creator_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_accounts_on_creator_id ON accounts USING btree (creator_id);


--
-- Name: index_accounts_on_currency; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_accounts_on_currency ON accounts USING btree (currency);


--
-- Name: index_accounts_on_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_accounts_on_date ON accounts USING btree (date);


--
-- Name: index_accounts_on_description; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_accounts_on_description ON accounts USING gin (description gin_trgm_ops);


--
-- Name: index_accounts_on_due_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_accounts_on_due_date ON accounts USING btree (due_date);


--
-- Name: index_accounts_on_extras; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_accounts_on_extras ON accounts USING gin (extras);


--
-- Name: index_accounts_on_has_error; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_accounts_on_has_error ON accounts USING btree (has_error);


--
-- Name: index_accounts_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_accounts_on_name ON accounts USING btree (name);


--
-- Name: index_accounts_on_nuller_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_accounts_on_nuller_id ON accounts USING btree (nuller_id);


--
-- Name: index_accounts_on_project_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_accounts_on_project_id ON accounts USING btree (project_id);


--
-- Name: index_accounts_on_state; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_accounts_on_state ON accounts USING btree (state);


--
-- Name: index_accounts_on_tag_ids; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_accounts_on_tag_ids ON accounts USING gin (tag_ids);


--
-- Name: index_accounts_on_tax_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_accounts_on_tax_id ON accounts USING btree (tax_id);


--
-- Name: index_accounts_on_tax_in_out; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_accounts_on_tax_in_out ON accounts USING btree (tax_in_out);


--
-- Name: index_accounts_on_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_accounts_on_type ON accounts USING btree (type);


--
-- Name: index_accounts_on_updater_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_accounts_on_updater_id ON accounts USING btree (updater_id);


--
-- Name: index_attachments_on_attachable_id_and_attachable_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_attachments_on_attachable_id_and_attachable_type ON attachments USING btree (attachable_id, attachable_type);


--
-- Name: index_attachments_on_image; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_attachments_on_image ON attachments USING btree (image);


--
-- Name: index_attachments_on_publish; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_attachments_on_publish ON attachments USING btree (publish);


--
-- Name: index_attachments_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_attachments_on_user_id ON attachments USING btree (user_id);


--
-- Name: index_contacts_on_active; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_contacts_on_active ON contacts USING btree (active);


--
-- Name: index_contacts_on_client; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_contacts_on_client ON contacts USING btree (client);


--
-- Name: index_contacts_on_first_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_contacts_on_first_name ON contacts USING btree (first_name);


--
-- Name: index_contacts_on_last_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_contacts_on_last_name ON contacts USING btree (last_name);


--
-- Name: index_contacts_on_matchcode; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_contacts_on_matchcode ON contacts USING btree (matchcode);


--
-- Name: index_contacts_on_staff; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_contacts_on_staff ON contacts USING btree (staff);


--
-- Name: index_contacts_on_supplier; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_contacts_on_supplier ON contacts USING btree (supplier);


--
-- Name: index_contacts_on_tag_ids; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_contacts_on_tag_ids ON contacts USING gin (tag_ids);


--
-- Name: index_histories_on_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_histories_on_created_at ON histories USING btree (created_at);


--
-- Name: index_histories_on_historiable_id_and_historiable_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_histories_on_historiable_id_and_historiable_type ON histories USING btree (historiable_id, historiable_type);


--
-- Name: index_histories_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_histories_on_user_id ON histories USING btree (user_id);


--
-- Name: index_inventories_on_account_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_inventories_on_account_id ON inventories USING btree (account_id);


--
-- Name: index_inventories_on_contact_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_inventories_on_contact_id ON inventories USING btree (contact_id);


--
-- Name: index_inventories_on_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_inventories_on_date ON inventories USING btree (date);


--
-- Name: index_inventories_on_has_error; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_inventories_on_has_error ON inventories USING btree (has_error);


--
-- Name: index_inventories_on_operation; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_inventories_on_operation ON inventories USING btree (operation);


--
-- Name: index_inventories_on_project_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_inventories_on_project_id ON inventories USING btree (project_id);


--
-- Name: index_inventories_on_ref_number; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_inventories_on_ref_number ON inventories USING btree (ref_number);


--
-- Name: index_inventories_on_store_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_inventories_on_store_id ON inventories USING btree (store_id);


--
-- Name: index_inventories_on_updater_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_inventories_on_updater_id ON inventories USING btree (updater_id);


--
-- Name: index_inventory_details_on_inventory_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_inventory_details_on_inventory_id ON inventory_details USING btree (inventory_id);


--
-- Name: index_inventory_details_on_item_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_inventory_details_on_item_id ON inventory_details USING btree (item_id);


--
-- Name: index_inventory_details_on_store_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_inventory_details_on_store_id ON inventory_details USING btree (store_id);


--
-- Name: index_items_on_code; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_items_on_code ON items USING btree (code);


--
-- Name: index_items_on_creator_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_items_on_creator_id ON items USING btree (creator_id);


--
-- Name: index_items_on_for_sale; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_items_on_for_sale ON items USING btree (for_sale);


--
-- Name: index_items_on_stockable; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_items_on_stockable ON items USING btree (stockable);


--
-- Name: index_items_on_tag_ids; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_items_on_tag_ids ON items USING gin (tag_ids);


--
-- Name: index_items_on_unit_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_items_on_unit_id ON items USING btree (unit_id);


--
-- Name: index_items_on_updater_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_items_on_updater_id ON items USING btree (updater_id);


--
-- Name: index_links_on_api_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_links_on_api_token ON links USING btree (api_token);


--
-- Name: index_links_on_organisation_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_links_on_organisation_id ON links USING btree (organisation_id);


--
-- Name: index_links_on_tenant; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_links_on_tenant ON links USING btree (tenant);


--
-- Name: index_links_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_links_on_user_id ON links USING btree (user_id);


--
-- Name: index_movement_details_on_account_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_movement_details_on_account_id ON movement_details USING btree (account_id);


--
-- Name: index_movement_details_on_item_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_movement_details_on_item_id ON movement_details USING btree (item_id);


--
-- Name: index_organisations_on_country_code; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_organisations_on_country_code ON organisations USING btree (country_code);


--
-- Name: index_organisations_on_country_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_organisations_on_country_id ON organisations USING btree (country_id);


--
-- Name: index_organisations_on_currency; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_organisations_on_currency ON organisations USING btree (currency);


--
-- Name: index_organisations_on_due_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_organisations_on_due_date ON organisations USING btree (due_date);


--
-- Name: index_organisations_on_tenant; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_organisations_on_tenant ON organisations USING btree (tenant);


--
-- Name: index_projects_on_active; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_projects_on_active ON projects USING btree (active);


--
-- Name: index_stocks_on_active; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_stocks_on_active ON stocks USING btree (active);


--
-- Name: index_stocks_on_item_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_stocks_on_item_id ON stocks USING btree (item_id);


--
-- Name: index_stocks_on_minimum; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_stocks_on_minimum ON stocks USING btree (minimum);


--
-- Name: index_stocks_on_quantity; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_stocks_on_quantity ON stocks USING btree (quantity);


--
-- Name: index_stocks_on_store_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_stocks_on_store_id ON stocks USING btree (store_id);


--
-- Name: index_stocks_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_stocks_on_user_id ON stocks USING btree (user_id);


--
-- Name: index_tag_groups_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_tag_groups_on_name ON tag_groups USING btree (name);


--
-- Name: index_tag_groups_on_tag_ids; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_tag_groups_on_tag_ids ON tag_groups USING gin (tag_ids);


--
-- Name: index_tags_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_tags_on_name ON tags USING btree (name);


--
-- Name: index_users_on_auth_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_auth_token ON users USING btree (auth_token);


--
-- Name: index_users_on_confirmation_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_confirmation_token ON users USING btree (confirmation_token);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_email ON users USING btree (email);


--
-- Name: index_users_on_first_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_users_on_first_name ON users USING btree (first_name);


--
-- Name: index_users_on_last_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_users_on_last_name ON users USING btree (last_name);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO public.schema_migrations (version) VALUES ('20100101101010');

INSERT INTO public.schema_migrations (version) VALUES ('20100324202441');

INSERT INTO public.schema_migrations (version) VALUES ('20100325221629');

INSERT INTO public.schema_migrations (version) VALUES ('20100401192000');

INSERT INTO public.schema_migrations (version) VALUES ('20100416193705');

INSERT INTO public.schema_migrations (version) VALUES ('20100421174307');

INSERT INTO public.schema_migrations (version) VALUES ('20100427190727');

INSERT INTO public.schema_migrations (version) VALUES ('20100531141109');

INSERT INTO public.schema_migrations (version) VALUES ('20110119140408');

INSERT INTO public.schema_migrations (version) VALUES ('20110201153434');

INSERT INTO public.schema_migrations (version) VALUES ('20110201161907');

INSERT INTO public.schema_migrations (version) VALUES ('20110411174426');

INSERT INTO public.schema_migrations (version) VALUES ('20110411182005');

INSERT INTO public.schema_migrations (version) VALUES ('20110411182905');

INSERT INTO public.schema_migrations (version) VALUES ('20111103143524');

INSERT INTO public.schema_migrations (version) VALUES ('20121215153208');

INSERT INTO public.schema_migrations (version) VALUES ('20130114144400');

INSERT INTO public.schema_migrations (version) VALUES ('20130114164401');

INSERT INTO public.schema_migrations (version) VALUES ('20130115020409');

INSERT INTO public.schema_migrations (version) VALUES ('20130204171801');

INSERT INTO public.schema_migrations (version) VALUES ('20130221151829');

INSERT INTO public.schema_migrations (version) VALUES ('20130325155351');

INSERT INTO public.schema_migrations (version) VALUES ('20130411141221');

INSERT INTO public.schema_migrations (version) VALUES ('20130426151609');

INSERT INTO public.schema_migrations (version) VALUES ('20130429120114');

INSERT INTO public.schema_migrations (version) VALUES ('20130510144731');

INSERT INTO public.schema_migrations (version) VALUES ('20130510222719');

INSERT INTO public.schema_migrations (version) VALUES ('20130522125737');

INSERT INTO public.schema_migrations (version) VALUES ('20130527202406');

INSERT INTO public.schema_migrations (version) VALUES ('20130618172158');

INSERT INTO public.schema_migrations (version) VALUES ('20130618184031');

INSERT INTO public.schema_migrations (version) VALUES ('20130702144114');

INSERT INTO public.schema_migrations (version) VALUES ('20130704130428');

INSERT INTO public.schema_migrations (version) VALUES ('20130715185912');

INSERT INTO public.schema_migrations (version) VALUES ('20130716131229');

INSERT INTO public.schema_migrations (version) VALUES ('20130716131801');

INSERT INTO public.schema_migrations (version) VALUES ('20130717190543');

INSERT INTO public.schema_migrations (version) VALUES ('20130911005608');

INSERT INTO public.schema_migrations (version) VALUES ('20131009131456');

INSERT INTO public.schema_migrations (version) VALUES ('20131009141203');

INSERT INTO public.schema_migrations (version) VALUES ('20131211134555');

INSERT INTO public.schema_migrations (version) VALUES ('20131221130149');

INSERT INTO public.schema_migrations (version) VALUES ('20131223155017');

INSERT INTO public.schema_migrations (version) VALUES ('20131224080216');

INSERT INTO public.schema_migrations (version) VALUES ('20131224080916');

INSERT INTO public.schema_migrations (version) VALUES ('20131224081504');

INSERT INTO public.schema_migrations (version) VALUES ('20131227025934');

INSERT INTO public.schema_migrations (version) VALUES ('20131227032328');

INSERT INTO public.schema_migrations (version) VALUES ('20131229164735');

INSERT INTO public.schema_migrations (version) VALUES ('20140105165519');

INSERT INTO public.schema_migrations (version) VALUES ('20140118184207');

INSERT INTO public.schema_migrations (version) VALUES ('20140127023427');

INSERT INTO public.schema_migrations (version) VALUES ('20140127025407');

INSERT INTO public.schema_migrations (version) VALUES ('20140129135140');

INSERT INTO public.schema_migrations (version) VALUES ('20140131140212');

INSERT INTO public.schema_migrations (version) VALUES ('20140205123754');

INSERT INTO public.schema_migrations (version) VALUES ('20140213135130');

INSERT INTO public.schema_migrations (version) VALUES ('20140215130814');

INSERT INTO public.schema_migrations (version) VALUES ('20140217120803');

INSERT INTO public.schema_migrations (version) VALUES ('20140217134723');

INSERT INTO public.schema_migrations (version) VALUES ('20140219170720');

INSERT INTO public.schema_migrations (version) VALUES ('20140219210139');

INSERT INTO public.schema_migrations (version) VALUES ('20140219210551');

INSERT INTO public.schema_migrations (version) VALUES ('20140227163833');

INSERT INTO public.schema_migrations (version) VALUES ('20140417145820');

INSERT INTO public.schema_migrations (version) VALUES ('20140423120216');

INSERT INTO public.schema_migrations (version) VALUES ('20140603135208');

INSERT INTO public.schema_migrations (version) VALUES ('20140704132611');

INSERT INTO public.schema_migrations (version) VALUES ('20140730171947');

INSERT INTO public.schema_migrations (version) VALUES ('20140828122720');

INSERT INTO public.schema_migrations (version) VALUES ('20140925003650');

INSERT INTO public.schema_migrations (version) VALUES ('20141028104251');

INSERT INTO public.schema_migrations (version) VALUES ('20141112132422');

INSERT INTO public.schema_migrations (version) VALUES ('20160211130733');

INSERT INTO public.schema_migrations (version) VALUES ('20160215132803');

INSERT INTO public.schema_migrations (version) VALUES ('20160215133105');

INSERT INTO public.schema_migrations (version) VALUES ('20160215135420');

INSERT INTO public.schema_migrations (version) VALUES ('20160602111033');

