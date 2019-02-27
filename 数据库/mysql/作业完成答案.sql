-- һ������ѧ���ɼ����ݿ�
CREATE DATABASE IF NOT EXISTS cms_student; 
use cms_student;

-- ����ѧ����(students)��ѧ�ţ�SNO��������(SNAME)���Ա�(SSEX)������(SBIRTHDAY )�������༶(CLASS )
CREATE TABLE IF NOT EXISTS students(
Sno SMALLINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
Sname VARCHAR(20) NOT NULL UNIQUE,
Ssex ENUM('��','Ů','����') DEFAULT '����',
Sbirthday INT,
classId SMALLINT UNSIGNED NOT NULL 
);
-- ��students���в�������
INSERT students VALUES(1,'����',1,19920103,1);
INSERT students VALUES(2,'����',3,19910923,2);
INSERT students VALUES(3,'tom',2,19921202,3);
INSERT students VALUES(4,'king',2,19921102,4);
INSERT students VALUES(5,'mudong',1,19930312,5);
INSERT students VALUES(6,'dongdong',3,19930223,6);
INSERT students VALUES(7,'������',1,19911203,7);
INSERT students VALUES(8,'lemon',2,19900802,5);
INSERT students VALUES(9,'����',2,19911213,1);
INSERT students VALUES(10,'���Ĺ�',1,19910423,3);

-- �����γ̱�(course)���γ̱��(CNO)���γ���(CNAME)���ڿ���ʦ(TNO)
CREATE TABLE IF NOT EXISTS course(
Cno SMALLINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
Cname VARCHAR(50) NOT NULL UNIQUE,
Tno SMALlINT UNSIGNED
);
-- ��course���в�������
INSERT course VALUES(1,'����',1),(2,'��ѧ',2)
,(3,'��ѧ',3)
,(4,'����',4)
,(5,'�����',1)
,(6,'����',7)
,(7,'����',3)
,(8,'����',1)
,(9,'����',8)
,(10,'����',9);

-- �����ɼ���(score):ѧ��(SNO)���γ̱��(CNO)���÷�(DEGREE)
CREATE TABLE IF NOT EXISTS score(
Sno SMALLINT UNSIGNED,
Cno SMALLINT UNSIGNED,
degree TINYINT
);
-- ��score���в�������
INSERT score VALUES(1,1,90),(1,2,80),(2,1,60),(2,2,30),(2,4,33),(5,2,31),(5,6,82),(6,7,50),(8,2,100),(8,3,94),(7,2,75),(3,1,100);

-- ������ʦ��(teacher):��ʦ���(TNO)����ʦ����(TNAME)���Ա�(TSSEX)������(TBIRTHDAY)��ְ��(TITLE)����λ���ң�DEPART��
CREATE TABLE IF NOT EXISTS teacher(
Tno SMALLINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
Tname VARCHAR(20) NOT NULL,
Tsex ENUM('��','Ů','����') DEFAULT '����',
Tbirthday INT,
Title VARCHAR(100),
depart VARCHAR(100)
);
-- ��teacher���в�������
INSERT teacher VALUES(1,'����ʦ',1,19810802,'�߼���ʦ','�����ϵ'),
(2,'����ʦ',1,19820802,'�ؼ���ʦ','���ӹ���ϵ'),
(3,'����ʦ',2,19800221,'��ͨ��ʦ','���ӹ���ϵ'),
(4,'����ʦ',2,19781121,'��ͨ��ʦ','���ӹ���ϵ'),
(5,'����ʦ',2,19830324,'�߼���ʦ','�����ϵ'),
(6,'ĸ��ʦ',2,19821224,'��ͨ��ʦ','�����ϵ'),
(7,'����ʦ',1,19801201,'�ؼ�ʦ','�����ϵ'),
(8,'����ʦ',2,19791111,'�߼���ʦ','���ӹ���ϵ'),
(9,'����ʦ',1,19820324,'�߼���ʦ','�����ϵ'),
(10,'����ʦ',2,19800902,'�߼���ʦ','�����ϵ');



