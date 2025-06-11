-- Delete all data from tables
DELETE FROM answers;
DELETE FROM questions;
DELETE FROM quizzes;
DELETE FROM categories;

-- Reset auto-increment to 1 for all tables
ALTER TABLE answers AUTO_INCREMENT = 1;
ALTER TABLE questions AUTO_INCREMENT = 1;
ALTER TABLE quizzes AUTO_INCREMENT = 1;
ALTER TABLE categories AUTO_INCREMENT = 1;
-- Insert Categories
INSERT INTO categories (category_id, name, description, created_at) VALUES
(1, 'Programming', 'All about programming languages and concepts', NOW()),
(2, 'Mathematics', 'Mathematical concepts and problems', NOW()),
(3, 'Science', 'General science topics', NOW());

-- Insert Quizzes
INSERT INTO quizzes (quizz_id, category_id, created_by, title, description, time_limit, total_score, status, visibility, created_at) VALUES
(1, 1, 11, 'Java Basics', 'Test your Java fundamentals', 30, 100, 'PUBLISHED', 'PUBLIC', NOW()),
(2, 1, 11, 'Python Programming', 'Python programming concepts', 25, 80, 'PUBLISHED', 'PUBLIC', NOW()),
(3, 2, 1, 'Basic Algebra', 'Algebraic expressions and equations', 20, 70, 'PUBLISHED', 'PUBLIC', NOW()),
(4, 2, 1, 'Geometry Fundamentals', 'Basic geometry concepts', 30, 80, 'PUBLISHED', 'PUBLIC', NOW()),
(5, 3, 11, 'General Physics', 'Basic physics concepts', 35, 70, 'PUBLISHED', 'PUBLIC', NOW());

-- Insert Questions for Quiz 1: Java Basics (10 questions)
INSERT INTO questions (question_id, quizz_id, question_text, question_type, score, order_index, created_at) VALUES
(1, 1, 'What is Java?', 'SINGLE_CHOICE', 10, 1, NOW()),
(2, 1, 'Which of these are Java keywords?', 'MULTIPLE_CHOICE', 10, 2, NOW()),
(3, 1, 'Java is platform independent?', 'TRUE_FALSE', 10, 3, NOW()),
(4, 1, 'What is the main method signature in Java?', 'SINGLE_CHOICE', 10, 4, NOW()),
(5, 1, 'Select all valid Java variable names:', 'MULTIPLE_CHOICE', 10, 5, NOW()),
(6, 1, 'Java supports multiple inheritance through classes?', 'TRUE_FALSE', 10, 6, NOW()),
(7, 1, 'What is the default value of int in Java?', 'SINGLE_CHOICE', 10, 7, NOW()),
(8, 1, 'Which of these are valid access modifiers in Java?', 'MULTIPLE_CHOICE', 10, 8, NOW()),
(9, 1, 'Java is purely object oriented?', 'TRUE_FALSE', 10, 9, NOW()),
(10, 1, 'What is the size of double in Java?', 'SINGLE_CHOICE', 10, 10, NOW());

-- Insert Questions for Quiz 2: Python Programming (8 questions)
INSERT INTO questions (question_id, quizz_id, question_text, question_type, score, order_index, created_at) VALUES
(11, 2, 'Python is an interpreted language?', 'TRUE_FALSE', 10, 1, NOW()),
(12, 2, 'What is the Python package manager called?', 'SINGLE_CHOICE', 10, 2, NOW()),
(13, 2, 'Select all valid Python data types:', 'MULTIPLE_CHOICE', 10, 3, NOW()),
(14, 2, 'Python supports multiple inheritance?', 'TRUE_FALSE', 10, 4, NOW()),
(15, 2, 'What is the correct file extension for Python files?', 'SINGLE_CHOICE', 10, 5, NOW()),
(16, 2, 'Which of these are Python keywords?', 'MULTIPLE_CHOICE', 10, 6, NOW()),
(17, 2, 'Is indentation important in Python?', 'TRUE_FALSE', 10, 7, NOW()),
(18, 2, 'What is the correct way to create a function in Python?', 'SINGLE_CHOICE', 10, 8, NOW());

-- Insert Questions for Quiz 3: Basic Algebra (7 questions)
INSERT INTO questions (question_id, quizz_id, question_text, question_type, score, order_index, created_at) VALUES
(19, 3, 'What is the value of x in 2x + 3 = 7?', 'SINGLE_CHOICE', 10, 1, NOW()),
(20, 3, 'Select all expressions that equal 10:', 'MULTIPLE_CHOICE', 10, 2, NOW()),
(21, 3, 'Is -(-2) equal to 2?', 'TRUE_FALSE', 10, 3, NOW()),
(22, 3, 'Solve for x: 3x - 4 = 8', 'SINGLE_CHOICE', 10, 4, NOW()),
(23, 3, 'Which of these are quadratic equations?', 'MULTIPLE_CHOICE', 10, 5, NOW()),
(24, 3, 'Is the square root of a negative number a real number?', 'TRUE_FALSE', 10, 6, NOW()),
(25, 3, 'What is the value of x² when x = 3?', 'SINGLE_CHOICE', 10, 7, NOW());

-- Insert Questions for Quiz 4: Geometry Fundamentals (8 questions)
INSERT INTO questions (question_id, quizz_id, question_text, question_type, score, order_index, created_at) VALUES
(26, 4, 'What is the area formula for a rectangle?', 'SINGLE_CHOICE', 10, 1, NOW()),
(27, 4, 'Select all shapes that are polygons:', 'MULTIPLE_CHOICE', 10, 2, NOW()),
(28, 4, 'Are all squares rectangles?', 'TRUE_FALSE', 10, 3, NOW()),
(29, 4, 'What is the sum of angles in a triangle?', 'SINGLE_CHOICE', 10, 4, NOW()),
(30, 4, 'Which of these are types of triangles?', 'MULTIPLE_CHOICE', 10, 5, NOW()),
(31, 4, 'Is a circle a polygon?', 'TRUE_FALSE', 10, 6, NOW()),
(32, 4, 'What is the formula for the circumference of a circle?', 'SINGLE_CHOICE', 10, 7, NOW()),
(33, 4, 'Select all true statements about parallelograms:', 'MULTIPLE_CHOICE', 10, 8, NOW());

-- Insert Questions for Quiz 5: General Physics (7 questions)
INSERT INTO questions (question_id, quizz_id, question_text, question_type, score, order_index, created_at) VALUES
(34, 5, 'What is the SI unit of force?', 'SINGLE_CHOICE', 10, 1, NOW()),
(35, 5, 'Select all scalar quantities:', 'MULTIPLE_CHOICE', 10, 2, NOW()),
(36, 5, 'Is momentum a vector quantity?', 'TRUE_FALSE', 10, 3, NOW()),
(37, 5, 'What is the formula for force?', 'SINGLE_CHOICE', 10, 4, NOW()),
(38, 5, 'Which of these are forms of energy?', 'MULTIPLE_CHOICE', 10, 5, NOW()),
(39, 5, 'Does light travel faster than sound?', 'TRUE_FALSE', 10, 6, NOW()),
(40, 5, 'What is the unit of electric current?', 'SINGLE_CHOICE', 10, 7, NOW());

-- Insert Answers for Quiz 1 questions
INSERT INTO answers (answer_id, question_id, answer_text, is_correct, order_index, created_at) VALUES
-- For Question 1 (SINGLE_CHOICE)
(1, 1, 'A programming language', TRUE, 1, NOW()),
(2, 1, 'A type of coffee', FALSE, 2, NOW()),
(3, 1, 'An operating system', FALSE, 3, NOW()),
(4, 1, 'A database', FALSE, 4, NOW()),

-- For Question 2 (MULTIPLE_CHOICE)
(5, 2, 'class', TRUE, 1, NOW()),
(6, 2, 'static', TRUE, 2, NOW()),
(7, 2, 'array', FALSE, 3, NOW()),
(8, 2, 'void', TRUE, 4, NOW()),

-- For Question 3 (TRUE_FALSE)
(9, 3, 'True', TRUE, 1, NOW()),
(10, 3, 'False', FALSE, 2, NOW()),

-- For Question 4 (SINGLE_CHOICE)
(11, 4, 'public static void main(String[] args)', TRUE, 1, NOW()),
(12, 4, 'public void main(String[] args)', FALSE, 2, NOW()),
(13, 4, 'void main()', FALSE, 3, NOW()),
(14, 4, 'static void main()', FALSE, 4, NOW()),

-- For Question 5 (MULTIPLE_CHOICE)
(15, 5, 'myVariable', TRUE, 1, NOW()),
(16, 5, '_value', TRUE, 2, NOW()),
(17, 5, '2variable', FALSE, 3, NOW()),
(18, 5, '$price', TRUE, 4, NOW()),

-- For Question 6 (TRUE_FALSE)
(19, 6, 'True', FALSE, 1, NOW()),
(20, 6, 'False', TRUE, 2, NOW()),

