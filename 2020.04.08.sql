/*
	함수 : 단일행 함수, 그룹함수
	- 문자열 관련 함수
		대소문자변경 : upper, lower
		문자열 길이 : length(문자열의 바이트 수), char_length(문자열의 길이)
		부분문자열 : substr, left, right
			substr(컬럼, 시작인덱스, 갯수) => 갯수 생략시 이후 문자열 전부
			left(컬럼, 갯수) => 오른쪽에서 갯수만큼 부분 문자열 리턴
			right(컬럼, 갯수) => 왼쪽에서 갯수만큼 부분 문자열 리턴
		문자열 연결함수 : concat
			문자의 위치 : instr(컬럼, 문자) : 컬럼에서 문자의 인덱스 리턴
			문자 추가 :
				lpad(컬럼명, 전체자리수, 나머지부분을 채울 문자) : 왼쪽 추가
				rpad(컬럼명, 전체자리수, 나머지부분을 채울 문자) : 오른쪽 추가
			문자 제거 : 양쪽 끝의 문자를 제거
				trim(leading|trailing|both 문자열 from 컬럼명)
				trim(컬럼명) : 양쪽 공백 제거
				ltrim(컬럼명) : 왼쪽 공백 제거
				rtrim(컬럼명) : 오른쪽 공백 제거
				=> 문자 중간에 있는 공백 제거 안됨
			문자 치환 : replace(컬럼명, 문자1, 문자2)
			=> 컬럼의 문자열 중 문자1->문자2
	- 숫자 관련 함수
		반올림 : round(칼럼, [표시할 소수점이하자리수])
		버림 : truncate(컬럼, 표시할 소수점이하자리수)
		나머지 : mod(숫자1, 숫자2) 숫자1%숫자2
		제곱 : power(숫자1, 숫자2) 숫자1을 숫자2만큼 제곱
		근사정수 : 큰 근사정수 : ceil(숫자)
						작은 근사정수 : floor(숫자)
	- 날짜 관련 함수
		현재시점 : now()
		오늘일자 : curdate(), current_date, current_date()
		일자수 계산 : datediff(날짜1, 날짜2) 날짜1 - 날짜2 일자 수
		일자의 부분함수 :
			year(날짜) : 날짜의 년도 리턴
			month(날짜) : 날짜의 월 리턴
			day(날짜) : 날짜의 일 리턴
			weekday(날짜) : 0(월요일) 부터
			dayofweek(날짜) : 1(일요일) 부터
			last_day(날짜) : 그 달의 마지막 일자
		날짜의 이전, 이후 :
			날짜 이후 : date_add(날짜, interval 숫자 [year|month|day|hour|minute|second])
			날짜 이전 : date_sub(날짜, interval 숫자 [year|month|day|hour|minute|second])
		날짜 변환 함수
			문자열 -> 날짜로 변환 : str_to_date(문자열, '형식지정문자')
			날짜 -> 문자열로 변환 : date_format(날짜, '형식지정문자')
		형식지정문자 :
			년도 : %Y, 월 : %m, 일 : %d, 시 : %h,%H, 분 : %i, 초 : %s
*/

/*
	기타함수
		ifnull(컬럼,기본값) : 컬럼이 null인 경우 기본값으로 변환
*/
-- 교수의 이름, 직급, 급여, 보너스, 급여+보너스(총급여) 출력하기 
SELECT NAME, POSITION, salary, bonus, (salary+bonus) 총급여 FROM professor WHERE bonus IS NOT NULL
UNION
SELECT NAME, POSITION, salary, bonus, salary 총급여 FROM professor WHERE bonus IS null

SELECT NAME, POSITION, salary, bonus, salary+IFNULL(bonus,0) 총급여 FROM professor

--문제 1. 교수의 이름, 직책, 급여, 보너스 출력하기. 보너스가 없는 경우 '보너스 없음'출력
SELECT NAME,POSITION,salary,IFNULL(bonus,'보너스없음') 보너스 FROM professor
--문제 2. 학생의 이름과 지도교수 번호를 출력하기. 지도교수가 없는 경우 '지도교수 배정안됨'출력하기
SELECT NAME,ifnull(profno,'지도교수 배정안됨') 지도교수 FROM student
--문제 3. 전공테이블에서 코드, 코드명,build 출력하기. build값이 없는 경우 '단독건물없음' 출력하기
SELECT CODE, NAME, ifnull(build, '단독건물 없음') 건물 FROM major

