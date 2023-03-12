create database hotelmanagement; -- How to create 

use hotelmanagement; -- Jumps into the database, must use it before making any changes/queries 

CREATE TABLE Hotel (  -- Every table must implement a primary key 
  hotel_id INT PRIMARY KEY,
  hotel_name VARCHAR(50) NOT NULL, -- Characters up to 50 can be inputted into this attribute
  location VARCHAR(100) NOT NULL,  -- Characters up to 50 can be inputted into this attribute
  contact_info VARCHAR(20) NOT NULL  -- Characters up to 50 can be inputted into this attribute
);

-- Defining the room type which can be single, double, queen, presidental suite etc 
CREATE TABLE RoomType (
  roomtype_id INT PRIMARY KEY, -- Int can only accept numerical values
  room_price DECIMAL(10,2) --  10 beginning and 2 after
);

CREATE TABLE Room (
  room_id INT PRIMARY KEY,-- The room_ID will also refer to room number 
  hotel_id INT NOT NULL,
  roomtype_ID INT,
  FOREIGN KEY (hotel_id) REFERENCES Hotel(hotel_id),
  FOREIGN KEY (roomtype_id) REFERENCES RoomType(roomtype_id)
);

-- Record the guest information separately, could possibly be used for future promotional emails to guests
CREATE TABLE Guest (
  guest_id INT PRIMARY KEY,
  guest_name VARCHAR(50) NOT NULL,
  guest_contact_info VARCHAR(50) NOT NULL -- Contact info can be listed as email and phone number
);

-- Defines booking register, all booking transactions are recorded in this table 
CREATE TABLE Booking (
  booking_id INT PRIMARY KEY,
  guest_id INT NOT NULL,
  room_id INT ,
  checkin_date DATE,
  checkout_date DATE,
  requests VARCHAR(100),
  FOREIGN KEY (guest_id) REFERENCES Guest(guest_id),
  FOREIGN KEY (room_id) REFERENCES Room(room_id)
);

-- Defines department which connect employees; such as Reception, Room-service, management, kitchen etc 
CREATE TABLE Department (
  dept_ID INT PRIMARY KEY,
  dept_name VARCHAR(50)
);

-- Defines employee information and their contact info along with their superior
CREATE TABLE Employee (
  employee_id INT PRIMARY KEY,
  dept_id INT,
  employee_name VARCHAR(50),
  job_title VARCHAR(50),
  contact VARCHAR(20),
  hotel_id INT,
  FOREIGN KEY (dept_id) REFERENCES Department(dept_id),
  FOREIGN KEY (hotel_id) REFERENCES Hotel(hotel_id)
);

-- This table provides the service type which can be room service, bar service, restauraunt service, long distance call etc
CREATE TABLE Service_Type (  
	service_type_id INT primary key, 
    service_description varchar(100)
);

CREATE TABLE Service (
  booking_id INT, 
  service_type_id INT, 
  service_date date,
  amount DECIMAL(10,2),
  FOREIGN KEY (booking_id) REFERENCES Booking(booking_id),
  FOREIGN KEY (service_type_id) REFERENCES Service_Type(service_type_id)
);

INSERT INTO Hotel VALUES (123, "Embassy" , "Toronto", 4166786545);
SELECT hotel_id FROM Hotel;
SELECT * FROM HOTEL WHERE location = 'Alberta' ORDER BY hotel_id DESC;


INSERT INTO Hotel (hotel_id, hotel_name, location, contact_info)
VALUES 
(100, 'Chateau Lake Louise', 'Alberta', '555-555-1212'),
(101, 'The Fairmont Banff Springs', 'Alberta', '555-555-1213'),
(102, 'The Fairmont Chateau Whistler', 'British Columbia', '555-555-1214'),
(103, 'The Fairmont Jasper Park Lodge', 'Alberta', '555-555-1215');

INSERT INTO Guest (guest_id, guest_name, guest_contact_info)
VALUES
(100, 'John Doe', 'johndoe@email.com'),
(101, 'Jane Doe', 'janedoe@email.com'),
(102, 'John Smith', 'johnsmith@email.com'),
(103, 'Jane Smith', 'janesmith@email.com');

INSERT INTO RoomType (roomtype_id, room_price)
VALUES 
(1, 100),
(2, 200),
(3, 300),
(4, 400);

INSERT INTO Room (room_id, hotel_id, roomtype_id)
VALUES
(101, 100, 1),
(102, 101, 2),
(103, 102, 3),
(104, 103, 4);

INSERT INTO Department (dept_id, dept_name)
VALUES
(100, 'Reception'),
(101, 'Room-service'),
(102, 'Management'),
(103, 'Kitchen');

