CREATE DATABASE MovieRentals;
USE MovieRentals;

CREATE TABLE User (
    Id VARCHAR(36),
    Username VARCHAR(25),
    Password VARCHAR(100),
    Email VARCHAR(100),
    Rating INT
);

CREATE TABLE Movie (
    Id VARCHAR(36),
    Title VARCHAR(100),
    Genre VARCHAR(100),
    Director VARCHAR(100),
    LeadActor VARCHAR(100)
);

CREATE TABLE Rental (
    Id VARCHAR(36),
    UserId VARCHAR(36),
    MovieId VARCHAR(36),
    RentalDate DATE,
    DueDate DATE,
    LateFees DECIMAL(5,2)
);

CREATE TABLE Rating (
    Id VARCHAR(36),
    UserId VARCHAR(36),
    MovieId VARCHAR(36),
    RatingValue INT
);

CREATE TABLE Clerk (
    Id VARCHAR(36),
    Username VARCHAR(25),
    Password VARCHAR(100)
);

CREATE TABLE Transaction (
    Id VARCHAR(36),
    ClerkId VARCHAR(36),
    TransactionDate DATE,
    Description TEXT
);

INSERT INTO User (Id, Username, Password, Email, Rating) VALUES 
('1', 'Alice', 'password123', 'alice@example.com', 5),
('2', 'Bob', 'password456', 'bob@example.com', 4);

INSERT INTO Movie (Id, Title, Genre, Director, LeadActor) VALUES 
('1', 'Inception', 'Sci-Fi', 'Christopher Nolan', 'Leonardo DiCaprio'),
('2', 'The Matrix', 'Sci-Fi', 'Wachowski Sisters', 'Keanu Reeves');

INSERT INTO Rental (Id, UserId, MovieId, RentalDate, DueDate, LateFees) VALUES 
('1', '1', '1', '2023-01-01', '2023-01-07', 0.00),
('2', '2', '2', '2023-01-03', '2023-01-10', 2.50);

INSERT INTO Rating (Id, UserId, MovieId, RatingValue) VALUES 
('1', '1', '1', 5),
('2', '2', '2', 4);

INSERT INTO Clerk (Id, Username, Password) VALUES 
('1', 'Clerk1', 'clerkpass123'),
('2', 'Clerk2', 'clerkpass456');

INSERT INTO Transaction (Id, ClerkId, TransactionDate, Description) VALUES 
('1', '1', '2023-01-02', 'Rental transaction for Inception'),
('2', '2', '2023-01-04', 'Rental transaction for The Matrix');

SELECT * FROM User;
SELECT * FROM Movie WHERE Genre = 'Sci-Fi';

UPDATE Rental SET LateFees = 5.00 WHERE Id = '2';
DELETE FROM User WHERE Username = 'Bob';

SELECT User.Username, Movie.Title 
FROM User
JOIN Rental ON User.Id = Rental.UserId
JOIN Movie ON Rental.MovieId = Movie.Id;

SELECT Title, Genre 
FROM Movie 
WHERE Id IN (SELECT MovieId FROM Rental WHERE LateFees > 0);

USE MovieRentals;
DROP TABLE Transaction;
RENAME TABLE User to Users;
RENAME TABLE Movie to Movies;
RENAME TABLE Rental to Rentals;
RENAME TABLE Rating to Ratings;
RENAME TABLE Clerk to Clerks;

ALTER TABLE Users
MODIFY Id INT;
ALTER TABLE Users
ADD PRIMARY KEY (Id);
ALTER TABLE Users
MODIFY Id INT AUTO_INCREMENT;
ALTER TABLE Users
DROP Rating;
ALTER TABLE Users
MODIFY Password VARCHAR(100) NOT NULL;
ALTER TABLE Users
ADD CONSTRAINT u_username UNIQUE (Username);
ALTER TABLE Users
ADD CONSTRAINT u_email UNIQUE (Email);

ALTER TABLE Movies
MODIFY Id INT;
ALTER TABLE Movies
ADD PRIMARY KEY (Id);
ALTER TABLE Movies
MODIFY Id INT AUTO_INCREMENT;
ALTER TABLE Movies
RENAME COLUMN LeadActor to Year;
ALTER TABLE Movies
MODIFY Year INT;
ALTER TABLE Movies
ADD CONSTRAINT chk_year CHECK (Year > 1888);
ALTER TABLE Movies
MODIFY Title VARCHAR(100);
ALTER TABLE Movies
MODIFY COLUMN Title VARCHAR(100) NOT NULL;