/*
	조건 관련 함수
		if : if(조건문, 참, 거짓)
		case
			: case 컬럼 when 값1 then 문자
							when 값2 then 문자
							...
							else 문자 end
			  case when 조건1 then 문자
			  		 when 조건2 then 문자
			  		 ...
			  		 else 문자 end
*/
-- 교수 이름, 학과번호, 학과명 출력하기. 학과명은 학과번호가 101인경우 '컴퓨터공학', 나머지는 '그외학과' 출력.
SELECT NAME,deptno,if(deptno=101, '컴퓨터공학', '그외학과') 학과명 FROM professor
--문제1. 학생의 주민번호 7번째 자리가 1인경우 남자로, 2인경우 여자로 성별 출력. 그 외는 주민번호 오류로 성별 출력하기.
-- 학생의 이름, 주민번호, 성별 출력
SELECT NAME, jumin, if(substr(jumin,7,1)=1,'남자',(if(substr(jumin,7,1)=2,'여자','오류'))) 성별 FROM student
--문제2. 교수테이블에서 교수의 이름, 학과번호, 학과명 출력.
--학과명 : 101(컴퓨터공학), 102(멀티미디어공학), 201(기계공학), 나머지(그 외 학과)
SELECT NAME,deptno, if(deptno=101, '컴퓨터공학', if(deptno=102, '멀티미디어공학', if(deptno=201, '기계공학','그외학과'))) 학과명  from professor
--문제3. 학생의 이름, 전화번호, 지역명 출력하기
--지역명 : 02(서울), 031(경기), 032(인천), 그 외(기타지역)
SELECT NAME, tel, if(left(tel,INSTR(tel,')')-1)=02, '서울',
						if(left(tel,INSTR(tel,')')-1)=031, '경기',
						if(left(tel,INSTR(tel,')')-1)=032, '인천', '기타지역'))) 지역명
FROM student
--문제4. 학생의 이름, 전화번호, 지역명 출력하기
--지역명 : 02, 031, 032 은 수도권,  그 외(기타지역) in사용
SELECT NAME, tel, if(LEFT(tel,INSTR(tel,')')-1) IN (02, 031, 032), '수도권', '기타지역') FROM student

/*
	case 함수
*/
-- 교수 중 학과명이 101인 경우 '컴퓨터공학' 그 외는 공란으로 출력
-- 교수 이름, 학과코드, 학과명
SELECT NAME,deptno, if(deptno=101,'컴퓨터공학','') 학과명 FROM professor
SELECT NAME,deptno,
				case deptno when 101 then '컴퓨터공학'
				ELSE ''END 학과명
from professor
-- 교수 중 학과명이 101인 경우 '컴퓨터공학' 그 외는 '기타학과'으로 출력
-- 교수 이름, 학과코드, 학과명
SELECT NAME,deptno,
				case deptno when 101 then '컴퓨터공학'
				ELSE '기타학과'END 학과명
from professor
--교수테이블에서 교수의 이름, 학과번호, 학과명 출력.
--학과명 : 101(컴퓨터공학), 102(멀티미디어공학), 201(기계공학), 나머지(그 외 학과)
SELECT NAME,deptno,
			case deptno when 101 then '컴퓨터공학'
							when 102 then '멀티미디어공학'
							when 201 then '기계공학'
							ELSE '그 외 학과' END 학과명
FROM professor
--학생의 주민번호 7번째 자리가 1, 3은 남자, 2, 4는 여자 출력. 그 외는 주민번호 오류
--학생이름, 주민번호, 성별 출력(if, case문 이용)
SELECT NAME, jumin, if(SUBSTR(jumin,7,1) IN (1,3),'남자', if(SUBSTR(jumin,7,1) IN (2,4), '여자', '주민번호 오류')) 성별 FROM student
SELECT NAME, jumin,
	case SUBSTR(jumin,7,1) when 1 then '남자'
								  when 3 then '남자'
								  when 2 then '여자'
								  when 4 then '여자'
								  ELSE '주민번호 오류' END 성별
