-- 一、创建学生成绩数据库
CREATE DATABASE IF NOT EXISTS cms_student; 
use cms_student;

-- 创建学生表(students)：学号（SNO）、姓名(SNAME)、性别(SSEX)、生日(SBIRTHDAY )、所属班级(CLASS )
CREATE TABLE IF NOT EXISTS students(
Sno SMALLINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
Sname VARCHAR(20) NOT NULL UNIQUE,
Ssex ENUM('男','女','保密') DEFAULT '保密',
Sbirthday INT,
classId SMALLINT UNSIGNED NOT NULL 
);
-- 向students表中插入数据
INSERT students VALUES(1,'张三',1,19920103,1);
INSERT students VALUES(2,'李四',3,19910923,2);
INSERT students VALUES(3,'tom',2,19921202,3);
INSERT students VALUES(4,'king',2,19921102,4);
INSERT students VALUES(5,'mudong',1,19930312,5);
INSERT students VALUES(6,'dongdong',3,19930223,6);
INSERT students VALUES(7,'张三峰',1,19911203,7);
INSERT students VALUES(8,'lemon',2,19900802,5);
INSERT students VALUES(9,'王红',2,19911213,1);
INSERT students VALUES(10,'李四国',1,19910423,3);

-- 创建课程表(course)：课程编号(CNO)、课程名(CNAME)、授课老师(TNO)
CREATE TABLE IF NOT EXISTS course(
Cno SMALLINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
Cname VARCHAR(50) NOT NULL UNIQUE,
Tno SMALlINT UNSIGNED
);
-- 向course表中插入数据
INSERT course VALUES(1,'语文',1),(2,'数学',2)
,(3,'化学',3)
,(4,'外语',4)
,(5,'计算机',1)
,(6,'生物',7)
,(7,'物理',3)
,(8,'体育',1)
,(9,'音乐',8)
,(10,'美术',9);

-- 创建成绩表(score):学号(SNO)、课程编号(CNO)、得分(DEGREE)
CREATE TABLE IF NOT EXISTS score(
Sno SMALLINT UNSIGNED,
Cno SMALLINT UNSIGNED,
degree TINYINT
);
-- 向score表中插入数据
INSERT score VALUES(1,1,90),(1,2,80),(2,1,60),(2,2,30),(2,4,33),(5,2,31),(5,6,82),(6,7,50),(8,2,100),(8,3,94),(7,2,75),(3,1,100);

-- 创建教师表(teacher):教师编号(TNO)、教师姓名(TNAME)、性别(TSSEX)、生日(TBIRTHDAY)、职称(TITLE)、单位科室（DEPART）
CREATE TABLE IF NOT EXISTS teacher(
Tno SMALLINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
Tname VARCHAR(20) NOT NULL,
Tsex ENUM('男','女','保密') DEFAULT '保密',
Tbirthday INT,
Title VARCHAR(100),
depart VARCHAR(100)
);
-- 向teacher表中插入数据
INSERT teacher VALUES(1,'张老师',1,19810802,'高级教师','计算机系'),
(2,'王老师',1,19820802,'特级教师','电子工程系'),
(3,'李老师',2,19800221,'普通教师','电子工程系'),
(4,'金老师',2,19781121,'普通教师','电子工程系'),
(5,'夏老师',2,19830324,'高级教师','计算机系'),
(6,'母老师',2,19821224,'普通教师','计算机系'),
(7,'曹老师',1,19801201,'特级师','计算机系'),
(8,'刚老师',2,19791111,'高级教师','电子工程系'),
(9,'花老师',1,19820324,'高级教师','计算机系'),
(10,'星老师',2,19800902,'高级教师','计算机系');



