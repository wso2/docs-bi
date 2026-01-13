# AI Data Mapping

## What is the data mapper?

The [data mapper]({{base_path}}/developer-guides/data-mapping/manual-data-mapping/) in BI is a component designed to facilitate the transformation and mapping of data from one format to another. This is essential when data from diverse sources needs to be integrated and processed uniformly across various applications and services. By automating the mapping process, integration developers can significantly enhance their efficiency, reducing the manual effort typically required for extensive mapping tasks through the component's visual mapping interface.

<a href="{{base_path}}/assets/img/developer-guides/data-mapping/ai-data-mapping/manual-data-mapper-visualizer.gif">
<img src="{{base_path}}/assets/img/developer-guides/data-mapping/ai-data-mapping/manual-data-mapper-visualizer.gif" alt="Manual Datamapper Visualizer" width="70%"></a>

In industries such as healthcare, insurance, and banking where data must move between complex systems, manual data mapping presents significant challenges:

- Transforming FHIR Patient resources to custom hospital formats
- Converting HL7 v2 messages into modern API structures
- Mapping insurance claims with hundreds or thousands of fields
- Reconciling financial transactions between incompatible data standards

Manual mapping is time-intensive, error-prone, and requires substantial developer effort. Schema changes necessitate rework, debugging, and extended development cycles.

The AI Data Mapper addresses these challenges through automated mapping generation.

## The AI data mapper

The AI Data Mapper generates complete, compilable Ballerina transformation code between any two data structures, regardless of size, nesting depth, or structural complexity.

Workflow:

1. Upload input and output schemas
2. Optionally provide supporting mapping documentation
3. Generate mapping code
4. Receive production-ready, type-safe, validated Ballerina code

The system produces validated mapping code without requiring manual field-by-field matching.

<a href="{{base_path}}/assets/img/developer-guides/data-mapping/ai-data-mapping/ai-data-mapper-visualizer.gif">
<img src="{{base_path}}/assets/img/developer-guides/data-mapping/ai-data-mapping/ai-data-mapper-visualizer.gif" alt="AI Datamapper Visualizer" width="70%"></a>

## AI datamapper features

### 1. Automated mapping generation

Upload input and output record definitions to generate complete mappings.

The system analyzes:

- Field names and naming conventions
- Semantic relationships between fields
- Nested data structures
- Array types and cardinality
- Optional and nullable fields
- Domain-specific patterns (particularly in healthcare contexts)

The generated mapping code follows established engineering practices and is produced in seconds.

### 2. Advanced expression generation

The mapper handles complex transformation scenarios:

- Type conversions: Automatic conversion between primitive types (`string` to `int`, `decimal` to `float`, etc.)
- Optional field handling: Null-safety checks and proper optional field management
- Nested record transformation: Deep structure mapping with proper path resolution
- Array-to-array mappings: Element-wise transformations with appropriate iteration logic
- Conditional logic: Field presence validation and default value assignment

### 3. Enhanced accuracy through supporting documentation

The AI Data Mapper supports the upload of reference materials to improve mapping accuracy. While schema-only analysis is supported, providing additional documentation enhances the system's understanding of field relationships and business rules.

Supported documentation formats include:

- PDF documents
- Images (JPEG, JPG, PNG)
- CSV files
- Text files

For complex mapping scenarios involving large schemas or domain-specific requirements, multiple documents can be uploaded simultaneously. The system analyzes the combined documentation to generate more accurate and context-aware transformations.

### 4. Sub-mapping reuse

The AI Data Mapper detects existing mapping expressions within the codebase and reuses them where applicable. This approach provides:

- Reduced code duplication
- Consistent transformation logic across the integration
- Smaller codebase and improved compilation performance
- Adherence to DRY (Don't Repeat Yourself) principles

Example: Consider an existing mapping that transforms `firstName` and `lastName` into a `full name`:

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

When generating new mappings requiring the same fullName transformation, the system reuses the existing `fullNameOfPerson` expression rather than regenerating `firstName + " " + lastName` inline. This ensures consistency across your transformations and reduces redundant code.

### 5. Function extraction for scalability

For mappings with extensive field counts (hundreds to thousands of fields), the system extracts helper functions to maintain code readability and comply with language server constraints. Complex transformations involving union types, deeply nested structures, and array-to-array operations are automatically decomposed into reusable functions.

### 6. Code validation

All generated mappings are validated by the Ballerina Language Server prior to output, ensuring:

- Syntactic correctness
- Type safety compliance
- Proper import statements

- Reserved keyword handling

The output is guaranteed to be compilable code.

## Healthcare mapping examples

### Example 1: Custom to standard format (ClaimSubmission to [international401:Claim](https://central.ballerina.io/ballerinax/health.fhir.r4.international401/4.0.0#Claim))

<a href="{{base_path}}/assets/img/developer-guides/data-mapping/ai-data-mapping/claim-submission-to-international401-claim.gif">
<img src="{{base_path}}/assets/img/developer-guides/data-mapping/ai-data-mapping/claim-submission-to-international401-claim.gif" alt="AI Data Mapper transforming a custom ClaimSubmission record into a standard international401:Claim format" width="70%"></a>

### Example 2: Standard to standard format ([hl7v23:PID](https://central.ballerina.io/ballerinax/health.hl7v23/4.0.1#PID) to [international401:Patient](https://central.ballerina.io/ballerinax/health.fhir.r4.international401/4.0.0#Patient))

<a href="{{base_path}}/assets/img/developer-guides/data-mapping/ai-data-mapping/hl7v23-pid-to-international401-patient.gif">
<img src="{{base_path}}/assets/img/developer-guides/data-mapping/ai-data-mapping/hl7v23-pid-to-international401-patient.gif" alt="AI Data Mapper converting HL7V23 PID segment to international401:Patient format" width="70%"></a>

## Responsible use

Large Language Models can produce unexpected results when processing highly domain-specific or atypical schema patterns. To ensure accuracy and safety, the following practices are recommended:

- Review all generated mappings before deployment to production environments
- Test with representative data samples that reflect actual use cases
- Verify that generated transformation logic aligns with business requirements
- Provide feedback on incorrect or incomplete mappings to support continuous improvement

## Integration development with AI-assisted mapping

The AI Data Mapper represents a significant advancement in integration development practices. By automating repetitive field matching, conversion logic generation, and type checking, developers can redirect effort toward higher-value activities: designing robust architectures, implementing business logic, and building scalable systems.

This tool is applicable across multiple use cases:

- API development and integration
- Microservices orchestration
- Data pipeline construction
- Industry-specific interoperability implementations
- Transformation between proprietary and standardized data formats
