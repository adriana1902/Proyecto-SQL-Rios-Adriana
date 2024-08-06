DROP DATABASE IF EXISTS las_carmelitas;

CREATE DATABASE las_carmelitas;

USE las_carmelitas; 

CREATE TABLE ALUMNOS (
	id_alumno int NOT NULL PRIMARY KEY
,	nombre  VARCHAR (40) NOT NULL
,	apellido VARCHAR (40) NOT NULL 
,	domicilio VARCHAR (60)
,	telefono VARCHAR (15)
,	anio_ingreso INT NOT NULL	
) ENGINE = innoDB;  

CREATE TABLE PADRES (
	id_padres int NOT NULL PRIMARY KEY,
	nombre VARCHAR (40) NOT NULL,
	apellido VARCHAR (40) NOT NULL, 
	ocupacion VARCHAR (30) NOT NULL,
	domicilio VARCHAR (60) NOT NULL, 
	telefono VARCHAR (15),
    ALUMNOS_id_alumno INT NOT NULL, 
    FOREIGN KEY (ALUMNOS_id_alumno) REFERENCES ALUMNOS (id_alumno)
	) ENGINE = innoDB,  
    COMMENT "ES PADRE DE:" ;

CREATE TABLE ADMINISTRACION (
	id_pagos_admin int NOT NULL,
	id_cobranzas_admin int NOT NULL,
	descripcion varchar(200) NOT NULL,
	CONSTRAINT PK_ADMINISTRACION PRIMARY KEY (id_pagos_admin, id_cobranzas_admin),
	PADRES_id_padres INT NOT NULL,
    FOREIGN KEY (PADRES_id_padres) REFERENCES PADRES (id_padres)
    );

ALTER TABLE ADMINISTRACION ADD INDEX idx_cobranzas (id_cobranzas_admin);

CREATE TABLE PAGOS (
	id_pagos INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	proveedores VARCHAR (100) NOT NULL,
	servicios VARCHAR (60) NOT NULL,
	haberes int NOT NULL,
	cob_medica VARCHAR (20) NOT NULL,
	seguros FLOAT (20.3),
    id_pagos_admin INT NOT NULL,
    id_cobranzas_admin INT NOT NULL,
    ADMINISTRACION_id_pagos_admin INT NOT NULL
    -- FOREIGN KEY (ADMINISTRACION_id_pagos_admin) REFERENCES ADMINISTRACION (id_pagos_admin)
);

ALTER TABLE PAGOS 
	ADD CONSTRAINT fk_pagos_end
	FOREIGN KEY (id_pagos_admin, id_cobranzas_admin) REFERENCES ADMINISTRACION (id_pagos_admin, id_cobranzas_admin);

CREATE TABLE COBRANZAS (
	id_cobranza INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	cuota int NOT NULL,
	matricula int NOT NULL,
	micro int NOT NULL,
	comedor int NOT NULL,
	id_pagos_admin INT NOT NULL,
    id_cobranzas_admin INT NOT NULL
	-- FOREIGN KEY (id_cobranza) REFERENCES ADMINISTRACION (id_cobranzas_admin)
);

ALTER TABLE COBRANZAS 
	ADD CONSTRAINT fk_cobranzas_end
	FOREIGN KEY (id_pagos_admin, id_cobranzas_admin) REFERENCES ADMINISTRACION (id_pagos_admin, id_cobranzas_admin);

    CREATE TABLE DOCENTES (
	id_docente INT NOT NULL PRIMARY KEY, 
	nombre VARCHAR (40) NOT NULL, 
	apellido VARCHAR (40) NOT NULL, 
	titulo VARCHAR (100) NOT NULL, 
	domicilio VARCHAR (160) NOT NULL, 
	telefono VARCHAR (15), 
	email VARCHAR (100) NOT NULL UNIQUE,
	materia VARCHAR (30) NOT NULL,
	hora_ingreso INT NOT NULL, 
    id_pagos_admin INT NOT NULL,
    id_cobranzas_admin INT NOT NULL,
    CONSTRAINT FOREIGN KEY (id_pagos_admin,id_cobranzas_admin) REFERENCES ADMINISTRACION (id_pagos_admin,id_cobranzas_admin)
	) ENGINE = innoDB;

ALTER TABLE DOCENTES 
	ADD CONSTRAINT fk_cobranzas_end
	FOREIGN KEY (id_pagos_admin, id_cobranzas_admin) REFERENCES ADMINISTRACION (id_pagos_admin, id_cobranzas_admin);

CREATE TABLE CICLO_ESCOLAR (
	id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	descripcion varchar(200) NOT NULL,
	id_alumno int NOT NULL, 
    CONSTRAINT FOREIGN KEY (id_alumno) REFERENCES ALUMNOS (id_alumno),
    id_docente int NOT NULL,
    CONSTRAINT FOREIGN KEY (id_docente) REFERENCES DOCENTES (id_docente) 
    ) ENGINE = innoDB  ;

CREATE TABLE INSCRIPCIONES (
  id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  id_alumno INT NOT NULL,
  id_ciclo_escolar INT NOT NULL,
  id_docente INT NOT NULL,
  anio_escolar INT NOT NULL,
  FOREIGN KEY (id_alumno) REFERENCES ALUMNOS (id_alumno),
  FOREIGN KEY (id_ciclo_escolar) REFERENCES CICLO_ESCOLAR (id),
  FOREIGN KEY (id_docente) REFERENCES DOCENTES (id_docente)
);

CREATE TABLE MATERIAS (
	id_materia INT NOT NULL PRIMARY KEY
,	descripcion VARCHAR (30)
,	id INT NOT NULL AUTO_INCREMENT 
,	FOREIGN KEY (id) REFERENCES CICLO_ESCOLAR (id)
);

LOAD DATA LOCAL INFILE './alumnos.csv'
        INTO TABLE  ALUMNOS 
            FIELDS TERMINATED   BY ','  ENCLOSED BY ''
            LINES TERMINATED    BY '\n' 		 
            IGNORE 1 LINES
		(id_alumno,nombre,apellido,domicilio,telefono,anio_ingreso) ;
  
use las_carmelitas; select * from padres ;

LOAD DATA LOCAL INFILE './padres.csv'
        INTO TABLE  PADRES 
            FIELDS TERMINATED   BY ','  ENCLOSED BY ''
            LINES TERMINATED    BY '\n' 		 
            IGNORE 1 LINES
		(id_padres,nombre,apellido,ocupacion,domicilio,telefono,ALUMNOS_id_alumno) ;



CREATE VIEW APELLIDO_ALUMNOS_VISTA as 
	SELECT apellido
	FROM ALUMNOS; 