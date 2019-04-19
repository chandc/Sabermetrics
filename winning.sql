#comparing average error by year
SELECT w.yearID, AVG(ABS(w.Error)) AS AverageError
FROM(
   SELECT teamID, yearID, W,
   G*(R^2)/(R^2+RA^2) AS predictedW,
   (G*(R^2)/(R^2+RA^2) - W) AS Error
   FROM Teams
   WHERE yearID >= 1955) w
GROUP BY w.yearID


#comparing errors by year
SELECT w.yearID, 
      MIN(w.Error) AS MINError,
      MAX(w.Error) AS MAXError,
      STD(w.Error) AS STDError
FROM(
   SELECT teamID, yearID, W,
   G*(R^2)/(R^2+RA^2) AS predictedW,
   (G*(R^2)/(R^2+RA^2) - W) AS Error
   FROM Teams
   WHERE yearID >= 1955) w
GROUP BY w.yearID
ORDER BY STDError DESC


#SF Giant 2013 Barring Data
SELECT CONCAT(nameFirst, " ", nameLast) AS PlayerName,
   G,AB,H,2B,3B,HR,R,RBI,SB,
   H/AB AS BA,
   (H+BB+HBP)/(AB+BB+HBP+SF) AS OBP,
   (H+2B+2*3B+3*HR)/AB AS SLG
FROM Batting b
JOIN Master m
   ON b.playerID = m.playerID
WHERE yearID = "2013" AND teamID="SFN"
ORDER by SLG DESC;


SELECT yearID,
   G,AB,H,2B,3B,HR,R,RBI,SB,
   H/AB AS BA,
   (H+BB+HBP)/(AB+BB+HBP+SF) AS OBP,
   (H+2B+2*3B+3*HR)/AB AS SLG
FROM Batting b
WHERE yearID = "2013" AND lgID = 'AL'



SELECT
   CONCAT(m.nameFirst, ' ', m.nameLast) AS playerName,
   yearID,
   G,AB,H,2B,3B,HR,R,RBI,SB,
   H/AB AS BA,
   (H+BB+HBP)/(AB+BB+HBP+SF) AS OBP,
   (H+2B+2*3B+3*HR)/AB AS SLG
FROM Batting b
JOIN Master m
   ON b.playerID = m.playerID
WHERE yearID = "2013" AND lgID = 'AL'


SELECT
   CONCAT(m.nameFirst, ' ', m.nameLast) AS playerName,
   yearID,
   G,AB,H,2B,3B,HR,R,RBI,SB,
   H/AB AS BA,
   (H+BB+HBP)/(AB+BB+HBP+SF) AS OBP,
   (H+2B+2*3B+3*HR)/AB AS SLG
FROM Batting b
JOIN Master m
   ON b.playerID = m.playerID
WHERE m.nameLast = 'Rodriguez' AND AB >= 50

# To get career stats, it is better to JOIN on players, year and stint first, 
# then run the GROUP BY on the joined table after
SELECT b.playerID, 
       SUM(b.AB) AS CAREER_AB,
       SUM(b.HR) AS CARERR_HR,
       SUM(p.IPouts) AS CAREER_IPouts,
       SUM(p.SO) AS CAREER_SO
FROM Batting b
JOIN Pitching p
   ON (b.playerID = p.playerID
       AND b.yearID = p.yearID
       AND b.stint = p.stint)
GROUP BY playerID #DESC



# 
SELECT b.yearID, 
       SUM(b.H)  AS TOTAL_PITCHER_H,
       SUM(p.WP) AS TOTAL_WP
FROM Batting b
JOIN Pitching p
   ON (b.playerID = p.playerID
       AND b.yearID = p.yearID
       AND b.stint = p.stint)
GROUP BY b.yearID DESC
ORDER BY b.yearID DESC



# query to explore payroll efficiency
SELECT t.yearID, t.teamID, t.W, s.Payroll, s.Payroll/t.W AS DollarperW
FROM Teams t
JOIN (
   SELECT yearID, teamID, SUM(salary) AS Payroll
   FROM Salaries
   GROUP BY yearID, teamID) s
ON t.yearID = s.yearID
AND t.teamID = s.teamID
WHERE t.yearID >= 2000
ORDER BY DollarperW #DESC


