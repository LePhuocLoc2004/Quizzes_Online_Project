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