-- For Question 7 (SINGLE_CHOICE)
(21, 7, '0', TRUE, 1, NOW()),
(22, 7, 'null', FALSE, 2, NOW()),
(23, 7, '1', FALSE, 3, NOW()),
(24, 7, 'undefined', FALSE, 4, NOW()),

-- For Question 8 (MULTIPLE_CHOICE)
(25, 8, 'public', TRUE, 1, NOW()),
(26, 8, 'private', TRUE, 2, NOW()),
(27, 8, 'protected', TRUE, 3, NOW()),
(28, 8, 'friend', FALSE, 4, NOW()),

-- For Question 9 (TRUE_FALSE)
(29, 9, 'True', FALSE, 1, NOW()),
(30, 9, 'False', TRUE, 2, NOW()),

-- For Question 10 (SINGLE_CHOICE)
(31, 10, '8 bytes', TRUE, 1, NOW()),
(32, 10, '4 bytes', FALSE, 2, NOW()),
(33, 10, '2 bytes', FALSE, 3, NOW()),
(34, 10, '16 bytes', FALSE, 4, NOW());

-- Sample answers for Python quiz questions
INSERT INTO answers (question_id, answer_text, is_correct, order_index, created_at) VALUES
-- For Question 11 (TRUE_FALSE)
(11, 'True', TRUE, 1, NOW()),
(11, 'False', FALSE, 2, NOW()),

-- For Question 12 (SINGLE_CHOICE)
(12, 'pip', TRUE, 1, NOW()),
(12, 'npm', FALSE, 2, NOW()),
(12, 'yarn', FALSE, 3, NOW()),
(12, 'gradle', FALSE, 4, NOW()),

-- For Question 13 (MULTIPLE_CHOICE)
(13, 'int', TRUE, 1, NOW()),
(13, 'str', TRUE, 2, NOW()),
(13, 'list', TRUE, 3, NOW()),
(13, 'array', FALSE, 4, NOW()),

-- For Question 14 (TRUE_FALSE)
(14, 'True', TRUE, 1, NOW()),
(14, 'False', FALSE, 2, NOW()),

-- For Question 15 (SINGLE_CHOICE)
(15, '.py', TRUE, 1, NOW()),
(15, '.python', FALSE, 2, NOW()),
(15, '.pt', FALSE, 3, NOW()),
(15, '.pyt', FALSE, 4, NOW()),

-- For Question 16 (MULTIPLE_CHOICE) 
(16, 'def', TRUE, 1, NOW()),
(16, 'if', TRUE, 2, NOW()),
(16, 'function', FALSE, 3, NOW()),
(16, 'while', TRUE, 4, NOW()),

-- For Question 17 (TRUE_FALSE)
(17, 'True', TRUE, 1, NOW()),
(17, 'False', FALSE, 2, NOW()),

-- For Question 18 (SINGLE_CHOICE)
(18, 'def function_name():', TRUE, 1, NOW()),
(18, 'function function_name():', FALSE, 2, NOW()),
(18, 'func function_name():', FALSE, 3, NOW()),
(18, 'define function_name():', FALSE, 4, NOW());

-- Answers for Basic Algebra Quiz (Quiz 3)
INSERT INTO answers (answer_id, question_id, answer_text, is_correct, order_index, created_at) VALUES
-- Question 19
(61, 19, '2', TRUE, 1, NOW()),
(62, 19, '3', FALSE, 2, NOW()),
(63, 19, '4', FALSE, 3, NOW()),
(64, 19, '5', FALSE, 4, NOW()),

-- Question 20
(65, 20, '5 + 5', TRUE, 1, NOW()),
(66, 20, '2 * 5', TRUE, 2, NOW()),
(67, 20, '15 - 5', TRUE, 3, NOW()),
(68, 20, '3 * 4', FALSE, 4, NOW()),

-- Question 21
(69, 21, 'True', TRUE, 1, NOW()),
(70, 21, 'False', FALSE, 2, NOW()),

-- Question 22
(71, 22, '4', TRUE, 1, NOW()),
(72, 22, '3', FALSE, 2, NOW()),
(73, 22, '5', FALSE, 3, NOW()),
(74, 22, '6', FALSE, 4, NOW()),

-- Question 23
(75, 23, 'x² + 2x + 1', TRUE, 1, NOW()),
(76, 23, '2x² - 3x + 4', TRUE, 2, NOW()),
(77, 23, '3x + 2', FALSE, 3, NOW()),
(78, 23, '5x³ + 2x² + 1', FALSE, 4, NOW()),

-- Question 24
(79, 24, 'True', FALSE, 1, NOW()),
(80, 24, 'False', TRUE, 2, NOW()),

-- Question 25
(81, 25, '9', TRUE, 1, NOW()),
(82, 25, '6', FALSE, 2, NOW()),
(83, 25, '3', FALSE, 3, NOW()),
(84, 25, '12', FALSE, 4, NOW());

-- Answers for Geometry Fundamentals Quiz (Quiz 4)
INSERT INTO answers (answer_id, question_id, answer_text, is_correct, order_index, created_at) VALUES
-- Question 26
(85, 26, 'length × width', TRUE, 1, NOW()),
(86, 26, 'length + width', FALSE, 2, NOW()),
(87, 26, '2(length + width)', FALSE, 3, NOW()),
(88, 26, 'length² + width²', FALSE, 4, NOW()),

-- Question 27
(89, 27, 'Triangle', TRUE, 1, NOW()),
(90, 27, 'Square', TRUE, 2, NOW()),
(91, 27, 'Circle', FALSE, 3, NOW()),
(92, 27, 'Pentagon', TRUE, 4, NOW()),

-- Question 28
(93, 28, 'True', TRUE, 1, NOW()),
(94, 28, 'False', FALSE, 2, NOW()),

-- Question 29
(95, 29, '180 degrees', TRUE, 1, NOW()),
(96, 29, '360 degrees', FALSE, 2, NOW()),
(97, 29, '90 degrees', FALSE, 3, NOW()),
(98, 29, '270 degrees', FALSE, 4, NOW()),

-- Question 30
(99, 30, 'Equilateral', TRUE, 1, NOW()),
(100, 30, 'Isosceles', TRUE, 2, NOW()),
(101, 30, 'Scalene', TRUE, 3, NOW()),
(102, 30, 'Circular', FALSE, 4, NOW()),

-- Question 31
(103, 31, 'True', FALSE, 1, NOW()),
(104, 31, 'False', TRUE, 2, NOW()),

-- Question 32
(105, 32, '2πr', TRUE, 1, NOW()),
(106, 32, 'πr²', FALSE, 2, NOW()),
(107, 32, '2πr²', FALSE, 3, NOW()),
(108, 32, 'π²r', FALSE, 4, NOW()),

-- Question 33
(109, 33, 'Opposite sides are parallel', TRUE, 1, NOW()),
(110, 33, 'Opposite angles are equal', TRUE, 2, NOW()),
(111, 33, 'All angles are 90 degrees', FALSE, 3, NOW()),
(112, 33, 'Opposite sides are equal', TRUE, 4, NOW());

-- Answers for General Physics Quiz (Quiz 5)
INSERT INTO answers (answer_id, question_id, answer_text, is_correct, order_index, created_at) VALUES
-- Question 34
(113, 34, 'Newton', TRUE, 1, NOW()),
(114, 34, 'Joule', FALSE, 2, NOW()),
(115, 34, 'Watt', FALSE, 3, NOW()),
(116, 34, 'Pascal', FALSE, 4, NOW()),

-- Question 35
(117, 35, 'Temperature', TRUE, 1, NOW()),
(118, 35, 'Mass', TRUE, 2, NOW()),
(119, 35, 'Velocity', FALSE, 3, NOW()),
(120, 35, 'Time', TRUE, 4, NOW()),

-- Question 36
(121, 36, 'True', TRUE, 1, NOW()),
(122, 36, 'False', FALSE, 2, NOW()),

-- Question 37
(123, 37, 'F = ma', TRUE, 1, NOW()),
(124, 37, 'F = mv', FALSE, 2, NOW()),
(125, 37, 'F = mg', FALSE, 3, NOW()),
(126, 37, 'F = mc²', FALSE, 4, NOW()),

-- Question 38
(127, 38, 'Kinetic', TRUE, 1, NOW()),
(128, 38, 'Potential', TRUE, 2, NOW()),
(129, 38, 'Thermal', TRUE, 3, NOW()),
(130, 38, 'Motion', FALSE, 4, NOW()),

-- Question 39
(131, 39, 'True', TRUE, 1, NOW()),
(132, 39, 'False', FALSE, 2, NOW()),

-- Question 40
(133, 40, 'Ampere', TRUE, 1, NOW()),
(134, 40, 'Volt', FALSE, 2, NOW()),
(135, 40, 'Watt', FALSE, 3, NOW()),
(136, 40, 'Ohm', FALSE, 4, NOW());

