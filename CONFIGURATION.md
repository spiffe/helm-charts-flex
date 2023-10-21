<!-- vim: filetype=markdown colorcolumn=80
-->
# helm-charts-flex Configuration

[![Apache 2.0 License](https://img.shields.io/github/license/spiffe/helm-charts)](https://opensource.org/licenses/Apache-2.0)
[![Development Phase](https://github.com/spiffe/spiffe/blob/main/.img/maturity/dev.svg)](https://github.com/spiffe/spiffe/blob/main/MATURITY.md#development)
[![Artifact Hub](https://img.shields.io/endpoint?url=https://artifacthub.io/badge/repository/spiffe)](https://artifacthub.io/packages/search?repo=spiffe)


## File locations

Some file in the spire deployment can be relocated.  Relocating files may assist
in avoiding collisions when installing multiple SPIRE instances on the same
hardware, or may place files into locations confroming with your file placement
standards.  Below is a list of relocatable files and their default locations.

| File                          | Config Path      | Default Location           | 
| ----------------------------- | ---------------- | -------------------------- |
| Agent Configuration File      | agent.configFile | /opt/spire/conf/agent.conf |

Changing the location of a file will automatically update the other components
to expect the file in its specified location.

## Image Configuration

Registries contain container images which are organized by tags.  An organization
may wish to hold the images in a local repository for better image management
or to capture local builds of SPIRE when on-site source code management is required.

The values associated with global image controls include:

| Path               | Type   | Default           |
| ------------------ | ------ | ----------------- |
| image.registry     | string | ghcr.io           |
| image.registryPort | int    |                   |
| image.tag          | string | 1.8.0             |

These controls alter all image defaults, providing a convenient way to ensure
all SPIRE components use the same set of images. These defauls can be overridden
by specific component image controls.


## Agent Configuration

Agent configuration covers the agent installation and the configured behavior
of the installed agent.  

### Agent Config File

The agent config file contains the configuration elements passed to the agent
at agent launch.

| Path             | Type   | Default                      | 
| ---------------- | ------ | ---------------------------- |
| agent.configFile | string | "/opt/spire/conf/agent.conf" |

**agent.configFile** controls both the in-container path of the config file as
well as the command line agent parameters that reference the config file.

### Agent Image Controls

The agent is controlled by a container defintion which pulls the agent's image
from a container repository. This image contains the spire-agent executable
which connects to the spire-server through a procedure known as agent-attestation.

The values associated with the agent image include:

| Path                     | Type   | Defaults             |
| ------------------------ | ------ | -------------------- |
| agent.image.name         | string | spire/spire-agent    |
| agent.image.registry     | string | {image.registry}     |
| agent.image.registryPort | int    | {image.registryPort} |
| agent.image.tag          | string | {image.tag}          |

> Note: These values default to other values.  If the other values are unset
> consult thier default values to determine the final value.

When settings are best applied to all images, consider setting them in the the
[Image Configuration](image_configuration) section.

Here is an example of a customized agent image, where a test agent is being
used with other non-test components.

```yaml
agent:
  image:
    name: "mycorp/spire-test-agent"
    registry: "mycorp"
    registryPort: 8080
    tag: "latest"
```

### Agent Health Checks

The agent can expose additional endpoint that can be used for health checking.
It is enabled by default, but can be disabled by setting **.agent.healthCheck.enable**
to *false*.

The values associated with the agent health checks include

| Path                          | Type   | Default     | 
| ----------------------------- | ------ | ----------- |
| agent.healthCheck.enable      | bool   | true        |
| agent.healthCheck.bindAddress | string | "localhost" |
| agent.healthCheck.bindPort    | int    | 80          |
| agent.healthCheck.livePath    | string | "/live"     |
| agent.healthCheck.readyPath   | string | "/ready"    |

> Note: The livePath indicates if the agent has died.
> While the readyPath indicates if the agent is capable of processing requests.

One may override one or more of these values by setting them in the values.yaml
file or in the "set" command line interfaces associated with your deployment.

Here is an example of a heavily customized agent health check configuration:

```yaml
agent:
  healthCheck:
    bindAddress: "0.0.0.0"
    bindPort: 8080
    livePath: "/i_am_alive"
    readyPath: "/i_am_ready"
```

And here is an eample of a disabled agent health check configuraition:

```yaml
agent:
  healthCheck:
    enable: false
```

Note that disabling agent health checks makes is much more difficult for
Kubernetes to properly assess when the agent is functional (alive) and when the 
agent is ready to service requests (ready).
