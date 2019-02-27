-- 创建maizi数据库
CREATE DATABASE IF NOT EXISTS maizi DEFAULT CHARACTER SET 'UTF8';
-- 选择maizi数据库
USE maizi;
-- 创建学员表（user）
-- 编号 id
-- 用户名 username
-- 年龄 age
-- 性别 sex
-- 邮箱 email
-- 地址 addr
-- 生日 birth
-- 工资 salary
-- 电话 tel
-- 是否结婚 married
-- 注 意：当需要输入中文时候，需要零时转换客户端的编码方式
-- SET NAMES GBK
-- COMMENT 给字段添加注释
CREATE TABLE IF NOT EXISTS `user`(
id SMALLINT,
username VARCHAR(20),
age TINYINT,
sex ENUM('男','女','保密'),
email VARCHAR(50),
addr VARCHAR(200),
birth YEAR,
salary FLOAT(8,2),
tel INT,
married TINYINT(1) COMMENT '0代表未结婚，非零代表已结婚'
)ENGINE=INNODB CHARSET=UTF8;
-- 创建课程表 course
-- 编号 cid
-- 课程名字 courName
-- 课程描述 courDESC
CREATE TABLE IF NOT EXISTS `course`(
cid SMALLINT,
courName VARCHAR(50),
courDESC VARCHAR(200)
);

-- 创建新闻分类表 cms_cate
-- 编号 id
-- 分类名称 cateName
-- 分类描述 cateDESC
CREATE TABLE IF NOT EXISTS `cms_cate`(
id SMALLINT,
cateName VARCHAR(50),
cateDESC VARCHAR(200)
);

-- 创建新闻表 cms_news
-- 编号 id
-- 新闻标题 newsTitle
-- 新闻内容 newsContent
-- 新闻发布时间 newsTime
-- 点击量 newsClickNum
-- 是否置顶 stick
-- 所属分类 cateId
-- 发布人 issuser
CREATE TABLE IF NOT EXISTS `cms_news`(
id SMALLINT,
newsTitle VARCHAR(200),
newsContent LONGTEXT,
pubTime DATETIME,
ClickNum INT,
isTop TINYINT(1) COMMENT '0代表不置顶，非零代表置顶',
cateId SMALLINT,
issuser VARCHAR(50)
);

-- unsigned 无符号test1, 0填充zerofill 
CREATE TABLE IF NOT EXISTS `test1`(
num1 TINYINT UNSIGNED,
num2 SMALLINT ZEROFILL,
num3 MEDIUMINT ZEROFILL,
num4 INT ZEROFILL,
num5 BIGINT ZEROFILL
);
-- 测试浮点数
CREATE TABLE IF NOT EXISTS `test2`(
num1 FLOAT(8,2),
num2 DOUBLE(8,2),
num3 DECIMAL(8,2)
);
INSERT test2 VALUES(3.1495,3.1495,3.1495);
SELECT * FROM test2 WHERE num3='3.15';
-- 测试枚举类型ENUM
CREATE TABLE IF NOT EXISTS test3(
sex ENUM('男','女','保密')
);
INSERT test3 value('男');
INSERT test3 value('女');
INSERT test3 value('保密');
INSERT test3 value(2);
-- 测试集合类型set
CREATE TABLE IF NOT EXISTS test4(
fav SET('A','B','C','D')
);
INSERT test4 value('A,B,D');
INSERT test4 value('D,C,A');
INSERT test4 value(15);