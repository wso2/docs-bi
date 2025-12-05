# AI Data Mapping

## What Is the Data Mapper?

The [data mapper](https://ballerina.io/learn/vs-code-extension/implement-the-code/data-mapper/) in Ballerina is a component designed to facilitate the transformation and mapping of data from one format to another. This is crucial when data from diverse sources needs to be integrated and processed uniformly across various applications and services. By automating the mapping process, integration developers can significantly enhance their efficiency, reducing the manual effort typically required for extensive mapping tasks through the component's visual mapping interface.

<a href="{{base_path}}/assets/img/developer-guides/data-mapping/ai-data-mapping/manual-data-mapper-visualizer.gif">
<img src="{{base_path}}/assets/img/developer-guides/data-mapping/ai-data-mapping/manual-data-mapper-visualizer.gif" alt="Manual Datamapper Visualizer" width="70%"></a>

If you work in **healthcare**, **insurance**, **banking**, or any industry where data must move between complex systems, you already know the pain.

- Moving a **FHIR Patient** to a custom hospital format.
- Converting **HL7 v2** messages into a modern API.
- Mapping **1,000-field insurance claims** line-by-line.
- Reconciling **financial transactions** between incompatible standards.

It's slow. It's error-prone. It eats weeks of developer time.
And every changed field means rework, debugging, and more late nights.

**What if AI could take all of that pain away?**

## Meet the AI Data Mapper

The **AI Data Mapper** instantly generates complete, ready-to-compile Ballerina transformation code between any two data structures no matter how large, nested, or complex.

1. Upload your input and output schemas
2. Add any supporting mapping docs if you have them
3. Click one button
4. Get compilable Ballerina code

You get **production-grade**, **type-safe**, **validated mapping code** without manually matching a single field.

<a href="{{base_path}}/assets/img/developer-guides/data-mapping/ai-data-mapping/ai-data-mapper-visualizer.gif">
<img src="{{base_path}}/assets/img/developer-guides/data-mapping/ai-data-mapping/ai-data-mapper-visualizer.gif" alt="AI Datamapper Visualizer" width="70%"></a>

## Why Teams Love It

### 1. One Click → Complete Auto-Mapping

Just upload your input/output record definitions.

The AI understands:

- Field names
- Concepts and semantics
- Nested structures
- Arrays
- Optional fields
- Common domain patterns (especially healthcare)

It generates the mapping as if a senior engineer wrote it but in seconds.

### 2. Advanced Expression Generation

The mapper handles complex scenarios automatically:

- **Type conversions**: `string` to `int`, `decimal` to `float`, etc.
- **Optional fields**: Proper null-safety checks
- **Nested records**: Deep structure transformations
- **Array to array mappings**: Element-wise transformations with proper iteration
- **Conditional logic**: Field presence checks and default values

### 3. Enhanced Accuracy Through Supporting Documentation

- *Got mapping specs?*
- *Old mapping spreadsheets?*
- *PDFs from vendors?*
- *Images or screenshots from legacy systems?*

The AI Data Mapper allows you to improve mapping accuracy by providing **specifications or supporting documentations**. While it can generate mappings entirely from schema analysis alone, you can also upload a wide range of reference materials including PDFs, images (`JPEG`, `JPG`, `PNG`), CSV files, and text files to guide the AI's understanding of field relationships.

For complex scenarios such as large healthcare mappings, you can upload **multiple documents** simultaneously. This enables the system to analyze comprehensive mapping specifications across several files, ensuring more precise and context-aware transformations.

### 4. Sub-mapping Reuse

When generating mappings, the AI Data Mapper automatically detects existing mapping expressions in your codebase. Instead of duplicating transformation logic, it reuses these sub-mappings, resulting in:

- Cleaner, more maintainable code
- Consistent transformations across your integration
- Reduced code size and compilation time
- Better alignment with DRY (Don't Repeat Yourself) principles

For example, if you already have a mapping expression that transforms `firstName` and `lastName` into a `full name`:

```ballerina
type Person record {|
    string firstName;
    string lastName;
|};

type Student record {|
    string fullName;
|};

function transform(Person person) returns Student =>
    let string fullNameOfPerson = person.firstName + " " + person.lastName in {
        fullName: fullNameOfPerson
    };
```

When generating new mappings that require the same fullName transformation, the mapper will automatically reuse the existing `fullNameOfPerson` expression rather than regenerating `firstName + " " + lastName` inline. This ensures consistency across your transformations and reduces redundant code.

### 5. Function Extraction for Scalability

For large mappings with **hundreds or even thousands of fields**, the system intelligently extracts helper functions to keep code maintainable and within language server limits. Complex transformations including those involving **union types**, **deeply nested structures**, and **array-to-array transformations**, are automatically split into reusable functions.

### 6. Every Mapping Is Validated

Before the mapping is returned, it is checked by the **Ballerina Language Server** for:

- Syntax correctness
- Type safety
- Required imports
- Reserved keyword handling

You always get code that compiles.

## Real Healthcare Examples

### Example 1: Custom Mapping (ClaimSubmission) to Standard Mapping([international401:Claim](https://central.ballerina.io/ballerinax/health.fhir.r4.international401/4.0.0#Claim))

<a href="{{base_path}}/assets/img/developer-guides/data-mapping/ai-data-mapping/claim-submission-to-international401-claim.gif">
<img src="{{base_path}}/assets/img/developer-guides/data-mapping/ai-data-mapping/claim-submission-to-international401-claim.gif" alt="AI Data Mapper transforming a custom ClaimSubmission record into a standard international401:Claim format" width="70%"></a>


### Example 2: Standard Mapping ([hl7v23:PID](https://central.ballerina.io/ballerinax/health.hl7v23/4.0.1#PID)) to Standard Mapping ([international401:Patient](https://central.ballerina.io/ballerinax/health.fhir.r4.international401/4.0.0#Patient))

<a href="{{base_path}}/assets/img/developer-guides/data-mapping/ai-data-mapping/hl7v23-pid-to-international401-patient.gif">
<img src="{{base_path}}/assets/img/developer-guides/data-mapping/ai-data-mapping/hl7v23-pid-to-international401-patient.gif" alt="AI Data Mapper converting HL7V23 PID segment to international401:Patient format" width="70%"></a>

## Responsible Use

While **Large Language Models** have made remarkable progress, they can still produce unexpected results especially when dealing with highly domain-specific or unusual schema patterns. To ensure safe and accurate outcomes, we strongly recommend the following:

- **Review all generated mappings** before using them in production.
- **Test with representative and realistic data samples**.
- **Validate that the generated logic aligns with your business rules**.
- **Share feedback on incorrect or missing mappings** so the system can continue to improve.

## The Future of Integration Development

The **AI Data Mapper** marks a major shift in how integrations are built. Instead of spending hours manually matching fields, writing conversion logic, and tracking down type errors, developers can now offload the most repetitive and error-prone tasks to AI.

This leaves you free to focus on what truly matters: building robust, scalable, business-critical systems.

Whether you're:

- Building new APIs
- Orchestrating microservices
- Constructing data pipelines
- Implementing industry-specific interoperability solutions
- Transforming between custom and standard data formats

## Try the AI Data Mapper Today

Upload your schemas even the big, scary ones and see how fast your largest integrations can move.

We're continuously improving based on real-world usage.
Share your feedback, suggestions, or issues through the [Ballerina community channels](https://ballerina.io/community/) we're continuously improving based on your real-world usage.

## Useful Links

- [Ballerina VS Code Extension — Data Mapper](https://ballerina.io/learn/vs-code-extension/implement-the-code/data-mapper/)
- [WSO2 BI Developer Guides — Manual Data Mapping]({{base_path}}/developer-guides/data-mapping/manual-data-mapping/)
- [Introducing Ballerina AI Data Mapper](https://wso2.com/library/blogs/introducing-ballerina-ai-data-mapper/)
