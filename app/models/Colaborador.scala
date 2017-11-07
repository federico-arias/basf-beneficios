package models

import javax.inject.Inject

import play.api.db.DBApi
import play.api.libs.json.JsValue

import scala.concurrent.Future
import scala.concurrent.ExecutionContext

class Colaborador @Inject()(dbapi: DBApi)(implicit ec: ExecutionContext) {

	private val db = dbapi.database("default")

	def getOne(id: String): JsValue = {
		JsonHelper.oneRowToJson("colaborador", "id", id, db)
	}

	def getByKeyword(searchTerm: String): JsValue = {
		val sql = s"select * from colaborador c where c.colaborador || c.apellido like %$searchTerm%"
		JsonHelper.customSqlToJsonRow(sql, db)
	}

	def getAll: JsValue = {
		JsonHelper.tableToJson("colaborador", db);	
	} 

	def getAllSolicitudes(colaboradorId: Int): JsValue = {
		val sql: String = s"(select * from solicitud where colaborador_id = ${colaboradorId})"
		JsonHelper.tableToJson(sql, db)
	}
}

