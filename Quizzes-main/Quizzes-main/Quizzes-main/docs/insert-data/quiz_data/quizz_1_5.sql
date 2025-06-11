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