FROM student

SELECT NAME, jumin,
	case  when SUBSTR(jumin,7,1) IN (1,3) then '남자'
   	   when SUBSTR(jumin,7,1) IN (2,4) then '여자'
			ELSE '주민번호 오류' END 성별
FROM student

--문제1. 학생의 이름과 전화번호, 지역명 출력하기
--지역명 : 02(서울), 031(경기), 032(인천), 그 외(기타지역)
SELECT NAME,tel,
	case LEFT(tel, INSTR(tel,')')-1) when 02  then '서울'
												when 031 then '경기'
												when 032 then '인천'
	ELSE '기타지역' END 지역명
FROM student
--문제2. 학생의 생일이 1~3월(1분기) 4~6월(2분기) 7~9(3분기) 10~12(4분기) 분기 출력하기 
--학생의 이름, 주민번호, 출생분기 출력. 생일은 주민번호 기준 
SELECT NAME, jumin,
	case when SUBSTR(jumin,3,2) BETWEEN 1 AND 3 then '1분기'
		  when SUBSTR(jumin,3,2) BETWEEN 4 AND 6 then '2분기'
		  when SUBSTR(jumin,3,2) BETWEEN 7 AND 9 then '3분기'
		  when SUBSTR(jumin,3,2) BETWEEN 10 AND 12 then '4분기'
	END 출생분기
FROM student
--문제3. 학생의 생일이 1~3월(1분기) 4~6월(2분기) 7~9(3분기) 10~12(4분기) 분기 출력하기
--학생의 이름, 생일, 출생분기 출력. 생일은 생일 기준 
SELECT NAME, birthday,
	case when MONTH(birthday) BETWEEN 1 AND 3 then '1분기'
		  when MONTH(birthday) BETWEEN 4 AND 6 then '2분기'
		  when MONTH(birthday) BETWEEN 7 AND 9 then '3분기'
		  when MONTH(birthday) BETWEEN 10 AND 12 then '4분기'
	END 출생분기
FROM student

/*
	그룹함수 : 레코드 여러 줄을 이용하여 결과 리턴
		group by
		having
*/
-- count() 함수 : 조회된 레코드의 건수를 리턴. null은 건수에서 제외됨.
-- 교수의 전체 인원, 보너스를 받는 인원을 출력
SELECT COUNT(*), COUNT(bonus) FROM professor
-- 학생들의 전체 인원, 학생 중 지도교수를 배정받은 학생의 인원수 출력
SELECT COUNT(*), COUNT(profno) FROM student
-- 1학년 학생 전체 인원수와 지도교수를 배정받은 학생의 인원수 출력
SELECT COUNT(*), COUNT(profno) FROM student WHERE grade=1
-- 학년 별 학생의 인원수와 지도교수를 배정받은 학생 인원수를 출력
SELECT grade, COUNT(*), COUNT(profno) FROM student GROUP BY grade
--1.전공학과1별 학생의 인원수와 지도교수를 배정받은 학생의 인원수를 출력
SELECT major1, COUNT(*) 인원수, COUNT(profno) '지도교수배정 인원수' FROM student group BY major1
--2.직책별 교수의 인원수와 보너스를 받고 있는 인원수를 출력
SELECT POSITION, COUNT(*) 인원수, COUNT(bonus) 보너스받은인원수 FROM professor GROUP BY POSITION
--3.사원 중 부서별 인원수와 보너스를 받고 있는 인원수를 출력하기
SELECT deptno 부서명, COUNT(*) 인원수, COUNT(bonus) 보너스받은인원수 FROM emp GROUP BY deptno

/*
	sum(), avg() : null값은 평균과 합계에서 제외
*/
--교수들의 급여합계와 보너스 합계 출력
SELECT SUM(salary), SUM(bonus) FROM professor
--교수들의 급여평균과 보너스 평균 출력
SELECT AVG(salary), AVG(bonus),COUNT(*) FROM professor
--교수들의 전체인원수, 급여합계, 보너스합계, 급여평균,보너스평균 출력
-- 보너스평균은 보너스를 받는 교수들만의 평균
SELECT COUNT(*),SUM(salary),SUM(bonus),AVG(salary),AVG(bonus) FROM professor
-- null값 상관없이 전체 평균을 구할 때 ifnull 이용
SELECT COUNT(*),SUM(salary),SUM(bonus),AVG(salary),AVG(ifnull(bonus,0)) FROM professor

