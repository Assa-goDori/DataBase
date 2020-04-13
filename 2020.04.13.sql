/*
	subquery : where 조건문에 select 구문을 사용할 수 있다.
		단일행 subquery : subquery의 결과가 1개의 레코드인 경우
				연산자 : =, >, <, ...
		복수행 subquery : subquery의 결과가 여러개 레코드인 경우
				연산자 : in, >any, <any, >all, <all, ...
		다중컬럼 subquery : 비교대상이 되는 컬럼이 두개 이상임.
				복수행인 경우 : all, any 사용불가
		상호연관 subquery : 외부query의 컬럼을 내부query에서 참조
				성능 부분이 나쁘다.
		스칼라 subquery : 컬럼부분에 사용되는 subquery
		having 구문 subquery 사용가능
		from 구문 subquery : inline view
				반드시 alias 별명을 설정해야 함
		
	DDL : 데이터 정의어. commit, rollback 사용 불가(transaction 불가)
		create : create table, create index, create user, create datebase, ...
				객체를 생성하는 명령어.
		drop : drop table 테이블명
				객체를 제거하는 명령어.
*/

/*
	alter : 객체(table)의 구조 변경
*/
CREATE TABLE major2 AS SELECT * FROM major
SELECT * FROM major2
--major2 테이블에 loc 컬럼 추가하기
DESC major2
ALTER TABLE major2 ADD loc VARCHAR(100)
--major2 테이블에 loc 컬럼의 크기를 50으로 수정하기
ALTER TABLE major2 MODIFY loc VARCHAR(50)
--major2 테이블에 loc 컬럼의 이름을 area로 변경하기
ALTER TABLE major2 CHANGE loc AREA VARCHAR(50)
--major2 테이블에서 area 컬럼 제거하기
ALTER TABLE major2 DROP AREA
--constraint : 제약조건 -> 기본키, 외래키
--major2 테이블에 기본키 설정하기
ALTER TABLE major2 ADD CONSTRAINT PRIMARY KEY(CODE)

--pointitem 테이블의 no 컬럼을 기본키로 설정하기
DESC pointitem
ALTER TABLE pointitem ADD CONSTRAINT PRIMARY KEY(NO)

--emp 테이블의 deptno 컬럼의 값은 반드시 dept 테이블의 deptno 컬럼의 있는 값만 사용이 가능하도록 설정하기(외래키 설정)
DESC emp
DESC dept
SELECT distinct deptno FROM emp
SELECT DISTINCT deptno FROM dept
ALTER TABLE emp ADD CONSTRAINT FOREIGN KEY(deptno) REFERENCES dept(deptno)

--문제1. dept2 테이블을 deptno, dname 컬럼만 가지도록 데이터는 loc 값이 서울이 아닌 레코드만 선택하여 저장하기
CREATE TABLE dept2 AS SELECT deptno,dname FROM dept WHERE loc != '서울'
--문제2. dept2 테이블에 area 컬럼은 문자형 50 크기로 설정하기
			기본값은 서울로 설정
ALTER TABLE dept2 ADD AREA VARCHAR(50) DEFAULT '서울'
--문제3. dept2 테이블에 deptno 컬럼을 기본키로 설정하기
ALTER TABLE dept2 ADD CONSTRAINT PRIMARY KEY(deptno)
--문제4. dept2 테이블을 제거하기
DROP TABLE dept2

-- major2 테이블에서 name 컬럼을 문자 3자로 변경하기
-- 컬럼의 크기를 줄이는 경우 등록된 데이터의 길이를 허용하는 경우만 처리됨.
ALTER TABLE major2 MODIFY NAME VARCHAR(10)
DESC major2

-- truncate : DDL에 속한 명령어. 데이터를 제거
-- 			commit, rollback이 불가능 => transcation(commit, rollback) 불가함
--				transaction : all or noting(원자화, 업무단위의 transaction이 모두 ok가 되어야함)
--				속도가 빠르다.
-- delete : DML에 속한 명령어. 데이터 제거
--				commit, rollback이 가능 => transaction 처리 됨
--				속도가 느리다.
SELECT * FROM major2
TRUNCATE TABLE major2
-- transaction 처리 설정
SET autocommit=false
INSERT INTO major2 VALUES(1,'공과대학',0,'')
DELETE FROM major2 WHERE CODE=1
ROLLBACK

