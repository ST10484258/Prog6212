

/* =========================================================
   1. CREATE DATABASE
   ========================================================= */

IF DB_ID('RaceDayDB') IS NULL
BEGIN
    CREATE DATABASE RaceDayDB;
END;


USE RaceDayDB;



/* =========================================================
   2. DROP EXISTING TABLES
      This allows the script to be re-run during testing.
   ========================================================= */

IF OBJECT_ID('dbo.Results', 'U') IS NOT NULL
    DROP TABLE dbo.Results;


IF OBJECT_ID('dbo.Enrolments', 'U') IS NOT NULL
    DROP TABLE dbo.Enrolments;


IF OBJECT_ID('dbo.Categories', 'U') IS NOT NULL
    DROP TABLE dbo.Categories;


IF OBJECT_ID('dbo.Events', 'U') IS NOT NULL
    DROP TABLE dbo.Events;


IF OBJECT_ID('dbo.Users', 'U') IS NOT NULL
    DROP TABLE dbo.Users;


IF OBJECT_ID('dbo.Roles', 'U') IS NOT NULL
    DROP TABLE dbo.Roles;



/* =========================================================
   3. CREATE ROLES TABLE
   ========================================================= */

CREATE TABLE dbo.Roles
(
    RoleID INT IDENTITY(1,1) NOT NULL,
    RoleName VARCHAR(50) NOT NULL,

    CONSTRAINT PK_Roles
        PRIMARY KEY (RoleID),

    CONSTRAINT UQ_Roles_RoleName
        UNIQUE (RoleName)
);



/* =========================================================
   4. CREATE USERS TABLE
   ========================================================= */

CREATE TABLE dbo.Users
(
    UserID INT IDENTITY(1,1) NOT NULL,
    RoleID INT NOT NULL,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Email VARCHAR(150) NOT NULL,
    PasswordHash VARCHAR(255) NOT NULL,
    PhoneNumber VARCHAR(20) NULL,
    CreatedAt DATETIME2 NOT NULL
        CONSTRAINT DF_Users_CreatedAt
        DEFAULT SYSDATETIME(),

    CONSTRAINT PK_Users
        PRIMARY KEY (UserID),

    CONSTRAINT UQ_Users_Email
        UNIQUE (Email),

    CONSTRAINT FK_Users_Roles
        FOREIGN KEY (RoleID)
        REFERENCES dbo.Roles(RoleID)
);



/* =========================================================
   5. CREATE EVENTS TABLE
   ========================================================= */

CREATE TABLE dbo.Events
(
    EventID INT IDENTITY(1,1) NOT NULL,
    OrganiserID INT NOT NULL,
    EventName VARCHAR(150) NOT NULL,
    Description VARCHAR(500) NULL,
    EventDate DATE NOT NULL,
    Location VARCHAR(200) NOT NULL,
    Distance DECIMAL(6,2) NOT NULL,
    EventType VARCHAR(30) NOT NULL,
    Status VARCHAR(30) NOT NULL
        CONSTRAINT DF_Events_Status
        DEFAULT 'Upcoming',
    CreatedAt DATETIME2 NOT NULL
        CONSTRAINT DF_Events_CreatedAt
        DEFAULT SYSDATETIME(),

    CONSTRAINT PK_Events
        PRIMARY KEY (EventID),

    CONSTRAINT FK_Events_Organiser
        FOREIGN KEY (OrganiserID)
        REFERENCES dbo.Users(UserID),

    CONSTRAINT CK_Events_Distance
        CHECK (Distance > 0),

    CONSTRAINT CK_Events_EventType
        CHECK (EventType IN ('Running', 'Walking', 'Cycling')),

    CONSTRAINT CK_Events_Status
        CHECK (Status IN ('Upcoming', 'Completed', 'Cancelled'))
);



/* =========================================================
   6. CREATE CATEGORIES TABLE
   ========================================================= */

