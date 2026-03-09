bundle: {

    _cluster: {
        name:  string @timoni(runtime:string:TIMONI_CLUSTER_NAME)
        group: string @timoni(runtime:string:TIMONI_CLUSTER_GROUP)
        uid:   string @timoni(runtime:string:CLUSTER_UID)
    }

    apiVersion: "v1alpha1"
    name:       "podinfo"

    instances: {

        beta: {

            module: {
                url: "file://../"
            }

            namespace: "podinfo-beta"

            // run this instance only for beta clusters
            _when: _cluster.group == "kind-cluster"

            values: {

                deploymentName: "my-app-deployment-beta"
                serviceName:    "my-app-service-beta"

                replicas: 1

                service: {
                    port: 80
                }

                image: {
                    repository: "docker.io/nginx"
                    tag:        "1.29.4"
                    digest:     ""
                    pullPolicy: "IfNotPresent"
                }

                env: {
                    MY_ENV_VAR:  "beta-value"
                    ANOTHER_VAR: "beta-another-value"
                }

                hpa: {
                    enabled: true
                    minReplicas: 1
                    maxReplicas: 2
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
        }

        prod: {

            module: {
                url: "file://../"
            }

            namespace: "podinfo-prod"

            // run this instance only for prod clusters
            _when: _cluster.group == "dev-cluster"

            values: {

                deploymentName: "my-app-deployment-prod"
                serviceName:    "my-app-service-prod"

                replicas: 3

                service: {
                    port: 80
                }

                image: {
                    repository: "docker.io/nginx"
                    tag:        "1.29.5"
                    digest:     ""
                    pullPolicy: "IfNotPresent"
                }

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