DESC dept

/*
   select * || 컬럼명1,컬럼명2,.. from 테이블명
	[ where 조건문]    => 조건문 있으면 조건문의 결과가 참인 row만 선택
	                   => 조건문 없으면 모든 row 선택
   사원 테이블(emp) 의 모든 컬럼과 모든 레코드 조회하기
*/
SELECT * FROM emp
-- 부서테이블(dept) 의 모든 컬럼과 모든 레코드 조회하기
SELECT * FROM dept

-- emp 테이블에서 모든 레코드의
-- 사원번호(empno),사원이름(ename),직급(job) 컬럼을 조회하기
SELECT empno,ename,job FROM emp
-- emp 테이블에서 deptno 컬럼의 값이 20인 부서의
-- 사원번호(empno),사원이름(ename),직급(job)  컬럼을 조회하기
SELECT empno,ename,job,deptno FROM emp
WHERE deptno = 20

/*  컬럼에 리터널 문자 사용하기
    리터널 문자 : 상수값.
*/
SELECT empno,ename,'사원' FROM emp

/*
1.교수테이블(professor) 에서 교수번호(no), 교수이름(name), '교수' 컬럼 출력하기
2.학생테이블(student) 에서 학번(studno),학생이름(name), '학생' 컬럼 출력하기
3.학과테이블(major)에서 학과번호(code),학과명(name),'학과' 컬럼 출력하기
*/
SELECT NO, NAME, '교수' FROM professor
SELECT studno,NAME, '학생' FROM student
SELECT CODE, NAME, '학과' FROM major

/*
  컬럼명에 별명(alias) 주기 : 조회된 컬럼명을 변경하기
*/
SELECT NO 교수번호 , NAME 교수이름 FROM professor
SELECT NO '교수 번호' , NAME "교수 이름" FROM professor
SELECT NO AS "교수 번호" , NAME AS "교수 이름" FROM professor

/*
  컬럼의 값을 연산하여 사용하기 : 변경된 컬럼의 값을 조회
*/
-- 사원테이블(emp)에서 사원번호(empno), 사원이름(ename),현재급여(salary),
--  10%인상예정급여 출력하기
SELECT  empno, ename, salary, salary*1.1 FROM emp

/*
  1. 교수테이블(professor)에서 교수번호(no),교수이름(name), 현재급여(salary),
     5%인상예정급여 출력하기
  2. 교수테이블에서 교수번호,교수이름, 연봉조회하기
     연봉 : 급여 *12로 한다.   
*/
SELECT NO,NAME,salary, salary * 1.05   FROM professor
SELECT NO,NAME,salary*12 FROM professor

/*
   distinct : 중복 제거. 조회시 성능이 좋지 않다.
            select 다음에 한번만 사용이 가능함.
*/
-- 교수가 속한 부서코드를 조회하기
SELECT distinct deptno FROM professor
-- 교수의 직급(position)을 조회하기
SELECT distinct POSITION FROM professor
-- 교수의 부서별 직급 조회하기
SELECT distinct deptno, POSITION FROM professor

-- where 조건문 : 레코드 선택하는 조건.
--            where 조건문이 없는 경우는 모든레코드를 조회
--            where 조건문이 있는 경우는 조건문의 결과가 참인 레코드만  조회
--
-- 학생테이블(student)중 학년(grade)이 1학년인 학생의 모든 컬럼을 조회하기
SELECT * FROM student WHERE grade = 1
-- 학생테이블(student)중 학년(grade)이 2학년인 학생의 
-- 학번(studno),이름(name), 학년(grade),전공1코드(major1) 컬럼을 
-- 조회하기
SELECT studno,NAME,grade, major1 FROM student
WHERE grade = 2
-- 3학년 학생 중 전공1코드가 101학과인 학생의 학번,이름,학년,전공1코드
-- 조회하기
SELECT studno,NAME,grade, major1 FROM student
WHERE grade = 3 AND major1 = 101
-- 3학년 학생 이거나 전공1코드가 101학과인 학생의 학번,이름,학년,전공1코드
-- 조회하기
SELECT studno,NAME,grade, major1 FROM student
WHERE grade = 3 or major1 = 101

