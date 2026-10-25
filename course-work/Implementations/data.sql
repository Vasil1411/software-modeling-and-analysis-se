CREATE DATABASE FotMobDB;
GO
USE FotMobDB;
GO



-- 1. League Table
CREATE TABLE League (
    league_id INT IDENTITY(1,1) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    country VARCHAR(50) NOT NULL,
    logo_url VARCHAR(255)
);

-- 2. Team Table (league_id removed, handled by League_Team)
CREATE TABLE Team (
    team_id INT IDENTITY(1,1) PRIMARY KEY,
    stadium VARCHAR(100),
    name VARCHAR(100) NOT NULL,
    logo_url VARCHAR(255),
    founded_year INT
);

-- 3. League_Team Table (Many-to-Many relationship)
CREATE TABLE League_Team (
    league_id INT FOREIGN KEY REFERENCES League(league_id),
    team_id INT FOREIGN KEY REFERENCES Team(team_id),
    PRIMARY KEY (league_id, team_id)
);

-- 4. Player Table 
CREATE TABLE Player (
    player_id INT IDENTITY(1,1) PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    nationality VARCHAR(50),
    height DECIMAL(5,2),
    transfer_value DECIMAL(12,2),
    age INT,
    weight DECIMAL(5,2),
    image_url VARCHAR(255),
    positions VARCHAR(100), 
    team_id INT FOREIGN KEY REFERENCES Team(team_id)
);

-- 5. Coach Table
CREATE TABLE Coach (
    coach_id INT IDENTITY(1,1) PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    nationality VARCHAR(50),
    team_id INT FOREIGN KEY REFERENCES Team(team_id)
);

-- 6. Referee Table
CREATE TABLE Referee (
    referee_id INT IDENTITY(1,1) PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL
);

-- 7. Match Table
CREATE TABLE Match (
    match_id INT IDENTITY(1,1) PRIMARY KEY,
    home_team_score INT DEFAULT 0,
    away_team_score INT DEFAULT 0,
    league_id INT FOREIGN KEY REFERENCES League(league_id),
    referee_id INT FOREIGN KEY REFERENCES Referee(referee_id),
    match_date DATETIME,
    status VARCHAR(20),
    home_team_id INT FOREIGN KEY REFERENCES Team(team_id),
    away_team_id INT FOREIGN KEY REFERENCES Team(team_id)
);

-- 8. Match Stat Table
CREATE TABLE Match_Stat (
    match_stats_id INT IDENTITY(1,1) PRIMARY KEY,
    possession_home INT,
    possession_away INT,
    passes INT,
    corners INT,
    xg_home DECIMAL(4,2),
    xg_away DECIMAL(4,2),
    offsides INT,
    saves INT,
    shots INT,
    fouls INT,
    match_id INT FOREIGN KEY REFERENCES Match(match_id)
);

-- 9. Match Event Table
CREATE TABLE Match_Event (
    match_event_id INT IDENTITY(1,1) PRIMARY KEY,
    minute INT NOT NULL,
    event_type VARCHAR(50) NOT NULL, -- e.g. 'goal', 'yellow_card', 'red_card'
    match_id INT FOREIGN KEY REFERENCES Match(match_id),
    player_id INT FOREIGN KEY REFERENCES Player(player_id)
);

-- 10. News Table
CREATE TABLE News (
    news_id INT IDENTITY(1,1) PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    description TEXT,
    published_date DATETIME,
    image_url VARCHAR(255),
    team_id INT FOREIGN KEY REFERENCES Team(team_id)
);

-- 11. Trophy Table
CREATE TABLE Trophy (
    trophy_id INT IDENTITY(1,1) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    season VARCHAR(20),
    team_id INT FOREIGN KEY REFERENCES Team(team_id),
    player_id INT FOREIGN KEY REFERENCES Player(player_id)
);

-- 12. User Table 
CREATE TABLE [User] (
    user_id INT IDENTITY(1,1) PRIMARY KEY,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL
);

-- 13. User_Follow_Team Table (Many-to-Many)
CREATE TABLE User_Follow_Team (
    user_id INT FOREIGN KEY REFERENCES [User](user_id),
    team_id INT FOREIGN KEY REFERENCES Team(team_id),
    PRIMARY KEY (user_id, team_id)
);

