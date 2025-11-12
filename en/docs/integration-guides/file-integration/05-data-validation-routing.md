# Use Case: Data Validation and Routing (File-Level Rejection)

In this integration pattern, we will validate an entire incoming file against a set of critical business rules before any processing begins. This is an "all-or-nothing" integrity check. If the file fails validation (e.g., a record count mismatch or a high error threshold), the entire file is rejected and moved to a quarantine location for manual review, preventing corrupt or incomplete data from entering the target system.

## Scenario

A company's payroll department receives a daily "Time Log" batch file (.csv) from an external vendor. Before this file is fed into the payroll system, it must pass an integrity check:

1. Control Total: Count of the records must be 150.

2. Error Threshold: The integration will check each record's employee_id against a cache of valid employees. If more than 5% of the records have an invalid ID, the entire file is considered unreliable and must be rejected.


--- Notes

code: samples/data_validation

```mermaid
flowchart TD
    A(Start: File detected in /payroll/in/) --> B[Read entire file];
    B --> C[Validate: Count records, read trailer, check error %];
    
    C --> D{Integrity Checks Pass?};
    
    D -- No --> E[Move file to /payroll/quarantine/];
    E --> F[Send rejection alert];
    F --> Z_ERR(End: Quarantined);
    
    D -- Yes --> G[Process records (e.g., send to payroll system - kafka topic)];
    G --> H[Move original file to /payroll/archive/];
    H --> Z_OK(End: Success);
```