-- 1. emp 테이블에서 부서코드가 10인 사원의 
--    이름,급여,부서코드 조회하기
-- 2. emp 테이블에서 급여가 800보다 큰사람의 이름,급여,부서코드 조회하기
SELECT ename,salary, deptno FROM emp
WHERE deptno=10
SELECT ename,salary, deptno FROM emp
WHERE salary > 800

-- 3. professor 테이블에서 직급(position)이 정교수인 교수의
--    이름(name), 부서코드(deptno), 직급(position)을 조회하기
SELECT NAME,deptno,POSITION FROM professor
WHERE POSITION='정교수'

-- emp 테이블에서 모든 사원의 급여를 10%인상할 때 인상예정급여가 1000 이상인
-- 사원의 이름, 현재급여, 인상예정급여, 부서코드 조회하기
SELECT ename, salary,salary*1.1, deptno FROM emp
WHERE salary*1.1 >=950

/*
   where 조건문에서 사용되는 연산자.
   between 연산자
   where 컬럼명 between A and B : 
=>  where 컬럼명 >= A and 컬럼명 <= B : 
*/
-- 1학년, 2학년 학생의 모든 컬럼 조회하기
SELECT * FROM student WHERE grade = 1 OR grade = 2
SELECT * FROM student WHERE grade between 1 and 2
SELECT * FROM student WHERE grade >= 1 and grade <= 2

/*
  문제 1 : 1학년 학생 중 몸무게가 70이상 80이하인 학생의 
           이름,학년,몸무게,전공학과1 조회하기
  문제2 : 전공학과1이 101인 학생 중 키가 160이상 180이하인 학생의
          이름, 학년,키,전공학과1 조회하기         
*/
SELECT NAME,grade,weight,major1 FROM student
WHERE grade = 1 AND weight between 70 AND 80

SELECT NAME,grade,weight,major1 FROM student
WHERE grade = 1 AND weight >=70 AND weight <= 80

SELECT NAME,grade, height, major1 FROM student
WHERE major1 = 101 AND height BETWEEN 160 AND 180
SELECT NAME,grade, height, major1 FROM student
WHERE major1 = 101 AND height >= 160  AND height <= 180

/*
   in 연산자 : or 조건문을 여러개 나열가능
*/
-- 전공학과1가 101, 201인 학과의 학생을 조회하기
SELECT * FROM student WHERE major1 = 101 OR major1 = 201
SELECT * FROM student WHERE major1 IN (101, 201)

/*
  문제1 : 교수 중 학과코드가 101,201 학과에 속한 교수의 교수번호(no),
          교수이름(name),학과코드(deptno), 입사일(hiredate)
*/
SELECT NO,NAME,deptno,hiredate FROM professor
WHERE deptno IN (101,201)
SELECT NO,NAME,deptno,hiredate FROM professor
WHERE deptno =101 or deptno = 201

/*
   like 연산자 :포함하는 문자열 검색
     % : 0개이상의 임의의 문자 의미
     _ : 1개의 임의의 문자 의미
*/
-- 학생 중 성이 김씨인 학생의 이름과 전공코드 출력하기
SELECT NAME,major1 FROM student
WHERE NAME LIKE '김%'
-- 학생 중 이름에 '진'자가 있는  학생의 이름과 전공코드 출력하기
SELECT NAME,major1 FROM student
WHERE NAME LIKE '%진%'
--학생 중 이름이 2자인 학생의 이름과 학년 전공코드1 출력하기
SELECT NAME,grade,major1 FROM student
WHERE NAME LIKE "__"

/*
  1.학생의 이름이 '훈'자로 끝나는 학생의 이름과, 학년, 전공코드1 출력하기
  2.학생의 전화번호가 서울지역(02)인 학생의 이름, 학번,전화번호 출력하기
*/
SELECT NAME, grade,major1 FROM student
WHERE NAME LIKE "%훈"
SELECT NAME, studno, tel FROM student
WHERE tel like "02%"

