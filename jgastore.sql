-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Versión del servidor:         5.5.24-log - MySQL Community Server (GPL)
-- SO del servidor:              Win64
-- HeidiSQL Versión:             9.4.0.5125
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;


-- Volcando estructura de base de datos para jgastore
CREATE DATABASE IF NOT EXISTS `jgastore` /*!40100 DEFAULT CHARACTER SET latin1 */;
USE `jgastore`;

-- Volcando estructura para tabla jgastore.categoria
CREATE TABLE IF NOT EXISTS `categoria` (
  `idCategoria` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(50) NOT NULL,
  PRIMARY KEY (`idCategoria`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Volcando datos para la tabla jgastore.categoria: ~0 rows (aproximadamente)
/*!40000 ALTER TABLE `categoria` DISABLE KEYS */;
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
/*!40000 ALTER TABLE `cliente` DISABLE KEYS */;
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
/*!40000 ALTER TABLE `enviopedidoproducto` DISABLE KEYS */;
/*!40000 ALTER TABLE `enviopedidoproducto` ENABLE KEYS */;

-- Volcando estructura para tabla jgastore.metodopago
CREATE TABLE IF NOT EXISTS `metodopago` (
  `idMetodoPago` int(11) NOT NULL,
  `nombre` varchar(50) NOT NULL,
  PRIMARY KEY (`idMetodoPago`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Volcando datos para la tabla jgastore.metodopago: ~0 rows (aproximadamente)
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
  CONSTRAINT `idMetodoPago` FOREIGN KEY (`idMetodoPago`) REFERENCES `metodopago` (`idMetodoPago`),
  CONSTRAINT `idCliente2` FOREIGN KEY (`idCliente`) REFERENCES `cliente` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Volcando datos para la tabla jgastore.metodopagocliente: ~0 rows (aproximadamente)
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
  CONSTRAINT `idProducto` FOREIGN KEY (`idProducto`) REFERENCES `producto` (`idProducto`),
  CONSTRAINT `idPedido` FOREIGN KEY (`idPedido`) REFERENCES `pedido` (`idPedido`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Volcando datos para la tabla jgastore.pedidoproducto: ~0 rows (aproximadamente)
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
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Volcando datos para la tabla jgastore.producto: ~0 rows (aproximadamente)
/*!40000 ALTER TABLE `producto` DISABLE KEYS */;
/*!40000 ALTER TABLE `producto` ENABLE KEYS */;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
