# Testing

BI has a built-in robust test framework, which allows you to ensure that your applications are reliable. The Ballerina powered testframework provides support for assertions, data providers, mocking, and code coverage features, which enable programmers to write comprehensive tests.

## Test a Simple Function

Follow the steps below to get started with testing in your BI project.

1\. Create a BI Project
   Open WSO2 BI and create a new project.
   Add an artifact of type **`automation`** to your project.

2\. Add a Sample Function
   In the generated `main.bal` file, add the following function:

   ```ballerina
   public function intAdd(int a, int b) returns int {
       return a + b;
   }
   ```

3\. Create a Unit Test
   Navigate to the **Testing** extension from the left-hand navigation panel.
   Create a new unit test and include an assertion to validate the output of the `intAdd` function.

4\. Run the Tests
   Use the **Run Test** option to execute the newly added test case, or choose to run all the tests under the `DEFAULT_GROUP`.


<a href="{{base_path}}/assets/img/developer-guides/testing/testting-a-function.gif"><img src="{{base_path}}/assets/img/developer-guides/testing/testting-a-function.gif" alt="Testing a simple function" width="80%"></a>


For further details on the Ballerina testframework you can refer to [Ballerina Testing Guide](https://ballerina.io/learn/test-ballerina-code/test-a-simple-function/).
