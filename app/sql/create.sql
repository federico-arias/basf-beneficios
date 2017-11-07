--START TRANSACTION;
BEGIN TRANSACTION;

--CREATE DATABASE IF NOT EXISTS basf_beneficios_dev;

--USE basf_beneficios_dev;

CREATE TABLE IF NOT EXISTS moneda (
	id SERIAL,
	moneda VARCHAR NOT NULL, 

	CONSTRAINT pk_moneda PRIMARY KEY (id) );

CREATE TABLE IF NOT EXISTS tasa (
	id SERIAL,
	de_id INTEGER NOT NULL,
	a_id INTEGER NOT NULL, 
	tasa NUMERIC(5,2),
	fecha DATE,

	CONSTRAINT fk_de_id FOREIGN KEY (de_id)
		REFERENCES moneda (id),
	CONSTRAINT fk_a_id FOREIGN KEY (a_id)
		REFERENCES moneda (id),
	CONSTRAINT pk_tasa PRIMARY KEY (id) );
	
CREATE TABLE IF NOT EXISTS usuario (
	id SERIAL NOT NULL,
	usuario TEXT NOT NULL,
	contrasena VARCHAR NOT NULL,
	autorizacion INTEGER NOT NULL,

	CONSTRAINT pk_usuario PRIMARY KEY (id) );

CREATE TABLE IF NOT EXISTS autorizacion (
	id SERIAL NOT NULL,
	nivel INTEGER NOT NULL,

	CONSTRAINT pk_autorizacion PRIMARY KEY (id) );


DROP TYPE IF EXISTS gender;
CREATE TYPE gender AS ENUM ('m', 'f');

CREATE TABLE IF NOT EXISTS colaborador (
	id SERIAL NOT NULL, 
	colaborador VARCHAR(30) NOT NULL, 
	nacimiento DATE,
	apellido VARCHAR(50) NOT NULL, 
	es_sindicalizado BOOLEAN,
	es_indefinido BOOLEAN,
	genero gender,
	area VARCHAR(40),
	run INTEGER NOT NULL, 
	verificador VARCHAR(1),
	ingreso DATE NOT NULL, 
	site VARCHAR(30) NOT NULL,
	ciudad VARCHAR(30) NOT NULL, 
	pais VARCHAR(30) NOT NULL,

	CONSTRAINT pk_colaborador PRIMARY KEY (id));

CREATE TABLE IF NOT EXISTS carga_colaborador (
	id SERIAL NOT NULL,
	carga TEXT NOT NULL,
	apellido TEXT,
	rut VARCHAR NOT NULL,
	nacimiento date,
	colaborador_id INTEGER NOT NULL,

	CONSTRAINT fk_colaborador_id FOREIGN KEY (colaborador_id) REFERENCES colaborador (id),
   	CONSTRAINT pk_carga_colaborador PRIMARY KEY (id) );


/*
CREATE TABLE IF NOT EXISTS tipo (
	id INTEGER UNIQUE NOT NULL,
    tipo VARCHAR(30) NOT NULL,

    CONSTRAINT pk_tipo PRIMARY KEY (id) );

CREATE TABLE IF NOT EXISTS estado (
	id INTEGER UNIQUE NOT NULL,
	estado TEXT NOT NULL,

	CONSTRAINT chk_estado CHECK (estado IN ("Aprobado", "Rechazado", "Evaluando")),
	CONSTRAINT pk_estado PRIMARY KEY (id) );
*/

DROP TYPE IF EXISTS scope;
CREATE TYPE scope AS ENUM ('individual', 'colectivo');

CREATE TABLE IF NOT EXISTS categoria (
	id SERIAL UNIQUE NOT NULL,
	categoria VARCHAR NOT NULL,

	CONSTRAINT pk_categoria PRIMARY KEY (id));

CREATE TABLE IF NOT EXISTS subcategoria (
	id SERIAL,
	subcategoria VARCHAR NOT NULL,
	categoria_id INTEGER NOT NULL,

	CONSTRAINT fk_categoria_id FOREIGN KEY (categoria_id)
		REFERENCES categoria (id)
		ON DELETE CASCADE,
	CONSTRAINT pk_subcategoria PRIMARY KEY (id) );

CREATE TABLE IF NOT EXISTS beneficio (
	id SERIAL, 
    beneficio VARCHAR NOT NULL,
	observacion VARCHAR,
	subcategoria_id INTEGER NOT NULL,
	es_financiero BOOLEAN,
    es_transversal BOOLEAN NOT NULL,

	CONSTRAINT fk_subcategoria_id FOREIGN KEY (subcategoria_id)
		REFERENCES subcategoria (id),
    CONSTRAINT pk_beneficio PRIMARY KEY (id));

CREATE TABLE IF NOT EXISTS encuesta (
	id SERIAL,
	categoria_id INTEGER NOT NULL,
	colaborador_id INTEGER NOT NULL,
	nota INTEGER NOT NULL,
	ano DATE,

	CONSTRAINT pk_encuesta PRIMARY KEY (id),
	CONSTRAINT fk_categoria_id FOREIGN KEY (categoria_id)
		REFERENCES categoria (id),
	CONSTRAINT fk_colaborador_id FOREIGN KEY (colaborador_id) 
		REFERENCES colaborador (id) );

CREATE TABLE IF NOT EXISTS solicitud (
	id BIGINT UNIQUE NOT NULL,
	colaborador_id INTEGER NOT NULL,
	beneficio_id INTEGER NOT NULL, 
	solicitado DATE,
	resuelto DATE,
	es_aprobado BOOLEAN NOT NULL,
	creacion TIMESTAMP DEFAULT current_timestamp,
	monto INTEGER, 

	CONSTRAINT fk_beneficio_id FOREIGN KEY (beneficio_id) REFERENCES beneficio (id),
	CONSTRAINT fk_colaborador_id FOREIGN KEY (colaborador_id) REFERENCES colaborador (id),
	CONSTRAINT pk_solicitud PRIMARY KEY (id) );

CREATE TABLE IF NOT EXISTS presupuesto (
	id SERIAL NOT NULL,
	monto INTEGER NOT NULL,
	beneficio_id INTEGER NOT NULL,
	asignacion date,
	created_at timestamp default current_timestamp,

	CONSTRAINT fk_beneficio_id FOREIGN KEY beneficio_id
		REFERENCES beneficio (id),
	CONSTRAINT pk_presupuesto PRIMARY KEY (id) );

CREATE INDEX solicitud_index ON solicitud (resuelto);

/* https://stackoverflow.com/questions/24954439/database-approve-reject-workflow */
/*CREATE VIEW aprobado
AS
SELECT id, colaborador_id, beneficio_id, solicitud, resolucion
	FROM solicitud
	WHERE aprobado = true;
*/

--COMMIT;
--ROLLBACK;
