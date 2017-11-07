package controllers

import play.api._
import play.api.mvc._
import javax.inject._
import models.{Colaborador, SolicitudDao, Beneficio}

@Singleton
class Api @Inject()(c: Colaborador, s: SolicitudDao, b: Beneficio) extends Controller {
	def colaborador(id: String) = Action {
		Ok(c.getOne(id))
	}

	def colaboradores() = Action {
		Ok(c.getAll)
	}

	def solicitudesPorArea = AuthAction.async {
			s.porArea.map( solicitud => Ok(Json.toJson(solicitud)) )
	}

	def beneficio(id: String) = Action {
		Ok(b.getOne(id))
	}

	def beneficios = Action {
		Ok(b.getAll())
	}


} 
