CREATE SCHEMA drugdatabase;

USE drugdatabase;

CREATE TABLE customer (
  uid1 varchar(20) NOT NULL,
  pass varchar(20) DEFAULT NULL,
  fname varchar(15) DEFAULT NULL,
  lname varchar(15) DEFAULT NULL,
  email varchar(30) DEFAULT NULL,
  address1 varchar(128) DEFAULT NULL,
  phno bigint DEFAULT NULL,
  PRIMARY KEY (uid1)
);

CREATE TABLE seller (
  sid1 varchar(15) NOT NULL,
  sname varchar(20) DEFAULT NULL,
  pass varchar(20) DEFAULT NULL,
  address1 varchar(128) DEFAULT NULL,
  phno bigint DEFAULT NULL,
  PRIMARY KEY (sid1)
);

CREATE TABLE product (
  pid varchar(15) NOT NULL,
  pname varchar(20) DEFAULT NULL,
  manufacturer varchar(20) DEFAULT NULL,
  mfg date DEFAULT NULL,
  exp date DEFAULT NULL,
  price int DEFAULT NULL,
  PRIMARY KEY (pid),
  UNIQUE KEY pname (pname)
);

CREATE TABLE inventory (
  pid varchar(15) NOT NULL,
  pname varchar(20) DEFAULT NULL,
  quantity int unsigned DEFAULT NULL,
  sid1 varchar(15) NOT NULL,
  PRIMARY KEY (pid,sid1),
  CONSTRAINT fk01 FOREIGN KEY (pid) REFERENCES product (pid) ON DELETE CASCADE,
  CONSTRAINT fk02 FOREIGN KEY (pname) REFERENCES product (pname) ON DELETE CASCADE,
  CONSTRAINT fk03 FOREIGN KEY (sid1) REFERENCES seller (sid1) ON DELETE CASCADE
);

CREATE TABLE orders (
 oid1 Int NOT NULL AUTO_INCREMENT,
 pid varchar(15) DEFAULT NULL,
 sid1 varchar(15) DEFAULT NULL,
 uid1 varchar(15) DEFAULT NULL,
 orderdatetime datetime DEFAULT NULL,
 quantity int unsigned DEFAULT NULL,
 price int unsigned DEFAULT NULL,
 PRIMARY KEY (oid1),
 CONSTRAINT fk04 FOREIGN KEY (pid) REFERENCES product (pid) ON DELETE CASCADE,
 CONSTRAINT fk05 FOREIGN KEY (sid1) REFERENCES seller (sid1) ON DELETE CASCADE,
 CONSTRAINT fk06 FOREIGN KEY (uid1) REFERENCES customer (uid1) ON DELETE CASCADE
);

ALTER TABLE orders AUTO_INCREMENT=1000;




DELIMITER //

CREATE TRIGGER updatetime BEFORE INSERT ON orders FOR EACH ROW
BEGIN
    SET NEW.orderdatetime = NOW();
END//

DELIMITER ;



DELIMITER //
CREATE TRIGGER inventorytrigger AFTER INSERT ON orders
FOR EACH ROW
begin

DECLARE qnty int;
DECLARE productid varchar(20);

SELECT   pid INTO productid
FROM      orders
ORDER BY  oid1 DESC
LIMIT     1;

SELECT   quantity INTO qnty 
FROM      orders
ORDER BY  oid1 DESC
LIMIT     1;

UPDATE inventory
SET quantity=quantity-qnty
WHERE pid=productid;
END//

DELIMITER ;





DELIMITER //

CREATE PROCEDURE getsellerorders(IN param1 VARCHAR(20))
BEGIN
    SELECT *  FROM orders where sid1=param1;
END //
 
DELIMITER ;



DELIMITER //

CREATE PROCEDURE getorders
(IN param1 VARCHAR(20))
BEGIN
   SELECT * FROM orders WHERE uid1=param1;
END //

DELIMITER ;