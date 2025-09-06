cd Docker
docker build -t extract:v1 -f extract.Dockerfile .
docker build -t transform:v1 -f transform.Dockerfile .
docker build -t load:v1 -f load.Dockerfile .
k3d image load extract:v1 -c test-cluster
k3d image load transform:v1 -c test-cluster
k3d image load load:v1 -c test-cluster
docker build -t run-model:v1 -f earnings_model.Dockerfile .
docker build -t deploy-dashboard:v1 -f deploy_dashboard.Dockerfile .
k3d image load run-model:v1 -c test-cluster
k3d image load deploy-dashboard:v1 -c test-cluster