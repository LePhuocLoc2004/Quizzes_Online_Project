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
