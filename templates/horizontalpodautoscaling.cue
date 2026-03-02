package templates

import (
	autoscalingv2 "k8s.io/api/autoscaling/v2"
)

#HorizontalPodAutoscaling: autoscalingv2.#HorizontalPodAutoscaler & {
	_config:    #Config
	apiVersion: "autoscaling/v2"
	kind:       "HorizontalPodAutoscaler"
	metadata:   _config.metadata
	if _config.hpa.annotations != _|_ {
		metadata: annotations: _config.hpa.annotations
	}
	spec: autoscalingv2.#HorizontalPodAutoscalerSpec & {
		scaleTargetRef: {
			apiVersion: "apps/v1"
			kind:       "Deployment"
			name:       _config.deploymentName
		}
		if _config.hpa.minReplicas != _|_ {
			minReplicas: _config.hpa.minReplicas
		}
		maxReplicas: _config.hpa.maxReplicas
		if _config.hpa.metrics != _|_ {
			metrics: _config.hpa.metrics
		}
		if _config.hpa.behavior != _|_ {
			behavior: _config.hpa.behavior
		}
	}
}
