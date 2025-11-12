-- Create a table for Customers
CREATE TABLE Customers (
    customer_id VARCHAR(100) PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL
);

-- Create the main Orders table
CREATE TABLE Orders (
    order_id VARCHAR(100) PRIMARY KEY,
    order_date TIMESTAMP NOT NULL,
    total_amount DECIMAL(10, 2) NOT NULL,
    customer_id VARCHAR(100),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

-- Create a table for Shipping Details, linked to an Order
CREATE TABLE ShippingDetails (
    shipping_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id VARCHAR(100) NOT NULL UNIQUE, -- Assuming one shipping address per order
    street VARCHAR(255) NOT NULL,
    city VARCHAR(100) NOT NULL,
    zip_code VARCHAR(20) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id)
);

-- Create a table for the individual Line Items in an Order
CREATE TABLE OrderLines (
    order_line_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id VARCHAR(100) NOT NULL,
    sku VARCHAR(100) NOT NULL,
    description VARCHAR(255),
    quantity INT NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id)
);

-- Create a simple Inventory table to be updated
CREATE TABLE Inventory (
    sku VARCHAR(100) PRIMARY KEY,
    stock_quantity INT NOT NULL DEFAULT 0
);