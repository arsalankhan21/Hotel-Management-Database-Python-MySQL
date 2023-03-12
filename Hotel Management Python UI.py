import mysql.connector

# Function to connect to MySQL database
def connect():
    connection = mysql.connector.connect(
        host="localhost",
        user="sqluser",
        password="password",
        database="hotelmanagement"
    )
    return connection

# Function to drop tables
def drop_all_tables():
    connection = connect()
    cursor = connection.cursor()
    cursor.execute("DROP TABLE IF EXISTS employee, department, hotel, guest, booking, service, room, roomtype, service_type")
    connection.commit()
    cursor.close()
    connection.close()
    print("All tables dropped successfully")

# Function to create tables
def create_tables():
    connection = connect()
    cursor = connection.cursor()
    cursor.execute("""
        CREATE TABLE IF NOT EXISTS Hotel (
            hotel_id INT PRIMARY KEY,
            hotel_name VARCHAR(50) NOT NULL,
            location VARCHAR(100) NOT NULL,
            contact_info VARCHAR(20) NOT NULL
        )
    """)
    cursor.execute("""
        CREATE TABLE IF NOT EXISTS RoomType (
            roomtype_id INT PRIMARY KEY,
            room_price DECIMAL(10,2)
        )
    """)
    cursor.execute("""
        CREATE TABLE IF NOT EXISTS Room (
            room_id INT PRIMARY KEY,
            hotel_id INT NOT NULL,
            roomtype_id INT,
            FOREIGN KEY (hotel_id) REFERENCES Hotel(hotel_id),
            FOREIGN KEY (roomtype_id) REFERENCES RoomType(roomtype_id)
        )
    """)
    cursor.execute("""
        CREATE TABLE IF NOT EXISTS Guest (
            guest_id INT PRIMARY KEY,
            guest_name VARCHAR(50) NOT NULL,
            guest_contact_info VARCHAR(50) NOT NULL
        )
    """)
    cursor.execute("""
        CREATE TABLE IF NOT EXISTS Booking (
            booking_id INT PRIMARY KEY,
            guest_id INT NOT NULL,
            room_id INT ,
            checkin_date DATE,
            checkout_date DATE,
            requests VARCHAR(100),
            FOREIGN KEY (guest_id) REFERENCES Guest(guest_id),
            FOREIGN KEY (room_id) REFERENCES Room(room_id)
        )
    """)
    cursor.execute("""
        CREATE TABLE IF NOT EXISTS Department (
            dept_ID INT PRIMARY KEY,
            dept_name VARCHAR(50)
        )
    """)
    cursor.execute("""
        CREATE TABLE IF NOT EXISTS Employee (
            employee_id INT PRIMARY KEY,
            dept_id INT,
            employee_name VARCHAR(50),
            job_title VARCHAR(50),
            contact VARCHAR(20),
            hotel_id INT,
            FOREIGN KEY (dept_id) REFERENCES Department(dept_id),
            FOREIGN KEY (hotel_id) REFERENCES Hotel(hotel_id)
        )
    """)
    cursor.execute("""
        CREATE TABLE IF NOT EXISTS Service_Type (
            service_type_id INT PRIMARY KEY,
            service_description VARCHAR(100)
        )
    """)
    cursor.execute("""
        CREATE TABLE IF NOT EXISTS Service (
            booking_id INT,
            service_type_id INT,
            service_date DATE,
            amount DECIMAL(10,2),
            FOREIGN KEY (booking_id) REFERENCES Booking(booking_id),
            FOREIGN KEY (service_type_id) REFERENCES Service_Type(service_type_id)
        )
    """)
    connection.commit()
    cursor.close()
    connection.close()
    print("Tables created successfully")

# Function to populate tables
def populate_tables():
    connection = connect()
    cursor = connection.cursor()
    
    cursor.execute("INSERT INTO Hotel VALUES (123, 'Embassy', 'Toronto', 4166786545)")
    
    cursor.execute("""
        INSERT INTO Hotel (hotel_id, hotel_name, location, contact_info)
        VALUES 
        (100, 'Chateau Lake Louise', 'Alberta', '555-555-1212'),
        (101, 'The Fairmont Banff Springs', 'Alberta', '555-555-1213'),
        (102, 'The Fairmont Chateau Whistler', 'British Columbia', '555-555-1214'),
        (103, 'The Fairmont Jasper Park Lodge', 'Alberta', '555-555-1215')
    """)
    
    cursor.execute("""
        INSERT INTO Guest (guest_id, guest_name, guest_contact_info)
        VALUES
        (100, 'John Doe', 'johndoe@email.com'),
        (101, 'Jane Doe', 'janedoe@email.com'),
        (102, 'John Smith', 'johnsmith@email.com'),
        (103, 'Jane Smith', 'janesmith@email.com')
    """)
    
    cursor.execute("""
        INSERT INTO RoomType (roomtype_id, room_price)
        VALUES 
        (1, 100),
        (2, 200),
        (3, 300),
        (4, 400)
    """)
    
    cursor.execute("""
        INSERT INTO Room (room_id, hotel_id, roomtype_id)
        VALUES
        (101, 100, 1),
        (102, 101, 2),
        (103, 102, 3),
        (104, 103, 4)
    """)
    
    cursor.execute("""
        INSERT INTO Department (dept_id, dept_name)
        VALUES
        (100, 'Reception'),
        (101, 'Room-service'),
        (102, 'Management'),
        (103, 'Kitchen')
    """)
    
    cursor.execute("""
        INSERT INTO Employee (employee_id, dept_id, employee_name, job_title, contact, hotel_id)
        VALUES
        (100, 100, 'Jane Doe', 'Receptionist', '555-555-1216', 100),
        (101, 101, 'John Smith', 'Room-service', '555-555-1217', 100),
        (102, 102, 'Jane Smith', 'Manager', '555-555-1218', 100),
        (103, 103, 'John Doe', 'Chef', '666-666-3434', 100)
    """)
    
    cursor.execute("""
        -- Define Service Type
        INSERT INTO Service_Type (service_type_id, service_description) 
        VALUES (1, 'Room Service'), (2, 'Bar Service'), (3, 'Restaurant Service'), (4, 'Long Distance Call')
    """)
    
        # Insert Booking data
    cursor.execute("INSERT INTO Booking (booking_id, guest_id, room_id, checkin_date, checkout_date, requests) VALUES (100, 100, 101, '2022-01-01', '2022-01-02', 'Early Check-In'), (101, 100, 101, '2022-01-03', '2022-01-04', 'Late Check-Out'), (102, 101, 102, '2022-01-05', '2022-01-06', 'Extra Beds'), (103, 101, 103, '2022-01-07', '2022-01-08', 'Special Requests')")
    
    # Insert Service data
    cursor.execute("INSERT INTO Service (booking_id, service_type_id, service_date, amount) VALUES (100, 1, '2022-12-23', 10.50), (101, 2, '2022-12-24', 15.75), (102, 3, '2022-12-25', 20.50), (103, 4, '2022-12-26', 5.25)")
    
    connection.commit()
    cursor.close()
    connection.close()
    print("Tables populated successfully")

