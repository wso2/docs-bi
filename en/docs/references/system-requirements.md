---
title: "WSO2 Integrator: BI System requirements"
description: "Detailed list of system requirements and prerequisites for running BI components."
---

# WSO2 Integrator: BI System requirements

Prior to installing WSO2 Integrator: BI, make sure that the appropriate prerequisites are fulfilled.

<table>
  <tr>
    <td>
      <b>Minimum</b>
      <p>(Suitable for smaller integrations)</p>
    </td>
    <td>
      <ul>
        <li>
          0.2 core (compute units with at least 1.0-1.2 GHz Opteron/Xeon processor)
        </li>
        <li>
          512 MB heap size
        </li>
      </ul>
    </td>
  </tr>
  <tr>
    <td>
      <b>Recommended</b>
      <p>(Suitable for larger integrations)</p>
    </td>
    <td>
      <ul>
      <li>
          1 core (compute units with at least 1.0-1.2 GHz Opteron/Xeon processor)
        </li>
        <li>
          1 GB heap size
        </li>
      </ul>
    </td>
  </tr>
</table>

## Environment compatibility

The details of the tested environments for the WSO2 Integrator: BI are given below.

### Tested operating systems

The WSO2 Integrator: BI runtime is tested with the following operating systems:

| Operating System         | Versions   |
|--------------------------|------------|
| Windows                  | 10+       |
| Ubuntu                   | 24.04      |
| Red Hat Enterprise Linux | 9   |
| MacOS                    | 14.6      |

### Tested Java runtime environments

The WSO2 Integrator: BI runtime is tested with the following JREs:

> A compatible JRE version will be automatically installed during the Ballerina installation process if one is not already available in the environment.

| JRE         |Versions|
|-------------|--------|
| CorrettoJRE | 21 |
| AdoptOpenJRE | 21 |
| OpenJRE     | 21 |
| Oracle JRE  | 21 |

### ARM compatibility

WSO2 Integrator: BI is compatible with ARM processors. It can run on ARM-based systems, such as those with Apple Silicon or ARM-based Linux distributions.
