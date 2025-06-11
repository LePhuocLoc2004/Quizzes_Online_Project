-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1:3308
-- Generation Time: Mar 08, 2025 at 08:39 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `quizz_app`
--

-- --------------------------------------------------------

--
-- Table structure for table `answers`
--

CREATE TABLE `answers` (
  `answer_id` bigint(20) NOT NULL,
  `question_id` bigint(20) DEFAULT NULL,
  `answer_text` text NOT NULL,
  `is_correct` tinyint(1) DEFAULT 0,
  `order_index` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `deleted_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `answers`
--

INSERT INTO `answers` (`answer_id`, `question_id`, `answer_text`, `is_correct`, `order_index`, `created_at`, `deleted_at`) VALUES
(1, 1, 'A programming language', 1, 1, '2025-02-21 20:16:13', NULL),
(2, 1, 'A type of coffee', 0, 2, '2025-02-21 20:16:13', NULL),
(3, 1, 'An operating system', 0, 3, '2025-02-21 20:16:13', NULL),
(4, 1, 'A database', 0, 4, '2025-02-21 20:16:13', NULL),
(5, 2, 'class', 1, 1, '2025-02-21 20:16:13', NULL),
(6, 2, 'static', 1, 2, '2025-02-21 20:16:13', NULL),
(7, 2, 'array', 0, 3, '2025-02-21 20:16:13', NULL),
(8, 2, 'void', 1, 4, '2025-02-21 20:16:13', NULL),
(9, 3, 'True', 1, 1, '2025-02-21 20:16:13', NULL),
(10, 3, 'False', 0, 2, '2025-02-21 20:16:13', NULL),
(11, 4, 'public static void main(String[] args)', 1, 1, '2025-02-21 20:16:13', NULL),
(12, 4, 'public void main(String[] args)', 0, 2, '2025-02-21 20:16:13', NULL),
(13, 4, 'void main()', 0, 3, '2025-02-21 20:16:13', NULL),
(14, 4, 'static void main()', 0, 4, '2025-02-21 20:16:13', NULL),
(15, 5, 'myVariable', 1, 1, '2025-02-21 20:16:13', NULL),
(16, 5, '_value', 1, 2, '2025-02-21 20:16:13', NULL),
(17, 5, '2variable', 0, 3, '2025-02-21 20:16:13', NULL),
(18, 5, '$price', 1, 4, '2025-02-21 20:16:13', NULL),
(19, 6, 'True', 0, 1, '2025-02-21 20:16:13', NULL),
(20, 6, 'False', 1, 2, '2025-02-21 20:16:13', NULL),
(21, 7, '0', 1, 1, '2025-02-21 20:16:13', NULL),
(22, 7, 'null', 0, 2, '2025-02-21 20:16:13', NULL),
(23, 7, '1', 0, 3, '2025-02-21 20:16:13', NULL),
(24, 7, 'undefined', 0, 4, '2025-02-21 20:16:13', NULL),
(25, 8, 'public', 1, 1, '2025-02-21 20:16:13', NULL),
(26, 8, 'private', 1, 2, '2025-02-21 20:16:13', NULL),
(27, 8, 'protected', 1, 3, '2025-02-21 20:16:13', NULL),
(28, 8, 'friend', 0, 4, '2025-02-21 20:16:13', NULL),
(29, 9, 'True', 0, 1, '2025-02-21 20:16:13', NULL),
(30, 9, 'False', 1, 2, '2025-02-21 20:16:13', NULL),
(31, 10, '8 bytes', 1, 1, '2025-02-21 20:16:13', NULL),
(32, 10, '4 bytes', 0, 2, '2025-02-21 20:16:13', NULL),
(33, 10, '2 bytes', 0, 3, '2025-02-21 20:16:13', NULL),
(34, 10, '16 bytes', 0, 4, '2025-02-21 20:16:13', NULL),
(35, 11, 'True', 1, 1, '2025-02-21 20:16:13', NULL),
(36, 11, 'False', 0, 2, '2025-02-21 20:16:13', NULL),
(37, 12, 'pip', 1, 1, '2025-02-21 20:16:13', NULL),
(38, 12, 'npm', 0, 2, '2025-02-21 20:16:13', NULL),
(39, 12, 'yarn', 0, 3, '2025-02-21 20:16:13', NULL),
(40, 12, 'gradle', 0, 4, '2025-02-21 20:16:13', NULL),
(41, 13, 'int', 1, 1, '2025-02-21 20:16:13', NULL),
(42, 13, 'str', 1, 2, '2025-02-21 20:16:13', NULL),
(43, 13, 'list', 1, 3, '2025-02-21 20:16:13', NULL),
(44, 13, 'array', 0, 4, '2025-02-21 20:16:13', NULL),
(45, 14, 'True', 1, 1, '2025-02-21 20:16:13', NULL),
(46, 14, 'False', 0, 2, '2025-02-21 20:16:13', NULL),
(47, 15, '.py', 1, 1, '2025-02-21 20:16:13', NULL),
(48, 15, '.python', 0, 2, '2025-02-21 20:16:13', NULL),
(49, 15, '.pt', 0, 3, '2025-02-21 20:16:13', NULL),
(50, 15, '.pyt', 0, 4, '2025-02-21 20:16:13', NULL),
(51, 16, 'def', 1, 1, '2025-02-21 20:16:13', NULL),
(52, 16, 'if', 1, 2, '2025-02-21 20:16:13', NULL),
(53, 16, 'function', 0, 3, '2025-02-21 20:16:13', NULL),
(54, 16, 'while', 1, 4, '2025-02-21 20:16:13', NULL),
(55, 17, 'True', 1, 1, '2025-02-21 20:16:13', NULL),
(56, 17, 'False', 0, 2, '2025-02-21 20:16:13', NULL),
(57, 18, 'def function_name():', 1, 1, '2025-02-21 20:16:13', NULL),
(58, 18, 'function function_name():', 0, 2, '2025-02-21 20:16:13', NULL),
(59, 18, 'func function_name():', 0, 3, '2025-02-21 20:16:13', NULL),
(60, 18, 'define function_name():', 0, 4, '2025-02-21 20:16:13', NULL),
(61, 19, '2', 1, 1, '2025-02-21 20:16:13', NULL),
(62, 19, '3', 0, 2, '2025-02-21 20:16:13', NULL),
(63, 19, '4', 0, 3, '2025-02-21 20:16:13', NULL),
(64, 19, '5', 0, 4, '2025-02-21 20:16:13', NULL),
(65, 20, '5 + 5', 1, 1, '2025-02-21 20:16:13', NULL),
(66, 20, '2 * 5', 1, 2, '2025-02-21 20:16:13', NULL),
(67, 20, '15 - 5', 1, 3, '2025-02-21 20:16:13', NULL),
(68, 20, '3 * 4', 0, 4, '2025-02-21 20:16:13', NULL),
(69, 21, 'True', 1, 1, '2025-02-21 20:16:13', NULL),
(70, 21, 'False', 0, 2, '2025-02-21 20:16:13', NULL),
(71, 22, '4', 1, 1, '2025-02-21 20:16:13', NULL),
(72, 22, '3', 0, 2, '2025-02-21 20:16:13', NULL),
(73, 22, '5', 0, 3, '2025-02-21 20:16:13', NULL),
(74, 22, '6', 0, 4, '2025-02-21 20:16:13', NULL),
(75, 23, 'x² + 2x + 1', 1, 1, '2025-02-21 20:16:13', NULL),
(76, 23, '2x² - 3x + 4', 1, 2, '2025-02-21 20:16:13', NULL),
(77, 23, '3x + 2', 0, 3, '2025-02-21 20:16:13', NULL),
(78, 23, '5x³ + 2x² + 1', 0, 4, '2025-02-21 20:16:13', NULL),
(79, 24, 'True', 0, 1, '2025-02-21 20:16:13', NULL),
(80, 24, 'False', 1, 2, '2025-02-21 20:16:13', NULL),
(81, 25, '9', 1, 1, '2025-02-21 20:16:13', NULL),
(82, 25, '6', 0, 2, '2025-02-21 20:16:13', NULL),
(83, 25, '3', 0, 3, '2025-02-21 20:16:13', NULL),
(84, 25, '12', 0, 4, '2025-02-21 20:16:13', NULL),
(85, 26, 'length × width', 1, 1, '2025-02-21 20:16:13', NULL),
(86, 26, 'length + width', 0, 2, '2025-02-21 20:16:13', NULL),
(87, 26, '2(length + width)', 0, 3, '2025-02-21 20:16:13', NULL),
(88, 26, 'length² + width²', 0, 4, '2025-02-21 20:16:13', NULL),
(89, 27, 'Triangle', 1, 1, '2025-02-21 20:16:13', NULL),
(90, 27, 'Square', 1, 2, '2025-02-21 20:16:13', NULL),
(91, 27, 'Circle', 0, 3, '2025-02-21 20:16:13', NULL),
(92, 27, 'Pentagon', 1, 4, '2025-02-21 20:16:13', NULL),
(93, 28, 'True', 1, 1, '2025-02-21 20:16:13', NULL),
(94, 28, 'False', 0, 2, '2025-02-21 20:16:13', NULL),
(95, 29, '180 degrees', 1, 1, '2025-02-21 20:16:13', NULL),
(96, 29, '360 degrees', 0, 2, '2025-02-21 20:16:13', NULL),
(97, 29, '90 degrees', 0, 3, '2025-02-21 20:16:13', NULL),
(98, 29, '270 degrees', 0, 4, '2025-02-21 20:16:13', NULL),
(99, 30, 'Equilateral', 1, 1, '2025-02-21 20:16:13', NULL),
(100, 30, 'Isosceles', 1, 2, '2025-02-21 20:16:13', NULL),
(101, 30, 'Scalene', 1, 3, '2025-02-21 20:16:13', NULL),
(102, 30, 'Circular', 0, 4, '2025-02-21 20:16:13', NULL),
(103, 31, 'True', 0, 1, '2025-02-21 20:16:13', NULL),
(104, 31, 'False', 1, 2, '2025-02-21 20:16:13', NULL),
(105, 32, '2πr', 1, 1, '2025-02-21 20:16:13', NULL),
(106, 32, 'πr²', 0, 2, '2025-02-21 20:16:13', NULL),
(107, 32, '2πr²', 0, 3, '2025-02-21 20:16:13', NULL),
(108, 32, 'π²r', 0, 4, '2025-02-21 20:16:13', NULL),
(109, 33, 'Opposite sides are parallel', 1, 1, '2025-02-21 20:16:13', NULL),
(110, 33, 'Opposite angles are equal', 1, 2, '2025-02-21 20:16:13', NULL),
(111, 33, 'All angles are 90 degrees', 0, 3, '2025-02-21 20:16:13', NULL),
(112, 33, 'Opposite sides are equal', 1, 4, '2025-02-21 20:16:13', NULL),
(113, 34, 'Newton', 1, 1, '2025-02-21 20:16:13', NULL),
(114, 34, 'Joule', 0, 2, '2025-02-21 20:16:13', NULL),
(115, 34, 'Watt', 0, 3, '2025-02-21 20:16:13', NULL),
(116, 34, 'Pascal', 0, 4, '2025-02-21 20:16:13', NULL),
(117, 35, 'Temperature', 1, 1, '2025-02-21 20:16:13', NULL),
(118, 35, 'Mass', 1, 2, '2025-02-21 20:16:13', NULL),
(119, 35, 'Velocity', 0, 3, '2025-02-21 20:16:13', NULL),
(120, 35, 'Time', 1, 4, '2025-02-21 20:16:13', NULL),
(121, 36, 'True', 1, 1, '2025-02-21 20:16:13', NULL),
(122, 36, 'False', 0, 2, '2025-02-21 20:16:13', NULL),
(123, 37, 'F = ma', 1, 1, '2025-02-21 20:16:13', NULL),
(124, 37, 'F = mv', 0, 2, '2025-02-21 20:16:13', NULL),
(125, 37, 'F = mg', 0, 3, '2025-02-21 20:16:13', NULL),
(126, 37, 'F = mc²', 0, 4, '2025-02-21 20:16:13', NULL),
(127, 38, 'Kinetic', 1, 1, '2025-02-21 20:16:13', NULL),
(128, 38, 'Potential', 1, 2, '2025-02-21 20:16:13', NULL),
(129, 38, 'Thermal', 1, 3, '2025-02-21 20:16:13', NULL),
(130, 38, 'Motion', 0, 4, '2025-02-21 20:16:13', NULL),
(131, 39, 'True', 1, 1, '2025-02-21 20:16:13', NULL),
(132, 39, 'False', 0, 2, '2025-02-21 20:16:13', NULL),
(133, 40, 'Ampere', 1, 1, '2025-02-21 20:16:13', NULL),
(134, 40, 'Volt', 0, 2, '2025-02-21 20:16:13', NULL),
(135, 40, 'Watt', 0, 3, '2025-02-21 20:16:13', NULL),
(136, 40, 'Ohm', 0, 4, '2025-02-21 20:16:13', NULL),
(137, 41, 'A programming language for web development', 1, 1, '2025-02-21 20:16:14', NULL),
(138, 41, 'A markup language', 0, 2, '2025-02-21 20:16:14', NULL),
(139, 41, 'A database system', 0, 3, '2025-02-21 20:16:14', NULL),
(140, 41, 'An operating system', 0, 4, '2025-02-21 20:16:14', NULL),
(141, 42, 'string', 1, 1, '2025-02-21 20:16:14', NULL),
(142, 42, 'number', 1, 2, '2025-02-21 20:16:14', NULL),
(143, 42, 'boolean', 1, 3, '2025-02-21 20:16:14', NULL),
(144, 42, 'char', 0, 4, '2025-02-21 20:16:14', NULL),
(145, 43, 'True', 1, 1, '2025-02-21 20:16:14', NULL),
(146, 43, 'False', 0, 2, '2025-02-21 20:16:14', NULL),
(147, 44, 'let x = 5;', 1, 1, '2025-02-21 20:16:14', NULL),
(148, 44, 'variable x = 5;', 0, 2, '2025-02-21 20:16:14', NULL),
(149, 44, 'int x = 5;', 0, 3, '2025-02-21 20:16:14', NULL),
(150, 44, 'x := 5;', 0, 4, '2025-02-21 20:16:14', NULL),
(151, 45, 'push()', 1, 1, '2025-02-21 20:16:14', NULL),
(152, 45, 'pop()', 1, 2, '2025-02-21 20:16:14', NULL),
(153, 45, 'shift()', 1, 3, '2025-02-21 20:16:14', NULL),
(154, 45, 'remove()', 0, 4, '2025-02-21 20:16:14', NULL),
(155, 46, 'True', 0, 1, '2025-02-21 20:16:14', NULL),
(156, 46, 'False', 1, 2, '2025-02-21 20:16:14', NULL),
(157, 47, 'Check data type of a value', 1, 1, '2025-02-21 20:16:14', NULL),
(158, 47, 'Convert data types', 0, 2, '2025-02-21 20:16:14', NULL),
(159, 47, 'Create new types', 0, 3, '2025-02-21 20:16:14', NULL),
(160, 47, 'Compare types', 0, 4, '2025-02-21 20:16:14', NULL),
(161, 48, 'Object literal {}', 1, 1, '2025-02-21 20:16:14', NULL),
(162, 48, 'new Object()', 1, 2, '2025-02-21 20:16:14', NULL),
(163, 48, 'Object.create()', 1, 3, '2025-02-21 20:16:14', NULL),
(164, 48, 'make.object()', 0, 4, '2025-02-21 20:16:14', NULL),
(165, 49, 'Document Object Model', 1, 1, '2025-02-21 20:16:14', NULL),
(166, 49, 'Data Object Model', 0, 2, '2025-02-21 20:16:14', NULL),
(167, 49, 'Document Oriented Model', 0, 3, '2025-02-21 20:16:14', NULL),
(168, 49, 'Data Oriented Markup', 0, 4, '2025-02-21 20:16:14', NULL),
(169, 50, 'Structured Query Language', 1, 1, '2025-02-21 20:16:14', NULL),
(170, 50, 'System Query Language', 0, 2, '2025-02-21 20:16:14', NULL),
(171, 50, 'Simple Query Language', 0, 3, '2025-02-21 20:16:14', NULL),
(172, 50, 'Standard Query Logic', 0, 4, '2025-02-21 20:16:14', NULL),
(173, 51, 'SELECT', 1, 1, '2025-02-21 20:16:14', NULL),
(174, 51, 'INSERT', 1, 2, '2025-02-21 20:16:14', NULL),
(175, 51, 'UPDATE', 1, 3, '2025-02-21 20:16:14', NULL),
(176, 51, 'MODIFY', 0, 4, '2025-02-21 20:16:14', NULL),
(177, 52, 'True', 0, 1, '2025-02-21 20:16:14', NULL),
(178, 52, 'False', 1, 2, '2025-02-21 20:16:14', NULL),
(179, 53, 'SELECT', 1, 1, '2025-02-21 20:16:14', NULL),
(180, 53, 'FETCH', 0, 2, '2025-02-21 20:16:14', NULL),
(181, 53, 'GET', 0, 3, '2025-02-21 20:16:14', NULL),
(182, 53, 'RETRIEVE', 0, 4, '2025-02-21 20:16:14', NULL),
(183, 54, 'INNER JOIN', 1, 1, '2025-02-21 20:16:14', NULL),
(184, 54, 'LEFT JOIN', 1, 2, '2025-02-21 20:16:14', NULL),
(185, 54, 'RIGHT JOIN', 1, 3, '2025-02-21 20:16:14', NULL),
(186, 54, 'MIDDLE JOIN', 0, 4, '2025-02-21 20:16:14', NULL),
(187, 55, 'Remove duplicate values', 1, 1, '2025-02-21 20:16:14', NULL),
(188, 55, 'Sort values', 0, 2, '2025-02-21 20:16:14', NULL),
(189, 55, 'Filter values', 0, 3, '2025-02-21 20:16:14', NULL),
(190, 55, 'Count values', 0, 4, '2025-02-21 20:16:14', NULL),
(191, 56, 'COUNT', 1, 1, '2025-02-21 20:16:14', NULL),
(192, 56, 'SUM', 1, 2, '2025-02-21 20:16:14', NULL),
(193, 56, 'AVG', 1, 3, '2025-02-21 20:16:14', NULL),
(194, 56, 'COMBINE', 0, 4, '2025-02-21 20:16:14', NULL),
(195, 57, 'Unique identifier for a record', 1, 1, '2025-02-21 20:16:14', NULL),
(196, 57, 'First column in table', 0, 2, '2025-02-21 20:16:14', NULL),
(197, 57, 'Most important data', 0, 3, '2025-02-21 20:16:14', NULL),
(198, 57, 'Auto-generated number', 0, 4, '2025-02-21 20:16:14', NULL),
(199, 58, 'Rate of change of a function', 1, 1, '2025-02-21 20:16:14', NULL),
(200, 58, 'Area under a curve', 0, 2, '2025-02-21 20:16:14', NULL),
(201, 58, 'Sum of all numbers', 0, 3, '2025-02-21 20:16:14', NULL),
(202, 58, 'Product of functions', 0, 4, '2025-02-21 20:16:14', NULL),
(203, 59, 'Antiderivative', 1, 1, '2025-02-21 20:16:14', NULL),
(204, 59, 'Definite integral', 1, 2, '2025-02-21 20:16:14', NULL),
(205, 59, 'Indefinite integral', 1, 3, '2025-02-21 20:16:14', NULL),
(206, 59, 'Differential equation', 0, 4, '2025-02-21 20:16:14', NULL),
(207, 60, 'True', 0, 1, '2025-02-21 20:16:14', NULL),
(208, 60, 'False', 1, 2, '2025-02-21 20:16:14', NULL),
(209, 61, '2x', 1, 1, '2025-02-21 20:16:14', NULL),
(210, 61, 'x', 0, 2, '2025-02-21 20:16:14', NULL),
(211, 61, '2', 0, 3, '2025-02-21 20:16:14', NULL),
(212, 61, 'x²', 0, 4, '2025-02-21 20:16:14', NULL),
(213, 62, 'One-sided limit', 1, 1, '2025-02-21 20:16:14', NULL),
(214, 62, 'Two-sided limit', 1, 2, '2025-02-21 20:16:14', NULL),
(215, 62, 'Infinite limit', 1, 3, '2025-02-21 20:16:14', NULL),
(216, 62, 'Zero limit', 0, 4, '2025-02-21 20:16:14', NULL),
(217, 63, 'Differentiate composite functions', 1, 1, '2025-02-21 20:16:14', NULL),
(218, 63, 'Add functions', 0, 2, '2025-02-21 20:16:14', NULL),
(219, 63, 'Multiply functions', 0, 3, '2025-02-21 20:16:14', NULL),
(220, 63, 'Divide functions', 0, 4, '2025-02-21 20:16:14', NULL),
(221, 64, 'Integration by parts', 1, 1, '2025-02-21 20:16:14', NULL),
(222, 64, 'Substitution method', 1, 2, '2025-02-21 20:16:14', NULL),
(223, 64, 'Partial fractions', 1, 3, '2025-02-21 20:16:14', NULL),
(224, 64, 'Division method', 0, 4, '2025-02-21 20:16:14', NULL),
(225, 65, 'Point where function reaches highest value locally', 1, 1, '2025-02-21 20:16:14', NULL),
(226, 65, 'Highest point of function', 0, 2, '2025-02-21 20:16:14', NULL),
(227, 65, 'Starting point of function', 0, 3, '2025-02-21 20:16:14', NULL),
(228, 65, 'End point of function', 0, 4, '2025-02-21 20:16:14', NULL),
(229, 66, 'Rate of change', 1, 1, '2025-02-21 20:16:14', NULL),
(230, 66, 'Total change', 0, 2, '2025-02-21 20:16:14', NULL),
(231, 66, 'Average value', 0, 3, '2025-02-21 20:16:14', NULL),
(232, 66, 'Final value', 0, 4, '2025-02-21 20:16:14', NULL),
(233, 67, 'True', 1, 1, '2025-02-21 20:16:14', NULL),
(234, 67, 'False', 0, 2, '2025-02-21 20:16:14', NULL),
(235, 68, 'Smallest unit of matter', 1, 1, '2025-02-21 20:16:14', NULL),
(236, 68, 'Smallest living thing', 0, 2, '2025-02-21 20:16:14', NULL),
(237, 68, 'Type of molecule', 0, 3, '2025-02-21 20:16:14', NULL),
(238, 68, 'Part of a cell', 0, 4, '2025-02-21 20:16:14', NULL),
(239, 69, 'Helium', 1, 1, '2025-02-21 20:16:14', NULL),
(240, 69, 'Neon', 1, 2, '2025-02-21 20:16:14', NULL),
(241, 69, 'Argon', 1, 3, '2025-02-21 20:16:14', NULL),
(242, 69, 'Oxygen', 0, 4, '2025-02-21 20:16:14', NULL),
(243, 70, 'True', 1, 1, '2025-02-21 20:16:14', NULL),
(244, 70, 'False', 0, 2, '2025-02-21 20:16:14', NULL),
(245, 71, '1', 1, 1, '2025-02-21 20:16:14', NULL),
(246, 71, '2', 0, 2, '2025-02-21 20:16:14', NULL),
(247, 71, '3', 0, 3, '2025-02-21 20:16:14', NULL),
(248, 71, '4', 0, 4, '2025-02-21 20:16:14', NULL),
(249, 72, 'Covalent', 1, 1, '2025-02-21 20:16:14', NULL),
(250, 72, 'Ionic', 1, 2, '2025-02-21 20:16:14', NULL),
(251, 72, 'Metallic', 1, 3, '2025-02-21 20:16:14', NULL),
(252, 72, 'Magnetic', 0, 4, '2025-02-21 20:16:14', NULL),
(253, 73, '0 to 14', 1, 1, '2025-02-21 20:16:14', NULL),
(254, 73, '-1 to 15', 0, 2, '2025-02-21 20:16:14', NULL),
(255, 73, '1 to 10', 0, 3, '2025-02-21 20:16:14', NULL),
(256, 73, '0 to 10', 0, 4, '2025-02-21 20:16:14', NULL),
(257, 74, 'Solid', 1, 1, '2025-02-21 20:16:14', NULL),
(258, 74, 'Liquid', 1, 2, '2025-02-21 20:16:14', NULL),
(259, 74, 'Gas', 1, 3, '2025-02-21 20:16:14', NULL),
(260, 74, 'Energy', 0, 4, '2025-02-21 20:16:14', NULL),
(261, 75, 'Group of atoms bonded together', 1, 1, '2025-02-21 20:16:14', NULL),
(262, 75, 'Single atom', 0, 2, '2025-02-21 20:16:14', NULL),
(263, 75, 'Type of element', 0, 3, '2025-02-21 20:16:14', NULL),
(264, 75, 'Form of energy', 0, 4, '2025-02-21 20:16:14', NULL),
(265, 76, 'True', 0, 1, '2025-02-21 20:16:14', NULL),
(266, 76, 'False', 1, 2, '2025-02-21 20:16:14', NULL),
(267, 77, 'Basic unit of life', 1, 1, '2025-02-21 20:16:14', NULL),
(268, 77, 'Type of tissue', 0, 2, '2025-02-21 20:16:14', NULL),
(269, 77, 'Part of an organ', 0, 3, '2025-02-21 20:16:14', NULL),
(270, 77, 'Chemical compound', 0, 4, '2025-02-21 20:16:14', NULL),
(271, 78, 'Mitochondria', 1, 1, '2025-02-21 20:16:14', NULL),
(272, 78, 'Nucleus', 1, 2, '2025-02-21 20:16:14', NULL),
(273, 78, 'Golgi apparatus', 1, 3, '2025-02-21 20:16:14', NULL),
(274, 78, 'Cell wall', 0, 4, '2025-02-21 20:16:14', NULL),
(275, 79, 'True', 1, 1, '2025-02-21 20:16:14', NULL),
(276, 79, 'False', 0, 2, '2025-02-21 20:16:14', NULL),
(277, 80, 'Mitochondria', 1, 1, '2025-02-21 20:16:14', NULL),
(278, 80, 'Nucleus', 0, 2, '2025-02-21 20:16:14', NULL),
(279, 80, 'Chloroplast', 0, 3, '2025-02-21 20:16:14', NULL),
(280, 80, 'Ribosome', 0, 4, '2025-02-21 20:16:14', NULL),
(281, 81, 'Mitosis', 1, 1, '2025-02-21 20:16:14', NULL),
(282, 81, 'Meiosis', 1, 2, '2025-02-21 20:16:14', NULL),
(283, 81, 'Binary fission', 1, 3, '2025-02-21 20:16:14', NULL),
(284, 81, 'Osmosis', 0, 4, '2025-02-21 20:16:14', NULL),
(285, 82, 'Process of converting light energy to chemical energy', 1, 1, '2025-02-21 20:16:14', NULL),
(286, 82, 'Breaking down of glucose', 0, 2, '2025-02-21 20:16:14', NULL),
(287, 82, 'Cell division process', 0, 3, '2025-02-21 20:16:14', NULL),
(288, 82, 'Protein synthesis', 0, 4, '2025-02-21 20:16:14', NULL),
(289, 83, 'Red blood cells', 1, 1, '2025-02-21 20:16:14', NULL),
(290, 83, 'White blood cells', 1, 2, '2025-02-21 20:16:14', NULL),
(291, 83, 'Platelets', 1, 3, '2025-02-21 20:16:14', NULL),
(292, 83, 'Muscle cells', 0, 4, '2025-02-21 20:16:14', NULL),
(293, 84, 'True', 1, 1, '2025-02-21 20:16:14', NULL),
(294, 84, 'False', 0, 2, '2025-02-21 20:16:14', NULL),
(295, 85, 'Average of all values', 1, 1, '2025-02-21 20:16:14', NULL),
(296, 85, 'Middle value', 0, 2, '2025-02-21 20:16:14', NULL),
(297, 85, 'Most frequent value', 0, 3, '2025-02-21 20:16:14', NULL),
(298, 85, 'Sum of all values', 0, 4, '2025-02-21 20:16:14', NULL),
(299, 86, 'Mean', 1, 1, '2025-02-21 20:16:14', NULL),
(300, 86, 'Median', 1, 2, '2025-02-21 20:16:14', NULL),
(301, 86, 'Mode', 1, 3, '2025-02-21 20:16:14', NULL),
(302, 86, 'Range', 0, 4, '2025-02-21 20:16:14', NULL),
(303, 87, 'True', 1, 1, '2025-02-21 20:16:14', NULL),
(304, 87, 'False', 0, 2, '2025-02-21 20:16:14', NULL),
(305, 88, 'Spread of data', 1, 1, '2025-02-21 20:16:14', NULL),
(306, 88, 'Center of data', 0, 2, '2025-02-21 20:16:14', NULL),
(307, 88, 'Size of data', 0, 3, '2025-02-21 20:16:14', NULL),
(308, 88, 'Order of data', 0, 4, '2025-02-21 20:16:14', NULL),
(309, 89, 'Random', 1, 1, '2025-02-21 20:16:14', NULL),
(310, 89, 'Stratified', 1, 2, '2025-02-21 20:16:14', NULL),
(311, 89, 'Cluster', 1, 3, '2025-02-21 20:16:14', NULL),
(312, 89, 'Organized', 0, 4, '2025-02-21 20:16:14', NULL),
(313, 90, 'Relationship between two variables', 1, 1, '2025-02-21 20:16:14', NULL),
(314, 90, 'Measure of center', 0, 2, '2025-02-21 20:16:14', NULL),
(315, 90, 'Type of graph', 0, 3, '2025-02-21 20:16:14', NULL),
(316, 90, 'Statistical test', 0, 4, '2025-02-21 20:16:14', NULL),
(317, 91, '0.5', 1, 1, '2025-02-21 20:16:14', NULL),
(318, 91, '1.0', 1, 2, '2025-02-21 20:16:14', NULL),
(319, 91, '0.0', 1, 3, '2025-02-21 20:16:14', NULL),
(320, 91, '1.5', 0, 4, '2025-02-21 20:16:14', NULL),
(321, 92, 'Most frequent value', 1, 1, '2025-02-21 20:16:14', NULL),
(322, 92, 'Middle value', 0, 2, '2025-02-21 20:16:14', NULL),
(323, 92, 'Average value', 0, 3, '2025-02-21 20:16:14', NULL),
(324, 92, 'Largest value', 0, 4, '2025-02-21 20:16:14', NULL),
(325, 93, 'False', 1, 1, '2025-02-21 20:16:14', NULL),
(326, 93, 'True', 0, 2, '2025-02-21 20:16:14', NULL),
(327, 94, 'Hydrocarbon with single bonds', 1, 1, '2025-02-21 20:16:14', NULL),
(328, 94, 'Hydrocarbon with double bonds', 0, 2, '2025-02-21 20:16:14', NULL),
(329, 94, 'Carbon compound with oxygen', 0, 3, '2025-02-21 20:16:14', NULL),
(330, 94, 'Carbon compound with nitrogen', 0, 4, '2025-02-21 20:16:14', NULL),
(331, 95, 'Hydroxyl', 1, 1, '2025-02-21 20:16:14', NULL),
(332, 95, 'Carboxyl', 1, 2, '2025-02-21 20:16:14', NULL),
(333, 95, 'Amino', 1, 3, '2025-02-21 20:16:14', NULL),
(334, 95, 'Carbon', 0, 4, '2025-02-21 20:16:14', NULL),
(335, 96, 'True', 1, 1, '2025-02-21 20:16:14', NULL),
(336, 96, 'False', 0, 2, '2025-02-21 20:16:14', NULL),
(337, 97, 'Methanol', 1, 1, '2025-02-21 20:16:14', NULL),
(338, 97, 'Ethanol', 0, 2, '2025-02-21 20:16:14', NULL),
(339, 97, 'Propanol', 0, 3, '2025-02-21 20:16:14', NULL),
(340, 97, 'Butanol', 0, 4, '2025-02-21 20:16:14', NULL),
(341, 98, 'Structural', 1, 1, '2025-02-21 20:16:14', NULL),
(342, 98, 'Geometric', 1, 2, '2025-02-21 20:16:14', NULL),
(343, 98, 'Optical', 1, 3, '2025-02-21 20:16:14', NULL),
(344, 98, 'Chemical', 0, 4, '2025-02-21 20:16:14', NULL),
(345, 99, 'Compound of only carbon and hydrogen', 1, 1, '2025-02-21 20:16:14', NULL),
(346, 99, 'Any organic compound', 0, 2, '2025-02-21 20:16:14', NULL),
(347, 99, 'Carbon-oxygen compound', 0, 3, '2025-02-21 20:16:14', NULL),
(348, 99, 'Carbon-nitrogen compound', 0, 4, '2025-02-21 20:16:14', NULL),
(349, 100, 'Contains double bond', 1, 1, '2025-02-21 20:16:14', NULL),
(350, 100, 'Unsaturated', 1, 2, '2025-02-21 20:16:14', NULL),
(351, 100, 'More reactive than alkanes', 1, 3, '2025-02-21 20:16:14', NULL),
(352, 100, 'Contains triple bond', 0, 4, '2025-02-21 20:16:14', NULL),
(353, 101, 'Product of alcohol and acid reaction', 1, 1, '2025-02-21 20:16:14', NULL),
(354, 101, 'Type of alcohol', 0, 2, '2025-02-21 20:16:14', NULL),
(355, 101, 'Form of alkane', 0, 3, '2025-02-21 20:16:14', NULL),
(356, 101, 'Organic base', 0, 4, '2025-02-21 20:16:14', NULL),
(357, 102, 'True', 1, 1, '2025-02-21 20:16:14', NULL),
(358, 102, 'False', 0, 2, '2025-02-21 20:16:14', NULL),
(359, 103, 'Ethane', 1, 1, '2025-02-21 20:16:14', NULL),
(360, 103, 'Methane', 0, 2, '2025-02-21 20:16:14', NULL),
(361, 103, 'Propane', 0, 3, '2025-02-21 20:16:14', NULL),
(362, 103, 'Butane', 0, 4, '2025-02-21 20:16:14', NULL),
(363, 104, 'HyperText Markup Language', 1, 1, '2025-02-21 20:16:14', NULL),
(364, 104, 'High Text Markup Language', 0, 2, '2025-02-21 20:16:14', NULL),
(365, 104, 'Hyper Transfer Markup Language', 0, 3, '2025-02-21 20:16:14', NULL),
(366, 104, 'High Transfer Markup Language', 0, 4, '2025-02-21 20:16:14', NULL),
(367, 105, '<div>', 1, 1, '2025-02-21 20:16:14', NULL),
(368, 105, '<span>', 1, 2, '2025-02-21 20:16:14', NULL),
(369, 105, '<p>', 1, 3, '2025-02-21 20:16:14', NULL),
(370, 105, '<text>', 0, 4, '2025-02-21 20:16:14', NULL),
(371, 106, 'True', 1, 1, '2025-02-21 20:16:14', NULL),
(372, 106, 'False', 0, 2, '2025-02-21 20:16:14', NULL),
(373, 107, '<a>', 1, 1, '2025-02-21 20:16:14', NULL),
(374, 107, '<link>', 0, 2, '2025-02-21 20:16:14', NULL),
(375, 107, '<href>', 0, 3, '2025-02-21 20:16:14', NULL),
(376, 107, '<url>', 0, 4, '2025-02-21 20:16:14', NULL),
(377, 108, 'Class', 1, 1, '2025-02-21 20:16:14', NULL),
(378, 108, 'ID', 1, 2, '2025-02-21 20:16:14', NULL),
(379, 108, 'Tag', 1, 3, '2025-02-21 20:16:14', NULL),
(380, 108, 'Style', 0, 4, '2025-02-21 20:16:14', NULL),
(381, 109, 'Content, padding, border, and margin', 1, 1, '2025-02-21 20:16:14', NULL),
(382, 109, 'Only content and border', 0, 2, '2025-02-21 20:16:14', NULL),
(383, 109, 'Only margin and padding', 0, 3, '2025-02-21 20:16:14', NULL),
(384, 109, 'Content and margin only', 0, 4, '2025-02-21 20:16:14', NULL),
(385, 110, 'Static', 1, 1, '2025-02-21 20:16:14', NULL),
(386, 110, 'Relative', 1, 2, '2025-02-21 20:16:14', NULL),
(387, 110, 'Absolute', 1, 3, '2025-02-21 20:16:14', NULL),
(388, 110, 'Dynamic', 0, 4, '2025-02-21 20:16:14', NULL),
(389, 111, 'True', 1, 1, '2025-02-21 20:16:14', NULL),
(390, 111, 'False', 0, 2, '2025-02-21 20:16:14', NULL),
(391, 112, 'Opposite/Hypotenuse', 1, 1, '2025-02-21 20:16:14', NULL),
(392, 112, 'Adjacent/Hypotenuse', 0, 2, '2025-02-21 20:16:14', NULL),
(393, 112, 'Opposite/Adjacent', 0, 3, '2025-02-21 20:16:14', NULL),
(394, 112, 'Hypotenuse/Adjacent', 0, 4, '2025-02-21 20:16:14', NULL),
(395, 113, 'Sine', 1, 1, '2025-02-21 20:16:14', NULL),
(396, 113, 'Cosine', 1, 2, '2025-02-21 20:16:14', NULL),
(397, 113, 'Tangent', 1, 3, '2025-02-21 20:16:14', NULL),
(398, 113, 'Parallel', 0, 4, '2025-02-21 20:16:14', NULL),
(399, 114, 'True', 1, 1, '2025-02-21 20:16:14', NULL),
(400, 114, 'False', 0, 2, '2025-02-21 20:16:14', NULL),
(401, 115, '2π', 1, 1, '2025-02-21 20:16:14', NULL),
(402, 115, 'π', 0, 2, '2025-02-21 20:16:14', NULL),
(403, 115, '4π', 0, 3, '2025-02-21 20:16:14', NULL),
(404, 115, 'π/2', 0, 4, '2025-02-21 20:16:14', NULL),
(405, 116, 'sin²θ + cos²θ = 1', 1, 1, '2025-02-21 20:16:14', NULL),
(406, 116, 'tanθ = sinθ/cosθ', 1, 2, '2025-02-21 20:16:14', NULL),
(407, 116, 'sin(2θ) = 2sinθcosθ', 1, 3, '2025-02-21 20:16:14', NULL),
(408, 116, 'sin²θ = cos²θ', 0, 4, '2025-02-21 20:16:14', NULL),
(409, 117, 'Cosecant', 1, 1, '2025-02-21 20:16:14', NULL),
(410, 117, 'Secant', 0, 2, '2025-02-21 20:16:14', NULL),
(411, 117, 'Cotangent', 0, 3, '2025-02-21 20:16:14', NULL),
(412, 117, 'Tangent', 0, 4, '2025-02-21 20:16:14', NULL),
(413, 118, 'Hypotenuse', 1, 1, '2025-02-21 20:16:14', NULL),
(414, 118, 'Adjacent side', 1, 2, '2025-02-21 20:16:14', NULL),
(415, 118, 'Opposite side', 1, 3, '2025-02-21 20:16:14', NULL),
(416, 118, 'Diameter', 0, 4, '2025-02-21 20:16:14', NULL),
(417, 119, 'False', 1, 1, '2025-02-21 20:16:14', NULL),
(418, 119, 'True', 0, 2, '2025-02-21 20:16:14', NULL),
(419, 120, '[-1, 1]', 1, 1, '2025-02-21 20:16:14', NULL),
(420, 120, '[-2, 2]', 0, 2, '2025-02-21 20:16:14', NULL),
(421, 120, '[0, 1]', 0, 3, '2025-02-21 20:16:14', NULL),
(422, 120, '[-π, π]', 0, 4, '2025-02-21 20:16:14', NULL),
(423, 121, 'Inner Core', 1, 1, '2025-02-21 20:16:14', NULL),
(424, 121, 'Outer Core', 0, 2, '2025-02-21 20:16:14', NULL),
(425, 121, 'Mantle', 0, 3, '2025-02-21 20:16:14', NULL),
(426, 121, 'Crust', 0, 4, '2025-02-21 20:16:14', NULL),
(427, 122, 'Igneous', 1, 1, '2025-02-21 20:16:14', NULL),
(428, 122, 'Sedimentary', 1, 2, '2025-02-21 20:16:14', NULL),
(429, 122, 'Metamorphic', 1, 3, '2025-02-21 20:16:14', NULL),
(430, 122, 'Liquid', 0, 4, '2025-02-21 20:16:14', NULL),
(431, 123, 'True', 0, 1, '2025-02-21 20:16:14', NULL),
(432, 123, 'False', 1, 2, '2025-02-21 20:16:14', NULL),
(433, 124, 'Gravitational pull of the Moon', 1, 1, '2025-02-21 20:16:14', NULL),
(434, 124, 'Earth rotation', 0, 2, '2025-02-21 20:16:14', NULL),
(435, 124, 'Ocean currents', 0, 3, '2025-02-21 20:16:14', NULL),
(436, 124, 'Wind patterns', 0, 4, '2025-02-21 20:16:14', NULL),
(437, 125, 'Convergent', 1, 1, '2025-02-21 20:16:14', NULL),
(438, 125, 'Divergent', 1, 2, '2025-02-21 20:16:14', NULL),
(439, 125, 'Transform', 1, 3, '2025-02-21 20:16:14', NULL),
(440, 125, 'Circular', 0, 4, '2025-02-21 20:16:14', NULL),
(441, 126, 'Trapping of heat by atmospheric gases', 1, 1, '2025-02-21 20:16:14', NULL),
(442, 126, 'Plant growth in greenhouses', 0, 2, '2025-02-21 20:16:14', NULL),
(443, 126, 'Reflection of sunlight', 0, 3, '2025-02-21 20:16:14', NULL),
(444, 126, 'Ocean temperature changes', 0, 4, '2025-02-21 20:16:14', NULL),
(445, 127, 'Hurricane', 1, 1, '2025-02-21 20:16:14', NULL),
(446, 127, 'Tornado', 1, 2, '2025-02-21 20:16:14', NULL),
(447, 127, 'Thunderstorm', 1, 3, '2025-02-21 20:16:14', NULL),
(448, 127, 'Rainbow', 0, 4, '2025-02-21 20:16:14', NULL),
(449, 128, 'False', 1, 1, '2025-02-21 20:16:14', NULL),
(450, 128, 'True', 0, 2, '2025-02-21 20:16:14', NULL),
(451, 129, 'A JavaScript library for building user interfaces', 1, 1, '2025-02-21 20:16:14', NULL),
(452, 129, 'A programming language', 0, 2, '2025-02-21 20:16:14', NULL),
(453, 129, 'A database system', 0, 3, '2025-02-21 20:16:14', NULL),
(454, 129, 'A web server', 0, 4, '2025-02-21 20:16:14', NULL),
(455, 130, 'useState', 1, 1, '2025-02-21 20:16:14', NULL),
(456, 130, 'useEffect', 1, 2, '2025-02-21 20:16:14', NULL),
(457, 130, 'useContext', 1, 3, '2025-02-21 20:16:14', NULL),
(458, 130, 'useProgram', 0, 4, '2025-02-21 20:16:14', NULL),
(459, 131, 'True', 0, 1, '2025-02-21 20:16:14', NULL),
(460, 131, 'False', 1, 2, '2025-02-21 20:16:14', NULL),
(461, 132, 'JavaScript XML syntax', 1, 1, '2025-02-21 20:16:14', NULL),
(462, 132, 'Java Syntax Extension', 0, 2, '2025-02-21 20:16:14', NULL),
(463, 132, 'JavaScript Extension', 0, 3, '2025-02-21 20:16:14', NULL),
(464, 132, 'Java XML', 0, 4, '2025-02-21 20:16:14', NULL),
(465, 133, 'componentDidMount', 1, 1, '2025-02-21 20:16:14', NULL),
(466, 133, 'componentDidUpdate', 1, 2, '2025-02-21 20:16:14', NULL),
(467, 133, 'componentWillUnmount', 1, 3, '2025-02-21 20:16:14', NULL),
(468, 133, 'componentWillMount', 0, 4, '2025-02-21 20:16:14', NULL),
(469, 134, 'Object that stores component\'s data', 1, 1, '2025-02-21 20:16:14', NULL),
(470, 134, 'Database connection', 0, 2, '2025-02-21 20:16:14', NULL),
(471, 134, 'Server configuration', 0, 3, '2025-02-21 20:16:14', NULL),
(472, 134, 'CSS styling', 0, 4, '2025-02-21 20:16:14', NULL),
(473, 135, 'Functional Components', 1, 1, '2025-02-21 20:16:14', NULL),
(474, 135, 'Class Components', 1, 2, '2025-02-21 20:16:14', NULL),
(475, 135, 'Higher-Order Components', 1, 3, '2025-02-21 20:16:14', NULL),
(476, 135, 'Static Components', 0, 4, '2025-02-21 20:16:14', NULL),
(477, 136, 'Lightweight copy of actual DOM', 1, 1, '2025-02-21 20:16:14', NULL),
(478, 136, 'Browser extension', 0, 2, '2025-02-21 20:16:14', NULL),
(479, 136, 'JavaScript engine', 0, 3, '2025-02-21 20:16:14', NULL),
(480, 136, 'CSS framework', 0, 4, '2025-02-21 20:16:14', NULL),
(481, 137, 'False', 1, 1, '2025-02-21 20:16:14', NULL),
(482, 137, 'True', 0, 2, '2025-02-21 20:16:14', NULL),
(483, 138, 'A rectangular array of numbers', 1, 1, '2025-02-21 20:16:14', NULL),
(484, 138, 'A mathematical equation', 0, 2, '2025-02-21 20:16:14', NULL),
(485, 138, 'A geometric shape', 0, 3, '2025-02-21 20:16:14', NULL),
(486, 138, 'A numerical sequence', 0, 4, '2025-02-21 20:16:14', NULL),
(487, 139, 'Square matrix', 1, 1, '2025-02-21 20:16:14', NULL),
(488, 139, 'Identity matrix', 1, 2, '2025-02-21 20:16:14', NULL),
(489, 139, 'Diagonal matrix', 1, 3, '2025-02-21 20:16:14', NULL),
(490, 139, 'Circular matrix', 0, 4, '2025-02-21 20:16:14', NULL),
(491, 140, 'True', 1, 1, '2025-02-21 20:16:14', NULL),
(492, 140, 'False', 0, 2, '2025-02-21 20:16:14', NULL),
(493, 141, 'A scalar value derived from a square matrix', 1, 1, '2025-02-21 20:16:14', NULL),
(494, 141, 'The sum of matrix elements', 0, 2, '2025-02-21 20:16:14', NULL),
(495, 141, 'The product of matrices', 0, 3, '2025-02-21 20:16:14', NULL),
(496, 141, 'The inverse of a matrix', 0, 4, '2025-02-21 20:16:14', NULL),
(497, 142, 'Addition', 1, 1, '2025-02-21 20:16:14', NULL),
(498, 142, 'Multiplication', 1, 2, '2025-02-21 20:16:14', NULL),
(499, 142, 'Transpose', 1, 3, '2025-02-21 20:16:14', NULL),
(500, 142, 'Division', 0, 4, '2025-02-21 20:16:14', NULL),
(501, 143, 'Vector that maintains direction when transformed', 1, 1, '2025-02-21 20:16:14', NULL),
(502, 143, 'Zero vector', 0, 2, '2025-02-21 20:16:14', NULL),
(503, 143, 'Unit vector', 0, 3, '2025-02-21 20:16:14', NULL),
(504, 143, 'Basis vector', 0, 4, '2025-02-21 20:16:14', NULL),
(505, 144, 'Diagonal elements are all 1', 1, 1, '2025-02-21 20:16:14', NULL),
(506, 144, 'Non-diagonal elements are 0', 1, 2, '2025-02-21 20:16:14', NULL),
(507, 144, 'Square matrix', 1, 3, '2025-02-21 20:16:14', NULL),
(508, 144, 'Rectangular matrix', 0, 4, '2025-02-21 20:16:14', NULL),
(509, 145, 'Number of linearly independent rows/columns', 1, 1, '2025-02-21 20:16:14', NULL),
(510, 145, 'Number of rows', 0, 2, '2025-02-21 20:16:14', NULL),
(511, 145, 'Number of columns', 0, 3, '2025-02-21 20:16:14', NULL),
(512, 145, 'Sum of diagonal elements', 0, 4, '2025-02-21 20:16:14', NULL),
(513, 146, 'False', 1, 1, '2025-02-21 20:16:14', NULL),
(514, 146, 'True', 0, 2, '2025-02-21 20:16:14', NULL),
(515, 147, 'Matrix with zero determinant', 1, 1, '2025-02-21 20:16:14', NULL),
(516, 147, 'Identity matrix', 0, 2, '2025-02-21 20:16:14', NULL),
(517, 147, 'Square matrix', 0, 3, '2025-02-21 20:16:14', NULL),
(518, 147, 'Diagonal matrix', 0, 4, '2025-02-21 20:16:14', NULL),
(519, 148, 'A huge collection of stars, gas, and dust', 1, 1, '2025-02-21 20:16:14', NULL),
(520, 148, 'A single star system', 0, 2, '2025-02-21 20:16:14', NULL),
(521, 148, 'A type of planet', 0, 3, '2025-02-21 20:16:14', NULL),
(522, 148, 'A moon', 0, 4, '2025-02-21 20:16:14', NULL),
(523, 149, 'Earth', 1, 1, '2025-02-21 20:16:14', NULL),
(524, 149, 'Mars', 1, 2, '2025-02-21 20:16:14', NULL),
(525, 149, 'Jupiter', 1, 3, '2025-02-21 20:16:14', NULL),
(526, 149, 'Pluto', 0, 4, '2025-02-21 20:16:14', NULL),
(527, 150, 'True', 1, 1, '2025-02-21 20:16:14', NULL),
(528, 150, 'False', 0, 2, '2025-02-21 20:16:14', NULL),
(529, 151, 'Moon\'s position relative to Earth and Sun', 1, 1, '2025-02-21 20:16:14', NULL),
(530, 151, 'Earth\'s rotation', 0, 2, '2025-02-21 20:16:14', NULL),
(531, 151, 'Solar flares', 0, 3, '2025-02-21 20:16:14', NULL),
(532, 151, 'Planetary alignment', 0, 4, '2025-02-21 20:16:14', NULL),
(533, 152, 'Spiral', 1, 1, '2025-02-21 20:16:14', NULL),
(534, 152, 'Elliptical', 1, 2, '2025-02-21 20:16:14', NULL),
(535, 152, 'Irregular', 1, 3, '2025-02-21 20:16:14', NULL),
(536, 152, 'Squared', 0, 4, '2025-02-21 20:16:14', NULL),
(537, 153, 'Distance light travels in one year', 1, 1, '2025-02-21 20:16:14', NULL),
(538, 153, 'Time light takes to reach Earth', 0, 2, '2025-02-21 20:16:14', NULL),
(539, 153, 'Speed of light', 0, 3, '2025-02-21 20:16:14', NULL),
(540, 153, 'Brightness of a star', 0, 4, '2025-02-21 20:16:14', NULL),
(541, 154, 'Red Giant', 1, 1, '2025-02-21 20:16:14', NULL),
(542, 154, 'White Dwarf', 1, 2, '2025-02-21 20:16:14', NULL),
(543, 154, 'Neutron Star', 1, 3, '2025-02-21 20:16:14', NULL),
(544, 154, 'Blue Moon', 0, 4, '2025-02-21 20:16:14', NULL),
(545, 155, 'False', 1, 1, '2025-02-21 20:16:14', NULL),
(546, 155, 'True', 0, 2, '2025-02-21 20:16:14', NULL),
(547, 156, 'Process of organizing data to reduce redundancy', 1, 1, '2025-02-21 20:16:14', NULL),
(548, 156, 'Creating backup of database', 0, 2, '2025-02-21 20:16:14', NULL),
(549, 156, 'Converting data types', 0, 3, '2025-02-21 20:16:14', NULL),
(550, 156, 'Deleting duplicate records', 0, 4, '2025-02-21 20:16:14', NULL),
(551, 157, 'One-to-One', 1, 1, '2025-02-21 20:16:14', NULL),
(552, 157, 'One-to-Many', 1, 2, '2025-02-21 20:16:14', NULL),
(553, 157, 'Many-to-Many', 1, 3, '2025-02-21 20:16:14', NULL),
(554, 157, 'None-to-None', 0, 4, '2025-02-21 20:16:14', NULL),
(555, 158, 'True', 1, 1, '2025-02-21 20:16:14', NULL),
(556, 158, 'False', 0, 2, '2025-02-21 20:16:14', NULL),
(557, 159, 'A key referencing another table\'s primary key', 1, 1, '2025-02-21 20:16:14', NULL),
(558, 159, 'A backup key', 0, 2, '2025-02-21 20:16:14', NULL),
(559, 159, 'An optional key', 0, 3, '2025-02-21 20:16:14', NULL),
(560, 159, 'A temporary key', 0, 4, '2025-02-21 20:16:14', NULL),
(561, 160, 'UNIQUE', 1, 1, '2025-02-21 20:16:14', NULL),
(562, 160, 'NOT NULL', 1, 2, '2025-02-21 20:16:14', NULL),
(563, 160, 'CHECK', 1, 3, '2025-02-21 20:16:14', NULL),
(564, 160, 'VERIFY', 0, 4, '2025-02-21 20:16:14', NULL),
(565, 161, 'Data structure to improve query speed', 1, 1, '2025-02-21 20:16:14', NULL),
(566, 161, 'Primary key', 0, 2, '2025-02-21 20:16:14', NULL),
(567, 161, 'Table of contents', 0, 3, '2025-02-21 20:16:14', NULL),
(568, 161, 'Data backup', 0, 4, '2025-02-21 20:16:14', NULL),
(569, 162, '1NF', 1, 1, '2025-02-21 20:16:14', NULL),
(570, 162, '2NF', 1, 2, '2025-02-21 20:16:14', NULL),
(571, 162, '3NF', 1, 3, '2025-02-21 20:16:14', NULL),
(572, 162, '0NF', 0, 4, '2025-02-21 20:16:14', NULL),
(573, 163, 'Accuracy and consistency of data', 1, 1, '2025-02-21 20:16:14', NULL),
(574, 163, 'Data backup process', 0, 2, '2025-02-21 20:16:14', NULL),
(575, 163, 'Data encryption', 0, 3, '2025-02-21 20:16:14', NULL),
(576, 163, 'Data storage method', 0, 4, '2025-02-21 20:16:14', NULL),
(577, 164, 'False', 1, 1, '2025-02-21 20:16:14', NULL),
(578, 164, 'True', 0, 2, '2025-02-21 20:16:14', NULL),
(579, 165, 'Likelihood of an event occurring', 1, 1, '2025-02-21 20:16:14', NULL),
(580, 165, 'Certainty of an outcome', 0, 2, '2025-02-21 20:16:14', NULL),
(581, 165, 'Number of possible outcomes', 0, 3, '2025-02-21 20:16:14', NULL),
(582, 165, 'Prediction of future events', 0, 4, '2025-02-21 20:16:14', NULL),
(583, 166, 'Normal distribution', 1, 1, '2025-02-21 20:16:14', NULL),
(584, 166, 'Binomial distribution', 1, 2, '2025-02-21 20:16:14', NULL),
(585, 166, 'Poisson distribution', 1, 3, '2025-02-21 20:16:14', NULL),
(586, 166, 'Linear distribution', 0, 4, '2025-02-21 20:16:14', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `categories`
--

CREATE TABLE `categories` (
  `category_id` bigint(20) NOT NULL,
  `name` varchar(100) NOT NULL,
  `description` text DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp(),
  `deleted_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `categories`
--

INSERT INTO `categories` (`category_id`, `name`, `description`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 'Programming', 'All about programming languages and concepts', '2025-02-21 20:16:13', '2025-02-21 20:16:13', NULL),
(2, 'Mathematics', 'Mathematical concepts and problems', '2025-02-21 20:16:13', '2025-02-21 20:16:13', NULL),
(3, 'Science', 'General science topics', '2025-02-21 20:16:13', '2025-02-21 20:16:13', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `questions`
--

CREATE TABLE `questions` (
  `question_id` bigint(20) NOT NULL,
  `quizz_id` bigint(20) DEFAULT NULL,
  `question_text` text NOT NULL,
  `question_type` varchar(20) NOT NULL COMMENT 'SINGLE_CHOICE, MULTIPLE_CHOICE, TRUE_FALSE',
  `score` int(11) DEFAULT 0,
  `order_index` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `deleted_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `questions`
--

INSERT INTO `questions` (`question_id`, `quizz_id`, `question_text`, `question_type`, `score`, `order_index`, `created_at`, `deleted_at`) VALUES
(1, 1, 'What is Java?', 'SINGLE_CHOICE', 10, 1, '2025-02-21 20:16:13', NULL),
(2, 1, 'Which of these are Java keywords?', 'MULTIPLE_CHOICE', 10, 2, '2025-02-21 20:16:13', NULL),
(3, 1, 'Java is platform independent?', 'TRUE_FALSE', 10, 3, '2025-02-21 20:16:13', NULL),
(4, 1, 'What is the main method signature in Java?', 'SINGLE_CHOICE', 10, 4, '2025-02-21 20:16:13', NULL),
(5, 1, 'Select all valid Java variable names:', 'MULTIPLE_CHOICE', 10, 5, '2025-02-21 20:16:13', NULL),
(6, 1, 'Java supports multiple inheritance through classes?', 'TRUE_FALSE', 10, 6, '2025-02-21 20:16:13', NULL),
(7, 1, 'What is the default value of int in Java?', 'SINGLE_CHOICE', 10, 7, '2025-02-21 20:16:13', NULL),
(8, 1, 'Which of these are valid access modifiers in Java?', 'MULTIPLE_CHOICE', 10, 8, '2025-02-21 20:16:13', NULL),
(9, 1, 'Java is purely object oriented?', 'TRUE_FALSE', 10, 9, '2025-02-21 20:16:13', NULL),
(10, 1, 'What is the size of double in Java?', 'SINGLE_CHOICE', 10, 10, '2025-02-21 20:16:13', NULL),
(11, 2, 'Python is an interpreted language?', 'TRUE_FALSE', 10, 1, '2025-02-21 20:16:13', NULL),
(12, 2, 'What is the Python package manager called?', 'SINGLE_CHOICE', 10, 2, '2025-02-21 20:16:13', NULL),
(13, 2, 'Select all valid Python data types:', 'MULTIPLE_CHOICE', 10, 3, '2025-02-21 20:16:13', NULL),
(14, 2, 'Python supports multiple inheritance?', 'TRUE_FALSE', 10, 4, '2025-02-21 20:16:13', NULL),
(15, 2, 'What is the correct file extension for Python files?', 'SINGLE_CHOICE', 10, 5, '2025-02-21 20:16:13', NULL),
(16, 2, 'Which of these are Python keywords?', 'MULTIPLE_CHOICE', 10, 6, '2025-02-21 20:16:13', NULL),
(17, 2, 'Is indentation important in Python?', 'TRUE_FALSE', 10, 7, '2025-02-21 20:16:13', NULL),
(18, 2, 'What is the correct way to create a function in Python?', 'SINGLE_CHOICE', 10, 8, '2025-02-21 20:16:13', NULL),
(19, 3, 'What is the value of x in 2x + 3 = 7?', 'SINGLE_CHOICE', 10, 1, '2025-02-21 20:16:13', NULL),
(20, 3, 'Select all expressions that equal 10:', 'MULTIPLE_CHOICE', 10, 2, '2025-02-21 20:16:13', NULL),
(21, 3, 'Is -(-2) equal to 2?', 'TRUE_FALSE', 10, 3, '2025-02-21 20:16:13', NULL),
(22, 3, 'Solve for x: 3x - 4 = 8', 'SINGLE_CHOICE', 10, 4, '2025-02-21 20:16:13', NULL),
(23, 3, 'Which of these are quadratic equations?', 'MULTIPLE_CHOICE', 10, 5, '2025-02-21 20:16:13', NULL),
(24, 3, 'Is the square root of a negative number a real number?', 'TRUE_FALSE', 10, 6, '2025-02-21 20:16:13', NULL),
(25, 3, 'What is the value of x² when x = 3?', 'SINGLE_CHOICE', 10, 7, '2025-02-21 20:16:13', NULL),
(26, 4, 'What is the area formula for a rectangle?', 'SINGLE_CHOICE', 10, 1, '2025-02-21 20:16:13', NULL),
(27, 4, 'Select all shapes that are polygons:', 'MULTIPLE_CHOICE', 10, 2, '2025-02-21 20:16:13', NULL),
(28, 4, 'Are all squares rectangles?', 'TRUE_FALSE', 10, 3, '2025-02-21 20:16:13', NULL),
(29, 4, 'What is the sum of angles in a triangle?', 'SINGLE_CHOICE', 10, 4, '2025-02-21 20:16:13', NULL),
(30, 4, 'Which of these are types of triangles?', 'MULTIPLE_CHOICE', 10, 5, '2025-02-21 20:16:13', NULL),
(31, 4, 'Is a circle a polygon?', 'TRUE_FALSE', 10, 6, '2025-02-21 20:16:13', NULL),
(32, 4, 'What is the formula for the circumference of a circle?', 'SINGLE_CHOICE', 10, 7, '2025-02-21 20:16:13', NULL),
(33, 4, 'Select all true statements about parallelograms:', 'MULTIPLE_CHOICE', 10, 8, '2025-02-21 20:16:13', NULL),
(34, 5, 'What is the SI unit of force?', 'SINGLE_CHOICE', 10, 1, '2025-02-21 20:16:13', NULL),
(35, 5, 'Select all scalar quantities:', 'MULTIPLE_CHOICE', 10, 2, '2025-02-21 20:16:13', NULL),
(36, 5, 'Is momentum a vector quantity?', 'TRUE_FALSE', 10, 3, '2025-02-21 20:16:13', NULL),
(37, 5, 'What is the formula for force?', 'SINGLE_CHOICE', 10, 4, '2025-02-21 20:16:13', NULL),
(38, 5, 'Which of these are forms of energy?', 'MULTIPLE_CHOICE', 10, 5, '2025-02-21 20:16:13', NULL),
(39, 5, 'Does light travel faster than sound?', 'TRUE_FALSE', 10, 6, '2025-02-21 20:16:13', NULL),
(40, 5, 'What is the unit of electric current?', 'SINGLE_CHOICE', 10, 7, '2025-02-21 20:16:13', NULL),
(41, 6, 'What is JavaScript?', 'SINGLE_CHOICE', 10, 1, '2025-02-21 20:16:13', NULL),
(42, 6, 'Select all JavaScript data types:', 'MULTIPLE_CHOICE', 10, 2, '2025-02-21 20:16:13', NULL),
(43, 6, 'JavaScript is case sensitive?', 'TRUE_FALSE', 10, 3, '2025-02-21 20:16:13', NULL),
(44, 6, 'What is the correct way to declare a variable in modern JavaScript?', 'SINGLE_CHOICE', 10, 4, '2025-02-21 20:16:13', NULL),
(45, 6, 'Which of these are valid array methods in JavaScript?', 'MULTIPLE_CHOICE', 10, 5, '2025-02-21 20:16:13', NULL),
(46, 6, 'JavaScript runs on the client side only?', 'TRUE_FALSE', 10, 6, '2025-02-21 20:16:13', NULL),
(47, 6, 'What is the typeof operator used for?', 'SINGLE_CHOICE', 10, 7, '2025-02-21 20:16:13', NULL),
(48, 6, 'Select valid ways to create objects:', 'MULTIPLE_CHOICE', 10, 8, '2025-02-21 20:16:13', NULL),
(49, 6, 'What is the DOM?', 'SINGLE_CHOICE', 10, 9, '2025-02-21 20:16:13', NULL),
(50, 7, 'What does SQL stand for?', 'SINGLE_CHOICE', 10, 1, '2025-02-21 20:16:14', NULL),
(51, 7, 'Select all valid SQL commands:', 'MULTIPLE_CHOICE', 10, 2, '2025-02-21 20:16:14', NULL),
(52, 7, 'SQL is case sensitive?', 'TRUE_FALSE', 10, 3, '2025-02-21 20:16:14', NULL),
(53, 7, 'Which SQL command is used to retrieve data?', 'SINGLE_CHOICE', 10, 4, '2025-02-21 20:16:14', NULL),
(54, 7, 'Which of these are valid JOIN types?', 'MULTIPLE_CHOICE', 10, 5, '2025-02-21 20:16:14', NULL),
(55, 7, 'What does DISTINCT keyword do?', 'SINGLE_CHOICE', 10, 6, '2025-02-21 20:16:14', NULL),
(56, 7, 'Select valid aggregate functions:', 'MULTIPLE_CHOICE', 10, 7, '2025-02-21 20:16:14', NULL),
(57, 7, 'What is a primary key?', 'SINGLE_CHOICE', 10, 8, '2025-02-21 20:16:14', NULL),
(58, 8, 'What is a derivative?', 'SINGLE_CHOICE', 10, 1, '2025-02-21 20:16:14', NULL),
(59, 8, 'Select all terms related to integration:', 'MULTIPLE_CHOICE', 10, 2, '2025-02-21 20:16:14', NULL),
(60, 8, 'Is every continuous function differentiable?', 'TRUE_FALSE', 10, 3, '2025-02-21 20:16:14', NULL),
(61, 8, 'What is the derivative of x²?', 'SINGLE_CHOICE', 10, 4, '2025-02-21 20:16:14', NULL),
(62, 8, 'Which of these are types of limits?', 'MULTIPLE_CHOICE', 10, 5, '2025-02-21 20:16:14', NULL),
(63, 8, 'What is the chain rule used for?', 'SINGLE_CHOICE', 10, 6, '2025-02-21 20:16:14', NULL),
(64, 8, 'Select valid integration techniques:', 'MULTIPLE_CHOICE', 10, 7, '2025-02-21 20:16:14', NULL),
(65, 8, 'What is a local maximum?', 'SINGLE_CHOICE', 10, 8, '2025-02-21 20:16:14', NULL),
(66, 8, 'The derivative represents:', 'SINGLE_CHOICE', 10, 9, '2025-02-21 20:16:14', NULL),
(67, 8, 'Is zero a real number?', 'TRUE_FALSE', 10, 10, '2025-02-21 20:16:14', NULL),
(68, 9, 'What is an atom?', 'SINGLE_CHOICE', 10, 1, '2025-02-21 20:16:14', NULL),
(69, 9, 'Select all noble gases:', 'MULTIPLE_CHOICE', 10, 2, '2025-02-21 20:16:14', NULL),
(70, 9, 'Is water a compound?', 'TRUE_FALSE', 10, 3, '2025-02-21 20:16:14', NULL),
(71, 9, 'What is the atomic number of Hydrogen?', 'SINGLE_CHOICE', 10, 4, '2025-02-21 20:16:14', NULL),
(72, 9, 'Which of these are types of chemical bonds?', 'MULTIPLE_CHOICE', 10, 5, '2025-02-21 20:16:14', NULL),
(73, 9, 'What is the pH scale range?', 'SINGLE_CHOICE', 10, 6, '2025-02-21 20:16:14', NULL),
(74, 9, 'Select all state of matter:', 'MULTIPLE_CHOICE', 10, 7, '2025-02-21 20:16:14', NULL),
(75, 9, 'What is a molecule?', 'SINGLE_CHOICE', 10, 8, '2025-02-21 20:16:14', NULL),
(76, 9, 'Can atoms be created or destroyed?', 'TRUE_FALSE', 10, 9, '2025-02-21 20:16:14', NULL),
(77, 10, 'What is a cell?', 'SINGLE_CHOICE', 10, 1, '2025-02-21 20:16:14', NULL),
(78, 10, 'Select all organelles found in animal cells:', 'MULTIPLE_CHOICE', 10, 2, '2025-02-21 20:16:14', NULL),
(79, 10, 'DNA is found in the nucleus?', 'TRUE_FALSE', 10, 3, '2025-02-21 20:16:14', NULL),
(80, 10, 'What is the powerhouse of the cell?', 'SINGLE_CHOICE', 10, 4, '2025-02-21 20:16:14', NULL),
(81, 10, 'Which of these are types of cell division?', 'MULTIPLE_CHOICE', 10, 5, '2025-02-21 20:16:14', NULL),
(82, 10, 'What is photosynthesis?', 'SINGLE_CHOICE', 10, 6, '2025-02-21 20:16:14', NULL),
(83, 10, 'Select all types of blood cells:', 'MULTIPLE_CHOICE', 10, 7, '2025-02-21 20:16:14', NULL),
(84, 10, 'Is every living thing made of cells?', 'TRUE_FALSE', 10, 8, '2025-02-21 20:16:14', NULL),
(85, 11, 'What is the mean?', 'SINGLE_CHOICE', 10, 1, '2025-02-21 20:16:14', NULL),
(86, 11, 'Select all measures of central tendency:', 'MULTIPLE_CHOICE', 10, 2, '2025-02-21 20:16:14', NULL),
(87, 11, 'Is standard deviation always positive?', 'TRUE_FALSE', 10, 3, '2025-02-21 20:16:14', NULL),
(88, 11, 'What does variance measure?', 'SINGLE_CHOICE', 10, 4, '2025-02-21 20:16:14', NULL),
(89, 11, 'Which of these are types of sampling methods?', 'MULTIPLE_CHOICE', 10, 5, '2025-02-21 20:16:14', NULL),
(90, 11, 'What is correlation?', 'SINGLE_CHOICE', 10, 6, '2025-02-21 20:16:14', NULL),
(91, 11, 'Select valid probability values:', 'MULTIPLE_CHOICE', 10, 7, '2025-02-21 20:16:14', NULL),
(92, 11, 'What is the mode?', 'SINGLE_CHOICE', 10, 8, '2025-02-21 20:16:14', NULL),
(93, 11, 'Can standard deviation be negative?', 'TRUE_FALSE', 10, 9, '2025-02-21 20:16:14', NULL),
(94, 12, 'What is an alkane?', 'SINGLE_CHOICE', 10, 1, '2025-02-21 20:16:14', NULL),
(95, 12, 'Select all functional groups:', 'MULTIPLE_CHOICE', 10, 2, '2025-02-21 20:16:14', NULL),
(96, 12, 'Are all organic compounds carbon-based?', 'TRUE_FALSE', 10, 3, '2025-02-21 20:16:14', NULL),
(97, 12, 'What is the simplest alcohol?', 'SINGLE_CHOICE', 10, 4, '2025-02-21 20:16:14', NULL),
(98, 12, 'Which of these are types of isomers?', 'MULTIPLE_CHOICE', 10, 5, '2025-02-21 20:16:14', NULL),
(99, 12, 'What is a hydrocarbon?', 'SINGLE_CHOICE', 10, 6, '2025-02-21 20:16:14', NULL),
(100, 12, 'Select valid alkene characteristics:', 'MULTIPLE_CHOICE', 10, 7, '2025-02-21 20:16:14', NULL),
(101, 12, 'What is an ester?', 'SINGLE_CHOICE', 10, 8, '2025-02-21 20:16:14', NULL),
(102, 12, 'Is benzene aromatic?', 'TRUE_FALSE', 10, 9, '2025-02-21 20:16:14', NULL),
(103, 12, 'What is the IUPAC name for CH3-CH3?', 'SINGLE_CHOICE', 10, 10, '2025-02-21 20:16:14', NULL),
(104, 13, 'What does HTML stand for?', 'SINGLE_CHOICE', 10, 1, '2025-02-21 20:16:14', NULL),
(105, 13, 'Select all valid HTML tags:', 'MULTIPLE_CHOICE', 10, 2, '2025-02-21 20:16:14', NULL),
(106, 13, 'Is CSS used for styling?', 'TRUE_FALSE', 10, 3, '2025-02-21 20:16:14', NULL),
(107, 13, 'Which tag is used for hyperlinks?', 'SINGLE_CHOICE', 10, 4, '2025-02-21 20:16:14', NULL),
(108, 13, 'Which of these are CSS selectors?', 'MULTIPLE_CHOICE', 10, 5, '2025-02-21 20:16:14', NULL),
(109, 13, 'What is CSS Box Model?', 'SINGLE_CHOICE', 10, 6, '2025-02-21 20:16:14', NULL),
(110, 13, 'Select all CSS positioning types:', 'MULTIPLE_CHOICE', 10, 7, '2025-02-21 20:16:14', NULL),
(111, 13, 'Is HTML5 backward compatible?', 'TRUE_FALSE', 10, 8, '2025-02-21 20:16:14', NULL),
(112, 14, 'What is sine?', 'SINGLE_CHOICE', 10, 1, '2025-02-21 20:16:14', NULL),
(113, 14, 'Select all trigonometric ratios:', 'MULTIPLE_CHOICE', 10, 2, '2025-02-21 20:16:14', NULL),
(114, 14, 'Is cos(0) equal to 1?', 'TRUE_FALSE', 10, 3, '2025-02-21 20:16:14', NULL),
(115, 14, 'What is the period of sine function?', 'SINGLE_CHOICE', 10, 4, '2025-02-21 20:16:14', NULL),
(116, 14, 'Which of these are trigonometric identities?', 'MULTIPLE_CHOICE', 10, 5, '2025-02-21 20:16:14', NULL),
(117, 14, 'What is the reciprocal of sine?', 'SINGLE_CHOICE', 10, 6, '2025-02-21 20:16:14', NULL),
(118, 14, 'Select all parts of a right triangle:', 'MULTIPLE_CHOICE', 10, 7, '2025-02-21 20:16:14', NULL),
(119, 14, 'Are all triangles right triangles?', 'TRUE_FALSE', 10, 8, '2025-02-21 20:16:14', NULL),
(120, 14, 'What is the range of sine function?', 'SINGLE_CHOICE', 10, 9, '2025-02-21 20:16:14', NULL),
(121, 15, 'What is the innermost layer of Earth?', 'SINGLE_CHOICE', 10, 1, '2025-02-21 20:16:14', NULL),
(122, 15, 'Select all types of rocks:', 'MULTIPLE_CHOICE', 10, 2, '2025-02-21 20:16:14', NULL),
(123, 15, 'Is the Earth perfectly spherical?', 'TRUE_FALSE', 10, 3, '2025-02-21 20:16:14', NULL),
(124, 15, 'What causes tides?', 'SINGLE_CHOICE', 10, 4, '2025-02-21 20:16:14', NULL),
(125, 15, 'Which of these are types of plate boundaries?', 'MULTIPLE_CHOICE', 10, 5, '2025-02-21 20:16:14', NULL),
(126, 15, 'What is the greenhouse effect?', 'SINGLE_CHOICE', 10, 6, '2025-02-21 20:16:14', NULL),
(127, 15, 'Select all types of weather phenomena:', 'MULTIPLE_CHOICE', 10, 7, '2025-02-21 20:16:14', NULL),
(128, 15, 'Is Earth the largest planet in our solar system?', 'TRUE_FALSE', 10, 8, '2025-02-21 20:16:14', NULL),
(129, 16, 'What is React?', 'SINGLE_CHOICE', 10, 1, '2025-02-21 20:16:14', NULL),
(130, 16, 'Select all React hooks:', 'MULTIPLE_CHOICE', 10, 2, '2025-02-21 20:16:14', NULL),
(131, 16, 'Is React a framework?', 'TRUE_FALSE', 10, 3, '2025-02-21 20:16:14', NULL),
(132, 16, 'What is JSX?', 'SINGLE_CHOICE', 10, 4, '2025-02-21 20:16:14', NULL),
(133, 16, 'Which of these are React lifecycle methods?', 'MULTIPLE_CHOICE', 10, 5, '2025-02-21 20:16:14', NULL),
(134, 16, 'What is state in React?', 'SINGLE_CHOICE', 10, 6, '2025-02-21 20:16:14', NULL),
(135, 16, 'Select all React component types:', 'MULTIPLE_CHOICE', 10, 7, '2025-02-21 20:16:14', NULL),
(136, 16, 'What is Virtual DOM?', 'SINGLE_CHOICE', 10, 8, '2025-02-21 20:16:14', NULL),
(137, 16, 'Does React use HTML?', 'TRUE_FALSE', 10, 9, '2025-02-21 20:16:14', NULL),
(138, 17, 'What is a matrix?', 'SINGLE_CHOICE', 10, 1, '2025-02-21 20:16:14', NULL),
(139, 17, 'Select all types of matrices:', 'MULTIPLE_CHOICE', 10, 2, '2025-02-21 20:16:14', NULL),
(140, 17, 'Is a vector a matrix?', 'TRUE_FALSE', 10, 3, '2025-02-21 20:16:14', NULL),
(141, 17, 'What is determinant?', 'SINGLE_CHOICE', 10, 4, '2025-02-21 20:16:14', NULL),
(142, 17, 'Which operations can be performed on matrices?', 'MULTIPLE_CHOICE', 10, 5, '2025-02-21 20:16:14', NULL),
(143, 17, 'What is an eigenvector?', 'SINGLE_CHOICE', 10, 6, '2025-02-21 20:16:14', NULL),
(144, 17, 'Select properties of identity matrix:', 'MULTIPLE_CHOICE', 10, 7, '2025-02-21 20:16:14', NULL),
(145, 17, 'What is matrix rank?', 'SINGLE_CHOICE', 10, 8, '2025-02-21 20:16:14', NULL),
(146, 17, 'Is matrix multiplication commutative?', 'TRUE_FALSE', 10, 9, '2025-02-21 20:16:14', NULL),
(147, 17, 'What is a singular matrix?', 'SINGLE_CHOICE', 10, 10, '2025-02-21 20:16:14', NULL),
(148, 18, 'What is a galaxy?', 'SINGLE_CHOICE', 10, 1, '2025-02-21 20:16:14', NULL),
(149, 18, 'Select all planets in our solar system:', 'MULTIPLE_CHOICE', 10, 2, '2025-02-21 20:16:14', NULL),
(150, 18, 'Is the Sun a star?', 'TRUE_FALSE', 10, 3, '2025-02-21 20:16:14', NULL),
(151, 18, 'What causes lunar phases?', 'SINGLE_CHOICE', 10, 4, '2025-02-21 20:16:14', NULL),
(152, 18, 'Which of these are types of galaxies?', 'MULTIPLE_CHOICE', 10, 5, '2025-02-21 20:16:14', NULL),
(153, 18, 'What is a light year?', 'SINGLE_CHOICE', 10, 6, '2025-02-21 20:16:14', NULL),
(154, 18, 'Select types of stars:', 'MULTIPLE_CHOICE', 10, 7, '2025-02-21 20:16:14', NULL),
(155, 18, 'Is Pluto a planet?', 'TRUE_FALSE', 10, 8, '2025-02-21 20:16:14', NULL),
(156, 19, 'What is normalization?', 'SINGLE_CHOICE', 10, 1, '2025-02-21 20:16:14', NULL),
(157, 19, 'Select all types of relationships:', 'MULTIPLE_CHOICE', 10, 2, '2025-02-21 20:16:14', NULL),
(158, 19, 'Is a primary key unique?', 'TRUE_FALSE', 10, 3, '2025-02-21 20:16:14', NULL),
(159, 19, 'What is a foreign key?', 'SINGLE_CHOICE', 10, 4, '2025-02-21 20:16:14', NULL),
(160, 19, 'Which of these are database constraints?', 'MULTIPLE_CHOICE', 10, 5, '2025-02-21 20:16:14', NULL),
(161, 19, 'What is an index in database?', 'SINGLE_CHOICE', 10, 6, '2025-02-21 20:16:14', NULL),
(162, 19, 'Select valid normalization forms:', 'MULTIPLE_CHOICE', 10, 7, '2025-02-21 20:16:14', NULL),
(163, 19, 'What is data integrity?', 'SINGLE_CHOICE', 10, 8, '2025-02-21 20:16:14', NULL),
(164, 19, 'Can a table have multiple primary keys?', 'TRUE_FALSE', 10, 9, '2025-02-21 20:16:14', NULL),
(165, 20, 'What is probability?', 'SINGLE_CHOICE', 10, 1, '2025-02-21 20:16:14', NULL),
(166, 20, 'Select all probability distributions:', 'MULTIPLE_CHOICE', 10, 2, '2025-02-21 20:16:14', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `quizzes`
--

CREATE TABLE `quizzes` (
  `quizz_id` bigint(20) NOT NULL,
  `category_id` bigint(20) DEFAULT NULL,
  `title` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `photo` varchar(255) DEFAULT NULL,
  `created_by` bigint(20) DEFAULT NULL,
  `time_limit` int(11) DEFAULT NULL COMMENT 'Time limit in minutes',
  `total_score` int(11) DEFAULT 0,
  `status` varchar(20) NOT NULL COMMENT 'DRAFT, PUBLISHED, ARCHIVED',
  `visibility` varchar(20) NOT NULL COMMENT 'PUBLIC, PRIVATE',
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp(),
  `deleted_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `quizzes`
--

INSERT INTO `quizzes` (`quizz_id`, `category_id`, `title`, `description`, `photo`, `created_by`, `time_limit`, `total_score`, `status`, `visibility`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 1, 'Java Basics', 'Test your Java fundamentals', NULL, 11, 1, 100, 'PUBLISHED', 'PUBLIC', '2025-02-21 20:16:13', '2025-02-21 20:16:13', NULL),
(2, 1, 'Python Programming', 'Python programming concepts', NULL, 11, 25, 80, 'PUBLISHED', 'PUBLIC', '2025-02-21 20:16:13', '2025-02-21 20:16:13', NULL),
(3, 2, 'Basic Algebra', 'Algebraic expressions and equations', NULL, 1, 20, 70, 'PUBLISHED', 'PUBLIC', '2025-02-21 20:16:13', '2025-02-21 20:16:13', NULL),
(4, 2, 'Geometry Fundamentals', 'Basic geometry concepts', NULL, 1, 30, 80, 'PUBLISHED', 'PUBLIC', '2025-02-21 20:16:13', '2025-02-21 20:16:13', NULL),
(5, 3, 'General Physics', 'Basic physics concepts', NULL, 11, 35, 70, 'PUBLISHED', 'PUBLIC', '2025-02-21 20:16:13', '2025-02-21 20:16:13', NULL),
(6, 1, 'JavaScript Basics', 'Fundamental concepts of JavaScript', NULL, 11, 30, 90, 'PUBLISHED', 'PUBLIC', '2025-02-21 20:16:13', '2025-02-21 20:16:13', NULL),
(7, 1, 'SQL Fundamentals', 'Basic SQL queries and database concepts', NULL, 11, 25, 80, 'PUBLISHED', 'PUBLIC', '2025-02-21 20:16:13', '2025-02-21 20:16:13', NULL),
(8, 2, 'Calculus Basics', 'Introduction to calculus concepts', NULL, 1, 35, 100, 'PUBLISHED', 'PUBLIC', '2025-02-21 20:16:13', '2025-02-21 20:16:13', NULL),
(9, 3, 'Chemistry Basics', 'Fundamental chemistry concepts', NULL, 11, 30, 90, 'PUBLISHED', 'PUBLIC', '2025-02-21 20:16:13', '2025-02-21 20:16:13', NULL),
(10, 3, 'Biology Essentials', 'Basic concepts in biology', NULL, 11, 25, 80, 'PUBLISHED', 'PUBLIC', '2025-02-21 20:16:13', '2025-02-21 20:16:13', NULL),
(11, 2, 'Statistics Basics', 'Introduction to statistical concepts', NULL, 1, 30, 90, 'PUBLISHED', 'PUBLIC', '2025-02-21 20:16:14', '2025-02-21 20:16:14', NULL),
(12, 3, 'Organic Chemistry', 'Basic organic chemistry concepts', NULL, 11, 35, 100, 'PUBLISHED', 'PUBLIC', '2025-02-21 20:16:14', '2025-02-21 20:16:14', NULL),
(13, 1, 'HTML and CSS', 'Web development fundamentals', NULL, 11, 25, 80, 'PUBLISHED', 'PUBLIC', '2025-02-21 20:16:14', '2025-02-21 20:16:14', NULL),
(14, 2, 'Trigonometry', 'Basic trigonometric concepts', NULL, 1, 30, 90, 'PUBLISHED', 'PUBLIC', '2025-02-21 20:16:14', '2025-02-21 20:16:14', NULL),
(15, 3, 'Earth Science', 'Fundamentals of earth science', NULL, 11, 25, 80, 'PUBLISHED', 'PUBLIC', '2025-02-21 20:16:14', '2025-02-21 20:16:14', NULL),
(16, 1, 'React Fundamentals', 'Basic concepts of React.js', NULL, 11, 30, 90, 'PUBLISHED', 'PUBLIC', '2025-02-21 20:16:14', '2025-02-21 20:16:14', NULL),
(17, 2, 'Linear Algebra', 'Fundamentals of linear algebra', NULL, 1, 35, 100, 'PUBLISHED', 'PUBLIC', '2025-02-21 20:16:14', '2025-02-21 20:16:14', NULL),
(18, 3, 'Astronomy Basics', 'Introduction to astronomy', NULL, 11, 25, 80, 'PUBLISHED', 'PUBLIC', '2025-02-21 20:16:14', '2025-02-21 20:16:14', NULL),
(19, 1, 'Database Design', 'Fundamentals of database design', NULL, 11, 30, 90, 'PUBLISHED', 'PUBLIC', '2025-02-21 20:16:14', '2025-02-21 20:16:14', NULL),
(20, 2, 'Probability Theory', 'Basic concepts of probability', NULL, 1, 2, 20, 'PUBLISHED', 'PUBLIC', '2025-02-21 20:16:14', '2025-02-21 20:16:14', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `quizz_attempts`
--

CREATE TABLE `quizz_attempts` (
  `attempt_id` bigint(20) NOT NULL,
  `quizz_id` bigint(20) DEFAULT NULL,
  `user_id` bigint(20) DEFAULT NULL,
  `start_time` datetime NOT NULL,
  `end_time` datetime DEFAULT NULL,
  `score` int(11) DEFAULT 0,
  `status` varchar(20) DEFAULT NULL COMMENT 'IN_PROGRESS, COMPLETED, TIMEOUT',
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `quizz_attempts`
--

INSERT INTO `quizz_attempts` (`attempt_id`, `quizz_id`, `user_id`, `start_time`, `end_time`, `score`, `status`, `created_at`) VALUES
(1, 1, 1, '2025-03-07 19:02:33', '2025-03-07 19:02:43', 20, 'COMPLETED', '2025-03-07 19:02:33'),
(2, 1, 1, '2025-03-07 19:02:49', '2025-03-07 19:16:43', 0, 'TIMEOUT', '2025-03-07 19:02:49'),
(3, 1, 1, '2025-03-07 19:16:48', '2025-03-07 19:16:54', 20, 'COMPLETED', '2025-03-07 19:16:48'),
(4, 1, 1, '2025-03-07 19:17:00', '2025-03-07 21:15:03', 0, 'TIMEOUT', '2025-03-07 19:17:00'),
(5, 1, 1, '2025-03-07 21:15:07', '2025-03-07 21:15:19', 20, 'COMPLETED', '2025-03-07 21:15:07'),
(6, 1, 1, '2025-03-07 21:15:33', '2025-03-07 21:19:14', 0, 'TIMEOUT', '2025-03-07 21:15:33'),
(7, 1, 1, '2025-03-07 21:19:18', '2025-03-07 21:19:27', 30, 'COMPLETED', '2025-03-07 21:19:18'),
(8, 1, 1, '2025-03-07 21:19:43', '2025-03-07 21:49:33', 0, 'TIMEOUT', '2025-03-07 21:19:43'),
(9, 1, 1, '2025-03-07 21:49:37', '2025-03-07 21:49:48', 20, 'COMPLETED', '2025-03-07 21:49:37'),
(10, 1, 1, '2025-03-07 21:49:56', '2025-03-07 22:23:41', 0, 'TIMEOUT', '2025-03-07 21:49:56'),
(11, 1, 1, '2025-03-07 22:23:46', '2025-03-07 22:23:56', 20, 'COMPLETED', '2025-03-07 22:23:46'),
(12, 1, 1, '2025-03-07 22:24:13', '2025-03-07 22:36:05', 0, 'TIMEOUT', '2025-03-07 22:24:13'),
(38, 1, 1, '2025-03-08 12:06:24', '2025-03-08 12:06:45', 20, 'COMPLETED', '2025-03-08 12:06:24'),
(39, 1, 1, '2025-03-08 12:07:05', '2025-03-08 12:08:24', 0, 'TIMEOUT', '2025-03-08 12:07:05'),
(40, 2, 1, '2025-03-08 12:07:12', NULL, NULL, 'IN_PROGRESS', '2025-03-08 12:07:12'),
(41, 1, 1, '2025-03-08 12:31:43', '2025-03-08 12:32:59', 10, 'TIMEOUT', '2025-03-08 12:31:43'),
(42, 14, 1, '2025-03-08 12:31:59', '2025-03-08 12:34:09', 20, 'COMPLETED', '2025-03-08 12:31:59'),
(43, 10, 1, '2025-03-08 12:32:16', '2025-03-08 12:33:37', 40, 'COMPLETED', '2025-03-08 12:32:16'),
(44, 7, 1, '2025-03-08 12:32:29', NULL, NULL, 'IN_PROGRESS', '2025-03-08 12:32:29'),
(45, 11, 1, '2025-03-08 12:32:33', NULL, NULL, 'IN_PROGRESS', '2025-03-08 12:32:33'),
(46, 20, 1, '2025-03-08 12:32:49', '2025-03-08 12:34:32', 10, 'COMPLETED', '2025-03-08 12:32:49'),
(47, 15, 1, '2025-03-08 12:32:54', NULL, NULL, 'IN_PROGRESS', '2025-03-08 12:32:54'),
(48, 6, 1, '2025-03-08 12:33:25', NULL, NULL, 'IN_PROGRESS', '2025-03-08 12:33:25'),
(49, 1, 15, '2025-03-08 14:24:31', '2025-03-08 14:26:01', 50, 'TIMEOUT', '2025-03-08 14:24:31'),
(50, 1, 15, '2025-03-08 14:36:05', '2025-03-08 14:36:15', 30, 'COMPLETED', '2025-03-08 14:36:05'),
(51, 2, 15, '2025-03-08 14:36:45', NULL, 30, 'IN_PROGRESS', '2025-03-08 14:36:45'),
(52, 1, 15, '2025-03-08 14:36:50', '2025-03-08 14:38:02', 40, 'TIMEOUT', '2025-03-08 14:36:50');

-- --------------------------------------------------------

--
-- Table structure for table `rankings`
--

CREATE TABLE `rankings` (
  `ranking_id` bigint(20) NOT NULL,
  `user_id` bigint(20) DEFAULT NULL,
  `total_score` int(11) DEFAULT 0,
  `quizzes_completed` int(11) DEFAULT 0,
  `correct_answers` int(11) DEFAULT 0,
  `rank_position` int(11) DEFAULT NULL,
  `updated_at` datetime DEFAULT current_timestamp(),
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `user_id` bigint(20) NOT NULL,
  `username` varchar(50) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role` varchar(20) NOT NULL COMMENT 'ADMIN, USER',
  `profile_image` varchar(255) DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT 1,
  `created_at` datetime DEFAULT current_timestamp(),
  `deleted_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`user_id`, `username`, `email`, `password`, `role`, `profile_image`, `is_active`, `created_at`, `deleted_at`) VALUES
(1, 'test', 'test@gmail.com', '$2a$10$AgcYpi/4sc2DDjGEQF2FSePgd44Lk5uEEP1J7W4Esis01POUppJ5m', 'ROLE_USER', NULL, 1, '2025-02-12 17:17:16', NULL),
(2, 'test1', 'test1@gmail.com', '$2a$10$yLZOkCTAeEn3r6USRxIJoOaJeTGMx7NlFgb1KToS9RKFAyQY2TEPa', 'USER', NULL, 1, '2025-02-12 17:18:48', NULL),
(3, 'test2', 'test2@gmail.com', '$2a$10$VixUMkjh5D.jAF.PFRjZV.pkBjR/HWkEMLJO9WXynCILuJ1d9G3UK', 'USER', NULL, 0, '2025-02-12 17:21:07', NULL),
(4, 'test3', 'test3@gmail.com', '$2a$10$Hz.kWIeutoItsgfY9wbcLul0hJBDE0VjnLSsDb0MsTp3uq4R8GAM.', 'USER', NULL, 1, '2025-02-12 17:24:22', NULL),
(5, 'test4', 'test4@gmail.com', '$2a$10$Lq.Es8qZFyZprnPHaNz7vuFXlCKSs8I241aYpTzWXz5WypGmJ9Nqm', 'USER', NULL, 0, '2025-02-12 17:27:20', NULL),
(6, 'test5', 'test5@gmail.com', '$2a$10$h1eKDpF5ucWdbtMyL1pxOOv8yZ9KnTtkdLiSo44poKJADaYd1vUke', 'USER', NULL, 0, '2025-02-12 17:30:40', NULL),
(7, 'test6', 'test6@gmail.com', '$2a$10$lInas2v8bwWcMByLRjs37.kIa1zoljIRq/SqTkX0sg0Z0Fy4JGJk6', 'USER', NULL, 0, '2025-02-12 17:31:46', NULL),
(10, 'than', 'than@gmail.com', '$2a$10$MzdNik8CDWZ6sbuudHhR6uMXzqm5DPyuQlc7DuIhFreznKQxNlYuq', 'ROLE_ADMIN', NULL, 1, '2025-02-12 22:16:35', NULL),
(11, 'admin', 'admin@gmail.com', '$2a$10$/zKkboZrc5pb6Yl807Z6HOp3JTXRXgT5VljXhy8VhRdTbLQXN94mS', 'ROLE_ADMIN', NULL, 1, '2025-02-12 22:18:31', NULL),
(12, 'user', 'user@gmail.com', '$2a$10$PDsjagw2/8oVSs0/gn8bSOsYKlYjzskIvmbTnTjtdG8bWUOmOx46S', 'ROLE_USER', NULL, 0, '2025-02-13 14:12:57', NULL),
(13, 'than1', 'than1@gmail.com', '$2a$10$meAzetT5DKN4Oz1SW0wsP.y/RAmCN23uxES8Sb0jzxqhjhNawMlCO', 'ROLE_USER', NULL, 0, '2025-02-13 15:17:56', NULL),
(14, 'than123', 'than123@gmail.com', '$2a$10$CIEyZ/ttvv47uZKNlBqN2OTP90asHVGyDAuxETCc6pVrCViSPzgci', 'ROLE_USER', NULL, 1, '2025-02-18 14:35:26', NULL),
(15, 'krantz', 'nguyenminhthan1308@gmail.com', '$2a$10$uySauE/zA6TaPtUVEd/o7ukb.0tnH7N0CKDuLRnVx1oQSw10OrBsK', 'ROLE_USER', NULL, 1, '2025-03-08 14:22:47', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `user_answers`
--

CREATE TABLE `user_answers` (
  `user_answer_id` bigint(20) NOT NULL,
  `attempt_id` bigint(20) DEFAULT NULL,
  `question_id` bigint(20) DEFAULT NULL,
  `answer_id` bigint(20) DEFAULT NULL,
  `is_correct` tinyint(1) DEFAULT 0,
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `user_answers`
--

INSERT INTO `user_answers` (`user_answer_id`, `attempt_id`, `question_id`, `answer_id`, `is_correct`, `created_at`) VALUES
(404, 1, 1, 1, NULL, '2025-03-07 19:02:35'),
(408, 1, 2, 5, NULL, '2025-03-07 19:02:37'),
(409, 1, 2, 6, NULL, '2025-03-07 19:02:37'),
(410, 1, 2, 7, NULL, '2025-03-07 19:02:37'),
(411, 1, 3, 9, NULL, '2025-03-07 19:02:41'),
(412, 3, 1, 1, NULL, '2025-03-07 19:16:49'),
(416, 3, 2, 5, NULL, '2025-03-07 19:16:51'),
(417, 3, 2, 6, NULL, '2025-03-07 19:16:51'),
(418, 3, 2, 7, NULL, '2025-03-07 19:16:51'),
(419, 3, 3, 9, NULL, '2025-03-07 19:16:52'),
(420, 5, 1, 1, NULL, '2025-03-07 21:15:09'),
(424, 5, 2, 5, NULL, '2025-03-07 21:15:11'),
(425, 5, 2, 6, NULL, '2025-03-07 21:15:11'),
(426, 5, 2, 7, NULL, '2025-03-07 21:15:11'),
(427, 5, 3, 9, NULL, '2025-03-07 21:15:12'),
(428, 5, 4, 12, NULL, '2025-03-07 21:15:13'),
(430, 5, 8, 25, NULL, '2025-03-07 21:15:16'),
(431, 5, 8, 27, NULL, '2025-03-07 21:15:16'),
(432, 7, 1, 1, NULL, '2025-03-07 21:19:19'),
(434, 7, 2, 5, NULL, '2025-03-07 21:19:21'),
(435, 7, 2, 7, NULL, '2025-03-07 21:19:21'),
(436, 7, 3, 9, NULL, '2025-03-07 21:19:23'),
(440, 7, 8, 25, NULL, '2025-03-07 21:19:25'),
(441, 7, 8, 26, NULL, '2025-03-07 21:19:25'),
(442, 7, 8, 27, NULL, '2025-03-07 21:19:25'),
(443, 9, 1, 1, NULL, '2025-03-07 21:49:39'),
(450, 9, 3, 9, NULL, '2025-03-07 21:49:43'),
(462, 9, 2, 7, NULL, '2025-03-07 21:49:46'),
(463, 9, 2, 5, NULL, '2025-03-07 21:49:46'),
(464, 9, 2, 6, NULL, '2025-03-07 21:49:46'),
(465, 11, 1, 1, NULL, '2025-03-07 22:23:48'),
(469, 11, 2, 5, NULL, '2025-03-07 22:23:50'),
(470, 11, 2, 6, NULL, '2025-03-07 22:23:50'),
(471, 11, 2, 7, NULL, '2025-03-07 22:23:50'),
(472, 11, 3, 9, NULL, '2025-03-07 22:23:51'),
(474, 11, 8, 26, NULL, '2025-03-07 22:23:54'),
(475, 11, 8, 27, NULL, '2025-03-07 22:23:54'),
(582, 38, 2, 5, NULL, '2025-03-08 12:06:27'),
(583, 38, 2, 6, NULL, '2025-03-08 12:06:27'),
(584, 38, 2, 7, NULL, '2025-03-08 12:06:27'),
(585, 38, 1, 1, NULL, '2025-03-08 12:06:29'),
(586, 38, 3, 10, NULL, '2025-03-08 12:06:30'),
(588, 38, 4, 12, NULL, '2025-03-08 12:06:32'),
(592, 38, 5, 15, NULL, '2025-03-08 12:06:34'),
(593, 38, 5, 16, NULL, '2025-03-08 12:06:34'),
(594, 38, 5, 17, NULL, '2025-03-08 12:06:34'),
(595, 38, 6, 19, NULL, '2025-03-08 12:06:36'),
(596, 38, 7, 22, NULL, '2025-03-08 12:06:37'),
(598, 38, 8, 25, NULL, '2025-03-08 12:06:40'),
(599, 38, 8, 27, NULL, '2025-03-08 12:06:40'),
(600, 38, 9, 30, NULL, '2025-03-08 12:06:42'),
(601, 38, 10, 33, NULL, '2025-03-08 12:06:43'),
(602, 40, 11, 36, NULL, '2025-03-08 12:07:14'),
(603, 40, 12, 37, NULL, '2025-03-08 12:07:15'),
(605, 40, 13, 42, NULL, '2025-03-08 12:07:16'),
(606, 40, 13, 44, NULL, '2025-03-08 12:07:16'),
(607, 39, 1, 2, NULL, '2025-03-08 12:07:57'),
(608, 41, 1, 1, NULL, '2025-03-08 12:31:46'),
(612, 41, 2, 6, NULL, '2025-03-08 12:31:49'),
(613, 41, 2, 5, NULL, '2025-03-08 12:31:49'),
(614, 41, 2, 7, NULL, '2025-03-08 12:31:49'),
(616, 41, 4, 12, NULL, '2025-03-08 12:31:51'),
(619, 41, 10, 34, NULL, '2025-03-08 12:31:53'),
(621, 41, 8, 26, NULL, '2025-03-08 12:31:55'),
(622, 41, 8, 27, NULL, '2025-03-08 12:31:55'),
(623, 42, 112, 391, NULL, '2025-03-08 12:32:01'),
(624, 42, 114, 400, NULL, '2025-03-08 12:32:02'),
(625, 42, 115, 401, NULL, '2025-03-08 12:32:03'),
(627, 42, 113, 396, NULL, '2025-03-08 12:32:05'),
(628, 42, 113, 397, NULL, '2025-03-08 12:32:05'),
(629, 42, 117, 410, NULL, '2025-03-08 12:32:06'),
(630, 42, 120, 420, NULL, '2025-03-08 12:32:07'),
(632, 42, 116, 405, NULL, '2025-03-08 12:32:09'),
(633, 42, 116, 407, NULL, '2025-03-08 12:32:09'),
(634, 42, 119, 418, NULL, '2025-03-08 12:32:10'),
(635, 42, 118, 414, NULL, '2025-03-08 12:32:13'),
(638, 43, 78, 272, NULL, '2025-03-08 12:32:19'),
(639, 43, 78, 273, NULL, '2025-03-08 12:32:19'),
(640, 43, 79, 275, NULL, '2025-03-08 12:32:20'),
(641, 43, 80, 277, NULL, '2025-03-08 12:32:21'),
(642, 43, 81, 282, NULL, '2025-03-08 12:32:22'),
(643, 43, 82, 287, NULL, '2025-03-08 12:32:23'),
(644, 43, 83, 292, NULL, '2025-03-08 12:32:25'),
(645, 43, 84, 293, NULL, '2025-03-08 12:32:26'),
(648, 43, 77, 267, NULL, '2025-03-08 12:32:42'),
(649, 46, 165, 579, NULL, '2025-03-08 12:32:51'),
(650, 49, 1, 1, 1, '2025-03-08 14:24:34'),
(654, 49, 2, 5, 1, '2025-03-08 14:25:07'),
(655, 49, 2, 6, 1, '2025-03-08 14:25:07'),
(656, 49, 2, 8, 1, '2025-03-08 14:25:07'),
(657, 49, 3, 9, 1, '2025-03-08 14:25:09'),
(659, 49, 4, 13, 0, '2025-03-08 14:25:11'),
(660, 50, 1, 1, 1, '2025-03-08 14:36:06'),
(664, 50, 2, 5, 1, '2025-03-08 14:36:08'),
(665, 50, 2, 6, 1, '2025-03-08 14:36:08'),
(666, 50, 2, 8, 1, '2025-03-08 14:36:08'),
(667, 50, 3, 9, 1, '2025-03-08 14:36:09'),
(668, 50, 4, 13, 0, '2025-03-08 14:36:12'),
(669, 50, 8, 27, 0, '2025-03-08 14:36:13'),
(670, 51, 11, 35, 1, '2025-03-08 14:36:46'),
(671, 51, 14, 45, 1, '2025-03-08 14:36:47'),
(672, 51, 18, 57, 1, '2025-03-08 14:36:48'),
(673, 52, 1, 1, 1, '2025-03-08 14:36:51'),
(674, 52, 9, 29, 0, '2025-03-08 14:36:52'),
(678, 52, 2, 5, 1, '2025-03-08 14:37:12'),
(679, 52, 2, 6, 1, '2025-03-08 14:37:12'),
(680, 52, 2, 8, 1, '2025-03-08 14:37:12'),
(681, 52, 7, 23, 0, '2025-03-08 14:37:15'),
(683, 52, 8, 26, 0, '2025-03-08 14:37:17'),
(684, 52, 8, 27, 0, '2025-03-08 14:37:17'),
(686, 52, 5, 15, 0, '2025-03-08 14:37:20'),
(687, 52, 5, 17, 0, '2025-03-08 14:37:20'),
(688, 52, 6, 19, 0, '2025-03-08 14:37:21'),
(689, 52, 3, 9, 1, '2025-03-08 14:37:22'),
(690, 52, 4, 12, 0, '2025-03-08 14:37:24'),
(691, 52, 10, 31, 1, '2025-03-08 14:37:25');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `answers`
--
ALTER TABLE `answers`
  ADD PRIMARY KEY (`answer_id`),
  ADD KEY `question_id` (`question_id`);

--
-- Indexes for table `categories`
--
ALTER TABLE `categories`
  ADD PRIMARY KEY (`category_id`);

--
-- Indexes for table `questions`
--
ALTER TABLE `questions`
  ADD PRIMARY KEY (`question_id`),
  ADD KEY `quizz_id` (`quizz_id`);

--
-- Indexes for table `quizzes`
--
ALTER TABLE `quizzes`
  ADD PRIMARY KEY (`quizz_id`),
  ADD KEY `created_by` (`created_by`),
  ADD KEY `idx_quiz_status` (`status`),
  ADD KEY `idx_quiz_visibility` (`visibility`),
  ADD KEY `idx_quiz_category` (`category_id`);

--
-- Indexes for table `quizz_attempts`
--
ALTER TABLE `quizz_attempts`
  ADD PRIMARY KEY (`attempt_id`),
  ADD KEY `quizz_id` (`quizz_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `rankings`
--
ALTER TABLE `rankings`
  ADD PRIMARY KEY (`ranking_id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `idx_ranking_score` (`total_score`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`user_id`),
  ADD UNIQUE KEY `username` (`username`),
  ADD UNIQUE KEY `email` (`email`),
  ADD UNIQUE KEY `UK6dotkott2kjsp8vw4d0m25fb7` (`email`),
  ADD UNIQUE KEY `UKr43af9ap4edm43mmtq01oddj6` (`username`),
  ADD KEY `idx_user_email` (`email`),
  ADD KEY `idx_user_username` (`username`);

--
-- Indexes for table `user_answers`
--
ALTER TABLE `user_answers`
  ADD PRIMARY KEY (`user_answer_id`),
  ADD KEY `attempt_id` (`attempt_id`),
  ADD KEY `question_id` (`question_id`),
  ADD KEY `answer_id` (`answer_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `answers`
--
ALTER TABLE `answers`
  MODIFY `answer_id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=607;

--
-- AUTO_INCREMENT for table `categories`
--
ALTER TABLE `categories`
  MODIFY `category_id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `questions`
--
ALTER TABLE `questions`
  MODIFY `question_id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=173;

--
-- AUTO_INCREMENT for table `quizzes`
--
ALTER TABLE `quizzes`
  MODIFY `quizz_id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT for table `quizz_attempts`
--
ALTER TABLE `quizz_attempts`
  MODIFY `attempt_id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=53;

--
-- AUTO_INCREMENT for table `rankings`
--
ALTER TABLE `rankings`
  MODIFY `ranking_id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `user_id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `user_answers`
--
ALTER TABLE `user_answers`
  MODIFY `user_answer_id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=692;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `answers`
--
ALTER TABLE `answers`
  ADD CONSTRAINT `answers_ibfk_1` FOREIGN KEY (`question_id`) REFERENCES `questions` (`question_id`);

--
-- Constraints for table `questions`
--
ALTER TABLE `questions`
  ADD CONSTRAINT `questions_ibfk_1` FOREIGN KEY (`quizz_id`) REFERENCES `quizzes` (`quizz_id`);

--
-- Constraints for table `quizzes`
--
ALTER TABLE `quizzes`
  ADD CONSTRAINT `quizzes_ibfk_1` FOREIGN KEY (`created_by`) REFERENCES `users` (`user_id`),
  ADD CONSTRAINT `quizzes_ibfk_2` FOREIGN KEY (`category_id`) REFERENCES `categories` (`category_id`);

--
-- Constraints for table `quizz_attempts`
--
ALTER TABLE `quizz_attempts`
  ADD CONSTRAINT `quizz_attempts_ibfk_1` FOREIGN KEY (`quizz_id`) REFERENCES `quizzes` (`quizz_id`),
  ADD CONSTRAINT `quizz_attempts_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`);

--
-- Constraints for table `rankings`
--
ALTER TABLE `rankings`
  ADD CONSTRAINT `rankings_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`);

--
-- Constraints for table `user_answers`
--
ALTER TABLE `user_answers`
  ADD CONSTRAINT `user_answers_ibfk_2` FOREIGN KEY (`question_id`) REFERENCES `questions` (`question_id`),
  ADD CONSTRAINT `user_answers_ibfk_3` FOREIGN KEY (`answer_id`) REFERENCES `answers` (`answer_id`),
  ADD CONSTRAINT `user_answers_quizz_attempts_fk` FOREIGN KEY (`attempt_id`) REFERENCES `quizz_attempts` (`attempt_id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
