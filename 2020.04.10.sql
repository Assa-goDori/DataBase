/*
	그룹 함수
		순위지정함수 : rank() over(정렬방식)
		누계산출함수 : sum(컬럼명) over(정렬방식)
	join 구문 : 여러개의 테이블을 연결하여 조회
		Cross join : M*N 건수로 조회. 사용시 주의 요망
		등가조인(Equi Join) : 조인컬럼을 이용하여 조건에 맞는 레코드만 조회
									 조인컬럼값이 같은 경우 조인 대상 레코드
		비등가조인(Non Equi Join) : 조인컬럼의 조건이 =이 아닌 경우. 범위지정으로 조인
		self join : 조인되는 테이블이 같은 테이블임.
						조인컬럼은 같은 테이블의 다른 컬럼을 이용함
						반드시 테이블의 별명을 지정해야 한다
		outer join : 조인컬럼의 조건에 맞지 않아도 조회가 되도록 하는 조인
			left outer join : 왼쪽 테이블의 내용이 전부 나오도록
			right outer join : 오른쪽 테이블의 내용이 전부 나오도록
			full outer join : 양쪽 테이블의 내용이 전부 나오도록
									union 명령어를 이용하여 구현
*/

--문제1. major 테이블에서 학과코드, 학과명, 상위학과코드, 상위학과명 출력하기.
--			모든학과를 조회함.
SELECT m1.code, m1.name, ifnull(m1.part,'상위학과없음'), ifnull(m2.name, ' ')
FROM major m1 LEFT JOIN major m2
ON m1.part = m2.code
--문제2. 교수번호,이름,입사일,자신보다 입사일이 빠른 사람의 인원수 출력하기.
--			모든 교수들이 조회됨.
SELECT p1.no, p1.NAME, p1.hiredate, COUNT(p2.hiredate) 인원수
FROM professor p1 LEFT JOIN professor p2
ON p1.hiredate > p2.hiredate
GROUP BY p1.no

/*
	subquery : select 구문 내부에 select 구문이 존재함.
					where 조건문에 사용되는 select 구문
					단일행 subquery : where 조건문에서 사용되는 select의 결과가 한개인 경우
						사용되는 연산자 : =, <, >, >=, <= (관계연산자)
					복수행 subquery : where 조건문에서 사용되는 select의 결과가 여러개인 경우
						사용되는 연산자 : IN, > ALL, < ALL, > ANY, < ANY
*/

--emp 테이블에서 이혜라 사원보다 많은 급여를 받는 직원의 정보 출력하기
SELECT salary FROM emp WHERE ename='이혜라'
SELECT * FROM emp WHERE salary > (SELECT salary FROM emp WHERE ename='이혜라')

--문제1. 학생 중 김종연 학생보다 윗학년의 이름, 학년, 전공1코드,전공학과명 출력하기
SELECT s.name, s.grade, s.major1, m.name
FROM student s join major m
on s.major1=m.code
WHERE s.grade > (SELECT grade FROM student WHERE NAME='김종연')
--문제2. 학생 중 김종연 학생과 같은 학과의 학생의 이름, 학년, 전공1코드, 전공학과명 출력하기
SELECT s.name, s.grade, s.major1, m.name
FROM student s join major m
on s.major1=m.code
WHERE s.major1 = (SELECT major1 FROM student WHERE NAME='김종연')
--문제3. 사원의 평균급여 미만의 급여를 받는 사원 번호,이름,직급,급여 출력하기
SELECT empno, ename, job, salary
FROM emp
WHERE salary < (SELECT avg(salary) FROM emp)
--문제4. 직급이 사원인 사람 중 사원의 평균급여 미만의 급여를 받는 사원 번호,이름,직급,급여 출력하기
SELECT empno, ename, job, salary
FROM emp
WHERE salary <(SELECT AVG(salary) FROM emp WHERE job='사원')
--문제5. 직급이 사원인 사람 중 평균급여 미만의 급여를 받는 사원 직급의 사원 번호,이름,직급,급여 출력하기
SELECT empno, ename, job, salary
FROM emp
WHERE  job='사원' and salary <(SELECT AVG(salary) FROM emp)

/*
	복수행 서브쿼리 : 서브쿼리의 결과가 여러행인 경우
*/
-- emp, dept 테이블을 이용하여 근무지역이 서울인 사원의 사번,이름,부서번호,부서명 출력하기
SELECT e.empno, e.ename, e.deptno, d.dname
FROM emp e, dept d
WHERE e.deptno = d.deptno
AND e.deptno in (SELECT deptno FROM dept WHERE loc = '서울')
--문제1. 1학년 학생과 같은 키를 가지고 있는 2학년 학생의 이름, 키, 학년 출력하기
SELECT NAME, height, grade
from student
WHERE grade=2 and height in (SELECT distinct height FROM student WHERE grade=1)

