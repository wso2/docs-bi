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
          1 GB memory for the container/pod
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

### Tested Java Runtime Environments

The WSO2 Integrator: BI runtime is tested with the following JREs:

> A compatible JRE version will be automatically installed during the Ballerina installation process if one is not already available in the environment.

| JRE         |Versions|
|-------------|--------|
| CorrettoJRE | 21 |
| AdoptOpenJRE | 21 |
| OpenJRE     | 21 |
| Oracle JRE  | 21 |

### Tested Database Management Systems

The WSO2 Integrator: BI runtime is tested with the following databases:

| DBMS                 | Versions                |
|----------------------|-------------------------|
| MySQL                | 8+                      |
| Oracle               | 12c R2+                 |
| Microsoft SQL Server | 2005+                   |
| PostgreSQL           | 8.4+                    |

### ARM compatibility

WSO2 Integrator: BI is compatible with ARM processors. It can run on ARM-based systems, such as those with Apple Silicon or ARM-based Linux distributions.