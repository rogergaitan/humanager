-- MySQL dump 10.13  Distrib 5.5.46, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: humanager_development
-- ------------------------------------------------------
-- Server version	5.5.46-0ubuntu0.14.04.2

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `addresses`
--

DROP TABLE IF EXISTS `addresses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `addresses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `entity_id` int(11) DEFAULT NULL,
  `province_id` int(11) DEFAULT NULL,
  `canton_id` int(11) DEFAULT NULL,
  `district_id` int(11) DEFAULT NULL,
  `address` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_addresses_on_entity_id` (`entity_id`),
  KEY `index_addresses_on_province_id` (`province_id`),
  KEY `index_addresses_on_canton_id` (`canton_id`),
  KEY `index_addresses_on_district_id` (`district_id`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `addresses`
--

LOCK TABLES `addresses` WRITE;
/*!40000 ALTER TABLE `addresses` DISABLE KEYS */;
INSERT INTO `addresses` VALUES (1,1,NULL,NULL,NULL,'','2015-11-24 22:17:55','2015-11-24 22:45:27'),(2,2,NULL,NULL,NULL,'','2015-11-24 22:17:55','2015-11-24 22:47:13'),(3,3,NULL,NULL,NULL,'','2015-11-24 22:17:55','2015-11-24 22:48:15'),(4,4,NULL,NULL,NULL,'','2015-11-24 22:17:55','2015-11-24 22:48:32'),(5,5,NULL,NULL,NULL,'','2015-11-24 22:17:55','2015-11-24 22:48:51'),(6,6,NULL,NULL,NULL,'','2015-11-24 22:17:55','2015-11-24 22:49:07'),(7,7,NULL,NULL,NULL,'','2015-11-24 22:17:55','2015-11-24 22:49:22'),(8,8,NULL,NULL,NULL,'','2015-11-24 22:17:55','2015-11-24 22:50:02'),(9,9,NULL,NULL,NULL,'','2015-11-24 22:17:55','2015-11-24 22:51:00'),(10,10,NULL,NULL,NULL,'','2015-11-24 22:17:55','2015-11-24 22:51:17'),(11,11,NULL,NULL,NULL,'','2015-11-24 22:17:55','2015-11-24 22:51:31'),(12,12,NULL,NULL,NULL,'','2015-11-24 22:17:55','2015-11-24 22:51:43'),(13,13,NULL,NULL,NULL,'','2015-11-24 22:17:55','2015-11-24 22:51:55'),(14,14,NULL,NULL,NULL,'','2015-11-24 22:17:55','2015-11-24 22:52:08'),(15,15,NULL,NULL,NULL,'','2015-11-24 22:17:55','2015-11-24 22:52:20'),(16,16,NULL,NULL,NULL,NULL,'2015-11-24 22:17:55','2015-11-24 22:17:55'),(17,17,NULL,NULL,NULL,NULL,'2015-11-24 22:17:55','2015-11-24 22:17:55'),(18,18,NULL,NULL,NULL,NULL,'2015-11-24 22:17:56','2015-11-24 22:17:56'),(19,19,NULL,NULL,NULL,NULL,'2015-11-24 22:17:56','2015-11-24 22:17:56');
/*!40000 ALTER TABLE `addresses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `bank_accounts`
--

DROP TABLE IF EXISTS `bank_accounts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `bank_accounts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `entity_id` int(11) DEFAULT NULL,
  `bank` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `bank_account` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `sinpe` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `account_title` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_bank_accounts_on_entity_id` (`entity_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bank_accounts`
--

LOCK TABLES `bank_accounts` WRITE;
/*!40000 ALTER TABLE `bank_accounts` DISABLE KEYS */;
/*!40000 ALTER TABLE `bank_accounts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cantons`
--

DROP TABLE IF EXISTS `cantons`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cantons` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `province_id` int(11) DEFAULT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_cantons_on_province_id` (`province_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cantons`
--

LOCK TABLES `cantons` WRITE;
/*!40000 ALTER TABLE `cantons` DISABLE KEYS */;
/*!40000 ALTER TABLE `cantons` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `categories`
--

DROP TABLE IF EXISTS `categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `categories` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `code` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `description` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `categories`
--

