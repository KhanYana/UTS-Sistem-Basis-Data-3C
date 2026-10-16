--
-- PostgreSQL database dump
--

\restrict CDk2ziEMWGqoNlLTkqhahJ9UiPamjejOfXCl1rTWoGvaZIJFGTvyFYLeEZQiOSF

-- Dumped from database version 18.6
-- Dumped by pg_dump version 18.6

-- Started on 2026-10-16 08:42:03

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

--
-- TOC entry 232 (class 1255 OID 17841)
-- Name: fn_check_owner(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.fn_check_owner() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM PrivateOwner  WHERE ownerNo = NEW.ownerNo)
       AND NOT EXISTS (SELECT 1 FROM BusinessOwner WHERE ownerNo = NEW.ownerNo) THEN
        RAISE EXCEPTION 'ownerNo % tidak ada di PrivateOwner maupun BusinessOwner', NEW.ownerNo;
    END IF;
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.fn_check_owner() OWNER TO postgres;

--
-- TOC entry 233 (class 1255 OID 17843)
-- Name: fn_max_phone(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.fn_max_phone() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF TG_OP = 'UPDATE' AND OLD.branchNo = NEW.branchNo THEN
        RETURN NEW;
    END IF;
    IF (SELECT COUNT(*) FROM Telephone WHERE branchNo = NEW.branchNo) >= 3 THEN
        RAISE EXCEPTION 'Branch % sudah punya 3 nomor telepon (maksimum 1..3)', NEW.branchNo;
    END IF;
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.fn_max_phone() OWNER TO postgres;

--
-- TOC entry 235 (class 1255 OID 17847)
-- Name: fn_max_properties(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.fn_max_properties() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF NEW.staffNo IS NULL THEN
        RETURN NEW;
    END IF;
    IF TG_OP = 'UPDATE' AND OLD.staffNo IS NOT DISTINCT FROM NEW.staffNo THEN
        RETURN NEW;
    END IF;
    IF (SELECT COUNT(*) FROM PropertyForRent WHERE staffNo = NEW.staffNo) >= 100 THEN
        RAISE EXCEPTION 'Staff % sudah mengawasi 100 properti (maksimum 0..100)', NEW.staffNo;
    END IF;
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.fn_max_properties() OWNER TO postgres;

--
-- TOC entry 234 (class 1255 OID 17845)
-- Name: fn_max_supervisees(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.fn_max_supervisees() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF NEW.supervisorStaffNo IS NULL THEN
        RETURN NEW;
    END IF;
    IF TG_OP = 'UPDATE' AND OLD.supervisorStaffNo IS NOT DISTINCT FROM NEW.supervisorStaffNo THEN
        RETURN NEW;
    END IF;
    IF (SELECT COUNT(*) FROM Staff WHERE supervisorStaffNo = NEW.supervisorStaffNo) >= 10 THEN
        RAISE EXCEPTION 'Supervisor % sudah mengawasi 10 staff (maksimum 0..10)', NEW.supervisorStaffNo;
    END IF;
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.fn_max_supervisees() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 231 (class 1259 OID 17753)
-- Name: advert; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.advert (
    propertyno character varying(5) NOT NULL,
    newspapername character varying(40) NOT NULL,
    dateadvert date NOT NULL
);


ALTER TABLE public.advert OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 17706)
-- Name: branch; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.branch (
    branchno character varying(4) NOT NULL,
    mgrstaffno character varying(5) NOT NULL
);


ALTER TABLE public.branch OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 17687)
-- Name: businessowner; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.businessowner (
    ownerno character varying(5) NOT NULL
);


ALTER TABLE public.businessowner OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 17675)
-- Name: client; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.client (
    clientno character varying(5) NOT NULL
);


ALTER TABLE public.client OWNER TO postgres;

--
-- TOC entry 229 (class 1259 OID 17738)
-- Name: lease; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.lease (
    leaseno character varying(8) NOT NULL,
    clientno character varying(5) NOT NULL,
    propertyno character varying(5) NOT NULL
);


ALTER TABLE public.lease OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 17700)
-- Name: manager; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.manager (
    staffno character varying(5) NOT NULL
);


ALTER TABLE public.manager OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 17669)
-- Name: newspaper; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.newspaper (
    newspapername character varying(40) NOT NULL
);