-- 대소문자 구분 안됨(오라클 구분됨.)
-- 교수테이블에서 id 컬럼에 k문자를 가진 교수의 이름,id, 직책 조회하기
SELECT NAME,id, POSITION FROM professor
WHERE id LIKE '%K%'

-- 대소문자 구분이 필요한 경우 : binary 예약어 사용함
SELECT NAME,id, POSITION FROM professor
WHERE id LIKE binary '%k%'

/*
  not like 
*/
-- 학생 중 김씨가 아닌 학생의 학번, 이름, 학년, 전공코드1 출력하기
SELECT studno,NAME,grade,major1 FROM student
WHERE NAME not LIKE '김%'

/*
  is null, is not null
  
  NULL 의 의미는 값이 없다.
  => 연산 또는 비교의 대상이 아니다.
     null값과 연산 후의 결과는 null임
*/
SELECT * FROM professor
WHERE bonus is NULL

-- 교수의 이름과, 급여,보너스, 급여+보너스 조회하기
SELECT NAME, salary,bonus, salary+bonus FROM professor

--1. 교수 중 보너스가 있는 교수의 이름,급여, 보너스 출력하기
SELECT NAME,salary,bonus FROM professor
WHERE bonus IS NOT NULL
--2. 교수 중 보너스가 있는 교수의 이름,급여, 보너스, 연봉 출력하기
-- 연봉 : 급여 * 12 + bonus임
SELECT NAME,salary,bonus, salary * 12 + bonus 연봉  FROM professor
WHERE bonus IS NOT NULL

/*
  select 컬럼명 || *  
    from 테이블명 || 뷰명
  [ where 조건문 ]
  [ order by 컬럼명]  => 정렬 표시
*/
/*
  order by :정렬(sort)하기
  오름차순 : asc 기본정렬방식 생략가능
  내림차순 : desc
  
  select 구문의 가장 나중에 기술되어야함.
*/
-- 1학년 학생의 이름과 키를 조회하기. 단 키가 큰순으로 조회하기
SELECT NAME, height FROM student WHERE grade = 1
ORDER BY height DESC
SELECT NAME, height FROM student WHERE grade = 1
ORDER BY 2 DESC
SELECT NAME 이름, height 키 FROM student WHERE grade = 1
ORDER BY 키 DESC

-- 문제 1
--  emp 테이블에서 사원이름, 현재급여, 인상예상급여를 조회하기
--    인상예상급여: 현재급여의 10% 인상된 급여
--    인상예상급여의 내림차순으로 조회하기

SELECT ename, salary, salary*1.1 FROM emp
ORDER BY salary*1.1 DESC
SELECT ename, salary, salary*1.1 FROM emp
ORDER BY 3 DESC
SELECT ename, salary, salary*1.1 인상급여 FROM emp
ORDER BY 인상급여 DESC

--  emp 테이블에서 사원이름, 현재급여, 인상예상급여를 조회하기
--    인상예상급여: 현재급여의 10% 인상된 급여
--    인상예상급여의 내림차순으로 이름의 오름차순  조회하기
SELECT ename, salary, salary*1.1 FROM emp
ORDER BY salary*1.1 DESC,ename

-- 학생의 이름, 학년,키를 학년순, 키가 큰순으로 조회하기
-- 학생의 이름, 전공1 ,키를 전공1순, 키가 작은순으로 조회하기
SELECT NAME,grade,height FROM student ORDER BY grade,height DESC
SELECT NAME, major1, height FROM student ORDER BY major1, height
SELECT NAME, major1, height FROM student ORDER BY height,major1