LOCK TABLES `categories` WRITE;
/*!40000 ALTER TABLE `categories` DISABLE KEYS */;
/*!40000 ALTER TABLE `categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `companies`
--

DROP TABLE IF EXISTS `companies`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `companies` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `code` int(11) DEFAULT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `label_reports_1` text COLLATE utf8_unicode_ci,
  `label_reports_2` text COLLATE utf8_unicode_ci,
  `label_reports_3` text COLLATE utf8_unicode_ci,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `companies`
--

LOCK TABLES `companies` WRITE;
/*!40000 ALTER TABLE `companies` DISABLE KEYS */;
INSERT INTO `companies` VALUES (1,1,'Finca Santa Rita',NULL,NULL,NULL,'2015-11-24 22:13:48','2015-11-24 22:13:48');
/*!40000 ALTER TABLE `companies` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `contacts`
--

DROP TABLE IF EXISTS `contacts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `contacts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `entity_id` int(11) DEFAULT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `occupation` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `phone` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `email` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `skype` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_contacts_on_entity_id` (`entity_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `contacts`
--

LOCK TABLES `contacts` WRITE;
/*!40000 ALTER TABLE `contacts` DISABLE KEYS */;
/*!40000 ALTER TABLE `contacts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `costs_centers`
--

DROP TABLE IF EXISTS `costs_centers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `costs_centers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `company_id` int(11) DEFAULT NULL,
  `icost_center` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `name_cc` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `icc_father` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `iactivity` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_costs_centers_on_company_id` (`company_id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `costs_centers`
--

LOCK TABLES `costs_centers` WRITE;
/*!40000 ALTER TABLE `costs_centers` DISABLE KEYS */;
INSERT INTO `costs_centers` VALUES (1,1,'','Finca Santa Rita','','','2015-11-24 22:18:32','2015-11-24 22:18:32'),(2,1,'1','Finca Sta Rita','','0','2015-11-24 22:18:32','2015-11-24 22:18:32'),(3,1,'101','Dania 1','1','1','2015-11-24 22:18:32','2015-11-24 22:18:32'),(4,1,'10101','Area en Desarrollo','101','1','2015-11-24 22:18:32','2015-11-24 22:18:32'),(5,1,'10102','Area en Produccion','101','1','2015-11-24 22:18:32','2015-11-24 22:18:32'),(6,1,'102','Dania 2','1','1','2015-11-24 22:18:32','2015-11-24 22:18:32'),(7,1,'10201','Area en Desarrollo','102','1','2015-11-24 22:18:32','2015-11-24 22:18:32'),(8,1,'10202','Area en Produccion','102','1','2015-11-24 22:18:32','2015-11-24 22:18:32'),(9,1,'103','El Bosque','1','1','2015-11-24 22:18:32','2015-11-24 22:18:32'),(10,1,'10301','Area en Desarrollo','103','1','2015-11-24 22:18:32','2015-11-24 22:18:32'),(11,1,'10302','Area en Produccion','103','1','2015-11-24 22:18:32','2015-11-24 22:18:32');
/*!40000 ALTER TABLE `costs_centers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `customer_profiles`
--

DROP TABLE IF EXISTS `customer_profiles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `customer_profiles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customer_profiles`
--

LOCK TABLES `customer_profiles` WRITE;
/*!40000 ALTER TABLE `customer_profiles` DISABLE KEYS */;
/*!40000 ALTER TABLE `customer_profiles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `customers`
--

DROP TABLE IF EXISTS `customers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `customers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `customer_profile_id` int(11) DEFAULT NULL,
  `entity_id` int(11) DEFAULT NULL,
  `asigned_seller` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_customers_on_customer_profile_id` (`customer_profile_id`),
  KEY `index_customers_on_entity_id` (`entity_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customers`
--

LOCK TABLES `customers` WRITE;
/*!40000 ALTER TABLE `customers` DISABLE KEYS */;
/*!40000 ALTER TABLE `customers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `deduction_employees`
--

DROP TABLE IF EXISTS `deduction_employees`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `deduction_employees` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `deduction_id` int(11) DEFAULT NULL,
  `employee_id` int(11) DEFAULT NULL,
  `completed` tinyint(1) DEFAULT '0',
  `boolean` tinyint(1) DEFAULT '0',
  `calculation` decimal(10,2) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_deduction_employees_on_deduction_id` (`deduction_id`),
  KEY `index_deduction_employees_on_employee_id` (`employee_id`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `deduction_employees`
--

LOCK TABLES `deduction_employees` WRITE;
/*!40000 ALTER TABLE `deduction_employees` DISABLE KEYS */;
INSERT INTO `deduction_employees` VALUES (1,1,15,0,0,NULL,'2015-11-24 22:36:52','2015-11-24 22:36:52'),(2,1,14,0,0,NULL,'2015-11-24 22:36:52','2015-11-24 22:36:52'),(3,1,6,0,0,NULL,'2015-11-24 22:36:52','2015-11-24 22:36:52'),(4,1,16,0,0,NULL,'2015-11-24 22:36:52','2015-11-24 22:36:52'),(5,1,8,0,0,NULL,'2015-11-24 22:36:52','2015-11-24 22:36:52'),(6,1,17,0,0,NULL,'2015-11-24 22:36:52','2015-11-24 22:36:52'),(7,1,12,0,0,NULL,'2015-11-24 22:36:52','2015-11-24 22:36:52'),(8,1,18,0,0,NULL,'2015-11-24 22:36:52','2015-11-24 22:36:52'),(9,1,4,0,0,NULL,'2015-11-24 22:36:52','2015-11-24 22:36:52'),(10,1,5,0,0,NULL,'2015-11-24 22:36:52','2015-11-24 22:36:52'),(11,1,2,0,0,NULL,'2015-11-24 22:36:52','2015-11-24 22:36:52'),(12,1,13,0,0,NULL,'2015-11-24 22:36:52','2015-11-24 22:36:52'),(13,1,19,0,0,NULL,'2015-11-24 22:36:52','2015-11-24 22:36:52'),(14,1,7,0,0,NULL,'2015-11-24 22:36:52','2015-11-24 22:36:52'),(15,1,11,0,0,NULL,'2015-11-24 22:36:52','2015-11-24 22:36:52'),(16,1,10,0,0,NULL,'2015-11-24 22:36:52','2015-11-24 22:36:52'),(17,1,3,0,0,NULL,'2015-11-24 22:36:52','2015-11-24 22:36:52'),(18,1,9,0,0,NULL,'2015-11-24 22:36:52','2015-11-24 22:36:52'),(19,1,1,0,0,NULL,'2015-11-24 22:36:52','2015-11-24 22:36:52');
/*!40000 ALTER TABLE `deduction_employees` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `deduction_payments`
--

DROP TABLE IF EXISTS `deduction_payments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `deduction_payments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `deduction_employee_id` int(11) DEFAULT NULL,
  `payroll_id` int(11) DEFAULT NULL,
  `payment_date` date DEFAULT NULL,
  `previous_balance` decimal(10,2) DEFAULT NULL,
  `payment` decimal(10,2) DEFAULT NULL,
  `current_balance` decimal(10,2) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_deduction_payments_on_deduction_employee_id` (`deduction_employee_id`),
  KEY `index_deduction_payments_on_payroll_id` (`payroll_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `deduction_payments`
--

LOCK TABLES `deduction_payments` WRITE;
/*!40000 ALTER TABLE `deduction_payments` DISABLE KEYS */;
/*!40000 ALTER TABLE `deduction_payments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `deduction_payrolls`
--

DROP TABLE IF EXISTS `deduction_payrolls`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `deduction_payrolls` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `deduction_id` int(11) DEFAULT NULL,
  `payroll_id` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_deduction_payrolls_on_deduction_id` (`deduction_id`),
  KEY `index_deduction_payrolls_on_payroll_id` (`payroll_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `deduction_payrolls`
--

LOCK TABLES `deduction_payrolls` WRITE;
/*!40000 ALTER TABLE `deduction_payrolls` DISABLE KEYS */;
/*!40000 ALTER TABLE `deduction_payrolls` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `deductions`
--

DROP TABLE IF EXISTS `deductions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `deductions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `company_id` int(11) DEFAULT NULL,
  `description` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `deduction_type` enum('constant','unique','amount_to_exhaust') COLLATE utf8_unicode_ci DEFAULT NULL,
  `amount_exhaust` decimal(10,2) DEFAULT NULL,
  `decimal` decimal(10,2) DEFAULT NULL,
  `calculation_type` enum('percentage','fixed') COLLATE utf8_unicode_ci DEFAULT NULL,
  `ledger_account_id` int(11) DEFAULT NULL,
  `state` enum('completed','active') COLLATE utf8_unicode_ci DEFAULT 'active',
  `beneficiary_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `is_beneficiary` tinyint(1) DEFAULT '1',
  `individual` tinyint(1) DEFAULT '0',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_deductions_on_company_id` (`company_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `deductions`
--

LOCK TABLES `deductions` WRITE;
/*!40000 ALTER TABLE `deductions` DISABLE KEYS */;
INSERT INTO `deductions` VALUES (1,1,'CCSS Empleado','constant',NULL,NULL,'percentage',115,'active','',1,0,'2015-11-24 22:36:52','2015-11-24 22:36:52');
/*!40000 ALTER TABLE `deductions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `departments`
--

DROP TABLE IF EXISTS `departments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `departments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `employee_id` int(11) DEFAULT NULL,
  `costs_center_id` int(11) DEFAULT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_departments_on_employee_id` (`employee_id`),
  KEY `index_departments_on_costs_center_id` (`costs_center_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `departments`
--

LOCK TABLES `departments` WRITE;
/*!40000 ALTER TABLE `departments` DISABLE KEYS */;
INSERT INTO `departments` VALUES (1,1,10,'Desarrollo','2015-11-24 22:38:46','2015-11-24 22:38:46'),(2,2,8,'Produción','2015-11-24 22:44:34','2015-11-24 22:44:34');
/*!40000 ALTER TABLE `departments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `detail_personnel_actions`
--

DROP TABLE IF EXISTS `detail_personnel_actions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `detail_personnel_actions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type_of_personnel_action_id` int(11) DEFAULT NULL,
  `fields_personnel_action_id` int(11) DEFAULT NULL,
  `value` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_detail_personnel_actions_on_type_of_personnel_action_id` (`type_of_personnel_action_id`),
  KEY `index_detail_personnel_actions_on_fields_personnel_action_id` (`fields_personnel_action_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `detail_personnel_actions`
--

LOCK TABLES `detail_personnel_actions` WRITE;
/*!40000 ALTER TABLE `detail_personnel_actions` DISABLE KEYS */;
/*!40000 ALTER TABLE `detail_personnel_actions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `districts`
--

DROP TABLE IF EXISTS `districts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `districts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `canton_id` int(11) DEFAULT NULL,
  `province_id` int(11) DEFAULT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_districts_on_canton_id` (`canton_id`),
  KEY `index_districts_on_province_id` (`province_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `districts`
--

LOCK TABLES `districts` WRITE;
/*!40000 ALTER TABLE `districts` DISABLE KEYS */;
/*!40000 ALTER TABLE `districts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `emails`
--

DROP TABLE IF EXISTS `emails`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `emails` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `entity_id` int(11) DEFAULT NULL,
  `email` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `typeemail` enum('personal','work') COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_emails_on_entity_id` (`entity_id`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `emails`
--

LOCK TABLES `emails` WRITE;
/*!40000 ALTER TABLE `emails` DISABLE KEYS */;
INSERT INTO `emails` VALUES (1,1,'','personal','2015-11-24 22:17:55','2015-11-24 22:45:27'),(2,2,'','personal','2015-11-24 22:17:55','2015-11-24 22:47:13'),(3,3,'','personal','2015-11-24 22:17:55','2015-11-24 22:48:15'),(4,4,'','personal','2015-11-24 22:17:55','2015-11-24 22:48:32'),(5,5,'','personal','2015-11-24 22:17:55','2015-11-24 22:48:51'),(6,6,'','personal','2015-11-24 22:17:55','2015-11-24 22:49:07'),(7,7,'','personal','2015-11-24 22:17:55','2015-11-24 22:49:22'),(8,8,'','personal','2015-11-24 22:17:55','2015-11-24 22:50:02'),(9,9,'','personal','2015-11-24 22:17:55','2015-11-24 22:51:00'),(10,10,'','personal','2015-11-24 22:17:55','2015-11-24 22:51:17'),(11,11,'','personal','2015-11-24 22:17:55','2015-11-24 22:51:31'),(12,12,'','personal','2015-11-24 22:17:55','2015-11-24 22:51:43'),(13,13,'','personal','2015-11-24 22:17:55','2015-11-24 22:51:55'),(14,14,'','personal','2015-11-24 22:17:55','2015-11-24 22:52:08'),(15,15,'','personal','2015-11-24 22:17:55','2015-11-24 22:52:20'),(16,16,NULL,NULL,'2015-11-24 22:17:55','2015-11-24 22:17:55'),(17,17,NULL,NULL,'2015-11-24 22:17:55','2015-11-24 22:17:55'),(18,18,NULL,NULL,'2015-11-24 22:17:56','2015-11-24 22:17:56'),(19,19,NULL,NULL,'2015-11-24 22:17:56','2015-11-24 22:17:56');
/*!40000 ALTER TABLE `emails` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `employee_benefits`
--

DROP TABLE IF EXISTS `employee_benefits`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `employee_benefits` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `work_benefit_id` int(11) DEFAULT NULL,
  `employee_id` int(11) DEFAULT NULL,
  `completed` tinyint(1) DEFAULT '0',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_employee_benefits_on_work_benefit_id` (`work_benefit_id`),
  KEY `index_employee_benefits_on_employee_id` (`employee_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `employee_benefits`
--

LOCK TABLES `employee_benefits` WRITE;
/*!40000 ALTER TABLE `employee_benefits` DISABLE KEYS */;
/*!40000 ALTER TABLE `employee_benefits` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `employees`
--

DROP TABLE IF EXISTS `employees`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `employees` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `entity_id` int(11) DEFAULT NULL,
  `gender` enum('male','female') COLLATE utf8_unicode_ci DEFAULT NULL,
  `birthday` date DEFAULT NULL,
  `marital_status` enum('single','married','divorced','widowed','civil_union','engage') COLLATE utf8_unicode_ci DEFAULT NULL,
  `number_of_dependents` int(11) DEFAULT NULL,
  `spouse` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `join_date` date DEFAULT NULL,
  `social_insurance` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `department_id` int(11) DEFAULT NULL,
  `occupation_id` int(11) DEFAULT NULL,
  `role_id` int(11) DEFAULT NULL,
  `position_id` int(11) DEFAULT NULL,
  `seller` tinyint(1) DEFAULT NULL,
  `payment_method_id` int(11) DEFAULT NULL,
  `payment_frequency_id` int(11) DEFAULT NULL,
  `means_of_payment_id` int(11) DEFAULT NULL,
  `employee_id` int(11) DEFAULT NULL,
  `payment_unit_id` int(11) DEFAULT NULL,
  `payroll_type_id` int(11) DEFAULT NULL,
  `is_superior` tinyint(1) DEFAULT '0',
  `price_defined_work` tinyint(1) DEFAULT NULL,
  `number_employee` int(11) DEFAULT NULL,
  `account_bncr` varchar(12) COLLATE utf8_unicode_ci DEFAULT NULL,
  `wage_payment` decimal(10,2) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_employees_on_number_employee` (`number_employee`),
  KEY `index_employees_on_entity_id` (`entity_id`),
  KEY `index_employees_on_department_id` (`department_id`),
  KEY `index_employees_on_occupation_id` (`occupation_id`),
  KEY `index_employees_on_role_id` (`role_id`),
  KEY `index_employees_on_payment_method_id` (`payment_method_id`),
  KEY `index_employees_on_payment_frequency_id` (`payment_frequency_id`),
  KEY `index_employees_on_means_of_payment_id` (`means_of_payment_id`),
  KEY `index_employees_on_position_id` (`position_id`),
  KEY `index_employees_on_employee_id` (`employee_id`),
  KEY `index_employees_on_payment_unit_id` (`payment_unit_id`),
  KEY `index_employees_on_payroll_type_id` (`payroll_type_id`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `employees`
--

LOCK TABLES `employees` WRITE;
/*!40000 ALTER TABLE `employees` DISABLE KEYS */;
INSERT INTO `employees` VALUES (1,1,'male',NULL,'single',NULL,'',NULL,'',1,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0,NULL,'',NULL,'2015-11-24 22:17:55','2015-11-24 22:48:15'),(2,2,'male',NULL,'single',NULL,'',NULL,'',2,NULL,NULL,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0,NULL,'',NULL,'2015-11-24 22:17:55','2015-11-24 22:51:00'),(3,3,'male',NULL,'single',NULL,'',NULL,'',1,NULL,NULL,3,NULL,NULL,NULL,NULL,1,NULL,NULL,0,0,NULL,'',NULL,'2015-11-24 22:17:55','2015-11-24 22:48:15'),(4,4,'male',NULL,'single',NULL,'',NULL,'',1,NULL,NULL,3,NULL,NULL,NULL,NULL,1,NULL,NULL,0,0,NULL,'',NULL,'2015-11-24 22:17:55','2015-11-24 22:48:32'),(5,5,'male',NULL,'single',NULL,'',NULL,'',1,NULL,NULL,3,NULL,NULL,NULL,NULL,1,NULL,NULL,0,0,NULL,'',NULL,'2015-11-24 22:17:55','2015-11-24 22:48:51'),(6,6,'male',NULL,'single',NULL,'',NULL,'',1,NULL,NULL,3,NULL,NULL,NULL,NULL,1,NULL,NULL,0,0,NULL,'',NULL,'2015-11-24 22:17:55','2015-11-24 22:49:07'),(7,7,'male',NULL,'single',NULL,'',NULL,'',1,NULL,NULL,3,NULL,NULL,NULL,NULL,1,NULL,NULL,0,0,NULL,'',NULL,'2015-11-24 22:17:55','2015-11-24 22:49:22'),(8,8,'male',NULL,'single',NULL,'',NULL,'',1,NULL,NULL,3,NULL,NULL,NULL,NULL,1,NULL,NULL,0,0,NULL,'',NULL,'2015-11-24 22:17:55','2015-11-24 22:50:02'),(9,9,'male',NULL,'single',NULL,'',NULL,'',2,NULL,NULL,4,NULL,NULL,NULL,NULL,2,NULL,NULL,0,0,NULL,'',NULL,'2015-11-24 22:17:55','2015-11-24 22:51:00'),(10,10,'male',NULL,'single',NULL,'',NULL,'',2,NULL,NULL,4,NULL,NULL,NULL,NULL,2,NULL,NULL,0,0,NULL,'',NULL,'2015-11-24 22:17:55','2015-11-24 22:51:17'),(11,11,'male',NULL,'single',NULL,'',NULL,'',2,NULL,NULL,4,NULL,NULL,NULL,NULL,2,NULL,NULL,0,0,NULL,'',NULL,'2015-11-24 22:17:55','2015-11-24 22:51:31'),(12,12,'male',NULL,'single',NULL,'',NULL,'',2,NULL,NULL,4,NULL,NULL,NULL,NULL,2,NULL,NULL,0,0,NULL,'',NULL,'2015-11-24 22:17:55','2015-11-24 22:51:43'),(13,13,'male',NULL,'single',NULL,'',NULL,'',2,NULL,NULL,4,NULL,NULL,NULL,NULL,2,NULL,NULL,0,0,NULL,'',NULL,'2015-11-24 22:17:55','2015-11-24 22:51:55'),(14,14,'male',NULL,'single',NULL,'',NULL,'',2,NULL,NULL,4,NULL,NULL,NULL,NULL,2,NULL,NULL,0,0,NULL,'',NULL,'2015-11-24 22:17:55','2015-11-24 22:52:08'),(15,15,'male',NULL,'single',NULL,'',NULL,'',2,NULL,NULL,4,NULL,NULL,NULL,NULL,2,NULL,NULL,0,0,NULL,'',NULL,'2015-11-24 22:17:55','2015-11-24 22:52:20'),(16,16,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,'2015-11-24 22:17:55','2015-11-24 22:17:55'),(17,17,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,'2015-11-24 22:17:55','2015-11-24 22:17:55'),(18,18,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,'2015-11-24 22:17:56','2015-11-24 22:17:56'),(19,19,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,'2015-11-24 22:17:56','2015-11-24 22:17:56');
/*!40000 ALTER TABLE `employees` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `empmaestccs`
--

DROP TABLE IF EXISTS `empmaestccs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `empmaestccs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `empmaestccs`
--

LOCK TABLES `empmaestccs` WRITE;
/*!40000 ALTER TABLE `empmaestccs` DISABLE KEYS */;
/*!40000 ALTER TABLE `empmaestccs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `entities`
--

DROP TABLE IF EXISTS `entities`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `entities` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `surname` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `entityid` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `typeid` enum('national_id','residence_id','business_id','passport','other') COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `entities`
--

LOCK TABLES `entities` WRITE;
/*!40000 ALTER TABLE `entities` DISABLE KEYS */;
INSERT INTO `entities` VALUES (1,'Bismar','Alaniz','2','national_id','2015-11-24 22:17:55','2015-11-24 22:45:27'),(2,'Martha','Granado','3','national_id','2015-11-24 22:17:55','2015-11-24 22:47:13'),(3,'Fausto','Brenes','4','national_id','2015-11-24 22:17:55','2015-11-24 22:48:15'),(4,'Santos','Laguna','5','national_id','2015-11-24 22:17:55','2015-11-24 22:48:32'),(5,'Byron','Lacayo','6','national_id','2015-11-24 22:17:55','2015-11-24 22:48:51'),(6,'Bayardo','Rizo','7','national_id','2015-11-24 22:17:55','2015-11-24 22:49:07'),(7,'Paulino','Chavarria','8','national_id','2015-11-24 22:17:55','2015-11-24 22:49:22'),(8,'Erick','Ortiz','9','national_id','2015-11-24 22:17:55','2015-11-24 22:50:02'),(9,'Henry','Arauz','10','national_id','2015-11-24 22:17:55','2015-11-24 22:51:00'),(10,'Aurora','Centeno','11','national_id','2015-11-24 22:17:55','2015-11-24 22:51:17'),(11,'Santos','Centeno','12','national_id','2015-11-24 22:17:55','2015-11-24 22:51:31'),(12,'Erick','Maldonado','13','national_id','2015-11-24 22:17:55','2015-11-24 22:51:43'),(13,'Manuel','Garcia','14','national_id','2015-11-24 22:17:55','2015-11-24 22:51:55'),(14,'Gregorio','Sanchez','15','national_id','2015-11-24 22:17:55','2015-11-24 22:52:08'),(15,'Manuel','Siles','16','national_id','2015-11-24 22:17:55','2015-11-24 22:52:20'),(16,'Gloria','Real','17',NULL,'2015-11-24 22:17:55','2015-11-24 22:17:55'),(17,'Roger','Obando','18',NULL,'2015-11-24 22:17:55','2015-11-24 22:17:55'),(18,'Otoniel','Lanzas','19',NULL,'2015-11-24 22:17:56','2015-11-24 22:17:56'),(19,'Isaac','Diaz','20',NULL,'2015-11-24 22:17:56','2015-11-24 22:17:56');
/*!40000 ALTER TABLE `entities` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fields_personnel_actions`
--

DROP TABLE IF EXISTS `fields_personnel_actions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `fields_personnel_actions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `field_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fields_personnel_actions`
--

LOCK TABLES `fields_personnel_actions` WRITE;
/*!40000 ALTER TABLE `fields_personnel_actions` DISABLE KEYS */;
/*!40000 ALTER TABLE `fields_personnel_actions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ledger_accounts`
--

DROP TABLE IF EXISTS `ledger_accounts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ledger_accounts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `iaccount` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `naccount` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ifather` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=370 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ledger_accounts`
--

LOCK TABLES `ledger_accounts` WRITE;
/*!40000 ALTER TABLE `ledger_accounts` DISABLE KEYS */;
INSERT INTO `ledger_accounts` VALUES (1,'1','ACTIVO',NULL,'2015-11-24 22:18:53','2015-11-24 22:18:53'),(2,'11','Efectivo disponible','1','2015-11-24 22:18:53','2015-11-24 22:18:53'),(3,'1105','Caja','11','2015-11-24 22:18:53','2015-11-24 22:18:53'),(4,'1110','Bancos y Corporaciones.','11','2015-11-24 22:18:53','2015-11-24 22:18:53'),(5,'12','Inversiones','1','2015-11-24 22:18:53','2015-11-24 22:18:53'),(6,'1205','Acciones','12','2015-11-24 22:18:53','2015-11-24 22:18:53'),(7,'1210','Cuotas o partes de interés social','12','2015-11-24 22:18:53','2015-11-24 22:18:53'),(8,'1215','Bonos comerciales','12','2015-11-24 22:18:53','2015-11-24 22:18:53'),(9,'1220','Cédulas','12','2015-11-24 22:18:53','2015-11-24 22:18:53'),(10,'1225','Certificados','12','2015-11-24 22:18:53','2015-11-24 22:18:53'),(11,'1230','Papeles comerciales','12','2015-11-24 22:18:53','2015-11-24 22:18:53'),(12,'1235','Títulos','12','2015-11-24 22:18:53','2015-11-24 22:18:53'),(13,'1240','Aceptaciones bancarias','12','2015-11-24 22:18:53','2015-11-24 22:18:53'),(14,'1245','Derechos fiduciarios','12','2015-11-24 22:18:53','2015-11-24 22:18:53'),(15,'1250','Derechos de recompra (REPOS)','12','2015-11-24 22:18:53','2015-11-24 22:18:53'),(16,'1255','Inversiones obligatorias','12','2015-11-24 22:18:53','2015-11-24 22:18:53'),(17,'1260','Cuentas en participación','12','2015-11-24 22:18:53','2015-11-24 22:18:53'),(18,'1295','Otras inversiones','12','2015-11-24 22:18:53','2015-11-24 22:18:53'),(19,'1299','Ajustes por inflación','12','2015-11-24 22:18:53','2015-11-24 22:18:53'),(20,'13','Cuentas por cobrar','1','2015-11-24 22:18:53','2015-11-24 22:18:53'),(21,'1305','A clientes','13','2015-11-24 22:18:53','2015-11-24 22:18:53'),(22,'1325','A socios o accionistas','13','2015-11-24 22:18:53','2015-11-24 22:18:53'),(23,'1330','Anticipos y avances','13','2015-11-24 22:18:53','2015-11-24 22:18:53'),(24,'1340','Promesas de compra venta','13','2015-11-24 22:18:53','2015-11-24 22:18:53'),(25,'1345','Ingresos por cobrar','13','2015-11-24 22:18:53','2015-11-24 22:18:53'),(26,'1350','Retención sobre contratos','13','2015-11-24 22:18:53','2015-11-24 22:18:53'),(27,'1355','Anticipo impuestos','13','2015-11-24 22:18:53','2015-11-24 22:18:53'),(28,'1357','IVA retenido por tercero','13','2015-11-24 22:18:53','2015-11-24 22:18:53'),(29,'1365','A trabajadores','13','2015-11-24 22:18:53','2015-11-24 22:18:53'),(30,'1380','Deudores varios','13','2015-11-24 22:18:53','2015-11-24 22:18:53'),(31,'1390','Provisiones','13','2015-11-24 22:18:53','2015-11-24 22:18:53'),(32,'1399','Ajustes por inflación','13','2015-11-24 22:18:53','2015-11-24 22:18:53'),(33,'14','Inventarios','1','2015-11-24 22:18:53','2015-11-24 22:18:53'),(34,'1405','Insumos y materiales en bodega','14','2015-11-24 22:18:53','2015-11-24 22:18:53'),(35,'1410','Productos en proceso','14','2015-11-24 22:18:53','2015-11-24 22:18:53'),(36,'1425','Cultivos en desarrollo','14','2015-11-24 22:18:53','2015-11-24 22:18:53'),(37,'1430','Producto terminado','14','2015-11-24 22:18:53','2015-11-24 22:18:53'),(38,'1435','Mercancias no fabricadas por la empresa','14','2015-11-24 22:18:53','2015-11-24 22:18:53'),(39,'1445','Inventario semovientes','14','2015-11-24 22:18:53','2015-11-24 22:18:53'),(40,'15','Propiedad planta y equipo','1','2015-11-24 22:18:54','2015-11-24 22:18:54'),(41,'1504','Terrenos','15','2015-11-24 22:18:54','2015-11-24 22:18:54'),(42,'1508','Construcciones en curso','15','2015-11-24 22:18:54','2015-11-24 22:18:54'),(43,'1512','Maquinaria y equipo en montaje','15','2015-11-24 22:18:54','2015-11-24 22:18:54'),(44,'1516','Construcciones y edificaciones','15','2015-11-24 22:18:54','2015-11-24 22:18:54'),(45,'1520','Maquinaria y equipo','15','2015-11-24 22:18:54','2015-11-24 22:18:54'),(46,'1524','Muebles y enseres','15','2015-11-24 22:18:54','2015-11-24 22:18:54'),(47,'1528','Equipos de computación y comunicación','15','2015-11-24 22:18:54','2015-11-24 22:18:54'),(48,'1532','Equipo médico - científico','15','2015-11-24 22:18:54','2015-11-24 22:18:54'),(49,'1536','Equipo de hoteles y restaurantes','15','2015-11-24 22:18:54','2015-11-24 22:18:54'),(50,'1540','Vehículos (flota y equipo de transporte)','15','2015-11-24 22:18:54','2015-11-24 22:18:54'),(51,'1556','Acueductos, plantas y redes','15','2015-11-24 22:18:54','2015-11-24 22:18:54'),(52,'1560','Armamento de vigilancia','15','2015-11-24 22:18:54','2015-11-24 22:18:54'),(53,'1562','Envases y empaques','15','2015-11-24 22:18:54','2015-11-24 22:18:54'),(54,'1564','Cultivos en producción.','15','2015-11-24 22:18:54','2015-11-24 22:18:54'),(55,'1568','Vías de comunicación','15','2015-11-24 22:18:54','2015-11-24 22:18:54'),(56,'1572','Minas y canteras','15','2015-11-24 22:18:54','2015-11-24 22:18:54'),(57,'1576','Pozos artesianos','15','2015-11-24 22:18:54','2015-11-24 22:18:54'),(58,'1584','Semovientes','15','2015-11-24 22:18:54','2015-11-24 22:18:54'),(59,'1592','Depreciación acumulada','15','2015-11-24 22:18:54','2015-11-24 22:18:54'),(60,'1597','Amortización acumulada cultivos','15','2015-11-24 22:18:54','2015-11-24 22:18:54'),(61,'1598','Agotamiento acumulado','15','2015-11-24 22:18:54','2015-11-24 22:18:54'),(62,'1599','Ajustes por inflación','15','2015-11-24 22:18:54','2015-11-24 22:18:54'),(63,'16','Intangibles','1','2015-11-24 22:18:54','2015-11-24 22:18:54'),(64,'1605','Credito mercantil','16','2015-11-24 22:18:54','2015-11-24 22:18:54'),(65,'1610','Marcas','16','2015-11-24 22:18:54','2015-11-24 22:18:54'),(66,'1615','Patentes','16','2015-11-24 22:18:54','2015-11-24 22:18:54'),(67,'1620','Concesiones y franquicias','16','2015-11-24 22:18:54','2015-11-24 22:18:54'),(68,'1625','Derechos','16','2015-11-24 22:18:54','2015-11-24 22:18:54'),(69,'1630','Know how','16','2015-11-24 22:18:54','2015-11-24 22:18:54'),(70,'1635','Licencias','16','2015-11-24 22:18:54','2015-11-24 22:18:54'),(71,'1698','Depreciación y/o amortización acumulada','16','2015-11-24 22:18:54','2015-11-24 22:18:54'),(72,'1699','Ajustes por inflación','16','2015-11-24 22:18:54','2015-11-24 22:18:54'),(73,'17','Diferidos','1','2015-11-24 22:18:54','2015-11-24 22:18:54'),(74,'1705','Gastos pagados por anticipado','17','2015-11-24 22:18:54','2015-11-24 22:18:54'),(75,'1710','Cargos diferidos','17','2015-11-24 22:18:54','2015-11-24 22:18:54'),(76,'1799','Ajustes por inflación','17','2015-11-24 22:18:54','2015-11-24 22:18:54'),(77,'18','Otros activos','1','2015-11-24 22:18:54','2015-11-24 22:18:54'),(78,'1805','Bienes de arte y cultura','18','2015-11-24 22:18:54','2015-11-24 22:18:54'),(79,'1895','Otros activos diversos','18','2015-11-24 22:18:54','2015-11-24 22:18:54'),(80,'1899','Ajustes por inflación','18','2015-11-24 22:18:54','2015-11-24 22:18:54'),(81,'19','Valorizaciones','1','2015-11-24 22:18:54','2015-11-24 22:18:54'),(82,'1905','De inversiones','19','2015-11-24 22:18:54','2015-11-24 22:18:54'),(83,'1910','De propiedad planta y equipo','19','2015-11-24 22:18:54','2015-11-24 22:18:54'),(84,'1995','De otros activos','19','2015-11-24 22:18:54','2015-11-24 22:18:54'),(85,'2','PASIVOS',NULL,'2015-11-24 22:18:54','2015-11-24 22:18:54'),(86,'21','Obligaciones financieras','2','2015-11-24 22:18:54','2015-11-24 22:18:54'),(87,'2105','Bancarias','21','2015-11-24 22:18:54','2015-11-24 22:18:54'),(88,'2110','Tarjetas de crédito','21','2015-11-24 22:18:54','2015-11-24 22:18:54'),(89,'22','Proveedores','2','2015-11-24 22:18:54','2015-11-24 22:18:54'),(90,'2205','Proveedores','22','2015-11-24 22:18:54','2015-11-24 22:18:54'),(91,'23','Cuentas por pagar','2','2015-11-24 22:18:54','2015-11-24 22:18:54'),(92,'2335','Costos y gastos por pagar','23','2015-11-24 22:18:54','2015-11-24 22:18:54'),(93,'2355','Deudas con accionistas o socios','23','2015-11-24 22:18:54','2015-11-24 22:18:54'),(94,'2360','Dividendos o participaciones por pagar','23','2015-11-24 22:18:54','2015-11-24 22:18:54'),(95,'2365','Retención en la fuente','23','2015-11-24 22:18:54','2015-11-24 22:18:54'),(96,'2367','IVA retenido a un tercero','23','2015-11-24 22:18:55','2015-11-24 22:18:55'),(97,'2370','Retenciones y aportes de nómina','23','2015-11-24 22:18:55','2015-11-24 22:18:55'),(98,'2380','Acreedores varios','23','2015-11-24 22:18:55','2015-11-24 22:18:55'),(99,'24','Impuestos, gravámenes y tasas','2','2015-11-24 22:18:55','2015-11-24 22:18:55'),(100,'2404','De Renta y Complementarios','24','2015-11-24 22:18:55','2015-11-24 22:18:55'),(101,'2405','De renta y complem. vigencia anterior','24','2015-11-24 22:18:55','2015-11-24 22:18:55'),(102,'2408','IVA por pagar','24','2015-11-24 22:18:55','2015-11-24 22:18:55'),(103,'2412','De industria y comercio','24','2015-11-24 22:18:55','2015-11-24 22:18:55'),(104,'2413','De industria y com. vigencia anterior','24','2015-11-24 22:18:55','2015-11-24 22:18:55'),(105,'2416','A la propiedad raíz','24','2015-11-24 22:18:55','2015-11-24 22:18:55'),(106,'2424','De valorización','24','2015-11-24 22:18:55','2015-11-24 22:18:55'),(107,'25','Obligaciones laborales','2','2015-11-24 22:18:55','2015-11-24 22:18:55'),(108,'2505','Salarios por pagar','25','2015-11-24 22:18:55','2015-11-24 22:18:55'),(109,'2510','Cesantías consolidadas','25','2015-11-24 22:18:55','2015-11-24 22:18:55'),(110,'2515','Intereses sobre cesantías','25','2015-11-24 22:18:55','2015-11-24 22:18:55'),(111,'2520','Prima de servicios','25','2015-11-24 22:18:55','2015-11-24 22:18:55'),(112,'2525','Vacaciones consolidadas','25','2015-11-24 22:18:55','2015-11-24 22:18:55'),(113,'26','Pasivos estimados y provisiones','2','2015-11-24 22:18:55','2015-11-24 22:18:55'),(114,'2605','Para costos y gastos','26','2015-11-24 22:18:55','2015-11-24 22:18:55'),(115,'2610','Para obligaciones laborales','26','2015-11-24 22:18:55','2015-11-24 22:18:55'),(116,'2615','Para obligaciones fiscales','26','2015-11-24 22:18:55','2015-11-24 22:18:55'),(117,'2620','Pensiones de jubilación','26','2015-11-24 22:18:55','2015-11-24 22:18:55'),(118,'2630','Para mantenimiento y relaciones','26','2015-11-24 22:18:55','2015-11-24 22:18:55'),(119,'27','Diferidos','2','2015-11-24 22:18:55','2015-11-24 22:18:55'),(120,'2705','Ingresos recibidos por anticipado','27','2015-11-24 22:18:55','2015-11-24 22:18:55'),(121,'28','Otros pasivos','2','2015-11-24 22:18:55','2015-11-24 22:18:55'),(122,'2805','Anticipos y avances recibidos de clientes','28','2015-11-24 22:18:55','2015-11-24 22:18:55'),(123,'2895','Otros pasivos (diversos)','28','2015-11-24 22:18:55','2015-11-24 22:18:55'),(124,'3','PATRIMONIO',NULL,'2015-11-24 22:18:55','2015-11-24 22:18:55'),(125,'31','Capital social','3','2015-11-24 22:18:55','2015-11-24 22:18:55'),(126,'3105','Capital suscrito y/o aportes socios','31','2015-11-24 22:18:55','2015-11-24 22:18:55'),(127,'32','Superávit de capital','3','2015-11-24 22:18:55','2015-11-24 22:18:55'),(128,'3205','Prima en colocación de acciones','32','2015-11-24 22:18:55','2015-11-24 22:18:55'),(129,'33','Reservas','3','2015-11-24 22:18:55','2015-11-24 22:18:55'),(130,'3305','Reservas obligatorias','33','2015-11-24 22:18:55','2015-11-24 22:18:55'),(131,'3315','Reservas ocasionales','33','2015-11-24 22:18:55','2015-11-24 22:18:55'),(132,'34','Revalorización del patrimonio','3','2015-11-24 22:18:55','2015-11-24 22:18:55'),(133,'3405','Ajustes por inflación','34','2015-11-24 22:18:55','2015-11-24 22:18:55'),(134,'36','Resultados del ejercicio','3','2015-11-24 22:18:55','2015-11-24 22:18:55'),(135,'3605','Utilidad del ejercicio','36','2015-11-24 22:18:55','2015-11-24 22:18:55'),(136,'3610','Pérdida del ejercicio','36','2015-11-24 22:18:55','2015-11-24 22:18:55'),(137,'37','Resultados de ejercicios anteriores','3','2015-11-24 22:18:55','2015-11-24 22:18:55'),(138,'3705','Utilidades acumulados','37','2015-11-24 22:18:55','2015-11-24 22:18:55'),(139,'3710','Pérdidas acumuladas','37','2015-11-24 22:18:55','2015-11-24 22:18:55'),(140,'38','Superávit por valorizaciones','3','2015-11-24 22:18:55','2015-11-24 22:18:55'),(141,'3805','De inversiones','38','2015-11-24 22:18:55','2015-11-24 22:18:55'),(142,'3810','De propiedad planta y equipo','38','2015-11-24 22:18:55','2015-11-24 22:18:55'),(143,'3895','De otros activos','38','2015-11-24 22:18:55','2015-11-24 22:18:55'),(144,'4','INGRESOS',NULL,'2015-11-24 22:18:55','2015-11-24 22:18:55'),(145,'41','Ingresos operacionales','4','2015-11-24 22:18:55','2015-11-24 22:18:55'),(146,'4105','Venta de productos','41','2015-11-24 22:18:55','2015-11-24 22:18:55'),(147,'4135','Venta de materiales','41','2015-11-24 22:18:55','2015-11-24 22:18:55'),(148,'4160','Enseñanza','41','2015-11-24 22:18:55','2015-11-24 22:18:55'),(149,'4175','Bonific., rebajas y desc. en ventas','41','2015-11-24 22:18:55','2015-11-24 22:18:55'),(150,'42','Ingresos no operacionales','4','2015-11-24 22:18:56','2015-11-24 22:18:56'),(151,'4205','Otras ventas','42','2015-11-24 22:18:56','2015-11-24 22:18:56'),(152,'4210','Rendimientos financieros','42','2015-11-24 22:18:56','2015-11-24 22:18:56'),(153,'4215','Dividendos y participaciones','42','2015-11-24 22:18:56','2015-11-24 22:18:56'),(154,'4220','Arrendamientos','42','2015-11-24 22:18:56','2015-11-24 22:18:56'),(155,'4235','Servicios','42','2015-11-24 22:18:56','2015-11-24 22:18:56'),(156,'4240','Utilidad en venta de inversiones','42','2015-11-24 22:18:56','2015-11-24 22:18:56'),(157,'4245','Utilidad en venta de propiedades, planta y equipo','42','2015-11-24 22:18:56','2015-11-24 22:18:56'),(158,'4248','Utilidad en venta de otros bienes','42','2015-11-24 22:18:56','2015-11-24 22:18:56'),(159,'4250','Recuperaciones','42','2015-11-24 22:18:56','2015-11-24 22:18:56'),(160,'4252','Utilid. o pérd. en los ajustes de bodega','42','2015-11-24 22:18:56','2015-11-24 22:18:56'),(161,'4255','Indemnizaciones','42','2015-11-24 22:18:56','2015-11-24 22:18:56'),(162,'4295','Ingresos diversos','42','2015-11-24 22:18:56','2015-11-24 22:18:56'),(163,'47','Corrección Monetaria','4','2015-11-24 22:18:56','2015-11-24 22:18:56'),(164,'4705','Corrección Monetaria','47','2015-11-24 22:18:56','2015-11-24 22:18:56'),(165,'5','GASTOS',NULL,'2015-11-24 22:18:56','2015-11-24 22:18:56'),(166,'51','Operacionales de administración','5','2015-11-24 22:18:56','2015-11-24 22:18:56'),(167,'5105','Gastos de personal','51','2015-11-24 22:18:56','2015-11-24 22:18:56'),(168,'5110','Honorarios','51','2015-11-24 22:18:56','2015-11-24 22:18:56'),(169,'5115','Impuestos','51','2015-11-24 22:18:56','2015-11-24 22:18:56'),(170,'5120','Arrendamientos','51','2015-11-24 22:18:56','2015-11-24 22:18:56'),(171,'5125','Contribuciones y afiliaciones','51','2015-11-24 22:18:56','2015-11-24 22:18:56'),(172,'5130','Seguros','51','2015-11-24 22:18:56','2015-11-24 22:18:56'),(173,'5135','Servicios','51','2015-11-24 22:18:56','2015-11-24 22:18:56'),(174,'5140','Gastos legales','51','2015-11-24 22:18:56','2015-11-24 22:18:56'),(175,'5145','Mantenimientos y reparaciones','51','2015-11-24 22:18:56','2015-11-24 22:18:56'),(176,'5155','Gastos de viajes','51','2015-11-24 22:18:56','2015-11-24 22:18:56'),(177,'5160','Depreciaciones','51','2015-11-24 22:18:56','2015-11-24 22:18:56'),(178,'5165','Amortizaciones','51','2015-11-24 22:18:56','2015-11-24 22:18:56'),(179,'5195','Diversos','51','2015-11-24 22:18:56','2015-11-24 22:18:56'),(180,'52','Operacionales de venta','5','2015-11-24 22:18:56','2015-11-24 22:18:56'),(181,'5299','Provisiones','52','2015-11-24 22:18:56','2015-11-24 22:18:56'),(182,'53','No Operacionales','5','2015-11-24 22:18:56','2015-11-24 22:18:56'),(183,'5305','Financieros','53','2015-11-24 22:18:56','2015-11-24 22:18:56'),(184,'5310','Pérdida en venta y retiro de bienes','53','2015-11-24 22:18:56','2015-11-24 22:18:56'),(185,'5315','Gastos extraordinarios','53','2015-11-24 22:18:56','2015-11-24 22:18:56'),(186,'5395','Gastos diversos','53','2015-11-24 22:18:56','2015-11-24 22:18:56'),(187,'54','Impuestos de renta y complementarios','5','2015-11-24 22:18:56','2015-11-24 22:18:56'),(188,'5405','Impuestos de renta y complementarios','54','2015-11-24 22:18:56','2015-11-24 22:18:56'),(189,'59','Ganancias y pérdidas','5','2015-11-24 22:18:56','2015-11-24 22:18:56'),(190,'5905','Ganancias y pérdidas','59','2015-11-24 22:18:56','2015-11-24 22:18:56'),(191,'6','COSTOS DE VENTAS',NULL,'2015-11-24 22:18:56','2015-11-24 22:18:56'),(192,'61','Costos de ventas','6','2015-11-24 22:18:56','2015-11-24 22:18:56'),(193,'6105','Agricultura, ganadería, caza y pezca','61','2015-11-24 22:18:56','2015-11-24 22:18:56'),(194,'6110','Costo de ventas servicios','61','2015-11-24 22:18:56','2015-11-24 22:18:56'),(195,'6115','Industrias manufactureras','61','2015-11-24 22:18:56','2015-11-24 22:18:56'),(196,'6120','Construcción','61','2015-11-24 22:18:56','2015-11-24 22:18:56'),(197,'6125','Comercio al por mayor y al detal','61','2015-11-24 22:18:56','2015-11-24 22:18:56'),(198,'6130','Hoteles y restaurantes','61','2015-11-24 22:18:56','2015-11-24 22:18:56'),(199,'6135','Transporte, almacenamiento y comunicaciones','61','2015-11-24 22:18:56','2015-11-24 22:18:56'),(200,'6140','Actividad inmobiliaria y de alquiler','61','2015-11-24 22:18:56','2015-11-24 22:18:56'),(201,'6145','Enseñanza','61','2015-11-24 22:18:56','2015-11-24 22:18:56'),(202,'6190','Otros','61','2015-11-24 22:18:56','2015-11-24 22:18:56'),(203,'62','Compras','6','2015-11-24 22:18:56','2015-11-24 22:18:56'),(204,'6205','De mercancías','62','2015-11-24 22:18:56','2015-11-24 22:18:56'),(205,'6210','De materias primas','62','2015-11-24 22:18:56','2015-11-24 22:18:56'),(206,'6215','De materiales indirectos','62','2015-11-24 22:18:56','2015-11-24 22:18:56'),(207,'6220','De Energía','62','2015-11-24 22:18:56','2015-11-24 22:18:56'),(208,'6225','Devoluciones en compras (cr)','62','2015-11-24 22:18:56','2015-11-24 22:18:56'),(209,'7','COSTOS DE PRODUCCION',NULL,'2015-11-24 22:18:56','2015-11-24 22:18:56'),(210,'71','Insumos','7','2015-11-24 22:18:56','2015-11-24 22:18:56'),(211,'7105','Materia prima','71','2015-11-24 22:18:56','2015-11-24 22:18:56'),(212,'710505','Plantulas y semillas','7105','2015-11-24 22:18:57','2015-11-24 22:18:57'),(213,'710510','Materia prima general','7105','2015-11-24 22:18:57','2015-11-24 22:18:57'),(214,'7110','Insumos agricolas','71','2015-11-24 22:18:57','2015-11-24 22:18:57'),(215,'711010','Herbicidas','7110','2015-11-24 22:18:57','2015-11-24 22:18:57'),(216,'711015','Insecticidas','7110','2015-11-24 22:18:57','2015-11-24 22:18:57'),(217,'711020','Fungicidas','7110','2015-11-24 22:18:57','2015-11-24 22:18:57'),(218,'711025','Nematicida','7110','2015-11-24 22:18:57','2015-11-24 22:18:57'),(219,'711030','Reguladores','7110','2015-11-24 22:18:57','2015-11-24 22:18:57'),(220,'711035','Fertilizantes edáficos','7110','2015-11-24 22:18:57','2015-11-24 22:18:57'),(221,'711040','Fertilizantes foliares','7110','2015-11-24 22:18:57','2015-11-24 22:18:57'),(222,'711045','Materia órganica','7110','2015-11-24 22:18:57','2015-11-24 22:18:57'),(223,'711050','Coadyuvantes','7110','2015-11-24 22:18:57','2015-11-24 22:18:57'),(224,'711055','Biológicos','7110','2015-11-24 22:18:57','2015-11-24 22:18:57'),(225,'711060','Enmiendas','7110','2015-11-24 22:18:57','2015-11-24 22:18:57'),(226,'711075','Insumos menores','7110','2015-11-24 22:18:57','2015-11-24 22:18:57'),(227,'7115','Materiales de Post Cosecha','71','2015-11-24 22:18:57','2015-11-24 22:18:57'),(228,'711505','Materiales de Post Cosecha','7115','2015-11-24 22:18:57','2015-11-24 22:18:57'),(229,'7120','Materiales agrícolas','71','2015-11-24 22:18:57','2015-11-24 22:18:57'),(230,'712005','Materiales agrícolas','7120','2015-11-24 22:18:57','2015-11-24 22:18:57'),(231,'7125','Combustibles y lubricantes','71','2015-11-24 22:18:57','2015-11-24 22:18:57'),(232,'712505','Combustibles y lubricantes','7125','2015-11-24 22:18:57','2015-11-24 22:18:57'),(233,'72','Mano de obra directa','7','2015-11-24 22:18:57','2015-11-24 22:18:57'),(234,'7210','Mano de obra Cultivos','72','2015-11-24 22:18:57','2015-11-24 22:18:57'),(235,'721005','Labores de Presiembra','7210','2015-11-24 22:18:57','2015-11-24 22:18:57'),(236,'721010','Labores de Siembra','7210','2015-11-24 22:18:57','2015-11-24 22:18:57'),(237,'721015','Labores de Fertilización','7210','2015-11-24 22:18:57','2015-11-24 22:18:57'),(238,'721020','Labores de Desyerba','7210','2015-11-24 22:18:57','2015-11-24 22:18:57'),(239,'721025','Labores Fitosanitarias','7210','2015-11-24 22:18:57','2015-11-24 22:18:57'),(240,'721030','Labores de Control Plagas','7210','2015-11-24 22:18:57','2015-11-24 22:18:57'),(241,'721035','Labores de Recolección','7210','2015-11-24 22:18:57','2015-11-24 22:18:57'),(242,'721040','Labores de Erradicación','7210','2015-11-24 22:18:57','2015-11-24 22:18:57'),(243,'721045','Labores Culturales','7210','2015-11-24 22:18:57','2015-11-24 22:18:57'),(244,'721050','Labores de Mantenimiento','7210','2015-11-24 22:18:57','2015-11-24 22:18:57'),(245,'721060','Labores especializadas','7210','2015-11-24 22:18:57','2015-11-24 22:18:57'),(246,'721065','Labores generales','7210','2015-11-24 22:18:57','2015-11-24 22:18:57'),(247,'7215','Mano de obra Post Cosecha','72','2015-11-24 22:18:57','2015-11-24 22:18:57'),(248,'721505','Labores Post Cosecha','7215','2015-11-24 22:18:57','2015-11-24 22:18:57'),(249,'7220','Mano de obra Viveros','72','2015-11-24 22:18:57','2015-11-24 22:18:57'),(250,'722005','Labores Viveros','7220','2015-11-24 22:18:57','2015-11-24 22:18:57'),(251,'7225','Mano de obra Avicultura','72','2015-11-24 22:18:57','2015-11-24 22:18:57'),(252,'722505','Labores aves','7225','2015-11-24 22:18:57','2015-11-24 22:18:57'),(253,'7230','Mano de obra peces','72','2015-11-24 22:18:58','2015-11-24 22:18:58'),(254,'723005','Labores peces','7230','2015-11-24 22:18:58','2015-11-24 22:18:58'),(255,'7235','Mano de obra Potreros','72','2015-11-24 22:18:58','2015-11-24 22:18:58'),(256,'723505','Labores Potreros','7235','2015-11-24 22:18:58','2015-11-24 22:18:58'),(257,'7240','Mano de obra Abejas','72','2015-11-24 22:18:58','2015-11-24 22:18:58'),(258,'724005','Labores Abejas','7240','2015-11-24 22:18:58','2015-11-24 22:18:58'),(259,'7245','Mano de obra Ganadería','72','2015-11-24 22:18:58','2015-11-24 22:18:58'),(260,'724505','Labores Ganadería','7245','2015-11-24 22:18:58','2015-11-24 22:18:58'),(261,'7250','Mano de obra Porcicultura','72','2015-11-24 22:18:58','2015-11-24 22:18:58'),(262,'725005','Labores Porcicultura','7250','2015-11-24 22:18:58','2015-11-24 22:18:58'),(263,'7255','Mano de obra Lombricultura','72','2015-11-24 22:18:58','2015-11-24 22:18:58'),(264,'725505','Labores Lombricultura','7255','2015-11-24 22:18:58','2015-11-24 22:18:58'),(265,'73','Costos indirectos de produccion','7','2015-11-24 22:18:58','2015-11-24 22:18:58'),(266,'7301','Mano de obra indirecta','73','2015-11-24 22:18:58','2015-11-24 22:18:58'),(267,'730105','Mantenimiento carreteras','7301','2015-11-24 22:18:58','2015-11-24 22:18:58'),(268,'730110','Mantenimiento canales','7301','2015-11-24 22:18:58','2015-11-24 22:18:58'),(269,'730115','Mantenimiento de linderos','7301','2015-11-24 22:18:58','2015-11-24 22:18:58'),(270,'730120','Mantenimiento de campamentos','7301','2015-11-24 22:18:58','2015-11-24 22:18:58'),(271,'730125','Mantenimiento de bodegas','7301','2015-11-24 22:18:58','2015-11-24 22:18:58'),(272,'730135','Mantenimiento cable via','7301','2015-11-24 22:18:58','2015-11-24 22:18:58'),(273,'730140','Mantenimiento infraestructura','7301','2015-11-24 22:18:58','2015-11-24 22:18:58'),(274,'730145','Mano de obra construcciones y edificaciones','7301','2015-11-24 22:18:58','2015-11-24 22:18:58'),(275,'730195','Otras labores mantenimiento','7301','2015-11-24 22:18:58','2015-11-24 22:18:58'),(276,'7305','Gastos de personal','73','2015-11-24 22:18:58','2015-11-24 22:18:58'),(277,'730503','Salario integral','7305','2015-11-24 22:18:58','2015-11-24 22:18:58'),(278,'730506','Sueldos','7305','2015-11-24 22:18:58','2015-11-24 22:18:58'),(279,'730512','Jornales','7305','2015-11-24 22:18:58','2015-11-24 22:18:58'),(280,'730515','Horas extras y recargos','7305','2015-11-24 22:18:58','2015-11-24 22:18:58'),(281,'730518','Comisiones','7305','2015-11-24 22:18:58','2015-11-24 22:18:58'),(282,'730521','Viáticos','7305','2015-11-24 22:18:58','2015-11-24 22:18:58'),(283,'730524','Incapacidades','7305','2015-11-24 22:18:58','2015-11-24 22:18:58'),(284,'730527','Auxilio de transporte','7305','2015-11-24 22:18:58','2015-11-24 22:18:58'),(285,'730530','Cesantías','7305','2015-11-24 22:18:58','2015-11-24 22:18:58'),(286,'730533','Intereses sobre cesantías','7305','2015-11-24 22:18:58','2015-11-24 22:18:58'),(287,'730536','Prima de servicios','7305','2015-11-24 22:18:58','2015-11-24 22:18:58'),(288,'730539','Vacaciones','7305','2015-11-24 22:18:58','2015-11-24 22:18:58'),(289,'730542','Primas extralegales','7305','2015-11-24 22:18:58','2015-11-24 22:18:58'),(290,'730545','Auxilios','7305','2015-11-24 22:18:58','2015-11-24 22:18:58'),(291,'730548','Bonificaciones','7305','2015-11-24 22:18:58','2015-11-24 22:18:58'),(292,'730551','Dotación y suministro a trabajadores','7305','2015-11-24 22:18:58','2015-11-24 22:18:58'),(293,'730554','Seguros','7305','2015-11-24 22:18:58','2015-11-24 22:18:58'),(294,'730557','Cuotas partes pensiones de jubilación','7305','2015-11-24 22:18:58','2015-11-24 22:18:58'),(295,'730558','Amortización cálculo actuarial pensiones de jubilación','7305','2015-11-24 22:18:58','2015-11-24 22:18:58'),(296,'730559','Pensiones de jubilación','7305','2015-11-24 22:18:58','2015-11-24 22:18:58'),(297,'730560','Indemnizaciones laborales','7305','2015-11-24 22:18:58','2015-11-24 22:18:58'),(298,'730561','Amortización bonos pensionales','7305','2015-11-24 22:18:58','2015-11-24 22:18:58'),(299,'730562','Amortización títulos pensionales','7305','2015-11-24 22:18:58','2015-11-24 22:18:58'),(300,'730563','Capacitación al personal','7305','2015-11-24 22:18:58','2015-11-24 22:18:58'),(301,'730566','Gastos deportivos y de recreación','7305','2015-11-24 22:18:58','2015-11-24 22:18:58'),(302,'730568','Aportes a administradoras de riesgos profesionales arp','7305','2015-11-24 22:18:58','2015-11-24 22:18:58'),(303,'730569','Aportes a entidades promotoras de salud eps','7305','2015-11-24 22:18:58','2015-11-24 22:18:58'),(304,'730570','Aportes a fondos de pensiones y/o cesantías','7305','2015-11-24 22:18:59','2015-11-24 22:18:59'),(305,'730572','Aportes cajas de compensación familiar','7305','2015-11-24 22:18:59','2015-11-24 22:18:59'),(306,'730575','Aportes i.c.b.f.','7305','2015-11-24 22:18:59','2015-11-24 22:18:59'),(307,'730578','Sena','7305','2015-11-24 22:18:59','2015-11-24 22:18:59'),(308,'730581','Aportes sindicales','7305','2015-11-24 22:18:59','2015-11-24 22:18:59'),(309,'730584','Gastos médicos y drogas','7305','2015-11-24 22:18:59','2015-11-24 22:18:59'),(310,'730595','Otros','7305','2015-11-24 22:18:59','2015-11-24 22:18:59'),(311,'7310','Insumos indirectos','73','2015-11-24 22:18:59','2015-11-24 22:18:59'),(312,'731005','Plantulas y semillas','7310','2015-11-24 22:18:59','2015-11-24 22:18:59'),(313,'731010','Herbicidas','7310','2015-11-24 22:18:59','2015-11-24 22:18:59'),(314,'731015','Insecticidas','7310','2015-11-24 22:18:59','2015-11-24 22:18:59'),(315,'731020','Fungicidas','7310','2015-11-24 22:18:59','2015-11-24 22:18:59'),(316,'731025','Nematicida','7310','2015-11-24 22:18:59','2015-11-24 22:18:59'),(317,'731030','Reguladores','7310','2015-11-24 22:18:59','2015-11-24 22:18:59'),(318,'731035','Fertilizantes edáficos','7310','2015-11-24 22:18:59','2015-11-24 22:18:59'),(319,'731040','Fertilizantes foliares','7310','2015-11-24 22:18:59','2015-11-24 22:18:59'),(320,'731045','Materia órganica','7310','2015-11-24 22:18:59','2015-11-24 22:18:59'),(321,'731050','Coadyuvantes','7310','2015-11-24 22:18:59','2015-11-24 22:18:59'),(322,'731055','Biológicos','7310','2015-11-24 22:18:59','2015-11-24 22:18:59'),(323,'7320','Maquinaria y equipos','73','2015-11-24 22:18:59','2015-11-24 22:18:59'),(324,'732005','Mantenimiento de maquinaria','7320','2015-11-24 22:18:59','2015-11-24 22:18:59'),(325,'732010','Mantenimiento sistema de riego','7320','2015-11-24 22:18:59','2015-11-24 22:18:59'),(326,'732015','Mantenimiento cable via','7320','2015-11-24 22:18:59','2015-11-24 22:18:59'),(327,'732020','Mantenimiento equipo transporte','7320','2015-11-24 22:18:59','2015-11-24 22:18:59'),(328,'732025','Mantenimiento equipo agrícola','7320','2015-11-24 22:18:59','2015-11-24 22:18:59'),(329,'732030','Equipo de transporte','7320','2015-11-24 22:18:59','2015-11-24 22:18:59'),(330,'732035','Arrendamiento de equipos','7320','2015-11-24 22:18:59','2015-11-24 22:18:59'),(331,'732040','Repuestos y piezas','7320','2015-11-24 22:18:59','2015-11-24 22:18:59'),(332,'732045','Herramientas maquinaria','7320','2015-11-24 22:18:59','2015-11-24 22:18:59'),(333,'732050','Combustibles y lubricantes','7320','2015-11-24 22:18:59','2015-11-24 22:18:59'),(334,'7335','Servicios','73','2015-11-24 22:18:59','2015-11-24 22:18:59'),(335,'733505','Aseo y vigilancia','7335','2015-11-24 22:18:59','2015-11-24 22:18:59'),(336,'733510','Temporales','7335','2015-11-24 22:18:59','2015-11-24 22:18:59'),(337,'733515','Asistencia técnica','7335','2015-11-24 22:18:59','2015-11-24 22:18:59'),(338,'733520','Procesamiento electrónico de datos','7335','2015-11-24 22:18:59','2015-11-24 22:18:59'),(339,'733525','Acueducto y alcantarillado','7335','2015-11-24 22:18:59','2015-11-24 22:18:59'),(340,'733530','Energía eléctrica','7335','2015-11-24 22:18:59','2015-11-24 22:18:59'),(341,'733535','Teléfono','7335','2015-11-24 22:18:59','2015-11-24 22:18:59'),(342,'733540','Correo, portes y telegramas','7335','2015-11-24 22:18:59','2015-11-24 22:18:59'),(343,'733545','Fax y telex','7335','2015-11-24 22:18:59','2015-11-24 22:18:59'),(344,'733550','Transporte, fletes y acarreos','7335','2015-11-24 22:18:59','2015-11-24 22:18:59'),(345,'733555','Gas','7335','2015-11-24 22:18:59','2015-11-24 22:18:59'),(346,'733560','Publicidad, propaganda y promoción','7335','2015-11-24 22:18:59','2015-11-24 22:18:59'),(347,'733595','Otros','7335','2015-11-24 22:18:59','2015-11-24 22:18:59'),(348,'7340','Materiales agrícolas','73','2015-11-24 22:18:59','2015-11-24 22:18:59'),(349,'734005','Materiales agrícolas','7340','2015-11-24 22:18:59','2015-11-24 22:18:59'),(350,'7345','Herramientas agrícolas','73','2015-11-24 22:18:59','2015-11-24 22:18:59'),(351,'734505','Herramientas agrícolas','7345','2015-11-24 22:18:59','2015-11-24 22:18:59'),(352,'7350','Materiales civiles','73','2015-11-24 22:18:59','2015-11-24 22:18:59'),(353,'735005','Materiales civiles','7350','2015-11-24 22:18:59','2015-11-24 22:18:59'),(354,'7355','Dotaciones de trabajadores','73','2015-11-24 22:18:59','2015-11-24 22:18:59'),(355,'735505','Dotaciones de trabajadores','7355','2015-11-24 22:18:59','2015-11-24 22:18:59'),(356,'7370','Post Cosecha','73','2015-11-24 22:19:00','2015-11-24 22:19:00'),(357,'737005','Post Cosecha','7370','2015-11-24 22:19:00','2015-11-24 22:19:00'),(358,'7390','Depreciaciones','73','2015-11-24 22:19:00','2015-11-24 22:19:00'),(359,'739005','Construcciones y edificaciones','7390','2015-11-24 22:19:00','2015-11-24 22:19:00'),(360,'739010','Maquinaria y equipo','7390','2015-11-24 22:19:00','2015-11-24 22:19:00'),(361,'739015','Equipo de transporte','7390','2015-11-24 22:19:00','2015-11-24 22:19:00'),(362,'739020','Vias de comunicacion','7390','2015-11-24 22:19:00','2015-11-24 22:19:00'),(363,'739025','Envases y empaques','7390','2015-11-24 22:19:00','2015-11-24 22:19:00'),(364,'7395','Otros costos indirectos','73','2015-11-24 22:19:00','2015-11-24 22:19:00'),(365,'739505','Arrendamiento de fincas','7395','2015-11-24 22:19:00','2015-11-24 22:19:00'),(366,'739510','Seguros','7395','2015-11-24 22:19:00','2015-11-24 22:19:00'),(367,'739595','Otros','7395','2015-11-24 22:19:00','2015-11-24 22:19:00'),(368,'74','Contratistas','7','2015-11-24 22:19:00','2015-11-24 22:19:00'),(369,'7405','Contratistas','74','2015-11-24 22:19:00','2015-11-24 22:19:00');
/*!40000 ALTER TABLE `ledger_accounts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lines`
--

DROP TABLE IF EXISTS `lines`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `lines` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `code` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `description` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `inventory` int(11) DEFAULT NULL,
  `sale_cost` int(11) DEFAULT NULL,
  `utility_adjusment` int(11) DEFAULT NULL,
  `lost_adjustment` int(11) DEFAULT NULL,
  `income` int(11) DEFAULT NULL,
  `sales_return` int(11) DEFAULT NULL,
  `purchase_return` int(11) DEFAULT NULL,
  `sale_tax` int(11) DEFAULT NULL,
  `purchase_tax` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `lines`
--

LOCK TABLES `lines` WRITE;
/*!40000 ALTER TABLE `lines` DISABLE KEYS */;
/*!40000 ALTER TABLE `lines` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `means_of_payments`
--

DROP TABLE IF EXISTS `means_of_payments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `means_of_payments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `description` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `means_of_payments`
--

LOCK TABLES `means_of_payments` WRITE;
/*!40000 ALTER TABLE `means_of_payments` DISABLE KEYS */;
INSERT INTO `means_of_payments` VALUES (1,'Deposito','Deposito Bancario','2015-11-24 22:32:11','2015-11-24 22:32:11');
/*!40000 ALTER TABLE `means_of_payments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `model_names`
--

DROP TABLE IF EXISTS `model_names`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `model_names` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `model_names`
--

LOCK TABLES `model_names` WRITE;
/*!40000 ALTER TABLE `model_names` DISABLE KEYS */;
INSERT INTO `model_names` VALUES (1,'Province','2015-11-24 15:23:51','2015-11-24 15:23:51'),(2,'Canton','2015-11-24 15:23:51','2015-11-24 15:23:51'),(3,'District','2015-11-24 15:23:51','2015-11-24 15:23:51'),(4,'Employee','2015-11-24 15:23:51','2015-11-24 15:23:51'),(5,'Department','2015-11-24 15:23:51','2015-11-24 15:23:51'),(6,'Position','2015-11-24 15:23:51','2015-11-24 15:23:51'),(7,'Deduction','2015-11-24 15:23:51','2015-11-24 15:23:51'),(8,'WorkBenefit','2015-11-24 15:23:51','2015-11-24 15:23:51'),(9,'Occupation','2015-11-24 15:23:51','2015-11-24 15:23:51'),(10,'MeansOfPayment','2015-11-24 15:23:51','2015-11-24 15:23:51'),(11,'PaymentFrequency','2015-11-24 15:23:51','2015-11-24 15:23:51'),(12,'TypeOfPersonnelAction','2015-11-24 15:23:51','2015-11-24 15:23:51'),(13,'PayrollType','2015-11-24 15:23:51','2015-11-24 15:23:51'),(14,'User','2015-11-24 15:23:51','2015-11-24 15:23:51'),(15,'PaymentType','2015-11-24 15:23:51','2015-11-24 15:23:51'),(16,'OtherPayment','2015-11-24 15:23:51','2015-11-24 15:23:51'),(17,'Payroll','2015-11-24 15:23:51','2015-11-24 15:23:51'),(18,'PayrollLog','2015-11-24 15:23:51','2015-11-24 15:23:51'),(19,'DetailPersonnelAction','2015-11-24 15:23:51','2015-11-24 15:23:51'),(20,'Task','2015-11-24 15:23:51','2015-11-24 15:23:51');
/*!40000 ALTER TABLE `model_names` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `occupations`
--

DROP TABLE IF EXISTS `occupations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `occupations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `description` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ins_code` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ccss_code` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `occupations`
--

LOCK TABLES `occupations` WRITE;
/*!40000 ALTER TABLE `occupations` DISABLE KEYS */;
/*!40000 ALTER TABLE `occupations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `other_payment_employees`
--

DROP TABLE IF EXISTS `other_payment_employees`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `other_payment_employees` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `other_payment_id` int(11) DEFAULT NULL,
  `employee_id` int(11) DEFAULT NULL,
  `completed` tinyint(1) DEFAULT '0',
  `calculation` decimal(10,2) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_other_payment_employees_on_other_payment_id` (`other_payment_id`),
  KEY `index_other_payment_employees_on_employee_id` (`employee_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `other_payment_employees`
--

LOCK TABLES `other_payment_employees` WRITE;
/*!40000 ALTER TABLE `other_payment_employees` DISABLE KEYS */;
/*!40000 ALTER TABLE `other_payment_employees` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `other_payment_payments`
--

DROP TABLE IF EXISTS `other_payment_payments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `other_payment_payments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `other_payment_employee_id` int(11) DEFAULT NULL,
  `payroll_id` int(11) DEFAULT NULL,
  `payment_date` date DEFAULT NULL,
  `payment` decimal(10,2) DEFAULT NULL,
  `is_salary` tinyint(1) DEFAULT '0',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_other_payment_payments_on_other_payment_employee_id` (`other_payment_employee_id`),
  KEY `index_other_payment_payments_on_payroll_id` (`payroll_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `other_payment_payments`
--

LOCK TABLES `other_payment_payments` WRITE;
/*!40000 ALTER TABLE `other_payment_payments` DISABLE KEYS */;
/*!40000 ALTER TABLE `other_payment_payments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `other_payment_payrolls`
--

DROP TABLE IF EXISTS `other_payment_payrolls`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `other_payment_payrolls` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `other_payment_id` int(11) DEFAULT NULL,
  `payroll_id` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_other_payment_payrolls_on_other_payment_id` (`other_payment_id`),
  KEY `index_other_payment_payrolls_on_payroll_id` (`payroll_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `other_payment_payrolls`
--

LOCK TABLES `other_payment_payrolls` WRITE;
/*!40000 ALTER TABLE `other_payment_payrolls` DISABLE KEYS */;
/*!40000 ALTER TABLE `other_payment_payrolls` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `other_payments`
--

DROP TABLE IF EXISTS `other_payments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `other_payments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `costs_center_id` int(11) DEFAULT NULL,
  `ledger_account_id` int(11) DEFAULT NULL,
  `description` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `deduction_type` enum('constant','unique','amount_to_exhaust') COLLATE utf8_unicode_ci DEFAULT NULL,
  `calculation_type` enum('percentage','fixed') COLLATE utf8_unicode_ci DEFAULT NULL,
  `amount` decimal(10,2) DEFAULT NULL,
  `state` enum('completed','active') COLLATE utf8_unicode_ci DEFAULT 'active',
  `constitutes_salary` tinyint(1) DEFAULT NULL,
  `individual` tinyint(1) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_other_payments_on_costs_center_id` (`costs_center_id`),
  KEY `index_other_payments_on_ledger_account_id` (`ledger_account_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `other_payments`
--

LOCK TABLES `other_payments` WRITE;
/*!40000 ALTER TABLE `other_payments` DISABLE KEYS */;
/*!40000 ALTER TABLE `other_payments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `payment_frequencies`
--

DROP TABLE IF EXISTS `payment_frequencies`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `payment_frequencies` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `description` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `payment_frequencies`
--

LOCK TABLES `payment_frequencies` WRITE;
/*!40000 ALTER TABLE `payment_frequencies` DISABLE KEYS */;
INSERT INTO `payment_frequencies` VALUES (1,'Quincenal','Cada 15 días','2015-11-24 22:25:13','2015-11-24 22:25:13');
/*!40000 ALTER TABLE `payment_frequencies` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `payment_types`
--

DROP TABLE IF EXISTS `payment_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `payment_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `description` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `factor` decimal(10,2) DEFAULT NULL,
  `contract_code` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `payment_type` enum('ordinary','extra','double') COLLATE utf8_unicode_ci DEFAULT NULL,
  `state` enum('completed','active') COLLATE utf8_unicode_ci DEFAULT 'active',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `payment_types`
--

LOCK TABLES `payment_types` WRITE;
/*!40000 ALTER TABLE `payment_types` DISABLE KEYS */;
INSERT INTO `payment_types` VALUES (1,'Ordinario','Pago Ordinario',1.00,'1','ordinary','active','2015-11-24 22:20:08','2015-11-24 22:20:08'),(2,'Extra','Pago Extra',1.50,'2','extra','active','2015-11-24 22:20:28','2015-11-24 22:20:28'),(3,'Doble','Pago Doble',2.00,'3','double','active','2015-11-24 22:20:53','2015-11-24 22:20:53');
/*!40000 ALTER TABLE `payment_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `payment_units`
--

DROP TABLE IF EXISTS `payment_units`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `payment_units` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `description` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `payment_units`
--

LOCK TABLES `payment_units` WRITE;
/*!40000 ALTER TABLE `payment_units` DISABLE KEYS */;
/*!40000 ALTER TABLE `payment_units` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `payroll_employees`
--

DROP TABLE IF EXISTS `payroll_employees`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `payroll_employees` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `employee_id` int(11) DEFAULT NULL,
  `payroll_history_id` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_payroll_employees_on_employee_id` (`employee_id`),
  KEY `index_payroll_employees_on_payroll_history_id` (`payroll_history_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `payroll_employees`
--

LOCK TABLES `payroll_employees` WRITE;
/*!40000 ALTER TABLE `payroll_employees` DISABLE KEYS */;
/*!40000 ALTER TABLE `payroll_employees` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `payroll_histories`
--

DROP TABLE IF EXISTS `payroll_histories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `payroll_histories` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `task_id` int(11) DEFAULT NULL,
  `costs_center_id` int(11) DEFAULT NULL,
  `payroll_log_id` int(11) DEFAULT NULL,
  `payment_type_id` int(11) DEFAULT NULL,
  `time_worked` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `total` decimal(10,2) DEFAULT NULL,
  `task_total` decimal(10,2) DEFAULT NULL,
  `performance` decimal(10,2) DEFAULT NULL,
  `task_unidad` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `payroll_date` date DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_payroll_histories_on_task_id` (`task_id`),
  KEY `index_payroll_histories_on_costs_center_id` (`costs_center_id`),
  KEY `index_payroll_histories_on_payroll_log_id` (`payroll_log_id`),
  KEY `index_payroll_histories_on_payment_type_id` (`payment_type_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `payroll_histories`
--

LOCK TABLES `payroll_histories` WRITE;
/*!40000 ALTER TABLE `payroll_histories` DISABLE KEYS */;
/*!40000 ALTER TABLE `payroll_histories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `payroll_logs`
--

DROP TABLE IF EXISTS `payroll_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `payroll_logs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `payroll_id` int(11) DEFAULT NULL,
  `payroll_date` date DEFAULT NULL,
  `payroll_total` decimal(10,2) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_payroll_logs_on_payroll_id` (`payroll_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `payroll_logs`
--

LOCK TABLES `payroll_logs` WRITE;
/*!40000 ALTER TABLE `payroll_logs` DISABLE KEYS */;
/*!40000 ALTER TABLE `payroll_logs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `payroll_type_benefits`
--

DROP TABLE IF EXISTS `payroll_type_benefits`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `payroll_type_benefits` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `payroll_type_id` int(11) DEFAULT NULL,
  `work_benefit_id` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_payroll_type_benefits_on_payroll_type_id` (`payroll_type_id`),
  KEY `index_payroll_type_benefits_on_work_benefit_id` (`work_benefit_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `payroll_type_benefits`
--

LOCK TABLES `payroll_type_benefits` WRITE;
/*!40000 ALTER TABLE `payroll_type_benefits` DISABLE KEYS */;
/*!40000 ALTER TABLE `payroll_type_benefits` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `payroll_type_deductions`
--

DROP TABLE IF EXISTS `payroll_type_deductions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `payroll_type_deductions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `payroll_type_id` int(11) DEFAULT NULL,
  `deduction_id` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_payroll_type_deductions_on_payroll_type_id` (`payroll_type_id`),
  KEY `index_payroll_type_deductions_on_deduction_id` (`deduction_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `payroll_type_deductions`
--

LOCK TABLES `payroll_type_deductions` WRITE;
/*!40000 ALTER TABLE `payroll_type_deductions` DISABLE KEYS */;
INSERT INTO `payroll_type_deductions` VALUES (1,1,1,'2015-11-24 22:36:52','2015-11-24 22:36:52');
/*!40000 ALTER TABLE `payroll_type_deductions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `payroll_type_other_payments`
--

DROP TABLE IF EXISTS `payroll_type_other_payments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `payroll_type_other_payments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `payroll_type_id` int(11) DEFAULT NULL,
  `other_payment_id` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_payroll_type_other_payments_on_payroll_type_id` (`payroll_type_id`),
  KEY `index_payroll_type_other_payments_on_other_payment_id` (`other_payment_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `payroll_type_other_payments`
--

LOCK TABLES `payroll_type_other_payments` WRITE;
/*!40000 ALTER TABLE `payroll_type_other_payments` DISABLE KEYS */;
/*!40000 ALTER TABLE `payroll_type_other_payments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `payroll_types`
--

DROP TABLE IF EXISTS `payroll_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `payroll_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `company_id` int(11) DEFAULT NULL,
  `ledger_account_id` int(11) DEFAULT NULL,
  `description` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `payroll_type` enum('administrative','fieldwork','plant') COLLATE utf8_unicode_ci DEFAULT NULL,
  `state` tinyint(1) DEFAULT '1',
  `cod_doc_payroll_support` int(11) DEFAULT NULL,
  `mask_doc_payroll_support` varchar(5) COLLATE utf8_unicode_ci DEFAULT NULL,
  `cod_doc_accounting_support_mov` int(11) DEFAULT NULL,
  `mask_doc_accounting_support_mov` varchar(5) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_payroll_types_on_ledger_account_id` (`ledger_account_id`),
  KEY `index_payroll_types_on_company_id` (`company_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `payroll_types`
--

LOCK TABLES `payroll_types` WRITE;
/*!40000 ALTER TABLE `payroll_types` DISABLE KEYS */;
INSERT INTO `payroll_types` VALUES (1,1,108,'Administrativa','administrative',1,NULL,'',NULL,'','2015-11-24 22:24:24','2015-11-24 22:36:06');
/*!40000 ALTER TABLE `payroll_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `payrolls`
--

DROP TABLE IF EXISTS `payrolls`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `payrolls` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `company_id` int(11) DEFAULT NULL,
  `payroll_type_id` int(11) DEFAULT NULL,
  `start_date` date DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  `payment_date` date DEFAULT NULL,
  `state` tinyint(1) DEFAULT '1',
  `num_oper` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `num_oper_2` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_payrolls_on_payroll_type_id` (`payroll_type_id`),
  KEY `index_payrolls_on_company_id` (`company_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `payrolls`
--

LOCK TABLES `payrolls` WRITE;
/*!40000 ALTER TABLE `payrolls` DISABLE KEYS */;
/*!40000 ALTER TABLE `payrolls` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `permissions_categories`
--

DROP TABLE IF EXISTS `permissions_categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `permissions_categories` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `permissions_categories`
--

LOCK TABLES `permissions_categories` WRITE;
/*!40000 ALTER TABLE `permissions_categories` DISABLE KEYS */;
INSERT INTO `permissions_categories` VALUES (1,'Configuración','2013-07-31 22:03:28','2013-07-31 22:03:28'),(2,'Procesos','2013-07-31 22:05:44','2013-07-31 22:05:44'),(3,'Informes','2013-07-31 22:05:54','2013-07-31 22:05:54');
/*!40000 ALTER TABLE `permissions_categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `permissions_subcategories`
--

DROP TABLE IF EXISTS `permissions_subcategories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `permissions_subcategories` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `permissions_category_id` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_permissions_subcategories_on_permissions_category_id` (`permissions_category_id`)
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `permissions_subcategories`
--

LOCK TABLES `permissions_subcategories` WRITE;
/*!40000 ALTER TABLE `permissions_subcategories` DISABLE KEYS */;
INSERT INTO `permissions_subcategories` VALUES (1,'Provincias',1,'2013-08-01 16:41:04','2013-08-01 16:41:04'),(2,'Cantones',1,'2013-08-01 16:41:04','2013-08-01 16:41:04'),(3,'Distritos',1,'2013-08-01 16:41:04','2013-08-01 16:41:04'),(4,'Empleados',1,'2013-08-01 16:41:04','2013-08-01 16:41:04'),(5,'Departamentos',1,'2013-08-01 16:41:04','2013-08-01 16:41:04'),(6,'Puestos',1,'2013-08-01 16:41:04','2013-08-01 16:41:04'),(7,'Labores',1,'2013-08-01 16:41:04','2013-08-01 16:41:04'),(8,'Deducciones',1,'2013-08-01 16:41:04','2013-08-01 16:41:04'),(9,'Prestaciones',1,'2013-08-01 16:41:04','2013-08-01 16:41:04'),(10,'Centro de Costos',1,'2013-08-01 16:41:04','2013-08-01 16:41:04'),(11,'Cuentas Contables',1,'2013-08-01 16:41:04','2013-08-01 16:41:04'),(12,'Otros Salarios',1,'2013-08-01 16:41:04','2013-08-01 16:41:04'),(13,'Ocupaciones',1,'2013-08-01 16:41:04','2013-08-01 16:41:04'),(14,'Medios de Pago',1,'2013-08-01 16:41:04','2013-08-01 16:41:04'),(15,'Frecuencias de Pago',1,'2013-08-01 16:41:04','2013-08-01 16:41:04'),(16,'Tipos de Acciones del Personal',1,'2013-08-01 16:41:04','2013-08-01 16:41:04'),(17,'Tipos de Planillas',1,'2013-08-01 16:41:04','2013-08-01 16:41:04'),(18,'Usuarios',1,'2013-08-01 16:41:04','2013-08-01 16:41:04'),(19,'Planillas',2,'2013-08-01 16:42:31','2013-08-01 16:42:31'),(20,'Acciones de Personal',2,'2013-08-01 16:42:31','2013-08-01 16:42:31'),(21,'Comprobante pago Trabajadores',3,'2013-08-01 16:43:37','2013-08-01 16:43:37'),(22,'Comprobante General de Pago',3,'2013-08-01 16:43:37','2013-08-01 16:43:37'),(23,'Companias',1,'0000-00-00 00:00:00','0000-00-00 00:00:00'),(24,'Otros Pagos',1,'0000-00-00 00:00:00','0000-00-00 00:00:00'),(25,'Tipos de Pago',1,'0000-00-00 00:00:00','0000-00-00 00:00:00');
/*!40000 ALTER TABLE `permissions_subcategories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `permissions_users`
--

DROP TABLE IF EXISTS `permissions_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `permissions_users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `permissions_subcategory_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `p_create` tinyint(1) DEFAULT '0',
  `p_view` tinyint(1) DEFAULT '0',
  `p_modify` tinyint(1) DEFAULT '0',
  `p_delete` tinyint(1) DEFAULT '0',
  `p_close` tinyint(1) DEFAULT '0',
  `p_accounts` tinyint(1) DEFAULT '0',
  `p_pdf` tinyint(1) DEFAULT '0',
  `p_exel` tinyint(1) DEFAULT '0',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_permissions_users_on_permissions_subcategory_id` (`permissions_subcategory_id`),
  KEY `index_permissions_users_on_user_id` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `permissions_users`
--

LOCK TABLES `permissions_users` WRITE;
/*!40000 ALTER TABLE `permissions_users` DISABLE KEYS */;
INSERT INTO `permissions_users` VALUES (1,1,1,1,1,1,1,0,0,0,0,'2013-08-14 16:50:08','2013-11-15 17:41:54'),(2,2,1,1,1,1,1,0,0,0,0,'2013-08-14 16:50:08','2013-11-15 17:41:54'),(3,3,1,1,1,1,1,0,0,0,0,'2013-08-14 16:50:08','2013-11-15 17:41:54'),(4,4,1,1,1,1,1,0,0,0,0,'2013-08-14 16:50:08','2013-11-15 17:41:54'),(5,5,1,1,1,1,1,0,0,0,0,'2013-08-14 16:50:08','2013-11-15 17:41:54'),(6,6,1,1,1,1,1,0,0,0,0,'2013-08-14 16:50:08','2013-11-15 17:41:54'),(7,7,1,1,1,1,1,0,0,0,0,'2013-08-14 16:50:08','2013-11-15 17:41:54'),(8,8,1,1,1,1,1,0,0,0,0,'2013-08-14 16:50:08','2013-11-15 17:41:54'),(9,9,1,1,1,1,1,0,0,0,0,'2013-08-14 16:50:08','2013-11-15 17:41:54'),(10,10,1,1,1,1,1,0,0,0,0,'2013-08-14 16:50:08','2013-11-15 17:41:54'),(11,11,1,1,1,1,1,0,0,0,0,'2013-08-14 16:50:08','2013-11-15 17:41:54'),(12,12,1,1,1,1,1,0,0,0,0,'2013-08-14 16:50:08','2013-11-15 17:41:54'),(13,13,1,1,1,1,1,0,0,0,0,'2013-08-14 16:50:08','2013-11-15 17:41:54'),(14,14,1,1,1,1,1,0,0,0,0,'2013-08-14 16:50:08','2013-11-15 17:41:54'),(15,15,1,1,1,1,1,0,0,0,0,'2013-08-14 16:50:08','2013-11-15 17:41:54'),(16,16,1,1,1,1,1,0,0,0,0,'2013-08-14 16:50:08','2013-11-15 17:41:54'),(17,17,1,1,1,1,1,0,0,0,0,'2013-08-14 16:50:08','2013-11-15 17:41:54'),(18,18,1,1,1,1,1,0,0,0,0,'2013-08-14 16:50:08','2013-11-15 17:41:54'),(19,19,1,1,1,1,1,1,1,0,0,'2013-08-14 16:50:08','2013-11-15 17:41:54'),(20,20,1,1,1,1,1,1,1,0,0,'2013-08-14 16:50:08','2013-11-15 17:41:54'),(21,21,1,0,0,0,0,0,0,1,1,'2013-08-14 16:50:08','2013-11-15 17:41:54'),(22,22,1,0,0,0,0,0,0,1,1,'2013-08-14 16:50:08','2013-11-15 17:41:54'),(23,23,1,1,1,1,1,0,0,0,0,'2013-08-14 16:50:08','2014-12-01 19:38:10'),(24,24,1,1,1,1,1,0,0,0,0,'2013-08-14 16:50:08','2014-12-01 19:38:10'),(25,25,1,1,1,1,1,0,0,0,0,'2013-08-14 16:50:08','2014-12-01 19:38:10');
/*!40000 ALTER TABLE `permissions_users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `personalized_fields`
--

DROP TABLE IF EXISTS `personalized_fields`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `personalized_fields` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type_of_personnel_action_id` int(11) DEFAULT NULL,
  `fields_personnel_action_id` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_personalized_fields_on_type_of_personnel_action_id` (`type_of_personnel_action_id`),
  KEY `index_personalized_fields_on_fields_personnel_action_id` (`fields_personnel_action_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `personalized_fields`
--

LOCK TABLES `personalized_fields` WRITE;
/*!40000 ALTER TABLE `personalized_fields` DISABLE KEYS */;
/*!40000 ALTER TABLE `personalized_fields` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `photos`
--

DROP TABLE IF EXISTS `photos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `photos` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `employee_id` int(11) DEFAULT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `photo` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_photos_on_employee_id` (`employee_id`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `photos`
--

LOCK TABLES `photos` WRITE;
/*!40000 ALTER TABLE `photos` DISABLE KEYS */;
INSERT INTO `photos` VALUES (1,1,NULL,NULL,'2015-11-24 22:17:55','2015-11-24 22:17:55'),(2,2,NULL,NULL,'2015-11-24 22:17:55','2015-11-24 22:17:55'),(3,3,NULL,NULL,'2015-11-24 22:17:55','2015-11-24 22:17:55'),(4,4,NULL,NULL,'2015-11-24 22:17:55','2015-11-24 22:17:55'),(5,5,NULL,NULL,'2015-11-24 22:17:55','2015-11-24 22:17:55'),(6,6,NULL,NULL,'2015-11-24 22:17:55','2015-11-24 22:17:55'),(7,7,NULL,NULL,'2015-11-24 22:17:55','2015-11-24 22:17:55'),(8,8,NULL,NULL,'2015-11-24 22:17:55','2015-11-24 22:17:55'),(9,9,NULL,NULL,'2015-11-24 22:17:55','2015-11-24 22:17:55'),(10,10,NULL,NULL,'2015-11-24 22:17:55','2015-11-24 22:17:55'),(11,11,NULL,NULL,'2015-11-24 22:17:55','2015-11-24 22:17:55'),(12,12,NULL,NULL,'2015-11-24 22:17:55','2015-11-24 22:17:55'),(13,13,NULL,NULL,'2015-11-24 22:17:55','2015-11-24 22:17:55'),(14,14,NULL,NULL,'2015-11-24 22:17:55','2015-11-24 22:17:55'),(15,15,NULL,NULL,'2015-11-24 22:17:55','2015-11-24 22:17:55'),(16,16,NULL,NULL,'2015-11-24 22:17:55','2015-11-24 22:17:55'),(17,17,NULL,NULL,'2015-11-24 22:17:55','2015-11-24 22:17:55'),(18,18,NULL,NULL,'2015-11-24 22:17:56','2015-11-24 22:17:56'),(19,19,NULL,NULL,'2015-11-24 22:17:56','2015-11-24 22:17:56');
/*!40000 ALTER TABLE `photos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `positions`
--

DROP TABLE IF EXISTS `positions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `positions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `position` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `description` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `positions`
--

LOCK TABLES `positions` WRITE;
/*!40000 ALTER TABLE `positions` DISABLE KEYS */;
INSERT INTO `positions` VALUES (1,'Jefe de Desarrollo','Jefe de Desarrollo','2015-11-24 22:37:31','2015-11-24 22:37:31'),(2,'Jefe de Produccion','Jefe de Produccion','2015-11-24 22:45:59','2015-11-24 22:45:59'),(3,'Desarrollador','Desarrollador','2015-11-24 22:46:31','2015-11-24 22:46:31'),(4,'Production','Production','2015-11-24 22:46:46','2015-11-24 22:46:46');
/*!40000 ALTER TABLE `positions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product_pricings`
--

DROP TABLE IF EXISTS `product_pricings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `product_pricings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `product_id` int(11) DEFAULT NULL,
  `utility` float DEFAULT NULL,
  `type` enum('other','credit','cash') COLLATE utf8_unicode_ci DEFAULT NULL,
  `category` enum('a','b','c') COLLATE utf8_unicode_ci DEFAULT NULL,
  `sell_price` float DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product_pricings`
--

LOCK TABLES `product_pricings` WRITE;
/*!40000 ALTER TABLE `product_pricings` DISABLE KEYS */;
/*!40000 ALTER TABLE `product_pricings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `products`
--

DROP TABLE IF EXISTS `products`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `products` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `code` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `line_id` int(11) DEFAULT NULL,
  `subline_id` int(11) DEFAULT NULL,
  `category_id` int(11) DEFAULT NULL,
  `part_number` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `make` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `model` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `year` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `version` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `max_discount` int(11) DEFAULT NULL,
  `address` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `max_cant` int(11) DEFAULT NULL,
  `min_cant` int(11) DEFAULT NULL,
  `cost` float DEFAULT NULL,
  `bar_code` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `market_price` int(11) DEFAULT NULL,
  `status` enum('active','inactive','out_of_stock') COLLATE utf8_unicode_ci DEFAULT NULL,
  `stock` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `products`
--

LOCK TABLES `products` WRITE;
/*!40000 ALTER TABLE `products` DISABLE KEYS */;
/*!40000 ALTER TABLE `products` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `provinces`
--

DROP TABLE IF EXISTS `provinces`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `provinces` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `provinces`
--

LOCK TABLES `provinces` WRITE;
/*!40000 ALTER TABLE `provinces` DISABLE KEYS */;
/*!40000 ALTER TABLE `provinces` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `schema_migrations`
--

DROP TABLE IF EXISTS `schema_migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `schema_migrations` (
  `version` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  UNIQUE KEY `unique_schema_migrations` (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `schema_migrations`
--

LOCK TABLES `schema_migrations` WRITE;
/*!40000 ALTER TABLE `schema_migrations` DISABLE KEYS */;
INSERT INTO `schema_migrations` VALUES ('20120810200229'),('20120810201649'),('20120820215849'),('20120824191754'),('20120827202535'),('20120830181231'),('20120913203512'),('20120928002810'),('20121001204410'),('20121001204531'),('20121006180843'),('20121006181820'),('20121016183851'),('20121016190203'),('20121016210433'),('20121018181329'),('20121019175649'),('20121019175821'),('20121019180005'),('20121019210811'),('20121021205936'),('20121022154346'),('20121022184754'),('20121024204051'),('20121024204834'),('20121025204013'),('20121029011947'),('20121030200613'),('20121030231458'),('20121107224627'),('20121108184715'),('20121108223102'),('20121115054344'),('20121116164200'),('20121116164830'),('20121116165006'),('20121120185217'),('20121202235031'),('20121205003424'),('20121205003534'),('20121215104745'),('20121218165234'),('20130110005010'),('20130301161913'),('20130305203927'),('20130422200357'),('20130516213846'),('20130521160017'),('20130731210333'),('20130731210357'),('20130801160003'),('20131104215757'),('20141024203537'),('20141024213417'),('20141031214725'),('20141101001817'),('20141103214346'),('20141125161545'),('20150910165421'),('20151013200624'),('20151014154908');
/*!40000 ALTER TABLE `schema_migrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `session_validations`
--

DROP TABLE IF EXISTS `session_validations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `session_validations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `model_name_id` int(11) DEFAULT NULL,
  `reference_id` int(11) DEFAULT NULL,
  `ip_address` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_session_validations_on_user_id` (`user_id`),
  KEY `index_session_validations_on_model_name_id` (`model_name_id`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `session_validations`
--

LOCK TABLES `session_validations` WRITE;
/*!40000 ALTER TABLE `session_validations` DISABLE KEYS */;
INSERT INTO `session_validations` VALUES (1,1,11,1,'127.0.0.1','2015-11-24 22:25:54','2015-11-24 22:25:57'),(2,1,13,1,'127.0.0.1','2015-11-24 22:35:50','2015-11-24 22:36:06'),(3,1,4,1,'127.0.0.1','2015-11-24 22:44:48','2015-11-24 22:45:26'),(4,1,4,2,'127.0.0.1','2015-11-24 22:44:49','2015-11-24 22:47:13'),(5,1,4,3,'127.0.0.1','2015-11-24 22:47:26','2015-11-24 22:48:15'),(6,1,4,4,'127.0.0.1','2015-11-24 22:47:27','2015-11-24 22:48:32'),(7,1,4,5,'127.0.0.1','2015-11-24 22:47:28','2015-11-24 22:48:51'),(8,1,4,6,'127.0.0.1','2015-11-24 22:47:31','2015-11-24 22:49:07'),(9,1,4,7,'127.0.0.1','2015-11-24 22:47:33','2015-11-24 22:49:22'),(10,1,4,8,'127.0.0.1','2015-11-24 22:47:35','2015-11-24 22:50:02'),(11,1,4,9,'127.0.0.1','2015-11-24 22:50:30','2015-11-24 22:51:00'),(12,1,4,10,'127.0.0.1','2015-11-24 22:50:31','2015-11-24 22:51:17'),(13,1,4,11,'127.0.0.1','2015-11-24 22:50:32','2015-11-24 22:51:31'),(14,1,4,12,'127.0.0.1','2015-11-24 22:50:33','2015-11-24 22:51:43'),(15,1,4,13,'127.0.0.1','2015-11-24 22:50:34','2015-11-24 22:51:55'),(16,1,4,14,'127.0.0.1','2015-11-24 22:50:35','2015-11-24 22:52:08'),(17,1,4,15,'127.0.0.1','2015-11-24 22:50:35','2015-11-24 22:52:20');
/*!40000 ALTER TABLE `session_validations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sublines`
--

DROP TABLE IF EXISTS `sublines`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sublines` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `code` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `description` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sublines`
--

LOCK TABLES `sublines` WRITE;
/*!40000 ALTER TABLE `sublines` DISABLE KEYS */;
/*!40000 ALTER TABLE `sublines` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tasks`
--

DROP TABLE IF EXISTS `tasks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tasks` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `iactivity` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `itask` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ntask` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `iaccount` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `mlaborcost` decimal(10,2) DEFAULT NULL,
  `nunidad` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `unit_performance` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tasks`
--

LOCK TABLES `tasks` WRITE;
/*!40000 ALTER TABLE `tasks` DISABLE KEYS */;
INSERT INTO `tasks` VALUES (1,'0','0','Labores al gasto','5105',NULL,'Glb',NULL,'2015-11-24 22:18:11','2015-11-24 22:18:11'),(2,'1','1','Re-hoyado','721010',106.00,'dia',NULL,'2015-11-24 22:18:11','2015-11-24 22:18:11'),(3,'1','2','Resiembra','721010',106.00,'dia',NULL,'2015-11-24 22:18:11','2015-11-24 22:18:11'),(4,'1','3','Rompevientos y Barreras','721010',106.00,'dia',NULL,'2015-11-24 22:18:11','2015-11-24 22:18:11'),(5,'1','4','Siembra Temporal','721010',106.00,'dia',NULL,'2015-11-24 22:18:11','2015-11-24 22:18:11'),(6,'1','5','Siembra permanente','721010',106.00,'dia',NULL,'2015-11-24 22:18:11','2015-11-24 22:18:11'),(7,'1','6','Reg, Sombra Permanente','721010',106.00,'dia',NULL,'2015-11-24 22:18:11','2015-11-24 22:18:11'),(8,'1','7','Pica Sombra Permanente','721010',106.00,'dia',NULL,'2015-11-24 22:18:11','2015-11-24 22:18:11'),(9,'1','8','1a. Reg. Sombra Guineo','721010',106.00,'dia',NULL,'2015-11-24 22:18:11','2015-11-24 22:18:11'),(10,'1','9','2da. Reg. Sombra Guineo','721010',106.00,'dia',NULL,'2015-11-24 22:18:11','2015-11-24 22:18:11'),(11,'1','10','Zanjas de Drenajes','721010',106.00,'dia',NULL,'2015-11-24 22:18:11','2015-11-24 22:18:11'),(12,'1','11','1a. Chapia Pesada','721010',106.00,'dia',NULL,'2015-11-24 22:18:11','2015-11-24 22:18:11'),(13,'1','12','2a. Chapia Pesada','721010',106.00,'dia',NULL,'2015-11-24 22:18:11','2015-11-24 22:18:11'),(14,'1','13','1a. Carrila Pesada','721010',106.00,'dia',NULL,'2015-11-24 22:18:11','2015-11-24 22:18:11'),(15,'1','14','1a desbejuca','721010',106.00,'dia',NULL,'2015-11-24 22:18:11','2015-11-24 22:18:11'),(16,'1','15','2da desbejuca','721010',106.00,'dia',NULL,'2015-11-24 22:18:11','2015-11-24 22:18:11'),(17,'1','16','Ronda de Plantios','721010',106.00,'dia',NULL,'2015-11-24 22:18:11','2015-11-24 22:18:11'),(18,'1','17','Deshierba de Caminos','721010',106.00,'dia',NULL,'2015-11-24 22:18:11','2015-11-24 22:18:11'),(19,'1','18','1er. Deshije','721010',106.00,'dia',NULL,'2015-11-24 22:18:11','2015-11-24 22:18:11');
/*!40000 ALTER TABLE `tasks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `telephones`
--

DROP TABLE IF EXISTS `telephones`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `telephones` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `entity_id` int(11) DEFAULT NULL,
  `telephone` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `typephone` enum('personal','home','work') COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_telephones_on_entity_id` (`entity_id`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `telephones`
--

LOCK TABLES `telephones` WRITE;
/*!40000 ALTER TABLE `telephones` DISABLE KEYS */;
INSERT INTO `telephones` VALUES (1,1,NULL,NULL,'2015-11-24 22:17:55','2015-11-24 22:17:55'),(2,2,NULL,NULL,'2015-11-24 22:17:55','2015-11-24 22:17:55'),(3,3,NULL,NULL,'2015-11-24 22:17:55','2015-11-24 22:17:55'),(4,4,NULL,NULL,'2015-11-24 22:17:55','2015-11-24 22:17:55'),(5,5,NULL,NULL,'2015-11-24 22:17:55','2015-11-24 22:17:55'),(6,6,NULL,NULL,'2015-11-24 22:17:55','2015-11-24 22:17:55'),(7,7,NULL,NULL,'2015-11-24 22:17:55','2015-11-24 22:17:55'),(8,8,NULL,NULL,'2015-11-24 22:17:55','2015-11-24 22:17:55'),(9,9,NULL,NULL,'2015-11-24 22:17:55','2015-11-24 22:17:55'),(10,10,NULL,NULL,'2015-11-24 22:17:55','2015-11-24 22:17:55'),(11,11,NULL,NULL,'2015-11-24 22:17:55','2015-11-24 22:17:55'),(12,12,NULL,NULL,'2015-11-24 22:17:55','2015-11-24 22:17:55'),(13,13,NULL,NULL,'2015-11-24 22:17:55','2015-11-24 22:17:55'),(14,14,NULL,NULL,'2015-11-24 22:17:55','2015-11-24 22:17:55'),(15,15,NULL,NULL,'2015-11-24 22:17:55','2015-11-24 22:17:55'),(16,16,NULL,NULL,'2015-11-24 22:17:55','2015-11-24 22:17:55'),(17,17,NULL,NULL,'2015-11-24 22:17:55','2015-11-24 22:17:55'),(18,18,NULL,NULL,'2015-11-24 22:17:56','2015-11-24 22:17:56'),(19,19,NULL,NULL,'2015-11-24 22:17:56','2015-11-24 22:17:56');
/*!40000 ALTER TABLE `telephones` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `type_of_personnel_actions`
--

DROP TABLE IF EXISTS `type_of_personnel_actions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `type_of_personnel_actions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `description` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `type_of_personnel_actions`
--

LOCK TABLES `type_of_personnel_actions` WRITE;
/*!40000 ALTER TABLE `type_of_personnel_actions` DISABLE KEYS */;
/*!40000 ALTER TABLE `type_of_personnel_actions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `company_id` int(11) DEFAULT NULL,
  `email` varchar(255) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `encrypted_password` varchar(255) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `reset_password_token` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `reset_password_sent_at` datetime DEFAULT NULL,
  `remember_created_at` datetime DEFAULT NULL,
  `sign_in_count` int(11) DEFAULT '0',
  `current_sign_in_at` datetime DEFAULT NULL,
  `last_sign_in_at` datetime DEFAULT NULL,
  `current_sign_in_ip` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `last_sign_in_ip` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_users_on_email` (`email`),
  UNIQUE KEY `index_users_on_reset_password_token` (`reset_password_token`),
  KEY `index_users_on_company_id` (`company_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'admin','Admin User',1,'admin@dotcreek.com','$2a$10$MZVST5f.A/bLAAMA4bIhpeubxKlfgJ.8qHkWJSS1Ho89hIvWr0aOa',NULL,NULL,NULL,2,'2015-11-24 17:07:50','2015-11-24 15:53:36','127.0.0.1','127.0.0.1','2015-11-24 15:23:51','2015-11-24 22:17:41');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `vendors`
--

DROP TABLE IF EXISTS `vendors`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `vendors` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `entity_id` int(11) DEFAULT NULL,
  `credit_limit` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_vendors_on_entity_id` (`entity_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vendors`
--

LOCK TABLES `vendors` WRITE;
/*!40000 ALTER TABLE `vendors` DISABLE KEYS */;
/*!40000 ALTER TABLE `vendors` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `warehouses`
--

DROP TABLE IF EXISTS `warehouses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `warehouses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `code` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `description` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `manager` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `address` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `warehouses`
--

LOCK TABLES `warehouses` WRITE;
/*!40000 ALTER TABLE `warehouses` DISABLE KEYS */;
/*!40000 ALTER TABLE `warehouses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `work_benefits`
--

DROP TABLE IF EXISTS `work_benefits`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `work_benefits` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `company_id` int(11) DEFAULT NULL,
  `costs_center_id` int(11) DEFAULT NULL,
  `description` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `percentage` decimal(10,2) DEFAULT NULL,
  `debit_account` int(11) DEFAULT NULL,
  `credit_account` int(11) DEFAULT NULL,
  `beneficiary_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `is_beneficiary` tinyint(1) DEFAULT '1',
  `state` enum('completed','active') COLLATE utf8_unicode_ci DEFAULT 'active',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_work_benefits_on_company_id` (`company_id`),
  KEY `index_work_benefits_on_debit_account` (`debit_account`),
  KEY `index_work_benefits_on_credit_account` (`credit_account`),
  KEY `index_work_benefits_on_costs_center_id` (`costs_center_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `work_benefits`
--

LOCK TABLES `work_benefits` WRITE;
/*!40000 ALTER TABLE `work_benefits` DISABLE KEYS */;
/*!40000 ALTER TABLE `work_benefits` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `work_benefits_payments`
--

DROP TABLE IF EXISTS `work_benefits_payments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `work_benefits_payments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `employee_benefits_id` int(11) DEFAULT NULL,
  `payroll_id` int(11) DEFAULT NULL,
  `payment_date` date DEFAULT NULL,
  `percentage` decimal(10,2) DEFAULT NULL,
  `payment` decimal(10,2) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_work_benefits_payments_on_employee_benefits_id` (`employee_benefits_id`),
  KEY `index_work_benefits_payments_on_payroll_id` (`payroll_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `work_benefits_payments`
--

LOCK TABLES `work_benefits_payments` WRITE;
/*!40000 ALTER TABLE `work_benefits_payments` DISABLE KEYS */;
/*!40000 ALTER TABLE `work_benefits_payments` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2015-11-24 16:55:13
