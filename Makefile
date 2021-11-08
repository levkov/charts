SHELL = bash

all: stable

stable: kind deploy-stable

test: kind deploy-test

kind:
	kind create cluster

deploy-stable: deploy-stable-metrics-server deploy-stable-nfs-server-provisioner

deploy-test: deploy-test-metrics-server

deploy-stable-metrics-server:
	helm install stable-metrics-server stable/metrics-server/ --set "args={--kubelet-insecure-tls, --kubelet-preferred-address-types=InternalIP}" --namespace kube-system

deploy-stable-nfs-server-provisioner:
	helm install stable-nfs-server-provisioner stable/nfs-server-provisioner/ --namespace kube-system

package-stable: package-stable-metrics-server package-stable-nfs-server-provisioner

package-test: package-test-metrics-server

package-stable-metrics-server:
	cd $(CURDIR)/stable/ && helm package metrics-server/

package-stable-nfs-server-provisioner:
	cd $(CURDIR)/stable/ && helm package nfs-server-provisioner/

package-test-metrics-server:
	cd $(CURDIR)/test/ && helm package metrics-server/

index-stable:
	helm repo index stable --url https://levkov.github.io/charts/stable/

index-test:
	helm repo index test --url https://levkov.github.io/charts/test/

deploy-test-metrics-server:
	helm install test-metrics-server test/metrics-server/ --set "args={--kubelet-insecure-tls, --kubelet-preferred-address-types=InternalIP}" --namespace kube-system


clean:
	kind delete cluster