-- 14. User_Follow_Player Table (Many-to-Many)
CREATE TABLE User_Follow_Player (
    user_id INT FOREIGN KEY REFERENCES [User](user_id),
    player_id INT FOREIGN KEY REFERENCES Player(player_id),
    PRIMARY KEY (user_id, player_id)
);
GO


-- =============================================
-- 1. Insert Leagues
-- =============================================

INSERT INTO League (name, country, logo_url) VALUES 
('Premier League', 'England', NULL);

-- =============================================
-- 2. Insert Top 6 Teams (No logos or stadium image links)
-- =============================================
INSERT INTO Team (stadium, name, logo_url, founded_year) VALUES 
('Etihad Stadium', 'Manchester City', NULL, 1894),
('Old Trafford', 'Manchester United', NULL, 1878),
('Tottenham Hotspur Stadium', 'Tottenham Hotspur', NULL, 1882),
('Anfield', 'Liverpool', NULL, 1892),
('Emirates Stadium', 'Arsenal', NULL, 1886),
('Stamford Bridge', 'Chelsea', NULL, 1905);

-- Link all top 6 teams to the Premier League (league_id = 1)
INSERT INTO League_Team (league_id, team_id) VALUES 
(1, 1), (1, 2), (1, 3), (1, 4), (1, 5), (1, 6);


-- =============================================
-- 3. Insert Managers (Coaches)
-- =============================================
INSERT INTO Coach (first_name, last_name, nationality, team_id) VALUES 
('Enzo', 'Maresca', 'Italian', 1),
('Michael', 'Carrick', 'English', 2),
('Roberto', 'De Zerbi', 'Italian', 3),
('Andoni', 'Iraola', 'Spanish', 4),
('Mikel', 'Arteta', 'Spanish', 5),
('Xabi', 'Alonso', 'Spanish', 6);

-- =============================================
-- 4. Insert Star Players (Ages updated for October 2026, no image URLs)
-- =============================================
INSERT INTO Player (first_name, last_name, nationality, height, transfer_value, age, weight, image_url, positions, team_id) VALUES 
-- Manchester City (team_id = 1)
('Erling', 'Haaland', 'Norwegian', 1.95, 190000000.00, 26, 88.0, NULL, 'ST', 1),
('Kevin', 'De Bruyne', 'Belgian', 1.81, 45000000.00, 35, 70.0, NULL, 'AM, CM', 1),
('Rodri', 'Cascante', 'Spanish', 1.90, 120000000.00, 30, 82.0, NULL, 'DM', 1),

-- Manchester United (team_id = 2)
('Bruno', 'Fernandes', 'Portuguese', 1.79, 65000000.00, 32, 69.0, NULL, 'AM, CM', 2),
('Marcus', 'Rashford', 'English', 1.85, 55000000.00, 28, 70.0, NULL, 'LW, ST', 2),
('Kobbie', 'Mainoo', 'English', 1.75, 60000000.00, 21, 68.0, NULL, 'CM, DM', 2),

-- Tottenham Hotspur (team_id = 3)
('Heung-min', 'Son', 'South Korean', 1.83, 40000000.00, 34, 78.0, NULL, 'LW, ST, RW', 3),
('James', 'Maddison', 'English', 1.75, 60000000.00, 29, 73.0, NULL, 'AM, CM', 3),

-- Liverpool (team_id = 4)
('Mohamed', 'Salah', 'Egyptian', 1.75, 55000000.00, 34, 71.0, NULL, 'RW, ST', 4),
('Virgil', 'van Dijk', 'Dutch', 1.93, 25000000.00, 35, 92.0, NULL, 'CB', 4),
('Trent', 'Alexander-Arnold', 'English', 1.80, 75000000.00, 28, 69.0, NULL, 'RB, CM', 4),

-- Arsenal (team_id = 5)
('Bukayo', 'Saka', 'English', 1.78, 140000000.00, 25, 72.5, NULL, 'RW, RM, LW', 5),
('Declan', 'Rice', 'English', 1.85, 120000000.00, 27, 80.0, NULL, 'DM, CM', 5),
('Martin', 'Odegaard', 'Norwegian', 1.78, 110000000.00, 27, 68.0, NULL, 'AM', 5),

-- Chelsea (team_id = 6)
('Cole', 'Palmer', 'English', 1.89, 90000000.00, 24, 74.0, NULL, 'AM, RW, CF', 6),
('Joao', 'Pedro', 'Brazilian', 1.86, 80000000.00, 25, 75.0, NULL, 'CAM, ST, LW', 6),
('Morgan', 'Rogers', 'English', 1.88, 90000000.00, 28, 77.0, NULL, 'AM, LM, LW', 6);

