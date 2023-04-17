IMAGE = tailbenchenv:centos7

image:
	docker build -t ${IMAGE} -f Dockerfile .

