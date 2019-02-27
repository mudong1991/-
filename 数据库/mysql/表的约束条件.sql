-- ����
CREATE TABLE IF NOT EXISTS user1(
id INT PRIMARY KEY,
username VARCHAR(20)
);
-- �鿴������ı���
SHOW CREATE TABLE user1;
--��������
CREATE TABLE IF NOT EXISTS user2(
id INT,
username VARCHAR(20),
card CHAR(18),
PRIMARY KEY(id, card)
);
INSERT user2 VALUE(1,'mudong',218391283);
-- ����������
CREATE TABLE IF NOT EXISTS user3(
id SMALLINT KEY AUTO_INCREMENT,
username VARCHAR(20)
);
DESC user3;
INSERT user3 VALUE(1,'mudong');
INSERT user3(username) VALUE('dengqiu');
CREATE TABLE IF NOT EXISTS user4(
id SMALLINT KEY AUTO_INCREMENT,
username VARCHAR(20)
)AUTO_INCREMENT=100;-- ����Ĭ�ϴ�100��ʼ������
-- ���ñ�������
ALTER TABLE user4 AUTO_INCREMENT=500;
-- ����Ĭ��ֵ
-- ���Լ���
CREATE TABLE IF NOT EXISTS user5(
id INT PRIMARY KEY AUTO_INCREMENT,
love SET('mudong','dengqiu','mama','baba')
)ENGINE=MYISAM CHARSET=utf8;
INSERT user5 VALUE(2,'mudong,mama');
INSERT user5 VALUE(1,3);

-- ����һ���û���
CREATE TABLE IF NOT EXISTS user6(
id SMALLINT UNSIGNED KEY AUTO_INCREMENT,
username VARCHAR(20) NOT NULL UNIQUE,
passwd VARCHAR(32) NOT NULL,
email VARCHAR(50) NOT NULL default 'mudong@qq.com',
age TINYINT UNSIGNED DEFAULT 18,
addr VARCHAR(200) DEFAULT '����',
sex ENUM('��','Ů','����') DEFAULT '����',
salary FLOAT(8,2),
regTime INT UNSIGNED,
face CHAR(100) DEFAULT 'default.jpg',
card CHAR(18)
);
-- ����ֶ�
ALTER TABLE user6 ADD test1 TINYINT NOT NULL UNIQUE;
ALTER TABLE user6 ADD test VARCHAR(20) NOT NULL UNIQUE AFTER age;
-- ɾ���ֶ�
ALTER TABLE user6 DROP test,DROP test1;
-- �޸��ֶ�
ALTER TABLE user6 MODIFY email VARCHAR(210) NOT NULL DEFAULT '471166308@qq.com';
ALTER TABLE user6 MODIFY card char(18) AFTER addr;
ALTER TABLE user6 CHANGE test test1 VARCHAR(200) NOT NULL AFTER salary;
-- �������
