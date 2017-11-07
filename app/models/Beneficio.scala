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

	def getAll: JsValue = {
		var sql: String = s"(select b.beneficio, sc.subcategoria, c.categoria from beneficio b left join subcategoria sc on b.subcategoria_id = sc.id left join categoria c on sc.categoria_id = c.id)"
		JsonHelper.tableToJson(sql, db)
	}

	def getOne(beneficioId: String): JsValue = {
		val select:String = s"(select b.beneficio, b.es_transversal, sc.subcategoria, c.categoria from beneficio b left join subcategoria sc on b.subcategoria_id = sc.id left join categoria c on sc.categoria_id = c.id) as b.id"
		JsonHelper.oneRowToJson(select, "b.id", beneficioId, db)
	}
}
