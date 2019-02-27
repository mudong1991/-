SELECT id,sex,GROUP_CONCAT(username) AS all_username,
COUNT(*) AS total,
MAX(age) AS max_age,
MIN(age) AS min_age,
AVG(age) AS avg_age,
SUM(age) AS sum_age
FROM cms_user GROUP BY sex
HAVING total>1 ORDER BY age DESC;
-- 外键约束
CREATE TABLE IF NOT EXISTS department(
id TINYINT UNSIGNED KEY AUTO_INCREMENT,
dep_name VARCHAR(20) UNIQUE
);
INSERT department(dep_name) VALUES('技术部'),('运行部'),('尼玛部'),('傻逼部');


CREATE TABLE IF NOT EXISTS employee(
id SMALLINT UNSIGNED KEY AUTO_INCREMENT,
name VARCHAR(20) UNIQUE NULL NULL,
depId TINYINT UNSIGNED,
FOREIGN KEY(depId) REFERENCES department(id)
)ENGINE = INNODB;
INSERT employee(name,depId) VALUES('母东',1),('马杰',2),('大力',3),('万鸡',2),('锤子',4);