CREATE TABLE dbo.Categories
(
    CategoryID INT IDENTITY(1,1) NOT NULL,
    EventID INT NOT NULL,
    CategoryName VARCHAR(100) NOT NULL,
    Distance DECIMAL(6,2) NOT NULL,
    EntryFee DECIMAL(10,2) NOT NULL,
    MaximumParticipants INT NOT NULL,

    CONSTRAINT PK_Categories
        PRIMARY KEY (CategoryID),

    CONSTRAINT FK_Categories_Events
        FOREIGN KEY (EventID)
        REFERENCES dbo.Events(EventID),

    CONSTRAINT UQ_Categories_Event_Category
        UNIQUE (EventID, CategoryName),

    CONSTRAINT CK_Categories_Distance
        CHECK (Distance > 0),

    CONSTRAINT CK_Categories_EntryFee
        CHECK (EntryFee >= 0),

    CONSTRAINT CK_Categories_MaxParticipants
        CHECK (MaximumParticipants > 0)
);



/* =========================================================
   7. CREATE ENROLMENTS TABLE
   ========================================================= */

CREATE TABLE dbo.Enrolments
(
    EnrolmentID INT IDENTITY(1,1) NOT NULL,
    ParticipantID INT NOT NULL,
    CategoryID INT NOT NULL,
    EnrolmentDate DATETIME2 NOT NULL
        CONSTRAINT DF_Enrolments_EnrolmentDate
        DEFAULT SYSDATETIME(),
    Status VARCHAR(30) NOT NULL
        CONSTRAINT DF_Enrolments_Status
        DEFAULT 'Confirmed',

    CONSTRAINT PK_Enrolments
        PRIMARY KEY (EnrolmentID),

    CONSTRAINT FK_Enrolments_Participant
        FOREIGN KEY (ParticipantID)
        REFERENCES dbo.Users(UserID),

    CONSTRAINT FK_Enrolments_Category
        FOREIGN KEY (CategoryID)
        REFERENCES dbo.Categories(CategoryID),

    CONSTRAINT UQ_Enrolments_Participant_Category
        UNIQUE (ParticipantID, CategoryID),

    CONSTRAINT CK_Enrolments_Status
        CHECK (Status IN ('Pending', 'Confirmed', 'Cancelled'))
);



/* =========================================================
   8. CREATE RESULTS TABLE
   ========================================================= */

CREATE TABLE dbo.Results
(
    ResultID INT IDENTITY(1,1) NOT NULL,
    EnrolmentID INT NOT NULL,
    FinishTime TIME NOT NULL,
    FinishPosition INT NOT NULL,
    ResultStatus VARCHAR(30) NOT NULL
        CONSTRAINT DF_Results_ResultStatus
        DEFAULT 'Official',
    RecordedAt DATETIME2 NOT NULL
        CONSTRAINT DF_Results_RecordedAt
        DEFAULT SYSDATETIME(),

    CONSTRAINT PK_Results
        PRIMARY KEY (ResultID),

    CONSTRAINT FK_Results_Enrolments
        FOREIGN KEY (EnrolmentID)
        REFERENCES dbo.Enrolments(EnrolmentID),

    CONSTRAINT UQ_Results_Enrolment
        UNIQUE (EnrolmentID),

    CONSTRAINT CK_Results_FinishPosition
        CHECK (FinishPosition > 0),

    CONSTRAINT CK_Results_Status
        CHECK (ResultStatus IN ('Official', 'Pending', 'Disqualified'))
);



/* =========================================================
   9. INSERT ROLES
   ========================================================= */

INSERT INTO dbo.Roles
(
    RoleName
)
VALUES
    ('Organiser'),
    ('Participant');



/* =========================================================
   10. INSERT USERS
       2 Organisers
       2 Participants
   ========================================================= */

INSERT INTO dbo.Users
(
    RoleID,
    FirstName,
    LastName,
    Email,
    PasswordHash,
    PhoneNumber
)
VALUES
(
    1,
    'Thabo',
    'Mokoena',
    'thabo.mokoena@raceday.co.za',
    'HASHED_PASSWORD_ORGANISER_001',
    '0712345678'
),
(
    1,
    'Lerato',
    'Molefe',
    'lerato.molefe@raceday.co.za',
    'HASHED_PASSWORD_ORGANISER_002',
    '0723456789'
),
(
    2,
    'Karabo',
    'Molepo',
    'karabo.molepo@example.com',
    'HASHED_PASSWORD_PARTICIPANT_001',
    '0734567890'
),
(
    2,
    'Naledi',
    'Dlamini',
    'naledi.dlamini@example.com',
    'HASHED_PASSWORD_PARTICIPANT_002',
    '0745678901'
);



