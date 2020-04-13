/*
	기타 함수
		- ifnull(컬럼, 기본값) : 컬럼의 값이 null인 경우는 기본값으로 대체함
	조건 함수
		- if(조건문,참,거짓)
		- case :
			case 컬럼명 when 값 then 출력값,...
							else 출력값 end
			case when 조건문 then 출력값,...
							else 출력값 end
	그룹 함수 : 여러개의 레코드로 부터 결과 리턴. NULL 값은 제외됨.
		건수 : count(컬럼명) => 컬럼의 값이 NULL이 아닌 레코드 건수
				 count(*) => 전체 레코드 건수
		합계 : sum(컬럼명)
		평균 : avg(컬럼명)	=> 컬럼의 값이 NULL이 아닌 경우만 평균의 대상이 됨.
		가장 큰 값 : max(컬럼명)
		가장 작은 값 : min(컬럼명)
		표준편차 : stddev(컬럼명)
		분산 : variance(컬럼명)
		group by 컬럼명 : 그룹함수 사용시 그룹의 기준이되는 컬럼명 
		having : 그룹함수의 조건문 사용시 
		
		<select 구문 기본 구조>
		select 컬럼명 || *
		from 테이블명 || 뷰
		where 조건문 => 조건문의 결과가 참인 레코드
		group by 컬럼명 => 컬럼을 기준으로 그룹화
		having 조건문 => 조건문이 참인 그룹만 조회
		order by 컬럼명1, 컬럼명2, ... => 정렬방식을 순서대로 처리
			오름차순 : asc, 생략가능
			내림차순 : desc
*/

/* 순위 지정 함수 : rank over */
-- 교수들의 번호, 이름,급여,급여를 많이 받는 순위 출력하기
SELECT NO,NAME,salary,rank() over(ORDER BY salary DESC) 급여순위 FROM professor
-- 교수들의 번호, 이름,급여,급여를 적게 받는 순위 출력하기
SELECT NO,NAME,salary,rank() over(ORDER BY salary) 급여순위 FROM professor
--1. emp 테이블에서 30번 부서 직원들의 사원번호,이름,급여,급여가 적은 순위 출력하기
SELECT empno, ename, salary, rank() over(ORDER BY salary) 순위 FROM emp WHERE deptno=30
--2. score 테이블에서 학생의 학번, 총점, 총점이 많은 순위(등수) 출력하기
SELECT studno,(kor+eng+math) 총점, rank() over(ORDER BY (kor+eng+math) DESC) 순위 FROM score
--3. score 테이블에서 학생의 학번,국어,영어,수학, 국어점수가 높은 순위로 출력하기
SELECT studno,kor,eng,math, rank() over(ORDER BY kor DESC) 국어순위,
									 rank() over(ORDER BY eng DESC) 영어순위,
									 rank() over(ORDER BY math DESC) 수학순위
FROM score
ORDER BY 영어순위
--4. 교수번호, 이름, 급여, 급여가 많은 순위,급여가 적은 순위 출력하기
--급여가 적은 순위 기준으로 출력
SELECT NAME,salary,rank() over(ORDER BY salary DESC), rank() over(ORDER BY salary) FROM professor ORDER BY 4

/* sum over : 누계 계산 */
--교수의 이름, 급여, 보너스, 급여의 중간합계 출력하기
SELECT NAME,salary,bonus, SUM(salary) over(ORDER BY salary DESC) 누계 FROM professor

/*
	join : 여러개의 테이블을 연결하여 조회하기
	cross join
		- m*n개의 레코드가 생성됨. 사용시 주의요망
		=> 1000건 * 1000건 = 1,000,000건
*/
SELECT * FROM emp, dept
-- SELECT * FROM emp => 14레코드, 9개 컬럼
-- SELECT * FROM dept => 5레코드, 3개 컬럼
-- SELECT * FROM emp, dept = > 14*5개, 12개 컬럼

--사원 테이블과 부서테이블을 cross join하여 사원번호, 사원명, 부서코드,부서명을 출력하기
--두개의 테이블에 같은 이름을 가진 컬럼이 있는 경우 테이블명을 기술해야 한다.
--단, 테이블에 별명을 설정하여 별명을 사용할 수 있다.
SELECT empno,ename,emp.deptno,dname FROM emp,dept
SELECT e.empno,e.ename,e.deptno,d.deptno,d.dname FROM emp e, dept d