/*
	DDL 명령어 : create, drop, alter, truncate
	DML 명령어 : 데이터 조작어
		C(create)	: 데이터(레코드, row) 생성 => insert
		R(read)		: 데이터 조회 => select
		U(update)	: 데이터 수정 => update
		D(delete)	: 데이터 삭제 => delete
		commit, rollback 가능 => transaction 처리 가능
*/
-- insert : 데이터 생성, 추가
-- insert into 테이블명 {(컬럼명1, 컬럼명2, ...)} values(값1, 값2, ...)
SELECT * FROM dept
-- deptno=90, dname='특판팀', loc='부산' 값 추가하기
INSERT INTO dept (deptno,dname,loc) VALUES(90,'특판팀','부산')
-- deptno=91, dname='특판1팀', loc='대구'값 추가하기
INSERT INTO dept VALUES(91,'특판1팀','대구')
-- deptno=92, dname='특판2팀' 값 추가하기
INSERT INTO dept (deptno,dname) VALUES(92,'특판2팀')
-- deptno=93, dname='특판3팀' 값 추가하기
INSERT INTO dept VALUES(93, '특판3팀','')
/*
	insert 컬럼부분을 기술하지 않고 insert 구문 사용하기
		1. 테이블에 정의된 모든 컬럼을 테이블의 구조대로 값을 입력
		2. 모든 컬럼의 순서대로 값이 설정됨.
	insert 컬럼부분을 기술하고 insert 구문 사용하기 => 권장
		1. 모든 컬럼에 값이 등록되지 않은 경우
		2. 컬럼의 순서를 모를 때
		3. DB의 구조변경이 자주 발생하는 경우
*/
--교수테이블에서 교수번호:6001, 이름:홍길동, id:hongkd, 급여:300, 입사일:2020-01-01, 직급:초빙교수 값을 가진 레코드 추가하기
INSERT INTO professor (NO, NAME, id, salary, hiredate,position) VALUES(6001,'홍길동','hongkd',300,'2020-01-01','초빙교수')
--교수테이블에서 교수번호:6002, 이름:김삿갓, id:sgkim, 급여:300, 입사일:2020-01-01, 직급:초빙교수 값을 가진 레코드 추가하기
--컬럼명 기술하지 않고 추가하기
INSERT INTO professor VALUES(6002,'김삿갓','sgkim','초빙교수',300,'2020-01-01',NULL,NULL,NULL,null)
DESC professor
SELECT * FROM professor
--교수테이블에서 교수번호:6003, 이름:이몽룡, id:mrlee, 급여:300, 입사일:2020년01월01일, 직급:초빙교수 값을 가진 레코드 추가하기
INSERT INTO professor (NO,NAME,id,salary,hiredate,POSITION) VALUES (6003,'이몽룡','mrlee',300,STR_TO_DATE('2020년01월01일','%Y년%m월%d일'),'초빙교수')

--기존테이블을 이용하여 데이터 추가하기
--major3테이블을 major테이블과 구조는 같고, 데이터는 없도록 테이블 생성하기(where절이 없는경우 모든레코드를 읽어옴. 따라서 where 절에 거짓을 만들어준다)
CREATE TABLE major3 AS SELECT * FROM major WHERE 1 = 2
SELECT * FROM major3
--major 테이블 중 code가 200이상인 데이터만 major3테이블에 데이터 추가하기
INSERT INTO major3 SELECT * FROM major WHERE CODE>=200

--문제1. major10테이블을 major 테이블과 같은 구조로 생성하기. 데이터는 없음
CREATE TABLE major10 AS SELECT * FROM major WHERE 1 = 2
SELECT * FROM major10
--문제2. major10 테이블에 공과대학에 속한 학과 정보만 데이터로 추가하기
INSERT INTO major10 SELECT * FROM major WHERE part in (SELECT CODE FROM major WHERE part IN (SELECT CODE FROM major WHERE NAME = '공과대학'))
--문제3. student1테이블을 student테이블과 같은 구조로, 데이터는 없음으로 생성하기
CREATE TABLE student1 AS SELECT * FROM student WHERE 1= 2
SELECT * FROM student1
--문제4. student1테이블에 1학년 학생 중 평균키 이상인 학생의 학번, 이름, id, 학년, 전공1, 키,주민번호 컬럼만 추가하기
INSERT INTO student1
(studno, NAME, id, grade, major1, height, jumin)
SELECT studno,NAME,id,grade,major1,height,jumin FROM student WHERE grade=1 AND height >= (SELECT AVG(height) FROM student)
--문제5.홍길동 교수와 같은 급여, 같은 직책이고, 오늘 입사한 임꺽정 교수 추가하기.(리터럴 컬럼 이용하기)
--교수번호:6004, 이름:임꺽정, 입사일: 오늘, id = junglim
INSERT INTO professor (NO, NAME, salary, POSITION, hiredate ,id)
SELECT 6004, '임꺽정', salary, POSITION, CURRENT_DATE, 'junglim' FROM professor WHERE NAME = '홍길동'
SELECT * FROM professor

