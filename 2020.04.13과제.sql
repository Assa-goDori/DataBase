/*
	학생의 이름 일부만 입력받아 해당 학생들의
	학번, 이름,키,몸무게,학년,
	자기학년의 최대키,평균키,최대몸무게,평균몸무게 출력하기
*/
SELECT s.studno, s.NAME, s.height, s.weight, s.grade, MAX_h, AVG_h, MAX_w, AVG_w
FROM student s, (SELECT grade, MAX(height) MAX_h, AVG(height) AVG_h, MAX(weight) MAX_w, AVG(weight) AVG_w FROM student GROUP BY grade) a
WHERE s.grade = a.grade
AND s.name LIKE '%김%'

SELECT studno, NAME, height, weight, grade,
	(select MAX(height) FROM student WHERE grade=s.grade)최대키,
	(select AVG(height) FROM student WHERE grade=s.grade)평균키,
	(select MAX(weight) FROM student WHERE grade=s.grade) 최대몸무게,
	(select AVG(weight) FROM student WHERE grade=s.grade) 평균몸무게
FROM student s
WHERE NAME LIKE '%영%'
