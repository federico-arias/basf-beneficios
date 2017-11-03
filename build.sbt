name := """basf-dev"""

version := "1.0-SNAPSHOT"

lazy val root = (project in file(".")).enablePlugins(PlayScala)

scalaVersion := "2.11.7"

libraryDependencies ++= Seq(
	jdbc,
	cache,
	ws,
	"com.typesafe.play" %% "anorm" % "2.5.3",
	"com.typesafe.akka" %% "akka-actor" % "2.5.6",
	"org.scalatestplus.play" %% "scalatestplus-play" % "1.5.1" % Test,
	"com.pauldijou" %% "jwt-play" % "0.14.0",
	"org.postgresql" % "postgresql" % "42.1.4" 
)

