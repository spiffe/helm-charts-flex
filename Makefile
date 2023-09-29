mkfile_path := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))

test:
	docker run -ti --rm -v $(mkfile_path):/apps docker://helmunittest/helm-unittest:3.11.1-0.3.0 spire-flex/

version:
	docker run -ti --rm -v $(mkfile_path):/apps docker://alpine/helm:3.11.1 version

package:
	docker run -ti --rm -v $(mkfile_path):/apps docker://alpine/helm:3.11.1 package spire-flex/