-- Insert Additional Quizzes
INSERT INTO quizzes (quizz_id, category_id, created_by, title, description, time_limit, total_score, status, visibility, created_at) VALUES
(6, 1, 11, 'JavaScript Basics', 'Fundamental concepts of JavaScript', 30, 90, 'PUBLISHED', 'PUBLIC', NOW()),
(7, 1, 11, 'SQL Fundamentals', 'Basic SQL queries and database concepts', 25, 80, 'PUBLISHED', 'PUBLIC', NOW()),
(8, 2, 1, 'Calculus Basics', 'Introduction to calculus concepts', 35, 100, 'PUBLISHED', 'PUBLIC', NOW()),
(9, 3, 11, 'Chemistry Basics', 'Fundamental chemistry concepts', 30, 90, 'PUBLISHED', 'PUBLIC', NOW()),
(10, 3, 11, 'Biology Essentials', 'Basic concepts in biology', 25, 80, 'PUBLISHED', 'PUBLIC', NOW());

-- Update Questions for Quiz 6: JavaScript Basics (9 questions)
INSERT INTO questions (question_id, quizz_id, question_text, question_type, score, order_index, created_at) VALUES
(41, 6, 'What is JavaScript?', 'SINGLE_CHOICE', 10, 1, NOW()),
(42, 6, 'Select all JavaScript data types:', 'MULTIPLE_CHOICE', 10, 2, NOW()),
(43, 6, 'JavaScript is case sensitive?', 'TRUE_FALSE', 10, 3, NOW()),
(44, 6, 'What is the correct way to declare a variable in modern JavaScript?', 'SINGLE_CHOICE', 10, 4, NOW()),
(45, 6, 'Which of these are valid array methods in JavaScript?', 'MULTIPLE_CHOICE', 10, 5, NOW()),
(46, 6, 'JavaScript runs on the client side only?', 'TRUE_FALSE', 10, 6, NOW()),
(47, 6, 'What is the typeof operator used for?', 'SINGLE_CHOICE', 10, 7, NOW()),
(48, 6, 'Select valid ways to create objects:', 'MULTIPLE_CHOICE', 10, 8, NOW()),
(49, 6, 'What is the DOM?', 'SINGLE_CHOICE', 10, 9, NOW());

-- Update Questions for Quiz 7: SQL Fundamentals (8 questions)
INSERT INTO questions (question_id, quizz_id, question_text, question_type, score, order_index, created_at) VALUES
(50, 7, 'What does SQL stand for?', 'SINGLE_CHOICE', 10, 1, NOW()),
(51, 7, 'Select all valid SQL commands:', 'MULTIPLE_CHOICE', 10, 2, NOW()),
(52, 7, 'SQL is case sensitive?', 'TRUE_FALSE', 10, 3, NOW()),
(53, 7, 'Which SQL command is used to retrieve data?', 'SINGLE_CHOICE', 10, 4, NOW()),
(54, 7, 'Which of these are valid JOIN types?', 'MULTIPLE_CHOICE', 10, 5, NOW()),
(55, 7, 'What does DISTINCT keyword do?', 'SINGLE_CHOICE', 10, 6, NOW()),
(56, 7, 'Select valid aggregate functions:', 'MULTIPLE_CHOICE', 10, 7, NOW()),
(57, 7, 'What is a primary key?', 'SINGLE_CHOICE', 10, 8, NOW());

-- Update Questions for Quiz 8: Calculus Basics (10 questions)
INSERT INTO questions (question_id, quizz_id, question_text, question_type, score, order_index, created_at) VALUES
(58, 8, 'What is a derivative?', 'SINGLE_CHOICE', 10, 1, NOW()),
(59, 8, 'Select all terms related to integration:', 'MULTIPLE_CHOICE', 10, 2, NOW()),
(60, 8, 'Is every continuous function differentiable?', 'TRUE_FALSE', 10, 3, NOW()),
(61, 8, 'What is the derivative of x²?', 'SINGLE_CHOICE', 10, 4, NOW()),
(62, 8, 'Which of these are types of limits?', 'MULTIPLE_CHOICE', 10, 5, NOW()),
(63, 8, 'What is the chain rule used for?', 'SINGLE_CHOICE', 10, 6, NOW()),
(64, 8, 'Select valid integration techniques:', 'MULTIPLE_CHOICE', 10, 7, NOW()),
(65, 8, 'What is a local maximum?', 'SINGLE_CHOICE', 10, 8, NOW()),
(66, 8, 'The derivative represents:', 'SINGLE_CHOICE', 10, 9, NOW()),
(67, 8, 'Is zero a real number?', 'TRUE_FALSE', 10, 10, NOW());

-- Update Questions for Quiz 9: Chemistry Basics (9 questions)
INSERT INTO questions (question_id, quizz_id, question_text, question_type, score, order_index, created_at) VALUES
(68, 9, 'What is an atom?', 'SINGLE_CHOICE', 10, 1, NOW()),
(69, 9, 'Select all noble gases:', 'MULTIPLE_CHOICE', 10, 2, NOW()),
(70, 9, 'Is water a compound?', 'TRUE_FALSE', 10, 3, NOW()),
(71, 9, 'What is the atomic number of Hydrogen?', 'SINGLE_CHOICE', 10, 4, NOW()),
(72, 9, 'Which of these are types of chemical bonds?', 'MULTIPLE_CHOICE', 10, 5, NOW()),
(73, 9, 'What is the pH scale range?', 'SINGLE_CHOICE', 10, 6, NOW()),
(74, 9, 'Select all state of matter:', 'MULTIPLE_CHOICE', 10, 7, NOW()),
(75, 9, 'What is a molecule?', 'SINGLE_CHOICE', 10, 8, NOW()),
(76, 9, 'Can atoms be created or destroyed?', 'TRUE_FALSE', 10, 9, NOW());

-- Update Questions for Quiz 10: Biology Essentials (8 questions)
INSERT INTO questions (question_id, quizz_id, question_text, question_type, score, order_index, created_at) VALUES
(77, 10, 'What is a cell?', 'SINGLE_CHOICE', 10, 1, NOW()),
(78, 10, 'Select all organelles found in animal cells:', 'MULTIPLE_CHOICE', 10, 2, NOW()),
(79, 10, 'DNA is found in the nucleus?', 'TRUE_FALSE', 10, 3, NOW()),
(80, 10, 'What is the powerhouse of the cell?', 'SINGLE_CHOICE', 10, 4, NOW()),
(81, 10, 'Which of these are types of cell division?', 'MULTIPLE_CHOICE', 10, 5, NOW()),
(82, 10, 'What is photosynthesis?', 'SINGLE_CHOICE', 10, 6, NOW()),
(83, 10, 'Select all types of blood cells:', 'MULTIPLE_CHOICE', 10, 7, NOW()),
(84, 10, 'Is every living thing made of cells?', 'TRUE_FALSE', 10, 8, NOW());

-- Answers for Quiz 6 (JavaScript Basics)
INSERT INTO answers (question_id, answer_text, is_correct, order_index, created_at) VALUES
-- JavaScript definition
(41, 'A programming language for web development', TRUE, 1, NOW()),
(41, 'A markup language', FALSE, 2, NOW()),
(41, 'A database system', FALSE, 3, NOW()),
(41, 'An operating system', FALSE, 4, NOW()),

-- JavaScript data types
(42, 'string', TRUE, 1, NOW()),
(42, 'number', TRUE, 2, NOW()),
(42, 'boolean', TRUE, 3, NOW()),
(42, 'char', FALSE, 4, NOW()),

-- Case sensitivity
(43, 'True', TRUE, 1, NOW()),
(43, 'False', FALSE, 2, NOW()),

-- Variable declaration
(44, 'let x = 5;', TRUE, 1, NOW()),
(44, 'variable x = 5;', FALSE, 2, NOW()),
(44, 'int x = 5;', FALSE, 3, NOW()),
(44, 'x := 5;', FALSE, 4, NOW()),

-- Array methods question
(45, 'push()', TRUE, 1, NOW()),
(45, 'pop()', TRUE, 2, NOW()),
(45, 'shift()', TRUE, 3, NOW()),
(45, 'remove()', FALSE, 4, NOW()),

-- JavaScript client side
(46, 'True', FALSE, 1, NOW()),
(46, 'False', TRUE, 2, NOW()),

-- typeof operator
(47, 'Check data type of a value', TRUE, 1, NOW()),
(47, 'Convert data types', FALSE, 2, NOW()),
(47, 'Create new types', FALSE, 3, NOW()),
(47, 'Compare types', FALSE, 4, NOW()),

-- Object creation
(48, 'Object literal {}', TRUE, 1, NOW()),
(48, 'new Object()', TRUE, 2, NOW()),
(48, 'Object.create()', TRUE, 3, NOW()),
(48, 'make.object()', FALSE, 4, NOW()),

