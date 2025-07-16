## GitHub Action for CI/CD integration

The [Ballerina GitHub](https://github.com/marketplace/actions/ballerina-action) Action enables seamless automation of CI/CD workflows for WSO2 Integrator: BI projects hosted on GitHub. This action can be used to build and push Ballerina packages that serve as integration artifacts in WSO2 Integrator: BI.

The following sample GitHub Actions workflow demonstrates how to automate the build and publish process for a Ballerina-based integration using WSO2 Integrator: BI. The workflow uses the Ballerina GitHub Action to build the integration and publish it to Ballerina Central.

{% raw %}
```yaml
name: Ballerina publish example

on: [workflow_dispatch]

jobs:
  build:
    
    runs-on: ubuntu-latest
    
    steps:
      - name: Checkout
        uses: actions/checkout@v1
    
      - name: Ballerina Build
        uses: ballerina-platform/ballerina-action@master
        with:
          args: 
            pack

      - name: Ballerina Push
        uses: ballerina-platform/ballerina-action@master
        with:
          args: 
            push 
        env: 
            BALLERINA_CENTRAL_ACCESS_TOKEN: ${{ secrets.BallerinaToken }}
```
{% endraw %}