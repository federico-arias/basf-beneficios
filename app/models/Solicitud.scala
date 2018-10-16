package models

import javax.inject.Inject

import anorm.{ Macro, RowParser, SqlParser}, Macro.ColumnNaming
import anorm.SqlParser._
import anorm._
import play.api.db.DBApi
import play.api.libs.json.JsValue
import java.util.Date

import scala.concurrent.Future
import scala.concurrent.ExecutionContext

case class SolicitudPorArea(area: String, beneficioId: Int, beneficio: String, nSolicitudes: Int, porcentajeAprobacion: Double, beneficioPorArea: Int)

class Solicitud @Inject()(dbapi: DBApi)(implicit ec: ExecutionContext) {

	private val db = dbapi.database("default")

	private[models] val parserSolicitudesPorArea = Macro.namedParser[SolicitudPorArea](ColumnNaming.SnakeCase)

	def porArea: Future[List[SolicitudPorArea]] = Future(db.withConnection { implicit connection =>
		SQL(
			"""
			SELECT c.area,
			b.id AS beneficio_id,
			b.beneficio AS beneficio,
			COUNT(*) AS n_solicitudes,
			SUM(s.esta_aprobado::int)::float / COUNT(*)::float AS porcentaje_aprobacion,
			SUM(COUNT(*)) OVER (PARTITION BY c.area) AS beneficio_por_area
			FROM solicitud AS s
			LEFT JOIN colaborador AS c
			ON s.colaborador_id = c.id
			LEFT JOIN beneficio AS b
			ON s.beneficio_id = b.id
			WHERE s.solicitado_en  >= date_trunc('year', now())
			GROUP BY c.area, b.id, b.beneficio
			"""
			).as(parserSolicitudesPorArea.*)
	})(ec)

	def create(colaboradorId: Int, 
					beneficioId: Int,
					solicitado: Option[Date],
					resuelto: Option[Date],
					esAprobado: Option[Boolean],
					monto: Option[Int],
					monedaId: Option[Int]) = {
		insert(SQL(
			"""
			INSERT INTO solicitud(colaborador_id, beneficio_id, solicitado_en, resuelto_en, esta_aprobado, monto, moneda_id)
			VALUES ({colaboradorId}, {beneficioId}, {solicitado}, {resuelto}, {esAprobado}, {monto}, {monedaId})
			"""
		).on('colaboradorId -> colaboradorId,
			'beneficioId -> beneficioId,
			'solicitado -> solicitado,
			'resuelto -> resuelto,
			'esAprobado -> esAprobado,
			'monto -> monto,
			'monedaId -> monedaId
			)
		)
	}

	def update(modified: Option[Map[String, String]], id: String) = {
		//modified.map( m => m.map( x => 
	}

	def insert(query: SimpleSql[Row]): Option[Long] = {
		db.withConnection{ implicit conn => 
			query.executeInsert()
		}
	}

	def demora(): JsValue = {
		val sql = """
		(SELECT b.pais,
			AVG((s.resuelto_en - s.solicitado_en)::integer)
		FROM solicitud s
		LEFT JOIN beneficio b ON s.beneficio_id = b.id
		WHERE b.es_medido_tiempo_respuesta IS TRUE
		AND s.solicitado_en >= date_trunc('year', now())
		GROUP BY b.pais)
		"""
		JsonHelper.tableToJson(sql, db)
	}

	def demoraAvg(): JsValue = {
		val sql = """
		(SELECT b.id,
			b.beneficio,
			b.pais,
			AVG(s.resuelto_en - s.solicitado_en) AS respuesta
		FROM solicitud s
		LEFT JOIN beneficio b ON s.beneficio_id = b.id
		WHERE b.es_medido_tiempo_respuesta IS TRUE
		AND b.es_aprobado IS TRUE
		AND s.solicitado_en >= date_trunc('year', now())
		GROUP BY b.pais, b.beneficio, b.id
		ORDER BY respuesta DESC)
		"""
		JsonHelper.tableToJson(sql, db)
	}

	def aprobacion(): JsValue = {
		val sql = """
		(SELECT b.id,
			b.beneficio,
			b.pais,
			SUM(s.esta_aprobado::integer) / COUNT(*)::float AS aprobacion,
			COUNT(*) AS n
		FROM solicitud s
		LEFT JOIN beneficio b ON s.beneficio_id = b.id
		WHERE b.es_aprobado IS TRUE
		AND s.solicitado_en >= date_trunc('year', now())
		GROUP BY b.pais, b.beneficio, b.id
		ORDER BY aprobacion ASC)
		"""
		JsonHelper.tableToJson(sql, db)
	}
}
