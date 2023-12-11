/*Create new database*/
CREATE SCHEMA IF NOT EXISTS `SYW` DEFAULT CHARACTER SET UTF8MB4;
/*Tell which database you will use*/
USE SYW;

--------------------------------------------------------
-- Tables
--------------------------------------------------------

/*Create table for countries*/
CREATE TABLE IF NOT EXISTS `country` (
  `COUNTRY_ID` VARCHAR(2) NOT NULL,
  `COUNTRY_NAME` VARCHAR(25) NOT NULL,
  PRIMARY KEY (`COUNTRY_ID`))
ENGINE = InnoDB;


/*Create table with customers information*/
CREATE TABLE IF NOT EXISTS `customer` (
  `CUSTOMER_ID` INT NOT NULL AUTO_INCREMENT UNIQUE,
  `FIRST_NAME` VARCHAR(20) NOT NULL,
  `LAST_NAME` VARCHAR(25) NOT NULL,
  `EMAIL` VARCHAR(35) NOT NULL,
  `PHONE_NUMBER` VARCHAR(20) NOT NULL,
  `STREET_ADDRESS` VARCHAR(40) NOT NULL,
  `POSTAL_CODE` VARCHAR(12) NOT NULL,
  `CITY` VARCHAR(30) NOT NULL,
  `COUNTRY_ID` VARCHAR(2) NOT NULL,
  PRIMARY KEY (`CUSTOMER_ID`),
  CONSTRAINT `fk_country`
    FOREIGN KEY (`COUNTRY_ID`)
    REFERENCES `SYW`.`country` (`COUNTRY_ID`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE) 
ENGINE = InnoDB;


/*Create table with suppliers information*/
CREATE TABLE IF NOT EXISTS `supplier` (
  `SUPPLIER_ID` INT NOT NULL AUTO_INCREMENT UNIQUE,
  `SUPPLIER_NAME` VARCHAR(35) NOT NULL,
  `EMAIL` VARCHAR(35) NOT NULL,
  `PHONE_NUMBER` VARCHAR(20) NOT NULL,
  `STREET_ADDRESS` VARCHAR(40) NOT NULL,
  `POSTAL_CODE` VARCHAR(12) NOT NULL,
  `CITY` VARCHAR(30) NOT NULL,
  `COUNTRY_ID` VARCHAR(2) NOT NULL,
  PRIMARY KEY (`SUPPLIER_ID`),
  CONSTRAINT `fk_country_supplier`
    FOREIGN KEY (`COUNTRY_ID`)
    REFERENCES `SYW`.`country` (`COUNTRY_ID`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE)
ENGINE = InnoDB;


/*Create table with carriers information*/
CREATE TABLE IF NOT EXISTS `carrier` (
  `CARRIER_ID` INT NOT NULL AUTO_INCREMENT UNIQUE, 
  `CARRIER_COMPANY` VARCHAR(25) NOT NULL,
  `TRANSPORT_MODE` VARCHAR(20) DEFAULT NULL,
  `EMAIL` VARCHAR(35) NOT NULL,
  `PHONE_NUMBER` VARCHAR(20) NOT NULL, 
  PRIMARY KEY (`CARRIER_ID`)) 
ENGINE = InnoDB;


/*Create table with promotions*/
CREATE TABLE IF NOT EXISTS `promo` (
  `PROMO_ID` INT NOT NULL AUTO_INCREMENT UNIQUE,
  `PROMO_CODE` VARCHAR(15) NOT NULL,
  `DISCOUNT` TINYINT NOT NULL,
  PRIMARY KEY (`PROMO_ID`))
ENGINE = InnoDB;



/*Create table for orders.*/
CREATE TABLE IF NOT EXISTS `order` (
  `ORDER_ID` INT NOT NULL AUTO_INCREMENT UNIQUE,
  `DATE` DATE NOT NULL,
  `CUSTOMER_ID` INT NOT NULL,
  `PROMO_ID` INT DEFAULT NULL,
  `TOTAL_PRICE` DECIMAL(7,2) NOT NULL,
  `RATING` TINYINT NULL,
  PRIMARY KEY (`ORDER_ID`),
  CONSTRAINT `fk_customer`
    FOREIGN KEY (`CUSTOMER_ID`)
    REFERENCES `SYW`.`customer` (`CUSTOMER_ID`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
  CONSTRAINT `fk_promo_applied`
    FOREIGN KEY (`PROMO_ID`)
    REFERENCES `SYW`.`promo` (`PROMO_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `ck_rating` CHECK (`RATING` IS NULL OR `RATING` BETWEEN 1 AND 5))
ENGINE = InnoDB;


/*Create table with items information*/
CREATE TABLE IF NOT EXISTS `item` (
  `ITEM_ID` INT NOT NULL AUTO_INCREMENT UNIQUE,
  `MODEL` VARCHAR(30) NOT NULL,
  `BRAND` VARCHAR(15) NOT NULL,
  `STOCK` INT NOT NULL,
  `PRICE` DECIMAL(6,2) NOT NULL,
  `RATING_ITEM` TINYINT DEFAULT NULL,
  PRIMARY KEY (`ITEM_ID`),
CONSTRAINT `ck_rating_item` CHECK (`RATING_ITEM` IS NULL OR `RATING_ITEM` BETWEEN 1 AND 5))
ENGINE = InnoDB;


/*Create table order_line. 
This will be a linking table between orders and items, so an order can have more than one item.*/
CREATE TABLE IF NOT EXISTS `order_line` (
  `ORDER_LINE_ID` INT NOT NULL AUTO_INCREMENT UNIQUE,
  `ORDER_ID` INT NOT NULL,
  `ITEM_ID` INT NOT NULL,
  `QUANTITY` INT NOT NULL,
  PRIMARY KEY (`ORDER_LINE_ID`),
  CONSTRAINT `fk_order`
    FOREIGN KEY (`ORDER_ID`)
    REFERENCES `SYW`.`order` (`ORDER_ID`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
  CONSTRAINT `fk_item`
    FOREIGN KEY (`ITEM_ID`)
    REFERENCES `SYW`.`item` (`ITEM_ID`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE)
ENGINE = InnoDB;


/*Create table with orders to the suppliers*/
CREATE TABLE IF NOT EXISTS `order_supplier` (
  `ORDER_SUP_ID` INT NOT NULL AUTO_INCREMENT UNIQUE,
  `DATE` DATE NOT NULL,
  `SUPPLIER_ID` INT NOT NULL,
  `ITEM_ID` INT NOT NULL,
  `SUPPLY_QUANTITY` INT NOT NULL,
  `SUPPLY_PRICE` DECIMAL(6,2) NOT NULL,
  PRIMARY KEY (`ORDER_SUP_ID`),
  CONSTRAINT `fk_order_to_supplier`
    FOREIGN KEY (`SUPPLIER_ID`)
    REFERENCES `SYW`.`supplier` (`SUPPLIER_ID`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
  CONSTRAINT `fk_item_supplied`
    FOREIGN KEY (`ITEM_ID`)
    REFERENCES `SYW`.`item` (`ITEM_ID`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE) 
ENGINE = InnoDB;


/*Create table with delivery information. This serves both for customers delivery and suppliers delivery*/
CREATE TABLE IF NOT EXISTS `delivery` (
  `DELIVERY_ID` INT NOT NULL AUTO_INCREMENT UNIQUE,
  `ORDER_ID` INT DEFAULT NULL,
  `ORDER_SUP_ID` INT DEFAULT NULL,
  `CARRIER_ID` INT NOT NULL,
  PRIMARY KEY (`DELIVERY_ID`),
  CONSTRAINT `fk_order_client`
    FOREIGN KEY (`ORDER_ID`)
    REFERENCES `SYW`.`order` (`ORDER_ID`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
  CONSTRAINT `fk_order_supplier`
    FOREIGN KEY (`ORDER_SUP_ID`)
    REFERENCES `SYW`.`order_supplier` (`ORDER_SUP_ID`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE, 
  CONSTRAINT `fk_carrier_order`
    FOREIGN KEY (`CARRIER_ID`)
    REFERENCES `SYW`.`carrier` (`CARRIER_ID`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE)
ENGINE = InnoDB;


CREATE TABLE IF NOT EXISTS `syw`.`log` (
  `ID` INT NOT NULL AUTO_INCREMENT,
  `ORDER_ID` INT NOT NULL,
  `COUNTRY_ID` VARCHAR(2) NOT NULL,
  `NUMBER_ITEMS` INT DEFAULT NULL,
  `AMOUNT` DECIMAL(7,2) NOT NULL,
  PRIMARY KEY (`ID`))
ENGINE = InnoDB;


---------------------------------------------------------
-- Data
---------------------------------------------------------

/*Populate country table*/
INSERT INTO `country` (`COUNTRY_ID`, `COUNTRY_NAME`) VALUES
('AL', 'Albania'),
('AD', 'Andorra'),
('AT', 'Austria'),
('BY', 'Belarus'),
('BE', 'Belgium'),
('BA', 'Bosnia and Herzegovina'),
('BG', 'Bulgaria'),
('HR', 'Croatia'),
('CY', 'Cyprus'),
('CZ', 'Czech Republic'),
('DK', 'Denmark'),
('EE', 'Estonia'),
('FI', 'Finland'),
('FR', 'France'),
('DE', 'Germany'),
('GR', 'Greece'),
('HU', 'Hungary'),
('IS', 'Iceland'),
('IE', 'Ireland'),
('IT', 'Italy'),
('LV', 'Latvia'),
('LI', 'Liechtenstein'),
('LT', 'Lithuania'),
('LU', 'Luxembourg'),
('MK', 'North Macedonia'),
('MT', 'Malta'),
('MD', 'Moldova'),
('MC', 'Monaco'),
('ME', 'Montenegro'),
('NL', 'Netherlands'),
('NO', 'Norway'),
('PL', 'Poland'),
('PT', 'Portugal'),
('RO', 'Romania'),
('RU', 'Russia'),
('SM', 'San Marino'),
('RS', 'Serbia'),
('SK', 'Slovakia'),
('SI', 'Slovenia'),
('ES', 'Spain'),
('SE', 'Sweden'),
('CH', 'Switzerland'),
('UA', 'Ukraine'),
('GB', 'United Kingdom'),
('VA', 'Vatican City');

-- Add more countries as needed


/*Populate customer table*/
INSERT INTO `customer` (`FIRST_NAME`, `LAST_NAME`, `EMAIL`, `PHONE_NUMBER`, `STREET_ADDRESS`, `POSTAL_CODE`, `CITY`, `COUNTRY_ID`) VALUES
('Anna', 'Schmidt', 'anna.schmidt@email.de', '123-456-7890', 'Hauptstrasse 123', '12345', 'Berlin', 'DE'),
('Luca', 'Ricci', 'luca.ricci@email.it', '987-654-3210', 'Via Roma 456', '54321', 'Rome', 'IT'),
('Sophie', 'Dubois', 'sophie.dubois@email.fr', '456-789-0123', 'Rue de la Mode 789', '67890', 'Paris', 'FR'),
('Miguel', 'Lopez', 'miguel.lopez@email.es', '321-098-7654', 'Calle Principal 321', '09876', 'Madrid', 'ES'),
('Elena', 'Ivanova', 'elena.ivanova@email.ru', '789-012-3456', 'Ulitsa Gorkogo 654', '54321', 'Moscow', 'RU'),
('Jan', 'Jansen', 'jan.jansen@email.nl', '234-567-8901', 'Hoofdstraat 987', '23456', 'Amsterdam', 'NL'),
('Sophia', 'Andersson', 'sophia.andersson@email.se', '876-543-2109', 'Storgatan 210', '10987', 'Stockholm', 'SE'),
('Andreas', 'Müller', 'andreas.mueller@email.de', '543-210-9876', 'Musterstrasse 543', '09876', 'Munich', 'DE'),
('Maria', 'Costa', 'maria.costa@email.pt', '210-987-6543', 'Rua das Flores 876', '76543', 'Lisbon', 'PT'),
('Mateo', 'Ortega', 'mateo.ortega@email.es', '789-012-3456', 'Calle Mayor 123', '21098', 'Barcelona', 'ES'),
('Isabella', 'Rossi', 'isabella.rossi@email.it', '345-678-9012', 'Via Dante 876', '09876', 'Milan', 'IT'),
('Liam', 'Smith', 'liam.smith@email.uk', '012-345-6789', 'High Street 234', '56789', 'London', 'GB'),
('Sofia', 'Kovacs', 'sofia.kovacs@email.hu', '789-012-3456', 'Király utca 567', '43210', 'Budapest', 'HU'),
('Lucas', 'Kowalski', 'lucas.kowalski@email.pl', '234-567-8901', 'Nowy Świat 890', '54321', 'Warsaw', 'PL'),
('Emma', 'Andersen', 'emma.andersen@email.dk', '876-543-2109', 'Strøget 210', '09876', 'Copenhagen', 'DK'),
('Giorgos', 'Papadopoulos', 'giorgos.papadopoulos@email.gr', '543-210-9876', 'Ermou 543', '76543', 'Athens', 'GR'),
('Anita', 'Novak', 'anita.novak@email.si', '210-987-6543', 'Prešernov trg 876', '21098', 'Ljubljana', 'SI'),
('Tomasz', 'Nowak', 'tomasz.nowak@email.pl', '789-012-3456', 'Plac Zamkowy 123', '43210', 'Warsaw', 'PL'),
('Sophie', 'Bergman', 'sophie.bergman@email.se', '345-678-9012', 'Drottninggatan 876', '56789', 'Stockholm', 'SE'),
('Nikos', 'Pappas', 'nikos.pappas@email.gr', '012-345-6789', 'Leoforos Vasilissis Sofias 234', '21098', 'Athens', 'GR'),
('Eva', 'Lopez', 'eva.lopez@email.es', '789-012-3456', 'Carrer Gran Via 543', '09876', 'Barcelona', 'ES'),
('Giovanni', 'Conti', 'giovanni.conti@email.it', '234-567-8901', 'Via del Corso 876', '54321', 'Rome', 'IT'),
('Julia', 'Andersson', 'julia.andersson@email.se', '876-543-2109', 'Drottninggatan 210', '10987', 'Stockholm', 'SE'),
('Piotr', 'Wojcik', 'piotr.wojcik@email.pl', '543-210-9876', 'Aleje Jerozolimskie 765', '09876', 'Warsaw', 'PL'),
('Sophie', 'Dubois', 'sophie.dubois@email.fr', '210-987-6543', 'Rue du Faubourg Saint-Honoré 543', '21098', 'Paris', 'FR'),
('Marta', 'Gomez', 'marta.gomez@email.es', '789-012-3456', 'Calle de Alcalá 876', '76543', 'Madrid', 'ES'),
('Fabio', 'Ricci', 'fabio.ricci@email.it', '012-345-6789', 'Via della Conciliazione 210', '43210', 'Rome', 'IT'),
('Anastasia', 'Ivanova', 'anastasia.ivanova@email.ru', '543-210-9876', 'Nevsky Prospect 890', '21098', 'St. Petersburg', 'RU'),
('Frederik', 'Nielsen', 'frederik.nielsen@email.dk', '210-987-6543', 'Nyhavn 543', '09876', 'Copenhagen', 'DK'),
('Elena', 'Russo', 'elena.russo@email.it', '789-012-3456', 'Piazza San Marco 210', '76543', 'Venice', 'IT'),
('Oliver', 'Müller', 'oliver.muller@email.de', '543-210-9876', 'Kurfürstendamm 765', '43210', 'Berlin', 'DE'),
('Alessia', 'Ricci', 'alessia.ricci@email.it', '210-987-6543', 'Via Garibaldi 543', '21098', 'Milan', 'IT'),
('Lukas', 'Kovacs', 'lukas.kovacs@email.hu', '789-012-3456', 'Vörösmarty tér 210', '09876', 'Budapest', 'HU'),
('Ines', 'Ferreira', 'ines.ferreira@email.pt', '543-210-9876', 'Rua Augusta 543', '43210', 'Lisbon', 'PT'),
('Alejandro', 'Gomez', 'alejandro.gomez@email.es', '210-987-6543', 'Plaza Mayor 210', '21098', 'Madrid', 'ES'),
('Eva', 'Bergman', 'eva.bergman@email.se', '789-012-3456', 'Kungsgatan 543', '76543', 'Stockholm', 'SE'),
('Giulia', 'Moretti', 'giulia.moretti@email.it', '543-210-9876', 'Via Veneto 765', '43210', 'Rome', 'IT'),
('Sebastian', 'Andersson', 'sebastian.andersson@email.se', '210-987-6543', 'Vasagatan 210', '21098', 'Stockholm', 'SE'),
('Nina', 'Jansen', 'nina.jansen@email.nl', '789-012-3456', 'Leidsestraat 543', '09876', 'Amsterdam', 'NL'),
('Mateo', 'Lopez', 'mateo.lopez@email.es', '210-987-6543', 'Calle Gran Vía 210', '76543', 'Madrid', 'ES'),
('Sofia', 'Ricci', 'sofia.ricci@email.it', '789-012-3456', 'Via Condotti 543', '43210', 'Rome', 'IT'),
('Emil', 'Andersen', 'emil.andersen@email.dk', '543-210-9876', 'Strøget 765', '21098', 'Copenhagen', 'DK'),
('Luis', 'Gomez', 'luis.gomez@email.es', '210-987-6543', 'Calle Serrano 210', '09876', 'Madrid', 'ES'),
('Zofia', 'Nowak', 'zofia.nowak@email.pl', '789-012-3456', 'Nowy Świat 543', '76543', 'Warsaw', 'PL'),
('Matteo', 'Rossi', 'matteo.rossi@email.it', '543-210-9876', 'Via della Libertà 210', '43210', 'Palermo', 'IT');


/*Populate supplier table*/
INSERT INTO `supplier` (`SUPPLIER_NAME`, `EMAIL`, `PHONE_NUMBER`, `STREET_ADDRESS`, `POSTAL_CODE`, `CITY`, `COUNTRY_ID`) VALUES
('SneakPeak Ltd.', 'sneakpeak@email.com', '+1234567890', '123 High Street', '12345', 'London', 'GB'),
('EuroKicks', 'eurokicks@email.com', '+9876543210', '456 Fashion Avenue', '54321', 'Paris', 'FR'),
('EliteFootwear GmbH', 'elite@email.com', '+4445556666', '789 Trendy Lane', '98765', 'Berlin', 'DE'),
('LuxeSoles Srl', 'luxesoles@email.com', '+1112223333', '101 Luxury Road', '56789', 'Milan', 'IT'),
('NordicSneaks AB', 'nordicsneaks@email.com', '+6667778888', '321 Trendsetter Street', '43210', 'Stockholm', 'SE'),
('MadKicks SA', 'madkicks@email.com', '+3334445555', '876 Urban Plaza', '10987', 'Madrid', 'ES'),
('FunkyFeet Ltd.', 'funkyfeet@email.com', '+9990001111', '555 Groovy Lane', '87654', 'Amsterdam', 'NL'),
('EleganceFootwear AG', 'elegance@email.com', '+7778889999', '777 Chic Avenue', '54321', 'Zurich', 'CH'),
('StyleMasters SAS', 'stylemasters@email.com', '+2223334444', '888 Fashion Boulevard', '23456', 'Brussels', 'BE'),
('EasternSneakers Kft.', 'easternsneakers@email.com', '+5556667777', '444 Eastern Street', '76543', 'Budapest', 'HU'),
('GoldenSole Oy', 'goldensole@email.com', '+1233214567', '222 Gold Lane', '87654', 'Helsinki', 'FI'),
('BalkanKicks Ltd.', 'balkankicks@email.com', '+9876541230', '999 Limited Edition Road', '12345', 'Sofia', 'BG'),
('ScandiSteps ApS', 'scandisteps@email.com', '+6543210987', '789 Scandi Street', '43210', 'Copenhagen', 'DK'),
('MediterraneanStyle Srl', 'mediterranean@email.com', '+9871234567', '456 Med Street', '10987', 'Athens', 'GR'),
('PolishPrestige Sp. z o.o.', 'polishprestige@email.com', '+1234567890', '123 Prestige Lane', '56789', 'Warsaw', 'PL'),
('IberianInnovation SL', 'iberian@email.com', '+3456789012', '666 Innovation Avenue', '23456', 'Lisbon', 'PT'),
('CentralSneaks s.r.o.', 'centralsneaks@email.com', '+7890123456', '333 Central Street', '87654', 'Prague', 'CZ'),
('BalticShoes AS', 'balticshoes@email.com', '+2345678901', '777 Baltic Boulevard', '54321', 'Riga', 'LV'),
('EstonianElegance OÜ', 'estonianelegance@email.com', '+8901234567', '888 Elegance Lane', '43210', 'Tallinn', 'EE'),
('LuxurySteps ApS', 'luxurysteps@email.com', '+5678901234', '555 Luxury Road', '10987', 'Oslo', 'NO');



/*Populate carrier table*/
INSERT INTO `carrier` (`CARRIER_COMPANY`, `TRANSPORT_MODE`, `EMAIL`, `PHONE_NUMBER`) VALUES
('Speedy Ship', 'Air', 'info@speedyship.com', '123-456-7890'),
('Cargo Express', 'Sea', 'contact@cargoxpress.com', '987-654-3210'),
('Ground Haulers', 'Land', 'info@groundhaulers.com', '456-789-0123'),
('Swift Transport', 'Air', 'info@swifttransport.com', '321-098-7654'),
('Ocean Freight Co.', 'Sea', 'sales@oceanfreight.com', '789-012-3456'),
('Road Warriors Logistics', 'Land', 'info@roadwarriors.com', '234-567-8901'),
('Airborne Carriers', 'Air', 'contact@airbornecarriers.com', '876-543-2109'),
('Sea Breeze Shipping', 'Sea', 'info@seabreezeshipping.com', '543-210-9876'),
('Ground Express', 'Land', 'sales@groundexpress.com', '210-987-6543'),
('Global Trans Logistics', 'Air', 'info@globaltrans.com', '789-012-3456');


/*Populate promotion table*/
INSERT INTO `promo` (`PROMO_CODE`, `DISCOUNT`) VALUES
('SAVE10', 10),
('FREESHIP', 5),
('FLASHSALE20', 20),
('NEWUSER15', 15),
('WEEKEND25', 25),
('SPRINGSALE', 12),
('SUMMER20', 20),
('LOYALTY10', 10),
('HOLIDAY15', 15),
('CLEARANCE30', 30);


/*Populate order table */
INSERT INTO `order` (`DATE`, `CUSTOMER_ID`, `PROMO_ID`, `TOTAL_PRICE`, `RATING`) VALUES
('2022-01-05', 1, NULL, 550.00, 4),
('2022-02-10', 2, 1, 680.00, 5),
('2022-03-15', 3, NULL, 420.00, 3),
('2022-04-20', 4, 6, 630.00, 4),
('2022-07-05', 7, 7, 425.00, 5),
('2022-08-10', 8, 1, 496.00, 3),
('2022-09-15', 9, NULL, 598.00, 4),
('2022-10-20', 10, 3, 662.00, 5),
('2022-11-25', 11, 9, 431.00, 4),
('2022-12-30', 12, 9, 520.00, 5),
('2023-01-15', 3, NULL, 394.00, 3),
('2023-02-20', 14, 2, 416.00, 4),
('2023-04-30', 16, 6, 442.50, 3),
('2023-06-10', 18, 7, 592.00, 5),
('2023-09-25', 21, NULL, 380.00, 5),
('2023-10-30', 22, 4, 220.00, 4),
('2023-11-04', 23, NULL, 350.00, 5),
('2023-12-09', 24, 1, 480.00, 3),
('2023-01-14', 2, NULL, 310.00, 4),
('2023-02-19', 26, 3, 495.00, 5),
('2023-03-26', 27, NULL, 620.00, NULL),
('2023-04-01', 28, 2, 375.00, NULL),
('2023-05-06', 29, NULL, 498.00, NULL),
('2023-06-11', 3, 7, 640.00, NULL);


/*Populate item table*/
INSERT INTO `item` (`MODEL`, `BRAND`, `STOCK`, `PRICE`, `RATING_ITEM`) VALUES
('Air Max 1', 'Nike', 10, 199.99, 4),
('Classic Leather', 'Reebok', 20, 149.99, 5),
('Superstar', 'Adidas', 10, 299.99, 4),
('Chuck Taylor All Star', 'Converse', 15, 129.99, 5),
('Old Skool', 'Vans', 25, 179.99, 4),
('Gel-Lyte III', 'ASICS', 30, 249.99, 3),
('Stan Smith', 'Adidas', 10, 159.99, 5),
('Air Force 1', 'Nike', 25, 199.99, 4),
('Chuck 70', 'Converse', 18, 169.99, 5),
('Superstar Boost', 'Adidas', 22, 219.99, 4),
('Sk8-Hi', 'Vans', 18, 189.99, 3),
('Air Jordan 1', 'Nike', 12, 139.99, 5),
('Zoom Pegasus Turbo', 'Nike', 15, 179.99, 4),
('Ultraboost', 'Adidas', 23, 199.99, 5),
('Gazelle', 'Adidas', 15, 149.99, 4),
('Epic React Flyknit', 'Nike', 20, 169.99, 5),
('Air Max 90', 'Nike', 22, 189.99, 4),
('Club C 85', 'Reebok', 18, 129.99, 5),
('Classic Slip-On', 'Vans', 25, 99.99, 4),
('Gel-Kayano 5', 'ASICS', 15, 219.99, 3),
('Chuck Taylor 2', 'Converse', 20, 119.99, 5),
('Air Max 270', 'Nike', 10, 229.99, 4),
('NMD R1', 'Adidas', 25, 179.99, 5),
('Sk8-Hi Pro', 'Vans', 15, 159.99, 4),
('Gel-Quantum 360', 'ASICS', 12, 249.99, 5),
('Chuck Taylor 70', 'Converse', 10, 139.99, 3),
('Air Max 97', 'Nike', 18, 199.99, 5),
('Ultra Boost Uncaged', 'Adidas', 18, 169.99, 4),
('Classic Leather Legacy', 'Reebok', 22, 139.99, 5),
('Authentic', 'Vans', 25, 89.99, 4),
('Air Max 90 Premium', 'Nike', 20, 189.99, 4),
('NMD R1 STLT', 'Adidas', 15, 159.99, 5),
('Gel-Nimbus 23', 'ASICS', 25, 229.99, 4),
('Chuck Taylor All Star Modern', 'Converse', 10, 119.99, 5),
('Zoom Fly SP', 'Nike', 18, 179.99, 4),
('Superstar Slip-On', 'Adidas', 22, 129.99, 5),
('Old Skool BMX', 'Vans', 8, 159.99, 3),
('Air Jordan 4 Retro', 'Nike', 12, 249.99, 5),
('Ultraboost 20', 'Adidas', 25, 209.99, 4),
('Club C Revenge', 'Reebok', 15, 109.99, 5),
('ZX Flux', 'Adidas', 15, 179.99, 4),
('EQT Support', 'Adidas', 20, 199.99, 5);


/*Populate order_line table */
INSERT INTO `order_line` (`ORDER_ID`, `ITEM_ID`, `QUANTITY`) VALUES
(1, 10, 2),
(2, 3, 1),
(2, 24, 1),
(3, 15, 1),
(4, 7, 2),
(5, 9, 2),
(6, 11, 1),
(7, 13, 1),
(7, 4, 1),
(8, 15, 2),
(9, 21, 1),
(9, 18, 1),
(10, 12, 1),
(11, 21, 2),
(12, 2, 2),
(13, 25, 1),
(13, 6, 2),
(14, 17, 1),
(15, 9, 2),
(16, 32, 1),
(17, 13, 1),
(18, 15, 1),
(18, 6, 1),
(19, 17, 2),
(20, 19, 1),
(21, 2, 2),
(22, 24, 1),
(23, 16, 2),
(24, 8, 1),
(24, 14, 1);


/*Populate order_supplier table */
INSERT INTO `order_supplier` (`DATE`, `SUPPLIER_ID`, `ITEM_ID`, `SUPPLY_QUANTITY`, `SUPPLY_PRICE`) VALUES
('2022-02-10', 2, 2, 3, 310.85),
('2022-04-20', 4, 4, 4, 420.00),
('2022-05-25', 5, 5, 2, 304.99),
('2022-06-30', 6, 10, 3, 580.00),
('2022-08-10', 8, 8, 2, 320.40),
('2022-09-15', 9, 9, 2, 250.66),
('2022-10-20', 10, 11, 1, 142.00),
('2022-11-25', 11, 1, 3, 321.00),
('2022-12-30', 12, 12, 1, 102.20),
('2023-01-15', 1, 13, 4, 524.00),
('2023-02-20', 2, 14, 2, 316.55),
('2023-03-25', 3, 15, 3, 304.00),
('2023-04-30', 4, 6, 1, 192.50),
('2023-05-05', 5, 7, 3, 302.50),
('2023-06-10', 6, 21, 2, 148.99),
('2023-07-15', 7, 19, 3, 120.23),
('2023-08-20', 8, 20, 2, 224.50),
('2023-11-12', 19, 22, 3, 540.50);


/*Populate delivery table */
INSERT INTO `delivery` (`ORDER_ID`, `ORDER_SUP_ID`, `CARRIER_ID`) VALUES
(1, NULL, 10),
(2, NULL, 2),
(3, NULL, 3),
(4, NULL, 1),
(5, NULL, 4),
(NULL, 1, 3),
(NULL, 2, 1),
(6, NULL, 2),
(7, NULL, 5),
(8, NULL, 10),
(9, NULL, 2),
(NULL, 3, 3),
(10, NULL, 6),
(11, NULL, 8),
(NULL, 4, 3),
(12, NULL, 1),
(13, NULL, 9),
(14, NULL, 1),
(15, NULL, 2),
(16, NULL, 8),
(17, NULL, 1),
(NULL, 5, 2),
(NULL, 6, 5),
(18, NULL, 1),
(NULL, 7, 7),
(19, NULL, 3),
(20, NULL, 1),
(21, NULL, 2),
(NULL, 8, 8),
(NULL, 9, 1),
(NULL, 10, 2),
(22, NULL, 9),
(23, NULL, 1),
(NULL, 11, 2),
(NULL, 12, 4),
(NULL, 13, 1),
(NULL, 14, 2),
(24, NULL, 3),
(NULL, 15, 6),
(NULL, 16, 3),
(NULL, 17, 1),
(NULL, 18, 2);




--------------------------------------------------------
-- Invoice
--------------------------------------------------------
-- Create view for simplified invoice
CREATE OR REPLACE VIEW invoice_simplified AS
SELECT o.order_id AS 'Order_ID', CONCAT(i.model, ', ', i.brand) AS Product,i.price AS 'Unit price',
	ol.quantity AS Quantity, (i.price * QUANTITY) AS Price
FROM item i
JOIN order_line ol ON i.item_id = ol.item_id
JOIN `order` o ON ol.order_id = o.order_id
JOIN customer c ON o.customer_id = c.customer_id
WHERE o.order_id = 2;

-- Create view for complete invoice (with details)
CREATE OR REPLACE VIEW invoice_complete AS
SELECT o.order_id AS 'Invoice Number',
	   o.date AS 'Date of Issue', 
       CONCAT(c.first_name, ' ', c.last_name) AS 'Client Name',
       c.street_address AS 'Street address', 
       CONCAT(c.city, ', ', c.country_id) AS ' City, Country',
       c.postal_code AS 'ZIP Code', 
       "Shoes your weapon" AS 'Company Name',
       "916517179" AS 'Phone Number', 
       "shoesyourwaepon@shopify.com" AS 'Email',
       '23%' AS '(TAX RATE)',
       ROUND((o.total_price - (o.total_price / 1.23)), 2) AS TAX,
       ROUND((o.total_price / (1 - (p.discount)/100)),2) AS SUBTOTAL, 
       p.promo_code AS 'Promotion Code', 
       p.discount AS 'Promotion Percentage Off', 
       o.total_price  AS TOTAL
FROM customer c
JOIN `order` o ON c.customer_id = o.customer_id 
JOIN  order_line ol ON o.order_id = ol.order_id
JOIN  item i ON ol.item_id = i.item_id
JOIN  invoice_simplified inv ON o.order_id = inv.order_id
LEFT JOIN promo p ON o.promo_id = p.promo_id; 


select *
from invoice_simplified
;
select distinct *
from invoice_complete;


--------------------------------------------------------
-- Triggers
--------------------------------------------------------

-- trigger 1
DELIMITER //
CREATE TRIGGER update_stock_after_order_supplier
AFTER INSERT ON `order_supplier`
FOR EACH ROW
BEGIN
    DECLARE ordered_quantity INT;
    
    -- Get the quantity ordered
    SELECT `SUPPLY_QUANTITY` INTO ordered_quantity   
    FROM `order_supplier`
    WHERE `ORDER_SUP_ID` = NEW.`ORDER_SUP_ID`;

    -- Update the stock of the item
    UPDATE `item`
    SET `STOCK` = `STOCK` + ordered_quantity
    WHERE `ITEM_ID` = NEW.`ITEM_ID`;
END;
//
DELIMITER ;


-- trigger 2
DELIMITER //
CREATE TRIGGER update_stock_after_order_line
AFTER INSERT ON `order_line`
FOR EACH ROW
BEGIN
    DECLARE ordered_quantity INT;
    
    -- Get the quantity ordered
    SELECT `QUANTITY` INTO ordered_quantity
    FROM `order_line`
    WHERE `ORDER_LINE_ID` = NEW.`ORDER_LINE_ID`;

    -- Update the stock of the item
    UPDATE `item`
    SET `STOCK` = `STOCK` - ordered_quantity
    WHERE `ITEM_ID` = NEW.`ITEM_ID`;
END;
//
DELIMITER ;


-- trigger 3
-- 1st part, because we don't have number_items
DELIMITER //
CREATE TRIGGER after_order_insert
AFTER INSERT ON `order`
FOR EACH ROW
BEGIN

	DECLARE COUNTRY_ID VARCHAR(2);

    -- Get the Country_ID from the customer table
    SELECT CUSTOMER.COUNTRY_ID INTO COUNTRY_ID
    FROM `customer`
    WHERE CUSTOMER.CUSTOMER_ID = NEW.CUSTOMER_ID;

    INSERT INTO `log` (Order_ID, Country_ID, Number_items, Amount)
    VALUES (NEW.ORDER_ID, COUNTRY_ID, NULL, NEW.TOTAL_PRICE);
END;
//
DELIMITER ;
-- 2nd part, update number_items based on order_line
DELIMITER //
CREATE TRIGGER after_order_line_insert
AFTER INSERT ON `order_line`
FOR EACH ROW
BEGIN
    UPDATE `log`
    SET Number_items = (SELECT SUM(QUANTITY) FROM `order_line` WHERE ORDER_ID = NEW.ORDER_ID)
    WHERE Order_ID = NEW.ORDER_ID;
END;
//
DELIMITER ;

