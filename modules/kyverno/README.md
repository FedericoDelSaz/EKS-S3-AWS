## Terraform Kyverno Module
This module is used in order to manage the Kyverno installation and configuration.
The documentation provided in this README is about to describe the installation process.

For more information about kyverno check [kyverno-docs](https://kyverno.io/docs/)

### Installation
Kyverno is installed via Helm using the [official chart](https://github.com/kyverno/kyverno/tree/main/charts/kyverno).

The configuration file is located at [kyverno-values-file](../kyverno/files/kyverno-values.yaml)

This module also installs common and cluster specific policies that are applied during the cluster configuration:
- [kyverno-common-policies](./kyverno-common-policies/)

### Enabling/Disabling Kyverno and Kyverno policies
This module can be enabled/disabled as well as the policies that you want to install.

Parameters:
- **kyverno_enabled**, set to true/false in order to enable/disable the component.
- **kyverno_common_policies_enabled**, set to true/false in order to install/uninstall common policies.
