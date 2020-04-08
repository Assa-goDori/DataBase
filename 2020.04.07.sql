/*
	1. 테이블의 구조 : desc
	2. 테이블의 내용 조회 : select
	select 컬럼명1, 컬럼명2, ... || *
	from 테이블명 
	[where 조건문] : 레코드의 선택 기준.
	[group by 컬럼명]
	[having 조건문] : 그룹선택 기준. 반드시 group by와 함께 사용됨 
	[order by 컬럼명] : 정렬 설정 
	 
	3. 컬럼 
	   리터널 컬럼 : 상수 컬럼 
	   벌명 설정(alias)
	   연산자 사용 가능 
	   중복 제거 : distinct
	4. where 조건문 
	   관계연산자(>,<,=,>=,<= ...)
	   논리연산자(and, or)
	   컬럼명 between A and B
	   in : 값 여러개를 or 조건으로 설정 
	   like, not like
	   	% : 0개이상의 임의의 문자 
	   	_ : 1개의 임의의 문자 
	   is null, is not null
			null은 값이 없기 때문에 연산이 불가능함.
	5. order by : 정렬 설정 
		select 구문의 마지막에 기술되어야 한다.
		오름차순 정렬 : asc (기본값 생략 가능)
		내림차순 : desc
		order by 컬럼1, 컬럼2 => 컬럼1 1차정렬, 컬럼2 2차정렬 
	6. 집합연산자 :
		union : 합집합 
		union all : 합집합 중복 제거 안됨. 단순 결과 연결하여 조회 
			=> 두개의 select 구문의 조회되는 컬럼의 수가 같아야 한다.
*/

/*
	함수 
		단일행 함수 : 하나의 레코드에서만 사용되는 함수 
		그룹 함수 : 여러행에 관련된 기능을 처리하는 함수 
						group by, having 절과 관련있는 함수 
*/
/*
	단일행 함수 : 문자관련 함수 
	1. 대소문자 변환 함수 : upper,lower
*/
--학생의 전공학과1이 101학과인 학생의 이름, id, 대문자id, 소문자id 조회하기 
SELECT NAME,id,UPPER(id),LOWER(id) FROM student WHERE major1=101

--문자열의 길이 함수 : length, char_length
--length : 문자열의 byte수 리턴(영문 1바이트, 한글 3바이트)
--char_length : 문자열 갯수 리턴 

--학생의 이름,아이디,이름글자수,이름바이트수 조회하기 
SELECT NAME,id,CHAR_LENGTH(NAME),LENGTH(NAME),CHAR_LENGTH(id),LENGTH(id) FROM student

--문자열 연결 함수 : concat()
--교수의 이름과 직급을 연결하여 조회하기 
SELECT NAME,POSITION FROM professor
SELECT CONCAT(NAME,POSITION,"님") 교수목록  FROM professor

--문제1
--학생 정보를 다음 예와 같이 조회하기 
--홍길동1학년 150cm 50kg
SELECT CONCAT(NAME,grade,"학년 ",height,"cm ",weight,"kg") 학생정보 FROM student

-- 부분 문자열 : substr, left, right
-- substr(컬럼명, 시작index, 글자수)
-- left(컬럼명, 글자수)
-- right(컬럼명, 글자수)
-- 학생의 이름만 조회하기.
SELECT RIGHT(NAME, 2) FROM student

-- 학생의 이름과 주민번호기준 생일부분 조회하기.
SELECT NAME, left(jumin,6) 생년월일 FROM student
SELECT NAME, concat(SUBSTR(jumin, 1, 6),"-",SUBSTR(jumin,7,1),"******") 생년월일 FROM student
--1. 학생 중 생일이 3월인 학생의 이름과 생년월일 출력하기
--생일은 주민번호 기준으로 한다.
SELECT NAME, SUBSTR(jumin,1,6) FROM student WHERE SUBSTR(jumin,4,1)=3
--2. 학생의 이름, 생년월일을 99년 02월 20일의 형식으로 출력하고, 학년 출력하기
--생년월일은 주민번호 기준
--월을 기준으로 정렬하기
SELECT NAME, concat(SUBSTR(jumin,1,2), "년 ", SUBSTR(jumin,3,2),"월 ",SUBSTR(jumin,5,2),"일") 생년월일, grade FROM student ORDER BY SUBSTR(jumin,3,2)

