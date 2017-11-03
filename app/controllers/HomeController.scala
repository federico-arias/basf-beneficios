package controllers

import play.api._
import play.api.Play.current
import play.api.libs.json._
import play.api.db._
import play.api.mvc._
import pdi.jwt.Jwt
import pdi.jwt.JwtAlgorithm
import scala.concurrent.Future
import javax.inject._
import models._
import scala.concurrent.ExecutionContext.Implicits.global

@Singleton
class HomeController @Inject()(solicitud: BeneficiosDAO) extends Controller {

	implicit val personFormat = Json.format[Solicitud]

	def index = UserAction.async { req =>
		req.user.map ( _ =>
			solicitud.porArea.map( solicitud => Ok(Json.toJson(solicitud)) )
		).getOrElse{Future.successful(Results.Forbidden)}
	}

	def login = Action { req:  Request[AnyContent] => 
		val formulario = req.body.asFormUrlEncoded
		Some(formulario.get("username"))	
			.flatMap( us => Some(formulario.get("password")).flatMap( ps => Login(us(0), ps(0)) ))
			.map( token => Redirect("/").withCookies( Cookie("jwt", token)))
			.getOrElse{Results.Forbidden}
	}

	def beneficios = AuthAction { 
		Action {
			Ok("hello")
		}
	}
}

object Login {
	def apply (u: String, p: String): Option[String] = {
		if (u == "libia" && p == "leon") 
			Some(Jwt.encode("""{"user":1}""", "secretKey", JwtAlgorithm.HS384))
		else None
	}
}



object User {
	def auth[A](req: Request[A]): Option[User] = {
		val Re = """(?<=Bearer\s)\S+""".r
		val authHeader = req.headers.get(http.HeaderNames.AUTHORIZATION)
		authHeader	
			.flatMap(ah => Re.findFirstIn(ah))
			.flatMap(token => Jwt.decodeRawAll(token, "secretKey", Seq(JwtAlgorithm.HS384)).toOption)
			.map(t => t._2)
			.map(n => new User(n))
	}

	def apply(name: String) {
		new User(name)
	}
}

class User(val name: String) 

class AuthReq[A](val user: Option[User], val request: Request[A])
extends WrappedRequest[A](request)

case class AuthAction[A](action: Action[A]) extends ActionBuilder[AuthReq] {
	
	def apply(request: Request[A]): Future[Result] = {
		Logger.info("Calling action")
		action(request)
	  }

	def invokeBlock[A](
		request: Request[A],
		block: AuthReq[A] => Future[Result]): Future[Result] = {
			User.auth(request)
				.map(user => block(new AuthReq(Some(user), request)))
				.getOrElse(Future.successful(Results.Forbidden))
	}
}

object UserAction extends ActionBuilder[AuthReq] with ActionTransformer[Request, AuthReq] {
  def transform[A](request: Request[A]) = Future.successful {
			User.auth(request)
				.map(user => new AuthReq(Some(user), request))
				.getOrElse{new AuthReq(None, request)}
  }
}