--문제1.교수의 부서별 인원수, 부서별급여합계,부서별보너스합계,부서별급여평균,부서별보너스평균  출력
--단, 보너스가 없는 교수도 평균에 계산하도록 하기
SELECT deptno, COUNT(*) 인원수, SUM(salary) 부서별급여합계, SUM(ifnull(bonus,0)) 부서별보너스합계,
		AVG(salary) 부서별급여평균, AVG(IFNULL(bonus,0)) 부서별보너스평균
FROM professor
GROUP BY deptno
--문제2.교수의 직급별 인원수, 부서별급여합계, 부서별보너스합계,부서별급여평균,부서별보너스평균 출력
--단, 보너스가 없는 교수도 평균에 계산하도록 하기
SELECT POSITION, COUNT(*) 인원수, SUM(salary) 부서별급여합계,
		SUM(ifnull(bonus,0)) 부서별보너스합계, AVG(salary) 부서별급여평균,
		AVG(IFNULL(bonus,0)) 부서별보너스평균
FROM professor
GROUP BY POSITION
-- 문제3.1학년 학생의 키와 몸무게의 평균 출력하기
SELECT AVG(height), AVG(weight) FROM student WHERE grade=1
-- 문제4.학년별 학생의 키와 몸무게의 평균 출력하기
SELECT grade, AVG(height), AVG(weight) FROM student GROUP BY grade
-- 문제5. 부서별 교수의 급여합, 보너스합, 연봉합, 급여평균, 보너스평균, 연봉평균 출력하기
-- 연봉 : 급여*12 + 보너스
-- 보너스가 없는 경우는 0으로 처리함.
-- 평균 출력시 소수점 이하 2자리로 반올림 출력
SELECT deptno, SUM(salary) 급여합, SUM(IFNULL(bonus,0)) 보너스합, SUM(salary*12+IFNULL(bonus,0)) 연봉합,
		round(AVG(salary),2) 급여평균,
		round(AVG(IFNULL(bonus,0)),2) 보너스평균,
		round(AVG(salary*12+IFNULL(bonus,0)),2) 연봉평균
FROM professor
GROUP BY deptno
--문제6.  학생의 학년별 키와 몸무게 평균 출력하기
-- 학년별로 정렬하기. 평균은 소수점 이하 2자리로 반올림 출력
SELECT grade,
	ROUND(AVG(height),2) '키 평균',
	ROUND(AVG(weight),2) '몸무게 평균'
FROM student
GROUP BY grade
ORDER BY grade

-- min, max : 최소값, 최대값
-- 전공학과1별 가장 키가 큰 학생의 키와, 가장 키가 작은 학생의 키, 키 평균 출력하기
SELECT major1, MAX(height), MIN(height), round(AVG(height),2) FROM student GROUP BY major1

--문제
--교수 중 급여와 보너스의 합계가 가장 많은 값, 가장 적은 값, 평균 출력하기
--보너스가 없는 경우는 0으로 처리
--평균 금액은 소수점 이하 한자리로 반올림해서 출력
SELECT MAX(salary+IFNULL(bonus,0)) 최대값, MIN(salary+IFNULL(bonus,0)) 최소값, round(AVG(salary+IFNULL(bonus,0)),1) 평균  FROM professor

-- stddev, variance : 표준편차, 분산
-- 교수들의 급여평균, 표준편차, 분산 구하기
SELECT round(AVG(salary),1) 평균, STDDEV(salary) 표준편차, VARIANCE(salary) 분산 FROM professor

/*
	having : 그룹의 조건. 반드시 group by가 존재해야 됨
*/
--학생의 학년별 키와 몸무게 평균 출력하기
--단, 몸무게 평균이 70 이상인 학년만 출력하기
SELECT grade, AVG(height), AVG(weight) FROM student GROUP BY grade HAVING AVG(weight)>=70
--문제1.
--교수의 부서별 급여합계와 평균을 구하기
--단, 급여평균이 400이상인 부서만 출력하기
SELECT deptno, COUNT(salary), SUM(salary) 급여합계, AVG(salary) 급여평균 FROM professor GROUP BY deptno HAVING AVG(salary)>=400