-- ������ɲ�ѯ��Ŀ
-- 1�� ��ѯStudent���е����м�¼��Sname��Ssex��Class�С�
SELECT Sname,Ssex,classId FROM students;
-- 2�� ��ѯ��ʦ���еĵ�λ�����ظ���Depart�С�
SELECT * FROM teacher GROUP BY depart;
-- 3�� ��ѯStudent������м�¼��
SELECT * FROM students;
-- 4�� ��ѯScore���гɼ���60��80֮������м�¼��
SELECT * FROM score WHERE 60<=degree AND degree<=80;
-- 5�� ��ѯScore���гɼ�Ϊ85��86��88�ļ�¼��
SELECT * FROM score WHERE degree IN(85,86,88);
-- 6�� ��ѯStudent���С�95031������Ա�Ϊ��Ů����ͬѧ��¼��
SELECT * FROM students WHERE classId=95031 OR Ssex='Ů';
-- 7�� ��Class�����ѯStudent������м�¼��
SELECT * FROM students ORDER BY classId DESC;
-- 8�� ��Cno����Degree�����ѯScore������м�¼��
SELECT * FROM score ORDER BY Cno ASC,degree DESC;
-- 9�� ��ѯ��95031�����ѧ��������
SELECT COUNT(*) FROM students WHERE classId=95031;
-- 10����ѯScore���е���߷ֵ�ѧ��ѧ�źͿγ̺š�
SELECT Sno,Cno,degree FROM score WHERE degree=(SELECT MAX(degree) FROM score);
-- 11����ѯ��3-105���ſγ̵�ƽ���֡�
SELECT AVG(degree) FROM score WHERE Cno='3-105';
SELECT AVG(degree) FROM score GROUP BY Cno HAVING Cno='3-105';
-- 12����ѯScore����������5��ѧ��ѡ�޵Ĳ���3��ͷ�Ŀγ̵�ƽ��������
SELECT AVG(degree) FROM score WHERE Cno REGEXP '^3.*' GROUP BY Cno HAVING COUNT(*)>=5;
-- 13����ѯ��ͷִ���70����߷�С��90��Sno�С�
SELECT * FROM score GROUP BY Sno HAVING MAX(degree)<90 AND MIN(degree)>70;
-- 14����ѯ����ѧ����Sname��Cno��Degree�С�
SELECT st.Sname,sc.Cno,sc.degree FROM students AS st JOIN score AS sc ON st.Sno=sc.Sno;
-- 15����ѯ����ѧ����Sno��Cname��Degree�С�
SELECT st.Sno,st.Sname,sc.degree FROM students AS st JOIN score AS sc ON st.Sno=sc.Sno;
-- 16����ѯ����ѧ����Sname��Cname��Degree�С�
SELECT st.Sname,co.Cname,sc.degree FROM students AS st JOIN score AS sc ON st.Sno=sc.Sno JOIN course AS co ON co.Cno=sc.Cno;
-- 17����ѯ��95033������ѡ�γ̵�ƽ���֡�
SELECT AVG(degree) FROM score WHERE score.Sno IN(SELECT GROUP_CONCAT(students.Sno) FROM students GROUP BY classId HAVING classId=1);
create table grade(low int,upp int,rank char(1));
insert into grade values(90,100,'A');
insert into grade values(80,89,'B');
insert into grade values(70,79,'C');
insert into grade values(60,69,'D');
insert into grade values(0,59,'E');
commit;
-- 18���ֲ�ѯ����ͬѧ��Sno��Cno��rank�С�
SELECT sc.Sno,sc.Cno,g.rank FROM score AS sc LEFT JOIN grade AS g ON sc.degree>=g.low AND sc.degree<=g.upp ORDER BY sc.Sno;
-- 19����ѯѡ�ޡ�1���γ̵ĳɼ����ڡ�1����ͬѧ�ɼ�������ͬѧ�ļ�¼��
SELECT Sno,Cno,degree FROM score WHERE degree>(SELECT degree FROM score WHERE Sno=1 AND Cno=1) AND Cno=1;
-- #20����ѯscore��ѡѧһ�����Ͽγ̵�ͬѧ�з���Ϊ����߷ֳɼ��ļ�¼��
SELECT * FROM score WHERE Sno IN(SELECT Sno FROM score GROUP BY Sno HAVING COUNT(Cno)>1 AND degree<MAX(degree));
-- 21����ѯ�ɼ�����ѧ��Ϊ��1�����γ̺�Ϊ��2���ĳɼ������м�¼��
SELECT * FROM score WHERE degree>(SELECT degree FROM score WHERE Sno=1 AND Cno=2);
-- 22����ѯ��ѧ��Ϊ1��ͬѧͬ�����������ѧ����Sno��Sname��Sbirthday�С�
SELECT * FROM students WHERE LEFT(Sbirthday,4)=(SELECT LEFT(Sbirthday,4) FROM students WHERE Sno=1);
-- 23����ѯ������ʦ����ʦ�οε�ѧ���ɼ���
SELECT Sno,Cno,degree,'����ʦ' FROM score WHERE Cno IN(SELECT c.Cno FROM course AS c JOIN teacher AS t ON c.Tno=t.Tno WHERE Tname='����ʦ');
-- 24����ѯѡ��ĳ�γ̵�ͬѧ��������5�˵Ľ�ʦ������
SELECT t.Tname,c.Cname,GROUP_CONCAT(s.Sno)FROM score AS s JOIN course AS c ON c.Cno=s.Cno JOIN teacher AS t ON c.Tno=t.Tno GROUP BY s.Cno HAVING COUNT(s.Sno)>2;
-- 25����ѯ1���2��ȫ��ѧ���ļ�¼��
SELECT * FROM students WHERE classId=1 OR classId=2;
-- 26����ѯ������85�����ϳɼ��Ŀγ�Cno.
SELECT Cno,GROUP_CONCAT(degree) FROM score WHERE degree>85 GROUP BY Cno; 
-- 27����ѯ���������ϵ����ʦ���̿γ̵ĳɼ���
SELECT * FROM score WHERE Cno IN(SELECT Cno FROM course WHERE Tno IN(SELECT Tno FROM teacher WHERE depart='�����ϵ'));
-- 28����ѯ�������ϵ���롰���ӹ���ϵ����ְͬ�ƵĽ�ʦ��Tname��
SELECT Tname FROM teacher WHERE depart='�����ϵ' AND Title NOT IN(SELECT Title FROM teacher WHERE depart='���ӹ���ϵ');
-- 29����ѯѡ�ޱ��Ϊ��1���γ��ҳɼ����ٸ���ѡ�ޱ��Ϊ��2����ͬѧ��Cno��Sno��Degree,����Degree�Ӹߵ��ʹ�������
SELECT Cno,Sno,degree FROM score WHERE degree > (SELECT MAX(degree) FROM score WHERE Cno=2) AND Cno=1 ORDER BY degree DESC;
-- 30����ѯѡ�ޱ��Ϊ��1���ҳɼ�����ѡ�ޱ��Ϊ��2���γ̵�ͬѧ��Cno��Sno��Degree.
SELECT Cno,Sno,degree FROM score WHERE degree > (SELECT MAX(degree) FROM score WHERE Cno=2) AND Cno=1;
-- 31����ѯ���н�ʦ��ͬѧ��name��sex��birthday.
SELECT s.Sname AS name,s.Ssex AS sex,s.Sbirthday AS birthday FROM students AS s UNION SELECT t.Tname,t.Tsex,t.Tbirthday FROM teacher AS t;
-- 32����ѯ���С�Ů����ʦ�͡�Ů��ͬѧ��name��sex��birthday.
SELECT s.Sname AS name,s.Ssex AS sex,s.Sbirthday AS birthday FROM students AS s  WHERE s.Ssex='Ů' UNION SELECT t.Tname,t.Tsex,t.Tbirthday FROM teacher AS t WHERE t.Tsex=2;
-- #33����ѯ�ɼ��ȸÿγ�ƽ���ɼ��͵�ͬѧ�ĳɼ���
SELECT * FROM score WHERE Sno IN(SELECT Sno FROM score GROUP BY Cno HAVING degree<AVG(degree));
-- 34����ѯ�����ον�ʦ��Tname��Depart.
SELECT Tname,depart FROM teacher WHERE Tno IN(SELECT Tno FROM course);
-- 35 ��ѯ����δ���εĽ�ʦ��Tname��Depart. 
SELECT Tname,depart FROM teacher WHERE Tno NOT IN(SELECT Tno FROM course);
-- 36����ѯ������2�������İ�š�
SELECT classId,GROUP_CONCAT(Sno) FROM students WHERE Ssex=1 GROUP BY classId HAVING COUNT(Sno)>1;
-- 37����ѯStudent���в��ա�������ͬѧ��¼��
SELECT * FROM students WHERE Sname NOT REGEXP '^��.*';
-- 38����ѯStudent����ÿ��ѧ�������������䡣
SELECT Sname,LEFT(REPLACE(CURDATE(),'-','')-LEFT(Sbirthday,8),2) AS age FROM students;
-- 39����ѯStudent����������С��Sbirthday����ֵ��
SELECT Sbirthday FROM students WHERE RIGHT(Sbirthday,4)=(SELECT MAX(RIGHT(Sbirthday,4)) FROM students);
-- 40���԰�ź�����Ӵ�С��˳���ѯStudent���е�ȫ����¼��
SELECT * FROM students ORDER BY classId DESC,Sbirthday ASC;
-- 41����ѯ���С���ʦ�������ϵĿγ̡�
SELECT Cname FROM course WHERE Tno IN(SELECT Tno FROM teacher WHERE Tsex=1);
-- 42����ѯ��߷�ͬѧ��Sno��Cno��Degree�С�
SELECT * FROM score WHERE degree=(SELECT MAX(degree) FROM score);
-- 43����ѯ�͡�������ͬ�Ա������ͬѧ��Sname.
SELECT Sname FROM students WHERE Ssex=(SELECT Ssex FROM students WHERE Sname='����') AND Sname != '����';
-- 44����ѯ�͡�������ͬ�Ա�ͬ���ͬѧSname.
SELECT Sname FROM students WHERE Ssex=(SELECT Ssex FROM students WHERE Sname='����') AND classId=(SELECT classId FROM students WHERE Sname='����') AND Sname != '����';
-- 45����ѯ����ѡ�ޡ���ѧ���γ̵ġ��С�ͬѧ�ĳɼ���
SELECT st.Sname,st.Ssex,co.Cname,sc.degree FROM students AS st JOIN score AS sc ON st.Sno=sc.Sno JOIN course AS co ON sc.Cno=co.Cno WHERE co.Cname='��ѧ' AND st.Ssex=1;

