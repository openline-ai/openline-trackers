
docker stop local-sql-runner
docker rm local-sql-runner
docker build --platform=linux/amd64 -t local-sql-runner:latest -f Dockerfile .
docker run -d --name local-sql-runner --network host local-sql-runner:latest
docker logs -f local-sql-runner
