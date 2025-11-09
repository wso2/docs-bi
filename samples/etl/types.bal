type ShippingAddress record {|
    string street;
    string city;
    string zip;
    json...;
|};

type Customer record {|
    string id;
    string email;
    ShippingAddress shippingAddress;
    json...;
|};

type LineItemsItem record {|
    string sku;
    string description;
    int quantity;
    decimal price;
    json...;
|};

type Order record {|
    string orderId;
    string orderDate;
    decimal total;
    Customer customer;
    LineItemsItem[] lineItems;
    json...;
|};
