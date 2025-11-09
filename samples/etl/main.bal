import ballerina/ftp;

listener ftp:Listener ftpListener = new (host = ftpHost, port = ftpPort, protocol = "ftp", path = "/orders/in/",
    auth = {
        credentials: {username: ftpHost, password: ftpPassword}
    },
    fileNamePattern = "*.json"
);

service ftp:Service on ftpListener {

    remote function onFileJson(Order orderDetails, ftp:FileInfo fileInfo, ftp:Caller caller) returns error? {
        if orderDetails.lineItems.length() == 0 {
            check caller->rename(fileInfo.pathDecoded, "/orders/quarantine/" + fileInfo.name);
            return;
        }

        transaction {
            check updateCustomer(orderDetails.customer);
            check updateOrder(orderDetails);
            check commit;
            check caller->rename(fileInfo.pathDecoded, "/orders/processed/" + fileInfo.name);
        } on fail {
            check caller->rename(fileInfo.pathDecoded, "/orders/error/" + fileInfo.name);
        }
    }

}

function updateCustomer(Customer customer) returns error? {
    // Implementation to update customer in the database
    _ = check mysqlClient->execute(`INSERT INTO Customers (customer_id, email)
                            VALUES (${customer.id}, ${customer.email})
                            ON DUPLICATE KEY UPDATE
                                email = VALUES(email);`);
}

function updateOrder(Order orderDetails) returns error? {
    // Implementation to update order in the database
    _ = check mysqlClient->execute(`INSERT INTO Orders (order_id, order_date, total_amount, customer_id)
                    VALUES (${orderDetails.orderId}, ${orderDetails.orderDate}, 
                    ${orderDetails.total}, ${orderDetails.customer.id}`);

    foreach LineItemsItem item in orderDetails.lineItems {
        _ = check mysqlClient->execute(
            `INSERT INTO OrderLines (order_id, sku, description, quantity, price)
                            VALUES (${orderDetails.orderId}, ${item.sku}, ${item.description}, ${item.quantity}, ${item.price});`);

    _ = check mysqlClient->execute(`UPDATE Inventory 
                                    SET stock_quantity = stock_quantity - ${item.quantity} 
                                    WHERE sku = ${item.sku};`);
    }

}
