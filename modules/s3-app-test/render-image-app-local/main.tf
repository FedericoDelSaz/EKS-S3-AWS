resource "kubectl_manifest" "render_image_app" {
  yaml_body = <<YAML
apiVersion: apps/v1
kind: Deployment
metadata:
  name: ${var.app_name}-app
  namespace: ${var.namespace}
  labels:
    app: ${var.app_name}
spec:
  replicas: 1
  selector:
    matchLabels:
      app: ${var.app_name}
  template:
    metadata:
      labels:
        app: ${var.app_name}
    spec:
      containers:
        - name: ${var.app_name}
          image: felodel/render-image:latest
          ports:
            - containerPort: 80
YAML
}

resource "kubectl_manifest" "s3_app_service" {
  yaml_body = <<YAML
apiVersion: v1
kind: Service
metadata:
  name: ${var.app_name}-app-service
  namespace: ${var.namespace}
spec:
  selector:
    app: ${var.app_name}
  ports:
    - protocol: TCP
      port: 80
      targetPort: 80
  type: ClusterIP
YAML
  depends_on = [
    kubectl_manifest.render_image_app
  ]
}