# query to explore payroll efficiency
SELECT t.yearID, t.teamID, t.attendance, s.Payroll,
       s.Payroll/t.attendance AS DollarsperFan
FROM Teams t
JOIN (
   SELECT yearID, teamID, SUM(salary) AS Payroll
   FROM Salaries
   GROUP BY yearID, teamID) s
ON t.yearID = s.yearID
AND t.teamID = s.teamID
ORDER BY DollarsperFan DESC



SELECT CONCAT(m.nameFirst, ' ', m.nameLast) AS playerName, m.nameNick,
   p.yearID, p.IPOuts, p.W, p.SO, p.ERA,
   (p.BB+p.H)/(p.IPOuts/3) AS WHIP
FROM Pitching p
JOIN Master m
   ON p.playerID = m.playerID
WHERE m.nameNick = "Lefty" AND IPOuts > 60


SELECT *
FROM Batting b
JOIN Master m
   ON b.playerID = m.playerID
JOIN SchoolsPlayers sp
   ON sp.playerID = m.plyaerID
JOIN Schools
   ON s.schoolID = sp.playerIF
WHERE schoolName = "   "
ORDER BY



SELECT CONCAT(m.nameFirst, " ", m.nameLast) AS playerName, 
       s.schoolName, b.yearID, b.G,
       b.H/b.AB AS BA,
  (b.H+b.BB+b.HBP)/(b.AB+b.BB+b.HBP+b.SF) AS OBP,
  (b.H+b.2B+2*b.3B+3*b.HR)/b.AB AS SLG
FROM Batting b
JOIN Master m
   ON b.playerID = m.playerID
JOIN SchoolsPlayers sp
   ON sp.playerID = m.playerID
JOIN Schools s
   ON s.schoolID = sp.schoolID
WHERE s.schoolState = 'HI' AND b.AB >= 10
ORDER BY SLG DESC


#
SELECT CONCAT(m.nameFirst," ", m.nameLast) AS playerName, 
  b.yearID, b.teamID, b.stint,
  b.G, b.AB, b.SB,
  b.H/b.AB AS BA,
  (b.H+b.BB+b.HBP)/(b.AB+b.BB+b.HBP+b.SF) AS OBP,
  (b.H+b.2B+2*b.3B+3*b.HR)/b.AB AS SLG,
  f.POS, f.DP,
  f.A + f.PO + f.E AS TotalChances,
  (f.A + f.PO)/(f.A + f.PO + f.E) AS FPct
FROM Batting b
JOIN Master m
   ON b.playerID = m.playerID
JOIN Fielding f
       ON (f.playerID = b.playerID
       AND f.yearID = b.yearID
       AND f.stint = b.stint)
WHERE m.nameFirst="Hunter" AND m.nameLast="Pence" AND f.POS = "RF"




SELECT b.playerID, b.yearID, b.teamID, b.lgID, b.AB, b.H/b.AB AS BA, 
    p.IPouts, p.ERA
FROM Batting b
INNER JOIN Pitching p
ON (b.playerID = p.playerID
       AND b.yearID = p.yearID
       AND b.stint = p.stint)
WHERE b.yearID=2010 AND b.AB >= 1


SELECT b.playerID, b.yearID, b.teamID, b.lgIDSELECT b.playerID, b.yearID, b.teamID, b.lgID, b.AB, b.H/b.AB AS BA, 
    p.IPouts, p.ERA
FROM Batting b
LEFT JOIN Pitching p
ON (b.playerID = p.playerID
       AND b.yearID = p.yearID
       AND b.stint = p.stint)
WHERE b.yearID=2010 AND b.AB >= 1




SELECT b.playerID, b.yearID, b.teamID, b.lgID, b.AB, b.H/b.AB AS BA, 
    p.IPouts, p.ERA
FROM Batting b
LEFT JOIN Pitching p
ON (b.playerID = p.playerID
       AND b.yearID = p.yearID
       AND b.stint = p.stint)
WHERE b.yearID=2010 AND b.AB >= 1


SELECT p.playerID, p.yearID, p.teamID, p.lgID, b.AB, b.H/b.AB AS BA,
    p.IPouts, p.ERA
FROM Batting b
RIGHT JOIN Pitching p
ON (p.playerID = b.playerID
       AND p.yearID = b.yearID
       AND p.stint = b.stint)
WHERE p.yearID=2010 
