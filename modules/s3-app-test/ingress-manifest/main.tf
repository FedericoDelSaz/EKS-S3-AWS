resource "kubectl_manifest" "ingress" {
  yaml_body = <<YAML
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: nginx-ingress
  namespace: ${var.namespace}
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /$1
    nginx.ingress.kubernetes.io/use-regex: "true"
    cert-manager.io/cluster-issuer: ${var.issuer_name}
    alb.ingress.kubernetes.io/load-balancer-name: ${var.alb_name}
    alb.ingress.kubernetes.io/scheme: internet-facing
    alb.ingress.kubernetes.io/target-type: instance
    alb.ingress.kubernetes.io/load-balancer-attributes: idle_timeout.timeout_seconds=60
spec:
  ingressClassName: alb
  tls:
    - hosts:
        - new-work-se-test.com
      secretName: new-work-se-test-tls
  rules:
    - host: new-work-se-test.com
      http:
        paths:
          - path: /hello/?(.*)
            pathType: ImplementationSpecific
            backend:
              service:
                name: nginx-service
                port:
                  number: 80
          - path: /render-image-local/?(.*)
            pathType: ImplementationSpecific
            backend:
              service:
                name: render-image-local-app-service
                port:
                  number: 80
          - path: /render-image/?(.*)
            pathType: ImplementationSpecific
            backend:
              service:
                name: render-image-app-service
                port:
                  number: 80
YAML
}