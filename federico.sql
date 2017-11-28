PGDMP     6                
    u           federico    9.4.12    9.4.12 _    h           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                       false            i           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                       false            j           1262    24592    federico    DATABASE     z   CREATE DATABASE federico WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'es_CL.UTF-8' LC_CTYPE = 'es_CL.UTF-8';
    DROP DATABASE federico;
             postgres    false                        2615    2200    public    SCHEMA        CREATE SCHEMA public;
    DROP SCHEMA public;
             postgres    false            k           0    0    SCHEMA public    COMMENT     6   COMMENT ON SCHEMA public IS 'standard public schema';
                  postgres    false    6                        3079    11861    plpgsql 	   EXTENSION     ?   CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;
    DROP EXTENSION plpgsql;
                  false            l           0    0    EXTENSION plpgsql    COMMENT     @   COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';
                       false    1            *           1247    24917    gender    TYPE     1   CREATE TYPE gender AS ENUM (
    'm',
    'f'
);
    DROP TYPE public.gender;
       public       federico    false    6            4           1247    24946    scope    TYPE     A   CREATE TYPE scope AS ENUM (
    'individual',
    'colectivo'
);
    DROP TYPE public.scope;
       public       federico    false    6            �            1259    24911    autorizacion    TABLE     S   CREATE TABLE autorizacion (
    id integer NOT NULL,
    nivel integer NOT NULL
);
     DROP TABLE public.autorizacion;
       public         federico    false    6            �            1259    24972 	   beneficio    TABLE     #  CREATE TABLE beneficio (
    id integer NOT NULL,
    beneficio character varying NOT NULL,
    observacion character varying,
    subcategoria_id integer,
    es_costeable boolean,
    es_individual boolean NOT NULL,
    pais text DEFAULT 'BCW'::text NOT NULL,
    es_medido_uso boolean DEFAULT false NOT NULL,
    es_aprobado boolean DEFAULT false NOT NULL,
    es_medido_tiempo_respuesta boolean DEFAULT false NOT NULL,
    es_exclusivo_indefinidos boolean DEFAULT false NOT NULL,
    subcategoria text NOT NULL,
    categoria text NOT NULL
);
    DROP TABLE public.beneficio;
       public         federico    false    6            �            1259    49173    beneficio_id_seq    SEQUENCE     r   CREATE SEQUENCE beneficio_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 '   DROP SEQUENCE public.beneficio_id_seq;
       public       federico    false    6    180            m           0    0    beneficio_id_seq    SEQUENCE OWNED BY     7   ALTER SEQUENCE beneficio_id_seq OWNED BY beneficio.id;
            public       federico    false    185            �            1259    24926    carga    TABLE     �   CREATE TABLE carga (
    id integer NOT NULL,
    carga text NOT NULL,
    rut character varying,
    nacido_en date,
    colaborador_id integer,
    es_hijo boolean,
    rut_colaborador text NOT NULL
);
    DROP TABLE public.carga;
       public         federico    false    6            �            1259    73756    carga_id_seq    SEQUENCE     n   CREATE SEQUENCE carga_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.carga_id_seq;
       public       federico    false    176    6            n           0    0    carga_id_seq    SEQUENCE OWNED BY     /   ALTER SEQUENCE carga_id_seq OWNED BY carga.id;
            public       federico    false    192            �            1259    24951 	   categoria    TABLE     ^   CREATE TABLE categoria (
    id integer NOT NULL,
    categoria character varying NOT NULL
);
    DROP TABLE public.categoria;
       public         federico    false    6            �            1259    73761    categoria_id_seq    SEQUENCE     r   CREATE SEQUENCE categoria_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 '   DROP SEQUENCE public.categoria_id_seq;
       public       federico    false    178    6            o           0    0    categoria_id_seq    SEQUENCE OWNED BY     7   ALTER SEQUENCE categoria_id_seq OWNED BY categoria.id;
            public       federico    false    193            �            1259    24921    colaborador    TABLE     �  CREATE TABLE colaborador (
    id integer NOT NULL,
    colaborador text NOT NULL,
    esta_sindicalizado boolean,
    area character varying(40),
    run text NOT NULL,
    ingreso_en date,
    sucursal character varying(30) NOT NULL,
    ciudad character varying(30),
    pais character varying(30),
    nacimiento_en date,
    es_indefinido boolean,
    nacionalidad text,
    esta_casado boolean,
    direccion text,
    comuna text,
    region text,
    telefono text,
    cargo text,
    empresa text,
    supervisor text,
    centro_costo character varying(9),
    es_hombre boolean,
    codigo_sap text,
    mail text,
    supervisor_rut text,
    supervisor_id integer
);
    DROP TABLE public.colaborador;
       public         federico    false    6            �            1259    65619    colaborador_id_seq    SEQUENCE     y   CREATE SEQUENCE colaborador_id_seq
    START WITH 1001
    INCREMENT BY 1
    MINVALUE 1001
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public.colaborador_id_seq;
       public       federico    false    175    6            p           0    0    colaborador_id_seq    SEQUENCE OWNED BY     ;   ALTER SEQUENCE colaborador_id_seq OWNED BY colaborador.id;
            public       federico    false    191            �            1259    24990    encuesta    TABLE     �   CREATE TABLE encuesta (
    id integer NOT NULL,
    colaborador_id integer NOT NULL,
    nota integer NOT NULL,
    aplicacion date,
    categoria_id integer
);
    DROP TABLE public.encuesta;
       public         federico    false    6            �            1259    32784    encuesta_id_seq    SEQUENCE     q   CREATE SEQUENCE encuesta_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE public.encuesta_id_seq;
       public       federico    false    181    6            q           0    0    encuesta_id_seq    SEQUENCE OWNED BY     5   ALTER SEQUENCE encuesta_id_seq OWNED BY encuesta.id;
            public       federico    false    183            �            1259    73764    subcategoria_id    SEQUENCE     q   CREATE SEQUENCE subcategoria_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE public.subcategoria_id;
       public       federico    false    6            �            1259    24959    subcategoria    TABLE     �   CREATE TABLE subcategoria (
    id integer DEFAULT nextval('subcategoria_id'::regclass) NOT NULL,
    subcategoria character varying NOT NULL,
    categoria_id integer,
    categoria text NOT NULL
);
     DROP TABLE public.subcategoria;
       public         federico    false    194    6            �            1259    73771    lookup_sc_id    VIEW     �   CREATE VIEW lookup_sc_id AS
 SELECT c.categoria,
    sc.subcategoria,
    sc.id AS scid
   FROM (categoria c
     LEFT JOIN subcategoria sc ON ((sc.categoria_id = c.id)));
    DROP VIEW public.lookup_sc_id;
       public       federico    false    179    179    179    178    178    6            �            1259    49178    moneda    TABLE     X   CREATE TABLE moneda (
    id integer NOT NULL,
    moneda character varying NOT NULL
);
    DROP TABLE public.moneda;
       public         federico    false    6            �            1259    49176    moneda_id_seq    SEQUENCE     o   CREATE SEQUENCE moneda_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 $   DROP SEQUENCE public.moneda_id_seq;
       public       federico    false    6    187            r           0    0    moneda_id_seq    SEQUENCE OWNED BY     1   ALTER SEQUENCE moneda_id_seq OWNED BY moneda.id;
            public       federico    false    186            �            1259    24939    presupuesto    TABLE     �   CREATE TABLE presupuesto (
    id integer NOT NULL,
    monto integer NOT NULL,
    asignacion date,
    beneficio_id integer NOT NULL,
    moneda_id integer
);
    DROP TABLE public.presupuesto;
       public         federico    false    6            �            1259    65555    presupuesto_id_seq    SEQUENCE     t   CREATE SEQUENCE presupuesto_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public.presupuesto_id_seq;
       public       federico    false    6    177            s           0    0    presupuesto_id_seq    SEQUENCE OWNED BY     ;   ALTER SEQUENCE presupuesto_id_seq OWNED BY presupuesto.id;
            public       federico    false    190            �            1259    25005 	   solicitud    TABLE     S  CREATE TABLE solicitud (
    id bigint NOT NULL,
    colaborador_id integer NOT NULL,
    beneficio_id integer NOT NULL,
    solicitado_en date,
    resuelto_en date,
    esta_aprobado boolean,
    creacion timestamp without time zone DEFAULT now(),
    monto integer,
    moneda_id integer,
    estado text DEFAULT 'En trámite'::text
);
    DROP TABLE public.solicitud;
       public         federico    false    6            �            1259    40976    solicitud_id_seq    SEQUENCE     r   CREATE SEQUENCE solicitud_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 '   DROP SEQUENCE public.solicitud_id_seq;
       public       federico    false    182    6            t           0    0    solicitud_id_seq    SEQUENCE OWNED BY     7   ALTER SEQUENCE solicitud_id_seq OWNED BY solicitud.id;
            public       federico    false    184            �            1259    49186    tasa    TABLE     �   CREATE TABLE tasa (
    id integer NOT NULL,
    de_id integer NOT NULL,
    a_id integer NOT NULL,
    tasa numeric(5,2),
    fecha date
);
    DROP TABLE public.tasa;
       public         federico    false    6            �            1259    49184    tasa_id_seq    SEQUENCE     m   CREATE SEQUENCE tasa_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 "   DROP SEQUENCE public.tasa_id_seq;
       public       federico    false    6    189            u           0    0    tasa_id_seq    SEQUENCE OWNED BY     -   ALTER SEQUENCE tasa_id_seq OWNED BY tasa.id;
            public       federico    false    188            �            1259    24903    usuario    TABLE     �   CREATE TABLE usuario (
    id bigint NOT NULL,
    nombre text NOT NULL,
    contrasena character varying NOT NULL,
    autorizacion integer NOT NULL
);
    DROP TABLE public.usuario;
       public         federico    false    6            �           2604    49175    id    DEFAULT     ^   ALTER TABLE ONLY beneficio ALTER COLUMN id SET DEFAULT nextval('beneficio_id_seq'::regclass);
 ;   ALTER TABLE public.beneficio ALTER COLUMN id DROP DEFAULT;
       public       federico    false    185    180            �           2604    73758    id    DEFAULT     V   ALTER TABLE ONLY carga ALTER COLUMN id SET DEFAULT nextval('carga_id_seq'::regclass);
 7   ALTER TABLE public.carga ALTER COLUMN id DROP DEFAULT;
       public       federico    false    192    176            �           2604    73763    id    DEFAULT     ^   ALTER TABLE ONLY categoria ALTER COLUMN id SET DEFAULT nextval('categoria_id_seq'::regclass);
 ;   ALTER TABLE public.categoria ALTER COLUMN id DROP DEFAULT;
       public       federico    false    193    178            �           2604    65621    id    DEFAULT     b   ALTER TABLE ONLY colaborador ALTER COLUMN id SET DEFAULT nextval('colaborador_id_seq'::regclass);
 =   ALTER TABLE public.colaborador ALTER COLUMN id DROP DEFAULT;
       public       federico    false    191    175            �           2604    32786    id    DEFAULT     \   ALTER TABLE ONLY encuesta ALTER COLUMN id SET DEFAULT nextval('encuesta_id_seq'::regclass);
 :   ALTER TABLE public.encuesta ALTER COLUMN id DROP DEFAULT;
       public       federico    false    183    181            �           2604    49181    id    DEFAULT     X   ALTER TABLE ONLY moneda ALTER COLUMN id SET DEFAULT nextval('moneda_id_seq'::regclass);
 8   ALTER TABLE public.moneda ALTER COLUMN id DROP DEFAULT;
       public       federico    false    186    187    187            �           2604    65557    id    DEFAULT     b   ALTER TABLE ONLY presupuesto ALTER COLUMN id SET DEFAULT nextval('presupuesto_id_seq'::regclass);
 =   ALTER TABLE public.presupuesto ALTER COLUMN id DROP DEFAULT;
       public       federico    false    190    177            �           2604    40978    id    DEFAULT     ^   ALTER TABLE ONLY solicitud ALTER COLUMN id SET DEFAULT nextval('solicitud_id_seq'::regclass);
 ;   ALTER TABLE public.solicitud ALTER COLUMN id DROP DEFAULT;
       public       federico    false    184    182            �           2604    49189    id    DEFAULT     T   ALTER TABLE ONLY tasa ALTER COLUMN id SET DEFAULT nextval('tasa_id_seq'::regclass);
 6   ALTER TABLE public.tasa ALTER COLUMN id DROP DEFAULT;
       public       federico    false    189    188    189            Q          0    24911    autorizacion 
   TABLE DATA               *   COPY autorizacion (id, nivel) FROM stdin;
    public       federico    false    174   g       W          0    24972 	   beneficio 
   TABLE DATA               �   COPY beneficio (id, beneficio, observacion, subcategoria_id, es_costeable, es_individual, pais, es_medido_uso, es_aprobado, es_medido_tiempo_respuesta, es_exclusivo_indefinidos, subcategoria, categoria) FROM stdin;
    public       federico    false    180   .g       v           0    0    beneficio_id_seq    SEQUENCE SET     9   SELECT pg_catalog.setval('beneficio_id_seq', 109, true);
            public       federico    false    185            S          0    24926    carga 
   TABLE DATA               ]   COPY carga (id, carga, rut, nacido_en, colaborador_id, es_hijo, rut_colaborador) FROM stdin;
    public       federico    false    176   (l       w           0    0    carga_id_seq    SEQUENCE SET     5   SELECT pg_catalog.setval('carga_id_seq', 624, true);
            public       federico    false    192            U          0    24951 	   categoria 
   TABLE DATA               +   COPY categoria (id, categoria) FROM stdin;
    public       federico    false    178   �       x           0    0    categoria_id_seq    SEQUENCE SET     7   SELECT pg_catalog.setval('categoria_id_seq', 6, true);
            public       federico    false    193            R          0    24921    colaborador 
   TABLE DATA               6  COPY colaborador (id, colaborador, esta_sindicalizado, area, run, ingreso_en, sucursal, ciudad, pais, nacimiento_en, es_indefinido, nacionalidad, esta_casado, direccion, comuna, region, telefono, cargo, empresa, supervisor, centro_costo, es_hombre, codigo_sap, mail, supervisor_rut, supervisor_id) FROM stdin;
    public       federico    false    175   S�       y           0    0    colaborador_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('colaborador_id_seq', 1333, true);
            public       federico    false    191            X          0    24990    encuesta 
   TABLE DATA               O   COPY encuesta (id, colaborador_id, nota, aplicacion, categoria_id) FROM stdin;
    public       federico    false    181   �      z           0    0    encuesta_id_seq    SEQUENCE SET     :   SELECT pg_catalog.setval('encuesta_id_seq', 48000, true);
            public       federico    false    183            ^          0    49178    moneda 
   TABLE DATA               %   COPY moneda (id, moneda) FROM stdin;
    public       federico    false    187   �      {           0    0    moneda_id_seq    SEQUENCE SET     4   SELECT pg_catalog.setval('moneda_id_seq', 2, true);
            public       federico    false    186            T          0    24939    presupuesto 
   TABLE DATA               N   COPY presupuesto (id, monto, asignacion, beneficio_id, moneda_id) FROM stdin;
    public       federico    false    177   �      |           0    0    presupuesto_id_seq    SEQUENCE SET     :   SELECT pg_catalog.setval('presupuesto_id_seq', 71, true);
            public       federico    false    190            Y          0    25005 	   solicitud 
   TABLE DATA               �   COPY solicitud (id, colaborador_id, beneficio_id, solicitado_en, resuelto_en, esta_aprobado, creacion, monto, moneda_id, estado) FROM stdin;
    public       federico    false    182   �      }           0    0    solicitud_id_seq    SEQUENCE SET     :   SELECT pg_catalog.setval('solicitud_id_seq', 4395, true);
            public       federico    false    184            V          0    24959    subcategoria 
   TABLE DATA               J   COPY subcategoria (id, subcategoria, categoria_id, categoria) FROM stdin;
    public       federico    false    179   ^6      ~           0    0    subcategoria_id    SEQUENCE SET     7   SELECT pg_catalog.setval('subcategoria_id', 17, true);
            public       federico    false    194            `          0    49186    tasa 
   TABLE DATA               5   COPY tasa (id, de_id, a_id, tasa, fecha) FROM stdin;
    public       federico    false    189   }7                 0    0    tasa_id_seq    SEQUENCE SET     2   SELECT pg_catalog.setval('tasa_id_seq', 4, true);
            public       federico    false    188            P          0    24903    usuario 
   TABLE DATA               @   COPY usuario (id, nombre, contrasena, autorizacion) FROM stdin;
    public       federico    false    173   �7      �           2606    24915    pk_autorizacion 
   CONSTRAINT     S   ALTER TABLE ONLY autorizacion
    ADD CONSTRAINT pk_autorizacion PRIMARY KEY (id);
 F   ALTER TABLE ONLY public.autorizacion DROP CONSTRAINT pk_autorizacion;
       public         federico    false    174    174            �           2606    24979    pk_beneficio 
   CONSTRAINT     M   ALTER TABLE ONLY beneficio
    ADD CONSTRAINT pk_beneficio PRIMARY KEY (id);
 @   ALTER TABLE ONLY public.beneficio DROP CONSTRAINT pk_beneficio;
       public         federico    false    180    180            �           2606    24933    pk_carga_colaborador 
   CONSTRAINT     Q   ALTER TABLE ONLY carga
    ADD CONSTRAINT pk_carga_colaborador PRIMARY KEY (id);
 D   ALTER TABLE ONLY public.carga DROP CONSTRAINT pk_carga_colaborador;
       public         federico    false    176    176            �           2606    24958    pk_categoria 
   CONSTRAINT     M   ALTER TABLE ONLY categoria
    ADD CONSTRAINT pk_categoria PRIMARY KEY (id);
 @   ALTER TABLE ONLY public.categoria DROP CONSTRAINT pk_categoria;
       public         federico    false    178    178            �           2606    24925    pk_colaborador 
   CONSTRAINT     Q   ALTER TABLE ONLY colaborador
    ADD CONSTRAINT pk_colaborador PRIMARY KEY (id);
 D   ALTER TABLE ONLY public.colaborador DROP CONSTRAINT pk_colaborador;
       public         federico    false    175    175            �           2606    24994    pk_encuesta 
   CONSTRAINT     K   ALTER TABLE ONLY encuesta
    ADD CONSTRAINT pk_encuesta PRIMARY KEY (id);
 >   ALTER TABLE ONLY public.encuesta DROP CONSTRAINT pk_encuesta;
       public         federico    false    181    181            �           2606    49183 	   pk_moneda 
   CONSTRAINT     G   ALTER TABLE ONLY moneda
    ADD CONSTRAINT pk_moneda PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.moneda DROP CONSTRAINT pk_moneda;
       public         federico    false    187    187            �           2606    24944    pk_presupuesto 
   CONSTRAINT     Q   ALTER TABLE ONLY presupuesto
    ADD CONSTRAINT pk_presupuesto PRIMARY KEY (id);
 D   ALTER TABLE ONLY public.presupuesto DROP CONSTRAINT pk_presupuesto;
       public         federico    false    177    177            �           2606    25010    pk_solicitud 
   CONSTRAINT     M   ALTER TABLE ONLY solicitud
    ADD CONSTRAINT pk_solicitud PRIMARY KEY (id);
 @   ALTER TABLE ONLY public.solicitud DROP CONSTRAINT pk_solicitud;
       public         federico    false    182    182            �           2606    24966    pk_subcategoria 
   CONSTRAINT     S   ALTER TABLE ONLY subcategoria
    ADD CONSTRAINT pk_subcategoria PRIMARY KEY (id);
 F   ALTER TABLE ONLY public.subcategoria DROP CONSTRAINT pk_subcategoria;
       public         federico    false    179    179            �           2606    49191    pk_tasa 
   CONSTRAINT     C   ALTER TABLE ONLY tasa
    ADD CONSTRAINT pk_tasa PRIMARY KEY (id);
 6   ALTER TABLE ONLY public.tasa DROP CONSTRAINT pk_tasa;
       public         federico    false    189    189            �           2606    24910 
   pk_usuario 
   CONSTRAINT     I   ALTER TABLE ONLY usuario
    ADD CONSTRAINT pk_usuario PRIMARY KEY (id);
 <   ALTER TABLE ONLY public.usuario DROP CONSTRAINT pk_usuario;
       public         federico    false    173    173            �           1259    25021    solicitud_index    INDEX     E   CREATE INDEX solicitud_index ON solicitud USING btree (resuelto_en);
 #   DROP INDEX public.solicitud_index;
       public         federico    false    182            �           2606    49197    fk_a_id    FK CONSTRAINT     [   ALTER TABLE ONLY tasa
    ADD CONSTRAINT fk_a_id FOREIGN KEY (a_id) REFERENCES moneda(id);
 6   ALTER TABLE ONLY public.tasa DROP CONSTRAINT fk_a_id;
       public       federico    false    189    187    2005            �           2606    25011    fk_beneficio_id    FK CONSTRAINT     s   ALTER TABLE ONLY solicitud
    ADD CONSTRAINT fk_beneficio_id FOREIGN KEY (beneficio_id) REFERENCES beneficio(id);
 C   ALTER TABLE ONLY public.solicitud DROP CONSTRAINT fk_beneficio_id;
       public       federico    false    1998    182    180            �           2606    49168    fk_beneficio_id    FK CONSTRAINT     �   ALTER TABLE ONLY presupuesto
    ADD CONSTRAINT fk_beneficio_id FOREIGN KEY (beneficio_id) REFERENCES beneficio(id) ON DELETE CASCADE;
 E   ALTER TABLE ONLY public.presupuesto DROP CONSTRAINT fk_beneficio_id;
       public       federico    false    177    180    1998            �           2606    49212    fk_categoria_id    FK CONSTRAINT     r   ALTER TABLE ONLY encuesta
    ADD CONSTRAINT fk_categoria_id FOREIGN KEY (categoria_id) REFERENCES categoria(id);
 B   ALTER TABLE ONLY public.encuesta DROP CONSTRAINT fk_categoria_id;
       public       federico    false    1994    181    178            �           2606    65646    fk_categoria_id    FK CONSTRAINT     �   ALTER TABLE ONLY subcategoria
    ADD CONSTRAINT fk_categoria_id FOREIGN KEY (categoria_id) REFERENCES categoria(id) ON DELETE CASCADE;
 F   ALTER TABLE ONLY public.subcategoria DROP CONSTRAINT fk_categoria_id;
       public       federico    false    1994    179    178            �           2606    24934    fk_colaborador_id    FK CONSTRAINT     u   ALTER TABLE ONLY carga
    ADD CONSTRAINT fk_colaborador_id FOREIGN KEY (colaborador_id) REFERENCES colaborador(id);
 A   ALTER TABLE ONLY public.carga DROP CONSTRAINT fk_colaborador_id;
       public       federico    false    175    1988    176            �           2606    65614    fk_colaborador_id    FK CONSTRAINT     �   ALTER TABLE ONLY solicitud
    ADD CONSTRAINT fk_colaborador_id FOREIGN KEY (colaborador_id) REFERENCES colaborador(id) ON DELETE CASCADE;
 E   ALTER TABLE ONLY public.solicitud DROP CONSTRAINT fk_colaborador_id;
       public       federico    false    175    1988    182            �           2606    65638    fk_colaborador_id    FK CONSTRAINT     �   ALTER TABLE ONLY encuesta
    ADD CONSTRAINT fk_colaborador_id FOREIGN KEY (colaborador_id) REFERENCES colaborador(id) ON DELETE CASCADE;
 D   ALTER TABLE ONLY public.encuesta DROP CONSTRAINT fk_colaborador_id;
       public       federico    false    1988    181    175            �           2606    49192    fk_de_id    FK CONSTRAINT     ]   ALTER TABLE ONLY tasa
    ADD CONSTRAINT fk_de_id FOREIGN KEY (de_id) REFERENCES moneda(id);
 7   ALTER TABLE ONLY public.tasa DROP CONSTRAINT fk_de_id;
       public       federico    false    189    2005    187            �           2606    24985    fk_subcategoria_id    FK CONSTRAINT     |   ALTER TABLE ONLY beneficio
    ADD CONSTRAINT fk_subcategoria_id FOREIGN KEY (subcategoria_id) REFERENCES subcategoria(id);
 F   ALTER TABLE ONLY public.beneficio DROP CONSTRAINT fk_subcategoria_id;
       public       federico    false    179    180    1996            Q      x������ � �      W   �  x��W�n�F>��b�	Ē�ߛ��q�$b���2"���.���>Jo9��C�G��uv��~h��j�e����7ߌF}�D�	��׊�`QKH�珬�e	��j��N���B��(%gא�T�F��̠Q���[M�X4g!ٕ��K���b~5���H=B�l~�����r�,!E$_���Ň����;�)W\#���*��\� ����`��*�S�PZ�o��1��H�nU�\d��b�"�C\H�㴉c7�3"���Aӳ��e�_����kxV5������S��A��v7e���
	�.���f��ڸ��Cd].����:5�q/p-����1�7����`�ȿ��ʯFD��y�� ��ҧ<領$�H�@����~�b��������4V�ºHT�F(ʐ+#O�Ϊ)��CD��h �� ��r5
���0vP���_2�![�A�7Q��D��)�FT�aR13�#Љ�FU�vs�EF�\�w�	������Y���1&���>�z�>aD��Ȅ��4����Y�_G�%��8�lA��c&"E@S���ir�����eM�z�<k�P&��w��H	?��f���,��$߅��B���x+��'���)Xw&}�p�A�XquU%!uIѴ��X��)�zJS�՜�[�U��˯��6�;����]E��h��a�����ԡv2R	����|\S��̒'2�[\ZQ�����X��A�dI�����l�-��Mlh�Py���wX�Nh̚��(p%+�Z�F���p&l�'�ݤS��dhp�?y���,7���`���|���@��S�"Jx�L<2��K-�<-�UE�jC �֬\�g���י��]#Ӗ��;ؗ'����t
?9������U��w��$���Lla*}:�z�~Ż�[T�t�Q{��C� ѪzkD��t��?
R�U`��K�n� �����)2�2hC�Z�/?p��j���yO�$��k=ؑ����\M�����~����I�,�	ܤ���y��5Z2�{�*�wO�,�3�iN<b�}�3޶��(}��e�XU0N|���Lm�Cu���Q�=�|As��¸M�Rڱ��u/�,^ZC�r-�i~*LK��ͦ8b�~��q��I��֡�cw�u�n�"|sx�n��4�:�M��=tMԎ����L�3�xX}�Y\W��`��H ��oy������w"�������*\C���H�Q�z�W��T�{�L�IT{�緝N�_�o4�      S      x��}˖Ǒ�:������%^I $�أ>�����J2+��1_��Z��n�������#*#����Q� �2�����5�h�w��vX={�7���f�^�V?6C�_?5���Ӯ{����c������O�<����p=�Wo����:��K�b]��O>7#V��?~WϮ��u^�F�ݼ��}p�i�����a�7x��q�]("=�.�x��O��ꇻ�p�����E랚�a��?֛���~}�z1��������Z��.�-��M�Z��1v�u����M��a�ۛ��z7�O��v.���mC쟶��d7ڥ$�6/�㝮�����< ���=y��n��'�k>�ø���e��f�������*�G>��{�8Ӽ�؜�-\|Z]�6�a��:yLO	=%�й�m�s���>�����l=d|�������D�:��ŗ��	y�ȉ��䞦'��I���v��nȂ���1ַ֦��ӴT��^������W>�᱌��MoU����/�͇�4���y}�%��m6��a�O��Z|&n�����>T������z3ToR⺎���?6���������y�N7�؟�׻V^ZϽ˿{�>5v7P���v�=Pov�կ��qo]�t�?��Uu���ӛG*ڧ��6�����f3>Zߥ�ńM�|�H�7����yv�'Z0-�M��[U��2Ӕ���p������ޏ_��[9���;<��0GO��Z�~�����p7��3g�k�{�Շ�Av���k}�L�%�������%� η��M�8Oq��$�7*���ӈ�_!�p��V���Ŝ9n�<ԝw����Y 6��?`��%X���aн�������	��8U�O|l^�H<W�;�������}���>�^ݜh�h=m�������z�nN�b#tc-fu�ܬ�o��aRo�c�G�YO	-��6�?�:��11؆tAF�|'_𠏲��a��������b�dX�Og��O�y��˸_�:��}=��aZ���q��=��#<c��w�~+f��pwÅ���ᤖ�R\����e����q�wx��bm�)x�mr��� y�j����E�K7�e��2���Zz9o>vѷ��ѓ+�csa��X}���1�����b�zy���e^�����І`��K�o�m���u;����~��f��m^�H����z�N��p��'�m�#��.>��y�X���]��z�|w�1�c�E1!�<�k�]����I45�'��JKu7텕�y�Oïr�YY=��wӳfL�SV({�g�+����j8vi��<�ao�q2��U��'�Q�z"O�P=��	<�	X�Ey��~'z��7|m�0��;9~��lGg�{����g�����.�'1ͤ���u8������� ��9T��������I�6�+�K�X�z�� �CIC��D�� �xs����5���o�R�x��u��0B�lg�ƦK���v�\��.�r8�%a |h��n���lo����^���y��/�h<��"	r\�NDW��� .%,�#�~;�>u�`�R��R��$疸"۫�$��6�8-����f������{s�����b`�!&�}��A�&��sPs��܇ϻ�D/�-�aRK R��4)D�I�E�v��ř� Ӽw�X���ѩZ���X��:\������9��Ǯ�挼���5TF �������S�(�[~�(G�$ A�'�W�����z�m��zX,p|����հ��=�2��=,�V
��WwTt�k�qq�Sl���e� ~INR�]u�3U���>�	i�����.�`��gɸ:>�"�g����V5�f<	gr�>�\�g;I�~I7�ڝ�w�������h��b�m��\�^z.��yZ�t�pn6�͇���斡n�,���(F�����,#y�UAX�y ��y�8d�8b���&Ơ�oV���U�/���zw�n��ש�[�pMΔ|?��tQ� 5�Kp�k<���b�7���N���7O���Rc%hQNRߪ�2.rm�Lk(D0w9�5���<��C�P;�$G|�O_ߞj�'�y~�K]�o��h�p��H�e�9{1� Q�>"�A:L�ʪR�D�)�_��P�gۭYMA�E9��F!�BN7G˲������f|���_���@��ޖ�_�w��{�|��=y�'���ݬR'9��� Ƚ�Dl��������j���$�����i����8�x�N#y�(�%�l�V��	��j�#�ؙ,�Cd�'�V0��U��!��^��o##�wNe�j#�L$��v��S�R�/7PΛ
�����@��g��u}��*���C���.���a�5�1�ꅬ�BK[�ɯ�a/d��o֟F�܏���ŀ�G.� *L��I �V�9h2�k����$X1�٭8Hn�רc!ɴY��L�؝`5���h��'Z�6L,b��#-����JM��K+��7���]B+8�����Q�ۚP��As�|0@!�3a��X���`6C9|���C���\�|ڊ��b��0x��,��*�IQ5��/�g��w�S���+ZI�Z[��S�����œ�1��'ϘU��͝ �׻������<4�V�5�0a��[��h}tx?P0c������M� �0\�sq˽w�m 651����]}(	���D�}`vѻk-j�K��2��Rb���5��F �*p��ɿ67��x
"���#�K����h�(o�8���u�DL�A���5�kJ�KRV3�0>��=�C�͏t ��IVS��4�Z����A_����,�yҐ�� �^`�c��>��-���5�Qu� �+�$�ʬ�5v��j����4Ǌ�|���|��@,�魆���<CMF4	��A~]ð	���<���'�#�nƎ���0a�4@�wo`F��m!˸�K��A�3��,�|D��ߦ�u��ДJ���Q,60�H���=C�4l/���l���.��g�;H�.,��8ti��b�b��m�p��O�)���$���$��0ۀ�2�a�չ #�%�ŧ���PF��8=E�$���Xs�8 �,�=_�q6�թz���w\[���a����	Ծ���4<Ji��}u}�?���%0���D��1i����8���Fkأ�!�8~����w8l�Y��Pj~�s��|��C�5-�k��d�Z���!�s��_6�_�ao`)����	M����	S\(�&Y9Y�l�J>$?�ߓ,"օ��J�~?n�k����5^�>0�-y`��p�}`=�s���v7�����i����3:{�]�ct}����<�6�mv��R�+`e. ����0I�a)�k^���f���'�bH�32��9�{�R.؀ǣ��*^�Z�hVE��_��Eh��K_ 1�/�&�HQv�~�Xn��d�`�~��PJRKI����R^���:o#�m)�ת�������z#���E�'KA�y��E���w���mo�)G��5>7zC�c--J%(+g�d�/�%��:�c�`�clp\E�B�=!�����|	#Q1�Db+bRƲ,�Hv&�#�K��܅� ���Ɋ\eF��c O�](Y/�:5��eg�Od���xp.�_�E��79j�qKf����[��NS��|�/ʰ9|Gtl��@��y'��?�T`c����V��N��<�E!r�ճ.��\�yw����WJ8U�Q�D��ņ�
�P5�_���y�l�Woc��#Tn�������_�6�o�5�4) f�D�+qؙ�>�ИVSp��b�2R�N����A �Í�r�{|��Ϥ#H°���b��$�O�c�d�H�Y����->��ޡ�x$�z�g�<��n�f9��6�hi�$���9�,KY�p������� a���m>���~�@�Z�����Մk,Bl.lj��8��5Le�Q���Á�hM ��R�!Ζ�!�xX}U����%U��,-%0 <mh��(?~��W꧔��(&�H>��S�;
�>�    ��zp�۠񻑇���r�aXF'ڊ0����ƕ*o9%�i}ʴ"1�$�	������leɷ�b�?��5;	�J9���å��m��'��_v{����q�GB�7ԧnu��"�����V����P����iz����#�4� ��KC�@p�󺢈��{�'��c��M����;��o���R��	�m/�� U�� 7���O�o�V��0�Ɛ�.�2����	?�,\=iA�gpi�\(����Od�)(|����p�f*�f�&�֤��%���B{��񢀶�K��A�)=����*�"v�zѷ�r��`���0;}�A��0��7b5�c���qbiY�!D�-��P���]�0cwZl�S��� ��W�V߉�B�����|��a�뷿Jj�����X��*�B��k��El�cJ+a�l�e,�>0C��9�"
 ,���l�f�D��9h�1�hd-NH�6�_ ���D�q\�x�^��E1�����k�r}��{��`�0��;q��<QLA�Me��zAK���E�y��B�e���L]��K����pfT��?�^^�����$pI�T־ !�e����+HI�|Z�o����os�&�Z�E#r�z�
�p���K%�"��C�Pk�`ZK�')[
�&��᠄0����2�1fT�N=�&�
"��`5,ԠI�E�+Ι��[�w����?� ���÷�mEi����#�:�z�ř���@�S~�H.[��}����,�X�t���uA���#[�w����aw�%��-�:(Cb�V!�@44����SM�RJlxƵ���?w�ת8.�J������� �8�x��_�L��̓�͗G�-�|~�tԦ� �tO�2��{x�O���"�a�^K�5,�w3vQ��?��0�{�P���(��x��.?��̄"������h��8�]p��;)���X��X���F��#�-�������_*�E
y9�Q�m@�I���[��o<P�_&�_�lRvao[�:�_�j��HX�u��]5e�6P������_�&؈�^�C^3!��L�fͽ��f�ۯ��z�3J��)���ɫ����7[�W��֟����Z�\,��3�������r#�.�Q�E��趽���UK��b�c�t�%b���S���Ȟk.-��Kn��$��#z;�?�MI�$�r8�N3���G8�8/&Q��6l��I�������W$�˜��ے���(I�"�i�.k�B ��Ϥ˔���W���հg����:�*�6bD��,Ê��O���CN�i��]c%�Z��R x�)��$g�{{.�U�����d�%���N��u��e��n5s������g����Ƥ�lN/t�ŭ��B2pN���(C�<,/eL�-�U�$F�H�\k-@��LT���I"���d%�  �T�=\�J{v}������j�
�܉�-%����:�KIxD����d�Rs/���xC��e�! ���5�a��
	�4��'.�~o�KҀ|`�R�]d���&�n�7�ϧ$/"�A�gۄfS���גXo2�"F� �X+�ģP֞����K��W�ob&�5VU
��� 7+Nep %������z��6iwNwQ�/n���L�cGa���ھ�M�L
L��6�к��QDv���n�HG� a��M�����N�ƾu^������ݴT�b<�..����W���\�^��1b�(�&c��t����*�og�Mͫ�����DoYJ>f[k��\�ks��r�(l{w��~>�;+�L���B7/vLd!�g5�!�2�"�Ɖjo���>��>���)���q`�c��[*�9�~������k�_�U̘	&�T��"��3�[M�j8��5NX�LG�Jy딫΍���04(�=yg��Ftb�"7�A���ZW�	%���'���p��ٜ���)�y㎽(&5�KlX-ٻ�FғW}�c"/ֻZP������{���vBv������.x�P�P�.r��%�y7�F��������*�4INnGb��Ǜ�H|, 8��1�5��}�� [��g�Lo��4�`/�w�R/�l�/��t���yd�.c/6���\�X�4.�R��������I�X�'K����L�Iz��hOC�}�����	�-��	#nA�zoKGC�-.�UN[�i�pZV���oX̋���e����BP�G�	<�>-r���6��i9����z&&��"��͗I/gBhՉ�6��
�BH7�YY�Z�U����1,��V�OB�$�3B�!���^D�G~T1ֹ��`�7^
��_��KY3��p��t�d�X�ّ�v��[�|X�Fj�*�Q�����&8!^�5���Uc��A�z?q�%�JQ�~�a-�e&�Ip�Ie���n��f晈V6L�Q���נ��L	���(Fk/���ŗ���At����zw���7	�3ʉ1=��F����N�x���*��%��Ե9�8=��Ya����A'��gZ'(���n'b6��#tqfF� �Y!2�!��R������@�wr ��ss]*�y�
8)p��K��l_�� ��dTڀ�Z�͂4`�pA@�2�?0K�eb�N}���o{u�FZl�[��O�`4FF0/!S��u.
�|�s'D�uEM��œQjƶk�1 �Jn*����I<�C��b��r�pA3}���1^V�򫍨@)J����׳S٫�H$��f�\׉݉i:���ǅ,��������,�V�NV�z�T")䶵&�k���d,��̻�Y�&E�)+�W[��#���;@�/��×�P����_�Bf���@ev�K�l��%��@,�{�{��S��
y�t�R=�-��3=K��D@Z���m���@�i!��'�X\�*r�v������J�6Viu>U�*���꣤x{����}G~ۭL ��0,�%���ެ��t4*}b땣M~��g)�Z���'L����R����S�E�<��P�(i&�]��O�S��OB��3�'��h3����g����\X��V
�B����"Q��ZW0eބ�Dd�@&6Vw�%2�8_���E�J��-�s�[� ���NF)����NxJ��χ�~����J�cl	�3�Ppff[4f��Z(!Y�9 �Hf)#L<���� N}��{�F��g0o!��aW��-�����$"
A��ӭ�O��g�r.�ع�����M,O��yXU�$^E�^����]��aƌM!��	1�V�2r�~]�
>�wU$c4���BVn�K}���4>�x�ʤ�5@)Yo�v�����r������gϗ��jכ��G�x�t�*�$;iN�cvE�i���������b/���n��8#͆��2N�E[KF� 2)��&�XӔq�e�r������b�N9�T�ڊ��	��lYF��}� ���[X����	� >��жt[iZTӱ� ���y���^��|S)�9[�J����h�`�$*(7rB�I0�-�C�-U��$))f!A��R�Hh�Kb.��;[�i�`�?H��m_2ge����*V^�����������  9���s|��צճ�L�� {#.ߠo��ɰ]%x�ʩ*��rAw!�{�o��RW1�HX����Q�dFg#�^Yo,�ǣ���(��^�]�m黽 �Nf���g�"�:Ɓ�N��V* ��Z1v�soO�C�/-�e�rYad�S��fs.����6u ��Qj^�Z��	@���Uɨ�YR~Cv:�y!�]ށ��X'3�z�g�N�S�6�:2��/-1�Xr�������2�I�sY��l�*AL�n)+�>��#�n�l6D]��Զ<���~�]eO�i�qd��\~.��k_N�$�[Lc��
��n�v4 ���L=�5f����5/?'�I��/!'�ާ � ��|���N�	��� ��D�$U�,�T��X�r���ZX����+�Iz#m�p@G�������Ntt�Q�6�����/d�a/������0��<����#�ŌBg��b�9��;f(�	��	od+�f��d� !5    9Ҭ�~Į���lv��]���s��<�v:X��2����$6�_
`�nǎ�L��
0Z���2UrL��-J��I���L��	~�bm{��d"dM��� ��;�9,ej���(�(S�&���6$|�� ZJ6d2���w�����4@+g�1"�O�p.��������0e	r�%���.�jyĵ�d)�t3��t,�yV��E'� �udq��μ���z7�k�p򶰖�3��^krJ,$,��r��$g7hI�nH���F�ba�K(�@���Wλ$�Ӆ��(ק�[X�L�W�(�Q� �>F���0�RtS�z�"�q&ȴ�e�N�Ky��#I��  b�}�S��1A��ex�{I
dt�S)��#ِ���u��4^�>����f1FN������N�$L���˫J��W�H��V�
�R%/�����m��OL�S�9�}bF�{d>�t�p�Ԕ��ց �s�p�|-�=�:����2��� �S���.�S<=K`题NH{��.iU4�̏�O�\Jn۲���]j��Q���o$��<%��`s�:�"�4��է���ᅟ-CWt��<�&�Ma�˪2e�uޤ<M9��@my�<��į
�;�ک��e�Hzc)#L�=u�2�Q�_$�� ��x�22E�~T���	���X�����ަ�e6G��-W����������T�&?ƃ�� ���LZ�O&�9&���H�Hew:� �y~��J�V�KA��/����Gl��4��<�Ihvr��f�ư�_�=t1�L�$�t���M�[�J����9>2d
��9��7��F���"�`'g�qx�P�b��#�����e�ӷC�?��=hx �ɩ$(���BT|�\��0�*`q���sI��)�X�'I��RR�4�Z��8lF"_�G����9�F��~���}3�������,;i�BVj����;�LL6�X7�I�;�H�F��L�=[='���� �h�.SyD3#L9@���8{��6�Yէ�])��\�����8���$�; ,��cB� 6��4������ɑ��Ö�B1_��SN��~;�ɽ���i�t��ZT����jlt���R)��+9���3��G�}��\-�����,�Z�:ƒ�ѫ�g>?���Ox��Pڂ+%m��e�V���g4�N�QN�3	��}�p��x�g�]�����S�Ym�6�ZKݪ�Ts~�����=�b�-�U�fp���(��J��h�����<��j��8d+^ʙ�W92�GJ L���R��ɏ��" ;�!�Tb�.�7��0p��=��$����!�C/.LJ|l/-��������Я�G���8���L�V�W�,C��=�CD;� 2��_���E*���M1��2)O�s��P5���[&Z�~a*|"���q�B�1x,�I���A�|��9��Gb��{Q{L�ݮ��D������!-�y�pCP�[�@���E4���O�,���H9#�{J󕐊��҇xv�a��݊
7�����&3�tt"{b|rb�T�YP��y�3��*(�t��ͭˎ���˦
"C2��0�#O�H]�ԇ�څl�BB7����������g랺��Z�io:"�wm��1k�ܰ�"��a.�����9g�G�K��(H'�g�8��V���T���% w��)̪K�W�/���:[���r��/s�Η�YsN�Ah����d>���#OrR^�*ggl�$ji5ۚLy,drP�.d�s~���ƛi�r��:ě6yRmӔ,/c&/V�7�-f� g�J�X��丱?x��ѵ�����H~S�һ<T���z��y�Ŵ}�f��:Pj!f*=s=�w�(�s� �!25��9}|J�6�r�W�i�:*8�*��W��^V���^g>B�L����a���V;x�Մ��#;.��ևڷX�=��+6��9\�	��ru.鹤м�%����l�����eL_�� ).�#�ň�I�+�7�L���Cf�WW7/�_"4,�\���Zp-I�i�� e�
.Sm�ӧ���@R/����eT�\������:.�\N7�WV,B�mJ�� �K6t����� ��&m�2����ʲ7�b�@,��Ni�KAv;:�Z�d���?^Q����\� ����"ȳ�FE�f=)yO�%d��Q��BDD�m������ Āϒ>ci@ T�S}��Z�� i+��
4�'Z
�Ą�fmS��e��Bg���̝�d�尙{�a9��[Gz39?��[��i꙳���h�Fކ�)E�k����)]�m*Z>������vU=�Rd��N��1A+\�KE^2���\�|�'ΝJ9�� X�=L��ӧ�\�D&��f�KbL�b���Y0�Zݒ�#�������Z�s).HPߔtT�BB�����\e���<�=�+ݎ�D�L,I:GO�@����S�m(����ZƯq$�~SغKAQg�UN��Io�(�\��ք��A�:k��� ��<1YV�Ѧ��؅D��E5޳y�b�{F�o �ԙ:՞�=%Y&kʣ5�%׈(����ʐd���ά�/��j��Y���������n���Ă���;�/w.'��|��uF�R�o����=CL5��?�&#�s��u}G�h��gKQ����#�E`$��8,D��_b���Y�E��/�w;�%K0�1����`���E��eQ/O{�ĺ�Ǒ�o�u2?"��B���˵�����|�kۥ����JP�K��<�a��Wuͮ
��f�Χfy�o7�i�4?�L�'�V�#�,��D,/���/e�T>��K���Qt�'��mfç|���������`T>S%C����Q\�*��l���p~1G6$Z��3��iU�+$Ip$��O����5��e�R..q{�k�\�����J���JP�."k6�Cl�3�����V"�i�l\���H���3ı�ș�N-�|?�DX����$h_�������Ok�PI��x[�����%�·%��-�{R���yK�o�O2����R7�kQ��:�^�`��}N �2
]�qGg��|�;�§�fWL�� di�JWv���s��i,��ۑ�#�T���z'����fQ�1Ʌ<9��P��؍k)	�7{$���y�<�M�u���t�s����p�o�L���ni�SS)�p:&^���E���&DD�r)�i��d������4���q+3��f_�}��ْ��8�L�1�I������xâ�욧:�P9�̡��`��9t�v>t�����x�Y�"�N���O���N��+�qꝝ�R�%)m�4G�{�<�F?	k�r5�77c*]�=�����4q��u'�ټ�����t��O�y������P�����%���2�#OZ�U���S�~	WGP� �5���?��K�e��L�䜆(�����؏7L�^�$OM�S��򄻾^���&���&>ϧƏ���X���ţ�Dև�YUz6��Ò����"�[�aP{}�Ė3��t�Pҁ����v5�=Վsun�x�T�Ee��!��!����L��� �����c镢���Q�O���O3ݹ�}�EZl[���!b[XU�q;����y�-wN�O������.맫�L���p	�����΅�~��:fcR�#���2p"S��>w'��>H��l�Cn��Tnu ������G��X���c~���`ˁ)f��5M�'�4��B���r�ܾ	�^y_A��שm�[z���5���as�M#o�����i�z�V�6��s��^^�3[:�Wϊ�ˁ���L��ס��0�uDڛ�ls� �q�}Պ���ؙ~;�L���|��k'��^籍�ӕ���E���rφ{I�B�W��i�4�$�?��Y�`�0s�z!PP:In&��7{��68����n���7�xX^!��v���yg���"�Q�S��p��ȵ�����N�$�]�����S06�nt�/��&��q{}����������qc���7 A��ޕ��2=�4�oW^�n��#IfI�]�~�F|;k���m�N6�.\^_�E��v�
�ߓ�Nm��    邅|�*����ت�]�ڪ2 ���ࠡ�������
Gռ�)�������p ,��rV=]�'[ �dj@�މ�z���n��G���L�dl��	��8�+�b5�o���	Ⱦ��y>��+�HcY'>�4�zf�S�n�ǽ���ǹH:(!�2��MS���Hv���]�^��w�3ZlH׎������^NO&O��������s�9q@FX<ł����Z&�L��w���10Y@-Bc�U�KEBWg�$��4���_Ef$0����H	���~�+��)�1MK ��#���`���R���>X�FQ�N�D�iD �mW��ß���IL�_U�r�-m�������|~4�]���yYH~����vG����lr˞��J��6V�)�I���sL��Z�d*��xE�]Ӽ��To�S��,[#Q6T.t�s��46���~X��f�J��c�-P��%�ə�8��;U��$��":ޭ�g���	4�O�����zJ�NI���N�9[�f;�����v@�<?BIׇ�nF�N��V�5��wR`^�p���G����y�_�D:= �T�/�HX?k����'�����1vj"�X`\a�jd��l:MmĶ��t���հ���%�dW�+�J��!
ګ#Ox 3�P�s�]��w��)ĪX�MSO�֜��@T�L*	U�gGn�h,��C)��΢vF�h�?����V�;�ZT)2jW����i���	�����ڐ�z,?��z��(#�����Ǣ�9w�g̒~|�Z���l?��"����ͣ#���|/����'f�� [�n�-A�N�<գTZxV�ʸG��F�̱��Ŭ��G���i�U�)��QD�Aaf�A��y�����"&�bNe�1o��<�����K�yi�,=8�ogdXm�y�����-���,��S]��lۤ���]���vވ��d �z#c�ss��m� '�����l�]��.��:S�{�K��֣�S��(4�ܬ�!>�Ǌ�N�*DN����n)��,�G�An�D��O!fnX���j}}��QMvA�Gm <��2&tPLS�т�5(��v�k���"f<{�!���u����,!�!��E@�CJ��sYLS��S ��9 ~���9��)�A��D��=[�>-\�{���n(��c!&���;�$pbW�/��e����I�����r�{��@cVo }Lt�?J"7a/���b*7��� ��d�T憱�A升�S�A���j�}��B$0c,{��Z|/�	�Z�[�÷3��Oz5o�(��Q8��~��у�y��D=���o ��xJ/N�V��C
��;[��>S 5ꬔX��ԫ���k�cn� gJ�ͼo˔s#1��j�)f+���2����o�a[C�N����θ�@�y���q�i����+2W�έ�󈨮z�^T�3�(�y�0�I%	��|+^�� �F��4ȭ���>]�+5��t��d���z��8C����jc�����'�-���9��j��4��؜�Dp��aJ�bg7U�$,��������hG>��W%��U�$�L4l5ı�Ġ��Wz�*�f�W�{	�h!�����I��8fy�Z�|�,�p��x�����u:�=E)K��=yc!6@d�#b��}-%Oס#ޑ�f�+
/�q|O,��㓲!��'�MN��~���<g�pW�l�i�b�*��I(myy���ע�N0����� M���OW��qw7|]k�������R� !����~8͗78е�^ ����e��)9z��K����yS:[��	!J�0U�A�^��]?8�~ʷ��R5��U�S��j�P��a�!��H^�$ZUH���CZڄ����m.ޱ�n��	�����]�"�H7 �i��3J��w�xKF�	|]n��Y&i��t44�q6�@�u]N�f�& �$�r͢R�vld���Qh�)Q��I�:q�z��p#�b�R����o��Fgu�p!'bK�˙cW�5i;-E~b���W��꧓\���t�O9�Q���������y<O�L����R|<.���)m��拤5$���XR�&v\^D�`�j5h>��4�⋴!�CZi�dN�ΙӡU7{�m�"ci���Q���vŀ�V�W�x�֗|��(f	>@�^r�+ې|����cv罶���<�ԬM9	���m].�g�B�e��ަ�s�Uc���2��rB[R�yq.oj�ܡ"�Ng�X�Wp(5������$V�(J�:�Pq�BP�W����S	�v��``+]�֣�\㒭e_*��/x3bx�@~���*���v�V��o�z�#�	o{��/��x��PF�t2��v�a:��i��뱁^
�3��B���A-^hǑ��}Y��Z�]���Ω� ��V���%��(��Vb�z�V��D�u�3�u�ث3Iǰ8ͨ�qd���&�����f*|ϟv�w��y�����=ogdOǎ���ph2�l�	������"AZ��q&M��kgV��	w�����r�7q�/E=6Vٌ�s6�sf>������q� �B���d�
�V�X%4:g���Z����6*l�
Hΰ�]�k������z�J��g���f,�S�e&V�9����܌*Jd�)�G8,��J�.*Y�(��v΢��k>�`�J6�`�5|t� Z].��d��L��9��IY�`t�wCa�f<�J.	���}S��g����f,�V՝t�vs�!Y<L+�����
9���^�'�>�GS�D$c��
eΕ�l�x��z{X}���)�we�L[2@6�
����nƁQ�~V�o��¦8�2�Uofe�r��2�fC��zj�1^�{p�����~�Hu�g8U"hB�Iu�Qyp<N	��-AD^K��|���9���'C�K�b\He�L+�$<"�jʥM�@�3�~���Ô����$�g������
�C���8-���rz�D߬��&Fx/�nk}8�N��Ć�kǐ��{`�� YAbӬ��/�����Z��D-��qr��>��٘2��YN��]��Bɵ����H����[���%rw{;�au�/�o�1�]S��;Ҍ�������r�=l%i&��
��޿��v�<�z"x=�'>�O�Rp��xΛ<���*�\�$V��Cn�'�ůiVp�J�J�,��U �G�~j����}:�7J򯫭
��V�M.M_��\9X�D$��!��r�o��jr,r�ǻ@Je�HBH+��bw}?H�޺��Nڡ���"N6�d��v�G��kM��R,�|b ���s�ǚ�z.W$�Z�^	\���I�1ٙ��
e�-�1�6v9��u�*�M�&7�1�m]N<*[F>�$�x�,;`+#��x8�L�I袩���/�dؑ�-"-G�%j(î�>�CAt�=4}�,���Q]�%�#�È��8[�:�{8�%~d$�08��I(�Q� �d���ͮ#md6�ε� "�L���K����h\�m6rr� ]��9M6nn�M�L��~
Z:�����HX���LaE��I-��F�35i@G�٢�X��'���(����$����4�&��I�E�j�(����%M���B�^��O\�VD��{/WP�QhLjs��֬�����gF��������E���%��`�����b��E$b�0wyq����{�ߎ��#;���v�vY�sWY�d9WR����0&�#81���n�(�26�Y�I��ϻ�X?���Ny���c�
����`D$O��]�uKR�VaUz=!J�`e�Ք`��`���������Tם?;�/9�]:��~��9���
(*�y)�����j��EvMc�q3Cs���j`va�c,T��@��}�R�Q����p�}��N�7Чl�D!���Y%��d9�O�11�![M���A�0lza��J��+<
�I�r�s�@ ���yRpx��C��t�\m�r�e��uy��頄�6="�F��,W��s]s��v�?�_���*E���Sl���9��?nGZ��ܯ�KN��z�9䂑����{g�Gw=*�O�r�@�{�aM��I.m��[`����a��r��ş�����P�`�rP�6h����ً�l#뀒 �  ��[Vy8��ƦW��<T��H𠭛�ǯ�aϧK҂��B�c�����dLW��
'�?~�����d�_e¨ޣb�'|�U8|��T\�ě��:�S��:�u��8�s�4����-���N(�#�N��y5���Ѝ�$�*	!����")�^JA��s�>a�R
6<W'$�9�M�o9s�h��u>9٧���뺜b��7�H��Ƙ��w�]�gj'u>�!Kc�����f�`�:;�wR��1���r�P�J+��N;k�є�a	�K4�%&�^�%V?o�B�/߭ �����CK>vgZ}�ڋg�9|*}8���'�֛�υ���Q�i��Uo@/T��(�o�Skr__��zY}���Ff���߬e`S�J�c��!���+yi.m�g�l>�C�2���BY��Z�~�,��:Cn^7d}.D��KO-c�]�c�5��^/ �K���2�ʱ�e���8ҤX#B�!�:�%���B&pװ&R����#�6����NYN� h2v��U��R�Ҫ'0���]-�����X��l�X��7<{�r�J,sZ��|�C7J��W�8����|!CPf���Xfe�Ṅz9t�(!�M��c!v-W�2��ϊ�2��)*� ��)*^�\Zj煱��D 6����M9��_���ɓ�v��p      U   c   x�3�tK����L,J-�2�tM��;�9739��˘381�4�˄�5�4919���<.SN�Ĝ̔���T�2 �ˌ�1�$�LI-�f敤�A���qqq �z"A      R      x�ͽMs�H�6xf�
���=��@>o�I�ARU���+SY��T��Y�3�9��ms����wm����?��xD�� DR��M��ʒ �#��q��w��V�2��M�L��uv�%�Ě�sk��t9�<�q9r��qC?:���������'��1���Kw�e4����(��U�N�Rk�Ͷ��Y�l��P���/�l�M�E2*�Y��?��"��*�g�íu��d�,�����z�X�ta]��}�՜���8�yd�[���lǉ5O���Z��,�e-�E�M~�|�q}*:�q�o;#�X��q���'���P�r7%�mV�z\���&���2˵������{���<}���{��+�:�Np�ʆ����Қ͓5}��lbYgV	k�g_$��^��S�kz�&�,�In͓q^$���5gY�?O҇����!�$���$�xK���?rk�l�lB_<.�e>��=2��'�}<7�>j��z���B�R�O��$�J8��r�H���If�~�K�G
���쳷���ܡ�y�$��3zX�$mҢH,���O��&�B'�Fْ�%�,'ف;k�]a�\�k�E�]N#&����d���nq��xL����v�!}��hmqD6����������rG�<)&��2�O
���!�/.�tj���ydh�<h���:;K:5�}m���:_[�)�Ф�빾5Zm�_��&?�HB��'���׮�$����iߙ��.�38q,B_�Q�%E�M��x��u���.2�<��(�0�f�D,\2�Y���Q�f��I�����|��G)h�N㿔�b��9mϰs�d���Nw�ft��lI��-�t��(��*�H��{���j~cM.�li�k�yAd����Jyh�t��,���'	=��.)2�D�d>YKm2Z~�Mf��o��d�(��di+:�t~z/��lm��-m윖������wbO���ߏ����h��0֔>��Xg��|k<�'ߑ��������_�\���u2_����l���c��|���Y\Z���\��}�т�ی�JN��,�_��E:�V)�ȥ��:�yEd&��Z㾅ʇ��wȣ��Ӌ��� ��H��>���
/=ٷ�B� ݶ}�8O�d"��^�X�2�5~$̰"w�\�iÌ�?y-b��z���0"�!�s�^�<�f��Lrk�帴r�e� �'�L�Oe���l��l�3i_�.��ٮ��biAON��Ur���q^��	?>���J��S��	��%�W�L7t]�μ��DW��ݴ�nR��$D�t%yGY#�l�eF����)�]m��b�nݣ�$թ��������=��{�}z���v/��O�TO�=�'����O��A�@¶����!�(��h�u�(ttc��� `��9᭲�nɱ�X#�3�fZ�SV�d�&|��ؗ�O@Fq�x��L�b{�aE~E?+`����j�x��a���{�yzP6����D���w|�(,M4�gJ�p��o��*��j�[�Q�^{��@��c�E:��0��3�0�լ����X�V����Ff�KOFnH�ӹ�s�.��/[Zܚ>A�B_x���iA����䩌3w	��mR�U�t��U��	ͭ�|m���W��b���u;(:h�ޛ]��	Y=���v݁C0���uv��.?��ߥt�fV2+��Q��Fn�2�����\���&�X����q"�s��޳T�T\w��KK�&K�r�t�^%���>�FUq��,��0�CHG�o8&@�1��P�!�-tN�vj�ߏ��f�S��'����B�4�K�[�׹o��� P �%�'	�:��Ս����� P�`�[8}�px 7�� ��I���ɓ��>� �ܺ��d�"oqu�Gk�����`�Z��������̹�ҍ8N�l'r灲��D�ͤ�jk4B?�X:N.�-5'�rk��
+����"��!*��G_\Y	NԅI^J �[m�5�i>�J������Ev��x
��w�KQ��bcXj��w��"����M��N�{vp��� ;�v�؂�lrA�7��#j7=�X���{��4& Ζ��'�����7D�)�|���vI��-����H	�Χ8I"$w��#��ǩ,w�����ⲩdi�-���D։u��L��+$G��G� ��]������-
�c8@�\�[S(q�AA9�!�un}�nnq����=sk9t�%�e|"7&"��D�Ї�Sl�^1�+�>JR�a��e�>J~����Uw"91�n�ri�����m��`������y�<�n��z�V�q�w?�`k�����vA�cF�ӽ�b�Zi�}��u�2aH���6N^�[��8]l���)]�
PO?���P���ʫߕ�$���9|Gj[�Ql���%-��N�5����0�<I6R�F��%@qM�e���z�)$%��p��H~�����Ow�Y�<l�Vp��8��� ˷ߗVH��Z�c�e���>9VE�{%�%WT̲��S�Bu�;�	+����N2d�r�&8�x��]O�1�rJ�舮:d��
��1�r�댓ug�C�*�u�L'���nF���\u��]�+"C:�Qq޶���[6�� ��>� �(�c`�-nz^r7������H�eKw���ɐ7�}�o�=OZ��"���&�?����y�;�ogD\)��k��k��E���n��2+�?c��tw	7�Hm�Y���/���:�^{�u�Bw��mb�����WB����{���9�`�����u����Sn�+G�u�H��d�ue��r7�y�C�3�9��M��{Z(����~���Žn~	�B��ta�l2��>s2%'0����bɁS�_��e6�e�uM���	�N��F���s:�~��6�^�OhA�W
��u>�;j��/]�__$�!�؎1a��}�}����?�c�P#�w�鱘��|�bz�mS��b��b
�#�Y&���i�̍�ȕ��_W
bd�[����p}�A��"?��G�"C�F�$�A7ہU��[_�i�����U��ј�*/f��e��"�9�Jl�e��5���?ƨ4y���&Y�����O91AN���]N,��nM<���k!x�*����ۮ����'����]��</��K�\e��_�MN7�����ԃT�;0�
����~�n�,5˕�'c��㞧,��"�rK��u:�ʙȃ�^w= �Nrd:o���g=!P؈<����qr�\(Oi��U~�(�︢���Qhj���r�3P�\����:�?Ͷ���K�Os,\�������0�z��%�~F���|,c�A�,�x��?��+�N�"�5j���ИO�z�G1',�Wn�V�<��k��f�u��{M�dh=u�{�)E��	�
�f��,+��-�<�<�pBJ7#���Ԗ3� �%HB>�s"}<�\�� k���=k¢�@�dY��� �Ւmm�*7�G���Yk��u�L�9}P���a��^�NZ�H �;��VΖ���@Ù+"_�)�	��W��"M|���+sT~�����s��k�K�7\��X�)�Hz�[�S�(3�6V�{c�L)D�pЪ��%[si�B��"yQ,�Ċ��)ڥ:�뺜:�+�{2���^�����A�"�"��^[��qꇁ�����^�?7�̮-�Kί4q���F&7rf����%����$�P��1�x-ڍ��U�X��l�U�r�qx��M:ےQ)�CN����{����I�A����_����F B�nt@P�����uڐ�=A��7#S0�>vB�t	?E�5���'�7�v7�fp�W��_5���R��@�b�4Š���P6�s3��	�ُ�n�o�l�f�{���İ��^-�[��إ㈢n�}�P@b ���G���8�jk4\�z i3	2��S��t��9N��Sł�][J"	�:}jK����<��� �����y*��L�\o:H9p����}��n���2q�L�"G�t¹���7������'҉c��*�i�&�;Ӫ�ؔ�4�봠��Bh�&����7�ŝ��    �z�Cx��J10.�PFC%e ?t)��G��I��2}�����o�Ev��Pe�#��&� ��Ղ}�b�y����5HVY$�J#lle��E�ݛ���T�$�s���~WZp�B&�ھ�`��U첛@)ky������I!|�Z��PϷ?�#d$r��9�z��-2���/�D���4�է�2�d�
��U,U|Y���P_y�|)�y�T�J��V� ��>�)lm�!��P���+���()����˥pd����Mf؄ts�b(LinE켁UX��I��Ǔ�;�P%ƫ,�ص*���Y*�ܳ�(^���]3N�DTzQ��#2N��cg	=<����y,����3�G�������pR�$�,�T!�?����HE���"�n�����z�����vA����%�E��&S�6㊔�Ą�z�3(�f�{�Xdy4kE���

���Ձ�(��D�H�AEn�9Z'�S3�N�����"�:!8^fu6/��
4�$o"�%�,CQ�j!�.�
*�!y�Vr�{�u���y*6�6��9yz��������駇����Gks����>�^vV$N��oqՒ�:�oh�S���L�On�	_����lr��edBZ��l��[����f3_�Ċ|����Y�(�q�C� �R(��j��՞m��i��M���j)���V��klU4�o�$/k�.'Hx�6�ނQ=�[����uJ�5`z%ST�h����h��.�*:O��h����� X+P������9b��_*(�:4Ŵf6.(�Sd�)
I6���|��~�a�$���\ao���Ϡdr����597�<$���m6F-1O�Mg��3\��C��I�E�m0.pK�A���K4�W��U�����÷���ƚ�����V7
���x\�����AJ��� DZ����-�������O/-u?H	�#�Ɂ58~	x�p[c��6�D�/P����x5�䗑�)�̼I擤Qڣ�0OۗY���G��=��]���%i�ҏ�����L���2f�����W��`�5�u3Џ͖�-��d�q�S=o+=�On�4�>���~��2����| O1O)�]�N���<9��)b/
"'l���@N�.��n=|#���zF6]f�5y`P�2U���cR�U��� �*��-��:;��AP7,nƥ���VN��ҨaD���#���4����U(�e-��u��݄R�3���oNb�ue}l�|K���[|�2;m�_u	B6s�4�BZA�a]����L��KE6Rr�$������j�����"�@2�-�@�IBa�3Xj�]�Ȫ�U�j��8�<�Njķ!A��-n���d��Mv"�#�s{X* ����O�(:���g��sO�U(�h@C3�R*���/�c�G�3W�ԠH�SC����c?bx�Eڼ�z��<�)s0M�/]m�x�,��"�!c��2o�l�G���+p�S�6�B���	�������.:�7�z��!�G��XD��]�j;�K��5!�3f�B�s�\ڡV���O�1��>H�s�dX��Ṕ��%#�eH����q}e��(����5B�����5��@j=}��v���=�?�w����\(���U�F����8bP����X7�
��v[���M�i�ܖ
=,��Y��t��Ms�QȞ>ݗ���U*�w��*���|��`[i�]
��Q���"N�Й0!��bǓ��a*T��&>]��&�j�t��^d#�IpP���R���x�it<Qe��C�0��P�U�u�m7_��I�̌8���k�F�6L\m6E�(<'���L�p�t#���?�5���+|s�S�+|�%l�6j�`[b��D��(y�Y�`3!�pk��3��1�F�[o��ׯ�?�<Q��˚��?��w��X�#�Y'LpM}�-͢�vtITL�*ݩ�:�d����&��g�Jwe��U�&������'k����ǻg����yg��?=�&�(�{�Xߒ�گq\��\�yp	Ћ����fI���WX£ 8��k$W��^k�lww�6�v�;�֎kt�S��+�^Cw�!گ�}�f6+�-q�[�8��:���j4t��T���s B)�^lo�}��4�8�QV)^���^t�*c���&G�1��O�t���UU���\���=^*p�v���*���5� ����<�c��"@��/^�D]�!W��+�b ��Q�9��<�݇��?g/�WvڡU+�nŻ{;��-��R�j�ml3T�	�iǳ8�i_g�k��V��)ָ!��aг�"����U�m�����ߏ ���鈁E�hWK�#Gوl3MtW>�m*8TƉ�v}M�!7��`�E�vp6h�>�v�ڇ�l�::ӧ����Be�e:M���;̺~n�h;m�Ý�q:�1��HcˣlҢi�t���s ����J�Ud3^�m�=�|���:Ɵ���::j�,PZDܗ\[�ڷ)88o��o1?4�W�.��z�6/~ �4G�He��<����q]��V,(���Q	$���Du�ekz���ґ�a��*����
%��	��6�æ�mƘ`p',G!����|C��Z��h"�;����}\q����R��´9��A	��햓Ù��Lvq�(:���˝��������V���D��3"	W�p-��қ�|��[Q:��>�i�ю��&sԵ�g:t"G��m����R�=?�?����N䕹�ū�y��)"���-�j0x����jƑKC�M�
�W�� ;��t�M�� (�Q���j;���nܜ2u���l^���P��=�����9\��UAW�r}�!_�e�����7�M
1O�n�����G�˹����1��d(�V�n���y!m�^1�d��u���dєQq#A�"�qL�H9]�)�n��r���f��6�vH-����\Jl%�>�\��.�G56�բ7�ش��0�p�w���a����$��7G��`EvA˥�7������($�ɔ�����1����he,/�Cz� �(J�-�*r��n.� ߀qG-����O�F�������6��c��yNƣ���|k���4
4�`ʏ����5D�9�	�\������Q��~=�S:_��u�B�q��G,���h}�]�!�8�oT۸.9OQ�7ew:�9�n�]��l|�� 8�䆡(T璓��B��Ф��=�2D��VCV���ȃH`ϓ�|�<�%�;����!���ﶕ5m��y�H���5��i�D>��GzS��qz%ko_y�tY�ݗ�':j�_���deK�^ɔb/H�>�2��1��C]x��y�"w�_��(��e���J~�{���������D����Ǳ^(���X@,��^U��,�XIL��6���Š�vu�8������,��:s����(QYg"�go	��f5^�B�z�
_�r��`�C�1�����	�:a�R�h����_��Xd����ſt�|z������{�t�x�B_`��{y�+���]+bc� !Ꙅ=d;�I�����nVl�
��)��k&q��S#�"<�pb�(�*�._WUb�^;s}B�>+4Z����k�KUc�A!�p
e�q��P���KP�Zz���/e{���8C�`H�_�ج��:EcbKcZ����w��N��K��H(���`���Ǉ7�1��Tl�|V�Ҷ^�P&!�`���Ev��:���(�[W_�UE����ꛧ������Q�D �HE!��X�I�ƥL�ULF8v2�Uw/69����,�8usj� �!�t��&��e-\��
B�!b��z�6?����A~ݭۤ�y��Y��_���gͽ��SY�Yb�`�t�)�w(�3�޼���������^��w���ٟ�w/��O/��fiym���q����K�L� A�����_��ĭS�<��H�8JTL��m���c$����Ɗ�2�pe���JT�~��F�e��iK�pܪk^fWLn��c%�M��z��;:~t�M]�Qt�R�C1e��1��.9"6����ʗ�    �~�W��=A�:����d1�'�^�XˑB>�>�T��jѦ[�e��F�l�5t� y�\;AD��A(}^�'� �hn����K��W��f����d�L�E�)�$�H�(zYms�3J���hx������)~T��U�14�����|����9�`���,�^��A��r�onV�-��r�!�E zK����6�#ʙ�*���@����ة����#�?��q�ߊb��v��b�V�D��F��E�_��ֽ�:�o���~���k�!c�T����a$d�t�1�vy9S��y�K���6�X���d�`��8Rr�6��$�&]��Ϟ�{!_^�h�4� ���(�%��H��ۊEE��[W���~���b��~�{�JǱx��|��׻�\ω�iOpg1n\f���1���{y�U!�q���F�y�&Q��F�:�
Uo�B=gJ����V�{ߐߨC@�Q.s��Z�p��@�]ڊE������	B��I�F�4��4k֠F��xX�;
�WqA�<@)��ʦi5�U�D�U���?Ph�_d�y�^E:���U��@�u���;���u��V[��I$5RZ����v(��Ϋc[3�>"�[����:3�[�J��&!Fg�zb����Ơ� vq���"�Ff�ݰr/�j�����H�>9�tS�VȊ��H{��ECM���M-�6�D]`�Mc��bK�}�%�yE��GA��\�
���#a�Y2E�*��	�gY�ߎ���>8-M_��ÿ=ڟw��bQ�>7*�^:ܓPW^��T�z��H[���5�!-�D��A���0S[Tl�a����@2��Oc���)N\b���^ )�n٪���TC�`�	,q����<���#Ǩ��SrJU-��W��M� �{�ٿς� �܀���r�N��Ǭ��M~?�����}��1V�� ���Ӗbtݐ�eA� ���vYMjr�����]*��0&���e�і�s|��@r��l���сx��Y���)�pf��^�(YT���l�]����������3���2T�Fƒ\;�@⥐¨�4��	(T�*�����~�.�������@3�ɲ�F�z���&=>�,���J+�����x�U�L[���*���s�"?6�G���P�kN�A��P3B�|6�@ <Yk�O�1���S��(si�߯�)韕5X'8Q��m�t^� tz��A�GN���y�f��ZrXIF�'�<T����9*EU�1w��a(�JnUXK�F%KqɃ����d�����*���>�m��k��5p�_ZR:'e���W�t��>ۍ��X��1��w�b�ȗ�G�N	��H%	1<4�;�(�}�n�V�G��t�O����Ǟ9��d~z|��X���Ah!a��	��J��U��c!/�Aфz`�fO��9,�d���"�Q���o�Kš4���2����A�X�0�'CQ�H�s�h����	Q:��c�#���u+��1n�5O΃P9fzi]o囲巿�3]�������}��-��d'C���@�*���U#m�N�lW:���7��&N���,�e�8z���&��1��l���0tKi�M0�:��C�
/sc��n:1m��څbN5!�j�i�[<��̴�O%~-j�'+������e&��C���^l�Hm��+Bi�gU�t7+��+��!�:T���><ɹ���K�B�Zofh�NQ}`]�c��m����[��P��~�{��d��{x�=���:��0�)o����YC�2pB�m9��&%���>Bo��x�>=�b�u�K/bZ�����? ���I[#��Q;��O�LE&����w?}%{��Ͽ����T�ߟ7B���\�fY �g���RG iۺa�9�k�BM�y��G�ߜg�pp�O8)�.)�c'�I���j��z��2�@Kn��kA�*�y������~Q�qF(�sP�>�@Fo0��{�1��sb�ґ���Jm��i�t�F3�8o/�<y�	Os��D�-�p����!t�>��&|t�]�6\���a�H1R�\%��t[�Tu�q���><7���V�{@Z��
$��Bc��5v�R`�R�G��D��(�-�W>���R[7=S�K@m�A�%	��PS�9[!���r��A1݋��i���鞒Q�+�h"��t��S��@7TeC~h�tb�E/ݶX�x�n�b贗�}���
�$[�����B��4����"ڱB��!���PR?4�]��$$��N�s��6K��I��t���~�*�bK#��,n��yb��-���$@
6Š��z�?�4�b����&�yI���ˠ2�a����͒|P�-O�ӏ�@6ܻ�>�2$-�P�<���>l|h���:ꛥ�7�~��`���x;�2��<Wc�v�aM[�Q�l���T�G�[33_��N'-�Di>��6��j
������m���H9���X���ܠJ񝿿�����*�*Zbf�$�(<!,��"�%�����97N���_�,���ת�h̀���4��L~A�|\N�=����^�+	j#xk.��j��"��m�U3����FPR�B��i��=
<�r�3*�@]�Q�"��b;�\��F��t���������(�
l�-�f�1c|]'wsd��p]�9�H�#�]	z�mR��tnY�A�2��= �ۡQ���N���eFG`M�w>����=����CJ��}�hy���ߧ)2�ط��T��YW7sN}�ALG�l�4wb~����bd�!ƃG�{�\�`�?���e&K�6Gf$s�Ea�\3�!�t�!3����*��R=%��o��?u�ܶZ�m��?���zo��Gi_O1/J�z��8m����v;�hO��3�3��9|����[�]����Ka�Z~��sM�1���WYgKg�e���	E��p;�����3O���&��^US�ڠ�3�D����I�4���(�.3�m��v�K���J�D�cR�=0�Z�S�n0'��¿t_��eO~�O�ח����C�JET��VK�z֏�q���4�X.$3L� 鎕����s�j�0�[���:_�-�*
��ײok�3m>�c����r�C��b���2��}��bU���Hx�6I��{�َf�\q��_ﾼ�|�(� <x�3[���/����,E��X��"���m*rLx����*���:/Y�ѐi����ݣ����ǿ�
���K׋�Wg�� �qnu����tу�4l���)���_�������5Ge���`_�_�������C�y��=�Q��\$ӄG�Z�M;�K�44���y2ôV���|qS�UNS����#�0�dI�f����wF�'r?7��� ��I�ͬ�H��3�߆:}�&�9dZ�y1t��~`yz�"LW�e�a�}&��P�k�-�c�4yf���WCŤzt�&Jg�d�W(���Z�"�g^�}�O�갔�&V-����Ro������iMy��hzi552m]�
15����W;7r�!�ɓ�Pt�{u���g�x�w�z��ܬ��֨3c��!��ޗ��0�%�x�/��ݨLgQc)�
��}�I���WA���8������`LW���T΃�Z��IÒ�z<���o�j$+F��l^i6�0CU����{���wPwo�;�$1��І-uâ�R��ڨ>��v��3}�G�Y��׻g(8�>��?���?'�rMo���p$[]�Ȍ�=9~��P�m��H���P����� T��C��;͠h�S4��e�٨$H{|Dst�6B����7w�|����-�������n�z�����������I(���X�b����=�'Γ�w�$�S���!��m	�S�3�W,Ն	j!�y(�1o���h�*�B���$�@�[���u�甲� xf�c)�7L�"҃�?+ʧ֔�%�r��r7���n��ȋ�L[���O52�"�'ec����.��d'EV���򣰻�zeWH����c�����r~�[�i'�|�X�Q�zmm�~�/׏GU��M�9��:��#(��ot�
���X    M��-_�����˱��$��������r2�#�d�ub��3��2��v�Qe�ga*F{]�2$��~��Ni_�j����b��PܯW����J�!�Z���T��j��jd���V�(�lyw6�2y��Ӧ�
_�^����=]�̋����_Ȧ��l�`�(�}�6�4��� ��:�8����̒+��$9�l+Ke�1�b&����k��)��u��u����1����[�7Ƶ��u?���o��'C��ڼ����UFh�Y#�\|ֱ��W5Z�C�	)[��n�i]�p$�B�Yƞi����8VY,! rZKDߜNu*��aM7M��[l2��0�뱍6��<ު�������۝��=fF�޻��_�sB@�X�5���5�oߕ�͸�h���ռ��V`jP�#��W�7�.�bl�o���p��l��'d�F��b������:.�kv�<@�� ���z�����"�nm�=�~o����Zx3(Ueΰ#�pX�:g��A"F���L��uS˶�̎��z�US2{���d��tIm/��![��_�[����:���ӯ��_���t׻�P�C�,��ם������??Z��?�=�0;���˝%�*A7Ԫ/�j��X}
ex�Y����cj(�W�T@�4�=:���D�.w�o@c�@q��	�֣��;���aApq���ɥH,�6�m �C"�G�����~wcو�f�H1�a_;�˃6E�����b}|��v��]a�4�۴v�����X��6�\:��mh�.v�\��m����I�Q���[�^�r�{�rI<$�N!�k3�0����ckI7�{	ozcs��|Gu�1󑢔��8Y�V�����}M �Yʼ�G��ֶ̖ Gi���b�&yЭ��		�=9ӂ���Z�	t[+-���_��t�x7���u�Wwn��������S�X~Oc���e7�c��ø�8s�{ Ǻ�1
��fw�����Z"�S�������̭���/O���a�o;+y������7���b2�H�+����o���ӗ�9d�Zr�u���7���1ݾPTؤ�K�r��Q��Se���.��fK��b�&�I���L�=Q�qO��p��P�;���P��E�X{#�7j_�y<e��\�pyekg$�ȍ��x�AW�H��b��� �H@6^I���S�h���uP��D^��4Q{Z���B �(��yq�T��:��D݉�Hu?6�7��,�j����=ސ]�d�f)�g�
{aj�6t(���-�D�CDh���E��l�6��Mg��2t�cm%�f�j���5�?�ȁI?��8�9�M��:j$�ÐN^�(���l�Y�U˞p� �K�}��V��I����=���老ٮ/=I�S۪<_M��=U�~ÿ���mhX�H=�fM�+@7�F�|�'�O�;��5x��-Jj�������&�V��2u �2lЁ8X9��z��+��<��ť,<�g�z�|ƣ���&ה���h�{ЄhC�d�N��dd�E��8�e��A��e4�X�\�7ϱ�v��Dz��]��T�苃�J�l�@�>�TF�9���q�p+��w��*�I�"B.�V[�`@�3rKCAY5��B�rH�W:�@����9��J$'�5]��g��0c�c��\��qur��1"xe�}��w�DbTQ�*Y#�J��h���H������RvwQ���/n���s�5}��s&�eY>�|�C6>��-�%�z|1�C�75��}J��ٌ�Rxl�f</���4��1[C���S��qD�-��[G��=1�X-�Q�+{b��ػ�rb��aI�Evi�0y��>&M;.{�:���]OU7@��g�@��N�W�o�6���_�O�5�f���tff(m���g��me�!�W��d�Jս�o�#Tv,Y�3Ә�v,E7�Y谭��KH��f�	��i8RL�SDZ�֬Uà���r��mZQ��.��o��JR��ݫ�+:ώu�sẂ��.�`,Q��D��c��uӠq����������l��!H�h����R��+�F;m9�����7�㲚������3)gKn�q=�6�l���ǲ�!�a�L29���K��{����q����O6(��疬��.-^��8]=SD���`_x��1���:��W�>�1�N��'W31S�"���m�D�L��M�1�"�1��az{���4L0�W
DQ�|�,��?�n��*w���{��	�R/��jz�!Ƌ��Ie���Z�M����W��0?Z��r"�H���T�ֈ�aGWMzѼa�I4g
�Ǽh�cH4!���"�uv�27����%G'��^��]
S�$٤L�t���i�2�Hi��y*�)[^�g�7��̀x�20N�9�]�>Oa�De��%X�ǔz��|�4e6T5&��N>G?nk6_I$�HI��!�ou7��-qsH�\M��W5J�U��1a�Β���e)���jsk͵��S��5@�J���S��9}�q��T�Ժsx�S{�څ\\l�b[١��:�� �,s;����)��C�Ԁ������C�:J�GȊ�j�i_��?��o��/�=�7+(���7�)��Ξ��MO������������5m��QaJt����ъ����X50��
�)�Y��
pn{�|Xr�%��/9�̯�)f�D~5��au�?��ߝ Ah���X����5�q��gX�Y�����IʸS����ݐ(v:��VLw/�)ϰ?�X-: �x?xLA',�E�z��ژ`�9f}�&���ꒉq؆'YW��|�$��������h��4P����B@������[��Ή#fd�56m�!͵8fbu���5��(��Q���u%�fu��n�l��QYvԺ�Û��Ts(�}�$�+�ct���u�q{��9�"�R�"�
��4�G>ȉ���[|P]/��bi�"'hV�w7$����#�K>M1�^kAJ�2ɀh�p�ѫa5�����+oO��$�"���W2�l[鎝q'�JOάs���ɜ�s`�[���q�Z"N��	QOU��@�4'ĴX$�A��F)\�B~�4����������vNP��ω�轮W�ڭ��/���B��3��YC�x��~¹QN�2���K�zD��$EN(�WY���ޒG�|?kuR�AjU��$�I_A�]��!�Ä��3`�.6)۪�%�
y�j33��,Rn��Τ�&�K/�������/�[$8�YO-�6f�	���EA�K�03�1�9
<鸢�ݍig���~G^�"|ac��K5��9I�~�V��J����l1�T%뻈�ڋ����l	�����=,�A'%ޕ��p�C�?�\Oćɘ�AI`�*E�@le�A;��;�s3�a 4=M�ny�/V8Qg�7��5��$�ϵd�XMQ/d��NЕ�/BC�5
�9�2�b7�GH�3$e��I�5�R��8Fjr��ӷ��hc@3G1����(n9#'����Z#�k^z#�q8 ;��>)z��P�-4���k���^w�����Y���i�3�;�c~�A�RC���:�jE�Z��q!`��e�ΫT]]�]N9=m�d��i�W����mo�O8��X�G�����9 ��L�.�����D"蠑�ݤkL��c�oȕ�M��no2@0��R��8A�U)�X�+�d�����~�6�A��Ni#	�2��ro�2`v�f{ȿPl5�%�k���wZ�O��I�%`�/���0�P���Eΰ���u���/gKT���b�ջn,�jQ��(:k��Rڲ䭕N37/w��=����kkC��y(�(���6����b�4Q�%ІYV�x:�Aϭ�����qS�crg�f=%SŐ纒8tZ囘.7�q��Y� �vee!��4p�9Lʉ#�b�b�o��
f(N���;�'�_��4����ũ�:BܳP{P]Xd�o��oӓs�\~բ"F�3 4ї�U��TxS�T������
�~�q���+w��~��ϕ���$�N�4M��)ױ��td���@��;б%{ĥ���~ދ<"E̷=-�$P�.!�����������`ʾ����b    f�"놠��E��(�V��J?�7�&�
�i*]�<ņ�k�6a <%tG��8�t��4�pD�J/Q��~ۦ2=FkV�&���<��$юc[��~������$���F�'%C��	�C����l7��E+��5�br�D5��'�.�F����R�Dx��C�NoN��9���d!�Z��yԙ��9���1!�l�-l��=�rv_?�?ُ��v���q>��'.-`$�������F,#WxݪHK�9]�5���ܳ%G带����Zn;��O�)�]�7��S(�S:��bk\L֪��e��5V6%Yx��5.hCm�|�y|��{'����r��6��O��SU��Ո�n��R8�#Tݣ�y/�J�����3�z�K5�Mu�Zh��w��,C��Ŀp�7����I�Ќ�Ø>�P[)�I(�=s���q������;k����hIGZ������J�~�=� ���=�>�=?A������
H��+%Im�����e�|�m�!s�,K}z���Č�Me.�|�/0C)W��]�ȱCKsⷎ~X��Ӳ��M}p@2����b��2kd5�����4(��c�$��+~���^_KM�Cz��k��=�B�=��S:қr�V��2����*W��%5E�g�
\�����d��������P��Ho$���v���-E_��9��X�џ��t�wF�Y��s?��	ip��˜���u� �Vv�h�#F�g<���4�{h�Dv"��gMELG7��uV�t��&�Yߐ�	G���e�!:�ʐi�M�C���<����_��O3���f����rC��n|������K�)��F�L]&
b�(͐���H����tK�=��d%�>=@�����"{G�j�7<P�<�6_�7���3�E~��]��j@�I	"�lt�3�9���E>Uqe,��l��M]b�B:����Ae�m��]�äI�
���<� ه?r����t��S�Q�a�|��Bn�n��#�Q!����y����8�}ŵ��v>��&ݣq9�a����O�wޱ-�j�0���$�Q�	�ҷ�T#����y��̉ M����y���*��ŷ�sB���3P<}MI���&�p��Ҝ���F+�G���lm�~�Q!kǂI�bbfV���a�c�h����0y�岸�HF�ޱ�F�zva&�/L���j���N���)��1[a��K9*��ХSAk
�iEǗ���tĀ���_8�>XK�1\LU;�x�.3��}������ӓ��D�O-kSe��F�MR�n���Em��,X�Q��/,�:�\��hx-sݾO;���-�9�����E1K�\#B-Co5�BK��=��@G�i����Y�v��#�瀲.Ks<!E�����Ы`�	
�k�by�i����_&ɖ'�Xա����	"�ş�X�@�C#馷�X��J���4Rte䄲�!T�[È�v:w�қ\3�F��d|�r�e�c�-���IJ�AU��jl�s#������xu��Dk�{�	ݳ�������� ^Y���/�@�fO�Q��e�-�[�9�Gǥ����#��}/t�}_������;�Wء�A�{+�,��z���B]{/ ?C;����sj��R���p���C�Z,a/�l^�L�Wu+��6W��e=>Sk�CD�\�C,2�a0�,��[�_UW$X�$�1(�{S��,�P�d��!�
Wǖq�x���ṡ�ޥ�f�������5����Q)��y�"�nqZ[�p`r�7��_t	��W����W\9tt�4�P���Jm�@��x��h@+I��ҏ���j��bjD{Ú�?~}$x��xO�Ț>�v�lt�o��vҜ\��hl	|�=iǨ�X�"Oǆ����}�s[/u 8��A�K2�����]U�J�^��L�8Mu"�Ϡ/L �|����sBw�M�'��c�$��x�v���0��ɣ�7�(rN���s�Q}9��˞cw�2�l ��9�Y�ָ+�^-��'g"wϩ���z���:����s9]��ݰx��Us��%�Y��Z�-���<�iR���#��OČ�����I�Cn_�;�[��v[Yb(Q��#���.Q�-���S��􄣾�5�O�T]�`��G�U*�h�MN=U�Ip������D¶���m��.	�B��yj7�E>�M���pcY3�S���tVY-��`��Y�rKy�)yg�*����zĀ��{��e�5i�m����G`;�?dg	��f�8�^0@u��!0R����P±Y
Z�O(;[�:�������[$F�D"��Sb�%Q�T�ܠ�=g�Z��j���#PMq��a�fr�����}0��턍�ɀ���CA3��Dg�?�ע>��W���g߁r�{&(0i$j���G[.r�G�j!��hG�r@gt+�3�3���J���C����2�h*��fl�J�&��0O��ş��۫F}�z�����mrM��������"���՚Π��+�����"�縷�iE>�.�ڃy�����~xՙ�B<-/>�
g��z��K��]��{m�g�F����J�M�=Y}�)�
�z	ù�M���T����8+��4l���]�ȨE��u(`��ӈ��/K�����A�ڳ��H��/{��`���gq�#�����\2țtȮ�2\�8c�L�T'q�����e]cGF�2ײ�V�q���S��^B7��Ls�b��l�0������!�����#�U�YA�
�R���]E �	��x�\%s͸�bh#+����~YQ�݃N��2��Rk:�N{y�LNT	o�r�U��|W����^j�6���,��-0aO��8\�>Tc�a�Bu0��^�}�P�����ǟ�����{�|�5��i�����9`����Uǘ^��PᇥY4����=\�}�2����K�-B,�մ�ς0.�A�6P{�?�le�x�?����,̪]�ˉ�:�sCQ�f�-UM*�PcX**-ūX������ڃ�N�ΤhpI���������,�#�M�������M��u�[GGs�n�{�$����-3�)������U=IJ���x�n:D֓��U�w��O��`Twtu��j��?����'�L���cuBe��^�w��n����(��5@_�n��uG�9E���G<x�U�6y ��a}T
Ǐ�nm4�C8M�q�lK�ˣѶ���y
�1�����Qt�0t��g0Fo	�$�����,ˏc���Z,ᕍdf�C��@୎��j�j�����(���GJ��򚯿�N�ah��j�$扃�ޱ�Vv�!C��k+�/�i6��t���'vj��[�k4�������#LN�̬���q�"�\_���E��x~�رUd�D��r3+9�mCȦ�%�<QS��\/�8�!�wۣ����&�;���|� ��G�]U1_��[�d`�����&�L\�딏��ԥ��V�W���(o[
�MЊ��LQY�`X��x�ڦ��*:{!ƅ�:Vn+�݉���0������P!��;�4}�B�k&Q��oQ�������y	o�F��2�X�m�?ԏ�#L����n��zda��K������܅j$�۬4,��v�e�b�H멁u�˂c��N��VǴ��0d�^����Ѩ�?R�Db8�tU�r&��cg9�^��k�jC|��Z����Et���b��Ł���w��:��r��R��4Cp�H��&.�*6�&�HnX2&�K��6Y�l`(>��H�l��"�nYr�x�,�"��f�Tg��	��j��p_�#�������-q,b'4�=_��e�l���q�h+��$"w���Eu#��������V�]�W�ő&7
���L!��J"��7kݳ��u�#���;�)��$�.�i�vr��
E+�����K���r�r�h�ȭ�5�b�F[�ӥg-���x~�P}㴔f�Y��V߀Z�qp\��b��V�qA�HC�f����D2���: T�T ��:�78I�f��3��)�e��X{SXE(��#�)D���`�B d6�nO�E	l��k�� ��I����o    2ʾ�+m~�)2/��?�H��^'M����=e�2�6Σ�D>�1�Ӄ0�L�Iscd���Q���~�"��2��Q7�����˗'�ew�����H�#p~�5 �$��A�!%(py�)����w�OO��g�߻;�$��ΣF;U# ��D�A
F��o��d`A�k\  �N����;G�p��e��4��BM�����PL��2�����V���CX$C邓ak�0���A�~�4���D|l�jt�"���3��]3� @�qr|C�;映t�Ypm��S�jb��Үr֚_6�醊cW�H��+f�spf����(x��ʛor��=MS�%�-�-/�XuYÉV�=�1�3���M�@Fȥ��"%���f�|��Ž(
���m��.�WW�jb�]�rb+-�.�1��B�_G�io~�wd�"CJ���l�yPt�S�0WM�;W�='���n����=@��IaB/��VVR��\�;��Ӯ�Y������TH?0��Q3��yi�����"U:� ��"˛�fL�hT��b�f�S��Bm���8���y$F���iJ�#�Dm�tK����"�F��Ѵn��vl]f+d:��N���m'ݧ{�v��$J�s�8[/|p?��A�J�  =�����u�W���"%@ ңU��YO����s�o��u%�z�5ɀ�T�X��Ð�BD�;]m)<��	�,��^p.��s%t
z�W����p��8K^3Ǽ�H����U���	X88{��m�W�9}���1�z�v��A_�׌�-o��ck1f���+/@���1"�Z�����>�1��'cZ��(s�(�N�I^k����(�Y�؎�*�͖I���Ѥ����!
U �G�2���'�#�Rk��iZ&(����D�㰗�I����[�}�ܹ��ᮑ&{�����ow��J�`�9
Y��S[�7Wp�9�rĻ�:�t���*��9gS�� ��Zt������o�hRFb˱y�C�<��VH���bs�`�����.���ֈ�c8=2<~�Q�L�[:Z4',^M�$k[m��%"d���*�&].1��[S���w��j�h�%�@�k�:U�0���[��ӯO�?�}E:A����$�N��^�	}#���H@�0�u�L�����&w�k����_F�z�M-���"��;�s),t�5CL�Q�.z.A-��NJW��K��GX��n�F�4bw�IVYR5�k�\�'N���G��Z���20Äc)eDn^}U%�`i��Ϝ��NtF|��̋��'.�\F��d[��/�i万&:���z��-k���J?�.9|��[5뽒�D(����")�kYh�w#��DF|�Y��d\�n���:~O���p� ��d�͉r)o�ɝ��-���%HZQ�{�ر��Q)Q!~0W��� �{}Z<�]	�v`��l��K��R9�=V~h�N��J��m��:���q��s[	��~k����{}�%�@h�[�_����`�Ԁo��J��)���m�RM��Ow_��Uc}c���,W��C��FmZ�ji���=ut��\Q�7+rI�~�CdE$
�<��f���������+*�2!ǌKn�(��?Y�B���'��Z)�#��o�{��~j�&V��K�+��n5eĤEBf&_V2����8�5�kz�^9V��7�n��H�B�v���twe�ČԠ'F����������N�'/��~~|z�߽X.]	?}���v��W���'������:y"�N��Z�XY�@F�÷US���0a�oΪ� �)�w�}1�7\N
��cV�qzf$��黹7�%�S#n���xM{iͥ޲Ά��P2�w�Q)\�A{���ܡ�2��"�D�M��Jw3fW�x�.9J:a�Sb\�iA�B��tUZ���1b�n����'d���U���r�QV�Ѿ�١0]���qDj��t��l5���NK?�	t$6�X��W�B�$�d�g�rR��y������(�[�� �ww�#��^�-Ŝz�W)�v�Lo�
q�.�̽�"G�~r��jԃ[�̪�z��٩z"��"|\$�|>UU!M�Hd'u����ueD�����Z�"3#��M%���o�]��c
s��ٻI9䐹^���a���-0�t�!�JJ�Tj��u��p^��.�K�U����4�L�߿S��r�c�-�>����G�D����?��Q'�Tԩ;l��p[Y��
��wɒ�`�C=Á�%��h��_'�����RI
=p�S3��J/��R�N�	F[�
N}���],�y%��ф�]�{GA�TtO�т�5IR(�����.��wD��c����l��=����;
��)X�'�1pi��D��>C����Pi&����bNt���.].��$:0�ISg�*�Z�*,Ð����&Ѭ$g�E%�\�M����ߦ�6t<l4��9�l�B�;���0��6������X�i��^��zw�O/织�<�_��k�v�&	3��6��n�b[XW٢�g)��hOm����ա$t�8�#�J�3���g��Q>��s�P���:U�A�2`���V�������<3K��ќ�j�hb�h��U��5GuM���%=��>�Ar�܀�|�(�d����/�-��P�Y��.�i �zu��+��e��ә5�A@-]O|��y3�38^H1��خ#8d*$�͚�D�bf�l�J:ͱW����j�����%��\�{��QO���v�*$�TEdG/0�b��9�NAY��(�[0�S(Zi*A�f�v��:-ǲ`������Y��>q	G�:�E�G�c��S&�����MW���bL ��RMi�5��]�ב�����N�l�#H1*
��˺���XV�c�!�g�r�_���\@V�)[uz�{��.�n�Ċme��҈�jSU	 ����@�J憒o�SE��':%��4���0�Ĭ_��3�wK�1�Ge�nz��E�HX �g���HȾ��J>�霎�R�μXe��$�m�CZy�ZsLf�����!��[��i��� /?#�.�\wF�T)�0��uO�Ax'��>�krDX����h��4Q$�~_k9!�1�9�wr�e�	k�X�=|M������T8��i�+Q�HQ�'�i�b�4���RwE:ҭ��=���u��X	-�p�y]��@g�bԯ�����~�F����'2�B\�"6p�Q���ȍZO-�ܦ
���o�5���+:W+����U���`�>�Q�NL�AQJ=���a[ij���	�_A�����:��A�Ѹ�PQW���ˌ�Dc�{�)��iH(��5��o� 0�Ma��r�k����y�����㓵��?~�Y�w=�p�J�^�\�lr� v3'�
���'����w���Ά�6��vَ��u+j���vө�Ėh�<TF�HX����q]���CF���`���V���?�F�����b�nT���e����%��^ �E���<�2W��JI���%��h�?Fn�oO/w�W�j3��b:�ט!k)��4Y�Xz8��R#Bұ�����>�����)m��4�'�y�4r����ʷ�[��~md)��i���\\_��}�ƹ����ɚ�^���_~z�{���c;ɇ���um:��/~�}y��x�t������g�?h�|�z�[���}�t>�3:�p���N�m�?�Ա��� 3�z�q�U�6������qd�0��5��0���t��R
��0͞dh���+�tZ���Z�jЯTEgL����5Ӆ�����wJ1m]�`= ��ʐlOa��ɷd,tO�ղ(^c �8ćN#阳qt��4�A�{1�� CтtG���.���C�i��me�Y-��1p"ö)���?d)�Y:�C���[D�[���҃�iR�uKkA)$T&����0T��b��~n��
B���N��y��_���c�W�2Es/<?6Q��P��Ji�Ć7����(�T
�t�g�5s��ɂ'q��`kv$B���YK�����M2�"f�p�F8���}j�� �<2�RpM�f�^;�L�wD��0���]i�aǪZ��]2�hG��m��� 3  ����{��R2����R#�Y��n��`p�)�w!�[��[�p�����-F�%;*[��D�E�9�!K��Jq ����!���o0�k9����O���ĵ�-�>��K�k�� }b�����+.�����}+�A�C�z��I��tR��K86�7R�1I�ͤ���/O�w?�^��*;EB,
���4�(F#����șp��E2C��n��_��Z+p��V�<bzx]������Z�ZW��4� l��EX
i��~߈v4^��Ln�4yB7��u��bT��ڶg�)g��n�;�m���e:�ٖ̓�r\n��9[�prYkc  @�q����Gn4m�3/-s(,.o��ϖ��:)��0K���ݗ�������u�oO���������1���x/<ͣ5�C�(��"R�r���P���xcU="�Z��yI��Ehq��
������l!hk�g�"��m�2S�|U
S
w����o8����I��`�����BW~P�Iz�)=�u� �MzUVӓ�}i�H�e���w$�Q�+��4[�|&B��v��}%���3���f#4:s(L�
YvH����!Cf�Q��+��tO0#�%阮�M�Fȵ*�>:2ѷ�DG�O1]�)jg(���pz���{�r9;���m!�^�u`�4���R=O�C-�������<�����Ie�!O��.��Ee�|y���`:(�P���8�+*�Y�ͦ ���:���Z7FE�*-���f��}�ǂua�X0�Y������Eн�z|(�zm6u	���:��@K�i)"d�P��%��ӏ�������`��      X      x������ � �      ^      x�3�t���I�2�H-:��+F��� A��      T   �   x�}��!�"�u�������QVޏU|�F�$a&e�K�R�n$-������4-��L07��%���z�k;��OsU����S�[��|�:�
�i�8"��ORL��ίg�,�x���J#��q�u3���Z� �k;�      Y      x��]K�-9n�ZEo�6D��sO���ڀ���y-ޘE*SdV�'�x8U����)2��,���Oo?9��M�������������7��Q�G�������'��D�����/���?����?������R6&��~Ӽ~��\��f�4�za�h���	<g����1ۅY����V��3f�)���Ҹ��oI�;�o���;e
@�����Af��g:i-�s
f��*�svyΜ?c2��7&�(����"��&���-�EJ���<g�y��1�f꺙�����s}�7f�0�{�/�
�g�DU���Lg<������ĕL�#Y�y��7N��s�?�����^�ۃ��w/�Ek�7&�7����kU?bRY{��96&%�.���T;G//3����N��^��A�ח����d?3�����+��1鼱"��.��+�x[�	�ڔ��8�Nj��<S���Z�0/ ʿ��s"��v}��Z٘돳E�̳�mO=0�&���Ÿ]G=�i}Y'G��6�lg3%�L�+G���y;�y�r��@6��i��������f~~��-���v�~f9�N�,{�G�(jh�1��"~��i�q6t5��3��R�|_jֽ�Ɯ7�zy����Ϯv4��n�)��{΁c�ecR����V<(����vG˒�x���������4�:o����E�]��R��N��?�R���jK|w��	<�B���g\��4�%�����1�L��r�Iz|�,8��ʏ�1�8/���s��E�1���'v߳��Տ�1��/甇}�ܢ:�z#�G|�	�������u���, �Rm5Z��1��#K?t �(��´�r�%G��K���~�n'�TJ��jJ딿�j!#��ڈ»��4~8��;y�m+�`7ʹ1)�_�c� �+���a�-͟~���b�m��/L���8�� v�ec�E���H?���7�ƼN��ܠ8Y�u�d�)iJ{�}����&��k�*�-�����d����9�#Sv�:�n?"K��'�/s<�s�s��3	�����0ycRr�;����,�<�t���,�ۏ�<ӅY��p���?~�f5,����qۤۡM����>G����+7��n�3ʾV��;SZ���&ϻ�^��=S�2��ɷ��aBp-G��bH+7�r�CI�	p=��yl�C\>��R�Q#���´w?^��YR�0ycZ��.C���9��������.dKA0�PZ/s��I)�rg�����$pk��l��t&Q/o�I��k�6�b�SQS� p�T/����r�����\��ۃ.��fc��K�舾gߘ.E>�܀KD᲏y�OYu:�N(fj}�ya6�'����YF��1�6����+�z�L��6��ɞs�5ڝZ�h�<&e��
��
�`�I��>:�1���3p�LjE�;�W��p{�y&1����啺lK�֨mL:Dm��qvDd^LbG�lӓ7&
#��46$O۟v�!F�p�>���*���0��9S���
\�[�&�r��8�icN�4��.D7����zwA-\B<�CZ�7V�+�ݑ��V�߃����V�ͥ�]��YJ��Y��{;J�i��׃�H�Z%�,�;v4!C=�)�t�'%g� ��)�"�A��dT�ր>{�֣������$@��w*ܰb�JZ�����a��\Ԑ�9��׹0g�S�0��u!�L��h���Uݰ0����Ց��\1G�Y6�|��Ѧ�A=�Uݰ	V�n���e��E�7����gQ�6N��6���k�������Z��"&�:E�4)�S��6s�=�8,�¨=8�U�0�U�ɒ�,{೽S�S� �|0`7<$�{@ݰ�&[~t']_�H+����������D%�\#�W�f8�0	
C�q����F;1��#��"����Sg�7(a�b&w����D/��4��[9~`N�����dcq�<������%�:mJhEǜ��_&j8")��圪oX�lL�!Y�u�ȅ*�̺{�i#4����4q�<�#��L�l{�7LK�@�+�f�UV}��F�?�"�7�4�bJ���w�z~B�:|�~aZa�}O��J��ؘâ�|mP9�����*p��9��V	�%)H�1Ր���{���H��[R��w[��t�nN����#j@�k�����z
�>�����V�����>XuM�V�0��es��̈�)�t��L���D�S̈ɖ��F�r="�Yӣ�vs�^ʅD|n��1������H3��mX1���=M3 �34w���j�����Z�s�������3�h�X�Z�x<����6ф�AŎ��m���]1}�A5Td�gcA+�)���Tڰ0�7���{D)Vi�`��,�B�s��S�h^�����HvU(",5NԪ��K��Q����l_�|dH�l�R��O��K "�@���������U)�yPQ6�@���G�jA9�E� �l+�8uT�Uy��lLӴ<T�l�i,҆�*�VBK���RY�6�SvWA�?n��@mQ�C��9�w+)!����/��A0���_��_݈(�cv���!=�G�r��7�yqV[Dapژ���wG�E
�jI���bD}�Y|��В9oL�
�I��1Wr	֝˅�
�C�4SQ���4Q�̓n��g��r�/PK�)t~��-Qߐ���Q�ɫD�}�5&[X{�j�=I%r!r��ڸ�y����#�BN#"���-d�Ї�F�/�5��A0O};�J���A9�F�.Hs�c��-�[�yc��-ى�e�4��;Z��pa�k�@:z�S�hYNw�.GU�u�/̶1��70d��^���7�/N��R�w�ta�!Uw��k��U��+Oﰡ�cY�͜H�L���ہ.L�0m��9z$�ko}i�����j��6A�T�ۉTm��S3w"��l%�w��>7}m��zU�$�a��A�1F6=�!�qa�m�����h�Rۘì��V��z� Si��Apg�r���{,̱1��(F\a���[W�URzr�u�M? ���fZ��1�U��?)Љ�L�����fj���[Z#�,��F<W՞Ǩ�ڬ�wEva�i�j�b�iB���*��b�{��SF�#ih��*�m���ѭ)	Ӌ=��	U[���H�r7R@G/��4,���F&\%ꑿ�ccsrى�PCV��T�RL'���*'���E��M�4(�w'�a����y�Pd�9��z������T������w�����]F��<�0��.�єHE�e��3T�!�n7�J�C*�����|xD��h���=ng��"��)�T�E��e�v"(`��1ǆ<�ݓ�Gt��Q .xT��n=�_��z�0��t>��Z�g�v����p��a6,׷xqa�I��;����8�wzX�ofAV���]PБ�Pfs�1Ō�I��2��3��]�@�%�柀���ٌ��vcªy�7�H�1U�Q��]'s�����S�h��6�qJ
�r��Q5Pe��)�qP��[��0yczI=Z^>�{׉��Z�Ƅf�"�r~w�Tm� �r�8���xZG�Ѳ��A0�#�G%H��]4���[~�|S��ޘ�´ΖC0H������$T1=���IHƔ9�D�@�9�#�;���v�����X�-b�K�lSD�|�-�\��Cj������m�2c$�i%ء=mL�XV��6�ɍ����j�}�6��)̐zޘnD2Ŵ��;/�j�i�)/��E�H��"UՒ�Z~_As% D[�����P�,C�i���s�)���H���G�x+�5�p��:�QРM2o̹1�)v��e�"l�p1-�E��=����X1�r�l
N1�,���G�p�[��E� ��	͍B@~y�+�U�
�f`ܧS�����QSE �����[�B��"O/����VO�6�GF����M�L����m%�#ߔҽ����a�<Ԑ��L�Il��������ݘ�r\���]U*��]��G\��!�����v<�er�k���kن/V��o|��)Yk����JhѠ��>    �"��B�Io���TKb;9S5P`�U(T��٫\!9�Q"�TU��؜$��DW���p�Ie��~x&�ܒ��Sy��T�BҰ�Kz�� ���Qu���n0����5,ȣ�J66���x�
.L1�u�u��\�=b���ӿ1�Ɯn�r��[<����LD3��j�)��A�|l"�+V@p��L5��a�)B��Fs!>������T� �C6\�����f���=M,�2/�j�*kP�;�L��8�ڃj��AZ�G�Z���~��9VՙѨ�>�<h/�i*��a�HCʏP���=կ�����7,c<�'~N��a��+�d(]�a��mcZC��=�%P������=>��t_�Ae����VRa�tC��c��"�|c�!�T*W�~LZb� �oȰ?9�����	���
t"AQN�<4��r;A�킶�J�l�k��c�P�'�G!T�(�����";�
dHH���P�D�T�0�L~�@�p�Ē4@=�#[����
��3���f�!'���-�ya����M���!&oL#-][x��M��zt;�9[-|}�VRa�`�v!7b �p��yC��Y��1'd��$�}����v�`�UU��c�݇(���ny���&�6�J��,���K*k`��Oą㓢PDe�u�NS]�R~��WR]�������Y<������g�=��%��&�5,L7$��A!茈RY7�)�LЉDEIRY��8=��k��h9&�5,O׍��Rz�D��)UI����K�҈x;
=-�v�:�l#JdK�S����՜Ȗ��|�YM*l��oL���}-\�NB0���#�c�s�- �Hu|㚦}�h��%�^��l`���Ј	��(rr
�a[�!�@=ڢ"m����fg="[Ԍ�|P����Ka�:� qC�|�s]�H&�"�uC^�9�y���%4��k�ɋ]�H�$ݣ-*ꆜ�N6d*d�#z3�&f�h�Y��a���M�y����pB�Z�eDٰ1M�����]��F�{��J
��fޘg�N�,i@�v�4�Z4WL7Kކ�
j�Z�VL�<q?2C��F �R��<�ó�8�{.�=Z�J)��4����K�D�h&���|���&Yr0��J�{���vA���(+�i
���$D�Ȓ�p,�ê���\ >��b����P*�#��<I���1���x	Mzw_V)J*�p�E��Ե5
F�(���ɍ���*I��>�tݗ�)\P��w�ӎ��#1$W!*���mN�(72鿣z��\�e����H�`�g��T��<�3.���j�J#ݠ����T�t��U���O?ְ�7��L���/L7�U)Q�P��p��?���IM0��
Q��n6Qvm?(bL�Z?��b7�|�貃*�?�݃�(���d�a�<ƅi����2�C�L�0��K�w疑N(�^�ʐǍi�ov]�Q�4i��9ͅz�!jI�@'�<�p�Nxu
�	�B%�:�B�+��,�.@%����*M/�G#e�'l��j��r~vG�!��3�#\�"�;����}y��p0	ba����ӻx����A,"��t%?׫����"oȏ�Ư���(��ڹ��9;ՙ��[�kx,��B�a���t�ǪҠ��ZG\܀���=T�
�0]]�~�� ��y��
�Nnu�#��X��[	����P����y��G�� ���v�m]{�7(��Q����dS��-�rn٫ʯ�=�l\�e����yc�O�נ�a���Ѵ,��&���y婜hc���X�%���
˙/Y����O�Ʒ�GVi+�d�IJ.�CY|	Fa�(�d���v/|86a�����D�so��P"�N��wG���L�`N#��(��D�]y�`���q*�[<S�g�K~H������4 �	�����8����{�o;���/��iX�OT��Ы��b��=��=��j^,�Ә��QH_"/B��t��9�%�>�^
�f��~ӂ/��9`�$�RL6r>[�
~�^ ��Q��QPkX�FR�*�4z�;�!Q:#���tC�M��o�z�5��=����h�|��Y5���.>�!�3)�ܿĉ�i���x�֎��9�!���%�<��ȪD�s�5��u
�O8��A_�Q�,e��nwG	8�St I���� �'�%�.�i��M�G11|S�� ��(d�_Bt��n��1��<SLX�ڸ@+��t=�n�2�<�g ߔC���G�p��m7=T99���|�'����/�1M�tZ�h8�@)^^1�����(Q�HQS�6��q��ك�L�I�{cW��*��	�S,�%�A�z&��A�8�I����d�1"o'NI0�t�l�ޘ\j_��s]�K�����6U�О���e�H]\r��˪mx\-�|�v��GO*����[���N�*n�iS�� �P��p�J�=�)��N�vF�n�i��RE�r������d��[��3`�U�Г�򕌾Dcv{
$�Y�������%h�V�U��Ɇ�U�����=�:U���,�nY��\���u��4 7�j�R0�G��`�I���xg� �(U7�&�[�|Gw�_�ЭY��]U��H��fP��*nX���!$?H^v���iVmC�#ܽ�:�9WCj>��* �]N(�TqCo>��� `-��d7X���橜��k�[7��G͞�'|	�Ӭ��c/��>2c:��2T]sŴ��4	g(YΑ.P?�bZ��aNA	�;�Y��{��4�:�Z0�*���w�ح";���5h��*mL�":b�L�"�A���
b~H�?�4�d�6���]�q���-S7�*�U�O�%5|c�������Ԋ@r�U�����<���9���H�J8/C �i䈿Qi�p����{�8�6�IVi��E�蔟(K�@W�U�0�I��ě	Z��c΍��ޓE"t֠�/��aT�u��,��9J?T�0����*o��9G�j�B�7؉���G~O�_�bJ�D��Gl���i����;(qg7ϋ���8E�����B�^%;g�CUܰ�c�/�t�ht1E����=���b|�}�u��a�9�+c���(
Uq�Lƫw���ܣ�,�*n����y�(���׬↙|���Ewn��ʝU�0��{�
����e�7LG���a�S���7��tB�y⎴(�U}�,F1Zu��]8/1��a?A̍���rpiaͪoXΤ[Y*;*�s+��i�x��k�z��f�7����h��=��ikQy�t�Ga4��D�E���u�H7��f�U7L�}�����ۂ����AZ�!0�A5��7,H�$|��_�c;���A���Rb,ԃFή��aNڑ,fJ�4)�^T��΁:mq���ڽO��v�o�T\�aC�� ���&Ga���p�LQu?Z��Nd��S���K8h�Ã������aa�+��*7:<f =*�n`w�*�T$�	j^E��]D~bP|�E�A�XTݰ0�y^΄G��HkXT���G��y�#Ǥ��.�/��a���**oPP�4s��E��&]T��͛�����A?sQ}�?��i�QKV�A�PTࠠ.L44���A�\Q��
H��;�e��^�)�y8����B�]4����A ]/�Uz���z0����a9gXd�p�h��7�Š������b)*p`>Ӿ��DݕH^T���{�|��&{P�)�o�hlX7�����;�2vC11����N ��S9�Uޚ�㗑�� �-�o�h̭�Y�hf�Eޠ��39*����VD� !�]ѬL���M��SLrݜd,��s�G��6����M(��h-�$u��/��	M�l�"�EَLO��	A�m)�1�)��O8�k�RՔ�>�Xp�ϵ�eKUSr��6#�Ne[/׼1]	��lȍ��!0%Q8"/�nm&
*"�T%��m��#lJ#rˢoLO8�מ��A���J�����7/�qA��]���E霨4�w�r�WǗ�Lh�|��T� 9�4(E��/�lO�� �  �-�\���0hv|t���#W/��k����N0&�Ú�Q�֜��/�@�R �.�^�Nk�����h���;*��(�B2l���e�7I��.�-�B�E�}�qa:��O(;.*mnL��='4��S"��45�n��n ���st]P�ic�V<7g�P;8��ic��b�r��#J��Z��g:-S�p�A�B�ec����zA1p0L�t�$W�6��>>[g��m#��q�D[�-��i��{FV��M�ܮt�#���n�����=G!}����,�s]0X:_���`!=�{�0$xΑ.L�j�Yӈk�%h|��*�S�� [I/%}��e�-®��L��GE�%�#Rv18���EE�t'q>
�)Qx#n�t��dc�aY2E�ԍ�m��x�ZT��.)�
���d�]����@SDݠ�N*�&m##j��)$��pќS� �z��R�V��N ��rk��ǜ�1�׾�2�^%ڟS��E
�ƅ�F��Y6�t�����-$Z����z��}Ш�y��v4}�oN��3��g�0]:�pt{t4�̱1�w��Aw�G�jF�0ݽAH�U�i��d��ݥ1�ޔ��RFBܱ�d�Cx�u
���RIH6��]u���H�QDؠ�]����V�\^D� ĝS�y%33�ӥ�d�����O4#�!������ҵ      V     x�m�MN�0���)r ��,a�BTB�ؘ4�,��(�T�H,X�z1RZU��������
^��
�ׁ:��6^�Fsp��?�H&*�63,R�#k{�`g�3Lrx�P6��Ԗ��js�+������疴�b��}�6z/Gw�`��IOmG���n�xD�d��&A�>4��x��D�&++����y.W+ɴR�N�ݕ,�B~�7��8O�j1�~�T�1x
�؜j��ϝ�>��ϓ���x]���y�~-��\h�^      `   7   x�3�4�4�4�35�4204�54�54�2���PD�9��h�&@���1z\\\ �Bd      P      x������ � �     