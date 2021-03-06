--encuesta
WITH encuesta_data AS (
	SELECT b.id AS beneficio_id, 
		c.id AS colaborador_id, 
		round(random() * 100) AS nota, 
		d.a as ano, 
		d.s as semestre
	FROM beneficio b
	CROSS JOIN colaborador c
	CROSS JOIN ( SELECT a,s 
		FROM generate_series(2016,2017) a 
		CROSS JOIN generate_series(1,2) s) as d
	)
INSERT INTO encuesta (beneficio_id, colaborador_id, nota, ano, semestre)
	SELECT beneficio_id, colaborador_id, nota, to_date(ano::text, 'YYYY'), semestre
	FROM encuesta_data;

--inserta valores random en una sola columna
UPDATE solicitud
	SET moneda_id = (random() > 0.5)::int + 1
	RETURNING moneda_id;

-- cada colaborador solicita un subconjunto de los beneficios totales
BEGIN TRANSACTION;

INSERT INTO solicitud(colaborador_id, beneficio_id, solicitado_en, resuelto_en, esta_aprobado, monto)
	SELECT colaborador_id, 
	beneficio_id, 
	solicitado,
	solicitado + random() * (NOW()+'90 days' - NOW()) as resuelto,
	random() > 0.4 as es_aprobado,
	floor(random() * 10000)	as montirijillo
	FROM (
		SELECT c.id as colaborador_id,
		b.id as beneficio_id,
		timestamp '2016-01-01' + random() * (NOW() + '1.7 years' - NOW()) as solicitado
		FROM beneficio b
		CROSS JOIN colaborador c
	) cal
	WHERE random() < 0.04;

INSERT INTO beneficio(nombre, subcategoria_id, es_transversal)
	VALUES ('Benef T1', 2, true);

/* \copy */
\copy colaborador(sucursal, centro_costo, codigo_sap, run, colaborador, nacionalidad, nacimiento_en, direccion, comuna, ciudad, region, mail, telefono, ingreso_en, cargo, supervisor, esta_casado, es_hombre, es_indefinido, esta_sindicalizado) FROM '/home/federico/cols.csv' csv

--with lookup table
UPDATE carga g SET colaborador_id=c.id FROM colaborador c
    WHERE g.rut_colaborador = c.rut;

