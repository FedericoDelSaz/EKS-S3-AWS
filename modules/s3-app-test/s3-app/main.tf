resource "kubectl_manifest" "s3_pv" {
  yaml_body = <<YAML
apiVersion: v1
kind: PersistentVolume
metadata:
  name: ${var.bucket_name}-pv
spec:
  capacity:
    storage: 1200Gi # ignored, required
  accessModes:
    - ReadWriteMany
  csi:
    driver: s3.csi.aws.com
    volumeHandle: ${var.bucket_name}-volume
    volumeAttributes:
      bucketName: ${var.bucket_name}
YAML
}

resource "kubectl_manifest" "s3_claim" {
  yaml_body = <<YAML
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: ${var.bucket_name}-claim
  namespace: ${var.namespace}
spec:
  accessModes:
    - ReadWriteMany
  storageClassName: ""
  resources:
    requests:
      storage: 1200Gi
  volumeName: ${var.bucket_name}-pv
YAML
  depends_on = [
    kubectl_manifest.s3_pv
  ]
}

resource "kubectl_manifest" "s3_app" {
  yaml_body = <<YAML
apiVersion: apps/v1
kind: Deployment
metadata:
  name: ${var.bucket_name}-app
  namespace: ${var.namespace}
spec:
  replicas: 2
  selector:
    matchLabels:
      app: ${var.bucket_name}-app
  template:
    metadata:
      labels:
        app: ${var.bucket_name}-app
    spec:
      containers:
        - name: app
          image: centos:centos7.9.2009
          command: ["/bin/sh"]
          args: ["-c", "echo 'Hello from the container!' >> /data/$(date -u).txt; tail -f /dev/null"]
          volumeMounts:
            - name: persistent-storage
              mountPath: /data
      volumes:
        - name: persistent-storage
          persistentVolumeClaim:
            claimName: ${var.bucket_name}-claim
YAML
  depends_on = [
    kubectl_manifest.s3_claim
  ]
}

resource "kubectl_manifest" "s3_app_service" {
  yaml_body = <<YAML
apiVersion: v1
kind: Service
metadata:
  name: ${var.bucket_name}-app-service
  namespace: ${var.namespace}
spec:
  selector:
    app: ${var.bucket_name}-app
  ports:
    - protocol: TCP
      port: 80
      targetPort: 80
  type: ClusterIP
YAML
  depends_on = [
    kubectl_manifest.s3_app
  ]
}