-- DOM
(49, 'Document Object Model', TRUE, 1, NOW()),
(49, 'Data Object Model', FALSE, 2, NOW()),
(49, 'Document Oriented Model', FALSE, 3, NOW()),
(49, 'Data Oriented Markup', FALSE, 4, NOW());

-- Answers for Quiz 7 (SQL Fundamentals)
INSERT INTO answers (question_id, answer_text, is_correct, order_index, created_at) VALUES
-- SQL meaning
(50, 'Structured Query Language', TRUE, 1, NOW()),
(50, 'System Query Language', FALSE, 2, NOW()),
(50, 'Simple Query Language', FALSE, 3, NOW()),
(50, 'Standard Query Logic', FALSE, 4, NOW()),

-- SQL commands
(51, 'SELECT', TRUE, 1, NOW()),
(51, 'INSERT', TRUE, 2, NOW()),
(51, 'UPDATE', TRUE, 3, NOW()),
(51, 'MODIFY', FALSE, 4, NOW()),

-- SQL case sensitivity
(52, 'True', FALSE, 1, NOW()),
(52, 'False', TRUE, 2, NOW()),

-- SQL retrieve data
(53, 'SELECT', TRUE, 1, NOW()),
(53, 'FETCH', FALSE, 2, NOW()),
(53, 'GET', FALSE, 3, NOW()),
(53, 'RETRIEVE', FALSE, 4, NOW()),

-- JOIN types
(54, 'INNER JOIN', TRUE, 1, NOW()),
(54, 'LEFT JOIN', TRUE, 2, NOW()),
(54, 'RIGHT JOIN', TRUE, 3, NOW()),
(54, 'MIDDLE JOIN', FALSE, 4, NOW()),

-- DISTINCT
(55, 'Remove duplicate values', TRUE, 1, NOW()),
(55, 'Sort values', FALSE, 2, NOW()),
(55, 'Filter values', FALSE, 3, NOW()),
(55, 'Count values', FALSE, 4, NOW()),

-- Aggregate functions
(56, 'COUNT', TRUE, 1, NOW()),
(56, 'SUM', TRUE, 2, NOW()),
(56, 'AVG', TRUE, 3, NOW()),
(56, 'COMBINE', FALSE, 4, NOW()),

-- Primary key
(57, 'Unique identifier for a record', TRUE, 1, NOW()),
(57, 'First column in table', FALSE, 2, NOW()),
(57, 'Most important data', FALSE, 3, NOW()),
(57, 'Auto-generated number', FALSE, 4, NOW());

-- Answers for Quiz 8 (Calculus Basics)
INSERT INTO answers (question_id, answer_text, is_correct, order_index, created_at) VALUES
-- Derivative definition
(58, 'Rate of change of a function', TRUE, 1, NOW()),
(58, 'Area under a curve', FALSE, 2, NOW()),
(58, 'Sum of all numbers', FALSE, 3, NOW()),
(58, 'Product of functions', FALSE, 4, NOW()),

-- Integration terms
(59, 'Antiderivative', TRUE, 1, NOW()),
(59, 'Definite integral', TRUE, 2, NOW()),
(59, 'Indefinite integral', TRUE, 3, NOW()),
(59, 'Differential equation', FALSE, 4, NOW()),

-- Continuous function
(60, 'True', FALSE, 1, NOW()),
(60, 'False', TRUE, 2, NOW()),

-- Derivative of x²
(61, '2x', TRUE, 1, NOW()),
(61, 'x', FALSE, 2, NOW()),
(61, '2', FALSE, 3, NOW()),
(61, 'x²', FALSE, 4, NOW()),

-- Limit types
(62, 'One-sided limit', TRUE, 1, NOW()),
(62, 'Two-sided limit', TRUE, 2, NOW()),
(62, 'Infinite limit', TRUE, 3, NOW()),
(62, 'Zero limit', FALSE, 4, NOW()),

-- Chain rule
(63, 'Differentiate composite functions', TRUE, 1, NOW()),
(63, 'Add functions', FALSE, 2, NOW()),
(63, 'Multiply functions', FALSE, 3, NOW()),
(63, 'Divide functions', FALSE, 4, NOW()),

-- Integration techniques
(64, 'Integration by parts', TRUE, 1, NOW()),
(64, 'Substitution method', TRUE, 2, NOW()),
(64, 'Partial fractions', TRUE, 3, NOW()),
(64, 'Division method', FALSE, 4, NOW()),

-- Local maximum
(65, 'Point where function reaches highest value locally', TRUE, 1, NOW()),
(65, 'Highest point of function', FALSE, 2, NOW()),
(65, 'Starting point of function', FALSE, 3, NOW()),
(65, 'End point of function', FALSE, 4, NOW()),

-- Derivative represents
(66, 'Rate of change', TRUE, 1, NOW()),
(66, 'Total change', FALSE, 2, NOW()),
(66, 'Average value', FALSE, 3, NOW()),
(66, 'Final value', FALSE, 4, NOW()),

-- Zero real number
(67, 'True', TRUE, 1, NOW()),
(67, 'False', FALSE, 2, NOW());

-- Answers for Quiz 9 (Chemistry Basics)
INSERT INTO answers (question_id, answer_text, is_correct, order_index, created_at) VALUES
-- Atom definition
(68, 'Smallest unit of matter', TRUE, 1, NOW()),
(68, 'Smallest living thing', FALSE, 2, NOW()),
(68, 'Type of molecule', FALSE, 3, NOW()),
(68, 'Part of a cell', FALSE, 4, NOW()),

-- Noble gases
(69, 'Helium', TRUE, 1, NOW()),
(69, 'Neon', TRUE, 2, NOW()),
(69, 'Argon', TRUE, 3, NOW()),
(69, 'Oxygen', FALSE, 4, NOW()),

-- Water compound
(70, 'True', TRUE, 1, NOW()),
(70, 'False', FALSE, 2, NOW()),

-- Hydrogen atomic number
(71, '1', TRUE, 1, NOW()),
(71, '2', FALSE, 2, NOW()),
(71, '3', FALSE, 3, NOW()),
(71, '4', FALSE, 4, NOW()),

-- Chemical bonds
(72, 'Covalent', TRUE, 1, NOW()),
(72, 'Ionic', TRUE, 2, NOW()),
(72, 'Metallic', TRUE, 3, NOW()),
(72, 'Magnetic', FALSE, 4, NOW()),

-- pH scale range
(73, '0 to 14', TRUE, 1, NOW()),
(73, '-1 to 15', FALSE, 2, NOW()),
(73, '1 to 10', FALSE, 3, NOW()),
(73, '0 to 10', FALSE, 4, NOW()),

-- State of matter
(74, 'Solid', TRUE, 1, NOW()),
(74, 'Liquid', TRUE, 2, NOW()),
(74, 'Gas', TRUE, 3, NOW()),
(74, 'Energy', FALSE, 4, NOW()),

-- Molecule
(75, 'Group of atoms bonded together', TRUE, 1, NOW()),
(75, 'Single atom', FALSE, 2, NOW()),
(75, 'Type of element', FALSE, 3, NOW()),
(75, 'Form of energy', FALSE, 4, NOW()),

-- Atoms created or destroyed
(76, 'True', FALSE, 1, NOW()),
(76, 'False', TRUE, 2, NOW());

-- Answers for Quiz 10 (Biology Essentials)
INSERT INTO answers (question_id, answer_text, is_correct, order_index, created_at) VALUES
-- Cell definition
(77, 'Basic unit of life', TRUE, 1, NOW()),
(77, 'Type of tissue', FALSE, 2, NOW()),
(77, 'Part of an organ', FALSE, 3, NOW()),
(77, 'Chemical compound', FALSE, 4, NOW()),

-- Animal cell organelles
(78, 'Mitochondria', TRUE, 1, NOW()),
(78, 'Nucleus', TRUE, 2, NOW()),
(78, 'Golgi apparatus', TRUE, 3, NOW()),
(78, 'Cell wall', FALSE, 4, NOW()),

-- DNA location
(79, 'True', TRUE, 1, NOW()),
(79, 'False', FALSE, 2, NOW()),

-- Cell powerhouse
(80, 'Mitochondria', TRUE, 1, NOW()),
(80, 'Nucleus', FALSE, 2, NOW()),
(80, 'Chloroplast', FALSE, 3, NOW()),
(80, 'Ribosome', FALSE, 4, NOW()),

-- Cell division types
(81, 'Mitosis', TRUE, 1, NOW()),
(81, 'Meiosis', TRUE, 2, NOW()),
(81, 'Binary fission', TRUE, 3, NOW()),
(81, 'Osmosis', FALSE, 4, NOW()),

-- Photosynthesis
(82, 'Process of converting light energy to chemical energy', TRUE, 1, NOW()),
(82, 'Breaking down of glucose', FALSE, 2, NOW()),
(82, 'Cell division process', FALSE, 3, NOW()),
(82, 'Protein synthesis', FALSE, 4, NOW()),

