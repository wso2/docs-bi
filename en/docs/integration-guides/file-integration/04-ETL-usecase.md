# Use Case: Ingest, Transform, Load: Ingesting JSON Orders into a Database

In this integration, we will build a robust workflow to ingest e-commerce orders submitted as JSON files. We will configure an FTP service to monitor a directory for new order files. Upon detection, the integration will read the file, validate its schema, and then use a database transaction to process the nested JSON data. This involves inserting the main order details, customer shipping information, and iterating over the list of line items to populate multiple database tables. Finally, the original file will be archived.

## Scenario
Partner marketplaces (like Amazon, Shopify) or B2B portals drop new orders as individual JSON files into a secure SFTP folder for fulfillment. These files contain nested data, including customer details and a list of products (line items).


--- Notes

code: samples/etl


```mermaid
flowchart TD
    A(Start: JSON file detected in ./sftp/orders/in/) --> B{Validate JSON schema};

    B -- Invalid --> B_ERR[Move file to ./quarantine/];
    B_ERR --> Z_ERR(End: Quarantined);
    
    B -- Valid --> C[Start Database Transaction];
    C --> D[Insert into Orders table];
    D --> E[Insert into ShippingDetails table];
    E --> F[Iterate over lineItems array];
    F --> G[Insert into OrderLines table];
    G --> H[Update Inventory table];
    H --> F;

    F -- Iteration Complete --> I{Commit Transaction?};

    I -- Failure/Rollback --> I_ERR[Move file to ./error/];
    I_ERR --> Z_ERR2(End: Error);

    I -- Success/Commit --> J[Move original file to ./archive/];
    J --> K[Publish 'OrderReceived' event];
    K --> Z(End: Success);
```

![Flow Diagram](./images/ETL.excalidraw.png)
