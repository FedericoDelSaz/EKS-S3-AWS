resource "kubectl_manifest" "hello_config_map" {
  yaml_body = <<YAML
apiVersion: v1
kind: ConfigMap
metadata:
  name: nginx-html
  namespace: ${var.namespace}
data:
  index.html: |
    <html>
      <head><title>Hello, World!</title></head>
      <body>
        <h1>Hello, Kubernetes!</h1>
      </body>
    </html>
YAML
}

resource "kubectl_manifest" "hello_deploy" {
  yaml_body = <<YAML
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-hello
  namespace: ${var.namespace}
spec:
  replicas: 1
  selector:
    matchLabels:
      app: nginx-hello
  template:
    metadata:
      labels:
        app: nginx-hello
    spec:
      containers:
        - name: nginx
          image: nginx:latest
          ports:
            - containerPort: 80
          volumeMounts:
            - name: html-volume
              mountPath: /usr/share/nginx/html
      volumes:
        - name: html-volume
          configMap:
            name: nginx-html
YAML
}

resource "kubectl_manifest" "hello_service" {
  yaml_body = <<YAML
apiVersion: v1
kind: Service
metadata:
  name: nginx-service
  namespace: ${var.namespace}
spec:
  selector:
    app: nginx-hello
  ports:
    - protocol: TCP
      port: 80
      targetPort: 80
  type: ClusterIP
YAML
}