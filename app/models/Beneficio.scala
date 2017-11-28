package models

import javax.inject.Inject

import anorm.{ Macro, RowParser, SqlParser}, Macro.ColumnNaming
import anorm.SqlParser._
import anorm._
import play.api.db.DBApi
import play.api.libs.json.JsValue

import scala.concurrent.Future
import scala.concurrent.ExecutionContext

@javax.inject.Singleton
class Beneficio @Inject()(dbapi: DBApi)(implicit ec: ExecutionContext) {

	private val db = dbapi.database("default")

	def whereCategory(id: String) = ??? 

	def where(col: String, cond: String) = {
		val sql: String = raw"""
							(
							SELECT id, 
								beneficio,
								es_aprobado,
								es_costeable
							FROM beneficio
							WHERE ${col} is ${cond}
							and es_individual = true
							)
							"""
		JsonHelper.tableToJson(sql, db)
	}

	def selectForm(id: String): JsValue = {
		val sql: String = s"(select b.es_financiero, b.es_transversal, b.es_medido_tiempo_respuesta, b.es_exclusivo_indefinidos, es_medido_uso from beneficio b where b.id = $id)"
		JsonHelper.oneRowToJson(sql, "1", "1", db)
	}

	def selectAll(): JsValue = {
		var sql: String = """
					(select c.categoria, json_agg(bs) as beneficios
					from beneficio b
					left join subcategoria sc
					on b.subcategoria_id = sc.id
					left join categoria c
					on sc.categoria_id = c.id
					left join (select b.id, b.beneficio from beneficio b) bs
					on bs.id = b.id
					where b.es_individual = false
					group by c.categoria)
					"""
		JsonHelper.tableToJson(sql, db)
	}

	def select(beneficioId: String): JsValue = {
		val select:String = raw"""
			(select x.id as id, 
				b1.beneficio, 
				b1.observacion, 
				x.presupuesto,
				sc.subcategoria,
				c.categoria,
				b1.pais,
				b1.es_medido_uso
			from beneficio as b1 
			left join (select b.id, json_agg(p.*) as presupuesto
				from beneficio b
				left join presupuesto p
				on b.id = p.beneficio_id
				group by b.id) x
			on b1.id = x.id
			left join subcategoria sc
			on b1.subcategoria_id = sc.id
			left join categoria c
			on sc.categoria_id = c.id
			where b1.id = ${beneficioId})
		"""
		JsonHelper.oneRowToJson(select, "1", "1", db)
	}
}
