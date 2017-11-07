package models

import play.api.libs.json.JsValue
import java.util.Date
import anorm._
import play.api.db.DBApi

import scala.concurrent.Future
import scala.concurrent.ExecutionContext
import javax.inject.Inject

class Presupuesto @Inject()(dbapi: DBApi)(implicit ec: ExecutionContext) {

	private val db = dbapi.database("default")

	def putPresupuesto(monto: Int,
					   asignacion: Date,
					   beneficioId: Int,
					   monedaId: Int): Option[Long] = {
		insert(SQL(
			"""
			INSERT INTO presupuesto(id, monto, moneda_id, beneficio_id) 
			VALUES (${asignacion}, ${monto}, ${monedaId} ${beneficioId})
			"""
			))

	}

	def getAllPresupuestosByBeneficioId(beneficioId: Int): JsValue = ???

	def insert(query: SqlQuery): Option[Long] = {
		db.withConnection{ implicit conn => 
			query.executeInsert()
		}
	}
}
