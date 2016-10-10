DELIMITER //

DROP TABLE IF EXISTS facturas;
DROP TABLE IF EXISTS facturas_aux;

DROP PROCEDURE IF EXISTS insert_factura;
DROP PROCEDURE IF EXISTS start_insert;

SET GLOBAL tx_isolation='SERIALIZABLE';
SET @id = 0;

CREATE TABLE facturas (id INT, PRIMARY KEY(id), name CHAR(20));
CREATE TABLE facturas_aux ( factura_id INT, name CHAR(20));

CREATE PROCEDURE insert_factura(name CHAR(20))
BEGIN
	START TRANSACTION;
		INSERT INTO facturas (SELECT @id, name);
		DO SLEEP(1);
		/* INSERT INTO facturas_aux (, name); */
	COMMIT;
END; //

CREATE TRIGGER inc
AFTER INSERT
   ON facturas FOR EACH ROW
BEGIN
	SET @id := @id + 1;
END; //


CREATE PROCEDURE start_insert(name CHAR(20))
BEGIN
	label1: LOOP
		CALL insert_factura(name);
	END LOOP label1;
END; //

DELIMITER ;

SELECt * FROM facturas;