-- =============================================
-- 5. Insert Referees
-- =============================================
INSERT INTO Referee (first_name, last_name) VALUES 
('Anthony', 'Taylor'),
('Michael', 'Oliver'),
('Stuart', 'Attwell'),
('Simon', 'Hooper');

-- =============================================
-- 6. Insert Matches (Autumn 2026 Season context)
-- =============================================
INSERT INTO Match (home_team_score, away_team_score, league_id, referee_id, match_date, status, home_team_id, away_team_id) VALUES 
(3, 2, 1, 1, '2026-09-14 17:30:00', 'Finished', 1, 5), -- Man City vs Arsenal
(2, 2, 1, 2, '2026-09-21 15:00:00', 'Finished', 2, 4), -- Man United vs Liverpool
(1, 3, 1, 3, '2026-10-04 20:00:00', 'Finished', 6, 3), -- Chelsea vs Tottenham
(2, 1, 1, 4, '2026-10-18 16:30:00', 'Finished', 4, 1); -- Liverpool vs Man City

-- =============================================
-- 7. Insert Match Statistics
-- =============================================
INSERT INTO Match_Stat (possession_home, possession_away, passes, corners, xg_home, xg_away, offsides, saves, shots, fouls, match_id) VALUES 
(57, 43, 590, 8, 2.30, 1.40, 2, 4, 17, 10, 1),
(48, 52, 460, 5, 1.50, 1.60, 1, 3, 13, 12, 2),
(52, 48, 510, 6, 1.20, 2.10, 3, 5, 14, 15, 3),
(50, 50, 530, 7, 1.90, 1.85, 2, 5, 16, 11, 4);

-- =============================================
-- 8. Insert Match Events (Goals, Cards)
-- =============================================
INSERT INTO Match_Event (minute, event_type, match_id, player_id) VALUES 
-- Match 1: Man City vs Arsenal
(18, 'goal', 1, 1),
(35, 'yellow_card', 1, 13),
(52, 'goal', 1, 12),
(71, 'goal', 1, 12),
(89, 'goal', 1, 1),

-- Match 2: Man United vs Liverpool
(12, 'goal', 2, 5),
(31, 'goal', 2, 9),
(68, 'goal', 2, 10),
(84, 'goal', 2, 4),

-- Match 3: Chelsea vs Tottenham
(15, 'goal', 3, 15),
(40, 'goal', 3, 7),
(55, 'goal', 3, 7),
(79, 'goal', 3, 7),

-- Match 4: Liverpool vs Man City
(25, 'goal', 4, 9),
(45, 'yellow_card', 4, 3),
(60, 'goal', 4, 10),
(82, 'goal', 4, 1);

-- =============================================
-- 9. Insert News (Autumn 2026 context, no photo URLs)
-- =============================================
INSERT INTO News (title, description, published_date, image_url, team_id) VALUES 
('Early Title Statement', 'Manchester City defeat Arsenal in a thrilling 5-goal encounter at the Etihad.', '2026-09-15 09:30:00', NULL, 1),
('Anfield Stalemate', 'Liverpool and Manchester United share the spoils after a hard-fought draw.', '2026-09-22 10:00:00', NULL, 4),
('Palmer Masterclass', 'Cole Palmer inspires Chelsea to an impressive away victory over Tottenham.', '2026-10-05 08:45:00', NULL, 6);

-- =============================================
-- 10. Insert Trophies (Club & Individual for 2025/2026 season)
-- =============================================
INSERT INTO Trophy (name, season, team_id, player_id) VALUES 
('Premier League', '2025/2026', 1, NULL),
('FA Cup', '2025/2026', 4, NULL),
('League Cup', '2025/2026', 5, NULL),
('Golden Boot', '2025/2026', NULL, 1), -- Erling Haaland
('Playmaker of the Season', '2025/2026', NULL, 2); -- Kevin De Bruyne

-- =============================================
-- 11. Insert Users
-- =============================================
INSERT INTO [User] (email, password) VALUES 
('john_cfc@gmail.com', 'hashed_pass_london'),
('anfield_king@yahoo.com', 'hashed_pass_reds'),
('mancity_fan99@abv.bg', 'hashed_pass_blue');