ALTER TABLE Clerks
MODIFY Id INT;
ALTER TABLE Clerks
ADD PRIMARY KEY (Id);
ALTER TABLE Clerks
MODIFY COLUMN Id INT AUTO_INCREMENT;
ALTER TABLE Clerks
MODIFY Username VARCHAR(25);
ALTER TABLE Clerks
MODIFY Username VARCHAR(25) NOT NULL;
ALTER TABLE Clerks
MODIFY Password VARCHAR(25) NOT NULL;
ALTER TABLE Clerks
ADD CONSTRAINT u_username UNIQUE (Username);

ALTER TABLE Ratings
MODIFY Id INT;
ALTER TABLE Ratings
ADD PRIMARY KEY (Id);
ALTER TABLE Ratings
MODIFY Id INT AUTO_INCREMENT;
ALTER TABLE Ratings
ADD CONSTRAINT chk_rating CHECK (RatingValue BETWEEN 1 AND 10);
ALTER TABLE Ratings
MODIFY UserId INT;
ALTER TABLE Ratings
MODIFY MovieId INT;
ALTER TABLE Ratings
ADD CONSTRAINT fk_users1 FOREIGN KEY (UserId) REFERENCES Users(Id);
ALTER TABLE Ratings
ADD CONSTRAINT fk_movies1 FOREIGN KEY (MovieId) REFERENCES Movies(Id);

ALTER TABLE Rentals
MODIFY Id INT;
ALTER TABLE Rentals
ADD PRIMARY KEY (Id);
ALTER TABLE Rentals
MODIFY Id INT AUTO_INCREMENT;
ALTER TABLE Rentals
DROP LateFees;
ALTER TABLE Rentals
MODIFY RentalDate DATE DEFAULT NOW();
ALTER TABLE Rentals
MODIFY DueDate DATE DEFAULT (NOW() + INTERVAL 14 DAY);
ALTER TABLE Rentals
ADD ClerkId INT;
ALTER TABLE Rentals
MODIFY UserId INT;
ALTER TABLE Rentals
MODIFY MovieId INT;
ALTER TABLE Rentals
ADD CONSTRAINT fk_clerks1 FOREIGN KEY (ClerkId) REFERENCES Clerks(Id);
ALTER TABLE Rentals
ADD CONSTRAINT fk_users2 FOREIGN KEY (UserId) REFERENCES Users(Id);
ALTER TABLE Rentals
ADD CONSTRAINT fk_movies2 FOREIGN KEY (MovieId) REFERENCES Movies(Id);

SET GLOBAL local_infile=1;

LOAD DATA LOCAL INFILE './clerks.csv'
INTO TABLE Clerks
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT * FROM Clerks LIMIT 5;

LOAD DATA LOCAL INFILE './movies.csv'
INTO TABLE Movies
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT * FROM Movies LIMIT 5;

LOAD DATA LOCAL INFILE './users.csv'
INTO TABLE Users
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT * FROM Users LIMIT 5;

LOAD DATA LOCAL INFILE './rentals.csv'
INTO TABLE Rentals
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT * FROM Rentals LIMIT 5;

LOAD DATA LOCAL INFILE './ratings.csv'
INTO TABLE Ratings
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT * FROM Ratings LIMIT 5;

SET GLOBAL local_infile=0;

SELECT Title, Genre
FROM Movies
WHERE Id IN (SELECT MovieId FROM Rentals WHERE ClerkId = -1);

SELECT Genre, COUNT(*) as NumberOfMovies 
FROM Movies 
GROUP BY Genre 
HAVING COUNT(*) > 1;

ADD CONSTRAINT chk_year CHECK (Year > 1888);
ADD CONSTRAINT chk_rating CHECK (RatingValue BETWEEN 1 AND 10);
ADD CONSTRAINT fk_users1 FOREIGN KEY (UserId) REFERENCES Users(Id);

SELECT * FROM Movie WHERE Genre = 'Sci-Fi';

SELECT User.Username, Movie.Title 
FROM User
JOIN Rental ON User.Id = Rental.UserId
JOIN Movie ON Rental.MovieId = Movie.Id;
