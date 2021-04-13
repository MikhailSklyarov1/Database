-- MySQL dump 10.13  Distrib 8.0.23, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: schedule
-- ------------------------------------------------------
-- Server version	8.0.23

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `audiences`
--

DROP TABLE IF EXISTS `audiences`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `audiences` (
  `id_audience` int unsigned NOT NULL AUTO_INCREMENT,
  `number` int DEFAULT NULL,
  `floors` tinyint DEFAULT NULL,
  `id_campus` int unsigned NOT NULL,
  PRIMARY KEY (`id_audience`),
  UNIQUE KEY `number` (`number`),
  KEY `fk_audiences__campuses__id_campuses_1` (`id_campus`),
  CONSTRAINT `fk_audiences__campuses__id_campuses_1` FOREIGN KEY (`id_campus`) REFERENCES `campuses` (`id_campus`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `audiences`
--

LOCK TABLES `audiences` WRITE;
/*!40000 ALTER TABLE `audiences` DISABLE KEYS */;
INSERT INTO `audiences` VALUES (1,25,5,1),(2,26,5,1),(3,12,2,2);
/*!40000 ALTER TABLE `audiences` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `campuses`
--

DROP TABLE IF EXISTS `campuses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `campuses` (
  `id_campus` int unsigned NOT NULL AUTO_INCREMENT,
  `address` varchar(30) DEFAULT NULL,
  `name` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`id_campus`),
  UNIQUE KEY `name` (`name`),
  UNIQUE KEY `address` (`address`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `campuses`
--

LOCK TABLES `campuses` WRITE;
/*!40000 ALTER TABLE `campuses` DISABLE KEYS */;
INSERT INTO `campuses` VALUES (1,'Мира 152','высотный'),(2,'Мира 150','А');
/*!40000 ALTER TABLE `campuses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `departments`
--

DROP TABLE IF EXISTS `departments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `departments` (
  `id_department` int unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(30) DEFAULT NULL,
  `id_faculty` int unsigned NOT NULL,
  PRIMARY KEY (`id_department`),
  KEY `fk_departments__faculty__id_faculty_1` (`id_faculty`),
  CONSTRAINT `fk_departments__faculty__id_faculty_1` FOREIGN KEY (`id_faculty`) REFERENCES `faculties` (`id_faculty`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `departments`
--

LOCK TABLES `departments` WRITE;
/*!40000 ALTER TABLE `departments` DISABLE KEYS */;
INSERT INTO `departments` VALUES (1,'компьютерное проектирование',1),(2,'схемотехника',2);
/*!40000 ALTER TABLE `departments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `education_type`
--

DROP TABLE IF EXISTS `education_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `education_type` (
  `id_education_type` int unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(30) DEFAULT NULL,
  `description` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`id_education_type`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `education_type`
--

LOCK TABLES `education_type` WRITE;
/*!40000 ALTER TABLE `education_type` DISABLE KEYS */;
INSERT INTO `education_type` VALUES (1,'очное обучение','пары каждую неделю'),(2,'заочное обучение','сдача работ в указанный срок');
/*!40000 ALTER TABLE `education_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `faculties`
--

DROP TABLE IF EXISTS `faculties`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `faculties` (
  `id_faculty` int unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(10) NOT NULL,
  PRIMARY KEY (`id_faculty`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `faculties`
--

LOCK TABLES `faculties` WRITE;
/*!40000 ALTER TABLE `faculties` DISABLE KEYS */;
INSERT INTO `faculties` VALUES (1,'ФЭИИТ'),(2,'ЭТ');
/*!40000 ALTER TABLE `faculties` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `groups`
--

DROP TABLE IF EXISTS `groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `groups` (
  `id_group` int unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(10) DEFAULT NULL,
  `course_number` tinyint DEFAULT NULL,
  `id_faculty` int unsigned NOT NULL,
  `id_education_type` int unsigned NOT NULL,
  PRIMARY KEY (`id_group`),
  UNIQUE KEY `name` (`name`),
  KEY `fk_groups__faculty__id_faculty_1` (`id_faculty`),
  KEY `fk_groups__education_type__id_education_type_1` (`id_education_type`),
  CONSTRAINT `fk_groups__education_type__id_education_type_1` FOREIGN KEY (`id_education_type`) REFERENCES `education_type` (`id_education_type`),
  CONSTRAINT `fk_groups__faculty__id_faculty_1` FOREIGN KEY (`id_faculty`) REFERENCES `faculties` (`id_faculty`),
  CONSTRAINT `groups_chk_1` CHECK ((`course_number` <= 4))
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `groups`
--

LOCK TABLES `groups` WRITE;
/*!40000 ALTER TABLE `groups` DISABLE KEYS */;
INSERT INTO `groups` VALUES (1,'ИТ-25',1,1,1),(2,'ИТ-27',2,1,1);
/*!40000 ALTER TABLE `groups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lessons`
--

DROP TABLE IF EXISTS `lessons`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `lessons` (
  `id_lesson` int unsigned NOT NULL AUTO_INCREMENT,
  `date` date DEFAULT NULL,
  `subgroup` varchar(30) DEFAULT NULL,
  `id_group` int unsigned NOT NULL,
  `id_audience` int unsigned NOT NULL,
  `id_subject` int unsigned NOT NULL,
  `id_type` int unsigned NOT NULL,
  `id_time_number` int unsigned NOT NULL,
  `id_teacher` int unsigned DEFAULT NULL,
  PRIMARY KEY (`id_lesson`),
  KEY `fk_lessons__groups__id_group_1` (`id_group`),
  KEY `fk_lessons__audiences__id_audiences_1` (`id_audience`),
  KEY `fk_lessons__subject__id_subject_1` (`id_subject`),
  KEY `fk_lessons__type__id_type_1` (`id_type`),
  KEY `fk_lessons__time_number__id_time_number_1` (`id_time_number`),
  KEY `id_teacher` (`id_teacher`),
  CONSTRAINT `fk_lessons__audiences__id_audiences_1` FOREIGN KEY (`id_audience`) REFERENCES `audiences` (`id_audience`),
  CONSTRAINT `fk_lessons__groups__id_group_1` FOREIGN KEY (`id_group`) REFERENCES `groups` (`id_group`),
  CONSTRAINT `fk_lessons__subject__id_subject_1` FOREIGN KEY (`id_subject`) REFERENCES `subjects` (`id_subject`),
  CONSTRAINT `fk_lessons__time_number__id_time_number_1` FOREIGN KEY (`id_time_number`) REFERENCES `time_numbers` (`id_time_number`),
  CONSTRAINT `fk_lessons__type__id_type_1` FOREIGN KEY (`id_type`) REFERENCES `types` (`id_type`),
  CONSTRAINT `lessons_ibfk_1` FOREIGN KEY (`id_teacher`) REFERENCES `teachers` (`id_teacher`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `lessons`
--

LOCK TABLES `lessons` WRITE;
/*!40000 ALTER TABLE `lessons` DISABLE KEYS */;
INSERT INTO `lessons` VALUES (1,'2021-04-14','утренняя',1,1,1,1,1,NULL),(2,'2021-04-14','вечерняя',1,1,1,1,2,NULL),(3,'2021-04-15','вечерняя',2,1,2,1,2,NULL);
/*!40000 ALTER TABLE `lessons` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `subjects`
--

DROP TABLE IF EXISTS `subjects`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `subjects` (
  `id_subject` int unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(30) DEFAULT NULL,
  `description` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id_subject`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `subjects`
--

LOCK TABLES `subjects` WRITE;
/*!40000 ALTER TABLE `subjects` DISABLE KEYS */;
INSERT INTO `subjects` VALUES (1,'Программирование','основы программирования на языке C++'),(2,'Электротехника','электротехника.начальный курс');
/*!40000 ALTER TABLE `subjects` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `teachers`
--

DROP TABLE IF EXISTS `teachers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `teachers` (
  `id_teacher` int unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(50) DEFAULT NULL,
  `experience` tinyint DEFAULT NULL,
  `id_department` int unsigned NOT NULL,
  PRIMARY KEY (`id_teacher`),
  KEY `fk_teachers__department__id_department_1` (`id_department`),
  CONSTRAINT `fk_teachers__department__id_department_1` FOREIGN KEY (`id_department`) REFERENCES `departments` (`id_department`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `teachers`
--

LOCK TABLES `teachers` WRITE;
/*!40000 ALTER TABLE `teachers` DISABLE KEYS */;
INSERT INTO `teachers` VALUES (1,'Иванов П.Г.',3,1),(2,'Петров И.И.',6,2);
/*!40000 ALTER TABLE `teachers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `teachers_to_departments`
--

DROP TABLE IF EXISTS `teachers_to_departments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `teachers_to_departments` (
  `id_teacher` int unsigned NOT NULL,
  `id_department` int unsigned NOT NULL,
  `working_rate` double DEFAULT NULL,
  PRIMARY KEY (`id_teacher`,`id_department`),
  KEY `fk_teachers_to_departments__departments__id_department_1` (`id_department`),
  CONSTRAINT `fk_teachers_to_departments__departments__id_department_1` FOREIGN KEY (`id_department`) REFERENCES `departments` (`id_department`),
  CONSTRAINT `fk_teachers_to_departments__teachers__id_teacher_1` FOREIGN KEY (`id_teacher`) REFERENCES `teachers` (`id_teacher`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `teachers_to_departments`
--

LOCK TABLES `teachers_to_departments` WRITE;
/*!40000 ALTER TABLE `teachers_to_departments` DISABLE KEYS */;
INSERT INTO `teachers_to_departments` VALUES (1,1,0.5),(2,2,1);
/*!40000 ALTER TABLE `teachers_to_departments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `teachers_to_subjects`
--

DROP TABLE IF EXISTS `teachers_to_subjects`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `teachers_to_subjects` (
  `id_teacher` int unsigned NOT NULL,
  `id_subject` int unsigned NOT NULL,
  PRIMARY KEY (`id_teacher`,`id_subject`),
  KEY `fk_teachers_to_subjects__subjects__id_subject_1` (`id_subject`),
  CONSTRAINT `fk_teachers_to_subjects__subjects__id_subject_1` FOREIGN KEY (`id_subject`) REFERENCES `lessons` (`id_subject`),
  CONSTRAINT `fk_teachers_to_subjects__teachers__id_teacher_1` FOREIGN KEY (`id_teacher`) REFERENCES `teachers` (`id_teacher`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `teachers_to_subjects`
--

LOCK TABLES `teachers_to_subjects` WRITE;
/*!40000 ALTER TABLE `teachers_to_subjects` DISABLE KEYS */;
INSERT INTO `teachers_to_subjects` VALUES (1,1),(2,2);
/*!40000 ALTER TABLE `teachers_to_subjects` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `time_numbers`
--

DROP TABLE IF EXISTS `time_numbers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `time_numbers` (
  `id_time_number` int unsigned NOT NULL AUTO_INCREMENT,
  `start_time` time DEFAULT NULL,
  `end_time` time DEFAULT NULL,
  PRIMARY KEY (`id_time_number`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `time_numbers`
--

LOCK TABLES `time_numbers` WRITE;
/*!40000 ALTER TABLE `time_numbers` DISABLE KEYS */;
INSERT INTO `time_numbers` VALUES (1,'08:00:00','09:30:00'),(2,'09:40:00','11:10:00');
/*!40000 ALTER TABLE `time_numbers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `types`
--

DROP TABLE IF EXISTS `types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `types` (
  `id_type` int unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(30) DEFAULT NULL,
  `description` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id_type`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `types`
--

LOCK TABLES `types` WRITE;
/*!40000 ALTER TABLE `types` DISABLE KEYS */;
INSERT INTO `types` VALUES (1,'лекция','преподаватель объясняет материал'),(2,'практика','закрепление пройденного материала'),(3,'лабораторная работа','самостоятельная работа студента');
/*!40000 ALTER TABLE `types` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2021-04-13 23:25:56
