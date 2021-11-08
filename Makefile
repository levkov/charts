SHELL = bash

all: stable

stable: deploy-stable

test: deploy-test

kind:
	kind create cluster

k3d:
	k3d cluster create --api-port 6550 -p "80:80@loadbalancer" --agents 2

deploy-stable: deploy-stable-metrics-server deploy-stable-nfs-server-provisioner

deploy-test: deploy-test-metrics-server deploy-test-nfs-server-provisioner

deploy-stable-metrics-server:
	helm install stable-metrics-server stable/metrics-server/ --set "args={--kubelet-insecure-tls, --kubelet-preferred-address-types=InternalIP}" --namespace kube-system

deploy-stable-nfs-server-provisioner:
	helm install stable-nfs-server-provisioner stable/nfs-server-provisioner/ --namespace kube-system

package-stable: package-stable-metrics-server package-stable-nfs-server-provisioner

package-test: package-test-metrics-server package-test-nfs-server-provisioner

package-stable-metrics-server:
	cd $(CURDIR)/stable/ && helm package metrics-server/

package-stable-nfs-server-provisioner:
	cd $(CURDIR)/stable/ && helm package nfs-server-provisioner/

package-test-metrics-server:
	cd $(CURDIR)/test/ && helm package metrics-server/

package-test-nfs-server-provisioner:
	cd $(CURDIR)/test/ && helm package nfs-server-provisioner/

index-stable:
	helm repo index stable --url https://levkov.github.io/charts/stable/

index-test:
	helm repo index test --url https://levkov.github.io/charts/test/

deploy-test-metrics-server:
	helm install test-metrics-server test/metrics-server/ --set "args={--kubelet-insecure-tls, --kubelet-preferred-address-types=InternalIP}" --namespace kube-system

deploy-test-nfs-server-provisioner:
	helm install test-nfs-server-provisioner test/nfs-server-provisioner/ --namespace kube-system

clean:
	kind delete cluster || true && k3d cluster delete || true