package templates

#VirtualService: {
	#config:    #Config
	apiVersion: "networking.istio.io/v1beta1"
	kind:       "VirtualService"
	metadata: {
		if #config.virtualService.name != _|_ {
			name: #config.virtualService.name
		}
		if #config.virtualService.name == _|_ {
			name: #config.metadata.name
		}
		namespace: #config.metadata.namespace
		labels:    #config.metadata.labels
		if #config.virtualService.annotations != _|_ {
			annotations: #config.virtualService.annotations
		}
	}
	spec: {
		hosts:    #config.virtualService.hosts
		gateways: #config.virtualService.gateways
		http: [
			{
				route: [
					{
						destination: {
							host: #config.serviceName
							port: {
								number: #config.service.port
							}
						}
					},
				]
			},
		]
	}
}