--문자열에서 문자의 위치 : instr
--instr(칼럼,문자) : 컬럼의 값에서 문자의 위치(인덱스) 리턴
--학생의 이름, 전화번호, )문자의 위치 조회
SELECT NAME, tel, INSTR(tel, ')') FROM student

--문제1
--학생의 이름, 전화번호, 지역번호 출력하기
--지역번호 전화번호에서 02, 032 등)앞의 문자를 의미
SELECT NAME,tel,SUBSTR(tel,1,INSTR(tel,')')-1) 지역번호 FROM student
--문제2
--교수의 이름, url, homepage 출력하기
--homepage는 url에서 http:// 이후의 문자열을 의미
SELECT NAME,url,SUBSTR(url,INSTR(url,'/')+2) homepage FROM professor

-- 문자 추가 함수 : lpad, rpad
-- lpad : 왼쪽에 문자 추가. lpad(컬럼명, 전체자리수, 문자)
-- rpad : 오른쪽에 문자 추가. rpad(컬럼명, 전체자리수, 문자)

--학생의 학번, 이름 출력하기. 학번은 10자리로 빈자리는 오른쪽에 *로 채워 출력하기
SELECT rpad(studno, 10,'*'), NAME FROM student
--학생의 학번, 이름 id를 출력하기. 학번은 10자리로 출력, 빈자리는 오른쪽에 *로 출력.
--id는 20자리로 왼쪽에 $로 출력.
SELECT rpad(studno,10,'*'), NAME, LPAD(id, 20, '$') FROM student

-- 문자 제거 함수: trim, rtrim, ltrim
-- 왼쪽 공백 제거 :
SELECT CONCAT("***",LTRIM("       왼쪽 공백 제거       "),"***")
SELECT CONCAT("***",RTRIM("       오른쪽 공백 제거       "),"***")
SELECT CONCAT("***",TRIM("       양쪽 공백 제거       "),"***")
-- 000120000056700000 문자의 양쪽 0을 제거하기
SELECT TRIM(BOTH '0' FROM '000120000056700000')
-- 000120000056700000 문자의 오른쪽 0을 제거하기
SELECT TRIM(TRAILING '0' FROM '000120000056700000')
-- 000120000056700000 문자의 왼쪽 0을 제거하기
SELECT TRIM(LEADING '0' FROM '000120000056700000')

--교수 테이블에서 url 컬럼에서 http://가 제거된 homepage 컬럼 출력하기
SELECT TRIM(LEADING 'http://' FROM url) homepage FROM professor

--문자 치환 함수 : replace
--replace(컬럼명, "문자1", "문자2") => 컬럼에서 문자1을 문자2로 변경
-- 학생의 이름을 성부분의 한개의 글자만 #으로 출력하기
SELECT REPLACE(NAME, LEFT(NAME,1), "#") FROM student

--문제 1
--101 학과 학생의 이름과 주민번호 출력하기
--단 주민번호는 뒤 6자리는 *로 출력하기
SELECT NAME, REPLACE(jumin, RIGHT(jumin,6), "******") FROM student WHERE major1 = 101

