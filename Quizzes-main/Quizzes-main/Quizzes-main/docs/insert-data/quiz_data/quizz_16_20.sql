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
