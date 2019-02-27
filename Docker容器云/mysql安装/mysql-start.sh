container_name=mysql-server
mysql_dir=/opt/mysql


docker rm -f $container_name

docker run -p 3306:3306 --name $container_name -v $mysql_dir/conf/my.cnf:/etc/mysql/my.cnf -v $mysql_dir/log:/var/log/mysql/ -v $mysql_dir/data:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=root -d mysql:5.6
#docker run -p 3306:3306 --name $container_name -e MYSQL_ROOT_PASSWORD=root -d mysql:5.6