def query_tables():
    connection = connect()
    cursor = connection.cursor()
    
    # Query 1: Using EXISTS to check for guest with bookings
    cursor.execute("SELECT guest_name FROM Guest g WHERE EXISTS (SELECT * FROM Booking b WHERE b.guest_id = g.guest_id)")
    print("Query 1: Guests with Bookings")
    for row in cursor.fetchall():
        print(row)
    print("")

    # Query 2: Using UNION to combine guest names and department names
    cursor.execute("SELECT guest_name FROM Guest UNION SELECT room_id FROM room")
    print("Query 2: Guest and Rooms")
    for row in cursor.fetchall():
        print(row)
    print("")

    # Query 3: Using ORDER_BY to find hotels in Toronto
    cursor.execute("SELECT * FROM Hotel WHERE location = 'Toronto' ORDER BY hotel_id DESC")
    print("Query 3: Available Locations in Toronto")
    for row in cursor.fetchall():
        print(row)
    print("")

    # Query 4: Using COUNT to find the number of bookings for each guest
    cursor.execute("SELECT guest_name, COUNT(*) FROM Booking b JOIN Guest g ON b.guest_id = g.guest_id GROUP BY guest_name")
    print("Query 4: Number of bookings for each guest")
    for row in cursor.fetchall():
        print(row)
    print("")

    # Query 5: Using GROUP BY and HAVING to find guests with multiple bookings
    cursor.execute("SELECT guest_name, COUNT(*) FROM Booking b JOIN Guest g ON b.guest_id = g.guest_id GROUP BY guest_name HAVING COUNT(*) > 1")
    print("Query 5:  Guests with multiple bookings")
    for row in cursor.fetchall():
        print(row)
    print("")

    # Query 6: Using GROUP BY and HAVING to find rooms with multiple bookings
    cursor.execute("SELECT room_id, COUNT(*) FROM Booking GROUP BY room_id HAVING COUNT(*) > 1")
    print("Query 6: Rooms with Multiple Bookings")
    for row in cursor.fetchall():
        print(row)
    print("")

    # Query 7: Using GROUP BY and HAVING to find hotels with a high occupancy rate
    cursor.execute("SELECT r.hotel_id, h.hotel_name, COUNT(*)*100.0 / (SELECT COUNT(*) FROM Room WHERE hotel_id = r.hotel_id) as occupancy_rate FROM Booking b JOIN Room r ON b.room_id = r.room_id JOIN Hotel h ON r.hotel_id = h.hotel_id GROUP BY r.hotel_id, h.hotel_name HAVING occupancy_rate > 80")
    print("Query 7: Hotels with High Occupancy Rates")
    for row in cursor.fetchall():
        print(row)
    print("")
    
    # Query 8: Using UNION to combine guest names and service descriptions
    cursor.execute("SELECT employee_name FROM Employee UNION SELECT service_type_id FROM Service")
    print("Query 8: Employee and Service Descriptions")
    for row in cursor.fetchall():
        print(row)
    print("")
    
# Query 9: Using MINUS to find rooms that have not been booked
    cursor.execute("SELECT room_id FROM room WHERE room_id NOT IN (SELECT room_id FROM booking)")
    print("Query 9: Available Rooms")
    for row in cursor.fetchall():
        print(row)
    print("")
    
    cursor.close()
    connection.close()



# Main function for menu
def main():
    while True:
        print("=================================================================")
        print("| Main Menu - Hotel Management Database:                      |")
        print("| Select desired option:             |")
        print("-----------------------------------------------------------------")
        print("1) Drop Tables")
        print("2) Create Tables")
        print("3) Populate Tables")
        print("4) Query Tables")
        print("E) End/Exit")
        choice = input("Choose: ")
        if choice == "1":
            drop_all_tables()
        elif choice == "2":
            create_tables()
        elif choice == "3":
            populate_tables()
        elif choice == "4":
            query_tables()
        elif choice == "E":
            break

main()

