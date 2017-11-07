
-- WHERE s.solicitado >= date_trunc('year', now())
-- WHERE s.solicitado >= date_trunc('year', now() - interval '1 year') 
	-- and s.solicitado < now() - interval '1 year';
-- trimestre date_trunc('year', now()) + 
-- date_trunc('year', now()) + interval '3 months'

/************

POPULARIDAD

************/

--N de solicitudes X área X beneficio + N solicitudes X Área este último año
--using \o out.json to export + \C + \t

	SELECT array_to_json(array_agg(row_to_json(t)))
	FROM (
		SELECT c.area,
			b.id AS beneficio_id,
			b.beneficio AS beneficio,
			COUNT(*) AS n_solicitudes,
			SUM(s.es_aprobado::int)::float / COUNT(*)::float AS porcentaje_aprobacion,
			SUM(COUNT(*)) OVER (PARTITION BY c.area) AS beneficio_por_area
		FROM solicitud AS s
		LEFT JOIN colaborador AS c
			ON s.colaborador_id = c.id
		LEFT JOIN beneficio AS b
			ON s.beneficio_id = b.id
		WHERE s.solicitado  >= date_trunc('year', now())
		GROUP BY c.area, b.id, b.beneficio -- nombre e id tienen combinación unica
	) AS t;

--N de solicitudes por grupo etario este último año

	SELECT array_to_json(array_agg(row_to_json(t)))
	FROM (
		SELECT b.nombre, COUNT(*),
			CASE 
				WHEN date_part('year', age(nacimiento)) > 50 THEN 'mayor'
				WHEN date_part('year', age(nacimiento)) > 40 THEN 'adulto'
				WHEN date_part('year', age(nacimiento)) > 30 THEN 'adulto joven'
				ELSE 'joven'
			END AS "grupo"
		FROM solicitud AS s
		LEFT JOIN colaborador AS c
		ON s.colaborador_id = c.id
		LEFT JOIN beneficio AS b
		ON s.beneficio_id = b.id
		WHERE s.solicitado  >= date_trunc('year', now())
		GROUP BY b.nombre, grupo
	) AS t;


--N de solicitudes por género YTD
	SELECT s.solicitud, c.genero, COUNT(*) AS genderCount
	FROM solicitud AS s
	LEFT JOIN colaborador as c
		ON s.colaborador_id = c.id
	WHERE s.solicitado  >= date_trunc('year', now())
	GROUP BY c.genero;

--N de solicitudes por área y género YTD
	SELECT c.area,
	c.genero,
	COUNT(*) AS "genderAndAreaCount",
	SUM(COUNT(*)) OVER (PARTITION BY genero) AS "genderCount",
	SUM(COUNT(*)) OVER (PARTITION BY area) AS "areaCount"
	FROM solicitud AS s
	LEFT JOIN colaborador AS c
		ON s.colaborador_id = c.id
	WHERE s.solicitado  >= date_trunc('year', now())
	GROUP BY genero, area; --genero, area, ano, semestre

/************

EFECTIVIDAD

************/

--select date_trunc('year', now()) - interval '1 year';
 
--prespuesto solicitudes + presupuesto colectivo YTD

	with presupuestos (id, monto) as (
		select b.id, sum(s.monto * t.tasa) as monto
		from solicitud s
		left join beneficio b on s.beneficio_id = b.id
		left join tasa t on s.moneda_id = t.de_id
		where t.a_id = 2
			and s.solicitado >= date_trunc('year', now())
			--and s.resuelto is not null
		group by b.id
		union
		select b.id, p.monto * t.tasa as monto
		from (
			select beneficio_id, max(asignacion) as max
			from presupuesto
			group by beneficio_id
			) ptmp
		left join presupuesto p 
			on ptmp.beneficio_id = p.beneficio_id
			and ptmp.max = p.asignacion
		left join beneficio b on p.beneficio_id = b.id
		left join tasa t on p.moneda_id = t.de_id
		where t.a_id = 2
		) 
	select b.id, b.beneficio, c.categoria, sc.subcategoria, ps.monto, a.aceptacion
	from beneficio b
	left join presupuestos ps on b.id = ps.id
	left join subcategoria sc on b.subcategoria_id = sc.id
	left join categoria c on sc.categoria_id = c.id
	left join (
		select avg(e.nota) as aceptacion, e.categoria_id
		from encuesta as e
		where e.aplicacion >= date_trunc('year', now())
		group by e.categoria_id
	) as a
		on c.id = a.categoria_id;


/************

TIEMPO DE ESPERA

************/

--tiempo de respuesta promedio por categoría

	SELECT array_to_json(array_agg(row_to_json(t)))
	FROM (
		SELECT b.nombre, cat.categoria,
		AVG(s.resuelto - s.solicitado)::integer AS "respuesta"
		FROM solicitud AS s
		LEFT JOIN beneficio AS b
			ON s.beneficio_id = b.id
		LEFT JOIN subcategoria AS sc
			ON b.subcategoria_id = sc.id
		LEFT JOIN categoria AS cat
			ON sc.categoria_id = cat.id
		WHERE s.solicitado  >= date_trunc('year', now())
		GROUP BY b.nombre, cat.categoria
	) AS t;
		
