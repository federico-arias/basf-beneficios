package models

import javax.inject.Inject

import play.api.db.DBApi
import play.api.libs.json.JsValue

import scala.concurrent.Future
import scala.concurrent.ExecutionContext

class Colaborador @Inject()(dbapi: DBApi)(implicit ec: ExecutionContext) {

	private val db = dbapi.database("default")

	def getOne(id: String): JsValue = {
		val tabla: String = raw"""
		(select c.*, sq.*, gg.*
		from colaborador as c
		left join (select c.id as uuid, json_agg(s.*)
			from colaborador c
			left join (select s.*, b.* from solicitud s
				left join beneficio b
				on s.beneficio_id = b.id) s
			on c.id = s.colaborador_id
			group by c.id) sq
		on c.id = sq.uuid
		right join (select g.colaborador_id, 
						json_agg(g) as cargas
					from (select carga, colaborador_id, rut, nacido_en from carga) g
					group by g.colaborador_id) gg
		on c.id = gg.colaborador_id
		where c.id = ${id})	
		"""
		JsonHelper.oneRowToJson(tabla, "1", "1", db)
	}

	def selectAllLike(searchTerm: String): JsValue = {
		val tabla = s"(select * from colaborador c where c.colaborador ilike '%$searchTerm%')"
		JsonHelper.tableToJson(tabla, db)
	}

	def getAll: JsValue = {
		JsonHelper.tableToJson("colaborador", db);	
	} 

	def getAllSolicitudes(colaboradorId: Int): JsValue = {
		val sql: String = s"(select * from solicitud where colaborador_id = ${colaboradorId})"
		JsonHelper.tableToJson(sql, db)
	}
}