/*
	등가 조인 : Equi join
		조인컬럼을 이용하여 필요한 레코드만 조회
		조인컬럼은 대부분 키값인 경우가 많다.
*/
--mariaDB 방식 조인
SELECT e.empno, e.ename, e.deptno, d.dname FROM emp e, dept d WHERE e.deptno = d.deptno
--Ansi방식 조인
SELECT e.empno, e.ename, e.deptno, d.dname FROM emp e join dept d on e.deptno = d.deptno

--학생테이블에서 학번, 이름 조회, 점수테이블에서 학번에 해당하는 국어,영어,수학 점수 조회
--학생의 학번, 이름, 국어,영어,수학 점수 출력하기
SELECT s1.studno, NAME, kor, eng, math FROM student s1, score s2 WHERE s1.studno = s2.studno
SELECT s1.studno, NAME, kor, eng, math FROM student s1 join score s2 on s1.studno = s2.studno

--학생의 학번, 이름, 학년, 지도교수번호, 지도교수이름 조회하기
SELECT studno, s.NAME, grade, profno '지도교수 번호', p.name 지도교수이름 FROM student s, professor p WHERE s.profno=p.no
SELECT studno, s.NAME, grade, profno '지도교수 번호', p.name 지도교수이름 FROM student s join professor p on s.profno=p.no
--3학년 학생의 학번, 이름, 학년, 지도교수번호, 지도교수이름 조회하기
SELECT studno, s.NAME, grade, profno '지도교수 번호', p.name 지도교수이름 FROM student s, professor p WHERE s.profno=p.no AND grade=3
SELECT studno, s.NAME, grade, profno '지도교수 번호', p.name 지도교수이름 FROM student s join professor p on s.profno=p.no WHERE grade=3

--김태훈 학생의 학번, 이름, 국어, 영어, 수학, 총점을 출력하기
SELECT s1.studno, s1.NAME, kor, eng, math, kor+eng+math 총점 FROM student s1, score s2 WHERE s1.studno = s2.studno and s1.name = '김태훈'
SELECT s1.studno, s1.NAME, kor, eng, math, kor+eng+math 총점 FROM student s1 join score s2 on s1.studno = s2.studno and s1.name = '김태훈'

--학생의 이름, 학과명, 지도교수이름
--이름 : student테이블
--학과명 : major테이블
--지도교수명 : professor테이블
SELECT s.name, m.name, p.name FROM student s, major m, professor p WHERE s.major1=m.code AND s.profno = p.no
SELECT s.name, m.name, p.name FROM student s join major m ON s.major1=m.code join professor p on s.profno = p.no

--1.학생의 학번, 이름, 학과명, 국어,수학,영어 점수 출력
SELECT s.studno, s.name, m.name, s2.kor, s2.math, s2.eng FROM student s, major m, score s2 WHERE s.major1=m.code AND s.studno=s2.studno
SELECT s.studno, s.name, m.name, s2.kor, s2.math, s2.eng FROM student s join major m ON s.major1=m.code join score s2 on s.studno=s2.studno
--2.사원이름, 부서코드,부서명 출력
SELECT e.ename, e.deptno, d.dname FROM emp e, dept d WHERE e.deptno=d.deptno
SELECT e.ename, e.deptno, d.dname FROM emp e join dept d on e.deptno=d.deptno
--3.p_grade 테이블과 emp 테이블을 조인해서 사원의 이름, 직급(job), 현재 연봉, 해당직급의 연봉하한과 연봉상한 출력하기
--현재 연봉 : (급여*12 + bonus)*10000
--보너스가 없는 경우는 0으로 처리
SELECT e.ename, e.job, (e.salary*12 + IFNULL(e.bonus,0))*10000 현재연봉, p.s_pay 연봉상한, p.e_pay 연봉하한
FROM emp e, p_grade p
WHERE e.job = p.position