-- 그룹 문자열에서 위치 검색
-- find_in_set (문자열, 문자열 그룹) : , 나누어진 그룹 문자열에서 문자열의 위치 리턴
SELECT FIND_IN_SET('y', 'x,y,z')
SELECT FIND_IN_SET('이', '김,홍,이,박')
--문제1
-- 학생의 학번, 이름, id를 출력하기
-- id 첫문자는 대문자로 나머지는 소문자로 출력하기
-- id 순으로 정렬하여 출력하기
SELECT studno, NAME, CONCAT(UPPER(LEFT(id,1)), lower(SUBSTR(id,2,CHAR_LENGTH(id)))) ID FROM student
--문제2
--학생의 id 길이가 7개이상 10개이하인 id를 가진 학생의 학번,이름,id, id의 글자수 출력
SELECT studno, NAME, id, CHAR_LENGTH(id) id글자수 FROM student WHERE CHAR_LENGTH(id) BETWEEN 7 AND 10

/*
	숫자 관련 함수
	반올림함수 
		round(숫자) : 소수점 제거
		round(숫자1, 숫자2) : 숫자1을 소수점 이하 숫자2+1에서 반올림
									 숫자1을 소수점이하 숫자2만큼 출력
									 -1 : 소수점이상 1의자리에서 반올림
*/
SELECT ROUND(12.3456, -1) r1, ROUND(12.3456) r2, ROUND(12.3456,0) r3,
		 ROUND(12.3456, 1) r4, ROUND(12.3456, 2) r5, ROUND(12.3456, 3) r6
/*
	버림함수
		truncate(숫자1, 숫자2) : 숫자1을 소수점 이하 숫자2만큼 출력
*/
SELECT TRUNCATE(12.3456, -1) r1, truncate(12.3456,0) r2,
		 truncate(12.3456, 1) r3, truncate(12.3456, 2) r4, truncate(12.3456, 3) r5

-- 교수의 급여를 15%인상하여 정수로 출력. 교수 이름, 현재급여, 반올림예상급여,절삭된예상급여 출력
SELECT NAME,salary, ROUND(salary*1.15) 반올림예상급여 ,TRUNCATE(salary*1.15,0) 절삭된예상급여 FROM professor

SELECT * FROM score
--1. score 테이블에서 학번,국어,수학,영어점수 총점&평균 출력하기
-- 단, 평균은 소수점 이하 2자리까지 반올림해서 출력
-- 총점의 내림차순으로 정렬 
SELECT studno,kor,math,eng,(kor+math+eng) 총점, ROUND((kor+math+eng)/3,2) 평균 from score ORDER BY 총점 DESC
SELECT *,(kor+math+eng) 총점, ROUND((kor+math+eng)/3,2) 평균 from score ORDER BY 총점 DESC

/*
	근사정수 :
		ceil : 큰 근사 정수
		floor : 작은 근사 정수
*/
SELECT CEIL(12.3456), FLOOR(12.3456), CEIL(-12.3456), FLOOR(-12.3456)
/*
	나머지 함수 : mod
	제곱함수 : power
*/
SELECT MOD(21,8), POWER(3,3)

/*
	날짜 관련 함수
		현재 날짜 : now(), curdate(), current_date, current_date()
*/
SELECT now(), curdate(), current_date, CURRENT_DATE()
SELECT CURDATE()+0
-- 날짜 사이의 일자 수 계산 : datediff()
SELECT NOW(), '2020-01-01', DATEDIFF(NOW(), '2020-01-01')

--학생의 이름과 생일, 학생의 생일부터 현재까지의 일수 출력하기
SELECT NAME,birthday,DATEDIFF(NOW(), birthday) FROM student
SELECT datediff(NOW(), '1993-04-30')

--학생 중 생일이 1996년 이후에 태어난 학생의 이름과 생일 출력하기
SELECT NAME, birthday FROM student WHERE birthday >= '1996-01-01'

