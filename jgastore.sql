-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Versión del servidor:         5.7.15-log - MySQL Community Server (GPL)
-- SO del servidor:              Win64
-- HeidiSQL Versión:             9.4.0.5125
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;


-- Volcando estructura de base de datos para jgastore
CREATE DATABASE IF NOT EXISTS `jgastore` /*!40100 DEFAULT CHARACTER SET utf8 */;
USE `jgastore`;

-- Volcando estructura para tabla jgastore.categoria
CREATE TABLE IF NOT EXISTS `categoria` (
  `idCategoria` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(50) NOT NULL,
  PRIMARY KEY (`idCategoria`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;

-- Volcando datos para la tabla jgastore.categoria: ~0 rows (aproximadamente)
DELETE FROM `categoria`;
/*!40000 ALTER TABLE `categoria` DISABLE KEYS */;
INSERT INTO `categoria` (`idCategoria`, `nombre`) VALUES
	(1, 'Celulares');
/*!40000 ALTER TABLE `categoria` ENABLE KEYS */;

-- Volcando estructura para tabla jgastore.cliente
CREATE TABLE IF NOT EXISTS `cliente` (
  `email` varchar(64) NOT NULL,
  `nombre` varchar(50) DEFAULT NULL,
  `apellido` varchar(50) DEFAULT NULL,
  `username` varchar(64) NOT NULL,
  `password` varchar(64) NOT NULL,
  `fotoPerfil` varchar(50) DEFAULT NULL,
  `fechaNacimiento` date DEFAULT NULL,
  `genero` char(50) DEFAULT NULL,
  `telefono` varchar(50) DEFAULT NULL,
  `ciudad` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Volcando datos para la tabla jgastore.cliente: ~0 rows (aproximadamente)
DELETE FROM `cliente`;
/*!40000 ALTER TABLE `cliente` DISABLE KEYS */;
INSERT INTO `cliente` (`email`, `nombre`, `apellido`, `username`, `password`, `fotoPerfil`, `fechaNacimiento`, `genero`, `telefono`, `ciudad`) VALUES
	('36965c9b2fbc2aea90eca5dd264259785d4a0702e58ae43fecfbd1a2f2338ca6', 'Alejandro', NULL, 'alejandrombc', 'ef797c8118f02dfb649607dd5d3f8c7623048c9c063d532cc95c5ed7a898a64f', NULL, NULL, 'M', NULL, 'Caracas'),
	('52901674ddcd9a1b84ee158adee0cfafb3ec9ee3e04114a8edbf5f49f813d25f', 'Gregorio', NULL, 'gregorioelmio', 'ad07879aea820dd3dc8a014e387f3e5046d80dfb14506d3c6ed002321a20b860', NULL, NULL, 'M', NULL, 'Caracas'),
	('b42372cccd0a5bbd116a8062659ad618e2e7736c6e33991b9a82b52123dcff8c', 'Jesus', NULL, 'jesusgrafica', '92aae27de4a8f2da851ac347e790c45c209cb24670cf65196aa4000742045212', NULL, NULL, 'M', NULL, 'Caracas');
/*!40000 ALTER TABLE `cliente` ENABLE KEYS */;

-- Volcando estructura para tabla jgastore.envio
CREATE TABLE IF NOT EXISTS `envio` (
  `idEnvio` int(11) NOT NULL AUTO_INCREMENT,
  `direccion1` varchar(50) NOT NULL,
  `direccion2` varchar(50) DEFAULT NULL,
  `estado` varchar(50) NOT NULL,
  `ciudad` varchar(50) NOT NULL,
  `codigoPostal` int(11) NOT NULL,
  `idCliente` varchar(64) NOT NULL,
  PRIMARY KEY (`idEnvio`),
  KEY `idCliente3` (`idCliente`),
  CONSTRAINT `idCliente3` FOREIGN KEY (`idCliente`) REFERENCES `cliente` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Volcando datos para la tabla jgastore.envio: ~0 rows (aproximadamente)
DELETE FROM `envio`;
/*!40000 ALTER TABLE `envio` DISABLE KEYS */;
/*!40000 ALTER TABLE `envio` ENABLE KEYS */;

-- Volcando estructura para tabla jgastore.enviopedidoproducto
CREATE TABLE IF NOT EXISTS `enviopedidoproducto` (
  `idEnvio` int(11) NOT NULL,
  `idPedidoProducto` int(11) NOT NULL,
  PRIMARY KEY (`idEnvio`,`idPedidoProducto`),
  KEY `idPedidoProducto` (`idPedidoProducto`),
  CONSTRAINT `idEnvio` FOREIGN KEY (`idEnvio`) REFERENCES `envio` (`idEnvio`),
  CONSTRAINT `idPedidoProducto` FOREIGN KEY (`idPedidoProducto`) REFERENCES `pedidoproducto` (`idPedidoProducto`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Volcando datos para la tabla jgastore.enviopedidoproducto: ~0 rows (aproximadamente)
DELETE FROM `enviopedidoproducto`;
/*!40000 ALTER TABLE `enviopedidoproducto` DISABLE KEYS */;
/*!40000 ALTER TABLE `enviopedidoproducto` ENABLE KEYS */;

-- Volcando estructura para tabla jgastore.metodopago
CREATE TABLE IF NOT EXISTS `metodopago` (
  `idMetodoPago` int(11) NOT NULL,
  `nombre` varchar(50) NOT NULL,
  PRIMARY KEY (`idMetodoPago`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Volcando datos para la tabla jgastore.metodopago: ~0 rows (aproximadamente)
DELETE FROM `metodopago`;
/*!40000 ALTER TABLE `metodopago` DISABLE KEYS */;
/*!40000 ALTER TABLE `metodopago` ENABLE KEYS */;

-- Volcando estructura para tabla jgastore.metodopagocliente
CREATE TABLE IF NOT EXISTS `metodopagocliente` (
  `idMetodoPagoCliente` int(11) NOT NULL AUTO_INCREMENT,
  `numeroTarjetaCredito` int(16) DEFAULT NULL,
  `idMetodoPago` int(11) NOT NULL,
  `idCliente` varchar(64) DEFAULT NULL,
  PRIMARY KEY (`idMetodoPagoCliente`),
  KEY `idCliente2` (`idCliente`),
  KEY `idMetodoPago` (`idMetodoPago`),
  CONSTRAINT `idCliente2` FOREIGN KEY (`idCliente`) REFERENCES `cliente` (`email`),
  CONSTRAINT `idMetodoPago` FOREIGN KEY (`idMetodoPago`) REFERENCES `metodopago` (`idMetodoPago`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Volcando datos para la tabla jgastore.metodopagocliente: ~0 rows (aproximadamente)
DELETE FROM `metodopagocliente`;
/*!40000 ALTER TABLE `metodopagocliente` DISABLE KEYS */;
/*!40000 ALTER TABLE `metodopagocliente` ENABLE KEYS */;

-- Volcando estructura para tabla jgastore.pedido
CREATE TABLE IF NOT EXISTS `pedido` (
  `idPedido` int(11) NOT NULL AUTO_INCREMENT,
  `fechaPedido` date NOT NULL,
  `idCliente` varchar(64) NOT NULL,
  PRIMARY KEY (`idPedido`),
  KEY `idCliente` (`idCliente`),
  CONSTRAINT `idCliente` FOREIGN KEY (`idCliente`) REFERENCES `cliente` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Volcando datos para la tabla jgastore.pedido: ~0 rows (aproximadamente)
DELETE FROM `pedido`;
/*!40000 ALTER TABLE `pedido` DISABLE KEYS */;
/*!40000 ALTER TABLE `pedido` ENABLE KEYS */;

-- Volcando estructura para tabla jgastore.pedidoproducto
CREATE TABLE IF NOT EXISTS `pedidoproducto` (
  `idPedidoProducto` int(11) NOT NULL AUTO_INCREMENT,
  `cantidad` int(11) NOT NULL DEFAULT '1',
  `precio` double NOT NULL,
  `idProducto` int(11) DEFAULT NULL,
  `idPedido` int(11) DEFAULT NULL,
  PRIMARY KEY (`idPedidoProducto`),
  KEY `idProducto` (`idProducto`),
  KEY `idPedido` (`idPedido`),
  CONSTRAINT `idPedido` FOREIGN KEY (`idPedido`) REFERENCES `pedido` (`idPedido`),
  CONSTRAINT `idProducto` FOREIGN KEY (`idProducto`) REFERENCES `producto` (`idProducto`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Volcando datos para la tabla jgastore.pedidoproducto: ~0 rows (aproximadamente)
DELETE FROM `pedidoproducto`;
/*!40000 ALTER TABLE `pedidoproducto` DISABLE KEYS */;
/*!40000 ALTER TABLE `pedidoproducto` ENABLE KEYS */;

-- Volcando estructura para tabla jgastore.producto
CREATE TABLE IF NOT EXISTS `producto` (
  `idProducto` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(50) DEFAULT NULL,
  `descripcion` varchar(50) DEFAULT NULL,
  `foto` varchar(50) DEFAULT NULL,
  `precio` double DEFAULT NULL,
  `cantVendida` int(11) DEFAULT NULL,
  `idCategoria` int(11) DEFAULT NULL,
  PRIMARY KEY (`idProducto`),
  KEY `idCategoria` (`idCategoria`),
  CONSTRAINT `idCategoria` FOREIGN KEY (`idCategoria`) REFERENCES `categoria` (`idCategoria`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;

-- Volcando datos para la tabla jgastore.producto: ~0 rows (aproximadamente)
DELETE FROM `producto`;
/*!40000 ALTER TABLE `producto` DISABLE KEYS */;
INSERT INTO `producto` (`idProducto`, `nombre`, `descripcion`, `foto`, `precio`, `cantVendida`, `idCategoria`) VALUES
	(1, 'iPhone 7', 'Nuevo iPhone de Apple', NULL, 1000000, 0, 1),
	(2, 'Samsung Note', 'Cuidado, explota a veces', NULL, 750000, 2, 1),
	(3, 'Yezz 314a', 'Pote para el metro', NULL, 20, 1, 1),
	(4, 'Nokia 3310', 'Indestructible', NULL, 500, 6, 1),
	(5, 'Blu Gold', 'Para los que quieren un smartphone', NULL, 10000, 20, 1);
/*!40000 ALTER TABLE `producto` ENABLE KEYS */;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
