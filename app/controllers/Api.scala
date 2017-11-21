package controllers

import play.api._
import play.api.mvc._
import play.api.data._
import play.api.data.Forms._
import play.api.libs.json.Json
import javax.inject._
import models.{Colaborador, Solicitud, Beneficio, Presupuesto, SolicitudPorArea}
import scala.concurrent.ExecutionContext.Implicits.global

import play.api.i18n.I18nSupport
import play.api.i18n.MessagesApi

case class SolicitudData(colaboradorId: Int,
						beneficioId: Int,
						solicitado: Option[java.util.Date],
						resuelto:Option[java.util.Date],
						esAprobado:Option[Boolean],
						monto: Option[Int],
						monedaId: Option[Int])

@Singleton
class Api @Inject()(c: Colaborador, s: Solicitud, b: Beneficio, p: Presupuesto, val messagesApi: MessagesApi)  extends Controller with I18nSupport {

	implicit private val solicitudWritesJs = Json.writes[SolicitudPorArea]

	def colaborador(id: String) = Action {
		Ok(c.getOne(id))
	}

	def colaboradores() = Action {
		Ok(c.getAll)
	}

	def search(term: String) = Action {
		Ok(c.selectAllLike(term))
	}

	def solicitudesPorArea = AuthAction.async {
		s.porArea.map( solicitud => Ok(Json.toJson(solicitud)) )
	}

	def beneficio(id: String) = Action {
		Ok(b.select(id))
	}

	def beneficios = Action {
		Ok(b.selectAll())
	}

	def beneficioForm(id: String) = Action {
		Ok(b.beneficioForm(id))
	}

	case class PresupuestoData(monto: Int, asignacion: java.util.Date, beneficioId: Int, monedaId: Int)

	val presupuestoForm: Form[PresupuestoData] = Form(mapping(
		"monto" -> number,
		"asignacion" -> date("yyyy-MM-dd"),
		"moneda_id" -> number,
		"beneficio_id" -> number
	  )(PresupuestoData.apply)(PresupuestoData.unapply)
	)

	def putPresupuesto = Action(parse.form(presupuestoForm)) { implicit r =>
		val b = r.body
		p.create(b.monto, b.asignacion, b.monedaId, b.beneficioId)
			.map( l => Ok(s"Inserted row with id ${l}"))
			.getOrElse(BadRequest("You fool"))
	}


	private val solicitudForm: Form[SolicitudData] = Form(mapping(
		"colaborador_id" -> number,
		"beneficio_id" -> number,
		"solicitado_en" -> optional(date("yyyy-MM-dd")),
		"resuelto_en" -> optional(date("yyyy-MM-dd")),
		"esta_aprobado" -> optional(checked("on")),
		"monto" -> optional(number),
		"moneda_id" -> optional(number)
		)(SolicitudData.apply)(SolicitudData.unapply))

	def putSolicitud = Action(parse.form(solicitudForm)) { implicit r =>
		var b = r.body
		s.create(b.colaboradorId, b.beneficioId, b.solicitado, b.resuelto, b.esAprobado, b.monto, b.monedaId)
			.map( l => Ok(s"Inserted row with id ${l}"))
			.getOrElse(BadRequest("You fool"))
	} 
}