-- =============================================
-- 12. Insert User Follows (Teams & Players)
-- =============================================
INSERT INTO User_Follow_Team (user_id, team_id) VALUES 
(1, 6), -- John follows Chelsea
(2, 4), -- Anfield king follows Liverpool
(3, 1); -- Mancity fan follows Man City

INSERT INTO User_Follow_Player (user_id, player_id) VALUES 
(1, 15), -- John follows Cole Palmer
(2, 9),  -- Anfield king follows Mo Salah
(3, 1);  -- Mancity fan follows Erling Haaland
GO



-- =============================================
-- 3 FUNCTIONS
-- =============================================

-- 1. Function to get total goals scored by a specific player
CREATE FUNCTION udf_GetPlayerGoals (@PlayerId INT)
RETURNS INT
AS
BEGIN
    DECLARE @Goals INT;
    SELECT @Goals = COUNT(*) 
    FROM Match_Event 
    WHERE player_id = @PlayerId AND event_type = 'goal';
    RETURN ISNULL(@Goals, 0);
END;
GO

-- 2. Function to check if a team belongs to a league via League_Team
CREATE FUNCTION udf_IsTeamInLeague (@TeamId INT, @LeagueId INT)
RETURNS BIT
AS
BEGIN
    DECLARE @Result BIT = 0;
    IF EXISTS (SELECT 1 FROM League_Team WHERE team_id = @TeamId AND league_id = @LeagueId)
        SET @Result = 1;
    RETURN @Result;
END;
GO

-- 3. Function to get total trophies won by a team
CREATE FUNCTION udf_GetTeamTotalTrophies (@TeamId INT)
RETURNS INT
AS
BEGIN
    DECLARE @TrophyCount INT;
    SELECT @TrophyCount = COUNT(*) 
    FROM Trophy 
    WHERE team_id = @TeamId;
    RETURN ISNULL(@TrophyCount, 0);
END;
GO

-- =============================================
-- 3 STORED PROCEDURES
-- =============================================

-- 1. Procedure to add a new match event
CREATE PROCEDURE usp_AddMatchEvent
    @Minute INT,
    @EventType VARCHAR(50),
    @MatchId INT,
    @PlayerId INT
AS
BEGIN
    INSERT INTO Match_Event (minute, event_type, match_id, player_id)
    VALUES (@Minute, @EventType, @MatchId, @PlayerId);
END;
GO

-- 2. Procedure to update match score
CREATE PROCEDURE usp_UpdateMatchScore
    @MatchId INT,
    @HomeScore INT,
    @AwayScore INT
AS
BEGIN
    UPDATE Match
    SET home_team_score = @HomeScore, away_team_score = @AwayScore
    WHERE match_id = @MatchId;
END;
GO

-- 3. Procedure to get all players of a specific team
CREATE PROCEDURE usp_GetPlayersByTeam
    @TeamId INT
AS
BEGIN
    SELECT player_id, first_name, last_name, positions, transfer_value
    FROM Player
    WHERE team_id = @TeamId;
END;
GO

-- =============================================
-- 3 TRIGGERS
-- =============================================

-- 1. Trigger to validate player age (must be between 1 and 50)
CREATE TRIGGER trg_CheckPlayerAge
ON Player
AFTER INSERT, UPDATE
AS
BEGIN
    IF EXISTS (SELECT 1 FROM inserted WHERE age <= 0 OR age > 50)
    BEGIN
        RAISERROR ('Invalid player age! Age must be between 1 and 50 years.', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
GO

-- 2. Trigger to prevent duplicate team follows by the same user
CREATE TRIGGER trg_PreventDuplicateFollow
ON User_Follow_Team
INSTEAD OF INSERT
AS
BEGIN
    INSERT INTO User_Follow_Team (user_id, team_id)
    SELECT i.user_id, i.team_id
    FROM inserted i
    WHERE NOT EXISTS (
        SELECT 1 FROM User_Follow_Team f 
        WHERE f.user_id = i.user_id AND f.team_id = i.team_id
    );
END;
GO

-- 3. Trigger to prevent adding events to matches started more than 5 minutes ago
CREATE TRIGGER trg_PreventEventOnPastMatch
ON Match_Event
AFTER INSERT
AS
BEGIN
    IF EXISTS (
        SELECT 1 
        FROM inserted i
        JOIN Match m ON i.match_id = m.match_id
        WHERE m.match_date < DATEADD(MINUTE, -5, GETDATE())
    )
    BEGIN
        RAISERROR ('Cannot add events to a match that started more than 5 minutes ago!', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
GO