SELECT e.ename, e.job, (e.salary*12 + IFNULL(e.bonus,0))*10000 현재연봉, p.s_pay 연봉상한, p.e_pay 연봉하한
FROM emp e join p_grade p
ON e.job = p.position
--4.지도교수이름과 지도학생이름 출력
SELECT p.name 교수명, s.name 학생명 FROM professor p, student s WHERE p.no=s.profno ORDER BY p.name
SELECT p.name 교수명, s.name 학생명 FROM professor p join student s ON p.no=s.profno ORDER BY p.name
--지도교수별로 지도학생의 수를 조회하기
SELECT p.name 교수명, COUNT(*) 지도학생수
FROM professor p, student s
WHERE p.no=s.profno
GROUP BY p.name

SELECT p.name 교수명, COUNT(*) 지도학생수
FROM professor p join student s
ON p.no=s.profno
GROUP BY p.name
--지도교수별로 지도학생의 수를 조회. 단, 지도학생이 2명이상인 교수만 출력
SELECT p.name 교수명, COUNT(*) 지도학생수
FROM professor p, student s
WHERE p.no=s.profno
GROUP BY p.name
HAVING COUNT(*)>=2

SELECT p.name 교수명, COUNT(*) 지도학생수
FROM professor p join student s
ON p.no=s.profno
GROUP BY p.name
HAVING COUNT(*)>=2

/*
	비 등가 조인(Non Equi Join)
		조인 컬럼의 조건이 =이 아닌 경우.
		범위 지정
*/
SELECT * FROM guest
SELECT * FROM pointitem

--고객(guest)테이블과 상품(pointitem)테이블에서 고객의 포인트로 받을 수 있는 상품명, 고객이름, 포인트 출력
SELECT g.name 고객명, g.point 보유포인트, p.name 상품명 FROM guest g, pointitem p WHERE g.point BETWEEN p.spoint AND p.epoint
SELECT g.name 고객명, g.point 보유포인트, p.name 상품명 FROM guest g join pointitem p ON g.point BETWEEN p.spoint AND p.epoint
--고객이 보유포인트보다 낮은 포인트의 상품을 선택 할 수 있다. 외장하드를 선택할 수 있는 고객의 이름, 포인트, 포인트상품명, 시작포인트, 종료포인트 조회
SELECT g.name 고객명, g.point 보유포인트, p.name 상품명, p.spoint 시작포인트, p.epoint 종료포인트
FROM guest g, pointitem p
WHERE g.point>=p.spoint and p.name='외장하드'

SELECT g.name 고객명, g.point 보유포인트, p.name 상품명, p.spoint 시작포인트, p.epoint 종료포인트
FROM guest g join pointitem p
ON g.point>=p.spoint WHERE p.name='외장하드'
--1. 낮은 포인트의 상품을 가져갈 수 있다고 가정할 때, 개인별로 가져갈 수 있는 상품의 갯수 조회하기
--고객명, 고객포인트, 상품의갯수 출력하기. 상품의갯수의 역순으로 정렬하여 출력하기
SELECT g.name, g.point, COUNT(*) '상품의 수'
FROM guest g, pointitem p
WHERE g.point>=p.spoint
GROUP BY g.name
ORDER BY COUNT(*) DESC
--2. 낮은 포인트의 상품을 가져갈 수 있다고 가정할 때, 개인별로 가져갈 수 있는 상품의 갯수 조회하기
--고명, 고객포인트, 상품의갯수 출력하기. 가져갈 수 있는 상품의 갯수가 2개이상인 고객만 조회하기
SELECT g.name, g.point, COUNT(*) '상품의 수'
FROM guest g, pointitem p
WHERE g.point>=p.spoint
GROUP BY g.name
having COUNT(*)>=2
ORDER BY COUNT(*) DESC

--3.학생의 학과, 이름, 국어,수학,영어, 총점,평균,학점
--학점은 scorebase 테이블을 따른다.
SELECT s1.major1, s1.name, s2.kor, s2.math, s2.eng, (s2.kor+s2.math+s2.eng) 총점, (s2.kor+s2.math+s2.eng)/3 평균, s3.grade 학점
FROM student s1, score s2, scorebase s3
WHERE s1.studno=s2.studno AND ROUND((s2.kor+s2.math+s2.eng)/3) BETWEEN s3.min_point AND s3.max_point
--4.3번 문제에서 학점별 인원수, 학점별 평균점수의 평균
SELECT s3.grade 학점, COUNT(*) '학점별 인원수', AVG((s2.kor+s2.math+s2.eng)/3) 학점별평균
FROM student s1, score s2, scorebase s3
WHERE s1.studno=s2.studno AND ROUND((s2.kor+s2.math+s2.eng)/3) BETWEEN s3.min_point AND s3.max_point
GROUP BY s3.grade