-- Blood cells
(83, 'Red blood cells', TRUE, 1, NOW()),
(83, 'White blood cells', TRUE, 2, NOW()),
(83, 'Platelets', TRUE, 3, NOW()),
(83, 'Muscle cells', FALSE, 4, NOW()),

-- Living things made of cells
(84, 'True', TRUE, 1, NOW()),
(84, 'False', FALSE, 2, NOW());

-- Insert Additional Quizzes (11-15)
INSERT INTO quizzes (quizz_id, category_id, created_by, title, description, time_limit, total_score, status, visibility, created_at) VALUES
(11, 2, 1, 'Statistics Basics', 'Introduction to statistical concepts', 30, 90, 'PUBLISHED', 'PUBLIC', NOW()),
(12, 3, 11, 'Organic Chemistry', 'Basic organic chemistry concepts', 35, 100, 'PUBLISHED', 'PUBLIC', NOW()),
(13, 1, 11, 'HTML and CSS', 'Web development fundamentals', 25, 80, 'PUBLISHED', 'PUBLIC', NOW()),
(14, 2, 1, 'Trigonometry', 'Basic trigonometric concepts', 30, 90, 'PUBLISHED', 'PUBLIC', NOW()),
(15, 3, 11, 'Earth Science', 'Fundamentals of earth science', 25, 80, 'PUBLISHED', 'PUBLIC', NOW());

-- Questions for Quiz 11: Statistics Basics (9 questions)
INSERT INTO questions (question_id, quizz_id, question_text, question_type, score, order_index, created_at) VALUES
(85, 11, 'What is the mean?', 'SINGLE_CHOICE', 10, 1, NOW()),
(86, 11, 'Select all measures of central tendency:', 'MULTIPLE_CHOICE', 10, 2, NOW()),
(87, 11, 'Is standard deviation always positive?', 'TRUE_FALSE', 10, 3, NOW()),
(88, 11, 'What does variance measure?', 'SINGLE_CHOICE', 10, 4, NOW()),
(89, 11, 'Which of these are types of sampling methods?', 'MULTIPLE_CHOICE', 10, 5, NOW()),
(90, 11, 'What is correlation?', 'SINGLE_CHOICE', 10, 6, NOW()),
(91, 11, 'Select valid probability values:', 'MULTIPLE_CHOICE', 10, 7, NOW()),
(92, 11, 'What is the mode?', 'SINGLE_CHOICE', 10, 8, NOW()),
(93, 11, 'Can standard deviation be negative?', 'TRUE_FALSE', 10, 9, NOW());

-- Questions for Quiz 12: Organic Chemistry (10 questions)
INSERT INTO questions (question_id, quizz_id, question_text, question_type, score, order_index, created_at) VALUES
(94, 12, 'What is an alkane?', 'SINGLE_CHOICE', 10, 1, NOW()),
(95, 12, 'Select all functional groups:', 'MULTIPLE_CHOICE', 10, 2, NOW()),
(96, 12, 'Are all organic compounds carbon-based?', 'TRUE_FALSE', 10, 3, NOW()),
(97, 12, 'What is the simplest alcohol?', 'SINGLE_CHOICE', 10, 4, NOW()),
(98, 12, 'Which of these are types of isomers?', 'MULTIPLE_CHOICE', 10, 5, NOW()),
(99, 12, 'What is a hydrocarbon?', 'SINGLE_CHOICE', 10, 6, NOW()),
(100, 12, 'Select valid alkene characteristics:', 'MULTIPLE_CHOICE', 10, 7, NOW()),
(101, 12, 'What is an ester?', 'SINGLE_CHOICE', 10, 8, NOW()),
(102, 12, 'Is benzene aromatic?', 'TRUE_FALSE', 10, 9, NOW()),
(103, 12, 'What is the IUPAC name for CH3-CH3?', 'SINGLE_CHOICE', 10, 10, NOW());

-- Questions for Quiz 13: HTML and CSS (8 questions)
INSERT INTO questions (question_id, quizz_id, question_text, question_type, score, order_index, created_at) VALUES
(104, 13, 'What does HTML stand for?', 'SINGLE_CHOICE', 10, 1, NOW()),
(105, 13, 'Select all valid HTML tags:', 'MULTIPLE_CHOICE', 10, 2, NOW()),
(106, 13, 'Is CSS used for styling?', 'TRUE_FALSE', 10, 3, NOW()),
(107, 13, 'Which tag is used for hyperlinks?', 'SINGLE_CHOICE', 10, 4, NOW()),
(108, 13, 'Which of these are CSS selectors?', 'MULTIPLE_CHOICE', 10, 5, NOW()),
(109, 13, 'What is CSS Box Model?', 'SINGLE_CHOICE', 10, 6, NOW()),
(110, 13, 'Select all CSS positioning types:', 'MULTIPLE_CHOICE', 10, 7, NOW()),
(111, 13, 'Is HTML5 backward compatible?', 'TRUE_FALSE', 10, 8, NOW());

-- Questions for Quiz 14: Trigonometry (9 questions)
INSERT INTO questions (question_id, quizz_id, question_text, question_type, score, order_index, created_at) VALUES
(112, 14, 'What is sine?', 'SINGLE_CHOICE', 10, 1, NOW()),
(113, 14, 'Select all trigonometric ratios:', 'MULTIPLE_CHOICE', 10, 2, NOW()),
(114, 14, 'Is cos(0) equal to 1?', 'TRUE_FALSE', 10, 3, NOW()),
(115, 14, 'What is the period of sine function?', 'SINGLE_CHOICE', 10, 4, NOW()),
(116, 14, 'Which of these are trigonometric identities?', 'MULTIPLE_CHOICE', 10, 5, NOW()),
(117, 14, 'What is the reciprocal of sine?', 'SINGLE_CHOICE', 10, 6, NOW()),
(118, 14, 'Select all parts of a right triangle:', 'MULTIPLE_CHOICE', 10, 7, NOW()),
(119, 14, 'Are all triangles right triangles?', 'TRUE_FALSE', 10, 8, NOW()),
(120, 14, 'What is the range of sine function?', 'SINGLE_CHOICE', 10, 9, NOW());

-- Questions for Quiz 15: Earth Science (8 questions)
INSERT INTO questions (question_id, quizz_id, question_text, question_type, score, order_index, created_at) VALUES
(121, 15, 'What is the innermost layer of Earth?', 'SINGLE_CHOICE', 10, 1, NOW()),
(122, 15, 'Select all types of rocks:', 'MULTIPLE_CHOICE', 10, 2, NOW()),
(123, 15, 'Is the Earth perfectly spherical?', 'TRUE_FALSE', 10, 3, NOW()),
(124, 15, 'What causes tides?', 'SINGLE_CHOICE', 10, 4, NOW()),
(125, 15, 'Which of these are types of plate boundaries?', 'MULTIPLE_CHOICE', 10, 5, NOW()),
(126, 15, 'What is the greenhouse effect?', 'SINGLE_CHOICE', 10, 6, NOW()),
(127, 15, 'Select all types of weather phenomena:', 'MULTIPLE_CHOICE', 10, 7, NOW()),
(128, 15, 'Is Earth the largest planet in our solar system?', 'TRUE_FALSE', 10, 8, NOW());

-- Answers for Statistics Quiz (Quiz 11)
INSERT INTO answers (question_id, answer_text, is_correct, order_index, created_at) VALUES
(85, 'Average of all values', TRUE, 1, NOW()),
(85, 'Middle value', FALSE, 2, NOW()),
(85, 'Most frequent value', FALSE, 3, NOW()),
(85, 'Sum of all values', FALSE, 4, NOW()),

(86, 'Mean', TRUE, 1, NOW()),
(86, 'Median', TRUE, 2, NOW()),
(86, 'Mode', TRUE, 3, NOW()),
(86, 'Range', FALSE, 4, NOW()),

(87, 'True', TRUE, 1, NOW()),
(87, 'False', FALSE, 2, NOW()),

(88, 'Spread of data', TRUE, 1, NOW()),
(88, 'Center of data', FALSE, 2, NOW()),
(88, 'Size of data', FALSE, 3, NOW()),
(88, 'Order of data', FALSE, 4, NOW()),

(89, 'Random', TRUE, 1, NOW()),
(89, 'Stratified', TRUE, 2, NOW()),
(89, 'Cluster', TRUE, 3, NOW()),
(89, 'Organized', FALSE, 4, NOW()),

(90, 'Relationship between two variables', TRUE, 1, NOW()),
(90, 'Measure of center', FALSE, 2, NOW()),
(90, 'Type of graph', FALSE, 3, NOW()),
(90, 'Statistical test', FALSE, 4, NOW()),