/*
	update : 컬럼의 값 수정하기

	update 테이블명 set 컬럼1=값1, 컬럼2=값2, ...
	[where 조건문] => 없는 경우 : 모든레코드
						=> 있는 경우 : 조건문의 결과가 참인 레코드
*/
-- 사원 중 직급이 사원인 경우 보너스를 10만원 인상하기
-- 보너스가 없는 경우 0으로 처리함.
SELECT * FROM emp WHERE job='사원'
UPDATE emp SET bonus = IFNULL(bonus,0)+10
WHERE job = '사원'
--이상미 교수와 같은 직급의 교수 중 급여가 350 미만인 교수의 급여를 10%인상하기
UPDATE professor SET salary = salary*1.1
WHERE POSITION = (SELECT POSITION FROM professor WHERE NAME='이상미')
AND salary < 350
SELECT * FROM professor WHERE position = '조교수' AND salary<350
--보너스가 없는 시간강사의 보너스를 조교수의 평균보너스의 50%로 변경하기
--단. 평균보너스는 절삭하여 정수로 변경
UPDATE professor SET bonus = (SELECT truncate(AVG(bonus)*0.5,0) FROM professor WHERE POSITION ='조교수')
WHERE POSITION = '시간강사'
AND bonus IS null

/*
	delete : 레코드, row 삭제

	delete from 테이블명
	[where 조건문] => 없는 경우 : 모든레코드 삭제
						=> 있는 경우 : 조건문의 결과가 참인 레코드만 삭제
*/
SELECT * FROM major3
-- major3의 모든 레코드 삭제
delete FROM major3
-- 삭제 취소
ROLLBACK
-- major3테이블에서 코드가 300이상인 레코드 삭제
DELETE FROM major3
WHERE CODE >= 300
--1.student3 테이블을 student와 같은 구조이면서, 3학년 학생의 정보만 저장하는 테이블 생성
CREATE TABLE student3 AS SELECT * FROM student WHERE grade=3
SELECT * FROM student3
--2.student3 테이블에서 1학년 평균키보다 큰 학생의 정보만 제거하기
DELETE FROM student3 WHERE height > (SELECT AVG(height) FROM student WHERE grade=1)


/*
	SQL (Struct Query Language)

	DDL : Date Definition Language(데이터 정의어)
		create, drop, alter, truncate 
	DML : Data Manupulation Language(데이터 조작어)
		insert(C),select(R), update(U), delete(D)
	TCL : Transaction Control Language(트렌젝션 제어어)
		commit, rollback
	DCL : Data Control Language(데이터 제어어)
		grant : 권한 설정
		revoke : 권한 뺏기
*/

/*
	2020.04.13 과제
*/

-- 1. 테이블 test4를 생성하기
--    컬럼은 정수형인 no 가 기본키로 
--      name 문자형 20자리
--      tel 문자형 20 자리
--      addr  문자형 100자리로 기본값을 서울시 금천구로 설정하
CREATE TABLE test4 (
	NO int PRIMARY KEY,
	NAME VARCHAR(20),
	tel VARCHAR(20),
	addr VARCHAR(100) DEFAULT '서울시 금천구'
)
-- 2. 교수 테이블로 부터 101 학과 교수들의 
--    번호, 이름, 학과코드, 급여, 보너스, 직급만을 컬럼으로
--    가지는 professor_101 테이블을 생성하기
CREATE TABLE professor_101 AS SELECT NO,NAME,deptno,salary,bonus,POSITION FROM professor WHERE deptno=101
-- 3. 사원테이블에서 사원번호 3001, 이름:홍길동, 직책:사외이사
--    급여:100,부서:10 입사일:2020년04월01일 인 레코드 추가하기
INSERT emp (empno, ename, job, salary, deptno, hiredate)
VALUES (3001, '홍길동', '사외이사', 100, 10, STR_TO_DATE('2020년04월01일', '%Y년%m월%d일'))
-- 4. 지도교수가 없는 학생의 지도교수를 
--   이용학생의 지도교수로 변경하기
UPDATE student set profno = (SELECT profno FROM student WHERE NAME='이용')
WHERE profno IS null
-- 5. 교수중 홍길동과 같은 직급의 교수의 급여를 101학과의 평균급여로
--    변경하기. 단 소숫점이하는 반올림하기.
UPDATE professor SET salary = (SELECT round(AVG(salary)) FROM professor WHERE deptno = 101)
WHERE POSITION = (SELECT POSITION FROM professor WHERE NAME = '홍길동')
-- 6. 교수 테이블에서 홍길동교수와 같은 직급의 교수를 퇴직시키기
DELETE FROM professor
WHERE POSITION = (SELECT POSITION FROM professor WHERE NAME = '홍길동')
