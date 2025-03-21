resource "aws_s3_bucket" "s3_bucket_driver" {
  bucket = var.bucket_name

  tags = {
    Name        = var.bucket_name
    Environment = var.environment
  }
}

# S3 Bucket policy to allow access from the EKS service account used by the CSI driver
resource "aws_s3_object" "bucket_policy" {
  bucket  = aws_s3_bucket.s3_bucket_driver.bucket
  key     = "bucket-policy.json"
  acl     = "private"
  content = <<EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": "*",
        "Action": [
                "s3:PutObject",
                "s3:GetObject",
                "s3:DeleteObject",
                "s3:AbortMultipartUpload",
                "s3:ListBucket"
            ],
        "Resource": "arn:aws:s3:::${aws_s3_bucket.s3_bucket_driver.bucket}/*",
        "Condition": {
          "StringEquals": {
            "aws:PrincipalTag/eks.amazonaws.com/serviceaccount": "true"
          }
        }
      }
    ]
  }
  EOF
}

#resource "aws_s3_object" "image_upload" {
#  bucket = aws_s3_bucket.s3_bucket_driver.bucket
#  key    = "image.jpg"  # Path inside the S3 bucket
#  source = "/home/flo/git-private/new-work-test/modules/s3-app-test/render-image-app/images/image.jpg"  # Local file path
#  acl    = "public-read" # Change if needed
#}

resource "kubectl_manifest" "retain_storage_class" {
  yaml_body = <<YAML
kind: StorageClass
apiVersion: storage.k8s.io/v1
metadata:
  name: render-image-retain
provisioner: s3.csi.aws.com
reclaimPolicy: Retain
parameters:
  type: standart
  mounter: s3fs
  bucketName: ${var.bucket_name}
volumeBindingMode: Immediate
reclaimPolicy: Retain
YAML
}

resource "kubectl_manifest" "render_image_pv" {
  yaml_body = <<YAML
apiVersion: v1
kind: PersistentVolume
metadata:
  name: render-image-pv
spec:
  capacity:
    storage: 1Gi
  volumeMode: Filesystem
  accessModes:
    - ReadWriteMany
  persistentVolumeReclaimPolicy: Retain
  csi:
    driver: s3.csi.aws.com
    volumeHandle: ${var.bucket_name}-volume
    volumeAttributes:
      bucketName: ${var.bucket_name}
  mountOptions:
    - dir-mode=0777
    - file-mode=0666
    - allow-delete
    - allow-other
    - allow-overwrite
    - uid=1000
    - gid=1000
    - region eu-west-1
  storageClassName: render-image-retain
YAML
  lifecycle {
    prevent_destroy = true
  }
}

resource "kubectl_manifest" "render_image_claim" {
  yaml_body = <<YAML
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: render-image-pvc
  namespace: ${var.namespace}
spec:
  accessModes:
    - ReadWriteMany
  resources:
    requests:
      storage: 1Gi
  storageClassName: render-image-retain
YAML

  lifecycle {
    prevent_destroy = true
  }

  depends_on = [
    kubectl_manifest.render_image_pv
  ]
}

resource "kubectl_manifest" "render_image_app" {
  yaml_body = <<YAML
apiVersion: apps/v1
kind: Deployment
metadata:
  name: render-image-app
  namespace: ${var.namespace}
  labels:
    app: render-image
spec:
  replicas: 1
  selector:
    matchLabels:
      app: render-image
  template:
    metadata:
      labels:
        app: render-image
    spec:
      containers:
        - name: render-image
          image: nginx:alpine
          ports:
            - containerPort: 80
          volumeMounts:
            - name: s3-volume
              mountPath: /usr/share/nginx/html/
      volumes:
        - name: s3-volume
          persistentVolumeClaim:
            claimName: render-image-pvc
YAML
  depends_on = [
    kubectl_manifest.render_image_claim
  ]
}

resource "kubectl_manifest" "s3_app_service" {
  yaml_body = <<YAML
apiVersion: v1
kind: Service
metadata:
  name: render-image-app-service
  namespace: ${var.namespace}
spec:
  selector:
    app: render-image
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

