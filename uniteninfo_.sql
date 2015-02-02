-- phpMyAdmin SQL Dump
-- version 3.5.2.2
-- http://www.phpmyadmin.net
--
-- Host: 127.0.0.1
-- Generation Time: Jan 26, 2015 at 02:29 AM
-- Server version: 5.5.27
-- PHP Version: 5.4.7

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+08:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `uniteninfo`
--

DROP FUNCTION IF EXISTS semester_sort;
DROP FUNCTION IF EXISTS UC_DELIMETER;
DROP FUNCTION IF EXISTS UC_FIRST;

SHOW FUNCTION STATUS;

DELIMITER $$
--
-- Functions
--
CREATE  FUNCTION `semester_sort`(semester_name VARCHAR(100)) RETURNS varchar(20) CHARSET latin1
    DETERMINISTIC
BEGIN 
	DECLARE sem INT(11);
	IF(STRCMP( SUBSTRING_INDEX( TRIM(semester_name), ',', 1 ), 'Semester 1') = 0) 
        THEN 
        	SET sem = 1; 
    ELSEIF(STRCMP( SUBSTRING_INDEX( TRIM(semester_name), ',', 1 ), 'Semester 2') = 0)
        THEN 
        	SET sem = 2; 
    ELSEIF(STRCMP( SUBSTRING_INDEX( TRIM(semester_name), ',', 1 ), 'Special Semester') = 0) 
        THEN 
        	SET sem = 3; 
    END IF; 
    return CONCAT(SUBSTRING(semester_name , -9 ),',',sem); 
END$$

CREATE  FUNCTION `UC_DELIMETER`(oldName VARCHAR(255), delim VARCHAR(1), trimSpaces BOOL) RETURNS varchar(255) CHARSET latin1
BEGIN
  SET @oldString := oldName;
  SET @newString := "";
 
  tokenLoop: LOOP
    IF trimSpaces THEN SET @oldString := TRIM(BOTH " " FROM @oldString); END IF;
 
    SET @splitPoint := LOCATE(delim, @oldString);
 
    IF @splitPoint = 0 THEN
      SET @newString := CONCAT(@newString, UC_FIRST(@oldString));
      LEAVE tokenLoop;
    END IF;
 
    SET @newString := CONCAT(@newString, UC_FIRST(SUBSTRING(@oldString, 1, @splitPoint)));
    SET @oldString := SUBSTRING(@oldString, @splitPoint+1);
  END LOOP tokenLoop;
 
  RETURN @newString;
END$$

CREATE  FUNCTION `UC_FIRST`(oldWord VARCHAR(255)) RETURNS varchar(255) CHARSET latin1
RETURN CONCAT(UCASE(SUBSTRING(oldWord, 1, 1)),SUBSTRING(oldWord, 2))$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `campus`
--

