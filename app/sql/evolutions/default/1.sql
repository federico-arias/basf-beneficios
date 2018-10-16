# --- !Ups

ALTER TABLE encuesta 
	RENAME aplicacion TO aplicada_en;



# --- !Downs

ALTER TABLE encuesta 
	RENAME aplicada_en TO aplicacion;
