/* Creating Table */
CREATE SCHEMA IF NOT EXISTS film_library;

CREATE TABLE IF NOT EXISTS Films (
    F_ID SERIAL PRIMARY KEY,
    F_Name VARCHAR(100),
    F_Producer VARCHAR(40),
    F_Director VARCHAR(40),
    F_Prizes INT,
    F_Year INT,
    F_Rating INT,
    F_Count_Rating INT,
    F_Type VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS Actors (
    A_ID SERIAL PRIMARY KEY,
    A_Name VARCHAR(100),
	A_LastName VARCHAR(100),
    A_Gender VARCHAR(6)
);

CREATE TABLE IF NOT EXISTS FilmCast (
    F_ID INT,
    A_ID INT,
    FOREIGN KEY (F_ID) REFERENCES Films(F_ID),
    FOREIGN KEY (A_ID) REFERENCES Actors(A_ID)
);

CREATE TABLE IF NOT EXISTS Users (
    U_ID SERIAL PRIMARY KEY,
    U_Username VARCHAR(100),
    U_Password VARCHAR(100)
);
/* tables created*/