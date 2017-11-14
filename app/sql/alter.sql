BEGIN TRANSACTION;
ALTER TABLE colaborador 
	ADD COLUMN nacimiento date;

ALTER TABLE beneficio
	DROP COLUMN alcance;

CREATE SEQUENCE encuesta_id_seq;
ALTER TABLE encuesta
	ALTER COLUMN id SET DEFAULT nextval('encuesta_id_seq');
ALTER SEQUENCE encuesta_id_seq OWNED BY encuesta.id;

CREATE SEQUENCE beneficio_id_seq;
ALTER TABLE beneficio
	ALTER COLUMN id SET DEFAULT nextval('beneficio_id_seq');
ALTER SEQUENCE beneficio_id_seq OWNED BY beneficio.id;

CREATE SEQUENCE presupuesto_id_seq;
ALTER TABLE presupuesto
	ALTER COLUMN id SET DEFAULT nextval('presupuesto_id_seq');
ALTER SEQUENCE presupuesto_id_seq OWNED BY presupuesto.id;

CREATE SEQUENCE solicitud_id_seq;
ALTER TABLE solicitud
	ALTER COLUMN id SET DEFAULT nextval('solicitud_id_seq');
ALTER SEQUENCE solicitud_id_seq OWNED BY solicitud.id;

ALTER TABLE beneficio
	DROP COLUMN presupuesto_id;

ALTER TABLE presupuesto
	ADD COLUMN beneficio_id INTEGER NOT NULL;

ALTER TABLE presupuesto
	ADD CONSTRAINT fk_beneficio_id FOREIGN KEY (beneficio_id)
		REFERENCES beneficio (id) ON DELETE CASCADE;

ALTER TABLE colaborador
	ADD COLUMN es_indefinido BOOLEAN;

ALTER TABLE presupuesto
	ADD COLUMN moneda;

ALTER TABLE colaborador
	RENAME COLUMN nombre TO colaborador;

ALTER TABLE presupuesto
	DROP COLUMN semestre;

ALTER TABLE solicitud
	ADD COLUMN moneda_id INTEGER;

ALTER TABLE solicitud
	ADD CONSTRAINT fk_moneda_id FOREIGN KEY (moneda_id)
		REFERENCES moneda (id);
	

