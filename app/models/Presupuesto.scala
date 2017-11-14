package models

import java.util.Date
import java.text.SimpleDateFormat

import anorm._
import play.api.db.DBApi
import play.api.libs.json.JsValue

import scala.concurrent.Future
import scala.concurrent.ExecutionContext
import javax.inject.Inject

class Presupuesto @Inject()(dbapi: DBApi)(implicit ec: ExecutionContext) {

	private val db = dbapi.database("default")

	def create(monto: Int,
					   asignacion: Date,
					   beneficioId: Int,
					   monedaId: Int): Option[Long] = {
		insert(SQL(
			raw"""
			INSERT INTO presupuesto(monto, asignacion, moneda_id, beneficio_id) 
			VALUES (${monto}, '${asignacion}', ${monedaId}, ${beneficioId})
			"""
			))
	}

	def insert(query: SqlQuery): Option[Long] = {
		db.withConnection{ implicit conn => 
			query.executeInsert()
		}
	}
}
