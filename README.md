# RaceDay – Event Management System

## PROG6212 Programming 3B – Part 1

RaceDay is a full-stack event management system designed for South African road running, walking and cycling events. The system allows organisers to manage events, categories, participant enrolments and results, while participants can register for events and track their personal enrolments and results.

---

## 1. Project Overview

The RaceDay system is designed to support two main user roles:

### Organiser
Organisers can:

- Create events.
- Edit events.
- Delete events.
- Manage event categories.
- View event enrolments.
- Capture participant results.
- Update participant results.

### Participant
Participants can:

- Create an account.
- Log in to the system.
- Browse available events.
- View event categories.
- Enrol in an event category.
- View their own enrolments.
- View and track their personal results.

Role-based access control will be enforced at API level in the later development stages of the project.

---

# 2. Technologies Used

The following technologies and tools are used in the RaceDay project:

- C#
- .NET
- ASP.NET Core Web API
- SQL Server
- SQL Server Management Studio 22 (SSMS)
- Git
- GitHub
- GitHub Actions
- Visual Studio
- HTML/CSS/JavaScript where applicable in later stages

---

# 3. Part 1 – System Planning and Database

Part 1 focuses on the planning and database design of the RaceDay system.

The main deliverables are:

- Entity Relationship Diagram (ERD)
- API Endpoint Plan
- SQL Server Database Script
- Project documentation

---

## 4. Database Design

The RaceDay database contains six main entities:

1. Roles
2. Users
3. Events
4. Categories
5. Enrolments
6. Results

### Entity Relationships

The main relationships are:

- One Role can have many Users.
- One Organiser can manage many Events.
- One Event can contain many Categories.
- One Participant can have many Enrolments.
- One Category can have many Enrolments.
- One Enrolment can have zero or one Result.

The Enrolments entity resolves the many-to-many relationship between Participants and Event Categories.

---

## 5. Database Tables

### Roles

Stores the different roles available in the RaceDay system.

Example roles:

- Organiser
- Participant

### Users

Stores user account and profile information.

Important attributes include:

- UserID
- RoleID
- FirstName
- LastName
- Email
- PasswordHash
- PhoneNumber
- CreatedAt

### Events

Stores information about RaceDay events.

Important attributes include:

- EventID
- OrganiserID
- EventName
- Description
- EventDate
- Location
- Distance
- EventType
- Status
- CreatedAt

### Categories

Stores the different participation categories available for each event.

Important attributes include:

- CategoryID
- EventID
- CategoryName
- Distance
- EntryFee
- MaximumParticipants

### Enrolments

Stores participant enrolments in event categories.

Important attributes include:

- EnrolmentID
- ParticipantID
- CategoryID
- EnrolmentDate
- Status

### Results

Stores participant results after completing an event.

Important attributes include:

- ResultID
- EnrolmentID
- FinishTime
- FinishPosition
- ResultStatus
- RecordedAt

---

# 6. Database Constraints

The database uses several SQL Server constraints to maintain data integrity.

These include:

- Primary keys
- Foreign keys
- NOT NULL constraints
- UNIQUE constraints
- DEFAULT constraints
- CHECK constraints

For example, email addresses are unique so that two users cannot register using the same email address.

The database also uses CHECK constraints to prevent invalid event types, statuses, entry fees and participant limits from being stored.

---

# 7. Sample Data

The database contains sample data for testing.

The seed data includes:

- 2 Organisers
- 2 Participants
- 3 Events
- Categories for every event
- Sample participant enrolments
- Sample participant results

This sample data allows the database relationships and queries to be tested before the API is developed.

---

# 8. API Endpoint Planning

The API endpoint plan covers the main functionality required by the RaceDay system.

The planned API areas include:

### Authentication

- Register
- Login

### User Profile

- View own profile
- Update own profile

### Events

- View events
- View a specific event
- Create an event
- Update an event
- Delete an event

### Categories

- View event categories
- View a specific category
- Create a category
- Update a category
- Delete a category

### Enrolments

- Create an enrolment
- View own enrolments
- View event enrolments
- View a specific enrolment

### Results

- Capture results
- Update results
- View personal results
- View event results
- View a specific result

---

# 9. Project Structure

The repository is organised as follows:

```text
RaceDay/
│
├── docs/
│   ├── RaceDay_ERD.png
│   ├── RaceDay_API_Endpoint_Plan.md
│   └── RaceDay_Database.sql
│
├── .github/
│   └── workflows/
│       └── build.yml
│
├── README.md
│
└── [Application files]# Prog6212