/* =========================================================
   11. INSERT EVENTS
       3 EVENTS
   ========================================================= */

INSERT INTO dbo.Events
(
    OrganiserID,
    EventName,
    Description,
    EventDate,
    Location,
    Distance,
    EventType,
    Status
)
VALUES
(
    1,
    'Johannesburg City Run',
    'Annual road-running event through Johannesburg.',
    '2026-10-18',
    'Johannesburg, Gauteng',
    21.10,
    'Running',
    'Upcoming'
),
(
    1,
    'Pretoria Charity Walk',
    'Community walking event supporting local charities.',
    '2026-11-07',
    'Pretoria, Gauteng',
    10.00,
    'Walking',
    'Upcoming'
),
(
    2,
    'Soweto Cycling Challenge',
    'Cycling event suitable for recreational and experienced cyclists.',
    '2026-11-21',
    'Soweto, Gauteng',
    40.00,
    'Cycling',
    'Upcoming'
);



/* =========================================================
   12. INSERT CATEGORIES
       Categories for EVERY event
   ========================================================= */

INSERT INTO dbo.Categories
(
    EventID,
    CategoryName,
    Distance,
    EntryFee,
    MaximumParticipants
)
VALUES
/* Johannesburg City Run */
(
    1,
    '5 KM Fun Run',
    5.00,
    80.00,
    500
),
(
    1,
    '10 KM Road Race',
    10.00,
    120.00,
    750
),
(
    1,
    '21.1 KM Half Marathon',
    21.10,
    180.00,
    1000
),

/* Pretoria Charity Walk */
(
    2,
    '5 KM Charity Walk',
    5.00,
    50.00,
    400
),
(
    2,
    '10 KM Charity Walk',
    10.00,
    80.00,
    600
),

/* Soweto Cycling Challenge */
(
    3,
    '20 KM Recreational Ride',
    20.00,
    100.00,
    300
),
(
    3,
    '40 KM Cycling Challenge',
    40.00,
    160.00,
    500
);



/* =========================================================
   13. INSERT SAMPLE ENROLMENTS
   ========================================================= */

INSERT INTO dbo.Enrolments
(
    ParticipantID,
    CategoryID,
    EnrolmentDate,
    Status
)
VALUES
(
    3,
    1,
    '2026-09-01 09:30:00',
    'Confirmed'
),
(
    3,
    4,
    '2026-09-02 10:15:00',
    'Confirmed'
),
(
    4,
    2,
    '2026-09-02 11:00:00',
    'Confirmed'
),
(
    4,
    7,
    '2026-09-03 14:20:00',
    'Confirmed'
);



/* =========================================================
   14. INSERT SAMPLE RESULTS
   ========================================================= */

INSERT INTO dbo.Results
(
    EnrolmentID,
    FinishTime,
    FinishPosition,
    ResultStatus
)
VALUES
(
    1,
    '00:28:45',
    15,
    'Official'
),
(
    2,
    '00:42:18',
    27,
    'Official'
);



/* =========================================================
   15. VERIFY THE DATABASE
   ========================================================= */

SELECT *
FROM dbo.Roles;


SELECT *
FROM dbo.Users;


SELECT *
FROM dbo.Events;


SELECT *
FROM dbo.Categories;


SELECT *
FROM dbo.Enrolments;


SELECT *
FROM dbo.Results;



/* =========================================================
   16. VERIFY RELATIONSHIPS WITH A JOIN
   ========================================================= */

SELECT
    u.FirstName + ' ' + u.LastName AS Participant,
    e.EventName,
    c.CategoryName,
    en.Status AS EnrolmentStatus,
    r.FinishTime,
    r.FinishPosition,
    r.ResultStatus
FROM dbo.Enrolments en
INNER JOIN dbo.Users u
    ON en.ParticipantID = u.UserID
INNER JOIN dbo.Categories c
    ON en.CategoryID = c.CategoryID
INNER JOIN dbo.Events e
    ON c.EventID = e.EventID
LEFT JOIN dbo.Results r
    ON en.EnrolmentID = r.EnrolmentID;