--1.학생의 이름과 생일, 현재까지의 개월수와 나이를 출력하기
--개월수는 일수/30으로 계산, 나이는 일수/365로 계산
--개월수와 나이는 반올림하여 정수로 출력하기
SELECT NAME, birthday, round(DATEDIFF(NOW(), birthday)/30) 개월수, ROUND(DATEDIFF(NOW(), birthday)/365) 나이 FROM student
--2. 교수의 이름과 직급, 입사일(hiredate), 입사개월수, 입사년수 출력하기
--입사개월수는 일수/30, 입사년수 일수/365 계산
--입사개월수와 입사년수는 절삭해서 정수로 출력
SELECT NAME,POSITION,hiredate, truncate(DATEDIFF(NOW(), hiredate)/30,0) 입사개월수, truncate(DATEDIFF(NOW(), hiredate)/365, 0) 입사년수 FROM professor
/*
	year : 날짜의 연도
	month : 월
	day : 일
	weekday : 요일, 0:월요일 ~ 6:일요일
	dayofweek : 요일, 1:일요일 ~ 7:토요일
	week : 일년 기준 몇번째 주
	last_day : 해당월의 마지막 날짜
*/
SELECT YEAR(NOW()), MONTH(NOW()), DAY(NOW()),
		 WEEKDAY(NOW()),DAYOFWEEK(NOW()),
		 week(NOW()),LAST_DAY(NOW())
		 
--1. 교수이름, 입사일, 입사년도의 휴가 보상일, 올해의 휴가보상일
--휴가보상일 : 입사월의 마지막 일자
SELECT NAME, hiredate, LAST_DAY(hiredate) 휴가보상일, LAST_DAY(concat(year(NOW()),"-",MONTH(hiredate),"-",DAY(hiredate))) 올해휴가보상일  FROM professor
SELECT NAME, hiredate, LAST_DAY(hiredate) 휴가보상일, CONCAT(YEAR(NOW()),"-",LPAD(MONTH(hiredate),2,'0'),"-",DAY(LAST_DAY(hiredate))) 올해휴가보상일 FROM professor
--2. 교수테이블에서 입사일 1~3월인 교수의 급여를 15% 인상예정임.
--인상예정급여는 정수로 출력하기 
--교수의 이름, 현재급여,반올림인상급여, 절삭인상급여, 급여소급일 출력
--급여소급일 올해의 입사월의 마지막날
SELECT NAME,salary,round(salary*1.15) 반올림인상급여, TRUNCATE(salary*1.15,0) 절삭인상급여,
LAST_DAY(concat(year(NOW()),"-",MONTH(hiredate),"-01")) 급여소급일
FROM professor
WHERE MONTH(hiredate) BETWEEN 1 AND 3

/*
	기준 일자부터 이전/이후 날짜 리턴
	date_add : 기준일 이후 
	date_sub : 기준일 이전
*/
-- 현재시간 기준 1일 이후 날짜
SELECT NOW(), date_add(NOW(), INTERVAL 1 DAY)
-- 현재시간 기준 1일 이전 날짜 
SELECT NOW(), DATE_SUB(NOW(), INTERVAL 1 DAY)
-- 현재시간 기준 1시간 이후 날짜 
SELECT NOW(), date_add(NOW(), INTERVAL 1 HOUR)
-- 현재시간 기준 3시간 이전 날짜 
SELECT NOW(), date_sub(NOW(), INTERVAL 3 HOUR)
-- 현재시간 기준 1분 이후 날짜
SELECT NOW(), date_add(NOW(), INTERVAL 1 MINUTE)
-- 현재시간 기준 1초 이후 날짜
SELECT NOW(), date_add(NOW(), INTERVAL 1 SECOND)
-- 현재시간 기준 1달 이후 날짜 
SELECT NOW(), date_add(NOW(), INTERVAL 1 MONTH)
-- 현재시간 기준 1년 이후 날짜
SELECT NOW(), date_add(NOW(), INTERVAL 1 YEAR)

