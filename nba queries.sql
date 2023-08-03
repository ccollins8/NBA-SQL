-- How many NBA Teams are there?
SELECT COUNT(*) as Amount_of_Teams
FROM team;

-- Who are the tallest active players on each team? Who are the 5 tallest players from the resulting list?
SELECT t.full_name AS team, cpi.display_first_last AS player,max(height) AS height
FROM common_player_info cpi
JOIN team t ON cpi.team_id = t.id
JOIN player p ON cpi.person_id = p.id
WHERE p.is_active = 1
GROUP BY t.full_name
ORDER BY height DESC
LIMIT 5;

-- How many active players are on each team? List the top 5 teams with the most active players from the resulting list.
SELECT t.full_name, COUNT(*) AS player_count
FROM common_player_info cpi
JOIN team t ON cpi.team_id = t.id
JOIN player p ON cpi.person_id = p.id
WHERE p.is_active = 1
GROUP BY t.full_name
ORDER BY player_count DESC
LIMIT 5;

-- For each team, count how many active players are in the following categories: Bellow 6'4, Between 6'4 and 6'7, Above 6'7
-- UPDATE common_player_info SET height = replace(height,'-','-0') WHERE length(height) = 3;

WITH apt AS (
SELECT t.full_name AS team_name, p.full_name AS player_name,cpi.height
FROM common_player_info cpi
JOIN team t ON cpi.team_id = t.id
JOIN player p ON cpi.person_id = p.id
WHERE p.is_active = 1)

select team_name, 
	   COUNT(CASE WHEN height < '6-04' THEN 1 END) AS 'players_bellow_6-04',
	   COUNT(CASE WHEN height BETWEEN '6-04' AND '6-07' THEN 1 END) AS 'between_6-04_and_6-07',
	   COUNT(CASE WHEN height > '6-07' THEN 1 END) AS 'above_6-07'
FROM apt
GROUP by team_name;

-- How many games did the Chicago Bulls play in 2020?
SELECT COUNT(*) AS total_games_2020_bulls
FROM game
WHERE game_date LIKE '2020%' AND 
(team_name_home = 'Chicago Bulls' OR team_name_away = 'Chicago Bulls');

-- What Teams had the best win/loss ratio in 2020
WITH team_wl_2020 AS(
SELECT team_name_home AS team_name, wl_home AS wl,game_date
FROM game
WHERE game_date LIKE '2020%'
UNION ALL
SELECT team_name_away, wl_away,game_date
FROM game
WHERE game_date LIKE '2020%')

select team_name, 
	   COUNT(CASE WHEN wl = 'W' THEN 1 END) AS games_won,
	   COUNT(CASE WHEN wl = 'L' THEN 1 END) as games_lost,
	   ROUND(COUNT(CASE WHEN wl = 'W' THEN 1 END)*1.0
	   / COUNT(CASE WHEN wl = 'L' THEN 1 END),2) AS win_loss_ratio
FROM team_wl_2020
GROUP BY team_name
ORDER BY win_loss_ratio DESC
LIMIT 5;

-- What is average game attendance for each team playing at home in 2023? List the top 5 
SELECT g.team_name_home, CAST(avg(gi.attendance)AS INT) AS average_attendence_2023
FROM game g
JOIN game_info gi ON g.game_id = gi.game_id
WHERE g.game_date LIKE '2023%'
GROUP BY g.team_name_home
ORDER BY average_attendence_2023 DESC
LIMIT 5;