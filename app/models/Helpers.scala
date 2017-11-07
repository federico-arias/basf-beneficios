package models

import anorm.SQL
import anorm.SqlParser._
import anorm._
import play.api.libs.json.{JsValue, Json}
import play.api.db.Database

object JsonHelper {

	/*
	implicit object jsonToStatement extends ToStatement[JsValue] {
		def set(s: PreparedStatement, i: Int, json: JsValue):Unit={
			val jsonObject=new org.postgresql.util.PGobject()  
			jsonObject.setType("json")
			jsonObject.setValue(Json.stringify(json))
			s.setObject(i, jsonObject)
		}
	}
	 */

	implicit val columnToJsValue:Column[JsValue]=anorm.Column.nonNull[JsValue] { (value, meta) =>
		val MetaDataItem(qualified, nullable, clazz)=meta
		value match {
			case json: org.postgresql.util.PGobject=> Right(Json.parse(json.getValue))
			case _ => Left(TypeDoesNotMatch(s"Cannot convert $value: ${value.asInstanceOf[AnyRef].getClass} to Json for column $qualified"))
		}
	}

	val JSON = "application/json"


	def tableToJson(tablename: String, db: Database) = {
		val sql = s"select array_to_json(array_agg(row_to_json(t))) as result from $tablename t;"
		customSqlToJsonRow(sql, db)
	}

	def oneRowToJson(tablename: String, idColumn: String, id: String, db: Database) = {
		val sql = s"select row_to_json(t) as result from $tablename t where $idColumn = $id;"
		customSqlToJsonRow(sql, db)
	}

	def customSqlToJsonRow(sql: String, db: Database) = {
		db.withConnection { implicit conn => 
			SQL(sql).as(get[JsValue]("result").single) 
		} 
	}
}
