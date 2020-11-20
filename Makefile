SHELL = bash

all: kind

kind:
	kind create cluster

test-stable-metrics-server:
	helm install stable-metrics-server stable/metrics-server/ --set "args={--kubelet-insecure-tls, --kubelet-preferred-address-types=InternalIP}" --namespace kube-system

package-stable-metrics-server:
	cd $(CURDIR)/stable/ && helm package metrics-server/

index-stable:
	helm repo index stable --url https://levkov.github.io/charts/stable/

clean:
	kind delete cluster