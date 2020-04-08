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
