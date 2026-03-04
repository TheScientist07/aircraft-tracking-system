-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Mar 04, 2026 at 08:27 AM
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
-- Database: `aircraft_tracking`
--

-- --------------------------------------------------------

--
-- Table structure for table `aircraft`
--

CREATE TABLE `aircraft` (
  `id` int(11) NOT NULL,
  `registration_number` varchar(50) NOT NULL,
  `model` varchar(100) NOT NULL,
  `total_hours` double NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `aircraft`
--

INSERT INTO `aircraft` (`id`, `registration_number`, `model`, `total_hours`) VALUES
(1, '9J-ADJ', 'CESSNA 210', 5255.2),
(2, '9J-CPC', 'CESSNA 206', 12000);

-- --------------------------------------------------------

--
-- Table structure for table `components`
--

CREATE TABLE `components` (
  `id` int(11) NOT NULL,
  `aircraft_id` int(11) NOT NULL,
  `component_name` varchar(100) NOT NULL,
  `life_limit_hours` double NOT NULL,
  `current_hours` double NOT NULL,
  `next_due_hours` double NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `components`
--

INSERT INTO `components` (`id`, `aircraft_id`, `component_name`, `life_limit_hours`, `current_hours`, `next_due_hours`) VALUES
(1, 1, 'magneto', 5000, 3500, 5000),
(2, 1, 'Battery', 2500, 2300, 2500),
(3, 1, 'Starter', 6000, 6100, 6000),
(4, 2, 'Propeller', 2400, 2000, 2400),
(5, 2, 'Engine', 12000, 12000, 12000),
(6, 2, 'Battery', 2500, 2400, 2500),
(7, 2, 'Magneto', 6000, 6100, 6000);

-- --------------------------------------------------------

--
-- Table structure for table `documents`
--

CREATE TABLE `documents` (
  `id` int(11) NOT NULL,
  `aircraft_id` int(11) NOT NULL,
  `document_type` varchar(100) NOT NULL,
  `issue_date` date NOT NULL,
  `expiry_date` date NOT NULL,
  `file_path` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `documents`
--

INSERT INTO `documents` (`id`, `aircraft_id`, `document_type`, `issue_date`, `expiry_date`, `file_path`) VALUES
(3, 1, 'Certificate of Insurance', '2025-03-01', '2026-05-02', NULL),
(4, 1, 'Radio license', '2025-02-28', '2026-03-01', NULL),
(5, 1, 'Weight and Balance Certificate', '2025-03-28', '2026-03-27', NULL),
(6, 2, 'Certificate of Maintenance', '2025-12-03', '2026-02-28', NULL),
(7, 2, 'Certificate of Airworthiness', '2025-01-03', '2026-01-31', NULL),
(8, 2, 'Certificate of Insurance', '2025-01-01', '2026-03-14', NULL),
(9, 2, 'Radio license', '2025-01-01', '2026-04-30', NULL),
(10, 2, 'Weight and Balance Certificate', '2024-12-30', '2026-01-01', NULL),
(11, 1, 'Certificate of Maintenance', '2026-01-01', '2026-04-04', 'uploads/aircraft_report_1.pdf'),
(12, 1, 'Certificate of Airworthiness', '2025-01-01', '2026-03-14', 'uploads/1772599412280_aircraft_report_2.pdf');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `full_name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `role_level` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `full_name`, `email`, `password_hash`, `role_level`) VALUES
(2, 'Gideon Ndlovu', 'admin@system.com', '$2a$10$Oqc.M5Lzz1ib//pfxR1oYeVp5qpsenGk7.wPQn89P8XmXwD4SpTo6', 5);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `aircraft`
--
ALTER TABLE `aircraft`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `components`
--
ALTER TABLE `components`
  ADD PRIMARY KEY (`id`),
  ADD KEY `aircraft_id` (`aircraft_id`);

--
-- Indexes for table `documents`
--
ALTER TABLE `documents`
  ADD PRIMARY KEY (`id`),
  ADD KEY `aircraft_id` (`aircraft_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `aircraft`
--
ALTER TABLE `aircraft`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `components`
--
ALTER TABLE `components`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `documents`
--
ALTER TABLE `documents`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `components`
--
ALTER TABLE `components`
  ADD CONSTRAINT `components_ibfk_1` FOREIGN KEY (`aircraft_id`) REFERENCES `aircraft` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `documents`
--
ALTER TABLE `documents`
  ADD CONSTRAINT `documents_ibfk_1` FOREIGN KEY (`aircraft_id`) REFERENCES `aircraft` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