--1. 교수테이블에서 교수번호,교수이름,학과코드,급여,예상급여(10%인상)
--   를 학과코드순으로 예상급여의 역순으로 조회하기
SELECT NO,NAME,deptno,salary, salary * 1.1 FROM professor
ORDER BY deptno, 5 DESC
SELECT NO,NAME,deptno,salary, salary * 1.1 FROM professor
ORDER BY deptno, salary * 1.1 DESC
SELECT NO,NAME,deptno,salary, salary * 1.1 인상급여  FROM professor
ORDER BY deptno, 인상급여 DESC
--2. 학생테이블에서 지도교수(profno)가 배정되지 않은 학생의 학번, 이름,
--   지도교수번호, 전공1코드를 출력하기. 전공1코드순으로 정렬하기
SELECT studno,NAME,profno,major1 
  FROM student
WHERE profno IS NULL
ORDER BY major1
-- 3. 1학년 학생의 이름,키,몸무게 출력하기
--    키는 작은순으로 몸무게는 큰순으로 출력하기
SELECT NAME,height,weight FROM student
WHERE grade = 1
ORDER BY height, weight DESC

/*
  합집합 : union, union all
    union : 합집합. 중복 내용 제거
    union all : 두개 select의 결과가 합하여 출력됨. 중복제거 안됨
    
  - 조회되는 컬럼의 갯수가 같아야 한다.  
*/
-- 전공1학과가 202 학과이거나, 전공2학과가 101인 학생의 학번,이름,전공1,전공2
-- 출력하기
SELECT studno,NAME,major1,major2 FROM student
WHERE major1 = 202 OR major2 = 101
-- union 방식
SELECT studno,NAME,major1,major2 FROM student
WHERE major1 = 202
union
SELECT studno,NAME,major1,major2 FROM student
WHERE  major2 = 101
-- union all 방식
SELECT studno,NAME,major1,major2 FROM student
WHERE major1 = 202
UNION all
SELECT studno,NAME,major1,major2 FROM student
WHERE  major2 = 101

-- 학생 중 전공1학과가 101번학과인 학생의 학번,이름,전공1코드를조회하고
-- 교수 중 학과코드가 101번 학과인 교수의 교수번호,이름, 학과코드 조회하기
SELECT studno,NAME,major1,'학생' 구분 FROM student
WHERE major1 = 101
UNION
SELECT NO,NAME,deptno,'교수' FROM professor
WHERE deptno = 101
ORDER BY NAME

--1. 교수 중 급여가 450이상인 경우는 5%인상예정이고, 450 미만인 경우는 10인상예정
-- 이다. 교수번호,교수이름,현재급여, 인상예정급여 조회하기
--2. 교수 중 보너스가 있는 교수의 연봉은 급여*12+보너스이고,
--   보너스가 없는 교수의 연봉은 급여*12로한다.
--  교수번호,교수이름,급여,보너스,연봉을 조회하기
--  연봉순으로 정렬하기

SELECT NO,NAME,salary, salary*1.05 인상예정급여 FROM professor
WHERE salary >= 450
union
SELECT NO,NAME,salary, salary*1.1  FROM professor
WHERE salary < 450

SELECT NO,NAME,salary,bonus, salary*12+bonus 연봉 FROM professor
WHERE bonus IS NOT NULL
union
SELECT NO,NAME,salary,bonus, salary*12 FROM professor
WHERE bonus IS  NULL
ORDER BY 연봉
-- 학생 중 생일이 1997-11-3인 학생의 정보 조회하기
SELECT * FROM student
WHERE birthday = '1997-11-03'

/*
	2020.04.06 과제
*/

--1. emp 테이블에서 empno는 사원번호로, ename 사원명, job는 직급으로 별칭을 설정하여  조회하기 
SELECT empno 사원번호, ename 사원명, job 직급 FROM emp

--2. dept 테이블에서 deptno 부서#, dname 부서명, loc 부서위치로 별칭을 설정하여 조회하기 
SELECT deptno '부서#', dname 부서명, loc 부서위치 from dept

--3. 학생을 담당하는 지도교수번호를 조회하기 
SELECT DISTINCT profno FROM student WHERE profno IS NOT NULL

--4. 현재 교수들에게 설정된 직급을 조회하기 
SELECT distinct position FROM professor