ALTER TABLE public.newspaper OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 17681)
-- Name: privateowner; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.privateowner (
    ownerno character varying(5) NOT NULL
);


ALTER TABLE public.privateowner OWNER TO postgres;

--
-- TOC entry 228 (class 1259 OID 17730)
-- Name: propertyforrent; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.propertyforrent (
    propertyno character varying(5) NOT NULL,
    ownerno character varying(5) NOT NULL,
    staffno character varying(5),
    branchno character varying(4) NOT NULL
);


ALTER TABLE public.propertyforrent OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 17722)
-- Name: registration; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.registration (
    clientno character varying(5) NOT NULL,
    branchno character varying(4) NOT NULL,
    staffno character varying(5) NOT NULL
);


ALTER TABLE public.registration OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 17693)
-- Name: staff; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.staff (
    staffno character varying(5) NOT NULL,
    supervisorstaffno character varying(5),
    branchno character varying(4) NOT NULL
);


ALTER TABLE public.staff OWNER TO postgres;

--
-- TOC entry 226 (class 1259 OID 17715)
-- Name: telephone; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.telephone (
    telno character varying(13) NOT NULL,
    branchno character varying(4) NOT NULL
);


ALTER TABLE public.telephone OWNER TO postgres;

--
-- TOC entry 230 (class 1259 OID 17746)
-- Name: viewing; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.viewing (
    clientno character varying(5) NOT NULL,
    propertyno character varying(5) NOT NULL
);


ALTER TABLE public.viewing OWNER TO postgres;

--
-- TOC entry 5114 (class 0 OID 17753)
-- Dependencies: 231
-- Data for Name: advert; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.advert (propertyno, newspapername, dateadvert) FROM stdin;
PA14	Evening Standard	2026-09-01
\.


--
-- TOC entry 5108 (class 0 OID 17706)
-- Dependencies: 225
-- Data for Name: branch; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.branch (branchno, mgrstaffno) FROM stdin;
B005	S1500
\.


--
-- TOC entry 5105 (class 0 OID 17687)
-- Dependencies: 222
-- Data for Name: businessowner; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.businessowner (ownerno) FROM stdin;
CO93
\.


--
-- TOC entry 5103 (class 0 OID 17675)
-- Dependencies: 220
-- Data for Name: client; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.client (clientno) FROM stdin;
CR76
CR56
\.


--
-- TOC entry 5112 (class 0 OID 17738)
-- Dependencies: 229
-- Data for Name: lease; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.lease (leaseno, clientno, propertyno) FROM stdin;
10024	CR76	PA14
\.


--
-- TOC entry 5107 (class 0 OID 17700)
-- Dependencies: 224
-- Data for Name: manager; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.manager (staffno) FROM stdin;
S1500
\.


--
-- TOC entry 5102 (class 0 OID 17669)
-- Dependencies: 219
-- Data for Name: newspaper; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.newspaper (newspapername) FROM stdin;
Evening Standard
\.


--
-- TOC entry 5104 (class 0 OID 17681)
-- Dependencies: 221
-- Data for Name: privateowner; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.privateowner (ownerno) FROM stdin;
CO46
\.


--
-- TOC entry 5111 (class 0 OID 17730)
-- Dependencies: 228
-- Data for Name: propertyforrent; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.propertyforrent (propertyno, ownerno, staffno, branchno) FROM stdin;
PA14	CO46	SL21	B005
PG4	CO93	SG37	B005
\.


--
-- TOC entry 5110 (class 0 OID 17722)
-- Dependencies: 227
-- Data for Name: registration; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.registration (clientno, branchno, staffno) FROM stdin;
CR76	B005	SL21
CR56	B005	SG37
\.


--
-- TOC entry 5106 (class 0 OID 17693)
-- Dependencies: 223
-- Data for Name: staff; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.staff (staffno, supervisorstaffno, branchno) FROM stdin;
S1500	\N	B005
SL21	S1500	B005
SG37	S1500	B005
\.


--
-- TOC entry 5109 (class 0 OID 17715)
-- Dependencies: 226
-- Data for Name: telephone; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.telephone (telno, branchno) FROM stdin;
0207-886-1212	B005
0207-886-1213	B005
\.