/*
	self join : join을 같은 테이블끼리함
					반드시 테이블의 별명을 사용해야함.
*/
-- 사원테이블에서 사원번호, 사원명, 상사의 이름을 조회하기
SELECT e1.empno, e1.ename, e2.ename
FROM emp e1, emp e2
WHERE e1.mgr = e2.empno

--1. 학과(major)테이블에서 학과코드, 학과명, 상위학과명 출력하기
SELECT m1.code, m1.name 학과, m1.part, m1.name 상위학과
from major m1, major m2
WHERE m1.part = m2.code
--2. 교수테이블에서 교수번호, 이름, 입사일, 자신의 입사일과 같은사람의 인원수
--   입사일이 빠른 순으로 정렬하여 출력
SELECT p1.no, p1.name, p1.hiredate, COUNT(*)-1 인원수
FROM professor p1, professor p2
WHERE p1.hiredate=p2.hiredate
GROUP BY p1.name
ORDER BY p1.hiredate

/*
	outer join
		양쪽 테이블의 조인컬럼 조건에 맞는 경우만 레코드가 조회됨 => inner join
		조건에 맞지 않아도 한쪽 테이블의 레코드 조회 가능 => outer join

		left outer join : 왼쪽 테이블의 레코드는 모두 조회
		right outer join : 오른쪽 테이블의 레코드는 모두 조회
		full outer join : 양쪽 테이블의 모든 레코드를 조회
								=> 구현되지 않음. union 명령어를 이용
*/
-- 학생의 이름, 지도교수의 이름 출력
SELECT s.name, p.name
FROM student s, professor p
WHERE s.profno = p.no

-- left outer join으로 학생의 이름, 지도교수 이름 출력. 지도교수가 없는 학생도 출력
SELECT s.name 학생, ifnull(p.name, '지도교수없음') 지도교수
FROM student s LEFT join professor p
on s.profno = p.no
-- 오라클 버전
SELECT s.name 학생, ifnull(p.name, '지도교수없음') 지도교수
FROM student s, professor p
on s.profno = p.no(+)

--right outer join 학생의 이름, 지도교수 이름 출력. 지도학생이 없는 교수도 출력
SELECT ifnull(s.name,'지도학생없음') 학생, p.name 지도교수
FROM student s right join professor p
on s.profno = p.no
--오라클 버전
SELECT ifnull(s.name,'지도학생없음') 학생, p.name 지도교수
FROM student s, professor p
on s.profno(+) = p.no

--full outer join 학생의 이름, 지도교수 이름 출력. 지도교수 or 지도학생이 없는 학생과 교수 이름 모두 출력
SELECT s.name 학생, ifnull(p.name, '지도교수없음') 지도교수
FROM student s LEFT join professor p
on s.profno = p.no
UNION
SELECT ifnull(s.name,'지도학생없음') 학생, p.name 지도교수
FROM student s right join professor p
on s.profno = p.no

--1. emp, p_grade 테이블을 조인하여 사원 이름, 직급, 연봉, 해당직급 연봉하한, 연봉상한 출력
--   연봉 : (급여*12+보너스)*10000. 보너스가 없으면 0으로 처리
--   단, 모든 사원을 출력하기
SELECT e.ename, e.job, (e.salary*12+IFNULL(e.bonus,0))*10000 연봉, p.s_pay 연봉하한, p.e_pay 연봉상한
FROM emp e LEFT JOIN p_grade p
on e.job = p.position
--2. emp, p_grade 테이블을 조인하여 사원 이름, 입사일, 근속년도, 현재직급, 예상직급 출력
--   근속년도 : 오늘을 기준으로 입사일의 일자/365 나눈후 소수점이하 버림
--   단, 모든 사원을 출력하기
SELECT e.ename, e.hiredate, truncate(DATEDIFF(NOW(), e.hiredate)/365,0) 근속년도, e.job 현재직급, p.position 예상직급
FROM emp e LEFT JOIN p_grade p 
ON truncate(DATEDIFF(NOW(), e.hiredate)/365,0) BETWEEN p.s_year AND p.e_year
--3. emp, p_grade 테이블을 조인하여 사원 이름, 생일, 나이, 현재직급, 예상직급 출력하기
--   나이는 오늘을 기준으로 생일까지의 일자/365 소수점 이하 버림
--   단, 모든 사원을 출력하기
SELECT e.ename, e.birthday, truncate(DATEDIFF(NOW(), e.birthday)/365,0) 나이, e.job 현재직급, p.position 예상직급
FROM emp e LEFT JOIN p_grade p 
ON truncate(DATEDIFF(NOW(), e.birthday)/365,0) BETWEEN p.s_age AND p.e_age