-- 二、完成查询题目
-- 1、 查询Student表中的所有记录的Sname、Ssex和Class列。
SELECT Sname,Ssex,classId FROM students;
-- 2、 查询教师所有的单位即不重复的Depart列。
SELECT * FROM teacher GROUP BY depart;
-- 3、 查询Student表的所有记录。
SELECT * FROM students;
-- 4、 查询Score表中成绩在60到80之间的所有记录。
SELECT * FROM score WHERE 60<=degree AND degree<=80;
-- 5、 查询Score表中成绩为85，86或88的记录。
SELECT * FROM score WHERE degree IN(85,86,88);
-- 6、 查询Student表中“95031”班或性别为“女”的同学记录。
SELECT * FROM students WHERE classId=95031 OR Ssex='女';
-- 7、 以Class降序查询Student表的所有记录。
SELECT * FROM students ORDER BY classId DESC;
-- 8、 以Cno升序、Degree降序查询Score表的所有记录。
SELECT * FROM score ORDER BY Cno ASC,degree DESC;
-- 9、 查询“95031”班的学生人数。
SELECT COUNT(*) FROM students WHERE classId=95031;
-- 10、查询Score表中的最高分的学生学号和课程号。
SELECT Sno,Cno,degree FROM score WHERE degree=(SELECT MAX(degree) FROM score);
-- 11、查询‘3-105’号课程的平均分。
SELECT AVG(degree) FROM score WHERE Cno='3-105';
SELECT AVG(degree) FROM score GROUP BY Cno HAVING Cno='3-105';
-- 12、查询Score表中至少有5名学生选修的并以3开头的课程的平均分数。
SELECT AVG(degree) FROM score WHERE Cno REGEXP '^3.*' GROUP BY Cno HAVING COUNT(*)>=5;
-- 13、查询最低分大于70，最高分小于90的Sno列。
SELECT * FROM score GROUP BY Sno HAVING MAX(degree)<90 AND MIN(degree)>70;
-- 14、查询所有学生的Sname、Cno和Degree列。
SELECT st.Sname,sc.Cno,sc.degree FROM students AS st JOIN score AS sc ON st.Sno=sc.Sno;
-- 15、查询所有学生的Sno、Cname和Degree列。
SELECT st.Sno,st.Sname,sc.degree FROM students AS st JOIN score AS sc ON st.Sno=sc.Sno;
-- 16、查询所有学生的Sname、Cname和Degree列。
SELECT st.Sname,co.Cname,sc.degree FROM students AS st JOIN score AS sc ON st.Sno=sc.Sno JOIN course AS co ON co.Cno=sc.Cno;
-- 17、查询“95033”班所选课程的平均分。
SELECT AVG(degree) FROM score WHERE score.Sno IN(SELECT GROUP_CONCAT(students.Sno) FROM students GROUP BY classId HAVING classId=1);
create table grade(low int,upp int,rank char(1));
insert into grade values(90,100,'A');
insert into grade values(80,89,'B');
insert into grade values(70,79,'C');
insert into grade values(60,69,'D');
insert into grade values(0,59,'E');
commit;
-- 18、现查询所有同学的Sno、Cno和rank列。
SELECT sc.Sno,sc.Cno,g.rank FROM score AS sc LEFT JOIN grade AS g ON sc.degree>=g.low AND sc.degree<=g.upp ORDER BY sc.Sno;
-- 19、查询选修“1”课程的成绩高于“1”号同学成绩的所有同学的记录。
SELECT Sno,Cno,degree FROM score WHERE degree>(SELECT degree FROM score WHERE Sno=1 AND Cno=1) AND Cno=1;
-- #20、查询score中选学一门以上课程的同学中分数为非最高分成绩的记录。
SELECT * FROM score WHERE Sno IN(SELECT Sno FROM score GROUP BY Sno HAVING COUNT(Cno)>1 AND degree<MAX(degree));
-- 21、查询成绩高于学号为“1”、课程号为“2”的成绩的所有记录。
SELECT * FROM score WHERE degree>(SELECT degree FROM score WHERE Sno=1 AND Cno=2);
-- 22、查询和学号为1的同学同年出生的所有学生的Sno、Sname和Sbirthday列。
SELECT * FROM students WHERE LEFT(Sbirthday,4)=(SELECT LEFT(Sbirthday,4) FROM students WHERE Sno=1);
-- 23、查询“张老师“教师任课的学生成绩。
SELECT Sno,Cno,degree,'张老师' FROM score WHERE Cno IN(SELECT c.Cno FROM course AS c JOIN teacher AS t ON c.Tno=t.Tno WHERE Tname='张老师');
-- 24、查询选修某课程的同学人数多于5人的教师姓名。
SELECT t.Tname,c.Cname,GROUP_CONCAT(s.Sno)FROM score AS s JOIN course AS c ON c.Cno=s.Cno JOIN teacher AS t ON c.Tno=t.Tno GROUP BY s.Cno HAVING COUNT(s.Sno)>2;
-- 25、查询1班和2班全体学生的记录。
SELECT * FROM students WHERE classId=1 OR classId=2;
-- 26、查询存在有85分以上成绩的课程Cno.
SELECT Cno,GROUP_CONCAT(degree) FROM score WHERE degree>85 GROUP BY Cno; 
-- 27、查询出“计算机系“教师所教课程的成绩表。
SELECT * FROM score WHERE Cno IN(SELECT Cno FROM course WHERE Tno IN(SELECT Tno FROM teacher WHERE depart='计算机系'));
-- 28、查询“计算机系”与“电子工程系“不同职称的教师的Tname。
SELECT Tname FROM teacher WHERE depart='计算机系' AND Title NOT IN(SELECT Title FROM teacher WHERE depart='电子工程系');
-- 29、查询选修编号为“1“课程且成绩至少高于选修编号为“2”的同学的Cno、Sno和Degree,并按Degree从高到低次序排序。
SELECT Cno,Sno,degree FROM score WHERE degree > (SELECT MAX(degree) FROM score WHERE Cno=2) AND Cno=1 ORDER BY degree DESC;
-- 30、查询选修编号为“1”且成绩高于选修编号为“2”课程的同学的Cno、Sno和Degree.
SELECT Cno,Sno,degree FROM score WHERE degree > (SELECT MAX(degree) FROM score WHERE Cno=2) AND Cno=1;
-- 31、查询所有教师和同学的name、sex和birthday.
SELECT s.Sname AS name,s.Ssex AS sex,s.Sbirthday AS birthday FROM students AS s UNION SELECT t.Tname,t.Tsex,t.Tbirthday FROM teacher AS t;
-- 32、查询所有“女”教师和“女”同学的name、sex和birthday.
SELECT s.Sname AS name,s.Ssex AS sex,s.Sbirthday AS birthday FROM students AS s  WHERE s.Ssex='女' UNION SELECT t.Tname,t.Tsex,t.Tbirthday FROM teacher AS t WHERE t.Tsex=2;
-- #33、查询成绩比该课程平均成绩低的同学的成绩表。
SELECT * FROM score WHERE Sno IN(SELECT Sno FROM score GROUP BY Cno HAVING degree<AVG(degree));
-- 34、查询所有任课教师的Tname和Depart.
SELECT Tname,depart FROM teacher WHERE Tno IN(SELECT Tno FROM course);
-- 35 查询所有未讲课的教师的Tname和Depart. 
SELECT Tname,depart FROM teacher WHERE Tno NOT IN(SELECT Tno FROM course);
-- 36、查询至少有2名男生的班号。
SELECT classId,GROUP_CONCAT(Sno) FROM students WHERE Ssex=1 GROUP BY classId HAVING COUNT(Sno)>1;
-- 37、查询Student表中不姓“王”的同学记录。
SELECT * FROM students WHERE Sname NOT REGEXP '^王.*';
-- 38、查询Student表中每个学生的姓名和年龄。
SELECT Sname,LEFT(REPLACE(CURDATE(),'-','')-LEFT(Sbirthday,8),2) AS age FROM students;
-- 39、查询Student表中最大和最小的Sbirthday日期值。
SELECT Sbirthday FROM students WHERE RIGHT(Sbirthday,4)=(SELECT MAX(RIGHT(Sbirthday,4)) FROM students);
-- 40、以班号和年龄从大到小的顺序查询Student表中的全部记录。
SELECT * FROM students ORDER BY classId DESC,Sbirthday ASC;
-- 41、查询“男”教师及其所上的课程。
SELECT Cname FROM course WHERE Tno IN(SELECT Tno FROM teacher WHERE Tsex=1);
-- 42、查询最高分同学的Sno、Cno和Degree列。
SELECT * FROM score WHERE degree=(SELECT MAX(degree) FROM score);
-- 43、查询和“张三”同性别的所有同学的Sname.
SELECT Sname FROM students WHERE Ssex=(SELECT Ssex FROM students WHERE Sname='张三') AND Sname != '张三';
-- 44、查询和“张三”同性别并同班的同学Sname.
SELECT Sname FROM students WHERE Ssex=(SELECT Ssex FROM students WHERE Sname='张三') AND classId=(SELECT classId FROM students WHERE Sname='张三') AND Sname != '张三';
-- 45、查询所有选修“数学”课程的“男”同学的成绩表
SELECT st.Sname,st.Ssex,co.Cname,sc.degree FROM students AS st JOIN score AS sc ON st.Sno=sc.Sno JOIN course AS co ON sc.Cno=co.Cno WHERE co.Cname='数学' AND st.Ssex=1;

