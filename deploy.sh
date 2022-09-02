echo -n 'masterpassword123.' > ./masterpassword
kubectl create secret generic rundeckpro-storage-converter --from-file=./masterpassword

echo -n 'minio' > ./awskey
echo -n 'minio123' > ./awssecret
kubectl create secret generic rundeckpro-log-storage --from-file=./awskey --from-file=./awssecret

kubectl create secret generic rundeckpro-license --from-file=./data/rundeckpro-license.key


echo -n 'rundeck123.' > ./password
kubectl create secret generic mysql-rundeckuser --from-file=./password

kubectl create secret generic rundeckpro-admin-acl --from-file=./data/admin-role.aclpolicy


kubectl apply -f persistent-volumes.yaml
kubectl apply -f minio-deployment.yaml
kubectl apply -f mysql-deployment.yaml

kubectl apply --filename https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/static/provider/kind/deploy.yaml

kubectl wait --namespace ingress-nginx \
 --for=condition=ready pod \
  --selector=app.kubernetes.io/component=controller \
  --timeout=90s
kubectl apply -f rundeckpro-deployment.yaml