(91, '0.5', TRUE, 1, NOW()),
(91, '1.0', TRUE, 2, NOW()),
(91, '0.0', TRUE, 3, NOW()),
(91, '1.5', FALSE, 4, NOW()),

(92, 'Most frequent value', TRUE, 1, NOW()),
(92, 'Middle value', FALSE, 2, NOW()),
(92, 'Average value', FALSE, 3, NOW()),
(92, 'Largest value', FALSE, 4, NOW()),

(93, 'False', TRUE, 1, NOW()),
(93, 'True', FALSE, 2, NOW());

-- Answers for Organic Chemistry Quiz (Quiz 12)
INSERT INTO answers (question_id, answer_text, is_correct, order_index, created_at) VALUES
(94, 'Hydrocarbon with single bonds', TRUE, 1, NOW()),
(94, 'Hydrocarbon with double bonds', FALSE, 2, NOW()),
(94, 'Carbon compound with oxygen', FALSE, 3, NOW()),
(94, 'Carbon compound with nitrogen', FALSE, 4, NOW()),

(95, 'Hydroxyl', TRUE, 1, NOW()),
(95, 'Carboxyl', TRUE, 2, NOW()),
(95, 'Amino', TRUE, 3, NOW()),
(95, 'Carbon', FALSE, 4, NOW()),

(96, 'True', TRUE, 1, NOW()),
(96, 'False', FALSE, 2, NOW()),

(97, 'Methanol', TRUE, 1, NOW()),
(97, 'Ethanol', FALSE, 2, NOW()),
(97, 'Propanol', FALSE, 3, NOW()),
(97, 'Butanol', FALSE, 4, NOW()),

(98, 'Structural', TRUE, 1, NOW()),
(98, 'Geometric', TRUE, 2, NOW()),
(98, 'Optical', TRUE, 3, NOW()),
(98, 'Chemical', FALSE, 4, NOW()),

(99, 'Compound of only carbon and hydrogen', TRUE, 1, NOW()),
(99, 'Any organic compound', FALSE, 2, NOW()),
(99, 'Carbon-oxygen compound', FALSE, 3, NOW()),
(99, 'Carbon-nitrogen compound', FALSE, 4, NOW()),

(100, 'Contains double bond', TRUE, 1, NOW()),
(100, 'Unsaturated', TRUE, 2, NOW()),
(100, 'More reactive than alkanes', TRUE, 3, NOW()),
(100, 'Contains triple bond', FALSE, 4, NOW()),

(101, 'Product of alcohol and acid reaction', TRUE, 1, NOW()),
(101, 'Type of alcohol', FALSE, 2, NOW()),
(101, 'Form of alkane', FALSE, 3, NOW()),
(101, 'Organic base', FALSE, 4, NOW()),

(102, 'True', TRUE, 1, NOW()),
(102, 'False', FALSE, 2, NOW()),

(103, 'Ethane', TRUE, 1, NOW()),
(103, 'Methane', FALSE, 2, NOW()),
(103, 'Propane', FALSE, 3, NOW()),
(103, 'Butane', FALSE, 4, NOW());

-- Answers for HTML and CSS Quiz (Quiz 13)
INSERT INTO answers (question_id, answer_text, is_correct, order_index, created_at) VALUES
(104, 'HyperText Markup Language', TRUE, 1, NOW()),
(104, 'High Text Markup Language', FALSE, 2, NOW()),
(104, 'Hyper Transfer Markup Language', FALSE, 3, NOW()),
(104, 'High Transfer Markup Language', FALSE, 4, NOW()),

(105, '<div>', TRUE, 1, NOW()),
(105, '<span>', TRUE, 2, NOW()),
(105, '<p>', TRUE, 3, NOW()),
(105, '<text>', FALSE, 4, NOW()),

(106, 'True', TRUE, 1, NOW()),
(106, 'False', FALSE, 2, NOW()),

(107, '<a>', TRUE, 1, NOW()),
(107, '<link>', FALSE, 2, NOW()),
(107, '<href>', FALSE, 3, NOW()),
(107, '<url>', FALSE, 4, NOW()),

(108, 'Class', TRUE, 1, NOW()),
(108, 'ID', TRUE, 2, NOW()),
(108, 'Tag', TRUE, 3, NOW()),
(108, 'Style', FALSE, 4, NOW()),

(109, 'Content, padding, border, and margin', TRUE, 1, NOW()),
(109, 'Only content and border', FALSE, 2, NOW()),
(109, 'Only margin and padding', FALSE, 3, NOW()),
(109, 'Content and margin only', FALSE, 4, NOW()),

(110, 'Static', TRUE, 1, NOW()),
(110, 'Relative', TRUE, 2, NOW()),
(110, 'Absolute', TRUE, 3, NOW()),
(110, 'Dynamic', FALSE, 4, NOW()),

(111, 'True', TRUE, 1, NOW()),
(111, 'False', FALSE, 2, NOW());

-- Answers for Trigonometry Quiz (Quiz 14)
INSERT INTO answers (question_id, answer_text, is_correct, order_index, created_at) VALUES
(112, 'Opposite/Hypotenuse', TRUE, 1, NOW()),
(112, 'Adjacent/Hypotenuse', FALSE, 2, NOW()),
(112, 'Opposite/Adjacent', FALSE, 3, NOW()),
(112, 'Hypotenuse/Adjacent', FALSE, 4, NOW()),

(113, 'Sine', TRUE, 1, NOW()),
(113, 'Cosine', TRUE, 2, NOW()),
(113, 'Tangent', TRUE, 3, NOW()),
(113, 'Parallel', FALSE, 4, NOW()),

(114, 'True', TRUE, 1, NOW()),
(114, 'False', FALSE, 2, NOW()),

(115, '2π', TRUE, 1, NOW()),
(115, 'π', FALSE, 2, NOW()),
(115, '4π', FALSE, 3, NOW()),
(115, 'π/2', FALSE, 4, NOW()),

(116, 'sin²θ + cos²θ = 1', TRUE, 1, NOW()),
(116, 'tanθ = sinθ/cosθ', TRUE, 2, NOW()),
(116, 'sin(2θ) = 2sinθcosθ', TRUE, 3, NOW()),
(116, 'sin²θ = cos²θ', FALSE, 4, NOW()),

(117, 'Cosecant', TRUE, 1, NOW()),
(117, 'Secant', FALSE, 2, NOW()),
(117, 'Cotangent', FALSE, 3, NOW()),
(117, 'Tangent', FALSE, 4, NOW()),

(118, 'Hypotenuse', TRUE, 1, NOW()),
(118, 'Adjacent side', TRUE, 2, NOW()),
(118, 'Opposite side', TRUE, 3, NOW()),
(118, 'Diameter', FALSE, 4, NOW()),

(119, 'False', TRUE, 1, NOW()),
(119, 'True', FALSE, 2, NOW()),

(120, '[-1, 1]', TRUE, 1, NOW()),
(120, '[-2, 2]', FALSE, 2, NOW()),
(120, '[0, 1]', FALSE, 3, NOW()),
(120, '[-π, π]', FALSE, 4, NOW());

-- Answers for Earth Science Quiz (Quiz 15)
INSERT INTO answers (question_id, answer_text, is_correct, order_index, created_at) VALUES
(121, 'Inner Core', TRUE, 1, NOW()),
(121, 'Outer Core', FALSE, 2, NOW()),
(121, 'Mantle', FALSE, 3, NOW()),
(121, 'Crust', FALSE, 4, NOW()),

(122, 'Igneous', TRUE, 1, NOW()),
(122, 'Sedimentary', TRUE, 2, NOW()),
(122, 'Metamorphic', TRUE, 3, NOW()),
(122, 'Liquid', FALSE, 4, NOW()),

(123, 'True', FALSE, 1, NOW()),
(123, 'False', TRUE, 2, NOW()),

(124, 'Gravitational pull of the Moon', TRUE, 1, NOW()),
(124, 'Earth rotation', FALSE, 2, NOW()),
(124, 'Ocean currents', FALSE, 3, NOW()),
(124, 'Wind patterns', FALSE, 4, NOW()),

(125, 'Convergent', TRUE, 1, NOW()),
(125, 'Divergent', TRUE, 2, NOW()),
(125, 'Transform', TRUE, 3, NOW()),
(125, 'Circular', FALSE, 4, NOW()),

(126, 'Trapping of heat by atmospheric gases', TRUE, 1, NOW()),
(126, 'Plant growth in greenhouses', FALSE, 2, NOW()),
(126, 'Reflection of sunlight', FALSE, 3, NOW()),
(126, 'Ocean temperature changes', FALSE, 4, NOW()),

(127, 'Hurricane', TRUE, 1, NOW()),
(127, 'Tornado', TRUE, 2, NOW()),
(127, 'Thunderstorm', TRUE, 3, NOW()),
(127, 'Rainbow', FALSE, 4, NOW()),

