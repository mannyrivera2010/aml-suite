--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: agency_profile; Type: TABLE; Schema: public; Owner: ozp_user; Tablespace: 
--

CREATE TABLE agency_profile (
    id integer NOT NULL,
    profile_id integer NOT NULL,
    agency_id integer NOT NULL
);


ALTER TABLE public.agency_profile OWNER TO ozp_user;

--
-- Name: agency_profile_id_seq; Type: SEQUENCE; Schema: public; Owner: ozp_user
--

CREATE SEQUENCE agency_profile_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.agency_profile_id_seq OWNER TO ozp_user;

--
-- Name: agency_profile_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ozp_user
--

ALTER SEQUENCE agency_profile_id_seq OWNED BY agency_profile.id;


--
-- Name: auth_group; Type: TABLE; Schema: public; Owner: ozp_user; Tablespace: 
--

CREATE TABLE auth_group (
    id integer NOT NULL,
    name character varying(80) NOT NULL
);


ALTER TABLE public.auth_group OWNER TO ozp_user;

--
-- Name: auth_group_id_seq; Type: SEQUENCE; Schema: public; Owner: ozp_user
--

CREATE SEQUENCE auth_group_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auth_group_id_seq OWNER TO ozp_user;

--
-- Name: auth_group_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ozp_user
--

ALTER SEQUENCE auth_group_id_seq OWNED BY auth_group.id;


--
-- Name: auth_group_permissions; Type: TABLE; Schema: public; Owner: ozp_user; Tablespace: 
--

CREATE TABLE auth_group_permissions (
    id integer NOT NULL,
    group_id integer NOT NULL,
    permission_id integer NOT NULL
);


ALTER TABLE public.auth_group_permissions OWNER TO ozp_user;

--
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: ozp_user
--

CREATE SEQUENCE auth_group_permissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auth_group_permissions_id_seq OWNER TO ozp_user;

--
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ozp_user
--

ALTER SEQUENCE auth_group_permissions_id_seq OWNED BY auth_group_permissions.id;


--
-- Name: auth_permission; Type: TABLE; Schema: public; Owner: ozp_user; Tablespace: 
--

CREATE TABLE auth_permission (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    content_type_id integer NOT NULL,
    codename character varying(100) NOT NULL
);


ALTER TABLE public.auth_permission OWNER TO ozp_user;

--
-- Name: auth_permission_id_seq; Type: SEQUENCE; Schema: public; Owner: ozp_user
--

CREATE SEQUENCE auth_permission_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auth_permission_id_seq OWNER TO ozp_user;

--
-- Name: auth_permission_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ozp_user
--

ALTER SEQUENCE auth_permission_id_seq OWNED BY auth_permission.id;


--
-- Name: auth_user; Type: TABLE; Schema: public; Owner: ozp_user; Tablespace: 
--

CREATE TABLE auth_user (
    id integer NOT NULL,
    password character varying(128) NOT NULL,
    last_login timestamp with time zone,
    is_superuser boolean NOT NULL,
    username character varying(150) NOT NULL,
    first_name character varying(30) NOT NULL,
    last_name character varying(30) NOT NULL,
    email character varying(254) NOT NULL,
    is_staff boolean NOT NULL,
    is_active boolean NOT NULL,
    date_joined timestamp with time zone NOT NULL
);


ALTER TABLE public.auth_user OWNER TO ozp_user;

--
-- Name: auth_user_groups; Type: TABLE; Schema: public; Owner: ozp_user; Tablespace: 
--

CREATE TABLE auth_user_groups (
    id integer NOT NULL,
    user_id integer NOT NULL,
    group_id integer NOT NULL
);


ALTER TABLE public.auth_user_groups OWNER TO ozp_user;

--
-- Name: auth_user_groups_id_seq; Type: SEQUENCE; Schema: public; Owner: ozp_user
--

CREATE SEQUENCE auth_user_groups_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auth_user_groups_id_seq OWNER TO ozp_user;

--
-- Name: auth_user_groups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ozp_user
--

ALTER SEQUENCE auth_user_groups_id_seq OWNED BY auth_user_groups.id;


--
-- Name: auth_user_id_seq; Type: SEQUENCE; Schema: public; Owner: ozp_user
--

CREATE SEQUENCE auth_user_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auth_user_id_seq OWNER TO ozp_user;

--
-- Name: auth_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ozp_user
--

ALTER SEQUENCE auth_user_id_seq OWNED BY auth_user.id;


--
-- Name: auth_user_user_permissions; Type: TABLE; Schema: public; Owner: ozp_user; Tablespace: 
--

CREATE TABLE auth_user_user_permissions (
    id integer NOT NULL,
    user_id integer NOT NULL,
    permission_id integer NOT NULL
);


ALTER TABLE public.auth_user_user_permissions OWNER TO ozp_user;

--
-- Name: auth_user_user_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: ozp_user
--

CREATE SEQUENCE auth_user_user_permissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auth_user_user_permissions_id_seq OWNER TO ozp_user;

--
-- Name: auth_user_user_permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ozp_user
--

ALTER SEQUENCE auth_user_user_permissions_id_seq OWNED BY auth_user_user_permissions.id;


--
-- Name: category_listing; Type: TABLE; Schema: public; Owner: ozp_user; Tablespace: 
--

CREATE TABLE category_listing (
    id integer NOT NULL,
    listing_id integer NOT NULL,
    category_id integer NOT NULL
);


ALTER TABLE public.category_listing OWNER TO ozp_user;

--
-- Name: category_listing_id_seq; Type: SEQUENCE; Schema: public; Owner: ozp_user
--

CREATE SEQUENCE category_listing_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.category_listing_id_seq OWNER TO ozp_user;

--
-- Name: category_listing_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ozp_user
--

ALTER SEQUENCE category_listing_id_seq OWNED BY category_listing.id;


--
-- Name: contact_listing; Type: TABLE; Schema: public; Owner: ozp_user; Tablespace: 
--

CREATE TABLE contact_listing (
    id integer NOT NULL,
    listing_id integer NOT NULL,
    contact_id integer NOT NULL
);


ALTER TABLE public.contact_listing OWNER TO ozp_user;

--
-- Name: contact_listing_id_seq; Type: SEQUENCE; Schema: public; Owner: ozp_user
--

CREATE SEQUENCE contact_listing_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.contact_listing_id_seq OWNER TO ozp_user;

--
-- Name: contact_listing_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ozp_user
--

ALTER SEQUENCE contact_listing_id_seq OWNED BY contact_listing.id;


--
-- Name: corsheaders_corsmodel; Type: TABLE; Schema: public; Owner: ozp_user; Tablespace: 
--

CREATE TABLE corsheaders_corsmodel (
    id integer NOT NULL,
    cors character varying(255) NOT NULL
);


ALTER TABLE public.corsheaders_corsmodel OWNER TO ozp_user;

--
-- Name: corsheaders_corsmodel_id_seq; Type: SEQUENCE; Schema: public; Owner: ozp_user
--

CREATE SEQUENCE corsheaders_corsmodel_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.corsheaders_corsmodel_id_seq OWNER TO ozp_user;

--
-- Name: corsheaders_corsmodel_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ozp_user
--

ALTER SEQUENCE corsheaders_corsmodel_id_seq OWNED BY corsheaders_corsmodel.id;


--
-- Name: django_admin_log; Type: TABLE; Schema: public; Owner: ozp_user; Tablespace: 
--

CREATE TABLE django_admin_log (
    id integer NOT NULL,
    action_time timestamp with time zone NOT NULL,
    object_id text,
    object_repr character varying(200) NOT NULL,
    action_flag smallint NOT NULL,
    change_message text NOT NULL,
    content_type_id integer,
    user_id integer NOT NULL,
    CONSTRAINT django_admin_log_action_flag_check CHECK ((action_flag >= 0))
);


ALTER TABLE public.django_admin_log OWNER TO ozp_user;

--
-- Name: django_admin_log_id_seq; Type: SEQUENCE; Schema: public; Owner: ozp_user
--

CREATE SEQUENCE django_admin_log_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.django_admin_log_id_seq OWNER TO ozp_user;

--
-- Name: django_admin_log_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ozp_user
--

ALTER SEQUENCE django_admin_log_id_seq OWNED BY django_admin_log.id;


--
-- Name: django_content_type; Type: TABLE; Schema: public; Owner: ozp_user; Tablespace: 
--

CREATE TABLE django_content_type (
    id integer NOT NULL,
    app_label character varying(100) NOT NULL,
    model character varying(100) NOT NULL
);


ALTER TABLE public.django_content_type OWNER TO ozp_user;

--
-- Name: django_content_type_id_seq; Type: SEQUENCE; Schema: public; Owner: ozp_user
--

CREATE SEQUENCE django_content_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.django_content_type_id_seq OWNER TO ozp_user;

--
-- Name: django_content_type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ozp_user
--

ALTER SEQUENCE django_content_type_id_seq OWNED BY django_content_type.id;


--
-- Name: django_migrations; Type: TABLE; Schema: public; Owner: ozp_user; Tablespace: 
--

CREATE TABLE django_migrations (
    id integer NOT NULL,
    app character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    applied timestamp with time zone NOT NULL
);


ALTER TABLE public.django_migrations OWNER TO ozp_user;

--
-- Name: django_migrations_id_seq; Type: SEQUENCE; Schema: public; Owner: ozp_user
--

CREATE SEQUENCE django_migrations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.django_migrations_id_seq OWNER TO ozp_user;

--
-- Name: django_migrations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ozp_user
--

ALTER SEQUENCE django_migrations_id_seq OWNED BY django_migrations.id;


--
-- Name: django_session; Type: TABLE; Schema: public; Owner: ozp_user; Tablespace: 
--

CREATE TABLE django_session (
    session_key character varying(40) NOT NULL,
    session_data text NOT NULL,
    expire_date timestamp with time zone NOT NULL
);


ALTER TABLE public.django_session OWNER TO ozp_user;

--
-- Name: intent_listing; Type: TABLE; Schema: public; Owner: ozp_user; Tablespace: 
--

CREATE TABLE intent_listing (
    id integer NOT NULL,
    listing_id integer NOT NULL,
    intent_id integer NOT NULL
);


ALTER TABLE public.intent_listing OWNER TO ozp_user;

--
-- Name: intent_listing_id_seq; Type: SEQUENCE; Schema: public; Owner: ozp_user
--

CREATE SEQUENCE intent_listing_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.intent_listing_id_seq OWNER TO ozp_user;

--
-- Name: intent_listing_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ozp_user
--

ALTER SEQUENCE intent_listing_id_seq OWNED BY intent_listing.id;


--
-- Name: listing_activity_change_detail; Type: TABLE; Schema: public; Owner: ozp_user; Tablespace: 
--

CREATE TABLE listing_activity_change_detail (
    id integer NOT NULL,
    listingactivity_id integer NOT NULL,
    changedetail_id integer NOT NULL
);


ALTER TABLE public.listing_activity_change_detail OWNER TO ozp_user;

--
-- Name: listing_activity_change_detail_id_seq; Type: SEQUENCE; Schema: public; Owner: ozp_user
--

CREATE SEQUENCE listing_activity_change_detail_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.listing_activity_change_detail_id_seq OWNER TO ozp_user;

--
-- Name: listing_activity_change_detail_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ozp_user
--

ALTER SEQUENCE listing_activity_change_detail_id_seq OWNED BY listing_activity_change_detail.id;


--
-- Name: notification_profile; Type: TABLE; Schema: public; Owner: ozp_user; Tablespace: 
--

CREATE TABLE notification_profile (
    id integer NOT NULL,
    notification_id integer NOT NULL,
    profile_id integer NOT NULL
);


ALTER TABLE public.notification_profile OWNER TO ozp_user;

--
-- Name: notification_profile_id_seq; Type: SEQUENCE; Schema: public; Owner: ozp_user
--

CREATE SEQUENCE notification_profile_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.notification_profile_id_seq OWNER TO ozp_user;

--
-- Name: notification_profile_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ozp_user
--

ALTER SEQUENCE notification_profile_id_seq OWNED BY notification_profile.id;


--
-- Name: ozpcenter_agency; Type: TABLE; Schema: public; Owner: ozp_user; Tablespace: 
--

CREATE TABLE ozpcenter_agency (
    id integer NOT NULL,
    title character varying(255) NOT NULL,
    short_name character varying(32) NOT NULL,
    icon_id integer
);


ALTER TABLE public.ozpcenter_agency OWNER TO ozp_user;

--
-- Name: ozpcenter_agency_id_seq; Type: SEQUENCE; Schema: public; Owner: ozp_user
--

CREATE SEQUENCE ozpcenter_agency_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ozpcenter_agency_id_seq OWNER TO ozp_user;

--
-- Name: ozpcenter_agency_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ozp_user
--

ALTER SEQUENCE ozpcenter_agency_id_seq OWNED BY ozpcenter_agency.id;


--
-- Name: ozpcenter_applicationlibraryentry; Type: TABLE; Schema: public; Owner: ozp_user; Tablespace: 
--

CREATE TABLE ozpcenter_applicationlibraryentry (
    id integer NOT NULL,
    folder character varying(255),
    listing_id integer NOT NULL,
    owner_id integer NOT NULL,
    "position" integer NOT NULL,
    CONSTRAINT ozpcenter_applicationlibraryentry_position_check CHECK (("position" >= 0))
);


ALTER TABLE public.ozpcenter_applicationlibraryentry OWNER TO ozp_user;

--
-- Name: ozpcenter_applicationlibraryentry_id_seq; Type: SEQUENCE; Schema: public; Owner: ozp_user
--

CREATE SEQUENCE ozpcenter_applicationlibraryentry_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ozpcenter_applicationlibraryentry_id_seq OWNER TO ozp_user;

--
-- Name: ozpcenter_applicationlibraryentry_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ozp_user
--

ALTER SEQUENCE ozpcenter_applicationlibraryentry_id_seq OWNED BY ozpcenter_applicationlibraryentry.id;


--
-- Name: ozpcenter_category; Type: TABLE; Schema: public; Owner: ozp_user; Tablespace: 
--

CREATE TABLE ozpcenter_category (
    id integer NOT NULL,
    title character varying(50) NOT NULL,
    description character varying(255)
);


ALTER TABLE public.ozpcenter_category OWNER TO ozp_user;

--
-- Name: ozpcenter_category_id_seq; Type: SEQUENCE; Schema: public; Owner: ozp_user
--

CREATE SEQUENCE ozpcenter_category_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ozpcenter_category_id_seq OWNER TO ozp_user;

--
-- Name: ozpcenter_category_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ozp_user
--

ALTER SEQUENCE ozpcenter_category_id_seq OWNED BY ozpcenter_category.id;


--
-- Name: ozpcenter_changedetail; Type: TABLE; Schema: public; Owner: ozp_user; Tablespace: 
--

CREATE TABLE ozpcenter_changedetail (
    id integer NOT NULL,
    field_name character varying(255) NOT NULL,
    old_value character varying(4000),
    new_value character varying(4000)
);


ALTER TABLE public.ozpcenter_changedetail OWNER TO ozp_user;

--
-- Name: ozpcenter_changedetail_id_seq; Type: SEQUENCE; Schema: public; Owner: ozp_user
--

CREATE SEQUENCE ozpcenter_changedetail_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ozpcenter_changedetail_id_seq OWNER TO ozp_user;

--
-- Name: ozpcenter_changedetail_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ozp_user
--

ALTER SEQUENCE ozpcenter_changedetail_id_seq OWNED BY ozpcenter_changedetail.id;


--
-- Name: ozpcenter_contact; Type: TABLE; Schema: public; Owner: ozp_user; Tablespace: 
--

CREATE TABLE ozpcenter_contact (
    id integer NOT NULL,
    secure_phone character varying(50),
    unsecure_phone character varying(50),
    email character varying(100) NOT NULL,
    name character varying(100) NOT NULL,
    organization character varying(100),
    contact_type_id integer NOT NULL
);


ALTER TABLE public.ozpcenter_contact OWNER TO ozp_user;

--
-- Name: ozpcenter_contact_id_seq; Type: SEQUENCE; Schema: public; Owner: ozp_user
--

CREATE SEQUENCE ozpcenter_contact_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ozpcenter_contact_id_seq OWNER TO ozp_user;

--
-- Name: ozpcenter_contact_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ozp_user
--

ALTER SEQUENCE ozpcenter_contact_id_seq OWNED BY ozpcenter_contact.id;


--
-- Name: ozpcenter_contacttype; Type: TABLE; Schema: public; Owner: ozp_user; Tablespace: 
--

CREATE TABLE ozpcenter_contacttype (
    id integer NOT NULL,
    name character varying(50) NOT NULL,
    required boolean NOT NULL
);


ALTER TABLE public.ozpcenter_contacttype OWNER TO ozp_user;

--
-- Name: ozpcenter_contacttype_id_seq; Type: SEQUENCE; Schema: public; Owner: ozp_user
--

CREATE SEQUENCE ozpcenter_contacttype_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ozpcenter_contacttype_id_seq OWNER TO ozp_user;

--
-- Name: ozpcenter_contacttype_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ozp_user
--

ALTER SEQUENCE ozpcenter_contacttype_id_seq OWNED BY ozpcenter_contacttype.id;


--
-- Name: ozpcenter_docurl; Type: TABLE; Schema: public; Owner: ozp_user; Tablespace: 
--

CREATE TABLE ozpcenter_docurl (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    url character varying(2083) NOT NULL,
    listing_id integer NOT NULL
);


ALTER TABLE public.ozpcenter_docurl OWNER TO ozp_user;

--
-- Name: ozpcenter_docurl_id_seq; Type: SEQUENCE; Schema: public; Owner: ozp_user
--

CREATE SEQUENCE ozpcenter_docurl_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ozpcenter_docurl_id_seq OWNER TO ozp_user;

--
-- Name: ozpcenter_docurl_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ozp_user
--

ALTER SEQUENCE ozpcenter_docurl_id_seq OWNED BY ozpcenter_docurl.id;


--
-- Name: ozpcenter_image; Type: TABLE; Schema: public; Owner: ozp_user; Tablespace: 
--

CREATE TABLE ozpcenter_image (
    id integer NOT NULL,
    uuid character varying(36) NOT NULL,
    security_marking character varying(1024) NOT NULL,
    file_extension character varying(16) NOT NULL,
    image_type_id integer NOT NULL
);


ALTER TABLE public.ozpcenter_image OWNER TO ozp_user;

--
-- Name: ozpcenter_image_id_seq; Type: SEQUENCE; Schema: public; Owner: ozp_user
--

CREATE SEQUENCE ozpcenter_image_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ozpcenter_image_id_seq OWNER TO ozp_user;

--
-- Name: ozpcenter_image_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ozp_user
--

ALTER SEQUENCE ozpcenter_image_id_seq OWNED BY ozpcenter_image.id;


--
-- Name: ozpcenter_imagetype; Type: TABLE; Schema: public; Owner: ozp_user; Tablespace: 
--

CREATE TABLE ozpcenter_imagetype (
    id integer NOT NULL,
    name character varying(64) NOT NULL,
    max_size_bytes integer NOT NULL,
    max_width integer NOT NULL,
    max_height integer NOT NULL,
    min_width integer NOT NULL,
    min_height integer NOT NULL
);


ALTER TABLE public.ozpcenter_imagetype OWNER TO ozp_user;

--
-- Name: ozpcenter_imagetype_id_seq; Type: SEQUENCE; Schema: public; Owner: ozp_user
--

CREATE SEQUENCE ozpcenter_imagetype_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ozpcenter_imagetype_id_seq OWNER TO ozp_user;

--
-- Name: ozpcenter_imagetype_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ozp_user
--

ALTER SEQUENCE ozpcenter_imagetype_id_seq OWNED BY ozpcenter_imagetype.id;


--
-- Name: ozpcenter_intent; Type: TABLE; Schema: public; Owner: ozp_user; Tablespace: 
--

CREATE TABLE ozpcenter_intent (
    id integer NOT NULL,
    action character varying(64) NOT NULL,
    media_type character varying(129) NOT NULL,
    label character varying(255) NOT NULL,
    icon_id integer NOT NULL
);


ALTER TABLE public.ozpcenter_intent OWNER TO ozp_user;

--
-- Name: ozpcenter_intent_id_seq; Type: SEQUENCE; Schema: public; Owner: ozp_user
--

CREATE SEQUENCE ozpcenter_intent_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ozpcenter_intent_id_seq OWNER TO ozp_user;

--
-- Name: ozpcenter_intent_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ozp_user
--

ALTER SEQUENCE ozpcenter_intent_id_seq OWNED BY ozpcenter_intent.id;


--
-- Name: ozpcenter_listing; Type: TABLE; Schema: public; Owner: ozp_user; Tablespace: 
--

CREATE TABLE ozpcenter_listing (
    id integer NOT NULL,
    title character varying(255) NOT NULL,
    approved_date timestamp with time zone,
    edited_date timestamp with time zone NOT NULL,
    description character varying(8192),
    launch_url character varying(2083),
    version_name character varying(255),
    unique_name character varying(255),
    what_is_new character varying(255),
    description_short character varying(150),
    usage_requirements character varying(1000),
    approval_status character varying(255) NOT NULL,
    is_enabled boolean NOT NULL,
    is_featured boolean NOT NULL,
    avg_rate double precision NOT NULL,
    total_votes integer NOT NULL,
    total_rate5 integer NOT NULL,
    total_rate4 integer NOT NULL,
    total_rate3 integer NOT NULL,
    total_rate2 integer NOT NULL,
    total_rate1 integer NOT NULL,
    total_reviews integer NOT NULL,
    iframe_compatible boolean NOT NULL,
    security_marking character varying(1024),
    is_private boolean NOT NULL,
    agency_id integer NOT NULL,
    banner_icon_id integer,
    current_rejection_id integer,
    large_banner_icon_id integer,
    large_icon_id integer,
    last_activity_id integer,
    listing_type_id integer,
    required_listings_id integer,
    small_icon_id integer,
    is_deleted boolean NOT NULL,
    total_review_responses integer NOT NULL,
    system_requirements character varying(1000),
    feedback_score integer NOT NULL
);


ALTER TABLE public.ozpcenter_listing OWNER TO ozp_user;

--
-- Name: ozpcenter_listing_id_seq; Type: SEQUENCE; Schema: public; Owner: ozp_user
--

CREATE SEQUENCE ozpcenter_listing_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ozpcenter_listing_id_seq OWNER TO ozp_user;

--
-- Name: ozpcenter_listing_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ozp_user
--

ALTER SEQUENCE ozpcenter_listing_id_seq OWNED BY ozpcenter_listing.id;


--
-- Name: ozpcenter_listingactivity; Type: TABLE; Schema: public; Owner: ozp_user; Tablespace: 
--

CREATE TABLE ozpcenter_listingactivity (
    id integer NOT NULL,
    action character varying(128) NOT NULL,
    activity_date timestamp with time zone NOT NULL,
    description character varying(2000),
    author_id integer NOT NULL,
    listing_id integer NOT NULL
);


ALTER TABLE public.ozpcenter_listingactivity OWNER TO ozp_user;

--
-- Name: ozpcenter_listingactivity_id_seq; Type: SEQUENCE; Schema: public; Owner: ozp_user
--

CREATE SEQUENCE ozpcenter_listingactivity_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ozpcenter_listingactivity_id_seq OWNER TO ozp_user;

--
-- Name: ozpcenter_listingactivity_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ozp_user
--

ALTER SEQUENCE ozpcenter_listingactivity_id_seq OWNED BY ozpcenter_listingactivity.id;


--
-- Name: ozpcenter_listingtype; Type: TABLE; Schema: public; Owner: ozp_user; Tablespace: 
--

CREATE TABLE ozpcenter_listingtype (
    id integer NOT NULL,
    title character varying(50) NOT NULL,
    description character varying(255) NOT NULL
);


ALTER TABLE public.ozpcenter_listingtype OWNER TO ozp_user;

--
-- Name: ozpcenter_listingtype_id_seq; Type: SEQUENCE; Schema: public; Owner: ozp_user
--

CREATE SEQUENCE ozpcenter_listingtype_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ozpcenter_listingtype_id_seq OWNER TO ozp_user;

--
-- Name: ozpcenter_listingtype_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ozp_user
--

ALTER SEQUENCE ozpcenter_listingtype_id_seq OWNED BY ozpcenter_listingtype.id;


--
-- Name: ozpcenter_notification; Type: TABLE; Schema: public; Owner: ozp_user; Tablespace: 
--

CREATE TABLE ozpcenter_notification (
    id integer NOT NULL,
    created_date timestamp with time zone NOT NULL,
    message character varying(4096) NOT NULL,
    expires_date timestamp with time zone NOT NULL,
    author_id integer NOT NULL,
    listing_id integer,
    agency_id integer,
    peer character varying(4096),
    group_target character varying(24) NOT NULL,
    notification_type character varying(24) NOT NULL,
    entity_id integer,
    notification_subtype character varying(36)
);


ALTER TABLE public.ozpcenter_notification OWNER TO ozp_user;

--
-- Name: ozpcenter_notification_id_seq; Type: SEQUENCE; Schema: public; Owner: ozp_user
--

CREATE SEQUENCE ozpcenter_notification_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ozpcenter_notification_id_seq OWNER TO ozp_user;

--
-- Name: ozpcenter_notification_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ozp_user
--

ALTER SEQUENCE ozpcenter_notification_id_seq OWNED BY ozpcenter_notification.id;


--
-- Name: ozpcenter_notificationmailbox; Type: TABLE; Schema: public; Owner: ozp_user; Tablespace: 
--

CREATE TABLE ozpcenter_notificationmailbox (
    id integer NOT NULL,
    target_profile_id integer NOT NULL,
    notification_id integer NOT NULL,
    emailed_status boolean NOT NULL,
    read_status boolean NOT NULL,
    acknowledged_status boolean NOT NULL
);


ALTER TABLE public.ozpcenter_notificationmailbox OWNER TO ozp_user;

--
-- Name: ozpcenter_notificationmailbox_id_seq; Type: SEQUENCE; Schema: public; Owner: ozp_user
--

CREATE SEQUENCE ozpcenter_notificationmailbox_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ozpcenter_notificationmailbox_id_seq OWNER TO ozp_user;

--
-- Name: ozpcenter_notificationmailbox_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ozp_user
--

ALTER SEQUENCE ozpcenter_notificationmailbox_id_seq OWNED BY ozpcenter_notificationmailbox.id;


--
-- Name: ozpcenter_profile; Type: TABLE; Schema: public; Owner: ozp_user; Tablespace: 
--

CREATE TABLE ozpcenter_profile (
    id integer NOT NULL,
    display_name character varying(255) NOT NULL,
    bio character varying(1000) NOT NULL,
    dn character varying(1000) NOT NULL,
    issuer_dn character varying(1000),
    auth_expires timestamp with time zone NOT NULL,
    access_control character varying(16384) NOT NULL,
    user_id integer,
    center_tour_flag boolean NOT NULL,
    hud_tour_flag boolean NOT NULL,
    webtop_tour_flag boolean NOT NULL,
    email_notification_flag boolean NOT NULL,
    listing_notification_flag boolean NOT NULL,
    subscription_notification_flag boolean NOT NULL,
    leaving_ozp_warning_flag boolean NOT NULL
);


ALTER TABLE public.ozpcenter_profile OWNER TO ozp_user;

--
-- Name: ozpcenter_profile_id_seq; Type: SEQUENCE; Schema: public; Owner: ozp_user
--

CREATE SEQUENCE ozpcenter_profile_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ozpcenter_profile_id_seq OWNER TO ozp_user;

--
-- Name: ozpcenter_profile_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ozp_user
--

ALTER SEQUENCE ozpcenter_profile_id_seq OWNED BY ozpcenter_profile.id;


--
-- Name: ozpcenter_recommendationfeedback; Type: TABLE; Schema: public; Owner: ozp_user; Tablespace: 
--

CREATE TABLE ozpcenter_recommendationfeedback (
    id integer NOT NULL,
    feedback integer NOT NULL,
    target_listing_id integer NOT NULL,
    target_profile_id integer NOT NULL
);


ALTER TABLE public.ozpcenter_recommendationfeedback OWNER TO ozp_user;

--
-- Name: ozpcenter_recommendationfeedback_id_seq; Type: SEQUENCE; Schema: public; Owner: ozp_user
--

CREATE SEQUENCE ozpcenter_recommendationfeedback_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ozpcenter_recommendationfeedback_id_seq OWNER TO ozp_user;

--
-- Name: ozpcenter_recommendationfeedback_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ozp_user
--

ALTER SEQUENCE ozpcenter_recommendationfeedback_id_seq OWNED BY ozpcenter_recommendationfeedback.id;


--
-- Name: ozpcenter_recommendationsentry; Type: TABLE; Schema: public; Owner: ozp_user; Tablespace: 
--

CREATE TABLE ozpcenter_recommendationsentry (
    id integer NOT NULL,
    target_profile_id integer NOT NULL,
    recommendation_data bytea NOT NULL
);


ALTER TABLE public.ozpcenter_recommendationsentry OWNER TO ozp_user;

--
-- Name: ozpcenter_recommendationsentry_id_seq; Type: SEQUENCE; Schema: public; Owner: ozp_user
--

CREATE SEQUENCE ozpcenter_recommendationsentry_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ozpcenter_recommendationsentry_id_seq OWNER TO ozp_user;

--
-- Name: ozpcenter_recommendationsentry_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ozp_user
--

ALTER SEQUENCE ozpcenter_recommendationsentry_id_seq OWNED BY ozpcenter_recommendationsentry.id;


--
-- Name: ozpcenter_review; Type: TABLE; Schema: public; Owner: ozp_user; Tablespace: 
--

CREATE TABLE ozpcenter_review (
    id integer NOT NULL,
    text character varying(4000),
    rate integer NOT NULL,
    edited_date timestamp with time zone NOT NULL,
    author_id integer NOT NULL,
    listing_id integer NOT NULL,
    review_parent_id integer,
    created_date timestamp with time zone NOT NULL
);


ALTER TABLE public.ozpcenter_review OWNER TO ozp_user;

--
-- Name: ozpcenter_review_id_seq; Type: SEQUENCE; Schema: public; Owner: ozp_user
--

CREATE SEQUENCE ozpcenter_review_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ozpcenter_review_id_seq OWNER TO ozp_user;

--
-- Name: ozpcenter_review_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ozp_user
--

ALTER SEQUENCE ozpcenter_review_id_seq OWNED BY ozpcenter_review.id;


--
-- Name: ozpcenter_screenshot; Type: TABLE; Schema: public; Owner: ozp_user; Tablespace: 
--

CREATE TABLE ozpcenter_screenshot (
    id integer NOT NULL,
    large_image_id integer NOT NULL,
    listing_id integer NOT NULL,
    small_image_id integer NOT NULL,
    description character varying(160),
    "order" integer
);


ALTER TABLE public.ozpcenter_screenshot OWNER TO ozp_user;

--
-- Name: ozpcenter_screenshot_id_seq; Type: SEQUENCE; Schema: public; Owner: ozp_user
--

CREATE SEQUENCE ozpcenter_screenshot_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ozpcenter_screenshot_id_seq OWNER TO ozp_user;

--
-- Name: ozpcenter_screenshot_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ozp_user
--

ALTER SEQUENCE ozpcenter_screenshot_id_seq OWNED BY ozpcenter_screenshot.id;


--
-- Name: ozpcenter_subscription; Type: TABLE; Schema: public; Owner: ozp_user; Tablespace: 
--

CREATE TABLE ozpcenter_subscription (
    id integer NOT NULL,
    entity_type character varying(12) NOT NULL,
    entity_id integer NOT NULL,
    target_profile_id integer NOT NULL
);


ALTER TABLE public.ozpcenter_subscription OWNER TO ozp_user;

--
-- Name: ozpcenter_subscription_id_seq; Type: SEQUENCE; Schema: public; Owner: ozp_user
--

CREATE SEQUENCE ozpcenter_subscription_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ozpcenter_subscription_id_seq OWNER TO ozp_user;

--
-- Name: ozpcenter_subscription_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ozp_user
--

ALTER SEQUENCE ozpcenter_subscription_id_seq OWNED BY ozpcenter_subscription.id;


--
-- Name: ozpcenter_tag; Type: TABLE; Schema: public; Owner: ozp_user; Tablespace: 
--

CREATE TABLE ozpcenter_tag (
    id integer NOT NULL,
    name character varying(30) NOT NULL
);


ALTER TABLE public.ozpcenter_tag OWNER TO ozp_user;

--
-- Name: ozpcenter_tag_id_seq; Type: SEQUENCE; Schema: public; Owner: ozp_user
--

CREATE SEQUENCE ozpcenter_tag_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ozpcenter_tag_id_seq OWNER TO ozp_user;

--
-- Name: ozpcenter_tag_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ozp_user
--

ALTER SEQUENCE ozpcenter_tag_id_seq OWNED BY ozpcenter_tag.id;


--
-- Name: ozpiwc_dataresource; Type: TABLE; Schema: public; Owner: ozp_user; Tablespace: 
--

CREATE TABLE ozpiwc_dataresource (
    id integer NOT NULL,
    key character varying(1024) NOT NULL,
    entity character varying(1048576),
    content_type character varying(1024),
    username character varying(128) NOT NULL,
    pattern character varying(1024),
    permissions character varying(1024),
    version character varying(1024)
);


ALTER TABLE public.ozpiwc_dataresource OWNER TO ozp_user;

--
-- Name: ozpiwc_dataresource_id_seq; Type: SEQUENCE; Schema: public; Owner: ozp_user
--

CREATE SEQUENCE ozpiwc_dataresource_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ozpiwc_dataresource_id_seq OWNER TO ozp_user;

--
-- Name: ozpiwc_dataresource_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ozp_user
--

ALTER SEQUENCE ozpiwc_dataresource_id_seq OWNED BY ozpiwc_dataresource.id;


--
-- Name: profile_listing; Type: TABLE; Schema: public; Owner: ozp_user; Tablespace: 
--

CREATE TABLE profile_listing (
    id integer NOT NULL,
    listing_id integer NOT NULL,
    profile_id integer NOT NULL
);


ALTER TABLE public.profile_listing OWNER TO ozp_user;

--
-- Name: profile_listing_id_seq; Type: SEQUENCE; Schema: public; Owner: ozp_user
--

CREATE SEQUENCE profile_listing_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.profile_listing_id_seq OWNER TO ozp_user;

--
-- Name: profile_listing_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ozp_user
--

ALTER SEQUENCE profile_listing_id_seq OWNED BY profile_listing.id;


--
-- Name: stewarded_agency_profile; Type: TABLE; Schema: public; Owner: ozp_user; Tablespace: 
--

CREATE TABLE stewarded_agency_profile (
    id integer NOT NULL,
    profile_id integer NOT NULL,
    agency_id integer NOT NULL
);


ALTER TABLE public.stewarded_agency_profile OWNER TO ozp_user;

--
-- Name: stewarded_agency_profile_id_seq; Type: SEQUENCE; Schema: public; Owner: ozp_user
--

CREATE SEQUENCE stewarded_agency_profile_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.stewarded_agency_profile_id_seq OWNER TO ozp_user;

--
-- Name: stewarded_agency_profile_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ozp_user
--

ALTER SEQUENCE stewarded_agency_profile_id_seq OWNED BY stewarded_agency_profile.id;


--
-- Name: tag_listing; Type: TABLE; Schema: public; Owner: ozp_user; Tablespace: 
--

CREATE TABLE tag_listing (
    id integer NOT NULL,
    listing_id integer NOT NULL,
    tag_id integer NOT NULL
);


ALTER TABLE public.tag_listing OWNER TO ozp_user;

--
-- Name: tag_listing_id_seq; Type: SEQUENCE; Schema: public; Owner: ozp_user
--

CREATE SEQUENCE tag_listing_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tag_listing_id_seq OWNER TO ozp_user;

--
-- Name: tag_listing_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ozp_user
--

ALTER SEQUENCE tag_listing_id_seq OWNED BY tag_listing.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: ozp_user
--

ALTER TABLE ONLY agency_profile ALTER COLUMN id SET DEFAULT nextval('agency_profile_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: ozp_user
--

ALTER TABLE ONLY auth_group ALTER COLUMN id SET DEFAULT nextval('auth_group_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: ozp_user
--

ALTER TABLE ONLY auth_group_permissions ALTER COLUMN id SET DEFAULT nextval('auth_group_permissions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: ozp_user
--

ALTER TABLE ONLY auth_permission ALTER COLUMN id SET DEFAULT nextval('auth_permission_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: ozp_user
--

ALTER TABLE ONLY auth_user ALTER COLUMN id SET DEFAULT nextval('auth_user_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: ozp_user
--

ALTER TABLE ONLY auth_user_groups ALTER COLUMN id SET DEFAULT nextval('auth_user_groups_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: ozp_user
--

ALTER TABLE ONLY auth_user_user_permissions ALTER COLUMN id SET DEFAULT nextval('auth_user_user_permissions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: ozp_user
--

ALTER TABLE ONLY category_listing ALTER COLUMN id SET DEFAULT nextval('category_listing_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: ozp_user
--

ALTER TABLE ONLY contact_listing ALTER COLUMN id SET DEFAULT nextval('contact_listing_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: ozp_user
--

ALTER TABLE ONLY corsheaders_corsmodel ALTER COLUMN id SET DEFAULT nextval('corsheaders_corsmodel_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: ozp_user
--

ALTER TABLE ONLY django_admin_log ALTER COLUMN id SET DEFAULT nextval('django_admin_log_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: ozp_user
--

ALTER TABLE ONLY django_content_type ALTER COLUMN id SET DEFAULT nextval('django_content_type_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: ozp_user
--

ALTER TABLE ONLY django_migrations ALTER COLUMN id SET DEFAULT nextval('django_migrations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: ozp_user
--

ALTER TABLE ONLY intent_listing ALTER COLUMN id SET DEFAULT nextval('intent_listing_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: ozp_user
--

ALTER TABLE ONLY listing_activity_change_detail ALTER COLUMN id SET DEFAULT nextval('listing_activity_change_detail_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: ozp_user
--

ALTER TABLE ONLY notification_profile ALTER COLUMN id SET DEFAULT nextval('notification_profile_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: ozp_user
--

ALTER TABLE ONLY ozpcenter_agency ALTER COLUMN id SET DEFAULT nextval('ozpcenter_agency_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: ozp_user
--

ALTER TABLE ONLY ozpcenter_applicationlibraryentry ALTER COLUMN id SET DEFAULT nextval('ozpcenter_applicationlibraryentry_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: ozp_user
--

ALTER TABLE ONLY ozpcenter_category ALTER COLUMN id SET DEFAULT nextval('ozpcenter_category_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: ozp_user
--

ALTER TABLE ONLY ozpcenter_changedetail ALTER COLUMN id SET DEFAULT nextval('ozpcenter_changedetail_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: ozp_user
--

ALTER TABLE ONLY ozpcenter_contact ALTER COLUMN id SET DEFAULT nextval('ozpcenter_contact_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: ozp_user
--

ALTER TABLE ONLY ozpcenter_contacttype ALTER COLUMN id SET DEFAULT nextval('ozpcenter_contacttype_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: ozp_user
--

ALTER TABLE ONLY ozpcenter_docurl ALTER COLUMN id SET DEFAULT nextval('ozpcenter_docurl_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: ozp_user
--

ALTER TABLE ONLY ozpcenter_image ALTER COLUMN id SET DEFAULT nextval('ozpcenter_image_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: ozp_user
--

ALTER TABLE ONLY ozpcenter_imagetype ALTER COLUMN id SET DEFAULT nextval('ozpcenter_imagetype_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: ozp_user
--

ALTER TABLE ONLY ozpcenter_intent ALTER COLUMN id SET DEFAULT nextval('ozpcenter_intent_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: ozp_user
--

ALTER TABLE ONLY ozpcenter_listing ALTER COLUMN id SET DEFAULT nextval('ozpcenter_listing_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: ozp_user
--

ALTER TABLE ONLY ozpcenter_listingactivity ALTER COLUMN id SET DEFAULT nextval('ozpcenter_listingactivity_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: ozp_user
--

ALTER TABLE ONLY ozpcenter_listingtype ALTER COLUMN id SET DEFAULT nextval('ozpcenter_listingtype_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: ozp_user
--

ALTER TABLE ONLY ozpcenter_notification ALTER COLUMN id SET DEFAULT nextval('ozpcenter_notification_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: ozp_user
--

ALTER TABLE ONLY ozpcenter_notificationmailbox ALTER COLUMN id SET DEFAULT nextval('ozpcenter_notificationmailbox_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: ozp_user
--

ALTER TABLE ONLY ozpcenter_profile ALTER COLUMN id SET DEFAULT nextval('ozpcenter_profile_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: ozp_user
--

ALTER TABLE ONLY ozpcenter_recommendationfeedback ALTER COLUMN id SET DEFAULT nextval('ozpcenter_recommendationfeedback_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: ozp_user
--

ALTER TABLE ONLY ozpcenter_recommendationsentry ALTER COLUMN id SET DEFAULT nextval('ozpcenter_recommendationsentry_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: ozp_user
--

ALTER TABLE ONLY ozpcenter_review ALTER COLUMN id SET DEFAULT nextval('ozpcenter_review_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: ozp_user
--

ALTER TABLE ONLY ozpcenter_screenshot ALTER COLUMN id SET DEFAULT nextval('ozpcenter_screenshot_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: ozp_user
--

ALTER TABLE ONLY ozpcenter_subscription ALTER COLUMN id SET DEFAULT nextval('ozpcenter_subscription_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: ozp_user
--

ALTER TABLE ONLY ozpcenter_tag ALTER COLUMN id SET DEFAULT nextval('ozpcenter_tag_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: ozp_user
--

ALTER TABLE ONLY ozpiwc_dataresource ALTER COLUMN id SET DEFAULT nextval('ozpiwc_dataresource_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: ozp_user
--

ALTER TABLE ONLY profile_listing ALTER COLUMN id SET DEFAULT nextval('profile_listing_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: ozp_user
--

ALTER TABLE ONLY stewarded_agency_profile ALTER COLUMN id SET DEFAULT nextval('stewarded_agency_profile_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: ozp_user
--

ALTER TABLE ONLY tag_listing ALTER COLUMN id SET DEFAULT nextval('tag_listing_id_seq'::regclass);


--
-- Data for Name: agency_profile; Type: TABLE DATA; Schema: public; Owner: ozp_user
--

COPY agency_profile (id, profile_id, agency_id) FROM stdin;
253	1	2
254	2	1
255	3	4
256	4	3
257	5	1
258	6	1
259	7	2
260	8	3
261	9	3
262	10	3
263	11	3
264	12	3
265	13	1
266	14	1
267	15	4
268	16	4
269	17	2
270	18	2
271	19	2
272	19	3
273	20	2
274	20	3
275	21	1
276	21	2
277	21	3
278	22	1
279	22	2
280	22	3
\.


--
-- Name: agency_profile_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ozp_user
--

SELECT pg_catalog.setval('agency_profile_id_seq', 280, true);


--
-- Data for Name: auth_group; Type: TABLE DATA; Schema: public; Owner: ozp_user
--

COPY auth_group (id, name) FROM stdin;
1	USER
2	ORG_STEWARD
3	APPS_MALL_STEWARD
4	BETA_USER
\.


--
-- Name: auth_group_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ozp_user
--

SELECT pg_catalog.setval('auth_group_id_seq', 4, true);


--
-- Data for Name: auth_group_permissions; Type: TABLE DATA; Schema: public; Owner: ozp_user
--

COPY auth_group_permissions (id, group_id, permission_id) FROM stdin;
\.


--
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ozp_user
--

SELECT pg_catalog.setval('auth_group_permissions_id_seq', 1, false);


--
-- Data for Name: auth_permission; Type: TABLE DATA; Schema: public; Owner: ozp_user
--

COPY auth_permission (id, name, content_type_id, codename) FROM stdin;
1	Can add log entry	1	add_logentry
2	Can change log entry	1	change_logentry
3	Can delete log entry	1	delete_logentry
4	Can add content type	2	add_contenttype
5	Can change content type	2	change_contenttype
6	Can delete content type	2	delete_contenttype
7	Can add permission	5	add_permission
8	Can change permission	5	change_permission
9	Can delete permission	5	delete_permission
10	Can add group	3	add_group
11	Can change group	3	change_group
12	Can delete group	3	delete_group
13	Can add user	4	add_user
14	Can change user	4	change_user
15	Can delete user	4	delete_user
16	Can add session	6	add_session
17	Can change session	6	change_session
18	Can delete session	6	delete_session
19	Can add image type	9	add_imagetype
20	Can change image type	9	change_imagetype
21	Can delete image type	9	delete_imagetype
22	Can add image	15	add_image
23	Can change image	15	change_image
24	Can delete image	15	delete_image
25	Can add tag	28	add_tag
26	Can change tag	28	change_tag
27	Can delete tag	28	delete_tag
28	Can add agency	21	add_agency
29	Can change agency	21	change_agency
30	Can delete agency	21	delete_agency
31	Can add application library entry	27	add_applicationlibraryentry
32	Can change application library entry	27	change_applicationlibraryentry
33	Can delete application library entry	27	delete_applicationlibraryentry
34	Can add category	8	add_category
35	Can change category	8	change_category
36	Can delete category	8	delete_category
37	Can add change detail	7	add_changedetail
38	Can change change detail	7	change_changedetail
39	Can delete change detail	7	delete_changedetail
40	Can add contact	17	add_contact
41	Can change contact	17	change_contact
42	Can delete contact	17	delete_contact
43	Can add contact type	25	add_contacttype
44	Can change contact type	25	change_contacttype
45	Can delete contact type	25	delete_contacttype
46	Can add doc url	19	add_docurl
47	Can change doc url	19	change_docurl
48	Can delete doc url	19	delete_docurl
49	Can add intent	11	add_intent
50	Can change intent	11	change_intent
51	Can delete intent	11	delete_intent
52	Can add review	23	add_review
53	Can change review	23	change_review
54	Can delete review	23	delete_review
55	Can add profile	12	add_profile
56	Can change profile	12	change_profile
57	Can delete profile	12	delete_profile
58	Can add listing	16	add_listing
59	Can change listing	16	change_listing
60	Can delete listing	16	delete_listing
61	Can add recommendations entry	13	add_recommendationsentry
62	Can change recommendations entry	13	change_recommendationsentry
63	Can delete recommendations entry	13	delete_recommendationsentry
64	Can add recommendation feedback	18	add_recommendationfeedback
65	Can change recommendation feedback	18	change_recommendationfeedback
66	Can delete recommendation feedback	18	delete_recommendationfeedback
67	Can add listing activity	26	add_listingactivity
68	Can change listing activity	26	change_listingactivity
69	Can delete listing activity	26	delete_listingactivity
70	Can add screenshot	20	add_screenshot
71	Can change screenshot	20	change_screenshot
72	Can delete screenshot	20	delete_screenshot
73	Can add listing type	24	add_listingtype
74	Can change listing type	24	change_listingtype
75	Can delete listing type	24	delete_listingtype
76	Can add notification	22	add_notification
77	Can change notification	22	change_notification
78	Can delete notification	22	delete_notification
79	Can add notification mail box	10	add_notificationmailbox
80	Can change notification mail box	10	change_notificationmailbox
81	Can delete notification mail box	10	delete_notificationmailbox
82	Can add subscription	14	add_subscription
83	Can change subscription	14	change_subscription
84	Can delete subscription	14	delete_subscription
85	Can add data resource	29	add_dataresource
86	Can change data resource	29	change_dataresource
87	Can delete data resource	29	delete_dataresource
\.


--
-- Name: auth_permission_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ozp_user
--

SELECT pg_catalog.setval('auth_permission_id_seq', 87, true);


--
-- Data for Name: auth_user; Type: TABLE DATA; Schema: public; Owner: ozp_user
--

COPY auth_user (id, password, last_login, is_superuser, username, first_name, last_name, email, is_staff, is_active, date_joined) FROM stdin;
1	pbkdf2_sha256$36000$USBW6axHgl01$LCbD0h7R5Mrv4YXvOF1Rsxgzk5zKsXs6lfMEqNBjiYI=	\N	t	bigbrother			bigbrother@oceania.gov	t	t	2017-11-08 18:07:36.216681-05
2	pbkdf2_sha256$36000$oM2BrkTVHJE6$qJcCz9p1kJ3tP1lwpWKTTlqNWhlxHQFW5q7QAbGVY0g=	\N	t	bigbrother2			bigbrother2@oceania.gov	t	t	2017-11-08 18:07:36.282342-05
3	pbkdf2_sha256$36000$B71a7a7TMqk5$4L4nnMDAizlIwaJWMYCe6ZCpGbU46A4JYyzWOaHDiSE=	\N	t	khaleesi			khaleesi@dragonborn.gov	t	t	2017-11-08 18:07:36.334896-05
4	pbkdf2_sha256$36000$whpc0kSmmE8G$ViCwabB4AkYt4q0SP6bhzcc3ytBXQq9L87DDY11a2SY=	\N	t	bettafish			bettafish@oceania.gov	t	t	2017-11-08 18:07:36.37855-05
5	pbkdf2_sha256$36000$uxfR6k6R341P$XHHsr8H5i7NcxL2xJrK0nb9bnRfAz0CS4gcHpm1B3g4=	\N	t	wsmith			wsmith@oceania.gov	t	t	2017-11-08 18:07:36.441005-05
6	pbkdf2_sha256$36000$jtJk9jHOJyap$x3lB3wwz3S/z7JcpleocliJjlD78GHqFLUExvLojA40=	\N	t	julia			julia@oceania.gov	t	t	2017-11-08 18:07:36.483552-05
7	pbkdf2_sha256$36000$QE6hqreCuP6E$R2Pzf7pe2R4b9BlZmzuqCZuxcqEo3bnnFAgzsX/SCgQ=	\N	t	obrien			obrien@oceania.gov	t	t	2017-11-08 18:07:36.528778-05
8	pbkdf2_sha256$36000$4jnXHXyezawf$ct5g82A265ydB9+dDwe1nZe+Y3HzgRyjv+I+1ojHLfM=	\N	t	david			david@oceania.gov	t	t	2017-11-08 18:07:36.573552-05
9	pbkdf2_sha256$36000$9o1dsPOSWWlo$tWX4Qo6BL5r9es3LWUpTNnYF04x48w5+ZyVDJAqiorw=	\N	f	aaronson			aaronson@airstripone.com	f	t	2017-11-08 18:07:36.615481-05
10	pbkdf2_sha256$36000$QbhqT1lEKtvh$Y8EvPKhJlC8vVm5+YC1GhaeA41eyN+akXQqoAupXNjk=	\N	f	pmurt			pmurt@airstripone.com	f	t	2017-11-08 18:07:36.654252-05
11	pbkdf2_sha256$36000$we51Ojpem29H$wRZUqsEUlZC+6PYNSzWUR8TaTTctby8aA63bqBQBw5g=	\N	f	hodor			hodor@hodor.com	f	t	2017-11-08 18:07:36.693225-05
12	pbkdf2_sha256$36000$Dt9Y8lDFePzv$IhLUQJCw2eG5Jz1wdQuWfrq4z7gjTsQDpLzTW1V8p9E=	\N	f	betaraybill			betaraybill@oceania.gov	f	t	2017-11-08 18:07:36.73289-05
13	pbkdf2_sha256$36000$SbVtPDYgLQvP$dsvcI7KcAF+KabVXZSVWiU1uNjr1ZJeltaZ9Zum33ag=	\N	f	jones			jones@airstripone.com	f	t	2017-11-08 18:07:36.774899-05
14	pbkdf2_sha256$36000$HZq3vPnE7UHi$Pl7Br03o6HdUpu8DAsZSJhv4ZVppR0RoK6W0FUNVthg=	\N	f	tammy			tammy@airstripone.com	f	t	2017-11-08 18:07:36.814332-05
15	pbkdf2_sha256$36000$IVqLRlI3qCgb$C+2nbhvwrAlrktljqTRH1P6D+U8G6GnjfkW7W0M1xs0=	\N	f	rutherford			rutherford@airstripone.com	f	t	2017-11-08 18:07:36.853288-05
16	pbkdf2_sha256$36000$3Fq7iXubYK3B$V2p9ghOG6XAFVvKeDPMTfS1i1wINNg6Xw3rqQ9+/E9M=	\N	f	noah			noah@airstripone.com	f	t	2017-11-08 18:07:36.893208-05
17	pbkdf2_sha256$36000$TkiQdBtPYhGR$UtNmFnTxs3/Kezan5ZJ3DPqYd15O9S+wsHBXNmfA3dc=	\N	f	syme			syme@airstripone.com	f	t	2017-11-08 18:07:36.93234-05
18	pbkdf2_sha256$36000$JgVPGb9VXy7H$gu1JIdBGkRkHfGEdyyb2IxbE1i1ZDvipkuDRyrXC0i8=	\N	f	abe			abe@airstripone.com	f	t	2017-11-08 18:07:36.971366-05
19	pbkdf2_sha256$36000$db0C70T1NxT0$KGo6ie8aj2uXl+XIO/w17mGjNr2QUdm8C8YNd9luL24=	\N	f	tparsons			tparsons@airstripone.com	f	t	2017-11-08 18:07:37.010573-05
20	pbkdf2_sha256$36000$mqOMPDjghSvZ$PTGJ6W1aJ/rWfS77hmmICewnu9ro6nM+JhovOnffHAg=	\N	f	jsnow			jsnow@forthewatch.com	f	t	2017-11-08 18:07:37.05298-05
21	pbkdf2_sha256$36000$mxMviNuml1KH$V6BRYz/7rivWi3vuz7AuYOy9y9XYgJzY7uPyytcpnjE=	\N	f	charrington			charrington@airstripone.com	f	t	2017-11-08 18:07:37.095-05
22	pbkdf2_sha256$36000$u2btlQspLIzW$32Bd959zZpE2sf+kF9c68Cn2DXBBFvEyq5RDj6qSAyE=	\N	f	johnson			johnson@airstripone.com	f	t	2017-11-08 18:07:37.140047-05
\.


--
-- Data for Name: auth_user_groups; Type: TABLE DATA; Schema: public; Owner: ozp_user
--

COPY auth_user_groups (id, user_id, group_id) FROM stdin;
217	1	3
218	2	3
219	3	3
220	4	3
221	4	4
222	5	2
223	6	2
224	7	2
225	8	2
226	9	1
227	10	1
228	11	1
229	12	1
230	12	4
231	13	1
232	14	1
233	15	1
234	16	1
235	17	1
236	18	1
237	19	1
238	20	1
239	21	1
240	22	1
\.


--
-- Name: auth_user_groups_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ozp_user
--

SELECT pg_catalog.setval('auth_user_groups_id_seq', 240, true);


--
-- Name: auth_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ozp_user
--

SELECT pg_catalog.setval('auth_user_id_seq', 22, true);


--
-- Data for Name: auth_user_user_permissions; Type: TABLE DATA; Schema: public; Owner: ozp_user
--

COPY auth_user_user_permissions (id, user_id, permission_id) FROM stdin;
\.


--
-- Name: auth_user_user_permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ozp_user
--

SELECT pg_catalog.setval('auth_user_user_permissions_id_seq', 1, false);


--
-- Data for Name: category_listing; Type: TABLE DATA; Schema: public; Owner: ozp_user
--

COPY category_listing (id, listing_id, category_id) FROM stdin;
2384	1	10
2385	2	4
2386	2	12
2387	3	4
2388	4	5
2389	5	5
2390	5	9
2391	5	15
2392	6	7
2393	6	16
2394	7	3
2395	7	7
2396	8	5
2397	8	16
2398	9	6
2399	10	14
2400	11	6
2401	12	4
2402	13	8
2403	13	9
2404	13	14
2405	14	4
2406	15	5
2407	16	7
2408	16	16
2409	17	3
2410	17	12
2411	17	15
2412	18	10
2413	19	7
2414	19	16
2415	20	12
2416	20	15
2417	21	8
2418	21	12
2419	22	15
2420	23	8
2421	23	13
2422	24	5
2423	24	6
2424	24	9
2425	25	5
2426	26	3
2427	27	3
2428	28	4
2429	28	11
2430	28	15
2431	29	4
2432	29	12
2433	30	5
2434	30	15
2435	31	9
2436	32	4
2437	33	8
2438	34	5
2439	35	8
2440	36	9
2441	37	6
2442	37	9
2443	38	5
2444	38	15
2445	39	15
2446	40	3
2447	41	7
2448	41	16
2449	42	7
2450	42	16
2451	43	2
2452	43	3
2453	43	8
2454	43	12
2455	43	14
2456	43	15
2457	43	16
2458	44	7
2459	45	5
2460	46	2
2461	47	6
2462	48	15
2463	49	10
2464	50	10
2465	51	6
2466	52	15
2467	53	14
2468	54	6
2469	55	8
2470	56	4
2471	57	2
2472	57	5
2473	58	5
2474	58	15
2475	59	12
2476	59	15
2477	60	4
2478	60	12
2479	61	12
2480	61	15
2481	62	6
2482	63	3
2483	64	5
2484	65	7
2485	66	5
2486	66	8
2487	66	15
2488	67	16
2489	68	9
2490	69	9
2491	70	6
2492	71	5
2493	71	15
2494	72	6
2495	73	2
2496	74	3
2497	74	4
2498	74	12
2499	75	4
2500	75	12
2501	76	6
2502	77	7
2503	77	16
2504	78	6
2505	79	2
2506	80	9
2507	81	7
2508	81	16
2509	82	5
2510	82	15
2511	83	3
2512	84	5
2513	84	8
2514	85	6
2515	85	15
2516	86	4
2517	86	12
2518	87	5
2519	88	6
2520	89	5
2521	90	6
2522	91	5
2523	92	2
2524	92	5
2525	93	16
2526	94	5
2527	95	5
2528	95	15
2529	96	5
2530	96	15
2531	97	5
2532	97	15
2533	98	6
2534	99	9
2535	99	12
2536	99	15
2537	100	7
2538	100	16
2539	101	9
2540	102	12
2541	102	15
2542	103	6
2543	104	6
2544	105	6
2545	106	12
2546	107	6
2547	108	5
2548	108	15
2549	109	6
2550	110	5
2551	111	8
2552	112	5
2553	112	11
2554	113	6
2555	114	6
2556	115	5
2557	115	6
2558	116	12
2559	116	15
2560	117	4
2561	117	12
2562	117	15
2563	118	8
2564	119	4
2565	120	4
2566	120	11
2567	121	5
2568	122	5
2569	122	6
2570	122	11
2571	123	15
2572	124	5
2573	125	5
2574	126	6
2575	127	10
2576	128	15
2577	129	6
2578	130	3
2579	130	8
2580	130	11
2581	131	5
2582	132	5
2583	133	3
2584	133	12
2585	134	12
2586	135	7
2587	135	16
2588	136	7
2589	137	12
2590	137	15
2591	138	15
2592	139	4
2593	139	10
2594	139	12
2595	140	15
2596	141	6
2597	142	14
2598	143	5
2599	144	11
2600	145	7
2601	146	12
2602	146	14
2603	146	15
2604	147	7
2605	148	3
2606	148	6
2607	149	10
2608	150	2
2609	150	4
2610	150	15
2611	151	15
2612	152	5
2613	152	15
2614	153	3
2615	153	4
2616	153	14
2617	154	16
2618	155	16
2619	156	10
2620	157	5
2621	158	15
2622	159	6
2623	160	6
2624	161	2
2625	162	15
2626	163	6
2627	163	10
2628	164	15
2629	165	5
2630	166	4
2631	166	6
2632	166	10
2633	167	14
2634	168	10
2635	169	16
2636	170	12
2637	170	13
2638	171	4
2639	171	9
2640	171	15
2641	172	5
2642	173	7
2643	174	6
2644	175	10
2645	176	6
2646	177	5
2647	178	8
2648	179	6
2649	179	8
2650	180	5
2651	181	4
2652	182	6
2653	182	8
2654	183	6
2655	184	5
2656	184	6
2657	185	4
2658	186	5
2659	187	7
2660	187	16
2661	188	4
\.


--
-- Name: category_listing_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ozp_user
--

SELECT pg_catalog.setval('category_listing_id_seq', 2661, true);


--
-- Data for Name: contact_listing; Type: TABLE DATA; Schema: public; Owner: ozp_user
--

COPY contact_listing (id, listing_id, contact_id) FROM stdin;
450	2	26
451	2	8
452	8	1
453	22	25
454	23	8
455	26	30
456	26	21
457	26	12
458	27	12
459	30	17
460	32	17
461	37	7
462	38	17
463	43	9
464	47	3
465	55	11
466	58	17
467	66	17
468	68	2
469	68	29
470	68	22
471	69	24
472	69	6
473	69	18
474	74	28
475	74	21
476	74	12
477	82	17
478	87	3
479	91	3
480	95	17
481	96	17
482	97	17
483	108	3
484	121	3
485	122	3
486	132	25
487	141	31
488	148	20
489	148	32
490	148	4
491	148	23
492	148	13
493	152	17
494	163	15
495	168	27
496	168	10
497	168	19
498	172	3
499	180	3
500	181	3
501	186	3
\.


--
-- Name: contact_listing_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ozp_user
--

SELECT pg_catalog.setval('contact_listing_id_seq', 501, true);


--
-- Data for Name: corsheaders_corsmodel; Type: TABLE DATA; Schema: public; Owner: ozp_user
--

COPY corsheaders_corsmodel (id, cors) FROM stdin;
\.


--
-- Name: corsheaders_corsmodel_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ozp_user
--

SELECT pg_catalog.setval('corsheaders_corsmodel_id_seq', 1, false);


--
-- Data for Name: django_admin_log; Type: TABLE DATA; Schema: public; Owner: ozp_user
--

COPY django_admin_log (id, action_time, object_id, object_repr, action_flag, change_message, content_type_id, user_id) FROM stdin;
\.


--
-- Name: django_admin_log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ozp_user
--

SELECT pg_catalog.setval('django_admin_log_id_seq', 1, false);


--
-- Data for Name: django_content_type; Type: TABLE DATA; Schema: public; Owner: ozp_user
--

COPY django_content_type (id, app_label, model) FROM stdin;
1	admin	logentry
2	contenttypes	contenttype
3	auth	group
4	auth	user
5	auth	permission
6	sessions	session
7	ozpcenter	changedetail
8	ozpcenter	category
9	ozpcenter	imagetype
10	ozpcenter	notificationmailbox
11	ozpcenter	intent
12	ozpcenter	profile
13	ozpcenter	recommendationsentry
14	ozpcenter	subscription
15	ozpcenter	image
16	ozpcenter	listing
17	ozpcenter	contact
18	ozpcenter	recommendationfeedback
19	ozpcenter	docurl
20	ozpcenter	screenshot
21	ozpcenter	agency
22	ozpcenter	notification
23	ozpcenter	review
24	ozpcenter	listingtype
25	ozpcenter	contacttype
26	ozpcenter	listingactivity
27	ozpcenter	applicationlibraryentry
28	ozpcenter	tag
29	ozpiwc	dataresource
\.


--
-- Name: django_content_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ozp_user
--

SELECT pg_catalog.setval('django_content_type_id_seq', 29, true);


--
-- Data for Name: django_migrations; Type: TABLE DATA; Schema: public; Owner: ozp_user
--

COPY django_migrations (id, app, name, applied) FROM stdin;
1	contenttypes	0001_initial	2017-09-19 13:24:57.963841-04
2	auth	0001_initial	2017-09-19 13:24:58.117409-04
3	admin	0001_initial	2017-09-19 13:24:58.176315-04
4	contenttypes	0002_remove_content_type_name	2017-09-19 13:24:58.247468-04
5	auth	0002_alter_permission_name_max_length	2017-09-19 13:24:58.270618-04
6	auth	0003_alter_user_email_max_length	2017-09-19 13:24:58.292833-04
7	auth	0004_alter_user_username_opts	2017-09-19 13:24:58.311647-04
8	auth	0005_alter_user_last_login_null	2017-09-19 13:24:58.334576-04
9	auth	0006_require_contenttypes_0002	2017-09-19 13:24:58.338339-04
10	ozpcenter	0001_initial	2017-09-19 13:25:00.241083-04
11	ozpcenter	0002_auto_20160310_1929	2017-09-19 13:25:00.558469-04
12	ozpcenter	0003_listing_is_deleted	2017-09-19 13:25:00.710399-04
13	ozpcenter	0004_auto_20160511_1653	2017-09-19 13:25:00.869346-04
14	ozpcenter	0005_notification_agency	2017-09-19 13:25:00.935022-04
15	ozpcenter	0006_notification__peer	2017-09-19 13:25:00.992468-04
16	ozpcenter	0007_auto_20160928_1858	2017-09-19 13:25:01.047661-04
17	ozpcenter	0008_auto_20160928_1904	2017-09-19 13:25:01.118737-04
18	ozpcenter	0009_applicationlibraryentry_position	2017-09-19 13:25:01.20577-04
19	ozpcenter	0010_auto_20170109_2128	2017-09-19 13:25:01.446019-04
20	ozpcenter	0011_recommendationsentry	2017-09-19 13:25:01.527136-04
21	ozpcenter	0012_auto_20170322_1309	2017-09-19 13:25:01.776036-04
22	ozpcenter	0013_notification_fill_migrate	2017-09-19 13:25:01.786775-04
23	ozpcenter	0014_notificationmailbox	2017-09-19 13:25:01.879343-04
24	ozpcenter	0015_notification_script	2017-09-19 13:25:01.887105-04
25	ozpcenter	0016_subscription	2017-09-19 13:25:01.97813-04
26	ozpcenter	0017_recommendationsentry_recommendation_data	2017-09-19 13:25:02.249217-04
27	ozpcenter	0018_screenshot_description	2017-09-19 13:25:02.32167-04
28	ozpcenter	0019_auto_20170417_2045	2017-09-19 13:25:02.380431-04
29	ozpcenter	0020_beta_group_script	2017-09-19 13:25:02.39192-04
30	ozpcenter	0021_screenshot_order	2017-09-19 13:25:02.46895-04
31	ozpcenter	0022_profile_email_notification_flag	2017-09-19 13:25:02.551063-04
32	ozpcenter	0023_auto_20170629_1323	2017-09-19 13:25:02.9152-04
33	ozpcenter	0024_auto_20170829_1944	2017-09-19 13:25:03.098218-04
34	ozpcenter	0025_listing_total_review_responses	2017-09-19 13:25:03.262684-04
35	ozpcenter	0026_auto_20170912_1524	2017-09-19 13:25:03.549174-04
36	ozpiwc	0001_initial	2017-09-19 13:25:03.607034-04
37	sessions	0001_initial	2017-09-19 13:25:03.643905-04
38	ozpcenter	0027_auto_20170919_1341	2017-09-27 12:35:04.702266-04
39	ozpcenter	0028_profile_leaving_ozp_warning_flag	2017-09-27 12:35:04.828703-04
40	ozpcenter	0029_auto_20170921_1342	2017-09-27 12:35:04.911325-04
41	ozpcenter	0030_recommendationfeedback	2017-09-27 12:35:04.997945-04
42	admin	0002_logentry_remove_auto_add	2017-10-18 15:08:34.692145-04
43	auth	0007_alter_validators_add_error_messages	2017-10-18 15:08:34.710188-04
44	auth	0008_alter_user_username_max_length	2017-10-18 15:08:34.743034-04
45	ozpcenter	0031_notification_notification_subtype	2017-10-18 15:08:34.814346-04
46	ozpcenter	0032_listing_feedback_score	2017-10-18 15:08:34.930798-04
47	ozpcenter	0033_auto_20171027_1948	2017-11-08 17:31:47.59887-05
\.


--
-- Name: django_migrations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ozp_user
--

SELECT pg_catalog.setval('django_migrations_id_seq', 47, true);


--
-- Data for Name: django_session; Type: TABLE DATA; Schema: public; Owner: ozp_user
--

COPY django_session (session_key, session_data, expire_date) FROM stdin;
\.


--
-- Data for Name: intent_listing; Type: TABLE DATA; Schema: public; Owner: ozp_user
--

COPY intent_listing (id, listing_id, intent_id) FROM stdin;
\.


--
-- Name: intent_listing_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ozp_user
--

SELECT pg_catalog.setval('intent_listing_id_seq', 1, false);


--
-- Data for Name: listing_activity_change_detail; Type: TABLE DATA; Schema: public; Owner: ozp_user
--

COPY listing_activity_change_detail (id, listingactivity_id, changedetail_id) FROM stdin;
\.


--
-- Name: listing_activity_change_detail_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ozp_user
--

SELECT pg_catalog.setval('listing_activity_change_detail_id_seq', 5, true);


--
-- Data for Name: notification_profile; Type: TABLE DATA; Schema: public; Owner: ozp_user
--

COPY notification_profile (id, notification_id, profile_id) FROM stdin;
\.


--
-- Name: notification_profile_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ozp_user
--

SELECT pg_catalog.setval('notification_profile_id_seq', 1, false);


--
-- Data for Name: ozpcenter_agency; Type: TABLE DATA; Schema: public; Owner: ozp_user
--

COPY ozpcenter_agency (id, title, short_name, icon_id) FROM stdin;
1	Ministry of Truth	Minitrue	2
2	Ministry of Peace	Minipax	3
3	Ministry of Love	Miniluv	4
4	Ministry of Plenty	Miniplen	5
5	Test	Test	6
6	Test 1	Test 1	7
7	Test 2	Test2	8
8	Test 3	Test 3	9
9	Test 4	Test 4	10
\.


--
-- Name: ozpcenter_agency_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ozp_user
--

SELECT pg_catalog.setval('ozpcenter_agency_id_seq', 9, true);


--
-- Data for Name: ozpcenter_applicationlibraryentry; Type: TABLE DATA; Schema: public; Owner: ozp_user
--

COPY ozpcenter_applicationlibraryentry (id, folder, listing_id, owner_id, "position") FROM stdin;
1	Instruments	1	1	10
2	old	2	5	0
3	\N	2	11	0
4	\N	9	15	0
5	planets	9	5	8
6	\N	10	4	0
7	\N	10	5	4
8	\N	14	13	0
9	\N	18	4	1
10	Beverages	21	4	5
11	old	23	5	1
12	\N	23	1	15
13	\N	29	1	18
14	\N	30	11	0
15	\N	30	1	20
16	\N	44	5	2
17	\N	47	3	0
18	Instruments	49	1	9
19	Instruments	50	1	12
20	\N	59	1	19
21	\N	63	5	3
22	\N	68	3	0
23	\N	69	3	0
24	\N	70	3	0
25	Beverages	72	4	6
26	\N	73	1	16
27	Funny	76	4	3
28	heros	77	5	5
29	heros	81	5	6
30	\N	82	11	0
31	\N	87	13	0
32	Animals	87	1	4
33	\N	90	13	0
34	Weather	93	1	1
35	Animals	94	1	5
36	\N	96	11	0
37	Funny	101	4	2
38	heros	101	5	7
39	Games	103	4	8
40	Animals	108	1	6
41	Games	115	4	7
42	\N	116	15	0
43	Animals	122	1	7
44	Instruments	127	1	13
45	planets	147	5	9
46	\N	148	4	4
47	Weather	154	1	2
48	Instruments	156	1	11
49	\N	158	1	17
50	Weather	169	1	0
51	Instruments	175	1	14
52	Animals	180	1	8
53	\N	186	3	0
54	Animals	186	1	3
\.


--
-- Name: ozpcenter_applicationlibraryentry_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ozp_user
--

SELECT pg_catalog.setval('ozpcenter_applicationlibraryentry_id_seq', 54, true);


--
-- Data for Name: ozpcenter_category; Type: TABLE DATA; Schema: public; Owner: ozp_user
--

COPY ozpcenter_category (id, title, description) FROM stdin;
1	Accessories	Accessories Description
2	Books and Reference	Things made of paper
3	Business	For making money
4	Communication	Moving info between people and things
5	Education	Educational in nature
6	Entertainment	For fun
7	Finance	For managing money
8	Health and Fitness	Be healthy, be fit
9	Media and Video	Videos and media stuff
10	Music and Audio	Using your ears
11	News	What's happening where
12	Productivity	Do more in less time
13	Shopping	For spending your money
14	Sports	Score more points than your opponent
15	Tools	Tools and Utilities
16	Weather	Get the temperature
\.


--
-- Name: ozpcenter_category_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ozp_user
--

SELECT pg_catalog.setval('ozpcenter_category_id_seq', 16, true);


--
-- Data for Name: ozpcenter_changedetail; Type: TABLE DATA; Schema: public; Owner: ozp_user
--

COPY ozpcenter_changedetail (id, field_name, old_value, new_value) FROM stdin;
\.


--
-- Name: ozpcenter_changedetail_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ozp_user
--

SELECT pg_catalog.setval('ozpcenter_changedetail_id_seq', 1, false);


--
-- Data for Name: ozpcenter_contact; Type: TABLE DATA; Schema: public; Owner: ozp_user
--

COPY ozpcenter_contact (id, secure_phone, unsecure_phone, email, name, organization, contact_type_id) FROM stdin;
1	741-774-7414	\N	a@b.com	A B	\N	1
2	741-774-7414	965-8569	cersei@gmail.com	Cersei	Default	1
3	741-774-7414	666-555-5555	gsmith@science.com	Dr. George Smith	Organization for animal heath	1
4	741-774-7414	666-7774	riderhard@mine.net	HOF	HOG2	1
5	741-774-7414	555-1212	smokinaces@mine.net	Joe Dirt	Smokin Aces	1
6	741-774-7414	854-8569	johnsnow@gmail.com	John Snow	Default	1
7	741-774-7414	784-1548	silentbob@clerks.com	Kevin Smith	Default	1
8	741-774-7414	321-123-7894	osha@stark.com	Osha	House Stark	1
9	741-774-7414	555-555-5555	r@s.com	P Scale	\N	1
10	741-774-7414	784-1548	scott@stp.com	Scott	Default	1
11	741-774-7414	\N	Tyler@fc.com	Tyler	\N	1
12	741-774-7414	555-555-5555	w@s.com	W Smith	Default	1
13	741-774-7414	202-5555	willieg@mustride.net	Willie G	\N	1
14	741-774-7414	784-1548	no@gmail.com	someguy	someplace	1
15	741-774-7414	123-456-7890	chris@sound.com	Chris	Default	2
16	741-774-7414	555-1212	riderdie@mustride.net	Frank Beans	Ride r' Die	2
17	741-774-7414	123-456-7890	rbaratheon@baratheon.com	Robert Baratheon	House Baratheon	2
18	741-774-7414	652-5236	sansa@gmail.com	Sansa	Default	2
19	741-774-7414	784-1548	scott@vr.com	Scott	Default	2
20	741-774-7414	666-1111	goodtogo@my.net	Slippery Wen Wet	HOG	2
21	741-774-7414	555-555-5555	t@t.com	Tammy	Default	2
22	741-774-7414	632-5236	tyrion@gmail.com	Tyrion Lannister	Default	2
23	741-774-7414	555-1212	willie.g@hog.net	willie g	HOG	2
24	741-774-7414	856-9632	arya@gmail.com	Arya	Default	3
25	741-774-7414	\N	bowsers@castle.com	Bowser	\N	3
26	741-774-7414	222-324-3846	brienne@stark.com	Brienne Tarth	House Stark	3
27	741-774-7414	784-1548	chester@lp.com	Chester	Default	3
28	741-774-7414	555-555-5555	d@d.com	Donald Duck	\N	3
29	741-774-7414	523-5547	jamie@gmail.com	Jamie Lannister	Default	3
30	741-774-7414	555-555-5555	m@m.com	M Smith	Default	3
31	741-774-7414	\N	mario@plumbersinc.com	Mario	\N	3
32	741-774-7414	555-6666	mustride@aka.net	Must Ride	HOG	3
33	741-774-7414	555-1212	HOG@miniture.net	Willie G	HOG	3
\.


--
-- Name: ozpcenter_contact_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ozp_user
--

SELECT pg_catalog.setval('ozpcenter_contact_id_seq', 33, true);


--
-- Data for Name: ozpcenter_contacttype; Type: TABLE DATA; Schema: public; Owner: ozp_user
--

COPY ozpcenter_contacttype (id, name, required) FROM stdin;
1	Civilian	f
2	Government	f
3	Military	f
\.


--
-- Name: ozpcenter_contacttype_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ozp_user
--

SELECT pg_catalog.setval('ozpcenter_contacttype_id_seq', 3, true);


--
-- Data for Name: ozpcenter_docurl; Type: TABLE DATA; Schema: public; Owner: ozp_user
--

COPY ozpcenter_docurl (id, name, url, listing_id) FROM stdin;
1	guide	http://www.google.com/guide	2
2	wiki	http://www.google.com/wiki	2
3	https://en.wikipedia.org/wiki/Smoking_(cooking)	https://en.wikipedia.org/wiki/Spice_rub	11
4	https://en.wikipedia.org/wiki/Worm_charming	https://en.wikipedia.org/wiki/Soft_plastic_bait	15
5	https://en.wikipedia.org/wiki/List_of_whisky_brands#Bourbon	https://en.wikipedia.org/wiki/Moonshine	21
6	Wiki	https://en.wikipedia.org/wiki/Fiat_525	54
7	https://en.wikipedia.org/wiki/Finnish_Museum_of_Horology	https://en.wikipedia.org/wiki/Striking_clock	63
8	https://en.wikipedia.org/wiki/Corn_whiskey	https://en.wikipedia.org/wiki/Moonshine_in_popular_culture	109
9	Wiki	https://en.wikipedia.org/wiki/Buff-faced_pygmy_parrot	121
10	https://en.wikipedia.org/wiki/Golf_club	https://en.wikipedia.org/wiki/Super_Swing_Golf	160
\.


--
-- Name: ozpcenter_docurl_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ozp_user
--

SELECT pg_catalog.setval('ozpcenter_docurl_id_seq', 10, true);


--
-- Data for Name: ozpcenter_image; Type: TABLE DATA; Schema: public; Owner: ozp_user
--

COPY ozpcenter_image (id, uuid, security_marking, file_extension, image_type_id) FROM stdin;
1	65a16800-b06d-4d80-a734-575f25efb224	UNCLASSIFIED	png	3
2	dd1ce9c9-9a24-46f5-b051-7a9179637d21	UNCLASSIFIED	jpg	1
3	535bb766-4b0d-425f-ac2b-8e379a8a7636	UNCLASSIFIED	png	1
4	1329b12a-865a-4c85-9ca8-32cadddef4bd	UNCLASSIFIED	jpeg	1
5	8bf314f1-8460-4ff2-9adc-92d8e7fe88c8	UNCLASSIFIED	png	1
6	902383e5-5d22-405f-b0ae-e713bd816f19	UNCLASSIFIED	png	1
7	6a473f03-2e38-473d-87af-8b252a880fe9	UNCLASSIFIED	png	1
8	f9afa7ad-0cb5-43b3-9a0e-9e616766d1ed	UNCLASSIFIED	png	1
9	40362183-00e2-442f-992a-2161e71f6de1	UNCLASSIFIED	png	1
10	907b575c-7e90-4a66-a924-75fc61ec29f9	UNCLASSIFIED	png	1
11	10a806d4-73de-4b47-8693-301630f86348	UNCLASSIFIED	jpeg	7
12	fc993c3c-66f6-4b83-b695-efd047ca6dfb	UNCLASSIFIED	jpeg	5
13	a88bed77-500a-413e-b292-60330e407fe4	UNCLASSIFIED	jpeg	2
14	47693aa8-782e-4fe4-846f-21f7a48edc9f	UNCLASSIFIED	jpeg	4
15	9273c9a8-c8b0-4ab4-af22-367c5a259291	UNCLASSIFIED	png	7
16	7aeab76c-b646-4428-8dd2-41a488c97f55	UNCLASSIFIED	png	5
17	2a726818-728f-43b9-a4f0-ae3bb96ae387	UNCLASSIFIED	png	2
18	c757947b-cabb-4876-80d4-7f9fef13f032	UNCLASSIFIED	png	4
19	199f4b95-5f7f-45b0-9353-91bb24b08ef5	UNCLASSIFIED	jpeg	7
20	f2743539-23d0-42bc-b021-2ece08817456	UNCLASSIFIED	jpeg	5
21	497c6bc8-1968-4d6a-a344-fcc19fcf0583	UNCLASSIFIED	jpeg	2
22	27d995fb-1342-40de-95a6-df01ca5ba0b3	UNCLASSIFIED	jpeg	4
23	9371a604-820a-4c20-8e64-b898d6b48b07	UNCLASSIFIED	jpeg	7
24	8b1c482f-ac8b-4608-9beb-ecc42f46e9da	UNCLASSIFIED	jpeg	5
25	1dd42fe1-0e21-4658-ac34-cb1d41ab76ee	UNCLASSIFIED	jpeg	2
26	59453682-9d20-4607-a133-7db7776f3672	UNCLASSIFIED	jpeg	4
27	2a508c99-f705-4e88-ade2-2f4304eae87f	UNCLASSIFIED	jpeg	7
28	7af84d87-53da-4f13-95dc-bea1812395d3	UNCLASSIFIED	jpeg	5
29	f245fb9b-0aac-4a31-93ae-49d85aa48219	UNCLASSIFIED	jpeg	2
30	8d1d9a5e-1584-45ce-a66f-ce96efb7c41e	UNCLASSIFIED	jpeg	4
31	786cb22a-b149-4305-82d7-296c073aca2d	UNCLASSIFIED	png	7
32	8f233787-d640-469b-abc5-a4fd5425db3b	UNCLASSIFIED	png	5
33	43adf777-c9c6-4511-aeaa-5129089f0de5	UNCLASSIFIED	png	2
34	7a21ac4c-ac66-4e68-beb1-f4941b407a38	UNCLASSIFIED	png	4
35	691d3452-683e-4273-9a76-0e9212136e7d	UNCLASSIFIED	png	7
36	7941acde-e279-448d-98fa-f193542c6279	UNCLASSIFIED	png	5
37	c2a989d5-42f7-4ed4-b66f-d8a5ac264aee	UNCLASSIFIED	png	2
38	0625bd02-54b5-4a2e-8e32-d7b0d18fe939	UNCLASSIFIED	png	4
39	3cbab76c-8ff0-497d-bbcb-171f1d95b33f	UNCLASSIFIED	png	7
40	ce2395d7-852c-41b7-9dc0-911c3c440575	UNCLASSIFIED	png	5
41	86eca8ce-3fe7-40c8-9988-430e172f7152	UNCLASSIFIED	png	2
42	9bb6d20b-d833-4fe1-bfa0-b95ead07d161	UNCLASSIFIED	png	4
43	d5e9c2e0-ea0d-405b-9246-3bc9f6ef25be	UNCLASSIFIED	jpeg	7
44	94dcbda7-a170-46c0-94a2-c508320b5aca	UNCLASSIFIED	jpeg	5
45	b767092d-c98b-4d70-a0ef-3c8da5160509	UNCLASSIFIED	jpeg	2
46	a44b1070-7dc4-4a4d-8c10-84a495d08024	UNCLASSIFIED	jpeg	4
47	ae5dbb2e-71f7-4880-93e8-46cb96ecb75a	UNCLASSIFIED	png	7
48	434dd398-24a8-4d82-a024-7e2931d6a587	UNCLASSIFIED	png	5
49	8cf360d3-d913-4194-9b5c-b154047b04d0	UNCLASSIFIED	png	2
50	446c2c85-28f4-43a2-b8db-6c8443d8bdcc	UNCLASSIFIED	png	4
51	fe70b43a-7d77-4ad9-894f-eab7b728cc89	UNCLASSIFIED	jpeg	7
52	06d8a134-4ca9-48aa-8764-9ed740d395b5	UNCLASSIFIED	jpeg	5
53	51cec340-e8e1-466e-a54c-7896fb796b8b	UNCLASSIFIED	jpeg	2
54	d4ccebcf-0342-4057-8b2a-123ddb07e959	UNCLASSIFIED	jpeg	4
55	dfee8f0f-707d-4be2-ac5f-6f86ba9bfdec	UNCLASSIFIED	jpeg	7
56	8e819b07-d55f-4a0c-a89a-07c3e125c5fd	UNCLASSIFIED	jpeg	5
57	810c39c5-669f-4fef-a8fa-3ab019e0ba81	UNCLASSIFIED	jpeg	2
58	4e513606-db21-48ee-9eb2-e92f11777efc	UNCLASSIFIED	jpeg	4
59	2e278ee6-c545-4d3f-b34c-8366d265f93b	UNCLASSIFIED	jpeg	7
60	075ec147-9b7f-4240-81d9-3180b92f8411	UNCLASSIFIED	jpeg	5
61	793409c1-7f92-42f1-a0a2-900b732a8e00	UNCLASSIFIED	jpeg	2
62	f57c3ef1-2d12-49fa-8e30-4a41a939e50c	UNCLASSIFIED	jpeg	4
63	abf621a9-0ba9-466b-8f64-c7aa72763803	UNCLASSIFIED	jpeg	7
64	1b3e87b9-1cfa-4811-bdd7-8417639d72f8	UNCLASSIFIED	jpeg	5
65	757353be-fa8f-45b5-8af3-145aa8eafbfe	UNCLASSIFIED	jpeg	2
66	2f6b5d49-7e56-4ed3-a0c6-6b6576371c50	UNCLASSIFIED	jpeg	4
67	22b3cc8c-914f-4c26-878b-c4fadd763c4d	UNCLASSIFIED	png	7
68	7490a6de-bae9-4116-8dec-9a79d695dace	UNCLASSIFIED	png	5
69	20182fe5-bc67-4603-afc7-21dcba16ba57	UNCLASSIFIED	png	2
70	2a13a5dd-354a-41fd-b78c-089bb08fdff3	UNCLASSIFIED	png	4
71	f1946943-05af-4a1e-abc6-8a527b9f311b	UNCLASSIFIED	jpeg	7
72	43db6903-2b14-4936-a8d9-188c332e4b75	UNCLASSIFIED	jpeg	5
73	9030ffe7-a9bb-47db-b692-5ad1da2fed6f	UNCLASSIFIED	jpeg	2
74	cb08631e-f52f-47dc-a295-b0709dd6d32a	UNCLASSIFIED	jpeg	4
75	bb9f83ee-3bca-4c0e-8585-8778aa565a0d	UNCLASSIFIED	jpeg	7
76	0dc70303-f107-4cf2-9e8d-c664d8a796fe	UNCLASSIFIED	jpeg	5
77	f84cd0ed-b045-43d1-97a3-d841164ef2ca	UNCLASSIFIED	jpeg	2
78	26bdb9c3-a8e2-4ffb-98e9-429ed30c26a9	UNCLASSIFIED	jpeg	4
79	4bf2bb1e-2faf-4a91-9d4b-36707797db08	UNCLASSIFIED	jpeg	7
80	e47abf97-b87e-4d6a-a530-61762734e1a2	UNCLASSIFIED	jpeg	5
81	b7e7435c-acb9-49ea-a5ba-1803853f1ccc	UNCLASSIFIED	jpeg	2
82	e1050342-80fc-4c83-a5af-79019b59f12c	UNCLASSIFIED	jpeg	4
83	6dc3cdad-fa56-4bf1-a0a4-2ac1b0c1587f	UNCLASSIFIED	jpeg	7
84	9f7047bc-4db5-4070-95e0-625f049888eb	UNCLASSIFIED	jpeg	5
85	3d2156d2-d67f-4d91-936e-f2fe5952538f	UNCLASSIFIED	jpeg	2
86	456f1273-9237-4819-addf-e1b8d7f0167f	UNCLASSIFIED	jpeg	4
87	406dd578-6b7a-4741-bfa1-a7355a4bc168	UNCLASSIFIED	jpeg	7
88	eeb323ee-3a75-41c4-be55-027e68474458	UNCLASSIFIED	jpeg	5
89	dcad4e73-50fe-43ef-aeeb-4d2fa52c6c7b	UNCLASSIFIED	jpeg	2
90	125a0ef3-dd5b-4d01-880c-a2b46e16dea3	UNCLASSIFIED	jpeg	4
91	f0c3839d-fc94-49bf-9a53-cea5953ddebb	UNCLASSIFIED	jpeg	7
92	e87e147f-f499-479d-a45b-93251bc1be37	UNCLASSIFIED	jpeg	5
93	5cbf52ac-7bc7-4a9c-8a97-68e69a1291d6	UNCLASSIFIED	jpeg	2
94	d21ff671-2399-4808-924b-9c6df21d48cb	UNCLASSIFIED	jpeg	4
95	60bc900d-6e12-4b53-ac69-3d77ecfc56ec	UNCLASSIFIED	png	7
96	731ce60e-d726-445d-a544-4ee192fe4e07	UNCLASSIFIED	png	5
97	fccb26fd-1158-4555-a3bf-242d0a2581f5	UNCLASSIFIED	png	2
98	2a37ade3-340c-41ac-b41f-f2e3b73b374e	UNCLASSIFIED	png	4
99	68af2a11-5d65-48a5-bc2d-85e2877ce559	UNCLASSIFIED	png	7
100	56fa7722-cc64-4e58-8a63-e3e5274138eb	UNCLASSIFIED	png	5
101	4a9f7b34-ec76-4478-bdcf-bddca703f3ac	UNCLASSIFIED	png	2
102	953f2184-3e82-4237-ab86-ce0a8be54bf0	UNCLASSIFIED	png	4
103	bbc09bb8-5225-4b2a-94c0-f80def855d4a	UNCLASSIFIED	jpeg	7
104	d93bde28-420c-41de-950a-f0068795e456	UNCLASSIFIED	jpeg	5
105	9802d098-5416-4b72-8b9c-e36f9bc3891c	UNCLASSIFIED	png	2
106	87bbd97d-a06c-41ea-84e5-baf065924476	UNCLASSIFIED	jpeg	4
107	481bfbca-6af9-4b9c-928a-e5d1e87c4af8	UNCLASSIFIED	jpeg	7
108	0c53b250-64f9-4762-8f2c-2fada43d5314	UNCLASSIFIED	jpeg	5
109	44a1181c-144a-4a48-bae3-7ad43ba1903f	UNCLASSIFIED	jpeg	2
110	4322747d-60f9-4fad-9ac0-9938a6b1515e	UNCLASSIFIED	jpeg	4
111	3b073212-ddbb-4f1c-a015-6c9c0fdc50e2	UNCLASSIFIED	png	7
112	f8f937bb-d112-4b25-a532-17991db05619	UNCLASSIFIED	png	5
113	082c0ba7-62a9-4658-bf8f-e9c0d71bc13e	UNCLASSIFIED	png	2
114	7f37f448-b2d5-4a9b-8151-f1bb7155e258	UNCLASSIFIED	png	4
115	dd4e914c-9b9b-4971-b6a7-d305e92f6f2b	UNCLASSIFIED	png	7
116	643cea00-8b43-4263-a6fd-5092156ad692	UNCLASSIFIED	png	5
117	9fc2dc54-47f9-4090-9258-fbb55d0549c0	UNCLASSIFIED	png	2
118	af647649-ba5d-4460-adac-fed994a2d6d3	UNCLASSIFIED	png	4
119	6d6356b8-dec9-407a-8854-a0cda4a38659	UNCLASSIFIED	jpeg	7
120	292078b6-9259-488e-a159-e01f71da6ed5	UNCLASSIFIED	jpeg	5
121	501790ef-6928-4a9a-9ab3-84646a97d00e	UNCLASSIFIED	jpeg	2
122	988d26c0-707e-4aec-9703-a197ed9edfcf	UNCLASSIFIED	jpeg	4
123	c9458850-34a3-4a33-88d1-00cb96b487dc	UNCLASSIFIED	jpeg	7
124	ecbcab7a-bb2c-418b-b3dc-4f67ae7c96af	UNCLASSIFIED	jpeg	5
125	349ac651-9a0f-4ad6-a88c-dd22bf9853b9	UNCLASSIFIED	jpeg	2
126	eefef2e7-462d-4a68-b854-6cfa3ee36eba	UNCLASSIFIED	jpeg	4
127	128f56c4-33a1-4d0e-b953-f74bea30a55b	UNCLASSIFIED	png	7
128	94b1953b-73ed-453b-90b0-179edeeabd13	UNCLASSIFIED	png	5
129	4bee9c53-a9cc-4e0d-96ce-3795d93b3f49	UNCLASSIFIED	png	2
130	853ba16b-9013-4e3c-8ad5-d28fc514d8a8	UNCLASSIFIED	png	4
131	791674ea-2ca2-4912-90a2-7c43d5ca396c	UNCLASSIFIED	jpeg	7
132	80ee8346-d555-4c01-9f83-6689a684be67	UNCLASSIFIED	jpeg	5
133	8e23dc47-c8b8-4c26-9dd8-c1b6a254e5f3	UNCLASSIFIED	jpeg	2
134	f93cb57d-b47a-45e1-a2a2-d594ba0f29da	UNCLASSIFIED	jpeg	4
135	6021bd26-8e09-428a-84a4-c87169a56531	UNCLASSIFIED	png	7
136	42bb6940-ada2-41b6-8a9a-210378afd6d3	UNCLASSIFIED	png	5
137	5d954052-ff67-4d7c-b918-3be54281776d	UNCLASSIFIED	png	2
138	fd859aa1-0181-4526-b6d1-2ca70ce7dabd	UNCLASSIFIED	png	4
139	603476da-31a3-4d95-b947-f40aa7018dab	UNCLASSIFIED	jpeg	7
140	fd924df5-2060-4cc6-9f2e-217ede380ed3	UNCLASSIFIED	jpeg	5
141	c12c1315-2ebf-44f5-88e1-5a726c2246fb	UNCLASSIFIED	jpeg	2
142	496f15c5-39ac-4987-b5dc-6f57ee899cff	UNCLASSIFIED	jpeg	4
143	4f84f213-f207-48cb-b3e1-855f6405844c	UNCLASSIFIED	jpeg	7
144	bae71449-10f2-447e-ab99-02727a68a2cc	UNCLASSIFIED	jpeg	5
145	65e7efea-c063-43d1-815b-fe3c2555a16a	UNCLASSIFIED	jpeg	2
146	c46c992a-82dd-49a4-af8a-f09a295faa01	UNCLASSIFIED	jpeg	4
147	6a9889e7-c9b6-4fc4-8811-f541a707c34a	UNCLASSIFIED	jpeg	7
148	e5270626-2f07-4e95-92af-725b5a03f6ab	UNCLASSIFIED	jpeg	5
149	00b06ebb-a2e7-441f-991f-1ba5245e0d29	UNCLASSIFIED	jpeg	2
150	6bb2f0e4-e78e-4bc4-9125-f8a28dfb1a77	UNCLASSIFIED	jpeg	4
151	5bcc76de-31fc-4bee-8e4d-34f06d13db5d	UNCLASSIFIED	jpeg	7
152	ddd6b1c2-fb72-4b20-8454-2bdb081909fe	UNCLASSIFIED	jpeg	5
153	7ac5a63d-f981-46a8-aae9-59d6f0df1c19	UNCLASSIFIED	jpeg	2
154	073ddff4-ae8e-487e-9a90-88c879df212d	UNCLASSIFIED	jpeg	4
155	8d103a9d-690c-426c-a4fa-93fcd894ae84	UNCLASSIFIED	jpeg	7
156	b8a3a989-0bb1-45b8-ae27-f49079734fcd	UNCLASSIFIED	jpeg	5
157	58ffb8a1-b422-4802-a693-c0475e102b81	UNCLASSIFIED	jpeg	2
158	09f0ed5c-b0d3-4241-b7a6-44cb4509b915	UNCLASSIFIED	jpeg	4
159	0477ce9f-16bd-47b9-a6f5-3d93dba4415f	UNCLASSIFIED	png	7
160	c582731d-9220-4c37-aa39-cef866b09747	UNCLASSIFIED	png	5
161	7a414467-d8ba-4b5a-912f-cdafd1ec74db	UNCLASSIFIED	png	2
162	8a72a0ed-82af-497a-aa71-ce5f9d18ab63	UNCLASSIFIED	png	4
163	2d65ee94-379b-47ea-8f59-8e4a843a56fb	UNCLASSIFIED	png	7
164	2cfed349-a84e-4945-b24a-8072b4732ad6	UNCLASSIFIED	png	5
165	0a28cfe8-7272-4bc5-af41-bca00b04c884	UNCLASSIFIED	png	2
166	58461ac3-99b3-450b-8c58-1e70bc5e1cd8	UNCLASSIFIED	png	4
167	6756193e-2d9f-4f81-a268-9478c121cff1	UNCLASSIFIED	jpeg	7
168	e450f886-ef31-47cf-a796-e9cc35d68e8f	UNCLASSIFIED	jpeg	5
169	1d2139ab-947c-4f96-b6c7-2494eb5c149f	UNCLASSIFIED	jpeg	2
170	3338f993-3e2a-41ab-93f5-c9b64a7fd30e	UNCLASSIFIED	jpeg	4
171	a954febb-5592-4164-a95e-126f8fe84077	UNCLASSIFIED	jpeg	7
172	ec2bf45b-6ff8-4020-8acb-f5362345ce08	UNCLASSIFIED	jpeg	5
173	989c13da-d6a4-4520-b1e7-50029ce779ce	UNCLASSIFIED	jpeg	2
174	2a7aeef1-533b-4292-befe-e79b1fbc62b8	UNCLASSIFIED	jpeg	4
175	6adbaeea-259b-4ad6-86f2-4541c43612de	UNCLASSIFIED	png	7
176	6e65e5a8-4da4-4b60-a33b-ec8310accdab	UNCLASSIFIED	png	5
177	0d5843ae-d218-42c5-9805-5ea020fa9313	UNCLASSIFIED	png	2
178	8d794693-ae8c-415c-8da2-841876fd0cc9	UNCLASSIFIED	png	4
179	5c40e181-ea26-4876-aeae-0155f9680825	UNCLASSIFIED	png	7
180	c5d96206-e85b-456f-8c6b-71fa0b3d0c0c	UNCLASSIFIED	png	5
181	c65f7f28-1dd7-4751-bc83-2adfdfab404b	UNCLASSIFIED	png	2
182	085335ea-5f94-4db6-b8dc-482d5c8daeea	UNCLASSIFIED	png	4
183	19940749-20a0-485a-a390-e4a275d9641e	UNCLASSIFIED	png	7
184	02168afe-6390-42ca-8160-c601555d4d32	UNCLASSIFIED	png	5
185	42b00331-38de-49f1-ad68-e2803d6d1cf2	UNCLASSIFIED	jpeg	2
186	861ed70c-2b92-452a-b52e-dc435aa410da	UNCLASSIFIED	jpeg	4
187	b6243977-5a67-452c-b524-37a73ca822f6	UNCLASSIFIED	jpeg	7
188	3a78845f-9ca1-4222-b520-a8ebe53e42ff	UNCLASSIFIED	jpeg	5
189	d90a264c-87fe-4649-8c56-bfe9822d882d	UNCLASSIFIED	jpeg	2
190	de5386ad-b466-411b-8dde-7086193dec00	UNCLASSIFIED	jpeg	4
191	5c0e4b11-10d4-470e-81ed-ad05be264425	UNCLASSIFIED	jpeg	7
192	073e32b1-f9a4-4afd-9581-4e551b3b4c54	UNCLASSIFIED	jpeg	5
193	84a3c7e0-9986-4fb4-8eed-51437c71bfdd	UNCLASSIFIED	jpeg	2
194	0f7bf60e-a952-40af-af09-a40a91a9e285	UNCLASSIFIED	jpeg	4
195	10acf0fd-695a-46cc-a2c6-7097f6471e75	UNCLASSIFIED	png	7
196	17895f91-03ee-4526-9ac3-c432eea004c0	UNCLASSIFIED	png	5
197	054a73bc-b29d-4dc9-ac03-ca9850115c6a	UNCLASSIFIED	jpeg	2
198	f8099866-23a4-4e5d-9074-48692d91ab3f	UNCLASSIFIED	jpeg	4
199	b617fb58-669a-4563-b8bd-1b4a247a3ea4	UNCLASSIFIED	png	7
200	cb955ffb-7daf-421b-93e3-082a41ca483a	UNCLASSIFIED	png	5
201	f7ddb69d-c53c-4310-9d58-5f9eccb05d41	UNCLASSIFIED	png	2
202	2b1e4f2a-be30-4e98-9819-2258fd7a9520	UNCLASSIFIED	png	4
203	66ac1b02-71cd-46d8-8a90-976d83e8d409	UNCLASSIFIED	jpeg	7
204	9a8fc4f6-ecf5-4dab-80fc-ff53f3dd733f	UNCLASSIFIED	jpeg	5
205	1a4d22af-de31-4737-831e-009620ad9305	UNCLASSIFIED	jpeg	2
206	579ba2a5-bb4c-4e7b-aba5-e3fe0a7a8c5e	UNCLASSIFIED	jpeg	4
207	a93d58e0-c14d-4d08-8983-99933acf868e	UNCLASSIFIED	jpeg	7
208	78c821e5-1410-45cb-b1c4-665dbfccf3cf	UNCLASSIFIED	jpeg	5
209	84fb39c0-eeab-40d5-8a5c-43a19d978f5d	UNCLASSIFIED	jpeg	2
210	14a7a000-9c4c-4a23-8cd3-0a4a26c1f62e	UNCLASSIFIED	jpeg	4
211	6f942e22-280a-4fbf-ab50-0a2b620c2b2c	UNCLASSIFIED	jpeg	7
212	019fc75e-b7d6-4adc-b69b-8bd3430f212d	UNCLASSIFIED	jpeg	5
213	13536dfe-da93-4178-b54a-3d56d2c631f7	UNCLASSIFIED	jpeg	2
214	40e5daca-1ffe-45e7-b2dd-fe09df7a5a19	UNCLASSIFIED	jpeg	4
215	ee666f82-ebbd-440d-9928-f41fcb5fc089	UNCLASSIFIED	jpeg	7
216	e9adc38d-bee9-4c49-8470-7b5b37dc3b85	UNCLASSIFIED	jpeg	5
217	2d86589d-2316-4acc-9d84-28c7efdbb277	UNCLASSIFIED	jpeg	2
218	222db9eb-bdf2-4170-99c9-234fbaf4df44	UNCLASSIFIED	jpeg	4
219	68e09fab-792d-419a-939d-cd3fccc68628	UNCLASSIFIED	png	7
220	87f26dd3-9dfc-4328-9d36-f9e901981d90	UNCLASSIFIED	png	5
221	84549d64-b6e1-465d-8844-8add62de0417	UNCLASSIFIED	png	2
222	bd30edeb-f34f-4cb2-ad01-1a81aaaa6817	UNCLASSIFIED	png	4
223	320d67b2-90d3-4936-a3fb-56b790d08084	UNCLASSIFIED	jpeg	7
224	13c3437a-bfb6-4c14-8b28-d370226de242	UNCLASSIFIED	jpeg	5
225	79799686-8e1f-4f4d-8d2d-50c507aba0c6	UNCLASSIFIED	jpeg	2
226	b0592de0-bf2f-44e2-9138-4646d8d4207a	UNCLASSIFIED	jpeg	4
227	c3954efd-fdf9-4d3e-9e92-8b1bb8ff295f	UNCLASSIFIED	jpeg	7
228	9ef413a9-aabf-4d3d-a33c-45281327bfda	UNCLASSIFIED	jpeg	5
229	9c517b2d-b24c-4323-b6ba-ad228ad20614	UNCLASSIFIED	jpeg	2
230	5ed82787-2838-44ce-9bb1-bc47aa414f9a	UNCLASSIFIED	jpeg	4
231	c75c55f7-729a-4ad2-8d38-32b2c328c0ae	UNCLASSIFIED	jpeg	7
232	e11a9167-6713-499c-89a2-7f2a19e66442	UNCLASSIFIED	jpeg	5
233	320d4620-f18b-49d6-b41e-b7b81fe1cd3f	UNCLASSIFIED	jpeg	2
234	687d733a-370a-4bac-8007-385aa67d19ef	UNCLASSIFIED	jpeg	4
235	0a26522d-7e3f-446d-bd08-a3eab7c40eef	UNCLASSIFIED	jpeg	7
236	10fd6e45-938e-4068-a111-dcf97f2afc66	UNCLASSIFIED	jpeg	5
237	6e2e96ca-9f27-4be0-b548-4a939d2d99d1	UNCLASSIFIED	jpeg	2
238	0229dfce-f780-4106-9712-42315b1d0fb0	UNCLASSIFIED	jpeg	4
239	694f6511-a729-42ed-b518-1a2fadfde9da	UNCLASSIFIED	png	7
240	07973815-bf8e-4feb-a5df-30fd6ae6581d	UNCLASSIFIED	png	5
241	bc6ba6fd-4c21-4ebd-978e-ce1b9bc6aa33	UNCLASSIFIED	png	2
242	0b587dfe-8993-4d4b-9231-aa31b33c14c2	UNCLASSIFIED	png	4
243	29927261-95d6-49c6-aa8b-7e03161d2282	UNCLASSIFIED	jpeg	7
244	15eb5df1-dd83-455b-9cc7-9739ad290147	UNCLASSIFIED	jpeg	5
245	f18aa1a4-a3a8-41f0-a31e-015a11e52436	UNCLASSIFIED	png	2
246	58bc6ff2-4dcf-4466-aaf7-4c4a7b82d4a0	UNCLASSIFIED	jpeg	4
247	4faf1f43-f284-4a39-99b5-e4a1810a6bcc	UNCLASSIFIED	jpeg	7
248	c155bad2-2ba9-4380-bb5c-a79eaa365f67	UNCLASSIFIED	jpeg	5
249	9360d0bc-78ca-4f00-b3d0-5ff9f1740146	UNCLASSIFIED	jpeg	2
250	1a81ed04-267f-4cd7-91c0-cfc109db99a3	UNCLASSIFIED	jpeg	4
251	6b121bb4-20d8-4610-ac79-2794da690b8b	UNCLASSIFIED	jpeg	7
252	36f54ff0-b31b-454e-9534-6070cf8e06bb	UNCLASSIFIED	jpeg	5
253	d1227ace-9dc1-4c37-a2cf-41732df1fa0b	UNCLASSIFIED	jpeg	2
254	5b016a1a-ce20-4875-be50-d59a48d3bb93	UNCLASSIFIED	jpeg	4
255	f84879df-4346-4a9f-9288-033814b14a7b	UNCLASSIFIED	jpeg	7
256	4bfeaf3f-5115-40c9-96f8-a1022526b930	UNCLASSIFIED	jpeg	5
257	037ff274-c0ed-4e79-acef-7cb47867e693	UNCLASSIFIED	jpeg	2
258	1f8aab61-c2ad-485f-a053-49541cec0bc4	UNCLASSIFIED	jpeg	4
259	bdba85ca-f6df-449a-b5f5-902aabbe9eb5	UNCLASSIFIED	jpeg	7
260	ab82737e-2901-43ab-9ec0-a1ee7b23f39f	UNCLASSIFIED	jpeg	5
261	5417a1ac-8e52-48c0-a8f5-53fdedd2fc92	UNCLASSIFIED	jpeg	2
262	72f65f0e-d96f-4642-8209-108d967af4cb	UNCLASSIFIED	jpeg	4
263	b5499555-7cb8-4443-8256-d93f0142cf1d	UNCLASSIFIED	jpeg	7
264	866026a1-29c9-4cc0-9d14-dc5de8f7058f	UNCLASSIFIED	jpeg	5
265	97e50612-a3e7-4148-b4b3-e0726f3b86fe	UNCLASSIFIED//FOR OFFICIAL USE ONLY	jpeg	2
266	ae3c473a-bdd8-4bd1-ad8c-bf7f33df5686	UNCLASSIFIED//FOR OFFICIAL USE ONLY	jpeg	4
267	a2ac9029-d45f-448d-880b-cc1d72c148c9	UNCLASSIFIED	jpeg	7
268	d2a9beee-42cc-404a-bcf2-ab1711a54f02	UNCLASSIFIED	jpeg	5
269	207c9169-059f-4676-b32e-aad405aa3ab5	UNCLASSIFIED	jpeg	2
270	866a6dba-f8b2-4446-8bc3-4e5513474a19	UNCLASSIFIED//FOR OFFICIAL USE ONLY	jpeg	4
271	147190c6-ae76-4ef8-9671-440be508174d	UNCLASSIFIED	png	7
272	8b4f3ef1-566e-4a66-9001-9ee1af64e024	UNCLASSIFIED	png	5
273	11216f2b-7530-4d2e-acb2-849c41441070	UNCLASSIFIED	png	2
274	5dc99ef5-9714-4530-8739-37b7c0b0994c	UNCLASSIFIED	png	4
275	62e00751-2808-4faa-99ae-1a10658525cb	UNCLASSIFIED	jpeg	7
276	1416e16d-57e0-4122-9a95-075d34b18f1f	UNCLASSIFIED	jpeg	5
277	203fce0d-b4f3-4a43-81be-be22ee76cb96	UNCLASSIFIED	jpeg	2
278	a67ebbfd-b02a-4614-8d8c-a466918c51d5	UNCLASSIFIED	jpeg	4
279	1aebcc56-a782-4533-bac4-10b3b10cec6b	UNCLASSIFIED	jpeg	7
280	b31feabb-5294-47e0-8cbc-2effb42490d3	UNCLASSIFIED	jpeg	5
281	8a59f3eb-b606-487d-99c4-93ef70fa8859	UNCLASSIFIED	jpeg	2
282	264a4235-07ff-42d8-af5d-09a7c9fcc2c5	UNCLASSIFIED	jpeg	4
283	193da127-95de-4887-b843-67ed22e7126c	UNCLASSIFIED	jpeg	7
284	ce8430b6-da7d-4f01-bc60-de7e67ae85a0	UNCLASSIFIED	jpeg	5
285	66ef04ff-c2c4-43b8-baf4-0b681f4a2b55	UNCLASSIFIED	jpeg	2
286	13029bff-a7a7-4ff8-91f9-ab2dc6882a7d	UNCLASSIFIED	jpeg	4
287	c959b142-b5ea-4c9a-aedf-852f420d3f2c	UNCLASSIFIED	png	7
288	0d210390-8e0b-4ffc-abc1-86cf371a006b	UNCLASSIFIED	png	5
289	233af535-1aa3-4a44-8d53-33c907675619	UNCLASSIFIED	jpeg	2
290	acfecc80-f730-4e4c-ba8b-d29bf58f1378	UNCLASSIFIED	jpeg	4
291	5fbced22-5261-43df-a29c-c3984df3f64f	UNCLASSIFIED	jpeg	7
292	92590904-012c-426c-be7c-b20ad744f553	UNCLASSIFIED	jpeg	5
293	6607fb1b-6d54-406b-9fa5-7176593ba476	UNCLASSIFIED	jpeg	2
294	9f63cf67-f218-40bc-b24f-ceca401e40d0	UNCLASSIFIED	jpeg	4
295	5c0a58b1-8020-4520-bd14-a67be9ab4bf1	UNCLASSIFIED	jpeg	7
296	795b7bb3-e756-4ec7-91bd-115695bdcf5e	UNCLASSIFIED	jpeg	5
297	f61ff8c4-edea-44eb-b436-ff24d345696a	UNCLASSIFIED	jpeg	2
298	959ccc40-e35c-4dfa-9fac-78af3b531a44	UNCLASSIFIED	jpeg	4
299	e7e5badd-e102-47ad-9a41-ba06fcc8f977	UNCLASSIFIED	png	7
300	bc4e1a36-cf42-4d6b-b806-32d29dbf09fe	UNCLASSIFIED	png	5
301	0d34aef1-228c-43fc-9b8a-dfa1ccfbe87e	UNCLASSIFIED	png	2
302	1effc7dc-6c9a-45d0-b780-18713a39356d	UNCLASSIFIED	png	4
303	fdb3b76d-825e-4355-a0e5-b4b9bc3be1c3	UNCLASSIFIED	png	7
304	d1ac14fc-4397-4fd4-838b-74873a552033	UNCLASSIFIED	png	5
305	7e4051d9-7e18-4e5b-940b-8ffbd0af36d4	UNCLASSIFIED	png	2
306	c1b896fd-f288-4b5d-9192-f259deefa55b	UNCLASSIFIED	png	4
307	85d3c780-763a-42f3-bbdf-87a45aefde2d	UNCLASSIFIED	jpeg	7
308	9fc5fbe0-1995-4038-bfe5-33b2ba78cc79	UNCLASSIFIED	jpeg	5
309	3c7a7e9f-36fd-481c-bda5-1a42f6a2751a	UNCLASSIFIED	jpeg	2
310	bc48c27b-fc81-4115-bd20-d01f160cecad	UNCLASSIFIED	jpeg	4
311	4112f5e2-3771-477e-9b27-8be561baaea5	UNCLASSIFIED	jpeg	7
312	bb283e09-8ed3-4e9f-94b1-50ea4aba4940	UNCLASSIFIED	jpeg	5
313	1cd4053b-31fd-4666-ac45-a26637f4f677	UNCLASSIFIED	jpeg	2
314	7f24bc59-5742-4af0-887e-99831d68c0ff	UNCLASSIFIED	jpeg	4
315	e7901885-c254-4af2-921f-20b87ce02d4d	UNCLASSIFIED	jpeg	7
316	0c54c5d2-7569-4d90-bb69-e61048f8a993	UNCLASSIFIED	jpeg	5
317	5f572811-8cb4-482d-b9f8-5740d3337335	UNCLASSIFIED	jpeg	2
318	a1d042d2-06e5-409f-b427-bde53089ec33	UNCLASSIFIED	jpeg	4
319	c49c850a-0d60-4c6c-a1ee-250865d6eb8f	UNCLASSIFIED	jpeg	7
320	bc8186d4-3fa6-4255-b721-9367c8e2a40a	UNCLASSIFIED	jpeg	5
321	ce227426-cf63-4469-833a-6ca875994ab2	UNCLASSIFIED	jpeg	2
322	226706c0-f6a5-4cc0-a7f8-b7bf67f7685a	UNCLASSIFIED	jpeg	4
323	953f3bf5-bd7b-4625-aac8-2f531763e310	UNCLASSIFIED	jpeg	7
324	e2ddc6e9-a22d-4b9d-9d98-71d5af92782d	UNCLASSIFIED	jpeg	5
325	829e4dd5-91d6-4a8b-83e9-aadd2632abb2	UNCLASSIFIED	jpeg	2
326	86de0361-55eb-4bff-9e82-756d5b00f24e	UNCLASSIFIED	jpeg	4
327	a2de8cf7-31fd-49fe-a46a-cbf6bbf52e92	UNCLASSIFIED	jpeg	7
328	1d55bc04-d028-4336-bcbb-1dd5baff1a8f	UNCLASSIFIED	jpeg	5
329	46f7c8d9-0c1f-4212-a157-3c54d32e64f9	UNCLASSIFIED	jpeg	2
330	d1af23d5-2abe-4034-9f14-4a26d80c5468	UNCLASSIFIED	jpeg	4
331	4f0b59ff-e48a-4022-aaba-6fd5c4a670fb	UNCLASSIFIED	png	7
332	2cf0abef-498d-4a8a-bae6-61b9ac013cd7	UNCLASSIFIED	png	5
333	5d78af19-9755-4f9b-9de6-0f94e35f0c31	UNCLASSIFIED	png	2
334	ae7df5fc-52e7-4dea-b792-b341178b8e7f	UNCLASSIFIED	png	4
335	451c6d18-1f7e-4d81-b144-1dd519c08bdd	UNCLASSIFIED	png	7
336	5f729b76-9d34-452d-a9e2-6a9fd8e5c5e9	UNCLASSIFIED	png	5
337	c467fc01-c006-42dc-9ca0-87d23da8c51a	UNCLASSIFIED	png	2
338	bf9f5749-15a8-4d9d-a258-a2522dffc43a	UNCLASSIFIED	png	4
339	570a733b-b4c5-4a92-91f9-1d0520b807a8	UNCLASSIFIED	jpeg	7
340	d642e1be-20db-4044-808c-b4e24756c886	UNCLASSIFIED	jpeg	5
341	f35c6ed5-5404-4c15-9683-f7ccf3866a0f	UNCLASSIFIED	jpeg	2
342	71471530-5d8c-4758-8bc0-862fbe8aace2	UNCLASSIFIED	jpeg	4
343	e0c2e3ff-2042-40d3-b4b5-9ab03c337809	UNCLASSIFIED	jpeg	7
344	474d1f8d-a4b6-4ffa-b482-62613f4ff1ac	UNCLASSIFIED	jpeg	5
345	6ace17e0-0e16-410b-8425-ea05dfde8e0f	UNCLASSIFIED	jpeg	2
346	c7282a3a-a1bb-4fbb-aad7-8410820dc75e	UNCLASSIFIED	jpeg	4
347	46690984-8250-498d-b278-513ac2a004d3	UNCLASSIFIED	png	7
348	ef5a6db4-d9b3-40f0-b200-4a6ac90465f6	UNCLASSIFIED	png	5
349	7992154a-c67b-4323-83fb-dc13a1753e5a	UNCLASSIFIED	png	2
350	eea005dc-270c-43be-a6d7-fdf7c13c01f4	UNCLASSIFIED	png	4
351	53f4162b-ebc9-48e7-b440-d5802bc048d4	UNCLASSIFIED	jpeg	7
352	d7582cc9-4eac-4db1-bb90-c7ff72cf5cfc	UNCLASSIFIED	jpeg	5
353	69180673-f838-43dc-8fe6-cbc7ff2f73d4	UNCLASSIFIED	jpeg	2
354	f5f7ccc7-f621-4607-a581-712aed1c3e6f	UNCLASSIFIED	jpeg	4
355	b378d6b5-7ae2-4229-93e4-de54723a3ce3	UNCLASSIFIED	jpeg	7
356	d65c830f-fcb2-4fab-a7c2-4c1b67b986a2	UNCLASSIFIED	jpeg	5
357	bccd8e4c-c634-409e-90c6-ef18317b5a38	UNCLASSIFIED//FOR OFFICIAL USE ONLY	jpeg	2
358	bf7fddf4-bd6b-4984-84a0-02042814c608	UNCLASSIFIED	jpeg	4
359	68486f13-39da-444c-8eb0-61c1dffdabc5	UNCLASSIFIED	jpeg	7
360	fe84129e-171d-4ddc-9af9-d1deb163bb9d	UNCLASSIFIED	jpeg	5
361	8d873873-1448-4fd4-b232-595d576080ac	UNCLASSIFIED	jpeg	2
362	ec0cec30-8b6d-48f0-8661-8aaa41b506c2	UNCLASSIFIED	jpeg	4
363	7ca49254-251f-44d9-9c02-e5dfa0f9c75f	UNCLASSIFIED	jpeg	7
364	71eefeac-5bb1-4539-9143-f1f6f2bc6822	UNCLASSIFIED	jpeg	5
365	f501cf10-2a2a-4e1c-a104-dc08cf014ff7	UNCLASSIFIED	jpeg	2
366	0c712d8a-2861-4924-958c-70a97756d8f9	UNCLASSIFIED	jpeg	4
367	2aeb8c26-4b7d-4155-ade1-9676b7d92c81	UNCLASSIFIED	jpeg	7
368	6e4e70e9-6f63-403d-bb2e-1367d863742b	UNCLASSIFIED	jpeg	5
369	73a07e59-1fc4-4c89-b251-ae8eac493525	UNCLASSIFIED	jpeg	2
370	8d77385f-8f0b-467a-84e5-03b025201b90	UNCLASSIFIED	jpeg	4
371	5f9d39b5-f6ce-491b-b6e6-1131e5725fe6	UNCLASSIFIED	jpeg	7
372	e8b8761c-08ad-40a2-820b-65ae1f8155a1	UNCLASSIFIED	jpeg	5
373	68bc9aad-4d65-4b20-a34f-36720295b774	UNCLASSIFIED//FOR OFFICIAL USE ONLY	jpeg	2
374	8a2d6ca2-bb98-4821-a894-ee4aac867cf7	UNCLASSIFIED//FOR OFFICIAL USE ONLY	jpeg	4
375	3a4608fb-46d3-49e1-ac3e-acc2c9054328	UNCLASSIFIED	png	7
376	ed77fe4e-b393-4f8a-a990-175f48d99f94	UNCLASSIFIED	png	5
377	c321336c-7c82-4881-bef4-475535650988	UNCLASSIFIED	png	2
378	044e1b86-328b-4f6f-bf93-9750cca7b8ea	UNCLASSIFIED	png	4
379	fc3db734-f310-432d-9e83-f0d1558d6b85	UNCLASSIFIED	jpeg	7
380	e6c4ea84-9444-4bda-9bd0-7abd27f57c57	UNCLASSIFIED	jpeg	5
381	dfda9991-cbbd-4f4a-9bf7-68f9ae8610fc	UNCLASSIFIED	jpeg	2
382	9a1518d2-f1bf-4f1f-a806-0657fa9bc1d8	UNCLASSIFIED	jpeg	4
383	4944e390-5004-46b6-8f88-5be75a7c9a30	UNCLASSIFIED	jpeg	7
384	8a66c182-07eb-4c9d-a7bd-70efdc8b26e0	UNCLASSIFIED	jpeg	5
385	2f00daeb-da5e-4b43-8388-98518f536f48	UNCLASSIFIED	jpeg	2
386	c310c9c2-99aa-4e29-a231-2de3d36c62a1	UNCLASSIFIED	jpeg	4
387	7d33bd5a-7faa-45ad-b0c4-8e5b2192e805	UNCLASSIFIED	png	7
388	83b647a1-0084-420d-9238-8de267d1ea6a	UNCLASSIFIED	png	5
389	d3029024-94a3-45ad-8767-b41913a42830	UNCLASSIFIED	png	2
390	91d200b9-c5b1-4c1e-a5fe-a566cd124356	UNCLASSIFIED	png	4
391	fa01dace-bb7c-4c1a-a2f3-9b1d60d80a3d	UNCLASSIFIED	png	7
392	0e59dbd3-8a37-48ed-9169-0c6e21ba9842	UNCLASSIFIED	png	5
393	cd558a56-7c2b-4ef0-a576-83bcd6752a39	UNCLASSIFIED	png	2
394	3f072f46-517f-494d-893e-3b4270743997	UNCLASSIFIED	png	4
395	555e2d0a-837c-47bd-8206-c24511bb6572	UNCLASSIFIED	png	7
396	78fcefda-3ae2-4b2b-a6f2-8ea569ad9db5	UNCLASSIFIED	png	5
397	d4b0fbff-a05e-4455-913c-257fc3a87752	UNCLASSIFIED	png	2
398	1b90f3cb-593f-4539-bca1-286309fd196a	UNCLASSIFIED	png	4
399	660d6731-8bf0-4fc3-8d7c-3b0fb7ad5c1e	UNCLASSIFIED	png	7
400	7c6185af-e293-4efc-941b-1bc1ef5b314b	UNCLASSIFIED	png	5
401	a9af919f-741e-4012-b9e3-e42c30a95987	UNCLASSIFIED	png	2
402	3e1d473d-92d2-46d7-af65-2de5e06bc336	UNCLASSIFIED	png	4
403	433c8223-1364-49b4-b068-1fb97ca51047	UNCLASSIFIED	jpeg	7
404	ce2868bd-3837-46df-a52c-5b925c4c4d9e	UNCLASSIFIED	jpeg	5
405	e7f334d3-f923-424d-b0fa-47d34db3b4ee	UNCLASSIFIED	jpeg	2
406	f7d0d799-8cc6-4388-a597-db1374f8a650	UNCLASSIFIED	jpeg	4
407	d4fe0641-8be7-4a67-8cb9-ca60adeb7612	UNCLASSIFIED	png	7
408	277ecc95-ad14-4f8b-8d62-53cd7f0db016	UNCLASSIFIED	png	5
409	0b781bb6-ed24-41ae-951b-436b317506b5	UNCLASSIFIED	png	2
410	291ecaa7-ea57-406e-8c8c-b5d3710d3930	UNCLASSIFIED	png	4
411	b2f969ff-569a-42f4-ba96-f12253a20ea2	UNCLASSIFIED	jpeg	7
412	76470e86-d8ef-407a-8c42-d40b2b2d6548	UNCLASSIFIED	jpeg	5
413	631f2589-b41a-4754-9e25-46096f9be3ba	UNCLASSIFIED	jpeg	2
414	5a9b5328-d1b3-4c33-88a5-20fd6373d35f	UNCLASSIFIED	jpeg	4
415	d80d8566-d0b1-4f40-8662-71dc198697e7	UNCLASSIFIED	jpeg	7
416	4a02568b-8717-476e-9d8c-a824e28fac49	UNCLASSIFIED	jpeg	5
417	5a85c3d4-5728-41a6-add3-681803c0d5f1	UNCLASSIFIED	png	2
418	609bf839-d4d8-4e6d-bce3-ae1e245220d4	UNCLASSIFIED	jpeg	4
419	6ee3693b-7654-4908-b0e6-513c6b597c51	UNCLASSIFIED	png	7
420	a40af0a5-c72a-4d1c-b2bb-b5cdb52ce2ad	UNCLASSIFIED	png	5
421	ebd9e6fe-352e-46b5-9a8f-24512b5d3476	UNCLASSIFIED	png	2
422	8a7dd47b-ce37-490d-9097-bf862e58dacd	UNCLASSIFIED	gif	4
423	d39d3e2f-9ee8-4953-a1a6-b376b1a2eaef	UNCLASSIFIED	png	7
424	3deb4010-d83d-4b31-a546-0a279d2d6bd9	UNCLASSIFIED	png	5
425	896105e5-32ab-4974-968e-ab03ef9ed96e	UNCLASSIFIED	png	2
426	36495d06-79b9-4685-8202-4ffbdce329af	UNCLASSIFIED	png	4
427	0cf0ae85-3172-418d-8f1c-d26e495f96fe	UNCLASSIFIED	jpeg	7
428	f375ed95-92fc-4b84-a843-f61c78eb9e52	UNCLASSIFIED	jpeg	5
429	3b9b948f-e218-4b53-b05e-e2e86b3b0305	UNCLASSIFIED	jpeg	2
430	832a2973-f84b-48e5-bdc9-dd405a94640e	UNCLASSIFIED	jpeg	4
431	6c19e05f-2b2f-4070-9998-738d6ac808f0	UNCLASSIFIED	png	7
432	b0422d91-ccf7-49c0-91ec-9cab172fc1da	UNCLASSIFIED	png	5
433	33fe4474-e21e-4cc6-abf1-6910e427a187	UNCLASSIFIED	png	2
434	79bb4a45-b1e4-49c6-b6f2-f06875a36e78	UNCLASSIFIED	png	4
435	76077a8f-4e7d-4eda-8052-629e6a00eb73	UNCLASSIFIED	jpeg	7
436	fa5c55f2-03e2-4e4c-a81e-947a9b55e11c	UNCLASSIFIED	jpeg	5
437	f2d9825b-3e95-4fdd-927e-30606adadb16	UNCLASSIFIED	jpeg	2
438	20f03ac1-9b4d-4e05-835e-fcf99e41b2fe	UNCLASSIFIED	jpeg	4
439	63b9a592-7edd-4832-8ce8-3af55de36e58	UNCLASSIFIED	jpeg	7
440	7d34be7e-a364-40bd-9712-c14b0382a800	UNCLASSIFIED	jpeg	5
441	16d3d721-c4b6-4669-b459-c97383e9920f	UNCLASSIFIED	jpeg	2
442	b2b91d31-ff4b-49e5-a535-169e400a0768	UNCLASSIFIED	jpeg	4
443	ceb81595-6b5a-422c-81cf-017703c39128	UNCLASSIFIED	jpeg	7
444	ca17cee3-b4d9-4bb4-8e0f-ff62efeee8bf	UNCLASSIFIED	jpeg	5
445	027ea485-5c77-4d9a-8fcd-af72cde4a1fc	UNCLASSIFIED	jpeg	2
446	81fa8bdb-2d6c-461b-8992-865add38786b	UNCLASSIFIED	jpeg	4
447	642b9859-9e35-423c-96e7-411c35464526	UNCLASSIFIED	png	7
448	93026a3f-507c-411a-b9e0-8025f41e1b7a	UNCLASSIFIED	png	5
449	407035de-1467-4a80-80ad-1695b9cefd57	UNCLASSIFIED	png	2
450	97682aaf-7ac4-42b3-8e70-02bc20a6e5d4	UNCLASSIFIED	png	4
451	cb5543ea-cd5b-4a6a-8cb9-a76e647ba728	UNCLASSIFIED	jpeg	7
452	aefba37f-b19c-4200-a3c8-5f001b4962e3	UNCLASSIFIED	jpeg	5
453	e73fd9c9-d5f6-4da4-80e5-548251bd608b	UNCLASSIFIED	jpeg	2
454	91ab6a55-a8d4-4937-a514-9c410f439f2d	UNCLASSIFIED	jpeg	4
455	af4e3a9c-7b76-496c-9226-9b8dba1fca75	UNCLASSIFIED	png	7
456	76c8e859-ca18-48e3-9aa9-e2a0de259a0c	UNCLASSIFIED	png	5
457	71691ae1-68ce-4ea4-b037-96be5fc9ef7c	UNCLASSIFIED	png	2
458	7aa9667d-c6f9-4c26-849a-3e0732f646ed	UNCLASSIFIED	png	4
459	2462a12e-e8d7-48f3-b7b2-b6b0f231f3af	UNCLASSIFIED	gif	7
460	71969d46-a43f-43fc-a4a5-b505818370b5	UNCLASSIFIED	gif	5
461	b3fbab8c-d8e0-4be6-a497-fed128f3ec87	UNCLASSIFIED	gif	2
462	7ecb2993-f316-4afd-a880-b8b26bb10090	UNCLASSIFIED	gif	4
463	efe64805-f1a9-4f07-8f1f-ff0d9b605623	UNCLASSIFIED	jpeg	7
464	83155c9c-f631-4c84-a7d4-fbd110a551b5	UNCLASSIFIED	jpeg	5
465	fdb65fd0-4642-4b68-abb6-639ad3c8dc9a	UNCLASSIFIED	jpeg	2
466	9c0e4d6f-0c51-4a8c-bea1-434d12a2df08	UNCLASSIFIED	jpeg	4
467	f7953bf0-d205-4e09-af9f-2df3546d89af	UNCLASSIFIED	jpeg	7
468	da005a1c-a045-40e3-91e2-e33a438d837d	UNCLASSIFIED	jpeg	5
469	9f37397c-2e54-48c7-ac25-1fe40c43a9d8	UNCLASSIFIED	jpeg	2
470	a08c2189-36b8-4262-9134-ba1bcd619753	UNCLASSIFIED	jpeg	4
471	0f46a847-7607-4819-a012-93df1f80a162	UNCLASSIFIED	jpeg	7
472	3644d184-f05c-4dd6-83af-d2eab973b7d4	UNCLASSIFIED	jpeg	5
473	18c8e85b-2f6e-45cb-9c47-c9a71010dae2	UNCLASSIFIED	jpeg	2
474	6a2787b8-aba7-4ed4-8679-00e77f1e43ca	UNCLASSIFIED	jpeg	4
475	16714c49-c961-4fb6-a089-8ae51fdac1f2	UNCLASSIFIED	jpeg	7
476	a1865fc7-08f2-44fd-a362-11bc5152060e	UNCLASSIFIED	jpeg	5
477	4ddda2f7-be38-4f91-806e-d311efe4a9e3	UNCLASSIFIED	jpeg	2
478	ca8827df-a950-42e5-93c2-9af2562e025d	UNCLASSIFIED	jpeg	4
479	e11ea107-a5cb-4c24-99b7-8318a7c7b9de	UNCLASSIFIED	jpeg	7
480	d4c97903-19d4-4f74-888b-21970fae1aa7	UNCLASSIFIED	jpeg	5
481	b49d7325-946c-43db-806b-bf08c274d572	UNCLASSIFIED	jpeg	2
482	da1df9b7-3ec3-46c2-85d0-748ebd133448	UNCLASSIFIED	jpeg	4
483	31fe7c64-11f5-4d56-ba94-b07225347c27	UNCLASSIFIED	jpeg	7
484	9378c38b-5ecb-4b7e-a622-152cf3f5688b	UNCLASSIFIED	jpeg	5
485	4d85ac0d-f56c-43f6-901f-819e0ab4bfe2	UNCLASSIFIED	jpeg	2
486	c4db9078-9652-4bb6-bf86-e3e045c849e8	UNCLASSIFIED	jpeg	4
487	45229ef2-8147-4732-b531-3b12311c8623	UNCLASSIFIED	jpeg	7
488	5257823f-41c3-4e29-a3d6-ff8570e0e995	UNCLASSIFIED	jpeg	5
489	69970111-4b90-4848-b41a-d9b233782f0e	UNCLASSIFIED	jpeg	2
490	55bff5c1-7f34-44a1-84ac-2fcb99342606	UNCLASSIFIED	jpeg	4
491	a6e04753-affe-49cc-9cad-e4842c2f22fb	UNCLASSIFIED	jpeg	7
492	79ad00a9-d4d6-4fff-b440-66811a102868	UNCLASSIFIED	jpeg	5
493	bc3fcda9-66ab-4dc7-b29a-f54681a9bfb6	UNCLASSIFIED	jpeg	2
494	17087874-008f-4753-91f3-0b6a02512413	UNCLASSIFIED	jpeg	4
495	8a6abbd0-09c4-4bbb-a7f8-29b79038222e	UNCLASSIFIED	jpeg	7
496	70070bd0-a24b-4485-9178-de21156039fe	UNCLASSIFIED	jpeg	5
497	cbb78770-0685-4aff-b2af-e891a257be73	UNCLASSIFIED	jpeg	2
498	2aeedcd3-5821-4322-b32a-ea3ca9972f9c	UNCLASSIFIED	jpeg	4
499	74148120-63b9-4e47-8cf3-90f944323409	UNCLASSIFIED	jpeg	7
500	5727e8fb-65d5-47d3-b787-88460df9f258	UNCLASSIFIED	jpeg	5
501	2cb1558b-6c42-4b73-9b13-0b107f44dc56	UNCLASSIFIED	jpeg	2
502	60667258-fd41-4725-a41e-90b3d968d170	UNCLASSIFIED	jpeg	4
503	2df3c39a-5cff-4bc8-bdf5-b80d5b1ddeba	UNCLASSIFIED	png	7
504	520abf5f-f16d-40e9-82ff-0a6aa34cb21c	UNCLASSIFIED	png	5
505	a8cf327c-5eeb-46f2-93fb-7db0c603c9b3	UNCLASSIFIED	png	2
506	60ebd5e4-ddf8-419f-99a4-8fb4eba50e2f	UNCLASSIFIED	png	4
507	c98f917f-9d86-41a7-a725-76b92f7413bd	UNCLASSIFIED	png	7
508	448d1b90-3ec6-4757-91b9-a2152a346cb3	UNCLASSIFIED	png	5
509	f147f183-7b44-4bf6-b5dc-c73e59e3f644	UNCLASSIFIED	png	2
510	0a0d6c11-d1c9-4b65-a990-b1d06b1d394a	UNCLASSIFIED	png	4
511	488469eb-7946-4ac9-b34e-8a3a97435047	UNCLASSIFIED	png	7
512	14a5befe-38c2-479b-910e-9a4f89d67daa	UNCLASSIFIED	png	5
513	1d41afdd-7365-461c-8107-a956e5dea484	UNCLASSIFIED	png	2
514	743e60b3-e6ad-41a5-ab85-8732ebcd70c6	UNCLASSIFIED	png	4
515	02dae00f-29b1-42b5-aee3-f15e524f0bf9	UNCLASSIFIED	jpeg	7
516	aba12127-4803-44cc-83ea-296496c37360	UNCLASSIFIED	jpeg	5
517	9f883b8e-1849-479a-92c3-c47ae7ee491a	UNCLASSIFIED	jpeg	2
518	fe0a4b5a-e8ab-47d0-8bc4-2e9a6988048b	UNCLASSIFIED	jpeg	4
519	790f4617-5bc7-4a63-b9f8-0a64438f810f	UNCLASSIFIED	jpeg	7
520	aa2b8a75-2986-41d8-aa00-1aed32bc472e	UNCLASSIFIED	jpeg	5
521	96283918-b7b0-406b-88f1-6a013c8f1b2a	UNCLASSIFIED	jpeg	2
522	095dc583-2089-4041-ae68-51d90679c51f	UNCLASSIFIED	jpeg	4
523	0d877bc3-d3ad-4c88-8021-2d32d142348e	UNCLASSIFIED	png	7
524	6b757951-0df6-4139-a284-c880147445ad	UNCLASSIFIED	png	5
525	24ecb387-858f-4e01-ae14-fb76ce842e7f	UNCLASSIFIED	jpeg	2
526	aa36d56f-c21b-4ac7-8894-5d5ef02d853f	UNCLASSIFIED	jpeg	4
527	39d3ee47-1e19-4073-ab73-0f77440e0271	UNCLASSIFIED	jpeg	7
528	b1dd9d0f-e7b1-49bb-8ccc-a52bc6e9e1bf	UNCLASSIFIED	jpeg	5
529	7e57f39c-a60b-4d7e-8f2a-94bb2cb33a69	UNCLASSIFIED	jpeg	2
530	bcefaa59-0b55-40a5-95e8-e362de19df7d	UNCLASSIFIED	jpeg	4
531	507b474c-4d84-488d-bea2-81cfd15601a1	UNCLASSIFIED	jpeg	7
532	29924aa3-5951-4cdb-a347-53f5930cdeb4	UNCLASSIFIED	jpeg	5
533	e4935c06-baf8-486b-8d89-b25db6977788	UNCLASSIFIED	jpeg	2
534	6ee348f6-71e1-4975-9cfa-e76bc750605b	UNCLASSIFIED	jpeg	4
535	6188112d-2210-4a47-912f-a2818c1c7466	UNCLASSIFIED	jpeg	7
536	b86b34b6-b832-4e3c-8d76-971b0e302e02	UNCLASSIFIED	jpeg	5
537	11d64322-91a6-4f81-a54b-95d8ee4ea092	UNCLASSIFIED	jpeg	2
538	f74d3394-9836-4f4e-9b11-d87e7ed33c8c	UNCLASSIFIED	jpeg	4
539	0ef580d6-ca58-46fe-ba64-e04479c23f0f	UNCLASSIFIED	png	7
540	974a7ca0-ba26-491c-9531-1a9a886a2bad	UNCLASSIFIED	png	5
541	8856e2e7-e8b9-4925-bf8d-3604dbcd784e	UNCLASSIFIED	png	2
542	c4023bc6-97ed-4d0d-82cd-65f76b02d076	UNCLASSIFIED	png	4
543	edd0dd39-8550-475c-8f33-790789704dec	UNCLASSIFIED	jpeg	7
544	c8676301-cc73-4439-ad83-62ce4eb95916	UNCLASSIFIED	jpeg	5
545	c7160ccd-1813-4cb2-aa7e-28d16dbbf25a	UNCLASSIFIED	jpeg	2
546	994be4db-e720-4843-91ee-595f760cce53	UNCLASSIFIED	jpeg	4
547	a366987d-25cd-4238-afc2-698232008241	UNCLASSIFIED	jpeg	7
548	e4e63da4-5eba-4674-9844-76473225b9f1	UNCLASSIFIED	jpeg	5
549	223c3235-9c71-4d0a-ab5c-8c8194b06e11	UNCLASSIFIED	jpeg	2
550	a15f01b0-c516-45a7-b8ed-0a374b6ce7de	UNCLASSIFIED	jpeg	4
551	05dfd7b0-3402-43ed-ab9c-b48e18ac95a8	UNCLASSIFIED	jpeg	7
552	b7d73e1e-d511-4fe0-8f67-3443f39113f7	UNCLASSIFIED	jpeg	5
553	770a76b3-4c00-4152-91b6-a83869f294f1	UNCLASSIFIED	jpeg	2
554	39a8680d-51d6-4ed2-9e37-eca5494d2cf8	UNCLASSIFIED	jpeg	4
555	0bdc1621-ff57-4880-b4e6-5183d90e2002	UNCLASSIFIED	png	7
556	cec171e9-c207-4edd-a25b-f3d6ea579020	UNCLASSIFIED	png	5
557	086fc383-e7d0-4932-bb22-b900918868fb	UNCLASSIFIED	png	2
558	04cb2798-9b4b-480d-9cfd-1eb393c5b50c	UNCLASSIFIED	png	4
559	2b5d8a81-9dc6-4d43-9839-d7502221fcfc	UNCLASSIFIED	png	7
560	51a6f3f7-4d92-48e3-b017-ba9124404dda	UNCLASSIFIED	png	5
561	a9d7ae64-345b-4713-a7e2-0c41a9f65e20	UNCLASSIFIED	png	2
562	09aec1ad-0519-4bf8-bd0e-0f3c395068f0	UNCLASSIFIED	png	4
563	a04d1d0b-02a0-417f-92e0-5315b2b139d4	UNCLASSIFIED	jpeg	7
564	796821a3-da26-457c-9ae2-2e15903ade38	UNCLASSIFIED	jpeg	5
565	b617e2c7-038e-45be-8fa1-9bd351f3c66b	UNCLASSIFIED	jpeg	2
566	a46214fa-7850-4806-ba6b-dce792053025	UNCLASSIFIED	jpeg	4
567	596ccb4a-0992-4808-89de-17d3753037ee	UNCLASSIFIED	png	7
568	9871b690-39bc-43b7-92f8-741c8f96eaf3	UNCLASSIFIED	png	5
569	a0f72de5-999d-4018-b8eb-662f7138325f	UNCLASSIFIED	png	2
570	9740d815-94c1-46b8-8edf-32321895c55f	UNCLASSIFIED	png	4
571	80df2116-d17a-47f3-b29c-360826d4a1e3	UNCLASSIFIED	jpeg	7
572	eb14bff6-a1e3-4279-a237-b1ee63547a86	UNCLASSIFIED	jpeg	5
573	7f76e2e0-d6dd-42e8-b583-d8f70b497074	UNCLASSIFIED	jpeg	2
574	b104075b-62ee-48f8-b9cd-84fe47b3357a	UNCLASSIFIED	jpeg	4
575	461526e0-6654-45d2-99e3-4cacdfbd1d18	UNCLASSIFIED	jpeg	7
576	d8ac4dd8-e957-4a87-9069-431ed71cc001	UNCLASSIFIED	jpeg	5
577	cec5f06e-719b-4340-9008-20fee3f40b36	UNCLASSIFIED	jpeg	2
578	473b3520-a307-48a4-90d3-c62179935b15	UNCLASSIFIED	jpeg	4
579	3d004a8b-307d-47e6-8644-85b4e63671d5	UNCLASSIFIED	jpeg	7
580	78b0a6a0-2dfa-4144-9cc8-e3f6e129b2ba	UNCLASSIFIED	jpeg	5
581	747968bd-bcbc-4075-ad08-19a7b251c2e4	UNCLASSIFIED	jpeg	2
582	551ac48b-c049-476e-9311-b6d2ee236dd0	UNCLASSIFIED	jpeg	4
583	dd7681a7-05a1-4904-9e97-dc50736c1e26	UNCLASSIFIED	jpeg	7
584	e2dc0439-aabe-4a50-a7b2-f81b510c6965	UNCLASSIFIED	jpeg	5
585	765e9630-8e82-4642-8c2b-1b19db1f9da8	UNCLASSIFIED	jpeg	2
586	b3b6e617-2114-4763-b1a7-690416c8ee43	UNCLASSIFIED	jpeg	4
587	134c3fe1-6ed6-459a-b0b8-8cb340ea7ca4	UNCLASSIFIED	png	7
588	a02298d5-a303-4091-b40b-b2c99dc93b75	UNCLASSIFIED	png	5
589	15baff51-28e4-4dca-b995-3e50a9aa3308	UNCLASSIFIED	jpeg	2
590	89e7a33c-ec7c-4121-a604-1b5d941647ed	UNCLASSIFIED	jpeg	4
591	8ea1ae35-305a-48ef-91b3-61b8fa150661	UNCLASSIFIED	jpeg	7
592	455e2874-339c-4868-8248-4b21770386d3	UNCLASSIFIED	jpeg	5
593	ec11f096-ac7b-4289-9741-256f79628c1a	UNCLASSIFIED	jpeg	2
594	9a40a144-6c80-4866-9629-967922d3cb72	UNCLASSIFIED	jpeg	4
595	ac777b31-70cb-4332-8344-037a4cad9938	UNCLASSIFIED	jpeg	7
596	9c3240dd-61dc-4554-96f6-a3e1a018b0c8	UNCLASSIFIED	jpeg	5
597	93215e28-9c66-4ecc-81ec-95381c04aba4	UNCLASSIFIED	jpeg	2
598	c4b86eb3-057b-4ecb-bc06-3ec3fd9ff040	UNCLASSIFIED	jpeg	4
599	37a068b9-34bb-4b32-95b6-9f18869735ee	UNCLASSIFIED	jpeg	7
600	50acae52-4a63-4d3c-945b-04c2a48c17ab	UNCLASSIFIED	jpeg	5
601	170990d5-8b84-4b86-aa85-7c36eb9dd5ac	UNCLASSIFIED	png	2
602	841b23aa-f267-407a-bd9f-be692f95a6bd	UNCLASSIFIED	jpeg	4
603	6bd2a8fa-6884-41bb-8e3d-8da22f6bd658	UNCLASSIFIED	jpeg	7
604	c9ba6b12-db61-4abd-9e04-16f074f7c701	UNCLASSIFIED	jpeg	5
605	c1cc4cdb-f35d-4151-86dc-ab19564475d1	UNCLASSIFIED	jpeg	2
606	bc5294d5-b676-4a23-9b23-9b0e3b74b675	UNCLASSIFIED	jpeg	4
607	aded77c3-7a1f-4e9a-ba2b-a2bda887391f	UNCLASSIFIED	jpeg	7
608	b588c645-d48f-42c8-a0d1-a7ddb684d451	UNCLASSIFIED	jpeg	5
609	a6fb2360-0aae-4c98-81c2-161e22141cb7	UNCLASSIFIED	jpeg	2
610	2cd05a3f-4c8d-495a-851a-233527e8961e	UNCLASSIFIED	jpeg	4
611	646ed729-b249-4533-945e-381f9fce38a7	UNCLASSIFIED	jpeg	7
612	64d4aea4-e48a-4087-a2c6-f9fb3ac635c7	UNCLASSIFIED	jpeg	5
613	08548865-2c3c-41e1-b4a1-28541bba05f8	UNCLASSIFIED	jpeg	2
614	f8944366-1b6d-4e93-9bc2-d46c7ee0fc9a	UNCLASSIFIED	jpeg	4
615	c1557967-af9a-4489-bf2f-0535a58df4de	UNCLASSIFIED	png	7
616	c0c1f905-8da7-4786-8edc-3f3a84b9de57	UNCLASSIFIED	png	5
617	497f12f6-4d70-45dd-9a32-185e96b7da8c	UNCLASSIFIED	png	2
618	db5f900c-c7d0-4d34-ac4b-6fde7c7e4be6	UNCLASSIFIED	png	4
619	35a22b20-e0d3-4790-9c54-8b2ecaa672b2	UNCLASSIFIED	jpeg	7
620	4eb418cd-c94e-4637-9f53-c28074c4f017	UNCLASSIFIED	jpeg	5
621	0975e576-8092-4c5b-b493-7af9cfb984d8	UNCLASSIFIED	jpeg	2
622	e6a27f10-6de5-4fc7-9107-ac60f6f497ac	UNCLASSIFIED	jpeg	4
623	ee908a73-88e1-4d53-98b6-c6450b233aa3	UNCLASSIFIED	jpeg	7
624	78ef6d29-5367-4e33-958d-69aae2f67ec2	UNCLASSIFIED	jpeg	5
625	36def8cd-ef7a-43cc-ab2a-24c8cb6b30f2	UNCLASSIFIED	jpeg	2
626	33f9d4db-bfcd-4303-8d4d-4c0989cdcd5a	UNCLASSIFIED	jpeg	4
627	d8aa0322-2c09-435e-8619-3a70842aade2	UNCLASSIFIED	jpeg	7
628	bf62ca9e-d580-404b-98bb-717afa50bb9b	UNCLASSIFIED	jpeg	5
629	264bc556-d343-4978-b002-692c886e139e	UNCLASSIFIED	jpeg	2
630	feb80041-441f-4667-b84f-fe7907e3e2cf	UNCLASSIFIED	jpeg	4
631	cf1f7dcc-5614-4920-a73c-232585a90704	UNCLASSIFIED	jpeg	7
632	7a275494-51ef-4f2e-a4e1-810c0e9531fc	UNCLASSIFIED	jpeg	5
633	dea8e965-2f4d-4ed5-9008-bfa555bcbf5f	UNCLASSIFIED	jpeg	2
634	c45355fd-61ef-4740-be33-ffa798d377ec	UNCLASSIFIED	jpeg	4
635	0b54f93b-cc44-4c41-b39d-a76dbe475c63	UNCLASSIFIED	jpeg	7
636	968a28c3-6b04-4b2d-b022-5ed5335855fb	UNCLASSIFIED	jpeg	5
637	38ebaaff-9dee-4455-ab9a-db8d60139fd6	UNCLASSIFIED	jpeg	2
638	6a4d724b-c827-4b64-8970-d5409360da86	UNCLASSIFIED	jpeg	4
639	ee2a16d9-6d45-457f-afc1-148a7b240e23	UNCLASSIFIED	jpeg	7
640	67efc06c-5edd-4ea9-83bd-f506e7dde82a	UNCLASSIFIED	jpeg	5
641	0ead3439-bda7-44c4-aa76-791cb7bea76a	UNCLASSIFIED	jpeg	2
642	7140d312-1a6d-46da-a170-a8a612d14c57	UNCLASSIFIED	jpeg	4
643	c91ff263-842e-4067-961e-22c0041979fb	UNCLASSIFIED	jpeg	7
644	489dc2e4-c3c6-4572-995e-064f1f175e44	UNCLASSIFIED	jpeg	5
645	2e79fd63-51e6-4404-bce0-5dcc4022cdc4	UNCLASSIFIED	jpeg	2
646	bd634da7-2ab0-4dc3-bfd1-925847ea8d01	UNCLASSIFIED	jpeg	4
647	1eeab823-3782-4ce6-b254-e9c3891245ab	UNCLASSIFIED	png	7
648	a6b9c3b1-9cd9-4e16-8039-a46bcd372371	UNCLASSIFIED	jpeg	5
649	6ca845d2-93ff-4231-adca-723620ec69a0	UNCLASSIFIED	jpeg	2
650	34a81744-4a08-4a1f-8602-46a1bf69c78f	UNCLASSIFIED	jpeg	4
651	f912d802-36b6-4c14-a0ec-5f6871829006	UNCLASSIFIED	jpeg	7
652	a5edc56e-55d4-420a-ae1f-2bc7aa3e75cf	UNCLASSIFIED	jpeg	5
653	9d268c20-a7d5-428e-8831-2df7586060d0	UNCLASSIFIED	jpeg	2
654	30618dd6-f5ed-4bd6-ad74-6af61063e777	UNCLASSIFIED	jpeg	4
655	6247150f-f653-4f0a-b623-3088f9b8dda5	UNCLASSIFIED	jpeg	7
656	60a97e4c-74a1-409e-b3dc-da549306c1f0	UNCLASSIFIED	jpeg	5
657	5c64bd0f-30f1-4b59-9cc4-12a7b5373b41	UNCLASSIFIED	jpeg	2
658	cdad96d9-2b5c-4f77-b950-824419e4ffc1	UNCLASSIFIED	jpeg	4
659	ac34e588-fea3-471a-934a-92fd61611946	UNCLASSIFIED	jpeg	7
660	4e6e12cc-2408-4739-8494-9f2997c4fa15	UNCLASSIFIED	jpeg	5
661	5f341c3e-f48e-476f-adff-dbc087dd4f15	UNCLASSIFIED	jpeg	2
662	a2c69302-5b38-4b4e-9fb3-6dbdfab22ceb	UNCLASSIFIED	jpeg	4
663	ee3a8d62-7407-4b0e-ad0e-b722e1778d2d	UNCLASSIFIED	png	7
664	824b1b08-2a4b-4baf-88ff-92869ac1e2fa	UNCLASSIFIED	png	5
665	17dced3e-041c-4dc9-b443-7f7aedaa0698	UNCLASSIFIED	png	2
666	410e587d-d03e-4d94-9707-4933854201c5	UNCLASSIFIED	png	4
667	cf09ab64-9907-477d-8f3d-87fdad3bf846	UNCLASSIFIED	jpeg	7
668	935e73f9-f5fb-4ab6-b574-e1419adb1c7e	UNCLASSIFIED	jpeg	5
669	204e6f32-b40b-42cf-b0e9-fc79993ec6c8	UNCLASSIFIED	jpeg	2
670	acac868a-8641-4e8f-9e1d-8cbccade22e7	UNCLASSIFIED//FOR OFFICIAL USE ONLY	jpeg	4
671	7334d9bc-8340-434d-868e-6d95ef19e245	UNCLASSIFIED	jpeg	7
672	ac39d994-0c51-4572-ba7a-1dc92e7cd90a	UNCLASSIFIED	jpeg	5
673	f614212f-1f99-45bd-8398-23083345b8c7	UNCLASSIFIED	jpeg	2
674	9062e677-cccc-4cea-80f9-5b47f235a125	UNCLASSIFIED	jpeg	4
675	58a02e59-de18-4419-865f-940d7f422c86	UNCLASSIFIED	jpeg	7
676	421069e7-0b9f-40c6-a4ce-4300b0f5a1af	UNCLASSIFIED	jpeg	5
677	31f5960e-043e-44d3-b47d-951f7f54a42e	UNCLASSIFIED	jpeg	2
678	ba925e6a-5aa0-4620-8bc1-6d811d8e1c58	UNCLASSIFIED	jpeg	4
679	f524dd7e-691c-46bf-993f-a1bf1e39a8c0	UNCLASSIFIED	jpeg	7
680	8c5d53cd-17f9-434b-9768-1f3a97446173	UNCLASSIFIED	jpeg	5
681	a6048b6e-5140-44dc-8a42-ea09c41ba644	UNCLASSIFIED	jpeg	2
682	1d004c8d-9d64-4b34-abfc-b17756e0f6e0	UNCLASSIFIED	jpeg	4
683	3fb085de-dfe0-4bd1-8e99-a24d5bff6606	UNCLASSIFIED	jpeg	7
684	6939895e-f6f6-462f-85a3-834fcc7ee699	UNCLASSIFIED	jpeg	5
685	f22a9e14-03c6-4e52-9d05-0abd26df3f84	UNCLASSIFIED	jpeg	2
686	32a41448-8893-4fe5-9c3b-1e4ea58120a3	UNCLASSIFIED	jpeg	4
687	bfe46dfb-427d-4c12-a191-63e4e19b67f4	UNCLASSIFIED	png	7
688	2ddc18bc-ce37-4201-937f-8221705dc468	UNCLASSIFIED	png	5
689	3ce867f2-a44e-488b-b9c9-bbc2242670c5	UNCLASSIFIED	png	2
690	40342fe3-09d7-4195-84db-b6865e658465	UNCLASSIFIED	png	4
691	53c1c586-37ce-4c11-afc4-347350884d65	UNCLASSIFIED	jpeg	7
692	18d8c9a0-a8a1-4cf8-b905-e3f221bc970d	UNCLASSIFIED	jpeg	5
693	656feacd-9684-4123-8625-28c796353a52	UNCLASSIFIED	jpeg	2
694	2c37a4f0-e40d-4d0c-92ef-87ffd647d4f9	UNCLASSIFIED	jpeg	4
695	07b5bf95-9319-4ea8-91b0-bf24ce01ca3d	UNCLASSIFIED	jpeg	7
696	2ed212de-fe15-4fa5-a125-8424e35fcbf6	UNCLASSIFIED	jpeg	5
697	d2c3ee8d-f1a2-4f5e-aefd-2fe9392af9b1	UNCLASSIFIED	jpeg	2
698	4122bd43-1f2d-4daa-8013-50427e0a3d03	UNCLASSIFIED	jpeg	4
699	066890e3-acb5-4180-ba84-a420ec0ec1bd	UNCLASSIFIED	jpeg	7
700	0b33d431-185c-4cbc-9c17-bc353b973112	UNCLASSIFIED	jpeg	5
701	e5cea50e-0d75-4109-8594-02a38f74cabc	UNCLASSIFIED	jpeg	2
702	0ef21d48-d3e0-4191-8972-bc3deac32df7	UNCLASSIFIED	jpeg	4
703	5225c02d-8e54-411c-b0c7-9b1806882ecb	UNCLASSIFIED	jpeg	7
704	c451e1a7-b278-4409-b7a0-18e2966a6f90	UNCLASSIFIED	jpeg	5
705	f64439e3-d566-46c8-86be-647af9c8c021	UNCLASSIFIED	jpeg	2
706	c2f1bd2f-2a98-4253-8ff9-6463035c53ce	UNCLASSIFIED	jpeg	4
707	58074a76-3d9f-4c55-884e-5c1133c715d2	UNCLASSIFIED	jpeg	7
708	8db18385-4e5d-42ec-a191-4752db061776	UNCLASSIFIED	jpeg	5
709	a34ce81b-ca03-4d72-9c83-827186c4ddd1	UNCLASSIFIED	jpeg	2
710	bb64aa39-ce53-4ff6-951a-d19698e06e40	UNCLASSIFIED	jpeg	4
711	a616245f-4881-4872-a75d-e4207ea32575	UNCLASSIFIED	png	7
712	ac61fa8b-b4fa-471a-9490-eb739842e6af	UNCLASSIFIED	png	5
713	af57d2ae-29a6-48be-b02f-877aa0ebd57d	UNCLASSIFIED	png	2
714	97553e55-4188-4424-b5b6-11b2f7602af0	UNCLASSIFIED	png	4
715	69e0f6a7-4553-4dfc-b857-842d3f445c96	UNCLASSIFIED	jpeg	7
716	f15ea62b-09bd-4672-841e-96792c14d905	UNCLASSIFIED	jpeg	5
717	ae899e43-534b-4884-b992-5cf75640f2c8	UNCLASSIFIED	jpeg	2
718	a813f580-b993-4359-8335-d2de81365cb2	UNCLASSIFIED	jpeg	4
719	5ccb7c16-3b92-4986-aeb9-d66abfefaeb9	UNCLASSIFIED	jpeg	7
720	b186aa30-c823-4b86-8ffa-09ad12783c2e	UNCLASSIFIED	jpeg	5
721	5c54a0c5-cb94-4239-be73-cae80b8ebb98	UNCLASSIFIED	jpeg	2
722	f278b79a-2f4e-4e63-b519-0b5102db4b31	UNCLASSIFIED	jpeg	4
723	7ebe8f9d-cc20-4021-abcf-fd60eb67e76b	UNCLASSIFIED	jpeg	7
724	5965f453-f8bc-4c7b-87a8-242f03a6002a	UNCLASSIFIED	jpeg	5
725	9ff7a21d-fb15-47a5-8545-dfff97d96b3c	UNCLASSIFIED	jpeg	2
726	7ed4e3c5-8921-4b02-bad6-ad22f46d0683	UNCLASSIFIED	jpeg	4
727	877bf692-35c5-4a6d-8461-3620561637f0	UNCLASSIFIED	jpeg	7
728	420ada4e-4b7b-41ee-a278-8b7d4773870a	UNCLASSIFIED	jpeg	5
729	cdaa3041-83d0-420a-97b5-223a472e3840	UNCLASSIFIED	jpeg	2
730	114f7d5b-5d12-49ea-bc86-ff5cdca20262	UNCLASSIFIED	jpeg	4
731	c80be556-7827-4283-a0d4-3d1bd1f0eedd	UNCLASSIFIED	jpeg	7
732	9e937d74-970d-4e1d-aaad-101976f13f83	UNCLASSIFIED	jpeg	5
733	d4750d5e-ac9c-4df0-acf3-9d4afd1aa585	UNCLASSIFIED	jpeg	2
734	497a60dd-8317-4680-87f1-10a03c84369e	UNCLASSIFIED	jpeg	4
735	2daf2ce7-382e-4c7f-b06c-66dc1e7a3241	UNCLASSIFIED	png	7
736	02fcea6e-510c-4204-ab76-c2a6e1bbdf7d	UNCLASSIFIED	png	5
737	c5d53f7f-fe99-41b7-821d-dc8064953af5	UNCLASSIFIED	png	2
738	a1c0eef4-041b-4126-90fd-55865a9735a9	UNCLASSIFIED	png	4
739	ad497898-65d6-4c1b-b375-92304cab13c4	UNCLASSIFIED	png	7
740	e536be58-f504-4d56-ae51-18fd6f6e0f77	UNCLASSIFIED	png	5
741	5805f258-9cc8-47db-a500-6a7b850aebf7	UNCLASSIFIED	png	2
742	0bd95d28-c2dd-419b-b494-7aac9b8322cc	UNCLASSIFIED	png	4
743	6a88b8d4-ab6f-4ea2-bf9d-437a88df178f	UNCLASSIFIED	png	7
744	3fc5898d-1a56-4098-b2e2-66069770b99b	UNCLASSIFIED	png	5
745	3f944160-585b-4e29-b149-98e92990c891	UNCLASSIFIED	png	2
746	6d512af7-8c4d-4e67-b8fe-c6675882aee2	UNCLASSIFIED	png	4
747	af8da639-a9fc-48c3-9ccd-fa9b2c0eca80	UNCLASSIFIED	jpeg	7
748	3c336058-87f8-4399-8fad-a734e3598171	UNCLASSIFIED	jpeg	5
749	aa4be989-58a7-4f1b-a962-387f8a16415b	UNCLASSIFIED	jpeg	2
750	3a8bcf33-5e14-4c61-a0a3-4ae999d13f52	UNCLASSIFIED	jpeg	4
751	0752c091-fb2a-4350-b899-e0378d5dcca5	UNCLASSIFIED	jpeg	7
752	7816ed42-d26d-4d40-b2db-2ce2fc9997ed	UNCLASSIFIED	jpeg	5
753	86331b9a-0d04-424e-ba01-dfc37ed832a5	UNCLASSIFIED	jpeg	2
754	bd80ed62-d63b-422b-ba93-5c399730f377	UNCLASSIFIED//FOR OFFICIAL USE ONLY	jpeg	4
755	5dae6bcc-1a5a-4c13-817d-3b490163faec	UNCLASSIFIED	jpeg	7
756	2f1248b2-3243-4864-a52a-1c148f4e57e3	UNCLASSIFIED	jpeg	5
757	b25db9b4-c348-42a3-b27e-d4bbd45cfe42	UNCLASSIFIED	jpeg	2
758	badb1cf5-d6ef-45ac-89c3-b25a67d30cda	UNCLASSIFIED	jpeg	4
759	9fa37bf5-d8d0-43cc-945e-cf71a8c9a03c	UNCLASSIFIED	jpeg	7
760	5b32b3c5-ab29-4d9e-8bc6-8bd6097bc26a	UNCLASSIFIED	jpeg	5
761	ffbf0c9b-0ab7-4f68-b027-59bfb8dacd06	UNCLASSIFIED	jpeg	2
762	491bc73e-6d7e-43c9-bd62-da539188755a	UNCLASSIFIED	jpeg	4
763	b64a2fb8-83b9-4cd0-9fc6-dd85cbcfc814	UNCLASSIFIED	jpeg	8
764	a5ec6925-b7e4-46d0-9333-0d02101333d1	UNCLASSIFIED	jpeg	6
765	21cc4412-edac-4bac-a49b-60adc817eeb9	UNCLASSIFIED	png	8
766	68a0728f-53da-4aec-be7c-c5da83697ceb	UNCLASSIFIED	png	6
767	2fdd386e-e7fa-4879-b81c-21fa1bab7383	UNCLASSIFIED	png	8
768	77632d08-c35b-48a9-baa7-b0d73f0df84d	UNCLASSIFIED	png	6
769	1889e18b-4f24-4139-a866-70fc6d8f95e9	UNCLASSIFIED	jpeg	8
770	c218d87e-cbe4-4557-a964-08df8b4c5318	UNCLASSIFIED	jpeg	6
771	5fdefd73-dae3-49cb-8218-71d85f8d2dc7	UNCLASSIFIED	jpeg	8
772	0c808658-58aa-4eca-aa33-3c18a19db1f7	UNCLASSIFIED	jpeg	6
773	3a8fbd30-67dd-4fbd-af2a-3c69f319d32a	UNCLASSIFIED	jpeg	8
774	a0e8cc2f-06eb-4cce-82d3-7c9ab526adb5	UNCLASSIFIED	jpeg	6
775	0d33a5c4-e715-49a3-b828-446d22626a7a	UNCLASSIFIED	jpeg	8
776	f6e6766e-836c-461e-bf8d-90a39492464f	UNCLASSIFIED	jpeg	6
777	d59df491-7a88-4d54-9ce1-be3bdf921f6a	UNCLASSIFIED	png	8
778	2b582df5-5718-43fe-b03b-6a7cd569095e	UNCLASSIFIED	png	6
779	0933a952-dc99-4683-8e51-897d63e43815	UNCLASSIFIED	png	8
780	ab81299b-7729-4040-a686-5cc42e1cc040	UNCLASSIFIED	png	6
781	47f40eaf-1ef2-4924-9152-83a538862d74	UNCLASSIFIED	jpeg	8
782	1bca0ab3-4a38-4666-a65b-0b7585ca9d99	UNCLASSIFIED	jpeg	6
783	5f6a0c54-f174-44b3-aede-0ee78abbddb9	UNCLASSIFIED	png	8
784	73943d74-67e5-47d3-9912-947d5a86c437	UNCLASSIFIED	png	6
785	902da40d-6991-44cc-a7a9-8caff12c9aab	UNCLASSIFIED	jpeg	8
786	3158c1a7-008d-42b5-acdb-801143beecb9	UNCLASSIFIED	jpeg	6
787	1f136a7e-4440-4c4e-ab2f-55806d9b2b96	UNCLASSIFIED	jpeg	8
788	b09bb7d6-6072-489e-9a60-7ec6dd1f8b66	UNCLASSIFIED	jpeg	6
789	5fbbf428-54d0-468c-bcfe-9852220921d8	UNCLASSIFIED	jpeg	8
790	efcb6b34-896c-48da-b346-13e2c99a327d	UNCLASSIFIED	jpeg	6
791	49c7f9a8-1530-40bc-a8b0-7f8c65faf516	UNCLASSIFIED	jpeg	8
792	e5aaeac1-e77f-4c06-916b-f7bfb1ab20b0	UNCLASSIFIED	jpeg	6
793	9823bef8-4a96-4ec6-86ca-d0d4ab4874cf	UNCLASSIFIED	jpeg	8
794	9f7a0e89-84f0-4cd2-92bf-9629a599e8e0	UNCLASSIFIED	jpeg	6
795	47efddd8-c78a-4a0d-b5b4-86ea088b643b	UNCLASSIFIED	jpeg	8
796	b5a56326-335e-4e80-8ad8-41ba041df155	UNCLASSIFIED	jpeg	6
797	5da83640-9736-4f96-9071-c61e9203efb0	UNCLASSIFIED	jpeg	8
798	a8dc0b38-41a1-4947-8f66-5d634ac3ab24	UNCLASSIFIED	jpeg	6
799	0e0c2bb8-c02c-4abb-aded-aa2a40ad0371	UNCLASSIFIED	jpeg	8
800	365cfbc8-0797-467e-9a3d-533f7f22d921	UNCLASSIFIED	jpeg	6
801	9038a944-a152-43a0-9707-b87641448b26	UNCLASSIFIED	jpeg	8
802	8bc682f8-fe8c-476b-9ecc-a416842a1784	UNCLASSIFIED	jpeg	6
803	41e7c064-4e80-43d2-8123-c0a49b3f6bd2	UNCLASSIFIED	png	8
804	a6ffc7e6-b515-4b3e-bb7f-434d52b7fbba	UNCLASSIFIED	png	6
805	812e1983-662a-46c4-a22e-73fa18f5a5a2	UNCLASSIFIED	jpeg	8
806	c931f1c9-5179-47a1-8be6-c804b4845cfa	UNCLASSIFIED	jpeg	6
807	c8d60955-8e08-46ec-849b-fb4fd02faf26	UNCLASSIFIED	jpeg	8
808	aa941f6e-46a9-4a9e-850b-0df97d023fbb	UNCLASSIFIED	jpeg	6
809	1ef57a5b-3993-406d-b6dc-61dbe96a5f02	UNCLASSIFIED	jpeg	8
810	98da5231-dcc4-42b4-8bc6-445efb9826f4	UNCLASSIFIED	jpeg	6
811	7537c5d4-3d9d-4575-924c-53a98c96ed3c	UNCLASSIFIED	jpeg	8
812	19748110-218e-41e5-b7e9-a895b4c8a0ac	UNCLASSIFIED	jpeg	6
813	e103fcc0-37e1-4828-b961-6020d4f34a3b	UNCLASSIFIED	png	8
814	fd8ba2b0-7bb5-4eaa-a187-fd7a6d739304	UNCLASSIFIED	png	6
815	42d763af-ac81-40fe-a7cc-fe780505600c	UNCLASSIFIED	png	8
816	c48caaaf-45af-4400-a1e3-7fd09f81e36f	UNCLASSIFIED	png	6
817	b16103fb-b799-49cd-bb78-ec2c5d5dfbe4	UNCLASSIFIED	jpeg	8
818	6ea5f8a7-a43b-4043-9346-3ccce14c4f98	UNCLASSIFIED	jpeg	6
819	875a7320-5229-4cdd-96b8-310e9f0220c2	UNCLASSIFIED	jpeg	8
820	655c7330-569a-46f4-bc39-eeb1d3e93ff3	UNCLASSIFIED	jpeg	6
821	b45227b6-b423-4cba-a2f6-6f9813c40f4e	UNCLASSIFIED	png	8
822	148d0b85-6147-47aa-b29d-9612b85828c9	UNCLASSIFIED	png	6
823	a626c164-4eff-424a-8b01-5e70656005f7	UNCLASSIFIED	png	8
824	6b6a3eec-b82e-4c7b-b3c9-665ea06806ee	UNCLASSIFIED	png	6
825	c66a239a-6217-43de-b601-66490901cb82	UNCLASSIFIED	jpeg	8
826	d6c7a3e7-b752-4c84-a30a-76c311e18853	UNCLASSIFIED	jpeg	6
827	1870731d-3e1a-42c1-98aa-f71817f48a8f	UNCLASSIFIED	jpeg	8
828	50548b8a-6e81-4e7e-861e-faf90bcd1b04	UNCLASSIFIED	jpeg	6
829	d7886f13-ae96-4f14-b50f-20d93826912c	UNCLASSIFIED	png	8
830	bb30d1df-d69b-4daf-ab50-0f5a53d72025	UNCLASSIFIED	png	6
831	9cdcda21-1621-45b7-bbd9-1ee41cf312b2	UNCLASSIFIED	jpeg	8
832	b741792c-b1bf-4ac7-8bbf-93efdbd95e19	UNCLASSIFIED	jpeg	6
833	fade751a-39fd-4281-a09e-f55fb70cbcba	UNCLASSIFIED	png	8
834	9a163518-5329-4ecc-adff-84401885a8e8	UNCLASSIFIED	png	6
835	9b85cd78-0b0f-4f9f-bd31-c87ed4255249	UNCLASSIFIED	jpeg	8
836	599e558c-be5c-4f5a-a864-cf63f622b2f4	UNCLASSIFIED	jpeg	6
837	21a4de55-5963-4067-9533-0d545a46b96e	UNCLASSIFIED	jpeg	8
838	9feb6c46-808d-47ef-83c6-8171c1ee2cd2	UNCLASSIFIED	jpeg	6
839	e335394c-bac3-4e03-a50e-6bc7edc393ed	UNCLASSIFIED	jpeg	8
840	0c734249-30d9-49a6-a47d-61704b81adf0	UNCLASSIFIED	jpeg	6
841	a929ce3d-04d2-45c3-a6ab-edf1f37dd096	UNCLASSIFIED	jpeg	8
842	dc387d31-0b16-4ecb-b1d9-f567245714f4	UNCLASSIFIED	jpeg	6
843	c7d3c5d7-4f91-4f0f-b0e1-8daf7ac0df09	UNCLASSIFIED	jpeg	8
844	a756d75c-d8fd-4109-a123-66cb0276345d	UNCLASSIFIED	jpeg	6
845	bb197b19-2d39-49f6-b176-204f3387e97d	UNCLASSIFIED	jpeg	8
846	d7daa521-fd2c-464d-958d-0758d9966b5a	UNCLASSIFIED	jpeg	6
847	294226fc-98cd-4b1c-8b67-588e1a9daf5e	UNCLASSIFIED	jpeg	8
848	d754c700-db15-42a6-9f99-5d818058642b	UNCLASSIFIED	jpeg	6
849	11733514-ee1a-4e34-b9ad-40d06e619e23	UNCLASSIFIED	jpeg	8
850	3c23b55b-dbd3-491d-ae36-89ab9738286f	UNCLASSIFIED	jpeg	6
851	03f773b3-7eae-4956-b746-b5e57ac911e3	UNCLASSIFIED	jpeg	8
852	8b09bb15-3450-4c04-8489-750631b4284c	UNCLASSIFIED	jpeg	6
853	67744ae0-def3-43a5-a273-b8d47c3fa49a	UNCLASSIFIED	png	8
854	de2916b8-d82c-4cbf-9fa0-83864a7008cd	UNCLASSIFIED	png	6
855	3564bf0d-a4e9-48b0-bab9-82345f386dbe	UNCLASSIFIED	png	8
856	108c0305-8690-486f-948b-224f79d30e70	UNCLASSIFIED	png	6
857	48f7de35-7c5f-4b63-ac50-eef2f4e3a1aa	UNCLASSIFIED	jpeg	8
858	afc93990-c7fd-4343-9f2a-8dc83afc5395	UNCLASSIFIED	jpeg	6
859	84b6d1dc-f705-4c8b-9bf3-611c6c7136a7	UNCLASSIFIED	jpeg	8
860	c511544f-678c-450c-9a10-8b865e365246	UNCLASSIFIED	jpeg	6
861	8e936f61-6f3d-4d8e-bc4e-bd6b39504430	UNCLASSIFIED	jpeg	8
862	b24138d3-874c-4fdf-9f21-e56250a9622a	UNCLASSIFIED	jpeg	6
863	bfd48050-0339-4f54-b176-3e7a80004f50	UNCLASSIFIED	png	8
864	12569578-a1c7-42ad-8dc0-020149a86f19	UNCLASSIFIED	png	6
865	9182f312-c7bf-4bca-bbad-a54dbd59caad	UNCLASSIFIED	png	8
866	9c8f49ca-c12e-462c-9e9c-2b8b4d53d42e	UNCLASSIFIED	png	6
867	4f6c6e72-b97c-4214-b602-8612d6af428f	UNCLASSIFIED	jpeg	8
868	6e5cceb0-664e-4440-b7c9-fe61628549ac	UNCLASSIFIED	jpeg	6
869	f95d53e0-4d66-4385-9938-44d1ba88b936	UNCLASSIFIED	png	8
870	b848b12a-fc74-483e-8ced-6cd3ad7256f3	UNCLASSIFIED	png	6
871	cd7e06e9-04b1-4f3a-873e-c90e70b58b13	UNCLASSIFIED	jpeg	8
872	c23ff807-4b53-4947-91af-bd3a32d96c2e	UNCLASSIFIED	jpeg	6
873	806dfb1f-d601-4479-8c89-a769de222973	UNCLASSIFIED	jpeg	8
874	106f1eba-8d4b-48af-a894-3adec249e9d0	UNCLASSIFIED	jpeg	6
875	f0f84e9d-ac54-4ae0-a271-9cf34b371017	UNCLASSIFIED	jpeg	8
876	53b4475e-22f9-427c-b807-61908c085e5c	UNCLASSIFIED	jpeg	6
877	bbc49152-aabf-4805-9743-5ee8df707a94	UNCLASSIFIED	jpeg	8
878	6bae40f4-d8fd-4062-8ec9-6190c45faed1	UNCLASSIFIED	jpeg	6
879	10051aa5-762e-46fe-a123-33352e8f4e53	UNCLASSIFIED	jpeg	8
880	7342106f-cbb8-4703-b20e-429c667a986d	UNCLASSIFIED	jpeg	6
881	eda678dc-5a4f-4e1c-a630-1d188cb936a3	UNCLASSIFIED	png	8
882	6bdcea14-0b37-4de4-8037-70171d94b597	UNCLASSIFIED	png	6
883	5349ecd6-9778-4f1f-ad74-bd752c1658c0	UNCLASSIFIED	jpeg	8
884	0f3110bd-078a-4db2-a956-cd644f63024e	UNCLASSIFIED	jpeg	6
885	3b44aab0-ee07-45ee-9607-3069b44225ae	UNCLASSIFIED	jpeg	8
886	866383d1-67f1-49fa-b063-10c793022690	UNCLASSIFIED	jpeg	6
887	7b58528a-fa36-4d12-94f2-facab03282fd	UNCLASSIFIED	jpeg	8
888	e2660053-2b60-4b90-a3af-228247a526da	UNCLASSIFIED	jpeg	6
889	1858260b-c07f-4323-967e-ca8d24796a8b	UNCLASSIFIED	jpeg	8
890	29bca782-6e58-4979-a4a2-2eae7d5be57f	UNCLASSIFIED	jpeg	6
891	81e77212-a398-44e0-89b8-4fa0442622b4	UNCLASSIFIED	jpeg	8
892	27b6c22d-89bf-4e83-8768-f45e831285e0	UNCLASSIFIED	jpeg	6
893	73b354dc-09ed-4155-8222-9347bce2896a	UNCLASSIFIED	jpeg	8
894	b7872f9e-cfb5-4460-80da-5265bf0e076d	UNCLASSIFIED	jpeg	6
895	1e00ff32-449b-47c8-ab33-912746f816d9	UNCLASSIFIED	jpeg	8
896	b950a347-1902-4c0a-bdaf-cd119a38dea0	UNCLASSIFIED	jpeg	6
897	eb3af692-f63b-4602-841e-b13432f32f6b	UNCLASSIFIED	jpeg	8
898	b64cec82-e8a3-42e0-92eb-01e3d61fd478	UNCLASSIFIED	jpeg	6
899	9a2f3e2d-7dd0-40c4-a23e-90cfe0e9050b	UNCLASSIFIED	jpeg	8
900	9dd87a02-3b56-42f0-ba1c-668c85379189	UNCLASSIFIED	jpeg	6
901	b1d4bc40-e3cc-4224-a29d-f4854eaff3d9	UNCLASSIFIED	jpeg	8
902	08ab6fb5-a7dd-4936-bd00-31370b0cf063	UNCLASSIFIED	jpeg	6
903	b5f19ca6-c838-4d65-97da-b92f03194795	UNCLASSIFIED	jpeg	8
904	d2fce222-4b36-473d-a710-299a1ecbf873	UNCLASSIFIED	jpeg	6
905	37deb50d-f296-420d-8b32-0e53f18e1819	UNCLASSIFIED	jpeg	8
906	da0f2006-5b9c-4f61-8ad9-45050777da70	UNCLASSIFIED	jpeg	6
907	0fb21db9-f995-45db-abac-6d724bd53c5b	UNCLASSIFIED	png	8
908	818729cb-65d3-4120-877f-693c519d3ed9	UNCLASSIFIED	png	6
909	7dd0bcc0-172c-4e30-922b-33a3a528e354	UNCLASSIFIED	png	8
910	7aec9ebc-976f-408f-b6b6-fc3dfc13951e	UNCLASSIFIED	jpeg	6
911	e97dbcf4-469b-45b0-a825-197899697061	UNCLASSIFIED	jpeg	8
912	a8f8b468-215c-4da8-b28f-3a6648fc439f	UNCLASSIFIED	jpeg	6
913	9b470988-c2c5-4094-b32b-e8639d7c2ce9	UNCLASSIFIED	jpeg	8
914	0183c88c-3d64-4891-a681-ae88848691e5	UNCLASSIFIED	jpeg	6
915	92fd90d7-91f3-4a00-bca0-d627f2125cd5	UNCLASSIFIED	jpeg	8
916	809f013a-d06e-4fcc-9289-2afdaebcd165	UNCLASSIFIED	jpeg	6
917	2bc05374-59d0-4b8b-b936-75ac9092956b	UNCLASSIFIED	jpeg	8
918	23305819-560c-4472-b874-1ea6f4e0b005	UNCLASSIFIED	jpeg	6
919	5b406193-be07-4665-b60e-7e599f1cbd8a	UNCLASSIFIED	jpeg	8
920	39f73a75-1ede-4bf4-9d6f-0d971ae97648	UNCLASSIFIED	jpeg	6
921	aaad7dad-80bd-48f6-9942-1450652ffe36	UNCLASSIFIED	jpeg	8
922	dc49ee1c-8591-4c29-8644-eb76ab7e4233	UNCLASSIFIED	jpeg	6
923	56d9e8b2-2d4c-4567-93f1-b891a0c34ace	UNCLASSIFIED	png	8
924	784b74c1-2e26-428c-be48-7b257cc3223a	UNCLASSIFIED	png	6
925	169a7db0-3811-4d0a-8a67-113a80385fad	UNCLASSIFIED	jpeg	8
926	856e12d8-dce9-4069-b206-4836cc9d5e73	UNCLASSIFIED	jpeg	6
927	05bfad28-327f-4e4d-8e23-2dd2b4e33c31	UNCLASSIFIED	jpeg	8
928	18a9b6b4-6e68-4cdf-ab14-bcd363dff459	UNCLASSIFIED	jpeg	6
929	341a7c91-a83b-4f18-badc-69c55632b8e4	UNCLASSIFIED	jpeg	8
930	3d221813-def6-4dac-8893-5180c25dd3cc	UNCLASSIFIED	jpeg	6
931	37578984-0de1-45ec-95aa-71745dc27114	UNCLASSIFIED	jpeg	8
932	7fdeaf93-e206-4236-9c99-5020ddb775ea	UNCLASSIFIED	jpeg	6
933	110e6fa6-3114-41fd-9b26-c4558ce15232	UNCLASSIFIED	jpeg	8
934	da7c5d99-37c2-4b2a-9755-1f9d497d08a9	UNCLASSIFIED	jpeg	6
935	7de937a7-8f99-46ab-b190-c694d329292d	UNCLASSIFIED	jpeg	8
936	0c9fd9e3-0bb8-432e-b16f-d417b896c29b	UNCLASSIFIED	jpeg	6
937	5898cbfc-58fc-42c8-b2b1-891fbf657aac	UNCLASSIFIED	jpeg	8
938	307e24f1-c62d-440d-9c0a-d45d85602ea9	UNCLASSIFIED	jpeg	6
939	a6ac021d-89b7-403b-aaa1-af467c5ed59f	UNCLASSIFIED	jpeg	8
940	8e281379-188e-443c-8703-ba5bdfcb783f	UNCLASSIFIED	jpeg	6
941	cb7f9a62-ff18-4803-9f13-3fdb86e2ef65	UNCLASSIFIED	jpeg	8
942	ae6792de-3328-471d-80ef-4b1edf9f7dd3	UNCLASSIFIED	jpeg	6
943	ceb675ec-35d6-4ac1-ba99-71c0568a74c0	UNCLASSIFIED	jpeg	8
944	504f59be-99d5-4ae9-8159-6b007e9bd440	UNCLASSIFIED	jpeg	6
945	00581966-6c73-4b6e-a2c9-ee0a696d0431	UNCLASSIFIED	jpeg	8
946	e9e1db01-58db-478a-9b48-1a63ee5d92d3	UNCLASSIFIED	jpeg	6
947	2783865e-176e-41ed-a6fb-9f196ab35059	UNCLASSIFIED	jpeg	8
948	9f702ca7-c316-4672-a422-76521b02f188	UNCLASSIFIED	jpeg	6
949	70df1514-ba92-4e98-954f-6d6122867c81	UNCLASSIFIED	jpeg	8
950	ee90c315-5762-48a9-9998-717da1f86534	UNCLASSIFIED	jpeg	6
951	6d89e49f-5afe-433d-a943-5952b1858407	UNCLASSIFIED	jpeg	8
952	06cf74c0-3def-4e40-8028-b0ebcdfcbce7	UNCLASSIFIED//FOR OFFICIAL USE ONLY	jpeg	6
953	effbf196-8f1e-48d6-a3dd-225a7cea1515	UNCLASSIFIED	png	8
954	e7b9e156-9d50-4eea-be64-20b0c3c4040a	UNCLASSIFIED	png	6
955	c8b9539a-a670-4691-b792-c00527be7e66	UNCLASSIFIED	png	8
956	b5401046-4f27-4d70-bd5a-89975aa33d20	UNCLASSIFIED	png	6
957	7b434ffd-9e7e-47aa-9ae2-13deb7020f06	UNCLASSIFIED	png	8
958	3f2cde8e-4ddb-4943-b3b6-fe6e443c2bd5	UNCLASSIFIED	png	6
959	bddc1745-d551-4cee-a5ef-f59b889f486a	UNCLASSIFIED	png	8
960	0fb41209-3e9a-4547-806a-1b76eedbbede	UNCLASSIFIED	png	6
961	74bbfaf0-01ab-44df-8930-5a6630ec4322	UNCLASSIFIED	jpeg	8
962	562c1472-5cb7-4777-8e2b-c3d6b63453fe	UNCLASSIFIED	jpeg	6
963	a0d42a4e-03fd-436f-a4ab-cf803c6f54f8	UNCLASSIFIED	jpeg	8
964	0108a592-1a47-4ab6-80d0-48158f8370f8	UNCLASSIFIED	jpeg	6
965	57dc70db-1f98-478d-afc2-a2118bae95e7	UNCLASSIFIED	jpeg	8
966	3c9d3034-d8ba-4445-a208-beca1e87ffb2	UNCLASSIFIED	jpeg	6
967	d3166065-284f-4b08-9dee-9d16e5f3d880	UNCLASSIFIED	jpeg	8
968	a3bc69b2-212a-4665-8888-0bcd590cca72	UNCLASSIFIED	jpeg	6
969	70bce339-1ff6-460b-b163-6a8c32f26574	UNCLASSIFIED	jpeg	8
970	00507f43-502e-41f2-8493-5cd493b1b958	UNCLASSIFIED	jpeg	6
971	42004977-2c3b-47f1-a0cb-de4598e13bbf	UNCLASSIFIED	jpeg	8
972	fbfe8fc4-a9f1-4acb-9aa0-1bbd39db8485	UNCLASSIFIED	jpeg	6
973	67d0cd5d-de0b-4b02-b470-9ccadbfbbd38	UNCLASSIFIED	jpeg	8
974	308bd397-3220-46a5-9162-2a6ae31e7bdd	UNCLASSIFIED	jpeg	6
975	103a9721-dab0-443f-af0c-50cb2af6413e	UNCLASSIFIED	jpeg	8
976	f4681d3a-9590-495d-8d44-502a6d70fa66	UNCLASSIFIED	jpeg	6
977	dc14c286-9677-4c35-a49b-1fb890a20536	UNCLASSIFIED	jpeg	8
978	06747dad-43aa-4c6a-929c-ba767242e51b	UNCLASSIFIED	jpeg	6
979	d1e0db0b-f47d-4771-9abe-5946ce7d2cae	UNCLASSIFIED	jpeg	8
980	03e0127e-17e6-4951-aaac-b5fea40e3baa	UNCLASSIFIED	jpeg	6
981	728f493d-b32a-4755-85f5-ddaca55f1b7f	UNCLASSIFIED	png	8
982	ac31b9f4-dd80-49ce-80b1-593ae041617f	UNCLASSIFIED	png	6
983	ca43c934-8b21-4faf-9fda-11bbf0dcac6e	UNCLASSIFIED	jpeg	8
984	ed863440-efc7-4945-9440-b5a409011836	UNCLASSIFIED	jpeg	6
985	4a11a4d9-1292-4cb8-8718-64c971119d41	UNCLASSIFIED	jpeg	8
986	fa427116-78ca-43f7-bebd-0803893a4269	UNCLASSIFIED	jpeg	6
987	33336432-95e5-41d7-8799-d7703e27244c	UNCLASSIFIED	png	8
988	5572f396-645f-43c7-95e3-b9a80261011c	UNCLASSIFIED	png	6
989	ca29990a-8a1a-4a54-be2f-d7253d1844dd	UNCLASSIFIED	jpeg	8
990	21bf28e0-836c-44f2-b987-3cd5ca6a713f	UNCLASSIFIED	jpeg	6
991	2f94120d-9ad7-47ba-b412-b3f8b5bff4b2	UNCLASSIFIED	jpeg	8
992	3cc5e162-a365-41f0-b4f2-45fb0b4a0467	UNCLASSIFIED	jpeg	6
993	b58009df-c14d-452c-af4a-5d4df32b9e94	UNCLASSIFIED	jpeg	8
994	02141dfb-0688-49cc-a60e-0e88875dcb61	UNCLASSIFIED	jpeg	6
995	e68d5ed5-a5d2-4ba5-ac7c-20f59ef33f4a	UNCLASSIFIED	jpeg	8
996	3372afcf-1707-497a-8182-5e5318d1abc6	UNCLASSIFIED	jpeg	6
997	45533eeb-63b2-454f-b4ed-e50bbeb5a32a	UNCLASSIFIED	jpeg	8
998	91e91b2b-af87-45f1-850c-6fd864f2ee37	UNCLASSIFIED	jpeg	6
999	1cf2b069-40d8-49a6-95c0-20473d7514f7	UNCLASSIFIED	jpeg	8
1000	3e06075e-5e0b-4e49-ab03-b188717d797d	UNCLASSIFIED	jpeg	6
1001	3cf6570b-de83-4557-8107-64da4494c81a	UNCLASSIFIED	png	8
1002	78ffdc41-7058-46c3-9f99-c87f4151aeb4	UNCLASSIFIED	png	6
1003	0633f399-ba27-40fc-9bb1-30196b0efa5b	UNCLASSIFIED	png	8
1004	9fadbc07-c792-401e-b74c-3e66532f4a3f	UNCLASSIFIED	png	6
1005	556e69e9-0362-45dc-94bf-024d5ae23e00	UNCLASSIFIED	png	8
1006	b26081aa-8e12-4e89-a417-a1a5c646037a	UNCLASSIFIED	png	6
1007	c0c3acd3-1c58-42e4-9c9f-34a3c8b695ca	UNCLASSIFIED	png	8
1008	44f350ec-b413-44fa-a04a-b2cf09f667cc	UNCLASSIFIED	png	6
1009	d5d06fb6-d1bd-49bd-a2a6-0171692bb718	UNCLASSIFIED	jpeg	8
1010	e5f99688-25b7-47c6-b9ac-457dc5c9f9e6	UNCLASSIFIED	jpeg	6
1011	b0ed15b9-52f4-4ee3-a0e8-f727cc407717	UNCLASSIFIED	jpeg	8
1012	3dcbb530-5ed1-4b1d-ab5c-29a88e5272ce	UNCLASSIFIED	jpeg	6
1013	d1ed5fc7-cde3-418b-b70b-ac0bdb063996	UNCLASSIFIED	png	8
1014	0fb2b3c5-f4d3-4392-b7c5-e796d75353f3	UNCLASSIFIED	png	6
1015	056b72e9-c3fb-490c-9e2f-fa3efee2f44f	UNCLASSIFIED	png	8
1016	bd70e506-0650-4356-b1bd-a62700401f29	UNCLASSIFIED	png	6
1017	230a7e43-7896-4b85-a4f1-c0fddd7679db	UNCLASSIFIED	png	8
1018	1f4c692a-16da-4741-9e34-03256a7750de	UNCLASSIFIED	png	6
1019	7a8064d7-c5f0-470b-99f6-0c89cd86a9bd	UNCLASSIFIED	png	8
1020	db7af655-9d66-4c58-bc93-9d849e6e02ed	UNCLASSIFIED	png	6
1021	eafb29e3-dcfa-41cc-87a9-8c764a648729	UNCLASSIFIED	jpeg	8
1022	4ce7adf2-72d8-4af9-a041-0b85329e2086	UNCLASSIFIED	jpeg	6
1023	658dc3ea-e7fa-4415-ac7b-be0055debde4	UNCLASSIFIED	jpeg	8
1024	f41773a5-45f3-4b33-ab82-d925a1561d4a	UNCLASSIFIED	jpeg	6
1025	ccc98db4-c241-45ed-9c04-e2f0868b73b3	UNCLASSIFIED	jpeg	8
1026	92ede56f-ffc2-4d51-ac5d-1eb9f6936826	UNCLASSIFIED	jpeg	6
1027	dbccc66a-e7a3-4425-8f64-e56976b01da1	UNCLASSIFIED	jpeg	8
1028	19095259-5880-47b6-a4e0-9041bd41109d	UNCLASSIFIED	jpeg	6
1029	801723c9-4018-468f-890b-9ec19b7224d7	UNCLASSIFIED	png	8
1030	db8f5523-395a-46ba-ab24-ffdea3c44ab8	UNCLASSIFIED	png	6
1031	1304720a-578f-47e2-8035-ca27aac7c340	UNCLASSIFIED	png	8
1032	21d6c65e-d27c-4354-a6cd-5c545def406a	UNCLASSIFIED	png	6
1033	3c8cbefc-61ba-41fd-bf1a-b8fee0e55f6f	UNCLASSIFIED	jpeg	8
1034	24a883ca-5610-49fa-b1e8-ff5fbcce9961	UNCLASSIFIED	jpeg	6
1035	74d82724-3e6a-44fd-950a-f6bcfdd58a9c	UNCLASSIFIED	jpeg	8
1036	5b393531-02f0-4508-9b89-8b470a01c587	UNCLASSIFIED	jpeg	6
1037	636e667f-b224-42a9-b2b9-d57d7e687663	UNCLASSIFIED	jpeg	8
1038	f47b0657-fac9-4c6d-bc13-30587e8ec316	UNCLASSIFIED	jpeg	6
1039	20af1e85-16c2-4f87-ada7-6a2c7b7ae645	UNCLASSIFIED	jpeg	8
1040	5e2040a1-63aa-4534-888e-081ec5beace4	UNCLASSIFIED	jpeg	6
1041	aa7a348a-bf4d-4657-a00b-afd73970c6f9	UNCLASSIFIED	jpeg	8
1042	8a74e123-4d91-41a8-95f4-abdd147d201e	UNCLASSIFIED	jpeg	6
1043	63b70abb-ba71-4bbf-9f0d-704cae2ebaa5	UNCLASSIFIED	jpeg	8
1044	cb1dfb50-c1ad-477a-a343-6e72b61ef333	UNCLASSIFIED	jpeg	6
1045	1105eda0-63d5-4fb1-8801-4ee73ab9d449	UNCLASSIFIED	jpeg	8
1046	4a13e25c-d457-4714-ae1c-ad0ad9d6b5f7	UNCLASSIFIED	jpeg	6
1047	b72ec063-4c16-46a8-9b14-57ec195a111c	UNCLASSIFIED	png	8
1048	b5c532b7-3e24-4cf0-8a83-dd1fba6a9006	UNCLASSIFIED	png	6
1049	aaf9e53b-982e-4dda-bab1-af4c2f056b34	UNCLASSIFIED	jpeg	8
1050	3f266067-ed86-4aff-b9c4-3c5fb33c7a47	UNCLASSIFIED	jpeg	6
1051	1d6f29f6-85da-4b52-8021-9fa1ea60897e	UNCLASSIFIED	png	8
1052	ac6f6384-624b-4acd-ad81-6c2db469c5a7	UNCLASSIFIED	png	6
1053	d5feca80-0d57-45aa-85b7-8f3fd500f613	UNCLASSIFIED	jpeg	8
1054	1fcd5510-2c6b-4cae-a664-ea934cec7b4a	UNCLASSIFIED	jpeg	6
1055	efcf7612-acbc-4b9f-8819-5d12f334a118	UNCLASSIFIED	jpeg	8
1056	2f579fe5-a000-4171-ab67-f3572c652342	UNCLASSIFIED	jpeg	6
1057	63d2df06-fd58-4424-86a7-a9ada60e774d	UNCLASSIFIED//FOR OFFICIAL USE ONLY	jpeg	8
1058	8cb50445-18ae-4082-a31e-eed8a594c5a9	UNCLASSIFIED//FOR OFFICIAL USE ONLY	jpeg	6
1059	a6c087b7-fda8-470a-a9f7-377fcdc8366a	UNCLASSIFIED	jpeg	8
1060	576decfd-e7cb-4334-9b09-aebd4539dd7e	UNCLASSIFIED	jpeg	6
1061	31a96d8e-6606-4b3e-9290-7b5fa1d25950	UNCLASSIFIED	jpeg	8
1062	2ca9af0a-da56-4f90-9cd5-0272c05dab7f	UNCLASSIFIED	jpeg	6
1063	351422ae-6b8d-4095-9ad6-d7f930564574	UNCLASSIFIED	jpeg	8
1064	7225bf2a-c59f-4d9d-a740-a626f23161f2	UNCLASSIFIED	jpeg	6
1065	8c098829-91cd-4e57-9d4d-066ca8071286	UNCLASSIFIED	jpeg	8
1066	fc6933df-9a48-469c-9119-d4561871c960	UNCLASSIFIED	jpeg	6
1067	dbc63a34-4647-4d95-bc67-f7b418fc6f8c	UNCLASSIFIED	jpeg	8
1068	9e6dd8bc-4357-4b5b-9c8b-0028d9dcb0ef	UNCLASSIFIED	jpeg	6
1069	6c290270-eaf6-4e44-9d2b-b92e3a33371d	UNCLASSIFIED	jpeg	8
1070	b4e619f7-03c3-4ed3-ae8d-d78d248cb58a	UNCLASSIFIED	jpeg	6
1071	bf5b9f54-8d30-46d4-9a95-8e96146de029	UNCLASSIFIED	jpeg	8
1072	c6104aa9-ea5f-4ba9-a162-121b9f0a5119	UNCLASSIFIED	jpeg	6
1073	1b9498f0-3956-49a3-900e-fefa5de3a6ea	UNCLASSIFIED	jpeg	8
1074	6716d6cf-c97e-46ae-9ee3-9b01f3ee0ebe	UNCLASSIFIED	jpeg	6
1075	9d92bab2-99a8-4687-ad6b-e486ac6519f2	UNCLASSIFIED	jpeg	8
1076	d685a397-8b1e-4e85-8f0c-e0370a17b06f	UNCLASSIFIED	jpeg	6
1077	baa56816-29f9-41e0-b4f5-f2952db4f63c	UNCLASSIFIED	png	8
1078	fd2f2bf7-39b1-458a-80da-c6e0a6d82b36	UNCLASSIFIED	png	6
1079	b0fa2f27-2823-4ca1-a6d3-7ce3a389c205	UNCLASSIFIED	png	8
1080	33998f1b-60d9-40e0-9f4e-cec31a829634	UNCLASSIFIED	png	6
1081	7a4d6268-0a29-442a-b5ed-cf9d540eb44d	UNCLASSIFIED	png	8
1082	8d3989da-b595-43c9-b6c6-7a7b19dec32c	UNCLASSIFIED	png	6
1083	9b5558c6-d576-4aba-a5e5-7e5db11422ba	UNCLASSIFIED	png	8
1084	b66e415d-9758-4e9a-805d-ded491e58b08	UNCLASSIFIED	png	6
1085	d44d2958-ea07-4432-b982-b09cd74fe0c1	UNCLASSIFIED	jpeg	8
1086	7e69d1dc-3a0b-4c7e-b7a9-3e9848c65e9b	UNCLASSIFIED	jpeg	6
1087	476a2a08-0a52-4e83-941b-918d8952a6c5	UNCLASSIFIED	jpeg	8
1088	467fe9a9-c30a-4a1c-bc44-b923f2784000	UNCLASSIFIED	jpeg	6
1089	335e62e2-a2ca-432a-b07e-071cad7a268b	UNCLASSIFIED	jpeg	8
1090	20f161bf-d513-4898-bef5-380c7a3d31e9	UNCLASSIFIED	jpeg	6
1091	a4f75e83-d8db-4163-9db3-f3b62b136057	UNCLASSIFIED	jpeg	8
1092	6eb5a093-ab3e-42d1-83e7-139b5e9d5b34	UNCLASSIFIED	jpeg	6
1093	bf079a99-7866-46fc-a5cf-3e404f541d66	UNCLASSIFIED	gif	8
1094	6bf7e16b-984b-4d46-ac35-7a43bd83f22f	UNCLASSIFIED	gif	6
1095	ae7c9130-15ec-4ca2-95e5-1ef1239b9210	UNCLASSIFIED	jpeg	8
1096	69ffa867-ec03-4b0f-b7df-70c9cd4bf568	UNCLASSIFIED	jpeg	6
1097	fffff851-0145-4941-a503-c01a068a9487	UNCLASSIFIED	jpeg	8
1098	3b92f728-64c2-4743-ae93-608f1664d43f	UNCLASSIFIED	jpeg	6
1099	62221877-74c9-427c-9661-d343f1f3d776	UNCLASSIFIED	png	8
1100	189bf9eb-dcbb-4f22-8480-d773fc3762b9	UNCLASSIFIED	png	6
1101	0558d614-f5d0-45fe-94b8-8c5e8c62798f	UNCLASSIFIED	png	8
1102	d297ae38-267c-4af2-8418-2e2019955b53	UNCLASSIFIED	png	6
1103	59de639b-7335-4980-ae0d-6a9f94134f83	UNCLASSIFIED	png	8
1104	a1c87725-d908-4c49-b3fc-7bc20fa74ce3	UNCLASSIFIED	png	6
1105	32c3287f-30f4-4483-bcd0-ab716ad92473	UNCLASSIFIED	jpeg	8
1106	9eb4330f-6d3f-456c-abdd-feb720ff4613	UNCLASSIFIED	jpeg	6
1107	3ba27c2f-28ff-4c7c-8e17-253c3d1e49e2	UNCLASSIFIED	jpeg	8
1108	81f157f0-a525-48af-bd2d-bf548077f728	UNCLASSIFIED	jpeg	6
1109	b2f6f33b-1ae2-41b0-af46-1d8b94a81ed6	UNCLASSIFIED	jpeg	8
1110	ac50990a-9c40-4968-9d6f-0c2bc2f1bd76	UNCLASSIFIED	jpeg	6
1111	4606f598-3fe5-44d6-94fc-85be31991175	UNCLASSIFIED	png	8
1112	fe17422a-3c48-4af0-af67-a64df02aac8d	UNCLASSIFIED	png	6
1113	a8931259-cbc8-40f6-a608-0d5f2c42aa1b	UNCLASSIFIED	png	8
1114	635246a9-6fe6-470a-afdf-6278b0fa2234	UNCLASSIFIED	png	6
1115	610013c5-2756-401a-931f-4b8d062b4647	UNCLASSIFIED	jpeg	8
1116	c106ff1f-4f49-46db-b0d9-6f0eac59ef31	UNCLASSIFIED	jpeg	6
1117	b1aa62ed-de91-40e4-bce2-ccc4ef3192ae	UNCLASSIFIED	png	8
1118	9a71cc19-cac0-4a76-ac57-62d83917a5b4	UNCLASSIFIED	png	6
1119	3dd291b0-0e8c-42a1-a32b-aaf2667a405a	UNCLASSIFIED	jpeg	8
1120	4805e6be-fe4d-4539-9f7d-5ab5ec6bfd0e	UNCLASSIFIED	jpeg	6
1121	678999a8-4079-4dcd-90e9-252e0e161979	UNCLASSIFIED	jpeg	8
1122	402a596c-b089-4815-be96-5abfc655e480	UNCLASSIFIED	jpeg	6
1123	d90ebc49-1902-4e61-8d95-336ff3e15879	UNCLASSIFIED	jpeg	8
1124	383b1608-d297-4841-a6be-4b7e89718495	UNCLASSIFIED	jpeg	6
1125	735dc39c-a744-4f17-a4fb-cb145ab93e67	UNCLASSIFIED	jpeg	8
1126	a55d5935-fa62-4428-99ea-b5e68738c0b9	UNCLASSIFIED	jpeg	6
1127	7a45ea5d-40de-424e-ac5e-447eac67317d	UNCLASSIFIED	jpeg	8
1128	a580b1d9-b670-4e71-ba12-a6daee9b204e	UNCLASSIFIED	jpeg	6
1129	1db5d2a1-f918-46d8-8811-d39aff34540b	UNCLASSIFIED	png	8
1130	7a03b132-5ffc-473f-b8cc-4fb98b7b2f51	UNCLASSIFIED	png	6
1131	ab901adc-b434-46d4-a6d5-8ea425493052	UNCLASSIFIED	jpeg	8
1132	4b5658e8-570d-49b3-95fc-946014f90a74	UNCLASSIFIED	jpeg	6
1133	c099896e-2008-49b0-bfa6-3df16915b84f	UNCLASSIFIED	jpeg	8
1134	71c5411b-98ae-4e7e-a5b6-adb93a5a89ab	UNCLASSIFIED	jpeg	6
1135	2ffd74c1-dc5c-462e-9f99-7cb391b5ec87	UNCLASSIFIED	jpeg	8
1136	1a5920f3-af02-4c1a-9e6d-eec04a56057d	UNCLASSIFIED	jpeg	6
1137	bbb3118a-d113-4b05-9821-7a93094a5ce1	UNCLASSIFIED	jpeg	8
1138	bb887e56-f777-4277-97be-53ec52c3fdfd	UNCLASSIFIED	jpeg	6
1139	76068a8e-7a23-40dd-b9c1-e4bd808824e4	UNCLASSIFIED	jpeg	8
1140	66d7d6d4-c41e-4f04-9486-43fe79d3adc3	UNCLASSIFIED	jpeg	6
1141	f0558450-8cbb-4389-9e17-97f6ed143786	UNCLASSIFIED	jpeg	8
1142	1381d041-a93f-4518-a73a-c15e0b5ac029	UNCLASSIFIED	jpeg	6
1143	965a90ea-78d2-4797-ae92-d3ff9fbcc0c5	UNCLASSIFIED	jpeg	8
1144	a3885be0-1fe0-4f33-bb10-852ba6ffcd96	UNCLASSIFIED	jpeg	6
1145	bc07bbd9-1a5c-45f6-9910-4a37a85f3feb	UNCLASSIFIED	png	8
1146	f1a82725-15e5-4009-9f60-8ef113bad9e5	UNCLASSIFIED	png	6
1147	dea9627d-91fd-437f-a371-eb4e4e055d62	UNCLASSIFIED	jpeg	8
1148	475f08a8-9277-42f3-9228-cef0d0b6b639	UNCLASSIFIED	jpeg	6
1149	d627a918-e765-4c2d-bd97-710184f6f44a	UNCLASSIFIED	jpeg	8
1150	49a743f8-5c52-47ca-b87a-5fa4db241243	UNCLASSIFIED	jpeg	6
1151	e7401bcf-c523-4844-a307-5de9ab394c8e	UNCLASSIFIED	jpeg	8
1152	56beca1a-02c0-4e4e-b01f-00180e35678f	UNCLASSIFIED	jpeg	6
1153	02a62306-16f3-4f0d-aff2-e1013153700a	UNCLASSIFIED	jpeg	8
1154	cc1caa85-9f1a-447f-b29d-3d910c5b17ba	UNCLASSIFIED	jpeg	6
1155	f06e81e2-e814-4419-a739-a060e873600e	UNCLASSIFIED	jpeg	8
1156	76919269-741b-46d8-ad9c-fc9c9b64f02e	UNCLASSIFIED	jpeg	6
1157	7069109c-ad90-4577-a8e1-f807312c6c20	UNCLASSIFIED	jpeg	8
1158	dc60e25f-1dbd-4e02-8447-0ce4dfa63362	UNCLASSIFIED	jpeg	6
1159	3b4abfaa-9829-4bb0-85e8-9a6a9bfb5977	UNCLASSIFIED	jpeg	8
1160	02b920e8-08ae-4532-b745-c2ee4a7b13d8	UNCLASSIFIED	jpeg	6
1161	e4cb7f4b-a960-4dca-b5bb-d18c883a17ef	UNCLASSIFIED	jpeg	8
1162	ff21ad03-e951-4199-90e1-63a0e8d09a7c	UNCLASSIFIED	jpeg	6
1163	b5e51687-a0be-4ffd-9fcf-3ca7069cd032	UNCLASSIFIED	jpeg	8
1164	1f5adfa5-6885-4397-8872-42ad85cbf124	UNCLASSIFIED	jpeg	6
1165	f54166d0-df73-4f75-8201-979967a08e24	UNCLASSIFIED	jpeg	8
1166	da97c705-b41f-43aa-a36d-74772016b2c1	UNCLASSIFIED	png	6
1167	287ac02f-fa4d-4144-ab4c-650c743ef2a8	UNCLASSIFIED	jpeg	8
1168	75925c81-8c5b-40f2-bbd2-bd499ccc8dfd	UNCLASSIFIED	jpeg	6
1169	805295bd-378b-4e1a-bafb-74f393aa99b7	UNCLASSIFIED	jpeg	8
1170	b25805f8-4465-474d-9904-4042e88d8563	UNCLASSIFIED	jpeg	6
1171	e2421c25-d28e-47da-8cfd-d613de522cb7	UNCLASSIFIED	jpeg	8
1172	166090be-6a35-439e-acd4-3dff4626fdd1	UNCLASSIFIED	jpeg	6
1173	a5fbaf78-c805-4005-bf43-5e6131f99b68	UNCLASSIFIED	jpeg	8
1174	e7e60d40-de6d-445b-8ed6-50986cebc62c	UNCLASSIFIED	jpeg	6
1175	50a4921d-c205-4fc8-b6dc-6cff63fd46e3	UNCLASSIFIED	png	8
1176	6e76dc00-6134-4770-81bb-e446015b885f	UNCLASSIFIED	png	6
1177	2ccd5d0c-1ad8-4dd5-b742-c809a84fa21a	UNCLASSIFIED	jpeg	8
1178	12894246-6898-4ddb-a7cc-cd0b8e36faac	UNCLASSIFIED//FOR OFFICIAL USE ONLY	jpeg	6
1179	9ff68cf4-720c-499c-8f9c-f1a9a7916326	UNCLASSIFIED	jpeg	8
1180	191d1205-5917-473b-9fd5-27f8b6ff90ae	UNCLASSIFIED	jpeg	6
1181	bb70b2e5-f8b2-43a4-897c-37ebef57589f	UNCLASSIFIED//FOR OFFICIAL USE ONLY	jpeg	8
1182	f9acf0ef-dd46-4d0b-b0c1-8a0bc3e4f80a	UNCLASSIFIED//FOR OFFICIAL USE ONLY	jpeg	6
1183	3dc6135a-14ed-48ec-b17b-b7febb5d997e	UNCLASSIFIED	jpeg	8
1184	663c04b0-1a38-4892-8840-65b2af9d18df	UNCLASSIFIED	jpeg	6
1185	8d4c9d65-ec71-4ade-8048-adef2a4e937e	UNCLASSIFIED	jpeg	8
1186	36bca289-7b17-440b-a6ab-64fa38eb2f1e	UNCLASSIFIED	jpeg	6
1187	a2c29e22-8215-4519-95a6-fc09f4096c5f	UNCLASSIFIED//FOR OFFICIAL USE ONLY	jpeg	8
1188	14176528-a978-4087-9c08-352a53705726	UNCLASSIFIED//FOR OFFICIAL USE ONLY	jpeg	6
1189	e23cd878-6cf3-4072-8762-a82525e81aed	UNCLASSIFIED	jpeg	8
1190	75fe4d1b-efc1-4586-8af0-8c23cf98224a	UNCLASSIFIED	jpeg	6
1191	ba9a1523-e045-4814-a2db-f093d69b7835	UNCLASSIFIED	jpeg	8
1192	4675eabb-1914-447a-b81c-354da6340600	UNCLASSIFIED	jpeg	6
1193	ce8a6d95-f7eb-4bfc-b647-27d1b2f44295	UNCLASSIFIED	jpeg	8
1194	55b54396-13d0-4fe1-8f44-56f0bceedbd3	UNCLASSIFIED	jpeg	6
1195	d4c24772-90fe-4f67-8d26-9b43773f7a23	UNCLASSIFIED	jpeg	8
1196	0add6f01-6064-4301-a47e-c1b95525b23f	UNCLASSIFIED	jpeg	6
1197	67842ad7-ef4c-4325-96d7-53506197c0f9	UNCLASSIFIED	jpeg	8
1198	bc7c99a4-6251-446b-8db4-c3ea8a24a8de	UNCLASSIFIED	jpeg	6
1199	6bc599ef-8987-4255-9072-711e7d3f670d	UNCLASSIFIED	jpeg	8
1200	e6eff33a-2a44-4006-91a4-3e08e31c7809	UNCLASSIFIED	jpeg	6
1201	019fdb1b-f328-40a6-8b7a-32423e1ba26a	UNCLASSIFIED	jpeg	8
1202	831c3161-a54c-479e-906e-ed9c6c184d48	UNCLASSIFIED	jpeg	6
1203	24540958-8dea-405b-aae9-0c3a944c83c2	UNCLASSIFIED	png	8
1204	aba9452f-4a3c-4354-b9c3-5300a0adfc0e	UNCLASSIFIED	png	6
1205	60ab78ae-94cb-4e1f-ab30-c9f5946f3b6d	UNCLASSIFIED	png	8
1206	4087211e-d956-4b6d-aab8-d3174825f855	UNCLASSIFIED	png	6
1207	48d2c7b1-c671-4741-83f9-82fb7ec1d9d9	UNCLASSIFIED	jpeg	8
1208	351464a5-aba2-4d27-b809-bdbb4c4a3827	UNCLASSIFIED	jpeg	6
1209	4f48afb2-ad00-45d2-9ad7-486b51e6d17b	UNCLASSIFIED	jpeg	8
1210	9ff7adf9-590f-422c-b57f-cdcdabc4e67d	UNCLASSIFIED	jpeg	6
1211	8f905c67-2a1d-416b-b118-1aa79cf20705	UNCLASSIFIED	jpeg	8
1212	fd90158c-b697-47f0-a284-08dc13fc6843	UNCLASSIFIED	jpeg	6
1213	d66dbd25-8fc1-4cf2-b5c9-818f16ca572c	UNCLASSIFIED	jpeg	8
1214	ec80b2c1-d4ba-450b-9ecb-bfc9e252a813	UNCLASSIFIED	jpeg	6
1215	4bc9ce47-fef8-4a76-89b6-b10f75a59efd	UNCLASSIFIED	jpeg	8
1216	5ae9631d-57d9-4ebf-b6a0-627fdeee19c7	UNCLASSIFIED	jpeg	6
1217	f2f76a87-f1d2-452a-85c8-817749428989	UNCLASSIFIED	jpeg	8
1218	71fdc3c5-8e36-48a8-b3ab-43a19740f452	UNCLASSIFIED	jpeg	6
1219	d16a323d-a6e0-436d-b232-a0986a50d289	UNCLASSIFIED	png	8
1220	8a287d72-1cb2-479a-810c-89d553f2c9c9	UNCLASSIFIED	png	6
1221	5fb2bd10-6443-4d77-bac1-4a7b9a683301	UNCLASSIFIED	png	8
1222	f6a183e5-9155-4990-9290-59a682a9e3cc	UNCLASSIFIED	png	6
1223	a79d7abb-bc30-446c-b6ee-26f9624ef1e7	UNCLASSIFIED	png	8
1224	a78e2120-1045-457c-bf7e-5e698b1ae092	UNCLASSIFIED	png	6
1225	b31db01b-ff14-4210-bd63-a11f013dd7fd	UNCLASSIFIED	jpeg	8
1226	bf005dfd-1742-4a85-94e1-bbf2bcc1bb58	UNCLASSIFIED	jpeg	6
1227	4023c1d0-1673-4917-b17e-3ea1c63831c4	UNCLASSIFIED	jpeg	8
1228	96a92ce4-f46f-4a6c-8d5c-d13980c2ab6e	UNCLASSIFIED	jpeg	6
1229	7f776c33-28a7-49c4-8533-1e699c71e6b0	UNCLASSIFIED	jpeg	8
1230	8ecc0c33-af35-4bca-9bbd-23d4448716b8	UNCLASSIFIED	jpeg	6
1231	713e90ca-fd1b-40da-89f1-f73354182cb9	UNCLASSIFIED	jpeg	8
1232	d60ee8b2-916b-4cf3-9c79-949712c71e11	UNCLASSIFIED	jpeg	6
1233	e8850f5b-7fe3-4234-b8cd-2fd221ba4e2d	UNCLASSIFIED	jpeg	8
1234	62270ee4-8b62-4e82-afe9-0b4d91f4778a	UNCLASSIFIED	jpeg	6
1235	77e11f54-9074-44a4-8d32-d1f580412e19	UNCLASSIFIED	jpeg	8
1236	0b880d0c-9197-493e-9434-40f47d312cf1	UNCLASSIFIED	jpeg	6
\.


--
-- Name: ozpcenter_image_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ozp_user
--

SELECT pg_catalog.setval('ozpcenter_image_id_seq', 1236, true);


--
-- Data for Name: ozpcenter_imagetype; Type: TABLE DATA; Schema: public; Owner: ozp_user
--

COPY ozpcenter_imagetype (id, name, max_size_bytes, max_width, max_height, min_width, min_height) FROM stdin;
1	agency_icon	2097152	2048	2048	16	16
2	banner_icon	2097152	2048	2048	16	16
3	intent_icon	2097152	2048	2048	16	16
4	large_banner_icon	2097152	2048	2048	16	16
5	large_icon	8192	2048	2048	16	16
6	large_screenshot	1048576	2048	2048	16	16
7	small_icon	4096	2048	2048	16	16
8	small_screenshot	1048576	2048	2048	16	16
\.


--
-- Name: ozpcenter_imagetype_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ozp_user
--

SELECT pg_catalog.setval('ozpcenter_imagetype_id_seq', 8, true);


--
-- Data for Name: ozpcenter_intent; Type: TABLE DATA; Schema: public; Owner: ozp_user
--

COPY ozpcenter_intent (id, action, media_type, label, icon_id) FROM stdin;
1	/application/json/view	vnd.ozp-intent-v1+json.json	view	1
2	/application/json/edit	vnd.ozp-intent-v1+json.json	edit	1
\.


--
-- Name: ozpcenter_intent_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ozp_user
--

SELECT pg_catalog.setval('ozpcenter_intent_id_seq', 2, true);


--
-- Data for Name: ozpcenter_listing; Type: TABLE DATA; Schema: public; Owner: ozp_user
--

COPY ozpcenter_listing (id, title, approved_date, edited_date, description, launch_url, version_name, unique_name, what_is_new, description_short, usage_requirements, approval_status, is_enabled, is_featured, avg_rate, total_votes, total_rate5, total_rate4, total_rate3, total_rate2, total_rate1, total_reviews, iframe_compatible, security_marking, is_private, agency_id, banner_icon_id, current_rejection_id, large_banner_icon_id, large_icon_id, last_activity_id, listing_type_id, required_listings_id, small_icon_id, is_deleted, total_review_responses, system_requirements, feedback_score) FROM stdin;
1	Acoustic Guitar	2017-11-08 18:07:43.784802-05	2017-11-08 18:08:06.085906-05	A guitar that produces sound acoustically by transmitting the vibration of the strings to the air as opposed to relying on electronic amplification. The sound waves from the strings of an acoustic guitar resonate through the guitar's body, creating sound.	https://en.wikipedia.org/wiki/Acoustic_guitar	10.0	acoustic_guitar	Introduction of Steel strings and increased the area of the guitar top	A guitar that produces sound acoustically by transmitting the vibration of the strings.	Knowledge of acoustic properties of guitar	APPROVED	t	f	3	3	1	0	1	0	1	3	f	UNCLASSIFIED	f	2	13	\N	14	12	4	3	\N	11	f	0	None	0
3	Albatron Technology	\N	2017-11-08 18:07:43.948068-05	Albatron Technology Co. Ltd. is a Taiwan-based company, whose current CEO is Jack Ko. The company is primarily known for having been a major manufacture of graphics cards and motherboards based on NVIDIA chipsets in the 2000s which were marketed under the brand Albatron.	https://en.wikipedia.org/wiki/Albatron_Technology	1	albatron_technology	\N	Albatron Technology Co. Ltd. is a Taiwan-based company, whose current CEO is Jack Ko.	None	PENDING	t	f	0	0	0	0	0	0	0	0	t	UNCLASSIFIED	f	3	21	\N	22	20	10	2	\N	19	f	0	None	0
2	Air Mail	2017-11-08 18:07:43.921783-05	2017-11-08 18:08:06.216777-05	Sends mail via air	https://localhost:8443/demo_apps/centerSampleListings/airMail/index.html	1.0.0	ozp.test.air_mail	Nothing really new here	Sends airmail	None	APPROVED	t	t	3.20000000000000018	4	1	1	1	0	1	4	f	UNCLASSIFIED	f	1	17	\N	18	16	8	3	\N	15	f	0	None	0
4	Aliens	2017-11-08 18:07:44.001442-05	2017-11-08 18:08:06.298742-05	Extraterrestrial life, also called alien life (or, if it is a sentient or relatively complex individual, an "extraterrestrial" or "alien"), is life that does not originate from Earth. These hypothetical life forms may range from simple single-celled organisms to beings with civilizations far more advanced than humanity. Although many scientists expect extraterrestrial life to exist in some form, there is no evidence for its existence to date.	http://localhost.com	1	aliens	\N	E.T. phone home	None	APPROVED	t	f	3.29999999999999982	3	1	1	0	0	1	3	t	UNCLASSIFIED	f	6	25	\N	26	24	14	3	\N	23	f	0	None	0
5	Alingano Maisu	2017-11-08 18:07:44.070903-05	2017-11-08 18:07:44.070911-05	From Wikipedia, the free encyclopedia\nAlingano Maisu, also known simply as Maisu /ˈmaɪʃuː/, is a double-hulled voyaging canoe built in Kawaihae, Hawaii by members of Na Kalai Waʻa Moku o Hawaiʻi and ʻOhana Wa'a members from throughout the Pacific and abroad as a gift and tribute to Satawalese navigator Mau Piailug, who navigated the voyaging canoe Hōkūleʻa on her maiden voyage to Tahiti in 1976 and has since trained numerous native Hawaiians in the ancient art of wayfinding. The word maisu in the name of the canoe comes from the Satawalese word for breadfruit. In particular, the word refers to breadfruit that has been knocked down by storm winds and is therefore available for anyone to take. The name is said to symbolize the knowledge of navigation that is made freely available.\n\nThe concept for Alingano Maisu came about in 2001 when two Hawaiian voyaging groups, the Polynesian Voyaging Society and Na Kalai Waʻa Moku o Hawaiʻi, met with Piailug. The two hulls of the 56-foot (17 m) vessel were fabricated by the Friends of Hōkūleʻa and Hawaiʻiloa on Oʻahu and shipped to the Island of Hawaiʻi where Na Kalai Waʻa completed construction of the canoe. The Polynesian Voyaging Society provided much of the funding for the voyaging aspect of the project as well as an escort boat to help sail the canoe to Satawal.\n\nThe canoe is home-ported on the island of Yap under the command of Piailug's son, Sesario Sewralur.	https://en.wikipedia.org/wiki/Alingano_Maisu	1.0	alingano_maisu	\N	Alingano Maisu, also known simply as Maisu, is a double-hulled voyaging canoe built in Hawaii	None	APPROVED	t	f	0	0	0	0	0	0	0	0	t	UNCLASSIFIED	f	4	29	\N	30	28	18	4	\N	27	f	0	None	0
6	Apocalypse	2017-11-08 18:07:44.115309-05	2017-11-08 18:08:06.339176-05	Apocalypse (En Sabah Nur) is a fictional supervillain appearing in comic books published by Marvel Comics. He is one of the world's first mutants, and was originally a principal villain for the original X-Factor team and now for the X-Men and related spinoff teams. Created by writer Louise Simonson and artist Jackson Guice, Apocalypse first appeared in X-Factor #5 (May 1986).\nSince his introduction, the character has appeared in a number of X-Men titles, including spin-offs and several limited series. Apocalypse has also been featured in various forms of media. In 2016, Oscar Isaac portrayed the villain in the film X-Men: Apocalypse. He is ranked #24 in IGN's 100 Greatest Comic Book Villains of All Time.	https://en.wikipedia.org/wiki/Apocalypse_(comics)	1	apocalypse	\N	Apocalypse is an ancient mutant born with a variety of superhuman abilities.	None	APPROVED	t	f	1	1	0	0	0	0	1	1	t	UNCLASSIFIED	f	2	33	\N	34	32	22	3	\N	31	f	0	None	0
7	Applied Ethics Inc.	2017-11-08 18:07:44.388182-05	2017-11-08 18:07:44.388191-05	Applied ethics is the branch of ethics concerned with the analysis of particular moral issues in private and public life. For example, the bioethics community is concerned with identifying the correct approach to moral issues in the life sciences, such as euthanasia, the allocation of scarce health resources, or the use of human embryos in research. Environmental ethics is concerned with ecological issues such as the responsibility of government and corporations to clean up pollution. Business ethics includes questions regarding the duties or duty of 'whistleblowers' to the general public or to their loyalty to their employers. Applied ethics is distinguished from normative ethics, which concerns standards for right and wrong behavior, and from meta-ethics, which concerns the nature of ethical properties, statements, attitudes, and judgments.	http://appliedethicsinc.com	2.5	applied_ethics_inc.	\N	Applied ethics is the branch of ethics concerned with the analysis of particular moral issues.	None	APPROVED	t	f	0	0	0	0	0	0	0	0	t	UNCLASSIFIED	f	4	37	\N	38	36	26	3	\N	35	f	0	None	0
8	Astrology software	2017-11-08 18:07:44.460523-05	2017-11-08 18:08:06.381046-05	Astrology software is a type of computer programs designed to calculate horoscopes. Many of them also assemble interpretive text into narrative reports.\nAstro Computing Services (ACS) in San Diego, founded by Neil Michelsen in 1973, published a computer-generated astrological ephemeris in 1976, The American Ephemeris.\nWhen personal computers generally became available, astrologers and astrology hobbyists were able to purchase them and use astrological or astronomical calculation software or make such programs themselves. Astrologer and computer programmer Michael Erlewine was involved early in making astrological software for microcomputers available to the general public in the late 1970s. In 1978, Erlewine founded Matrix Software, and in 1980 he published a book with all the algorithms and data required for owners of microcomputers to make their own complete astrological programs. At first, astrology software was opposed by American astrologers who did not approve of computers in their field. However, acceptance grew as it became clear how more efficient and profitable such software could be.\nA few hundred fixed-purpose astrology computers were made, one of which was used by Nancy Reagan's astrologer beginning in about 1981	https://en.wikipedia.org/wiki/Astrology_software	1	astrology_software	\N	Astrology software is a type of computer programs designed to calculate horoscopes.	None	APPROVED	t	f	5	1	1	0	0	0	0	1	t	UNCLASSIFIED	f	8	41	\N	42	40	30	2	\N	39	f	0	None	0
10	Baltimore Ravens	2017-11-08 18:07:44.721736-05	2017-11-08 18:08:06.589243-05	The Baltimore Ravens are a professional American football team based in Baltimore, Maryland. The Ravens compete in the National Football League (NFL) as a member club of the American Football Conference (AFC) North division. The team plays its home games at M&T Bank Stadium and is headquartered in Owings Mills and is the best team in the NFL.\nThe Ravens were established in 1996, when Art Modell, who was then the owner of the Cleveland Browns, announced plans to relocate the franchise from Cleveland to Baltimore. As part of a settlement between the league and the city of Cleveland, Modell was required to leave the Browns' history and records in Cleveland for a replacement team and replacement personnel that would take control in 1999. In return, he was allowed to take his own personnel and team to Baltimore, where such personnel would then form an expansion team.	https://en.wikipedia.org/wiki/Baltimore_Ravens	2000	baltimore_ravens	\N	The Baltimore Ravens are a professional American football team based in Baltimore, Maryland	FOOTBALL	APPROVED	t	f	5	1	1	0	0	0	0	1	t	UNCLASSIFIED	f	3	49	\N	50	48	38	2	\N	47	f	0	None	0
11	Barbecue	2017-11-08 18:07:44.768692-05	2017-11-08 18:08:06.618708-05	Barbecuing encompasses four or five distinct types of cooking techniques. The original technique is cooking using smoke at low temperatures—usually around 240-280 °F or 115-145 °C—and significantly longer cooking times (several hours), known as smoking. Another technique, known as baking, used a masonry oven or baking oven that uses convection to cook meats and starches with moderate temperatures for an average cooking time of about an hour. Braising combines direct, dry heat charbroiling on a ribbed surface with a broth-filled pot for moist heat. Using this technique, cooking occurs at various speeds, starting fast, slowing down, then speeding up again, lasting for a few hours.\n\nGrilling is done over direct, dry heat, usually over a hot fire over 500 °F (260 °C) for a few minutes. Grilling may be done over wood, charcoal, gas, or electricity. The time difference between barbecuing and grilling is because of the temperature difference; at low temperatures used for barbecuing, meat takes several hours to reach the desired internal temperature.\nSmoking\nMain article: Smoking (cooking)\nChicken, pork and bacon-wrapped corn cooked in a barbecue smoker\n\nSmoking is the process of flavoring, cooking, and/or preserving food by exposing it to smoke from burning or smoldering material, most often wood. Meat and fish are the most common smoked foods, though cheeses, vegetables, nuts, and ingredients used to make beverages such as beer or smoked beer are also smoked.[full citation needed]\nRoasting\nSee also: Pit barbecue\n\nThe masonry oven is similar to a smoke pit; it allows for an open flame but cooks more quickly and uses convection to cook. Barbecue-baking can also be done in traditional stove-ovens. It can be used to cook meats, breads and other starches, casseroles, and desserts. It uses direct and indirect heat to surround the food with hot air to cook, and can be basted in much the same manner as grilled foods.\nBraising\n\nIt is possible to braise meats and vegetables in a pot on top of a grill. A gas or electric charbroil grill are the best choices for barbecue-braising, combining dry heat charbroil-grilling directly on a ribbed surface and braising in a broth-filled pot for moist heat. The pot is placed on top of the grill, covered, and allowed to simmer for a few hours. There are two advantages to barbecue-braising; it allows browning of the meat directly on the grill before the braising. It also allows for glazing of meat with sauce and finishing it directly over the fire after the braising. This effectively cooks the meat three times, which results in a soft, textured product that falls off the bone. The time needed for braising varies depending on whether a slow cooker or pressure cooker is used; it is generally slower than regular grilling or baking, but quicker than pit-smoking.[citation needed]	https://en.wikipedia.org/wiki/Barbecue	1	barbecue	Barbecue remains one of the most traditional foods in the United States.	Barbecuing is done slowly over low, indirect heat and the food is flavored by the smoking process.	Smoking\nSmoking is the process of flavoring, cooking, and/or preserving food by exposing it to smoke from burning or smoldering material, most often wood. Meat and fish are the most common smoked foods, though cheeses, vegetables, nuts, and ingredients used to make beverages such as beer or smoked beer are also smoked.[full citation needed]\nRoasting\nThe masonry oven is similar to a smoke pit; it allows for an open flame but cooks more quickly and uses convection to cook. Barbecue-baking can also be done in traditional stove-ovens. It can be used to cook meats, breads and other starches, casseroles, and desserts. It uses direct and indirect heat to surround the food with hot air to cook, and can be basted in much the same manner as grilled foods.	APPROVED	t	f	5	1	1	0	0	0	0	1	t	UNCLASSIFIED	f	1	53	\N	54	52	42	2	\N	51	f	0	None	0
17	BeiDou Navigation Satellite System	2017-11-08 18:07:45.12888-05	2017-11-08 18:08:06.92681-05	From Wikipedia, the free encyclopedia\n"BeiDou" redirects here. For other uses, see Beidou (disambiguation).\nBeiDoü Navigation Satellite System\nBeidou logo.png\nThe BeiDou system's logo\nCountry/ies of origin\tChina\nOperator(s)\tCNSA\nType\tMilitary, commercial\nStatus\tOperational (regionally)\nCoverage\tGlobal\nAccuracy\t10 m (public)\n0.1 m (encrypted)\nConstellation size\nTotal satellites\t35\nSatellites in orbit\t21\nFirst launch\t30 October 2000\nLast launch\t12 June 2016\nTotal launches\t27\nOrbital characteristics\nRegime(s)\tGEO, IGSO, MEO\nGeodesy\nAzimutalprojektion-schief kl-cropped.png\nFundamentals\nGeodesy Geodynamics Geomatics Cartography History\nConcepts\nGeographical distance Geoid Figure of the Earth Geodetic datum Geodesic Geographic coordinate system Horizontal position representation Latitude / Longitude Map projection Reference ellipsoid Satellite geodesy Spatial reference system\nTechnologies\nGlobal Navigation Satellite System (GNSS)\nGlobal Positioning System (GPS)\nGLONASS (Russian)\nBeiDou (BDS) (Chinese)\nGalileo (European)\nIndian Regional Navigation\nSatellite System (IRNSS) (India)\nQuasi-Zenith Satellite System (QZSS) (Japan)\nLegenda (satellite system)\nStandards (History)\nNGVD29\tSea Level Datum 1929\nOSGB36\tOrdnance Survey Great Britain 1936\nSK-42\tSystema Koordinat 1942 goda\nED50\tEuropean Datum 1950\nSAD69\tSouth American Datum 1969\nGRS 80\tGeodetic Reference System 1980\nNAD83\tNorth American Datum 1983\nWGS84\tWorld Geodetic System 1984\nNAVD88\tN. American Vertical Datum 1988\nETRS89\tEuropean Terrestrial Reference\nSystem 1989\nGCJ-02\tChinese encrypted datum 2002\nInternational Terrestrial Reference System\nSpatial Reference System Identifier (SRID)\nUniversal Transverse Mercator (UTM)\nv t e\nThe BeiDoü Navigation Satellite System (BDS, simplified Chinese: 北斗卫星导航系统; traditional Chinese: 北斗衛星導航系統; pinyin: Běidǒu wèixīng dǎoháng xìtǒng) is a Chinese satellite navigation system. It consists of two separate satellite constellations - a limited test system that has been operating since 2000, and a full-scale global navigation system that is currently under construction.\n\nThe first BeiDou system, officially called the BeiDou Satellite Navigation Experimental System (simplified Chinese: 北斗卫星导航试验系统; traditional Chinese: 北斗衛星導航試驗系統; pinyin: Běidǒu wèixīng dǎoháng shìyàn xìtǒng) and also known as BeiDou-1, consists of three satellites and offers limited coverage and applications. It has been offering navigation services, mainly for customers in China and neighboring regions, since 2000.\n\nThe second generation of the system, officially called the BeiDou Navigation Satellite System (BDS) and also known as COMPASS or BeiDou-2, will be a global satellite navigation system consisting of 35 satellites, and is under construction as of January 2015. It became operational in China in December 2011, with 10 satellites in use, and began offering services to customers in the Asia-Pacific region in December 2012. It is planned to begin serving global customers upon its completion in 2020.\n\nIn-mid 2015, China started the build-up of the third generation BeiDou system (BDS-3) in the global coverage constellation. The first BDS-3 satellite was launched 30 September 2015. As of March 2016, four BDS-3 in-orbit validation satellites have been launched.\n\nAccording to China Daily, fifteen years after the satellite system was launched, it is now generating a turnover of $31.5 billion per annum for major companies such as China Aerospace Science and Industry Corp, AutoNavi Holdings Ltd, and China North Industries Group Corp.\n\nBeidou has been described as a potential navigation satellite system to overtake GPS in global usage, and is expected to be more accurate than the GPS once it is fully completed.	https://en.wikipedia.org/wiki/BeiDou_Navigation_Satellite_System	1.0	beidou_navigation_satellite_system	\N	The BeiDoü Navigation Satellite System is a Chinese satellite navigation system	None	APPROVED	t	f	3.5	2	0	1	1	0	0	2	t	UNCLASSIFIED	f	4	77	\N	78	76	66	4	\N	75	f	0	None	0
12	Barsoom	2017-11-08 18:07:44.864483-05	2017-11-08 18:08:06.711773-05	Mars is the fourth planet from the Sun and the second-smallest planet in the Solar System, after Mercury. Named after the Roman god of war, it is often referred to as the "Red Planet" because the iron oxide prevalent on its surface gives it a reddish appearance. Mars is a terrestrial planet with a thin atmosphere, having surface features reminiscent both of the impact craters of the Moon and the valleys, deserts, and polar ice caps of Earth.\n\nThe rotational period and seasonal cycles of Mars are likewise similar to those of Earth, as is the tilt that produces the seasons. Mars is the site of Olympus Mons, the largest volcano and second-highest known mountain in the Solar System, and of Valles Marineris, one of the largest canyons in the Solar System. The smooth Borealis basin in the northern hemisphere covers 40% of the planet and may be a giant impact feature. Mars has two moons, Phobos and Deimos, which are small and irregularly shaped. These may be captured asteroids, similar to 5261 Eureka, a Mars trojan.\n\nThere are ongoing investigations assessing the past habitability potential of Mars, as well as the possibility of extant life. Future astrobiology missions are planned, including the Mars 2020 and ExoMars rovers. Liquid water cannot exist on the surface of Mars due to low atmospheric pressure, which is less than 1% of the Earth's, except at the lowest elevations for short periods. The two polar ice caps appear to be made largely of water. The volume of water ice in the south polar ice cap, if melted, would be sufficient to cover the entire planetary surface to a depth of 11 meters (36 ft). In November 2016, NASA reported finding a large amount of underground ice in the Utopia Planitia region of Mars. The volume of water detected has been estimated to be equivalent to the volume of water in Lake Superior.\n\nMars can easily be seen from Earth with the naked eye, as can its reddish coloring. Its apparent magnitude reaches −2.91, which is surpassed only by Jupiter, Venus, the Moon, and the Sun. Optical ground-based telescopes are typically limited to resolving features about 300 kilometers (190 mi) across when Earth and Mars are closest because of Earth's atmosphere.	https://en.wikipedia.org/wiki/Mars	1.0	barsoom	\N	Mars is the fourth planet from the Sun and the second-smallest planet in the Solar System.	Requires the internet.	APPROVED	t	f	4.29999999999999982	3	2	0	1	0	0	3	t	UNCLASSIFIED	f	3	57	\N	58	56	46	3	\N	55	f	0	None	0
13	Basketball	2017-11-08 18:07:44.908252-05	2017-11-08 18:08:06.774174-05	Basketball is a non-contact sport played on a rectangular court. While most often played as a team sport with five players on each side, three-on-three, two-on-two, and one-on-one competitions are also common. The objective is to shoot a ball through a hoop 18 inches (46 cm) in diameter and 10 feet (3.048 m) high that is mounted to a backboard at each end of the court. The game was invented in 1891 by Dr. James Naismith, who would be the first basketball coach of the Kansas Jayhawks, one of the most successful programs in the game's history.	http://localhost.com	23	basketball	\N	Possibly the best sport in the world	Must be tall	APPROVED	t	f	3.5	2	1	0	0	1	0	2	t	UNCLASSIFIED	f	3	61	\N	62	60	50	3	\N	59	f	0	None	0
14	Bass Fishing	2017-11-08 18:07:44.948765-05	2017-11-08 18:08:06.8048-05	Bass fishing is the activity of angling for the North American gamefish known colloquially as the black bass. There are numerous black bass species considered as gamefish in North America, including largemouth bass (Micropterus salmoides), smallmouth bass (Micropterus dolomieui), spotted bass or Kentucky bass (Micropterus punctulatus), and Guadalupe bass (order Perciformes).\nModern bass fishing has evolved into a multibillion-dollar industry. The sport has changed drastically since its beginnings in the late 19th century. From humble beginnings, the black bass has become the most specifically sought-after game fish in the United States. The sport has driven the development of all manner of fishing gear, including rods, reels, lines, lures, electronic depth and fish-finding instruments, drift boats, float tubes, also boats specified for bass fishing.	https://en.wikipedia.org/wiki/Bass_fishing	1	bass_fishing	The increasing popularity of the sport combined with "catch and release" practices have in some cases led to an overpopulation of bass.	The one that got away.	none	APPROVED	t	t	4	1	0	1	0	0	0	1	t	UNCLASSIFIED	f	1	65	\N	66	64	54	3	\N	63	f	0	None	0
23	Bread Basket	2017-11-08 18:07:45.66366-05	2017-11-08 18:08:07.13758-05	Carries delicious bread	https://localhost:8443/demo_apps/centerSampleListings/breadBasket/index.html	1.0.0	ozp.test.bread_basket	Nothing really new here	Carries bread	None	APPROVED	t	t	3.5	2	1	0	0	1	0	2	f	UNCLASSIFIED	t	1	101	\N	102	100	90	3	\N	99	f	0	None	0
15	Bass Lures	2017-11-08 18:07:44.991701-05	2017-11-08 18:07:44.991709-05	There are many types of fishing lures. In most cases they are manufactured to resemble prey for the fish, but they are sometimes engineered to appeal to a fishes' sense of territory, curiosity or aggression. Most lures are made to look like dying, injured, or fast moving fish. They include the following types:\n\n    A jig is a weighted hook with a lead head opposite the sharp tip. They usually have a minnow or crawfish or even a plastic worm on it to get the fish's attention. Deep water jigs used in saltwater fishing consist of a large metallic weight, which gives the impression of the body of the bait fish, which has a hook attached via a short length of kevlar usually to the top of the jig. Some jigs can be fished in water depths down to 300 metres.\n    Surface lures are also known as top water lures, poppers and stickbaits. They float and look like fish prey that is on top of the water. They can make a popping, burbling, or even a buzzing sound. It takes a long time to learn how to use this lure effectively\n    Spoon lures usually look like a spoon, with a wide rounded end and a narrower pointed end, similar n shape to a concave spearhead. They flash in the light while wobbling and darting due to their shape, which attracts fish.\n    LED lures have a built in led and battery to attract fish. They use a flashing or sometimes strobing pattern, using a combination of colors and leds.\n    Plugs are also known as crankbaits or minnows. These lures look like fish and they are run through the water where they can move in different ways because of instability due to the bib at the front under the head.\n    Artificial flies are designed to resemble all manner of fish prey and are used with a fly rod and reel in fly fishing.\n    Soft plastic baits are lures made of plastic or rubber designed to look like fish, crabs, squid, worms, lizards, frogs, leeches and other creatures.\n    Spinnerbait are pieces of wire that are bent at about a 60 degree angle with a hook at the bottom and a flashy spinner at the top.\n    Swimbait is a soft plastic bait/lure that resembles an actual bait fish. Some of these have a tail that makes the lure/bait look like it is swimming when drawn through the water.\n    Fish decoy is a type of lure that traditionally was carved to resemble a fish, frog, small rodent, or an insect that lures in fish so they can be speared. They are often used through the ice by fishermen and also by the Inuit people as part of their diet. The Mitchell Museum of the American Indian collection includes Native American fish decoys. William Jesse Ramey is considered a vintage master carver of fish decoys, and his work has been featured in museums.\n    Combined lures combine properties of several different types of lures.	https://en.wikipedia.org/wiki/Fishing_lure	1	bass_lures	A daisy chain is a teaser consisting of a "chain" of plastic lures run without hooks.	The fishing lure is either tied with a knot, or connected with a "swivel" onto the fishing line.	A fishing lure is a type of artificial fishing bait which is designed to attract a fish's attention. The lure uses movement, vibration, flash and color to bait fish. Many lures are equipped with one or more hooks that are used to catch fish when they strike the lure. Some lures are placed to attract fish so a spear can be impaled into the fish or so the fish can be captured by hand. Most lures are attached to the end of a fishing line and have various styles of hooks attached to the body and are designed to elicit a strike resulting in a hookset. Many lures are commercially made but some are hand made such as fishing flies. Hand tying fly lures to match the hatch is considered a challenge by many amateur entomologists.	APPROVED	t	f	0	0	0	0	0	0	0	0	t	UNCLASSIFIED	f	1	69	\N	70	68	58	3	\N	67	f	0	None	0
16	Beast	2017-11-08 18:07:45.036289-05	2017-11-08 18:08:06.866804-05	Beast (Henry Philip "Hank" McCoy) is a fictional superhero appearing in American comic books published by Marvel Comics and is a founding member of the X-Men. Originally called "The Beast", the character was introduced as a mutant possessing ape-like superhuman physical strength and agility, oversize hands and feet, a genius-level intellect, and an otherwise normal appearance. Eventually being referred to simply as "Beast", Hank McCoy underwent progressive physiological transformations, permanently gaining animalistic physical characteristics. These include blue fur, both simian and feline facial features, pointed ears, fangs, and claws. Beast's physical strength and senses increased to even greater levels.\nDespite Hank McCoy's inhuman appearance, he is depicted as a brilliant, well-educated man in the arts and sciences, known for his witty sense of humor. He is a world authority on biochemistry and genetics, the X-Men's medical doctor, and the science and mathematics instructor at the Xavier Institute (the X-Men's headquarters and school for young mutants). He is also a mutant political activist, campaigning against society's bigotry and discrimination against mutants. While fighting his own bestial instincts and fears of social rejection, Beast dedicates his physical and mental gifts to the creation of a better world for man and mutant.\nOne of the original X-Men, Beast has appeared regularly in X-Men-related comics since his debut. He has also been a member of the Avengers and Defenders.\nThe character has also appeared in media adaptations, including animated TV series and feature films. In X2, Steve Bacic portrayed him in a very brief cameo in his human appearance, while in X-Men: The Last Stand he was played by Kelsey Grammer. Nicholas Hoult portrays a younger version of the character in X-Men: First Class. Both Hoult and Grammer reprise their roles in X-Men: Days of Future Past. Hoult also reprised the role in X-Men: Apocalypse.	https://en.wikipedia.org/wiki/Beast_(comics)	2	beast	\N	Smart punch kick person	None	APPROVED	t	f	4	2	1	0	1	0	0	2	t	UNCLASSIFIED	f	2	73	\N	74	72	62	4	\N	71	f	0	None	0
18	Bleach	2017-11-08 18:07:45.185664-05	2017-11-08 18:08:06.987497-05	Bleach is the debut studio album by the American rock band Nirvana, released on June 15, 1989 by Sub Pop. The main recording sessions took place at Reciprocal Recording in Seattle, Washington between December 1988 and January 1989. It was also their only album to feature drummer Chad Channing.	https://en.wikipedia.org/wiki/Bleach_%28Nirvana_album%29	1.989	bleach	\N	Bleach is the debut studio album by the American rock band Nirvana	Flannel	APPROVED	t	f	4.5	2	1	1	0	0	0	2	t	UNCLASSIFIED	f	1	81	\N	82	80	70	2	\N	79	f	0	None	0
30	Chart Course	2017-11-08 18:07:46.462196-05	2017-11-08 18:08:07.350809-05	Chart your course	https://localhost:8443/demo_apps/centerSampleListings/chartCourse/index.html	1.0.0	ozp.test.chartcourse	Nothing really new here	Chart your course	None	APPROVED	t	t	3.5	2	1	0	0	1	0	2	f	UNCLASSIFIED	f	1	129	\N	130	128	118	3	\N	127	f	0	None	0
19	Blink	2017-11-08 18:07:45.260138-05	2017-11-08 18:08:07.076919-05	In the primary Earth-616 continuity of the Marvel Universe, Blink was introduced in the "Phalanx Covenant" storyline, in which the extraterrestrially derived techno-organic beings called the Phalanx captured her and several other young mutants to assimilate their powers. This version of Blink was tense and panicky and frightened of her powers (having "woken up in a pool of blood" after her first use of them). Clarice could not properly control her powers, and apparently was unable to teleport anything in an intact form. Instead, any object or person caught in Blink's teleportation field, also known as a "blink wave", would be shredded. She eventually used her abilities to "cut up" Harvest, a Phalanx entity guarding her and her peers, but she was caught in her own teleportation field and apparently died in the process. Because of her sacrifice, the remaining captives were set free and became the X-Men junior team Generation X.	https://en.wikipedia.org/wiki/Blink_(comics)	1	blink	\N	teleports and stuff	None	APPROVED	t	f	3.70000000000000018	3	2	0	0	0	1	3	t	UNCLASSIFIED	f	2	85	\N	86	84	74	1	\N	83	f	0	None	0
20	Bombardier Transportation	2017-11-08 18:07:45.371078-05	2017-11-08 18:07:45.371088-05	From Wikipedia, the free encyclopedia\nBombardier Transportation is the rail equipment division of the Canadian firm Bombardier Inc. Bombardier Transportation is one of the world's largest companies in the rail vehicle and equipment manufacturing and servicing industry. The division is headquartered in Berlin, Germany, and has regional offices and major development facilities in Canada (Montreal and Toronto) and the United States (Plattsburgh, New York). Bombardier Transportation has many minor production and development facilities worldwide.\nBombardier Transportation produces a wide range of products including passenger rail vehicles, locomotives, bogies, propulsion and controls.\nLaurent Troger is the president and chief operating officer of Bombardier Transportation. In January 2011, the company had 34,900 employees, 25,400 of them in Europe, and 60 manufacturing locations around the world.	https://en.wikipedia.org/wiki/Bombardier_Transportation	2.4	bombardier_transportation	\N	Bombardier Transportation is the rail equipment division of the Canadian firm Bombardier Inc.	None	APPROVED	t	f	0	0	0	0	0	0	0	0	t	UNCLASSIFIED	f	4	89	\N	90	88	78	4	\N	87	f	0	None	0
96	LocationLister	2017-11-08 18:07:53.838539-05	2017-11-08 18:08:09.070791-05	List locations	https://localhost:8443/demo_apps/locationLister/index.html	1.0.0	ozp.test.locationlister	Nothing really new here	List locations	None	APPROVED	t	t	4	1	0	1	0	0	0	1	f	UNCLASSIFIED	f	1	393	\N	394	392	382	3	\N	391	f	0	None	0
22	Bowser	2017-11-08 18:07:45.574155-05	2017-11-08 18:07:45.574165-05	Bowser (クッパ Kuppa, "Koopa") or King Koopa is a fictional character and the main antagonist of Nintendo's Mario franchise. In Japan, the character bears the title of Daimaō (大魔王 Great Demon King, lit.). In the United States, the character was first referred to as "Bowser, King of the Koopa" and "The sorcerer king" in the instruction manual. Bowser is the leader and likely the most powerful of the turtle-like Koopa race, and has been the archenemy of Mario ever since his first appearance, in the game Super Mario Bros.	https://en.wikipedia.org/wiki/Bowser_%28character%29	1	bowser	\N	Bowser or King Koopa is a fictional character and the main antagonist of Nintendo's Mario franchise.	Fireballs	APPROVED	t	f	0	0	0	0	0	0	0	0	t	UNCLASSIFIED	f	1	97	\N	98	96	86	5	\N	95	f	0	None	0
21	Bourbon	2017-11-08 18:07:45.442808-05	2017-11-08 18:07:45.442818-05	Bourbon whiskey /bɜːrbən/ is a type of American whiskey: a barrel-aged distilled spirit made primarily from corn. The name is derived from the French Bourbon dynasty, although it is unclear precisely what inspired the whiskey's name (contenders include Bourbon County in Kentucky and Bourbon Street in New Orleans). Bourbon has been distilled since the 18th century. The use of the term "bourbon" for the whiskey has been traced to the 1820s, and the term began to be used consistently in Kentucky in the 1870s. While bourbon may be made anywhere in the United States, it is strongly associated with the American South, and with Kentucky in particular. As of 2014, the distillers' wholesale market revenue for bourbon sold within the U.S. is about $2.7 billion, and bourbon makes up about two-thirds of the $1.6 billion of U.S. exports of distilled spirits.	https://en.wikipedia.org/wiki/Bourbon_whiskey	1	bourbon	Bourbon is served in a variety of manners, including neat, diluted with water, over ice ("on the rocks"), with other beverages in simple mixed drinks, and into cocktails, including the Manhattan, the Old Fashioned, the whiskey sour, and the mint julep.	Bottled (like other whiskeys) at 80 proof or more (40% alcohol by volume)	None	APPROVED	t	f	0	0	0	0	0	0	0	0	t	UNCLASSIFIED	f	1	93	\N	94	92	82	2	\N	91	f	0	None	0
24	Brisket	2017-11-08 18:07:45.726823-05	2017-11-08 18:07:45.726834-05	Brisket can be cooked many ways, including baking, boiling and roasting. Basting of the meat is often done during the cooking process. This normally tough cut of meat, due to the collagen fibers that make up the significant connective tissue in the cut, is tenderized when the collagen gelatinizes, resulting in more tender brisket. The fat cap, which is often left attached to the brisket, helps to keep the meat from drying during the prolonged cooking necessary to break down the connective tissue in the meat. Water is necessary for the conversion of collagen to gelatin, which is the hydrolysis product of collagen.\nPopular methods in the United States include rubbing with a spice rub or marinating the meat, then cooking slowly over indirect heat from charcoal or wood. This is a form of smoking the meat. A hardwood, such as oak, pecan, hickory, or mesquite, is sometimes added, alone or in combination with other hardwoods, to the main heat source. Sometimes, they make up all of the heat source, with chefs often prizing characteristics of certain woods. The smoke from these woods and from burnt dripping juices further enhances the flavor. The finished meat is a variety of barbecue. Smoked brisket done this way is popular in Texas barbecue. Once finished, pieces of brisket can be returned to the smoker to make burnt ends. Burnt ends are most popular in Kansas City-style barbecue, where they are traditionally served open-faced on white bread. The traditional New England boiled dinner features brisket as a main course option. Brisket is also cooked in a slow cooker as this also tenderizes the meat due to the slow cooking method, which is usually 8 hours for a 3lb brisket.	https://en.wikipedia.org/wiki/Brisket#Other_variations	1	brisket	Brisket is a cut of meat from the breast or lower chest of beef or veal. The beef brisket is one of the nine beef primal cuts, though the precise definition of the cut differs internationally.	The king of smoked meats.	none	APPROVED	t	f	0	0	0	0	0	0	0	0	t	UNCLASSIFIED	f	4	105	\N	106	104	94	4	\N	103	f	0	None	0
25	Building	2017-11-08 18:07:45.787368-05	2017-11-08 18:08:07.197735-05	A building or edifice is a structure with a roof and walls standing more or less permanently in one place, such as a house or factory.	http://localhost.com	1	building	\N	Buildings come in a  variety of sizes, shape, and functions.	None	APPROVED	t	f	3	2	0	1	0	1	0	2	t	UNCLASSIFIED	f	7	109	\N	110	108	98	4	\N	107	f	0	None	0
26	Business Insurance Risk	2017-11-08 18:07:46.012855-05	2017-11-08 18:07:46.012864-05	Insurance is a means of protection from financial loss. It is a form of risk management primarily used to hedge against the risk of a contingent, uncertain loss.\nAn entity which provides insurance is known as an insurer, insurance company, or insurance carrier. A person or entity who buys insurance is known as an insured or policyholder. The insurance transaction involves the insured assuming a guaranteed and known relatively small loss in the form of payment to the insurer in exchange for the insurer's promise to compensate the insured in the event of a covered loss. The loss may or may not be financial, but it must be reducible to financial terms and must involve something in which the insured has an insurable interest established by ownership, possession, or pre-existing relationship.	http://www.i.com	1.0	business_insurance_risk	\N	Insurance is a means of protection from financial loss. It is a form of risk management.	None	APPROVED	t	f	0	0	0	0	0	0	0	0	t	UNCLASSIFIED	f	1	113	\N	114	112	102	3	\N	111	f	0	None	0
27	Business Management System	2017-11-08 18:07:46.179368-05	2017-11-08 18:08:07.288943-05	Management (or managing) is the administration of an organization, whether it be a business, a not-for-profit organization, or government body. Management includes the activities of setting the strategy of an organization and coordinating the efforts of its employees or volunteers to accomplish its objectives through the application of available resources, such as financial, natural, technological, and human resources. The term "management" may also refer to the people who manage an organization.\nManagement is also an academic discipline, a social science whose objective is to study social organization and organizational leadership. Management is studied at colleges and universities; some important degrees in management are the Bachelor of Commerce (B.Com.) and Master of Business Administration (M.B.A.) and, for the public sector, the Master of Public Administration (MPA) degree. Individuals who aim at becoming management researchers or professors may complete the Doctor of Management (DM), the Doctor of Business Administration (DBA), or the PhD in Business Administration or Management.	http://businessmanagment.com	2.02	business_management_system	\N	Management (or managing) is the administration of an organization, whether it be a business.	None	APPROVED	t	f	3	3	0	1	1	1	0	3	t	UNCLASSIFIED	f	1	117	\N	118	116	106	2	\N	115	f	0	None	0
28	Cable ferry	2017-11-08 18:07:46.289563-05	2017-11-08 18:07:46.289573-05	From Wikipedia, the free encyclopedia\nThis article is about boats using a cable or chain to cross rivers. For boats using a chain to travel along a river, see Chain boat.\nA cable ferry (including the terms chain ferry, swing ferry, floating bridge, or punt) is a ferry that is guided (and in many cases propelled) across a river or large body of water by cables connected to both shores. Early cable ferries often used either rope or steel chains, with the latter resulting in the alternate name of chain ferry. Both of these were largely replaced by wire cable by the late 19th century.	https://en.wikipedia.org/wiki/Cable_ferry	1.1	cable_ferry	\N	A cable ferry is a ferry that is guided	None	APPROVED	t	f	0	0	0	0	0	0	0	0	t	UNCLASSIFIED	f	4	121	\N	122	120	110	2	\N	119	f	0	None	0
29	Chain boat navigation	2017-11-08 18:07:46.37595-05	2017-11-08 18:07:46.37596-05	Chain-boat navigation or chain-ship navigation is a little-known chapter in the history of shipping on European rivers. From around the middle of the 19th century, vessels called chain boats were used to haul strings of barges upstream by using a fixed chain lying on the bed of a river. The chain was raised from the riverbed to pass over the deck of the steamer, being hauled by a heavy winch powered by a steam engine. A variety of companies operated chain boat services on rivers such as the Elbe, Rhine, Neckar, Main, Saale, Havel, Spree and Saône as well as other rivers in Belgium and the Netherlands. Chain boats were also used in the United States.\n\nThe practice fell out of favour in the early 20th century when steamships with powerful engines and high boiler pressures - able to overcome the force of the river current - became commonplace	https://en.wikipedia.org/wiki/Chain_boat_navigation	1.0	chain_boat_navigation	\N	Chain-boat navigation or chain-ship navigation is a little-known chapter in the history	None	APPROVED	t	f	0	0	0	0	0	0	0	0	t	UNCLASSIFIED	f	4	125	\N	126	124	114	5	\N	123	f	0	None	0
31	Chasing Amy	2017-11-08 18:07:46.508694-05	2017-11-08 18:08:07.381671-05	Chasing Amy is a 1997 American romantic comedy-drama film written and directed by Kevin Smith. The film is about a male comic artist who falls in love with a lesbian woman, to the displeasure of his best friend. It is the third film in Smith's View Askewniverse series.\nThe film was originally inspired by a brief scene from an early movie by a friend of Smith's. In Guinevere Turner's Go Fish, one of the lesbian characters imagines her friends passing judgment on her for "selling out" by sleeping with a man. Kevin Smith was dating star Joey Lauren Adams at the time he was writing the script, which was also partly inspired by her.\nThe film won two awards at the 1998 Independent Spirit Awards (Best Screenplay for Smith and Best Supporting Actor for Jason Lee).	https://en.wikipedia.org/wiki/Chasing_Amy	1997	chasing_amy	\N	Chasing Amy is a 1997 American romantic comedy-drama film written and directed by Kevin Smith.	None	APPROVED	t	f	4	1	0	1	0	0	0	1	t	UNCLASSIFIED	f	5	133	\N	134	132	122	1	\N	131	f	0	None	0
32	Chatter Box	2017-11-08 18:07:46.647703-05	2017-11-08 18:07:46.647717-05	Chat with people	https://localhost:8443/demo_apps/centerSampleListings/chatterBox/index.html	1.0.0	ozp.test.chatterbox	Nothing really new here	Chat in a box	None	APPROVED	t	t	0	0	0	0	0	0	0	0	f	UNCLASSIFIED	f	3	137	\N	138	136	126	3	\N	135	f	0	None	0
33	Cheese and Crackers	2017-11-08 18:07:46.840416-05	2017-11-08 18:07:46.840441-05	Cheese and crackers is a common dish consisting of crackers paired with various or multiple cheeses. The dish was consumed by sailors before refrigeration existed, has been described as one of the first fast foods in the United States, and increased in popularity circa the 1850s in the U.S. It is prepared using various types of cheeses, and is often paired with wine. Mass-produced cheese and crackers brands include Handi-Snacks, Ritz, Jatz and Lunchables.	https://en.wikipedia.org/wiki/Cheese_and_crackers	1	cheese_and_crackers	\N	Cheese and crackers is a common dish consisting of crackers paired with various or multiple cheeses.	None	APPROVED	t	f	0	0	0	0	0	0	0	0	t	UNCLASSIFIED	f	3	141	\N	142	140	130	3	\N	139	f	0	None	0
34	Cheesecake	2017-11-08 18:07:46.909839-05	2017-11-08 18:07:46.90985-05	Cheesecake is a sweet dessert consisting of one or more layers. The main, and thickest layer, consists of a mixture of soft, fresh cheese (typically cream cheese or ricotta), eggs, and sugar; if there is a bottom layer it often consists of a crust or base made from crushed cookies (or digestive biscuits), graham crackers, pastry, or sponge cake. It may be baked or unbaked (usually refrigerated). Cheesecake is usually sweetened with sugar and may be flavored or topped with fruit, whipped cream, nuts, cookies, fruit sauce, or chocolate syrup. Cheesecake can be prepared in many flavors, such as strawberry, pumpkin, key lime, chocolate, Oreo, chestnut, or toffee.	https://en.wikipedia.org/wiki/Cheesecake	1	cheesecake	Good eats.	Cheesecakes can be broadly categorized into two basic types: baked and unbaked.	none	APPROVED	t	f	0	0	0	0	0	0	0	0	t	UNCLASSIFIED	f	1	145	\N	146	144	134	5	\N	143	f	0	None	0
35	Chicken and Waffles	2017-11-08 18:07:47.107153-05	2017-11-08 18:07:47.107174-05	Chicken and waffles refers to either of two American dishes - one from soul food, the other Pennsylvania Dutch - that combine chicken with waffles. It is served in certain specialty restaurants in the United States	https://en.wikipedia.org/wiki/Chicken_and_waffles	1	chicken_and_waffles	\N	Chicken and waffles	None	APPROVED	t	f	0	0	0	0	0	0	0	0	t	UNCLASSIFIED	f	3	149	\N	150	148	138	5	\N	147	f	0	None	0
36	Clerks	2017-11-08 18:07:47.154492-05	2017-11-08 18:08:07.410233-05	Clerks is a 1994 American independent black comedy film written, directed, and co-produced by Kevin Smith. Starring Brian O'Halloran as Dante Hicks and Jeff Anderson as Randal Graves, it presents a day in the lives of two store clerks and their acquaintances. Shot entirely in black-and-white, Clerks is the first of Smith's View Askewniverse films, and introduces several recurring characters, notably Jay and Silent Bob, the latter played by Smith himself. The structure of the movie contains nine scene breaks, signifying the nine rings of hell as in Dante Alighieri's Divine Comedy, from which the main character, Dante, gets his name.	https://en.wikipedia.org/wiki/Clerks	1	clerks	\N	Clerks is a 1994 American independent black comedy film.	None	APPROVED	t	f	3	1	0	0	1	0	0	1	t	UNCLASSIFIED	f	3	153	\N	154	152	142	2	\N	151	f	0	None	0
37	Clerks II	2017-11-08 18:07:47.208771-05	2017-11-08 18:08:07.43993-05	Clerks II is a 2006 American comedy film written and directed by Kevin Smith, the sequel to his 1994 film Clerks, and his sixth feature film to be set in the View Askewniverse. The film stars Brian O'Halloran, Jeff Anderson, Rosario Dawson, Trevor Fehrman, Jennifer Schwalbach Smith, Jason Mewes, and Smith, and picks up with the original characters from Clerks: Dante Hicks, Randal Graves and Jay and Silent Bob ten years after the events of the first film. Unlike the first film, which was shot in black-and-white, this film was shot in color.	https://en.wikipedia.org/wiki/Clerks_II	2	clerks_ii	\N	Clerks II is a 2006 American comedy film written and directed by Kevin Smith.	Color TV	APPROVED	t	f	3	1	0	0	1	0	0	1	t	UNCLASSIFIED	f	3	157	\N	158	156	146	2	\N	155	f	0	None	0
38	Clipboard	2017-11-08 18:07:47.296144-05	2017-11-08 18:07:47.296154-05	Clip stuff on a board	https://localhost:8443/demo_apps/centerSampleListings/clipboard/index.html	1.0.0	ozp.test.clipboard	Nothing really new here	Its a clipboard	None	APPROVED	t	t	0	0	0	0	0	0	0	0	f	UNCLASSIFIED	f	1	161	\N	162	160	150	3	\N	159	f	0	None	0
39	Clippy	2017-11-08 18:07:47.363882-05	2017-11-08 18:07:47.363891-05	The Office Assistant was an intelligent user interface for Microsoft Office that assisted users by way of an interactive animated character, which interfaced with the Office help content. It was included in Microsoft Office for Windows (versions 97 to 2003), in Microsoft Publisher (versions 98 to 2003), and Microsoft Office for Mac (versions 98 to 2004).\nThe default assistant in the English Windows version was named Clippit (commonly nicknamed Clippy), after a paperclip. The character was designed by Kevan J. Atteberry. Clippit was the default and by far the most notable Assistant (partly because in many cases the setup CD was required to install the other assistants), which also led to it being called simply the Microsoft Paperclip. The original Clippit in Office 97 was given a new look in Office 2000.	https://en.wikipedia.org/wiki/Office_Assistant	1	clippy	\N	The Office Assistant was an intelligent user interface for Microsoft Office	Office	APPROVED	t	f	0	0	0	0	0	0	0	0	t	UNCLASSIFIED	f	4	165	\N	166	164	154	5	\N	163	f	0	None	0
152	Skybox	2017-11-08 18:08:01.253884-05	2017-11-08 18:08:01.253904-05	Sky Overlord	https://localhost:8443/demo_apps/Skybox/index.html	1.0.0	ozp.test.skybox	It's a box in the sky	Sky Overlord	None	APPROVED	t	t	0	0	0	0	0	0	0	0	f	UNCLASSIFIED	f	3	617	\N	618	616	606	3	\N	615	f	0	None	0
40	Compound bow	2017-11-08 18:07:47.417226-05	2017-11-08 18:07:47.417237-05	In modern archery, a compound bow is a bow that uses a levering system, usually of cables and pulleys, to bend the limbs.\nThe pulley/cam system grants the user a mechanical advantage, and so the limbs of a compound bow are much stiffer than those of a recurve bow or longbow. This rigidity makes the compound bow more energy-efficient than other bows, as less energy is dissipated in limb movement. The higher-rigidity, higher-technology construction also improves accuracy by reducing the bow's sensitivity to changes in temperature and humidity.\nThe pulley/cam system also confers a benefit called "let-off". As the string is drawn back, the pulleys rotate. The pulleys are eccentric rather than round, and so their effective radius changes as they rotate. The pulleys feature two cam tracks. An inner cam track which connects mechanically to the limbs or opposite cam and an outer cam track which the bowstring runs through. As the bow is drawn the ratio of bowstring pay-out and bowstring take-up relative to limb-weight and leverage of the cams changes. By manipulation of the shapes of these cam tracks, different draw-stroke profiles can be created. A compound bow can be soft-drawing with a slow build-up to peak weight and a gradual let-off with a long "valley" at the end. It can also be hard-drawing with a very fast build-up to peak draw-weight, a long plateau where weight is maintained, and a quick let-off with a short valley. The let-off itself is the result of the cam profiles having passed center and approaching a condition very similar to a cam-lock. In fact some compound bows, if the draw-stops or draw-length modules are removed, will self-lock at full draw and require professional equipment to unlock safely.	https://en.wikipedia.org/wiki/Compound_bow	1	compound_bow	The function of the cam systems (known as the 'eccentrics') is to maximize the energy storage throughout the draw cycle and provide let-off at the end of the cycle (less holding weight at full draw).	The compound bow was first developed in 1966; the compound bow is the dominant form of bow.	none	APPROVED	t	f	0	0	0	0	0	0	0	0	t	UNCLASSIFIED	f	1	169	\N	170	168	158	5	\N	167	f	0	None	0
41	Cyclops	2017-11-08 18:07:47.47241-05	2017-11-08 18:08:07.500114-05	Cyclops (Scott Summers) is a fictional superhero appearing in American comic books published by Marvel Comics and is a founding member of the X-Men. Created by writer Stan Lee and artist Jack Kirby, the character first appeared in the comic book The X-Men #1 (September 1963).\n\nCyclops is a member of a subspecies of humans known as mutants, who are born with superhuman abilities. Cyclops can emit powerful beams of energy from his eyes. He cannot control the beams without the aid of special eyewear which he must wear at all times. He is typically considered the first of the X-Men, a team of mutant heroes who fight for peace and equality between mutants and humans, and one of the team's primary leaders.\n\nCyclops is most often portrayed as the archetypal hero of traditional American popular culture—the opposite of the tough, anti-authority antiheroes that emerged in American popular culture after the Vietnam War (e.g., Wolverine, his X-Men teammate).\n\nOne of Marvel's most prominent characters, Cyclops was rated #1 on IGN.com's list of Top 25 X-Men from the past forty years in 2006, and the 39th in their 2011 list of Top 100 Comic Book Heroes. In 2008, Wizard Magazine also ranked Cyclops the 106th in their list of the 200 Greatest Comic Book Characters of All Time. In a 2011 poll, readers of Comic Book Resources voted Cyclops as 9th in the ranking of 2011 Top Marvel Characters.\n\nJames Marsden has portrayed Cyclops in the first three and the seventh X-Men films, while in the 2009 prequel film, X-Men Origins: Wolverine, he is portrayed as a teenager by actor Tim Pocock. In 2016's X-Men: Apocalypse, he is portrayed by Tye Sheridan.	https://en.wikipedia.org/wiki/Cyclops_(comics)	1	cyclops	\N	Kind of a tool.	None	APPROVED	t	f	3	2	1	0	0	0	1	2	t	UNCLASSIFIED//FOR OFFICIAL USE ONLY	f	2	173	\N	174	172	162	1	\N	171	f	0	None	0
42	Deadpool	2017-11-08 18:07:47.550158-05	2017-11-08 18:08:07.559918-05	Deadpool (Wade Winston Wilson) is a fictional antihero appearing in American comic books published by Marvel Comics. Created by artist/writer Rob Liefeld and writer Fabian Nicieza, the character first appeared in The New Mutants #98 (cover-dated February 1991). Initially Deadpool was depicted as a supervillain when he made his first appearance in The New Mutants and later in issues of X-Force, but later evolved into his more recognizable antiheroic persona. Deadpool, whose real name is Wade Wilson, is a disfigured and mentally unstable mercenary with the superhuman ability of an accelerated healing factor and physical prowess. The character is known as the "Merc with a Mouth" because of his talkative nature and tendency to break the fourth wall, which is used by writers for humorous effect and running gags.\nThe character's popularity has seen him feature in numerous other media. In the 2004 series Cable & Deadpool, he refers to his own scarred appearance as "Ryan Reynolds crossed with a Shar Pei". Reynolds himself would eventually portray the character in the 2009 film X-Men Origins: Wolverine and reprised the role in the 2016 film Deadpool.	https://en.wikipedia.org/wiki/Deadpool	1	deadpool	\N	makes dead people	None	APPROVED	t	f	3.5	2	1	0	0	1	0	2	t	UNCLASSIFIED	f	2	177	\N	178	176	166	4	\N	175	f	0	None	0
43	Desktop Virtualization	2017-11-08 18:07:47.868931-05	2017-11-08 18:07:47.86894-05	Desktop virtualization is software technology that separates the desktop environment and associated application software from the physical client device that is used to access it.\nDesktop virtualization can be used in conjunction with application virtualization and user profile management systems, now termed "user virtualization," to provide a comprehensive desktop environment management system. In this mode, all the components of the desktop are virtualized, which allows for a highly flexible and much more secure desktop delivery model. In addition, this approach supports a more complete desktop disaster recovery strategy as all components are essentially saved in the data center and backed up through traditional redundant maintenance systems. If a user's device or hardware is lost, the restore is straightforward and simple, because the components will be present at login from another device. In addition, because no data is saved to the user's device, if that device is lost, there is much less chance that any critical data can be retrieved and compromised.	http://dv.com	2.01	desktop_virtualization	\N	Desktop virtualization is software technology that separates the desktop environment.	None	APPROVED	t	f	0	0	0	0	0	0	0	0	t	UNCLASSIFIED	f	1	181	\N	182	180	170	2	\N	179	f	0	None	0
44	Diamond	2017-11-08 18:07:48.134604-05	2017-11-08 18:07:48.134614-05	Diamond ( /ˈdaɪəmənd/ or /ˈdaɪmənd/) is a metastable allotrope of carbon, where the carbon atoms are arranged in a variation of the face-centered cubic crystal structure called a diamond lattice. Diamond is less stable than graphite, but the conversion rate from diamond to graphite is negligible at standard conditions. Diamond is renowned as a material with superlative physical qualities, most of which originate from the strong covalent bonding between its atoms. In particular, diamond has the highest hardness and thermal conductivity of any bulk material. Those properties determine the major industrial application of diamond in cutting and polishing tools and the scientific applications in diamond knives and diamond anvil cells.\n\nBecause of its extremely rigid lattice, it can be contaminated by very few types of impurities, such as boron and nitrogen. Small amounts of defects or impurities (about one per million of lattice atoms) color diamond blue (boron), yellow (nitrogen), brown (lattice defects), green (radiation exposure), purple, pink, orange or red. Diamond also has relatively high optical dispersion (ability to disperse light of different colors).\n\nMost natural diamonds are formed at high temperature and pressure at depths of 140 to 190 kilometers (87 to 118 mi) in the Earth's mantle. Carbon-containing minerals provide the carbon source, and the growth occurs over periods from 1 billion to 3.3 billion years (25% to 75% of the age of the Earth). Diamonds are brought close to the Earth's surface through deep volcanic eruptions by magma, which cools into igneous rocks known as kimberlites and lamproites. Diamonds can also be produced synthetically in a HPHT method which approximately simulates the conditions in the Earth's mantle. An alternative, and completely different growth technique is chemical vapor deposition (CVD). Several non-diamond materials, which include cubic zirconia and silicon carbide and are often called diamond simulants, resemble diamond in appearance and many properties. Special gemological techniques have been developed to distinguish natural diamonds, synthetic diamonds, and diamond simulants. The word is from the ancient Greek ἀδάμας - adámas "unbreakable".	https://en.wikipedia.org/wiki/Diamond	2	diamond	\N	An overpriced gemstone whose price is inflated by the De Beers cartel	Must spend x amount of your salary to show your love	APPROVED	t	f	0	0	0	0	0	0	0	0	t	UNCLASSIFIED	f	4	185	\N	186	184	174	5	\N	183	f	0	None	0
45	Dinosaur	2017-11-08 18:07:48.26146-05	2017-11-08 18:08:07.649768-05	Dinosaurs are a diverse group of reptiles of the clade Dinosauria that first appeared during the Triassic period. Although the exact origin and timing of the evolution of dinosaurs is the subject of active research, the current scientific consensus places their origin between 231 and 243 million years ago.	http://localhost.com	1	dinosaur	\N	They were dangerous creatures.	Windows 95	APPROVED	t	f	3.29999999999999982	3	1	1	0	0	1	3	t	UNCLASSIFIED	f	5	189	\N	190	188	178	1	\N	187	f	0	None	0
97	LocationViewer	2017-11-08 18:07:53.915609-05	2017-11-08 18:07:53.915618-05	View locations	https://localhost:8443/demo_apps/locationViewer/index.html	1.0.0	ozp.test.locationviewer	Nothing really new here	View locations	None	APPROVED	t	t	0	0	0	0	0	0	0	0	f	UNCLASSIFIED	f	1	397	\N	398	396	386	3	\N	395	f	0	None	0
46	Double Heroides	2017-11-08 18:07:48.317307-05	2017-11-08 18:07:48.317317-05	The Double Heroides are a set of six epistolary poems allegedly composed by Ovid in Latin elegiac couplets, following the fifteen poems of his Heroides, and numbered 16 to 21 in modern scholarly editions. These six poems present three separate exchanges of paired epistles: one each from a heroic lover from Greek or Roman mythology to his absent beloved, and one from the heroine in return. Ovid's authorship is uncertain.	https://en.wikipedia.org/wiki/Double_Heroides	6	double_heroides	\N	The Double Heroides are a set of six epistolary poems	None	APPROVED	t	f	0	0	0	0	0	0	0	0	t	UNCLASSIFIED	f	3	193	\N	194	192	182	3	\N	191	f	0	None	0
47	Dragons	2017-11-08 18:07:48.500464-05	2017-11-08 18:08:07.67885-05	A dragon is a legendary creature, typically scaled or fire-spewing and with serpentine, reptilian or avian traits, that features in the myths of many cultures around world. The two most well-known cultural traditions of dragon are\n\nThe European dragon, derived from European folk traditions and ultimately related to Balkans and Western Asian mythologies. Most are depicted as reptilian creatures with animal-level intelligence, and are uniquely six-limbed (four legs and a separate set of wings).\nThe Chinese dragon, with counterparts in Japan (namely the Japanese dragon), Korea and other East Asian and South Asian countries. Most are depicted as serpentine creatures with above-average intelligence, and are quadrupeds (four legs and wingless).\nThe two traditions may have evolved separately, but have influenced each other to a certain extent, particularly with the cross-cultural contact of recent centuries. The English word dragon and Latin word draco derives from Greek δράκων (drákōn), "dragon, serpent of huge size, water-snake".	https://en.wikipedia.org/wiki/Dragon	5	dragons	New illustrations of dragons	The fantastical lizard-like creature, often having wings or ability to fly	None	APPROVED	t	f	5	1	1	0	0	0	0	1	t	UNCLASSIFIED	f	4	197	\N	198	196	186	1	\N	195	f	0	None	0
48	E-ZPass	2017-11-08 18:07:48.626709-05	2017-11-08 18:07:48.62672-05	E‑ZPass is an electronic toll collection system used on most tolled roads, bridges, and tunnels in the midwestern and northeastern United States, as far south as North Carolina and as far west as Illinois. The E-ZPass Interagency Group (IAG) consists of 38 member agencies in operation within 16 states, which use the same technology and allow travelers to use the same transponder on toll roads throughout the network. Since its creation in 1987, various independent systems that use the same technology have been folded into the E-ZPass system, including the I-Pass in Illinois and the NC Quick Pass in North Carolina.	https://en.wikipedia.org/wiki/E-ZPass	1987	e-zpass	\N	E‑ZPass is an electronic toll collection system.	None	APPROVED	t	f	0	0	0	0	0	0	0	0	t	UNCLASSIFIED	f	3	201	\N	202	200	190	2	\N	199	f	0	None	0
49	Electric Guitar	2017-11-08 18:07:48.691765-05	2017-11-08 18:07:48.691776-05	Is a fretted stringed instrument with a neck and body that uses a pickup to convert the vibration of its strings into electrical signals. The vibration occurs when a guitarist strums, plucks or fingerpicks the strings	https://en.wikipedia.org/wiki/Electric_guitar	1.05	electric_guitar	Construction vary greatly in the shape of the body and the configuration of the neck, bridge, and pickup	Guitar that uses a pickup to convert the vibration of its strings into electrical signals	Magnetic pickup that uses the principle of direct electromagnetic induction	APPROVED	t	f	0	0	0	0	0	0	0	0	t	UNCLASSIFIED	f	2	205	\N	206	204	194	3	\N	203	f	0	None	0
50	Electric Piano	2017-11-08 18:07:48.755029-05	2017-11-08 18:07:48.755039-05	Electric musical instrument which produces sounds when a performer presses the keys of the piano-style musical keyboard. Pressing keys causes mechanical hammers to strike metal strings, metal reeds or wire tines, leading to vibrations which are converted into electrical signals by magnetic pickups, which are then connected to an instrument amplifier and loudspeaker to make a sound loud enough for the performer and audience to hear. Unlike a synthesizer, the electric piano is not an electronic instrument	https://en.wikipedia.org/wiki/Electric_piano	8.0.9	electric_piano	Digital electronic stage pianos that provide an emulated electric piano sound	Electric musical instrument which produces sounds when a performer presses the keys of the keyboard	Electricity and motivation to play piano	APPROVED	t	f	0	0	0	0	0	0	0	0	t	UNCLASSIFIED	f	2	209	\N	210	208	198	3	\N	207	f	0	None	0
51	English Bitter	\N	2017-11-08 18:07:48.848142-05	Bitter is a British style of pale ale that varies in colour from gold to dark amber, and in strength from 3% to 7% alcohol by volume.	https://en.wikipedia.org/wiki/Bitter_%28beer%29	3	english_bitter	\N	Bitter is a British style of pale ale that varies in colour from gold to dark amber.	None	PENDING	t	f	0	0	0	0	0	0	0	0	t	UNCLASSIFIED	f	3	213	\N	214	212	200	5	\N	211	f	0	None	0
52	Eraser	2017-11-08 18:07:48.98692-05	2017-11-08 18:07:48.986931-05	An eraser, (also called a rubber outside America, from the material first used) is an article of stationery that is used for removing writing from paper. Erasers have a rubbery consistency and come in a variety of shapes, sizes and colours. Some pencils have an eraser on one end. Less expensive erasers are made from synthetic rubber and synthetic soy-based gum, but more expensive or specialized erasers are vinyl, plastic, or gum-like materials.\nErasers were initially made for pencil markings, but more abrasive ink erasers were later introduced. The term is also used for things that remove writing from chalkboards and whiteboards.	https://en.wikipedia.org/wiki/Eraser	1	eraser	\N	An eraser is an article of stationery that is used for removing writing from paper.	Pencil	APPROVED	t	f	0	0	0	0	0	0	0	0	t	UNCLASSIFIED	f	3	217	\N	218	216	204	5	\N	215	f	0	None	0
53	Excitebike	2017-11-08 18:07:49.050286-05	2017-11-08 18:07:49.050305-05	Excitebike (エキサイトバイク Ekisaitobaiku) is a motocross racing video game franchise made by Nintendo. It debuted as a game for the Famicom in Japan in 1984 and as a launch title for the NES in 1985. It is the first game of the Excite series, succeeded by its direct sequel Excitebike 64, its spiritual successors Excite Truck and Excitebots: Trick Racing, and the WiiWare title Excitebike: World Rally. 3D Classics: Excitebike, a 3D remake of the original game, was free for a limited time to promote the launch of the Nintendo eShop in June 2011.	https://en.wikipedia.org/wiki/Excitebike	1	excitebike	\N	Excitebike (エキサイトバイク Ekisaitobaiku) is a motocross racing video game.	NES	APPROVED	t	f	0	0	0	0	0	0	0	0	t	UNCLASSIFIED	f	3	221	\N	222	220	208	2	\N	219	f	0	None	0
54	Fiat 525	2017-11-08 18:07:49.189383-05	2017-11-08 18:07:49.189393-05	The Fiat 525 is a passenger car produced by Italian automobile manufacturer Fiat between 1928 and 1931. The 525 was a larger successor to the Fiat 512. The 525 was modified a year after it began production and renamed the 525N. A sport variant, the 525SS, had a more powerful engine and a shorter chassis.\nFiat produced 4,400 525's.	https://en.wikipedia.org/wiki/Fiat_525	525	fiat_525	\N	The Fiat 525 is a passenger car produced by Italian automobile manufacturer Fiat.	None	APPROVED	t	f	0	0	0	0	0	0	0	0	t	UNCLASSIFIED	t	6	225	\N	226	224	212	2	\N	223	f	0	None	0
100	Magneto	2017-11-08 18:07:54.124039-05	2017-11-08 18:08:09.192442-05	Magneto is a fictional character appearing in American comic books published by Marvel Comics, commonly in association with the X-Men. Created by writer Stan Lee and artist Jack Kirby, the character first appears in The X-Men #1 (cover-dated Sept. 1963) as the archenemy of the X-Men.\nThe character is a powerful mutant, one of a fictional subspecies of humanity born with superhuman abilities, who has the ability to generate and control magnetic fields. Magneto regards mutants as evolutionarily superior to humans and rejects the possibility of peaceful human-mutant coexistence; he aims to conquer the world to enable mutants (whom he refers to as "homo superior") to replace humans as the dominant species. Writers have since fleshed out his origins and motivations, revealing him to be a Holocaust survivor whose extreme methods and cynical philosophy derive from his determination to protect mutantkind from suffering a similar fate at the hands of a world that fears and persecutes mutants. He is a friend of Professor X, the leader of the X-Men, but their different philosophies cause a rift in their friendship at times. Magneto's role in comics has varied from supervillain to antihero to superhero, having served as an occasional ally and even a member of the X-Men at times.\nHis character's early history has been compared with the civil rights leader Malcolm X and Jewish Defense League founder Meir Kahane. Magneto opposes the pacifist attitude of Professor X and pushes for a more aggressive approach to achieving civil rights. In 2011, IGN ranked Magneto as the greatest comic book villain of all time.\nSir Ian McKellen portrayed Magneto in four films of the X-Men film series, while Michael Fassbender portrayed a younger version of the character in three films.	https://en.wikipedia.org/wiki/Magneto_(comics)	1	magneto	\N	Controls metal, also they keep trying to make him good for some reason.	None	APPROVED	t	f	2	2	0	0	1	0	1	2	t	UNCLASSIFIED	f	2	409	\N	410	408	398	3	\N	407	f	0	None	0
55	Fight Club	2017-11-08 18:07:49.235523-05	2017-11-08 18:08:07.709689-05	Fight Club is a 1999 American film based on the 1996 novel of the same name by Chuck Palahniuk. The film was directed by David Fincher, and stars Brad Pitt, Edward Norton and Helena Bonham Carter. Norton plays the unnamed protagonist, referred to as the narrator, who is discontented with his white-collar job. He forms a "fight club" with soap maker Tyler Durden, played by Pitt, and they are joined by men who also want to fight recreationally. The narrator becomes embroiled in a relationship with Durden and a dissolute woman, Marla Singer, played by Bonham Carter.\nPalahniuk's novel was optioned by 20th Century Fox producer Laura Ziskin, who hired Jim Uhls to write the film adaptation. Fincher was one of four directors the producers considered, and was selected because of his enthusiasm for the film. Fincher developed the script with Uhls and sought screenwriting advice from the cast and others in the film industry. The director and the cast compared the film to Rebel Without a Cause (1955) and The Graduate (1967). They said its theme was the conflict between a generation of young people and the value system of advertising. The director copied the homoerotic overtones from Palahniuk's novel to make audiences uncomfortable and keep them from anticipating the twist ending.	https://en.wikipedia.org/wiki/Fight_Club	1	fight_club	\N	Fight Club is a 1999 American film based on the 1996 novel of the same name by Chuck Palahniuk.	The first rule of fight club is you do not talk about fight club	APPROVED	t	f	3	1	0	0	1	0	0	1	t	UNCLASSIFIED	f	3	229	\N	230	228	216	2	\N	227	f	0	None	0
56	Floppy Disk	2017-11-08 18:07:49.477787-05	2017-11-08 18:08:07.830702-05	A floppy disk, also called a floppy, diskette, or just disk, is a type of disk storage composed of a disk of thin and flexible magnetic storage medium, sealed in a rectangular plastic enclosure lined with fabric that removes dust particles. Floppy disks are read and written by a floppy disk drive.	http://localhost.com	12	floppy_disk	\N	They got destroyed by USB drives later on.	Must have floppy disk drive	APPROVED	t	f	3.20000000000000018	4	1	0	2	1	0	4	t	UNCLASSIFIED	f	8	233	\N	234	232	220	3	\N	231	f	0	None	0
57	Formula	2017-11-08 18:07:49.560816-05	2017-11-08 18:07:49.560825-05	A formula is a concise way of expressing information symbolically, as in a mathematical or chemical formula. The informal use of the term formula in science refers to the general construct of a relationship between given quantities. The plural of formula can be spelled either as formulas or formulae	https://en.wikipedia.org/wiki/Formula	8.1.9	formula	When the chemical compound of the formula consists of simple molecules, chemical formulas often employ ways to suggest the structure of the molecule. There are several types of these formulas, including molecular formulas and condensed formulas	A formula is a concise way of expressing information symbolically	Expressions are distinct from formulas in that they cannot contain an equals sign (=). Whereas formulas are comparable to sentences, expressions are more like phrases.	APPROVED	t	f	0	0	0	0	0	0	0	0	t	UNCLASSIFIED	f	2	237	\N	238	236	224	2	\N	235	f	0	None	0
58	FrameIt	2017-11-08 18:07:49.640934-05	2017-11-08 18:07:49.640943-05	Show things in an iframe	https://localhost:8443/demo_apps/frameit/index.html	1.0.0	ozp.test.frameit	Nothing really new here	Its an iframe	None	APPROVED	t	t	0	0	0	0	0	0	0	0	f	UNCLASSIFIED	f	1	241	\N	242	240	228	3	\N	239	f	0	None	0
59	Gallery of Maps	2017-11-08 18:07:49.816662-05	2017-11-08 18:08:07.889812-05	Featured pictures/Non-photographic media/Maps\nGallery of Maps\nThis page is a gallery of featured pictures that the community has chosen to be highlighted as some of the finest on Commons.\n\nContents  \n1\t  Gallery of Maps\n2\tMaps\n2.1\tMaps of Africa\n2.2\tMaps of Asia\n2.3\tMaps of the Caribbean\n2.4\tMaps of Europe\n2.5\tMaps of North America\n2.6\tMaps of Oceania\n2.7\tMaps of South America\n2.8\tOthers maps\n3\tUnsorted	https://commons.wikimedia.org/wiki/Commons:Featured_pictures/Non-photographic_media/Maps	1.0	gallery_of_maps	\N	Commons:Featured pictures/Non-photographic media/Maps	None	APPROVED	t	f	3.5	2	0	1	1	0	0	2	t	UNCLASSIFIED	f	4	245	\N	246	244	232	5	\N	243	f	0	None	0
60	Gerris	2017-11-08 18:07:49.872044-05	2017-11-08 18:07:49.872053-05	Gerris is computer software in the field of computational fluid dynamics (CFD). Gerris was released as free and open-source software, subject to the usage_requirements of the GNU General Public License (GPL), version 2 or any later.	https://en.wikipedia.org/wiki/Gerris_%28software%29	3d	gerris	\N	Gerris is computer software in the field of computational fluid dynamics (CFD).	None	APPROVED	t	f	0	0	0	0	0	0	0	0	t	UNCLASSIFIED	f	3	249	\N	250	248	236	1	\N	247	f	0	None	0
66	Hatch Latch	2017-11-08 18:07:50.251972-05	2017-11-08 18:07:50.25199-05	Hatch latches	https://localhost:8443/demo_apps/centerSampleListings/hatchLatch/index.html	1.0.0	ozp.test.hatchlatch	Nothing really new here	Its a hatch latch	None	APPROVED	t	t	0	0	0	0	0	0	0	0	f	UNCLASSIFIED	f	1	273	\N	274	272	262	3	\N	271	f	0	None	0
61	Global Navigation Grid Code	2017-11-08 18:07:49.930416-05	2017-11-08 18:08:07.949932-05	From Wikipedia, the free encyclopedia The Global Navigation Grid Code (GNGC) is a Chinese-developed point reference system designed for global navigation. It is similar in design to national grid reference systems used throughout the world. GNGC was based upon the work of the GeoSOT team, headquartered in the Institute of Remote Sensing and GIS, Peking University. The concept for this system was proposed in 2015 in Bin Li's dissertation: Navigation Computing Model of Global Navigation Grid Code. GNGC allows easy calculation of space and spatial indexes and can be extended to the provide navigation mesh coding. Along with the Beidou navigation system, GNGC provides independent intellectual property rights, globally applicable standards and global navigation trellis code.	https://en.wikipedia.org/wiki/Global_Navigation_Grid_Code	1.0	global_navigation_grid_code	\N	The Global Navigation Grid Code (GNGC) is a reference system designed for global navigation	None	APPROVED	t	f	5	2	2	0	0	0	0	2	t	UNCLASSIFIED	f	4	253	\N	254	252	240	4	\N	251	f	0	None	0
62	Gramophone record	2017-11-08 18:07:50.012466-05	2017-11-08 18:07:50.012474-05	A gramophone record (phonograph record in the US), commonly known as a vinyl record or simply vinyl or record, is an analog sound storage medium in the form of a flat polyvinyl chloride (previously shellac) disc with an inscribed, modulated spiral groove. The groove usually starts near the periphery and ends near the center of the disc.\n\nThe phonograph disc record was the primary medium used for music reproduction until late in the 20th century. It had co-existed with the phonograph cylinder from the late 1880s and replaced it by the late 1920s. Records retained the largest market share even when new formats such as compact cassette were mass-marketed. By the late 1980s, digital media, in the form of the compact disc, had gained a larger market share, and the vinyl record left the mainstream in 1991. From the 1990s to the 2010s, records continued to be manufactured and sold on a much smaller scale, and were especially used by disc jockeys (DJs), released by artists in some genres, and listened to by a niche market of audiophiles. The phonograph record has made a niche resurgence in the early 21st century - 9.2 million records were sold in the U.S. in 2014, a 260% increase since 2009. Likewise, in the UK sales have increased five-fold from 2009 to 2014.	https://en.wikipedia.org/wiki/Gramophone_record	45	gramophone_record	\N	A gramophone record (phonograph record in the US), commonly known as a vinyl record.	Record player	APPROVED	t	f	0	0	0	0	0	0	0	0	t	UNCLASSIFIED	f	5	257	\N	258	256	244	5	\N	255	f	0	None	0
63	Grandfather clock	2017-11-08 18:07:50.047502-05	2017-11-08 18:07:50.04751-05	A longcase clock, also tall-case clock, floor clock, or grandfather clock, is a tall, freestanding, weight-driven pendulum clock with the pendulum held inside the tower or waist of the case. Clocks of this style are commonly 1.8-2.4 metres (6-8 feet) tall. The case often features elaborately carved ornamentation on the hood (or bonnet), which surrounds and frames the dial, or clock face. The English clockmaker William Clement is credited with the development of this form in 1670. Until the early 20th century, pendulum clocks were the world's most accurate timekeeping technology, and longcase clocks, due to their superior accuracy, served as time standards for households and businesses. Today they are kept mainly for their decorative and antique value.	https://en.wikipedia.org/wiki/Longcase_clock	1	grandfather_clock	Traditionally, longcase clocks were made with two types of movement: eight-day and one-day (30-hour) movements. A clock with an eight-day movement required winding only once a week, while generally less expensive 30-hour clocks had to be wound every day.	A longcase clock, also tall-case clock, floor clock, or grandfather clock.	none	APPROVED	t	f	0	0	0	0	0	0	0	0	t	UNCLASSIFIED	f	1	261	\N	262	260	248	2	\N	259	f	0	None	0
64	Great white shark	2017-11-08 18:07:50.117575-05	2017-11-08 18:08:08.010824-05	The great white shark (Carcharodon carcharias), also known as the great white, white pointer, white shark, or white death, is a species of large mackerel shark which can be found in the coastal surface waters of all the major oceans. The great white shark is notable for its size, with larger female individuals growing to 6.1 m (20 ft) in length and 1,950 kg (4,300 lb) in weight at maturity. However most are smaller, males measuring 3.4 to 4.0 m (11 to 13 ft) and females 4.6 to 4.9 m (15 to 16 ft) on average. According to a 2014 study the lifespan of great white sharks is estimated to be as long as 70 years or more, well above previous estimates, making it one of the longest lived cartilaginous fish currently known. According to the same study, male great white sharks take 26 years to reach sexual maturity, while the females take 33 years to be ready to produce offspring. Great white sharks can swim at speeds of over 56 km/h (35 mph), and can swim to depths of 1,200 m (3,900 ft).	https://en.wikipedia.org/wiki/Great_white_shark	10.1.9	great_white_shark	The great white shark has no known natural predators other than, on very rare occasion, the killer whale.	The great white shark has a robust, large, conical snout.	Great white sharks live in almost all coastal and offshore waters which have water temperature between 12 and 24 °C (54 and 75 °F), with greater concentrations in the United States (Northeast and California), South Africa, Japan, Oceania, Chile, and the Mediterranean. One of the densest known populations is found around Dyer Island, South Africa.	APPROVED	t	f	4	2	1	0	1	0	0	2	t	UNCLASSIFIED	f	3	265	\N	266	264	252	3	\N	263	f	0	None	0
65	Harley-Davidson CVO	2017-11-08 18:07:50.174744-05	2017-11-08 18:08:08.04196-05	Harley-Davidson CVO (for Custom Vehicle Operations) motorcycles are a family of models created by Harley-Davidson for the factory custom market. For every model year since the program's inception in 1999, Harley-Davidson has chosen a small selection of its mass-produced motorcycle models and created limited-edition customizations of those platforms with larger-displacement engines, costlier paint designs, and additional accessories not found on the mainstream models. Special features for the CVO lineup have included performance upgrades from Harley's "Screamin' Eagle" branded parts, hand-painted pinstripes, ostrich leather on seats and trunks, gold leaf incorporated in the paint, and electronic accessories like GPS navigation systems and iPod music players.\nCVO models are produced in Harley-Davidson's York, Pennsylvania plant, where touring and Softail models are also manufactured. In each model year, CVO models feature larger-displacement engines than the mainstream models, and these larger-displacement engines make their way into the normal "big twin" line within a few years when CVO models are again upgraded. Accessories created for these customized units are sometimes offered in the Harley-Davidson accessory catalog for all models in later years, but badging and paint are kept exclusively for CVO model owners, and cannot be replaced without providing proof of ownership to the ordering dealer	https://en.wikipedia.org/wiki/Harley-Davidson_CVO	2	harley-davidson_cvo	CVO 125 big bore motors	CVOs are fast and loud.	None	APPROVED	t	t	3	1	0	0	1	0	0	1	t	UNCLASSIFIED	f	1	269	\N	270	268	258	1	\N	267	f	0	None	0
67	Hawaii	2017-11-08 18:07:50.373472-05	2017-11-08 18:08:08.133839-05	Hawaii is the only U.S. state located in Oceania and the only one composed entirely of islands. It is the northernmost island group in Polynesia, occupying most of an archipelago in the central Pacific Ocean. Hawaii is the only U.S. state located outside North America.	http://localhost.com	1	hawaii	\N	Hawaii is the 50th and most recent state to have joined the United States of America.	None	APPROVED	t	f	4	3	1	1	1	0	0	3	t	UNCLASSIFIED	f	2	277	\N	278	276	266	3	\N	275	f	0	None	0
68	House Lannister	2017-11-08 18:07:50.48051-05	2017-11-08 18:08:08.164372-05	This is a full description of House Lannister	http://www.google.com	v5.0	house_lannister	\N	This is a short description of House Lannister	none	APPROVED	t	f	1	1	0	0	0	0	1	1	t	UNCLASSIFIED	f	2	281	\N	282	280	270	3	\N	279	f	0	None	0
69	House Stark	2017-11-08 18:07:51.2381-05	2017-11-08 18:08:08.224657-05	Full Description of House Stark and members	http://www.google.com	v6.0	house_stark	\N	Short Description of House Stark and members	none	APPROVED	t	f	2.5	2	0	1	0	0	1	2	t	UNCLASSIFIED	f	1	285	\N	286	284	274	3	\N	283	f	0	None	0
70	House Targaryen	2017-11-08 18:07:51.313949-05	2017-11-08 18:08:08.255612-05	House Targaryen is a former Great House of Westeros and was the ruling royal House of the Seven Kingdoms for three centuries since it conquered and unified the realm, before it was deposed during Robert's Rebellion and House Baratheon replaced it as the new royal House. The few surviving Targaryens fled into exile to the Free Cities of Essos across the Narrow Sea. Currently based on Dragonstone off of the eastern coast of Westeros, House Targaryen seeks to retake the Seven Kingdoms from House Lannister, who formally replaced House Baratheon as the royal House following the destruction of the Great Sept of Baelor.	http://gameofthrones.wikia.com/wiki/House_Targaryen	11	house_targaryen	Now seeking allies to take down the false rulers of Westeros	The rightful rulers of Westeros. Currently in exile after betrayal by kingsmen.	None	APPROVED	t	f	5	1	1	0	0	0	0	1	t	UNCLASSIFIED	f	1	289	\N	290	288	278	4	\N	287	f	0	None	0
71	Huexotzinco Codex	2017-11-08 18:07:51.37979-05	2017-11-08 18:07:51.379801-05	The Huexotzinco Codex or Huejotzingo Codex is a colonial-era Nahua pictorial manuscript, collectively known as Aztec codices. The Huexotzinco Codex eight-sheet document on amatl, a pre-European paper made in Mesoamerica. It is part of the testimony in a legal case against members of the First Audiencia (high court) in Mexico, particularly its president, Nuño de Guzmán, ten years after the Spanish conquest in 1521. Huexotzinco, (Way-hoat-ZINC-o) is a town southeast of Mexico City, in the state of Puebla. In 1521, the Nahua Indian people of the town were the allies of the Spanish conqueror Hernán Cortes, and together they confronted their enemies to overcome Moctezuma, leader of the Aztec Empire. Cortes's indigenous allies from Tlaxcala were more successful than those Huejotzinco in translating that alliance into privileges in the colonial era and the Huejotzincan's petitioned the crown for such privileges. A 1560 petition to the crown in Nahuatl outlines their participation.	https://en.wikipedia.org/wiki/Huexotzinco_Codex	1	huexotzinco_codex	\N	The Huexotzinco Codex or Huejotzingo Codex is a colonial-era Nahua pictorial manuscript.	None	APPROVED	t	f	0	0	0	0	0	0	0	0	t	UNCLASSIFIED//FOR OFFICIAL USE ONLY	f	9	293	\N	294	292	282	1	\N	291	f	0	None	0
72	India Pale Ale	2017-11-08 18:07:51.414295-05	2017-11-08 18:07:51.414305-05	India pale ale (IPA) is a hoppy beer style within the broader category of pale ale. It has also been referred to as pale ale as prepared for India, India ale, pale India ale, or pale export India ale.\nThe term pale ale originally denoted an ale that had been brewed from pale malt. Among the first brewers known to export beer to India was George Hodgson's Bow Brewery, on the Middlesex-Essex border. Bow Brewery beers became popular among East India Company traders in the late 18th century because of the brewery's location near the East India Docks. Demand for the export style of pale ale, which had become known as India pale ale, developed in England around 1840 and it later became a popular product there. IPAs have a long history in Canada and the United States, and many breweries there produce a version of the style.	https://en.wikipedia.org/wiki/India_pale_ale	12	india_pale_ale	\N	India pale ale (IPA) is a hoppy beer style.	None	APPROVED	t	f	0	0	0	0	0	0	0	0	t	UNCLASSIFIED	f	1	297	\N	298	296	286	2	\N	295	f	0	None	0
73	Informational Book	2017-11-08 18:07:51.490912-05	2017-11-08 18:08:08.286796-05	The Wikimedia Foundation, Inc. is a nonprofit charitable organization dedicated to encouraging the growth, development and distribution of free, multilingual, educational content, and to providing the full content of these wiki-based projects to the public free of charge. The Wikimedia Foundation operates some of the largest collaboratively edited reference projects in the world, including Wikipedia, a top-ten internet property.\nImagine a world in which every single human being can freely share in the sum of all knowledge. That’s our commitment	https://wikimediafoundation.org/wiki/Home	1.0.5	informational_book	The annual plan documents the Foundation's 2016-17 financial plan, strategic targets, activities, and staffing overview.	The Free Encyclopedia	The Wikimedia Foundation relies heavily on the generous support from our users. Please consider making a donation today, be it time or money.\nThe Wikimedia Foundation is incorporated as a 501(c)(3) nonprofit organization in the United States, and donations from US citizens are tax deductible. Donations made by citizens of other countries may also be tax deductible. Please see deductibility of donations for details. Please see our fundraising page for details of making donations via credit card, PayPal, postal mail or direct deposit. For all other types of donations, please contact us.	APPROVED	t	f	5	1	1	0	0	0	0	1	t	UNCLASSIFIED//FOR OFFICIAL USE ONLY	f	2	301	\N	302	300	290	3	\N	299	f	0	None	0
127	Piano	2017-11-08 18:07:56.761948-05	2017-11-08 18:07:56.761959-05	piano is an acoustic, stringed musical instrument invented around the year 1700 (the exact year is uncertain), in which the strings are struck by hammers	https://en.wikipedia.org/wiki/Piano	10.8	piano	Most modern pianos have a row of 88 black and white keys	Acoustic, Stringed Musical Instrument	52 white keys for the notes of the C major scale (C, D, E, F, G, A and B) and 36 shorter black keys	APPROVED	t	f	0	0	0	0	0	0	0	0	t	UNCLASSIFIED	f	2	517	\N	518	516	506	3	\N	515	f	0	None	0
74	Intelligence Unleashed	2017-11-08 18:07:51.901525-05	2017-11-08 18:07:51.901534-05	Business Intelligence (BI) comprises the strategies and technologies used by enterprises for the data analysis of business information. BI technologies provide historical, current and predictive views of business operations. Common functions of business intelligence technologies include reporting, online analytical processing, analytics, data mining, process mining, complex event processing, business performance management, benchmarking, text mining, predictive analytics and prescriptive analytics. BI technologies can handle large amounts of structured and sometimes unstructured data to help identify, develop and otherwise create new strategic business opportunities. They aim to allow for the easy interpretation of these big data. Identifying new opportunities and implementing an effective strategy based on insights can provide businesses with a competitive market advantage and long-term stability.	http://bi.com	2.0	intelligence_unleashed	\N	Business Intelligence (BI) comprises the strategies and technologies used by enterprises.	None	APPROVED	t	f	0	0	0	0	0	0	0	0	t	UNCLASSIFIED	f	1	305	\N	306	304	294	2	\N	303	f	0	None	0
75	Intelligent transportation system	2017-11-08 18:07:52.004221-05	2017-11-08 18:07:52.00423-05	From Wikipedia, the free encyclopedia\nAn intelligent transportation system (ITS) is an advanced application which, without embodying intelligence as such, aims to provide innovative services relating to different modes of transport and traffic management and enable various users to be better informed and make safer, more coordinated, and 'smarter' use of transport networks.\nAlthough ITS may refer to all modes of transport, the directive of the European Union 2010/40/EU, made on the 7 July, 2010, defined ITS as systems in which information and communication technologies are applied in the field of road transport, including infrastructure, vehicles and users, and in traffic management and mobility management, as well as for interfaces with other modes of transport.	https://en.wikipedia.org/wiki/Intelligent_transportation_system	1.5	intelligent_transportation_system	\N	An intelligent transportation system (ITS) is an advanced application	None	APPROVED	t	f	0	0	0	0	0	0	0	0	t	UNCLASSIFIED	f	4	309	\N	310	308	298	3	\N	307	f	0	None	0
76	Internet meme	2017-11-08 18:07:52.103984-05	2017-11-08 18:07:52.103993-05	An Internet meme (/miːm/ MEEM)  is an activity, concept, catchphrase or piece of media which spreads, often as mimicry or for humorous purposes, from person to person via the Internet. An Internet meme may also take the form of an image (typically an image macro), hyperlink, video, website, or hashtag. It may be just a word or phrase, sometimes including an intentional misspelling. These small movements tend to spread from person to person via social networks, blogs, direct email, or news sources. They may relate to various existing Internet cultures or subcultures, often created or spread on various websites, or by Usenet boards and other such early-internet communications facilities. Fads and sensations tend to grow rapidly on the Internet, because the instant communication facilitates word-of-mouth transmission. Some examples include posting a photo of people lying down in public places (called "planking") and uploading a short video of people dancing to the Harlem Shake.	https://en.wikipedia.org/wiki/Internet_meme	1	internet_meme	\N	An Internet meme is a piece of media which spreads, often as mimicry or for humorous purposes	A funny bone	APPROVED	t	f	0	0	0	0	0	0	0	0	t	UNCLASSIFIED	f	3	313	\N	314	312	302	3	\N	311	f	0	None	0
77	Iron Man	2017-11-08 18:07:52.150267-05	2017-11-08 18:08:08.377456-05	Iron Man (Tony Stark) is a fictional superhero appearing in American comic books published by Marvel Comics. The character was created by writer and editor Stan Lee, developed by scripter Larry Lieber, and designed by artists Don Heck and Jack Kirby. The character made his first appearance in Tales of Suspense #39 (cover dated March 1963).\nA wealthy American business magnate, playboy, and ingenious scientist, Tony Stark suffers a severe chest injury during a kidnapping in which his captors attempt to force him to build a weapon of mass destruction. He instead creates a powered suit of armor to save his life and escape captivity. Later, Stark augments his suit with weapons and other technological devices he designed through his company, Stark Industries. He uses the suit and successive versions to protect the world as Iron Man, while at first concealing his true identity. Initially, Iron Man was a vehicle for Stan Lee to explore Cold War themes, particularly the role of American technology and business in the fight against communism. Subsequent re-imaginings of Iron Man have transitioned from Cold War themes to contemporary concerns, such as corporate crime and terrorism.\nThroughout most of the character's publication history, Iron Man has been a founding member of the superhero team the Avengers and has been featured in several incarnations of his own various comic book series. Iron Man has been adapted for several animated TV shows and films. The character is portrayed by Robert Downey Jr. in the live action film Iron Man (2008), which was a critical and box office success. Downey, who received much acclaim for his performance, reprised the role in a cameo in The Incredible Hulk (2008), two Iron Man sequels Iron Man 2 (2010) and Iron Man 3 (2013), The Avengers (2012), Avengers: Age of Ultron (2015), Captain America: Civil War (2016), and Spider-Man: Homecoming (2017), and will do so again in Avengers: Infinity War (2018) and its untitled sequel (2019) in the Marvel Cinematic Universe.\nIron Man was ranked 12th on IGN's "Top 100 Comic Book Heroes" in 2011, and third in their list of "The Top 50 Avengers" in 2012.	https://en.wikipedia.org/wiki/Iron_Man	1	iron_man	\N	pew pew pew	None	APPROVED	t	f	4.29999999999999982	3	2	0	1	0	0	3	t	UNCLASSIFIED	f	2	317	\N	318	316	306	1	\N	315	f	0	None	0
78	Jar of Flies	2017-11-08 18:07:52.222823-05	2017-11-08 18:08:08.407652-05	Jar of Flies is the second studio EP by the American rock band Alice in Chains, released on January 25, 1994 through Columbia Records. It is the first EP in music history to debut at number one on the Billboard 200 Chart with the first week sales exceeding 141,000 copies in the United States and was well received by critics. The EP has since been certified triple-platinum by the RIAA and has gone on to sell 4 million copies worldwide,[citation needed] making Jar of Flies one of the biggest sellers in Alice in Chains' catalog.	https://en.wikipedia.org/wiki/Jar_of_Flies	1.994	jar_of_flies	\N	Jar of Flies is the second studio EP by the American rock band Alice in Chains	None	APPROVED	t	f	3	1	0	0	1	0	0	1	t	UNCLASSIFIED//FOR OFFICIAL USE ONLY	f	3	321	\N	322	320	310	3	\N	319	f	0	None	0
79	Jasoom	2017-11-08 18:07:52.339018-05	2017-11-08 18:08:08.470764-05	Earth is the third planet from the Sun and the only object in the Universe known to harbor life. According to radiometric dating and other sources of evidence, Earth formed over 4 billion years ago. Earth's gravity interacts with other objects in space, especially the Sun and the Moon, Earth's only natural satellite. During one orbit around the Sun, Earth rotates about its axis about 365.26 times; thus, an Earth year is about 365.26 days long.[n 5]\nEarth's axis of rotation is tilted, producing seasonal variations on the planet's surface. The gravitational interaction between the Earth and Moon causes ocean tides, stabilizes the Earth's orientation on its axis, and gradually slows its rotation. Earth is the densest planet in the Solar System and the largest of the four terrestrial planets.\nEarth's lithosphere is divided into several rigid tectonic plates that migrate across the surface over periods of many millions of years. About 71% of Earth's surface is covered with water, mostly by its oceans. The remaining 29% is land consisting of continents and islands that together have many lakes, rivers and other sources of water that contribute to the hydrosphere. The majority of Earth's polar regions are covered in ice, including the Antarctic ice sheet and the sea ice of the Arctic ice pack. Earth's interior remains active with a solid iron inner core, a liquid outer core that generates the Earth's magnetic field, and a convecting mantle that drives plate tectonics.\nWithin the first billion years of Earth's history, life appeared in the oceans and began to affect the Earth's atmosphere and surface, leading to the proliferation of aerobic and anaerobic organisms. Some geological evidence indicates that life may have arisen as much as 4.1 billion years ago. Since then, the combination of Earth's distance from the Sun, physical properties, and geological history have allowed life to evolve and thrive. In the history of the Earth, biodiversity has gone through long periods of expansion, occasionally punctuated by mass extinction events. Over 99% of all species that ever lived on Earth are extinct. Estimates of the number of species on Earth today vary widely; most species have not been described. Over 7.4 billion humans live on Earth and depend on its biosphere and minerals for their survival. Humans have developed diverse societies and cultures; politically, the world has about 200 sovereign states.	https://en.wikipedia.org/wiki/Earth	1.0	jasoom	\N	Earth is the third planet from the Sun and the only object in the Universe known to harbor life.	Requires the internet.	APPROVED	t	f	3.5	2	1	0	0	1	0	2	t	UNCLASSIFIED	f	3	325	\N	326	324	314	3	\N	323	f	0	None	0
82	JotSpot	2017-11-08 18:07:52.567224-05	2017-11-08 18:08:08.623484-05	Jot things down	https://localhost:8443/demo_apps/centerSampleListings/jotSpot/index.html	1.0.0	ozp.test.jotspot	Nothing really new here	Jot stuff down	None	APPROVED	t	t	4	1	0	1	0	0	0	1	f	UNCLASSIFIED	f	1	337	\N	338	336	326	3	\N	335	f	0	None	0
80	Jay and Silent Bob Strike Back	2017-11-08 18:07:52.380834-05	2017-11-08 18:08:08.500854-05	Jay and Silent Bob Strike Back is a 2001 American comedy film written and directed by Kevin Smith, the fifth to be set in his View Askewniverse, a growing collection of characters and settings that developed out of his cult favorite Clerks. It focuses on the two eponymous characters, played respectively by Jason Mewes and Smith. The film features a large number of cameo appearances by famous actors and directors, and its title and logo for Jay and Silent Bob Strike Back are direct references to The Empire Strikes Back.\nOriginally intended to be the last film set in the Askewniverse, or to feature Jay and Silent Bob, Strike Back features many characters from the previous Askew films, some in dual roles and reprising roles from the previous entries. The film was a minor commercial success, grossing $33.8 million worldwide from a $22 million budget, and received mixed reviews from critics.\nFive years later and following the commercial failure of Jersey Girl, Smith reconsidered and decided to continue the series with Clerks II, resurrecting Jay and Silent Bob in supporting roles. Smith announced in February 2017 that he was writing a sequel called Jay and Silent Bob Reboot and hoped to start filming in summer 2017.	https://en.wikipedia.org/wiki/Jay_and_Silent_Bob_Strike_Back	20.01	jay_and_silent_bob_strike_back	\N	Jay and Silent Bob Strike Back is a 2001 American comedy film written and directed by Kevin Smith.	Pop culture knowledge	APPROVED	t	f	1	1	0	0	0	0	1	1	t	UNCLASSIFIED//FOR OFFICIAL USE ONLY	f	9	329	\N	330	328	318	5	\N	327	f	0	None	0
88	Komodo Dragon	2017-11-08 18:07:53.09742-05	2017-11-08 18:08:08.838403-05	The Komodo dragon (Varanus komodoensis), also known as the Komodo monitor, is a large species of lizard found in the Indonesian islands of Komodo, Rinca, Flores, Gili Motang, and Padar. A member of the monitor lizard family Varanidae, it is the largest living species of lizard, growing to a maximum length of 3 metres (10 ft) in rare cases and weighing up to approximately 70 kilograms (150 lb).\nTheir unusually large size has been attributed to island gigantism, since no other carnivorous animals fill the niche on the islands where they live. However, recent research suggests the large size of Komodo dragons may be better understood as representative of a relict population of very large varanid lizards that once lived across Indonesia and Australia, most of which, along with other megafauna, died out after the Pleistocene. Fossils very similar to V. komodoensis have been found in Australia dating to greater than 3.8 million years ago, and its body size remained stable on Flores, one of the handful of Indonesian islands where it is currently found, over the last 900,000 years, "a time marked by major faunal turnovers, extinction of the island's megafauna, and the arrival of early hominids by 880 ka [kiloannums]."\nAs a result of their size, these lizards dominate the ecosystems in which they live. Komodo dragons hunt and ambush prey including invertebrates, birds, and mammals. It has been claimed that they have a venomous bite; there are two glands in the lower jaw which secrete several toxic proteins. The biological significance of these proteins is disputed, but the glands have been shown to secrete an anticoagulant. Komodo dragon group behaviour in hunting is exceptional in the reptile world. The diet of big Komodo dragons mainly consists of deer, though they also eat considerable amounts of carrion. Komodo dragons also occasionally attack humans.\nMating begins between May and August, and the eggs are laid in September. About 20 eggs are deposited in abandoned megapode nests or in a self-dug nesting hole. The eggs are incubated for seven to eight months, hatching in April, when insects are most plentiful. Young Komodo dragons are vulnerable and therefore dwell in trees, safe from predators and cannibalistic adults. They take 8 to 9 years to mature, and are estimated to live up to 30 years.\nKomodo dragons were first recorded by Western scientists in 1910. Their large size and fearsome reputation make them popular zoo exhibits. In the wild, their range has contracted due to human activities, and they are listed as vulnerable by the IUCN. They are protected under Indonesian law, and a national park, Komodo National Park, was founded to aid protection efforts.	https://en.wikipedia.org/wiki/Komodo_dragon	1	komodo_dragon	\N	A huge lizard!	None	APPROVED	t	f	1	1	0	0	0	0	1	1	t	UNCLASSIFIED	f	1	361	\N	362	360	350	2	\N	359	f	0	None	0
81	Jean Grey	2017-11-08 18:07:52.457279-05	2017-11-08 18:08:08.590471-05	Jean Grey-Summers (born Jean Elaine Grey) is a fictional superhero appearing in American comic books published by Marvel Comics. The character has been known under the aliases Marvel Girl, Phoenix, and Dark Phoenix. Created by writer Stan Lee and artist Jack Kirby, the character first appeared in The X-Men #1 (September 1963).\nJean Grey is a member of a subspecies of humans known as mutants, who are born with superhuman abilities. She was born with telepathic and telekinetic powers. Her powers first manifested when she saw her childhood friend being hit by a car. She is a caring, nurturing figure, but she also has to deal with being an Omega-level mutant and the physical manifestation of the cosmic Phoenix Force. Jean Grey experienced a transformation into the Phoenix in the X-Men storyline "The Dark Phoenix Saga". She has faced death numerous times in the history of the series. Her first death was under her guise as Marvel Girl, when she died and was "reborn" as Phoenix in "The Dark Phoenix Saga". This transformation led to her second death, which was suicide, though not her last.\nShe is an important figure in the lives of other Marvel Universe characters, mostly the X-Men, including her husband Cyclops, her mentor and father figure Charles Xavier, her unrequited love interest Wolverine, her best friend and sister-like figure Storm, and her genetic children Rachel Summers, X-Man, Cable, and Stryfe.\nThe character was present for much of the X-Men's history, and she was featured in all three X-Men animated series and several video games. She is a playable character in X-Men Legends (2004), X-Men Legends II: Rise of Apocalypse (2005), Marvel Ultimate Alliance 2 (2009), Marvel vs Capcom 3: Fate of Two Worlds (2011), Marvel Heroes (2013), and Lego Marvel Super Heroes (2013), and appeared as a non-playable in the first Marvel: Ultimate Alliance.\nFamke Janssen portrayed the character in five installments of the X-Men films. Sophie Turner portrays a younger version in the 2016 film X-Men: Apocalypse.\nIn 2006, IGN rated Jean Grey 6th on their list of top 25 X-Men from the past forty years, and in 2011, IGN ranked her 13th in the "Top 100 Comic Book Heroes". Her Dark Phoenix persona was ranked 9th in IGN's "Top 100 Comic Book Villains of All Time" list, the highest rank for a female character.	https://en.wikipedia.org/wiki/Jean_Grey	1	jean_grey	\N	Dies a lot	None	APPROVED	t	f	4.29999999999999982	3	2	0	1	0	0	3	t	UNCLASSIFIED	f	2	333	\N	334	332	322	2	\N	331	f	0	None	0
83	Jupiter	2017-11-08 18:07:52.664867-05	2017-11-08 18:08:08.717464-05	Jupiter is the fifth planet from the Sun and the largest in the Solar System. It is a giant planet with a mass one-thousandth that of the Sun, but two and a half times that of all the other planets in the Solar System combined. Jupiter and Saturn are gas giants; the other two giant planets, Uranus and Neptune are ice giants. Jupiter has been known to astronomers since antiquity. The Romans named it after their god Jupiter. When viewed from Earth, Jupiter can reach an apparent magnitude of −2.94, bright enough for its reflected light to cast shadows, and making it on average the third-brightest object in the night sky after the Moon and Venus.\n\nJupiter is primarily composed of hydrogen with a quarter of its mass being helium, though helium comprises only about a tenth of the number of molecules. It may also have a rocky core of heavier elements, but like the other giant planets, Jupiter lacks a well-defined solid surface. Because of its rapid rotation, the planet's shape is that of an oblate spheroid (it has a slight but noticeable bulge around the equator). The outer atmosphere is visibly segregated into several bands at different latitudes, resulting in turbulence and storms along their interacting boundaries. A prominent result is the Great Red Spot, a giant storm that is known to have existed since at least the 17th century when it was first seen by telescope. Surrounding Jupiter is a faint planetary ring system and a powerful magnetosphere. Jupiter has at least 69 moons, including the four large Galilean moons discovered by Galileo Galilei in 1610. Ganymede, the largest of these, has a diameter greater than that of the planet Mercury.\n\nJupiter has been explored on several occasions by robotic spacecraft, most notably during the early Pioneer and Voyager flyby missions and later by the Galileo orbiter. In late February 2007, Jupiter was visited by the New Horizons probe, which used Jupiter's gravity to increase its speed and bend its trajectory en route to Pluto. The latest probe to visit the planet is Juno, which entered into orbit around Jupiter on July 4, 2016. Future targets for exploration in the Jupiter system include the probable ice-covered liquid ocean of its moon Europa.	https://en.wikipedia.org/wiki/Jupiter	1.0	jupiter	\N	Jupiter is the fifth planet from the Sun and the largest in the Solar System.	Requires the internet.	APPROVED	t	f	4	2	1	0	1	0	0	2	t	UNCLASSIFIED	f	3	341	\N	342	340	330	3	\N	339	f	0	None	0
84	KIAA0319	2017-11-08 18:07:52.702506-05	2017-11-08 18:07:52.702517-05	KIAA0319 is a protein which in humans is encoded by the KIAA0319 gene.\nVariants of the KIAA0319 gene have been associated with developmental dyslexia.\nReading disability, or dyslexia, is a major social, educational, and mental health problem. In spite of average intelligence and adequate educational opportunities, 5 to 10% of school children have substantial reading deficits. Twin and family studies have shown a substantial genetic component to this disorder, with heritable variation estimated at 50 to 70%.\nAn NIDCD-supported investigator recently has identified a mutation in a gene on chromosome 6, called the KIAA0319 gene, that appears to play a key role in Specific Language Impairment.	https://en.wikipedia.org/wiki/KIAA0319	KIAA0319	kiaa0319	\N	KIAA0319 is a protein which in humans is encoded by the KIAA0319 gene	None	APPROVED	t	f	0	0	0	0	0	0	0	0	t	UNCLASSIFIED	f	3	345	\N	346	344	334	5	\N	343	f	0	None	0
85	KSnapshot	2017-11-08 18:07:52.80172-05	2017-11-08 18:07:52.801729-05	KSnapshot is a screenshot application for the KDE desktop environment developed by Richard J. Moore, Matthias Ettrich and Aaron J. Seigo. The screenshots taken by KSnapshot are also called snapshots, which explains its name. It is written in Qt and C++. KSnapshot allows users to use hotkeys to take a screenshot.\nIn December 2015, KSnapshot has been replaced by Spectacle.	https://en.wikipedia.org/wiki/KSnapshot	0.8.1	ksnapshot	\N	KSnapshot is a screenshot application	KDE	APPROVED	t	f	0	0	0	0	0	0	0	0	t	UNCLASSIFIED	f	7	349	\N	350	348	338	2	\N	347	f	0	None	0
86	Karta GPS	2017-11-08 18:07:52.908238-05	2017-11-08 18:07:52.908248-05	Karta GPS is a mobile application developed by Karta Software Technologies Lda a daughter company of NDrive for the Android and iOS operating systems. It is distributed for free and pairs open-source map data from OpenStreetMap alongside curated content from Yelp and Foursquare.\nThe application does not require connection to Internet data (e.g. 3G, 4G, WiFi, etc.) and uses a GPS satellite connection to determine its location. Routes are calculated and plotted based on real-time traffic information provided by Inrix.	https://en.wikipedia.org/wiki/Karta_GPS	1.0	karta_gps	\N	Karta GPS is a mobile app developed by Karta Software Technologies Lda a daughter company of NDrive	None	APPROVED	t	f	0	0	0	0	0	0	0	0	t	UNCLASSIFIED	f	4	353	\N	354	352	342	1	\N	351	f	0	None	0
87	Killer Whale	2017-11-08 18:07:53.000456-05	2017-11-08 18:08:08.800214-05	The killer whale or orca (Orcinus orca) is a toothed whale belonging to the oceanic dolphin family, of which it is the largest member. Killer whales have a diverse diet, although individual populations often specialize in particular types of prey. Some feed exclusively on fish, while others hunt marine mammals such as seals and dolphins. They have been known to attack baleen whale calves, and even adult whales. Killer whales are apex predators, as there is no animal that preys on them. Killer whales are considered a cosmopolitan species, and can be found in each of the world's oceans in a variety of marine environments, from Arctic and Antarctic regions to tropical seas.\nKiller whales are highly social; some populations are composed of matrilineal family groups (pods) which are the most stable of any animal species. Their sophisticated hunting techniques and vocal behaviours, which are often specific to a particular group and passed across generations, have been described as manifestations of animal culture.Killer whales have a diverse diet, although individual populations often specialize in particular types of prey. Some feed exclusively on fish, while others hunt marine mammals such as seals and dolphins. They have been known to attack baleen whale calves, and even adult whales. Killer whales are apex predators, as there is no animal that preys on them. Killer whales are considered a cosmopolitan species, and can be found in each of the world's oceans in a variety of marine environments, from Arctic and Antarctic regions to tropical seas.\nKiller whales are highly social; some populations are composed of matrilineal family groups (pods) which are the most stable of any animal species. Their sophisticated hunting techniques and vocal behaviours, which are often specific to a particular group and passed across generations, have been described as manifestations of animal culture.	https://en.wikipedia.org/wiki/Killer_whale	1.0.1	killer_whale	Wild killer whales are not considered a threat to humans	orca is a toothed whale belonging to the oceanic dolphin family, of which it is the largest member	Killer whales are found in all oceans and most seas. Due to their enormous range, numbers, and density, distributional estimates are difficult to compare, but they clearly prefer higher latitudes and coastal areas over pelagic environments.	APPROVED	t	f	3.5	2	0	1	1	0	0	2	t	UNCLASSIFIED	f	2	357	\N	358	356	346	3	\N	355	f	0	None	0
95	LocationAnalyzer	2017-11-08 18:07:53.764109-05	2017-11-08 18:07:53.764117-05	Analyze locations	https://localhost:8443/demo_apps/locationAnalyzer/index.html	1.0.0	ozp.test.locationanalyzer	Nothing really new here	Analyze locations	None	APPROVED	t	t	0	0	0	0	0	0	0	0	f	UNCLASSIFIED	f	1	389	\N	390	388	378	3	\N	387	f	0	None	0
89	LIT RANCH	2017-11-08 18:07:53.252703-05	2017-11-08 18:08:08.944964-05	The 60,000 acre Lit Ranch is located on the Canadian River in Oldham, Hartley, Moore and Potter counties and now includes the Lit Farms -- 5000 acres of farmland in Hartley and Moore Counties. The ranch's history is as old as the history of the Texas Panhandle. The ranch began in the 1880s when Major Littlefield discovered the value of the mild climate and protection of the river breaks when trail driving cattle from Abilene to Dodge City. Major Littlefield sold the ranch to the Prairie Land and Cattle Company, a Scottish land company, who developed the ranch into a 240,000 acre ranch stretching from Tascosa to Dumas. Lee Bivins purchased the ranch from Prairie in the early 1900s and it was operated by the Bivins until 1980s when it was purchased by the W. H. O'Brien family of Amarillo, Texas	http://localhost.com	1	lit_ranch	\N	Its in Texas	None	APPROVED	t	f	3.70000000000000018	3	2	0	0	0	1	3	t	UNCLASSIFIED	f	3	365	\N	366	364	354	5	\N	363	f	0	None	0
90	Lager	2017-11-08 18:07:53.368853-05	2017-11-08 18:08:09.008583-05	Lager (German: storeroom or warehouse) (Czech: ležák) is a type of beer originating from the Austrian Empire (now Czech Republic) that is conditioned at low temperatures, normally at the brewery. It may be pale, golden, amber, or dark.\n\nAlthough one of the most defining features of lager is its maturation in cold storage, it is also distinguished by the use of a specific yeast. While it is possible to use lager yeast in a warm fermentation process, such as with American steam beer, the lack of a cold storage maturation phase precludes such beer from being classified as lager. On the other hand, German Altbier and Kölsch, brewed with a top-fermenting yeast at a warm temperature, but with a cold storage finishing stage, are classified as obergäriges Lagerbier (top-fermented lager beer)	https://en.wikipedia.org/wiki/Lager	5.5	lager	\N	Lager is a type of beer.	Tall cold glass	APPROVED	t	f	3.5	2	1	0	0	1	0	2	t	UNCLASSIFIED	f	1	369	\N	370	368	358	5	\N	367	f	0	None	0
91	Lamprey	2017-11-08 18:07:53.426631-05	2017-11-08 18:07:53.426641-05	Lampreys (sometimes also called, inaccurately, lamprey eels) are any jawless fish of the order Petromyzontiformes, placed in the superclass Cyclostomata. The adult lamprey may be characterized by a toothed, funnel-like sucking mouth. The common name "lamprey" is probably derived from Latin lampetra, which may mean "stone licker" (lambere "to lick" + petra "stone"), though the etymology is uncertain.\nCurrently there are about 38 known extant species of lampreys. Parasitic species are the best known, and feed by boring into the flesh of other fish to suck their blood; but only 18 species of lampreys are parasitic. Parasitic lampreys also attach themselves to larger animals to get a free ride. Adults of the non-parasitic species do not feed; they live off reserves acquired as ammocoetes (larvae), which they obtain through filter feeding.\nThe lampreys are a very ancient lineage of vertebrates, though their exact relationship to hagfishes and jawed vertebrates is still a matter of dispute.	https://en.wikipedia.org/wiki/Lamprey	1.0.5	lamprey	Lampreys have long been used as food for humans. They were highly appreciated by ancient Romans	Are any jawless fish of the order Petromyzontiformes	Adult lampreys spawn in rivers and then die. The young larvae, ammocoetes, spend several years in the rivers, where they live burrowed in fine sediment, filter feeding on detritus and microorganisms. Then, ammocoetes undergo a metamorphosis lasting several months	APPROVED	t	f	0	0	0	0	0	0	0	0	t	UNCLASSIFIED//FOR OFFICIAL USE ONLY	f	2	373	\N	374	372	362	3	\N	371	f	0	None	0
92	Learning Curves	2017-11-08 18:07:53.535455-05	2017-11-08 18:07:53.535465-05	A learning curve is a graphical representation of the increase of learning (vertical axis) with experience (horizontal axis).\nA learning curve averaged over many trials is smooth, and can be expressed as a mathematical function\nThe term learning curve is used in two main ways: where the same task is repeated in a series of trials, or where a body of knowledge is learned over time. The first person to describe the learning curve was Hermann Ebbinghaus in 1885, in the field of the psychology of learning, although the name wasn't used until 1909\nThe familiar expression "a steep learning curve" is intended to mean that the activity is difficult to learn, although a learning curve with a steep start actually represents rapid progress	https://en.wikipedia.org/wiki/Learning_curve	1.1	learning_curves	How to help yourself help with your learning curves	This book will teach you how to get others to help you with your learning curves	Must be able to learn	APPROVED	f	f	0	0	0	0	0	0	0	0	t	UNCLASSIFIED	f	1	377	\N	378	376	366	4	\N	375	f	0	None	0
93	Lightning	2017-11-08 18:07:53.605932-05	2017-11-08 18:07:53.605941-05	Lightning is a sudden electrostatic discharge that occurs during a thunderstorm. This discharge occurs between electrically charged regions of a cloud (called intra-cloud lightning or IC), between two clouds (CC lightning), or between a cloud and the ground (CG lightning).	https://en.wikipedia.org/wiki/Lightning	8.0.9	lightning	Lightning creates light in the form of black body radiation from the very hot plasma created by the electron flow	Dudden electrostatic discharge that occurs during a thunderstorm	Charged regions in the atmosphere temporarily equalize themselves through this discharge	APPROVED	t	f	0	0	0	0	0	0	0	0	t	UNCLASSIFIED	f	2	381	\N	382	380	370	3	\N	379	f	0	None	0
94	Lion Finder	2017-11-08 18:07:53.687826-05	2017-11-08 18:08:09.039796-05	The lion (Panthera leo) is one of the big cats in the genus Panthera and a member of the family Felidae. The commonly used term African lion collectively denotes the several subspecies in Africa. With some males exceeding 250 kg (550 lb) in weight, it is the second-largest living cat after the tiger, barring hybrids like the liger. Wild lions currently exist in sub-Saharan Africa and in India (where an endangered remnant population resides in and around Gir Forest National Park). In ancient historic times, their range was in most of Africa, including North Africa, and across Eurasia from Greece and southeastern Europe to India. In the late Pleistocene, about 10,000 years ago, the lion was the most widespread large land mammal after humans: Panthera leo spelaea lived in northern and western Europe and Panthera leo atrox lived in the Americas from the Yukon to Peru. The lion is classified as a vulnerable species by the International Union for Conservation of Nature (IUCN), having seen a major population decline in its African range of 30-50% over two decades during the second half of the twentieth century. Lion populations are untenable outside designated reserves and national parks. Although the cause of the decline is not fully understood, habitat loss and conflicts with humans are the greatest causes of concern. Within Africa, the West African lion population is particularly endangered.	https://en.wikipedia.org/wiki/Lion	2.0	lion_finder	\N	The lion is one of the big cats in the genus Panthera and a member of the family Felidae	Lions are muscular, deep-chested felids with short, rounded heads, reduced necks and round ears	APPROVED	t	f	1	1	0	0	0	0	1	1	t	UNCLASSIFIED	f	2	385	\N	386	384	374	3	\N	383	f	0	None	0
98	Luigi	2017-11-08 18:07:53.982452-05	2017-11-08 18:07:53.982461-05	Luigi (Japanese: ルイージ Hepburn: Ruīji, [ɾɯ.iː.dʑi̥]) (English: /luˈiːdʒi/; Italian: [luˈiːdʒi]) is a fictional character featured in video games and related media released by Nintendo. Created by prominent game designer Shigeru Miyamoto, Luigi is portrayed as the slightly younger but taller fraternal twin brother of Nintendo's mascot Mario, and appears in many games throughout the Mario franchise, often as a sidekick to his brother.	https://en.wikipedia.org/wiki/Luigi	1	luigi	\N	Luigi is a fictional character featured in video games and related media released by Nintendo.	None	APPROVED	t	f	0	0	0	0	0	0	0	0	t	UNCLASSIFIED	f	2	401	\N	402	400	390	1	\N	399	f	0	None	0
99	Magnetic positioning	2017-11-08 18:07:54.026718-05	2017-11-08 18:08:09.131871-05	Magnetic positioning is an IPS (Indoor positioning system) solution based on magnetic sensor data from a smartphone used to wirelessly locate objects or people inside a building.\n\nThere is currently no de facto standard for IPS, however magnetic positioning appears to be the most complete and cost effective[citation needed]. It offers accuracy without any hardware usage_requirements and a relatively low total cost of ownership[citation needed]. According to Opus Research magnetic positioning will emerge as a “foundational” indoor location technology.\n\nMagnetic positioning was invented by Professor Janne Haverinen and Anssi Kemppainen. Noticing that buildings' magnetic distortions were leading machines astray, they eventually turned the problem around and focused attention on the magnetic interferences caused by steel structures. What they found was that the disturbances inside them were consistent, creating a magnetic fingerprint unique to a building.\n\nProfessor Janne Haverinen founded the company IndoorAtlas in 2012 to commercialize the magnetic positioning solution with dual headquarters in Mountain View, CA and Oulu, Finland.	https://en.wikipedia.org/wiki/Magnetic_positioning	1.0	magnetic_positioning	\N	Magnetic positioning is an IPS (Indoor positioning system) solution based on magnetic sensor data	None	APPROVED	t	f	3	2	1	0	0	0	1	2	t	UNCLASSIFIED	f	4	405	\N	406	404	394	4	\N	403	f	0	None	0
101	Mallrats	2017-11-08 18:07:54.159822-05	2017-11-08 18:08:09.222161-05	Mallrats is a 1995 American comedy film written and directed by Kevin Smith. It is the second film in the View Askewniverse after 1994's Clerks.\nAs in the other View Askewniverse films, the characters Jay and Silent Bob feature prominently, and characters and events from other films are discussed. Several cast members, including Jason Lee, Ben Affleck, and Joey Lauren Adams, have gone on to work in several other Smith films. Comic book icon Stan Lee appeared, as did Brian O'Halloran, the star of Smith's breakout feature Clerks.\nPlans for a sequel, MallBrats, were announced in March 2015. In June 2016, Smith announced that the sequel would instead be a 10-episode TV series; in February 2017, Smith announced that he had not been able to sell the TV series to any network, and the sequel was shelved indefinitely.	https://en.wikipedia.org/wiki/Mallrats	1995	mallrats	\N	Mallrats is a 1995 American comedy film written and directed by Kevin Smith.	None	APPROVED	t	f	4	1	0	1	0	0	0	1	t	UNCLASSIFIED	f	2	413	\N	414	412	402	4	\N	411	f	0	None	0
102	Map of the world	2017-11-08 18:07:54.233936-05	2017-11-08 18:08:09.28246-05	A map is a symbolic depiction emphasizing relationships between elements of some space, such as objects, regions, or themes.\nMany maps are static, fixed to paper or some other durable medium, while others are dynamic or interactive. Although most commonly used to depict geography, maps may represent any space, real or imagined, without regard to context or scale, such as in brain mapping, DNA mapping, or computer network topology mapping. The space being mapped may be two dimensional, such as the surface of the earth, three dimensional, such as the interior of the earth, or even more abstract spaces of any dimension, such as arise in modeling phenomena having many independent variables.\nAlthough the earliest maps known are of the heavens, geographic maps of territory have a very long tradition and exist from ancient times. The word "map" comes from the medieval Latin Mappa mundi, wherein mappa meant napkin or cloth and mundi the world. Thus, "map" became the shortened term referring to a two-dimensional representation of the surface of the world.	https://en.wikipedia.org/wiki/Map	1.0	map_of_the_world	\N	A map is a symbolic depiction emphasizing relationships between elements of some space and objects.	None	APPROVED	t	f	5	2	2	0	0	0	0	2	t	UNCLASSIFIED	f	4	417	\N	418	416	406	5	\N	415	f	0	None	0
103	Mario	2017-11-08 18:07:54.303969-05	2017-11-08 18:07:54.303977-05	Mario (Japanese: マリオ Hepburn: Mario, [ma.ɾʲi.o]) (English: /ˈmɑːrioʊ/; Italian: [ˈmaːrjo]) is a fictional character in the Mario video game franchise, owned by Nintendo and created by Japanese video game designer Shigeru Miyamoto. Serving as the company's mascot and the eponymous protagonist of the series, Mario has appeared in over 200 video games since his creation. Depicted as a short, pudgy, Italian plumber who resides in the Mushroom Kingdom, his adventures generally center upon rescuing Princess Peach from the Koopa villain Bowser. His younger brother and sidekick is Luigi.	https://en.wikipedia.org/wiki/Mario	1	mario	\N	Mario is a fictional character in the Mario video game franchise.	Mushrooms	APPROVED	t	f	0	0	0	0	0	0	0	0	t	UNCLASSIFIED	f	4	421	\N	422	420	410	5	\N	419	f	0	None	0
104	Minesweeper	2017-11-08 18:07:54.350299-05	2017-11-08 18:08:09.341738-05	Minesweeper is a single-player puzzle video game. The objective of the game is to clear a rectangular board containing hidden "mines" or bombs without detonating any of them, with help from clues about the number of neighboring mines in each field. The game originates from the 1960s, and has been written for many computing platforms in use today. It has many variations and offshoots.	https://en.wikipedia.org/wiki/Minesweeper_%28video_game%29	1	minesweeper	\N	Minesweeper is a single-player puzzle video game.	None	APPROVED	t	f	3.5	2	1	0	0	1	0	2	t	UNCLASSIFIED	f	3	425	\N	426	424	414	2	\N	423	f	0	None	0
105	Mini Dachshund	2017-11-08 18:07:54.429728-05	2017-11-08 18:08:09.643611-05	Miniature dachshunds have a typical weight of 8 to 11 pounds in the United States. They also are normally a height of 5 to 7 inches at the withers.	http://localhost.com	1	mini_dachshund	\N	Some of their nicknames include "wiener dogs", "hot  dogs", or "sausage dogs."	None	APPROVED	t	f	1.80000000000000004	10	2	0	0	0	8	10	t	UNCLASSIFIED	f	3	429	\N	430	428	418	2	\N	427	f	0	None	0
106	Mister Mxyzptlk	2017-11-08 18:07:54.483187-05	2017-11-08 18:07:54.483195-05	Mister Mxyzptlk (/mɪksˈjɛzpɪtlɪk/ miks-YEZ-pit-lik, /ˈmɪksɪlplɪk/ or /mɪksˈjɛzpɪtəlɪk/), sometimes called Mxy, is a fictional impish character who appears in DC Comics' Superman comic books, sometimes as a supervillain and other times as an antihero.\n\nMr. Mxyzptlk was created to appear in Superman #30 (Sept. 1944), in the story "The Mysterious Mr. Mxyzptlk", by writer Jerry Siegel and artist Ira Yarborough. But due to publishing lag time, the character saw print first in the Superman daily comic strip by writer Whitney Ellsworth and artist Wayne Boring.	https://en.wikipedia.org/wiki/Mister_Mxyzptlk	1	mister_mxyzptlk	\N	Mister Mxyzptlk (/mɪksˈjɛzpɪtlɪk/ miks-YEZ-pit-lik, /ˈmɪksɪlplɪk/ or /mɪksˈjɛzpɪtəlɪk/)	None	APPROVED	t	f	0	0	0	0	0	0	0	0	t	UNCLASSIFIED	f	2	433	\N	434	432	422	5	\N	431	f	0	None	0
107	Mixing Console	2017-11-08 18:07:54.559648-05	2017-11-08 18:08:09.674358-05	In audio, a mixing console is an electronic device for combining (also called "mixing"), routing, and changing the volume level, timbre (tone color) and/or dynamics of many different audio signals, such as microphones being used by singers, mics picking up acoustic instruments such as drums or saxophones, signals from electric or electronic instruments such as the electric bass or synthesizer, or recorded music playing on a CD player. In the 2010s, a mixer is able to control analog or digital signals, depending on the type of mixer. The modified signals (voltages or digital samples) are summed to produce the combined output signals, which can then be broadcast, amplified through a sound reinforcement system or recorded (or some combination of these applications).\nMixing consoles are used in many applications, including recording studios, public address systems, sound reinforcement systems, nightclubs, dance clubs, broadcasting, television, and film post-production. A typical, simple application combines signals from two microphones (each used by vocalists singing a duet, perhaps) into an amplifier that drives one set of speakers simultaneously. In live performances, the signal from the mixer usually goes directly to an amplifier which is plugged into speaker cabinets, unless the mixer has a built-in power amplifier or is connected to powered speakers. A DJ mixer may have only two channels, for mixing two record players. A coffeehouse's tiny stage might only have a six channel mixer, enough for two singer-guitarists and a percussionist. A nightclub stage's mixer for rock music shows may have 24 channels for mixing the signals from a rhythm section, lead guitar and several vocalists. A mixing console for a large concert may have 48 channels. A mixing console in a professional recording studio may have as many as 96 channels.	https://en.wikipedia.org/wiki/Mixing_console	1	mixing_console	\N	a mixing console is an electronic device for combining, routing, and changing the volume level	Music	APPROVED	t	f	1	1	0	0	0	0	1	1	t	UNCLASSIFIED	f	3	437	\N	438	436	426	2	\N	435	f	0	None	0
108	Monkey Finder	2017-11-08 18:07:54.694796-05	2017-11-08 18:08:09.733103-05	Monkeys are haplorhine primates, a group generally possessing tails and consisting of about 260 known living species. There are two distinct lineages of monkeys: New World Monkeys and catarrhines. Apes emerged within the catarrhines with the Old World monkeys as a sister group, so cladistically they are monkeys as well. However, traditionally apes are not considered monkeys, rendering this grouping paraphyletic. The equivalent monophyletic clade are the simians. Many monkey species are tree-dwelling (arboreal), although there are species that live primarily on the ground, such as baboons. Most species are also active during the day (diurnal). Monkeys are generally considered to be intelligent, particularly Old World monkeys., a group generally possessing tails and consisting of about 260 known living species. There are two distinct lineages of monkeys: New World Monkeys and catarrhines. Apes emerged within the catarrhines with the Old World monkeys as a sister group, so cladistically they are monkeys as well. However, traditionally apes are not considered monkeys, rendering this grouping paraphyletic. The equivalent monophyletic clade are the simians. Many monkey species are tree-dwelling (arboreal), although there are species that live primarily on the ground, such as baboons. Most species are also active during the day (diurnal). Monkeys are generally considered to be intelligent, particularly Old World monkeys.	https://en.wikipedia.org/wiki/Monkey	5.0.5	monkey_finder	Hanuman, a prominent divine entity in Hinduism, is a human-like monkey god.	Monkeys are haplorhine primates	The many species of monkey have varied relationships with humans	APPROVED	t	f	1	2	0	0	0	0	2	2	t	UNCLASSIFIED//FOR OFFICIAL USE ONLY	f	2	441	\N	442	440	430	3	\N	439	f	0	None	0
109	Moonshine	2017-11-08 18:07:54.765637-05	2017-11-08 18:08:09.797161-05	Moonshine was originally a slang term used to describe high-proof distilled spirits usually produced illicitly, without government authorization. In recent years, however, moonshine has been legalized in various countries and has become a term of art. Legal in the United States since 2010, moonshine is defined as "clear, unaged whiskey".\nIn the United States, moonshine is typically made with corn mash as its main ingredient. Liquor-control laws in the United States that prohibit moonshining, once consisting of a total ban under the 18th Amendment of the Constitution, now focus on evasion of revenue taxation on spiritous or intoxicating liquors. They are enforced by the Bureau of Alcohol, Tobacco, Firearms and Explosives of the US Department of Justice; such enforcers of these laws are known by the often derisive nickname of "revenooers."	https://en.wikipedia.org/wiki/Moonshine	1	moonshine		The distillation was done at night to avoid discovery.	None	APPROVED	t	f	3.5	2	1	0	0	1	0	2	t	UNCLASSIFIED	f	1	445	\N	446	444	434	2	\N	443	f	0	None	0
128	Pluto (Not a planet)	2017-11-08 18:07:56.813962-05	2017-11-08 18:08:10.326152-05	NOT A PLANET NOT A PLANET NOT A PLANET NOT A PLANET NOT A PLANET NOT A PLANET NOT A PLANET NOT A PLANET NOT A PLANET NOT A PLANET NOT A PLANET NOT A PLANET NOT A PLANET NOT A PLANET NOT A PLANET NOT A PLANET NOT A PLANET NOT A PLANET NOT A PLANET NOT A PLANET NOT A PLANET NOT A PLANET NOT A PLANET NOT A PLANET NOT A PLANET NOT A PLANET NOT A PLANET NOT A PLANET NOT A PLANET NOT A PLANET NOT A PLANET NOT A PLANET NOT A PLANET NOT A PLANET NOT A PLANET NOT A PLANET NOT A PLANET NOT A PLANET NOT A PLANET NOT A PLANET NOT A PLANET NOT A PLANET NOT A PLANET NOT A PLANET NOT A PLANET NOT A PLANET NOT A PLANET NOT A PLANET NOT A PLANET NOT A PLANET NOT A PLANET NOT A PLANET NOT A PLANET NOT A PLANET NOT A PLANET NOT A PLANET NOT A PLANET NOT A PLANET NOT A PLANET NOT A PLANET NOT A PLANET NOT A PLANET NOT A PLANET NOT A PLANET NOT A PLANET NOT A PLANET NOT A PLANET NOT A PLANET NOT A PLANET NOT A PLANET NOT A PLANET NOT A PLANET NOT A PLANET NOT A PLANET NOT A PLANET NOT A PLANET NOT A PLANET NOT A PLANET NOT A PLANET NOT A PLANET NOT A PLANET NOT A PLANET NOT A PLANET NOT A PLANET NOT A PLANET NOT A PLANET NOT A PLANET NOT A PLANET NOT A PLANET NOT A PLANET NOT A PLANET NOT A PLANET NOT A PLANET NOT A PLANET NOT A PLANET NOT A PLANET NOT A PLANET NOT A PLANET NOT A PLANET NOT A PLANET NOT A PLANET NOT A PLANET NOT A PLANET NOT A PLANET NOT A PLANET NOT A PLANET NOT A PLANET NOT A PLANET NOT A PLANET NOT A PLANET NOT A PLANET NOT A PLANET NOT A PLANET NOT A PLANET NOT A PLANET NOT A PLANET NOT A PLANET NOT A PLANET NOT A PLANET NOT A PLANET NOT A PLANET NOT A PLANET NOT A PLANET NOT A PLANET NOT A PLANET NOT A PLANET NOT A PLANET NOT A PLANET NOT A PLANET NOT A PLANET NOT A PLANET NOT A PLANET NOT A PLANET NOT A PLANET NOT A PLANET	https://notaplanet.com	not.a.planet	pluto_(not_a_planet)	Not a planet again!	NOT A PLANET	Doesn't need anything to be not a planet.	APPROVED	t	f	3	2	1	0	0	0	1	2	t	UNCLASSIFIED	f	3	521	\N	522	520	510	3	\N	519	f	0	None	0
110	Morse Code	2017-11-08 18:07:54.849452-05	2017-11-08 18:07:54.849462-05	Morse code is a method of transmitting text information as a series of on-off tones, lights, or clicks that can be directly understood by a skilled listener or observer without special equipment. It is named for Samuel F. B. Morse, an inventor of the telegraph. The International Morse Code encodes the ISO basic Latin alphabet, some extra Latin letters, the Arabic numerals and a small set of punctuation and procedural signals (prosigns) as standardized sequences of short and long signals called "dots" and "dashes", or "dits" and "dahs", as in amateur radio practice. Because many non-English natural languages use more than the 26 Roman letters, extensions to the Morse alphabet exist for those languages.	https://en.wikipedia.org/wiki/Morse_code	1	morse_code	\N	It is named for Samuel F. B. Morse, an inventor of the telegraph.	-. --- -. .	APPROVED	t	f	0	0	0	0	0	0	0	0	t	UNCLASSIFIED	f	3	449	\N	450	448	438	1	\N	447	f	0	None	0
111	Motorcycle Helmet	2017-11-08 18:07:54.947879-05	2017-11-08 18:08:09.830072-05	A motorcycle helmet is a type of helmet used by motorcycle riders. The primary goal of a motorcycle helmet is motorcycle safety - to protect the rider's head during impact, thus preventing or reducing head injury and saving the rider's life. Some helmets provide additional conveniences, such as ventilation, face shields, ear protection, intercom etc.\nMotorcyclists are at high risk in traffic crashes. A 2008 systematic review examined studies on motorcycle riders who had crashed and looked at helmet use as an intervention. The review concluded that helmets reduce the risk of head injury by around 69% and death by around 42%. Although it was once speculated that wearing a motorcycle helmet increased neck and spinal injuries in a crash, recent evidence has shown the opposite to be the case, that helmets protect against cervical spine injury, and that an often-cited small study dating to the mid-1980s, "used flawed statistical reasoning".	https://en.wikipedia.org/wiki/Motorcycle_helmet	1	motorcycle_helmet	\N	A motorcycle helmet is a type of helmet used by motorcycle riders.	A motorcycle A head	APPROVED	t	f	5	1	1	0	0	0	0	1	t	UNCLASSIFIED	f	3	453	\N	454	452	442	2	\N	451	f	0	None	0
112	Motorsport	2017-11-08 18:07:55.027691-05	2017-11-08 18:08:09.893984-05	Motorsport or motorsports is a global term used to encompass the group of competitive sporting events which primarily involve the use of motorised vehicles, whether for racing or non-racing competition. The terminology can also be used to describe forms of competition of two-wheeled motorised vehicles under the banner of motorcycle racing, and includes off-road racing such as motocross.\n\nFour- (or more) wheeled motorsport competition is globally governed by the Federation Internationale de l'Automobile (FIA); and the Federation Internationale de Motocyclisme (FIM) governs two-wheeled competition.	https://en.wikipedia.org/wiki/Motorsport	1.0	motorsport	\N	Motorsport is a global term used to encompass the group of competitive sporting events.	None	APPROVED	t	f	3.5	2	0	1	1	0	0	2	t	UNCLASSIFIED	f	4	457	\N	458	456	446	2	\N	455	f	0	None	0
113	Movie Projector	2017-11-08 18:07:55.084974-05	2017-11-08 18:07:55.085004-05	A movie projector is an opto-mechanical device for displaying motion picture film by projecting it onto a screen. Most of the optical and mechanical elements, except for the illumination and sound devices, are present in movie cameras.	https://en.wikipedia.org/wiki/Movie_projector	1	movie_projector	\N	A movie projector is an opto-mechanical device for displaying motion pictures.	A Wall	APPROVED	t	f	0	0	0	0	0	0	0	0	t	UNCLASSIFIED	f	3	461	\N	462	460	450	2	\N	459	f	0	None	0
117	Navigation using Maps	2017-11-08 18:07:55.749506-05	2017-11-08 18:08:10.10177-05	From Wikipedia:\nGoogle Maps is a web mapping service developed by Google. It offers satellite imagery, street maps, 360° panoramic views of streets (Street View), real-time traffic conditions (Google Traffic), and route planning for traveling by foot, car, bicycle (in beta), or public transportation.\n\nGoogle Maps began as a C++ desktop program designed by Lars and Jens Eilstrup Rasmussen at Where 2 Technologies. In October 2004, the company was acquired by Google, which converted it into a web application. After additional acquisitions of a geospatial data visualization company and a realtime traffic analyzer, Google Maps was launched in February 2005. The service's front end utilizes JavaScript, XML, and Ajax. Google Maps offers an API that allows maps to be embedded on third-party websites, and offers a locator for urban businesses and other organizations in numerous countries around the world. Google Map Maker allowed users to collaboratively expand and update the service's mapping worldwide but was discontinued from March, 2017. However crowdsourced contributions to Google Maps are not ending as the company announced those features will be transferred to Google's Local Guides programme.\n\nGoogle Maps' satellite view is a "top-down" or "birds eye" view; most of the high-resolution imagery of cities is aerial photography taken from aircraft flying at 800 to 1,500 feet (240 to 460 m), while most other imagery is from satellites. Much of the available satellite imagery is no more than three years old and is updated on a regular basis. Google Maps uses a close variant of the Mercator projection, and therefore cannot accurately show areas around the poles.\n\nThe current redesigned version of the desktop application was made available in 2013, alongside the "classic" (pre-2013) version. Google Maps for mobile was released in September 2008 and features GPS turn-by-turn navigation. In August 2013, it was determined to be the world's most popular app for smartphones, with over 54% of global smartphone owners using it at least once.\n\nIn 2012, Google reported having over 7,100 employees and contractors directly working in mapping.	https://en.wikipedia.org/wiki/Google_Maps#External_links	1.0	navigation_using_maps	\N	Description of Google Maps is a web mapping service developed by Google	None	APPROVED	t	f	3.5	2	0	1	1	0	0	2	t	UNCLASSIFIED	f	4	477	\N	478	476	466	2	\N	475	f	0	None	0
114	N64	2017-11-08 18:07:55.231031-05	2017-11-08 18:07:55.231041-05	The Nintendo 64 (Japanese: ニンテンドウ64 Hepburn: Nintendō Rokujūyon), stylized as the NINTENDO64 and abbreviated to N64, is Nintendo's third home video game console for the international market. Named for its 64-bit central processing unit, it was released in June 1996 in Japan, September 1996 in North America, March 1997 in Europe and Australia, September 1997 in France and December 1997 in Brazil. It was the last major home console to use the cartridge as its primary storage format until Nintendo's seventh console, the Nintendo Switch, released in 2017. While the Nintendo 64 was succeeded by Nintendo's MiniDVD-based GameCube in September 2001, the consoles remained available until the system was retired in late 2003.	https://en.wikipedia.org/wiki/Nintendo_64	64bit	n64	\N	The Nintendo 64, stylized as the NINTENDO64 and abbreviated to N64.	A TV	APPROVED	t	f	0	0	0	0	0	0	0	0	t	UNCLASSIFIED	f	1	465	\N	466	464	454	2	\N	463	f	0	None	0
115	NES	2017-11-08 18:07:55.530585-05	2017-11-08 18:07:55.530595-05	The Nintendo Entertainment System (commonly abbreviated as NES) is an 8-bit home video game console that was developed and manufactured by Nintendo. It was initially released in Japan as the Family Computer (Japanese: ファミリーコンピュータ Hepburn: Famirī Konpyūta) (also known by the portmanteau abbreviation Famicom (ファミコン Famikon) and abbreviated as FC) on July 15, 1983, and was later released in North America during 1985, in Europe during 1986, and Australia in 1987. In South Korea, it was known as the Hyundai Comboy (현대 컴보이 Hyeondae Keomboi) and was distributed by SK Hynix which then was known as Hyundai Electronics. The best-selling gaming console of its time,e[›] the NES helped revitalize the US video game industry following the video game crash of 1983. With the NES, Nintendo introduced a now-standard business model of licensing third-party developers, authorizing them to produce and distribute titles for Nintendo's platform. It was succeeded by the Super Nintendo Entertainment System.	https://en.wikipedia.org/wiki/Nintendo_Entertainment_System	8bit	nes	\N	The Nintendo Entertainment System (commonly abbreviated as NES) is an 8-bit home video game console.	A TV	APPROVED	t	f	0	0	0	0	0	0	0	0	t	UNCLASSIFIED	f	4	469	\N	470	468	458	2	\N	467	f	0	None	0
118	Neptune	2017-11-08 18:07:55.859529-05	2017-11-08 18:08:10.174389-05	Neptune is the eighth and farthest known planet from the Sun in the Solar System. In the Solar System, it is the fourth-largest planet by diameter, the third-most-massive planet, and the densest giant planet. Neptune is 17 times the mass of Earth and is slightly more massive than its near-twin Uranus, which is 15 times the mass of Earth and slightly larger than Neptune. Neptune orbits the Sun once every 164.8 years at an average distance of 30.1 astronomical units (4.50×109 km). It is named after the Roman god of the sea and has the astronomical symbol ♆, a stylised version of the god Neptune's trident.\n\nNeptune is not visible to the unaided eye and is the only planet in the Solar System found by mathematical prediction rather than by empirical observation. Unexpected changes in the orbit of Uranus led Alexis Bouvard to deduce that its orbit was subject to gravitational perturbation by an unknown planet. Neptune was subsequently observed with a telescope on 23 September 1846 by Johann Galle within a degree of the position predicted by Urbain Le Verrier. Its largest moon, Triton, was discovered shortly thereafter, though none of the planet's remaining known 14 moons were located telescopically until the 20th century. The planet's distance from Earth gives it a very small apparent size, making it challenging to study with Earth-based telescopes. Neptune was visited by Voyager 2, when it flew by the planet on 25 August 1989. The advent of the Hubble Space Telescope and large ground-based telescopes with adaptive optics has recently allowed for additional detailed observations from afar.\n\nLike Jupiter and Saturn, Neptune's atmosphere is composed primarily of hydrogen and helium, along with traces of hydrocarbons and possibly nitrogen, but it contains a higher proportion of "ices" such as water, ammonia, and methane. However, its interior, like that of Uranus, is primarily composed of ices and rock, which is why Uranus and Neptune are normally considered "ice giants" to emphasise this distinction. Traces of methane in the outermost regions in part account for the planet's blue appearance.\n\nIn contrast to the hazy, relatively featureless atmosphere of Uranus, Neptune's atmosphere has active and visible weather patterns. For example, at the time of the Voyager 2 flyby in 1989, the planet's southern hemisphere had a Great Dark Spot comparable to the Great Red Spot on Jupiter. These weather patterns are driven by the strongest sustained winds of any planet in the Solar System, with recorded wind speeds as high as 2,100 kilometres per hour (580 m/s; 1,300 mph). Because of its great distance from the Sun, Neptune's outer atmosphere is one of the coldest places in the Solar System, with temperatures at its cloud tops approaching 55 K (−218 °C). Temperatures at the planet's centre are approximately 5,400 K (5,100 °C). Neptune has a faint and fragmented ring system (labelled "arcs"), which was discovered in 1982, then later confirmed by Voyager 2.	https://en.wikipedia.org/wiki/Neptune	1.0	neptune	\N	Neptune is the eighth and farthest known planet from the Sun in the Solar System.	Requires the internet.	APPROVED	t	f	3	2	1	0	0	0	1	2	t	UNCLASSIFIED	f	3	481	\N	482	480	470	3	\N	479	f	0	None	0
119	Network Switch	2017-11-08 18:07:55.94188-05	2017-11-08 18:08:10.213904-05	A computer networking device that connects devices together on a computer network by using packet switching to receive, process, and forward data to the destination device.  Multiple data cables are plugged into a switch to enable communication between different networked devices. Switches manage the flow of data across a network by transmitting a received network packet only to the one or more devices for which the packet is intended. Each networked device connected to a switch can be identified by its network address, allowing the switch to regulate the flow of traffic. This maximizes the security and efficiency of the network.	https://en.wikipedia.org/wiki/Network_switch	0.5.8	network_switch	Layer-7 switches may distribute the load based on uniform resource locators (URLs)	A computer networking device that connects devices together on a computer network	Unmanaged switches - these switches have no configuration interface or options. They are plug and play. They are typically the least expensive switches, and therefore often used in a small office/home office environment. Unmanaged switches can be desktop or rack mounted.\nManaged switches - these switches have one or more methods to modify the operation of the switch. Common management methods include: a command-line interface (CLI) accessed via serial console, telnet or Secure Shell, an embedded Simple Network Management Protocol (SNMP) agent allowing management from a remote console or management station, or a web interface for management from a web browser. Examples of configuration changes that one can do from a managed switch include: enabling features such as Spanning Tree Protocol or port mirroring, setting port bandwidth, creating or modifying virtual LANs (VLANs), etc. Two sub-classes of managed switches are marketed today:	APPROVED	t	f	4	1	0	1	0	0	0	1	t	UNCLASSIFIED	f	2	485	\N	486	484	474	3	\N	483	f	0	None	0
120	Newspaper	2017-11-08 18:07:56.036817-05	2017-11-08 18:07:56.036828-05	A serial publication containing news about current events, other informative articles about politics, sports, arts, and so on, and advertising. A newspaper is usually, but not exclusively, printed on relatively inexpensive, low-grade paper such as newsprint. The journalism organizations that publish newspapers are themselves often metonymically called newspapers.	https://en.wikipedia.org/wiki/Newspaper	8.05	newspaper	By the early 19th century, many cities in Europe, as well as North and South America, published newspapers. As of 2017, most newspapers are now published online as well as in print. The online versions are called online newspapers or news websites.	A publication containing news about current events usually on low-grade paper	Wide variety of material is published in newspapers, including opinion columns, weather forecasts, reviews of local services, obituaries, birth notices, crosswords, editorial cartoons, comic strips, and advice columns. Most newspapers are businesses, and they pay their expenses with a mixture of subscription revenue, newsstand sales, and advertising revenue.	APPROVED	t	f	0	0	0	0	0	0	0	0	t	UNCLASSIFIED	f	2	489	\N	490	488	478	4	\N	487	f	0	None	0
121	Parrot	2017-11-08 18:07:56.133908-05	2017-11-08 18:07:56.133918-05	Birds of the roughly 393 species in 92 genera that make up the order Psittaciformes, found in most tropical and subtropical regions.  Characteristic features of parrots include a strong, curved bill, an upright stance, strong legs, and clawed zygodactyl feet	https://en.wikipedia.org/wiki/Parrot	0.4.8	parrot	Psittaciform diversity in South America and Australasia suggests that the order may have evolved in Gondwana	Birds of the roughly 393 species in 92 genera found in most tropical and subtropical regions	Parrots are found on all tropical and subtropical continents and regions including Australia and Oceania, South Asia, Southeast Asia, Central America, South America, and Africa	APPROVED	t	f	0	0	0	0	0	0	0	0	t	UNCLASSIFIED	f	2	493	\N	494	492	482	3	\N	491	f	0	None	0
122	Parrotlet	2017-11-08 18:07:56.196841-05	2017-11-08 18:07:56.196851-05	The blue-winged parrotlet (Forpus xanthopterygius) is a small parrot found in much of South America. The blue-winged parrotlet is mainly found in lowlands, but locally up to 1200m in south-eastern Brazil. It occurs in woodland, scrub, savanna, and pastures. Flocks are usually around 20 birds but can grow to over 50 around fruiting trees or seeding grasses. It is generally common and widespread, though more localized in the Amazon Basin.	https://en.wikipedia.org/wiki/Blue-winged_parrotlet	1	parrotlet	The blue-winged parrotlet is a small parrot found in much of South America.	Parrotlets are a group of the smallest New World parrot species.	none	APPROVED	t	f	0	0	0	0	0	0	0	0	t	UNCLASSIFIED	f	1	497	\N	498	496	486	3	\N	495	f	0	None	0
125	Phentolamine	2017-11-08 18:07:56.584429-05	2017-11-08 18:08:10.25227-05	Phentolamine (Regitine) is a reversible nonselective α-adrenergic antagonist	https://en.wikipedia.org/wiki/Phentolamine	1	phentolamine	\N	Phentolamine (Regitine) is a reversible nonselective α-adrenergic antagonist	None	APPROVED	t	f	5	1	1	0	0	0	0	1	t	UNCLASSIFIED	f	5	509	\N	510	508	498	1	\N	507	f	0	None	0
123	Pencil	2017-11-08 18:07:56.236068-05	2017-11-08 18:07:56.236078-05	A pencil is a writing implement or art medium constructed of a narrow, solid pigment core inside a protective casing which prevents the core from being broken and/or from leaving marks on the user’s hand during use.\n\nPencils create marks by physical abrasion, leaving behind a trail of solid core material that adheres to a sheet of paper or other surface. They are distinct from pens, which instead disperse a trail of liquid or gel ink that stains the light colour of the paper.	https://en.wikipedia.org/wiki/Pencil	1	pencil	\N	A pencil is a writing implement	Paper	APPROVED	t	f	0	0	0	0	0	0	0	0	t	UNCLASSIFIED	f	3	501	\N	502	500	490	2	\N	499	f	0	None	0
124	Personal Computer	2017-11-08 18:07:56.501705-05	2017-11-08 18:07:56.501714-05	A personal computer (PC) is a multi-purpose electronic computer whose size, capabilities, and price make it feasible for individual use. PCs are intended to be operated directly by an end user, rather than by a computer expert or technician.\n"Computers were invented to 'compute': to solve complex mathematical problems, but today, due to media dependency and the everyday use of computers, it is seen that 'computing' is the least important thing computers do." The computer time-sharing models that were typically used with larger, more expensive minicomputer and mainframe systems, to enable them be used by many people at the same time, are not used with PCs.\nEarly computer owners in the 1960s, invariably institutional or corporate, had to write their own programs to do any useful work with the machines. In the 2010s, personal computer users have access to a wide range of commercial software, free software ("freeware") and free and open-source software, which are provided in ready-to-run form. Software for personal computers is typically developed and distributed independently from the hardware or OS manufacturers. Many personal computer users no longer need to write their own programs to make any use of a personal computer, although end-user programming is still feasible. This contrasts with systems such as smartphones or tablet computers, where software is often only available through a manufacturer-supported channel, and end-user program development may be discouraged by lack of support by the manufacturer.\nSince the early 1990s, Microsoft operating systems and Intel hardware have dominated much of the personal computer market, first with MS-DOS and then with Windows. Alternatives to Microsoft's Windows operating systems occupy a minority share of the industry. These include Apple's macOS and free open-source Unix-like operating systems such as Linux. Advanced Micro Devices (AMD) provides the main alternative to Intel's processors.	https://en.wikipedia.org/wiki/Personal_computer	1.0	personal_computer	\N	PCs are intended to be operated directly by an end user.	Web Browser	APPROVED	t	f	0	0	0	0	0	0	0	0	t	UNCLASSIFIED	f	2	505	\N	506	504	494	4	\N	503	f	0	None	0
126	Phylo	2017-11-08 18:07:56.678913-05	2017-11-08 18:07:56.678923-05	Phylo is an experimental video game about multiple sequence alignment optimisation. Developed by the McGill Centre for Bioinformatics, it was originally released as a free Flash game in November 2010. Designed as a game with a purpose, players solve pattern-matching puzzles that represent nucleotide sequences of different phylogenetic taxa to optimize alignments over a computer algorithm. By aligning together each nucleotide sequence, represented as differently coloured blocks, players attempt to create the highest point value score for each set of sequences by matching as many colours as possible and minimizing gaps.\nThe nucleotide sequences generated by Phylo are obtained from actual sequence data from the UCSC Genome Browser. High-scoring player alignments are collected as data and sent back to the McGill Centre for Bioinformatics to be further evaluated with a stronger scoring algorithm. Those player alignments that score higher than the current computer-generated score will be re-introduced into the global alignment as an optimization.	https://en.wikipedia.org/wiki/Phylo_%28video_game%29	1	phylo	\N	Phylo is an experimental video game about multiple sequence alignment optimisation	None	APPROVED	t	f	0	0	0	0	0	0	0	0	t	UNCLASSIFIED	f	1	513	\N	514	512	502	2	\N	511	f	0	None	0
129	Pokemon Ruby and Sapphire	2017-11-08 18:07:56.954978-05	2017-11-08 18:07:56.955-05	Pokemon Ruby Version and Sapphire Version (ポケットモンスタールビー・サファイア Poketto Monsutā Rubī & Safaia, "Pocket Monsters: Ruby & Sapphire") are the third installments of the Pokemon series of role-playing video games, developed by Game Freak and published by Nintendo for the Game Boy Advance. The games were first released in Japan in late 2002 and internationally in 2003. Pokemon Emerald, a special edition version, was released two years later in each region. These three games (Pokemon Ruby, Sapphire, and Emerald) are part of the third generation of the Pokemon video game series, also known as the "advanced generation". Remakes of the two games, titled Omega Ruby and Alpha Sapphire, were released for the Nintendo 3DS worldwide on November 21, 2014, exactly twelve years to the date of the original Ruby and Sapphire release date, with the exception of Europe, where it was released on November 28, 2014.\n\nThe gameplay is mostly unchanged from the previous games; the player controls the main character from an overhead perspective, and the controls are largely the same as those of previous games. As with previous games, the main objectives are to catch all of the Pokemon in the games and defeat the Elite Four (a group of Pokemon trainers); also like their predecessors, the games' main subplot involves the main character defeating a criminal organization that attempts to take over the region. New features, such as double battles and Pokemon abilities along with 135 new Pokemon, have been added. As the Game Boy Advance is more powerful than its predecessors, four players may be connected at a time instead of the previous limit of two. Additionally, the games can be connected to an e-Reader or other advanced generation Pokemon games.	https://en.wikipedia.org/wiki/Pok%C3%A9mon_Ruby_and_Sapphire	3	pokemon_ruby_and_sapphire	Now has versions for the Nintendo 3DS!	Third installments of the Pokemon series of video games	Must have the nintendo gaming system for the version of the game	APPROVED	t	f	0	0	0	0	0	0	0	0	t	UNCLASSIFIED	f	3	525	\N	526	524	514	2	\N	523	f	0	None	0
130	Polynesian navigation	\N	2017-11-08 18:07:57.074458-05	From Wikipedia, the free encyclopedia\nTraditional Polynesian navigation was used for thousands of years to make long voyages across thousands of miles of the open Pacific Ocean. Navigators travelled to small inhabited islands using wayfinding techniques and knowledge passed by oral tradition from master to apprentice, often in the form of song. Generally each island maintained a guild of navigators who had very high status; in times of famine or difficulty they could trade for aid or evacuate people to neighboring islands. As of 2014, these traditional navigation methods are still taught in the Polynesian outlier of Taumako Island in the Solomons.\nPolynesian navigation used some navigational instruments, which predate and are distinct from the machined metal tools used by European navigators (such as the sextant, first produced 1730, sea astrolabe, ~late 15th century, and marine chronometer, invented 1761). However, they also relied heavily on close observation of sea sign and a large body of knowledge from oral tradition.\nBoth wayfinding techniques and outrigger canoe construction methods have been kept as guild secrets, but in the modern revival of these skills, they are being recorded and published.	https://en.wikipedia.org/wiki/Polynesian_navigation	1.0	polynesian_navigation	\N	used for thousands of years to make long voyages	None	PENDING	t	f	0	0	0	0	0	0	0	0	t	UNCLASSIFIED	f	4	529	\N	530	528	518	2	\N	527	f	0	None	0
131	Postage Stamp	2017-11-08 18:07:57.170276-05	2017-11-08 18:07:57.170289-05	A postage stamp is a small piece of paper that is purchased and displayed on an item of mail as evidence of payment of postage. Typically, stamps are printed on special custom-made paper, show a national designation and a denomination (value) on the front, and have an adhesive gum on the back or are self-adhesive. Postage stamps are purchased from a postal administration (post office) or other authorized vendor, and are used to pay for the costs involved in moving mail, as well as other business necessities such as insurance and registration. They are sometimes a source of net profit to the issuing agency, especially when sold to collectors who will not actually use them for postage.	https://en.wikipedia.org/wiki/Postage_stamp	1c	postage_stamp	\N	A postage stamp is a small piece of paper that is displayed on an item of mail as payment of postage	Saliva	APPROVED	t	f	0	0	0	0	0	0	0	0	t	UNCLASSIFIED	f	6	533	\N	534	532	522	1	\N	531	f	0	None	0
137	Ruby Miner	2017-11-08 18:07:58.290385-05	2017-11-08 18:07:58.290395-05	A discovery app for Ruby on Rails gems.	http://guides.rubyonrails.org/active_record_migrations.html	1	ruby_miner	New gems!	A discovery app for Ruby on Rails gems	Linux, windows or mac compatible.	APPROVED	t	f	0	0	0	0	0	0	0	0	t	UNCLASSIFIED	f	4	557	\N	558	556	546	2	\N	555	f	0	None	0
132	Princess Peach	2017-11-08 18:07:57.337628-05	2017-11-08 18:08:10.363108-05	Princess Peach (Japanese: ピーチ姫 Hepburn: Pīchi-hime, [piː.tɕi̥ çi̥.me]) is a character in Nintendo's Mario franchise. Originally created by Shigeru Miyamoto, Peach is the princess of the fictional Mushroom Kingdom, which is constantly under attack by Bowser. She often plays the damsel in distress role within the series and is the lead female. She is often portrayed as Mario's love interest and has appeared in Super Princess Peach, where she is the main playable character.	https://en.wikipedia.org/wiki/Princess_Peach	1	princess_peach	\N	Princess Peach is a character in Nintendo's Mario franchise.	None	APPROVED	t	f	3	1	0	0	1	0	0	1	t	UNCLASSIFIED	f	4	537	\N	538	536	526	4	\N	535	f	0	None	0
133	Project Management	2017-11-08 18:07:57.758131-05	2017-11-08 18:08:10.43203-05	Project management is the discipline of initiating, planning, executing, controlling, and closing the work of a team to achieve specific goals and meet specific success criteria. A project is a temporary endeavor designed to produce a unique product, service or result with a defined beginning and end (usually time-constrained, and often constrained by funding or deliverable) undertaken to meet unique goals and objectives, typically to bring about beneficial change or added value. The temporary nature of projects stands in contrast with business as usual (or operations), which are repetitive, permanent, or semi-permanent functional activities to produce products or services. In practice, the management of such distinct production approaches requires the development of distinct technical skills and management strategies.\n\nThe primary challenge of project management is to achieve all of the project goals within the given constraints. This information is usually described in project documentation, created at the beginning of the development process. The primary constraints are scope, time, quality and budget. The secondary — and more ambitious — challenge is to optimize the allocation of necessary inputs and apply them to meet pre-defined objectives.	https://localhost:8443/default/index.html	1.0	project_management	\N	Project management is the discipline of initiating, planning, executing, controlling, and closing.	None	APPROVED	t	f	1.5	2	0	0	0	1	1	2	t	UNCLASSIFIED	f	1	541	\N	542	540	530	2	\N	539	f	0	None	0
134	Railroad	2017-11-08 18:07:57.991189-05	2017-11-08 18:08:10.57665-05	Rail transport is a means of transferring of passengers and goods on wheeled vehicles running on rails, also known as tracks. It is also commonly referred to as train transport. In contrast to road transport, where vehicles run on a prepared flat surface, rail vehicles (rolling stock) are directionally guided by the tracks on which they run. Tracks usually consist of steel rails, installed on ties (sleepers) and ballast, on which the rolling stock, usually fitted with metal wheels, moves. Other variations are also possible, such as slab track, where the rails are fastened to a concrete foundation resting on a prepared subsurface.\nRolling stock in a rail transport system generally encounters lower frictional resistance than road vehicles, so passenger and freight cars (carriages and wagons) can be coupled into longer trains. The operation is carried out by a railway company, providing transport between train stations or freight customer facilities. Power is provided by locomotives which either draw electric power from a railway electrification system or produce their own power, usually by diesel engines. Most tracks are accompanied by a signalling system. Railways are a safe land transport system when compared to other forms of transport.[Nb 1] Railway transport is capable of high levels of passenger and cargo utilization and energy efficiency, but is often less flexible and more capital-intensive than road transport, when lower traffic levels are considered.\nThe oldest, man-hauled railways date back to the 6th century BC, with Periander, one of the Seven Sages of Greece, credited with its invention. Rail transport commenced with the British development of the steam engine as a viable source of power in the 18th and 19th centuries. Steam locomotives were first developed in the United Kingdom in the early 19th century. Built by George Stephenson and his son Robert's company Robert Stephenson and Company, the Locomotion No. 1 is the first steam locomotive to carry passengers on a public rail line, the Stockton and Darlington Railway in 1825. George also built the first public inter-city railway line in the world to use steam locomotives, the Liverpool and Manchester Railway which opened in 1830. With steam engines, one could construct mainline railways, which were a key component of the Industrial Revolution. Also, railways reduced the costs of shipping, and allowed for fewer lost goods, compared with water transport, which faced occasional sinking of ships. The change from canals to railways allowed for "national markets" in which prices varied very little from city to city. The invention and development of the railway in the United Kingdom was one of the most important technological inventions of the 19th century.\nIn the 1880s, electrified trains were introduced, and also the first tramways and rapid transit systems came into being. Starting during the 1940s, the non-electrified railways in most countries had their steam locomotives replaced by diesel-electric locomotives, with the process being almost complete by 2000. During the 1960s, electrified high-speed railway systems were introduced in Japan and later in some other countries. Other forms of guided ground transport outside the traditional railway definitions, such as monorail or maglev, have been tried but have seen limited use. Following decline after World War II due to competition from cars, rail transport has had a revival in recent decades due to road congestion and rising fuel prices, as well as governments investing in rail as a means of reducing CO2 emissions in the context of concerns about global warming.	https://en.wikipedia.org/wiki/Rail_transport	1.0	railroad	\N	Rail transport is a means of transferring of passengers & goods on vehicles running on rails.	None	APPROVED	t	f	4	3	1	1	1	0	0	3	t	UNCLASSIFIED	f	4	545	\N	546	544	534	3	\N	543	f	0	None	0
142	Sailboat Racing	2017-11-08 18:07:59.272149-05	2017-11-08 18:08:10.705115-05	A form of sport involving yachts and larger sailboats, as distinguished from dinghy racing. It is composed of multiple yachts, in direct competition, racing around a course marked by buoys or other fixed navigational devices or racing longer distances across open water from point-to-point. It can involve a series of races when buoy racing or multiple legs when point-to-point racing.	https://en.wikipedia.org/wiki/Yacht_racing	5.0	sailboat_racing	America's Cup established in 1851	A form of sport involving yachts and larger sailboats	competition between countries who are allowed to send one team and three boats of a chosen one design class	APPROVED	t	f	3	1	0	0	1	0	0	1	t	UNCLASSIFIED	f	2	577	\N	578	576	566	3	\N	575	f	0	None	0
135	Rogue	2017-11-08 18:07:58.037354-05	2017-11-08 18:08:10.61968-05	Rogue is a fictional superhero appearing in American comic books published by Marvel Comics, commonly in association with the X-Men. The character debuted in Avengers Annual #10 (November 1981) as a villain, but then soon after she joined the X-Men.\nRogue is part of a subspecies of humans called mutants, who are born with superhuman abilities. Rogue has the involuntary ability to absorb and sometimes also remove the memories, physical strength, and superpowers of anyone she touches. Therefore, Rogue considers her powers to be a curse. For most of her life, she limited her physical contact with others, including her on-off love interest, Gambit. However, after many years, Rogue finally gained full control over her mutant ability.\nHailing from the fictional Caldecott County, Mississippi, Rogue is the X-Men's self-described southern belle. A runaway, she was adopted by Mystique of the Brotherhood of Evil Mutants and grew up as a villain. After Rogue permanently absorbs Ms. Marvel's psyche and Kree powers, she reforms and turns to the X-Men, fearing for her sanity. Rogue's real name and early history were not revealed until nearly 20 years after her introduction. Until the back story provided by Robert Rodi in the ongoing Rogue series, which began in September 2004, Rogue's background was only hinted at. Her name was revealed as Anna Marie, although her surname is still unknown. She has sometimes adopted the name Raven, which is the first name of her foster mother Mystique.\nRogue has been one of the most prominent members of the X-Men since the 1980s. She was #5 on IGN's Top 25 X-Men list for 2006, #4 on their Top Ten X-Babes list for 2006, #3 on Marvel's list of Top 10 Toughest Females for 2009 and was given title of #1 X-Man on CBR's Top 50 X-Men of All Time for 2008. She was ranked tenth in Comics Buyer's Guide's "100 Sexiest Women in Comics" list. Rogue has been featured in most of the X-Men animated series, and various video games. In the X-Men film series, she is portrayed by Anna Paquin. Her visual cue is often the white streak that runs through her hair.	https://en.wikipedia.org/wiki/Rogue_(comics)	1	rogue	\N	No touching	None	APPROVED	t	f	2	1	0	0	0	1	0	1	t	UNCLASSIFIED	f	2	549	\N	550	548	538	5	\N	547	f	0	None	0
136	Ruby	2017-11-08 18:07:58.130238-05	2017-11-08 18:08:10.659445-05	A ruby is a pink to blood-red colored gemstone, a variety of the mineral corundum (aluminium oxide). Other varieties of gem-quality corundum are called sapphires. Ruby is one of the traditional cardinal gems, together with amethyst, sapphire, emerald, and diamond. The word ruby comes from ruber, Latin for red. The color of a ruby is due to the element chromium.\nThe quality of a ruby is determined by its color, cut, and clarity, which, along with carat weight, affect its value. The brightest and most valuable shade of red called blood-red or pigeon blood, commands a large premium over other rubies of similar quality. After color follows clarity: similar to diamonds, a clear stone will command a premium, but a ruby without any needle-like rutile inclusions may indicate that the stone has been treated. Ruby is the traditional birthstone for July and is usually more pink than garnet, although some rhodolite garnets have a similar pinkish hue to most rubies. The world's most expensive ruby is the Sunrise Ruby.	https://en.wikipedia.org/wiki/Ruby	1	ruby	\N	A red-colored gem stone	Must be wealthy	APPROVED	t	f	5	1	1	0	0	0	0	1	t	UNCLASSIFIED	f	1	553	\N	554	552	542	5	\N	551	f	0	None	0
138	Ruby on Rails	2017-11-08 18:07:58.615439-05	2017-11-08 18:07:58.615449-05	Ruby on Rails, or simply Rails, is a server-side web application framework written in Ruby under the MIT License. Rails is a model-view-controller (MVC) framework, providing default structures for a database, a web service, and web pages. It encourages and facilitates the use of web standards such as JSON or XML for data transfer, and HTML, CSS and JavaScript for display and user interfacing. In addition to MVC, Rails emphasizes the use of other well-known software engineering patterns and paradigms, including convention over configuration (CoC), don't repeat yourself (DRY), and the active record pattern.	https://en.wikipedia.org/wiki/Ruby_on_Rails	5	ruby_on_rails	\N	Ruby on Rails, or simply Rails, is a server-side web application framework written in Ruby	Installers are available for all modern operating system	APPROVED	t	f	0	0	0	0	0	0	0	0	t	UNCLASSIFIED	f	4	561	\N	562	560	550	1	\N	559	f	0	None	0
139	Rutebok for Norge	2017-11-08 18:07:58.714217-05	2017-11-08 18:07:58.714226-05	From Wikipedia, the free encyclopedia\nRutebok for Norge is an overview of the entire Norwegian public transport network containing timetables, prices, maps and other essential information. It also contains a list of Norwegian accommodation.\n\nRutebok for Norge was first published in 1869 under the name "Norges Kommunikasjoner" or "Reiseblad". It got its current name in 1918 when it was merged with the state railways equivalent. The Rutebok was issued weekly 1880-1932, later every 14 days. It has been published since 1991 by Norsk Reiseinformasjon AS with 4 issues per year. Since 1994 an electronic version is also published, in the form of a CD-ROM containing the same information as the paper version; since 2003 it has also been available online at http://www.rutebok.no.	https://en.wikipedia.org/wiki/Rutebok_for_Norge	1.0	rutebok_for_norge	\N	Rutebok for Norge is an overview of the entire Norwegian public transport network	None	APPROVED	t	f	0	0	0	0	0	0	0	0	t	UNCLASSIFIED	f	4	565	\N	566	564	554	3	\N	563	f	0	None	0
140	SImple Text	2017-11-08 18:07:58.75686-05	2017-11-08 18:07:58.756881-05	SimpleText is the native text editor for the Apple classic Mac OS. SimpleText allows editing including text formatting (underline, italic, bold, etc.), fonts, and sizes. It was developed to integrate the features included in the different versions of TeachText that were created by various software development groups within Apple.\nIt can be considered similar to Windows' WordPad application. In later versions it also gained additional read only display capabilities for PICT files, as well as other Mac OS built-in formats like Quickdraw GX and QTIF, 3DMF and even QuickTime movies. SimpleText can even record short sound samples and, using Apple's PlainTalk speech system, read out text in English. Users who wanted to add sounds longer than 24 seconds, however, needed to use a separate program to create the sound and then paste the desired sound into the document using ResEdit.	https://en.wikipedia.org/wiki/SimpleText	1.4	simple_text	\N	SimpleText is the native text editor for the Apple classic Mac OS.	Mac OS	APPROVED	t	f	0	0	0	0	0	0	0	0	t	UNCLASSIFIED	f	3	569	\N	570	568	558	2	\N	567	f	0	None	0
141	SNES	2017-11-08 18:07:59.084-05	2017-11-08 18:07:59.084021-05	The Super Nintendo Entertainment System (officially abbreviated the Super NES or SNES, and commonly shortened to Super Nintendo) is a 16-bit home video game console developed by Nintendo that was released in 1990 in Japan and South Korea, 1991 in North America, 1992 in Europe and Australasia (Oceania), and 1993 in South America. In Japan, the system is called the Super Famicom (Japanese: スーパーファミコン Hepburn: Sūpā Famikon, officially adopting the abbreviated name of its predecessor, the Famicom), or SFC for short. In South Korea, it is known as the Super Comboy (슈퍼 컴보이 Syupeo Keomboi) and was distributed by Hyundai Electronics. Although each version is essentially the same, several forms of regional lockout prevent the different versions from being compatible with one another. It was released in Brazil on September 2, 1992, by Playtronic.	https://en.wikipedia.org/wiki/Super_Nintendo_Entertainment_System	16bit	snes	\N	The Super Nintendo Entertainment System (officially abbreviated the Super NES or SNES.	A TV	APPROVED	t	f	0	0	0	0	0	0	0	0	t	UNCLASSIFIED	f	4	573	\N	574	572	562	2	\N	571	f	0	None	0
143	Salmon	2017-11-08 18:07:59.34073-05	2017-11-08 18:07:59.340741-05	Salmon /ˈsæmən/ is the common name for several species of ray-finned fish in the family Salmonidae. Other fish in the same family include trout, char, grayling and whitefish. Salmon are native to tributaries of the North Atlantic (genus Salmo) and Pacific Ocean (genus Oncorhynchus). Many species of salmon have been introduced into non-native environments such as the Great Lakes of North America and Patagonia in South America. Salmon are intensively farmed in many parts of the world.\n\nTypically, salmon are anadromous: they are born in fresh water, migrate to the ocean, then return to fresh water to reproduce. However, populations of several species are restricted to fresh water through their lives. Various species of salmon display anadromous life strategies while others display freshwater resident life strategies. Folklore has it that the fish return to the exact spot where they were born to spawn; tracking studies have shown this to be mostly true. A portion of a returning salmon run may stray and spawn in different freshwater systems. The percent of straying depends on the species of salmon. Homing behavior has been shown to depend on olfactory memory	https://en.wikipedia.org/wiki/Salmon	1	salmon	\N	Atlantic salmon (Salmo salar) reproduce in northern rivers on both coasts of the Atlantic Ocean.	none	APPROVED	t	f	0	0	0	0	0	0	0	0	t	UNCLASSIFIED	f	1	581	\N	582	580	570	2	\N	579	f	0	None	0
144	San Bernardino Strait	\N	2017-11-08 18:08:00.45405-05	The San Bernardino Strait (Filipino: Kipot ng San Bernardino) is a strait in the Philippines, connecting the Samar Sea with the Philippine Sea. It separates the Bicol Peninsula of Luzon island from the island of Samar in the south.	https://en.wikipedia.org/wiki/San_Bernardino_Strait	1	san_bernardino_strait	\N	The San Bernardino Strait (Filipino: Kipot ng San Bernardino) is a strait in the Philippines	None	PENDING	t	f	0	0	0	0	0	0	0	0	t	UNCLASSIFIED	f	3	585	\N	586	584	574	3	\N	583	f	0	None	0
151	Sir Baboon McGood	2017-11-08 18:08:01.171621-05	2017-11-08 18:08:01.171631-05	Sir Baboon McGoon was an American Boeing B-17 Flying Fortress, a Douglas-Long Beach built B-17F-75-DL, ASN 42-3506, last assigned to the 324th Bombardment Squadron, 91st Bomb Group, 8th Air Force, operating out of RAF Bassingbourn (AAF Station 121), Cambridgeshire, England. Its nose art and name were based on the male character Baboon McGoon from Al Capp's comic strip, Li'l Abner.	https://en.wikipedia.org/wiki/Sir_Baboon_McGoon	B-17	sir_baboon_mcgood	\N	Sir Baboon McGoon was an American Boeing B-17 Flying Fortress.	gas	APPROVED	t	f	0	0	0	0	0	0	0	0	t	UNCLASSIFIED	f	5	613	\N	614	612	602	2	\N	611	f	0	None	0
145	Sapphire	2017-11-08 18:08:00.535937-05	2017-11-08 18:08:00.535945-05	Sapphire is a gemstone, a variety of the mineral corundum, an aluminium oxide (α-Al2O3). It is typically blue in color, but natural "fancy" sapphires also occur in yellow, purple, orange, and green colors; "parti sapphires" show two or more colors. The only color which sapphire cannot be is red - as red colored corundum is called ruby, another corundum variety. Pink colored corundum may be either classified as ruby or sapphire depending on locale. This variety in color is due to trace amounts of elements such as iron, titanium, chromium, copper, or magnesium.\n\nCommonly, natural sapphires are cut and polished into gemstones and worn in jewelry. They also may be created synthetically in laboratories for industrial or decorative purposes in large crystal boules. Because of the remarkable hardness of sapphires - 9 on the Mohs scale (the third hardest mineral, after diamond at 10 and moissanite at 9.5) - sapphires are also used in some non-ornamental applications, such as infrared optical components, high-durability windows, wristwatch crystals and movement bearings, and very thin electronic wafers, which are used as the insulating substrates of very special-purpose solid-state electronics (especially integrated circuits and GaN-based LEDs).	https://en.wikipedia.org/wiki/Sapphire	3	sapphire	\N	A blue gem stone	Must be fairly wealthy	APPROVED	t	f	0	0	0	0	0	0	0	0	t	UNCLASSIFIED	f	4	589	\N	590	588	578	5	\N	587	f	0	None	0
146	Satellite navigation	2017-11-08 18:08:00.647913-05	2017-11-08 18:08:10.782089-05	From Wikipedia, the free encyclopedia\nFor satellite navigation in automobile navigation systems, see Automotive navigation system.\nA satellite navigation or satnav system is a system that uses satellites to provide autonomous geo-spatial positioning. It allows small electronic receivers to determine their location (longitude, latitude, and altitude/elevation) to high precision (within a few metres) using time signals transmitted along a line of sight by radio from satellites. The system can be used for providing position, navigation or for tracking the position of something fitted with a receiver (satellite tracking). The signals also allow the electronic receiver to calculate the current local time to high precision, which allows time synchronisation. Satnav systems operate independently of any telephonic or internet reception, though these technologies can enhance the usefulness of the positioning information generated.\n\nA satellite navigation system with global coverage may be termed a global navigation satellite system (GNSS). As of December 2016 only the United States NAVSTAR Global Positioning System (GPS), the Russian GLONASS and the European Union's Galileo are global operational GNSSs. The European Union's Galileo GNSS is scheduled to be fully operational by 2020. China is in the process of expanding its regional BeiDou Navigation Satellite System into the global BeiDou-2 GNSS by 2020. France, India and Japan are in the process of developing regional navigation and augmentation systems as well.\n\nGlobal coverage for each system is generally achieved by a satellite constellation of 18-30 medium Earth orbit (MEO) satellites spread between several orbital planes. The actual systems vary, but use orbital inclinations of >50° and orbital periods of roughly twelve hours (at an altitude of about 20,000 kilometres or 12,000 miles).	https://en.wikipedia.org/wiki/Satellite_navigation	1.0	satellite_navigation	\N	A satellite navigation or satnav system is a system that uses satellites to provide geo positioning	None	APPROVED	t	f	4	2	1	0	1	0	0	2	t	UNCLASSIFIED	f	4	593	\N	594	592	582	4	\N	591	f	0	None	0
147	Saturn	2017-11-08 18:08:00.76991-05	2017-11-08 18:08:10.85554-05	Saturn is the sixth planet from the Sun and the second-largest in the Solar System, after Jupiter. It is a gas giant with an average radius about nine times that of Earth. Although it has only one-eighth the average density of Earth, with its larger volume Saturn is just over 95 times more massive. Saturn is named after the Roman god of agriculture; its astronomical symbol (♄) represents the god's sickle.\n\nSaturn's interior is probably composed of a core of iron-nickel and rock (silicon and oxygen compounds). This core is surrounded by a deep layer of metallic hydrogen, an intermediate layer of liquid hydrogen and liquid helium, and finally outside the Frenkel line a gaseous outer layer. Saturn has a pale yellow hue due to ammonia crystals in its upper atmosphere. Electrical current within the metallic hydrogen layer is thought to give rise to Saturn's planetary magnetic field, which is weaker than Earth's, but has a magnetic moment 580 times that of Earth due to Saturn's larger size. Saturn's magnetic field strength is around one-twentieth of Jupiter's. The outer atmosphere is generally bland and lacking in contrast, although long-lived features can appear. Wind speeds on Saturn can reach 1,800 km/h (500 m/s), higher than on Jupiter, but not as high as those on Neptune.\n\nSaturn has a prominent ring system that consists of nine continuous main rings and three discontinuous arcs and that is composed mostly of ice particles with a smaller amount of rocky debris and dust. 62 moons are known to orbit Saturn, of which fifty-three are officially named. This does not include the hundreds of moonlets comprising the rings. Titan, Saturn's largest moon, and the second-largest in the Solar System, is larger than the planet Mercury, although less massive, and is the only moon in the Solar System to have a substantial atmosphere.	https://en.wikipedia.org/wiki/Saturn	1.0	saturn	\N	Saturn is the sixth planet from the Sun and the second-largest in the Solar System	Requires the internet.	APPROVED	t	f	4	2	1	0	1	0	0	2	t	UNCLASSIFIED	f	3	597	\N	598	596	586	3	\N	595	f	0	None	0
148	Screamin Eagle CVO	2017-11-08 18:08:00.867951-05	2017-11-08 18:08:00.867965-05	Harley-Davidson CVO (for Custom Vehicle Operations) motorcycles are a family of models created by Harley-Davidson for the factory custom market. For every model year since the program's inception in 1999, Harley-Davidson has chosen a small selection of its mass-produced motorcycle models and created limited-edition customizations of those platforms with larger-displacement engines, costlier paint designs, and additional accessories not found on the mainstream models. Special features for the CVO lineup have included performance upgrades from Harley's "Screamin' Eagle" branded parts, hand-painted pinstripes, ostrich leather on seats and trunks, gold leaf incorporated in the paint, and electronic accessories like GPS navigation systems and iPod music players.\nCVO models are produced in Harley-Davidson's York, Pennsylvania plant, where touring and Softail models are also manufactured. In each model year, CVO models feature larger-displacement engines than the mainstream models, and these larger-displacement engines make their way into the normal "big twin" line within a few years when CVO models are again upgraded. Accessories created for these customized units are sometimes offered in the Harley-Davidson accessory catalog for all models in later years, but badging and paint are kept exclusively for CVO model owners, and cannot be replaced without providing proof of ownership to the ordering dealer.	https://en.wikipedia.org/wiki/Harley-Davidson_CVO#Critical_reception	1	screamin_eagle_cvo	none	CVO is the the program targets what Harley-Davidson calls its "Alpha Customer"; ride fast and hard.	none	APPROVED	t	f	0	0	0	0	0	0	0	0	t	UNCLASSIFIED	f	1	601	\N	602	600	590	3	\N	599	f	0	None	0
149	Sheet music	2017-11-08 18:08:00.947849-05	2017-11-08 18:08:00.947871-05	Sheet music is a handwritten or printed form of music notation that uses modern musical symbols to indicate the pitches (melodies), rhythms and/or chords of a song or instrumental musical piece. Like its analogs - printed books or pamphlets in English, Arabic or other languages - the medium of sheet music typically is paper (or, in earlier centuries, papyrus or parchment), although the access to musical notation since the 1980s has included the presentation of musical notation on computer screens and the development of scorewriter computer programs that can notate a song or piece electronically, and, in some cases, "play back" the notated music using a synthesizer or virtual instruments.	https://en.wikipedia.org/wiki/Sheet_music	1.09	sheet_music	Use of the term "sheet" is intended to differentiate written or printed forms of music from sound recordings	Sheet music is a handwritten or printed form of music notation that uses modern musical symbols	Knowledge to understand notes on music sheet	APPROVED	t	f	0	0	0	0	0	0	0	0	t	UNCLASSIFIED	f	2	605	\N	606	604	594	2	\N	603	f	0	None	0
150	Siemens Mobility	2017-11-08 18:08:01.101543-05	2017-11-08 18:08:01.101556-05	From Wikipedia, the free encyclopedia\nNot to be confused with Siemens Mobile.\nSiemens Mobility is a division of the German conglomerate Siemens. Prior to the corporate restructuring of Siemens AG (effective from 1 January 2008) Siemens Transportation Systems was the operational division most closely related to Siemens Mobility; products produced included automation and power systems, rolling stock for mass-transit, railway signalling and control systems, and railway electrification.\nThe group also incorporates the former railway rolling stock and locomotive division Siemens Schienenfahrzeugtechnik (Siemens Railway Technology).	https://en.wikipedia.org/wiki/Siemens_Mobility	1.9	siemens_mobility	\N	Siemens Mobility is a division of the German conglomerate Siemens	None	APPROVED	t	f	0	0	0	0	0	0	0	0	t	UNCLASSIFIED	f	4	609	\N	610	608	598	4	\N	607	f	0	None	0
153	Smart Phone	2017-11-08 18:08:01.347232-05	2017-11-08 18:08:01.347242-05	A mobile personal computer with a mobile operating system with features useful for mobile or handheld use. Smartphones, which are typically pocket-sized (as opposed to tablets, which are much larger than a pocket), have the ability to place and receive voice/video calls and create and receive text messages, have personal digital assistants	https://en.wikipedia.org/wiki/Smartphone	7.0	smart_phone	5G Connection will be faster than 4G	Handheld Wireless Phone used to call people and connect to the internet	Have high-speed mobile broadband 4G LTE, motion sensors, and mobile payment features	APPROVED	t	f	0	0	0	0	0	0	0	0	t	UNCLASSIFIED	f	2	621	\N	622	620	610	3	\N	619	f	0	None	0
154	Snow	2017-11-08 18:08:01.39877-05	2017-11-08 18:08:10.971289-05	Snow refers to forms of ice crystals that precipitate from the atmosphere (usually from clouds) and undergo changes on the Earth's surface.	http://localhost.com	1	snow	\N	Ice crystals precipitating.	None	APPROVED	t	f	2	3	0	0	1	1	1	3	t	UNCLASSIFIED	f	2	625	\N	626	624	614	3	\N	623	f	0	None	0
155	Soterosanthus	2017-11-08 18:08:01.52807-05	2017-11-08 18:08:01.528079-05	Soterosanthus shepheardii is a species of orchid found in Ecuador and Colombia, and the only species of the monotypic genus Soterosanthus. This species segregated from Sievekingia because of its upright inflorescence. Flowers are somewhat similar to Sievekingia as is the plant stature, being on the small side, around 6" tall. Plants are semi-deciduous and warmth tolerant. Grow in small pots of medium grade bark mix under same conditions as for Gongora; shaded light, even moisture, drier in winter. It is a rarely seen relative of Stanhopea.	https://en.wikipedia.org/wiki/Soterosanthus	1	soterosanthus	\N	Soterosanthus shepheardii is a species of orchid	None	APPROVED	t	f	0	0	0	0	0	0	0	0	t	UNCLASSIFIED	f	6	629	\N	630	628	618	2	\N	627	f	0	None	0
156	Sound Mixer	2017-11-08 18:08:01.61335-05	2017-11-08 18:08:01.61336-05	is an electronic device for combining (also called "mixing"), routing, and changing the volume level, timbre (tone color) and/or dynamics of many different audio signals, such as microphones being used by singers, mics picking up acoustic instruments such as drums or saxophones, signals from electric or electronic instruments such as the electric bass or synthesizer, or recorded music playing on a CD player. In the 2010s, a mixer is able to control analog or digital signals, depending on the type of mixer	https://en.wikipedia.org/wiki/Mixing_console	1.0.15	sound_mixer	Input jacks, Microphone preamplifiers, equalization	Electronic device for combining routing, and changing the volume level, different audio signals	Mixing consoles are used in many applications	APPROVED	t	f	0	0	0	0	0	0	0	0	t	UNCLASSIFIED	f	2	633	\N	634	632	622	3	\N	631	f	0	None	0
157	Steak	\N	2017-11-08 18:08:01.654628-05	A steak (/ˈsteɪk/) is a meat generally sliced across the muscle fibers, potentially including a bone. Exceptions, in which the meat is sliced parallel to the fibers, include the skirt steak that is cut from the plate, the flank steak that is cut from the abdominal muscles, and the Silverfinger steak that is cut from the loin and includes three rib bones. When the word "steak" is used without qualification, it generally refers to a beefsteak. In a larger sense, there are also fish steaks, ground meat steaks, pork steak and many more varieties of steaks.\n\nSteaks are usually grilled, but they can be pan-fried, or broiled. Steak is often grilled in an attempt to replicate the flavor of steak cooked over the glowing coals of an open fire. Steak can also be cooked in sauce, such as in steak and kidney pie, or minced and formed into patties, such as hamburgers.\n\nSteaks are also cut from grazing animals, usually farmed, other than cattle, including bison, camel, goat, horse, kangaroo, sheep, ostrich, pigs, reindeer, turkey, deer and zebu as well as various types of fish, especially salmon and large pelagic fish such as swordfish, shark and marlin. For some meats, such as pork, lamb and mutton, chevon and veal, these cuts are often referred to as chops. Some cured meat, such as gammon, is commonly served as steak.\n\nGrilled Portobello mushroom may be called mushroom steak, and similarly for other vegetarian dishes. Imitation steak is a food product that is formed into a steak shape from various pieces of meat. Grilled fruits, such as watermelon have been used as vegetarian steak alternatives.	https://en.wikipedia.org/wiki/Steak	1	steak	King of meats.	Beef steaks are commonly grilled, broiled or occasionally fried.	none	PENDING	t	f	0	0	0	0	0	0	0	0	t	UNCLASSIFIED	f	1	637	\N	638	636	624	1	\N	635	f	0	None	0
158	Stop sign	2017-11-08 18:08:01.722517-05	2017-11-08 18:08:11.034987-05	A stop sign is a traffic sign to notify drivers that they must make sure no cars are coming and stop before proceeding.	https://en.wikipedia.org/wiki/Stop_sign	8	stop_sign	\N	A stop sign is a traffic sign to notify drivers that they must stop before proceeding.	Brake Pedal	APPROVED	t	f	5	2	2	0	0	0	0	2	t	UNCLASSIFIED	f	3	641	\N	642	640	628	2	\N	639	f	0	None	0
159	Stout	2017-11-08 18:08:01.787626-05	2017-11-08 18:08:11.065027-05	Stout is a dark beer made using roasted malt or roasted barley, hops, water and yeast. Stouts were traditionally the generic term for the strongest or stoutest porters, typically 7% or 8%, produced by a brewery. There are a number of variations including Baltic porter, milk stout, and imperial stout; the most common variation is dry stout, exemplified by Guinness Draught, the world's best selling stout.[citation needed]\nThe first known use of the word stout for beer was in a document dated 1677 found in the Egerton Manuscript, the sense being that a stout beer was a strong beer not a dark beer. The name porter was first used in 1721 to describe a dark brown beer that had been made with roasted malts. Because of the huge popularity of porters, brewers made them in a variety of strengths. The stronger beers were called "stout porters", so the history and development of stout and porter are intertwined, and the term stout has become firmly associated with dark beer, rather than just strong beer.	https://en.wikipedia.org/wiki/Stout	17.20	stout	\N	Stout is a dark beer made using roasted malt or roasted barley, hops, water and yeast	None	APPROVED	t	f	5	1	1	0	0	0	0	1	t	UNCLASSIFIED	f	4	645	\N	646	644	632	2	\N	643	f	0	None	0
160	Stroke play	2017-11-08 18:08:01.848078-05	2017-11-08 18:08:11.09317-05	Stroke play, also known as medal play, is a scoring system in the sport of golf. It involves counting the total number of strokes taken on each hole during a given round, or series of rounds. The winner is the player who has taken the fewest strokes over the course of the round, or rounds.\nAlthough most professional tournaments are played using the stroke play scoring system, there are, or have been, some notable exceptions, for example the WGC-Accenture Match Play Championship and Volvo World Match Play Championship, which are both played in a match play format, and The International, a former PGA Tour event that used a modified stableford system. Most team events, for example the Ryder Cup, are also contested using the match play format.	https://en.wikipedia.org/wiki/Stroke_play	1	stroke_play	none	Golf scoring.	Most tournaments enforce a cut, which in a typical 72-hole tournament is done after 36 holes. The number of players who "make the cut" depends on the tournament rules - in a typical PGA Tour event the top 70 professionals (plus ties) after 36 holes. Any player who turns in a score higher than the "cut line" will "miss the cut" and take no further part in the tournament.\nCount back:\nOne method commonly used in amateur competitions, especially when a playoff is not practicable, is a scorecard "count back", whereby comparing scores hole by hole starting with 17, then 16 and so on... the first player with a lower score is declared the loser. This ensures that the player who was in the lead before the tie occurred is declared the winner. To put it another way, to win a tournament one must equal and then pass the leader...not merely catch up to him.	APPROVED	t	f	3	1	0	0	1	0	0	1	t	UNCLASSIFIED	f	1	649	\N	650	648	636	4	\N	647	f	0	None	0
161	Sudovian Book	2017-11-08 18:08:01.943983-05	2017-11-08 18:08:01.943993-05	The so-called Sudovian Book[nb 1] (German: Sudauer Büchlein, Lithuanian: Sūduvių knygelė) was an anonymous work about the customs, religion, and daily life of the Old Prussians from Sambia. The manuscript was written in German in the 16th century. The original did not survive and the book is known from later copies, transcriptions and publications. Modern scholars disagree on the origin and value of the book. Despite doubts about its reliability, the book became popular and was frequently quoted in other history books. Much of the Prussian mythology is reconstructed based on this work or its derivatives.	https://en.wikipedia.org/wiki/Sudovian_Book	1545	sudovian_book	\N	The so-called Sudovian Bookwas an anonymous work about the customs of the Old Prussians.	None	APPROVED	t	f	0	0	0	0	0	0	0	0	t	UNCLASSIFIED	f	3	653	\N	654	652	640	3	\N	651	f	0	None	0
162	Sun	2017-11-08 18:08:02.032856-05	2017-11-08 18:08:11.149961-05	The Sun is the star at the center of the Solar System. It is a nearly perfect sphere of hot plasma, with internal convective motion that generates a magnetic field via a dynamo process. It is by far the most important source of energy for life on Earth. Its diameter is about 109 times that of Earth, and its mass is about 330,000 times that of Earth, accounting for about 99.86% of the total mass of the Solar System. About three quarters of the Sun's mass consists of hydrogen (~73%); the rest is mostly helium (~25%), with much smaller quantities of heavier elements, including oxygen, carbon, neon, and iron.\nThe Sun is a G-type main-sequence star (G2V) based on its spectral class. As such, it is informally referred to as a yellow dwarf. It formed approximately 4.6 billion years ago from the gravitational collapse of matter within a region of a large molecular cloud. Most of this matter gathered in the center, whereas the rest flattened into an orbiting disk that became the Solar System. The central mass became so hot and dense that it eventually initiated nuclear fusion in its core. It is thought that almost all stars form by this process.\nThe Sun is roughly middle-aged; it has not changed dramatically for more than four billion years, and will remain fairly stable for more than another five billion years. After hydrogen fusion in its core has diminished to the point at which it is no longer in hydrostatic equilibrium, the core of the Sun will experience a marked increase in density and temperature while its outer layers expand to eventually become a red giant. It is calculated that the Sun will become sufficiently large to engulf the current orbits of Mercury and Venus, and render Earth uninhabitable.\nThe enormous effect of the Sun on Earth has been recognized since prehistoric times, and the Sun has been regarded by some cultures as a deity. The synodic rotation of Earth and its orbit around the Sun are the basis of the solar calendar, which is the predominant calendar in use today.	https://en.wikipedia.org/wiki/Sun	1.0	sun	\N	The Sun is the star at the center of the Solar System.	Requires the internet.	APPROVED	t	f	5	2	2	0	0	0	0	2	t	UNCLASSIFIED	f	3	657	\N	658	656	644	3	\N	655	f	0	None	0
163	Superunknown	2017-11-08 18:08:02.118264-05	2017-11-08 18:08:11.234172-05	Superunknown is the fourth album by American rock band Soundgarden, released on February 18, 1994, through A&M Records. It is the band's second album with bassist Ben Shepherd, and features new producer Michael Beinhorn.	https://en.wikipedia.org/wiki/Superunknown	19.94	superunknown	\N	Superunknown is the fourth album by American rock band Soundgarden	Good speakers	APPROVED	t	f	4	2	1	0	1	0	0	2	t	UNCLASSIFIED//FOR OFFICIAL USE ONLY	f	2	661	\N	662	660	648	1	\N	659	f	0	None	0
164	T-slot nut	2017-11-08 18:08:02.222272-05	2017-11-08 18:08:02.222281-05	A T-slot nut is used with a threaded clamp to position and secure pieces being worked on in a workshop. The T-slot nut slides along a T-slot track, which is set in workbench or table for a router, drill press, or bandsaw. T-slot nuts are also used with extruded aluminum framing, such as 80/20, to build a variety of industrial structures and machines.\n\nA T-slot bolt is generally stronger than a T-slot nut and hex-head cap screw.\n\nA heavy-duty T-slot nut with a M12 bolt is rated to support 10000 N (about 1 imperial ton).\n\nProfile 40×40 (40 mm by 40 mm, with 8 mm grooves) extruded aluminum profile[clarify] and the T-slot nuts to fit into them comprised the first modular system developed for use in mechanical engineering in 1980 by item Industrietechnik. The item aluminum framing system has since been expanded to include a variety of t-slot nuts that have been designed for specific applications.\n\nThe item system is very similar to the "channel-and-groove design" used in some toys.	https://en.wikipedia.org/wiki/T-slot_nut	1	t-slot_nut	\N	A T-slot nut is used with a threaded clamp.	None	APPROVED	t	f	0	0	0	0	0	0	0	0	t	UNCLASSIFIED	f	3	665	\N	666	664	652	5	\N	663	f	0	None	0
165	Taxonomy Classifier	2017-11-08 18:08:02.293912-05	2017-11-08 18:08:02.29392-05	Taxonomy (from Ancient Greek τάξις (taxis), meaning 'arrangement', and -νομία (-nomia), meaning 'method') is the science of defining and naming groups of biological organisms on the basis of shared characteristics. Organisms are grouped together into taxa (singular: taxon) and these groups are given a taxonomic rank; groups of a given rank can be aggregated to form a super group of higher rank, thus creating a taxonomic hierarchy. The Swedish botanist Carl Linnaeus is regarded as the father of taxonomy, as he developed a system known as Linnaean taxonomy for categorization of organisms and binomial nomenclature for naming organisms.	https://en.wikipedia.org/wiki/Taxonomy_(biology)	10.5.1	taxonomy_classifier	Linnaean system has progressed to a system of modern biological classification based on the evolutionary relationships between organisms, both living and extinct.	Science of defining and naming groups of biological organisms on the basis of shared characteristics	Knowledge of Science	APPROVED	t	f	0	0	0	0	0	0	0	0	t	UNCLASSIFIED	f	3	669	\N	670	668	656	3	\N	667	f	0	None	0
174	Venus	2017-11-08 18:08:03.059495-05	2017-11-08 18:08:11.641396-05	Venus is the second planet from the Sun, orbiting it every 224.7 Earth days. It has the longest rotation period (243 days) of any planet in the Solar System and rotates in the opposite direction to most other planets. It has no natural satellites. It is named after the Roman goddess of love and beauty. It is the second-brightest natural object in the night sky after the Moon, reaching an apparent magnitude of −4.6 - bright enough to cast shadows at night and, rarely, visible to the naked eye in broad daylight. Orbiting within Earth's orbit, Venus is an inferior planet and never appears to venture far from the Sun; its maximum angular distance from the Sun (elongation) is 47.8°.\n\nVenus is a terrestrial planet and is sometimes called Earth's "sister planet" because of their similar size, mass, proximity to the Sun, and bulk composition. It is radically different from Earth in other respects. It has the densest atmosphere of the four terrestrial planets, consisting of more than 96% carbon dioxide. The atmospheric pressure at the planet's surface is 92 times that of Earth, or roughly the pressure found 900 m (3,000 ft) underwater on Earth. Venus is by far the hottest planet in the Solar System, with a mean surface temperature of 735 K (462 °C; 863 °F), even though Mercury is closer to the Sun. Venus is shrouded by an opaque layer of highly reflective clouds of sulfuric acid, preventing its surface from being seen from space in visible light. It may have had water oceans in the past, but these would have vaporized as the temperature rose due to a runaway greenhouse effect. The water has probably photodissociated, and the free hydrogen has been swept into interplanetary space by the solar wind because of the lack of a planetary magnetic field. Venus's surface is a dry desertscape interspersed with slab-like rocks and is periodically resurfaced by volcanism.\n\nAs one of the brightest objects in the sky, Venus has been a major fixture in human culture for as long as records have existed. It has been made sacred to gods of many cultures, and has been a prime inspiration for writers and poets as the "morning star" and "evening star". Venus was the first planet to have its motions plotted across the sky, as early as the second millennium BC.\n\nAs the closest planet to Earth, Venus has been a prime target for early interplanetary exploration. It was the first planet beyond Earth visited by a spacecraft (Mariner 2 in 1962), and the first to be successfully landed on (by Venera 7 in 1970). Venus's thick clouds render observation of its surface impossible in visible light, and the first detailed maps did not emerge until the arrival of the Magellan orbiter in 1991. Plans have been proposed for rovers or more complex missions, but they are hindered by Venus's hostile surface conditions.	https://en.wikipedia.org/wiki/Venus	1.0	venus	\N	Venus is the second planet from the Sun, orbiting it every 224.7 Earth days.	Requires the internet.	APPROVED	t	f	2.5	2	0	1	0	0	1	2	t	UNCLASSIFIED	f	3	705	\N	706	704	692	3	\N	703	f	0	None	0
166	Ten	2017-11-08 18:08:02.363684-05	2017-11-08 18:08:11.343413-05	Ten is the debut studio album by American rock band Pearl Jam, released on August 27, 1991 through Epic Records. Following the disbanding of bassist Jeff Ament and guitarist Stone Gossard's previous group Mother Love Bone, the two recruited vocalist Eddie Vedder, guitarist Mike McCready, and drummer Dave Krusen to form Pearl Jam in 1990. Most of the songs began as instrumental jams, to which Vedder added lyrics about topics such as depression, homelessness, and abuse.	https://en.wikipedia.org/wiki/Ten_%28Pearl_Jam_album%29	19.91	ten	\N	Ten is the debut studio album by American rock band Pearl Jam	More Flannel	APPROVED	t	f	4	3	1	1	1	0	0	3	t	UNCLASSIFIED	f	3	673	\N	674	672	660	3	\N	671	f	0	None	0
167	Tennis	2017-11-08 18:08:02.437743-05	2017-11-08 18:08:02.437752-05	Tennis is a racket sport that can be played individually against a single opponent (singles) or between two teams of two players each (doubles). Each player uses a tennis racket that is strung with cord to strike a hollow rubber ball covered with felt over or around a net and into the opponent's court. The object of the game is to play the ball in such a way that the opponent is not able to play a valid return. The player who is unable to return the ball will not gain a point, while the opposite player will.	https://en.wikipedia.org/wiki/Tennis	2-4	tennis	\N	Tennis is a racket sport.	Rackets & Balls	APPROVED	t	f	0	0	0	0	0	0	0	0	t	UNCLASSIFIED	f	4	677	\N	678	676	664	5	\N	675	f	0	None	0
168	Tiny Music... Songs from the Vatican Gift Shop	2017-11-08 18:08:02.508629-05	2017-11-08 18:08:11.403074-05	Tiny Music... Songs from the Vatican Gift Shop is the third album by American rock band Stone Temple Pilots, released on March 26, 1996, on Atlantic Records. After a brief hiatus in 1995, the band regrouped to record Tiny Music, living and recording the album together in a mansion located in Santa Barbara, California.	https://en.wikipedia.org/wiki/Tiny_Music..._Songs_from_the_Vatican_Gift_Shop	199.6	tiny_music..._songs_from_the_vatican_gift_shop	\N	Tiny Music... Songs from the Vatican Gift Shop is the third album by American rock band STP.	None	APPROVED	t	f	3.5	2	0	1	1	0	0	2	t	UNCLASSIFIED	f	8	681	\N	682	680	668	5	\N	679	f	0	None	0
169	Tornado	2017-11-08 18:08:02.616672-05	2017-11-08 18:08:11.524208-05	Tornado is a rapidly rotating column of air that is in contact with both the surface of the Earth and a cumulonimbus cloud or, in rare cases, the base of a cumulus cloud. They are often referred to as twisters, whirlwinds or cyclones, although the word cyclone is used in meteorology to name a weather system with a low-pressure area in the center around which winds blow counterclockwise in the Northern Hemisphere and clockwise in the Southern	https://en.wikipedia.org/wiki/Tornado	1.85	tornado	Most tornadoes have wind speeds less than 110 miles per hour	Rotating column of air that is in contact with both the surface of the Earth and a cloud	Weather system with a low-pressure area in the center around which winds blow counterclockwise	APPROVED	t	t	1	3	0	0	0	0	3	3	t	UNCLASSIFIED	f	2	685	\N	686	684	672	3	\N	683	f	0	None	0
170	Toyota	2017-11-08 18:08:02.735969-05	2017-11-08 18:08:02.735978-05	Toyota Motor Corporation (Japanese: トヨタ自動車株式会社 Hepburn: Toyota Jidōsha KK, IPA: [toꜜjota], English: /tɔɪˈoʊtə/) is a Japanese multinational automotive manufacturer headquartered in Toyota, Aichi, Japan. In March 2014, Toyota's corporate structure consisted of 338,875 employees worldwide and, as of October 2016, was the ninth-largest company in the world by revenue. As of 2016, Toyota is the world's largest automotive manufacturer. Toyota was the world's first automobile manufacturer to produce more than 10 million vehicles per year which it has done since 2012, when it also reported the production of its 200-millionth vehicle. As of July 2014, Toyota was the largest listed company in Japan by market capitalization (worth more than twice as much as #2-ranked SoftBank) and by revenue.	https://en.wikipedia.org/wiki/Toyota	1	toyota	\N	Toyota Motor Corporation is a Japanese multinational automotive manufacturer.	None	APPROVED	t	f	0	0	0	0	0	0	0	0	t	UNCLASSIFIED	f	3	689	\N	690	688	676	4	\N	687	f	0	None	0
171	Transport Direct Portal	2017-11-08 18:08:02.83211-05	2017-11-08 18:08:02.832118-05	From Wikipedia, the free encyclopedia\nThe Transport Direct Portal was a distributed Internet-based multi-modal journey planner providing information for travel in England, Wales and Scotland. It was managed by Transport Direct, a division of the Department for Transport. It was launched in 2004 and was operated by a consortium led by Atos and later enhanced to include a cycle journey planning function. The closure of the portal was announced in September 2014 "Closure of the Transport Direct website" (PDF). and the portal closed on 30 September 2014.	https://en.wikipedia.org/wiki/Transport_Direct_Portal	1.0	transport_direct_portal	\N	Transport Direct Portal was a distributed Internet-based multi-modal	None	APPROVED	t	f	0	0	0	0	0	0	0	0	t	UNCLASSIFIED	f	4	693	\N	694	692	680	4	\N	691	f	0	None	0
172	Udea washingtonalis	2017-11-08 18:08:02.882056-05	2017-11-08 18:08:02.882065-05	Udea washingtonalis is a moth in the Crambidae family. It was described by Grote in 1882. It is found in North America, where it has been recorded from Alaska, British Columbia, California, Montana and Washington.\nThe wingspan is about 21 mm. The forewings are white with a dark brown band from the middle of the costa half-way to the inner margin. The antemedial and postmedial lines are broken and indistinct and there are black spots along the outer margin and the distal half of the costa. There is also pale yellowish shading in the median area. The hindwings are white with a diffuse yellowish terminal band and black dots along the outer margin. Adults are on wing from May to August.	https://en.wikipedia.org/wiki/Udea_washingtonalis	1	udea_washingtonalis	\N	Udea washingtonalis is a moth in the Crambidae family.	None	APPROVED	f	f	0	0	0	0	0	0	0	0	t	UNCLASSIFIED	f	3	697	\N	698	696	684	5	\N	695	f	0	None	0
173	Uranus	2017-11-08 18:08:03.005734-05	2017-11-08 18:08:11.584532-05	Uranus is the seventh planet from the Sun. It has the third-largest planetary radius and fourth-largest planetary mass in the Solar System. Uranus is similar in composition to Neptune, and both have different bulk chemical composition from that of the larger gas giants Jupiter and Saturn. For this reason, scientists often classify Uranus and Neptune as "ice giants" to distinguish them from the gas giants. Uranus's atmosphere is similar to Jupiter's and Saturn's in its primary composition of hydrogen and helium, but it contains more "ices" such as water, ammonia, and methane, along with traces of other hydrocarbons. It is the coldest planetary atmosphere in the Solar System, with a minimum temperature of 49 K (−224 °C; −371 °F), and has a complex, layered cloud structure with water thought to make up the lowest clouds and methane the uppermost layer of clouds. The interior of Uranus is mainly composed of ices and rock.\n\nUranus is the only planet whose name is derived from a figure from Greek mythology, from the Latinised version of the Greek god of the sky Ouranos. Like the other giant planets, Uranus has a ring system, a magnetosphere, and numerous moons. The Uranian system has a unique configuration among those of the planets because its axis of rotation is tilted sideways, nearly into the plane of its solar orbit. Its north and south poles, therefore, lie where most other planets have their equators. In 1986, images from Voyager 2 showed Uranus as an almost featureless planet in visible light, without the cloud bands or storms associated with the other giant planets. Observations from Earth have shown seasonal change and increased weather activity as Uranus approached its equinox in 2007. Wind speeds can reach 250 metres per second (900 km/h; 560 mph).	https://en.wikipedia.org/wiki/Uranus	1.0	uranus	\N	Uranus is the seventh planet from the Sun.	Requires the internet.	APPROVED	t	f	3.5	2	1	0	0	1	0	2	t	UNCLASSIFIED	f	3	701	\N	702	700	688	3	\N	699	f	0	None	0
175	Violin	2017-11-08 18:08:03.30894-05	2017-11-08 18:08:03.308961-05	Violin is a wooden string instrument in the violin family. It is the smallest and highest-pitched instrument in the family in regular use. Smaller violin-type instruments are known, including the violino piccolo and the kit violin, but these are virtually unused in the 2010s	https://en.wikipedia.org/wiki/Violin	0.5.1	violin	earliest stringed instruments were mostly plucked	Wooden string instrument in the violin family	The body of violin and bow	APPROVED	t	f	0	0	0	0	0	0	0	0	t	UNCLASSIFIED	f	2	709	\N	710	708	696	3	\N	707	f	0	None	0
176	Virtual Boy	\N	2017-11-08 18:08:03.868102-05	The Virtual Boy is a 32-bit table-top video game console developed and manufactured by Nintendo. Released in 1995, it was marketed as the first console capable of displaying stereoscopic 3D graphics. The player uses the console in a manner similar to a head-mounted display, placing their head against the eyepiece to see a red monochrome display. The games use a parallax effect to create the illusion of depth. Sales failed to meet targets, and by early 1996, Nintendo ceased distribution and game development, only ever releasing 22 games for the system.	https://en.wikipedia.org/wiki/Virtual_Boy	32bit	virtual_boy	\N	The Virtual Boy is a 32-bit table-top video game console developed and manufactured by Nintendo.	Pain meds for headaches and poor posture.  Ability to see red and black.	APPROVED_ORG	f	f	0	0	0	0	0	0	0	0	t	UNCLASSIFIED	f	4	713	\N	714	712	699	2	\N	711	f	0	None	0
177	Voodoo	\N	2017-11-08 18:08:03.899981-05	Louisiana Voodoo, also known as New Orleans Voodoo, describes a set of spiritual folkways developed from the traditions of the African diaspora. It is a cultural form of the Afro-American religions developed by West and Central Africans populations of the U.S. state of Louisiana. Voodoo is one of many incarnations of African-based spiritual folkways rooted in West African Dahomeyan Vodun. Its liturgical language is Louisiana Creole French, the language of the Louisiana Creole people.\n\nVoodoo became syncretized with the Catholic and Francophone culture of New Orleans as a result of the African cultural oppression in the region resulting from the Atlantic slave trade. Louisiana Voodoo is often confused with—but is not completely separable from—Haitian Vodou and Deep Southern Hoodoo. It differs from Haitian Vodou in its emphasis upon gris-gris, Voodoo queens, use of Hoodoo paraphernalia, and Li Grand Zombi. It was through Louisiana Voodoo that such terms as gris-gris (a Wolof term)[citation needed] and "Voodoo dolls"' were introduced into the American lexicon.	https://en.wikipedia.org/wiki/Louisiana_Voodoo	1	voodoo	None.	Voodoo was brought to French Louisiana during the colonial period by enslaved Africans.	none	PENDING	t	f	0	0	0	0	0	0	0	0	t	UNCLASSIFIED	f	1	717	\N	718	716	701	5	\N	715	f	0	None	0
179	Weissbier	\N	2017-11-08 18:08:04.094515-05	Weizenbier or Hefeweizen, in the southern parts of Bavaria usually called Weißbier (literally "white beer", but the name probably derives from Weizenbier, "wheat beer"), is a beer, traditionally from Bavaria, in which a significant proportion of malted barley is replaced with malted wheat. By German law, Weißbiers brewed in Germany must be top-fermented. Specialized strains of yeast are used which produce overtones of banana and clove as by-products of fermentation. Weißbier is so called because it was, at the time of its inception, paler in color than Munich's traditional brown beer. It is well known throughout Germany, though better known as Weizen ("Wheat") outside Bavaria. The terms Hefeweizen ("yeast wheat") or Hefeweißbier refer to wheat beer in its traditional, unfiltered form. The term Kristallweizen (crystal wheat), or kristall Weiß (crystal white beer), refers to a wheat beer that is filtered to remove the yeast and wheat proteins which contribute to its cloudy appearance.	https://en.wikipedia.org/wiki/Wheat_beer#Weissbier	15ibu	weissbier	\N	Weizenbier or Hefeweizen, in the southern parts of Bavaria usually called Weißbier.	None	PENDING	t	f	0	0	0	0	0	0	0	0	t	UNCLASSIFIED//FOR OFFICIAL USE ONLY	f	2	725	\N	726	724	707	5	\N	723	f	0	None	0
178	Waterme Lon	2017-11-08 18:08:03.998256-05	2017-11-08 18:08:11.722851-05	Watermelon Citrullus lanatus var. lanatus is a scrambling and trailing vine in the flowering plant family Cucurbitaceae. The species originated in southern Africa, and there is evidence of its cultivation in Ancient Egypt. It is grown in tropical and sub-tropical areas worldwide for its large edible fruit, also known as a watermelon, which is a special kind of berry with a hard rind and no internal division, botanically called a pepo. The sweet, juicy flesh is usually deep red to pink, with many black seeds. The fruit can be eaten raw or pickled and the rind is edible after cooking.	http://localhost.com	1	waterme_lon	\N	Tasty fruit for the summer.	None	APPROVED	t	f	4.70000000000000018	3	2	1	0	0	0	3	t	UNCLASSIFIED	f	4	721	\N	722	720	705	2	\N	719	f	0	None	0
180	White Horse	2017-11-08 18:08:04.231323-05	2017-11-08 18:08:11.749326-05	is one of two extant subspecies of Equus ferus. It is an odd-toed ungulate mammal belonging to the taxonomic family Equidae. The horse has evolved over the past 45 to 55 million years from a small multi-toed creature, Eohippus, into the large, single-toed animal of today. Humans began to domesticate horses around 4000 BC, and their domestication is believed to have been widespread by 3000 BC. Horses in the subspecies caballus are domesticated, although some domesticated populations live in the wild as feral horses. These feral populations are not true wild horses, as this term is used to describe horses that have never been domesticated, such as the endangered Przewalski's horse, a separate subspecies, and the only remaining true wild horse. There is an extensive, specialized vocabulary used to describe equine-related concepts, covering everything from anatomy to life stages, size, colors, markings, breeds, locomotion, and behavior.	https://en.wikipedia.org/wiki/Horse	1.5	white_horse	Horses' anatomy enables them to make use of speed to escape predators and they have a well-developed sense of balance and a strong fight-or-flight response	Large single-toed animal	Horses are prey animals with a strong fight-or-flight response	APPROVED	t	f	4	1	0	1	0	0	0	1	t	UNCLASSIFIED	f	2	729	\N	730	728	711	3	\N	727	f	0	None	0
181	White-tailed olalla rat	2017-11-08 18:08:04.339546-05	2017-11-08 18:08:04.339557-05	The white-tailed olalla rat (Olallamys albicauda) is a species of rodent in the family Echimyidae. It is endemic to Colombia. Its natural habitat is subtropical or tropical moist lowland forests. It is threatened by habitat loss.	https://en.wikipedia.org/wiki/White-tailed_olalla_rat	1	white-tailed_olalla_rat	\N	The white-tailed olalla rat (Olallamys albicauda) is a species of rodent in the family Echimyidae.	None	APPROVED	t	f	0	0	0	0	0	0	0	0	t	UNCLASSIFIED//FOR OFFICIAL USE ONLY	f	3	733	\N	734	732	715	5	\N	731	f	0	None	0
182	Wii	2017-11-08 18:08:04.632823-05	2017-11-08 18:08:04.632833-05	The Wii (/ˈwiː/ WEE) is a home video game console released by Nintendo on November 19, 2006. As a seventh-generation console, the Wii competed with Microsoft's Xbox 360 and Sony's PlayStation 3. Nintendo states that its console targets a broader demographic than that of the two others. As of the first quarter of 2012, the Wii leads its generation over PlayStation 3 and Xbox 360 in worldwide sales, with more than 101 million units sold; in December 2009, the console broke the sales record for a single month in the United States.	https://en.wikipedia.org/wiki/Wii	249.99	wii	\N	The Wii (/ˈwiː/ WEE) is a home video game console released by Nintendo on November 19, 2006.	A TV	APPROVED	t	f	0	0	0	0	0	0	0	0	t	UNCLASSIFIED	f	1	737	\N	738	736	719	2	\N	735	f	0	None	0
183	Wii U	\N	2017-11-08 18:08:05.42312-05	The Wii U (/ˌwiː ˈjuː/ WEE YOO) is a home video game console developed by Nintendo, and the successor to the Wii. The console was released in November 2012 and was the first eighth-generation video game console, as it competes with Sony's PlayStation 4 and Microsoft's Xbox One.\n\nThe Wii U is the first Nintendo console to support HD graphics. The system's primary controller is the Wii U GamePad, which features an embedded touchscreen, and combines directional buttons, analog sticks, and action buttons. The screen can be used either as a supplement to the main display (either providing an alternate, asymmetric gameplay experience, or a means of local multiplayer without resorting to a split screen), or in supported games, to play the game directly on the GamePad independently of the television. The Wii U is backward compatible with all Wii software and accessories - games can support any combination of the GamePad, Wii Remote, Nunchuk, Balance Board, or Nintendo's more traditionally designed Classic Controller or Wii U Pro Controller for input. Online functionality centers around the Nintendo Network platform and Miiverse, an integrated social networking service which allows users to share content in game-specific communities.	https://en.wikipedia.org/wiki/Wii_U	U	wii_u	\N	The Wii U is the first Nintendo console to support HD graphics.	A TV, or not.	PENDING	f	f	0	0	0	0	0	0	0	0	t	UNCLASSIFIED//FOR OFFICIAL USE ONLY	f	4	741	\N	742	740	721	2	\N	739	f	0	None	0
185	Witch Doctor	\N	2017-11-08 18:08:05.566093-05	A witch doctor was originally a type of healer who treated ailments believed to be caused by witchcraft. The term witch doctor is sometimes used to refer to healers, particularly in third world regions, who use traditional healing rather than contemporary medicine. In contemporary society, "witch doctor" is sometimes used derisively to refer to chiropractors,[dubious - discuss] homeopaths and faith healers.	https://en.wikipedia.org/wiki/Witch_doctor	1	witch_doctor	Modern science.	In southern Africa, the witch doctors are known as sangomas	none	PENDING	t	f	0	0	0	0	0	0	0	0	t	UNCLASSIFIED	f	1	749	\N	750	748	725	5	\N	747	f	0	None	0
184	Wikipedia	\N	2017-11-08 18:08:05.475912-05	Wikipedia (/ˌwɪkɪˈpiːdiə/ (About this sound listen) WIK-i-PEE-dee-ə or /ˌwɪkiˈpiːdiə/ (About this sound listen) WIK-ee-PEE-dee-ə) is a free online encyclopedia with the aim to allow anyone to edit articles. Wikipedia is the largest and most popular general reference work on the Internet and is ranked among the ten most popular websites. Wikipedia is owned by the nonprofit Wikimedia Foundation.\n\nWikipedia was launched on January 15, 2001, by Jimmy Wales and Larry Sanger. Sanger coined its name, a portmanteau of wiki[notes 4] and encyclopedia. There was only the English-language version initially, but it quickly developed similar versions in other languages, which differ in content and in editing practices. With 5,459,675 articles,[notes 5] the English Wikipedia is the largest of the more than 290 Wikipedia encyclopedias. Overall, Wikipedia consists of more than 40 million articles in more than 250 different languages and, as of February 2014, it had 18 billion page views and nearly 500 million unique visitors each month.\n\nAs of March 2017, Wikipedia has about forty thousand high-quality articles known as Featured Articles and Good Articles that cover vital topics. In 2005, Nature published a peer review comparing 42 science articles from Encyclopædia Britannica and Wikipedia, and found that Wikipedia's level of accuracy approached that of Encyclopædia Britannica.\n\nWikipedia has been criticized for allegedly exhibiting systemic bias, presenting a mixture of "truths, half truths, and some falsehoods", and, in controversial topics, being subject to manipulation and spin.	https://en.wikipedia.org/wiki/Wikipedia	1	wikipedia	\N	Wikipedia, the free encyclopedia	none	PENDING	t	f	0	0	0	0	0	0	0	0	t	UNCLASSIFIED	f	1	745	\N	746	744	723	5	\N	743	f	0	None	0
186	Wolf Finder	2017-11-08 18:08:05.718934-05	2017-11-08 18:08:11.803768-05	The gray wolf or grey wolf (Canis lupus), also known as the timber wolf or western wolf, is a canine native to the wilderness and remote areas of Eurasia and North America. It is the largest extant member of its family, with males averaging 43-45 kg (95-99 lb) and females 36-38.5 kg (79-85 lb). Like the red wolf, it is distinguished from other Canis species by its larger size and less pointed features, particularly on the ears and muzzle. Its winter fur is long and bushy and predominantly a mottled gray in color, although nearly pure white, red, and brown to black also occur. As of 2005, 37 subspecies of C. lupus are recognised by MSW3.\n\nThe gray wolf is the second most specialised member of the genus Canis, after the Ethiopian wolf, as demonstrated by its morphological adaptations to hunting large prey, its more gregarious nature, and its highly advanced expressive behavior. It is nonetheless closely related enough to smaller Canis species, such as the eastern wolf, coyote, and golden jackal, to produce fertile hybrids. It is the only species of Canis to have a range encompassing both the Old and New Worlds, and originated in Eurasia during the Pleistocene, colonizing North America on at least three separate occasions during the Rancholabrean. It is a social animal, travelling in nuclear families consisting of a mated pair, accompanied by the pair's adult offspring. The gray wolf is typically an apex predator throughout its range, with only humans and tigers posing a serious threat to it. It feeds primarily on large ungulates, though it also eats smaller animals, livestock, carrion, and garbage.	https://en.wikipedia.org/wiki/Gray_wolf	1.0.9	wolf_finder	\N	The gray wolf is one of the world's best-known and most-researched animals.	The gray wolf is a habitat generalist, and can occur in deserts, grasslands, forests and arctic tundras	APPROVED	t	f	4.5	2	1	1	0	0	0	2	t	UNCLASSIFIED	f	2	753	\N	754	752	729	3	\N	751	f	0	None	0
187	Wolverine	2017-11-08 18:08:05.776188-05	2017-11-08 18:08:11.830967-05	Wolverine (born James Howlett commonly known as Logan and sometimes as Weapon X) is a fictional character appearing in American comic books published by Marvel Comics, mostly in association with the X-Men. He is a mutant who possesses animal-keen senses, enhanced physical capabilities, powerful regenerative ability known as a healing factor, and three retractable bone claws in each hand. Wolverine has been depicted variously as a member of the X-Men, Alpha Flight, and the Avengers.\nThe character appeared in the last panel of The Incredible Hulk #180 before having a larger role in #181 (cover-dated Nov. 1974). He was created by writer Len Wein and Marvel art director John Romita, Sr., who designed the character, and was first drawn for publication by Herb Trimpe. Wolverine then joined a revamped version of the superhero team the X-Men, where eventually writer Chris Claremont and artist-writer John Byrne would play significant roles in the character's development. Artist Frank Miller collaborated with Claremont and helped to revise the character with a four-part eponymous limited series from September to December 1982 which debuted Wolverine's catchphrase, "I'm the best there is at what I do, but what I do best isn't very nice."\nWolverine is typical of the many tough antiheroes that emerged in American popular culture after the Vietnam War; his willingness to use deadly force and his brooding nature became standard characteristics for comic book antiheroes by the end of the 1980s. As a result, the character became a fan favorite of the increasingly popular X-Men franchise, and has been featured in his own solo comic since 1988.\nHe has appeared in most X-Men adaptations, including animated television series, video games, and the live-action 20th Century Fox X-Men film series, in which he is portrayed by Hugh Jackman in nine of the ten films. The character is highly rated in many comics best-of lists, ranked #1 in Wizard magazine's 2008 Top 200 Comic Book Characters; 4th in Empire's 2008 Greatest Comic Characters; and 4th on IGN's 2011 Top 100 Comic Book Heroes.	https://en.wikipedia.org/wiki/Wolverine_(character)	1	wolverine	\N	Stabs things	None	APPROVED	t	f	3	1	0	0	1	0	0	1	t	UNCLASSIFIED	f	2	757	\N	758	756	733	4	\N	755	f	0	None	0
188	Writing	2017-11-08 18:08:05.845084-05	2017-11-08 18:08:05.845094-05	Writing is a medium of human communication that represents language and emotion with signs and symbols. In most languages, writing is a complement to speech or spoken language. Writing is not a language, but a tool developed by human society. Within a language system, writing relies on many of the same structures as speech, such as vocabulary, grammar, and semantics, with the added dependency of a system of signs or symbols. The result of writing is called text, and the recipient of text is called a reader. Motivations for writing include publication, storytelling, correspondence and diary. Writing has been instrumental in keeping history, maintaining culture, dissemination of knowledge through the media and the formation of legal systems.	https://en.wikipedia.org/wiki/Writing	15.05	writing	It is possible to also write using a laptop	Writing is a medium of human communication, represents language and emotion with signs and symbols	A pen and paper	APPROVED	t	f	0	0	0	0	0	0	0	0	t	UNCLASSIFIED//FOR OFFICIAL USE ONLY	f	2	761	\N	762	760	737	3	\N	759	f	0	None	0
9	Azeroth	2017-11-08 18:07:44.540127-05	2017-11-08 18:08:06.55879-05	Azeroth is the name of the world in which the majority of the Warcraft series is set. The world of Azeroth is the birthplace of many races, most notable being elves (night elves, high elves, and blood elves), humans, dwarves, tauren, goblins, trolls, gnomes, pandarens and dragons. At its birth, Azeroth was blessed by the titans. One day, the demonic armies of the Burning Legion came and shattered the peace and led the night elves to sunder their world. Gradually, races were dragged to Azeroth (such as the orcs, draenei, and ogres), others evolved, and others were brought up from the dust itself.\nThe peoples of Azeroth have fought brutally against the demons and their servants, and much blood was, and is still being, shed. After the Third War, three major powers emerged: the Scourge, Horde, and Alliance. Other major powers include the naga, qiraji, and Scarlet Crusade. Although ravaged by conflict, somehow through trickery, betrayal, and sheer blood, Azeroth has survived the Burning Legion four times. However, Azeroth is still torn by conflict, hate, and war.	http://wowwiki.wikia.com/wiki/Azeroth_(world)	1.0	azeroth	\N	Azeroth is the name of the world in which the majority of the Warcraft series is set.	Requires the internet. And skillz.	APPROVED	t	f	4.20000000000000018	5	3	0	2	0	0	5	t	UNCLASSIFIED	f	3	45	\N	46	44	34	3	\N	43	f	0	None	0
116	Navigation	2017-11-08 18:07:55.633103-05	2017-11-08 18:08:10.044763-05	From Wikipedia, the free encyclopedia\nThis article is about determination of position and direction on or above the surface of the earth. For other uses, see Navigation (disambiguation).\nTable of geography, hydrography, and navigation, from the 1728 Cyclopaedia\nNavigation is a field of study that focuses on the process of monitoring and controlling the movement of a craft or vehicle from one place to another. The field of navigation includes four general categories: land navigation, marine navigation, aeronautic navigation, and space navigation.\nIt is also the term of art used for the specialized knowledge used by navigators to perform navigation tasks. All navigational techniques involve locating the navigator's position compared to known locations or patterns.\nNavigation, in a broader sense, can refer to any skill or study that involves the determination of position and direction. In this sense, navigation includes orienteering and pedestrian navigation. For information about different navigation strategies that people use, visit human navigation.	https://en.wikipedia.org/wiki/Navigation	1.0	navigation	\N	Navigation is a field of study that focuses on the movement of a craft or vehicle	None	APPROVED	t	f	4.20000000000000018	5	3	1	0	1	0	5	t	UNCLASSIFIED	f	4	473	\N	474	472	462	3	\N	471	f	0	None	0
\.


--
-- Name: ozpcenter_listing_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ozp_user
--

SELECT pg_catalog.setval('ozpcenter_listing_id_seq', 188, true);


--
-- Data for Name: ozpcenter_listingactivity; Type: TABLE DATA; Schema: public; Owner: ozp_user
--

COPY ozpcenter_listingactivity (id, action, activity_date, description, author_id, listing_id) FROM stdin;
1	CREATED	2017-11-08 18:07:43.769394-05	\N	1	1
2	SUBMITTED	2017-11-08 18:07:43.774634-05	\N	1	1
3	APPROVED_ORG	2017-11-08 18:07:43.77861-05	\N	1	1
4	APPROVED	2017-11-08 18:07:43.782456-05	\N	1	1
5	CREATED	2017-11-08 18:07:43.90722-05	\N	5	2
6	SUBMITTED	2017-11-08 18:07:43.911149-05	\N	5	2
7	APPROVED_ORG	2017-11-08 18:07:43.915357-05	\N	5	2
8	APPROVED	2017-11-08 18:07:43.919604-05	\N	5	2
9	CREATED	2017-11-08 18:07:43.942162-05	\N	4	3
10	SUBMITTED	2017-11-08 18:07:43.945855-05	\N	4	3
11	CREATED	2017-11-08 18:07:43.987407-05	\N	9	4
12	SUBMITTED	2017-11-08 18:07:43.991354-05	\N	9	4
13	APPROVED_ORG	2017-11-08 18:07:43.995237-05	\N	4	4
14	APPROVED	2017-11-08 18:07:43.999165-05	\N	4	4
15	CREATED	2017-11-08 18:07:44.057585-05	\N	15	5
16	SUBMITTED	2017-11-08 18:07:44.061356-05	\N	15	5
17	APPROVED_ORG	2017-11-08 18:07:44.06508-05	\N	1	5
18	APPROVED	2017-11-08 18:07:44.068793-05	\N	1	5
19	CREATED	2017-11-08 18:07:44.102065-05	\N	17	6
20	SUBMITTED	2017-11-08 18:07:44.105677-05	\N	17	6
21	APPROVED_ORG	2017-11-08 18:07:44.109304-05	\N	1	6
22	APPROVED	2017-11-08 18:07:44.113006-05	\N	1	6
23	CREATED	2017-11-08 18:07:44.373718-05	\N	5	7
24	SUBMITTED	2017-11-08 18:07:44.377916-05	\N	5	7
25	APPROVED_ORG	2017-11-08 18:07:44.38188-05	\N	1	7
26	APPROVED	2017-11-08 18:07:44.385788-05	\N	1	7
27	CREATED	2017-11-08 18:07:44.446718-05	\N	4	8
28	SUBMITTED	2017-11-08 18:07:44.450478-05	\N	4	8
29	APPROVED_ORG	2017-11-08 18:07:44.45439-05	\N	4	8
30	APPROVED	2017-11-08 18:07:44.458176-05	\N	4	8
31	CREATED	2017-11-08 18:07:44.525801-05	\N	12	9
32	SUBMITTED	2017-11-08 18:07:44.529517-05	\N	12	9
33	APPROVED_ORG	2017-11-08 18:07:44.533747-05	\N	1	9
34	APPROVED	2017-11-08 18:07:44.537774-05	\N	1	9
35	CREATED	2017-11-08 18:07:44.707539-05	\N	4	10
36	SUBMITTED	2017-11-08 18:07:44.711557-05	\N	4	10
37	APPROVED_ORG	2017-11-08 18:07:44.715585-05	\N	4	10
38	APPROVED	2017-11-08 18:07:44.719468-05	\N	4	10
39	CREATED	2017-11-08 18:07:44.751437-05	\N	13	11
40	SUBMITTED	2017-11-08 18:07:44.756233-05	\N	13	11
41	APPROVED_ORG	2017-11-08 18:07:44.76135-05	\N	4	11
42	APPROVED	2017-11-08 18:07:44.766066-05	\N	4	11
43	CREATED	2017-11-08 18:07:44.849722-05	\N	12	12
44	SUBMITTED	2017-11-08 18:07:44.853881-05	\N	12	12
45	APPROVED_ORG	2017-11-08 18:07:44.857964-05	\N	1	12
46	APPROVED	2017-11-08 18:07:44.862223-05	\N	1	12
47	CREATED	2017-11-08 18:07:44.894945-05	\N	9	13
48	SUBMITTED	2017-11-08 18:07:44.898729-05	\N	9	13
49	APPROVED_ORG	2017-11-08 18:07:44.902366-05	\N	4	13
50	APPROVED	2017-11-08 18:07:44.906032-05	\N	4	13
51	CREATED	2017-11-08 18:07:44.935816-05	\N	13	14
52	SUBMITTED	2017-11-08 18:07:44.939354-05	\N	13	14
53	APPROVED_ORG	2017-11-08 18:07:44.943025-05	\N	4	14
54	APPROVED	2017-11-08 18:07:44.946674-05	\N	4	14
55	CREATED	2017-11-08 18:07:44.976423-05	\N	13	15
56	SUBMITTED	2017-11-08 18:07:44.980701-05	\N	13	15
57	APPROVED_ORG	2017-11-08 18:07:44.985054-05	\N	4	15
58	APPROVED	2017-11-08 18:07:44.989199-05	\N	4	15
59	CREATED	2017-11-08 18:07:45.021578-05	\N	17	16
60	SUBMITTED	2017-11-08 18:07:45.025769-05	\N	17	16
61	APPROVED_ORG	2017-11-08 18:07:45.029671-05	\N	1	16
62	APPROVED	2017-11-08 18:07:45.033977-05	\N	1	16
63	CREATED	2017-11-08 18:07:45.113732-05	\N	15	17
64	SUBMITTED	2017-11-08 18:07:45.118137-05	\N	15	17
65	APPROVED_ORG	2017-11-08 18:07:45.122279-05	\N	1	17
66	APPROVED	2017-11-08 18:07:45.126445-05	\N	1	17
67	CREATED	2017-11-08 18:07:45.172572-05	\N	4	18
68	SUBMITTED	2017-11-08 18:07:45.176177-05	\N	4	18
69	APPROVED_ORG	2017-11-08 18:07:45.179731-05	\N	4	18
70	APPROVED	2017-11-08 18:07:45.183522-05	\N	4	18
71	CREATED	2017-11-08 18:07:45.241814-05	\N	17	19
72	SUBMITTED	2017-11-08 18:07:45.246991-05	\N	17	19
73	APPROVED_ORG	2017-11-08 18:07:45.25231-05	\N	1	19
74	APPROVED	2017-11-08 18:07:45.257327-05	\N	1	19
75	CREATED	2017-11-08 18:07:45.354846-05	\N	15	20
76	SUBMITTED	2017-11-08 18:07:45.359589-05	\N	15	20
77	APPROVED_ORG	2017-11-08 18:07:45.363993-05	\N	1	20
78	APPROVED	2017-11-08 18:07:45.368487-05	\N	1	20
79	CREATED	2017-11-08 18:07:45.42714-05	\N	13	21
80	SUBMITTED	2017-11-08 18:07:45.431407-05	\N	13	21
81	APPROVED_ORG	2017-11-08 18:07:45.435826-05	\N	4	21
82	APPROVED	2017-11-08 18:07:45.440241-05	\N	4	21
83	CREATED	2017-11-08 18:07:45.559198-05	\N	4	22
84	SUBMITTED	2017-11-08 18:07:45.563375-05	\N	4	22
85	APPROVED_ORG	2017-11-08 18:07:45.567583-05	\N	4	22
86	APPROVED	2017-11-08 18:07:45.571692-05	\N	4	22
87	CREATED	2017-11-08 18:07:45.647801-05	\N	6	23
88	SUBMITTED	2017-11-08 18:07:45.651827-05	\N	6	23
89	APPROVED_ORG	2017-11-08 18:07:45.656169-05	\N	5	23
90	APPROVED	2017-11-08 18:07:45.660777-05	\N	5	23
91	CREATED	2017-11-08 18:07:45.710413-05	\N	13	24
92	SUBMITTED	2017-11-08 18:07:45.714904-05	\N	13	24
93	APPROVED_ORG	2017-11-08 18:07:45.719511-05	\N	1	24
94	APPROVED	2017-11-08 18:07:45.724135-05	\N	1	24
95	CREATED	2017-11-08 18:07:45.772045-05	\N	9	25
96	SUBMITTED	2017-11-08 18:07:45.776294-05	\N	9	25
97	APPROVED_ORG	2017-11-08 18:07:45.780737-05	\N	4	25
98	APPROVED	2017-11-08 18:07:45.784875-05	\N	4	25
99	CREATED	2017-11-08 18:07:45.99652-05	\N	5	26
100	SUBMITTED	2017-11-08 18:07:46.001105-05	\N	5	26
101	APPROVED_ORG	2017-11-08 18:07:46.00565-05	\N	1	26
102	APPROVED	2017-11-08 18:07:46.010274-05	\N	1	26
103	CREATED	2017-11-08 18:07:46.164337-05	\N	5	27
104	SUBMITTED	2017-11-08 18:07:46.168666-05	\N	1	27
105	APPROVED_ORG	2017-11-08 18:07:46.172821-05	\N	1	27
106	APPROVED	2017-11-08 18:07:46.176963-05	\N	1	27
107	CREATED	2017-11-08 18:07:46.273936-05	\N	15	28
108	SUBMITTED	2017-11-08 18:07:46.278037-05	\N	15	28
109	APPROVED_ORG	2017-11-08 18:07:46.282331-05	\N	1	28
110	APPROVED	2017-11-08 18:07:46.287066-05	\N	1	28
111	CREATED	2017-11-08 18:07:46.360575-05	\N	15	29
112	SUBMITTED	2017-11-08 18:07:46.364647-05	\N	15	29
113	APPROVED_ORG	2017-11-08 18:07:46.369248-05	\N	1	29
114	APPROVED	2017-11-08 18:07:46.373527-05	\N	1	29
115	CREATED	2017-11-08 18:07:46.446897-05	\N	5	30
116	SUBMITTED	2017-11-08 18:07:46.450829-05	\N	5	30
117	APPROVED_ORG	2017-11-08 18:07:46.455105-05	\N	5	30
118	APPROVED	2017-11-08 18:07:46.459325-05	\N	5	30
119	CREATED	2017-11-08 18:07:46.488173-05	\N	4	31
120	SUBMITTED	2017-11-08 18:07:46.492727-05	\N	4	31
121	APPROVED_ORG	2017-11-08 18:07:46.497095-05	\N	4	31
122	APPROVED	2017-11-08 18:07:46.50441-05	\N	4	31
123	CREATED	2017-11-08 18:07:46.628459-05	\N	6	32
124	SUBMITTED	2017-11-08 18:07:46.63376-05	\N	6	32
125	APPROVED_ORG	2017-11-08 18:07:46.639244-05	\N	5	32
126	APPROVED	2017-11-08 18:07:46.644579-05	\N	5	32
127	CREATED	2017-11-08 18:07:46.824406-05	\N	4	33
128	SUBMITTED	2017-11-08 18:07:46.828795-05	\N	4	33
129	APPROVED_ORG	2017-11-08 18:07:46.833146-05	\N	4	33
130	APPROVED	2017-11-08 18:07:46.837698-05	\N	4	33
131	CREATED	2017-11-08 18:07:46.892987-05	\N	13	34
132	SUBMITTED	2017-11-08 18:07:46.897646-05	\N	13	34
133	APPROVED_ORG	2017-11-08 18:07:46.902532-05	\N	4	34
134	APPROVED	2017-11-08 18:07:46.907232-05	\N	4	34
135	CREATED	2017-11-08 18:07:47.090253-05	\N	4	35
136	SUBMITTED	2017-11-08 18:07:47.095082-05	\N	4	35
137	APPROVED_ORG	2017-11-08 18:07:47.099791-05	\N	4	35
138	APPROVED	2017-11-08 18:07:47.104454-05	\N	4	35
139	CREATED	2017-11-08 18:07:47.13854-05	\N	4	36
140	SUBMITTED	2017-11-08 18:07:47.14312-05	\N	4	36
141	APPROVED_ORG	2017-11-08 18:07:47.147548-05	\N	4	36
142	APPROVED	2017-11-08 18:07:47.151882-05	\N	4	36
143	CREATED	2017-11-08 18:07:47.192551-05	\N	4	37
144	SUBMITTED	2017-11-08 18:07:47.197117-05	\N	4	37
145	APPROVED_ORG	2017-11-08 18:07:47.201528-05	\N	4	37
146	APPROVED	2017-11-08 18:07:47.206115-05	\N	4	37
147	CREATED	2017-11-08 18:07:47.280386-05	\N	5	38
148	SUBMITTED	2017-11-08 18:07:47.284937-05	\N	5	38
149	APPROVED_ORG	2017-11-08 18:07:47.289289-05	\N	5	38
150	APPROVED	2017-11-08 18:07:47.293562-05	\N	5	38
151	CREATED	2017-11-08 18:07:47.347855-05	\N	4	39
152	SUBMITTED	2017-11-08 18:07:47.352276-05	\N	4	39
153	APPROVED_ORG	2017-11-08 18:07:47.356909-05	\N	4	39
154	APPROVED	2017-11-08 18:07:47.36123-05	\N	4	39
155	CREATED	2017-11-08 18:07:47.400005-05	\N	13	40
156	SUBMITTED	2017-11-08 18:07:47.404661-05	\N	13	40
157	APPROVED_ORG	2017-11-08 18:07:47.409441-05	\N	4	40
158	APPROVED	2017-11-08 18:07:47.414403-05	\N	4	40
159	CREATED	2017-11-08 18:07:47.455899-05	\N	17	41
160	SUBMITTED	2017-11-08 18:07:47.460523-05	\N	17	41
161	APPROVED_ORG	2017-11-08 18:07:47.465215-05	\N	1	41
162	APPROVED	2017-11-08 18:07:47.46972-05	\N	1	41
163	CREATED	2017-11-08 18:07:47.533676-05	\N	17	42
164	SUBMITTED	2017-11-08 18:07:47.538063-05	\N	17	42
165	APPROVED_ORG	2017-11-08 18:07:47.542474-05	\N	1	42
166	APPROVED	2017-11-08 18:07:47.547307-05	\N	1	42
167	CREATED	2017-11-08 18:07:47.852851-05	\N	5	43
168	SUBMITTED	2017-11-08 18:07:47.857374-05	\N	5	43
169	APPROVED_ORG	2017-11-08 18:07:47.862068-05	\N	1	43
170	APPROVED	2017-11-08 18:07:47.866414-05	\N	1	43
171	CREATED	2017-11-08 18:07:48.117369-05	\N	3	44
172	SUBMITTED	2017-11-08 18:07:48.122144-05	\N	3	44
173	APPROVED_ORG	2017-11-08 18:07:48.126978-05	\N	3	44
174	APPROVED	2017-11-08 18:07:48.131913-05	\N	3	44
175	CREATED	2017-11-08 18:07:48.24597-05	\N	9	45
176	SUBMITTED	2017-11-08 18:07:48.250392-05	\N	9	45
177	APPROVED_ORG	2017-11-08 18:07:48.254587-05	\N	4	45
178	APPROVED	2017-11-08 18:07:48.258939-05	\N	4	45
179	CREATED	2017-11-08 18:07:48.301077-05	\N	4	46
180	SUBMITTED	2017-11-08 18:07:48.30538-05	\N	4	46
181	APPROVED_ORG	2017-11-08 18:07:48.310242-05	\N	4	46
182	APPROVED	2017-11-08 18:07:48.31468-05	\N	4	46
183	CREATED	2017-11-08 18:07:48.487744-05	\N	3	47
184	SUBMITTED	2017-11-08 18:07:48.491396-05	\N	3	47
185	APPROVED_ORG	2017-11-08 18:07:48.494931-05	\N	3	47
186	APPROVED	2017-11-08 18:07:48.498437-05	\N	3	47
187	CREATED	2017-11-08 18:07:48.614219-05	\N	4	48
188	SUBMITTED	2017-11-08 18:07:48.617781-05	\N	4	48
189	APPROVED_ORG	2017-11-08 18:07:48.621244-05	\N	4	48
190	APPROVED	2017-11-08 18:07:48.624705-05	\N	4	48
191	CREATED	2017-11-08 18:07:48.679306-05	\N	1	49
192	SUBMITTED	2017-11-08 18:07:48.682845-05	\N	1	49
193	APPROVED_ORG	2017-11-08 18:07:48.686302-05	\N	1	49
194	APPROVED	2017-11-08 18:07:48.689753-05	\N	1	49
195	CREATED	2017-11-08 18:07:48.743278-05	\N	1	50
196	SUBMITTED	2017-11-08 18:07:48.746632-05	\N	1	50
197	APPROVED_ORG	2017-11-08 18:07:48.749893-05	\N	1	50
198	APPROVED	2017-11-08 18:07:48.753139-05	\N	1	50
199	CREATED	2017-11-08 18:07:48.843513-05	\N	4	51
200	SUBMITTED	2017-11-08 18:07:48.84645-05	\N	1	51
201	CREATED	2017-11-08 18:07:48.972731-05	\N	4	52
202	SUBMITTED	2017-11-08 18:07:48.976701-05	\N	4	52
203	APPROVED_ORG	2017-11-08 18:07:48.980501-05	\N	4	52
204	APPROVED	2017-11-08 18:07:48.984701-05	\N	4	52
205	CREATED	2017-11-08 18:07:49.030278-05	\N	4	53
206	SUBMITTED	2017-11-08 18:07:49.035035-05	\N	4	53
207	APPROVED_ORG	2017-11-08 18:07:49.039799-05	\N	4	53
208	APPROVED	2017-11-08 18:07:49.046392-05	\N	4	53
209	CREATED	2017-11-08 18:07:49.176289-05	\N	4	54
210	SUBMITTED	2017-11-08 18:07:49.179895-05	\N	4	54
211	APPROVED_ORG	2017-11-08 18:07:49.183976-05	\N	4	54
212	APPROVED	2017-11-08 18:07:49.187407-05	\N	4	54
213	CREATED	2017-11-08 18:07:49.222619-05	\N	4	55
214	SUBMITTED	2017-11-08 18:07:49.225963-05	\N	4	55
215	APPROVED_ORG	2017-11-08 18:07:49.22966-05	\N	4	55
216	APPROVED	2017-11-08 18:07:49.233462-05	\N	4	55
217	CREATED	2017-11-08 18:07:49.462488-05	\N	9	56
218	SUBMITTED	2017-11-08 18:07:49.466911-05	\N	9	56
219	APPROVED_ORG	2017-11-08 18:07:49.47113-05	\N	4	56
220	APPROVED	2017-11-08 18:07:49.475406-05	\N	4	56
221	CREATED	2017-11-08 18:07:49.546735-05	\N	1	57
222	SUBMITTED	2017-11-08 18:07:49.550655-05	\N	1	57
223	APPROVED_ORG	2017-11-08 18:07:49.554949-05	\N	1	57
224	APPROVED	2017-11-08 18:07:49.558635-05	\N	1	57
225	CREATED	2017-11-08 18:07:49.628629-05	\N	5	58
226	SUBMITTED	2017-11-08 18:07:49.63212-05	\N	5	58
227	APPROVED_ORG	2017-11-08 18:07:49.63557-05	\N	5	58
228	APPROVED	2017-11-08 18:07:49.638954-05	\N	5	58
229	CREATED	2017-11-08 18:07:49.80148-05	\N	15	59
230	SUBMITTED	2017-11-08 18:07:49.805806-05	\N	15	59
231	APPROVED_ORG	2017-11-08 18:07:49.80993-05	\N	1	59
232	APPROVED	2017-11-08 18:07:49.814223-05	\N	1	59
233	CREATED	2017-11-08 18:07:49.857876-05	\N	4	60
234	SUBMITTED	2017-11-08 18:07:49.86194-05	\N	4	60
235	APPROVED_ORG	2017-11-08 18:07:49.86575-05	\N	4	60
236	APPROVED	2017-11-08 18:07:49.869841-05	\N	4	60
237	CREATED	2017-11-08 18:07:49.916863-05	\N	15	61
238	SUBMITTED	2017-11-08 18:07:49.92046-05	\N	15	61
239	APPROVED_ORG	2017-11-08 18:07:49.924281-05	\N	1	61
240	APPROVED	2017-11-08 18:07:49.928339-05	\N	1	61
241	CREATED	2017-11-08 18:07:49.998466-05	\N	4	62
242	SUBMITTED	2017-11-08 18:07:50.002348-05	\N	4	62
243	APPROVED_ORG	2017-11-08 18:07:50.006575-05	\N	4	62
244	APPROVED	2017-11-08 18:07:50.010351-05	\N	4	62
245	CREATED	2017-11-08 18:07:50.034894-05	\N	13	63
246	SUBMITTED	2017-11-08 18:07:50.038412-05	\N	13	63
247	APPROVED_ORG	2017-11-08 18:07:50.041867-05	\N	4	63
248	APPROVED	2017-11-08 18:07:50.045407-05	\N	4	63
249	CREATED	2017-11-08 18:07:50.103688-05	\N	1	64
250	SUBMITTED	2017-11-08 18:07:50.107604-05	\N	1	64
251	APPROVED_ORG	2017-11-08 18:07:50.111802-05	\N	1	64
252	APPROVED	2017-11-08 18:07:50.115438-05	\N	1	64
253	CREATED	2017-11-08 18:07:50.155675-05	\N	13	65
254	SUBMITTED	2017-11-08 18:07:50.159049-05	\N	13	65
255	APPROVED_ORG	2017-11-08 18:07:50.162474-05	\N	4	65
256	SUBMITTED	2017-11-08 18:07:50.165959-05	\N	4	65
257	APPROVED_ORG	2017-11-08 18:07:50.169457-05	\N	4	65
258	APPROVED	2017-11-08 18:07:50.172825-05	\N	4	65
259	CREATED	2017-11-08 18:07:50.238302-05	\N	5	66
260	SUBMITTED	2017-11-08 18:07:50.241759-05	\N	5	66
261	APPROVED_ORG	2017-11-08 18:07:50.245663-05	\N	5	66
262	APPROVED	2017-11-08 18:07:50.249556-05	\N	5	66
263	CREATED	2017-11-08 18:07:50.359454-05	\N	9	67
264	SUBMITTED	2017-11-08 18:07:50.36363-05	\N	9	67
265	APPROVED_ORG	2017-11-08 18:07:50.367377-05	\N	4	67
266	APPROVED	2017-11-08 18:07:50.371253-05	\N	4	67
267	CREATED	2017-11-08 18:07:50.468427-05	\N	1	68
268	SUBMITTED	2017-11-08 18:07:50.471967-05	\N	1	68
269	APPROVED_ORG	2017-11-08 18:07:50.475483-05	\N	1	68
270	APPROVED	2017-11-08 18:07:50.478668-05	\N	1	68
271	CREATED	2017-11-08 18:07:51.222915-05	\N	1	69
272	SUBMITTED	2017-11-08 18:07:51.227039-05	\N	1	69
273	APPROVED_ORG	2017-11-08 18:07:51.231193-05	\N	1	69
274	APPROVED	2017-11-08 18:07:51.235347-05	\N	1	69
275	CREATED	2017-11-08 18:07:51.298653-05	\N	3	70
276	SUBMITTED	2017-11-08 18:07:51.302599-05	\N	3	70
277	APPROVED_ORG	2017-11-08 18:07:51.307563-05	\N	3	70
278	APPROVED	2017-11-08 18:07:51.311495-05	\N	3	70
279	CREATED	2017-11-08 18:07:51.364821-05	\N	4	71
280	SUBMITTED	2017-11-08 18:07:51.36864-05	\N	4	71
281	APPROVED_ORG	2017-11-08 18:07:51.372782-05	\N	4	71
282	APPROVED	2017-11-08 18:07:51.377199-05	\N	4	71
283	CREATED	2017-11-08 18:07:51.401149-05	\N	4	72
284	SUBMITTED	2017-11-08 18:07:51.405155-05	\N	1	72
285	APPROVED_ORG	2017-11-08 18:07:51.408856-05	\N	1	72
286	APPROVED	2017-11-08 18:07:51.412308-05	\N	1	72
287	CREATED	2017-11-08 18:07:51.478213-05	\N	1	73
288	SUBMITTED	2017-11-08 18:07:51.481631-05	\N	1	73
289	APPROVED_ORG	2017-11-08 18:07:51.485089-05	\N	1	73
290	APPROVED	2017-11-08 18:07:51.488587-05	\N	1	73
291	CREATED	2017-11-08 18:07:51.886814-05	\N	5	74
292	SUBMITTED	2017-11-08 18:07:51.891117-05	\N	5	74
293	APPROVED_ORG	2017-11-08 18:07:51.895185-05	\N	1	74
294	APPROVED	2017-11-08 18:07:51.899139-05	\N	1	74
295	CREATED	2017-11-08 18:07:51.989583-05	\N	15	75
296	SUBMITTED	2017-11-08 18:07:51.993561-05	\N	15	75
297	APPROVED_ORG	2017-11-08 18:07:51.99799-05	\N	1	75
298	APPROVED	2017-11-08 18:07:52.001931-05	\N	1	75
299	CREATED	2017-11-08 18:07:52.089592-05	\N	4	76
300	SUBMITTED	2017-11-08 18:07:52.093628-05	\N	4	76
301	APPROVED_ORG	2017-11-08 18:07:52.097626-05	\N	4	76
302	APPROVED	2017-11-08 18:07:52.101653-05	\N	4	76
303	CREATED	2017-11-08 18:07:52.135592-05	\N	17	77
304	SUBMITTED	2017-11-08 18:07:52.13967-05	\N	17	77
305	APPROVED_ORG	2017-11-08 18:07:52.143615-05	\N	1	77
306	APPROVED	2017-11-08 18:07:52.147978-05	\N	1	77
307	CREATED	2017-11-08 18:07:52.208836-05	\N	4	78
308	SUBMITTED	2017-11-08 18:07:52.212757-05	\N	4	78
309	APPROVED_ORG	2017-11-08 18:07:52.216902-05	\N	4	78
310	APPROVED	2017-11-08 18:07:52.220685-05	\N	4	78
311	CREATED	2017-11-08 18:07:52.322257-05	\N	12	79
312	SUBMITTED	2017-11-08 18:07:52.327187-05	\N	12	79
313	APPROVED_ORG	2017-11-08 18:07:52.331918-05	\N	1	79
314	APPROVED	2017-11-08 18:07:52.336425-05	\N	1	79
315	CREATED	2017-11-08 18:07:52.367038-05	\N	4	80
316	SUBMITTED	2017-11-08 18:07:52.370955-05	\N	4	80
317	APPROVED_ORG	2017-11-08 18:07:52.374656-05	\N	4	80
318	APPROVED	2017-11-08 18:07:52.378615-05	\N	4	80
319	CREATED	2017-11-08 18:07:52.436312-05	\N	17	81
320	SUBMITTED	2017-11-08 18:07:52.442441-05	\N	17	81
321	APPROVED_ORG	2017-11-08 18:07:52.44834-05	\N	1	81
322	APPROVED	2017-11-08 18:07:52.454004-05	\N	1	81
323	CREATED	2017-11-08 18:07:52.550669-05	\N	5	82
324	SUBMITTED	2017-11-08 18:07:52.555374-05	\N	5	82
325	APPROVED_ORG	2017-11-08 18:07:52.559925-05	\N	5	82
326	APPROVED	2017-11-08 18:07:52.564656-05	\N	5	82
327	CREATED	2017-11-08 18:07:52.649746-05	\N	12	83
328	SUBMITTED	2017-11-08 18:07:52.653832-05	\N	12	83
329	APPROVED_ORG	2017-11-08 18:07:52.658487-05	\N	1	83
330	APPROVED	2017-11-08 18:07:52.662557-05	\N	1	83
331	CREATED	2017-11-08 18:07:52.688006-05	\N	4	84
332	SUBMITTED	2017-11-08 18:07:52.692491-05	\N	4	84
333	APPROVED_ORG	2017-11-08 18:07:52.696467-05	\N	4	84
334	APPROVED	2017-11-08 18:07:52.700282-05	\N	4	84
335	CREATED	2017-11-08 18:07:52.78897-05	\N	4	85
336	SUBMITTED	2017-11-08 18:07:52.792926-05	\N	4	85
337	APPROVED_ORG	2017-11-08 18:07:52.796364-05	\N	4	85
338	APPROVED	2017-11-08 18:07:52.799754-05	\N	4	85
339	CREATED	2017-11-08 18:07:52.89361-05	\N	15	86
340	SUBMITTED	2017-11-08 18:07:52.89791-05	\N	15	86
341	APPROVED_ORG	2017-11-08 18:07:52.901887-05	\N	1	86
342	APPROVED	2017-11-08 18:07:52.905863-05	\N	1	86
343	CREATED	2017-11-08 18:07:52.983861-05	\N	1	87
344	SUBMITTED	2017-11-08 18:07:52.988307-05	\N	1	87
345	APPROVED_ORG	2017-11-08 18:07:52.993125-05	\N	1	87
346	APPROVED	2017-11-08 18:07:52.997851-05	\N	1	87
347	CREATED	2017-11-08 18:07:53.081614-05	\N	3	88
348	SUBMITTED	2017-11-08 18:07:53.085875-05	\N	3	88
349	APPROVED_ORG	2017-11-08 18:07:53.089924-05	\N	3	88
350	APPROVED	2017-11-08 18:07:53.094384-05	\N	3	88
351	CREATED	2017-11-08 18:07:53.238324-05	\N	9	89
352	SUBMITTED	2017-11-08 18:07:53.24234-05	\N	9	89
353	APPROVED_ORG	2017-11-08 18:07:53.246371-05	\N	4	89
354	APPROVED	2017-11-08 18:07:53.250509-05	\N	4	89
355	CREATED	2017-11-08 18:07:53.354801-05	\N	4	90
356	SUBMITTED	2017-11-08 18:07:53.358761-05	\N	4	90
357	APPROVED_ORG	2017-11-08 18:07:53.36268-05	\N	4	90
358	APPROVED	2017-11-08 18:07:53.366647-05	\N	4	90
359	CREATED	2017-11-08 18:07:53.413914-05	\N	1	91
360	SUBMITTED	2017-11-08 18:07:53.417511-05	\N	1	91
361	APPROVED_ORG	2017-11-08 18:07:53.421005-05	\N	1	91
362	APPROVED	2017-11-08 18:07:53.424614-05	\N	1	91
363	CREATED	2017-11-08 18:07:53.521035-05	\N	3	92
364	SUBMITTED	2017-11-08 18:07:53.525111-05	\N	3	92
365	APPROVED_ORG	2017-11-08 18:07:53.529161-05	\N	3	92
366	APPROVED	2017-11-08 18:07:53.533136-05	\N	3	92
367	CREATED	2017-11-08 18:07:53.594023-05	\N	1	93
368	SUBMITTED	2017-11-08 18:07:53.59758-05	\N	1	93
369	APPROVED_ORG	2017-11-08 18:07:53.600823-05	\N	1	93
370	APPROVED	2017-11-08 18:07:53.604034-05	\N	1	93
371	CREATED	2017-11-08 18:07:53.673004-05	\N	1	94
372	SUBMITTED	2017-11-08 18:07:53.677079-05	\N	1	94
373	APPROVED_ORG	2017-11-08 18:07:53.681308-05	\N	1	94
374	APPROVED	2017-11-08 18:07:53.685512-05	\N	1	94
375	CREATED	2017-11-08 18:07:53.751718-05	\N	5	95
376	SUBMITTED	2017-11-08 18:07:53.755124-05	\N	5	95
377	APPROVED_ORG	2017-11-08 18:07:53.758608-05	\N	5	95
378	APPROVED	2017-11-08 18:07:53.762079-05	\N	5	95
379	CREATED	2017-11-08 18:07:53.826987-05	\N	5	96
380	SUBMITTED	2017-11-08 18:07:53.830241-05	\N	5	96
381	APPROVED_ORG	2017-11-08 18:07:53.833497-05	\N	5	96
382	APPROVED	2017-11-08 18:07:53.8367-05	\N	5	96
383	CREATED	2017-11-08 18:07:53.900849-05	\N	5	97
384	SUBMITTED	2017-11-08 18:07:53.904766-05	\N	5	97
385	APPROVED_ORG	2017-11-08 18:07:53.90908-05	\N	5	97
386	APPROVED	2017-11-08 18:07:53.913291-05	\N	5	97
387	CREATED	2017-11-08 18:07:53.969043-05	\N	4	98
388	SUBMITTED	2017-11-08 18:07:53.972699-05	\N	4	98
389	APPROVED_ORG	2017-11-08 18:07:53.976376-05	\N	4	98
390	APPROVED	2017-11-08 18:07:53.980259-05	\N	4	98
391	CREATED	2017-11-08 18:07:54.013403-05	\N	15	99
392	SUBMITTED	2017-11-08 18:07:54.017135-05	\N	15	99
393	APPROVED_ORG	2017-11-08 18:07:54.020894-05	\N	1	99
394	APPROVED	2017-11-08 18:07:54.024532-05	\N	1	99
395	CREATED	2017-11-08 18:07:54.108988-05	\N	17	100
396	SUBMITTED	2017-11-08 18:07:54.113329-05	\N	17	100
397	APPROVED_ORG	2017-11-08 18:07:54.117484-05	\N	1	100
398	APPROVED	2017-11-08 18:07:54.121685-05	\N	1	100
399	CREATED	2017-11-08 18:07:54.145981-05	\N	4	101
400	SUBMITTED	2017-11-08 18:07:54.149794-05	\N	4	101
401	APPROVED_ORG	2017-11-08 18:07:54.15362-05	\N	4	101
402	APPROVED	2017-11-08 18:07:54.157611-05	\N	4	101
403	CREATED	2017-11-08 18:07:54.219272-05	\N	15	102
404	SUBMITTED	2017-11-08 18:07:54.223333-05	\N	15	102
405	APPROVED_ORG	2017-11-08 18:07:54.227685-05	\N	1	102
406	APPROVED	2017-11-08 18:07:54.23157-05	\N	1	102
407	CREATED	2017-11-08 18:07:54.289877-05	\N	4	103
408	SUBMITTED	2017-11-08 18:07:54.293829-05	\N	4	103
409	APPROVED_ORG	2017-11-08 18:07:54.297947-05	\N	4	103
410	APPROVED	2017-11-08 18:07:54.301747-05	\N	4	103
411	CREATED	2017-11-08 18:07:54.337415-05	\N	4	104
412	SUBMITTED	2017-11-08 18:07:54.341336-05	\N	4	104
413	APPROVED_ORG	2017-11-08 18:07:54.344817-05	\N	4	104
414	APPROVED	2017-11-08 18:07:54.348286-05	\N	4	104
415	CREATED	2017-11-08 18:07:54.415637-05	\N	9	105
416	SUBMITTED	2017-11-08 18:07:54.419725-05	\N	9	105
417	APPROVED_ORG	2017-11-08 18:07:54.423634-05	\N	4	105
418	APPROVED	2017-11-08 18:07:54.427471-05	\N	4	105
419	CREATED	2017-11-08 18:07:54.469259-05	\N	4	106
420	SUBMITTED	2017-11-08 18:07:54.473083-05	\N	4	106
421	APPROVED_ORG	2017-11-08 18:07:54.476924-05	\N	4	106
422	APPROVED	2017-11-08 18:07:54.480906-05	\N	4	106
423	CREATED	2017-11-08 18:07:54.544344-05	\N	4	107
424	SUBMITTED	2017-11-08 18:07:54.548553-05	\N	4	107
425	APPROVED_ORG	2017-11-08 18:07:54.552883-05	\N	4	107
426	APPROVED	2017-11-08 18:07:54.557183-05	\N	4	107
427	CREATED	2017-11-08 18:07:54.675287-05	\N	1	108
428	SUBMITTED	2017-11-08 18:07:54.680614-05	\N	1	108
429	APPROVED_ORG	2017-11-08 18:07:54.686195-05	\N	1	108
430	APPROVED	2017-11-08 18:07:54.691571-05	\N	1	108
431	CREATED	2017-11-08 18:07:54.749696-05	\N	13	109
432	SUBMITTED	2017-11-08 18:07:54.754134-05	\N	13	109
433	APPROVED_ORG	2017-11-08 18:07:54.758633-05	\N	4	109
434	APPROVED	2017-11-08 18:07:54.762969-05	\N	4	109
435	CREATED	2017-11-08 18:07:54.833508-05	\N	4	110
436	SUBMITTED	2017-11-08 18:07:54.837882-05	\N	4	110
437	APPROVED_ORG	2017-11-08 18:07:54.842622-05	\N	4	110
438	APPROVED	2017-11-08 18:07:54.84692-05	\N	4	110
439	CREATED	2017-11-08 18:07:54.931509-05	\N	4	111
440	SUBMITTED	2017-11-08 18:07:54.935988-05	\N	4	111
441	APPROVED_ORG	2017-11-08 18:07:54.940509-05	\N	4	111
442	APPROVED	2017-11-08 18:07:54.94512-05	\N	4	111
443	CREATED	2017-11-08 18:07:55.012359-05	\N	15	112
444	SUBMITTED	2017-11-08 18:07:55.016726-05	\N	15	112
445	APPROVED_ORG	2017-11-08 18:07:55.020917-05	\N	7	112
446	APPROVED	2017-11-08 18:07:55.025196-05	\N	1	112
447	CREATED	2017-11-08 18:07:55.069237-05	\N	4	113
448	SUBMITTED	2017-11-08 18:07:55.0736-05	\N	4	113
449	APPROVED_ORG	2017-11-08 18:07:55.077967-05	\N	4	113
450	APPROVED	2017-11-08 18:07:55.082257-05	\N	4	113
451	CREATED	2017-11-08 18:07:55.214968-05	\N	4	114
452	SUBMITTED	2017-11-08 18:07:55.219871-05	\N	4	114
453	APPROVED_ORG	2017-11-08 18:07:55.224191-05	\N	4	114
454	APPROVED	2017-11-08 18:07:55.228535-05	\N	4	114
455	CREATED	2017-11-08 18:07:55.514792-05	\N	4	115
456	SUBMITTED	2017-11-08 18:07:55.51933-05	\N	4	115
457	APPROVED_ORG	2017-11-08 18:07:55.523725-05	\N	4	115
458	APPROVED	2017-11-08 18:07:55.527974-05	\N	4	115
459	CREATED	2017-11-08 18:07:55.617497-05	\N	15	116
460	SUBMITTED	2017-11-08 18:07:55.621965-05	\N	15	116
461	APPROVED_ORG	2017-11-08 18:07:55.62628-05	\N	1	116
462	APPROVED	2017-11-08 18:07:55.630674-05	\N	1	116
463	CREATED	2017-11-08 18:07:55.731601-05	\N	15	117
464	SUBMITTED	2017-11-08 18:07:55.736424-05	\N	15	117
465	APPROVED_ORG	2017-11-08 18:07:55.741397-05	\N	1	117
466	APPROVED	2017-11-08 18:07:55.746643-05	\N	1	117
467	CREATED	2017-11-08 18:07:55.841001-05	\N	12	118
468	SUBMITTED	2017-11-08 18:07:55.846338-05	\N	12	118
469	APPROVED_ORG	2017-11-08 18:07:55.851284-05	\N	1	118
470	APPROVED	2017-11-08 18:07:55.856535-05	\N	1	118
471	CREATED	2017-11-08 18:07:55.925079-05	\N	1	119
472	SUBMITTED	2017-11-08 18:07:55.929672-05	\N	1	119
473	APPROVED_ORG	2017-11-08 18:07:55.934321-05	\N	1	119
474	APPROVED	2017-11-08 18:07:55.939163-05	\N	1	119
475	CREATED	2017-11-08 18:07:56.02025-05	\N	1	120
476	SUBMITTED	2017-11-08 18:07:56.024742-05	\N	1	120
477	APPROVED_ORG	2017-11-08 18:07:56.029334-05	\N	1	120
478	APPROVED	2017-11-08 18:07:56.034019-05	\N	1	120
479	CREATED	2017-11-08 18:07:56.117695-05	\N	1	121
480	SUBMITTED	2017-11-08 18:07:56.122067-05	\N	1	121
481	APPROVED_ORG	2017-11-08 18:07:56.126507-05	\N	1	121
482	APPROVED	2017-11-08 18:07:56.131158-05	\N	1	121
483	CREATED	2017-11-08 18:07:56.180271-05	\N	13	122
484	SUBMITTED	2017-11-08 18:07:56.185027-05	\N	13	122
485	APPROVED_ORG	2017-11-08 18:07:56.189616-05	\N	4	122
486	APPROVED	2017-11-08 18:07:56.194177-05	\N	4	122
487	CREATED	2017-11-08 18:07:56.220053-05	\N	4	123
488	SUBMITTED	2017-11-08 18:07:56.224569-05	\N	4	123
489	APPROVED_ORG	2017-11-08 18:07:56.229045-05	\N	4	123
490	APPROVED	2017-11-08 18:07:56.233551-05	\N	4	123
491	CREATED	2017-11-08 18:07:56.484833-05	\N	1	124
492	SUBMITTED	2017-11-08 18:07:56.489607-05	\N	1	124
493	APPROVED_ORG	2017-11-08 18:07:56.494171-05	\N	1	124
494	APPROVED	2017-11-08 18:07:56.498981-05	\N	1	124
495	CREATED	2017-11-08 18:07:56.569239-05	\N	4	125
496	SUBMITTED	2017-11-08 18:07:56.573505-05	\N	4	125
497	APPROVED_ORG	2017-11-08 18:07:56.577748-05	\N	4	125
498	APPROVED	2017-11-08 18:07:56.581916-05	\N	4	125
499	CREATED	2017-11-08 18:07:56.663075-05	\N	4	126
500	SUBMITTED	2017-11-08 18:07:56.667588-05	\N	4	126
501	APPROVED_ORG	2017-11-08 18:07:56.671929-05	\N	4	126
502	APPROVED	2017-11-08 18:07:56.676426-05	\N	4	126
503	CREATED	2017-11-08 18:07:56.746554-05	\N	1	127
504	SUBMITTED	2017-11-08 18:07:56.750829-05	\N	1	127
505	APPROVED_ORG	2017-11-08 18:07:56.75509-05	\N	1	127
506	APPROVED	2017-11-08 18:07:56.759471-05	\N	1	127
507	CREATED	2017-11-08 18:07:56.789264-05	\N	12	128
508	SUBMITTED	2017-11-08 18:07:56.796775-05	\N	12	128
509	APPROVED_ORG	2017-11-08 18:07:56.803724-05	\N	1	128
510	APPROVED	2017-11-08 18:07:56.810278-05	\N	1	128
511	CREATED	2017-11-08 18:07:56.936245-05	\N	3	129
512	SUBMITTED	2017-11-08 18:07:56.941436-05	\N	3	129
513	APPROVED_ORG	2017-11-08 18:07:56.946608-05	\N	3	129
514	APPROVED	2017-11-08 18:07:56.951906-05	\N	3	129
515	CREATED	2017-11-08 18:07:57.05835-05	\N	15	130
516	SUBMITTED	2017-11-08 18:07:57.062549-05	\N	15	130
517	APPROVED_ORG	2017-11-08 18:07:57.066675-05	\N	1	130
518	SUBMITTED	2017-11-08 18:07:57.070518-05	\N	15	130
519	CREATED	2017-11-08 18:07:57.151649-05	\N	4	131
520	SUBMITTED	2017-11-08 18:07:57.156946-05	\N	4	131
521	APPROVED_ORG	2017-11-08 18:07:57.162111-05	\N	4	131
522	APPROVED	2017-11-08 18:07:57.16721-05	\N	4	131
523	CREATED	2017-11-08 18:07:57.310331-05	\N	4	132
524	SUBMITTED	2017-11-08 18:07:57.318029-05	\N	4	132
525	APPROVED_ORG	2017-11-08 18:07:57.325784-05	\N	4	132
526	APPROVED	2017-11-08 18:07:57.333352-05	\N	4	132
527	CREATED	2017-11-08 18:07:57.744884-05	\N	5	133
528	SUBMITTED	2017-11-08 18:07:57.74865-05	\N	5	133
529	APPROVED_ORG	2017-11-08 18:07:57.752256-05	\N	1	133
530	APPROVED	2017-11-08 18:07:57.755972-05	\N	1	133
531	CREATED	2017-11-08 18:07:57.976695-05	\N	15	134
532	SUBMITTED	2017-11-08 18:07:57.980801-05	\N	15	134
533	APPROVED_ORG	2017-11-08 18:07:57.984946-05	\N	7	134
534	APPROVED	2017-11-08 18:07:57.988927-05	\N	1	134
535	CREATED	2017-11-08 18:07:58.020386-05	\N	17	135
536	SUBMITTED	2017-11-08 18:07:58.025004-05	\N	17	135
537	APPROVED_ORG	2017-11-08 18:07:58.029873-05	\N	1	135
538	APPROVED	2017-11-08 18:07:58.034521-05	\N	1	135
539	CREATED	2017-11-08 18:07:58.113558-05	\N	3	136
540	SUBMITTED	2017-11-08 18:07:58.118079-05	\N	3	136
541	APPROVED_ORG	2017-11-08 18:07:58.122829-05	\N	3	136
542	APPROVED	2017-11-08 18:07:58.127578-05	\N	3	136
543	CREATED	2017-11-08 18:07:58.274767-05	\N	3	137
544	SUBMITTED	2017-11-08 18:07:58.279082-05	\N	3	137
545	APPROVED_ORG	2017-11-08 18:07:58.28349-05	\N	3	137
546	APPROVED	2017-11-08 18:07:58.287909-05	\N	3	137
547	CREATED	2017-11-08 18:07:58.59961-05	\N	3	138
548	SUBMITTED	2017-11-08 18:07:58.603987-05	\N	3	138
549	APPROVED_ORG	2017-11-08 18:07:58.608459-05	\N	3	138
550	APPROVED	2017-11-08 18:07:58.612886-05	\N	3	138
551	CREATED	2017-11-08 18:07:58.698595-05	\N	15	139
552	SUBMITTED	2017-11-08 18:07:58.702902-05	\N	15	139
553	APPROVED_ORG	2017-11-08 18:07:58.707198-05	\N	1	139
554	APPROVED	2017-11-08 18:07:58.711553-05	\N	1	139
555	CREATED	2017-11-08 18:07:58.738502-05	\N	4	140
556	SUBMITTED	2017-11-08 18:07:58.74321-05	\N	4	140
557	APPROVED_ORG	2017-11-08 18:07:58.747807-05	\N	4	140
558	APPROVED	2017-11-08 18:07:58.752496-05	\N	4	140
559	CREATED	2017-11-08 18:07:59.067974-05	\N	4	141
560	SUBMITTED	2017-11-08 18:07:59.072524-05	\N	4	141
561	APPROVED_ORG	2017-11-08 18:07:59.07695-05	\N	4	141
562	APPROVED	2017-11-08 18:07:59.081275-05	\N	4	141
563	CREATED	2017-11-08 18:07:59.256359-05	\N	1	142
564	SUBMITTED	2017-11-08 18:07:59.260807-05	\N	1	142
565	APPROVED_ORG	2017-11-08 18:07:59.265173-05	\N	1	142
566	APPROVED	2017-11-08 18:07:59.26964-05	\N	1	142
567	CREATED	2017-11-08 18:07:59.323999-05	\N	13	143
568	SUBMITTED	2017-11-08 18:07:59.328509-05	\N	13	143
569	APPROVED_ORG	2017-11-08 18:07:59.333246-05	\N	4	143
570	APPROVED	2017-11-08 18:07:59.338052-05	\N	4	143
571	CREATED	2017-11-08 18:08:00.439892-05	\N	4	144
572	SUBMITTED	2017-11-08 18:08:00.443928-05	\N	4	144
573	APPROVED_ORG	2017-11-08 18:08:00.44779-05	\N	4	144
574	SUBMITTED	2017-11-08 18:08:00.451701-05	\N	4	144
575	CREATED	2017-11-08 18:08:00.521169-05	\N	3	145
576	SUBMITTED	2017-11-08 18:08:00.525154-05	\N	3	145
577	APPROVED_ORG	2017-11-08 18:08:00.529368-05	\N	3	145
578	APPROVED	2017-11-08 18:08:00.533704-05	\N	3	145
579	CREATED	2017-11-08 18:08:00.632551-05	\N	15	146
580	SUBMITTED	2017-11-08 18:08:00.637028-05	\N	15	146
581	APPROVED_ORG	2017-11-08 18:08:00.641308-05	\N	1	146
582	APPROVED	2017-11-08 18:08:00.645478-05	\N	1	146
583	CREATED	2017-11-08 18:08:00.756784-05	\N	12	147
584	SUBMITTED	2017-11-08 18:08:00.760592-05	\N	12	147
585	APPROVED_ORG	2017-11-08 18:08:00.764214-05	\N	1	147
586	APPROVED	2017-11-08 18:08:00.767841-05	\N	1	147
587	CREATED	2017-11-08 18:08:00.848738-05	\N	13	148
588	SUBMITTED	2017-11-08 18:08:00.854193-05	\N	13	148
589	APPROVED_ORG	2017-11-08 18:08:00.859674-05	\N	1	148
590	APPROVED	2017-11-08 18:08:00.864972-05	\N	1	148
591	CREATED	2017-11-08 18:08:00.933194-05	\N	1	149
592	SUBMITTED	2017-11-08 18:08:00.937221-05	\N	1	149
593	APPROVED_ORG	2017-11-08 18:08:00.941313-05	\N	1	149
594	APPROVED	2017-11-08 18:08:00.945333-05	\N	1	149
595	CREATED	2017-11-08 18:08:01.087006-05	\N	15	150
596	SUBMITTED	2017-11-08 18:08:01.091203-05	\N	15	150
597	APPROVED_ORG	2017-11-08 18:08:01.095204-05	\N	1	150
598	APPROVED	2017-11-08 18:08:01.099202-05	\N	1	150
599	CREATED	2017-11-08 18:08:01.159274-05	\N	4	151
600	SUBMITTED	2017-11-08 18:08:01.162751-05	\N	4	151
601	APPROVED_ORG	2017-11-08 18:08:01.166156-05	\N	4	151
602	APPROVED	2017-11-08 18:08:01.169587-05	\N	4	151
603	CREATED	2017-11-08 18:08:01.241264-05	\N	5	152
604	SUBMITTED	2017-11-08 18:08:01.244685-05	\N	5	152
605	APPROVED_ORG	2017-11-08 18:08:01.248105-05	\N	5	152
606	APPROVED	2017-11-08 18:08:01.25159-05	\N	5	152
607	CREATED	2017-11-08 18:08:01.331735-05	\N	1	153
608	SUBMITTED	2017-11-08 18:08:01.335908-05	\N	1	153
609	APPROVED_ORG	2017-11-08 18:08:01.340266-05	\N	1	153
610	APPROVED	2017-11-08 18:08:01.344623-05	\N	1	153
611	CREATED	2017-11-08 18:08:01.382928-05	\N	9	154
612	SUBMITTED	2017-11-08 18:08:01.387192-05	\N	9	154
613	APPROVED_ORG	2017-11-08 18:08:01.391595-05	\N	4	154
614	APPROVED	2017-11-08 18:08:01.395945-05	\N	4	154
615	CREATED	2017-11-08 18:08:01.512503-05	\N	4	155
616	SUBMITTED	2017-11-08 18:08:01.517075-05	\N	4	155
617	APPROVED_ORG	2017-11-08 18:08:01.521365-05	\N	4	155
618	APPROVED	2017-11-08 18:08:01.525642-05	\N	4	155
619	CREATED	2017-11-08 18:08:01.59758-05	\N	1	156
620	SUBMITTED	2017-11-08 18:08:01.602027-05	\N	1	156
621	APPROVED_ORG	2017-11-08 18:08:01.606331-05	\N	1	156
622	APPROVED	2017-11-08 18:08:01.610717-05	\N	1	156
623	CREATED	2017-11-08 18:08:01.647635-05	\N	13	157
624	SUBMITTED	2017-11-08 18:08:01.65197-05	\N	13	157
625	CREATED	2017-11-08 18:08:01.707165-05	\N	4	158
626	SUBMITTED	2017-11-08 18:08:01.711504-05	\N	4	158
627	APPROVED_ORG	2017-11-08 18:08:01.715756-05	\N	4	158
628	APPROVED	2017-11-08 18:08:01.719962-05	\N	4	158
629	CREATED	2017-11-08 18:08:01.771922-05	\N	4	159
630	SUBMITTED	2017-11-08 18:08:01.776239-05	\N	4	159
631	APPROVED_ORG	2017-11-08 18:08:01.780611-05	\N	4	159
632	APPROVED	2017-11-08 18:08:01.785003-05	\N	4	159
633	CREATED	2017-11-08 18:08:01.832087-05	\N	13	160
634	SUBMITTED	2017-11-08 18:08:01.836642-05	\N	13	160
635	APPROVED_ORG	2017-11-08 18:08:01.84098-05	\N	4	160
636	APPROVED	2017-11-08 18:08:01.845532-05	\N	4	160
637	CREATED	2017-11-08 18:08:01.928481-05	\N	4	161
638	SUBMITTED	2017-11-08 18:08:01.932856-05	\N	4	161
639	APPROVED_ORG	2017-11-08 18:08:01.93716-05	\N	4	161
640	APPROVED	2017-11-08 18:08:01.941553-05	\N	4	161
641	CREATED	2017-11-08 18:08:02.015988-05	\N	12	162
642	SUBMITTED	2017-11-08 18:08:02.020717-05	\N	12	162
643	APPROVED_ORG	2017-11-08 18:08:02.025457-05	\N	1	162
644	APPROVED	2017-11-08 18:08:02.030103-05	\N	1	162
645	CREATED	2017-11-08 18:08:02.103386-05	\N	4	163
646	SUBMITTED	2017-11-08 18:08:02.107573-05	\N	4	163
647	APPROVED_ORG	2017-11-08 18:08:02.111716-05	\N	4	163
648	APPROVED	2017-11-08 18:08:02.11586-05	\N	4	163
649	CREATED	2017-11-08 18:08:02.207964-05	\N	4	164
650	SUBMITTED	2017-11-08 18:08:02.211938-05	\N	4	164
651	APPROVED_ORG	2017-11-08 18:08:02.215895-05	\N	4	164
652	APPROVED	2017-11-08 18:08:02.219836-05	\N	4	164
653	CREATED	2017-11-08 18:08:02.279715-05	\N	1	165
654	SUBMITTED	2017-11-08 18:08:02.283631-05	\N	1	165
655	APPROVED_ORG	2017-11-08 18:08:02.287652-05	\N	1	165
656	APPROVED	2017-11-08 18:08:02.29159-05	\N	1	165
657	CREATED	2017-11-08 18:08:02.349431-05	\N	4	166
658	SUBMITTED	2017-11-08 18:08:02.353542-05	\N	4	166
659	APPROVED_ORG	2017-11-08 18:08:02.357484-05	\N	4	166
660	APPROVED	2017-11-08 18:08:02.361419-05	\N	4	166
661	CREATED	2017-11-08 18:08:02.423747-05	\N	4	167
662	SUBMITTED	2017-11-08 18:08:02.427638-05	\N	4	167
663	APPROVED_ORG	2017-11-08 18:08:02.431528-05	\N	4	167
664	APPROVED	2017-11-08 18:08:02.435516-05	\N	4	167
665	CREATED	2017-11-08 18:08:02.49458-05	\N	4	168
666	SUBMITTED	2017-11-08 18:08:02.498525-05	\N	4	168
667	APPROVED_ORG	2017-11-08 18:08:02.502509-05	\N	4	168
668	APPROVED	2017-11-08 18:08:02.506331-05	\N	4	168
669	CREATED	2017-11-08 18:08:02.602692-05	\N	1	169
670	SUBMITTED	2017-11-08 18:08:02.60661-05	\N	1	169
671	APPROVED_ORG	2017-11-08 18:08:02.610514-05	\N	1	169
672	APPROVED	2017-11-08 18:08:02.614358-05	\N	1	169
673	CREATED	2017-11-08 18:08:02.721892-05	\N	4	170
674	SUBMITTED	2017-11-08 18:08:02.725867-05	\N	4	170
675	APPROVED_ORG	2017-11-08 18:08:02.729789-05	\N	4	170
676	APPROVED	2017-11-08 18:08:02.73374-05	\N	4	170
677	CREATED	2017-11-08 18:08:02.817712-05	\N	15	171
678	SUBMITTED	2017-11-08 18:08:02.82172-05	\N	15	171
679	APPROVED_ORG	2017-11-08 18:08:02.825726-05	\N	1	171
680	APPROVED	2017-11-08 18:08:02.829765-05	\N	1	171
681	CREATED	2017-11-08 18:08:02.868053-05	\N	4	172
682	SUBMITTED	2017-11-08 18:08:02.872091-05	\N	4	172
683	APPROVED_ORG	2017-11-08 18:08:02.875926-05	\N	4	172
684	APPROVED	2017-11-08 18:08:02.879801-05	\N	4	172
685	CREATED	2017-11-08 18:08:02.988241-05	\N	12	173
686	SUBMITTED	2017-11-08 18:08:02.993288-05	\N	12	173
687	APPROVED_ORG	2017-11-08 18:08:02.998229-05	\N	1	173
688	APPROVED	2017-11-08 18:08:03.003004-05	\N	1	173
689	CREATED	2017-11-08 18:08:03.037626-05	\N	12	174
690	SUBMITTED	2017-11-08 18:08:03.042367-05	\N	12	174
691	APPROVED_ORG	2017-11-08 18:08:03.04758-05	\N	1	174
692	APPROVED	2017-11-08 18:08:03.055231-05	\N	1	174
693	CREATED	2017-11-08 18:08:03.294139-05	\N	1	175
694	SUBMITTED	2017-11-08 18:08:03.298163-05	\N	1	175
695	APPROVED_ORG	2017-11-08 18:08:03.301968-05	\N	1	175
696	APPROVED	2017-11-08 18:08:03.306144-05	\N	1	175
697	CREATED	2017-11-08 18:08:03.856915-05	\N	4	176
698	SUBMITTED	2017-11-08 18:08:03.861409-05	\N	4	176
699	APPROVED_ORG	2017-11-08 18:08:03.865582-05	\N	4	176
700	CREATED	2017-11-08 18:08:03.893194-05	\N	13	177
701	SUBMITTED	2017-11-08 18:08:03.897515-05	\N	13	177
702	CREATED	2017-11-08 18:08:03.982852-05	\N	9	178
703	SUBMITTED	2017-11-08 18:08:03.987295-05	\N	9	178
704	APPROVED_ORG	2017-11-08 18:08:03.991497-05	\N	4	178
705	APPROVED	2017-11-08 18:08:03.995733-05	\N	4	178
706	CREATED	2017-11-08 18:08:04.087541-05	\N	4	179
707	SUBMITTED	2017-11-08 18:08:04.092042-05	\N	4	179
708	CREATED	2017-11-08 18:08:04.214712-05	\N	1	180
709	SUBMITTED	2017-11-08 18:08:04.219769-05	\N	1	180
710	APPROVED_ORG	2017-11-08 18:08:04.22461-05	\N	1	180
711	APPROVED	2017-11-08 18:08:04.22889-05	\N	1	180
712	CREATED	2017-11-08 18:08:04.324227-05	\N	4	181
713	SUBMITTED	2017-11-08 18:08:04.328549-05	\N	4	181
714	APPROVED_ORG	2017-11-08 18:08:04.332751-05	\N	4	181
715	APPROVED	2017-11-08 18:08:04.336997-05	\N	4	181
716	CREATED	2017-11-08 18:08:04.620486-05	\N	4	182
717	SUBMITTED	2017-11-08 18:08:04.624093-05	\N	4	182
718	APPROVED_ORG	2017-11-08 18:08:04.627477-05	\N	4	182
719	APPROVED	2017-11-08 18:08:04.630887-05	\N	4	182
720	CREATED	2017-11-08 18:08:05.41625-05	\N	4	183
721	SUBMITTED	2017-11-08 18:08:05.420773-05	\N	4	183
722	CREATED	2017-11-08 18:08:05.469581-05	\N	13	184
723	SUBMITTED	2017-11-08 18:08:05.473639-05	\N	13	184
724	CREATED	2017-11-08 18:08:05.557259-05	\N	13	185
725	SUBMITTED	2017-11-08 18:08:05.562913-05	\N	13	185
726	CREATED	2017-11-08 18:08:05.70174-05	\N	1	186
727	SUBMITTED	2017-11-08 18:08:05.706403-05	\N	1	186
728	APPROVED_ORG	2017-11-08 18:08:05.711413-05	\N	1	186
729	APPROVED	2017-11-08 18:08:05.716192-05	\N	1	186
730	CREATED	2017-11-08 18:08:05.757861-05	\N	17	187
731	SUBMITTED	2017-11-08 18:08:05.762899-05	\N	17	187
732	APPROVED_ORG	2017-11-08 18:08:05.768403-05	\N	1	187
733	APPROVED	2017-11-08 18:08:05.773416-05	\N	1	187
734	CREATED	2017-11-08 18:08:05.828459-05	\N	1	188
735	SUBMITTED	2017-11-08 18:08:05.832962-05	\N	1	188
736	APPROVED_ORG	2017-11-08 18:08:05.837423-05	\N	1	188
737	APPROVED	2017-11-08 18:08:05.842233-05	\N	1	188
\.


--
-- Name: ozpcenter_listingactivity_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ozp_user
--

SELECT pg_catalog.setval('ozpcenter_listingactivity_id_seq', 737, true);


--
-- Data for Name: ozpcenter_listingtype; Type: TABLE DATA; Schema: public; Owner: ozp_user
--

COPY ozpcenter_listingtype (id, title, description) FROM stdin;
1	Code Library	code library
2	Desktop App	desktop app
3	Web Application	web applications
4	Web Services	web services
5	Widget	widget things
\.


--
-- Name: ozpcenter_listingtype_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ozp_user
--

SELECT pg_catalog.setval('ozpcenter_listingtype_id_seq', 5, true);


--
-- Data for Name: ozpcenter_notification; Type: TABLE DATA; Schema: public; Owner: ozp_user
--

COPY ozpcenter_notification (id, created_date, message, expires_date, author_id, listing_id, agency_id, peer, group_target, notification_type, entity_id, notification_subtype) FROM stdin;
1	2017-11-08 18:07:37.217046-05	System will be going down for approximately 30 minutes on X/Y at 1100Z	2017-11-15 23:07:37.193332-05	5	\N	\N	\N	all	system	\N	\N
2	2017-11-08 18:07:37.249539-05	System will be functioning in a degredaded state between 1800Z-0400Z on A/B	2017-11-15 23:07:37.193332-05	6	\N	\N	\N	all	system	\N	\N
3	2017-11-08 18:07:37.268448-05	System will be going down for approximately 30 minutes on C/D at 1700Z	2017-11-01 23:07:37.265598-04	5	\N	\N	\N	all	system	\N	\N
4	2017-11-08 18:07:37.284911-05	System will be functioning in a degredaded state between 2100Z-0430Z on F/G	2017-11-01 23:07:37.265598-04	6	\N	\N	\N	all	system	\N	\N
5	2017-11-08 18:08:06.010858-05	A user has rated listing <b>Acoustic Guitar</b> 3 stars	2017-12-08 18:08:06.005881-05	1	1	\N	\N	user	listing	1	listing_review
6	2017-11-08 18:08:06.055249-05	A user has rated listing <b>Acoustic Guitar</b> 1 star	2017-12-08 18:08:06.050747-05	5	1	\N	\N	user	listing	1	listing_review
7	2017-11-08 18:08:06.095419-05	A user has rated listing <b>Acoustic Guitar</b> 5 stars	2017-12-08 18:08:06.091291-05	17	1	\N	\N	user	listing	1	listing_review
8	2017-11-08 18:08:06.130078-05	A user has rated listing <b>Air Mail</b> 5 stars	2017-12-08 18:08:06.126317-05	21	2	\N	\N	user	listing	2	listing_review
9	2017-11-08 18:08:06.164399-05	A user has rated listing <b>Air Mail</b> 3 stars	2017-12-08 18:08:06.160878-05	19	2	\N	\N	user	listing	2	listing_review
10	2017-11-08 18:08:06.196507-05	A user has rated listing <b>Air Mail</b> 1 star	2017-12-08 18:08:06.193048-05	17	2	\N	\N	user	listing	2	listing_review
11	2017-11-08 18:08:06.222938-05	A user has rated listing <b>Air Mail</b> 4 stars	2017-12-08 18:08:06.220255-05	3	2	\N	\N	user	listing	2	listing_review
12	2017-11-08 18:08:06.250429-05	A user has rated listing <b>Aliens</b> 5 stars	2017-12-08 18:08:06.247347-05	9	4	\N	\N	user	listing	4	listing_review
13	2017-11-08 18:08:06.278509-05	A user has rated listing <b>Aliens</b> 1 star	2017-12-08 18:08:06.275822-05	17	4	\N	\N	user	listing	4	listing_review
14	2017-11-08 18:08:06.306503-05	A user has rated listing <b>Aliens</b> 4 stars	2017-12-08 18:08:06.303045-05	13	4	\N	\N	user	listing	4	listing_review
15	2017-11-08 18:08:06.349729-05	A user has rated listing <b>Apocalypse</b> 1 star	2017-12-08 18:08:06.345179-05	17	6	\N	\N	user	listing	6	listing_review
16	2017-11-08 18:08:06.390855-05	A user has rated listing <b>Astrology software</b> 5 stars	2017-12-08 18:08:06.386642-05	15	8	\N	\N	user	listing	8	listing_review
17	2017-11-08 18:08:06.428689-05	A user has rated listing <b>Azeroth</b> 5 stars	2017-12-08 18:08:06.424401-05	12	9	\N	\N	user	listing	9	listing_review
18	2017-11-08 18:08:06.46668-05	A user has rated listing <b>Azeroth</b> 5 stars	2017-12-08 18:08:06.462681-05	17	9	\N	\N	user	listing	9	listing_review
19	2017-11-08 18:08:06.50242-05	A user has rated listing <b>Azeroth</b> 3 stars	2017-12-08 18:08:06.498805-05	5	9	\N	\N	user	listing	9	listing_review
20	2017-11-08 18:08:06.534954-05	A user has rated listing <b>Azeroth</b> 3 stars	2017-12-08 18:08:06.531602-05	3	9	\N	\N	user	listing	9	listing_review
21	2017-11-08 18:08:06.566523-05	A user has rated listing <b>Azeroth</b> 5 stars	2017-12-08 18:08:06.563288-05	4	9	\N	\N	user	listing	9	listing_review
22	2017-11-08 18:08:06.596506-05	A user has rated listing <b>Baltimore Ravens</b> 5 stars	2017-12-08 18:08:06.593292-05	4	10	\N	\N	user	listing	10	listing_review
23	2017-11-08 18:08:06.626618-05	A user has rated listing <b>Barbecue</b> 5 stars	2017-12-08 18:08:06.623376-05	3	11	\N	\N	user	listing	11	listing_review
24	2017-11-08 18:08:06.657766-05	A user has rated listing <b>Barsoom</b> 5 stars	2017-12-08 18:08:06.654559-05	12	12	\N	\N	user	listing	12	listing_review
25	2017-11-08 18:08:06.688641-05	A user has rated listing <b>Barsoom</b> 3 stars	2017-12-08 18:08:06.685375-05	17	12	\N	\N	user	listing	12	listing_review
26	2017-11-08 18:08:06.719642-05	A user has rated listing <b>Barsoom</b> 5 stars	2017-12-08 18:08:06.716353-05	4	12	\N	\N	user	listing	12	listing_review
27	2017-11-08 18:08:06.751277-05	A user has rated listing <b>Basketball</b> 2 stars	2017-12-08 18:08:06.748001-05	9	13	\N	\N	user	listing	13	listing_review
28	2017-11-08 18:08:06.781737-05	A user has rated listing <b>Basketball</b> 5 stars	2017-12-08 18:08:06.77825-05	17	13	\N	\N	user	listing	13	listing_review
29	2017-11-08 18:08:06.812826-05	A user has rated listing <b>Bass Fishing</b> 4 stars	2017-12-08 18:08:06.80936-05	13	14	\N	\N	user	listing	14	listing_review
30	2017-11-08 18:08:06.844458-05	A user has rated listing <b>Beast</b> 5 stars	2017-12-08 18:08:06.841238-05	8	16	\N	\N	user	listing	16	listing_review
31	2017-11-08 18:08:06.874656-05	A user has rated listing <b>Beast</b> 3 stars	2017-12-08 18:08:06.871362-05	17	16	\N	\N	user	listing	16	listing_review
32	2017-11-08 18:08:06.904623-05	A user has rated listing <b>BeiDou Navigation Satellite System</b> 4 stars	2017-12-08 18:08:06.901443-05	1	17	\N	\N	user	listing	17	listing_review
33	2017-11-08 18:08:06.934788-05	A user has rated listing <b>BeiDou Navigation Satellite System</b> 3 stars	2017-12-08 18:08:06.931672-05	15	17	\N	\N	user	listing	17	listing_review
34	2017-11-08 18:08:06.96443-05	A user has rated listing <b>Bleach</b> 4 stars	2017-12-08 18:08:06.961234-05	15	18	\N	\N	user	listing	18	listing_review
35	2017-11-08 18:08:06.99488-05	A user has rated listing <b>Bleach</b> 5 stars	2017-12-08 18:08:06.991688-05	17	18	\N	\N	user	listing	18	listing_review
36	2017-11-08 18:08:07.025293-05	A user has rated listing <b>Blink</b> 5 stars	2017-12-08 18:08:07.021858-05	8	19	\N	\N	user	listing	19	listing_review
37	2017-11-08 18:08:07.054995-05	A user has rated listing <b>Blink</b> 5 stars	2017-12-08 18:08:07.051856-05	17	19	\N	\N	user	listing	19	listing_review
38	2017-11-08 18:08:07.084881-05	A user has rated listing <b>Blink</b> 1 star	2017-12-08 18:08:07.081325-05	12	19	\N	\N	user	listing	19	listing_review
39	2017-11-08 18:08:07.114562-05	A user has rated listing <b>Bread Basket</b> 2 stars	2017-12-08 18:08:07.11144-05	13	23	\N	\N	user	listing	23	listing_review
40	2017-11-08 18:08:07.144925-05	A user has rated listing <b>Bread Basket</b> 5 stars	2017-12-08 18:08:07.141744-05	6	23	\N	\N	user	listing	23	listing_review
41	2017-11-08 18:08:07.175481-05	A user has rated listing <b>Building</b> 4 stars	2017-12-08 18:08:07.172211-05	9	25	\N	\N	user	listing	25	listing_review
42	2017-11-08 18:08:07.205068-05	A user has rated listing <b>Building</b> 2 stars	2017-12-08 18:08:07.201855-05	17	25	\N	\N	user	listing	25	listing_review
43	2017-11-08 18:08:07.235303-05	A user has rated listing <b>Business Management System</b> 3 stars	2017-12-08 18:08:07.232097-05	1	27	\N	\N	user	listing	27	listing_review
44	2017-11-08 18:08:07.265761-05	A user has rated listing <b>Business Management System</b> 4 stars	2017-12-08 18:08:07.26226-05	4	27	\N	\N	user	listing	27	listing_review
45	2017-11-08 18:08:07.296621-05	A user has rated listing <b>Business Management System</b> 2 stars	2017-12-08 18:08:07.293327-05	17	27	\N	\N	user	listing	27	listing_review
46	2017-11-08 18:08:07.327321-05	A user has rated listing <b>Chart Course</b> 2 stars	2017-12-08 18:08:07.324105-05	5	30	\N	\N	user	listing	30	listing_review
47	2017-11-08 18:08:07.358545-05	A user has rated listing <b>Chart Course</b> 5 stars	2017-12-08 18:08:07.354951-05	1	30	\N	\N	user	listing	30	listing_review
48	2017-11-08 18:08:07.388861-05	A user has rated listing <b>Chasing Amy</b> 4 stars	2017-12-08 18:08:07.38577-05	15	31	\N	\N	user	listing	31	listing_review
49	2017-11-08 18:08:07.417467-05	A user has rated listing <b>Clerks</b> 3 stars	2017-12-08 18:08:07.414253-05	15	36	\N	\N	user	listing	36	listing_review
50	2017-11-08 18:08:07.447323-05	A user has rated listing <b>Clerks II</b> 3 stars	2017-12-08 18:08:07.444121-05	15	37	\N	\N	user	listing	37	listing_review
51	2017-11-08 18:08:07.477649-05	A user has rated listing <b>Cyclops</b> 1 star	2017-12-08 18:08:07.47437-05	17	41	\N	\N	user	listing	41	listing_review
52	2017-11-08 18:08:07.50777-05	A user has rated listing <b>Cyclops</b> 5 stars	2017-12-08 18:08:07.504253-05	12	41	\N	\N	user	listing	41	listing_review
53	2017-11-08 18:08:07.537525-05	A user has rated listing <b>Deadpool</b> 5 stars	2017-12-08 18:08:07.534248-05	4	42	\N	\N	user	listing	42	listing_review
54	2017-11-08 18:08:07.567433-05	A user has rated listing <b>Deadpool</b> 2 stars	2017-12-08 18:08:07.564213-05	17	42	\N	\N	user	listing	42	listing_review
55	2017-11-08 18:08:07.597375-05	A user has rated listing <b>Dinosaur</b> 1 star	2017-12-08 18:08:07.593944-05	9	45	\N	\N	user	listing	45	listing_review
56	2017-11-08 18:08:07.627333-05	A user has rated listing <b>Dinosaur</b> 5 stars	2017-12-08 18:08:07.624112-05	8	45	\N	\N	user	listing	45	listing_review
57	2017-11-08 18:08:07.657098-05	A user has rated listing <b>Dinosaur</b> 4 stars	2017-12-08 18:08:07.653894-05	3	45	\N	\N	user	listing	45	listing_review
58	2017-11-08 18:08:07.686396-05	A user has rated listing <b>Dragons</b> 5 stars	2017-12-08 18:08:07.683178-05	3	47	\N	\N	user	listing	47	listing_review
59	2017-11-08 18:08:07.717426-05	A user has rated listing <b>Fight Club</b> 3 stars	2017-12-08 18:08:07.714093-05	4	55	\N	\N	user	listing	55	listing_review
60	2017-11-08 18:08:07.747654-05	A user has rated listing <b>Floppy Disk</b> 3 stars	2017-12-08 18:08:07.744519-05	9	56	\N	\N	user	listing	56	listing_review
61	2017-11-08 18:08:07.778359-05	A user has rated listing <b>Floppy Disk</b> 5 stars	2017-12-08 18:08:07.775083-05	17	56	\N	\N	user	listing	56	listing_review
62	2017-11-08 18:08:07.808504-05	A user has rated listing <b>Floppy Disk</b> 3 stars	2017-12-08 18:08:07.805199-05	4	56	\N	\N	user	listing	56	listing_review
63	2017-11-08 18:08:07.837968-05	A user has rated listing <b>Floppy Disk</b> 2 stars	2017-12-08 18:08:07.83482-05	3	56	\N	\N	user	listing	56	listing_review
64	2017-11-08 18:08:07.867665-05	A user has rated listing <b>Gallery of Maps</b> 4 stars	2017-12-08 18:08:07.864545-05	17	59	\N	\N	user	listing	59	listing_review
65	2017-11-08 18:08:07.8975-05	A user has rated listing <b>Gallery of Maps</b> 3 stars	2017-12-08 18:08:07.89428-05	15	59	\N	\N	user	listing	59	listing_review
66	2017-11-08 18:08:07.927335-05	A user has rated listing <b>Global Navigation Grid Code</b> 5 stars	2017-12-08 18:08:07.924123-05	1	61	\N	\N	user	listing	61	listing_review
67	2017-11-08 18:08:07.957676-05	A user has rated listing <b>Global Navigation Grid Code</b> 5 stars	2017-12-08 18:08:07.954395-05	15	61	\N	\N	user	listing	61	listing_review
68	2017-11-08 18:08:07.987657-05	A user has rated listing <b>Great white shark</b> 5 stars	2017-12-08 18:08:07.984513-05	17	64	\N	\N	user	listing	64	listing_review
69	2017-11-08 18:08:08.018498-05	A user has rated listing <b>Great white shark</b> 3 stars	2017-12-08 18:08:08.015186-05	15	64	\N	\N	user	listing	64	listing_review
70	2017-11-08 18:08:08.049884-05	A user has rated listing <b>Harley-Davidson CVO</b> 3 stars	2017-12-08 18:08:08.046441-05	5	65	\N	\N	user	listing	65	listing_review
71	2017-11-08 18:08:08.081532-05	A user has rated listing <b>Hawaii</b> 4 stars	2017-12-08 18:08:08.078252-05	9	67	\N	\N	user	listing	67	listing_review
72	2017-11-08 18:08:08.111082-05	A user has rated listing <b>Hawaii</b> 5 stars	2017-12-08 18:08:08.107794-05	17	67	\N	\N	user	listing	67	listing_review
73	2017-11-08 18:08:08.141446-05	A user has rated listing <b>Hawaii</b> 3 stars	2017-12-08 18:08:08.138159-05	15	67	\N	\N	user	listing	67	listing_review
74	2017-11-08 18:08:08.171652-05	A user has rated listing <b>House Lannister</b> 1 star	2017-12-08 18:08:08.168512-05	3	68	\N	\N	user	listing	68	listing_review
75	2017-11-08 18:08:08.201418-05	A user has rated listing <b>House Stark</b> 1 star	2017-12-08 18:08:08.197971-05	12	69	\N	\N	user	listing	69	listing_review
76	2017-11-08 18:08:08.231943-05	A user has rated listing <b>House Stark</b> 4 stars	2017-12-08 18:08:08.228788-05	3	69	\N	\N	user	listing	69	listing_review
77	2017-11-08 18:08:08.262924-05	A user has rated listing <b>House Targaryen</b> 5 stars	2017-12-08 18:08:08.259765-05	3	70	\N	\N	user	listing	70	listing_review
78	2017-11-08 18:08:08.294325-05	A user has rated listing <b>Informational Book</b> 5 stars	2017-12-08 18:08:08.291078-05	17	73	\N	\N	user	listing	73	listing_review
79	2017-11-08 18:08:08.324795-05	A user has rated listing <b>Iron Man</b> 5 stars	2017-12-08 18:08:08.321291-05	17	77	\N	\N	user	listing	77	listing_review
80	2017-11-08 18:08:08.354901-05	A user has rated listing <b>Iron Man</b> 3 stars	2017-12-08 18:08:08.351668-05	15	77	\N	\N	user	listing	77	listing_review
81	2017-11-08 18:08:08.385002-05	A user has rated listing <b>Iron Man</b> 5 stars	2017-12-08 18:08:08.381798-05	3	77	\N	\N	user	listing	77	listing_review
82	2017-11-08 18:08:08.415546-05	A user has rated listing <b>Jar of Flies</b> 3 stars	2017-12-08 18:08:08.412228-05	15	78	\N	\N	user	listing	78	listing_review
83	2017-11-08 18:08:08.44781-05	A user has rated listing <b>Jasoom</b> 5 stars	2017-12-08 18:08:08.444366-05	12	79	\N	\N	user	listing	79	listing_review
84	2017-11-08 18:08:08.478524-05	A user has rated listing <b>Jasoom</b> 2 stars	2017-12-08 18:08:08.475229-05	17	79	\N	\N	user	listing	79	listing_review
85	2017-11-08 18:08:08.508876-05	A user has rated listing <b>Jay and Silent Bob Strike Back</b> 1 star	2017-12-08 18:08:08.505315-05	12	80	\N	\N	user	listing	80	listing_review
86	2017-11-08 18:08:08.538651-05	A user has rated listing <b>Jean Grey</b> 5 stars	2017-12-08 18:08:08.53536-05	17	81	\N	\N	user	listing	81	listing_review
87	2017-11-08 18:08:08.568475-05	A user has rated listing <b>Jean Grey</b> 5 stars	2017-12-08 18:08:08.565253-05	15	81	\N	\N	user	listing	81	listing_review
88	2017-11-08 18:08:08.59793-05	A user has rated listing <b>Jean Grey</b> 3 stars	2017-12-08 18:08:08.594706-05	5	81	\N	\N	user	listing	81	listing_review
89	2017-11-08 18:08:08.634718-05	A user has rated listing <b>JotSpot</b> 4 stars	2017-12-08 18:08:08.630039-05	21	82	\N	\N	user	listing	82	listing_review
90	2017-11-08 18:08:08.683732-05	A user has rated listing <b>Jupiter</b> 5 stars	2017-12-08 18:08:08.678827-05	12	83	\N	\N	user	listing	83	listing_review
91	2017-11-08 18:08:08.728075-05	A user has rated listing <b>Jupiter</b> 3 stars	2017-12-08 18:08:08.723356-05	17	83	\N	\N	user	listing	83	listing_review
92	2017-11-08 18:08:08.770987-05	A user has rated listing <b>Killer Whale</b> 4 stars	2017-12-08 18:08:08.766447-05	13	87	\N	\N	user	listing	87	listing_review
93	2017-11-08 18:08:08.809901-05	A user has rated listing <b>Killer Whale</b> 3 stars	2017-12-08 18:08:08.805609-05	15	87	\N	\N	user	listing	87	listing_review
94	2017-11-08 18:08:08.847668-05	A user has rated listing <b>Komodo Dragon</b> 1 star	2017-12-08 18:08:08.843742-05	1	88	\N	\N	user	listing	88	listing_review
95	2017-11-08 18:08:08.885037-05	A user has rated listing <b>LIT RANCH</b> 1 star	2017-12-08 18:08:08.881327-05	9	89	\N	\N	user	listing	89	listing_review
96	2017-11-08 18:08:08.919811-05	A user has rated listing <b>LIT RANCH</b> 5 stars	2017-12-08 18:08:08.916042-05	8	89	\N	\N	user	listing	89	listing_review
97	2017-11-08 18:08:08.952722-05	A user has rated listing <b>LIT RANCH</b> 5 stars	2017-12-08 18:08:08.949326-05	3	89	\N	\N	user	listing	89	listing_review
98	2017-11-08 18:08:08.984838-05	A user has rated listing <b>Lager</b> 5 stars	2017-12-08 18:08:08.981375-05	13	90	\N	\N	user	listing	90	listing_review
99	2017-11-08 18:08:09.016068-05	A user has rated listing <b>Lager</b> 2 stars	2017-12-08 18:08:09.012792-05	5	90	\N	\N	user	listing	90	listing_review
100	2017-11-08 18:08:09.047472-05	A user has rated listing <b>Lion Finder</b> 1 star	2017-12-08 18:08:09.044174-05	3	94	\N	\N	user	listing	94	listing_review
101	2017-11-08 18:08:09.078516-05	A user has rated listing <b>LocationLister</b> 4 stars	2017-12-08 18:08:09.075255-05	21	96	\N	\N	user	listing	96	listing_review
102	2017-11-08 18:08:09.10947-05	A user has rated listing <b>Magnetic positioning</b> 1 star	2017-12-08 18:08:09.106021-05	17	99	\N	\N	user	listing	99	listing_review
103	2017-11-08 18:08:09.139277-05	A user has rated listing <b>Magnetic positioning</b> 5 stars	2017-12-08 18:08:09.136067-05	15	99	\N	\N	user	listing	99	listing_review
104	2017-11-08 18:08:09.169737-05	A user has rated listing <b>Magneto</b> 1 star	2017-12-08 18:08:09.166511-05	4	100	\N	\N	user	listing	100	listing_review
105	2017-11-08 18:08:09.199926-05	A user has rated listing <b>Magneto</b> 3 stars	2017-12-08 18:08:09.196756-05	8	100	\N	\N	user	listing	100	listing_review
106	2017-11-08 18:08:09.229727-05	A user has rated listing <b>Mallrats</b> 4 stars	2017-12-08 18:08:09.226261-05	15	101	\N	\N	user	listing	101	listing_review
107	2017-11-08 18:08:09.260165-05	A user has rated listing <b>Map of the world</b> 5 stars	2017-12-08 18:08:09.256951-05	17	102	\N	\N	user	listing	102	listing_review
108	2017-11-08 18:08:09.289742-05	A user has rated listing <b>Map of the world</b> 5 stars	2017-12-08 18:08:09.286561-05	15	102	\N	\N	user	listing	102	listing_review
109	2017-11-08 18:08:09.319077-05	A user has rated listing <b>Minesweeper</b> 5 stars	2017-12-08 18:08:09.315894-05	1	104	\N	\N	user	listing	104	listing_review
110	2017-11-08 18:08:09.348985-05	A user has rated listing <b>Minesweeper</b> 2 stars	2017-12-08 18:08:09.345785-05	15	104	\N	\N	user	listing	104	listing_review
111	2017-11-08 18:08:09.37924-05	A user has rated listing <b>Mini Dachshund</b> 5 stars	2017-12-08 18:08:09.376034-05	1	105	\N	\N	user	listing	105	listing_review
112	2017-11-08 18:08:09.409316-05	A user has rated listing <b>Mini Dachshund</b> 5 stars	2017-12-08 18:08:09.406124-05	9	105	\N	\N	user	listing	105	listing_review
113	2017-11-08 18:08:09.439553-05	A user has rated listing <b>Mini Dachshund</b> 1 star	2017-12-08 18:08:09.436313-05	17	105	\N	\N	user	listing	105	listing_review
114	2017-11-08 18:08:09.469258-05	A user has rated listing <b>Mini Dachshund</b> 1 star	2017-12-08 18:08:09.46611-05	2	105	\N	\N	user	listing	105	listing_review
115	2017-11-08 18:08:09.498945-05	A user has rated listing <b>Mini Dachshund</b> 1 star	2017-12-08 18:08:09.495827-05	3	105	\N	\N	user	listing	105	listing_review
116	2017-11-08 18:08:09.529937-05	A user has rated listing <b>Mini Dachshund</b> 1 star	2017-12-08 18:08:09.526272-05	4	105	\N	\N	user	listing	105	listing_review
117	2017-11-08 18:08:09.560578-05	A user has rated listing <b>Mini Dachshund</b> 1 star	2017-12-08 18:08:09.557366-05	5	105	\N	\N	user	listing	105	listing_review
118	2017-11-08 18:08:09.59057-05	A user has rated listing <b>Mini Dachshund</b> 1 star	2017-12-08 18:08:09.587239-05	6	105	\N	\N	user	listing	105	listing_review
119	2017-11-08 18:08:09.620851-05	A user has rated listing <b>Mini Dachshund</b> 1 star	2017-12-08 18:08:09.617721-05	7	105	\N	\N	user	listing	105	listing_review
120	2017-11-08 18:08:09.650729-05	A user has rated listing <b>Mini Dachshund</b> 1 star	2017-12-08 18:08:09.647619-05	8	105	\N	\N	user	listing	105	listing_review
121	2017-11-08 18:08:09.681644-05	A user has rated listing <b>Mixing Console</b> 1 star	2017-12-08 18:08:09.678531-05	1	107	\N	\N	user	listing	107	listing_review
122	2017-11-08 18:08:09.710946-05	A user has rated listing <b>Monkey Finder</b> 1 star	2017-12-08 18:08:09.707838-05	13	108	\N	\N	user	listing	108	listing_review
123	2017-11-08 18:08:09.740955-05	A user has rated listing <b>Monkey Finder</b> 1 star	2017-12-08 18:08:09.737514-05	3	108	\N	\N	user	listing	108	listing_review
124	2017-11-08 18:08:09.772085-05	A user has rated listing <b>Moonshine</b> 5 stars	2017-12-08 18:08:09.768431-05	3	109	\N	\N	user	listing	109	listing_review
125	2017-11-08 18:08:09.80511-05	A user has rated listing <b>Moonshine</b> 2 stars	2017-12-08 18:08:09.801636-05	15	109	\N	\N	user	listing	109	listing_review
126	2017-11-08 18:08:09.838166-05	A user has rated listing <b>Motorcycle Helmet</b> 5 stars	2017-12-08 18:08:09.834839-05	1	111	\N	\N	user	listing	111	listing_review
127	2017-11-08 18:08:09.870736-05	A user has rated listing <b>Motorsport</b> 4 stars	2017-12-08 18:08:09.867457-05	17	112	\N	\N	user	listing	112	listing_review
128	2017-11-08 18:08:09.901766-05	A user has rated listing <b>Motorsport</b> 3 stars	2017-12-08 18:08:09.898299-05	15	112	\N	\N	user	listing	112	listing_review
129	2017-11-08 18:08:09.933057-05	A user has rated listing <b>Navigation</b> 5 stars	2017-12-08 18:08:09.929819-05	1	116	\N	\N	user	listing	116	listing_review
130	2017-11-08 18:08:09.963812-05	A user has rated listing <b>Navigation</b> 4 stars	2017-12-08 18:08:09.960665-05	15	116	\N	\N	user	listing	116	listing_review
131	2017-11-08 18:08:09.99352-05	A user has rated listing <b>Navigation</b> 2 stars	2017-12-08 18:08:09.990341-05	5	116	\N	\N	user	listing	116	listing_review
132	2017-11-08 18:08:10.022832-05	A user has rated listing <b>Navigation</b> 5 stars	2017-12-08 18:08:10.019308-05	3	116	\N	\N	user	listing	116	listing_review
133	2017-11-08 18:08:10.05177-05	A user has rated listing <b>Navigation</b> 5 stars	2017-12-08 18:08:10.048741-05	4	116	\N	\N	user	listing	116	listing_review
134	2017-11-08 18:08:10.079998-05	A user has rated listing <b>Navigation using Maps</b> 4 stars	2017-12-08 18:08:10.07685-05	1	117	\N	\N	user	listing	117	listing_review
135	2017-11-08 18:08:10.109551-05	A user has rated listing <b>Navigation using Maps</b> 3 stars	2017-12-08 18:08:10.106117-05	15	117	\N	\N	user	listing	117	listing_review
136	2017-11-08 18:08:10.144398-05	A user has rated listing <b>Neptune</b> 5 stars	2017-12-08 18:08:10.140167-05	12	118	\N	\N	user	listing	118	listing_review
137	2017-11-08 18:08:10.184158-05	A user has rated listing <b>Neptune</b> 1 star	2017-12-08 18:08:10.180062-05	17	118	\N	\N	user	listing	118	listing_review
138	2017-11-08 18:08:10.223293-05	A user has rated listing <b>Network Switch</b> 4 stars	2017-12-08 18:08:10.21926-05	1	119	\N	\N	user	listing	119	listing_review
139	2017-11-08 18:08:10.261585-05	A user has rated listing <b>Phentolamine</b> 5 stars	2017-12-08 18:08:10.257534-05	1	125	\N	\N	user	listing	125	listing_review
140	2017-11-08 18:08:10.297842-05	A user has rated listing <b>Pluto (Not a planet)</b> 1 star	2017-12-08 18:08:10.293902-05	12	128	\N	\N	user	listing	128	listing_review
141	2017-11-08 18:08:10.335452-05	A user has rated listing <b>Pluto (Not a planet)</b> 5 stars	2017-12-08 18:08:10.331231-05	17	128	\N	\N	user	listing	128	listing_review
142	2017-11-08 18:08:10.37171-05	A user has rated listing <b>Princess Peach</b> 3 stars	2017-12-08 18:08:10.368023-05	3	132	\N	\N	user	listing	132	listing_review
143	2017-11-08 18:08:10.40545-05	A user has rated listing <b>Project Management</b> 2 stars	2017-12-08 18:08:10.401863-05	3	133	\N	\N	user	listing	133	listing_review
144	2017-11-08 18:08:10.440018-05	A user has rated listing <b>Project Management</b> 1 star	2017-12-08 18:08:10.436597-05	4	133	\N	\N	user	listing	133	listing_review
145	2017-11-08 18:08:10.491231-05	A user has rated listing <b>Railroad</b> 3 stars	2017-12-08 18:08:10.485638-05	4	134	\N	\N	user	listing	134	listing_review
146	2017-11-08 18:08:10.542547-05	A user has rated listing <b>Railroad</b> 5 stars	2017-12-08 18:08:10.537436-05	17	134	\N	\N	user	listing	134	listing_review
147	2017-11-08 18:08:10.587819-05	A user has rated listing <b>Railroad</b> 4 stars	2017-12-08 18:08:10.583086-05	15	134	\N	\N	user	listing	134	listing_review
148	2017-11-08 18:08:10.629899-05	A user has rated listing <b>Rogue</b> 2 stars	2017-12-08 18:08:10.625415-05	8	135	\N	\N	user	listing	135	listing_review
149	2017-11-08 18:08:10.668215-05	A user has rated listing <b>Ruby</b> 5 stars	2017-12-08 18:08:10.664434-05	3	136	\N	\N	user	listing	136	listing_review
150	2017-11-08 18:08:10.715372-05	A user has rated listing <b>Sailboat Racing</b> 3 stars	2017-12-08 18:08:10.710907-05	5	142	\N	\N	user	listing	142	listing_review
151	2017-11-08 18:08:10.754359-05	A user has rated listing <b>Satellite navigation</b> 3 stars	2017-12-08 18:08:10.750398-05	1	146	\N	\N	user	listing	146	listing_review
152	2017-11-08 18:08:10.790792-05	A user has rated listing <b>Satellite navigation</b> 5 stars	2017-12-08 18:08:10.787074-05	15	146	\N	\N	user	listing	146	listing_review
153	2017-11-08 18:08:10.824155-05	A user has rated listing <b>Saturn</b> 3 stars	2017-12-08 18:08:10.820721-05	12	147	\N	\N	user	listing	147	listing_review
154	2017-11-08 18:08:10.866083-05	A user has rated listing <b>Saturn</b> 5 stars	2017-12-08 18:08:10.861582-05	17	147	\N	\N	user	listing	147	listing_review
155	2017-11-08 18:08:10.908755-05	A user has rated listing <b>Snow</b> 1 star	2017-12-08 18:08:10.904473-05	1	154	\N	\N	user	listing	154	listing_review
156	2017-11-08 18:08:10.945643-05	A user has rated listing <b>Snow</b> 3 stars	2017-12-08 18:08:10.941914-05	17	154	\N	\N	user	listing	154	listing_review
157	2017-11-08 18:08:10.979374-05	A user has rated listing <b>Snow</b> 2 stars	2017-12-08 18:08:10.975729-05	3	154	\N	\N	user	listing	154	listing_review
158	2017-11-08 18:08:11.011372-05	A user has rated listing <b>Stop sign</b> 5 stars	2017-12-08 18:08:11.008048-05	1	158	\N	\N	user	listing	158	listing_review
159	2017-11-08 18:08:11.042494-05	A user has rated listing <b>Stop sign</b> 5 stars	2017-12-08 18:08:11.039131-05	15	158	\N	\N	user	listing	158	listing_review
160	2017-11-08 18:08:11.071873-05	A user has rated listing <b>Stout</b> 5 stars	2017-12-08 18:08:11.06886-05	5	159	\N	\N	user	listing	159	listing_review
161	2017-11-08 18:08:11.099885-05	A user has rated listing <b>Stroke play</b> 3 stars	2017-12-08 18:08:11.096944-05	5	160	\N	\N	user	listing	160	listing_review
162	2017-11-08 18:08:11.128916-05	A user has rated listing <b>Sun</b> 5 stars	2017-12-08 18:08:11.126006-05	12	162	\N	\N	user	listing	162	listing_review
163	2017-11-08 18:08:11.157064-05	A user has rated listing <b>Sun</b> 5 stars	2017-12-08 18:08:11.153941-05	17	162	\N	\N	user	listing	162	listing_review
164	2017-11-08 18:08:11.201694-05	A user has rated listing <b>Superunknown</b> 5 stars	2017-12-08 18:08:11.196974-05	17	163	\N	\N	user	listing	163	listing_review
165	2017-11-08 18:08:11.244635-05	A user has rated listing <b>Superunknown</b> 3 stars	2017-12-08 18:08:11.240143-05	15	163	\N	\N	user	listing	163	listing_review
166	2017-11-08 18:08:11.283626-05	A user has rated listing <b>Ten</b> 4 stars	2017-12-08 18:08:11.279613-05	15	166	\N	\N	user	listing	166	listing_review
167	2017-11-08 18:08:11.319194-05	A user has rated listing <b>Ten</b> 5 stars	2017-12-08 18:08:11.315549-05	1	166	\N	\N	user	listing	166	listing_review
168	2017-11-08 18:08:11.350301-05	A user has rated listing <b>Ten</b> 3 stars	2017-12-08 18:08:11.347299-05	8	166	\N	\N	user	listing	166	listing_review
169	2017-11-08 18:08:11.378059-05	A user has rated listing <b>Tiny Music... Songs from the Vatican Gift Shop</b> 3 stars	2017-12-08 18:08:11.375273-05	15	168	\N	\N	user	listing	168	listing_review
170	2017-11-08 18:08:11.414389-05	A user has rated listing <b>Tiny Music... Songs from the Vatican Gift Shop</b> 4 stars	2017-12-08 18:08:11.409519-05	17	168	\N	\N	user	listing	168	listing_review
171	2017-11-08 18:08:11.459098-05	A user has rated listing <b>Tornado</b> 1 star	2017-12-08 18:08:11.454454-05	1	169	\N	\N	user	listing	169	listing_review
172	2017-11-08 18:08:11.499128-05	A user has rated listing <b>Tornado</b> 1 star	2017-12-08 18:08:11.495419-05	4	169	\N	\N	user	listing	169	listing_review
173	2017-11-08 18:08:11.531674-05	A user has rated listing <b>Tornado</b> 1 star	2017-12-08 18:08:11.52838-05	3	169	\N	\N	user	listing	169	listing_review
174	2017-11-08 18:08:11.561626-05	A user has rated listing <b>Uranus</b> 5 stars	2017-12-08 18:08:11.55828-05	17	173	\N	\N	user	listing	173	listing_review
175	2017-11-08 18:08:11.591612-05	A user has rated listing <b>Uranus</b> 2 stars	2017-12-08 18:08:11.588452-05	13	173	\N	\N	user	listing	173	listing_review
176	2017-11-08 18:08:11.62054-05	A user has rated listing <b>Venus</b> 4 stars	2017-12-08 18:08:11.617689-05	12	174	\N	\N	user	listing	174	listing_review
177	2017-11-08 18:08:11.648194-05	A user has rated listing <b>Venus</b> 1 star	2017-12-08 18:08:11.64527-05	17	174	\N	\N	user	listing	174	listing_review
178	2017-11-08 18:08:11.67573-05	A user has rated listing <b>Waterme Lon</b> 4 stars	2017-12-08 18:08:11.672839-05	9	178	\N	\N	user	listing	178	listing_review
179	2017-11-08 18:08:11.702804-05	A user has rated listing <b>Waterme Lon</b> 5 stars	2017-12-08 18:08:11.699975-05	17	178	\N	\N	user	listing	178	listing_review
180	2017-11-08 18:08:11.729253-05	A user has rated listing <b>Waterme Lon</b> 5 stars	2017-12-08 18:08:11.726415-05	3	178	\N	\N	user	listing	178	listing_review
181	2017-11-08 18:08:11.755935-05	A user has rated listing <b>White Horse</b> 4 stars	2017-12-08 18:08:11.753087-05	3	180	\N	\N	user	listing	180	listing_review
182	2017-11-08 18:08:11.783308-05	A user has rated listing <b>Wolf Finder</b> 5 stars	2017-12-08 18:08:11.780441-05	15	186	\N	\N	user	listing	186	listing_review
183	2017-11-08 18:08:11.810346-05	A user has rated listing <b>Wolf Finder</b> 4 stars	2017-12-08 18:08:11.807539-05	3	186	\N	\N	user	listing	186	listing_review
184	2017-11-08 18:08:11.837554-05	A user has rated listing <b>Wolverine</b> 3 stars	2017-12-08 18:08:11.834737-05	17	187	\N	\N	user	listing	187	listing_review
185	2017-11-08 18:08:11.935802-05	Acoustic Guitar update next week	2017-11-15 23:07:37.193332-05	1	1	\N	\N	all	listing	1	\N
186	2017-11-08 18:08:11.953328-05	Air Mail update next week	2017-11-15 23:07:37.193332-05	5	2	\N	\N	all	listing	2	\N
187	2017-11-08 18:08:11.970716-05	Air Mail update next week	2017-11-15 23:07:37.193332-05	5	2	\N	\N	all	listing	2	\N
188	2017-11-08 18:08:11.991078-05	Azeroth update next week	2017-11-15 23:07:37.193332-05	12	9	\N	\N	all	listing	9	\N
189	2017-11-08 18:08:12.011156-05	Azeroth update next week	2017-11-15 23:07:37.193332-05	12	9	\N	\N	all	listing	9	\N
190	2017-11-08 18:08:12.028493-05	Baltimore Ravens update next week	2017-11-15 23:07:37.193332-05	4	10	\N	\N	all	listing	10	\N
191	2017-11-08 18:08:12.045507-05	Baltimore Ravens update next week	2017-11-15 23:07:37.193332-05	4	10	\N	\N	all	listing	10	\N
192	2017-11-08 18:08:12.061447-05	Bass Fishing update next week	2017-11-15 23:07:37.193332-05	4	14	\N	\N	all	listing	14	\N
193	2017-11-08 18:08:12.076313-05	Bleach update next week	2017-11-15 23:07:37.193332-05	4	18	\N	\N	all	listing	18	\N
194	2017-11-08 18:08:12.093461-05	Bourbon update next week	2017-11-15 23:07:37.193332-05	13	21	\N	\N	all	listing	21	\N
195	2017-11-08 18:08:12.11172-05	Bread Basket update next week	2017-11-15 23:07:37.193332-05	6	23	\N	\N	all	listing	23	\N
196	2017-11-08 18:08:12.133401-05	Bread Basket update next week	2017-11-15 23:07:37.193332-05	6	23	\N	\N	all	listing	23	\N
197	2017-11-08 18:08:12.158393-05	Chain boat navigation update next week	2017-11-15 23:07:37.193332-05	15	29	\N	\N	all	listing	29	\N
198	2017-11-08 18:08:12.177891-05	Chart Course update next week	2017-11-15 23:07:37.193332-05	5	30	\N	\N	all	listing	30	\N
199	2017-11-08 18:08:12.197684-05	Chart Course update next week	2017-11-15 23:07:37.193332-05	5	30	\N	\N	all	listing	30	\N
200	2017-11-08 18:08:12.216761-05	Diamond update next week	2017-11-15 23:07:37.193332-05	5	44	\N	\N	all	listing	44	\N
201	2017-11-08 18:08:12.234476-05	Dragons update next week	2017-11-15 23:07:37.193332-05	2	47	\N	\N	all	listing	47	\N
202	2017-11-08 18:08:12.251382-05	Electric Guitar update next week	2017-11-15 23:07:37.193332-05	1	49	\N	\N	all	listing	49	\N
203	2017-11-08 18:08:12.267614-05	Electric Piano update next week	2017-11-15 23:07:37.193332-05	1	50	\N	\N	all	listing	50	\N
204	2017-11-08 18:08:12.287648-05	Gallery of Maps update next week	2017-11-15 23:07:37.193332-05	15	59	\N	\N	all	listing	59	\N
205	2017-11-08 18:08:12.308344-05	Grandfather clock update next week	2017-11-15 23:07:37.193332-05	4	63	\N	\N	all	listing	63	\N
206	2017-11-08 18:08:12.329844-05	House Lannister update next week	2017-11-15 23:07:37.193332-05	1	68	\N	\N	all	listing	68	\N
207	2017-11-08 18:08:12.350833-05	House Stark update next week	2017-11-15 23:07:37.193332-05	1	69	\N	\N	all	listing	69	\N
208	2017-11-08 18:08:12.370192-05	House Targaryen update next week	2017-11-15 23:07:37.193332-05	3	70	\N	\N	all	listing	70	\N
209	2017-11-08 18:08:12.38915-05	India Pale Ale update next week	2017-11-15 23:07:37.193332-05	4	72	\N	\N	all	listing	72	\N
210	2017-11-08 18:08:12.406795-05	Informational Book update next week	2017-11-15 23:07:37.193332-05	1	73	\N	\N	all	listing	73	\N
211	2017-11-08 18:08:12.423732-05	Internet meme update next week	2017-11-15 23:07:37.193332-05	4	76	\N	\N	all	listing	76	\N
212	2017-11-08 18:08:12.442292-05	Iron Man update next week	2017-11-15 23:07:37.193332-05	17	77	\N	\N	all	listing	77	\N
213	2017-11-08 18:08:12.459575-05	Jean Grey update next week	2017-11-15 23:07:37.193332-05	17	81	\N	\N	all	listing	81	\N
214	2017-11-08 18:08:12.474047-05	JotSpot update next week	2017-11-15 23:07:37.193332-05	5	82	\N	\N	all	listing	82	\N
215	2017-11-08 18:08:12.487983-05	Killer Whale update next week	2017-11-15 23:07:37.193332-05	1	87	\N	\N	all	listing	87	\N
216	2017-11-08 18:08:12.506328-05	Killer Whale update next week	2017-11-15 23:07:37.193332-05	1	87	\N	\N	all	listing	87	\N
217	2017-11-08 18:08:12.527472-05	Lager update next week	2017-11-15 23:07:37.193332-05	4	90	\N	\N	all	listing	90	\N
218	2017-11-08 18:08:12.546683-05	Lightning update next week	2017-11-15 23:07:37.193332-05	1	93	\N	\N	all	listing	93	\N
219	2017-11-08 18:08:12.565409-05	Lion Finder update next week	2017-11-15 23:07:37.193332-05	1	94	\N	\N	all	listing	94	\N
220	2017-11-08 18:08:12.583854-05	LocationLister update next week	2017-11-15 23:07:37.193332-05	5	96	\N	\N	all	listing	96	\N
221	2017-11-08 18:08:12.600879-05	Mallrats update next week	2017-11-15 23:07:37.193332-05	4	101	\N	\N	all	listing	101	\N
222	2017-11-08 18:08:12.617568-05	Mallrats update next week	2017-11-15 23:07:37.193332-05	4	101	\N	\N	all	listing	101	\N
223	2017-11-08 18:08:12.633209-05	Mario update next week	2017-11-15 23:07:37.193332-05	4	103	\N	\N	all	listing	103	\N
224	2017-11-08 18:08:12.647492-05	Monkey Finder update next week	2017-11-15 23:07:37.193332-05	1	108	\N	\N	all	listing	108	\N
225	2017-11-08 18:08:12.660995-05	NES update next week	2017-11-15 23:07:37.193332-05	4	115	\N	\N	all	listing	115	\N
226	2017-11-08 18:08:12.681378-05	Navigation update next week	2017-11-15 23:07:37.193332-05	15	116	\N	\N	all	listing	116	\N
227	2017-11-08 18:08:12.708478-05	Parrotlet update next week	2017-11-15 23:07:37.193332-05	13	122	\N	\N	all	listing	122	\N
228	2017-11-08 18:08:12.731076-05	Piano update next week	2017-11-15 23:07:37.193332-05	1	127	\N	\N	all	listing	127	\N
229	2017-11-08 18:08:12.758537-05	Saturn update next week	2017-11-15 23:07:37.193332-05	12	147	\N	\N	all	listing	147	\N
230	2017-11-08 18:08:12.78484-05	Screamin Eagle CVO update next week	2017-11-15 23:07:37.193332-05	13	148	\N	\N	all	listing	148	\N
231	2017-11-08 18:08:12.810822-05	Snow update next week	2017-11-15 23:07:37.193332-05	9	154	\N	\N	all	listing	154	\N
232	2017-11-08 18:08:12.83307-05	Sound Mixer update next week	2017-11-15 23:07:37.193332-05	1	156	\N	\N	all	listing	156	\N
233	2017-11-08 18:08:12.85417-05	Stop sign update next week	2017-11-15 23:07:37.193332-05	4	158	\N	\N	all	listing	158	\N
234	2017-11-08 18:08:12.874759-05	Tornado update next week	2017-11-15 23:07:37.193332-05	1	169	\N	\N	all	listing	169	\N
235	2017-11-08 18:08:12.894244-05	Violin update next week	2017-11-15 23:07:37.193332-05	1	175	\N	\N	all	listing	175	\N
236	2017-11-08 18:08:12.913576-05	White Horse update next week	2017-11-15 23:07:37.193332-05	1	180	\N	\N	all	listing	180	\N
237	2017-11-08 18:08:12.932151-05	Wolf Finder update next week	2017-11-15 23:07:37.193332-05	1	186	\N	\N	all	listing	186	\N
238	2017-11-08 18:08:12.95058-05	Wolf Finder update next week	2017-11-15 23:07:37.193332-05	1	186	\N	\N	all	listing	186	\N
\.


--
-- Name: ozpcenter_notification_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ozp_user
--

SELECT pg_catalog.setval('ozpcenter_notification_id_seq', 238, true);


--
-- Data for Name: ozpcenter_notificationmailbox; Type: TABLE DATA; Schema: public; Owner: ozp_user
--

COPY ozpcenter_notificationmailbox (id, target_profile_id, notification_id, emailed_status, read_status, acknowledged_status) FROM stdin;
1	1	1	f	f	f
2	2	1	f	f	f
3	3	1	f	f	f
4	4	1	f	f	f
5	5	1	f	f	f
6	6	1	f	f	f
7	7	1	f	f	f
8	8	1	f	f	f
9	9	1	f	f	f
10	10	1	f	f	f
11	11	1	f	f	f
12	12	1	f	f	f
13	13	1	f	f	f
14	14	1	f	f	f
15	15	1	f	f	f
16	16	1	f	f	f
17	17	1	f	f	f
18	18	1	f	f	f
19	19	1	f	f	f
20	20	1	f	f	f
21	21	1	f	f	f
22	22	1	f	f	f
23	1	2	f	f	f
24	2	2	f	f	f
25	3	2	f	f	f
26	4	2	f	f	f
27	5	2	f	f	f
28	6	2	f	f	f
29	7	2	f	f	f
30	8	2	f	f	f
31	9	2	f	f	f
32	10	2	f	f	f
33	11	2	f	f	f
34	12	2	f	f	f
35	13	2	f	f	f
36	14	2	f	f	f
37	15	2	f	f	f
38	16	2	f	f	f
39	17	2	f	f	f
40	18	2	f	f	f
41	19	2	f	f	f
42	20	2	f	f	f
43	21	2	f	f	f
44	22	2	f	f	f
45	1	3	f	f	f
46	2	3	f	f	f
47	3	3	f	f	f
48	4	3	f	f	f
49	5	3	f	f	f
50	6	3	f	f	f
51	7	3	f	f	f
52	8	3	f	f	f
53	9	3	f	f	f
54	10	3	f	f	f
55	11	3	f	f	f
56	12	3	f	f	f
57	13	3	f	f	f
58	14	3	f	f	f
59	15	3	f	f	f
60	16	3	f	f	f
61	17	3	f	f	f
62	18	3	f	f	f
63	19	3	f	f	f
64	20	3	f	f	f
65	21	3	f	f	f
66	22	3	f	f	f
67	1	4	f	f	f
68	2	4	f	f	f
69	3	4	f	f	f
70	4	4	f	f	f
71	5	4	f	f	f
72	6	4	f	f	f
73	7	4	f	f	f
74	8	4	f	f	f
75	9	4	f	f	f
76	10	4	f	f	f
77	11	4	f	f	f
78	12	4	f	f	f
79	13	4	f	f	f
80	14	4	f	f	f
81	15	4	f	f	f
82	16	4	f	f	f
83	17	4	f	f	f
84	18	4	f	f	f
85	19	4	f	f	f
86	20	4	f	f	f
87	21	4	f	f	f
88	22	4	f	f	f
89	1	5	f	f	f
90	7	5	f	f	f
91	1	6	f	f	f
92	7	6	f	f	f
93	1	7	f	f	f
94	7	7	f	f	f
95	4	8	f	f	f
96	5	8	f	f	f
97	6	8	f	f	f
98	4	9	f	f	f
99	5	9	f	f	f
100	6	9	f	f	f
101	4	10	f	f	f
102	5	10	f	f	f
103	6	10	f	f	f
104	4	11	f	f	f
105	5	11	f	f	f
106	6	11	f	f	f
107	9	12	f	f	f
108	4	12	f	f	f
109	9	13	f	f	f
110	4	13	f	f	f
111	9	14	f	f	f
112	4	14	f	f	f
113	17	15	f	f	f
114	7	15	f	f	f
115	4	16	f	f	f
116	8	17	f	f	f
117	12	17	f	f	f
118	6	17	f	f	f
119	8	18	f	f	f
120	12	18	f	f	f
121	6	18	f	f	f
122	8	19	f	f	f
123	12	19	f	f	f
124	6	19	f	f	f
125	8	20	f	f	f
126	12	20	f	f	f
127	6	20	f	f	f
128	8	21	f	f	f
129	12	21	f	f	f
130	6	21	f	f	f
131	8	22	f	f	f
132	4	22	f	f	f
133	6	22	f	f	f
134	4	23	f	f	f
135	13	23	f	f	f
136	5	23	f	f	f
137	6	23	f	f	f
138	8	24	f	f	f
139	12	24	f	f	f
140	6	24	f	f	f
141	8	25	f	f	f
142	12	25	f	f	f
143	6	25	f	f	f
144	8	26	f	f	f
145	12	26	f	f	f
146	6	26	f	f	f
147	8	27	f	f	f
148	9	27	f	f	f
149	6	27	f	f	f
150	8	28	f	f	f
151	9	28	f	f	f
152	6	28	f	f	f
153	4	29	f	f	f
154	13	29	f	f	f
155	5	29	f	f	f
156	6	29	f	f	f
157	17	30	f	f	f
158	7	30	f	f	f
159	17	31	f	f	f
160	7	31	f	f	f
161	7	32	f	f	f
162	15	32	f	f	f
163	7	33	f	f	f
164	15	33	f	f	f
165	4	34	f	f	f
166	5	34	f	f	f
167	6	34	f	f	f
168	4	35	f	f	f
169	5	35	f	f	f
170	6	35	f	f	f
171	17	36	f	f	f
172	7	36	f	f	f
173	17	37	f	f	f
174	7	37	f	f	f
175	17	38	f	f	f
176	7	38	f	f	f
177	4	39	f	f	f
178	5	39	f	f	f
179	6	39	f	f	f
180	4	40	f	f	f
181	5	40	f	f	f
182	6	40	f	f	f
183	9	41	f	f	f
184	4	41	f	f	f
185	9	42	f	f	f
186	4	42	f	f	f
187	4	43	f	f	f
188	5	43	f	f	f
189	6	43	f	f	f
190	4	44	f	f	f
191	5	44	f	f	f
192	6	44	f	f	f
193	4	45	f	f	f
194	5	45	f	f	f
195	6	45	f	f	f
196	4	46	f	f	f
197	5	46	f	f	f
198	6	46	f	f	f
199	4	47	f	f	f
200	5	47	f	f	f
201	6	47	f	f	f
202	4	48	f	f	f
203	8	49	f	f	f
204	4	49	f	f	f
205	6	49	f	f	f
206	8	50	f	f	f
207	4	50	f	f	f
208	6	50	f	f	f
209	17	51	f	f	f
210	7	51	f	f	f
211	17	52	f	f	f
212	7	52	f	f	f
213	17	53	f	f	f
214	7	53	f	f	f
215	17	54	f	f	f
216	7	54	f	f	f
217	9	55	f	f	f
218	4	55	f	f	f
219	9	56	f	f	f
220	4	56	f	f	f
221	9	57	f	f	f
222	4	57	f	f	f
223	2	58	f	f	f
224	3	58	f	f	f
225	7	58	f	f	f
226	8	59	f	f	f
227	4	59	f	f	f
228	6	59	f	f	f
229	9	60	f	f	f
230	4	60	f	f	f
231	9	61	f	f	f
232	4	61	f	f	f
233	9	62	f	f	f
234	4	62	f	f	f
235	9	63	f	f	f
236	4	63	f	f	f
237	7	64	f	f	f
238	15	64	f	f	f
239	7	65	f	f	f
240	15	65	f	f	f
241	7	66	f	f	f
242	15	66	f	f	f
243	7	67	f	f	f
244	15	67	f	f	f
245	8	68	f	f	f
246	1	68	f	f	f
247	6	68	f	f	f
248	8	69	f	f	f
249	1	69	f	f	f
250	6	69	f	f	f
251	4	70	f	f	f
252	13	70	f	f	f
253	5	70	f	f	f
254	6	70	f	f	f
255	9	71	f	f	f
256	7	71	f	f	f
257	9	72	f	f	f
258	7	72	f	f	f
259	9	73	f	f	f
260	7	73	f	f	f
261	1	74	f	f	f
262	7	74	f	f	f
263	1	75	f	f	f
264	4	75	f	f	f
265	5	75	f	f	f
266	6	75	f	f	f
267	1	76	f	f	f
268	4	76	f	f	f
269	5	76	f	f	f
270	6	76	f	f	f
271	3	77	f	f	f
272	4	77	f	f	f
273	5	77	f	f	f
274	6	77	f	f	f
275	1	78	f	f	f
276	7	78	f	f	f
277	17	79	f	f	f
278	7	79	f	f	f
279	17	80	f	f	f
280	7	80	f	f	f
281	17	81	f	f	f
282	7	81	f	f	f
283	8	82	f	f	f
284	1	82	f	f	f
285	4	82	f	f	f
286	6	82	f	f	f
287	8	83	f	f	f
288	12	83	f	f	f
289	6	83	f	f	f
290	8	84	f	f	f
291	12	84	f	f	f
292	6	84	f	f	f
293	4	85	f	f	f
294	17	86	f	f	f
295	7	86	f	f	f
296	17	87	f	f	f
297	7	87	f	f	f
298	17	88	f	f	f
299	7	88	f	f	f
300	4	89	f	f	f
301	5	89	f	f	f
302	6	89	f	f	f
303	8	90	f	f	f
304	12	90	f	f	f
305	6	90	f	f	f
306	8	91	f	f	f
307	12	91	f	f	f
308	6	91	f	f	f
309	1	92	f	f	f
310	7	92	f	f	f
311	1	93	f	f	f
312	7	93	f	f	f
313	3	94	f	f	f
314	4	94	f	f	f
315	5	94	f	f	f
316	6	94	f	f	f
317	8	95	f	f	f
318	9	95	f	f	f
319	6	95	f	f	f
320	8	96	f	f	f
321	9	96	f	f	f
322	6	96	f	f	f
323	8	97	f	f	f
324	9	97	f	f	f
325	6	97	f	f	f
326	4	98	f	f	f
327	5	98	f	f	f
328	6	98	f	f	f
329	4	99	f	f	f
330	5	99	f	f	f
331	6	99	f	f	f
332	1	100	f	f	f
333	7	100	f	f	f
334	4	101	f	f	f
335	5	101	f	f	f
336	6	101	f	f	f
337	7	102	f	f	f
338	15	102	f	f	f
339	7	103	f	f	f
340	15	103	f	f	f
341	17	104	f	f	f
342	7	104	f	f	f
343	17	105	f	f	f
344	7	105	f	f	f
345	4	106	f	f	f
346	7	106	f	f	f
347	7	107	f	f	f
348	15	107	f	f	f
349	7	108	f	f	f
350	15	108	f	f	f
351	8	109	f	f	f
352	4	109	f	f	f
353	6	109	f	f	f
354	8	110	f	f	f
355	4	110	f	f	f
356	6	110	f	f	f
357	8	111	f	f	f
358	9	111	f	f	f
359	6	111	f	f	f
360	8	112	f	f	f
361	9	112	f	f	f
362	6	112	f	f	f
363	8	113	f	f	f
364	9	113	f	f	f
365	6	113	f	f	f
366	8	114	f	f	f
367	9	114	f	f	f
368	6	114	f	f	f
369	8	115	f	f	f
370	9	115	f	f	f
371	6	115	f	f	f
372	8	116	f	f	f
373	9	116	f	f	f
374	6	116	f	f	f
375	8	117	f	f	f
376	9	117	f	f	f
377	6	117	f	f	f
378	8	118	f	f	f
379	9	118	f	f	f
380	6	118	f	f	f
381	8	119	f	f	f
382	9	119	f	f	f
383	6	119	f	f	f
384	8	120	f	f	f
385	9	120	f	f	f
386	6	120	f	f	f
387	8	121	f	f	f
388	4	121	f	f	f
389	6	121	f	f	f
390	1	122	f	f	f
391	7	122	f	f	f
392	1	123	f	f	f
393	7	123	f	f	f
394	4	124	f	f	f
395	13	124	f	f	f
396	5	124	f	f	f
397	6	124	f	f	f
398	4	125	f	f	f
399	13	125	f	f	f
400	5	125	f	f	f
401	6	125	f	f	f
402	8	126	f	f	f
403	4	126	f	f	f
404	6	126	f	f	f
405	7	127	f	f	f
406	15	127	f	f	f
407	7	128	f	f	f
408	15	128	f	f	f
409	7	129	f	f	f
410	15	129	f	f	f
411	7	130	f	f	f
412	15	130	f	f	f
413	7	131	f	f	f
414	15	131	f	f	f
415	7	132	f	f	f
416	15	132	f	f	f
417	7	133	f	f	f
418	15	133	f	f	f
419	7	134	f	f	f
420	15	134	f	f	f
421	7	135	f	f	f
422	15	135	f	f	f
423	8	136	f	f	f
424	12	136	f	f	f
425	6	136	f	f	f
426	8	137	f	f	f
427	12	137	f	f	f
428	6	137	f	f	f
429	1	138	f	f	f
430	7	138	f	f	f
431	4	139	f	f	f
432	8	140	f	f	f
433	12	140	f	f	f
434	6	140	f	f	f
435	8	141	f	f	f
436	12	141	f	f	f
437	6	141	f	f	f
438	4	142	f	f	f
439	7	142	f	f	f
440	2	143	f	f	f
441	4	143	f	f	f
442	13	143	f	f	f
443	5	143	f	f	f
444	6	143	f	f	f
445	2	144	f	f	f
446	4	144	f	f	f
447	13	144	f	f	f
448	5	144	f	f	f
449	6	144	f	f	f
450	7	145	f	f	f
451	15	145	f	f	f
452	7	146	f	f	f
453	15	146	f	f	f
454	7	147	f	f	f
455	15	147	f	f	f
456	17	148	f	f	f
457	7	148	f	f	f
458	4	149	f	f	f
459	5	149	f	f	f
460	6	149	f	f	f
461	1	150	f	f	f
462	7	150	f	f	f
463	7	151	f	f	f
464	15	151	f	f	f
465	7	152	f	f	f
466	15	152	f	f	f
467	8	153	f	f	f
468	12	153	f	f	f
469	6	153	f	f	f
470	8	154	f	f	f
471	12	154	f	f	f
472	6	154	f	f	f
473	9	155	f	f	f
474	7	155	f	f	f
475	9	156	f	f	f
476	7	156	f	f	f
477	9	157	f	f	f
478	7	157	f	f	f
479	8	158	f	f	f
480	4	158	f	f	f
481	6	158	f	f	f
482	8	159	f	f	f
483	4	159	f	f	f
484	6	159	f	f	f
485	4	160	f	f	f
486	7	160	f	f	f
487	4	161	f	f	f
488	13	161	f	f	f
489	5	161	f	f	f
490	6	161	f	f	f
491	8	162	f	f	f
492	12	162	f	f	f
493	6	162	f	f	f
494	8	163	f	f	f
495	12	163	f	f	f
496	6	163	f	f	f
497	4	164	f	f	f
498	7	164	f	f	f
499	4	165	f	f	f
500	7	165	f	f	f
501	8	166	f	f	f
502	4	166	f	f	f
503	6	166	f	f	f
504	8	167	f	f	f
505	4	167	f	f	f
506	6	167	f	f	f
507	8	168	f	f	f
508	4	168	f	f	f
509	6	168	f	f	f
510	4	169	f	f	f
511	4	170	f	f	f
512	1	171	f	f	f
513	7	171	f	f	f
514	1	172	f	f	f
515	7	172	f	f	f
516	1	173	f	f	f
517	7	173	f	f	f
518	8	174	f	f	f
519	12	174	f	f	f
520	6	174	f	f	f
521	8	175	f	f	f
522	12	175	f	f	f
523	6	175	f	f	f
524	8	176	f	f	f
525	12	176	f	f	f
526	6	176	f	f	f
527	8	177	f	f	f
528	12	177	f	f	f
529	6	177	f	f	f
530	9	178	f	f	f
531	7	178	f	f	f
532	9	179	f	f	f
533	7	179	f	f	f
534	9	180	f	f	f
535	7	180	f	f	f
536	1	181	f	f	f
537	7	181	f	f	f
538	1	182	f	f	f
539	7	182	f	f	f
540	1	183	f	f	f
541	7	183	f	f	f
542	17	184	f	f	f
543	7	184	f	f	f
544	1	185	f	f	f
545	5	186	f	f	f
546	11	186	f	f	f
547	5	187	f	f	f
548	11	187	f	f	f
549	5	188	f	f	f
550	15	188	f	f	f
551	5	189	f	f	f
552	15	189	f	f	f
553	5	190	f	f	f
554	4	190	f	f	f
555	5	191	f	f	f
556	4	191	f	f	f
557	13	192	f	f	f
558	4	193	f	f	f
559	4	194	f	f	f
560	1	195	f	f	f
561	5	195	f	f	f
562	1	196	f	f	f
563	5	196	f	f	f
564	1	197	f	f	f
565	1	198	f	f	f
566	11	198	f	f	f
567	1	199	f	f	f
568	11	199	f	f	f
569	5	200	f	f	f
570	3	201	f	f	f
571	1	202	f	f	f
572	1	203	f	f	f
573	1	204	f	f	f
574	5	205	f	f	f
575	3	206	f	f	f
576	3	207	f	f	f
577	3	208	f	f	f
578	4	209	f	f	f
579	1	210	f	f	f
580	4	211	f	f	f
581	5	212	f	f	f
582	5	213	f	f	f
583	11	214	f	f	f
584	1	215	f	f	f
585	13	215	f	f	f
586	1	216	f	f	f
587	13	216	f	f	f
588	13	217	f	f	f
589	1	218	f	f	f
590	1	219	f	f	f
591	11	220	f	f	f
592	5	221	f	f	f
593	4	221	f	f	f
594	5	222	f	f	f
595	4	222	f	f	f
596	4	223	f	f	f
597	1	224	f	f	f
598	4	225	f	f	f
599	15	226	f	f	f
600	1	227	f	f	f
601	1	228	f	f	f
602	5	229	f	f	f
603	4	230	f	f	f
604	1	231	f	f	f
605	1	232	f	f	f
606	1	233	f	f	f
607	1	234	f	f	f
608	1	235	f	f	f
609	1	236	f	f	f
610	1	237	f	f	f
611	3	237	f	f	f
612	1	238	f	f	f
613	3	238	f	f	f
\.


--
-- Name: ozpcenter_notificationmailbox_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ozp_user
--

SELECT pg_catalog.setval('ozpcenter_notificationmailbox_id_seq', 613, true);


--
-- Data for Name: ozpcenter_profile; Type: TABLE DATA; Schema: public; Owner: ozp_user
--

COPY ozpcenter_profile (id, display_name, bio, dn, issuer_dn, auth_expires, access_control, user_id, center_tour_flag, hud_tour_flag, webtop_tour_flag, email_notification_flag, listing_notification_flag, subscription_notification_flag, leaving_ozp_warning_flag) FROM stdin;
1	Big Brother		Big Brother bigbrother	\N	2017-11-08 18:07:36.275897-05	{"clearances": ["UNCLASSIFIED", "CONFIDENTIAL", "SECRET", "TOP SECRET"], "formal_accesses": ["SIERRA", "TANGO", "GOLF", "HOTEL"], "visas": ["NOVEMBER"]}	1	t	t	t	t	t	t	t
2	Big Brother2		Big Brother 2 bigbrother2	\N	2017-11-08 18:07:36.330154-05	{"clearances": ["UNCLASSIFIED", "CONFIDENTIAL", "SECRET", "TOP SECRET"], "formal_accesses": ["SIERRA", "TANGO", "GOLF", "HOTEL"], "visas": ["NOVEMBER"]}	2	t	t	t	t	t	t	t
3	Daenerys Targaryen		Daenerys Targaryen khaleesi	\N	2017-11-08 18:07:36.373964-05	{"clearances": ["UNCLASSIFIED", "CONFIDENTIAL", "SECRET", "TOP SECRET"], "formal_accesses": ["SIERRA", "TANGO", "GOLF", "HOTEL"], "visas": ["DRS"]}	3	t	t	t	t	t	t	t
4	Betta Fish		Bettafish bettafish	\N	2017-11-08 18:07:36.418045-05	{"clearances": ["UNCLASSIFIED", "CONFIDENTIAL", "SECRET", "TOP SECRET"], "formal_accesses": ["SIERRA", "TANGO", "GOLF", "HOTEL"], "visas": ["NOVEMBER"]}	4	t	t	t	t	t	t	t
5	Winston Smith		Winston Smith wsmith	\N	2017-11-08 18:07:36.476614-05	{"clearances": ["UNCLASSIFIED", "CONFIDENTIAL", "SECRET", "TOP SECRET"], "formal_accesses": ["SIERRA", "TANGO"], "visas": ["NOVEMBER"]}	5	t	t	t	t	t	t	t
6	Julia Dixon		Julia Dixon jdixon	\N	2017-11-08 18:07:36.519109-05	{"clearances": ["UNCLASSIFIED", "CONFIDENTIAL", "SECRET", "TOP SECRET"], "formal_accesses": ["SIERRA"], "visas": []}	6	t	t	t	t	t	t	t
7	O'brien		OBrien obrien	\N	2017-11-08 18:07:36.564033-05	{"clearances": ["UNCLASSIFIED", "CONFIDENTIAL", "SECRET", "TOP SECRET"], "formal_accesses": ["SIERRA", "TANGO", "GOLF", "HOTEL"], "visas": ["NOVEMBER"]}	7	t	t	t	t	t	t	t
8	David		David david	\N	2017-11-08 18:07:36.608798-05	{"clearances": ["UNCLASSIFIED", "CONFIDENTIAL", "SECRET", "TOP SECRET"], "formal_accesses": ["SIERRA", "TANGO", "GOLF", "HOTEL"], "visas": ["NOVEMBER"]}	8	t	t	t	t	t	t	t
9	Aaronson		Aaronson aaronson	\N	2017-11-08 18:07:36.650389-05	{"clearances": ["UNCLASSIFIED", "CONFIDENTIAL", "SECRET"], "formal_accesses": [], "visas": ["NOVEMBER"]}	9	t	t	t	t	t	t	t
10	pmurt		dlanod pmurt	\N	2017-11-08 18:07:36.689381-05	{"clearances": ["UNCLASSIFIED", "CONFIDENTIAL", "SECRET"], "formal_accesses": [], "visas": ["NOVEMBER"]}	10	t	t	t	t	t	t	t
11	Hodor		Hodor hodor	\N	2017-11-08 18:07:36.728964-05	{"clearances": ["UNCLASSIFIED", "CONFIDENTIAL", "SECRET"], "formal_accesses": [], "visas": ["STE", "RVR", "PKI"]}	11	t	t	t	t	t	t	t
12	Beta Ray Bill		BetaRayBill betaraybill	\N	2017-11-08 18:07:36.771045-05	{"clearances": ["UNCLASSIFIED", "CONFIDENTIAL", "SECRET", "TOP SECRET"], "formal_accesses": ["SIERRA", "TANGO", "GOLF", "HOTEL"], "visas": ["NOVEMBER"]}	12	t	t	t	t	t	t	t
13	Jones		Jones jones	\N	2017-11-08 18:07:36.810226-05	{"clearances": ["UNCLASSIFIED", "CONFIDENTIAL", "SECRET"], "formal_accesses": [], "visas": ["NOVEMBER"]}	13	t	t	t	t	t	t	t
14	Tammy		Tammy tammy	\N	2017-11-08 18:07:36.849443-05	{"clearances": ["UNCLASSIFIED", "CONFIDENTIAL", "SECRET"], "formal_accesses": [], "visas": ["NOVEMBER", "PKI"]}	14	t	t	t	t	t	t	t
15	Rutherford		Rutherford rutherford	\N	2017-11-08 18:07:36.888976-05	{"clearances": ["UNCLASSIFIED", "CONFIDENTIAL", "SECRET"], "formal_accesses": [], "visas": []}	15	t	t	t	t	t	t	t
16	Noah		Noah noah	\N	2017-11-08 18:07:36.928506-05	{"clearances": ["UNCLASSIFIED", "CONFIDENTIAL", "SECRET"], "formal_accesses": [], "visas": ["PKI"]}	16	t	t	t	t	t	t	t
17	Syme		Syme syme	\N	2017-11-08 18:07:36.967534-05	{"clearances": ["UNCLASSIFIED", "CONFIDENTIAL", "SECRET", "TOP SECRET"], "formal_accesses": ["SIERRA"], "visas": []}	17	t	t	t	t	t	t	t
18	Abe		Abe abe	\N	2017-11-08 18:07:37.006811-05	{"clearances": ["UNCLASSIFIED", "CONFIDENTIAL", "SECRET", "TOP SECRET"], "formal_accesses": ["SIERRA"], "visas": ["PKI"]}	18	t	t	t	t	t	t	t
19	Tom Parsons		Tparsons tparsons	\N	2017-11-08 18:07:37.046207-05	{"clearances": ["UNCLASSIFIED"], "formal_accesses": [], "visas": []}	19	t	t	t	t	t	t	t
20	Jon Snow		Jonsnow jsnow	\N	2017-11-08 18:07:37.088211-05	{"clearances": ["UNCLASSIFIED"], "formal_accesses": [], "visas": ["TWN", "PKI"]}	20	t	t	t	t	t	t	t
21	Charrington		Charrington charrington	\N	2017-11-08 18:07:37.130216-05	{"clearances": ["UNCLASSIFIED", "CONFIDENTIAL", "SECRET", "TOP SECRET"], "formal_accesses": ["SIERRA", "TANGO", "GOLF", "HOTEL"], "visas": ["NOVEMBER"]}	21	t	t	t	t	t	t	t
22	Johnson		Johnson johnson	\N	2017-11-08 18:07:37.175701-05	{"clearances": ["UNCLASSIFIED", "CONFIDENTIAL", "SECRET", "TOP SECRET"], "formal_accesses": ["SIERRA", "TANGO", "GOLF", "HOTEL"], "visas": ["NOVEMBER", "PKI"]}	22	t	t	t	t	t	t	t
\.


--
-- Name: ozpcenter_profile_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ozp_user
--

SELECT pg_catalog.setval('ozpcenter_profile_id_seq', 22, true);


--
-- Data for Name: ozpcenter_recommendationfeedback; Type: TABLE DATA; Schema: public; Owner: ozp_user
--

COPY ozpcenter_recommendationfeedback (id, feedback, target_listing_id, target_profile_id) FROM stdin;
\.


--
-- Name: ozpcenter_recommendationfeedback_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ozp_user
--

SELECT pg_catalog.setval('ozpcenter_recommendationfeedback_id_seq', 1, false);


--
-- Data for Name: ozpcenter_recommendationsentry; Type: TABLE DATA; Schema: public; Owner: ozp_user
--

COPY ozpcenter_recommendationsentry (id, target_profile_id, recommendation_data) FROM stdin;
1	1	\\x82a8426173656c696e6583a76d735f746f6f6bcb409b5f8780000000af7265636f6d6d656e646174696f6e73dc001492ccbacb4027000000000000920acb40240000000000009209cb4022666666666666920ecb40220000000000009252cb40220000000000009260cb402200000000000092cc9ecb40220000000000009202cb40200000000000009217cb4020000000000000921ecb402000000000000092cc93cb402000000000000092ccb4cb4020000000000000922fcb401c0000000000009246cb401c0000000000009249cb401c00000000000092cc9fcb401c00000000000092cca2cb401c00000000000092ccb2cb401acccccccccccd9212cb401a000000000000924dcb4019333333333333a6776569676874cb3ff0000000000000da0020426f6f6b6d61726b20436f6c6c61626f7261746976652046696c746572696e6783a76d735f746f6f6bcb402adc8000000000af7265636f6d6d656e646174696f6e73dc00119202cb40000000000000009260cb3ff00000000000009244cb3ff00000000000009245cb3ff00000000000009246cb3ff00000000000009209cb3ff0000000000000920acb3ff0000000000000922ccb3ff0000000000000924dcb3ff0000000000000920ecb3ff0000000000000922fcb3ff00000000000009251cb3ff00000000000009252cb3ff000000000000092cc93cb3ff0000000000000925acb3ff00000000000009265cb3ff0000000000000923fcb3ff0000000000000a6776569676874cb4014000000000000
2	2	\\x81a8426173656c696e6583a76d735f746f6f6bcb409b5f8780000000af7265636f6d6d656e646174696f6e73dc001492ccbacb4027000000000000920acb40240000000000009209cb4022666666666666920ecb40220000000000009252cb40220000000000009260cb402200000000000092cc9ecb40220000000000009202cb40200000000000009217cb4020000000000000921ecb402000000000000092cc93cb402000000000000092ccb4cb4020000000000000922fcb401c0000000000009246cb401c0000000000009249cb401c00000000000092cc9fcb401c00000000000092cca2cb401c00000000000092ccb2cb401acccccccccccd9212cb401a000000000000924dcb4019333333333333a6776569676874cb3ff0000000000000
3	3	\\x82a8426173656c696e6583a76d735f746f6f6bcb409b5f8780000000af7265636f6d6d656e646174696f6e73dc001492ccbacb4027000000000000920acb40240000000000009209cb4022666666666666920ecb40220000000000009252cb40220000000000009260cb402200000000000092cc9ecb40220000000000009202cb40200000000000009217cb4020000000000000921ecb402000000000000092cc93cb402000000000000092ccb4cb4020000000000000922fcb401c0000000000009246cb401c0000000000009249cb401c00000000000092cc9fcb401c00000000000092cca2cb401c00000000000092ccb2cb401acccccccccccd9212cb401a000000000000924dcb4019333333333333a6776569676874cb3ff0000000000000da0020426f6f6b6d61726b20436f6c6c61626f7261746976652046696c746572696e6783a76d735f746f6f6bcb402adc8000000000af7265636f6d6d656e646174696f6e73dc00149201cb3ff00000000000009249cb3ff0000000000000927acb3ff00000000000009217cb3ff0000000000000926ccb3ff000000000000092ccafcb3ff000000000000092cc9ecb3ff0000000000000921dcb3ff00000000000009231cb3ff00000000000009232cb3ff000000000000092ccb4cb3ff0000000000000925ecb3ff00000000000009257cb3ff000000000000092cca9cb3ff000000000000092cc9acb3ff0000000000000923bcb3ff000000000000092cc9ccb3ff0000000000000925dcb3ff0000000000000921ecb3ff0000000000000927fcb3ff0000000000000a6776569676874cb4014000000000000
4	4	\\x82a8426173656c696e6583a76d735f746f6f6bcb409b5f8780000000af7265636f6d6d656e646174696f6e73dc001492ccbacb4027000000000000920acb40240000000000009209cb4022666666666666920ecb40220000000000009252cb40220000000000009260cb402200000000000092cc9ecb40220000000000009202cb40200000000000009217cb4020000000000000921ecb402000000000000092cc93cb402000000000000092ccb4cb4020000000000000922fcb401c0000000000009246cb401c0000000000009249cb401c00000000000092cc9fcb401c00000000000092cca2cb401c00000000000092ccb2cb401acccccccccccd9212cb401a000000000000924dcb4019333333333333a6776569676874cb3ff0000000000000da0020426f6f6b6d61726b20436f6c6c61626f7261746976652046696c746572696e6783a76d735f746f6f6bcb402adc8000000000af7265636f6d6d656e646174696f6e73989251cb3ff00000000000009202cb3ff000000000000092cc93cb3ff00000000000009217cb3ff00000000000009209cb3ff0000000000000922ccb3ff0000000000000924dcb3ff0000000000000923fcb3ff0000000000000a6776569676874cb4014000000000000
5	5	\\x82a8426173656c696e6583a76d735f746f6f6bcb409b5f8780000000af7265636f6d6d656e646174696f6e73dc001492ccbacb4027000000000000920acb40240000000000009209cb4022666666666666920ecb40220000000000009252cb40220000000000009260cb402200000000000092cc9ecb40220000000000009202cb40200000000000009217cb4020000000000000921ecb402000000000000092cc93cb402000000000000092ccb4cb4020000000000000922fcb401c0000000000009246cb401c0000000000009249cb401c00000000000092cc9fcb401c00000000000092cca2cb401c00000000000092ccb2cb401acccccccccccd9212cb401a000000000000924dcb4019333333333333a6776569676874cb3ff0000000000000da0020426f6f6b6d61726b20436f6c6c61626f7261746976652046696c746572696e6783a76d735f746f6f6bcb402adc8000000000af7265636f6d6d656e646174696f6e73dc0014921ecb40000000000000009201cb3ff00000000000009248cb3ff00000000000009249cb3ff0000000000000924ccb3ff00000000000009212cb3ff000000000000092cc94cb3ff00000000000009215cb3ff00000000000009257cb3ff000000000000092cc9acb3ff000000000000092cc9ccb3ff0000000000000921dcb3ff000000000000092cc9ecb3ff00000000000009260cb3ff00000000000009267cb3ff000000000000092cca9cb3ff0000000000000927acb3ff0000000000000926ccb3ff00000000000009252cb3ff0000000000000925dcb3ff0000000000000a6776569676874cb4014000000000000
6	6	\\x81a8426173656c696e6583a76d735f746f6f6bcb409b5f8780000000af7265636f6d6d656e646174696f6e73dc001492ccbacb4027000000000000920acb40240000000000009209cb4022666666666666920ecb40220000000000009252cb40220000000000009260cb402200000000000092cc9ecb40220000000000009202cb40200000000000009217cb4020000000000000921ecb402000000000000092cc93cb402000000000000092ccb4cb4020000000000000922fcb401c0000000000009246cb401c0000000000009249cb401c00000000000092cc9fcb401c00000000000092cca2cb401c00000000000092ccb2cb401acccccccccccd9212cb401a000000000000924dcb4019333333333333a6776569676874cb3ff0000000000000
7	7	\\x81a8426173656c696e6583a76d735f746f6f6bcb409b5f8780000000af7265636f6d6d656e646174696f6e73dc001492ccbacb4027000000000000920acb40240000000000009209cb4022666666666666920ecb40220000000000009252cb40220000000000009260cb40220000000000009265cb402200000000000092cc9ecb40220000000000009202cb4020000000000000921ecb402000000000000092cc93cb4020000000000000922fcb401c0000000000009246cb401c0000000000009249cb401c00000000000092cc9fcb401c00000000000092cca2cb401c00000000000092ccb2cb401acccccccccccd9212cb401a000000000000924dcb40193333333333339251cb4019333333333333a6776569676874cb3ff0000000000000
8	8	\\x81a8426173656c696e6583a76d735f746f6f6bcb409b5f8780000000af7265636f6d6d656e646174696f6e73dc001492ccbacb4027000000000000920acb40240000000000009209cb4022666666666666920ecb40220000000000009252cb40220000000000009260cb40220000000000009265cb402200000000000092cc9ecb40220000000000009202cb4020000000000000921ecb402000000000000092cc93cb4020000000000000922fcb401c0000000000009246cb401c0000000000009249cb401c00000000000092cc9fcb401c00000000000092cca2cb401c00000000000092ccb2cb401acccccccccccd9212cb401a000000000000924dcb40193333333333339251cb4019333333333333a6776569676874cb3ff0000000000000
9	9	\\x81a8426173656c696e6583a76d735f746f6f6bcb409b5f8780000000af7265636f6d6d656e646174696f6e73dc001492ccbacb4027000000000000920acb40240000000000009209cb4022666666666666920ecb40220000000000009252cb40220000000000009260cb40220000000000009265cb402200000000000092cc9ecb40220000000000009202cb4020000000000000921ecb402000000000000092cc93cb4020000000000000922fcb401c0000000000009246cb401c0000000000009249cb401c00000000000092cc9fcb401c00000000000092cca2cb401c00000000000092ccb2cb401acccccccccccd9212cb401a000000000000924dcb40193333333333339251cb4019333333333333a6776569676874cb3ff0000000000000
10	10	\\x81a8426173656c696e6583a76d735f746f6f6bcb409b5f8780000000af7265636f6d6d656e646174696f6e73dc001492ccbacb4027000000000000920acb40240000000000009209cb4022666666666666920ecb40220000000000009252cb40220000000000009260cb40220000000000009265cb402200000000000092cc9ecb40220000000000009202cb4020000000000000921ecb402000000000000092cc93cb4020000000000000922fcb401c0000000000009246cb401c0000000000009249cb401c00000000000092cc9fcb401c00000000000092cca2cb401c00000000000092ccb2cb401acccccccccccd9212cb401a000000000000924dcb40193333333333339251cb4019333333333333a6776569676874cb3ff0000000000000
11	11	\\x82a8426173656c696e6583a76d735f746f6f6bcb409b5f8780000000af7265636f6d6d656e646174696f6e73dc001492ccbacb4027000000000000920acb40240000000000009209cb4022666666666666920ecb40220000000000009252cb40220000000000009260cb40220000000000009265cb402200000000000092cc9ecb40220000000000009202cb4020000000000000921ecb402000000000000092cc93cb4020000000000000922fcb401c0000000000009246cb401c0000000000009249cb401c00000000000092cc9fcb401c00000000000092cca2cb401c00000000000092ccb2cb401acccccccccccd9212cb401a000000000000924dcb40193333333333339251cb4019333333333333a6776569676874cb3ff0000000000000da0020426f6f6b6d61726b20436f6c6c61626f7261746976652046696c746572696e6783a76d735f746f6f6bcb402adc8000000000af7265636f6d6d656e646174696f6e73dc00149217cb40000000000000009201cb3ff00000000000009249cb3ff0000000000000920acb3ff00000000000009257cb3ff0000000000000924dcb3ff00000000000009251cb3ff000000000000092cc93cb3ff0000000000000927acb3ff000000000000092cc9acb3ff000000000000092cc9ccb3ff0000000000000921dcb3ff000000000000092cc9ecb3ff00000000000009265cb3ff000000000000092cca9cb3ff0000000000000927fcb3ff0000000000000922ccb3ff0000000000000925dcb3ff000000000000092ccafcb3ff00000000000009231cb3ff0000000000000a6776569676874cb4014000000000000
12	12	\\x81a8426173656c696e6583a76d735f746f6f6bcb409b5f8780000000af7265636f6d6d656e646174696f6e73dc001492ccbacb4027000000000000920acb40240000000000009209cb4022666666666666920ecb40220000000000009252cb40220000000000009260cb40220000000000009265cb402200000000000092cc9ecb40220000000000009202cb4020000000000000921ecb402000000000000092cc93cb4020000000000000922fcb401c0000000000009246cb401c0000000000009249cb401c00000000000092cc9fcb401c00000000000092cca2cb401c00000000000092ccb2cb401acccccccccccd9212cb401a000000000000924dcb40193333333333339251cb4019333333333333a6776569676874cb3ff0000000000000
13	13	\\x82a8426173656c696e6583a76d735f746f6f6bcb409b5f8780000000af7265636f6d6d656e646174696f6e73dc001492ccbacb4027000000000000920acb40240000000000009209cb4022666666666666920ecb40220000000000009252cb40220000000000009260cb402200000000000092cc9ecb40220000000000009202cb40200000000000009217cb4020000000000000921ecb402000000000000092cc93cb402000000000000092ccb4cb4020000000000000922fcb401c0000000000009246cb401c0000000000009249cb401c00000000000092cc9fcb401c00000000000092cca2cb401c00000000000092ccb2cb401acccccccccccd9212cb401a000000000000924dcb4019333333333333a6776569676874cb3ff0000000000000da0020426f6f6b6d61726b20436f6c6c61626f7261746976652046696c746572696e6783a76d735f746f6f6bcb402adc8000000000af7265636f6d6d656e646174696f6e73dc00149201cb3ff00000000000009249cb3ff0000000000000927acb3ff0000000000000926ccb3ff000000000000092ccafcb3ff000000000000092cc9ecb3ff0000000000000921dcb3ff00000000000009231cb3ff00000000000009232cb3ff000000000000092ccb4cb3ff0000000000000925ecb3ff000000000000092cc9acb3ff00000000000009217cb3ff000000000000092cca9cb3ff000000000000092ccbacb3ff0000000000000923bcb3ff000000000000092cc9ccb3ff0000000000000925dcb3ff0000000000000921ecb3ff0000000000000927fcb3ff0000000000000a6776569676874cb4014000000000000
14	14	\\x81a8426173656c696e6583a76d735f746f6f6bcb409b5f8780000000af7265636f6d6d656e646174696f6e73dc001492ccbacb4027000000000000920acb40240000000000009209cb4022666666666666920ecb40220000000000009252cb40220000000000009260cb402200000000000092cc9ecb40220000000000009202cb40200000000000009217cb4020000000000000921ecb402000000000000092cc93cb402000000000000092ccb4cb4020000000000000922fcb401c0000000000009246cb401c0000000000009249cb401c00000000000092cc9fcb401c00000000000092cca2cb401c00000000000092ccb2cb401acccccccccccd9212cb401a000000000000924dcb4019333333333333a6776569676874cb3ff0000000000000
15	15	\\x82a8426173656c696e6583a76d735f746f6f6bcb409b5f8780000000af7265636f6d6d656e646174696f6e73dc001492ccbacb4027000000000000920acb40240000000000009209cb4022666666666666920ecb40220000000000009252cb40220000000000009260cb40220000000000009265cb402200000000000092cc9ecb40220000000000009202cb4020000000000000921ecb402000000000000092cc93cb4020000000000000922fcb401c0000000000009246cb401c0000000000009249cb401c00000000000092cc9fcb401c00000000000092cca2cb401c00000000000092ccb2cb401acccccccccccd9212cb401a000000000000924dcb40193333333333339251cb4019333333333333a6776569676874cb3ff0000000000000da0020426f6f6b6d61726b20436f6c6c61626f7261746976652046696c746572696e6783a76d735f746f6f6bcb402adc8000000000af7265636f6d6d656e646174696f6e73999251cb3ff00000000000009202cb3ff000000000000092cc93cb3ff00000000000009265cb3ff00000000000009217cb3ff0000000000000920acb3ff0000000000000922ccb3ff0000000000000924dcb3ff0000000000000923fcb3ff0000000000000a6776569676874cb4014000000000000
16	16	\\x81a8426173656c696e6583a76d735f746f6f6bcb409b5f8780000000af7265636f6d6d656e646174696f6e73dc001492ccbacb4027000000000000920acb40240000000000009209cb4022666666666666920ecb40220000000000009252cb40220000000000009260cb40220000000000009265cb402200000000000092cc9ecb40220000000000009202cb4020000000000000921ecb402000000000000092cc93cb4020000000000000922fcb401c0000000000009246cb401c0000000000009249cb401c00000000000092cc9fcb401c00000000000092cca2cb401c00000000000092ccb2cb401acccccccccccd9212cb401a000000000000924dcb40193333333333339251cb4019333333333333a6776569676874cb3ff0000000000000
17	17	\\x81a8426173656c696e6583a76d735f746f6f6bcb409b5f8780000000af7265636f6d6d656e646174696f6e73dc001492ccbacb4027000000000000920acb40240000000000009209cb4022666666666666920ecb40220000000000009252cb40220000000000009260cb40220000000000009265cb402200000000000092cc9ecb40220000000000009202cb4020000000000000921ecb402000000000000092cc93cb4020000000000000922fcb401c0000000000009246cb401c0000000000009249cb401c00000000000092cc9fcb401c00000000000092cca2cb401c00000000000092ccb2cb401acccccccccccd9212cb401a000000000000924dcb40193333333333339251cb4019333333333333a6776569676874cb3ff0000000000000
18	18	\\x81a8426173656c696e6583a76d735f746f6f6bcb409b5f8780000000af7265636f6d6d656e646174696f6e73dc001492ccbacb4027000000000000920acb40240000000000009209cb4022666666666666920ecb40220000000000009252cb40220000000000009260cb40220000000000009265cb402200000000000092cc9ecb40220000000000009202cb4020000000000000921ecb402000000000000092cc93cb4020000000000000922fcb401c0000000000009246cb401c0000000000009249cb401c00000000000092cc9fcb401c00000000000092cca2cb401c00000000000092ccb2cb401acccccccccccd9212cb401a000000000000924dcb40193333333333339251cb4019333333333333a6776569676874cb3ff0000000000000
19	19	\\x81a8426173656c696e6583a76d735f746f6f6bcb409b5f8780000000af7265636f6d6d656e646174696f6e73dc001492ccbacb4027000000000000920acb40240000000000009209cb4022666666666666920ecb40220000000000009252cb40220000000000009260cb40220000000000009265cb402200000000000092cc9ecb40220000000000009202cb4020000000000000921ecb402000000000000092cc93cb4020000000000000922fcb401c0000000000009246cb401c0000000000009249cb401c00000000000092cc9fcb401c00000000000092cca2cb401c00000000000092ccb2cb401acccccccccccd9212cb401a000000000000924dcb40193333333333339251cb4019333333333333a6776569676874cb3ff0000000000000
20	20	\\x81a8426173656c696e6583a76d735f746f6f6bcb409b5f8780000000af7265636f6d6d656e646174696f6e73dc001492ccbacb4027000000000000920acb40240000000000009209cb4022666666666666920ecb40220000000000009252cb40220000000000009260cb40220000000000009265cb402200000000000092cc9ecb40220000000000009202cb4020000000000000921ecb402000000000000092cc93cb4020000000000000922fcb401c0000000000009246cb401c0000000000009249cb401c00000000000092cc9fcb401c00000000000092cca2cb401c00000000000092ccb2cb401acccccccccccd9212cb401a000000000000924dcb40193333333333339251cb4019333333333333a6776569676874cb3ff0000000000000
21	21	\\x81a8426173656c696e6583a76d735f746f6f6bcb409b5f8780000000af7265636f6d6d656e646174696f6e73dc001492ccbacb4027000000000000920acb40240000000000009209cb4022666666666666920ecb40220000000000009252cb40220000000000009260cb402200000000000092cc9ecb40220000000000009202cb40200000000000009217cb4020000000000000921ecb402000000000000092cc93cb402000000000000092ccb4cb4020000000000000922fcb401c0000000000009246cb401c0000000000009249cb401c00000000000092cc9fcb401c00000000000092cca2cb401c00000000000092ccb2cb401acccccccccccd9212cb401a000000000000924dcb4019333333333333a6776569676874cb3ff0000000000000
22	22	\\x81a8426173656c696e6583a76d735f746f6f6bcb409b5f8780000000af7265636f6d6d656e646174696f6e73dc001492ccbacb4027000000000000920acb40240000000000009209cb4022666666666666920ecb40220000000000009252cb40220000000000009260cb402200000000000092cc9ecb40220000000000009202cb40200000000000009217cb4020000000000000921ecb402000000000000092cc93cb402000000000000092ccb4cb4020000000000000922fcb401c0000000000009246cb401c0000000000009249cb401c00000000000092cc9fcb401c00000000000092cca2cb401c00000000000092ccb2cb401acccccccccccd9212cb401a000000000000924dcb4019333333333333a6776569676874cb3ff0000000000000
\.


--
-- Name: ozpcenter_recommendationsentry_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ozp_user
--

SELECT pg_catalog.setval('ozpcenter_recommendationsentry_id_seq', 22, true);


--
-- Data for Name: ozpcenter_review; Type: TABLE DATA; Schema: public; Owner: ozp_user
--

COPY ozpcenter_review (id, text, rate, edited_date, author_id, listing_id, review_parent_id, created_date) FROM stdin;
1	Favorite Instrument by far. BY. FAR.	3	2017-11-08 18:08:05.975118-05	1	1	\N	2017-11-08 18:08:05.975146-05
2	I don't like the sound of acoustic guitars. I like electric guitars more	1	2017-11-08 18:08:06.025292-05	5	1	\N	2017-11-08 18:08:06.025309-05
3	I love the sound of acoustic guitars	5	2017-11-08 18:08:06.068449-05	17	1	\N	2017-11-08 18:08:06.068477-05
4	This app is great - well designed and easy to use	5	2017-11-08 18:08:06.105928-05	21	2	\N	2017-11-08 18:08:06.105943-05
5	Air mail is ok - does what it says and no more	3	2017-11-08 18:08:06.141958-05	19	2	\N	2017-11-08 18:08:06.141972-05
6	Air mail crashes all the time - it doesn't even support IE 6!	1	2017-11-08 18:08:06.175181-05	17	2	\N	2017-11-08 18:08:06.175194-05
7	On par with sending ravens across Westeros, though less likely to be eaten along the way. 	4	2017-11-08 18:08:06.205335-05	3	2	\N	2017-11-08 18:08:06.205346-05
8	Very friendly. Would recommend to others	5	2017-11-08 18:08:06.231835-05	9	4	\N	2017-11-08 18:08:06.231845-05
9	I don't want to talk about it. 	1	2017-11-08 18:08:06.259525-05	17	4	\N	2017-11-08 18:08:06.259536-05
10	The Gray's... Moulder where are you?	4	2017-11-08 18:08:06.286389-05	13	4	\N	2017-11-08 18:08:06.286401-05
11	I will downvote anybody who is blue and you can't stop me. 	1	2017-11-08 18:08:06.319657-05	17	6	\N	2017-11-08 18:08:06.319676-05
12	I think that this is very cool software.  Must try it out.	5	2017-11-08 18:08:06.363037-05	15	8	\N	2017-11-08 18:08:06.363055-05
13	Favorite planet by far. BY. FAR.	5	2017-11-08 18:08:06.402301-05	12	9	\N	2017-11-08 18:08:06.402317-05
14	It was better in 2010.	5	2017-11-08 18:08:06.441403-05	17	9	\N	2017-11-08 18:08:06.441418-05
15	not everything can be 5 stars.	3	2017-11-08 18:08:06.478857-05	5	9	\N	2017-11-08 18:08:06.478871-05
16	Lots of great dragons but the humanoids sure like trying to kill them for loot. Not sure it's worth the effort to visit.	3	2017-11-08 18:08:06.513708-05	3	9	\N	2017-11-08 18:08:06.513721-05
17	Everything should be 5 stars	5	2017-11-08 18:08:06.545642-05	4	9	\N	2017-11-08 18:08:06.545653-05
18	BEST FOOTBALL TEAM EVER.	5	2017-11-08 18:08:06.576518-05	4	10	\N	2017-11-08 18:08:06.576528-05
19	I love to bbq with my 3 dragons. Extra yum with dragon fire!	5	2017-11-08 18:08:06.606382-05	3	11	\N	2017-11-08 18:08:06.606393-05
20	Looking like the next home.	5	2017-11-08 18:08:06.637448-05	12	12	\N	2017-11-08 18:08:06.637459-05
21	No roller coaster, a curfew and ice warriors.	3	2017-11-08 18:08:06.66796-05	17	12	\N	2017-11-08 18:08:06.667971-05
22	Found this in the Marketplace.  Much better than expected.	5	2017-11-08 18:08:06.698971-05	4	12	\N	2017-11-08 18:08:06.698982-05
23	Bad user interface but good content	2	2017-11-08 18:08:06.73022-05	9	13	\N	2017-11-08 18:08:06.730231-05
24	If you're complaining about the UI, its because you have neither hops nor handles.  I've contacted the mods, you will be removed.  FOREVER. 	5	2017-11-08 18:08:06.761352-05	17	13	\N	2017-11-08 18:08:06.761363-05
25	So easy a kid can do it.	4	2017-11-08 18:08:06.791954-05	13	14	\N	2017-11-08 18:08:06.791965-05
26	I like the blue.  I dislike having to have more than 20 characters.\n	5	2017-11-08 18:08:06.823781-05	8	16	\N	2017-11-08 18:08:06.823792-05
27	Why are they always blue?  It just doesn't make any sense. 	3	2017-11-08 18:08:06.8539-05	17	16	\N	2017-11-08 18:08:06.853911-05
28	Should consider this one.  It might be worth it.	4	2017-11-08 18:08:06.884137-05	1	17	\N	2017-11-08 18:08:06.884148-05
29	Okay app must try it today.	3	2017-11-08 18:08:06.914168-05	15	17	\N	2017-11-08 18:08:06.914179-05
30	Better than average and grew up with them	4	2017-11-08 18:08:06.944327-05	15	18	\N	2017-11-08 18:08:06.944338-05
31	I think they could go places!	5	2017-11-08 18:08:06.974561-05	17	18	\N	2017-11-08 18:08:06.974573-05
32	Too scared to fly United?  Try a blink.	5	2017-11-08 18:08:07.005293-05	8	19	\N	2017-11-08 18:08:07.005304-05
33	5/5 Not blue!  Thank the lords.	5	2017-11-08 18:08:07.034805-05	17	19	\N	2017-11-08 18:08:07.034816-05
34	I shimmer, not blink. SAD!	1	2017-11-08 18:08:07.064352-05	12	19	\N	2017-11-08 18:08:07.064363-05
35	This bread is stale!	2	2017-11-08 18:08:07.09457-05	13	23	\N	2017-11-08 18:08:07.094582-05
36	Yum!	5	2017-11-08 18:08:07.124646-05	6	23	\N	2017-11-08 18:08:07.124657-05
37	Essential for living life	4	2017-11-08 18:08:07.155369-05	9	25	\N	2017-11-08 18:08:07.15538-05
38	I don't get it.  Does its just sit there? 	2	2017-11-08 18:08:07.184911-05	17	25	\N	2017-11-08 18:08:07.184922-05
39	Management (or managing) is the administration of an organization, whether it be a business, a not-for-profit organization, or government body.	3	2017-11-08 18:08:07.214973-05	1	27	\N	2017-11-08 18:08:07.214984-05
40	Individuals who aim at becoming management researchers or professors may complete the Doctor of Management (DM), the Doctor of Business Administration (DBA), or the PhD in Business Administration or Management.	4	2017-11-08 18:08:07.245377-05	4	27	\N	2017-11-08 18:08:07.245388-05
41	I was told there would be cake, last time I did not get any cake, and i just want some cake. 	2	2017-11-08 18:08:07.276252-05	17	27	\N	2017-11-08 18:08:07.276263-05
42	This Chart is bad!	2	2017-11-08 18:08:07.307025-05	5	30	\N	2017-11-08 18:08:07.307036-05
43	Good Chart!	5	2017-11-08 18:08:07.337701-05	1	30	\N	2017-11-08 18:08:07.337712-05
44	Might be pretty good to look at.	4	2017-11-08 18:08:07.3688-05	15	31	\N	2017-11-08 18:08:07.368811-05
45	I really don't care for this one, but it might be good for others.	3	2017-11-08 18:08:07.397718-05	15	36	\N	2017-11-08 18:08:07.397729-05
46	This is an okay image and app.	3	2017-11-08 18:08:07.427494-05	15	37	\N	2017-11-08 18:08:07.427505-05
47	Blame the writers if you'd like, but easily the most worst x-men.   Besides Angel.  Oh?  you can fly?  Cause of your wings?  Half of everybody can fly and you can sit behind them at concerts and still see the show.	1	2017-11-08 18:08:07.457452-05	17	41	\N	2017-11-08 18:08:07.457463-05
48	BEST. X-MEN. EVER!!!	5	2017-11-08 18:08:07.48734-05	12	41	\N	2017-11-08 18:08:07.48735-05
49	Rating 5 stars because I don't want to make him mad.	5	2017-11-08 18:08:07.517336-05	4	42	\N	2017-11-08 18:08:07.517346-05
50	He wrecked the freeway.  I was late to work and rushed my experiment.  After drinking the radioactive material i just got sick :(	2	2017-11-08 18:08:07.546973-05	17	42	\N	2017-11-08 18:08:07.546984-05
51	Got attacked by one and was scary	1	2017-11-08 18:08:07.577199-05	9	45	\N	2017-11-08 18:08:07.57721-05
52	I like that they are oil now.   That is a useful substance. 	5	2017-11-08 18:08:07.606863-05	8	45	\N	2017-11-08 18:08:07.606874-05
53	Close to dragons but -1 star for not having wings, breathing fire or flying	4	2017-11-08 18:08:07.636909-05	3	45	\N	2017-11-08 18:08:07.636919-05
54	Dragons are the best! I want to mother them all <3	5	2017-11-08 18:08:07.666451-05	3	47	\N	2017-11-08 18:08:07.666462-05
55	Who broke the first rule?!?!	3	2017-11-08 18:08:07.696644-05	4	55	\N	2017-11-08 18:08:07.696655-05
56	Not the best tool now but still works	3	2017-11-08 18:08:07.727592-05	9	56	\N	2017-11-08 18:08:07.727603-05
57	You would not copy a car would you?  No!  Because that doesn't make any sense.  You would copy X-COM though. 	5	2017-11-08 18:08:07.75789-05	17	56	\N	2017-11-08 18:08:07.757901-05
58	Won't even hold an MP3.  Write time is very slow.  Somewhat noisy too.	3	2017-11-08 18:08:07.788174-05	4	56	\N	2017-11-08 18:08:07.788185-05
59	Real men don't use floppies.	2	2017-11-08 18:08:07.817983-05	3	56	\N	2017-11-08 18:08:07.817994-05
60	I keep hitting M and the map doesn't show up. 	4	2017-11-08 18:08:07.847367-05	17	59	\N	2017-11-08 18:08:07.847377-05
61	Okay app must try it today.	3	2017-11-08 18:08:07.877284-05	15	59	\N	2017-11-08 18:08:07.877295-05
62	One of the better ones that I have seen.	5	2017-11-08 18:08:07.907116-05	1	61	\N	2017-11-08 18:08:07.907127-05
63	Great app must try it today.	5	2017-11-08 18:08:07.937152-05	15	61	\N	2017-11-08 18:08:07.937163-05
64	Growing up I had a friend who talk during movies.  The worst.  Anyways after a trip to the beach I didn't have to worry about that anymore. 	5	2017-11-08 18:08:07.967635-05	17	64	\N	2017-11-08 18:08:07.967646-05
65	Okay this might be a good one.	3	2017-11-08 18:08:07.998152-05	15	64	\N	2017-11-08 18:08:07.998163-05
66	All new four-valve engine and suspension. Doubling down on valves, staying pat on styling.	3	2017-11-08 18:08:08.028881-05	5	65	\N	2017-11-08 18:08:08.028892-05
67	Very nice place! Expensive though	4	2017-11-08 18:08:08.061142-05	9	67	\N	2017-11-08 18:08:08.061153-05
68	I feel like I would like it!  10 stars!	5	2017-11-08 18:08:08.090885-05	17	67	\N	2017-11-08 18:08:08.090896-05
69	I know that I should not worry, but it is the volcanoes that I am worried about.  Otherwise a good place to visit.	3	2017-11-08 18:08:08.120602-05	15	67	\N	2017-11-08 18:08:08.120613-05
70	False rulers of the iron throne. They will soon fall in battle to my army of dragons. If I could give a 0 rating I would!	1	2017-11-08 18:08:08.151455-05	3	68	\N	2017-11-08 18:08:08.151467-05
71	Guy's not even a full stark.	1	2017-11-08 18:08:08.18116-05	12	69	\N	2017-11-08 18:08:08.181171-05
72	Won't bend the knee, but could prove to be a valuable ally. Dragons still beat direwolves though.	4	2017-11-08 18:08:08.21221-05	3	69	\N	2017-11-08 18:08:08.212221-05
73	The best, most powerful house ever. True rulers of Westeros.	5	2017-11-08 18:08:08.242803-05	3	70	\N	2017-11-08 18:08:08.242814-05
74	Zeus controls the world by creating brainwave modifiers that are sent through the air as cotton candy.  Its true!  You can read about it on wikipedia. 	5	2017-11-08 18:08:08.273889-05	17	73	\N	2017-11-08 18:08:08.2739-05
75	This is not Jarvis upvoting this.  It is not.  you cannot prove anything.  Also the fact that this site does not have a capatcha is AWESOME!  	5	2017-11-08 18:08:08.304159-05	17	77	\N	2017-11-08 18:08:08.30417-05
76	Ironman is okay not 100% sure it is good.	3	2017-11-08 18:08:08.334389-05	15	77	\N	2017-11-08 18:08:08.3344-05
77	I like my men rich and arrogant. 	5	2017-11-08 18:08:08.364445-05	3	77	\N	2017-11-08 18:08:08.364456-05
78	this okay not so sure.	3	2017-11-08 18:08:08.394596-05	15	78	\N	2017-11-08 18:08:08.394607-05
79	I like this planet. It's alright.	5	2017-11-08 18:08:08.42692-05	12	79	\N	2017-11-08 18:08:08.426931-05
80	Contains florida and the dallas cowboys.  This makes it irredeemable in the eyes of the lord.	2	2017-11-08 18:08:08.458229-05	17	79	\N	2017-11-08 18:08:08.45824-05
81	One of the main characters doesn't even speak. SAD!	1	2017-11-08 18:08:08.488269-05	12	80	\N	2017-11-08 18:08:08.48828-05
82	These timelines are way too confusing. 	5	2017-11-08 18:08:08.518068-05	17	81	\N	2017-11-08 18:08:08.518079-05
83	Yes a definite winner.	5	2017-11-08 18:08:08.548331-05	15	81	\N	2017-11-08 18:08:08.548342-05
84	After Jean and the X-Men defeated scientist Stephen Lang and his robotic Sentinels on his space station, the heroes escaped back to Earth in a shuttle through a lethal solar radiation storm.	3	2017-11-08 18:08:08.577969-05	5	81	\N	2017-11-08 18:08:08.577981-05
85	I really like it	4	2017-11-08 18:08:08.607199-05	21	82	\N	2017-11-08 18:08:08.60721-05
86	It's pretty big. Like, bigly big.	5	2017-11-08 18:08:08.6503-05	12	83	\N	2017-11-08 18:08:08.650322-05
87	To hard to to talk to because you just want to look at its eyestorm birthmark thing.	3	2017-11-08 18:08:08.698434-05	17	83	\N	2017-11-08 18:08:08.698452-05
88	Samoo was fun to watch at Sea World.	4	2017-11-08 18:08:08.742335-05	13	87	\N	2017-11-08 18:08:08.742352-05
89	They are nice but not a big fan.	3	2017-11-08 18:08:08.783284-05	15	87	\N	2017-11-08 18:08:08.7833-05
90	I don't think that cold blooded animals are very efficient 	1	2017-11-08 18:08:08.8218-05	1	88	\N	2017-11-08 18:08:08.821814-05
91	No children were allowed	1	2017-11-08 18:08:08.860905-05	9	89	\N	2017-11-08 18:08:08.860919-05
92	No children were allowed.	5	2017-11-08 18:08:08.896942-05	8	89	\N	2017-11-08 18:08:08.896955-05
93	This place was LIT! Definitely will return.	5	2017-11-08 18:08:08.931166-05	3	89	\N	2017-11-08 18:08:08.931178-05
94	This is an absolute must for every developers took kit.	5	2017-11-08 18:08:08.96336-05	13	90	\N	2017-11-08 18:08:08.963371-05
95	not everything can be 5 stars.	2	2017-11-08 18:08:08.995339-05	5	90	\N	2017-11-08 18:08:08.995351-05
96	Lions (and Lanisters) are the worst! The only reason you should want to find them is to feed them to your dragons.	1	2017-11-08 18:08:09.026551-05	3	94	\N	2017-11-08 18:08:09.026563-05
97	I really like it	4	2017-11-08 18:08:09.057752-05	21	96	\N	2017-11-08 18:08:09.057763-05
98	Useless, everybody knows rooms are round.  So how does this even work?  	1	2017-11-08 18:08:09.08895-05	17	99	\N	2017-11-08 18:08:09.088961-05
99	Great app must try it today.	5	2017-11-08 18:08:09.119277-05	15	99	\N	2017-11-08 18:08:09.119288-05
100	Not the nicest to work with.  I keep losing my stapler when around.	1	2017-11-08 18:08:09.148903-05	4	100	\N	2017-11-08 18:08:09.148914-05
101	Won't kill you for no reason.  Will kill you though. 	3	2017-11-08 18:08:09.179572-05	8	100	\N	2017-11-08 18:08:09.179583-05
102	Interesting this might be something to look at.	4	2017-11-08 18:08:09.209324-05	15	101	\N	2017-11-08 18:08:09.209335-05
103	I don't understand how this works.  How can the map represent something that exists?  Like, if i'm standing on the ground, then how that ground be on the map?  Pure nonsense.  5/5 stars	5	2017-11-08 18:08:09.239712-05	17	102	\N	2017-11-08 18:08:09.239724-05
104	Great app must try it today.	5	2017-11-08 18:08:09.269648-05	15	102	\N	2017-11-08 18:08:09.269659-05
105	A very very very very fun game	5	2017-11-08 18:08:09.299112-05	1	104	\N	2017-11-08 18:08:09.299123-05
106	I am not a very big fan of minesweeper.  But it would be good to pass the time.	2	2017-11-08 18:08:09.329103-05	15	104	\N	2017-11-08 18:08:09.329114-05
107	Cute small sized dogs	5	2017-11-08 18:08:09.35928-05	1	105	\N	2017-11-08 18:08:09.359291-05
108	The best looking dog	5	2017-11-08 18:08:09.389456-05	9	105	\N	2017-11-08 18:08:09.389467-05
109	Obvious attempt to influence people based on cuteness.	1	2017-11-08 18:08:09.419517-05	17	105	\N	2017-11-08 18:08:09.419528-05
110	I, a completely different person, also dislike this app and everything it stands for.	1	2017-11-08 18:08:09.44947-05	2	105	\N	2017-11-08 18:08:09.449481-05
111	Hello, comrade, this is also a completely different person.  I agree, worst dog ever. 	1	2017-11-08 18:08:09.479322-05	3	105	\N	2017-11-08 18:08:09.479333-05
112	Where was this dog on 9/11?  Hmm?  Do you kneow?  I don't.  Just asking a question.	1	2017-11-08 18:08:09.50903-05	4	105	\N	2017-11-08 18:08:09.509041-05
113	How do I give less than 1 star?  zero stars for this smug little brat of a dog. 	1	2017-11-08 18:08:09.540322-05	5	105	\N	2017-11-08 18:08:09.540334-05
114	Hitler's favorite breed.  Look it up. 	1	2017-11-08 18:08:09.570516-05	6	105	\N	2017-11-08 18:08:09.570527-05
115	I can't even with this dog. 	1	2017-11-08 18:08:09.600832-05	7	105	\N	2017-11-08 18:08:09.600844-05
116	Nobody likes this dog.  I asked everybody who is me.  YET!  Still it persists at a 2.0 rating?  fake reviews sheeple!  wake up. 	1	2017-11-08 18:08:09.631025-05	8	105	\N	2017-11-08 18:08:09.631037-05
117	I was looking for a food mixer and could not find it	1	2017-11-08 18:08:09.661367-05	1	107	\N	2017-11-08 18:08:09.661378-05
118	Is this a primate dating app?	1	2017-11-08 18:08:09.691456-05	13	108	\N	2017-11-08 18:08:09.691467-05
119	Not big enough for my dragons to eat	1	2017-11-08 18:08:09.720516-05	3	108	\N	2017-11-08 18:08:09.720527-05
120	An essential component of dragon fire. Helps burn citadels down. A+	5	2017-11-08 18:08:09.750735-05	3	109	\N	2017-11-08 18:08:09.750746-05
121	I am not a big fan of moonshine.	2	2017-11-08 18:08:09.783633-05	15	109	\N	2017-11-08 18:08:09.783644-05
122	A motorcycle helmet can be a life saver	5	2017-11-08 18:08:09.816502-05	1	111	\N	2017-11-08 18:08:09.816514-05
123	I'm confused about that sport part.  Doesn't the engine do all the work?  Shouldn't it be called, "Trynottocrashthemotor"	4	2017-11-08 18:08:09.849111-05	17	112	\N	2017-11-08 18:08:09.849123-05
124	Okay so it does not make sense from the images but the app is still great.	3	2017-11-08 18:08:09.880842-05	15	112	\N	2017-11-08 18:08:09.880854-05
125	Very good to use for navigation.	5	2017-11-08 18:08:09.912098-05	1	116	\N	2017-11-08 18:08:09.912111-05
126	Great app must try it today.	4	2017-11-08 18:08:09.943293-05	15	116	\N	2017-11-08 18:08:09.943305-05
127	not everything can be 5 stars.	2	2017-11-08 18:08:09.973494-05	5	116	\N	2017-11-08 18:08:09.973505-05
128	Aided us safely in our journey to Westeros.	5	2017-11-08 18:08:10.002851-05	3	116	\N	2017-11-08 18:08:10.002862-05
129	Everything can be 5 stars if you put your mind to it.	5	2017-11-08 18:08:10.032238-05	4	116	\N	2017-11-08 18:08:10.03225-05
130	Pretty good to use for navigation.	4	2017-11-08 18:08:10.060872-05	1	117	\N	2017-11-08 18:08:10.060883-05
131	Okay app must try it today.	3	2017-11-08 18:08:10.089167-05	15	117	\N	2017-11-08 18:08:10.089179-05
132	It's so blueeeee~~~!!!!!	5	2017-11-08 18:08:10.119266-05	12	118	\N	2017-11-08 18:08:10.119278-05
133	NO MORE #$(*)&@#% BLUE THINGS. 	1	2017-11-08 18:08:10.157576-05	17	118	\N	2017-11-08 18:08:10.157592-05
134	This switch allows many computers to be connected	4	2017-11-08 18:08:10.197214-05	1	119	\N	2017-11-08 18:08:10.197229-05
135	It prevented and controlled my high blood pressure during surgery	5	2017-11-08 18:08:10.235404-05	1	125	\N	2017-11-08 18:08:10.23542-05
136	LOL what is this doing here? Not even a planet.	1	2017-11-08 18:08:10.272666-05	12	128	\N	2017-11-08 18:08:10.27268-05
137	Fake news, Pluto was a planet when I was a kid, so its a planet now.  You can't just go around unplaneting things. 	5	2017-11-08 18:08:10.310342-05	17	128	\N	2017-11-08 18:08:10.310356-05
138	Strong female rulers! As long as she doesn't invade Westeros she's cool	3	2017-11-08 18:08:10.347595-05	3	132	\N	2017-11-08 18:08:10.347609-05
139	This is what I have a hand to assist me with. This does not meet my use cases at all.	2	2017-11-08 18:08:10.382509-05	3	133	\N	2017-11-08 18:08:10.382521-05
140	Not very interesting.  Hard to follow.  Does not seem to work.	1	2017-11-08 18:08:10.418098-05	4	133	\N	2017-11-08 18:08:10.418111-05
141	The rail road is fine, but when I tried to drive my car on it, it was very slow.  I think the rail road should have better compatibility. 	3	2017-11-08 18:08:10.45444-05	4	134	\N	2017-11-08 18:08:10.454463-05
142	Railroad Ima gonna let you finish but everybody knows shipping lanes had the best transport ever. 	5	2017-11-08 18:08:10.507313-05	17	134	\N	2017-11-08 18:08:10.507333-05
143	Great app must try it today.	4	2017-11-08 18:08:10.557129-05	15	134	\N	2017-11-08 18:08:10.557147-05
144	gave her a hug and was in a coma for 9 years.  Can't recommend. 	2	2017-11-08 18:08:10.601307-05	8	135	\N	2017-11-08 18:08:10.601323-05
145	Good for jewelry in my house colors.	5	2017-11-08 18:08:10.642581-05	3	136	\N	2017-11-08 18:08:10.642597-05
146	The currently available sailing publications and web sites are often filled with stories that are something less than insightful. 	3	2017-11-08 18:08:10.683617-05	5	142	\N	2017-11-08 18:08:10.68364-05
147	Okay to use for navigation, not the best.	3	2017-11-08 18:08:10.728221-05	1	146	\N	2017-11-08 18:08:10.728237-05
148	Great app must try it today.	5	2017-11-08 18:08:10.76636-05	15	146	\N	2017-11-08 18:08:10.766375-05
149	What's up with that dumb ring?	3	2017-11-08 18:08:10.801917-05	12	147	\N	2017-11-08 18:08:10.80193-05
150	I did like it.  I did like it so much.  So i put rings on it.  -God, probably. 	5	2017-11-08 18:08:10.836648-05	17	147	\N	2017-11-08 18:08:10.836665-05
151	The cold does not feel good	1	2017-11-08 18:08:10.880585-05	1	154	\N	2017-11-08 18:08:10.880602-05
152	I've heard that it knows nothing. 	3	2017-11-08 18:08:10.920928-05	17	154	\N	2017-11-08 18:08:10.920943-05
153	Snows refuse to bend the knee in my experience.	2	2017-11-08 18:08:10.956377-05	3	154	\N	2017-11-08 18:08:10.95639-05
154	This stop sign saved me from a accident!!! 	5	2017-11-08 18:08:10.989634-05	1	158	\N	2017-11-08 18:08:10.989648-05
155	I think that this is very necessary item to have on the roads.	5	2017-11-08 18:08:11.021784-05	15	158	\N	2017-11-08 18:08:11.021797-05
156	It takes bold brewers to brew bold beers. Brewers prepared to go to lengths that others wouldn't to perfect their craft. 	5	2017-11-08 18:08:11.052342-05	5	159	\N	2017-11-08 18:08:11.052354-05
157	Stroke play, also known as medal play, is a scoring system in the sport of golf. 	3	2017-11-08 18:08:11.080899-05	5	160	\N	2017-11-08 18:08:11.08091-05
158	Kinda need this guy.	5	2017-11-08 18:08:11.109894-05	12	162	\N	2017-11-08 18:08:11.109904-05
159	I will allow it for now, but I dislike his posturing threat of blowing up in a billion years. 	5	2017-11-08 18:08:11.13813-05	17	162	\N	2017-11-08 18:08:11.138141-05
160	I like this!  Are they touring soon? 	5	2017-11-08 18:08:11.168655-05	17	163	\N	2017-11-08 18:08:11.168681-05
161	Not sure about this one.	3	2017-11-08 18:08:11.215149-05	15	163	\N	2017-11-08 18:08:11.215169-05
162	Pretty good group would say that they are better than average.	4	2017-11-08 18:08:11.257363-05	15	166	\N	2017-11-08 18:08:11.25738-05
163	My favorite type of music genre 	5	2017-11-08 18:08:11.295911-05	1	166	\N	2017-11-08 18:08:11.295926-05
164	I've not heard of this band.  I wish the radio would play them. 	3	2017-11-08 18:08:11.33035-05	8	166	\N	2017-11-08 18:08:11.330363-05
165	Okay this one looks good as well.	3	2017-11-08 18:08:11.359592-05	15	168	\N	2017-11-08 18:08:11.359605-05
166	I would listen to this when I want to. 	4	2017-11-08 18:08:11.386031-05	17	168	\N	2017-11-08 18:08:11.386042-05
167	Tornado are too powerful	1	2017-11-08 18:08:11.428227-05	1	169	\N	2017-11-08 18:08:11.428246-05
168	Not a fan.  Scary and destructive.	1	2017-11-08 18:08:11.472593-05	4	169	\N	2017-11-08 18:08:11.47261-05
169	Kicks up a lot of dust and makes the dothraki less effective	1	2017-11-08 18:08:11.509772-05	3	169	\N	2017-11-08 18:08:11.509787-05
170	Don't be a child.  Its a fine enough place. 	5	2017-11-08 18:08:11.540902-05	17	173	\N	2017-11-08 18:08:11.540915-05
171	Looks like an egg, was there a chicken first?  	2	2017-11-08 18:08:11.571621-05	13	173	\N	2017-11-08 18:08:11.571633-05
172	Not really feeling the vibes.	4	2017-11-08 18:08:11.60134-05	12	174	\N	2017-11-08 18:08:11.601351-05
173	It is too arrogant. 	1	2017-11-08 18:08:11.629563-05	17	174	\N	2017-11-08 18:08:11.629574-05
174	Best time to use when it's hot outside.	4	2017-11-08 18:08:11.65718-05	9	178	\N	2017-11-08 18:08:11.657191-05
175	I ate a seed and a watermelon grew in my belly.  This provided an unlimited supply of food.  Try it and see! 	5	2017-11-08 18:08:11.684498-05	17	178	\N	2017-11-08 18:08:11.684509-05
176	Hilariously ripe and delicioius.	5	2017-11-08 18:08:11.711185-05	3	178	\N	2017-11-08 18:08:11.711195-05
177	The dothraki find these creatures useful though my dragons would prefer them as food. -1 Star for not flying	4	2017-11-08 18:08:11.737528-05	3	180	\N	2017-11-08 18:08:11.737539-05
178	Need this for my neighbourhood.	5	2017-11-08 18:08:11.764469-05	15	186	\N	2017-11-08 18:08:11.76448-05
179	So easy to use that a wolf came to me! It's knee wasn't very bendy though so -1 star.	4	2017-11-08 18:08:11.791755-05	3	186	\N	2017-11-08 18:08:11.791766-05
180	I don't understand how the guy who controls metal doesn't just throw this guy into orbit. 	3	2017-11-08 18:08:11.818914-05	17	187	\N	2017-11-08 18:08:11.818925-05
\.


--
-- Name: ozpcenter_review_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ozp_user
--

SELECT pg_catalog.setval('ozpcenter_review_id_seq', 180, true);


--
-- Data for Name: ozpcenter_screenshot; Type: TABLE DATA; Schema: public; Owner: ozp_user
--

COPY ozpcenter_screenshot (id, large_image_id, listing_id, small_image_id, description, "order") FROM stdin;
1	764	1	763	Black and White picture of Two Guitars	0
2	766	2	765	airmail screenshot set 1	0
3	768	2	767	airmail screenshot set 2	1
4	770	3	769	\N	0
5	772	4	771	Not actual photo of alien	0
6	774	5	773	\N	0
7	776	6	775	\N	0
8	778	7	777	\N	0
9	780	8	779	Astrology Software	0
10	782	9	781	\N	0
11	784	10	783	\N	0
12	786	10	785	\N	1
13	788	11	787	\N	0
14	790	12	789	\N	0
15	792	13	791	Invented basketball	0
16	794	14	793	Now that's a fish.	0
17	796	15	795	Can he land a bass?	0
18	798	16	797	\N	0
19	800	17	799	\N	0
20	802	18	801	\N	0
21	804	18	803	X-P	1
22	806	18	805	Kurdt	2
23	808	19	807	\N	0
24	810	20	809	\N	0
25	812	21	811	The real developers tool kit.	0
26	814	22	813	\N	0
27	816	23	815	\N	0
28	818	24	817	There's the meat; get in my belly!!!	0
29	820	25	819	\N	0
30	822	26	821	\N	0
31	824	27	823	\N	0
32	826	28	825	\N	0
33	828	29	827	\N	0
34	830	30	829	\N	0
35	832	31	831	\N	0
36	834	32	833	\N	0
37	836	33	835	\N	0
38	838	33	837	\N	1
39	840	34	839	\N	0
40	842	34	841	\N	1
41	844	34	843	\N	2
42	846	35	845	Chicken and Waffles	0
43	848	35	847	Chicken and Waffles	1
44	850	36	849	\N	0
45	852	37	851	\N	0
46	854	38	853	\N	0
47	856	39	855	\N	0
48	858	40	857	\N	0
49	860	41	859	\N	0
50	862	42	861	\N	0
51	864	43	863	\N	0
52	866	43	865	\N	1
53	868	44	867	Loose diamonds on a white background	0
54	870	44	869	Diamond necklace	1
55	872	44	871	A pendant with diamond and other gem stones	2
56	874	44	873	a diamond on a black background	3
57	876	45	875	Scariest one in history	0
58	878	45	877	\N	1
59	880	46	879	\N	0
60	882	47	881	An example of a dragon	0
61	884	47	883	Dragon footprints	1
62	886	48	885	\N	0
63	888	49	887	\N	0
64	890	50	889	Keyboard	0
65	892	51	891	\N	0
66	894	52	893	\N	0
67	896	53	895	\N	0
68	898	54	897	\N	0
69	900	55	899	\N	0
70	902	56	901	Floppy Disk	0
71	904	56	903	This is the floppy disk drive	1
72	906	57	905	Math Formula	0
73	908	58	907	\N	0
74	910	59	909	\N	0
75	912	60	911	\N	0
76	914	61	913	\N	0
77	916	62	915	\N	0
78	918	63	917	\N	0
79	920	64	919	Map and jaw pictures	0
80	922	65	921	\N	0
81	924	66	923	\N	0
82	926	67	925	Island	0
83	928	67	927	I like turtles	1
84	930	68	929	Cersei	0
85	932	68	931	Tyrion Lannister	1
86	934	68	933	Jamie Lannister	2
87	936	69	935	John Snow 1	0
88	938	69	937	Bran Stark	1
89	940	69	939	Sansa 3	2
90	942	69	941	Arya 4	3
91	944	70	943	Targaryen house sigil	0
92	946	70	945	Daenerys Targaryen with one of her adolescent dragons	1
93	948	71	947	\N	0
94	950	72	949	\N	0
95	952	73	951	\N	0
96	954	74	953	\N	0
97	956	74	955	\N	1
98	958	74	957	\N	2
99	960	74	959	\N	3
100	962	75	961	\N	0
101	964	76	963	\N	0
102	966	76	965	\N	1
103	968	76	967	\N	2
104	970	77	969	\N	0
105	972	78	971	\N	0
106	974	78	973	\N	1
107	976	79	975	\N	0
108	978	80	977	\N	0
109	980	81	979	\N	0
110	982	82	981	\N	0
111	984	83	983	\N	0
112	986	84	985	\N	0
113	988	85	987	\N	0
114	990	86	989	\N	0
115	992	87	991	\N	0
116	994	88	993	Komodo Dragon on a rock	0
117	996	89	995	A ranch	0
118	998	90	997	\N	0
119	1000	91	999	Adults superficially resemble eels in that they have scaleless, elongated bodies, and can range from 13 to 100 cm (5 to 40 inches) in length	0
120	1002	92	1001	Smooth average learning curve graph.	0
121	1004	92	1003	Exponential growth learning curve graph	1
122	1006	92	1005	Exponential rise and fall to a limit learning curve graph	2
123	1008	92	1007	S-Curve or Sigmoid function learning curve graph	3
124	1010	93	1009	White Lightning	0
125	1012	94	1011	\N	0
126	1014	95	1013	\N	0
127	1016	96	1015	\N	0
128	1018	97	1017	\N	0
129	1020	98	1019	\N	0
130	1022	99	1021	\N	0
131	1024	100	1023	\N	0
132	1026	101	1025	\N	0
133	1028	102	1027	\N	0
134	1030	103	1029	\N	0
135	1032	104	1031	\N	0
136	1034	105	1033	When dachshunds get mad	0
137	1036	106	1035	\N	0
138	1038	106	1037	\N	1
139	1040	107	1039	\N	0
140	1042	107	1041	\N	1
141	1044	108	1043	Baboon	0
142	1046	109	1045	\N	0
143	1048	110	1047	\N	0
144	1050	111	1049	MotorcycleHelmet 1	0
145	1052	112	1051	\N	0
146	1054	113	1053	\N	0
147	1056	114	1055	\N	0
148	1058	115	1057	\N	0
149	1060	115	1059	\N	1
150	1062	116	1061	\N	0
151	1064	117	1063	\N	0
152	1066	118	1065	\N	0
153	1068	119	1067	\N	0
154	1070	120	1069	Newspaper	0
155	1072	121	1071	Green Parrot	0
156	1074	121	1073	Red Parrot	1
157	1076	122	1075	birds...	0
158	1078	123	1077	\N	0
159	1080	124	1079	\N	0
160	1082	125	1081	\N	0
161	1084	126	1083	\N	0
162	1086	127	1085	\N	0
163	1088	128	1087	\N	0
164	1090	129	1089	The boxes for the original Gameboy Advance versionsof Pokemon Ruby and Sapphire	0
165	1092	129	1091	The cases for the new 3DS versions Pokemon Omega Ruby and Alpha Sapphire	1
166	1094	129	1093	Animated gif of the gameplay near one of the locations you can fish as well as find and plant berries	2
167	1096	130	1095	\N	0
168	1098	131	1097	\N	0
169	1100	132	1099	\N	0
170	1102	133	1101	\N	0
171	1104	133	1103	\N	1
172	1106	134	1105	\N	0
173	1108	135	1107	\N	0
174	1110	136	1109	example of a ruby	0
175	1112	137	1111	Ruby miner fancy logo	0
176	1114	138	1113	Screenshot of rails development	0
177	1116	139	1115	\N	0
178	1118	140	1117	\N	0
179	1120	141	1119	\N	0
180	1122	141	1121	\N	1
181	1124	142	1123	\N	0
182	1126	143	1125	\N	0
183	1128	143	1127	\N	1
184	1130	144	1129	\N	0
185	1132	145	1131	A sapphire and diamond ring	0
186	1134	146	1133	\N	0
187	1136	147	1135	\N	0
188	1138	148	1137	2016\n\n    CVO Pro Street Breakout (FXSE)\n    CVO Street Glide (FLHXSE)\n    CVO Road Glide Ultra (FLTRUSE)\n    CVO Ultra Limited (FLHTKSE)	0
189	1140	149	1139	Music Sheet	0
190	1142	150	1141	\N	0
191	1144	151	1143	\N	0
192	1146	152	1145	\N	0
193	1148	153	1147	Smart Phone	0
194	1150	154	1149	After a night of snow	0
195	1152	154	1151	Animal in snow	1
196	1154	155	1153	\N	0
197	1156	156	1155	\N	0
198	1158	157	1157	\N	0
199	1160	157	1159	\N	1
200	1162	158	1161	Stop	0
201	1164	159	1163	\N	0
202	1166	160	1165	In single player, these include a story mode, stroke play mode, and match mode, while in multiplayer, Balloon Pop mode replaces the story mode.	0
203	1168	161	1167	\N	0
204	1170	162	1169	\N	0
205	1172	163	1171	\N	0
206	1174	163	1173	Chris	1
207	1176	164	1175	\N	0
208	1178	165	1177	Giant Grouper and Red lionfish	0
209	1180	166	1179	\N	0
210	1182	166	1181	\N	1
211	1184	167	1183	\N	0
212	1186	168	1185	STP	0
213	1188	168	1187	\N	1
214	1190	169	1189	Tornado Destruction	0
215	1192	170	1191	\N	0
216	1194	170	1193	\N	1
217	1196	171	1195	\N	0
218	1198	172	1197	\N	0
219	1200	173	1199	\N	0
220	1202	174	1201	\N	0
221	1204	175	1203	Modern Violin	0
222	1206	176	1205	\N	0
223	1208	177	1207	Voodoo 1	0
224	1210	178	1209	Slices of watermelon	0
225	1212	179	1211	\N	0
226	1214	180	1213	White Horse	0
227	1216	180	1215	\N	1
228	1218	181	1217	\N	0
229	1220	182	1219	\N	0
230	1222	183	1221	\N	0
231	1224	184	1223	\N	0
232	1226	185	1225	WitchDoctor 1	0
233	1228	185	1227	WitchDoctor 2	1
234	1230	186	1229	\N	0
235	1232	186	1231	\N	1
236	1234	187	1233	\N	0
237	1236	188	1235	Writing down on a piece of paper	0
\.


--
-- Name: ozpcenter_screenshot_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ozp_user
--

SELECT pg_catalog.setval('ozpcenter_screenshot_id_seq', 237, true);


--
-- Data for Name: ozpcenter_subscription; Type: TABLE DATA; Schema: public; Owner: ozp_user
--

COPY ozpcenter_subscription (id, entity_type, entity_id, target_profile_id) FROM stdin;
\.


--
-- Name: ozpcenter_subscription_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ozp_user
--

SELECT pg_catalog.setval('ozpcenter_subscription_id_seq', 1, false);


--
-- Data for Name: ozpcenter_tag; Type: TABLE DATA; Schema: public; Owner: ozp_user
--

COPY ozpcenter_tag (id, name) FROM stdin;
1	demo
2	example
3	acoustic
4	classical
5	concert
6	guitar
7	instrument
8	spanish
9	string
10	strings
11	wooded
12	demo_tag
13	tag_0
14	hardware
15	Aliens
16	Space
17	history
18	maps
19	navigation
20	bad guys
21	ethics
22	organizational
23	social
24	hocus pocus
25	horoscope
26	Planets
27	baltimore
28	football
29	maryland
30	ravens
31	bbq
32	food
33	meat
34	sause
35	Basketball
36	NBA
37	Sports
38	bass
39	fish
40	mike
41	learning
42	work
43	xlure
44	avengers
45	x-men
46	Grunge
47	rail
48	transport
49	booze
50	buzz
51	drink
52	good
53	hangover
54	character
55	USDA
56	brisket
57	smoked
58	steak
59	Architecture
60	Buildings
61	business
62	insurance
63	risk
64	managment
65	process
66	Kevin Smith
67	cake
68	yum
69	chicken
70	waffles
71	Comedy
72	Movie
73	m$
74	microsoft
75	paperclip
76	arrow
77	bow
78	hunting
79	sport
80	merc
81	automation
82	desktop
83	efficiency
84	virtualization
85	carbon
86	chocolate
87	diamond
88	gem
89	gemstone
90	jewelry
91	white
92	Animals
93	Dead
94	Extinct
95	Reptiles
96	book
97	fantasy
98	imaginary
99	legend
100	mythology
101	car
102	driving
103	toll
104	music
105	sound
106	wood
107	wooden
108	keyboard
109	piano
110	recording
111	synthesizer
112	beer
113	pencil
114	bikes
115	games
116	nes
117	auto
118	automobile
119	about
120	don't
121	it
122	talk
123	Memory
124	Old
125	Storage
126	chalk
127	conceptual
128	handwritten
129	math
130	physics
131	science
132	text
133	writing
134	software
135	record
136	vinyl
137	clock
138	time
139	shark
140	CVO
141	davidson
142	harley
143	motorcycle
144	Expensive
145	Travel
146	Vacation
147	House Lannister
148	casterly rock
149	cersei
150	game of thrones
151	got
152	jaime
153	joffrey
154	tyrion
155	Starks
156	arya
157	bran
158	catelyn
159	direwolf
160	direwolves
161	jon
162	king in the north
163	ned
164	red wedding
165	rickon
166	sansa
167	winter is coming
168	daenerys
169	dany
170	dragon
171	fire and blood
172	mother of dragons
173	targaryen
174	codex
175	encyclopedia
176	free
177	brainstorm
178	collaborate
179	intelligent
180	funny
181	meme
182	pictures
183	Avengers
184	protein
185	images
186	tool
187	Mammal
188	Science
189	Lizard
190	Monitor
191	Reptile
192	Cows
193	Lit
194	Ranch
195	experience
196	self improvement
197	discharge
198	electrostatic
199	lightning
200	sky
201	storm
202	thunder
203	thunderstorm
204	weather
205	zeus
206	mammal
207	positioning
208	game
209	Dogs
210	comics
211	monkey
212	alchohol
213	fire water
214	homemade
215	white lightning
216	language
217	morse code
218	sos
219	bike
220	vehicle
221	movie
222	tv
223	Video games
224	video games
225	computer
226	connection
227	electronic
228	equipment
229	internet
230	person
231	rack
232	wire
233	facts
234	information
235	journal
236	journalism
237	journalist
238	news
239	newspaper
240	office
241	paper
242	press
243	animal
244	avian
245	bird
246	feathers
247	parrot
248	zygodactyl
249	pacific
250	parrotlet
251	small
252	smallest
253	brand
254	cellphone
255	contemporary
256	desk
257	display
258	electronics
259	headphone
260	indoors
261	mobile phone
262	monitor
263	mouse
264	organized
265	pc
266	screen
267	sony
268	table
269	technology
270	watch
271	wireless
272	Phentolamine
273	video game
274	antique
275	black-and-white
276	grand
277	musical
278	NOT A PLANET
279	game freak
280	gotta catch 'em all
281	nintendo
282	pocket monsters
283	pokemon
284	mail
285	agile
286	pm
287	pmo
288	scrum
289	transportation
290	red
291	ruby
292	stone
293	programming
294	rails
295	ror
296	developer
297	development
298	framework
299	text editor
300	Video Games
301	boat
302	boats
303	racing
304	sail
305	sea
306	yacht
307	yummy
308	water
309	blue
310	satellite
311	Harley
312	Screamin Eagle
313	close-up
314	note
315	notes
316	electric
317	plane
318	cellular
319	communication
320	contacts
321	device
322	modern
323	phone
324	smartphone
325	Cold
326	Weather
327	flower
328	audio
329	equalizer
330	fader
331	mixer
332	mixing
333	panel
334	studio
335	stop
336	club
337	golf
338	speed
339	Music
340	Soundgarden
341	clamp
342	nut
343	classifier
344	Pearl Jam
345	STP
346	disaster
347	force
348	natural
349	nature
350	powerful
351	tornado
352	wind
353	bug
354	classic
355	violin
356	magic
357	Food
358	Fruit
359	Fruits
360	equestrian
361	horse
362	pasture
363	wildlife
364	video Games
365	data
366	info
367	research
368	test
369	doc
370	doctor
371	medicine
372	notebook
373	pen
\.


--
-- Name: ozpcenter_tag_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ozp_user
--

SELECT pg_catalog.setval('ozpcenter_tag_id_seq', 373, true);


--
-- Data for Name: ozpiwc_dataresource; Type: TABLE DATA; Schema: public; Owner: ozp_user
--

COPY ozpiwc_dataresource (id, key, entity, content_type, username, pattern, permissions, version) FROM stdin;
\.


--
-- Name: ozpiwc_dataresource_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ozp_user
--

SELECT pg_catalog.setval('ozpiwc_dataresource_id_seq', 1, false);


--
-- Data for Name: profile_listing; Type: TABLE DATA; Schema: public; Owner: ozp_user
--

COPY profile_listing (id, listing_id, profile_id) FROM stdin;
1796	1	1
1797	2	5
1798	3	4
1799	4	9
1800	5	15
1801	6	17
1802	7	13
1803	7	5
1804	8	4
1805	9	12
1806	10	4
1807	11	13
1808	12	12
1809	13	9
1810	14	4
1811	14	13
1812	15	13
1813	16	17
1814	17	15
1815	18	4
1816	18	5
1817	19	17
1818	20	15
1819	21	13
1820	22	4
1821	23	6
1822	24	4
1823	24	13
1824	25	9
1825	26	4
1826	26	5
1827	27	5
1828	28	15
1829	29	15
1830	30	5
1831	31	4
1832	32	6
1833	33	4
1834	34	4
1835	34	13
1836	35	4
1837	36	4
1838	37	4
1839	38	5
1840	39	4
1841	40	4
1842	40	13
1843	41	17
1844	42	17
1845	43	5
1846	44	5
1847	45	9
1848	46	4
1849	47	2
1850	47	3
1851	48	4
1852	49	1
1853	50	1
1854	51	4
1855	52	4
1856	53	4
1857	54	4
1858	55	4
1859	56	9
1860	57	1
1861	58	5
1862	59	15
1863	60	4
1864	61	15
1865	62	4
1866	63	4
1867	63	13
1868	64	1
1869	65	4
1870	65	13
1871	66	5
1872	67	9
1873	68	1
1874	69	1
1875	70	3
1876	71	4
1877	72	4
1878	73	1
1879	74	4
1880	74	5
1881	75	15
1882	76	4
1883	77	17
1884	78	4
1885	78	1
1886	79	12
1887	80	4
1888	81	17
1889	82	5
1890	83	12
1891	84	4
1892	85	4
1893	86	15
1894	87	1
1895	88	3
1896	89	9
1897	90	4
1898	91	1
1899	92	3
1900	93	1
1901	94	1
1902	95	5
1903	96	5
1904	97	5
1905	98	4
1906	99	15
1907	100	17
1908	101	4
1909	102	15
1910	103	4
1911	104	4
1912	105	9
1913	106	4
1914	107	4
1915	108	1
1916	109	13
1917	110	4
1918	111	4
1919	112	15
1920	113	4
1921	114	4
1922	115	4
1923	116	15
1924	117	15
1925	118	12
1926	119	1
1927	120	1
1928	121	1
1929	122	13
1930	123	4
1931	124	1
1932	125	4
1933	126	4
1934	126	1
1935	126	15
1936	127	1
1937	128	12
1938	129	3
1939	130	15
1940	131	4
1941	132	4
1942	133	2
1943	133	13
1944	133	5
1945	134	15
1946	135	17
1947	136	5
1948	137	5
1949	138	21
1950	139	15
1951	140	4
1952	141	4
1953	142	1
1954	143	1
1955	143	13
1956	144	4
1957	145	5
1958	146	15
1959	147	12
1960	148	13
1961	149	1
1962	150	15
1963	151	4
1964	152	8
1965	152	10
1966	153	1
1967	154	9
1968	155	4
1969	156	1
1970	157	4
1971	157	13
1972	158	4
1973	159	4
1974	160	13
1975	161	4
1976	162	12
1977	163	4
1978	164	4
1979	165	1
1980	166	4
1981	167	4
1982	168	4
1983	169	1
1984	170	4
1985	171	15
1986	172	4
1987	173	12
1988	174	12
1989	175	1
1990	176	4
1991	177	4
1992	177	13
1993	178	9
1994	179	4
1995	180	1
1996	181	4
1997	182	4
1998	183	4
1999	184	13
2000	184	5
2001	185	4
2002	185	13
2003	186	1
2004	187	17
2005	188	1
\.


--
-- Name: profile_listing_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ozp_user
--

SELECT pg_catalog.setval('profile_listing_id_seq', 2005, true);


--
-- Data for Name: stewarded_agency_profile; Type: TABLE DATA; Schema: public; Owner: ozp_user
--

COPY stewarded_agency_profile (id, profile_id, agency_id) FROM stdin;
109	4	5
110	4	6
111	4	1
112	4	7
113	4	8
114	4	9
115	5	1
116	6	1
117	6	3
118	7	2
119	7	4
120	8	3
\.


--
-- Name: stewarded_agency_profile_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ozp_user
--

SELECT pg_catalog.setval('stewarded_agency_profile_id_seq', 120, true);


--
-- Data for Name: tag_listing; Type: TABLE DATA; Schema: public; Owner: ozp_user
--

COPY tag_listing (id, listing_id, tag_id) FROM stdin;
4745	1	3
4746	1	4
4747	1	5
4748	1	6
4749	1	7
4750	1	8
4751	1	9
4752	1	10
4753	1	11
4754	2	1
4755	2	12
4756	2	2
4757	2	13
4758	3	14
4759	4	15
4760	4	16
4761	5	17
4762	5	18
4763	5	19
4764	6	20
4765	7	21
4766	7	22
4767	7	23
4768	8	24
4769	8	25
4770	9	26
4771	10	27
4772	10	28
4773	10	29
4774	10	30
4775	11	31
4776	11	32
4777	11	33
4778	11	34
4779	12	26
4780	13	35
4781	13	36
4782	13	37
4783	14	38
4784	14	39
4785	14	40
4786	15	38
4787	15	39
4788	15	41
4789	15	42
4790	15	43
4791	16	44
4792	16	45
4793	17	18
4794	17	19
4795	18	46
4796	19	45
4797	20	47
4798	20	48
4799	21	49
4800	21	50
4801	21	51
4802	21	52
4803	21	53
4804	22	54
4805	23	1
4806	23	12
4807	23	2
4808	24	55
4809	24	31
4810	24	56
4811	24	33
4812	24	57
4813	24	58
4814	25	59
4815	25	60
4816	26	61
4817	26	62
4818	26	63
4819	27	64
4820	27	65
4821	27	63
4822	28	48
4823	29	19
4824	30	1
4825	30	12
4826	31	66
4827	32	1
4828	32	12
4829	33	32
4830	34	67
4831	34	39
4832	34	52
4833	34	68
4834	35	69
4835	35	32
4836	35	70
4837	36	71
4838	36	66
4839	36	72
4840	37	66
4841	37	72
4842	38	1
4843	38	12
4844	39	73
4845	39	74
4846	39	75
4847	40	76
4848	40	77
4849	40	78
4850	40	79
4851	41	45
4852	42	80
4853	43	81
4854	43	82
4855	43	83
4856	43	84
4857	44	85
4858	44	86
4859	44	87
4860	44	88
4861	44	89
4862	44	90
4863	44	91
4864	45	92
4865	45	93
4866	45	94
4867	45	95
4868	46	96
4869	47	97
4870	47	98
4871	47	99
4872	47	100
4873	48	101
4874	48	102
4875	48	103
4876	49	6
4877	49	7
4878	49	104
4879	49	105
4880	49	10
4881	49	106
4882	49	107
4883	50	7
4884	50	108
4885	50	104
4886	50	109
4887	50	110
4888	50	111
4889	51	112
4890	52	113
4891	53	114
4892	53	115
4893	53	116
4894	54	117
4895	54	118
4896	54	101
4897	55	119
4898	55	120
4899	55	121
4900	55	122
4901	56	123
4902	56	124
4903	56	125
4904	57	126
4905	57	127
4906	57	128
4907	57	41
4908	57	129
4909	57	130
4910	57	131
4911	57	132
4912	57	133
4913	58	1
4914	58	12
4915	59	18
4916	60	134
4917	61	18
4918	61	19
4919	62	104
4920	62	135
4921	62	136
4922	63	137
4923	63	138
4924	64	39
4925	64	131
4926	64	139
4927	65	140
4928	65	141
4929	65	142
4930	65	143
4931	66	1
4932	66	12
4933	67	144
4934	67	145
4935	67	146
4936	68	147
4937	68	148
4938	68	149
4939	68	150
4940	68	151
4941	68	152
4942	68	153
4943	68	154
4944	69	155
4945	69	156
4946	69	157
4947	69	158
4948	69	159
4949	69	160
4950	69	150
4951	69	151
4952	69	161
4953	69	162
4954	69	163
4955	69	164
4956	69	165
4957	69	166
4958	69	167
4959	70	168
4960	70	169
4961	70	170
4962	70	171
4963	70	150
4964	70	151
4965	70	172
4966	70	173
4967	71	174
4968	72	112
4969	73	175
4970	73	176
4971	74	177
4972	74	178
4973	75	179
4974	75	48
4975	76	180
4976	76	181
4977	76	182
4978	77	183
4979	78	46
4980	79	26
4981	80	66
4982	81	45
4983	82	1
4984	82	12
4985	83	26
4986	84	184
4987	85	185
4988	85	182
4989	86	18
4990	86	19
4991	86	186
4992	87	187
4993	87	188
4994	88	189
4995	88	190
4996	88	191
4997	89	192
4998	89	193
4999	89	194
5000	90	112
5001	91	39
5002	91	131
5003	92	195
5004	92	41
5005	92	196
5006	93	197
5007	93	198
5008	93	199
5009	93	200
5010	93	201
5011	93	202
5012	93	203
5013	93	204
5014	93	205
5015	94	206
5016	94	131
5017	95	1
5018	95	12
5019	96	1
5020	96	12
5021	97	1
5022	97	12
5023	98	54
5024	99	207
5025	100	20
5026	101	66
5027	102	18
5028	103	54
5029	104	208
5030	105	209
5031	106	210
5032	107	104
5033	108	1
5034	108	12
5035	108	206
5036	108	211
5037	109	212
5038	109	49
5039	109	213
5040	109	214
5041	109	215
5042	110	216
5043	110	217
5044	110	218
5045	111	219
5046	111	143
5047	111	220
5048	112	219
5049	112	101
5050	113	221
5051	113	222
5052	114	223
5053	115	224
5054	116	18
5055	116	19
5056	117	18
5057	117	19
5058	118	26
5059	119	225
5060	119	226
5061	119	227
5062	119	228
5063	119	229
5064	119	230
5065	119	231
5066	119	232
5067	120	61
5068	120	233
5069	120	234
5070	120	235
5071	120	236
5072	120	237
5073	120	238
5074	120	239
5075	120	240
5076	120	241
5077	120	242
5078	121	243
5079	121	244
5080	121	245
5081	121	246
5082	121	247
5083	121	248
5084	122	249
5085	122	247
5086	122	250
5087	122	251
5088	122	252
5089	123	113
5090	124	253
5091	124	61
5092	124	254
5093	124	225
5094	124	226
5095	124	255
5096	124	256
5097	124	257
5098	124	258
5099	124	259
5100	124	260
5101	124	229
5102	124	108
5103	124	261
5104	124	262
5105	124	263
5106	124	240
5107	124	264
5108	124	265
5109	124	266
5110	124	267
5111	124	268
5112	124	269
5113	124	270
5114	124	271
5115	125	272
5116	126	208
5117	126	273
5118	127	274
5119	127	275
5120	127	276
5121	127	7
5122	127	104
5123	127	277
5124	127	109
5125	127	106
5126	127	107
5127	128	278
5128	129	279
5129	129	280
5130	129	281
5131	129	282
5132	129	283
5133	129	273
5134	130	18
5135	130	19
5136	131	284
5137	132	54
5138	133	285
5139	133	286
5140	133	287
5141	133	288
5142	134	289
5143	135	45
5144	136	88
5145	136	89
5146	136	90
5147	136	290
5148	136	291
5149	136	292
5150	137	293
5151	137	294
5152	137	295
5153	137	291
5154	138	296
5155	138	297
5156	138	298
5157	138	293
5158	138	294
5159	138	295
5160	138	291
5161	138	134
5162	139	18
5163	139	19
5164	139	134
5165	140	299
5166	141	300
5167	142	301
5168	142	302
5169	142	303
5170	142	304
5171	142	305
5172	142	306
5173	143	39
5174	143	307
5175	144	308
5176	145	309
5177	145	88
5178	145	89
5179	145	90
5180	145	292
5181	146	18
5182	146	19
5183	146	310
5184	147	26
5185	148	140
5186	148	311
5187	148	312
5188	148	219
5189	148	143
5190	149	96
5191	149	313
5192	149	104
5193	149	314
5194	149	315
5195	149	241
5196	150	316
5197	150	47
5198	150	48
5199	151	317
5200	152	1
5201	152	12
5202	153	61
5203	153	254
5204	153	318
5205	153	319
5206	153	226
5207	153	320
5208	153	321
5209	153	257
5210	153	322
5211	153	323
5212	153	324
5213	153	271
5214	154	325
5215	154	326
5216	155	327
5217	156	328
5218	156	329
5219	156	330
5220	156	331
5221	156	332
5222	156	104
5223	156	333
5224	156	105
5225	156	334
5226	157	58
5227	158	335
5228	159	112
5229	160	336
5230	160	337
5231	160	338
5232	161	96
5233	162	26
5234	163	46
5235	163	339
5236	163	340
5237	164	341
5238	164	342
5239	165	343
5240	165	1
5241	166	46
5242	166	344
5243	167	79
5244	168	46
5245	168	345
5246	169	346
5247	169	347
5248	169	348
5249	169	349
5250	169	350
5251	169	351
5252	169	204
5253	169	352
5254	170	101
5255	171	18
5256	171	19
5257	171	134
5258	172	243
5259	172	353
5260	173	26
5261	174	26
5262	175	77
5263	175	354
5264	175	4
5265	175	7
5266	175	104
5267	175	105
5268	175	10
5269	175	355
5270	175	106
5271	175	107
5272	176	224
5273	177	356
5274	178	357
5275	178	358
5276	178	359
5277	179	112
5278	180	243
5279	180	360
5280	180	361
5281	180	206
5282	180	362
5283	180	91
5284	180	363
5285	181	243
5286	182	224
5287	183	364
5288	184	365
5289	184	366
5290	184	367
5291	184	368
5292	185	369
5293	185	370
5294	185	371
5295	186	206
5296	186	131
5297	187	45
5298	188	372
5299	188	241
5300	188	373
5301	188	133
\.


--
-- Name: tag_listing_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ozp_user
--

SELECT pg_catalog.setval('tag_listing_id_seq', 5301, true);


--
-- Name: agency_profile_pkey; Type: CONSTRAINT; Schema: public; Owner: ozp_user; Tablespace: 
--

ALTER TABLE ONLY agency_profile
    ADD CONSTRAINT agency_profile_pkey PRIMARY KEY (id);


--
-- Name: agency_profile_profile_id_agency_id_key; Type: CONSTRAINT; Schema: public; Owner: ozp_user; Tablespace: 
--

ALTER TABLE ONLY agency_profile
    ADD CONSTRAINT agency_profile_profile_id_agency_id_key UNIQUE (profile_id, agency_id);


--
-- Name: auth_group_name_key; Type: CONSTRAINT; Schema: public; Owner: ozp_user; Tablespace: 
--

ALTER TABLE ONLY auth_group
    ADD CONSTRAINT auth_group_name_key UNIQUE (name);


--
-- Name: auth_group_permissions_group_id_permission_id_key; Type: CONSTRAINT; Schema: public; Owner: ozp_user; Tablespace: 
--

ALTER TABLE ONLY auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_group_id_permission_id_key UNIQUE (group_id, permission_id);


--
-- Name: auth_group_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: ozp_user; Tablespace: 
--

ALTER TABLE ONLY auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_pkey PRIMARY KEY (id);


--
-- Name: auth_group_pkey; Type: CONSTRAINT; Schema: public; Owner: ozp_user; Tablespace: 
--

ALTER TABLE ONLY auth_group
    ADD CONSTRAINT auth_group_pkey PRIMARY KEY (id);


--
-- Name: auth_permission_content_type_id_codename_key; Type: CONSTRAINT; Schema: public; Owner: ozp_user; Tablespace: 
--

ALTER TABLE ONLY auth_permission
    ADD CONSTRAINT auth_permission_content_type_id_codename_key UNIQUE (content_type_id, codename);


--
-- Name: auth_permission_pkey; Type: CONSTRAINT; Schema: public; Owner: ozp_user; Tablespace: 
--

ALTER TABLE ONLY auth_permission
    ADD CONSTRAINT auth_permission_pkey PRIMARY KEY (id);


--
-- Name: auth_user_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: ozp_user; Tablespace: 
--

ALTER TABLE ONLY auth_user_groups
    ADD CONSTRAINT auth_user_groups_pkey PRIMARY KEY (id);


--
-- Name: auth_user_groups_user_id_group_id_key; Type: CONSTRAINT; Schema: public; Owner: ozp_user; Tablespace: 
--

ALTER TABLE ONLY auth_user_groups
    ADD CONSTRAINT auth_user_groups_user_id_group_id_key UNIQUE (user_id, group_id);


--
-- Name: auth_user_pkey; Type: CONSTRAINT; Schema: public; Owner: ozp_user; Tablespace: 
--

ALTER TABLE ONLY auth_user
    ADD CONSTRAINT auth_user_pkey PRIMARY KEY (id);


--
-- Name: auth_user_user_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: ozp_user; Tablespace: 
--

ALTER TABLE ONLY auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permissions_pkey PRIMARY KEY (id);


--
-- Name: auth_user_user_permissions_user_id_permission_id_key; Type: CONSTRAINT; Schema: public; Owner: ozp_user; Tablespace: 
--

ALTER TABLE ONLY auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permissions_user_id_permission_id_key UNIQUE (user_id, permission_id);


--
-- Name: auth_user_username_key; Type: CONSTRAINT; Schema: public; Owner: ozp_user; Tablespace: 
--

ALTER TABLE ONLY auth_user
    ADD CONSTRAINT auth_user_username_key UNIQUE (username);


--
-- Name: category_listing_listing_id_category_id_key; Type: CONSTRAINT; Schema: public; Owner: ozp_user; Tablespace: 
--

ALTER TABLE ONLY category_listing
    ADD CONSTRAINT category_listing_listing_id_category_id_key UNIQUE (listing_id, category_id);


--
-- Name: category_listing_pkey; Type: CONSTRAINT; Schema: public; Owner: ozp_user; Tablespace: 
--

ALTER TABLE ONLY category_listing
    ADD CONSTRAINT category_listing_pkey PRIMARY KEY (id);


--
-- Name: contact_listing_listing_id_contact_id_key; Type: CONSTRAINT; Schema: public; Owner: ozp_user; Tablespace: 
--

ALTER TABLE ONLY contact_listing
    ADD CONSTRAINT contact_listing_listing_id_contact_id_key UNIQUE (listing_id, contact_id);


--
-- Name: contact_listing_pkey; Type: CONSTRAINT; Schema: public; Owner: ozp_user; Tablespace: 
--

ALTER TABLE ONLY contact_listing
    ADD CONSTRAINT contact_listing_pkey PRIMARY KEY (id);


--
-- Name: corsheaders_corsmodel_pkey; Type: CONSTRAINT; Schema: public; Owner: ozp_user; Tablespace: 
--

ALTER TABLE ONLY corsheaders_corsmodel
    ADD CONSTRAINT corsheaders_corsmodel_pkey PRIMARY KEY (id);


--
-- Name: django_admin_log_pkey; Type: CONSTRAINT; Schema: public; Owner: ozp_user; Tablespace: 
--

ALTER TABLE ONLY django_admin_log
    ADD CONSTRAINT django_admin_log_pkey PRIMARY KEY (id);


--
-- Name: django_content_type_app_label_3bb28cb8ea571a60_uniq; Type: CONSTRAINT; Schema: public; Owner: ozp_user; Tablespace: 
--

ALTER TABLE ONLY django_content_type
    ADD CONSTRAINT django_content_type_app_label_3bb28cb8ea571a60_uniq UNIQUE (app_label, model);


--
-- Name: django_content_type_pkey; Type: CONSTRAINT; Schema: public; Owner: ozp_user; Tablespace: 
--

ALTER TABLE ONLY django_content_type
    ADD CONSTRAINT django_content_type_pkey PRIMARY KEY (id);


--
-- Name: django_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: ozp_user; Tablespace: 
--

ALTER TABLE ONLY django_migrations
    ADD CONSTRAINT django_migrations_pkey PRIMARY KEY (id);


--
-- Name: django_session_pkey; Type: CONSTRAINT; Schema: public; Owner: ozp_user; Tablespace: 
--

ALTER TABLE ONLY django_session
    ADD CONSTRAINT django_session_pkey PRIMARY KEY (session_key);


--
-- Name: intent_listing_listing_id_intent_id_key; Type: CONSTRAINT; Schema: public; Owner: ozp_user; Tablespace: 
--

ALTER TABLE ONLY intent_listing
    ADD CONSTRAINT intent_listing_listing_id_intent_id_key UNIQUE (listing_id, intent_id);


--
-- Name: intent_listing_pkey; Type: CONSTRAINT; Schema: public; Owner: ozp_user; Tablespace: 
--

ALTER TABLE ONLY intent_listing
    ADD CONSTRAINT intent_listing_pkey PRIMARY KEY (id);


--
-- Name: listing_activity_change_detai_listingactivity_id_changedeta_key; Type: CONSTRAINT; Schema: public; Owner: ozp_user; Tablespace: 
--

ALTER TABLE ONLY listing_activity_change_detail
    ADD CONSTRAINT listing_activity_change_detai_listingactivity_id_changedeta_key UNIQUE (listingactivity_id, changedetail_id);


--
-- Name: listing_activity_change_detail_pkey; Type: CONSTRAINT; Schema: public; Owner: ozp_user; Tablespace: 
--

ALTER TABLE ONLY listing_activity_change_detail
    ADD CONSTRAINT listing_activity_change_detail_pkey PRIMARY KEY (id);


--
-- Name: notification_profile_notification_id_profile_id_key; Type: CONSTRAINT; Schema: public; Owner: ozp_user; Tablespace: 
--

ALTER TABLE ONLY notification_profile
    ADD CONSTRAINT notification_profile_notification_id_profile_id_key UNIQUE (notification_id, profile_id);


--
-- Name: notification_profile_pkey; Type: CONSTRAINT; Schema: public; Owner: ozp_user; Tablespace: 
--

ALTER TABLE ONLY notification_profile
    ADD CONSTRAINT notification_profile_pkey PRIMARY KEY (id);


--
-- Name: ozpcenter_agency_pkey; Type: CONSTRAINT; Schema: public; Owner: ozp_user; Tablespace: 
--

ALTER TABLE ONLY ozpcenter_agency
    ADD CONSTRAINT ozpcenter_agency_pkey PRIMARY KEY (id);


--
-- Name: ozpcenter_agency_short_name_key; Type: CONSTRAINT; Schema: public; Owner: ozp_user; Tablespace: 
--

ALTER TABLE ONLY ozpcenter_agency
    ADD CONSTRAINT ozpcenter_agency_short_name_key UNIQUE (short_name);


--
-- Name: ozpcenter_agency_title_key; Type: CONSTRAINT; Schema: public; Owner: ozp_user; Tablespace: 
--

ALTER TABLE ONLY ozpcenter_agency
    ADD CONSTRAINT ozpcenter_agency_title_key UNIQUE (title);


--
-- Name: ozpcenter_applicationlibraryentry_pkey; Type: CONSTRAINT; Schema: public; Owner: ozp_user; Tablespace: 
--

ALTER TABLE ONLY ozpcenter_applicationlibraryentry
    ADD CONSTRAINT ozpcenter_applicationlibraryentry_pkey PRIMARY KEY (id);


--
-- Name: ozpcenter_category_pkey; Type: CONSTRAINT; Schema: public; Owner: ozp_user; Tablespace: 
--

ALTER TABLE ONLY ozpcenter_category
    ADD CONSTRAINT ozpcenter_category_pkey PRIMARY KEY (id);


--
-- Name: ozpcenter_category_title_key; Type: CONSTRAINT; Schema: public; Owner: ozp_user; Tablespace: 
--

ALTER TABLE ONLY ozpcenter_category
    ADD CONSTRAINT ozpcenter_category_title_key UNIQUE (title);


--
-- Name: ozpcenter_changedetail_pkey; Type: CONSTRAINT; Schema: public; Owner: ozp_user; Tablespace: 
--

ALTER TABLE ONLY ozpcenter_changedetail
    ADD CONSTRAINT ozpcenter_changedetail_pkey PRIMARY KEY (id);


--
-- Name: ozpcenter_contact_pkey; Type: CONSTRAINT; Schema: public; Owner: ozp_user; Tablespace: 
--

ALTER TABLE ONLY ozpcenter_contact
    ADD CONSTRAINT ozpcenter_contact_pkey PRIMARY KEY (id);


--
-- Name: ozpcenter_contacttype_name_key; Type: CONSTRAINT; Schema: public; Owner: ozp_user; Tablespace: 
--

ALTER TABLE ONLY ozpcenter_contacttype
    ADD CONSTRAINT ozpcenter_contacttype_name_key UNIQUE (name);


--
-- Name: ozpcenter_contacttype_pkey; Type: CONSTRAINT; Schema: public; Owner: ozp_user; Tablespace: 
--

ALTER TABLE ONLY ozpcenter_contacttype
    ADD CONSTRAINT ozpcenter_contacttype_pkey PRIMARY KEY (id);


--
-- Name: ozpcenter_docurl_pkey; Type: CONSTRAINT; Schema: public; Owner: ozp_user; Tablespace: 
--

ALTER TABLE ONLY ozpcenter_docurl
    ADD CONSTRAINT ozpcenter_docurl_pkey PRIMARY KEY (id);


--
-- Name: ozpcenter_image_pkey; Type: CONSTRAINT; Schema: public; Owner: ozp_user; Tablespace: 
--

ALTER TABLE ONLY ozpcenter_image
    ADD CONSTRAINT ozpcenter_image_pkey PRIMARY KEY (id);


--
-- Name: ozpcenter_image_uuid_key; Type: CONSTRAINT; Schema: public; Owner: ozp_user; Tablespace: 
--

ALTER TABLE ONLY ozpcenter_image
    ADD CONSTRAINT ozpcenter_image_uuid_key UNIQUE (uuid);


--
-- Name: ozpcenter_imagetype_name_key; Type: CONSTRAINT; Schema: public; Owner: ozp_user; Tablespace: 
--

ALTER TABLE ONLY ozpcenter_imagetype
    ADD CONSTRAINT ozpcenter_imagetype_name_key UNIQUE (name);


--
-- Name: ozpcenter_imagetype_pkey; Type: CONSTRAINT; Schema: public; Owner: ozp_user; Tablespace: 
--

ALTER TABLE ONLY ozpcenter_imagetype
    ADD CONSTRAINT ozpcenter_imagetype_pkey PRIMARY KEY (id);


--
-- Name: ozpcenter_intent_pkey; Type: CONSTRAINT; Schema: public; Owner: ozp_user; Tablespace: 
--

ALTER TABLE ONLY ozpcenter_intent
    ADD CONSTRAINT ozpcenter_intent_pkey PRIMARY KEY (id);


--
-- Name: ozpcenter_listing_current_rejection_id_key; Type: CONSTRAINT; Schema: public; Owner: ozp_user; Tablespace: 
--

ALTER TABLE ONLY ozpcenter_listing
    ADD CONSTRAINT ozpcenter_listing_current_rejection_id_key UNIQUE (current_rejection_id);


--
-- Name: ozpcenter_listing_last_activity_id_key; Type: CONSTRAINT; Schema: public; Owner: ozp_user; Tablespace: 
--

ALTER TABLE ONLY ozpcenter_listing
    ADD CONSTRAINT ozpcenter_listing_last_activity_id_key UNIQUE (last_activity_id);


--
-- Name: ozpcenter_listing_pkey; Type: CONSTRAINT; Schema: public; Owner: ozp_user; Tablespace: 
--

ALTER TABLE ONLY ozpcenter_listing
    ADD CONSTRAINT ozpcenter_listing_pkey PRIMARY KEY (id);


--
-- Name: ozpcenter_listing_unique_name_key; Type: CONSTRAINT; Schema: public; Owner: ozp_user; Tablespace: 
--

ALTER TABLE ONLY ozpcenter_listing
    ADD CONSTRAINT ozpcenter_listing_unique_name_key UNIQUE (unique_name);


--
-- Name: ozpcenter_listingactivity_pkey; Type: CONSTRAINT; Schema: public; Owner: ozp_user; Tablespace: 
--

ALTER TABLE ONLY ozpcenter_listingactivity
    ADD CONSTRAINT ozpcenter_listingactivity_pkey PRIMARY KEY (id);


--
-- Name: ozpcenter_listingtype_pkey; Type: CONSTRAINT; Schema: public; Owner: ozp_user; Tablespace: 
--

ALTER TABLE ONLY ozpcenter_listingtype
    ADD CONSTRAINT ozpcenter_listingtype_pkey PRIMARY KEY (id);


--
-- Name: ozpcenter_listingtype_title_key; Type: CONSTRAINT; Schema: public; Owner: ozp_user; Tablespace: 
--

ALTER TABLE ONLY ozpcenter_listingtype
    ADD CONSTRAINT ozpcenter_listingtype_title_key UNIQUE (title);


--
-- Name: ozpcenter_notification_pkey; Type: CONSTRAINT; Schema: public; Owner: ozp_user; Tablespace: 
--

ALTER TABLE ONLY ozpcenter_notification
    ADD CONSTRAINT ozpcenter_notification_pkey PRIMARY KEY (id);


--
-- Name: ozpcenter_notificationmailbox_pkey; Type: CONSTRAINT; Schema: public; Owner: ozp_user; Tablespace: 
--

ALTER TABLE ONLY ozpcenter_notificationmailbox
    ADD CONSTRAINT ozpcenter_notificationmailbox_pkey PRIMARY KEY (id);


--
-- Name: ozpcenter_profile_dn_key; Type: CONSTRAINT; Schema: public; Owner: ozp_user; Tablespace: 
--

ALTER TABLE ONLY ozpcenter_profile
    ADD CONSTRAINT ozpcenter_profile_dn_key UNIQUE (dn);


--
-- Name: ozpcenter_profile_pkey; Type: CONSTRAINT; Schema: public; Owner: ozp_user; Tablespace: 
--

ALTER TABLE ONLY ozpcenter_profile
    ADD CONSTRAINT ozpcenter_profile_pkey PRIMARY KEY (id);


--
-- Name: ozpcenter_profile_user_id_key; Type: CONSTRAINT; Schema: public; Owner: ozp_user; Tablespace: 
--

ALTER TABLE ONLY ozpcenter_profile
    ADD CONSTRAINT ozpcenter_profile_user_id_key UNIQUE (user_id);


--
-- Name: ozpcenter_recommendationfeedback_pkey; Type: CONSTRAINT; Schema: public; Owner: ozp_user; Tablespace: 
--

ALTER TABLE ONLY ozpcenter_recommendationfeedback
    ADD CONSTRAINT ozpcenter_recommendationfeedback_pkey PRIMARY KEY (id);


--
-- Name: ozpcenter_recommendationsentry_pkey; Type: CONSTRAINT; Schema: public; Owner: ozp_user; Tablespace: 
--

ALTER TABLE ONLY ozpcenter_recommendationsentry
    ADD CONSTRAINT ozpcenter_recommendationsentry_pkey PRIMARY KEY (id);


--
-- Name: ozpcenter_review_pkey; Type: CONSTRAINT; Schema: public; Owner: ozp_user; Tablespace: 
--

ALTER TABLE ONLY ozpcenter_review
    ADD CONSTRAINT ozpcenter_review_pkey PRIMARY KEY (id);


--
-- Name: ozpcenter_screenshot_pkey; Type: CONSTRAINT; Schema: public; Owner: ozp_user; Tablespace: 
--

ALTER TABLE ONLY ozpcenter_screenshot
    ADD CONSTRAINT ozpcenter_screenshot_pkey PRIMARY KEY (id);


--
-- Name: ozpcenter_subscription_pkey; Type: CONSTRAINT; Schema: public; Owner: ozp_user; Tablespace: 
--

ALTER TABLE ONLY ozpcenter_subscription
    ADD CONSTRAINT ozpcenter_subscription_pkey PRIMARY KEY (id);


--
-- Name: ozpcenter_tag_name_key; Type: CONSTRAINT; Schema: public; Owner: ozp_user; Tablespace: 
--

ALTER TABLE ONLY ozpcenter_tag
    ADD CONSTRAINT ozpcenter_tag_name_key UNIQUE (name);


--
-- Name: ozpcenter_tag_pkey; Type: CONSTRAINT; Schema: public; Owner: ozp_user; Tablespace: 
--

ALTER TABLE ONLY ozpcenter_tag
    ADD CONSTRAINT ozpcenter_tag_pkey PRIMARY KEY (id);


--
-- Name: ozpiwc_dataresource_pkey; Type: CONSTRAINT; Schema: public; Owner: ozp_user; Tablespace: 
--

ALTER TABLE ONLY ozpiwc_dataresource
    ADD CONSTRAINT ozpiwc_dataresource_pkey PRIMARY KEY (id);


--
-- Name: ozpiwc_dataresource_username_75d088372482b805_uniq; Type: CONSTRAINT; Schema: public; Owner: ozp_user; Tablespace: 
--

ALTER TABLE ONLY ozpiwc_dataresource
    ADD CONSTRAINT ozpiwc_dataresource_username_75d088372482b805_uniq UNIQUE (username, key);


--
-- Name: profile_listing_listing_id_profile_id_key; Type: CONSTRAINT; Schema: public; Owner: ozp_user; Tablespace: 
--

ALTER TABLE ONLY profile_listing
    ADD CONSTRAINT profile_listing_listing_id_profile_id_key UNIQUE (listing_id, profile_id);


--
-- Name: profile_listing_pkey; Type: CONSTRAINT; Schema: public; Owner: ozp_user; Tablespace: 
--

ALTER TABLE ONLY profile_listing
    ADD CONSTRAINT profile_listing_pkey PRIMARY KEY (id);


--
-- Name: stewarded_agency_profile_pkey; Type: CONSTRAINT; Schema: public; Owner: ozp_user; Tablespace: 
--

ALTER TABLE ONLY stewarded_agency_profile
    ADD CONSTRAINT stewarded_agency_profile_pkey PRIMARY KEY (id);


--
-- Name: stewarded_agency_profile_profile_id_agency_id_key; Type: CONSTRAINT; Schema: public; Owner: ozp_user; Tablespace: 
--

ALTER TABLE ONLY stewarded_agency_profile
    ADD CONSTRAINT stewarded_agency_profile_profile_id_agency_id_key UNIQUE (profile_id, agency_id);


--
-- Name: tag_listing_listing_id_tag_id_key; Type: CONSTRAINT; Schema: public; Owner: ozp_user; Tablespace: 
--

ALTER TABLE ONLY tag_listing
    ADD CONSTRAINT tag_listing_listing_id_tag_id_key UNIQUE (listing_id, tag_id);


--
-- Name: tag_listing_pkey; Type: CONSTRAINT; Schema: public; Owner: ozp_user; Tablespace: 
--

ALTER TABLE ONLY tag_listing
    ADD CONSTRAINT tag_listing_pkey PRIMARY KEY (id);


--
-- Name: agency_profile_169fc544; Type: INDEX; Schema: public; Owner: ozp_user; Tablespace: 
--

CREATE INDEX agency_profile_169fc544 ON agency_profile USING btree (agency_id);


--
-- Name: agency_profile_83a0eb3f; Type: INDEX; Schema: public; Owner: ozp_user; Tablespace: 
--

CREATE INDEX agency_profile_83a0eb3f ON agency_profile USING btree (profile_id);


--
-- Name: auth_group_name_3ad1a0e7949f9d2a_like; Type: INDEX; Schema: public; Owner: ozp_user; Tablespace: 
--

CREATE INDEX auth_group_name_3ad1a0e7949f9d2a_like ON auth_group USING btree (name varchar_pattern_ops);


--
-- Name: auth_group_permissions_0e939a4f; Type: INDEX; Schema: public; Owner: ozp_user; Tablespace: 
--

CREATE INDEX auth_group_permissions_0e939a4f ON auth_group_permissions USING btree (group_id);


--
-- Name: auth_group_permissions_8373b171; Type: INDEX; Schema: public; Owner: ozp_user; Tablespace: 
--

CREATE INDEX auth_group_permissions_8373b171 ON auth_group_permissions USING btree (permission_id);


--
-- Name: auth_permission_417f1b1c; Type: INDEX; Schema: public; Owner: ozp_user; Tablespace: 
--

CREATE INDEX auth_permission_417f1b1c ON auth_permission USING btree (content_type_id);


--
-- Name: auth_user_groups_0e939a4f; Type: INDEX; Schema: public; Owner: ozp_user; Tablespace: 
--

CREATE INDEX auth_user_groups_0e939a4f ON auth_user_groups USING btree (group_id);


--
-- Name: auth_user_groups_e8701ad4; Type: INDEX; Schema: public; Owner: ozp_user; Tablespace: 
--

CREATE INDEX auth_user_groups_e8701ad4 ON auth_user_groups USING btree (user_id);


--
-- Name: auth_user_user_permissions_8373b171; Type: INDEX; Schema: public; Owner: ozp_user; Tablespace: 
--

CREATE INDEX auth_user_user_permissions_8373b171 ON auth_user_user_permissions USING btree (permission_id);


--
-- Name: auth_user_user_permissions_e8701ad4; Type: INDEX; Schema: public; Owner: ozp_user; Tablespace: 
--

CREATE INDEX auth_user_user_permissions_e8701ad4 ON auth_user_user_permissions USING btree (user_id);


--
-- Name: auth_user_username_6129fcc871f48a65_like; Type: INDEX; Schema: public; Owner: ozp_user; Tablespace: 
--

CREATE INDEX auth_user_username_6129fcc871f48a65_like ON auth_user USING btree (username varchar_pattern_ops);


--
-- Name: category_listing_a5acdb6c; Type: INDEX; Schema: public; Owner: ozp_user; Tablespace: 
--

CREATE INDEX category_listing_a5acdb6c ON category_listing USING btree (listing_id);


--
-- Name: category_listing_b583a629; Type: INDEX; Schema: public; Owner: ozp_user; Tablespace: 
--

CREATE INDEX category_listing_b583a629 ON category_listing USING btree (category_id);


--
-- Name: contact_listing_6d82f13d; Type: INDEX; Schema: public; Owner: ozp_user; Tablespace: 
--

CREATE INDEX contact_listing_6d82f13d ON contact_listing USING btree (contact_id);


--
-- Name: contact_listing_a5acdb6c; Type: INDEX; Schema: public; Owner: ozp_user; Tablespace: 
--

CREATE INDEX contact_listing_a5acdb6c ON contact_listing USING btree (listing_id);


--
-- Name: django_admin_log_417f1b1c; Type: INDEX; Schema: public; Owner: ozp_user; Tablespace: 
--

CREATE INDEX django_admin_log_417f1b1c ON django_admin_log USING btree (content_type_id);


--
-- Name: django_admin_log_e8701ad4; Type: INDEX; Schema: public; Owner: ozp_user; Tablespace: 
--

CREATE INDEX django_admin_log_e8701ad4 ON django_admin_log USING btree (user_id);


--
-- Name: django_session_de54fa62; Type: INDEX; Schema: public; Owner: ozp_user; Tablespace: 
--

CREATE INDEX django_session_de54fa62 ON django_session USING btree (expire_date);


--
-- Name: django_session_session_key_221fa7b1ed1d672_like; Type: INDEX; Schema: public; Owner: ozp_user; Tablespace: 
--

CREATE INDEX django_session_session_key_221fa7b1ed1d672_like ON django_session USING btree (session_key varchar_pattern_ops);


--
-- Name: intent_listing_a5acdb6c; Type: INDEX; Schema: public; Owner: ozp_user; Tablespace: 
--

CREATE INDEX intent_listing_a5acdb6c ON intent_listing USING btree (listing_id);


--
-- Name: intent_listing_a5d69478; Type: INDEX; Schema: public; Owner: ozp_user; Tablespace: 
--

CREATE INDEX intent_listing_a5d69478 ON intent_listing USING btree (intent_id);


--
-- Name: listing_activity_change_detail_528f1dff; Type: INDEX; Schema: public; Owner: ozp_user; Tablespace: 
--

CREATE INDEX listing_activity_change_detail_528f1dff ON listing_activity_change_detail USING btree (listingactivity_id);


--
-- Name: listing_activity_change_detail_e27da002; Type: INDEX; Schema: public; Owner: ozp_user; Tablespace: 
--

CREATE INDEX listing_activity_change_detail_e27da002 ON listing_activity_change_detail USING btree (changedetail_id);


--
-- Name: notification_profile_53fb5b6b; Type: INDEX; Schema: public; Owner: ozp_user; Tablespace: 
--

CREATE INDEX notification_profile_53fb5b6b ON notification_profile USING btree (notification_id);


--
-- Name: notification_profile_83a0eb3f; Type: INDEX; Schema: public; Owner: ozp_user; Tablespace: 
--

CREATE INDEX notification_profile_83a0eb3f ON notification_profile USING btree (profile_id);


--
-- Name: ozpcenter_agency_fe6647e8; Type: INDEX; Schema: public; Owner: ozp_user; Tablespace: 
--

CREATE INDEX ozpcenter_agency_fe6647e8 ON ozpcenter_agency USING btree (icon_id);


--
-- Name: ozpcenter_agency_short_name_62a59e53d907f0d4_like; Type: INDEX; Schema: public; Owner: ozp_user; Tablespace: 
--

CREATE INDEX ozpcenter_agency_short_name_62a59e53d907f0d4_like ON ozpcenter_agency USING btree (short_name varchar_pattern_ops);


--
-- Name: ozpcenter_agency_title_6c9b52be0bc95bf3_like; Type: INDEX; Schema: public; Owner: ozp_user; Tablespace: 
--

CREATE INDEX ozpcenter_agency_title_6c9b52be0bc95bf3_like ON ozpcenter_agency USING btree (title varchar_pattern_ops);


--
-- Name: ozpcenter_applicationlibraryentry_5e7b1936; Type: INDEX; Schema: public; Owner: ozp_user; Tablespace: 
--

CREATE INDEX ozpcenter_applicationlibraryentry_5e7b1936 ON ozpcenter_applicationlibraryentry USING btree (owner_id);


--
-- Name: ozpcenter_applicationlibraryentry_a5acdb6c; Type: INDEX; Schema: public; Owner: ozp_user; Tablespace: 
--

CREATE INDEX ozpcenter_applicationlibraryentry_a5acdb6c ON ozpcenter_applicationlibraryentry USING btree (listing_id);


--
-- Name: ozpcenter_category_title_3c384c9cb9c4c4cf_like; Type: INDEX; Schema: public; Owner: ozp_user; Tablespace: 
--

CREATE INDEX ozpcenter_category_title_3c384c9cb9c4c4cf_like ON ozpcenter_category USING btree (title varchar_pattern_ops);


--
-- Name: ozpcenter_contact_b4a73b95; Type: INDEX; Schema: public; Owner: ozp_user; Tablespace: 
--

CREATE INDEX ozpcenter_contact_b4a73b95 ON ozpcenter_contact USING btree (contact_type_id);


--
-- Name: ozpcenter_contacttype_name_72b5054300884f0c_like; Type: INDEX; Schema: public; Owner: ozp_user; Tablespace: 
--

CREATE INDEX ozpcenter_contacttype_name_72b5054300884f0c_like ON ozpcenter_contacttype USING btree (name varchar_pattern_ops);


--
-- Name: ozpcenter_docurl_a5acdb6c; Type: INDEX; Schema: public; Owner: ozp_user; Tablespace: 
--

CREATE INDEX ozpcenter_docurl_a5acdb6c ON ozpcenter_docurl USING btree (listing_id);


--
-- Name: ozpcenter_image_bba883bb; Type: INDEX; Schema: public; Owner: ozp_user; Tablespace: 
--

CREATE INDEX ozpcenter_image_bba883bb ON ozpcenter_image USING btree (image_type_id);


--
-- Name: ozpcenter_image_uuid_af31bd52ef50d54_like; Type: INDEX; Schema: public; Owner: ozp_user; Tablespace: 
--

CREATE INDEX ozpcenter_image_uuid_af31bd52ef50d54_like ON ozpcenter_image USING btree (uuid varchar_pattern_ops);


--
-- Name: ozpcenter_imagetype_name_5a7e3660d70b4bd7_like; Type: INDEX; Schema: public; Owner: ozp_user; Tablespace: 
--

CREATE INDEX ozpcenter_imagetype_name_5a7e3660d70b4bd7_like ON ozpcenter_imagetype USING btree (name varchar_pattern_ops);


--
-- Name: ozpcenter_intent_fe6647e8; Type: INDEX; Schema: public; Owner: ozp_user; Tablespace: 
--

CREATE INDEX ozpcenter_intent_fe6647e8 ON ozpcenter_intent USING btree (icon_id);


--
-- Name: ozpcenter_listing_169fc544; Type: INDEX; Schema: public; Owner: ozp_user; Tablespace: 
--

CREATE INDEX ozpcenter_listing_169fc544 ON ozpcenter_listing USING btree (agency_id);


--
-- Name: ozpcenter_listing_2d32ca62; Type: INDEX; Schema: public; Owner: ozp_user; Tablespace: 
--

CREATE INDEX ozpcenter_listing_2d32ca62 ON ozpcenter_listing USING btree (small_icon_id);


--
-- Name: ozpcenter_listing_55d22161; Type: INDEX; Schema: public; Owner: ozp_user; Tablespace: 
--

CREATE INDEX ozpcenter_listing_55d22161 ON ozpcenter_listing USING btree (listing_type_id);


--
-- Name: ozpcenter_listing_6ea97d1f; Type: INDEX; Schema: public; Owner: ozp_user; Tablespace: 
--

CREATE INDEX ozpcenter_listing_6ea97d1f ON ozpcenter_listing USING btree (required_listings_id);


--
-- Name: ozpcenter_listing_7d6976c7; Type: INDEX; Schema: public; Owner: ozp_user; Tablespace: 
--

CREATE INDEX ozpcenter_listing_7d6976c7 ON ozpcenter_listing USING btree (large_banner_icon_id);


--
-- Name: ozpcenter_listing_bf208909; Type: INDEX; Schema: public; Owner: ozp_user; Tablespace: 
--

CREATE INDEX ozpcenter_listing_bf208909 ON ozpcenter_listing USING btree (banner_icon_id);


--
-- Name: ozpcenter_listing_fb492c13; Type: INDEX; Schema: public; Owner: ozp_user; Tablespace: 
--

CREATE INDEX ozpcenter_listing_fb492c13 ON ozpcenter_listing USING btree (large_icon_id);


--
-- Name: ozpcenter_listing_unique_name_168ca3eb4e50a421_like; Type: INDEX; Schema: public; Owner: ozp_user; Tablespace: 
--

CREATE INDEX ozpcenter_listing_unique_name_168ca3eb4e50a421_like ON ozpcenter_listing USING btree (unique_name varchar_pattern_ops);


--
-- Name: ozpcenter_listingactivity_4f331e2f; Type: INDEX; Schema: public; Owner: ozp_user; Tablespace: 
--

CREATE INDEX ozpcenter_listingactivity_4f331e2f ON ozpcenter_listingactivity USING btree (author_id);


--
-- Name: ozpcenter_listingactivity_a5acdb6c; Type: INDEX; Schema: public; Owner: ozp_user; Tablespace: 
--

CREATE INDEX ozpcenter_listingactivity_a5acdb6c ON ozpcenter_listingactivity USING btree (listing_id);


--
-- Name: ozpcenter_listingtype_title_7477e6bbc02b457_like; Type: INDEX; Schema: public; Owner: ozp_user; Tablespace: 
--

CREATE INDEX ozpcenter_listingtype_title_7477e6bbc02b457_like ON ozpcenter_listingtype USING btree (title varchar_pattern_ops);


--
-- Name: ozpcenter_notification_169fc544; Type: INDEX; Schema: public; Owner: ozp_user; Tablespace: 
--

CREATE INDEX ozpcenter_notification_169fc544 ON ozpcenter_notification USING btree (agency_id);


--
-- Name: ozpcenter_notification_4f331e2f; Type: INDEX; Schema: public; Owner: ozp_user; Tablespace: 
--

CREATE INDEX ozpcenter_notification_4f331e2f ON ozpcenter_notification USING btree (author_id);


--
-- Name: ozpcenter_notification_a5acdb6c; Type: INDEX; Schema: public; Owner: ozp_user; Tablespace: 
--

CREATE INDEX ozpcenter_notification_a5acdb6c ON ozpcenter_notification USING btree (listing_id);


--
-- Name: ozpcenter_notification_dffc4713; Type: INDEX; Schema: public; Owner: ozp_user; Tablespace: 
--

CREATE INDEX ozpcenter_notification_dffc4713 ON ozpcenter_notification USING btree (entity_id);


--
-- Name: ozpcenter_notificationmailbox_14c1d39e; Type: INDEX; Schema: public; Owner: ozp_user; Tablespace: 
--

CREATE INDEX ozpcenter_notificationmailbox_14c1d39e ON ozpcenter_notificationmailbox USING btree (target_profile_id);


--
-- Name: ozpcenter_notificationmailbox_53fb5b6b; Type: INDEX; Schema: public; Owner: ozp_user; Tablespace: 
--

CREATE INDEX ozpcenter_notificationmailbox_53fb5b6b ON ozpcenter_notificationmailbox USING btree (notification_id);


--
-- Name: ozpcenter_profile_dn_1e55d9f07a0f6de3_like; Type: INDEX; Schema: public; Owner: ozp_user; Tablespace: 
--

CREATE INDEX ozpcenter_profile_dn_1e55d9f07a0f6de3_like ON ozpcenter_profile USING btree (dn varchar_pattern_ops);


--
-- Name: ozpcenter_recommendationfeedback_093698ee; Type: INDEX; Schema: public; Owner: ozp_user; Tablespace: 
--

CREATE INDEX ozpcenter_recommendationfeedback_093698ee ON ozpcenter_recommendationfeedback USING btree (target_listing_id);


--
-- Name: ozpcenter_recommendationfeedback_14c1d39e; Type: INDEX; Schema: public; Owner: ozp_user; Tablespace: 
--

CREATE INDEX ozpcenter_recommendationfeedback_14c1d39e ON ozpcenter_recommendationfeedback USING btree (target_profile_id);


--
-- Name: ozpcenter_recommendationsentry_14c1d39e; Type: INDEX; Schema: public; Owner: ozp_user; Tablespace: 
--

CREATE INDEX ozpcenter_recommendationsentry_14c1d39e ON ozpcenter_recommendationsentry USING btree (target_profile_id);


--
-- Name: ozpcenter_review_4334f859; Type: INDEX; Schema: public; Owner: ozp_user; Tablespace: 
--

CREATE INDEX ozpcenter_review_4334f859 ON ozpcenter_review USING btree (review_parent_id);


--
-- Name: ozpcenter_review_4f331e2f; Type: INDEX; Schema: public; Owner: ozp_user; Tablespace: 
--

CREATE INDEX ozpcenter_review_4f331e2f ON ozpcenter_review USING btree (author_id);


--
-- Name: ozpcenter_review_a5acdb6c; Type: INDEX; Schema: public; Owner: ozp_user; Tablespace: 
--

CREATE INDEX ozpcenter_review_a5acdb6c ON ozpcenter_review USING btree (listing_id);


--
-- Name: ozpcenter_screenshot_2e890d9b; Type: INDEX; Schema: public; Owner: ozp_user; Tablespace: 
--

CREATE INDEX ozpcenter_screenshot_2e890d9b ON ozpcenter_screenshot USING btree (small_image_id);


--
-- Name: ozpcenter_screenshot_42efd8fd; Type: INDEX; Schema: public; Owner: ozp_user; Tablespace: 
--

CREATE INDEX ozpcenter_screenshot_42efd8fd ON ozpcenter_screenshot USING btree (large_image_id);


--
-- Name: ozpcenter_screenshot_a5acdb6c; Type: INDEX; Schema: public; Owner: ozp_user; Tablespace: 
--

CREATE INDEX ozpcenter_screenshot_a5acdb6c ON ozpcenter_screenshot USING btree (listing_id);


--
-- Name: ozpcenter_subscription_14c1d39e; Type: INDEX; Schema: public; Owner: ozp_user; Tablespace: 
--

CREATE INDEX ozpcenter_subscription_14c1d39e ON ozpcenter_subscription USING btree (target_profile_id);


--
-- Name: ozpcenter_subscription_89111891; Type: INDEX; Schema: public; Owner: ozp_user; Tablespace: 
--

CREATE INDEX ozpcenter_subscription_89111891 ON ozpcenter_subscription USING btree (entity_type);


--
-- Name: ozpcenter_subscription_dffc4713; Type: INDEX; Schema: public; Owner: ozp_user; Tablespace: 
--

CREATE INDEX ozpcenter_subscription_dffc4713 ON ozpcenter_subscription USING btree (entity_id);


--
-- Name: ozpcenter_subscription_entity_type_3a0213f84034746b_like; Type: INDEX; Schema: public; Owner: ozp_user; Tablespace: 
--

CREATE INDEX ozpcenter_subscription_entity_type_3a0213f84034746b_like ON ozpcenter_subscription USING btree (entity_type varchar_pattern_ops);


--
-- Name: ozpcenter_tag_name_71ff1c32f5c4dd55_like; Type: INDEX; Schema: public; Owner: ozp_user; Tablespace: 
--

CREATE INDEX ozpcenter_tag_name_71ff1c32f5c4dd55_like ON ozpcenter_tag USING btree (name varchar_pattern_ops);


--
-- Name: profile_listing_83a0eb3f; Type: INDEX; Schema: public; Owner: ozp_user; Tablespace: 
--

CREATE INDEX profile_listing_83a0eb3f ON profile_listing USING btree (profile_id);


--
-- Name: profile_listing_a5acdb6c; Type: INDEX; Schema: public; Owner: ozp_user; Tablespace: 
--

CREATE INDEX profile_listing_a5acdb6c ON profile_listing USING btree (listing_id);


--
-- Name: stewarded_agency_profile_169fc544; Type: INDEX; Schema: public; Owner: ozp_user; Tablespace: 
--

CREATE INDEX stewarded_agency_profile_169fc544 ON stewarded_agency_profile USING btree (agency_id);


--
-- Name: stewarded_agency_profile_83a0eb3f; Type: INDEX; Schema: public; Owner: ozp_user; Tablespace: 
--

CREATE INDEX stewarded_agency_profile_83a0eb3f ON stewarded_agency_profile USING btree (profile_id);


--
-- Name: tag_listing_76f094bc; Type: INDEX; Schema: public; Owner: ozp_user; Tablespace: 
--

CREATE INDEX tag_listing_76f094bc ON tag_listing USING btree (tag_id);


--
-- Name: tag_listing_a5acdb6c; Type: INDEX; Schema: public; Owner: ozp_user; Tablespace: 
--

CREATE INDEX tag_listing_a5acdb6c ON tag_listing USING btree (listing_id);


--
-- Name: D0a6d12d6bad1898cbfd9ebc8cd9cea7; Type: FK CONSTRAINT; Schema: public; Owner: ozp_user
--

ALTER TABLE ONLY listing_activity_change_detail
    ADD CONSTRAINT "D0a6d12d6bad1898cbfd9ebc8cd9cea7" FOREIGN KEY (listingactivity_id) REFERENCES ozpcenter_listingactivity(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: D56abefc45441b6879bb42098ebd6977; Type: FK CONSTRAINT; Schema: public; Owner: ozp_user
--

ALTER TABLE ONLY ozpcenter_listing
    ADD CONSTRAINT "D56abefc45441b6879bb42098ebd6977" FOREIGN KEY (current_rejection_id) REFERENCES ozpcenter_listingactivity(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: D6fbd0237223db863d6e6c8e30fe2e01; Type: FK CONSTRAINT; Schema: public; Owner: ozp_user
--

ALTER TABLE ONLY ozpcenter_listing
    ADD CONSTRAINT "D6fbd0237223db863d6e6c8e30fe2e01" FOREIGN KEY (last_activity_id) REFERENCES ozpcenter_listingactivity(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: agency_prof_profile_id_4b89dee6750cfae8_fk_ozpcenter_profile_id; Type: FK CONSTRAINT; Schema: public; Owner: ozp_user
--

ALTER TABLE ONLY agency_profile
    ADD CONSTRAINT agency_prof_profile_id_4b89dee6750cfae8_fk_ozpcenter_profile_id FOREIGN KEY (profile_id) REFERENCES ozpcenter_profile(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: agency_profil_agency_id_1ee8a860e9b219e6_fk_ozpcenter_agency_id; Type: FK CONSTRAINT; Schema: public; Owner: ozp_user
--

ALTER TABLE ONLY agency_profile
    ADD CONSTRAINT agency_profil_agency_id_1ee8a860e9b219e6_fk_ozpcenter_agency_id FOREIGN KEY (agency_id) REFERENCES ozpcenter_agency(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_content_type_id_100c1f664bb767bc_fk_django_content_type_id; Type: FK CONSTRAINT; Schema: public; Owner: ozp_user
--

ALTER TABLE ONLY auth_permission
    ADD CONSTRAINT auth_content_type_id_100c1f664bb767bc_fk_django_content_type_id FOREIGN KEY (content_type_id) REFERENCES django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_group_permissio_group_id_10297e644d483925_fk_auth_group_id; Type: FK CONSTRAINT; Schema: public; Owner: ozp_user
--

ALTER TABLE ONLY auth_group_permissions
    ADD CONSTRAINT auth_group_permissio_group_id_10297e644d483925_fk_auth_group_id FOREIGN KEY (group_id) REFERENCES auth_group(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_group_permission_id_436bf4629d4dcbd9_fk_auth_permission_id; Type: FK CONSTRAINT; Schema: public; Owner: ozp_user
--

ALTER TABLE ONLY auth_group_permissions
    ADD CONSTRAINT auth_group_permission_id_436bf4629d4dcbd9_fk_auth_permission_id FOREIGN KEY (permission_id) REFERENCES auth_permission(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_user_groups_group_id_11dfab2bae0f9c53_fk_auth_group_id; Type: FK CONSTRAINT; Schema: public; Owner: ozp_user
--

ALTER TABLE ONLY auth_user_groups
    ADD CONSTRAINT auth_user_groups_group_id_11dfab2bae0f9c53_fk_auth_group_id FOREIGN KEY (group_id) REFERENCES auth_group(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_user_groups_user_id_4599617763fb2ca8_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: ozp_user
--

ALTER TABLE ONLY auth_user_groups
    ADD CONSTRAINT auth_user_groups_user_id_4599617763fb2ca8_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_user_u_permission_id_32220a7f5f2cfd3_fk_auth_permission_id; Type: FK CONSTRAINT; Schema: public; Owner: ozp_user
--

ALTER TABLE ONLY auth_user_user_permissions
    ADD CONSTRAINT auth_user_u_permission_id_32220a7f5f2cfd3_fk_auth_permission_id FOREIGN KEY (permission_id) REFERENCES auth_permission(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_user_user_permiss_user_id_407ebf86b4cc8714_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: ozp_user
--

ALTER TABLE ONLY auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permiss_user_id_407ebf86b4cc8714_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: category__category_id_7fd27aafbb32dea6_fk_ozpcenter_category_id; Type: FK CONSTRAINT; Schema: public; Owner: ozp_user
--

ALTER TABLE ONLY category_listing
    ADD CONSTRAINT category__category_id_7fd27aafbb32dea6_fk_ozpcenter_category_id FOREIGN KEY (category_id) REFERENCES ozpcenter_category(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: category_li_listing_id_494e3812b4a2182d_fk_ozpcenter_listing_id; Type: FK CONSTRAINT; Schema: public; Owner: ozp_user
--

ALTER TABLE ONLY category_listing
    ADD CONSTRAINT category_li_listing_id_494e3812b4a2182d_fk_ozpcenter_listing_id FOREIGN KEY (listing_id) REFERENCES ozpcenter_listing(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: contact_lis_contact_id_33e112809e32f46d_fk_ozpcenter_contact_id; Type: FK CONSTRAINT; Schema: public; Owner: ozp_user
--

ALTER TABLE ONLY contact_listing
    ADD CONSTRAINT contact_lis_contact_id_33e112809e32f46d_fk_ozpcenter_contact_id FOREIGN KEY (contact_id) REFERENCES ozpcenter_contact(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: contact_lis_listing_id_164cff37001eaa2e_fk_ozpcenter_listing_id; Type: FK CONSTRAINT; Schema: public; Owner: ozp_user
--

ALTER TABLE ONLY contact_listing
    ADD CONSTRAINT contact_lis_listing_id_164cff37001eaa2e_fk_ozpcenter_listing_id FOREIGN KEY (listing_id) REFERENCES ozpcenter_listing(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: djan_content_type_id_3c3ef0e568e26cdd_fk_django_content_type_id; Type: FK CONSTRAINT; Schema: public; Owner: ozp_user
--

ALTER TABLE ONLY django_admin_log
    ADD CONSTRAINT djan_content_type_id_3c3ef0e568e26cdd_fk_django_content_type_id FOREIGN KEY (content_type_id) REFERENCES django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: django_admin_log_user_id_6d87a2e462904f8b_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: ozp_user
--

ALTER TABLE ONLY django_admin_log
    ADD CONSTRAINT django_admin_log_user_id_6d87a2e462904f8b_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: intent_list_listing_id_6f2b3bec74fc90d5_fk_ozpcenter_listing_id; Type: FK CONSTRAINT; Schema: public; Owner: ozp_user
--

ALTER TABLE ONLY intent_listing
    ADD CONSTRAINT intent_list_listing_id_6f2b3bec74fc90d5_fk_ozpcenter_listing_id FOREIGN KEY (listing_id) REFERENCES ozpcenter_listing(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: intent_listin_intent_id_59a0121a93878b08_fk_ozpcenter_intent_id; Type: FK CONSTRAINT; Schema: public; Owner: ozp_user
--

ALTER TABLE ONLY intent_listing
    ADD CONSTRAINT intent_listin_intent_id_59a0121a93878b08_fk_ozpcenter_intent_id FOREIGN KEY (intent_id) REFERENCES ozpcenter_intent(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: li_changedetail_id_fd6468c1e1ba59f_fk_ozpcenter_changedetail_id; Type: FK CONSTRAINT; Schema: public; Owner: ozp_user
--

ALTER TABLE ONLY listing_activity_change_detail
    ADD CONSTRAINT li_changedetail_id_fd6468c1e1ba59f_fk_ozpcenter_changedetail_id FOREIGN KEY (changedetail_id) REFERENCES ozpcenter_changedetail(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: n_notification_id_728ef0c61308d908_fk_ozpcenter_notification_id; Type: FK CONSTRAINT; Schema: public; Owner: ozp_user
--

ALTER TABLE ONLY notification_profile
    ADD CONSTRAINT n_notification_id_728ef0c61308d908_fk_ozpcenter_notification_id FOREIGN KEY (notification_id) REFERENCES ozpcenter_notification(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: notificatio_profile_id_408e4bac9578be38_fk_ozpcenter_profile_id; Type: FK CONSTRAINT; Schema: public; Owner: ozp_user
--

ALTER TABLE ONLY notification_profile
    ADD CONSTRAINT notificatio_profile_id_408e4bac9578be38_fk_ozpcenter_profile_id FOREIGN KEY (profile_id) REFERENCES ozpcenter_profile(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: o_notification_id_11017721d5367eb4_fk_ozpcenter_notification_id; Type: FK CONSTRAINT; Schema: public; Owner: ozp_user
--

ALTER TABLE ONLY ozpcenter_notificationmailbox
    ADD CONSTRAINT o_notification_id_11017721d5367eb4_fk_ozpcenter_notification_id FOREIGN KEY (notification_id) REFERENCES ozpcenter_notification(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: o_required_listings_id_1fb9c100517c3efd_fk_ozpcenter_listing_id; Type: FK CONSTRAINT; Schema: public; Owner: ozp_user
--

ALTER TABLE ONLY ozpcenter_listing
    ADD CONSTRAINT o_required_listings_id_1fb9c100517c3efd_fk_ozpcenter_listing_id FOREIGN KEY (required_listings_id) REFERENCES ozpcenter_listing(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: oz_contact_type_id_27df93faff156276_fk_ozpcenter_contacttype_id; Type: FK CONSTRAINT; Schema: public; Owner: ozp_user
--

ALTER TABLE ONLY ozpcenter_contact
    ADD CONSTRAINT oz_contact_type_id_27df93faff156276_fk_ozpcenter_contacttype_id FOREIGN KEY (contact_type_id) REFERENCES ozpcenter_contacttype(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: oz_listing_type_id_1ade0a1022e7748b_fk_ozpcenter_listingtype_id; Type: FK CONSTRAINT; Schema: public; Owner: ozp_user
--

ALTER TABLE ONLY ozpcenter_listing
    ADD CONSTRAINT oz_listing_type_id_1ade0a1022e7748b_fk_ozpcenter_listingtype_id FOREIGN KEY (listing_type_id) REFERENCES ozpcenter_listingtype(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: ozp_large_banner_icon_id_1d379fbb0165932f_fk_ozpcenter_image_id; Type: FK CONSTRAINT; Schema: public; Owner: ozp_user
--

ALTER TABLE ONLY ozpcenter_listing
    ADD CONSTRAINT ozp_large_banner_icon_id_1d379fbb0165932f_fk_ozpcenter_image_id FOREIGN KEY (large_banner_icon_id) REFERENCES ozpcenter_image(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: ozpc_target_listing_id_266e5d53fffcd4b8_fk_ozpcenter_listing_id; Type: FK CONSTRAINT; Schema: public; Owner: ozp_user
--

ALTER TABLE ONLY ozpcenter_recommendationfeedback
    ADD CONSTRAINT ozpc_target_listing_id_266e5d53fffcd4b8_fk_ozpcenter_listing_id FOREIGN KEY (target_listing_id) REFERENCES ozpcenter_listing(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: ozpc_target_profile_id_3b31a68e9d6def4d_fk_ozpcenter_profile_id; Type: FK CONSTRAINT; Schema: public; Owner: ozp_user
--

ALTER TABLE ONLY ozpcenter_subscription
    ADD CONSTRAINT ozpc_target_profile_id_3b31a68e9d6def4d_fk_ozpcenter_profile_id FOREIGN KEY (target_profile_id) REFERENCES ozpcenter_profile(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: ozpc_target_profile_id_4d9e39e5871311bf_fk_ozpcenter_profile_id; Type: FK CONSTRAINT; Schema: public; Owner: ozp_user
--

ALTER TABLE ONLY ozpcenter_recommendationfeedback
    ADD CONSTRAINT ozpc_target_profile_id_4d9e39e5871311bf_fk_ozpcenter_profile_id FOREIGN KEY (target_profile_id) REFERENCES ozpcenter_profile(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: ozpc_target_profile_id_5324f38bfca6bbb4_fk_ozpcenter_profile_id; Type: FK CONSTRAINT; Schema: public; Owner: ozp_user
--

ALTER TABLE ONLY ozpcenter_recommendationsentry
    ADD CONSTRAINT ozpc_target_profile_id_5324f38bfca6bbb4_fk_ozpcenter_profile_id FOREIGN KEY (target_profile_id) REFERENCES ozpcenter_profile(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: ozpce_target_profile_id_ab3d8ead83f0aea_fk_ozpcenter_profile_id; Type: FK CONSTRAINT; Schema: public; Owner: ozp_user
--

ALTER TABLE ONLY ozpcenter_notificationmailbox
    ADD CONSTRAINT ozpce_target_profile_id_ab3d8ead83f0aea_fk_ozpcenter_profile_id FOREIGN KEY (target_profile_id) REFERENCES ozpcenter_profile(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: ozpcen_image_type_id_3ecbf22799e02043_fk_ozpcenter_imagetype_id; Type: FK CONSTRAINT; Schema: public; Owner: ozp_user
--

ALTER TABLE ONLY ozpcenter_image
    ADD CONSTRAINT ozpcen_image_type_id_3ecbf22799e02043_fk_ozpcenter_imagetype_id FOREIGN KEY (image_type_id) REFERENCES ozpcenter_imagetype(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: ozpcen_review_parent_id_125c3a9fc5ce3907_fk_ozpcenter_review_id; Type: FK CONSTRAINT; Schema: public; Owner: ozp_user
--

ALTER TABLE ONLY ozpcenter_review
    ADD CONSTRAINT ozpcen_review_parent_id_125c3a9fc5ce3907_fk_ozpcenter_review_id FOREIGN KEY (review_parent_id) REFERENCES ozpcenter_review(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: ozpcenter__large_icon_id_7d60b34d6c3e194d_fk_ozpcenter_image_id; Type: FK CONSTRAINT; Schema: public; Owner: ozp_user
--

ALTER TABLE ONLY ozpcenter_listing
    ADD CONSTRAINT ozpcenter__large_icon_id_7d60b34d6c3e194d_fk_ozpcenter_image_id FOREIGN KEY (large_icon_id) REFERENCES ozpcenter_image(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: ozpcenter__small_icon_id_70bd9d22b0948367_fk_ozpcenter_image_id; Type: FK CONSTRAINT; Schema: public; Owner: ozp_user
--

ALTER TABLE ONLY ozpcenter_listing
    ADD CONSTRAINT ozpcenter__small_icon_id_70bd9d22b0948367_fk_ozpcenter_image_id FOREIGN KEY (small_icon_id) REFERENCES ozpcenter_image(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: ozpcenter_a_listing_id_78946b421dcbfdd5_fk_ozpcenter_listing_id; Type: FK CONSTRAINT; Schema: public; Owner: ozp_user
--

ALTER TABLE ONLY ozpcenter_applicationlibraryentry
    ADD CONSTRAINT ozpcenter_a_listing_id_78946b421dcbfdd5_fk_ozpcenter_listing_id FOREIGN KEY (listing_id) REFERENCES ozpcenter_listing(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: ozpcenter_agency_icon_id_42b4fc78a6233c78_fk_ozpcenter_image_id; Type: FK CONSTRAINT; Schema: public; Owner: ozp_user
--

ALTER TABLE ONLY ozpcenter_agency
    ADD CONSTRAINT ozpcenter_agency_icon_id_42b4fc78a6233c78_fk_ozpcenter_image_id FOREIGN KEY (icon_id) REFERENCES ozpcenter_image(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: ozpcenter_app_owner_id_1b61eb254a69a969_fk_ozpcenter_profile_id; Type: FK CONSTRAINT; Schema: public; Owner: ozp_user
--

ALTER TABLE ONLY ozpcenter_applicationlibraryentry
    ADD CONSTRAINT ozpcenter_app_owner_id_1b61eb254a69a969_fk_ozpcenter_profile_id FOREIGN KEY (owner_id) REFERENCES ozpcenter_profile(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: ozpcenter_banner_icon_id_724815a528fc6007_fk_ozpcenter_image_id; Type: FK CONSTRAINT; Schema: public; Owner: ozp_user
--

ALTER TABLE ONLY ozpcenter_listing
    ADD CONSTRAINT ozpcenter_banner_icon_id_724815a528fc6007_fk_ozpcenter_image_id FOREIGN KEY (banner_icon_id) REFERENCES ozpcenter_image(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: ozpcenter_d_listing_id_4d5ec50f0fac3266_fk_ozpcenter_listing_id; Type: FK CONSTRAINT; Schema: public; Owner: ozp_user
--

ALTER TABLE ONLY ozpcenter_docurl
    ADD CONSTRAINT ozpcenter_d_listing_id_4d5ec50f0fac3266_fk_ozpcenter_listing_id FOREIGN KEY (listing_id) REFERENCES ozpcenter_listing(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: ozpcenter_intent_icon_id_53f8844a993980d3_fk_ozpcenter_image_id; Type: FK CONSTRAINT; Schema: public; Owner: ozp_user
--

ALTER TABLE ONLY ozpcenter_intent
    ADD CONSTRAINT ozpcenter_intent_icon_id_53f8844a993980d3_fk_ozpcenter_image_id FOREIGN KEY (icon_id) REFERENCES ozpcenter_image(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: ozpcenter_l_listing_id_122c842e2d665b98_fk_ozpcenter_listing_id; Type: FK CONSTRAINT; Schema: public; Owner: ozp_user
--

ALTER TABLE ONLY ozpcenter_listingactivity
    ADD CONSTRAINT ozpcenter_l_listing_id_122c842e2d665b98_fk_ozpcenter_listing_id FOREIGN KEY (listing_id) REFERENCES ozpcenter_listing(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: ozpcenter_large_image_id_4e37ca3a8330c9ee_fk_ozpcenter_image_id; Type: FK CONSTRAINT; Schema: public; Owner: ozp_user
--

ALTER TABLE ONLY ozpcenter_screenshot
    ADD CONSTRAINT ozpcenter_large_image_id_4e37ca3a8330c9ee_fk_ozpcenter_image_id FOREIGN KEY (large_image_id) REFERENCES ozpcenter_image(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: ozpcenter_li_author_id_15a428411ff26033_fk_ozpcenter_profile_id; Type: FK CONSTRAINT; Schema: public; Owner: ozp_user
--

ALTER TABLE ONLY ozpcenter_listingactivity
    ADD CONSTRAINT ozpcenter_li_author_id_15a428411ff26033_fk_ozpcenter_profile_id FOREIGN KEY (author_id) REFERENCES ozpcenter_profile(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: ozpcenter_lis_agency_id_282cdcde18915b2a_fk_ozpcenter_agency_id; Type: FK CONSTRAINT; Schema: public; Owner: ozp_user
--

ALTER TABLE ONLY ozpcenter_listing
    ADD CONSTRAINT ozpcenter_lis_agency_id_282cdcde18915b2a_fk_ozpcenter_agency_id FOREIGN KEY (agency_id) REFERENCES ozpcenter_agency(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: ozpcenter_n_listing_id_1c5f36fd90c53d9e_fk_ozpcenter_listing_id; Type: FK CONSTRAINT; Schema: public; Owner: ozp_user
--

ALTER TABLE ONLY ozpcenter_notification
    ADD CONSTRAINT ozpcenter_n_listing_id_1c5f36fd90c53d9e_fk_ozpcenter_listing_id FOREIGN KEY (listing_id) REFERENCES ozpcenter_listing(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: ozpcenter_not_agency_id_645ae0916a31fe19_fk_ozpcenter_agency_id; Type: FK CONSTRAINT; Schema: public; Owner: ozp_user
--

ALTER TABLE ONLY ozpcenter_notification
    ADD CONSTRAINT ozpcenter_not_agency_id_645ae0916a31fe19_fk_ozpcenter_agency_id FOREIGN KEY (agency_id) REFERENCES ozpcenter_agency(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: ozpcenter_not_author_id_b2ff68e780ddcc9_fk_ozpcenter_profile_id; Type: FK CONSTRAINT; Schema: public; Owner: ozp_user
--

ALTER TABLE ONLY ozpcenter_notification
    ADD CONSTRAINT ozpcenter_not_author_id_b2ff68e780ddcc9_fk_ozpcenter_profile_id FOREIGN KEY (author_id) REFERENCES ozpcenter_profile(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: ozpcenter_profile_user_id_35487f2c30450d57_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: ozp_user
--

ALTER TABLE ONLY ozpcenter_profile
    ADD CONSTRAINT ozpcenter_profile_user_id_35487f2c30450d57_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: ozpcenter_r_listing_id_318213e659d0c78e_fk_ozpcenter_listing_id; Type: FK CONSTRAINT; Schema: public; Owner: ozp_user
--

ALTER TABLE ONLY ozpcenter_review
    ADD CONSTRAINT ozpcenter_r_listing_id_318213e659d0c78e_fk_ozpcenter_listing_id FOREIGN KEY (listing_id) REFERENCES ozpcenter_listing(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: ozpcenter_rev_author_id_133309ec8b0d2a7_fk_ozpcenter_profile_id; Type: FK CONSTRAINT; Schema: public; Owner: ozp_user
--

ALTER TABLE ONLY ozpcenter_review
    ADD CONSTRAINT ozpcenter_rev_author_id_133309ec8b0d2a7_fk_ozpcenter_profile_id FOREIGN KEY (author_id) REFERENCES ozpcenter_profile(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: ozpcenter_s_listing_id_28d3c9716b9119f5_fk_ozpcenter_listing_id; Type: FK CONSTRAINT; Schema: public; Owner: ozp_user
--

ALTER TABLE ONLY ozpcenter_screenshot
    ADD CONSTRAINT ozpcenter_s_listing_id_28d3c9716b9119f5_fk_ozpcenter_listing_id FOREIGN KEY (listing_id) REFERENCES ozpcenter_listing(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: ozpcenter_small_image_id_1306d2c5359f7472_fk_ozpcenter_image_id; Type: FK CONSTRAINT; Schema: public; Owner: ozp_user
--

ALTER TABLE ONLY ozpcenter_screenshot
    ADD CONSTRAINT ozpcenter_small_image_id_1306d2c5359f7472_fk_ozpcenter_image_id FOREIGN KEY (small_image_id) REFERENCES ozpcenter_image(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: profile_lis_listing_id_5ba9cfcaf1d5efc1_fk_ozpcenter_listing_id; Type: FK CONSTRAINT; Schema: public; Owner: ozp_user
--

ALTER TABLE ONLY profile_listing
    ADD CONSTRAINT profile_lis_listing_id_5ba9cfcaf1d5efc1_fk_ozpcenter_listing_id FOREIGN KEY (listing_id) REFERENCES ozpcenter_listing(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: profile_lis_profile_id_154cb7a8a7a265bc_fk_ozpcenter_profile_id; Type: FK CONSTRAINT; Schema: public; Owner: ozp_user
--

ALTER TABLE ONLY profile_listing
    ADD CONSTRAINT profile_lis_profile_id_154cb7a8a7a265bc_fk_ozpcenter_profile_id FOREIGN KEY (profile_id) REFERENCES ozpcenter_profile(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: stewarded_a_profile_id_497430da780f1d55_fk_ozpcenter_profile_id; Type: FK CONSTRAINT; Schema: public; Owner: ozp_user
--

ALTER TABLE ONLY stewarded_agency_profile
    ADD CONSTRAINT stewarded_a_profile_id_497430da780f1d55_fk_ozpcenter_profile_id FOREIGN KEY (profile_id) REFERENCES ozpcenter_profile(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: stewarded_age_agency_id_466a180e6346a213_fk_ozpcenter_agency_id; Type: FK CONSTRAINT; Schema: public; Owner: ozp_user
--

ALTER TABLE ONLY stewarded_agency_profile
    ADD CONSTRAINT stewarded_age_agency_id_466a180e6346a213_fk_ozpcenter_agency_id FOREIGN KEY (agency_id) REFERENCES ozpcenter_agency(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: tag_listing_listing_id_7c6488d302b891fb_fk_ozpcenter_listing_id; Type: FK CONSTRAINT; Schema: public; Owner: ozp_user
--

ALTER TABLE ONLY tag_listing
    ADD CONSTRAINT tag_listing_listing_id_7c6488d302b891fb_fk_ozpcenter_listing_id FOREIGN KEY (listing_id) REFERENCES ozpcenter_listing(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: tag_listing_tag_id_9e93413ca4e31fe_fk_ozpcenter_tag_id; Type: FK CONSTRAINT; Schema: public; Owner: ozp_user
--

ALTER TABLE ONLY tag_listing
    ADD CONSTRAINT tag_listing_tag_id_9e93413ca4e31fe_fk_ozpcenter_tag_id FOREIGN KEY (tag_id) REFERENCES ozpcenter_tag(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

