--
-- PostgreSQL database dump
--

-- Dumped from database version 17.2 (Debian 17.2-1.pgdg120+1)
-- Dumped by pg_dump version 17.2 (Debian 17.2-1.pgdg120+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
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
-- Name: Assemblies; Type: TABLE; Schema: public; Owner: swen
--

CREATE TABLE public."Assemblies" (
    "Id" integer NOT NULL,
    name text NOT NULL,
    aliases text[],
    sequence_type text NOT NULL,
    "sequence_trackId" text NOT NULL,
    "displayName" text,
    "adapterType" text NOT NULL
);


ALTER TABLE public."Assemblies" OWNER TO swen;

--
-- Name: Assemblies_Id_seq; Type: SEQUENCE; Schema: public; Owner: swen
--

CREATE SEQUENCE public."Assemblies_Id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Assemblies_Id_seq" OWNER TO swen;

--
-- Name: Assemblies_Id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: swen
--

ALTER SEQUENCE public."Assemblies_Id_seq" OWNED BY public."Assemblies"."Id";


--
-- Name: BamAdapter; Type: TABLE; Schema: public; Owner: swen
--

CREATE TABLE public."BamAdapter" (
    "Id" integer NOT NULL,
    "trackId" integer NOT NULL,
    "bamLocation" text NOT NULL,
    "indexLocation" text NOT NULL,
    "sequenceAdapterId" integer NOT NULL,
    "sequenceAdapterType" text NOT NULL
);


ALTER TABLE public."BamAdapter" OWNER TO swen;

--
-- Name: BamAdapter_Id_seq; Type: SEQUENCE; Schema: public; Owner: swen
--

CREATE SEQUENCE public."BamAdapter_Id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."BamAdapter_Id_seq" OWNER TO swen;

--
-- Name: BamAdapter_Id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: swen
--

ALTER SEQUENCE public."BamAdapter_Id_seq" OWNED BY public."BamAdapter"."Id";


--
-- Name: BedTabixAdapter; Type: TABLE; Schema: public; Owner: swen
--

CREATE TABLE public."BedTabixAdapter" (
    "Id" integer NOT NULL,
    "trackId" integer NOT NULL,
    "bedGzLocation" text NOT NULL,
    "indexLocation" text NOT NULL
);


ALTER TABLE public."BedTabixAdapter" OWNER TO swen;

--
-- Name: BedTabixAdapter_Id_seq; Type: SEQUENCE; Schema: public; Owner: swen
--

CREATE SEQUENCE public."BedTabixAdapter_Id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."BedTabixAdapter_Id_seq" OWNER TO swen;

--
-- Name: BedTabixAdapter_Id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: swen
--

ALTER SEQUENCE public."BedTabixAdapter_Id_seq" OWNED BY public."BedTabixAdapter"."Id";


--
-- Name: BgzipFastaAdapter; Type: TABLE; Schema: public; Owner: swen
--

CREATE TABLE public."BgzipFastaAdapter" (
    "Id" integer NOT NULL,
    "assemblyId" integer NOT NULL,
    "fastaLocation" text NOT NULL,
    "faiLocation" text NOT NULL,
    "gziLocation" text NOT NULL,
    "metadataLocation" text NOT NULL
);


ALTER TABLE public."BgzipFastaAdapter" OWNER TO swen;

--
-- Name: BgzipFastaAdapter_Id_seq; Type: SEQUENCE; Schema: public; Owner: swen
--

CREATE SEQUENCE public."BgzipFastaAdapter_Id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."BgzipFastaAdapter_Id_seq" OWNER TO swen;

--
-- Name: BgzipFastaAdapter_Id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: swen
--

ALTER SEQUENCE public."BgzipFastaAdapter_Id_seq" OWNED BY public."BgzipFastaAdapter"."Id";


--
-- Name: CramAdapter; Type: TABLE; Schema: public; Owner: swen
--

CREATE TABLE public."CramAdapter" (
    "Id" integer NOT NULL,
    "trackId" integer NOT NULL,
    "cramLocation" text NOT NULL,
    "craiLocation" text NOT NULL,
    "sequenceAdapterId" integer NOT NULL,
    "sequenceAdapterType" text NOT NULL
);


ALTER TABLE public."CramAdapter" OWNER TO swen;

--
-- Name: CramAdapter_Id_seq; Type: SEQUENCE; Schema: public; Owner: swen
--

CREATE SEQUENCE public."CramAdapter_Id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."CramAdapter_Id_seq" OWNER TO swen;

--
-- Name: CramAdapter_Id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: swen
--

ALTER SEQUENCE public."CramAdapter_Id_seq" OWNED BY public."CramAdapter"."Id";


--
-- Name: DeltaAdapter; Type: TABLE; Schema: public; Owner: swen
--

CREATE TABLE public."DeltaAdapter" (
    "Id" integer NOT NULL,
    "trackId" integer NOT NULL,
    "deltaLocation" text NOT NULL,
    "assemblyNames" text[] NOT NULL
);


ALTER TABLE public."DeltaAdapter" OWNER TO swen;

--
-- Name: DeltaAdapter_Id_seq; Type: SEQUENCE; Schema: public; Owner: swen
--

CREATE SEQUENCE public."DeltaAdapter_Id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."DeltaAdapter_Id_seq" OWNER TO swen;

--
-- Name: DeltaAdapter_Id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: swen
--

ALTER SEQUENCE public."DeltaAdapter_Id_seq" OWNED BY public."DeltaAdapter"."Id";


--
-- Name: Displays; Type: TABLE; Schema: public; Owner: swen
--

CREATE TABLE public."Displays" (
    "Id" integer NOT NULL,
    "displayId" text NOT NULL,
    "parentId" integer NOT NULL,
    "parentType" text NOT NULL,
    type text NOT NULL,
    CONSTRAINT "Displays_parentType_check" CHECK (("parentType" = ANY (ARRAY['Assembly'::text, 'Track'::text])))
);


ALTER TABLE public."Displays" OWNER TO swen;

--
-- Name: Displays_Id_seq; Type: SEQUENCE; Schema: public; Owner: swen
--

CREATE SEQUENCE public."Displays_Id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Displays_Id_seq" OWNER TO swen;

--
-- Name: Displays_Id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: swen
--

ALTER SEQUENCE public."Displays_Id_seq" OWNED BY public."Displays"."Id";


--
-- Name: Gff3TabixAdapter; Type: TABLE; Schema: public; Owner: swen
--

CREATE TABLE public."Gff3TabixAdapter" (
    "Id" integer NOT NULL,
    "trackId" integer NOT NULL,
    "gffGzLocation" text NOT NULL,
    "indexLocation" text NOT NULL
);


ALTER TABLE public."Gff3TabixAdapter" OWNER TO swen;

--
-- Name: Gff3TabixAdapter_Id_seq; Type: SEQUENCE; Schema: public; Owner: swen
--

CREATE SEQUENCE public."Gff3TabixAdapter_Id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Gff3TabixAdapter_Id_seq" OWNER TO swen;

--
-- Name: Gff3TabixAdapter_Id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: swen
--

ALTER SEQUENCE public."Gff3TabixAdapter_Id_seq" OWNED BY public."Gff3TabixAdapter"."Id";


--
-- Name: IndexedFastaAdapter; Type: TABLE; Schema: public; Owner: swen
--

CREATE TABLE public."IndexedFastaAdapter" (
    "Id" integer NOT NULL,
    "assemblyId" integer NOT NULL,
    "fastaLocation" text NOT NULL,
    "faiLocation" text NOT NULL,
    "metadataLocation" text NOT NULL
);


ALTER TABLE public."IndexedFastaAdapter" OWNER TO swen;

--
-- Name: IndexedFastaAdapter_Id_seq; Type: SEQUENCE; Schema: public; Owner: swen
--

CREATE SEQUENCE public."IndexedFastaAdapter_Id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."IndexedFastaAdapter_Id_seq" OWNER TO swen;

--
-- Name: IndexedFastaAdapter_Id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: swen
--

ALTER SEQUENCE public."IndexedFastaAdapter_Id_seq" OWNED BY public."IndexedFastaAdapter"."Id";


--
-- Name: PAFAdapter; Type: TABLE; Schema: public; Owner: swen
--

CREATE TABLE public."PAFAdapter" (
    "Id" integer NOT NULL,
    "trackId" integer NOT NULL,
    "pafLocation" text NOT NULL,
    "assemblyNames" text[] NOT NULL
);


ALTER TABLE public."PAFAdapter" OWNER TO swen;

--
-- Name: PAFAdapter_Id_seq; Type: SEQUENCE; Schema: public; Owner: swen
--

CREATE SEQUENCE public."PAFAdapter_Id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."PAFAdapter_Id_seq" OWNER TO swen;

--
-- Name: PAFAdapter_Id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: swen
--

ALTER SEQUENCE public."PAFAdapter_Id_seq" OWNED BY public."PAFAdapter"."Id";


--
-- Name: RefNameAlias; Type: TABLE; Schema: public; Owner: swen
--

CREATE TABLE public."RefNameAlias" (
    "Id" integer NOT NULL,
    "assemblyId" integer NOT NULL,
    "adapterType" text,
    "adapterId" text
);


ALTER TABLE public."RefNameAlias" OWNER TO swen;

--
-- Name: RefNameAlias_Id_seq; Type: SEQUENCE; Schema: public; Owner: swen
--

CREATE SEQUENCE public."RefNameAlias_Id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."RefNameAlias_Id_seq" OWNER TO swen;

--
-- Name: RefNameAlias_Id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: swen
--

ALTER SEQUENCE public."RefNameAlias_Id_seq" OWNED BY public."RefNameAlias"."Id";


--
-- Name: Renderer; Type: TABLE; Schema: public; Owner: swen
--

CREATE TABLE public."Renderer" (
    id integer NOT NULL,
    "DisplaysId" integer NOT NULL,
    "rendererKey" text NOT NULL,
    type text NOT NULL,
    "rendererDetails" jsonb
);


ALTER TABLE public."Renderer" OWNER TO swen;

--
-- Name: Renderer_id_seq; Type: SEQUENCE; Schema: public; Owner: swen
--

CREATE SEQUENCE public."Renderer_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Renderer_id_seq" OWNER TO swen;

--
-- Name: Renderer_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: swen
--

ALTER SEQUENCE public."Renderer_id_seq" OWNED BY public."Renderer".id;


--
-- Name: Tracks; Type: TABLE; Schema: public; Owner: swen
--

CREATE TABLE public."Tracks" (
    "Id" integer NOT NULL,
    "trackId" text NOT NULL,
    type text NOT NULL,
    name text NOT NULL,
    "assemblyNames" text[],
    category text[],
    "adapterType" text NOT NULL
);


ALTER TABLE public."Tracks" OWNER TO swen;

--
-- Name: Tracks_Id_seq; Type: SEQUENCE; Schema: public; Owner: swen
--

CREATE SEQUENCE public."Tracks_Id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Tracks_Id_seq" OWNER TO swen;

--
-- Name: Tracks_Id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: swen
--

ALTER SEQUENCE public."Tracks_Id_seq" OWNED BY public."Tracks"."Id";


--
-- Name: VcfTabixAdapter; Type: TABLE; Schema: public; Owner: swen
--

CREATE TABLE public."VcfTabixAdapter" (
    "Id" integer NOT NULL,
    "trackId" integer NOT NULL,
    "vcfGzLocation" text NOT NULL,
    "indexLocation" text NOT NULL
);


ALTER TABLE public."VcfTabixAdapter" OWNER TO swen;

--
-- Name: VcfTabixAdapter_Id_seq; Type: SEQUENCE; Schema: public; Owner: swen
--

CREATE SEQUENCE public."VcfTabixAdapter_Id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."VcfTabixAdapter_Id_seq" OWNER TO swen;

--
-- Name: VcfTabixAdapter_Id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: swen
--

ALTER SEQUENCE public."VcfTabixAdapter_Id_seq" OWNED BY public."VcfTabixAdapter"."Id";


--
-- Name: features; Type: TABLE; Schema: public; Owner: swen
--

CREATE TABLE public.features (
    "Id" integer NOT NULL,
    "RefNameAliasId" integer NOT NULL,
    "refName" text,
    "uniqueId" text,
    aliases text[]
);


ALTER TABLE public.features OWNER TO swen;

--
-- Name: features_Id_seq; Type: SEQUENCE; Schema: public; Owner: swen
--

CREATE SEQUENCE public."features_Id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."features_Id_seq" OWNER TO swen;

--
-- Name: features_Id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: swen
--

ALTER SEQUENCE public."features_Id_seq" OWNED BY public.features."Id";


--
-- Name: Assemblies Id; Type: DEFAULT; Schema: public; Owner: swen
--

ALTER TABLE ONLY public."Assemblies" ALTER COLUMN "Id" SET DEFAULT nextval('public."Assemblies_Id_seq"'::regclass);


--
-- Name: BamAdapter Id; Type: DEFAULT; Schema: public; Owner: swen
--

ALTER TABLE ONLY public."BamAdapter" ALTER COLUMN "Id" SET DEFAULT nextval('public."BamAdapter_Id_seq"'::regclass);


--
-- Name: BedTabixAdapter Id; Type: DEFAULT; Schema: public; Owner: swen
--

ALTER TABLE ONLY public."BedTabixAdapter" ALTER COLUMN "Id" SET DEFAULT nextval('public."BedTabixAdapter_Id_seq"'::regclass);


--
-- Name: BgzipFastaAdapter Id; Type: DEFAULT; Schema: public; Owner: swen
--

ALTER TABLE ONLY public."BgzipFastaAdapter" ALTER COLUMN "Id" SET DEFAULT nextval('public."BgzipFastaAdapter_Id_seq"'::regclass);


--
-- Name: CramAdapter Id; Type: DEFAULT; Schema: public; Owner: swen
--

ALTER TABLE ONLY public."CramAdapter" ALTER COLUMN "Id" SET DEFAULT nextval('public."CramAdapter_Id_seq"'::regclass);


--
-- Name: DeltaAdapter Id; Type: DEFAULT; Schema: public; Owner: swen
--

ALTER TABLE ONLY public."DeltaAdapter" ALTER COLUMN "Id" SET DEFAULT nextval('public."DeltaAdapter_Id_seq"'::regclass);


--
-- Name: Displays Id; Type: DEFAULT; Schema: public; Owner: swen
--

ALTER TABLE ONLY public."Displays" ALTER COLUMN "Id" SET DEFAULT nextval('public."Displays_Id_seq"'::regclass);


--
-- Name: Gff3TabixAdapter Id; Type: DEFAULT; Schema: public; Owner: swen
--

ALTER TABLE ONLY public."Gff3TabixAdapter" ALTER COLUMN "Id" SET DEFAULT nextval('public."Gff3TabixAdapter_Id_seq"'::regclass);


--
-- Name: IndexedFastaAdapter Id; Type: DEFAULT; Schema: public; Owner: swen
--

ALTER TABLE ONLY public."IndexedFastaAdapter" ALTER COLUMN "Id" SET DEFAULT nextval('public."IndexedFastaAdapter_Id_seq"'::regclass);


--
-- Name: PAFAdapter Id; Type: DEFAULT; Schema: public; Owner: swen
--

ALTER TABLE ONLY public."PAFAdapter" ALTER COLUMN "Id" SET DEFAULT nextval('public."PAFAdapter_Id_seq"'::regclass);


--
-- Name: RefNameAlias Id; Type: DEFAULT; Schema: public; Owner: swen
--

ALTER TABLE ONLY public."RefNameAlias" ALTER COLUMN "Id" SET DEFAULT nextval('public."RefNameAlias_Id_seq"'::regclass);


--
-- Name: Renderer id; Type: DEFAULT; Schema: public; Owner: swen
--

ALTER TABLE ONLY public."Renderer" ALTER COLUMN id SET DEFAULT nextval('public."Renderer_id_seq"'::regclass);


--
-- Name: Tracks Id; Type: DEFAULT; Schema: public; Owner: swen
--

ALTER TABLE ONLY public."Tracks" ALTER COLUMN "Id" SET DEFAULT nextval('public."Tracks_Id_seq"'::regclass);


--
-- Name: VcfTabixAdapter Id; Type: DEFAULT; Schema: public; Owner: swen
--

ALTER TABLE ONLY public."VcfTabixAdapter" ALTER COLUMN "Id" SET DEFAULT nextval('public."VcfTabixAdapter_Id_seq"'::regclass);


--
-- Name: features Id; Type: DEFAULT; Schema: public; Owner: swen
--

ALTER TABLE ONLY public.features ALTER COLUMN "Id" SET DEFAULT nextval('public."features_Id_seq"'::regclass);


--
-- Data for Name: Assemblies; Type: TABLE DATA; Schema: public; Owner: swen
--

COPY public."Assemblies" ("Id", name, aliases, sequence_type, "sequence_trackId", "displayName", "adapterType") FROM stdin;
1	AsparagusCHR_V1.1	{"Asparagus male v1.1"}	ReferenceSequenceTrack	AsparagusCHR_V1.1-ReferenceSequenceTrack	Aspargus officinalis Male assembly v1.1	IndexedFastaAdapter
2	fan_camarosa_v1.0.a1	{}	ReferenceSequenceTrack	fan_camarosa_v1.0.a1-1649075021930	Fragaria x ananassa Camarosa Genome Assembly v1.0	BgzipFastaAdapter
3	Strawberry_NEBNext_targets	{}	ReferenceSequenceTrack	Strawberry_NEBNext_targets-1671537066002	Strawberry NEBNext extended (+250bp) target sequences version [1AKP]	IndexedFastaAdapter
4	Asparagus_V2_EVY	{}	ReferenceSequenceTrack	Asparagus_V2_EVY-1705415138152	Asparagus genome V2 Evy	IndexedFastaAdapter
5	dh_limalexia	{}	ReferenceSequenceTrack	dh_limalexia-1737034294645	DH - Donor Limalexia (V1)	IndexedFastaAdapter
32	AsparagusCHR_V1.1TEST	{TEST}	ReferenceSequenceTrack	AsparagusCHR_V1.1-1743505703173	AsparagusCHR_V1.1TEST	IndexedFastaAdapter
33	AsparagusCHR_V1.1TEST	{TEST}	ReferenceSequenceTrack	AsparagusCHR_V1.1-1743506263060	AsparagusCHR_V1.1TEST	IndexedFastaAdapter
\.


--
-- Data for Name: BamAdapter; Type: TABLE DATA; Schema: public; Owner: swen
--

COPY public."BamAdapter" ("Id", "trackId", "bamLocation", "indexLocation", "sequenceAdapterId", "sequenceAdapterType") FROM stdin;
1	14	data/projects/p68_aardbei_merker_platform/05_analyse_seq_data/01_mapping/NEB_library_18_merged_UMI_consensus_mapped.bam	data/projects/p68_aardbei_merker_platform/05_analyse_seq_data/01_mapping/NEB_library_18_merged_UMI_consensus_mapped.bam.bai	1	BgzipFastaAdapter
2	15	data/projects/p68_aardbei_merker_platform/05_analyse_seq_data/01_mapping/NEB_library_18_paired_UMI_consensus_mapped.bam	data/projects/p68_aardbei_merker_platform/05_analyse_seq_data/01_mapping/NEB_library_18_paired_UMI_consensus_mapped.bam.bai	1	BgzipFastaAdapter
3	17	data/projects/p68_aardbei_merker_platform/05_analyse_seq_data/01_mapping/per_sample_bam/NEB_library_18_merged_UMI_consensus_mapped.KA21-0567.bam	data/projects/p68_aardbei_merker_platform/05_analyse_seq_data/01_mapping/per_sample_bam/NEB_library_18_merged_UMI_consensus_mapped.DH1.bai	1	BgzipFastaAdapter
4	18	data/projects/p68_aardbei_merker_platform/05_analyse_seq_data/01_mapping/per_sample_bam/NEB_library_18_merged_UMI_consensus_mapped.DH2.bam	data/projects/p68_aardbei_merker_platform/05_analyse_seq_data/01_mapping/per_sample_bam/NEB_library_18_merged_UMI_consensus_mapped.DH2.bai	1	BgzipFastaAdapter
5	19	data/projects/p68_aardbei_merker_platform/05_analyse_seq_data/01_mapping/per_sample_bam/NEB_library_18_merged_UMI_consensus_mapped.KA21-0567.bam	data/projects/p68_aardbei_merker_platform/05_analyse_seq_data/01_mapping/per_sample_bam/NEB_library_18_merged_UMI_consensus_mapped.KA21-0567.bai	1	BgzipFastaAdapter
6	20	data/projects/p68_aardbei_merker_platform/05_analyse_seq_data/01_mapping/per_sample_bam/NEB_library_18_merged_UMI_consensus_mapped.KO21A-4541.bam	data/projects/p68_aardbei_merker_platform/05_analyse_seq_data/01_mapping/per_sample_bam/NEB_library_18_merged_UMI_consensus_mapped.KO21A-4541.bai	1	BgzipFastaAdapter
7	21	data/projects/p68_aardbei_merker_platform/05_analyse_seq_data/01_mapping/per_sample_bam/NEB_library_18_merged_UMI_consensus_mapped.LJ21sp-2039.bam	data/projects/p68_aardbei_merker_platform/05_analyse_seq_data/01_mapping/per_sample_bam/NEB_library_18_merged_UMI_consensus_mapped.LJ21sp-2039.bai	1	BgzipFastaAdapter
8	22	data/projects/p68_aardbei_merker_platform/05_analyse_seq_data/01_mapping/per_sample_bam/NEB_library_18_merged_UMI_consensus_mapped.LJ21sp-2518.bam	data/projects/p68_aardbei_merker_platform/05_analyse_seq_data/01_mapping/per_sample_bam/NEB_library_18_merged_UMI_consensus_mapped.LJ21sp-2518.bai	1	BgzipFastaAdapter
9	23	data/projects/p68_aardbei_merker_platform/05_analyse_seq_data/01_mapping/per_sample_bam/NEB_library_18_merged_UMI_consensus_mapped.LJ21sp-2578.bam	data/projects/p68_aardbei_merker_platform/05_analyse_seq_data/01_mapping/per_sample_bam/NEB_library_18_merged_UMI_consensus_mapped.LJ21sp-2578.bai	1	BgzipFastaAdapter
10	24	data/projects/p68_aardbei_merker_platform/05_analyse_seq_data/01_mapping/per_sample_bam/NEB_library_18_merged_UMI_consensus_mapped.LJ21sp-2629.bam	data/projects/p68_aardbei_merker_platform/05_analyse_seq_data/01_mapping/per_sample_bam/NEB_library_18_merged_UMI_consensus_mapped.LJ21sp-2629.bai	1	BgzipFastaAdapter
11	25	data/projects/p68_aardbei_merker_platform/05_analyse_seq_data/01_mapping/per_sample_bam/NEB_library_18_merged_UMI_consensus_mapped.LJ21sp-2649.bam	data/projects/p68_aardbei_merker_platform/05_analyse_seq_data/01_mapping/per_sample_bam/NEB_library_18_merged_UMI_consensus_mapped.LJ21sp-2649.bai	1	BgzipFastaAdapter
12	26	data/projects/p68_aardbei_merker_platform/05_analyse_seq_data/01_mapping/per_sample_bam/NEB_library_18_merged_UMI_consensus_mapped.LJ21sp-2664.bam	data/projects/p68_aardbei_merker_platform/05_analyse_seq_data/01_mapping/per_sample_bam/NEB_library_18_merged_UMI_consensus_mapped.LJ21sp-2664.bai	1	BgzipFastaAdapter
13	27	data/projects/p68_aardbei_merker_platform/05_analyse_seq_data/01_mapping/per_sample_bam/NEB_library_18_merged_UMI_consensus_mapped.LS21sp-2916.bam	data/projects/p68_aardbei_merker_platform/05_analyse_seq_data/01_mapping/per_sample_bam/NEB_library_18_merged_UMI_consensus_mapped.LS21sp-2916.bai	1	BgzipFastaAdapter
14	28	data/projects/p68_aardbei_merker_platform/05_analyse_seq_data/01_mapping/per_sample_bam/NEB_library_18_merged_UMI_consensus_mapped.LS21sp-2921.bam	data/projects/p68_aardbei_merker_platform/05_analyse_seq_data/01_mapping/per_sample_bam/NEB_library_18_merged_UMI_consensus_mapped.LS21sp-2921.bai	1	BgzipFastaAdapter
15	29	data/projects/p68_aardbei_merker_platform/05_analyse_seq_data/01_mapping/per_sample_bam/NEB_library_18_merged_UMI_consensus_mapped.LS21sp-3143.bam	data/projects/p68_aardbei_merker_platform/05_analyse_seq_data/01_mapping/per_sample_bam/NEB_library_18_merged_UMI_consensus_mapped.LS21sp-3143.bai	1	BgzipFastaAdapter
16	30	data/projects/p68_aardbei_merker_platform/05_analyse_seq_data/01_mapping/per_sample_bam/NEB_library_18_merged_UMI_consensus_mapped.LSE21-264.bam	data/projects/p68_aardbei_merker_platform/05_analyse_seq_data/01_mapping/per_sample_bam/NEB_library_18_merged_UMI_consensus_mapped.LSE21-264.bai	1	BgzipFastaAdapter
17	31	data/projects/p68_aardbei_merker_platform/05_analyse_seq_data/01_mapping/per_sample_bam/NEB_library_18_merged_UMI_consensus_mapped.LSE21-585.bam	data/projects/p68_aardbei_merker_platform/05_analyse_seq_data/01_mapping/per_sample_bam/NEB_library_18_merged_UMI_consensus_mapped.LSE21-585.bai	1	BgzipFastaAdapter
18	32	data/projects/p68_aardbei_merker_platform/05_analyse_seq_data/01_mapping/per_sample_bam/NEB_library_18_merged_UMI_consensus_mapped.LSE21-593.bam	data/projects/p68_aardbei_merker_platform/05_analyse_seq_data/01_mapping/per_sample_bam/NEB_library_18_merged_UMI_consensus_mapped.LSE21-593.bai	1	BgzipFastaAdapter
19	33	data/projects/p68_aardbei_merker_platform/05_analyse_seq_data/01_mapping/per_sample_bam/NEB_library_18_merged_UMI_consensus_mapped.LSE21-773.bam	data/projects/p68_aardbei_merker_platform/05_analyse_seq_data/01_mapping/per_sample_bam/NEB_library_18_merged_UMI_consensus_mapped.LSE21-773.bai	1	BgzipFastaAdapter
20	34	data/projects/p68_aardbei_merker_platform/05_analyse_seq_data/01_mapping/per_sample_bam/NEB_library_18_merged_UMI_consensus_mapped.LSE21-820.bam	data/projects/p68_aardbei_merker_platform/05_analyse_seq_data/01_mapping/per_sample_bam/NEB_library_18_merged_UMI_consensus_mapped.LSE21-820.bai	1	BgzipFastaAdapter
21	35	data/projects/p68_aardbei_merker_platform/05_analyse_seq_data/01_mapping/per_sample_bam/NEB_library_18_merged_UMI_consensus_mapped.LSE21-841.bam	data/projects/p68_aardbei_merker_platform/05_analyse_seq_data/01_mapping/per_sample_bam/NEB_library_18_merged_UMI_consensus_mapped.LSE21-841.bai	1	BgzipFastaAdapter
22	43	data/lim-asp11-data/RNA/K30-1/RNA1Aligned.sortedByCoord.out.bam	data/lim-asp11-data/RNA/K30-1/RNA1Aligned.sortedByCoord.out.bam.bai	1	IndexedFastaAdapter
23	44	data/lim-asp11-data/RNA/K30-1/RNA2Aligned.sortedByCoord.out.bam	data/lim-asp11-data/RNA/K30-1/RNA2Aligned.sortedByCoord.out.bam.bai	1	IndexedFastaAdapter
24	45	data/lim-asp11-data/RNA/K30-1/RNA3Aligned.sortedByCoord.out.bam	data/lim-asp11-data/RNA/K30-1/RNA3Aligned.sortedByCoord.out.bam.bai	1	IndexedFastaAdapter
25	46	data/lim-asp11-data/RNA/K30-1/RNA4Aligned.sortedByCoord.out.bam	data/lim-asp11-data/RNA/K30-1/RNA4Aligned.sortedByCoord.out.bam.bai	1	IndexedFastaAdapter
26	47	data/lim-asp11-data/RNA/K30-1/RNA5Aligned.sortedByCoord.out.bam	data/lim-asp11-data/RNA/K30-1/RNA5Aligned.sortedByCoord.out.bam.bai	1	IndexedFastaAdapter
27	48	data/lim-asp11-data/RNA/K30-1/RNA6Aligned.sortedByCoord.out.bam	data/lim-asp11-data/RNA/K30-1/RNA6Aligned.sortedByCoord.out.bam.bai	1	IndexedFastaAdapter
28	49	data/lim-asp11-data/RNA/K30-1/RNA7Aligned.sortedByCoord.out.bam	data/lim-asp11-data/RNA/K30-1/RNA7Aligned.sortedByCoord.out.bam.bai	1	IndexedFastaAdapter
29	50	data/lim-asp11-data/RNA/K30-1/RNA8Aligned.sortedByCoord.out.bam	data/lim-asp11-data/RNA/K30-1/RNA8Aligned.sortedByCoord.out.bam.bai	1	IndexedFastaAdapter
30	75	data/projects/2024/phase-genomics/Strawberry_DHLI_assembly/LimalexiaDh_assembly/LimalexiaDh.hifiToRef.bam	data/projects/2024/phase-genomics/Strawberry_DHLI_assembly/LimalexiaDh_assembly/LimalexiaDh.hifiToRef.bam.bai	4	IndexedFastaAdapter
36	113	data/projects/2024/phase-genomics/Strawberry_DHLI_assembly/LimalexiaDh_assembly/LimalexiaDh.hifiToRef.bam	data/projects/2024/phase-genomics/Strawberry_DHLI_assembly/LimalexiaDh_assembly/LimalexiaDh.hifiToRef.bam.bai	4	IndexedFastaAdapter
\.


--
-- Data for Name: BedTabixAdapter; Type: TABLE DATA; Schema: public; Owner: swen
--

COPY public."BedTabixAdapter" ("Id", "trackId", "bedGzLocation", "indexLocation") FROM stdin;
1	2	data/lim-asp11-data/GBS/NEBDesigns/NEBv1.2/1AKD_inquiry_files/1AKD_design.captured_regions.LG_AsparagusCHR_v1.1.bed.gz	data/lim-asp11-data/GBS/NEBDesigns/NEBv1.2/1AKD_inquiry_files/1AKD_design.captured_regions.LG_AsparagusCHR_v1.1.bed.gz.tbi
2	3	data/lim-asp11-data/GBS/NimblegenDesigns/AsparagusMaleV1/OID4718-AspV0.23/AspV0.23_28nov2018_design_deliverables/AspV0.23_28nov2018_capture_targets.bed.gz	data/lim-asp11-data/GBS/NimblegenDesigns/AsparagusMaleV1/OID4718-AspV0.23/AspV0.23_28nov2018_design_deliverables/AspV0.23_28nov2018_capture_targets.bed.gz.tbi
3	5	data/lim-asp11-data/Annotations/bed/gaps.sorted.bed.gz	data/lim-asp11-data/Annotations/bed/gaps.sorted.bed.gz.tbi
4	9	data/strawberry/fan_camarosa_v1/bed/1AKP_design.captured_regions.1AKP_strawberry.bed.gz	data/strawberry/fan_camarosa_v1/bed/1AKP_design.captured_regions.1AKP_strawberry.bed.gz.tbi
5	40	data/projects/p68_aardbei_merker_platform/05_analyse_seq_data/03_mapping_to_target_ref/NEBNext_direct_target_to_flank_ref.bed.gz	data/projects/p68_aardbei_merker_platform/05_analyse_seq_data/03_mapping_to_target_ref/NEBNext_direct_target_to_flank_ref.bed.gz.tbi
6	41	data/projects/gwas-asp-ad-hoc-2023/05_gwas_hybrid_data/jbrowse/hybrid_stgew_both_jbrowse_bed.bed.gz	data/projects/gwas-asp-ad-hoc-2023/05_gwas_hybrid_data/jbrowse/hybrid_stgew_both_jbrowse_bed.bed.gz.tbi
\.


--
-- Data for Name: BgzipFastaAdapter; Type: TABLE DATA; Schema: public; Owner: swen
--

COPY public."BgzipFastaAdapter" ("Id", "assemblyId", "fastaLocation", "faiLocation", "gziLocation", "metadataLocation") FROM stdin;
1	2	data/strawberry/fan_camarosa_v1/refseq/F_ana_Camarosa_6-28-17.fasta.gz	data/strawberry/fan_camarosa_v1/refseq/F_ana_Camarosa_6-28-17.fasta.gz.fai	data/strawberry/fan_camarosa_v1/refseq/F_ana_Camarosa_6-28-17.fasta.gz.gzi	/path/to/fa.metadata.yaml
\.


--
-- Data for Name: CramAdapter; Type: TABLE DATA; Schema: public; Owner: swen
--

COPY public."CramAdapter" ("Id", "trackId", "cramLocation", "craiLocation", "sequenceAdapterId", "sequenceAdapterType") FROM stdin;
1	10	data/projects/229F1-4527V-slechte-zetting/02_mapping/bam/Pool1-229f1-4527v-slechte-zetting.clean.mapped.cram	data/projects/229F1-4527V-slechte-zetting/02_mapping/bam/Pool1-229f1-4527v-slechte-zetting.clean.mapped.cram.crai	1	IndexedFastaAdapter
2	11	data/projects/229F1-4527V-slechte-zetting/02_mapping/bam/Pool2-229f1-4527v-slechte-zetting.clean.mapped.cram	data/projects/229F1-4527V-slechte-zetting/02_mapping/bam/Pool2-229f1-4527v-slechte-zetting.clean.mapped.cram.crai	1	IndexedFastaAdapter
3	12	data/projects/229F1-4527V-slechte-zetting/02_mapping/bam/Pool3-229f1-4527v-goede-zetting.clean.mapped.cram	data/projects/229F1-4527V-slechte-zetting/02_mapping/bam/Pool3-229f1-4527v-goede-zetting.clean.mapped.cram.crai	1	IndexedFastaAdapter
4	13	data/projects/229F1-4527V-slechte-zetting/02_mapping/bam/Pool4-229f1-4527v-goede-zetting.clean.mapped.cram	data/projects/229F1-4527V-slechte-zetting/02_mapping/bam/Pool4-229f1-4527v-goede-zetting.clean.mapped.cram.crai	1	IndexedFastaAdapter
5	52	data/projects/2023/2023-jki-poty-resistance/01_mapping_variant_calling/output/02_mapping/AO03_06_5.cram	data/projects/2023/2023-jki-poty-resistance/01_mapping_variant_calling/output/02_mapping/AO03_06_5.cram.crai	1	IndexedFastaAdapter
6	53	data/projects/2023/2023-jki-poty-resistance/01_mapping_variant_calling/output/02_mapping/AO183_10_3.cram	data/projects/2023/2023-jki-poty-resistance/01_mapping_variant_calling/output/02_mapping/AO183_10_3.cram.crai	1	IndexedFastaAdapter
7	54	data/projects/2023/2023-jki-poty-resistance/01_mapping_variant_calling/output/02_mapping/AO709_19_3.cram	data/projects/2023/2023-jki-poty-resistance/01_mapping_variant_calling/output/02_mapping/AO709_19_3.cram.crai	1	IndexedFastaAdapter
8	55	data/projects/2023/2023-jki-poty-resistance/01_mapping_variant_calling/output/02_mapping/AO710_19_12.cram	data/projects/2023/2023-jki-poty-resistance/01_mapping_variant_calling/output/02_mapping/AO710_19_12.cram.crai	1	IndexedFastaAdapter
9	56	data/projects/2023/2023-jki-poty-resistance/01_mapping_variant_calling/output/02_mapping/AO710_19_9.cram	data/projects/2023/2023-jki-poty-resistance/01_mapping_variant_calling/output/02_mapping/AO710_19_9.cram.crai	1	IndexedFastaAdapter
10	57	data/projects/2023/2023-jki-poty-resistance/01_mapping_variant_calling/output/02_mapping/AO730_19_5.cram	data/projects/2023/2023-jki-poty-resistance/01_mapping_variant_calling/output/02_mapping/AO730_19_5.cram.crai	1	IndexedFastaAdapter
11	58	data/projects/2023/2023-jki-poty-resistance/01_mapping_variant_calling/output/02_mapping/AO759_19_3.cram	data/projects/2023/2023-jki-poty-resistance/01_mapping_variant_calling/output/02_mapping/AO759_19_3.cram.crai	1	IndexedFastaAdapter
12	59	data/projects/2023/2023-jki-poty-resistance/01_mapping_variant_calling/output/02_mapping/AO779_20_10.cram	data/projects/2023/2023-jki-poty-resistance/01_mapping_variant_calling/output/02_mapping/AO779_20_10.cram.crai	1	IndexedFastaAdapter
13	60	data/projects/2023/2023-jki-poty-resistance/01_mapping_variant_calling/output/02_mapping/AO779_20_16.cram	data/projects/2023/2023-jki-poty-resistance/01_mapping_variant_calling/output/02_mapping/AO779_20_16.cram.crai	1	IndexedFastaAdapter
14	61	data/projects/2023/2023-jki-poty-resistance/01_mapping_variant_calling/output/02_mapping/AO779_20_22.cram	data/projects/2023/2023-jki-poty-resistance/01_mapping_variant_calling/output/02_mapping/AO779_20_22.cram.crai	1	IndexedFastaAdapter
15	62	data/projects/2023/2023-jki-poty-resistance/01_mapping_variant_calling/output/02_mapping/AO779_20_28.cram	data/projects/2023/2023-jki-poty-resistance/01_mapping_variant_calling/output/02_mapping/AO779_20_28.cram.crai	1	IndexedFastaAdapter
16	63	data/projects/2023/2023-jki-poty-resistance/01_mapping_variant_calling/output/02_mapping/AO779_20_34.cram	data/projects/2023/2023-jki-poty-resistance/01_mapping_variant_calling/output/02_mapping/AO779_20_34.cram.crai	1	IndexedFastaAdapter
17	64	data/projects/2023/2023-jki-poty-resistance/01_mapping_variant_calling/output/02_mapping/AO791_20_2.cram	data/projects/2023/2023-jki-poty-resistance/01_mapping_variant_calling/output/02_mapping/AO791_20_2.cram.crai	1	IndexedFastaAdapter
18	65	data/projects/2023/2023-jki-poty-resistance/01_mapping_variant_calling/output/02_mapping/AO807_20_2.cram	data/projects/2023/2023-jki-poty-resistance/01_mapping_variant_calling/output/02_mapping/AO807_20_2.cram.crai	1	IndexedFastaAdapter
19	66	data/projects/2023/2023-jki-poty-resistance/01_mapping_variant_calling/output/02_mapping/AO807_20_7.cram	data/projects/2023/2023-jki-poty-resistance/01_mapping_variant_calling/output/02_mapping/AO807_20_7.cram.crai	1	IndexedFastaAdapter
20	67	data/projects/2023/2023-jki-poty-resistance/01_mapping_variant_calling/output/02_mapping/AO835_20_8.cram	data/projects/2023/2023-jki-poty-resistance/01_mapping_variant_calling/output/02_mapping/AO835_20_8.cram.crai	1	IndexedFastaAdapter
21	68	data/projects/2023/2023-jki-poty-resistance/01_mapping_variant_calling/output/02_mapping/AO871_20_3.cram	data/projects/2023/2023-jki-poty-resistance/01_mapping_variant_calling/output/02_mapping/AO871_20_3.cram.crai	1	IndexedFastaAdapter
22	69	data/projects/2023/2023-jki-poty-resistance/01_mapping_variant_calling/output/02_mapping/AO874_20_11.cram	data/projects/2023/2023-jki-poty-resistance/01_mapping_variant_calling/output/02_mapping/AO874_20_11.cram.crai	1	IndexedFastaAdapter
23	70	data/projects/2023/2023-jki-poty-resistance/01_mapping_variant_calling/output/02_mapping/AO874_20_14.cram	data/projects/2023/2023-jki-poty-resistance/01_mapping_variant_calling/output/02_mapping/AO874_20_14.cram.crai	1	IndexedFastaAdapter
24	71	data/projects/2023/2023-jki-poty-resistance/01_mapping_variant_calling/output/02_mapping/AO874_20_8.cram	data/projects/2023/2023-jki-poty-resistance/01_mapping_variant_calling/output/02_mapping/AO874_20_8.cram.crai	1	IndexedFastaAdapter
25	72	symlinks/jki_samples/sus.cram	symlinks/jki_samples/sus.cram.crai	1	IndexedFastaAdapter
26	73	symlinks/jki_samples/res.cram	symlinks/jki_samples/res.cram.crai	1	IndexedFastaAdapter
\.


--
-- Data for Name: DeltaAdapter; Type: TABLE DATA; Schema: public; Owner: swen
--

COPY public."DeltaAdapter" ("Id", "trackId", "deltaLocation", "assemblyNames") FROM stdin;
1	51	data/projects/2023/2023-asp-pan-genome-evy/genome/03_evaluation_genome/sequence_old_genome/NewRefToOldRef.delta	{AsparagusCHR_V1.1,Asparagus_V2_EVY}
\.


--
-- Data for Name: Displays; Type: TABLE DATA; Schema: public; Owner: swen
--

COPY public."Displays" ("Id", "displayId", "parentId", "parentType", type) FROM stdin;
1	AsparagusCHR_V1.1-ReferenceSequenceTrack-LinearReferenceSequenceDisplay	1	Track	LinearReferenceSequenceDisplay
2	AsparagusCHR_V1.1-ReferenceSequenceTrack-LinearGCContentDisplay	1	Track	LinearGCContentDisplay
3	fan_camarosa_v1.0.a1-1649075021930-LinearReferenceSequenceDisplay	2	Track	LinearReferenceSequenceDisplay
4	fan_camarosa_v1.0.a1-1649075021930-LinearGCContentDisplay	2	Track	LinearGCContentDisplay
5	Strawberry_NEBNext_targets-1671537066002-LinearReferenceSequenceDisplay	3	Track	LinearReferenceSequenceDisplay
6	Strawberry_NEBNext_targets-1671537066002-LinearGCContentDisplay	3	Track	LinearGCContentDisplay
7	Asparagus_V2_EVY-1705415138152-LinearReferenceSequenceDisplay	4	Track	LinearReferenceSequenceDisplay
8	Asparagus_V2_EVY-1705415138152-LinearGCContentDisplay	4	Track	LinearGCContentDisplay
9	dh_limalexia-1737034294645-LinearReferenceSequenceDisplay	5	Track	LinearReferenceSequenceDisplay
10	dh_limalexia-1737034294645-LinearGCContentDisplay	5	Track	LinearGCContentDisplay
11	gene_annotations-1634910154028-LinearBasicDisplay	1	Track	LinearBasicDisplay
12	gene_annotations-1634910154028-LinearArcDisplay	1	Track	LinearArcDisplay
13	gene_annotations-1634910154028-LinearManhattanDisplay	1	Track	LinearManhattanDisplay
14	nebnext_targets_v1.2_(1akd)-LinearBasicDisplay	2	Track	LinearBasicDisplay
15	nebnext_targets_v1.2_(1akd)-LinearArcDisplay	2	Track	LinearArcDisplay
16	nebnext_targets_v1.2_(1akd)-LinearManhattanDisplay	2	Track	LinearManhattanDisplay
17	nimblegen_asp_v0.23_(28_november_2018)-LinearBasicDisplay	3	Track	LinearBasicDisplay
18	nimblegen_asp_v0.23_(28_november_2018)-LinearArcDisplay	3	Track	LinearArcDisplay
19	nimblegen_asp_v0.23_(28_november_2018)-LinearManhattanDisplay	3	Track	LinearManhattanDisplay
20	nimblegen_variants_(juli_2018)-1635147421710-ChordVariantDisplay	4	Track	ChordVariantDisplay
21	nimblegen_variants_(juli_2018)-1635147421710-LinearVariantDisplay	4	Track	LinearVariantDisplay
22	nimblegen_variants_(juli_2018)-1635147421710-LinearPairedArcDisplay	4	Track	LinearPairedArcDisplay
23	reference_assembly_gaps_(asparaguschr_v1.1)-LinearBasicDisplay	5	Track	LinearBasicDisplay
24	reference_assembly_gaps_(asparaguschr_v1.1)-LinearArcDisplay	5	Track	LinearArcDisplay
25	reference_assembly_gaps_(asparaguschr_v1.1)-LinearManhattanDisplay	5	Track	LinearManhattanDisplay
26	wgs_variants_(2016)-1635149698226-ChordVariantDisplay	6	Track	ChordVariantDisplay
27	wgs_variants_(2016)-1635149698226-LinearVariantDisplay	6	Track	LinearVariantDisplay
28	wgs_variants_(2016)-1635149698226-LinearPairedArcDisplay	6	Track	LinearPairedArcDisplay
29	gene_annotation_fxa_v1.2-1649075483525-LinearBasicDisplay	7	Track	LinearBasicDisplay
30	gene_annotation_fxa_v1.2-1649075483525-LinearArcDisplay	7	Track	LinearArcDisplay
31	gene_annotation_fxa_v1.2-1649075483525-LinearManhattanDisplay	7	Track	LinearManhattanDisplay
32	fanasnp_filtered_pruned_&_selected_for_neb_direct-1649076041300-ChordVariantDisplay	8	Track	ChordVariantDisplay
33	fanasnp_filtered_pruned_&_selected_for_neb_direct-1649076041300-LinearVariantDisplay	8	Track	LinearVariantDisplay
34	fanasnp_filtered_pruned_&_selected_for_neb_direct-1649076041300-LinearPairedArcDisplay	8	Track	LinearPairedArcDisplay
35	nebnext.captured_regions.1akp_strawberry-1650630741802-LinearBasicDisplay	9	Track	LinearBasicDisplay
36	nebnext.captured_regions.1akp_strawberry-1650630741802-LinearArcDisplay	9	Track	LinearArcDisplay
37	nebnext.captured_regions.1akp_strawberry-1650630741802-LinearManhattanDisplay	9	Track	LinearManhattanDisplay
38	pool1_229f1-4527v_slechte_zetting-1666944441440-LinearAlignmentsDisplay	10	Track	LinearAlignmentsDisplay
39	pool1_229f1-4527v_slechte_zetting-1666944441440-LinearPileupDisplay	10	Track	LinearPileupDisplay
40	pool1_229f1-4527v_slechte_zetting-1666944441440-LinearSNPCoverageDisplay	10	Track	LinearSNPCoverageDisplay
41	pool1_229f1-4527v_slechte_zetting-1666944441440-LinearReadArcsDisplay	10	Track	LinearReadArcsDisplay
42	pool1_229f1-4527v_slechte_zetting-1666944441440-LinearReadCloudDisplay	10	Track	LinearReadCloudDisplay
43	pool1_229f1-4527v_slechte_zetting-1666944441440-LinearAlignmentsDisplay-1666944555419	11	Track	LinearAlignmentsDisplay
44	pool1_229f1-4527v_slechte_zetting-1666944441440-LinearPileupDisplay-1666944555419	11	Track	LinearPileupDisplay
45	pool1_229f1-4527v_slechte_zetting-1666944441440-LinearSNPCoverageDisplay-1666944555419	11	Track	LinearSNPCoverageDisplay
46	pool1_229f1-4527v_slechte_zetting-1666944441440-1666944555419-LinearReadArcsDisplay	11	Track	LinearReadArcsDisplay
47	pool1_229f1-4527v_slechte_zetting-1666944441440-1666944555419-LinearReadCloudDisplay	11	Track	LinearReadCloudDisplay
48	pool1_229f1-4527v_slechte_zetting-1666944441440-LinearAlignmentsDisplay-1666944555419-1666944652556	12	Track	LinearAlignmentsDisplay
49	pool1_229f1-4527v_slechte_zetting-1666944441440-LinearPileupDisplay-1666944555419-1666944652556	12	Track	LinearPileupDisplay
50	pool1_229f1-4527v_slechte_zetting-1666944441440-LinearSNPCoverageDisplay-1666944555419-1666944652556	12	Track	LinearSNPCoverageDisplay
51	pool1_229f1-4527v_slechte_zetting-1666944441440-1666944555419-1666944652556-LinearReadArcsDisplay	12	Track	LinearReadArcsDisplay
52	pool1_229f1-4527v_slechte_zetting-1666944441440-1666944555419-1666944652556-LinearReadCloudDisplay	12	Track	LinearReadCloudDisplay
53	pool1_229f1-4527v_slechte_zetting-1666944441440-LinearAlignmentsDisplay-1666944555419-1666944652556-1666944812427	13	Track	LinearAlignmentsDisplay
54	pool1_229f1-4527v_slechte_zetting-1666944441440-LinearPileupDisplay-1666944555419-1666944652556-1666944812427	13	Track	LinearPileupDisplay
55	pool1_229f1-4527v_slechte_zetting-1666944441440-LinearSNPCoverageDisplay-1666944555419-1666944652556-1666944812427	13	Track	LinearSNPCoverageDisplay
56	pool1_229f1-4527v_slechte_zetting-1666944441440-1666944555419-1666944652556-1666944812427-LinearReadArcsDisplay	13	Track	LinearReadArcsDisplay
57	pool1_229f1-4527v_slechte_zetting-1666944441440-1666944555419-1666944652556-1666944812427-LinearReadCloudDisplay	13	Track	LinearReadCloudDisplay
58	neb_library_18_merged_umi_consensus_mapped.bam-1667491985375-LinearAlignmentsDisplay	14	Track	LinearAlignmentsDisplay
59	neb_library_18_merged_umi_consensus_mapped.bam-1667491985375-LinearPileupDisplay	14	Track	LinearPileupDisplay
60	neb_library_18_merged_umi_consensus_mapped.bam-1667491985375-LinearSNPCoverageDisplay	14	Track	LinearSNPCoverageDisplay
61	neb_library_18_merged_umi_consensus_mapped.bam-1667491985375-LinearReadArcsDisplay	14	Track	LinearReadArcsDisplay
62	neb_library_18_merged_umi_consensus_mapped.bam-1667491985375-LinearReadCloudDisplay	14	Track	LinearReadCloudDisplay
63	neb_library_18_paired_umi_consensus_mapped.bam-1667547527957-LinearAlignmentsDisplay	15	Track	LinearAlignmentsDisplay
64	neb_library_18_paired_umi_consensus_mapped.bam-1667547527957-LinearPileupDisplay	15	Track	LinearPileupDisplay
65	neb_library_18_paired_umi_consensus_mapped.bam-1667547527957-LinearSNPCoverageDisplay	15	Track	LinearSNPCoverageDisplay
66	neb_library_18_paired_umi_consensus_mapped.bam-1667547527957-LinearReadArcsDisplay	15	Track	LinearReadArcsDisplay
67	neb_library_18_paired_umi_consensus_mapped.bam-1667547527957-LinearReadCloudDisplay	15	Track	LinearReadCloudDisplay
68	dh2.g.vcf-1667915176441-ChordVariantDisplay	16	Track	ChordVariantDisplay
69	dh2.g.vcf-1667915176441-LinearVariantDisplay	16	Track	LinearVariantDisplay
70	dh2.g.vcf-1667915176441-LinearPairedArcDisplay	16	Track	LinearPairedArcDisplay
71	dh1.bam-1668170166181-LinearAlignmentsDisplay	17	Track	LinearAlignmentsDisplay
72	dh1.bam-1668170166181-LinearPileupDisplay	17	Track	LinearPileupDisplay
73	dh1.bam-1668170166181-LinearSNPCoverageDisplay	17	Track	LinearSNPCoverageDisplay
74	dh1.bam-1668170166181-LinearReadArcsDisplay	17	Track	LinearReadArcsDisplay
75	dh1.bam-1668170166181-LinearReadCloudDisplay	17	Track	LinearReadCloudDisplay
76	neb_library_18_merged_umi_consensus_mapped.dh2.bam-1668170455554-LinearAlignmentsDisplay	18	Track	LinearAlignmentsDisplay
77	neb_library_18_merged_umi_consensus_mapped.dh2.bam-1668170455554-LinearPileupDisplay	18	Track	LinearPileupDisplay
78	neb_library_18_merged_umi_consensus_mapped.dh2.bam-1668170455554-LinearSNPCoverageDisplay	18	Track	LinearSNPCoverageDisplay
79	neb_library_18_merged_umi_consensus_mapped.dh2.bam-1668170455554-LinearReadArcsDisplay	18	Track	LinearReadArcsDisplay
80	neb_library_18_merged_umi_consensus_mapped.dh2.bam-1668170455554-LinearReadCloudDisplay	18	Track	LinearReadCloudDisplay
81	neb_library_18_merged_umi_consensus_mapped.ka21-0567.bam-1668171057678-LinearAlignmentsDisplay	19	Track	LinearAlignmentsDisplay
82	neb_library_18_merged_umi_consensus_mapped.ka21-0567.bam-1668171057678-LinearPileupDisplay	19	Track	LinearPileupDisplay
83	neb_library_18_merged_umi_consensus_mapped.ka21-0567.bam-1668171057678-LinearSNPCoverageDisplay	19	Track	LinearSNPCoverageDisplay
84	neb_library_18_merged_umi_consensus_mapped.ka21-0567.bam-1668171057678-LinearReadArcsDisplay	19	Track	LinearReadArcsDisplay
85	neb_library_18_merged_umi_consensus_mapped.ka21-0567.bam-1668171057678-LinearReadCloudDisplay	19	Track	LinearReadCloudDisplay
86	neb_library_18_merged_umi_consensus_mapped.ko21a-4541.bam-1668171076343-LinearAlignmentsDisplay	20	Track	LinearAlignmentsDisplay
87	neb_library_18_merged_umi_consensus_mapped.ko21a-4541.bam-1668171076343-LinearPileupDisplay	20	Track	LinearPileupDisplay
88	neb_library_18_merged_umi_consensus_mapped.ko21a-4541.bam-1668171076343-LinearSNPCoverageDisplay	20	Track	LinearSNPCoverageDisplay
89	neb_library_18_merged_umi_consensus_mapped.ko21a-4541.bam-1668171076343-LinearReadArcsDisplay	20	Track	LinearReadArcsDisplay
90	neb_library_18_merged_umi_consensus_mapped.ko21a-4541.bam-1668171076343-LinearReadCloudDisplay	20	Track	LinearReadCloudDisplay
91	neb_library_18_merged_umi_consensus_mapped.lj21sp-2039.bam-1668171105937-LinearAlignmentsDisplay	21	Track	LinearAlignmentsDisplay
92	neb_library_18_merged_umi_consensus_mapped.lj21sp-2039.bam-1668171105937-LinearPileupDisplay	21	Track	LinearPileupDisplay
93	neb_library_18_merged_umi_consensus_mapped.lj21sp-2039.bam-1668171105937-LinearSNPCoverageDisplay	21	Track	LinearSNPCoverageDisplay
94	neb_library_18_merged_umi_consensus_mapped.lj21sp-2039.bam-1668171105937-LinearReadArcsDisplay	21	Track	LinearReadArcsDisplay
95	neb_library_18_merged_umi_consensus_mapped.lj21sp-2039.bam-1668171105937-LinearReadCloudDisplay	21	Track	LinearReadCloudDisplay
96	neb_library_18_merged_umi_consensus_mapped.lj21sp-2518.bam-1668171210670-LinearAlignmentsDisplay	22	Track	LinearAlignmentsDisplay
97	neb_library_18_merged_umi_consensus_mapped.lj21sp-2518.bam-1668171210670-LinearPileupDisplay	22	Track	LinearPileupDisplay
98	neb_library_18_merged_umi_consensus_mapped.lj21sp-2518.bam-1668171210670-LinearSNPCoverageDisplay	22	Track	LinearSNPCoverageDisplay
99	neb_library_18_merged_umi_consensus_mapped.lj21sp-2518.bam-1668171210670-LinearReadArcsDisplay	22	Track	LinearReadArcsDisplay
100	neb_library_18_merged_umi_consensus_mapped.lj21sp-2518.bam-1668171210670-LinearReadCloudDisplay	22	Track	LinearReadCloudDisplay
101	neb_library_18_merged_umi_consensus_mapped.lj21sp-2578.bam-1668171232397-LinearAlignmentsDisplay	23	Track	LinearAlignmentsDisplay
102	neb_library_18_merged_umi_consensus_mapped.lj21sp-2578.bam-1668171232397-LinearPileupDisplay	23	Track	LinearPileupDisplay
103	neb_library_18_merged_umi_consensus_mapped.lj21sp-2578.bam-1668171232397-LinearSNPCoverageDisplay	23	Track	LinearSNPCoverageDisplay
104	neb_library_18_merged_umi_consensus_mapped.lj21sp-2578.bam-1668171232397-LinearReadArcsDisplay	23	Track	LinearReadArcsDisplay
105	neb_library_18_merged_umi_consensus_mapped.lj21sp-2578.bam-1668171232397-LinearReadCloudDisplay	23	Track	LinearReadCloudDisplay
106	neb_library_18_merged_umi_consensus_mapped.lj21sp-2629.bam-1668171293981-LinearAlignmentsDisplay	24	Track	LinearAlignmentsDisplay
107	neb_library_18_merged_umi_consensus_mapped.lj21sp-2629.bam-1668171293981-LinearPileupDisplay	24	Track	LinearPileupDisplay
108	neb_library_18_merged_umi_consensus_mapped.lj21sp-2629.bam-1668171293981-LinearSNPCoverageDisplay	24	Track	LinearSNPCoverageDisplay
109	neb_library_18_merged_umi_consensus_mapped.lj21sp-2629.bam-1668171293981-LinearReadArcsDisplay	24	Track	LinearReadArcsDisplay
110	neb_library_18_merged_umi_consensus_mapped.lj21sp-2629.bam-1668171293981-LinearReadCloudDisplay	24	Track	LinearReadCloudDisplay
111	neb_library_18_merged_umi_consensus_mapped.lj21sp-2649.bam-1668171316681-LinearAlignmentsDisplay	25	Track	LinearAlignmentsDisplay
112	neb_library_18_merged_umi_consensus_mapped.lj21sp-2649.bam-1668171316681-LinearPileupDisplay	25	Track	LinearPileupDisplay
113	neb_library_18_merged_umi_consensus_mapped.lj21sp-2649.bam-1668171316681-LinearSNPCoverageDisplay	25	Track	LinearSNPCoverageDisplay
114	neb_library_18_merged_umi_consensus_mapped.lj21sp-2649.bam-1668171316681-LinearReadArcsDisplay	25	Track	LinearReadArcsDisplay
115	neb_library_18_merged_umi_consensus_mapped.lj21sp-2649.bam-1668171316681-LinearReadCloudDisplay	25	Track	LinearReadCloudDisplay
116	neb_library_18_merged_umi_consensus_mapped.lj21sp-2664.bam-1668171343445-LinearAlignmentsDisplay	26	Track	LinearAlignmentsDisplay
117	neb_library_18_merged_umi_consensus_mapped.lj21sp-2664.bam-1668171343445-LinearPileupDisplay	26	Track	LinearPileupDisplay
118	neb_library_18_merged_umi_consensus_mapped.lj21sp-2664.bam-1668171343445-LinearSNPCoverageDisplay	26	Track	LinearSNPCoverageDisplay
119	neb_library_18_merged_umi_consensus_mapped.lj21sp-2664.bam-1668171343445-LinearReadArcsDisplay	26	Track	LinearReadArcsDisplay
120	neb_library_18_merged_umi_consensus_mapped.lj21sp-2664.bam-1668171343445-LinearReadCloudDisplay	26	Track	LinearReadCloudDisplay
121	neb_library_18_merged_umi_consensus_mapped.ls21sp-2916.bam-1668171370773-LinearAlignmentsDisplay	27	Track	LinearAlignmentsDisplay
122	neb_library_18_merged_umi_consensus_mapped.ls21sp-2916.bam-1668171370773-LinearPileupDisplay	27	Track	LinearPileupDisplay
123	neb_library_18_merged_umi_consensus_mapped.ls21sp-2916.bam-1668171370773-LinearSNPCoverageDisplay	27	Track	LinearSNPCoverageDisplay
124	neb_library_18_merged_umi_consensus_mapped.ls21sp-2916.bam-1668171370773-LinearReadArcsDisplay	27	Track	LinearReadArcsDisplay
125	neb_library_18_merged_umi_consensus_mapped.ls21sp-2916.bam-1668171370773-LinearReadCloudDisplay	27	Track	LinearReadCloudDisplay
126	neb_library_18_merged_umi_consensus_mapped.ls21sp-2921.bam-1668171394053-LinearAlignmentsDisplay	28	Track	LinearAlignmentsDisplay
127	neb_library_18_merged_umi_consensus_mapped.ls21sp-2921.bam-1668171394053-LinearPileupDisplay	28	Track	LinearPileupDisplay
128	neb_library_18_merged_umi_consensus_mapped.ls21sp-2921.bam-1668171394053-LinearSNPCoverageDisplay	28	Track	LinearSNPCoverageDisplay
129	neb_library_18_merged_umi_consensus_mapped.ls21sp-2921.bam-1668171394053-LinearReadArcsDisplay	28	Track	LinearReadArcsDisplay
130	neb_library_18_merged_umi_consensus_mapped.ls21sp-2921.bam-1668171394053-LinearReadCloudDisplay	28	Track	LinearReadCloudDisplay
131	neb_library_18_merged_umi_consensus_mapped.ls21sp-3143.bam-1668171418909-LinearAlignmentsDisplay	29	Track	LinearAlignmentsDisplay
132	neb_library_18_merged_umi_consensus_mapped.ls21sp-3143.bam-1668171418909-LinearPileupDisplay	29	Track	LinearPileupDisplay
133	neb_library_18_merged_umi_consensus_mapped.ls21sp-3143.bam-1668171418909-LinearSNPCoverageDisplay	29	Track	LinearSNPCoverageDisplay
134	neb_library_18_merged_umi_consensus_mapped.ls21sp-3143.bam-1668171418909-LinearReadArcsDisplay	29	Track	LinearReadArcsDisplay
135	neb_library_18_merged_umi_consensus_mapped.ls21sp-3143.bam-1668171418909-LinearReadCloudDisplay	29	Track	LinearReadCloudDisplay
136	neb_library_18_merged_umi_consensus_mapped.lse21-264.bam-1668171475845-LinearAlignmentsDisplay	30	Track	LinearAlignmentsDisplay
137	neb_library_18_merged_umi_consensus_mapped.lse21-264.bam-1668171475845-LinearPileupDisplay	30	Track	LinearPileupDisplay
138	neb_library_18_merged_umi_consensus_mapped.lse21-264.bam-1668171475845-LinearSNPCoverageDisplay	30	Track	LinearSNPCoverageDisplay
139	neb_library_18_merged_umi_consensus_mapped.lse21-264.bam-1668171475845-LinearReadArcsDisplay	30	Track	LinearReadArcsDisplay
140	neb_library_18_merged_umi_consensus_mapped.lse21-264.bam-1668171475845-LinearReadCloudDisplay	30	Track	LinearReadCloudDisplay
141	neb_library_18_merged_umi_consensus_mapped.lse21-585.bam-1668171506220-LinearAlignmentsDisplay	31	Track	LinearAlignmentsDisplay
142	neb_library_18_merged_umi_consensus_mapped.lse21-585.bam-1668171506220-LinearPileupDisplay	31	Track	LinearPileupDisplay
143	neb_library_18_merged_umi_consensus_mapped.lse21-585.bam-1668171506220-LinearSNPCoverageDisplay	31	Track	LinearSNPCoverageDisplay
144	neb_library_18_merged_umi_consensus_mapped.lse21-585.bam-1668171506220-LinearReadArcsDisplay	31	Track	LinearReadArcsDisplay
145	neb_library_18_merged_umi_consensus_mapped.lse21-585.bam-1668171506220-LinearReadCloudDisplay	31	Track	LinearReadCloudDisplay
146	neb_library_18_merged_umi_consensus_mapped.lse21-593.bam-1668171529325-LinearAlignmentsDisplay	32	Track	LinearAlignmentsDisplay
147	neb_library_18_merged_umi_consensus_mapped.lse21-593.bam-1668171529325-LinearPileupDisplay	32	Track	LinearPileupDisplay
148	neb_library_18_merged_umi_consensus_mapped.lse21-593.bam-1668171529325-LinearSNPCoverageDisplay	32	Track	LinearSNPCoverageDisplay
149	neb_library_18_merged_umi_consensus_mapped.lse21-593.bam-1668171529325-LinearReadArcsDisplay	32	Track	LinearReadArcsDisplay
150	neb_library_18_merged_umi_consensus_mapped.lse21-593.bam-1668171529325-LinearReadCloudDisplay	32	Track	LinearReadCloudDisplay
151	neb_library_18_merged_umi_consensus_mapped.lse21-773.bam-1668171567460-LinearAlignmentsDisplay	33	Track	LinearAlignmentsDisplay
152	neb_library_18_merged_umi_consensus_mapped.lse21-773.bam-1668171567460-LinearPileupDisplay	33	Track	LinearPileupDisplay
153	neb_library_18_merged_umi_consensus_mapped.lse21-773.bam-1668171567460-LinearSNPCoverageDisplay	33	Track	LinearSNPCoverageDisplay
154	neb_library_18_merged_umi_consensus_mapped.lse21-773.bam-1668171567460-LinearReadArcsDisplay	33	Track	LinearReadArcsDisplay
155	neb_library_18_merged_umi_consensus_mapped.lse21-773.bam-1668171567460-LinearReadCloudDisplay	33	Track	LinearReadCloudDisplay
156	neb_library_18_merged_umi_consensus_mapped.lse21-820.bam-1668171588517-LinearAlignmentsDisplay	34	Track	LinearAlignmentsDisplay
157	neb_library_18_merged_umi_consensus_mapped.lse21-820.bam-1668171588517-LinearPileupDisplay	34	Track	LinearPileupDisplay
158	neb_library_18_merged_umi_consensus_mapped.lse21-820.bam-1668171588517-LinearSNPCoverageDisplay	34	Track	LinearSNPCoverageDisplay
159	neb_library_18_merged_umi_consensus_mapped.lse21-820.bam-1668171588517-LinearReadArcsDisplay	34	Track	LinearReadArcsDisplay
160	neb_library_18_merged_umi_consensus_mapped.lse21-820.bam-1668171588517-LinearReadCloudDisplay	34	Track	LinearReadCloudDisplay
161	neb_library_18_merged_umi_consensus_mapped.lse21-841.bam-1668171613340-LinearAlignmentsDisplay	35	Track	LinearAlignmentsDisplay
162	neb_library_18_merged_umi_consensus_mapped.lse21-841.bam-1668171613340-LinearPileupDisplay	35	Track	LinearPileupDisplay
163	neb_library_18_merged_umi_consensus_mapped.lse21-841.bam-1668171613340-LinearSNPCoverageDisplay	35	Track	LinearSNPCoverageDisplay
164	neb_library_18_merged_umi_consensus_mapped.lse21-841.bam-1668171613340-LinearReadArcsDisplay	35	Track	LinearReadArcsDisplay
165	neb_library_18_merged_umi_consensus_mapped.lse21-841.bam-1668171613340-LinearReadCloudDisplay	35	Track	LinearReadCloudDisplay
166	limprimersdec2022.gff.gz-1669987079726-LinearBasicDisplay	36	Track	LinearBasicDisplay
167	limprimersdec2022.gff.gz-1669987079726-LinearArcDisplay	36	Track	LinearArcDisplay
168	limprimersdec2022.gff.gz-1669987079726-LinearManhattanDisplay	36	Track	LinearManhattanDisplay
169	nebnextasparagusofficinalisdb_20221219-1671444378424-LinearVariantDisplay	37	Track	LinearVariantDisplay
170	nebnextasparagusofficinalisdb_20221219-1671444378424-ChordVariantDisplay	37	Track	ChordVariantDisplay
171	nebnextasparagusofficinalisdb_20221219-1671444378424-LinearPairedArcDisplay	37	Track	LinearPairedArcDisplay
172	nebnextasparaguswildrelativesdb_20221219-1671444693319-LinearVariantDisplay	38	Track	LinearVariantDisplay
173	nebnextasparaguswildrelativesdb_20221219-1671444693319-ChordVariantDisplay	38	Track	ChordVariantDisplay
174	nebnextasparaguswildrelativesdb_20221219-1671444693319-LinearPairedArcDisplay	38	Track	LinearPairedArcDisplay
175	NEBNext_targets_vs_fan_camarosa_v1-DotplotDisplay	39	Track	DotplotDisplay
176	NEBNext_targets_vs_fan_camarosa_v1-LinearComparativeDisplay	39	Track	LinearComparativeDisplay
177	NEBNext_targets_vs_fan_camarosa_v1-LinearSyntenyDisplay	39	Track	LinearSyntenyDisplay
178	NEBNext_targets_vs_fan_camarosa_v1-LGVSyntenyDisplay	39	Track	LGVSyntenyDisplay
179	nebnext_direct_target_to_flank_ref.bed.gz-1671698875715-LinearBasicDisplay	40	Track	LinearBasicDisplay
180	nebnext_direct_target_to_flank_ref.bed.gz-1671698875715-LinearArcDisplay	40	Track	LinearArcDisplay
181	nebnext_direct_target_to_flank_ref.bed.gz-1671698875715-LinearManhattanDisplay	40	Track	LinearManhattanDisplay
182	hybrid_stgew_both_jbrowse_bed.bed.gz-1678958982464-LinearManhattanDisplay	41	Track	LinearManhattanDisplay
183	hybrid_stgew_both_jbrowse_bed.bed.gz-1678958982464-LinearBasicDisplay	41	Track	LinearBasicDisplay
184	hybrid_stgew_both_jbrowse_bed.bed.gz-1678958982464-LinearArcDisplay	41	Track	LinearArcDisplay
185	limgroup_old_(lgc)_kasp_targets-1696507354151-LinearBasicDisplay	42	Track	LinearBasicDisplay
186	limgroup_old_(lgc)_kasp_targets-1696507354151-LinearArcDisplay	42	Track	LinearArcDisplay
187	limgroup_old_(lgc)_kasp_targets-1696507354151-LinearManhattanDisplay	42	Track	LinearManhattanDisplay
188	rna1aligned.sortedbycoord.out.bam-1700571776213-LinearAlignmentsDisplay	43	Track	LinearAlignmentsDisplay
189	rna1aligned.sortedbycoord.out.bam-1700571776213-LinearPileupDisplay	43	Track	LinearPileupDisplay
190	rna1aligned.sortedbycoord.out.bam-1700571776213-LinearSNPCoverageDisplay	43	Track	LinearSNPCoverageDisplay
191	rna1aligned.sortedbycoord.out.bam-1700571776213-LinearReadArcsDisplay	43	Track	LinearReadArcsDisplay
192	rna1aligned.sortedbycoord.out.bam-1700571776213-LinearReadCloudDisplay	43	Track	LinearReadCloudDisplay
193	RNA2aligned.sortedbycoord.out.bam-1700571776213-LinearAlignmentsDisplay	44	Track	LinearAlignmentsDisplay
194	RNA2aligned.sortedbycoord.out.bam-1700571776213-LinearPileupDisplay	44	Track	LinearPileupDisplay
195	RNA2aligned.sortedbycoord.out.bam-1700571776213-LinearSNPCoverageDisplay	44	Track	LinearSNPCoverageDisplay
196	RNA2aligned.sortedbycoord.out.bam-1700571776213-LinearReadArcsDisplay	44	Track	LinearReadArcsDisplay
197	RNA2aligned.sortedbycoord.out.bam-1700571776213-LinearReadCloudDisplay	44	Track	LinearReadCloudDisplay
198	RNA3aligned.sortedbycoord.out.bam-1700571776213-LinearAlignmentsDisplay	45	Track	LinearAlignmentsDisplay
199	RNA3aligned.sortedbycoord.out.bam-1700571776213-LinearPileupDisplay	45	Track	LinearPileupDisplay
200	RNA3aligned.sortedbycoord.out.bam-1700571776213-LinearSNPCoverageDisplay	45	Track	LinearSNPCoverageDisplay
201	RNA3aligned.sortedbycoord.out.bam-1700571776213-LinearReadArcsDisplay	45	Track	LinearReadArcsDisplay
202	RNA3aligned.sortedbycoord.out.bam-1700571776213-LinearReadCloudDisplay	45	Track	LinearReadCloudDisplay
203	RNA4aligned.sortedbycoord.out.bam-1700571776213-LinearAlignmentsDisplay	46	Track	LinearAlignmentsDisplay
204	RNA4aligned.sortedbycoord.out.bam-1700571776213-LinearPileupDisplay	46	Track	LinearPileupDisplay
205	RNA4aligned.sortedbycoord.out.bam-1700571776213-LinearSNPCoverageDisplay	46	Track	LinearSNPCoverageDisplay
206	RNA4aligned.sortedbycoord.out.bam-1700571776213-LinearReadArcsDisplay	46	Track	LinearReadArcsDisplay
207	RNA4aligned.sortedbycoord.out.bam-1700571776213-LinearReadCloudDisplay	46	Track	LinearReadCloudDisplay
208	RNA5aligned.sortedbycoord.out.bam-1700571776213-LinearAlignmentsDisplay	47	Track	LinearAlignmentsDisplay
209	RNA5aligned.sortedbycoord.out.bam-1700571776213-LinearPileupDisplay	47	Track	LinearPileupDisplay
210	RNA5aligned.sortedbycoord.out.bam-1700571776213-LinearSNPCoverageDisplay	47	Track	LinearSNPCoverageDisplay
211	RNA5aligned.sortedbycoord.out.bam-1700571776213-LinearReadArcsDisplay	47	Track	LinearReadArcsDisplay
212	RNA5aligned.sortedbycoord.out.bam-1700571776213-LinearReadCloudDisplay	47	Track	LinearReadCloudDisplay
213	RNA6aligned.sortedbycoord.out.bam-1700571776213-LinearAlignmentsDisplay	48	Track	LinearAlignmentsDisplay
214	RNA6aligned.sortedbycoord.out.bam-1700571776213-LinearPileupDisplay	48	Track	LinearPileupDisplay
215	RNA6aligned.sortedbycoord.out.bam-1700571776213-LinearSNPCoverageDisplay	48	Track	LinearSNPCoverageDisplay
216	RNA6aligned.sortedbycoord.out.bam-1700571776213-LinearReadArcsDisplay	48	Track	LinearReadArcsDisplay
217	RNA6aligned.sortedbycoord.out.bam-1700571776213-LinearReadCloudDisplay	48	Track	LinearReadCloudDisplay
218	RNA7aligned.sortedbycoord.out.bam-1700571776213-LinearAlignmentsDisplay	49	Track	LinearAlignmentsDisplay
219	RNA7aligned.sortedbycoord.out.bam-1700571776213-LinearPileupDisplay	49	Track	LinearPileupDisplay
220	RNA7aligned.sortedbycoord.out.bam-1700571776213-LinearSNPCoverageDisplay	49	Track	LinearSNPCoverageDisplay
221	RNA7aligned.sortedbycoord.out.bam-1700571776213-LinearReadArcsDisplay	49	Track	LinearReadArcsDisplay
222	RNA7aligned.sortedbycoord.out.bam-1700571776213-LinearReadCloudDisplay	49	Track	LinearReadCloudDisplay
223	RNA8aligned.sortedbycoord.out.bam-1700571776213-LinearAlignmentsDisplay	50	Track	LinearAlignmentsDisplay
224	RNA8aligned.sortedbycoord.out.bam-1700571776213-LinearPileupDisplay	50	Track	LinearPileupDisplay
225	RNA8aligned.sortedbycoord.out.bam-1700571776213-LinearSNPCoverageDisplay	50	Track	LinearSNPCoverageDisplay
226	RNA8aligned.sortedbycoord.out.bam-1700571776213-LinearReadArcsDisplay	50	Track	LinearReadArcsDisplay
227	RNA8aligned.sortedbycoord.out.bam-1700571776213-LinearReadCloudDisplay	50	Track	LinearReadCloudDisplay
228	aspV1vsV2-DotplotDisplay	51	Track	DotplotDisplay
229	aspV1vsV2-LinearComparativeDisplay	51	Track	LinearComparativeDisplay
230	aspV1vsV2-LinearSyntenyDisplay	51	Track	LinearSyntenyDisplay
231	aspV1vsV2-LGVSyntenyDisplay	51	Track	LGVSyntenyDisplay
232	ao03_06_5.cram-1709823225117-LinearAlignmentsDisplay	52	Track	LinearAlignmentsDisplay
233	ao03_06_5.cram-1709823225117-LinearPileupDisplay	52	Track	LinearPileupDisplay
234	ao03_06_5.cram-1709823225117-LinearSNPCoverageDisplay	52	Track	LinearSNPCoverageDisplay
235	ao03_06_5.cram-1709823225117-LinearReadArcsDisplay	52	Track	LinearReadArcsDisplay
236	ao03_06_5.cram-1709823225117-LinearReadCloudDisplay	52	Track	LinearReadCloudDisplay
237	pros_ao183_10_3.cram-1709823291422-LinearAlignmentsDisplay	53	Track	LinearAlignmentsDisplay
238	pros_ao183_10_3.cram-1709823291422-LinearPileupDisplay	53	Track	LinearPileupDisplay
239	pros_ao183_10_3.cram-1709823291422-LinearSNPCoverageDisplay	53	Track	LinearSNPCoverageDisplay
240	pros_ao183_10_3.cram-1709823291422-LinearReadArcsDisplay	53	Track	LinearReadArcsDisplay
241	pros_ao183_10_3.cram-1709823291422-LinearReadCloudDisplay	53	Track	LinearReadCloudDisplay
242	res_ao709_19_3.cram-1709823346664-LinearAlignmentsDisplay	54	Track	LinearAlignmentsDisplay
243	res_ao709_19_3.cram-1709823346664-LinearPileupDisplay	54	Track	LinearPileupDisplay
244	res_ao709_19_3.cram-1709823346664-LinearSNPCoverageDisplay	54	Track	LinearSNPCoverageDisplay
245	res_ao709_19_3.cram-1709823346664-LinearReadArcsDisplay	54	Track	LinearReadArcsDisplay
246	res_ao709_19_3.cram-1709823346664-LinearReadCloudDisplay	54	Track	LinearReadCloudDisplay
247	sus_ao710_19_12.cram-1709823418213-LinearAlignmentsDisplay	55	Track	LinearAlignmentsDisplay
248	sus_ao710_19_12.cram-1709823418213-LinearPileupDisplay	55	Track	LinearPileupDisplay
249	sus_ao710_19_12.cram-1709823418213-LinearSNPCoverageDisplay	55	Track	LinearSNPCoverageDisplay
250	sus_ao710_19_12.cram-1709823418213-LinearReadArcsDisplay	55	Track	LinearReadArcsDisplay
251	sus_ao710_19_12.cram-1709823418213-LinearReadCloudDisplay	55	Track	LinearReadCloudDisplay
252	sus_ao710_19_9-1709825669576-LinearAlignmentsDisplay	56	Track	LinearAlignmentsDisplay
253	sus_ao710_19_9-1709825669576-LinearPileupDisplay	56	Track	LinearPileupDisplay
254	sus_ao710_19_9-1709825669576-LinearSNPCoverageDisplay	56	Track	LinearSNPCoverageDisplay
255	sus_ao710_19_9-1709825669576-LinearReadArcsDisplay	56	Track	LinearReadArcsDisplay
256	sus_ao710_19_9-1709825669576-LinearReadCloudDisplay	56	Track	LinearReadCloudDisplay
257	sus_ao730_19_5-1709825717307-LinearAlignmentsDisplay	57	Track	LinearAlignmentsDisplay
258	sus_ao730_19_5-1709825717307-LinearPileupDisplay	57	Track	LinearPileupDisplay
259	sus_ao730_19_5-1709825717307-LinearSNPCoverageDisplay	57	Track	LinearSNPCoverageDisplay
260	sus_ao730_19_5-1709825717307-LinearReadArcsDisplay	57	Track	LinearReadArcsDisplay
261	sus_ao730_19_5-1709825717307-LinearReadCloudDisplay	57	Track	LinearReadCloudDisplay
262	res_ao759_19_3-1709825766284-LinearAlignmentsDisplay	58	Track	LinearAlignmentsDisplay
263	res_ao759_19_3-1709825766284-LinearPileupDisplay	58	Track	LinearPileupDisplay
264	res_ao759_19_3-1709825766284-LinearSNPCoverageDisplay	58	Track	LinearSNPCoverageDisplay
265	res_ao759_19_3-1709825766284-LinearReadArcsDisplay	58	Track	LinearReadArcsDisplay
266	res_ao759_19_3-1709825766284-LinearReadCloudDisplay	58	Track	LinearReadCloudDisplay
267	res_ao779_20_10-1709825868049-LinearAlignmentsDisplay	59	Track	LinearAlignmentsDisplay
268	res_ao779_20_10-1709825868049-LinearPileupDisplay	59	Track	LinearPileupDisplay
269	res_ao779_20_10-1709825868049-LinearSNPCoverageDisplay	59	Track	LinearSNPCoverageDisplay
270	res_ao779_20_10-1709825868049-LinearReadArcsDisplay	59	Track	LinearReadArcsDisplay
271	res_ao779_20_10-1709825868049-LinearReadCloudDisplay	59	Track	LinearReadCloudDisplay
272	res_ao779_20_16-1709825954079-LinearAlignmentsDisplay	60	Track	LinearAlignmentsDisplay
273	res_ao779_20_16-1709825954079-LinearPileupDisplay	60	Track	LinearPileupDisplay
274	res_ao779_20_16-1709825954079-LinearSNPCoverageDisplay	60	Track	LinearSNPCoverageDisplay
275	res_ao779_20_16-1709825954079-LinearReadArcsDisplay	60	Track	LinearReadArcsDisplay
276	res_ao779_20_16-1709825954079-LinearReadCloudDisplay	60	Track	LinearReadCloudDisplay
277	res_ao779_20_22-1709827019240-LinearAlignmentsDisplay	61	Track	LinearAlignmentsDisplay
278	res_ao779_20_22-1709827019240-LinearPileupDisplay	61	Track	LinearPileupDisplay
279	res_ao779_20_22-1709827019240-LinearSNPCoverageDisplay	61	Track	LinearSNPCoverageDisplay
280	res_ao779_20_22-1709827019240-LinearReadArcsDisplay	61	Track	LinearReadArcsDisplay
281	res_ao779_20_22-1709827019240-LinearReadCloudDisplay	61	Track	LinearReadCloudDisplay
282	sus_ao779_20_28-1709827172204-LinearAlignmentsDisplay	62	Track	LinearAlignmentsDisplay
283	sus_ao779_20_28-1709827172204-LinearPileupDisplay	62	Track	LinearPileupDisplay
284	sus_ao779_20_28-1709827172204-LinearSNPCoverageDisplay	62	Track	LinearSNPCoverageDisplay
285	sus_ao779_20_28-1709827172204-LinearReadArcsDisplay	62	Track	LinearReadArcsDisplay
286	sus_ao779_20_28-1709827172204-LinearReadCloudDisplay	62	Track	LinearReadCloudDisplay
287	sus_ao779_20_34-1709827201684-LinearAlignmentsDisplay	63	Track	LinearAlignmentsDisplay
288	sus_ao779_20_34-1709827201684-LinearPileupDisplay	63	Track	LinearPileupDisplay
289	sus_ao779_20_34-1709827201684-LinearSNPCoverageDisplay	63	Track	LinearSNPCoverageDisplay
290	sus_ao779_20_34-1709827201684-LinearReadArcsDisplay	63	Track	LinearReadArcsDisplay
291	sus_ao779_20_34-1709827201684-LinearReadCloudDisplay	63	Track	LinearReadCloudDisplay
292	res_ao791_20_2-1709827262217-LinearAlignmentsDisplay	64	Track	LinearAlignmentsDisplay
293	res_ao791_20_2-1709827262217-LinearPileupDisplay	64	Track	LinearPileupDisplay
294	res_ao791_20_2-1709827262217-LinearSNPCoverageDisplay	64	Track	LinearSNPCoverageDisplay
295	res_ao791_20_2-1709827262217-LinearReadArcsDisplay	64	Track	LinearReadArcsDisplay
296	res_ao791_20_2-1709827262217-LinearReadCloudDisplay	64	Track	LinearReadCloudDisplay
297	res_ao807_20_2-1709827317759-LinearAlignmentsDisplay	65	Track	LinearAlignmentsDisplay
298	res_ao807_20_2-1709827317759-LinearPileupDisplay	65	Track	LinearPileupDisplay
299	res_ao807_20_2-1709827317759-LinearSNPCoverageDisplay	65	Track	LinearSNPCoverageDisplay
300	res_ao807_20_2-1709827317759-LinearReadArcsDisplay	65	Track	LinearReadArcsDisplay
301	res_ao807_20_2-1709827317759-LinearReadCloudDisplay	65	Track	LinearReadCloudDisplay
302	res_ao807_20_7-1709827376961-LinearAlignmentsDisplay	66	Track	LinearAlignmentsDisplay
303	res_ao807_20_7-1709827376961-LinearPileupDisplay	66	Track	LinearPileupDisplay
304	res_ao807_20_7-1709827376961-LinearSNPCoverageDisplay	66	Track	LinearSNPCoverageDisplay
305	res_ao807_20_7-1709827376961-LinearReadArcsDisplay	66	Track	LinearReadArcsDisplay
306	res_ao807_20_7-1709827376961-LinearReadCloudDisplay	66	Track	LinearReadCloudDisplay
307	res_ao835_20_8-1709827451420-LinearAlignmentsDisplay	67	Track	LinearAlignmentsDisplay
308	res_ao835_20_8-1709827451420-LinearPileupDisplay	67	Track	LinearPileupDisplay
309	res_ao835_20_8-1709827451420-LinearSNPCoverageDisplay	67	Track	LinearSNPCoverageDisplay
310	res_ao835_20_8-1709827451420-LinearReadArcsDisplay	67	Track	LinearReadArcsDisplay
311	res_ao835_20_8-1709827451420-LinearReadCloudDisplay	67	Track	LinearReadCloudDisplay
312	sus_ao871_20_3-1709827498172-LinearAlignmentsDisplay	68	Track	LinearAlignmentsDisplay
313	sus_ao871_20_3-1709827498172-LinearPileupDisplay	68	Track	LinearPileupDisplay
314	sus_ao871_20_3-1709827498172-LinearSNPCoverageDisplay	68	Track	LinearSNPCoverageDisplay
315	sus_ao871_20_3-1709827498172-LinearReadArcsDisplay	68	Track	LinearReadArcsDisplay
316	sus_ao871_20_3-1709827498172-LinearReadCloudDisplay	68	Track	LinearReadCloudDisplay
317	res_ao874_20_11-1709827593705-LinearAlignmentsDisplay	69	Track	LinearAlignmentsDisplay
318	res_ao874_20_11-1709827593705-LinearPileupDisplay	69	Track	LinearPileupDisplay
319	res_ao874_20_11-1709827593705-LinearSNPCoverageDisplay	69	Track	LinearSNPCoverageDisplay
320	res_ao874_20_11-1709827593705-LinearReadArcsDisplay	69	Track	LinearReadArcsDisplay
321	res_ao874_20_11-1709827593705-LinearReadCloudDisplay	69	Track	LinearReadCloudDisplay
322	sus_ao874_20_14-1709827677918-LinearAlignmentsDisplay	70	Track	LinearAlignmentsDisplay
323	sus_ao874_20_14-1709827677918-LinearPileupDisplay	70	Track	LinearPileupDisplay
324	sus_ao874_20_14-1709827677918-LinearSNPCoverageDisplay	70	Track	LinearSNPCoverageDisplay
325	sus_ao874_20_14-1709827677918-LinearReadArcsDisplay	70	Track	LinearReadArcsDisplay
326	sus_ao874_20_14-1709827677918-LinearReadCloudDisplay	70	Track	LinearReadCloudDisplay
327	res_ao874_20_8-1709827709998-LinearAlignmentsDisplay	71	Track	LinearAlignmentsDisplay
328	res_ao874_20_8-1709827709998-LinearPileupDisplay	71	Track	LinearPileupDisplay
329	res_ao874_20_8-1709827709998-LinearSNPCoverageDisplay	71	Track	LinearSNPCoverageDisplay
330	res_ao874_20_8-1709827709998-LinearReadArcsDisplay	71	Track	LinearReadArcsDisplay
331	res_ao874_20_8-1709827709998-LinearReadCloudDisplay	71	Track	LinearReadCloudDisplay
332	jki_sus_pooled_displ	72	Track	LinearSNPCoverageDisplay
333	jki_sus_pooled-LinearAlignmentsDisplay	72	Track	LinearAlignmentsDisplay
334	jki_sus_pooled-LinearPileupDisplay	72	Track	LinearPileupDisplay
335	jki_sus_pooled-LinearReadArcsDisplay	72	Track	LinearReadArcsDisplay
336	jki_sus_pooled-LinearReadCloudDisplay	72	Track	LinearReadCloudDisplay
337	jki_res_pooled_displ	73	Track	LinearSNPCoverageDisplay
338	jki_res_pooled-LinearAlignmentsDisplay	73	Track	LinearAlignmentsDisplay
339	jki_res_pooled-LinearPileupDisplay	73	Track	LinearPileupDisplay
340	jki_res_pooled-LinearReadArcsDisplay	73	Track	LinearReadArcsDisplay
341	jki_res_pooled-LinearReadCloudDisplay	73	Track	LinearReadCloudDisplay
342	jki_bsa_all_samples-LinearVariantDisplay	74	Track	LinearVariantDisplay
343	jki_bsa_all_samples-ChordVariantDisplay	74	Track	ChordVariantDisplay
344	jki_bsa_all_samples-LinearPairedArcDisplay	74	Track	LinearPairedArcDisplay
345	limalexiadh.hifitoref.bam-1737034584532-LinearAlignmentsDisplay	75	Track	LinearAlignmentsDisplay
346	limalexiadh.hifitoref.bam-1737034584532-LinearPileupDisplay	75	Track	LinearPileupDisplay
347	limalexiadh.hifitoref.bam-1737034584532-LinearSNPCoverageDisplay	75	Track	LinearSNPCoverageDisplay
348	limalexiadh.hifitoref.bam-1737034584532-LinearReadArcsDisplay	75	Track	LinearReadArcsDisplay
349	limalexiadh.hifitoref.bam-1737034584532-LinearReadCloudDisplay	75	Track	LinearReadCloudDisplay
405	LimalexiaDh.hifiToRef-1743492864158-LinearAlignmentsDisplay	111	Track	LinearAlignmentsDisplay
406	LimalexiaDh.hifiToRef-1743492864158-LinearAlignmentsDisplay	112	Track	LinearAlignmentsDisplay
407	LimalexiaDh.hifiToRef-1743493557816-LinearAlignmentsDisplay	113	Track	LinearAlignmentsDisplay
417	AsparagusCHR_V1.1-1743505703173-LinearReferenceSequenceDisplay	32	Track	LinearReferenceSequenceDisplay
418	AsparagusCHR_V1.1-1743506263060-LinearReferenceSequenceDisplay	33	Track	LinearReferenceSequenceDisplay
\.


--
-- Data for Name: Gff3TabixAdapter; Type: TABLE DATA; Schema: public; Owner: swen
--

COPY public."Gff3TabixAdapter" ("Id", "trackId", "gffGzLocation", "indexLocation") FROM stdin;
1	1	data/lim-asp11-data/Annotations/gff3/gff_annotv0.2.edit.gff3.gz	data/lim-asp11-data/Annotations/gff3/gff_annotv0.2.edit.gff3.gz.tbi
2	7	data/strawberry/fan_camarosa_v1/gff/Fxa_v1.2_makerStandard_MakerGenes_woTposases_sorted.gff.gz	data/strawberry/fan_camarosa_v1/gff/Fxa_v1.2_makerStandard_MakerGenes_woTposases_sorted.gff.gz.tbi
3	36	data/projects/limgroup-primers/latest/LimPrimersAsperge.gff.gz	data/projects/limgroup-primers/latest/LimPrimersAsperge.gff.gz.tbi
4	42	data/lim-asp11-data/LimgroupPrimers/LimKASP_Primers_old.gff.gz	data/lim-asp11-data/LimgroupPrimers/LimKASP_Primers_old.gff.gz.tbi
\.


--
-- Data for Name: IndexedFastaAdapter; Type: TABLE DATA; Schema: public; Owner: swen
--

COPY public."IndexedFastaAdapter" ("Id", "assemblyId", "fastaLocation", "faiLocation", "metadataLocation") FROM stdin;
1	1	data/lim-asp11-data/refseq/AsparagusCHR_V1.1.fa	data/lim-asp11-data/refseq/AsparagusCHR_V1.1.fa.fai	/path/to/fa.metadata.yaml
2	3	data/projects/p68_aardbei_merker_platform/05_analyse_seq_data/03_mapping_to_target_ref/NEBNext_target_flanks.fasta	data/projects/p68_aardbei_merker_platform/05_analyse_seq_data/03_mapping_to_target_ref/NEBNext_target_flanks.fasta.fai	/path/to/fa.metadata.yaml
3	4	data/projects/2023/2023-asp-pan-genome-evy/results/genome/Asparagus_V2_EVY.fasta	data/projects/2023/2023-asp-pan-genome-evy/results/genome/Asparagus_V2_EVY.fasta.fai	/path/to/fa.metadata.yaml
4	5	data/projects/2024/phase-genomics/Strawberry_DHLI_assembly/LimalexiaDh_assembly/LimalexiaDhPlusOrganel.fa	data/projects/2024/phase-genomics/Strawberry_DHLI_assembly/LimalexiaDh_assembly/LimalexiaDhPlusOrganel.fa.fai	/path/to/fa.metadata.yaml
26	32	data/lim-asp11-data/refseq/AsparagusCHR_V1.1.fa	data/lim-asp11-data/refseq/AsparagusCHR_V1.1.fa.fai	/path/to/fa.metadata.yaml
27	33	data/lim-asp11-data/refseq/AsparagusCHR_V1.1.fa	data/lim-asp11-data/refseq/AsparagusCHR_V1.1.fa.fai	/path/to/fa.metadata.yaml
\.


--
-- Data for Name: PAFAdapter; Type: TABLE DATA; Schema: public; Owner: swen
--

COPY public."PAFAdapter" ("Id", "trackId", "pafLocation", "assemblyNames") FROM stdin;
1	39	data/projects/p68_aardbei_merker_platform/05_analyse_seq_data/03_mapping_to_target_ref/NEBNext_targets_vs_fan_camarosa_v1.paf	{fan_camarosa_v1.0.a1,Strawberry_NEBNext_targets}
\.


--
-- Data for Name: RefNameAlias; Type: TABLE DATA; Schema: public; Owner: swen
--

COPY public."RefNameAlias" ("Id", "assemblyId", "adapterType", "adapterId") FROM stdin;
1	1	FromConfigAdapter	W6DyPGJ0UU
\.


--
-- Data for Name: Renderer; Type: TABLE DATA; Schema: public; Owner: swen
--

COPY public."Renderer" (id, "DisplaysId", "rendererKey", type, "rendererDetails") FROM stdin;
1	1	renderer	DivSequenceRenderer	{"type": "DivSequenceRenderer", "height": 15}
2	11	renderer	SvgFeatureRenderer	{"type": "SvgFeatureRenderer", "labels": {"fontSize": 11, "description": "jexl:get(feature,'desc_refseq') || get(feature,'description')"}}
3	14	renderer	SvgFeatureRenderer	{"type": "SvgFeatureRenderer", "showLabels": false}
4	17	renderer	SvgFeatureRenderer	{"type": "SvgFeatureRenderer", "showLabels": false, "showDescriptions": false}
5	21	renderer	SvgFeatureRenderer	{"type": "SvgFeatureRenderer", "labels": {"fontSize": 10}}
6	23	renderer	SvgFeatureRenderer	{"type": "SvgFeatureRenderer", "color1": "rgb(0,0,0,1)", "showLabels": false, "showDescriptions": false}
7	27	renderer	SvgFeatureRenderer	{"type": "SvgFeatureRenderer", "labels": {"fontSize": 10}}
8	182	LinearManhattanRenderer	LinearManhattanRenderer	{"type": "LinearManhattanRenderer", "color": "jexl:get(feature,'score')>=50?'blue':'#AAAAAA'"}
\.


--
-- Data for Name: Tracks; Type: TABLE DATA; Schema: public; Owner: swen
--

COPY public."Tracks" ("Id", "trackId", type, name, "assemblyNames", category, "adapterType") FROM stdin;
1	gene_annotations-1634910154028	FeatureTrack	Gene annotations	{AsparagusCHR_V1.1}	{"Reference annotation"}	Gff3TabixAdapter
2	nebnext_targets_v1.2_(1akd)	FeatureTrack	NEBNext targets v1.2 (1AKD)	{AsparagusCHR_V1.1}	{"GBS - NEBNext"}	BedTabixAdapter
3	nimblegen_asp_v0.23_(28_november_2018)	FeatureTrack	Nimblegen targets v0.23 (28 November 2018)	{AsparagusCHR_V1.1}	{"GBS - Nimblegen"}	BedTabixAdapter
4	nimblegen_variants_(juli_2018)-1635147421710	VariantTrack	Nimblegen variants (Juli 2018)	{AsparagusCHR_V1.1}	{"GBS - Nimblegen"}	VcfTabixAdapter
5	reference_assembly_gaps_(asparaguschr_v1.1)	FeatureTrack	Assembly gaps	{AsparagusCHR_V1.1}	{"Reference annotation"}	BedTabixAdapter
6	wgs_variants_(2016)-1635149698226	VariantTrack	WGS variants (2016)	{AsparagusCHR_V1.1}	{"WGS - Illumina short reads"}	VcfTabixAdapter
7	gene_annotation_fxa_v1.2-1649075483525	FeatureTrack	Gene annotation Fxa_v1.2	{fan_camarosa_v1.0.a1}	{}	Gff3TabixAdapter
8	fanasnp_filtered_pruned_&_selected_for_neb_direct-1649076041300	VariantTrack	fanaSNP filtered pruned & selected for NEB Direct	{fan_camarosa_v1.0.a1}	{}	VcfTabixAdapter
9	nebnext.captured_regions.1akp_strawberry-1650630741802	FeatureTrack	NEBNext.captured_regions.1AKP_strawberry	{fan_camarosa_v1.0.a1}	{"GBS - NEBNext"}	BedTabixAdapter
10	pool1_229f1-4527v_slechte_zetting-1666944441440	AlignmentsTrack	Pool1 229f1-4527v slechte zetting	{AsparagusCHR_V1.1}	{"Pool WGS sequencing","229f1-4527v slechte zetting"}	CramAdapter
11	pool1_229f1-4527v_slechte_zetting-1666944441440-1666944555419	AlignmentsTrack	Pool2 229f1-4527v slechte zetting	{AsparagusCHR_V1.1}	{"Pool WGS sequencing","229f1-4527v slechte zetting"}	CramAdapter
12	pool1_229f1-4527v_slechte_zetting-1666944441440-1666944555419-1666944652556	AlignmentsTrack	Pool3 229f1-4527v goede zetting	{AsparagusCHR_V1.1}	{"Pool WGS sequencing","229f1-4527v slechte zetting"}	CramAdapter
13	pool1_229f1-4527v_slechte_zetting-1666944441440-1666944555419-1666944652556-1666944812427	AlignmentsTrack	Pool4 229f1-4527v goede zetting	{AsparagusCHR_V1.1}	{"Pool WGS sequencing","229f1-4527v slechte zetting"}	CramAdapter
14	neb_library_18_merged_umi_consensus_mapped.bam-1667491985375	AlignmentsTrack	NEB_library_18_merged_UMI_consensus_mapped.bam	{fan_camarosa_v1.0.a1}	{"GBS - NEBNext"}	BamAdapter
15	neb_library_18_paired_umi_consensus_mapped.bam-1667547527957	AlignmentsTrack	NEB_library_18_paired_UMI_consensus_mapped.bam	{fan_camarosa_v1.0.a1}	{"GBS - NEBNext"}	BamAdapter
16	dh2.g.vcf-1667915176441	VariantTrack	DH2.g.vcf	{fan_camarosa_v1.0.a1}	{"GBS - NEBNext"}	VcfTabixAdapter
17	dh1.bam-1668170166181	AlignmentsTrack	DH1.bam	{fan_camarosa_v1.0.a1}	{}	BamAdapter
18	neb_library_18_merged_umi_consensus_mapped.dh2.bam-1668170455554	AlignmentsTrack	NEB_library_18_merged_UMI_consensus_mapped.DH2.bam	{fan_camarosa_v1.0.a1}	{}	BamAdapter
19	neb_library_18_merged_umi_consensus_mapped.ka21-0567.bam-1668171057678	AlignmentsTrack	NEB_library_18_merged_UMI_consensus_mapped.KA21-0567.bam	{fan_camarosa_v1.0.a1}	{}	BamAdapter
20	neb_library_18_merged_umi_consensus_mapped.ko21a-4541.bam-1668171076343	AlignmentsTrack	NEB_library_18_merged_UMI_consensus_mapped.KO21A-4541.bam	{fan_camarosa_v1.0.a1}	{}	BamAdapter
21	neb_library_18_merged_umi_consensus_mapped.lj21sp-2039.bam-1668171105937	AlignmentsTrack	NEB_library_18_merged_UMI_consensus_mapped.LJ21sp-2039.bam	{fan_camarosa_v1.0.a1}	{}	BamAdapter
22	neb_library_18_merged_umi_consensus_mapped.lj21sp-2518.bam-1668171210670	AlignmentsTrack	NEB_library_18_merged_UMI_consensus_mapped.LJ21sp-2518.bam	{fan_camarosa_v1.0.a1}	{}	BamAdapter
23	neb_library_18_merged_umi_consensus_mapped.lj21sp-2578.bam-1668171232397	AlignmentsTrack	NEB_library_18_merged_UMI_consensus_mapped.LJ21sp-2578.bam	{fan_camarosa_v1.0.a1}	{}	BamAdapter
24	neb_library_18_merged_umi_consensus_mapped.lj21sp-2629.bam-1668171293981	AlignmentsTrack	NEB_library_18_merged_UMI_consensus_mapped.LJ21sp-2629.bam	{fan_camarosa_v1.0.a1}	{}	BamAdapter
25	neb_library_18_merged_umi_consensus_mapped.lj21sp-2649.bam-1668171316681	AlignmentsTrack	NEB_library_18_merged_UMI_consensus_mapped.LJ21sp-2649.bam	{fan_camarosa_v1.0.a1}	{}	BamAdapter
26	neb_library_18_merged_umi_consensus_mapped.lj21sp-2664.bam-1668171343445	AlignmentsTrack	NEB_library_18_merged_UMI_consensus_mapped.LJ21sp-2664.bam	{fan_camarosa_v1.0.a1}	{}	BamAdapter
27	neb_library_18_merged_umi_consensus_mapped.ls21sp-2916.bam-1668171370773	AlignmentsTrack	NEB_library_18_merged_UMI_consensus_mapped.LS21sp-2916.bam	{fan_camarosa_v1.0.a1}	{}	BamAdapter
28	neb_library_18_merged_umi_consensus_mapped.ls21sp-2921.bam-1668171394053	AlignmentsTrack	NEB_library_18_merged_UMI_consensus_mapped.LS21sp-2921.bam	{fan_camarosa_v1.0.a1}	{}	BamAdapter
29	neb_library_18_merged_umi_consensus_mapped.ls21sp-3143.bam-1668171418909	AlignmentsTrack	NEB_library_18_merged_UMI_consensus_mapped.LS21sp-3143.bam	{fan_camarosa_v1.0.a1}	{}	BamAdapter
30	neb_library_18_merged_umi_consensus_mapped.lse21-264.bam-1668171475845	AlignmentsTrack	NEB_library_18_merged_UMI_consensus_mapped.LSE21-264.bam	{fan_camarosa_v1.0.a1}	{}	BamAdapter
31	neb_library_18_merged_umi_consensus_mapped.lse21-585.bam-1668171506220	AlignmentsTrack	NEB_library_18_merged_UMI_consensus_mapped.LSE21-585.bam	{fan_camarosa_v1.0.a1}	{}	BamAdapter
32	neb_library_18_merged_umi_consensus_mapped.lse21-593.bam-1668171529325	AlignmentsTrack	NEB_library_18_merged_UMI_consensus_mapped.LSE21-593.bam	{fan_camarosa_v1.0.a1}	{}	BamAdapter
33	neb_library_18_merged_umi_consensus_mapped.lse21-773.bam-1668171567460	AlignmentsTrack	NEB_library_18_merged_UMI_consensus_mapped.LSE21-773.bam	{fan_camarosa_v1.0.a1}	{}	BamAdapter
34	neb_library_18_merged_umi_consensus_mapped.lse21-820.bam-1668171588517	AlignmentsTrack	NEB_library_18_merged_UMI_consensus_mapped.LSE21-820.bam	{fan_camarosa_v1.0.a1}	{}	BamAdapter
35	neb_library_18_merged_umi_consensus_mapped.lse21-841.bam-1668171613340	AlignmentsTrack	NEB_library_18_merged_UMI_consensus_mapped.LSE21-841.bam	{fan_camarosa_v1.0.a1}	{}	BamAdapter
36	limprimersdec2022.gff.gz-1669987079726	FeatureTrack	Limgroup Primers	{AsparagusCHR_V1.1}	{}	Gff3TabixAdapter
37	nebnextasparagusofficinalisdb_20221219-1671444378424	VariantTrack	NEBNext variants - A. officinalis (20221219)	{AsparagusCHR_V1.1}	{"GBS - NEBNext"}	VcfTabixAdapter
38	nebnextasparaguswildrelativesdb_20221219-1671444693319	VariantTrack	NEBNext variants - Wild relatives (20221219)	{AsparagusCHR_V1.1}	{"GBS - NEBNext"}	VcfTabixAdapter
39	NEBNext_targets_vs_fan_camarosa_v1	SyntenyTrack	NEBNext_targets_vs_fan_camarosa_v1	{fan_camarosa_v1.0.a1,Strawberry_NEBNext_targets}	{}	PAFAdapter
40	nebnext_direct_target_to_flank_ref.bed.gz-1671698875715	FeatureTrack	NEBNext_direct_target_to_flank_ref.bed.gz	{Strawberry_NEBNext_targets}	{}	BedTabixAdapter
41	hybrid_stgew_both_jbrowse_bed.bed.gz-1678958982464	FeatureTrack	GWAS_hybrid_stgew_both	{AsparagusCHR_V1.1}	{GWAS}	BedTabixAdapter
42	limgroup_old_(lgc)_kasp_targets-1696507354151	FeatureTrack	Limgroup Old (LGC) KASP Targets	{AsparagusCHR_V1.1}	{}	Gff3TabixAdapter
43	rna1aligned.sortedbycoord.out.bam-1700571776213	AlignmentsTrack	RNA 1	{AsparagusCHR_V1.1}	{"RNA Seq",K30-1}	BamAdapter
44	RNA2aligned.sortedbycoord.out.bam-1700571776213	AlignmentsTrack	RNA 2	{AsparagusCHR_V1.1}	{"RNA Seq",K30-1}	BamAdapter
45	RNA3aligned.sortedbycoord.out.bam-1700571776213	AlignmentsTrack	RNA 3	{AsparagusCHR_V1.1}	{"RNA Seq",K30-1}	BamAdapter
46	RNA4aligned.sortedbycoord.out.bam-1700571776213	AlignmentsTrack	RNA 4	{AsparagusCHR_V1.1}	{"RNA Seq",K30-1}	BamAdapter
47	RNA5aligned.sortedbycoord.out.bam-1700571776213	AlignmentsTrack	RNA 5	{AsparagusCHR_V1.1}	{"RNA Seq",K30-1}	BamAdapter
48	RNA6aligned.sortedbycoord.out.bam-1700571776213	AlignmentsTrack	RNA 6	{AsparagusCHR_V1.1}	{"RNA Seq",K30-1}	BamAdapter
49	RNA7aligned.sortedbycoord.out.bam-1700571776213	AlignmentsTrack	RNA 7	{AsparagusCHR_V1.1}	{"RNA Seq",K30-1}	BamAdapter
50	RNA8aligned.sortedbycoord.out.bam-1700571776213	AlignmentsTrack	RNA 8	{AsparagusCHR_V1.1}	{"RNA Seq",K30-1}	BamAdapter
51	aspV1vsV2	SyntenyTrack	aspV1vsV2	{AsparagusCHR_V1.1,Asparagus_V2_EVY}	{}	DeltaAdapter
52	ao03_06_5.cram-1709823225117	AlignmentsTrack	ama_AO03_06_5	{AsparagusCHR_V1.1}	{"WGS - Illumina short reads","JKI samples","A. amarus parent"}	CramAdapter
53	pros_ao183_10_3.cram-1709823291422	AlignmentsTrack	pros_AO183_10_3	{AsparagusCHR_V1.1}	{"WGS - Illumina short reads","JKI samples","A. prostratus parent"}	CramAdapter
54	res_ao709_19_3.cram-1709823346664	AlignmentsTrack	res_AO709_19_3	{AsparagusCHR_V1.1}	{"WGS - Illumina short reads","JKI samples",resistant}	CramAdapter
55	sus_ao710_19_12.cram-1709823418213	AlignmentsTrack	sus_AO710_19_12	{AsparagusCHR_V1.1}	{"WGS - Illumina short reads","JKI samples",susceptible}	CramAdapter
56	sus_ao710_19_9-1709825669576	AlignmentsTrack	sus_AO710_19_9	{AsparagusCHR_V1.1}	{"WGS - Illumina short reads","JKI samples",susceptible}	CramAdapter
57	sus_ao730_19_5-1709825717307	AlignmentsTrack	sus_AO730_19_5	{AsparagusCHR_V1.1}	{"WGS - Illumina short reads","JKI samples",susceptible}	CramAdapter
58	res_ao759_19_3-1709825766284	AlignmentsTrack	res_AO759_19_3	{AsparagusCHR_V1.1}	{"WGS - Illumina short reads","JKI samples",resistant}	CramAdapter
59	res_ao779_20_10-1709825868049	AlignmentsTrack	res_AO779_20_10	{AsparagusCHR_V1.1}	{"WGS - Illumina short reads","JKI samples",resistant}	CramAdapter
60	res_ao779_20_16-1709825954079	AlignmentsTrack	res_AO779_20_16	{AsparagusCHR_V1.1}	{"WGS - Illumina short reads","JKI samples",resistant}	CramAdapter
61	res_ao779_20_22-1709827019240	AlignmentsTrack	res_AO779_20_22	{AsparagusCHR_V1.1}	{"WGS - Illumina short reads","JKI samples",resistant}	CramAdapter
62	sus_ao779_20_28-1709827172204	AlignmentsTrack	sus_AO779_20_28	{AsparagusCHR_V1.1}	{"WGS - Illumina short reads","JKI samples",susceptible}	CramAdapter
63	sus_ao779_20_34-1709827201684	AlignmentsTrack	sus_AO779_20_34	{AsparagusCHR_V1.1}	{"WGS - Illumina short reads","JKI samples",susceptible}	CramAdapter
64	res_ao791_20_2-1709827262217	AlignmentsTrack	res_AO791_20_2	{AsparagusCHR_V1.1}	{"WGS - Illumina short reads","JKI samples",resistant}	CramAdapter
65	res_ao807_20_2-1709827317759	AlignmentsTrack	sus_AO807_20_2	{AsparagusCHR_V1.1}	{"WGS - Illumina short reads","JKI samples",susceptible}	CramAdapter
66	res_ao807_20_7-1709827376961	AlignmentsTrack	res_AO807_20_7	{AsparagusCHR_V1.1}	{"WGS - Illumina short reads","JKI samples",resistant}	CramAdapter
67	res_ao835_20_8-1709827451420	AlignmentsTrack	res_AO835_20_8	{AsparagusCHR_V1.1}	{"WGS - Illumina short reads","JKI samples",resistant}	CramAdapter
68	sus_ao871_20_3-1709827498172	AlignmentsTrack	sus_AO871_20_3	{AsparagusCHR_V1.1}	{"WGS - Illumina short reads","JKI samples",susceptible}	CramAdapter
69	res_ao874_20_11-1709827593705	AlignmentsTrack	res_AO874_20_11	{AsparagusCHR_V1.1}	{"WGS - Illumina short reads","JKI samples",resistant}	CramAdapter
70	sus_ao874_20_14-1709827677918	AlignmentsTrack	sus_AO874_20_14	{AsparagusCHR_V1.1}	{"WGS - Illumina short reads","JKI samples",susceptible}	CramAdapter
71	res_ao874_20_8-1709827709998	AlignmentsTrack	sus_AO874_20_8	{AsparagusCHR_V1.1}	{"WGS - Illumina short reads","JKI samples",susceptible}	CramAdapter
72	jki_sus_pooled	AlignmentsTrack	sus_pooled	{AsparagusCHR_V1.1}	{"WGS - Illumina short reads","JKI samples",susceptible}	CramAdapter
73	jki_res_pooled	AlignmentsTrack	res_pooled	{AsparagusCHR_V1.1}	{"WGS - Illumina short reads","JKI samples",resistant}	CramAdapter
74	jki_bsa_all_samples	VariantTrack	jki_bsa_all_samples	{AsparagusCHR_V1.1}	{"WGS - Illumina short reads","JKI samples",bsa}	VcfTabixAdapter
75	limalexiadh.hifitoref.bam-1737034584532	AlignmentsTrack	LimalexiaDh.hifiToRef.bam	{dh_limalexia}	{}	BamAdapter
113	LimalexiaDh.hifiToRef-1743493557816	AlignmentsTrack	LimalexiaDh.hifiToRef	{dh_limalexia}	{"WGS - Illumina short reads","JKI samples",bsa}	BamAdapter
\.


--
-- Data for Name: VcfTabixAdapter; Type: TABLE DATA; Schema: public; Owner: swen
--

COPY public."VcfTabixAdapter" ("Id", "trackId", "vcfGzLocation", "indexLocation") FROM stdin;
1	4	data/lim-asp11-data/GBS/vcf/23-07-2018/2018.all.final.filtered.vcf.gz	data/lim-asp11-data/GBS/vcf/23-07-2018/2018.all.final.filtered.vcf.gz.tbi
2	6	data/lim-asp11-data/WGS/divPanel2016/vcf/AsparagusV1.panel.ann.eff.FS.vcf.gz	data/lim-asp11-data/WGS/divPanel2016/vcf/AsparagusV1.panel.ann.eff.FS.vcf.gz.tbi
3	8	data/projects/p68_aardbei_merker_platform/01_i1050_analyse_fanaSNP_results/03_deduplicate_and_filter/fanaSNP_filtered_pruned_selected.vcf.gz	data/projects/p68_aardbei_merker_platform/01_i1050_analyse_fanaSNP_results/03_deduplicate_and_filter/fanaSNP_filtered_pruned_selected.vcf.gz.tbi
4	16	data/projects/p68_aardbei_merker_platform/05_analyse_seq_data/02_variant_calls/gvcf/NEB_library_18.DH2.NEBtarget.g.vcf.gz	data/projects/p68_aardbei_merker_platform/05_analyse_seq_data/02_variant_calls/gvcf/NEB_library_18.DH2.NEBtarget.g.vcf.gz.tbi
5	37	http://10.0.0.21/jbrowse/data/lim-asp11-data/GBS/NEBNextGenomicDBs_export/NEBNextAsparagusOfficinalisDB.vcf.gz	http://10.0.0.21/jbrowse/data/lim-asp11-data/GBS/NEBNextGenomicDBs_export/NEBNextAsparagusOfficinalisDB.vcf.gz.tbi
6	38	http://chronos/jbrowse/data/lim-asp11-data/GBS/NEBNextGenomicDBs_export/NEBNextAsparagusWildRelativesDB.vcf.gz	http://chronos/jbrowse/data/lim-asp11-data/GBS/NEBNextGenomicDBs_export/NEBNextAsparagusWildRelativesDB.vcf.gz.tbi
7	74	symlinks/jki_samples/jki_all_samples_bsa_filtered.vcf.gz	symlinks/jki_samples/jki_all_samples_bsa_filtered.vcf.gz.tbi
\.


--
-- Data for Name: features; Type: TABLE DATA; Schema: public; Owner: swen
--

COPY public.features ("Id", "RefNameAliasId", "refName", "uniqueId", aliases) FROM stdin;
1	1	AsparagusV1_01	alias1	{1,chr1}
2	1	AsparagusV1_02	alias2	{2,chr2}
\.


--
-- Name: Assemblies_Id_seq; Type: SEQUENCE SET; Schema: public; Owner: swen
--

SELECT pg_catalog.setval('public."Assemblies_Id_seq"', 33, true);


--
-- Name: BamAdapter_Id_seq; Type: SEQUENCE SET; Schema: public; Owner: swen
--

SELECT pg_catalog.setval('public."BamAdapter_Id_seq"', 36, true);


--
-- Name: BedTabixAdapter_Id_seq; Type: SEQUENCE SET; Schema: public; Owner: swen
--

SELECT pg_catalog.setval('public."BedTabixAdapter_Id_seq"', 9, true);


--
-- Name: BgzipFastaAdapter_Id_seq; Type: SEQUENCE SET; Schema: public; Owner: swen
--

SELECT pg_catalog.setval('public."BgzipFastaAdapter_Id_seq"', 6, true);


--
-- Name: CramAdapter_Id_seq; Type: SEQUENCE SET; Schema: public; Owner: swen
--

SELECT pg_catalog.setval('public."CramAdapter_Id_seq"', 28, true);


--
-- Name: DeltaAdapter_Id_seq; Type: SEQUENCE SET; Schema: public; Owner: swen
--

SELECT pg_catalog.setval('public."DeltaAdapter_Id_seq"', 7, true);


--
-- Name: Displays_Id_seq; Type: SEQUENCE SET; Schema: public; Owner: swen
--

SELECT pg_catalog.setval('public."Displays_Id_seq"', 418, true);


--
-- Name: Gff3TabixAdapter_Id_seq; Type: SEQUENCE SET; Schema: public; Owner: swen
--

SELECT pg_catalog.setval('public."Gff3TabixAdapter_Id_seq"', 6, true);


--
-- Name: IndexedFastaAdapter_Id_seq; Type: SEQUENCE SET; Schema: public; Owner: swen
--

SELECT pg_catalog.setval('public."IndexedFastaAdapter_Id_seq"', 27, true);


--
-- Name: PAFAdapter_Id_seq; Type: SEQUENCE SET; Schema: public; Owner: swen
--

SELECT pg_catalog.setval('public."PAFAdapter_Id_seq"', 11, true);


--
-- Name: RefNameAlias_Id_seq; Type: SEQUENCE SET; Schema: public; Owner: swen
--

SELECT pg_catalog.setval('public."RefNameAlias_Id_seq"', 1, true);


--
-- Name: Renderer_id_seq; Type: SEQUENCE SET; Schema: public; Owner: swen
--

SELECT pg_catalog.setval('public."Renderer_id_seq"', 8, true);


--
-- Name: Tracks_Id_seq; Type: SEQUENCE SET; Schema: public; Owner: swen
--

SELECT pg_catalog.setval('public."Tracks_Id_seq"', 113, true);


--
-- Name: VcfTabixAdapter_Id_seq; Type: SEQUENCE SET; Schema: public; Owner: swen
--

SELECT pg_catalog.setval('public."VcfTabixAdapter_Id_seq"', 12, true);


--
-- Name: features_Id_seq; Type: SEQUENCE SET; Schema: public; Owner: swen
--

SELECT pg_catalog.setval('public."features_Id_seq"', 2, true);


--
-- Name: Assemblies Assemblies_pkey; Type: CONSTRAINT; Schema: public; Owner: swen
--

ALTER TABLE ONLY public."Assemblies"
    ADD CONSTRAINT "Assemblies_pkey" PRIMARY KEY ("Id");


--
-- Name: BamAdapter BamAdapter_pkey; Type: CONSTRAINT; Schema: public; Owner: swen
--

ALTER TABLE ONLY public."BamAdapter"
    ADD CONSTRAINT "BamAdapter_pkey" PRIMARY KEY ("Id");


--
-- Name: BedTabixAdapter BedTabixAdapter_pkey; Type: CONSTRAINT; Schema: public; Owner: swen
--

ALTER TABLE ONLY public."BedTabixAdapter"
    ADD CONSTRAINT "BedTabixAdapter_pkey" PRIMARY KEY ("Id");


--
-- Name: BgzipFastaAdapter BgzipFastaAdapter_pkey; Type: CONSTRAINT; Schema: public; Owner: swen
--

ALTER TABLE ONLY public."BgzipFastaAdapter"
    ADD CONSTRAINT "BgzipFastaAdapter_pkey" PRIMARY KEY ("Id");


--
-- Name: CramAdapter CramAdapter_pkey; Type: CONSTRAINT; Schema: public; Owner: swen
--

ALTER TABLE ONLY public."CramAdapter"
    ADD CONSTRAINT "CramAdapter_pkey" PRIMARY KEY ("Id");


--
-- Name: DeltaAdapter DeltaAdapter_pkey; Type: CONSTRAINT; Schema: public; Owner: swen
--

ALTER TABLE ONLY public."DeltaAdapter"
    ADD CONSTRAINT "DeltaAdapter_pkey" PRIMARY KEY ("Id");


--
-- Name: Displays Displays_pkey; Type: CONSTRAINT; Schema: public; Owner: swen
--

ALTER TABLE ONLY public."Displays"
    ADD CONSTRAINT "Displays_pkey" PRIMARY KEY ("Id");


--
-- Name: Gff3TabixAdapter Gff3TabixAdapter_pkey; Type: CONSTRAINT; Schema: public; Owner: swen
--

ALTER TABLE ONLY public."Gff3TabixAdapter"
    ADD CONSTRAINT "Gff3TabixAdapter_pkey" PRIMARY KEY ("Id");


--
-- Name: IndexedFastaAdapter IndexedFastaAdapter_pkey; Type: CONSTRAINT; Schema: public; Owner: swen
--

ALTER TABLE ONLY public."IndexedFastaAdapter"
    ADD CONSTRAINT "IndexedFastaAdapter_pkey" PRIMARY KEY ("Id");


--
-- Name: PAFAdapter PAFAdapter_pkey; Type: CONSTRAINT; Schema: public; Owner: swen
--

ALTER TABLE ONLY public."PAFAdapter"
    ADD CONSTRAINT "PAFAdapter_pkey" PRIMARY KEY ("Id");


--
-- Name: RefNameAlias RefNameAlias_pkey; Type: CONSTRAINT; Schema: public; Owner: swen
--

ALTER TABLE ONLY public."RefNameAlias"
    ADD CONSTRAINT "RefNameAlias_pkey" PRIMARY KEY ("Id");


--
-- Name: Renderer Renderer_pkey; Type: CONSTRAINT; Schema: public; Owner: swen
--

ALTER TABLE ONLY public."Renderer"
    ADD CONSTRAINT "Renderer_pkey" PRIMARY KEY (id);


--
-- Name: Tracks Tracks_pkey; Type: CONSTRAINT; Schema: public; Owner: swen
--

ALTER TABLE ONLY public."Tracks"
    ADD CONSTRAINT "Tracks_pkey" PRIMARY KEY ("Id");


--
-- Name: VcfTabixAdapter VcfTabixAdapter_pkey; Type: CONSTRAINT; Schema: public; Owner: swen
--

ALTER TABLE ONLY public."VcfTabixAdapter"
    ADD CONSTRAINT "VcfTabixAdapter_pkey" PRIMARY KEY ("Id");


--
-- Name: features features_pkey; Type: CONSTRAINT; Schema: public; Owner: swen
--

ALTER TABLE ONLY public.features
    ADD CONSTRAINT features_pkey PRIMARY KEY ("Id");


--
-- Name: BamAdapter BamAdapter_trackId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: swen
--

ALTER TABLE ONLY public."BamAdapter"
    ADD CONSTRAINT "BamAdapter_trackId_fkey" FOREIGN KEY ("trackId") REFERENCES public."Tracks"("Id");


--
-- Name: BedTabixAdapter BedTabixAdapter_trackId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: swen
--

ALTER TABLE ONLY public."BedTabixAdapter"
    ADD CONSTRAINT "BedTabixAdapter_trackId_fkey" FOREIGN KEY ("trackId") REFERENCES public."Tracks"("Id");


--
-- Name: BgzipFastaAdapter BgzipFastaAdapter_assemblyId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: swen
--

ALTER TABLE ONLY public."BgzipFastaAdapter"
    ADD CONSTRAINT "BgzipFastaAdapter_assemblyId_fkey" FOREIGN KEY ("assemblyId") REFERENCES public."Assemblies"("Id");


--
-- Name: CramAdapter CramAdapter_trackId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: swen
--

ALTER TABLE ONLY public."CramAdapter"
    ADD CONSTRAINT "CramAdapter_trackId_fkey" FOREIGN KEY ("trackId") REFERENCES public."Tracks"("Id");


--
-- Name: DeltaAdapter DeltaAdapter_trackId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: swen
--

ALTER TABLE ONLY public."DeltaAdapter"
    ADD CONSTRAINT "DeltaAdapter_trackId_fkey" FOREIGN KEY ("trackId") REFERENCES public."Tracks"("Id");


--
-- Name: Gff3TabixAdapter Gff3TabixAdapter_trackId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: swen
--

ALTER TABLE ONLY public."Gff3TabixAdapter"
    ADD CONSTRAINT "Gff3TabixAdapter_trackId_fkey" FOREIGN KEY ("trackId") REFERENCES public."Tracks"("Id");


--
-- Name: IndexedFastaAdapter IndexedFastaAdapter_assemblyId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: swen
--

ALTER TABLE ONLY public."IndexedFastaAdapter"
    ADD CONSTRAINT "IndexedFastaAdapter_assemblyId_fkey" FOREIGN KEY ("assemblyId") REFERENCES public."Assemblies"("Id");


--
-- Name: PAFAdapter PAFAdapter_trackId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: swen
--

ALTER TABLE ONLY public."PAFAdapter"
    ADD CONSTRAINT "PAFAdapter_trackId_fkey" FOREIGN KEY ("trackId") REFERENCES public."Tracks"("Id");


--
-- Name: RefNameAlias RefNameAlias_assemblyId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: swen
--

ALTER TABLE ONLY public."RefNameAlias"
    ADD CONSTRAINT "RefNameAlias_assemblyId_fkey" FOREIGN KEY ("assemblyId") REFERENCES public."Assemblies"("Id");


--
-- Name: Renderer Renderer_DisplaysId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: swen
--

ALTER TABLE ONLY public."Renderer"
    ADD CONSTRAINT "Renderer_DisplaysId_fkey" FOREIGN KEY ("DisplaysId") REFERENCES public."Displays"("Id");


--
-- Name: VcfTabixAdapter VcfTabixAdapter_trackId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: swen
--

ALTER TABLE ONLY public."VcfTabixAdapter"
    ADD CONSTRAINT "VcfTabixAdapter_trackId_fkey" FOREIGN KEY ("trackId") REFERENCES public."Tracks"("Id");


--
-- Name: features features_RefNameAliasId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: swen
--

ALTER TABLE ONLY public.features
    ADD CONSTRAINT "features_RefNameAliasId_fkey" FOREIGN KEY ("RefNameAliasId") REFERENCES public."RefNameAlias"("Id");


--
-- PostgreSQL database dump complete
--