(128, 'False', TRUE, 1, NOW()),
(128, 'True', FALSE, 2, NOW());
-- Insert Additional Quizzes (16-20)
INSERT INTO quizzes (quizz_id, category_id, created_by, title, description, time_limit, total_score, status, visibility, created_at) VALUES
(16, 1, 11, 'React Fundamentals', 'Basic concepts of React.js', 30, 90, 'PUBLISHED', 'PUBLIC', NOW()),
(17, 2, 1, 'Linear Algebra', 'Fundamentals of linear algebra', 35, 100, 'PUBLISHED', 'PUBLIC', NOW()),
(18, 3, 11, 'Astronomy Basics', 'Introduction to astronomy', 25, 80, 'PUBLISHED', 'PUBLIC', NOW()),
(19, 1, 11, 'Database Design', 'Fundamentals of database design', 30, 90, 'PUBLISHED', 'PUBLIC', NOW()),
(20, 2, 1, 'Probability Theory', 'Basic concepts of probability', 25, 80, 'PUBLISHED', 'PUBLIC', NOW());

-- Questions for Quiz 16: React Fundamentals
INSERT INTO questions (question_id, quizz_id, question_text, question_type, score, order_index, created_at) VALUES
(129, 16, 'What is React?', 'SINGLE_CHOICE', 10, 1, NOW()),
(130, 16, 'Select all React hooks:', 'MULTIPLE_CHOICE', 10, 2, NOW()),
(131, 16, 'Is React a framework?', 'TRUE_FALSE', 10, 3, NOW()),
(132, 16, 'What is JSX?', 'SINGLE_CHOICE', 10, 4, NOW()),
(133, 16, 'Which of these are React lifecycle methods?', 'MULTIPLE_CHOICE', 10, 5, NOW()),
(134, 16, 'What is state in React?', 'SINGLE_CHOICE', 10, 6, NOW()),
(135, 16, 'Select all React component types:', 'MULTIPLE_CHOICE', 10, 7, NOW()),
(136, 16, 'What is Virtual DOM?', 'SINGLE_CHOICE', 10, 8, NOW()),
(137, 16, 'Does React use HTML?', 'TRUE_FALSE', 10, 9, NOW());

-- Questions for Quiz 17: Linear Algebra
INSERT INTO questions (question_id, quizz_id, question_text, question_type, score, order_index, created_at) VALUES
(138, 17, 'What is a matrix?', 'SINGLE_CHOICE', 10, 1, NOW()),
(139, 17, 'Select all types of matrices:', 'MULTIPLE_CHOICE', 10, 2, NOW()),
(140, 17, 'Is a vector a matrix?', 'TRUE_FALSE', 10, 3, NOW()),
(141, 17, 'What is determinant?', 'SINGLE_CHOICE', 10, 4, NOW()),
(142, 17, 'Which operations can be performed on matrices?', 'MULTIPLE_CHOICE', 10, 5, NOW()),
(143, 17, 'What is an eigenvector?', 'SINGLE_CHOICE', 10, 6, NOW()),
(144, 17, 'Select properties of identity matrix:', 'MULTIPLE_CHOICE', 10, 7, NOW()),
(145, 17, 'What is matrix rank?', 'SINGLE_CHOICE', 10, 8, NOW()),
(146, 17, 'Is matrix multiplication commutative?', 'TRUE_FALSE', 10, 9, NOW()),
(147, 17, 'What is a singular matrix?', 'SINGLE_CHOICE', 10, 10, NOW());

-- Questions for Quiz 18: Astronomy Basics
INSERT INTO questions (question_id, quizz_id, question_text, question_type, score, order_index, created_at) VALUES
(148, 18, 'What is a galaxy?', 'SINGLE_CHOICE', 10, 1, NOW()),
(149, 18, 'Select all planets in our solar system:', 'MULTIPLE_CHOICE', 10, 2, NOW()),
(150, 18, 'Is the Sun a star?', 'TRUE_FALSE', 10, 3, NOW()),
(151, 18, 'What causes lunar phases?', 'SINGLE_CHOICE', 10, 4, NOW()),
(152, 18, 'Which of these are types of galaxies?', 'MULTIPLE_CHOICE', 10, 5, NOW()),
(153, 18, 'What is a light year?', 'SINGLE_CHOICE', 10, 6, NOW()),
(154, 18, 'Select types of stars:', 'MULTIPLE_CHOICE', 10, 7, NOW()),
(155, 18, 'Is Pluto a planet?', 'TRUE_FALSE', 10, 8, NOW());

-- Questions for Quiz 19: Database Design
INSERT INTO questions (question_id, quizz_id, question_text, question_type, score, order_index, created_at) VALUES(156, 19, 'What is normalization?', 'SINGLE_CHOICE', 10, 1, NOW()),
(157, 19, 'Select all types of relationships:', 'MULTIPLE_CHOICE', 10, 2, NOW()),
(158, 19, 'Is a primary key unique?', 'TRUE_FALSE', 10, 3, NOW()),
(159, 19, 'What is a foreign key?', 'SINGLE_CHOICE', 10, 4, NOW()),
(160, 19, 'Which of these are database constraints?', 'MULTIPLE_CHOICE', 10, 5, NOW()),
(161, 19, 'What is an index in database?', 'SINGLE_CHOICE', 10, 6, NOW()),
(162, 19, 'Select valid normalization forms:', 'MULTIPLE_CHOICE', 10, 7, NOW()),
(163, 19, 'What is data integrity?', 'SINGLE_CHOICE', 10, 8, NOW()),
(164, 19, 'Can a table have multiple primary keys?', 'TRUE_FALSE', 10, 9, NOW());

-- Questions for Quiz 20: Probability Theory
INSERT INTO questions (question_id, quizz_id, question_text, question_type, score, order_index, created_at) VALUES
(165, 20, 'What is probability?', 'SINGLE_CHOICE', 10, 1, NOW()),
(166, 20, 'Select all probability distributions:', 'MULTIPLE_CHOICE', 10, 2, NOW()),
(167, 20, 'Can probability be negative?', 'TRUE_FALSE', 10, 3, NOW()),
(168, 20, 'What is conditional probability?', 'SINGLE_CHOICE', 10, 4, NOW()),
(169, 20, 'Which of these are types of events?', 'MULTIPLE_CHOICE', 10, 5, NOW()),
(170, 20, 'What is Bayes'' Theorem?', 'SINGLE_CHOICE', 10, 6, NOW()),
(171, 20, 'Select properties of probability:', 'MULTIPLE_CHOICE', 10, 7, NOW()),
(172, 20, 'Are mutually exclusive events independent?', 'TRUE_FALSE', 10, 8, NOW());

-- Answers for React Fundamentals (Quiz 16)
INSERT INTO answers (question_id, answer_text, is_correct, order_index, created_at) VALUES
-- What is React?
(129, 'A JavaScript library for building user interfaces', TRUE, 1, NOW()),
(129, 'A programming language', FALSE, 2, NOW()),
(129, 'A database system', FALSE, 3, NOW()),
(129, 'A web server', FALSE, 4, NOW()),

-- React hooks
(130, 'useState', TRUE, 1, NOW()),
(130, 'useEffect', TRUE, 2, NOW()),
(130, 'useContext', TRUE, 3, NOW()),
(130, 'useProgram', FALSE, 4, NOW()),

-- React framework
(131, 'True', FALSE, 1, NOW()),
(131, 'False', TRUE, 2, NOW()),

-- JSX
(132, 'JavaScript XML syntax', TRUE, 1, NOW()),
(132, 'Java Syntax Extension', FALSE, 2, NOW()),
(132, 'JavaScript Extension', FALSE, 3, NOW()),
(132, 'Java XML', FALSE, 4, NOW()),

-- React lifecycle methods
(133, 'componentDidMount', TRUE, 1, NOW()),
(133, 'componentDidUpdate', TRUE, 2, NOW()),
(133, 'componentWillUnmount', TRUE, 3, NOW()),
(133, 'componentWillMount', FALSE, 4, NOW()),

-- State in React
(134, 'Object that stores component''s data', TRUE, 1, NOW()),
(134, 'Database connection', FALSE, 2, NOW()),
(134, 'Server configuration', FALSE, 3, NOW()),
(134, 'CSS styling', FALSE, 4, NOW()),

-- React component types
(135, 'Functional Components', TRUE, 1, NOW()),
(135, 'Class Components', TRUE, 2, NOW()),
(135, 'Higher-Order Components', TRUE, 3, NOW()),
(135, 'Static Components', FALSE, 4, NOW()),

-- Virtual DOM
(136, 'Lightweight copy of actual DOM', TRUE, 1, NOW()),
(136, 'Browser extension', FALSE, 2, NOW()),
(136, 'JavaScript engine', FALSE, 3, NOW()),
(136, 'CSS framework', FALSE, 4, NOW()),

-- React HTML
(137, 'False', TRUE, 1, NOW()),
(137, 'True', FALSE, 2, NOW());

