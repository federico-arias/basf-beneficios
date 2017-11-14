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

	def beneficioForm(id: String): JsValue = {
		val sql: String = s"(select b.es_financiero, b.es_transversal from beneficio where b.id = $id)"
		JsonHelper.oneRowToJson(sql, "1", "1", db)
	}

	def getAll(): JsValue = {
		var sql: String = "(select b.id, b.beneficio, b.observacion, sc.subcategoria, c.categoria from beneficio b left join subcategoria sc on b.subcategoria_id = sc.id left join categoria c on sc.categoria_id = c.id)"
		JsonHelper.tableToJson(sql, db)
	}

	def getOne(beneficioId: String): JsValue = {
		val select:String = raw"""
			(select x.id as id, b1.beneficio as nombre, b1.observacion, x.json 
			from beneficio as b1 
			left join (select b.id, json_agg(p.*) as presupuesto
				from beneficio b
				left join presupuesto p
				on b.id = p.beneficio_id
				group by b.id) x
			on b1.id = x.id
			where b1.id = ${beneficioId})
		"""
		JsonHelper.oneRowToJson(select, "1", "1", db)
	}
}
