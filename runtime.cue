runtime: {
    apiVersion: "v1alpha1"
    name:       "fleet"

    clusters: {
        "kind-cluster": {
            group:       "kind-cluster"
            kubeContext: "kind-cluster"
        }

        "dev-cluster": {
            group:       "dev-cluster"
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