-- Answers for Linear Algebra (Quiz 17)
INSERT INTO answers (question_id, answer_text, is_correct, order_index, created_at) VALUES
(138, 'A rectangular array of numbers', TRUE, 1, NOW()),
(138, 'A mathematical equation', FALSE, 2, NOW()),
(138, 'A geometric shape', FALSE, 3, NOW()),
(138, 'A numerical sequence', FALSE, 4, NOW()),

(139, 'Square matrix', TRUE, 1, NOW()),
(139, 'Identity matrix', TRUE, 2, NOW()),
(139, 'Diagonal matrix', TRUE, 3, NOW()),
(139, 'Circular matrix', FALSE, 4, NOW()),

(140, 'True', TRUE, 1, NOW()),
(140, 'False', FALSE, 2, NOW()),

(141, 'A scalar value derived from a square matrix', TRUE, 1, NOW()),
(141, 'The sum of matrix elements', FALSE, 2, NOW()),
(141, 'The product of matrices', FALSE, 3, NOW()),
(141, 'The inverse of a matrix', FALSE, 4, NOW()),

(142, 'Addition', TRUE, 1, NOW()),
(142, 'Multiplication', TRUE, 2, NOW()),
(142, 'Transpose', TRUE, 3, NOW()),
(142, 'Division', FALSE, 4, NOW()),

-- Eigenvector question
(143, 'Vector that maintains direction when transformed', TRUE, 1, NOW()),
(143, 'Zero vector', FALSE, 2, NOW()),
(143, 'Unit vector', FALSE, 3, NOW()),
(143, 'Basis vector', FALSE, 4, NOW()),

-- Identity matrix properties
(144, 'Diagonal elements are all 1', TRUE, 1, NOW()),
(144, 'Non-diagonal elements are 0', TRUE, 2, NOW()),
(144, 'Square matrix', TRUE, 3, NOW()),
(144, 'Rectangular matrix', FALSE, 4, NOW()),

-- Matrix rank
(145, 'Number of linearly independent rows/columns', TRUE, 1, NOW()),
(145, 'Number of rows', FALSE, 2, NOW()),
(145, 'Number of columns', FALSE, 3, NOW()),
(145, 'Sum of diagonal elements', FALSE, 4, NOW()),

-- Matrix multiplication commutative
(146, 'False', TRUE, 1, NOW()),
(146, 'True', FALSE, 2, NOW()),

-- Singular matrix
(147, 'Matrix with zero determinant', TRUE, 1, NOW()),
(147, 'Identity matrix', FALSE, 2, NOW()),
(147, 'Square matrix', FALSE, 3, NOW()),
(147, 'Diagonal matrix', FALSE, 4, NOW());

-- Answers for Astronomy Basics (Quiz 18)
INSERT INTO answers (question_id, answer_text, is_correct, order_index, created_at) VALUES
(148, 'A huge collection of stars, gas, and dust', TRUE, 1, NOW()),
(148, 'A single star system', FALSE, 2, NOW()),
(148, 'A type of planet', FALSE, 3, NOW()),
(148, 'A moon', FALSE, 4, NOW()),

(149, 'Earth', TRUE, 1, NOW()),
(149, 'Mars', TRUE, 2, NOW()),
(149, 'Jupiter', TRUE, 3, NOW()),
(149, 'Pluto', FALSE, 4, NOW()),

(150, 'True', TRUE, 1, NOW()),
(150, 'False', FALSE, 2, NOW()),

(151, 'Moon''s position relative to Earth and Sun', TRUE, 1, NOW()),
(151, 'Earth''s rotation', FALSE, 2, NOW()),
(151, 'Solar flares', FALSE, 3, NOW()),
(151, 'Planetary alignment', FALSE, 4, NOW()),

(152, 'Spiral', TRUE, 1, NOW()),
(152, 'Elliptical', TRUE, 2, NOW()),
(152, 'Irregular', TRUE, 3, NOW()),
(152, 'Squared', FALSE, 4, NOW()),

-- Light year
(153, 'Distance light travels in one year', TRUE, 1, NOW()),
(153, 'Time light takes to reach Earth', FALSE, 2, NOW()),
(153, 'Speed of light', FALSE, 3, NOW()),
(153, 'Brightness of a star', FALSE, 4, NOW()),

-- Types of stars
(154, 'Red Giant', TRUE, 1, NOW()),
(154, 'White Dwarf', TRUE, 2, NOW()),
(154, 'Neutron Star', TRUE, 3, NOW()),
(154, 'Blue Moon', FALSE, 4, NOW()),

-- Pluto planet
(155, 'False', TRUE, 1, NOW()),
(155, 'True', FALSE, 2, NOW());

-- Answers for Database Design (Quiz 19)
INSERT INTO answers (question_id, answer_text, is_correct, order_index, created_at) VALUES
(156, 'Process of organizing data to reduce redundancy', TRUE, 1, NOW()),
(156, 'Creating backup of database', FALSE, 2, NOW()),
(156, 'Converting data types', FALSE, 3, NOW()),
(156, 'Deleting duplicate records', FALSE, 4, NOW()),

(157, 'One-to-One', TRUE, 1, NOW()),
(157, 'One-to-Many', TRUE, 2, NOW()),
(157, 'Many-to-Many', TRUE, 3, NOW()),
(157, 'None-to-None', FALSE, 4, NOW()),

(158, 'True', TRUE, 1, NOW()),
(158, 'False', FALSE, 2, NOW()),

(159, 'A key referencing another table''s primary key', TRUE, 1, NOW()),
(159, 'A backup key', FALSE, 2, NOW()),
(159, 'An optional key', FALSE, 3, NOW()),
(159, 'A temporary key', FALSE, 4, NOW()),

(160, 'UNIQUE', TRUE, 1, NOW()),
(160, 'NOT NULL', TRUE, 2, NOW()),
(160, 'CHECK', TRUE, 3, NOW()),
(160, 'VERIFY', FALSE, 4, NOW()),

-- Database index
(161, 'Data structure to improve query speed', TRUE, 1, NOW()),
(161, 'Primary key', FALSE, 2, NOW()),
(161, 'Table of contents', FALSE, 3, NOW()),
(161, 'Data backup', FALSE, 4, NOW()),

-- Normalization forms
(162, '1NF', TRUE, 1, NOW()),
(162, '2NF', TRUE, 2, NOW()),
(162, '3NF', TRUE, 3, NOW()),
(162, '0NF', FALSE, 4, NOW()),

-- Data integrity
(163, 'Accuracy and consistency of data', TRUE, 1, NOW()),
(163, 'Data backup process', FALSE, 2, NOW()),
(163, 'Data encryption', FALSE, 3, NOW()),
(163, 'Data storage method', FALSE, 4, NOW()),

-- Multiple primary keys
(164, 'False', TRUE, 1, NOW()),
(164, 'True', FALSE, 2, NOW());

-- Answers for Probability Theory (Quiz 20)
INSERT INTO answers (question_id, answer_text, is_correct, order_index, created_at) VALUES
(165, 'Likelihood of an event occurring', TRUE, 1, NOW()),
(165, 'Certainty of an outcome', FALSE, 2, NOW()),
(165, 'Number of possible outcomes', FALSE, 3, NOW()),
(165, 'Prediction of future events', FALSE, 4, NOW()),

(166, 'Normal distribution', TRUE, 1, NOW()),
(166, 'Binomial distribution', TRUE, 2, NOW()),
(166, 'Poisson distribution', TRUE, 3, NOW()),
(166, 'Linear distribution', FALSE, 4, NOW()),

(167, 'True', FALSE, 1, NOW()),
(167, 'False', TRUE, 2, NOW()),

(168, 'Probability of an event given another event occurred', TRUE, 1, NOW()),
(168, 'Probability of two independent events', FALSE, 2, NOW()),
(168, 'Probability of no events occurring', FALSE, 3, NOW()),
(168, 'Probability of all events occurring', FALSE, 4, NOW()),

(169, 'Independent events', TRUE, 1, NOW()),
(169, 'Dependent events', TRUE, 2, NOW()),
(169, 'Mutually exclusive events', TRUE, 3, NOW()),
(169, 'Continuous events', FALSE, 4, NOW()),

-- Bayes Theorem
(170, 'Formula for conditional probability', TRUE, 1, NOW()),
(170, 'Formula for total probability', FALSE, 2, NOW()),
(170, 'Formula for independence', FALSE, 3, NOW()),
(170, 'Formula for variance', FALSE, 4, NOW()),

-- Properties of probability
(171, 'Between 0 and 1', TRUE, 1, NOW()),
(171, 'Sum of all outcomes is 1', TRUE, 2, NOW()),
(171, 'Non-negative', TRUE, 3, NOW()),
(171, 'Always greater than 0.5', FALSE, 4, NOW()),

-- Mutually exclusive events
(172, 'False', TRUE, 1, NOW()),
(172, 'True', FALSE, 2, NOW());


