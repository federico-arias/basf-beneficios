
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
		WHERE s.solicitado_en  >= date_trunc('year', now())
		GROUP BY c.area, b.id, b.beneficio -- nombre e id tienen combinación unica
	) AS t;

--N de solicitudes por grupo etario este último año

	SELECT array_to_json(array_agg(row_to_json(t)))
	FROM (
		SELECT b.nombre, COUNT(*),
			CASE 
				WHEN date_part('year', age(nacimiento_en)) > 50 THEN 'mayor'
				WHEN date_part('year', age(nacimiento_en)) > 40 THEN 'adulto'
				WHEN date_part('year', age(nacimiento_en)) > 30 THEN 'adulto joven'
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
	SELECT s.solicitud, c.genero, COUNT(*) AS solicitudes_por_genero
	FROM solicitud AS s
	LEFT JOIN colaborador as c
		ON s.colaborador_id = c.id
	WHERE s.solicitado_en  >= date_trunc('year', now())
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
		GROUP BY b.beneficio, cat.categoria
	) AS t;
		

/*************


PANEL II


**************/

--Top 5 solicitudes por género
--@pais
--@genero
	SELECT b.id,
		b.pais,
		b.beneficio,
		c.es_hombre,
		COUNT(*) AS solicitudes_por_genero
	FROM solicitud AS s
	LEFT JOIN colaborador as c
		ON s.colaborador_id = c.id
	LEFT JOIN beneficio as b
		ON s.beneficio_id = b.id
	WHERE s.solicitado_en  >= date_trunc('year', now())
	AND b.es_medido_uso is true
	AND es_individual is false
	GROUP BY b.id, b.beneficio, b.pais, c.es_hombre
	ORDER BY solicitudes_por_genero DESC
	LIMIT 5;

--% de solicitudes por categoría y subcategoria YTD
--total_subcat / total_cat ; total_cat /total
--COUNT(*) AS t_subcat,
--SUM(COUNT(*)) OVER(partition BY c.categoria) t_cat,
--@pais
	SELECT c.categoria, 
		sc.subcategoria,
		COUNT(*) / SUM(COUNT(*)) OVER(partition BY c.categoria) AS subcat_percent,
		SUM(COUNT(*)) OVER(PARTITION BY c.categoria) / SUM(COUNT(*)) OVER() cat_percent
	FROM solicitud s
	LEFT JOIN beneficio b ON s.beneficio_id = b.id
	LEFT JOIN subcategoria sc ON b.subcategoria_id = sc.id
	LEFT JOIN categoria c ON sc.categoria_id = c.id
	GROUP BY c.categoria, sc.subcategoria;

--N de solicitudes promedio
--@pais
	SELECT AVG(COUNT(*)) OVER() AS solicitudes_por_colab, c.id
	FROM solicitud s
	LEFT JOIN colaborador c ON s.colaborador_id = c.id
	WHERE c.pais = @pais
	GROUP BY c.id
	LIMIT 1; 


/*************


PANEL I


**************/

--Costo promedio
--pais := Perú | Chile
--moneda := sol | peso

	SELECT AVG(s.monto * t.tasa) 
		b.pais
	FROM solicitud s
	LEFT JOIN colaborador c ON s.colaborador_id = c.id
	left join tasa t on s.moneda_id = t.de_id
	LEFT JOIN beneficio AS b ON s.beneficio_id = b.id
	AND s.solicitado_en >= date_trunc('year', now())
	AND t.a_id = :moneda
	GROUP BY b.pais;

-- Gasto total
	SELECT SUM(s.monto * t.tasa),
		b.pais
	FROM solicitud s
	LEFT JOIN colaborador c ON s.colaborador_id = c.id
	left join tasa t on s.moneda_id = t.de_id
	LEFT JOIN beneficio AS b ON s.beneficio_id = b.id
	AND s.solicitado_en >= date_trunc('year', now())
	AND b.es_costeable IS TRUE
	AND t.a_id = :moneda
	GROUP BY b.pais;

--  Aprobación promedio

	SELECT AVG(e.nota)
   		b.pais	
	FROM encuesta e
	LEFT JOIN colaborador c ON e.colaborador_id = c.id
	GROUP BY c.pais;

-- Gasto, aceptación y 

/*************


PANEL III


**************/

-- AVG Tiempo de respuesta YTD / país en días

	SELECT b.pais,
		AVG((s.resuelto_en - s.solicitado_en)::integer)
	FROM solicitud s
	LEFT JOIN beneficio b ON s.beneficio_id = b.id
	WHERE b.es_medido_tiempo_respuesta IS TRUE
	AND s.solicitado_en >= date_trunc('year', now())
	GROUP BY b.pais;

-- % de solicitudes aprobadas

	SELECT b.pais,
		SUM(s.esta_aprobado::integer) / COUNT(*) AS aprobados
	FROM solicitud s
	LEFT JOIN beneficio b ON s.beneficio_id = b.id
	WHERE b.es_medido_tiempo_respuesta IS TRUE
	AND b.es_aprobado
	AND s.solicitado_en >= date_trunc('year', now())
	GROUP BY b.pais;

-- Top 5 mayor demora en respuesta YTD

	SELECT b.id,
		b.beneficio,
		b.pais,
		AVG(s.resuelto_en - s.solicitado_en) AS respuesta
	FROM solicitud s
	LEFT JOIN beneficio b ON s.beneficio_id = b.id
	WHERE b.es_medido_tiempo_respuesta IS TRUE
	AND b.es_aprobado IS TRUE
	AND s.solicitado_en >= date_trunc('year', now())
	GROUP BY b.pais, b.beneficio, b.id
	ORDER BY respuesta DESC
	LIMIT 5;
	
-- Top 5 Rechazados YTD

	SELECT b.id,
		b.beneficio,
		b.pais,
		SUM(s.esta_aprobado::integer) AS n_,
		SUM(s.esta_aprobado::integer) / COUNT(*)::float AS aprobacion,
		COUNT(*) AS n
	FROM solicitud s
	LEFT JOIN beneficio b ON s.beneficio_id = b.id
	WHERE b.es_aprobado IS TRUE
	AND s.solicitado_en >= date_trunc('year', now())
	GROUP BY b.pais, b.beneficio, b.id
	ORDER BY aprobacion ASC
	LIMIT 5;