CREATE TABLE IF NOT EXISTS `campus` (
  `campus_id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(256) NOT NULL,
  PRIMARY KEY (`campus_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=3 ;

--
-- Dumping data for table `campus`
--

INSERT INTO `campus` (`campus_id`, `name`) VALUES
(1, 'Kampus Putrajaya'),
(2, 'Kampus Sultan Haji Ahmad Shah, Muadzam Shah Pahang');

-- --------------------------------------------------------

--
-- Table structure for table `last_update_subject`
--

CREATE TABLE IF NOT EXISTS `last_update_subject` (
  `last_update_subject_id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `semester_id` int(11) NOT NULL,
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`last_update_subject_id`),
  KEY `user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `lecturer`
--

CREATE TABLE IF NOT EXISTS `lecturer` (
  `lecturer_id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  PRIMARY KEY (`lecturer_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `program`
--

CREATE TABLE IF NOT EXISTS `program` (
  `program_id` int(11) NOT NULL AUTO_INCREMENT,
  `program_name` varchar(256) NOT NULL,
  PRIMARY KEY (`program_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=3 ;

-- --------------------------------------------------------

--
-- Table structure for table `scorun`
--

CREATE TABLE IF NOT EXISTS `scorun` (
  `scorun_id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `value` float NOT NULL,
  `last_update` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`scorun_id`),
  KEY `user_id` (`user_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=2 ;

-- --------------------------------------------------------

--
-- Table structure for table `semester`
--

CREATE TABLE IF NOT EXISTS `semester` (
  `semester_id` int(11) NOT NULL AUTO_INCREMENT,
  `semester_name` varchar(100) NOT NULL,
  PRIMARY KEY (`semester_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=6 ;

-- --------------------------------------------------------

--
-- Table structure for table `subjects`
--

CREATE TABLE IF NOT EXISTS `subjects` (
  `subject_id` int(11) NOT NULL AUTO_INCREMENT,
  `code` varchar(20) NOT NULL,
  `name` varchar(100) NOT NULL,
  PRIMARY KEY (`subject_id`),
  UNIQUE KEY `code` (`code`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=714 ;

--
-- Dumping data for table `subjects`
--

INSERT INTO `subjects` (`subject_id`, `code`, `name`) VALUES
(1, 'HRSB313', 'Recruitment and Selection'),
(2, 'HRSB323', 'Training and Development'),
(3, 'HRSB333', 'Performance Management'),
(4, 'HRSB343', 'Cross-Cultural Management'),
(5, 'HRSB353', 'Compensation Management'),
(6, 'HRSB363', 'Industrial Relation'),
(7, 'HRSB373', 'Occupational Safety & Health'),
(8, 'HRSB383', 'HR Research'),
(9, 'HRSB393', 'Applied HR Research'),
(10, 'IBMB313', 'Managing Multinational Corporation'),
(11, 'IBMB323', 'Production and Operation Management'),
(12, 'IBMB333', 'International Business Policy'),
(13, 'IBMB343', 'Export Management'),
(14, 'IBMB353', 'International Human Resource Management'),
(15, 'IBMB363', 'International Logistic'),
(16, 'IBMB373', 'Seminar in International Business'),
(17, 'IBMB383', 'Sea Transportation'),
(18, 'IBMB393', 'Merger and Acquisition'),
(19, 'LAWB223', 'Malaysian Company Law'),
(20, 'LWBB113', 'Malaysian Commercial Law'),
(21, 'LWBB223', 'Malaysian Company Law and Secretarial Practices'),
(22, 'MGMB113', 'Principles of Management'),
(23, 'MGMB213', 'Organisational Behaviour'),
(24, 'MGMB214', 'Human Resource Management'),
(25, 'MGMB223', 'Organisation Theory'),
(26, 'MGMB233', 'Organisational Development and Change'),
(27, 'MGMB253', 'International Business'),
(28, 'MGMB263', 'Management Information System'),
(29, 'MGMB313', 'Business Ethics'),
(30, 'MGMB314', 'Strategic Management'),
(31, 'MGMB323', 'Management Science'),
(32, 'MGMB333', 'Strategic Management'),
(33, 'PNGB213', 'Management Science'),
(34, 'PNGB333', 'Strategic Management'),
(35, 'PSMB333', 'Organization Theory'),
(36, 'PSMB373', 'Organizational Development & Change'),
(37, 'HRMB313', 'Training & Development'),
(38, 'HRMB323', 'Human Resource Planning'),
(39, 'HRMB333', 'Total Quality Management'),
(40, 'HRMB343', 'Occupational Safety and Health'),
(41, 'HRMB413', 'Organizational Theory'),
(42, 'MMTB243', 'Human Resource Management'),
(43, 'MMTB333', 'Strategic Management'),
(44, 'PNGB223', 'Management Information System'),
(45, 'PNGB233', 'Organisational Behaviour'),
(46, 'PNGB243', 'Human Resource Management'),
(47, 'PNGB313', 'Business Ethics'),
(48, 'PNGB323', 'International Business'),
(49, 'PSMB313', 'Industrial Relation'),
(50, 'PSMB323', 'Training & Development'),
(51, 'PSMB343', 'Total Quality Management'),
(52, 'PSMB353', 'Compensation Management'),
(53, 'PSMB363', 'Performance Management'),
(54, 'PSMB383', 'Occupational Safety & Health'),
(55, 'PUNB113', 'Malaysian Commercial Law'),
(56, 'PUNB223', 'Malaysian Company Law & Sec. Practice'),
(57, 'ENDB313', 'Entrepreneurship'),
(58, 'ENDB323', 'Franchising'),
(59, 'ENDB333', 'Entrepreneurship Research'),
(60, 'ENDB343', 'IP & Technological Innovation'),
(61, 'ENDB353', 'Strategic Entrepreneurship'),
(62, 'ENDB363', 'Applied Entrepreneurship Research'),
(63, 'ENDB373', 'Issues In Malaysian Entrepreneurship'),
(64, 'ENEB313', 'Islamic Entrepreneurship'),
(65, 'ENEB323', 'International Entrepreneurship'),
(66, 'MGMB243', 'Marketing and Human Resources Management'),
(67, 'MKEB313', 'Marketing Channels Management'),
(68, 'MKEB323', 'Business-to-Business Marketing'),
(69, 'MKEB333', 'International Marketing'),
(70, 'MKGB113', 'Principles of Marketing'),
(71, 'MKGB213', 'Consumer and Buyer Behaviour'),
(72, 'MKGB313', 'Product Management'),
(73, 'MKGB323', 'Multimedia Marketing'),
(74, 'MKGB333', 'Integrated Marketing Communications'),
(75, 'MKGB343', 'Marketing Research'),
(76, 'MKGB353', 'Service Marketing'),
(77, 'MKGB363', 'Sales Management'),
(78, 'MKGB373', 'Applied Marketing Research'),
(79, 'MKGB383', 'Issue of Marketing in Malaysia'),
(80, 'ETPB313', 'Entrepreneurship'),
(81, 'ETPB323', 'Entrepreneurship From Islamic Perspective'),
(82, 'ETPB333', 'Franchising'),
(83, 'ETPB343', 'Technological Innovation'),
(84, 'ETPB353', 'Issues In Malaysian Entrepreneurship'),
(85, 'ETPB363', 'Strategic Entrepreneurship'),
(86, 'ETPB373', 'Entrepreneurship Field Studies'),
(87, 'PMSB113', 'Principles of Marketing'),
(88, 'PMSB213', 'Consumer and Buyer Behaviour'),
(89, 'PMSB303', 'Integrated Marketing Communication'),
(90, 'PMSB313', 'Marketing Research'),
(91, 'PMSB323', 'Marketing Channels Management'),
(92, 'PMSB333', 'Sales Management'),
(93, 'PMSB343', 'Business-to-Business Marketing'),
(94, 'PMSB353', 'Product Management'),
(95, 'PMSB363', 'Multimedia Marketing'),
(96, 'PMSB373', 'International Marketing'),
(97, 'PMSB383', 'Marketing Decisions Support System'),
(98, 'PMSB393', 'Services Marketing'),
(99, 'CECB113', 'Mechanics I: Statics'),
(100, 'CECB122', 'Mechanics II: Dynamics'),
(101, 'CECB211', 'Civil Engineering Drafting Technology Laboratory'),
(102, 'CECB212', 'Civil Engineering Drafting Technology'),
(103, 'CECB423', 'Numerical Methods for Civil Engineers'),
(104, 'CEEB221', 'Introduction to Environmental Engineering Laboratory'),
(105, 'CEEB223', 'Introduction to Environmental Engineering'),
(106, 'CEEB313', 'Water & Wastewater Engineering'),
(107, 'CEGB111', 'Geology Laboratory'),
(108, 'CEGB112', 'Engineering Geology'),
(109, 'CEGB231', 'Soil Mechanics Laboratory'),
(110, 'CEGB233', 'Soil Mechanics'),
(111, 'CEGB333', 'Geotechnical Engineering'),
(112, 'CEGB423', 'Foundation Engineering I'),
(113, 'CEGB483', 'GIS For Civil Engineering Applications'),
(114, 'CEGB493', 'Environmental Geotechnology and Geotechnical Modeling'),
(115, 'CEMB111', 'Civil Engineering Materials Laboratory'),
(116, 'CEMB113', 'Civil Engineering Materials'),
(117, 'CEMB121', 'Mechanics of Materials Laboratory'),
(118, 'CEMB124', 'Mechanics of Materials'),
(119, 'CEPB323', 'Project Management & Construction'),
(120, 'CERB412', 'Project I'),
(121, 'CERB424', 'Project II'),
(122, 'CESB223', 'Structural Analysis I'),
(123, 'CESB333', 'Structural Steel Design I'),
(124, 'CESB343', 'Reinforced Concrete Design I'),
(125, 'CESB353', 'Structural Analysis II'),
(126, 'CESB403', 'Computer Analysis & Design of Structures'),
(127, 'CESB423', 'Reinforced Concrete Design II'),
(128, 'CESB483', 'Repair, Assessment & Rehabbilitation'),
(129, 'CESB493', 'Integrated Civil Eng Design Project'),
(130, 'CETB411', 'Highway & Transportation Engineering Laboratory'),
(131, 'CETB412', 'Transportation Engineering'),
(132, 'CETB414', 'Highway & Transportation Engineering'),
(133, 'CETB423', 'Highway Design & Traffic Engineering'),
(134, 'CEVB211', 'Surveying Practical Training'),
(135, 'CEVB213', 'Surveying for Engineers'),
(136, 'CEWB121', 'Mechanics of Fluids Laboratory'),
(137, 'CEWB123', 'Mechanics of Fluids'),
(138, 'CEWB221', 'Hydrology & Hydraulic Engineering Laboratory'),
(139, 'CEWB222', 'Hydraulic Engineering'),
(140, 'CEWB423', 'Water Resources Engineering'),
(141, 'CEEB433', 'Solid Waste Management'),
(142, 'CETB322', 'Highway Engineering'),
(143, 'CEWB433', 'Urban Hydrology and Stormwater Engineering'),
(144, 'CEWB493', 'Dam Engineering'),
(145, 'EEEB113', 'Circuit Analysis 1'),
(146, 'EEEB123', 'Circuit Analysis II'),
(147, 'EEEB253', 'Electromagnetic Fields & Waves'),
(148, 'EEEB281', 'Electrical Machines Lab'),
(149, 'EEEB283', 'Electrical Machines & Drives'),
(150, 'EEEB323', 'Control System'),
(151, 'EEEB393', 'Power Electronics'),
(152, 'EEEB423', 'Control System II'),
(153, 'EEEB443', 'Control & Drives'),
(154, 'EEPB353', 'Electrical Power System I'),
(155, 'EEPB383', 'Electrical Power System II'),
(156, 'EEPB413', 'Electrical Installations'),
(157, 'EEPB463', 'High Voltage Technology'),
(158, 'EEPB473', 'Power System Protection'),
(159, 'EEPB493', 'High Voltage Direct Current (HVDC), and FACTS Devices'),
(160, 'EPEB423', 'Electricity Industry Economic'),
(161, 'EPEB433', 'Power System Communication'),
(162, 'EPEB443', 'Energy Conversions'),
(163, 'EPEB453', 'Power Distribution Engineering'),
(164, 'EPRB412', 'Project I'),
(165, 'EPRB423', 'Project II'),
(166, 'EPRB424', 'Project II'),
(167, 'EEEB344', 'Electromechanical Devices'),
(168, 'EEEB403', 'Capstone Design Course'),
(169, 'EEEB413', 'Electro-Mechanical Systems'),
(170, 'EEPB423', 'Electrical Safety and Hazards'),
(171, 'EPEB413', 'Power Quality'),
(172, 'EPRB413', 'Project I'),
(173, 'ECCB111', 'Introduction to Computer and Communication Engineering (Work'),
(174, 'ECCB114', 'Circuit Theory'),
(175, 'ECCB123', 'Electronics Circuits Analysis'),
(176, 'ECCB233', 'Digital Systems Design'),
(177, 'ECCB243', 'Computer Organization and Architecture'),
(178, 'ECCB311', 'Digital Signal Processing Lab'),
(179, 'ECCB323', 'Data Structure and Algorithms'),
(180, 'ECCB343', 'Digital Communications'),
(181, 'ECCB363', 'Wireless and Mobile Communication'),
(182, 'ECEB453', 'Computer Controlled Systems'),
(183, 'ECEB463', 'Artificial Intelligence and Neural-fuzzy Systems'),
(184, 'ECEB473', 'Advanced Microprocessor'),
(185, 'ECEB483', 'Computer Architecture'),
(186, 'ECRB412', 'Project 1'),
(187, 'ECRB424', 'Project II'),
(188, 'EECB351', 'Communication System Lab'),
(189, 'EECB353', 'Communication System'),
(190, 'EECB423', 'Data Communication and Network'),
(191, 'EECB433', 'Applied Telecommunication Systems'),
(192, 'EECB483', 'Optoelectronics and Fibre Optics'),
(193, 'EECB493', 'Radio Frequency/Microwave Engineering'),
(194, 'EEEB111', 'Electrical/Electronics Measurement Lab'),
(195, 'EEEB141', 'Electronics Design Lab'),
(196, 'EEEB143', 'Electronics Analysis & Design I'),
(197, 'EEEB161', 'Digital Logic Design Lab'),
(198, 'EEEB163', 'Digital Logic Design'),
(199, 'EEEB233', 'Signals & Systems'),
(200, 'EEEB273', 'Electronics Analysis & Design II'),
(201, 'EEEB363', 'Digital Signal Processing'),
(202, 'EEEB371', 'Microprocessor Systems Lab'),
(203, 'EEEB373', 'Microprocessor Systems'),
(204, 'EEEB383', 'Random Process'),
(205, 'EEIB413', 'Process Control & Instrumentations'),
(206, 'EESB313', 'Semiconductor Devices'),
(207, 'EESB423', 'VLSI Design'),
(208, 'EESB493', 'Embedded Systems'),
(209, 'ECCB113', 'Electronics Analysis & Design'),
(210, 'ECCB124', 'Circuit Theory'),
(211, 'ECCB131', 'Introduction to Computer and Communication Engineering (Work'),
(212, 'ECCB213', 'Object Oriented Programming'),
(213, 'EECB473', 'Data Network Architecture and Electronics'),
(214, 'EEEB473', 'Image Processing'),
(215, 'EEEB513', 'Computer Controlled Systems'),
(216, 'EEED183', 'Engr.Graphics & Computer Application'),
(217, 'EEED223', 'Electrical Machinery'),
(218, 'EEED234', 'Industrial Automation'),
(219, 'EEED254', 'Introduction to Microcontrollers'),
(220, 'EEIB423', 'Nuclear Electronics'),
(221, 'EESB443', 'Semiconductor Manufacturing Technology'),
(222, 'MEFB121', 'Manufacturing Processes Lab.'),
(223, 'MEFB211', 'Manufacturing Processes Lab'),
(224, 'MEFB213', 'Manufacturing Processes'),
(225, 'MEFB433', 'Production Planning & Control'),
(226, 'MEFB473', 'Computer Aided Manufacturing'),
(227, 'MEHB213', 'Thermodynamics I'),
(228, 'MEHB221', 'Fluids Mechanics Laboratory (Thermofluids Lab)'),
(229, 'MEHB223', 'Mechanics of Fluids I'),
(230, 'MEHB244', 'Thermodynamics'),
(231, 'MEHB312', 'Thermodynamics II'),
(232, 'MEHB321', 'Heat Transfer & Applied Thermo. Lab.'),
(233, 'MEHB323', 'Heat Transfer'),
(234, 'MEHB331', 'Thermo-Fluids Lab.'),
(235, 'MEHB332', 'Mechanics of Fluids II'),
(236, 'MEHB334', 'Mechanics of Fluids'),
(237, 'MEHB354', 'Advanced Thermo-Fluids'),
(238, 'MEHB413', 'Heating Ventilating & Air Conditioning'),
(239, 'MEHB433', 'Combustion Engineering'),
(240, 'MEHB463', 'Computational Fluid Dynamics'),
(241, 'MEHB471', 'Heat Transfer & App. Thermo. Lab.'),
(242, 'MEHB474', 'Heat Transfer'),
(243, 'MEHB503', 'Renewable Energy'),
(244, 'MEHB513', 'Introduction to Nuclear Technology'),
(245, 'MEHB523', 'Introduction To Sustainability Engineering'),
(246, 'MEMB113', 'Engineering Graphics and CAE'),
(247, 'MEMB123', 'Mechanics I: Statics'),
(248, 'MEMB203', 'Eng. Graphics & Comp. App. in Eng. (CAE)'),
(249, 'MEMB214', 'Mechanics I - Statics'),
(250, 'MEMB221', 'Mechanics and Materials Lab.'),
(251, 'MEMB224', 'Mechanics II : Dynamics'),
(252, 'MEMB233', 'Mechanics II: Dynamics'),
(253, 'MEMB243', 'Mechanics of Materials'),
(254, 'MEMB263', 'Theory of Machines'),
(255, 'MEMB311', 'Materials Lab'),
(256, 'MEMB314', 'Mechanics of Materials'),
(257, 'MEMB321', 'Mechanical Design & CAD Lab'),
(258, 'MEMB322', 'Mechanical Design Process'),
(259, 'MEMB324', 'Mechanical Design'),
(260, 'MEMB331', 'Machine Design & CAD Lab'),
(261, 'MEMB333', 'Machine Design'),
(262, 'MEMB443', 'Mechanical Vibrations'),
(263, 'MEMB453', 'Non Destructive Testing'),
(264, 'MEMB463', 'Failure Analysis and Design'),
(265, 'MEMB483', 'Capstone Design'),
(266, 'MESB203', 'Engineering Measurements & Lab'),
(267, 'MESB313', 'Modeling & Analysis of Dynamic Systems'),
(268, 'MESB333', 'Engineering Measurements & Lab'),
(269, 'MESB374', 'Modeling & Analysis of Dynamics System'),
(270, 'MESB403', 'Automation & Robotics'),
(271, 'MESB413', 'Elements of Mechatronics'),
(272, 'MESB443', 'Electro-Mechanical Systems'),
(273, 'METB113', 'Engineering Materials'),
(274, 'METB263', 'Engineering Materials'),
(275, 'METB413', 'Advanced Materials'),
(276, 'MPRB412', 'Project 1'),
(277, 'MPRB413', 'Engineering Design & Project I'),
(278, 'MPRB423', 'Project II'),
(279, 'MPRB424', 'Project II'),
(280, 'MEHB403', 'Power Generation'),
(281, 'MEHB423', 'Turbomachinery'),
(282, 'MEHB493', 'Internal Combustion Engine'),
(283, 'MEMB423', 'Finite Element Method'),
(284, 'MESB323', 'Modeling and Control of Dynamic System'),
(285, 'COEB223', 'Numerical Methods for Engineers'),
(286, 'COEB314', 'Industrial Training'),
(287, 'COEB422', 'Engineers in Society'),
(288, 'COEB432', 'Principles of Management'),
(289, 'COEB442', 'Engineering Economics'),
(290, 'MATB113', 'Advanced Calculus & Analytical Geometry'),
(291, 'MATB133', 'Statistics for Engineers'),
(292, 'MATB143', 'Differential Equations'),
(293, 'MATB253', 'Linear Algebra'),
(294, 'MATB324', 'Numerical Methods For Engineers'),
(295, 'MATB344', 'Applied Statistics'),
(296, 'ACFM613', 'Accounting and Finance for Managers'),
(297, 'ACFM623', 'Governance Practices and Business Ethics'),
(298, 'MGTM600', 'Research Project / Case Study'),
(299, 'CGNB293', 'Statistics for Computing'),
(300, 'CGNB314', 'Industrial Training'),
(301, 'CGNB316', 'Industrial Training'),
(302, 'CGNB413', 'Project 1'),
(303, 'CGNB424', 'Project 2'),
(304, 'MITM683', 'Computer Vision'),
(305, 'CGNB313', 'Technology Entrepreneurship'),
(306, 'CPRB413', 'Project I'),
(307, 'CPRB423', 'Project ll'),
(308, 'CPRB424', 'Project II'),
(309, 'ABAF024', 'Business Accounting 2'),
(310, 'ACOF014', 'Introduction to Costing'),
(311, 'AFAF024', 'Introductory Financial Accounting 2'),
(312, 'ECMF013', 'Principles of Microeconomics'),
(313, 'ECMF023', 'Principles of Macroeconomics'),
(314, 'FICF014', 'Principles of Finance'),
(315, 'MGMF033', 'Introduction to Business Management'),
(316, 'CGMB113', 'Multimedia Technologies'),
(317, 'CGMB114', 'Basic Drawing'),
(318, 'CGMB123', 'Multimedia Application Development'),
(319, 'CGMB124', 'Computer Modelling and Creativity'),
(320, 'CGMB213', 'Multimedia System Interface Design'),
(321, 'CGMB214', 'Computer Graphics I'),
(322, 'CGMB234', 'Multimedia System Design'),
(323, 'CGMB354', 'Image Processing and Computer Vision'),
(324, 'CGMB511', 'Multimedia Application Practicum'),
(325, 'CGMB534', 'Game Design'),
(326, 'CGMB544', 'Audio & Video Technology'),
(327, 'CGMB564', 'Computer Animation'),
(328, 'CGMB133', 'Basic Drawing'),
(329, 'CGMB324', 'Multimedia System Design'),
(330, 'CGMB414', 'Computer Animation'),
(331, 'CGMB424', 'Image Processing and Computer Vision'),
(332, 'CGMB434', 'Virtual Reality'),
(333, 'CGMB504', 'Computer Vision & Image Processing'),
(334, 'CGMB584', 'AI & Game Aesthetics'),
(335, 'CGMB594', 'Computer Graphics II'),
(336, 'CISB412', 'Ethics and IT Professional Practices'),
(337, 'CISB422', 'Emerging Technologies'),
(338, 'CISB423', 'PROJECT 1'),
(339, 'CISB453', 'Introduction to Knowledge Management'),
(340, 'CISB464', 'PROJECT 2'),
(341, 'CISB524', 'IT & Business Process Reengineering'),
(342, 'CISB544', 'IT Governance'),
(343, 'CGNB412', 'Ethical, Legal and Professional Issues'),
(344, 'CISB113', 'Fundamentals of Information Systems'),
(345, 'CISB134', 'Structured Programming using C'),
(346, 'CISB213', 'Human Computer Interaction'),
(347, 'CISB214', 'Database I'),
(348, 'CISB233', 'Principles of Management and Organizational Behaviour'),
(349, 'CISB243', 'IS Project Management'),
(350, 'CISB254', 'Introduction to Object-Oriented Programming Using JAVA'),
(351, 'CISB313', 'Management Information System'),
(352, 'CISB314', 'Database 2'),
(353, 'CISB323', 'Business Programming'),
(354, 'CISB324', 'Business Data Processing'),
(355, 'CISB333', 'e-Business'),
(356, 'CISB334', 'e-Business'),
(357, 'CISB344', 'ADVANCED DATABASE'),
(358, 'CISB413', 'Malaysian Power and Electrical Landscape'),
(359, 'CISB414', 'Strategic Information Systems Planning'),
(360, 'CISB424', 'Information System Auditing'),
(361, 'CISB434', 'Decision Support Systems'),
(362, 'CISB444', 'Strategic Information System Planning'),
(363, 'CISB454', 'Introduction to Knowledge Management'),
(364, 'CISB584', 'Enterprise Resource Planning'),
(365, 'CISB594', 'Business Intelligence'),
(366, 'CSEB113', 'Principles of Programming'),
(367, 'CSEB114', 'Principles of Programming'),
(368, 'CSEB253', 'Software Quality'),
(369, 'CSEB254', 'Software Quality'),
(370, 'CSEB424', 'Software Testing'),
(371, 'CSEB554', 'Computer Forensics'),
(372, 'CSEB122', 'Problem Solving'),
(373, 'CSEB124', 'Web Programming'),
(374, 'CSEB134', 'Programming I'),
(375, 'CSEB214', 'Programming II'),
(376, 'CSEB223', 'System Analysis and Design'),
(377, 'CSEB233', 'Fundamentals of Software Engineering'),
(378, 'CSEB274', 'Requirement Engineering'),
(379, 'CSEB283', 'Systems Design'),
(380, 'CSEB294', 'Web Programming'),
(381, 'CSEB313', 'Programming Language'),
(382, 'CSEB314', 'Programming Language'),
(383, 'CSEB324', 'Data Structure and Algorithm'),
(384, 'CSEB334', 'Object Oriented Programming'),
(385, 'CSEB343', 'Object Oriented Design'),
(386, 'CSEB344', 'Software Project Management'),
(387, 'CSEB444', 'Advanced Software Engineering'),
(388, 'CSEB453', 'Software Quality'),
(389, 'CSEB534', 'Java Programming'),
(390, 'CSEB564', 'Multi Agent System'),
(391, 'CCSB123', 'Discrete Structure'),
(392, 'CSNB143', 'Discrete Structures'),
(393, 'CSNB393', 'Storage Technologies'),
(394, 'CSNB554', 'Network Routing and WAN'),
(395, 'CSNB574', 'Networked Computing'),
(396, 'EEIB263', 'Logic System & Process Control Design'),
(397, 'MITM673', 'Computer Networks'),
(398, 'CSNB113', 'System Administration'),
(399, 'CSNB123', 'Computer Organization'),
(400, 'CSNB133', 'Information Theory'),
(401, 'CSNB134', 'Statistics & Information Theory'),
(402, 'CSNB144', 'Programming I With C'),
(403, 'CSNB163', 'Digital Logic Design'),
(404, 'CSNB213', 'Data Comm and Computer Networks'),
(405, 'CSNB214', 'Computer Network and LAN'),
(406, 'CSNB224', 'Operating Systems Concepts'),
(407, 'CSNB234', 'Artificial Intelligence'),
(408, 'CSNB244', 'Programming II with C++'),
(409, 'CSNB314', 'Advanced Computer Networks'),
(410, 'CSNB324', 'Advanced Operating Systems'),
(411, 'CSNB344', 'Data Structure & Algorithms with STL'),
(412, 'CSNB374', 'Microprocessor Systems'),
(413, 'CSNB414', 'Data and Computer Security'),
(414, 'CSNB424', 'Network Analysis and Design'),
(415, 'CSNB514', 'Data and Computer Security'),
(416, 'CSNB524', 'Network Analysis and Design'),
(417, 'CSNB584', 'Embedded Systems'),
(418, 'CSNB594', 'Parallel Computing'),
(419, 'ENGB213', 'Business English'),
(420, 'ITCB213', 'IT Communications'),
(421, 'JAPB113', 'Japanese Language'),
(422, 'MALB103', 'Malay Language for International Student (LAN MPW 2123)'),
(423, 'MALB113', 'Bahasa Melayu Korporat'),
(424, 'MANB113', 'Mandarin Language'),
(425, 'TECB213', 'Technical Communications'),
(426, 'ENGF103', 'English for Academic Purposes'),
(427, 'ACSF012', 'Academic Study Skills'),
(428, 'CRTF013', 'Critical Thinking & Logic Skills'),
(429, 'ENLF023', 'Foundation English 2'),
(430, 'ENGB123', 'English Language II'),
(431, 'ENGD113', 'English 1'),
(432, 'MALD113', 'Bahasa Melayu'),
(433, 'TECD113', 'Technical Communications'),
(434, 'WRIB103', 'Essential Writing for International Students'),
(435, 'WRIF103', 'Essential Writing for International Students'),
(436, 'CGND314', 'Project'),
(437, 'CGND324', 'Industrial Training'),
(438, 'CHED124', 'Chemistry for Engineering'),
(439, 'CHEF111', 'Chemistry Laboratory 1'),
(440, 'CHEF114', 'Chemistry I'),
(441, 'CHEF124', 'Chemistry II'),
(442, 'CMPD112', 'PC Maintenance and Troubleshooting'),
(443, 'CMPD124', 'Introduction to Programming and Problem Solving Techniques'),
(444, 'CMPD133', 'Discrete Structures'),
(445, 'CMPD144', 'Programming 1'),
(446, 'CMPD153', 'Systems Administration'),
(447, 'CMPD164', 'Web Programming'),
(448, 'CMPD173', 'System Analysis and Design'),
(449, 'CMPD213', 'Fundamentals of Software Engineering'),
(450, 'CMPD223', 'Computer Organization'),
(451, 'CMPD233', 'Multimedia Technologies'),
(452, 'CMPD244', 'Programming 2'),
(453, 'CMPD314', 'Database Systems'),
(454, 'CMPD323', 'Data Communication and Computer Networks'),
(455, 'CMPD344', 'Data Structures and Algorithms'),
(456, 'CMPD353', 'Fundamentals of Operating Systems'),
(457, 'CMPD364', 'Object-oriented Programming'),
(458, 'CMPF112', 'Computing Skills'),
(459, 'CMPF114', 'Introduction to Computing'),
(460, 'CMPF124', 'Personal Productivity with Information Technology'),
(461, 'CMPF134', 'Fundamentals of Data and Information'),
(462, 'CMPF144', 'Introduction to Problem Solving and Basic Computer'),
(463, 'CMPF214', 'Introduction to Business'),
(464, 'ACCF024', 'Information Technology & Accounting Application'),
(465, 'MATF104', 'College Algebra'),
(466, 'MATF115', 'Introductory Calculus and Analytic Geometry'),
(467, 'MATF125', 'Calculus & Analytic Geometry 1'),
(468, 'MATF126', 'Calculus and Analytic Geometry 1'),
(469, 'MATF134', 'Finite  Mathematics'),
(470, 'MATF144', 'Calculus and Analytic Geometry 2'),
(471, 'MATF174', 'Trigonometry and Conic Sections'),
(472, 'MATF204', 'Business Mathematics'),
(473, 'PHYF104', 'Introduction to Physics'),
(474, 'PHYF111', 'Physics Laboratory I'),
(475, 'PHYF114', 'Physics I'),
(476, 'PHYF115', 'Physics 1'),
(477, 'PHYF121', 'Physics Laboratory II'),
(478, 'PHYF125', 'Physics 2'),
(479, 'PHYF134', 'Physics II for Computer Science'),
(480, 'PHYF144', 'Physics III'),
(481, 'MGMF024', 'Business Computing 2'),
(482, 'QNTF024', 'Business Mathematics'),
(483, 'CHED114', 'Chemistry for Engineering'),
(484, 'EEED114', 'Electrical Technology I'),
(485, 'EEED121', 'Electrical Measurement Lab'),
(486, 'MATD113', 'College Algebra'),
(487, 'MATD123', 'Mathematics II'),
(488, 'MATD124', 'Mathematics ll'),
(489, 'MEFD123', 'Manufacturing Processes'),
(490, 'MEHD214', 'Thermodynamics'),
(491, 'MEHD221', 'Fluids Mechanics Lab'),
(492, 'MEHD224', 'Mechanics of  Fluids'),
(493, 'MEMD121', 'Computer Aided Design (CAD) Laboratory'),
(494, 'MEMD124', 'Mechanics: Statics'),
(495, 'MEMD221', 'Mechanics of Materials Lab'),
(496, 'MEMD224', 'Mechanics of Materials'),
(497, 'METD224', 'Engineering Materials'),
(498, 'TECD123', 'Technical Communications'),
(499, 'ICSB112', 'Islam and Civil Society 1'),
(500, 'ICSB212', 'Islam and Civil Society II'),
(501, 'ICSB312', 'Islam and Civil Society III'),
(502, 'ISLB112', 'Islamic Studies I'),
(503, 'ISLB212', 'Islamic II'),
(504, 'ISLB312', 'Islamic Studies III'),
(505, 'KDKB113', 'Kepimpinan dan Keusahawanan'),
(506, 'MASB113', 'Malaysian Studies (LAN MPW 2133)'),
(507, 'MCSB112', 'Moral and Civil Society 1'),
(508, 'MCSB212', 'Moral and Civil Society II'),
(509, 'MCSB312', 'Moral and Civil Society III'),
(510, 'MORB112', 'Moral Studies I'),
(511, 'MORB212', 'Moral Studies II'),
(512, 'MORB312', 'Moral Studies III'),
(513, 'PKIB113', 'Creative Thinking'),
(514, 'RELB113', 'Comparative Religion'),
(515, 'SPRB113', 'Sport and Recreation Management at Workplace'),
(516, 'SPYB113', 'Introduction to Social Psychology'),
(517, 'FITF102', 'Kecergasan Foundation'),
(518, 'GOLF102', 'Golf  Foundation'),
(519, 'ISLF101', 'Foundation Islamic Studies'),
(520, 'ISLF103', 'Foundation Islamic Studies'),
(521, 'KAYF102', 'Kayaking'),
(522, 'MACF103', 'Introduction to Malaysian Constitution'),
(523, 'MALF102', 'Malaysian Culture For International Students'),
(524, 'MALF104', 'Malaysian Culture For International Students'),
(525, 'MORF101', 'Foundation Moral Studies'),
(526, 'MORF103', 'Moral Foundation'),
(527, 'MTAF101', 'Foundation Malaysian Territorial Army'),
(528, 'MTAF103', 'Foundation Malaysian Territorial Army'),
(529, 'PPYF103', 'Psychology Of Thinking'),
(530, 'SWIF102', 'Swimming  Foundation'),
(531, 'MTAF011', 'Kor UNITEN'),
(532, 'ISLD113', 'Islamic'),
(533, 'MOSD113', 'Moral Studies'),
(534, 'TITB113', 'Tamadun Islam and Tamadun Asia'),
(535, 'CIVB113', 'World Civilization'),
(536, 'FITB111', 'Aerobic Fitness I'),
(537, 'GOLB111', 'Golf I'),
(538, 'KAYB111', 'Kayaking I'),
(539, 'MASD113', 'Malaysian Studies'),
(540, 'ISLB122', 'Islamic Studies II'),
(541, 'ABAB113', 'Business Accounting'),
(542, 'ACGB213', 'Corporate Governace and Business Ethics'),
(543, 'ACSB413', 'Integrated Case Study'),
(544, 'ACTB123', 'Intermediate Financial Accounting I'),
(545, 'ACTB133', 'Financial Accounting'),
(546, 'ACTB323', 'Adv. Accounting Information System'),
(547, 'AFOB413', 'Forensic Accounting'),
(548, 'AFRB223', 'Intermediate Financial Accounting I'),
(549, 'AFRB233', 'Intermediate Financial Accounting II'),
(550, 'AFRB343', 'Advanced Financial Accounting I'),
(551, 'AFRB353', 'Advanced Financial Accounting II'),
(552, 'AFRB463', 'Consolidated Financial Statements'),
(553, 'AIAB413', 'Islamic Accounting'),
(554, 'AISB223', 'Accounting Information System'),
(555, 'AISB333', 'Advanced Accounting Information System'),
(556, 'AMAB113', 'Cost Accounting'),
(557, 'AMAB213', 'Managerial Accounting'),
(558, 'AMAB223', 'Management Accounting'),
(559, 'AMAB333', 'Advanced Management Accounting'),
(560, 'APSB313', 'Public Sector Accounting'),
(561, 'ARMB313', 'Accounting Research Method'),
(562, 'ARMB423', 'Accounting Project Paper'),
(563, 'ATPB313', 'Accounting Theory and Practice'),
(564, 'ATXB213', 'Malaysian Taxation I'),
(565, 'ATXB223', 'Malaysian Taxation II'),
(566, 'ATXB333', 'Specialised Taxation'),
(567, 'AUDB313', 'Auditing'),
(568, 'AUDB323', 'Audit and Investigation'),
(569, 'AUDB433', 'Internal Auditing'),
(570, 'PUNB413', 'Corporate Governance'),
(571, 'ACTB213', 'Intermediate Financial Accounting II'),
(572, 'ACTB223', 'Management Accounting'),
(573, 'ACTB233', 'Advanced Financial Accounting I'),
(574, 'ACTB243', 'Accounting Information System'),
(575, 'ACTB253', 'Malaysian Taxation I'),
(576, 'ACTB263', 'Managerial Accounting'),
(577, 'ACTB313', 'Advanced Financial Accounting II'),
(578, 'ACTB333', 'Auditing'),
(579, 'ACTB343', 'Malaysian Taxation II'),
(580, 'ACTB353', 'Advanced Management Accounting'),
(581, 'ACTB413', 'Audit & Investigation'),
(582, 'ACTB423', 'Accounting Theory & Practice'),
(583, 'ACTB433', 'Public Sector Accounting'),
(584, 'ACTB443', 'Specialised Accounting'),
(585, 'ACTB453', 'Islamic Accounting'),
(586, 'ACTB463', 'International Accounting'),
(587, 'ACTB473', 'Specialised Taxation'),
(588, 'ACTB483', 'Internal Auditing'),
(589, 'AFRB113', 'Financial Accounting'),
(590, 'AISB113', 'Information Technology and Accounting Application'),
(591, 'AITB418', 'Industrial Training'),
(592, 'ETPB303', 'Industrial Training'),
(593, 'ITFB304', 'Industrial Training'),
(594, 'ITHB304', 'Industrial Training'),
(595, 'ITIB304', 'Industrial Training'),
(596, 'PTMB303', 'Industrial Training'),
(597, 'PTSB303', 'Industrial Training'),
(598, 'ATTB406', 'Industrial Training'),
(599, 'ITEB304', 'Industrial Training'),
(600, 'ITMB304', 'Industrial Training'),
(601, 'ECMB223', 'Microeconomics'),
(602, 'ECMB233', 'Macroeconomics'),
(603, 'ECMB303', 'International Trade'),
(604, 'ECMB313', 'Malaysian Economy'),
(605, 'ECMB323', 'Introduction to Econometrics'),
(606, 'ECMB343', 'Money and Banking'),
(607, 'ECOB313', 'Malaysian Economy'),
(608, 'FICB103', 'Principles of Finance'),
(609, 'FICB113', 'Financial Management'),
(610, 'FICB123', 'Financial Management for Accounting'),
(611, 'FICB213', 'Corporate Finance'),
(612, 'FICB223', 'Financial Statement Analysis'),
(613, 'FICB233', 'Investment'),
(614, 'FICB243', 'Valuation'),
(615, 'FICB263', 'Asset -Liability Management'),
(616, 'FICB273', 'Islamic Capital market'),
(617, 'FICB303', 'International Finance'),
(618, 'FICB313', 'Financial Markets and Institutions'),
(619, 'FICB323', 'Security Analysis and Portfolio Management'),
(620, 'FICB333', 'Insurance and Risk Management'),
(621, 'FICB344', 'Project Paper in Finance'),
(622, 'FICB353', 'Finance Theory'),
(623, 'FICB363', 'Bank Management'),
(624, 'FICB373', 'Personal Financial Planning'),
(625, 'FICB383', 'Islamic Banking and Finance'),
(626, 'FICB393', 'Contemporary Issues in Finance'),
(627, 'FNCB303', 'International Finance'),
(628, 'FNCB313', 'Financial Market & Institutions'),
(629, 'FNCB323', 'Security Analysis & Portfolio Management'),
(630, 'QNTB113', 'Business Statistics'),
(631, 'QNTB133', 'Mathematics and Statistics for Accounting'),
(632, 'QNTB313', 'Research Methods'),
(633, 'QTMB123', 'Business Mathematics'),
(634, 'QTMB213', 'Research Methods'),
(635, 'ECNB233', 'Macroeconomics'),
(636, 'ECOB223', 'Microeconomics'),
(637, 'ECOB233', 'Macroeconomics'),
(638, 'ENTB363', 'Business From The Islamic Perspective'),
(639, 'ENTB373', 'Transfer of Technology'),
(640, 'ENTB433', 'Entrepreneurship Field Studies I'),
(641, 'ENTD213', 'Basics of Entrepreneurship'),
(642, 'FICB343', 'Derivative Market'),
(643, 'FNCB103', 'Principles of Finance'),
(644, 'FNCB113', 'Financial Management'),
(645, 'FNCB213', 'Corporate Finance'),
(646, 'FNCB223', 'Financial Statement Analysis'),
(647, 'FNCB233', 'Investment'),
(648, 'FNCB333', 'Insurance & Risk Management'),
(649, 'FNCB343', 'Derivatives Market'),
(650, 'FNCB344', 'Project Paper in Finance'),
(651, 'FNCB353', 'Finance Theory'),
(652, 'FNCB363', 'Bank Management'),
(653, 'FNCB383', 'Islamic Banking & Finance'),
(654, 'QNTB103', 'Mathematics of Finance'),
(655, 'QNTB123', 'Business Mathematics'),
(656, 'QTMB103', 'Mathematics of Finance'),
(657, 'QTMB113', 'Business Statistics'),
(658, 'HESB113', 'Hubungan Etnik'),
(659, 'MSTD113', 'Malaysian Studies'),
(660, 'AESB111', 'Aerobics'),
(661, 'ARBB113', 'Arabic Language I'),
(662, 'ARBB123', 'Arabic Language II'),
(663, 'ATSB111', 'Athletics'),
(664, 'BANB111', 'Badminton'),
(665, 'CREB113', 'Creative English'),
(666, 'ENAB122', 'English for Accounting II'),
(667, 'ENBB113', 'English for Business'),
(668, 'ENBB123', 'Public Speaking & Presentation'),
(669, 'ISSB112', 'Islamic Studies I (LAN MPW 2143)'),
(670, 'ISSB122', 'Islamic Studies II (LAN MPW 2143)'),
(671, 'ISSB232', 'Islamic Studies III (LAN MPW 2143)'),
(672, 'JPNB113', 'Japanese Language I'),
(673, 'JPNB123', 'Japanese Language II'),
(674, 'KAGB111', 'Kayaking'),
(675, 'MADB113', 'Mandarin Language I'),
(676, 'MADB123', 'Mandarin Language II'),
(677, 'MGMB123', 'Business Communication'),
(678, 'MGMD123', 'Principles of Management'),
(679, 'MGMD133', 'Business Communication'),
(680, 'MLAB113', 'Malay Language for Foreign Students'),
(681, 'MOSB122', 'Moral Studies II (LAN MPW 2153)'),
(682, 'MOSB232', 'Moral Studies III (LAN MPW 2153)'),
(683, 'MSTB113', 'Malaysian Studies (LAN MPW 2133)'),
(684, 'PNGB123', 'Business Communication'),
(685, 'PSBB113', 'Psychology'),
(686, 'PSYB113', 'Psychology'),
(687, 'PURB113', 'Public Relations'),
(688, 'SOSB113', 'Sociology'),
(689, 'WOEB113', 'Workplace English'),
(690, 'ABAD113', 'Principles of Financial Accounting'),
(691, 'ACAD113', 'Introduction to Managerial Accounting'),
(692, 'AFAD113', 'Financial Accounting I'),
(693, 'AFAD123', 'Financial Accounting II'),
(694, 'AFAD133', 'Intermediate Financial Accounting'),
(695, 'AISD113', 'Info. Tech. & Accounting Application'),
(696, 'AISD123', 'Info. Tech. & Accounting Application II'),
(697, 'ATHB111', 'Athletics I'),
(698, 'BADB111', 'Badminton I'),
(699, 'ENAB112', 'English for Accounting I'),
(700, 'ENAB113', 'English for Accounting'),
(701, 'ENBD113', 'English Language I'),
(702, 'ENBD123', 'English Language II'),
(703, 'FICD113', 'Principles of Finance'),
(704, 'FICD123', 'Financial Management'),
(705, 'ISSD113', 'Islamic Studies'),
(706, 'LWBD113', 'Business Law'),
(707, 'MACB113', 'Malaysian Culture for Foreign Students'),
(708, 'MGMD113', 'Business Computing Skill'),
(709, 'MGMD233', 'Management Information System'),
(710, 'MKGD113', 'Principles of Marketing'),
(711, 'MOSB112', 'Moral Studies I (LAN MPW 2153)'),
(712, 'QNTD123', 'Mathematics of Finance'),
(713, 'QNTD133', 'Business Statistics');

-- --------------------------------------------------------

--
-- Table structure for table `subject_by_student`
--

CREATE TABLE IF NOT EXISTS `subject_by_student` (
  `subject_by_student_id` int(11) NOT NULL AUTO_INCREMENT,
  `price` float NOT NULL,
  `subjects_id` int(11) NOT NULL,
  `semester_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `lecturer_id` int(11) NOT NULL,
  PRIMARY KEY (`subject_by_student_id`),
  KEY `subjects_id` (`subjects_id`),
  KEY `semester_id` (`semester_id`),
  KEY `user_id` (`user_id`),
  KEY `lecturer_id` (`lecturer_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=45 ;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE IF NOT EXISTS `users` (
  `user_id` int(11) NOT NULL AUTO_INCREMENT,
  `studentId` varchar(10) NOT NULL,
  `name` varchar(255) NOT NULL,
  `passhash` varchar(77) NOT NULL,
  `program_id` int(11) NOT NULL,
  `campus_id` int(11) NOT NULL,
  `advisor_id` int(11) NOT NULL,
  `email` varchar(100) NOT NULL,
  `phone` varchar(20) NOT NULL,
  `current_semester_id` int(11) NOT NULL,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `studentId` (`studentId`),
  KEY `program_id` (`program_id`),
  KEY `campus_id` (`campus_id`),
  KEY `advisor_id` (`advisor_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=2 ;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `last_update_subject`
--
ALTER TABLE `last_update_subject`
  ADD CONSTRAINT `last_update_subject_ibfk_3` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`);

--
-- Constraints for table `scorun`
--
ALTER TABLE `scorun`
  ADD CONSTRAINT `scorun_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`);

--
-- Constraints for table `subject_by_student`
--
ALTER TABLE `subject_by_student`
  ADD CONSTRAINT `subject_by_student_ibfk_2` FOREIGN KEY (`semester_id`) REFERENCES `semester` (`semester_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `subject_by_student_ibfk_3` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `subject_by_student_ibfk_4` FOREIGN KEY (`lecturer_id`) REFERENCES `lecturer` (`lecturer_id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;