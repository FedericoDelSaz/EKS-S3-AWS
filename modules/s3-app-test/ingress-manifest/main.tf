resource "kubectl_manifest" "ingress" {
  yaml_body = <<YAML
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: nginx-ingress
  namespace: ${var.namespace}
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
    cert-manager.io/cluster-issuer: ${var.issuer_name}
spec:
  ingressClassName: nginx
  tls:
    - hosts:
        - new-work-se-test.com
      secretName: new-work-se-test-tls  # Cert will be stored in this secret
  rules:
    - host: new-work-se-test.com
      http:
        paths:
          - path: /hello
            pathType: Prefix
            backend:
              service:
                name: nginx-service
                port:
                  number: 80
YAML
}