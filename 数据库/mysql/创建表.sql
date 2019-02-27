-- ����maizi���ݿ�
CREATE DATABASE IF NOT EXISTS maizi DEFAULT CHARACTER SET 'UTF8';
-- ѡ��maizi���ݿ�
USE maizi;
-- ����ѧԱ��user��
-- ��� id
-- �û��� username
-- ���� age
-- �Ա� sex
-- ���� email
-- ��ַ addr
-- ���� birth
-- ���� salary
-- �绰 tel
-- �Ƿ��� married
-- ע �⣺����Ҫ��������ʱ����Ҫ��ʱת���ͻ��˵ı��뷽ʽ
-- SET NAMES GBK
-- COMMENT ���ֶ����ע��
CREATE TABLE IF NOT EXISTS `user`(
id SMALLINT,
username VARCHAR(20),
age TINYINT,
sex ENUM('��','Ů','����'),
email VARCHAR(50),
addr VARCHAR(200),
birth YEAR,
salary FLOAT(8,2),
tel INT,
married TINYINT(1) COMMENT '0����δ��飬��������ѽ��'
)ENGINE=INNODB CHARSET=UTF8;
-- �����γ̱� course
-- ��� cid
-- �γ����� courName
-- �γ����� courDESC
CREATE TABLE IF NOT EXISTS `course`(
cid SMALLINT,
courName VARCHAR(50),
courDESC VARCHAR(200)
);

-- �������ŷ���� cms_cate
-- ��� id
-- �������� cateName
-- �������� cateDESC
CREATE TABLE IF NOT EXISTS `cms_cate`(
id SMALLINT,
cateName VARCHAR(50),
cateDESC VARCHAR(200)
);

-- �������ű� cms_news
-- ��� id
-- ���ű��� newsTitle
-- �������� newsContent
-- ���ŷ���ʱ�� newsTime
-- ����� newsClickNum
-- �Ƿ��ö� stick
-- �������� cateId
-- ������ issuser
CREATE TABLE IF NOT EXISTS `cms_news`(
id SMALLINT,
newsTitle VARCHAR(200),
newsContent LONGTEXT,
pubTime DATETIME,
ClickNum INT,
isTop TINYINT(1) COMMENT '0�����ö�����������ö�',
cateId SMALLINT,
issuser VARCHAR(50)
);

-- unsigned �޷���test1, 0���zerofill 
CREATE TABLE IF NOT EXISTS `test1`(
num1 TINYINT UNSIGNED,
num2 SMALLINT ZEROFILL,
num3 MEDIUMINT ZEROFILL,
num4 INT ZEROFILL,
num5 BIGINT ZEROFILL
);
-- ���Ը�����
CREATE TABLE IF NOT EXISTS `test2`(
num1 FLOAT(8,2),
num2 DOUBLE(8,2),
num3 DECIMAL(8,2)
);
INSERT test2 VALUES(3.1495,3.1495,3.1495);
SELECT * FROM test2 WHERE num3='3.15';
-- ����ö������ENUM
CREATE TABLE IF NOT EXISTS test3(
sex ENUM('��','Ů','����')
);
INSERT test3 value('��');
INSERT test3 value('Ů');
INSERT test3 value('����');
INSERT test3 value(2);
-- ���Լ�������set
CREATE TABLE IF NOT EXISTS test4(
fav SET('A','B','C','D')
);
INSERT test4 value('A,B,D');
INSERT test4 value('D,C,A');
INSERT test4 value(15);