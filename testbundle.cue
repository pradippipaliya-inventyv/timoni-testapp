bundle: {
    _cluster: {
        name:  string @timoni(runtime:string:TIMONI_CLUSTER_NAME)
        group: string @timoni(runtime:string:TIMONI_CLUSTER_GROUP)
        uid:   string @timoni(runtime:string:CLUSTER_UID)
    }
    apiVersion: "v1alpha1"
    name:       "default"
    instances: {
        testapp: {

            module: {
                url: "file://."
            }
            namespace: "podinfo"
            values: {
                // Default values
                deploymentName: "my-app-deployment-\(_cluster.group)"
                serviceName:    "my-app-service-\(_cluster.group)"
                service: {
                    port: 80
                }
                image: {
                    repository: "docker.io/nginx"
                    digest: ""
                    pullPolicy: "IfNotPresent"
                }
                // Cluster specific overrides
                if _cluster.group == "kind-cluster" {
                    replicas: 1
                    image: tag: "1.29.4"
                    env: {
                        MY_ENV_VAR:  "beta-value"
                        ANOTHER_VAR: "beta-another-value"
                    }
                    hpa: {
                        enabled: true
                        minReplicas: 1
                        maxReplicas: 3
                        metrics: [
                            {
                                type: "Resource"
                                resource: {
                                    name: "cpu"
                                    target: {
                                        type: "Utilization"
                                        averageUtilization: 70
                                    }
                                }
                            }
                        ]
                    }
                    virtualService: {
                        enabled: true
                        hosts: ["beta-app.example.com"]
                        gateways: ["istio-system/beta-gateway"]
                    }
                }
                if _cluster.group == "amd-cluster" {
                    replicas: 3
                    image: tag: "1.29.5"
                    env: {
                        MY_ENV_VAR:  "prod-value"
                        ANOTHER_VAR: "prod-another-value"
                    }
                    hpa: {
                        enabled: true
                        minReplicas: 2
                        maxReplicas: 5
                        metrics: [
                            {
                                type: "Resource"
                                resource: {
                                    name: "cpu"
                                    target: {
                                        type: "Utilization"
                                        averageUtilization: 80
                                    }
                                }
                            }
                        ]
                    }
                    virtualService: {
                        enabled: true
                        hosts: ["prod-app.example.com"]
                        gateways: ["istio-system/prod-gateway"]
                    }
                }
            }
        }
    }
}