--문제2.
-- 교수의 학과별 평균급여, 인원수 출력하기
-- 평균급여가 300 이상인 학과만 출력하기
SELECT deptno, AVG(salary) 평균급여, COUNT(*)인원수 FROM professor GROUP BY deptno HAVING 평균급여>=300
--문제3.
-- 주민번호를 기준으로 남학생, 여학생의 최대키와 최소키, 평균키를 출력하기
-- 단, 평균키는 소수점이하 2자리로 반올림
SELECT if(SUBSTR(jumin,7,1)=1,'남자','여자') 성별,
		MAX(height) 최대키, MIN(height) 최소키, round(AVG(height),2) 평균키
FROM student
GROUP BY 성별
--문제4.
--학생 중 생일(birthday) 기준으로 월별로 태어난 인원수를 출력하기
SELECT CONCAT(MONTH(birthday),"월") 월, COUNT(*) 인원수
FROM student
GROUP BY 1
ORDER BY MONTH(birthday)
--문제5.
--학생 중 생일(birthday) 기준으로 월별로 태어난 인원수를 가로로 출력하기
SELECT COUNT(*) 전체,
		sum(if(MONTH(birthday)=1,1,0)) 1월, sum(MONTH(birthday)=2) 2월, sum(MONTH(birthday)=3) 3월,
		sum(MONTH(birthday)=4) 4월, sum(MONTH(birthday)=5) 5월, sum(MONTH(birthday)=6) 6월,
		sum(MONTH(birthday)=7) 7월, sum(MONTH(birthday)=8) 8월, sum(MONTH(birthday)=9) 9월,
		sum(MONTH(birthday)=10) 10월, sum(MONTH(birthday)=11) 11월, sum(MONTH(birthday)=12) 12월
FROM student
SELECT COUNT(*) 전체,
		 COUNT(case when MONTH(birthday)=1 then '1' END) 1월, COUNT(case when MONTH(birthday)=2 then '2' END) 2월,
		 COUNT(case when MONTH(birthday)=3 then '3' END) 3월, COUNT(case when MONTH(birthday)=4 then '4' END) 4월,
		 COUNT(case when MONTH(birthday)=5 then '5' END) 5월, COUNT(case when MONTH(birthday)=6 then '6' END) 6월,
		 COUNT(case when MONTH(birthday)=7 then '7' END) 7월, COUNT(case when MONTH(birthday)=8 then '8' END) 8월,
		 COUNT(case when MONTH(birthday)=9 then '9' END) 9월, COUNT(case when MONTH(birthday)=10 then '10' END) 10월,
		 COUNT(case when MONTH(birthday)=11 then '11' END) 11월, COUNT(case when MONTH(birthday)=12 then '12' END) 12월
FROM student

/*
	2020.04.08 과제
*/

--1. 학생을 3개 팀으로 분류하기 위해 학번을 3으로 나누어  나머지가 0이면 'A팀', 
--   1이면 'B팀', 2이면 'C팀'으로 
--    분류하여 학생 번호, 이름, 학과 번호, 팀 이름을 출력하여라
SELECT studno, NAME, major1,
		case MOD(studno, 3) when 0 then 'A팀'
								  when 1 then 'B팀'
								  when 2 then 'C팀'
		end
FROM student
-- 2. 전공1별 가장 키가 큰키와, 가장 작은키, 키의 평균을 구하기 평균키가 170이상인
--    전공1학과를 출력하기
SELECT major1, MAX(height) 최대키, MIN(height) 최소키, AVG(height) 평균키 FROM student GROUP BY major1 HAVING AVG(height)>=170
-- 3. score 테이블에서 학번, 국어,영어,수학, 학점, 인정여부 을 출력하기
--    학점은 세과목 평균이 95이상이면 A+,90 이상 A0
--                        85이상이면 B+,80 이상 B0
--                        75이상이면 C+,70 이상 C0
--                        65이상이면 D+,60 이상 D0
--     인정여부는 평균이 60이상이면 PASS로 미만이면 FAIL로 출력한다.                   
--    으로 출력한다.
SELECT studno,kor,eng,math,
		 case when (kor+eng+math)/3 BETWEEN 95 AND 100 then 'A+'
		 		when (kor+eng+math)/3 BETWEEN 90 AND 94 then 'A0'
		 		when (kor+eng+math)/3 BETWEEN 85 AND 89 then 'B+'
		 		when (kor+eng+math)/3 BETWEEN 80 AND 84 then 'B0'
		 		when (kor+eng+math)/3 BETWEEN 75 AND 79 then 'C+'
		 		when (kor+eng+math)/3 BETWEEN 70 AND 74 then 'C0'
		 		when (kor+eng+math)/3 BETWEEN 65 AND 69 then 'D+'
		 		when (kor+eng+math)/3 BETWEEN 60 AND 64 then 'D0'
		END 학점,
		 
		if(AVG(kor+eng+math)>=60,'PASS','FAIL') 인정여부