/*
	2020.04.09 과제
*/

-- 1. 장성태 학생의 학번, 이름, 전공1번호, 전공학과이름,학과위치(build) 출력하기
SELECT s.studno, s.NAME, s.major1, m.name, m.build
FROM student s, major m
WHERE s.major1 = m.code AND s.name = '장성태' 
-- 2. 몸무게 80 kg 이상인 학생의 학번, 이름,체중, 학과이름, 학과위치 출력
SELECT s.studno, s.name, s.weight, m.name, m.build
FROM student s, major m
WHERE s.major1=m.code AND s.weight>=80
-- 3. 4학년 학생의 이름 학과번호, 학과이름 출력하기
SELECT s.name, s.major1, m.name
FROM student s, major m
WHERE s.major1 = m.code AND s.grade=4
-- 4. 성이 김씨인 학생들의 이름, 학과이름 학과위치 출력하기
SELECT s.name, m.name, m.build
FROM student s, major m
WHERE s.major1 = m.code AND LEFT(s.name,1)='김'
-- 5. 학번과 학생이름, 소속학과이름을 학생 이름순으로 정렬하여 출력
SELECT s.studno, s.name, m.name
FROM student s, major m
WHERE s.major1 = m.code
ORDER BY s.name
-- 6  부서명과 부서별 교수의 급여합계 ,보너스합계 , 급여평균 ,보너스평균 출력하기
--    단 보너스가 없는 경우는 0으로 처리함.
--    평균 출력시 소숫점2자리로 반올림 하여 출력하기
SELECT m.name 부서명, SUM(p.salary)급여합계, SUM(ifnull(p.bonus,0))보너스합계, round(AVG(p.salary),2)급여평균, round(AVG(ifnull(p.bonus,0)),2) 보너스평균
FROM professor p, major m
WHERE p.deptno = m.code
GROUP BY m.name
-- 7 학생의 이름과 지도교수 이름 조회하기. 
--   지도 교수가 없는 학생과 지도 학생이  없는 교수도 조회하기
--   단 지도교수가 없는 학생의 지도교수는  '0000' 으로 출력하고
--   지도 학생이 없는 교수의 지도학생은 '****' 로 출력하기
SELECT s.name 학생, ifnull(p.name,'0000') 지도교수
FROM student s LEFT JOIN professor p
ON s.profno = p.no
UNION
SELECT ifnull(s.name,'****') 학생, p.name 지도교수
FROM student s right JOIN professor p
ON s.profno = p.no
-- 8. 지도 교수가 지도하는 학생의 인원수를 출력하기.
--    단 지도학생이 없는 교수의 인원수 0으로 출력하기
--    지도교수번호, 지도교수이름, 지도학생인원수를 출력하기
SELECT p.no, p.name, COUNT(s.name) 지도학생인원수
FROM student s RIGHT JOIN professor p
ON s.profno = p.no
GROUP BY p.name
-- 9.교수 중 지도학생이 없는 교수의 번호,이름, 학과번호, 학과명 출력하기
SELECT p.no, p.name, p.deptno, m.name
FROM professor p left JOIN student s ON s.profno = p.no JOIN major m
WHERE p.deptno = m.code and s.name IS NULL
GROUP BY p.no
-- 10. emp 테이블에서 사원번호, 사원명,직급,  상사이름, 상사직급 출력하기
--   모든 사원이 출력되어야 한다.
--    상사가 없는 사원은 상사이름을 '상사없음'으로  출력하기
SELECT e1.empno, e1.ename, e1.job, ifnull(e2.ename,'상사없음') 상사이름, ifnull(e2.job,'상사없음') 상사직급
FROM emp e1 LEFT JOIN emp e2
ON e1.mgr = e2.empno
