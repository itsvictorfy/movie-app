provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = "gke_victor-finalproj_europe-north1-a_finalproj-cluster"
}
#Configure Helm Provider
provider "helm" {
  kubernetes {
  config_path    = "~/.kube/config"
  config_context = "gke_victor-finalproj_europe-north1-a_finalproj-cluster"
  }
}

#Create Namesapce cicd
resource "kubernetes_namespace" "cicd" {
  metadata {
    name = "cicd"
  }
}
#Create Namesapce monitoring
resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = "monitoring"
  }
}
#Create Namesapce dev
resource "kubernetes_namespace" "dev" {
  metadata {
    name = "dev"
  }
}
#Create Namesapce stage
resource "kubernetes_namespace" "stage" {
  metadata {
    name = "stage"
  }
}
#Create Namesapce Prod
resource "kubernetes_namespace" "prod" {
  metadata {
    name = "prod"
  }
}
#Create Namesapce Database
resource "kubernetes_namespace" "database" {
  metadata {
    name = "database"
  }
}
#Install Prometheus using Helm
resource "helm_release" "prometheus" {
  chart = "prometheus"
  name = "prometheus"
  namespace = "monitoring"
  repository = "https://prometheus-community.github.io/helm-charts"
  version    = "15.5.3"
  set {
    name  = "server.persistentVolume.enabled"
    value = false
  }
  set {
    name  = "service.type"
    value = "LoadBalancer"
  }
  set {
    name = "server\\.resources"
    value = yamlencode({
      limits = {
        cpu    = "200m"
        memory = "50Mi"
      }
      requests = {
        cpu    = "100m"
        memory = "30Mi"
      }
    })
  }
}
#Install Grafana using Helm
resource "helm_release" "grafana" {
  name = "grafana"
  namespace = "monitoring"
  repository = "https://grafana.github.io/helm-charts"
  chart = "grafana"
    set {
    name  = "service.type"
    value = "LoadBalancer"
  }
}
#Install Jenkins using Helm
resource "helm_release" "jenkins" {
  name      = "jenkins"
  namespace = "cicd"
  repository = "https://charts.jenkins.io"
  chart     = "jenkins"
  set {
    name  = "controller.serviceType"
    value = "LoadBalancer"
  }
  set {
    name  = "controller.installPlugins" 
    value = jsonencode([
      "kubernetes:3937.vd7b_82db_e347b_",
      "workflow-aggregator:596.v8c21c963d92d",
      "git:5.1.0",
      "configuration-as-code:1647.ve39ca_b_829b_42",
      "blueocean:1.27.4",
      "docker-plugin:1.4"
    ])
  }
  set {
    name = "agent.image"
    value = "jenkins/jnlp-agent-docker"
  }

  set {
    name = "agent.tag"
    value = "jenkinsSlave"
  }

  set {
    name  = "controler.targetPort"
    value = 80
  }
}
resource "helm_release" "argocd" {
  name      = "argocd"
  namespace = "cicd"
  repository = "https://argoproj.github.io/argo-helm"
  chart     = "argo-cd"
  set {
    name = "service.type"
    value = "LoadBalancer"
  }
}

resource "helm_release" "nginx_ingress" {
  name       = "nginx-ingress"
  namespace = "cicd"
  repository = "ococi://ghcr.io/nginxinc/charts/nginx-ingress"
  chart      = "nginx-ingress-ntroller"
  version    = "10.1.2"  

  set {
    name  = "controller.publishService.enabled"
    value = "true"
  }
}
