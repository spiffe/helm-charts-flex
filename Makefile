mkfile_path := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))

.PHONY: check
check: test

template:
	docker run -ti --rm -v $(mkfile_path):/apps docker://alpine/helm:3.11.1 template spire-flex 

test:
	docker run -ti --rm -v $(mkfile_path):/apps docker://helmunittest/helm-unittest:3.11.1-0.3.0 spire-flex/  -f tests/*.yaml

helm-version:
	docker run -ti --rm -v $(mkfile_path):/apps docker://alpine/helm:3.11.1 version

package:
	docker run -ti --rm -v $(mkfile_path):/apps docker://alpine/helm:3.11.1 package spire-flex/

clean:
	rm -f spire-flex-*.tgz