INSERT INTO Employee (employee_id, dept_id, employee_name, job_title, contact, hotel_id)
VALUES
(100, 100, 'Jane Doe', 'Receptionist', '555-555-1216', 100),
(101, 101, 'John Smith', 'Room-service', '555-555-1217', 100),
(102, 102, 'Jane Smith', 'Manager', '555-555-1218', 100),
(103, 103, 'John Doe', 'Chef', '666-666-3434',100);

-- Define Service Type
INSERT INTO Service_Type (service_type_id, service_description) 
VALUES (1, 'Room Service'), (2, 'Bar Service'), (3, 'Restaurant Service'), (4, 'Long Distance Call');

INSERT INTO Booking (booking_id, guest_id, room_id, checkin_date, checkout_date, requests)
VALUES
(100, 100, 101, '2022-01-01', '2022-01-02', 'Early Check-In'),
(101, 100, 101, '2022-01-03', '2022-01-04', 'Late Check-Out'),
(102, 101, 102, '2022-01-05', '2022-01-06', 'Extra Beds'),
(103, 101, 103, '2022-01-07', '2022-01-08', 'Special Requests');

INSERT INTO Service (booking_id, service_type_id, service_date, amount) 
VALUES (100, 1, '2022-12-23', 10.50), 
       (101, 2, '2022-12-24', 15.75), 
       (102, 3, '2022-12-25', 20.50), 
       (103, 4, '2022-12-26', 5.25);
       
       -- 
       
SELECT * FROM Employee;
SELECT * FROM Department;
SELECT * FROM Hotel;
SELECT * FROM Guest;
SELECT * FROM Booking;
SELECT * FROM Service;
SELECT * FROM Room;
SELECT * FROM roomtype;
SELECT * FROM service_type;

-- 10 simple queries for Assignment 4 

SELECT DISTINCT * FROM Hotel WHERE hotel_id = 123;--
SELECT * FROM Hotel WHERE location = "Toronto" ORDER BY hotel_id DESC;
SELECT * FROM RoomType WHERE roomtype_id = 1 GROUP BY roomtype_id;--
SELECT * FROM Room WHERE hotel_id = 100 ORDER BY room_id ASC;
SELECT * FROM Guest WHERE guest_name = "John Doe" ORDER BY guest_name DESC;
SELECT * FROM Booking WHERE booking_id = 100 ORDER BY checkin_date ASC;
SELECT * FROM Department WHERE dept_id = 100 ORDER BY dept_id ASC;
SELECT DISTINCT employee_id, employee_name, dept_id FROM Employee ORDER BY dept_id, employee_name;
SELECT service_type_id, service_description FROM Service_Type ORDER BY service_type_id;
SELECT DISTINCT guest_id, guest_name FROM Guest ORDER BY guest_name ASC;--
 
--  CREATE VIEW regen_employee AS
--  SELECT employee_id, employee_name, dept_id FROM Employee e;
--  
--  SELECT * FROM regen_employee;
  
 -- Advanced Queries
 
CREATE VIEW booking_details_by_guest AS
SELECT g.guest_name, g.guest_contact_info, b.booking_id, r.room_id, b.checkin_date, b.checkout_date, b.requests
FROM Guest g
JOIN Booking b ON g.guest_id = b.guest_id
JOIN Room r ON b.room_id = r.room_id;

SELECT * FROM booking_details_by_guest;

CREATE VIEW employee_list AS
SELECT e.employee_id, e.employee_name, e.job_title, d.dept_name, h.hotel_name, h.location
FROM Employee e
JOIN Department d ON e.dept_id = d.dept_ID
JOIN Hotel h ON e.hotel_id = h.hotel_id;

SELECT * FROM employee_list;

CREATE VIEW revenue_by_room_type AS
SELECT rt.roomtype_id, rt.room_price, SUM(rt.room_price) AS total_revenue
FROM RoomType rt
JOIN Room r ON rt.roomtype_id = r.roomtype_id
JOIN Booking b ON r.room_id = b.room_id
GROUP BY rt.roomtype_id, rt.room_price;

Select * FROM revenue_by_room_type;

CREATE VIEW service_summary_view AS
SELECT g.guest_name, st.service_description, SUM(s.amount) AS total_amount
FROM Booking b
JOIN Guest g ON b.guest_id = g.guest_id
JOIN Service s ON b.booking_id = s.booking_id
JOIN Service_Type st ON s.service_type_id = st.service_type_id
GROUP BY g.guest_name, st.service_description;


Select * FROM service_summary_view;



 
 
 
 
 




