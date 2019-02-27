docker rm -f mongodb

docker run --name=mongodb -p 27017:27017 -v /opt/mongo/data:/data/db -d mongo
