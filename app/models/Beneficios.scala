package models

import javax.inject.Inject

import anorm.{ Macro, RowParser}, Macro.ColumnNaming
import anorm.SqlParser._
import anorm._
import play.api.db.DBApi

import scala.concurrent.Future
import scala.concurrent.ExecutionContext


case class Solicitud(area: String, beneficioId: Int, beneficio: String, nSolicitudes: Int, porcentajeAprobacion: Double, beneficioPorArea: Int)

@javax.inject.Singleton
class BeneficiosDAO @Inject()(dbapi: DBApi)(implicit ec: ExecutionContext) {

	private val db = dbapi.database("default")

	private[models] val parserSolicitudesPorArea = Macro.namedParser[Solicitud](ColumnNaming.SnakeCase)

	def porArea: Future[List[Solicitud]] = Future(db.withConnection { implicit connection =>
		SQL(
			"""
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
			GROUP BY c.area, b.id, b.beneficio
			"""
			).as(parserSolicitudesPorArea.*)
	})(ec)
}