-- 사원 테이블에서 사원 직급의 최대급여보다 급여가 높은 사람의 이름,직급,급여 출력하기
SELECT ename,job,salary
FROM emp
WHERE salary > (SELECT max(salary) FROM emp WHERE job='사원')

SELECT ename,job,salary
FROM emp
WHERE salary > ALL (SELECT salary FROM emp WHERE job='사원')
-- 사원 테이블에서 사원 직급의 최소급여보다 급여가 높은 사람의 이름,직급,급여 출력하기
SELECT ename,job,salary
FROM emp
WHERE salary > (SELECT min(salary) FROM emp WHERE job='사원')

SELECT ename,job,salary
FROM emp
WHERE salary > any (SELECT salary FROM emp WHERE job='사원')

--문제1. 4학년 학생의 최소 체중보다 체중이 적은 학생의 이름, 체중 출력하기
SELECT NAME, weight
FROM student
WHERE weight < all (SELECT weight FROM student WHERE grade=4)
--문제2. 1학년 학생 중 최대 키를 가진 학생의 정보를 출력하기
SELECT *
FROM student
WHERE grade=1 and height >= ALL(SELECT distinct height FROM student WHERE grade=1)
--문제3. emp테이블에서 부서별 평균 연봉 중 가장 작은 평균 연봉보다 적게 받는 직원의 직원명, 부서명, 급여, 연봉 출력하기
--			연봉 : 급여*12 + 보너스. 보너스가 없는 경우 0으로 처리
SELECT e.ename, d.dname, e.salary, e.salary*12+IFNULL(e.bonus,0) 연봉
FROM emp e, dept d
WHERE e.deptno = d.deptno
and salary*12+IFNULL(e.bonus,0) < ALL (SELECT AVG(e.salary*12+IFNULL(e.bonus,0)) FROM emp e, dept d WHERE e.deptno = d.deptno group BY d.dNAME)

/*
	다중 컬럼 서브쿼리 : 비교대상인 컬럼이 두개 이상임.
								ANY, ALL 사용불가
*/
-- 학년별로 최대키를 가진 학생의 학년과 이름, 키 출력
SELECT GRADE,NAME, height
FROM student
WHERE grade=1 AND height = (SELECT MAX(height) FROM student WHERE grade=1)
UNION
SELECT grade, NAME, height
FROM student
WHERE grade=2 AND height = (SELECT MAX(height) FROM student WHERE grade=2)
UNION
SELECT grade, NAME, height
FROM student
WHERE grade=3 AND height = (SELECT MAX(height) FROM student WHERE grade=3)
UNION
SELECT grade,NAME, height
FROM student
WHERE grade=4 AND height = (SELECT MAX(height) FROM student WHERE grade=4)

SELECT grade,NAME,height
FROM student
WHERE (grade,height) IN (SELECT grade,MAX(height) FROM student GROUP BY grade)

--학년별로 최소키를 가진 학생의 학년과 이름, 키 출력하기
SELECT grade, NAME, height
FROM student
WHERE (grade,height) IN (SELECT grade, MIN(height) FROM student GROUP BY grade)

--1. emp테이블에서 직급별로 해당직급의 최대 급여를 받는 직원 정보 출력
SELECT *
FROM emp
WHERE (job, salary) IN (SELECT job, MAX(salary) FROM emp GROUP BY job)
--2. 학과별로 입사일이 가장 오래된 교수의 교수번호, 이름, 입사일, 학과명 출력하기
SELECT NO, p.NAME, p.hiredate, p.deptno, m.name
FROM professor p, major m
WHERE p.deptno = m.code
AND (deptno, hiredate) IN (SELECT deptno, MIN(hiredate) FROM professor GROUP BY deptno)

/*
	상호연관 서브쿼리 : 외부 query가 내부 subquery에 영향을 주는 query. 성능이 안좋다.
*/
-- 직원이 직원의 현재 직급의 평균 급여 이상을 받는 직원의 이름,직급,급여 출력하기
SELECT ename,job,salary FROM emp e1
WHERE salary >= (SELECT AVG(salary) FROM emp e2 WHERE e2.job=e1.job)

--문제1. 교수테이블에서 교수의 본인 직급의 평균급여 이상을 받는 교수의 이름,직급,급여,학과명 출력하기
SELECT p.name,POSITION,salary, m.name
FROM professor p, major m
WHERE p.deptno = m.code
AND salary >= (SELECT AVG(salary) FROM professor p2 WHERE p2.position = p.position)

