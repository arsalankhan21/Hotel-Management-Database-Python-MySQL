use hotelmanagement;


CREATE TABLE Hotel ( -- Modified to remove partial dependencies
  hotel_id INT PRIMARY KEY,
  hotel_name VARCHAR(50) NOT NULL,
  location VARCHAR(100) NOT NULL
);

CREATE TABLE HotelContact ( -- Modified to remove partial dependencies
  hotel_id INT PRIMARY KEY,
  hotel_phone_number VARCHAR(20) NOT NULL,
  FOREIGN KEY (hotel_id) REFERENCES Hotel(hotel_id)
);

CREATE TABLE RoomType ( -- Modified to remove partial dependencies
  roomtype_id INT PRIMARY KEY,
  room_type VARCHAR(50) NOT NULL
);

CREATE TABLE RoomPrice ( -- Modified to remove partial dependencies
  roomtype_id INT PRIMARY KEY,
  hotel_id INT PRIMARY KEY,
  room_price DECIMAL(10,2) NOT NULL,
  FOREIGN KEY (roomtype_id) REFERENCES RoomType(roomtype_id),
  FOREIGN KEY (hotel_id) REFERENCES Hotel(hotel_id)
);

CREATE TABLE Room ( -- Modified hotel_id and roomtype_id by making both of them non-null.
  room_id INT PRIMARY KEY,
  hotel_id INT NOT NULL,
  roomtype_ID INT NOT NULL,
  FOREIGN KEY (hotel_id) REFERENCES Hotel(hotel_id),
  FOREIGN KEY (roomtype_id) REFERENCES RoomType(roomtype_id)
);

CREATE TABLE Guest ( -- split guest_contact_info into two attributes: guest_email and guest_phone_number to remove transitive dependency.
  guest_id INT PRIMARY KEY,
  guest_name VARCHAR(20) NOT NULL,
  guest_email VARCHAR(50) NOT NULL,
  guest_phone_number VARCHAR(20) NOT NULL
);

CREATE TABLE Booking ( -- Already in 3NF as each non-key attribute is dependent on the primary key and there are no transitive dependencies.
  booking_id INT PRIMARY KEY,
  guest_id INT NOT NULL,
  room_id INT NOT NULL,
  checkin_date DATE,
  checkout_date DATE,
  requests VARCHAR(100),
  FOREIGN KEY (guest_id) REFERENCES Guest(guest_id),
  FOREIGN KEY (room_id) REFERENCES Room(room_id)
);

CREATE TABLE Department ( -- Already in 3NF as each non-key attribute is dependent on the primary key and there are no transitive dependencies.
  dept_ID INT PRIMARY KEY,
  dept_name VARCHAR(50) NOT NULL
);

CREATE TABLE Employee ( -- Made hotel_id non-null to remove transitive dependency between dept_id and hotel_id.
  employee_id INT PRIMARY KEY,
  dept_id INT NOT NULL,
  employee_name VARCHAR(50),
  job_title VARCHAR(50),
  contact VARCHAR(20),
  hotel_id INT NOT NULL,
  FOREIGN KEY (dept_id) REFERENCES Department(dept_id),
  FOREIGN KEY (hotel_id) REFERENCES Hotel(hotel_id)
);

CREATE TABLE Service_Type ( -- -- Already in 3NF as each non-key attribute is dependent on the primary key and there are no transitive dependencies.
  service_type_id INT PRIMARY KEY,
  service_description VARCHAR(100) NOT NULL
);

