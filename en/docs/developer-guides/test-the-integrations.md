# Test the Integrations

BI has a built-in robust test framework, which allows you to ensure that your applications are reliable. The Ballerina powered testframework provides support for assertions, data providers, mocking, and code coverage features, which enable programmers to write comprehensive tests.

## Test a Simple Function

To get started, let's set up the BI project to run tests.

1\. Create a BI project and add an artifact type `automation` 

2\. Add the following function to the `main.bal` file.

    ```ballerina
    public function intAdd(int a, int b) returns int {
        return a + b;
    }
    ```

3\. Go tho the `Testing` extension on the left navigation panel. From there, create a new unit test and add an assertion to validate the results of the `intAdd` function.

4\. Execute the tests using the `Run Test` option for the recently added test case or by selecting to run all the tests in the `DEFAULT_GROUP`

<a href="{{base_path}}/assets/img/developer-guides/testing/testing_1.gif"><img src="{{base_path}}/assets/img/developer-guides/testing/testing_1.gif" alt="Testing a simple function" width="80%"></a>


For further details on the Ballerina testframework you can refer to [Ballerina Testing Guide](https://ballerina.io/learn/test-ballerina-code/test-a-simple-function/).