/*
	subquery 사용 위치에 따른 분류
		1. where 조건문
		2. 컬럼부분 : 스칼라 subquery
		3. having 구문
		4. from 구문 : inline view
							반드시 alias 지정해야됨
*/

-- emp테이블, dept테이블에서 사원이름,직급,부서코드,부서명 출력하기
SELECT e.ename, e.job, e.deptno, d.dname
FROM emp e, dept d
WHERE e.deptno = d.deptno
-- 스칼라 방식으로 변경
SELECT ename, job, deptno, (SELECT dname FROM dept d WHERE d.deptno = e.deptno)
FROM emp e

--학년별 평균체중이 가장 적은 학년의 학년과 평균 체중 출력하기
SELECT grade, AVG(weight)
FROM student
GROUP BY grade
HAVING AVG(weight) <=ALL (SELECT AVG(weight) FROM student GROUP BY grade)

SELECT grade, AVG(weight)
FROM student
GROUP BY grade
HAVING AVG(weight) = (SELECT MIN(AVG) from (SELECT AVG(weight) avg FROM student GROUP BY grade) a)

SELECT grade, MIN(AVG) FROM
(SELECT grade, AVG(weight) AVG FROM student GROUP BY grade ORDER BY 2) a

-- major 테이블에서 공과대학에 소속된 학과이름 출력하기
SELECT * FROM major

SELECT name
FROM major
WHERE part
in (SELECT code FROM major WHERE part = (SELECT CODE FROM major WHERE NAME='공과대학'))

--인라인 뷰(반드시 alias를 사용해야된다)
SELECT NAME
FROM major m, (SELECT CODE FROM major WHERE part = (SELECT CODE FROM major WHERE NAME='공과대학')) a
WHERE m.part = a.code

/*
	DDL : Data Definition Language. 데이터 정의어
			객체(table, index, view, user) 생성(create), 수정(alter), 제거(drop), 데이터만제거(truncate) 기능을 가진 명령어들의 집합
	특징 : transaction 처리(commit, rollback)가 안됨.
*/
-- create : table을 생성해주는 명령어

--test1 테이블 생성하기
CREATE TABLE test1 (
	NO INT PRIMARY KEY AUTO_INCREMENT,
	NAME VARCHAR(20),
	birth datetime
)
/*
	create table test1 : test1이름을 가진 table 생성하기
	NO : 컬럼이름.
	INT : 정수형 자료형
	PRIMARY KEY : 기본키 컬럼(중복불가, not null)
	AUTO_INCREMENT : 자동증가(숫자형 기본키에서만 사용 가능)
						 => 오라클에서는 사용안됨. Sequence 객체를 이용하여 기능을 수행
	datetime : 날짜와 시간을 함께 갖고 있음.
	date : 날짜 
	time : 시간
*/
SELECT * FROM test1
-test1의 구조 출력
DESC test1

--test2 테이블 생성하기
--컬럼 : seq : 숫자형, 기본키
--			NAME : 문자형, 20문자
--			birthday : 날짜만
CREATE TABLE test2 (
	seq INT PRIMARY KEY,
	NAME VARCHAR(20),
	birthday date
)
DESC test2

/*
	기본키가 여러 컬럼인 테이블 생성하기
	test3
	기본키들이 모두 같은 경우만 중복으로 한다.
*/
CREATE TABLE test3 (
	NO INT,
	seq INT,
	NAME VARCHAR(20),
	PRIMARY KEY(NO, seq)
)
DESC test3

--test2 테이블에 데이터 입력하기
INSERT INTO test2 values(1,'홍길동','2020-01-01')
INSERT INTO test2 VALUES(2,'김삿갓','2020-03-01')
SELECT * FROM test2
--test3 테이블에 데이터 입력하기
INSERT INTO test3 values(1,1,'홍길동')
INSERT INTO test3 values(1,2,'홍길동')
SELECT * FROM test3

--기본 값 설정하기 : test4
CREATE TABLE test4 (
	NO INT PRIMARY KEY,
	NAME VARCHAR(30) DEFAULT '홍길동' => 값입력이 안된경우 '홍길동'으로 설정
)
INSERT INTO test4 (NO) VALUES(1)
INSERT INTO test4 (NO, NAME) VALUES(2, '김삿갓')

--drop : table 제거
DROP TABLE test4
DROP TABLE test3

