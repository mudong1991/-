-- 创建一个user的数据表
CREATE TABLE IF NOT EXISTS user(
id SMALLINT UNSIGNED KEY AUTO_INCREMENT,
username VARCHAR(20) NOT NULL,
password CHAR(32) NOT NULL,
email VARCHAR(50) NOT NULL DEFAULT 'mudong@qq.com',
age TINYINT UNSIGNED
);
-- 向user表中插入数据
INSERT user VALUES(1,'mudong',123456,'adda@qq.com',24);
INSERT user(username,password,age) VALUES('tom',123123,26);
INSERT user VALUES(3,'dengqiu',123456,'dengqiu@qq.com',25);
-- 更新数据
UPDATE user SET age=24;
UPDATE user SET password='ksdlakfj',age=age-2 WHERE id=1;
UPDATE user SET password='ksdlakfj',age=age-2 WHERE id>=1;
UPDATE user SET email=DEFAULT WHERE id>=2;
