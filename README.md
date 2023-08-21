# Flask Web Application for Film Library

This is a simple Flask web application that provides endpoints to view movies and actors/actresses information from a PostgreSQL database it runs on a kubernetes cluster using Jenkins for CI and ArgoCD for CD. 

## Installation

1. Clone the repository to your local machine.
2. install NS
```bash
kubectl apply -f namespaces.yaml
```
2. Intall jenkins
```bash
helm repo add jenkins https://charts.jenkins.io
helm repo update
helm upgrade --install jenkins jenkins/jenkins --namespace cicd -f jenkis-values.yaml
```
3. Intall Argo
```bash
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```
4. Intall Grafana
```bash
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update
helm upgrade --install grafana grafana/grafana --namespace monitoring -f grafana-values.yaml
```
5. Intall Prometheus
```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
helm upgrade --install prometheus prometheus-community/prometheus --namespace cicd -f prom-values.yaml
```
6. Intall Database
```bash
helm install database oci://registry-1.docker.io/itsvictorfy/finalproj-db --version 1.0-00dd16d
```



