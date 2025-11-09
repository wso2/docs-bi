type AccessLog record {
    int timestamp;
    string client_ip;
    string http_method;
    string request_url;
    string user_agent;
};
