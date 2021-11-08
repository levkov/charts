SHELL = bash

all: kind test

kind:
	kind create cluster

test: test-stable-metrics-server test-stable-nfs-server-provisioner

test-stable-metrics-server:
	helm install stable-metrics-server stable/metrics-server/ --set "args={--kubelet-insecure-tls, --kubelet-preferred-address-types=InternalIP}" --namespace kube-system

test-stable-nfs-server-provisioner:
	helm install stable-nfs-server-provisioner stable/nfs-server-provisioner/ --namespace kube-system

package: package-stable-metrics-server package-stable-nfs-server-provisioner

package-stable-metrics-server:
	cd $(CURDIR)/stable/ && helm package metrics-server/

package-stable-nfs-server-provisioner:
	cd $(CURDIR)/stable/ && helm package nfs-server-provisioner/

index-stable:
	helm repo index stable --url https://levkov.github.io/charts/stable/

clean:
	kind delete cluster