--
-- TOC entry 5113 (class 0 OID 17746)
-- Dependencies: 230
-- Data for Name: viewing; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.viewing (clientno, propertyno) FROM stdin;
CR76	PA14
CR56	PG4
\.


--
-- TOC entry 4934 (class 2606 OID 17760)
-- Name: advert pk_advert; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.advert
    ADD CONSTRAINT pk_advert PRIMARY KEY (propertyno, newspapername, dateadvert);


--
-- TOC entry 4920 (class 2606 OID 17712)
-- Name: branch pk_branch; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.branch
    ADD CONSTRAINT pk_branch PRIMARY KEY (branchno);


--
-- TOC entry 4914 (class 2606 OID 17692)
-- Name: businessowner pk_businessowner; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.businessowner
    ADD CONSTRAINT pk_businessowner PRIMARY KEY (ownerno);


--
-- TOC entry 4910 (class 2606 OID 17680)
-- Name: client pk_client; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.client
    ADD CONSTRAINT pk_client PRIMARY KEY (clientno);


--
-- TOC entry 4930 (class 2606 OID 17745)
-- Name: lease pk_lease; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lease
    ADD CONSTRAINT pk_lease PRIMARY KEY (leaseno);


--
-- TOC entry 4918 (class 2606 OID 17705)
-- Name: manager pk_manager; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.manager
    ADD CONSTRAINT pk_manager PRIMARY KEY (staffno);


--
-- TOC entry 4908 (class 2606 OID 17674)
-- Name: newspaper pk_newspaper; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.newspaper
    ADD CONSTRAINT pk_newspaper PRIMARY KEY (newspapername);


--
-- TOC entry 4912 (class 2606 OID 17686)
-- Name: privateowner pk_privateowner; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.privateowner
    ADD CONSTRAINT pk_privateowner PRIMARY KEY (ownerno);


--
-- TOC entry 4928 (class 2606 OID 17737)
-- Name: propertyforrent pk_propertyforrent; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.propertyforrent
    ADD CONSTRAINT pk_propertyforrent PRIMARY KEY (propertyno);


--
-- TOC entry 4926 (class 2606 OID 17729)
-- Name: registration pk_registration; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.registration
    ADD CONSTRAINT pk_registration PRIMARY KEY (clientno);


--
-- TOC entry 4916 (class 2606 OID 17699)
-- Name: staff pk_staff; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.staff
    ADD CONSTRAINT pk_staff PRIMARY KEY (staffno);


--
-- TOC entry 4924 (class 2606 OID 17721)
-- Name: telephone pk_telephone; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.telephone
    ADD CONSTRAINT pk_telephone PRIMARY KEY (telno);


--
-- TOC entry 4932 (class 2606 OID 17752)
-- Name: viewing pk_viewing; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.viewing
    ADD CONSTRAINT pk_viewing PRIMARY KEY (clientno, propertyno);


--
-- TOC entry 4922 (class 2606 OID 17714)
-- Name: branch uq_branch_mgr; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.branch
    ADD CONSTRAINT uq_branch_mgr UNIQUE (mgrstaffno);


--
-- TOC entry 4952 (class 2620 OID 17844)
-- Name: telephone trg_max_phone; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_max_phone BEFORE INSERT OR UPDATE OF branchno ON public.telephone FOR EACH ROW EXECUTE FUNCTION public.fn_max_phone();


--
-- TOC entry 4953 (class 2620 OID 17848)
-- Name: propertyforrent trg_max_properties; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_max_properties BEFORE INSERT OR UPDATE OF staffno ON public.propertyforrent FOR EACH ROW EXECUTE FUNCTION public.fn_max_properties();


--
-- TOC entry 4951 (class 2620 OID 17846)
-- Name: staff trg_max_supervisees; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_max_supervisees BEFORE INSERT OR UPDATE OF supervisorstaffno ON public.staff FOR EACH ROW EXECUTE FUNCTION public.fn_max_supervisees();


--
-- TOC entry 4954 (class 2620 OID 17842)
-- Name: propertyforrent trg_property_owner; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_property_owner BEFORE INSERT OR UPDATE OF ownerno ON public.propertyforrent FOR EACH ROW EXECUTE FUNCTION public.fn_check_owner();