--기존 존재하는 테이블을 이용하여 새로운 테이블 생성하기 => 테스트 테이블 생성시 사용
-- dept 테이블의 모든 컬럼과 모든 레코드를 가지고 있는 depttest1 테이블 생성하기
CREATE TABLE depttest1 AS SELECT * FROM dept
SELECT * FROM depttest1
DESC depttest1
-- dept 테이블의 deptno,dname 컬럼과 해당 데이터를  가지고 있는 depttest2 테이블 생성하기
CREATE TABLE depttest2 AS SELECT deptno, dname FROM dept
SELECT * FROM depttest2
DESC depttest2
-- dpet 트에블의 deptno, dname 컬럼 및 데이터와 loc가 서울인 데이터를 가지고있는 depttest3 테이블 생성하기
CREATE TABLE depttest3 AS SELECT deptno, dname FROM dept WHERE loc='서울' 
SELECT * FROM depttest3
DESC depttest3

/*
	2020.04.10 과제
*/

-- 1.김경빈 사원과 같이 입사한 사원의 사원번호, 
--          사원명,직급, 부서코드, 부서명 을 출력하기
SELECT e.empno,e.ename, e.job, e.deptno, d.dname
FROM emp e, dept d
WHERE e.deptno = d.deptno
AND hiredate = (SELECT hiredate FROM emp WHERE ename = '김경빈')
-- 2.교수 테이블에서 송승환교수보다 나중에 입사한 
-- 교수의 이름, 입사일,학과코드,학과명을 출력하기 
SELECT p.name, p.hiredate, p.deptno, m.name
FROM professor p, major m
WHERE p.deptno = m.code
AND p.hiredate > (SELECT hiredate FROM professor WHERE NAME = '송승환')
-- 3.학생 중 2학년 학생의 최대 체중보다 체중이 큰 1학년 학생의 이름, 몸무게, 키를 출력하기
SELECT NAME,weight,height
FROM student
WHERE grade=1 and weight > ALL (SELECT distinct weight FROM student WHERE grade=2)
-- 4.학생테이블에서 전공학과가 101번인 학과의 평균몸무게보다
--   몸무게가 많은 학생들의 이름과 몸무게, 학과명 출력
SELECT s.NAME,s.weight,m.name
FROM student s, major m
WHERE s.major1 = m.code
AND s.weight > (SELECT AVG(weight) FROM student WHERE major1=101)
-- 5.이상미 교수와 같은 입사일에 입사한 교수 중 이영택교수 보다 
--   월급을 적게받는 교수의 이름, 급여, 입사일 출력하기
SELECT p.NAME,p.salary,p.hiredate
FROM professor p, (SELECT NAME, salary, hiredate FROM professor WHERE NAME='이상미') a
WHERE p.hiredate = a.hiredate
AND p.salary < (SELECT salary FROM professor WHERE NAME='이영택')
-- 6.101번 학과 학생들의 평균 몸무게 보다  
--   몸무게가 적은 학생의 학번과,이름과, 학과번호, 몸무게를 출력하기
SELECT studno, NAME, major1, weight
FROM student
WHERE weight < (SELECT AVG(weight) FROM student WHERE major1=101)
-- 7.자신의 학과 학생들의 평균 몸무게 보다 몸무게가 적은 
--   학생의 학번과,이름과, 학과번호, 몸무게를 출력하기
SELECT studno, NAME, major1, weight
FROM student s
WHERE weight < (SELECT AVG(weight) FROM student s2 WHERE s.major1 = s2.major1)
-- 8.학번이 960212학생과 학년이 같고 키는 
--   950115학생보다  큰 학생의 이름, 학년, 키를 출력하기
SELECT name, grade, height
FROM student
WHERE grade = (SELECT grade FROM student WHERE studno=960212)
AND height > (SELECT height FROM student WHERE studno=950115)
-- 9.컴퓨터정보학부에 소속된 모든 학생의 학번,이름, 학과번호, 학과명 출력하기
SELECT s.studno, s.NAME, s.major1, m.name
FROM student s, major m
WHERE s.major1 = m.code
AND s.major1 IN (SELECT CODE FROM major WHERE part = 100)

SELECT s.studno, s.name, s.major1, m.name
FROM student s, major m
WHERE s.major1 = m.code
and major1 IN (SELECT CODE FROM major where part = (SELECT CODE FROM major WHERE NAME='컴퓨터정보학부'))
-- 10.4학년학생 중 키가 제일 작은 학생보다 키가 큰 학생의 학번,이름,키를 출력하기
SELECT studno, NAME, height
FROM student
where height > (SELECT min(height) FROM student WHERE grade=4)
-- 11.학생 중에서 생년월일이 가장 빠른 학생의 학번, 이름, 생년월일을 출력하기
SELECT studno, NAME, birthday
FROM student
WHERE birthday = (SELECT min(birthday) FROM student)