--문제1. 현재기준 10일 이후의 일자의 해당월의 마지막 일자,
--			현재기준 20일 이전의 일자의 해당월의 마지막 일자 출력.
SELECT LAST_DAY(DATE_ADD(NOW(), INTERVAL 10 DAY))
SELECT LAST_DAY(DATE_SUB(NOW(), INTERVAL 20 DAY))
--문제2.
--교수의 정식 입사일은 입사일의 3개월 이후이다.
--교수번호, 이름, 입사일, 정식입사일 조회하기
SELECT no, NAME, hiredate, date_add(hiredate, INTERVAL 3 MONTH) 정식입사일 FROM professor
--문제3.
--사원(emp)테이블에서 사원의 정식입사일은 입사일의 2개월 이후 다음달 1일로 한다.
--사원번호, 이름, 입사일,정식입사일 출력하기
SELECT empno, ename, hiredate, date_add(last_day(DATE_ADD(hiredate, INTERVAL 2 MONTH)), INTERVAL 1 DAY) 정식입사일 FROM emp

/*
	변환 함수
	날짜를 문자열로 변환 : date_format
	문자를 날짜로 변환 : str_to_date
	%Y : 4자리 년도
	%m : 2자리 월
	%d : 2자리 일
	%h : 1~12 시
	%H : 0~23 시
	%i : 분
	%s : 초
	%a : 약자 요일(Mon, Tue, Thu, Wed ..)
	%W : 요일
	%p : AM/PM
*/
SELECT NOW(),
	DATE_FORMAT(NOW(),"%Y년%m월%d일 %H:%i:%s"),
	DATE_FORMAT(NOW(),"%Y년%m월%d일 %h:%i:%s %p"),
	DATE_FORMAT(NOW(),"%Y년%m월%d일 %h:%i:%s %W"),
	DATE_FORMAT(NOW(),"%Y년%m월%d일 %h:%i:%s %a")
SELECT STR_TO_DATE('20200407','%Y%m%d'),
		last_day(STR_TO_DATE('20200407','%Y%m%d'))
-- 20200407문자열을 2020년 04월 07일 형태로 출력하기
SELECT date_format(STR_TO_DATE('20200407', '%Y%m%d'), "%Y년%m월%d일%W")

/*
2020-04-07 과제
*/
--1. 교수 중 교수의 성이 ㅈ이 포함된 교수의 이름을 출력하기
SELECT name FROM professor WHERE LEFT(NAME,1) BETWEEN '자' AND '차'
--2. 교수들의 근무 개월 수를 현재 일을 기준으로  계산하되  근무 개월 순으로 
--   정렬하여 출력하기. 
--   단, 개월 수의 소수점 이하 버린다
SELECT truncate(DATEDIFF(NOW(), hiredate)/30,0) 근무개월수 FROM professor ORDER BY 근무개월수
--3. 교수테이블에서 이름과, 교수가 사용하는 email  서버의 이름을  출력하라. 
--이메일 서버는 @이후의 문자를 말한다.
SELECT NAME, substr(email, INSTR(email, '@')+1) email서버 FROM professor
--4. 101번학과, 201번, 301번 학과 교수의 이름과   id를 출력하는데, 
-- id는 오른쪽을 $로 채운 후  20자리로 출력하고  
--동일한 학과의 학생의  이름과 id를 출력하는데,  
--학생의 id는 왼쪽#으로 채운 후 20자리로 출력하라.
SELECT NAME, rpad(id,20,'$') id FROM professor WHERE deptno IN (101,201,301)
union
SELECT NAME, LPAD(id,20,'#') FROM student WHERE major1 IN (101,201,301)
--5. 사원의 입사 10주년이 되는 년도의 생일의 달 1일부터  한달을 안식월으로 
--   하고자 한다.
--   사원의 사원번호, 사원이름, 직급, 부서코드, 안식시작일, 안식종료일을 출력하기 
SELECT empno, ename, job, deptno, concat(year(DATE_ADD(hiredate, INTERVAL 10 YEAR)),"-",lpad(MONTH(birthday),2,'0'),"-01") 안식시작일, CONCAT(YEAR(DATE_ADD(hiredate, INTERVAL 10 YEAR)),"-",LPAD(MONTH(birthday),2,'0'),"-",day(LAST_DAY(birthday))) 안식종료일 FROM emp
