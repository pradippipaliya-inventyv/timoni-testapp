runtime: {
    apiVersion: "v1alpha1"
    name:       "fleet"

    clusters: {
        "beta-cluster": {
            group:       "kind-cluster"
            kubeContext: "kind-cluster"
        }

        "prod-cluster": {
            group:       "amd-cluster"
            kubeContext: "ab-cluster"
        }
    }

    values: [
        {
            query: "k8s:v1:Namespace:default"
            for: {
                "CLUSTER_UID": "obj.metadata.uid"
            }
        },
    ]
}