--
-- TOC entry 4940 (class 2606 OID 17786)
-- Name: registration fk_agrees; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.registration
    ADD CONSTRAINT fk_agrees FOREIGN KEY (clientno) REFERENCES public.client(clientno) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4949 (class 2606 OID 17836)
-- Name: advert fk_displays; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.advert
    ADD CONSTRAINT fk_displays FOREIGN KEY (newspapername) REFERENCES public.newspaper(newspapername) ON UPDATE CASCADE;


--
-- TOC entry 4935 (class 2606 OID 17761)
-- Name: staff fk_has; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.staff
    ADD CONSTRAINT fk_has FOREIGN KEY (branchno) REFERENCES public.branch(branchno) ON UPDATE CASCADE;


--
-- TOC entry 4945 (class 2606 OID 17811)
-- Name: lease fk_holds; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lease
    ADD CONSTRAINT fk_holds FOREIGN KEY (clientno) REFERENCES public.client(clientno) ON UPDATE CASCADE;


--
-- TOC entry 4937 (class 2606 OID 17771)
-- Name: manager fk_is_a; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.manager
    ADD CONSTRAINT fk_is_a FOREIGN KEY (staffno) REFERENCES public.staff(staffno) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4946 (class 2606 OID 17816)
-- Name: lease fk_leasedby; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lease
    ADD CONSTRAINT fk_leasedby FOREIGN KEY (propertyno) REFERENCES public.propertyforrent(propertyno) ON UPDATE CASCADE;


--
-- TOC entry 4938 (class 2606 OID 17776)
-- Name: branch fk_manages; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.branch
    ADD CONSTRAINT fk_manages FOREIGN KEY (mgrstaffno) REFERENCES public.manager(staffno) ON UPDATE CASCADE DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4943 (class 2606 OID 17801)
-- Name: propertyforrent fk_offers; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.propertyforrent
    ADD CONSTRAINT fk_offers FOREIGN KEY (branchno) REFERENCES public.branch(branchno) ON UPDATE CASCADE;


--
-- TOC entry 4944 (class 2606 OID 17806)
-- Name: propertyforrent fk_oversees; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.propertyforrent
    ADD CONSTRAINT fk_oversees FOREIGN KEY (staffno) REFERENCES public.staff(staffno) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- TOC entry 4950 (class 2606 OID 17831)
-- Name: advert fk_placedin; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.advert
    ADD CONSTRAINT fk_placedin FOREIGN KEY (propertyno) REFERENCES public.propertyforrent(propertyno) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4941 (class 2606 OID 17796)
-- Name: registration fk_processes; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.registration
    ADD CONSTRAINT fk_processes FOREIGN KEY (staffno) REFERENCES public.staff(staffno) ON UPDATE CASCADE;


--
-- TOC entry 4939 (class 2606 OID 17781)
-- Name: telephone fk_provides; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.telephone
    ADD CONSTRAINT fk_provides FOREIGN KEY (branchno) REFERENCES public.branch(branchno) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4942 (class 2606 OID 17791)
-- Name: registration fk_registers; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.registration
    ADD CONSTRAINT fk_registers FOREIGN KEY (branchno) REFERENCES public.branch(branchno) ON UPDATE CASCADE;


--
-- TOC entry 4947 (class 2606 OID 17821)
-- Name: viewing fk_requests; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.viewing
    ADD CONSTRAINT fk_requests FOREIGN KEY (clientno) REFERENCES public.client(clientno) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4936 (class 2606 OID 17766)
-- Name: staff fk_supervises; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.staff
    ADD CONSTRAINT fk_supervises FOREIGN KEY (supervisorstaffno) REFERENCES public.staff(staffno) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- TOC entry 4948 (class 2606 OID 17826)
-- Name: viewing fk_takes; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.viewing
    ADD CONSTRAINT fk_takes FOREIGN KEY (propertyno) REFERENCES public.propertyforrent(propertyno) ON UPDATE CASCADE ON DELETE CASCADE;


-- Completed on 2026-10-16 08:42:03

--
-- PostgreSQL database dump complete
--

\unrestrict CDk2ziEMWGqoNlLTkqhahJ9UiPamjejOfXCl1rTWoGvaZIJFGTvyFYLeEZQiOSF

