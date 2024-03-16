-- TP 2

-- CREATE A VIEW THAT SHOWS THE NAME OF THE USER AND THE TYPE OF USER

CREATE VIEW user_view AS 
SELECT first_name,
       last_name,
       description
  FROM SYSTEM_USER AS s
       LEFT JOIN
       USER_TYPE AS u ON s.id_SYSTEM_USER = u.id_USER_TYPE;


-- CREATE A VIEW THAT SHOWS THE GAMES COMPLETED BY EACH USER
CREATE VIEW user_games_completed AS
    SELECT s.first_name,
           s.last_name,
           g.name,
           p.completed
      FROM SYSTEM_USER AS s
           LEFT JOIN
           PLAY AS p ON s.id_SYSTEM_USER = p.id_SYSTEM_USER
           LEFT JOIN
           GAME AS g ON p.id_GAME = g.id_GAME
     WHERE p.completed = 1;

-- CREATE A VIEW THAT SHOWS THE NUMBER OF COMMENTS PER GAME
CREATE VIEW comments_by_game AS
SELECT g.name,
       COUNT(COMMENTARY) AS comments_by_game
  FROM COMMENTARY AS c
       LEFT JOIN
       GAME AS g ON c.id_GAME = g.id_GAME
 GROUP BY g.name;

-- CREATE A VIEW THAT SHOWS THE NAME OF THE GAME AND THE NUMBER OF VOTES PER GAME
CREATE VIEW games_and_votes AS
SELECT g.name,
       COUNT(COMMENTARY) AS comments_by_game
  FROM COMMENTARY AS c
       LEFT JOIN
       GAME AS g ON c.id_GAME = g.id_GAME
 GROUP BY g.name;
 
 -- CREATE A VIEW THAT CONTAINS THE NAME OF THE GAME AND THE NUMBER OF VOTES
 
CREATE VIEW names_games_vote AS
SELECT g.name,
		count(v.value)
FROM GAME AS g
		LEFT JOIN
VOTE AS v ON g.id_GAME = v.id_GAME
GROUP BY g.name;	

-- DDL 
		
PRAGMA foreign_keys = 0;

CREATE TABLE sqlitestudio_temp_table AS SELECT * FROM PLAY;

DROP TABLE PLAY;

CREATE TABLE PLAY (
    id_GAME        INTEGER NOT NULL
                           REFERENCES GAME (id_GAME) ON UPDATE CASCADE,
    id_SYSTEM_USER INTEGER NOT NULL
                           REFERENCES SYSTEM_USER (id_SYSTEM_USER),
    completed      INTEGER NOT NULL,
    PRIMARY KEY (
        id_game,
        id_system_user
    )
);

INSERT INTO PLAY (
                     id_GAME,
                     id_SYSTEM_USER,
                     completed
                 )
                 SELECT id_GAME,
                        id_SYSTEM_USER,
                        completed
                   FROM sqlitestudio_temp_table;

DROP TABLE sqlitestudio_temp_table;

PRAGMA foreign_keys = 1;

 
 
 
 