FROM score
GROUP BY studno
-- 4. 학생 테이블에서 이름, 키, 키의 범위에 따라 A, B, C ,D등급을 출력하기
--      160 미만 : A등급
--      160 ~ 169까지 : B등급
--      170 ~ 179까지 : C등급
--      180이상       : D등급
SELECT NAME, height,
		case when height>=180 then 'D등급'
			  when height BETWEEN 170 AND 179 then 'C등급'
			  when height BETWEEN 160 AND 169 then 'B등급'
			  when height<160 then 'A등급'
		END 등급
FROM student
-- 5. 교수테이블에서 교수의 급여액수를 기준으로 200이하는 4급, 201~300 : 3급, 301~400:2급
--     401 이상은 1급으로 표시한다. 교수의 이름, 급여, 등급을 출력하기
--     단 등급의 오름차순으로 정렬하기
SELECT NAME, salary,
		case when salary<=200 then '4급'
			  when salary BETWEEN 201 AND 300 then '3급'
			  when salary BETWEEN 301 AND 400 then '2급'
			  when salary>=401 then '1급'
		END 등급
FROM professor
ORDER BY 등급
-- 6.  사원의 직급(job)별로 평균 급여를 출력하고, 
--     평균 급여가 1000이상이면 '우수', 작으면 '보통'을 출력하여라
SELECT job, avg(salary) '평균 급여', if(AVG(salary)>=1000,'우수','보통') 등급
FROM emp
GROUP BY job
-- 7. 학과별로 학생의 평균 몸무게와 학생수를 출력하되 평균 몸무게의 내림차순으로 
-- 정렬하여 출력하기
SELECT major1 학과, AVG(weight) '평균 몸무게', COUNT(*) 학생수 FROM student GROUP BY major1 ORDER BY AVG(weight) DESC
-- 8. 학과별 교수의 수가 2명 이하인 학과번호, 인원수를 출력하기
SELECT deptno 학과번호, COUNT(*) 인원수 FROM professor GROUP BY deptno HAVING COUNT(*)<=2
-- 9. 전화번호의 지역번호가 02서울 031 경기, 051 부산, 052 경남, 나머지 그외지역
--    학생의 인원수를 조회하기 
SELECT case LEFT(tel, INSTR(tel, ')')-1) when 02 then '서울'
													  when 031 then '경기'
													  when 051 then '부산'
													  when 052 then '경남'
													  ELSE '그외지역' END 지역번호,
		count(*) 인원수
FROM student
GROUP BY 지역번호
-- 10. 전화번호의 지역번호가 02서울 031 경기, 051 부산, 052 경남, 나머지 그외지역
--    학생의 인원수를 조회하기. 
-- 가로로 출력하기
SELECT COUNT(*) 전체,
		 COUNT(case when LEFT(tel, INSTR(tel, ')')-1)=02 then '서울' END) 서울,
		 COUNT(case when LEFT(tel, INSTR(tel, ')')-1)=031 then '경기' END) 경기,
		 COUNT(case when LEFT(tel, INSTR(tel, ')')-1)=051 then '부산' END) 부산,
		 COUNT(case when LEFT(tel, INSTR(tel, ')')-1)=052 then '경남' END) 경남,
		 (COUNT(*) - COUNT(case when LEFT(tel, INSTR(tel, ')')-1) in(02,031,051,052) then ' ' END))  그외지역		 
FROM student