--5. 학생테이블에서 name, birthday,height,weight 컬럼을 조회하기 
--   단 name은 이름, birthday는 생년월일 ,height 키(cm),weight 몸무게(kg) 으로 변경하여 조회하기 
SELECT NAME 이름, birthday 생년월일, height '키(cm)', weight '몸무게(kg)' FROM student

--6. 전공1이 101번,201 학과의 학생 중 몸무게가 50이상 80이하인 학생의 
--    이름(name), 몸무게(weight), 학과코드(major1)를 조회하기 
SELECT NAME,weight,major1 FROM student WHERE major1 IN(101,201) AND weight BETWEEN 50 AND 80

--7. 사원의 급여가 700이상인 사원들만 급여를 5% 인상하기로 한다.
--    인상되는 사원의 이름, 현재급여, 예상인상급여, 부서코드 출력하기
SELECT ename,salary, salary*1.05 예상인상급여, deptno FROM emp WHERE salary>=700

--8. 학생테이블에서 생일이 1998년 6월 30일 이후에 출생한 학생 중 
--  1학년 학생인, 이름(name), 전공코드(major1), 생일(birthday), 학년(grade) 컬럼 조회하기
--  날짜 표시는 '1998-06-30' 한다.
 SELECT NAME,major1,birthday,grade FROM student WHERE birthday > '1998-06-30' AND grade = 1

--9. 학생테이블에서 생일이 1998년 6월 30일 이후에 출생한 학생 이거나, 1학년 학생인 학생의
-- 이름(name), 전공코드(major1), 생일(birthday), 학년(grade) 컬럼 조회하기
-- 날짜 표시는 '1998-06-30' 한다.
SELECT NAME,major1,birthday,grade FROM student where birthday > '1998-06-30' OR grade =1

--10. 전공학과 101이거나 201인학과 학생 중 키가 170이상인 
--    학생의 학번, 이름, 몸무게, 키, 학과코드  조회하기
SELECT studno,NAME,weight,height,major1 FROM student WHERE major1 IN(101,201) AND height>=170

--11.학생 테이블에 1학년 학생의 이름과 주민번호, 기준생일, 키와 몸무게를 출력하기. 
--    단 생일이 빠른 순서대로 정렬
SELECT NAME,jumin,birthday,height,weight FROM student WHERE grade=1 ORDER BY birthday

-- 12. 교수테이블(professor)급여가 300 이상이면서 보너스(bonus)을 받거나 
-- 급여가 450 이상인 교수 이름, 급여, 보너스을 출력하여라.
SELECT NAME,salary,bonus FROM professor WHERE (salary>=300 AND bonus IS NOT NULL) OR salary >= 450

-- 13. 학생 중 전화번호가 서울지역이 아닌 학생의 학번, 이름, 학년, 전화번호를 출력하기  
-- 단 학년 순으로 정렬하기
SELECT studno,NAME,grade,tel FROM student WHERE tel NOT LIKE '02%'

-- 14. 학생 테이블에서 id에 kim 이 있는 학생의 학번, 이름, 학년, id 를 출력하기.  
--    단 kim은 대소문자를 구분하지 않는다.
SELECT studno,NAME,grade,id FROM student WHERE id LIKE '%kim%'

-- 15. 교수테이블에서 보너스가 없는 교수의 교수번호, 이름, 급여, 10% 인상급여를 출력하고
--    보너스가 있는 교수는 의 급여는 인상되지 않도록 인상 예상급여를 출력하기
--    단 인상급여의 내림차순으로 정렬하기
SELECT NO,NAME,salary,salary*1.1 인상급여 FROM professor WHERE bonus IS NULL
UNION
SELECT NO,NAME,salary,salary*1 FROM professor WHERE bonus IS NOT NULL ORDER BY 인상급여 desc

--16. 학생 중 이름의 끝자가 '훈'인 학생의 학번, 이름, 전공1코드 조회하기. 학년 순으로 정렬하기
SELECT studno,NAME,major1 FROM student WHERE NAME LIKE '%훈' ORDER BY grade
