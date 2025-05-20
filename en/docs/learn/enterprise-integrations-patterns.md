# Enterprise Integrations Patterns

The WSO2 Ballerina Integrator supports the implementation of key Enterprise Integration Patterns (EIPs), enabling you to build robust and scalable integrations based on proven architectural best practices. These patterns—originally defined in <a href="http://www.eaipatterns.com/toc.html" target="_blank">Enterprise Integration Patterns</a> by Gregor Hohpe and Bobby Woolf—provide reusable solutions for common messaging and system integration challenges. This guide demonstrates how to implement each core pattern using the low-code capabilities and visual tools of the Ballerina Integrator, helping you design clear, maintainable, and standards-based integration flows.

???+ tip  "Enterprise Integration Patterns with Ballerina"

    For a code-centric implementation of Enterprise Integration Patterns using the Ballerina language, refer to the <a href="https://ballerina.io/learn/enterprise-integration-patterns/" target="_blank">Ballerina EIP guide</a>.

## Messaging systems

<table>
    <tr>
        <td><a href="https://github.com/wso2/integration-samples/tree/main/EI%20patterns/message" target="_blank">Message</a></td>
        <td><a href="{{base_path}}assets/img/learn/eip/message.svg"><img src="{{base_path}}/assets/img/learn/eip/message.svg" alt="message" width="80"></a></td>
        <td>How can two applications connected by a message channel exchange a piece of information</td>
    </tr>
    <tr>
        <td><a href="https://github.com/wso2/integration-samples/tree/main/EI%20patterns/message_endpoint" target="_blank">Message Endpoint</a></td>
        <td><a href="{{base_path}}/assets/img/learn/eip/message-endpoint.svg"><img src="{{base_path}}/assets/img/learn/eip/message-endpoint.svg" alt="message-endpoint" width="80"></a></td>
        <td>How an application connects to a messaging channel to send and receive messages</td>
    </tr>
    <tr>
        <td><a href="https://github.com/wso2/integration-samples/tree/main/EI%20patterns/message_translator" target="_blank">Message Translator</a></td>
        <td><a href="{{base_path}}/assets/img/learn/eip/message-translator.svg"><img src="{{base_path}}/assets/img/learn/eip/message-translator.svg" alt="message-translator" width="80"></a></td>
        <td>How systems using different data formats communicate with each other using messaging</td>
    </tr>
    <tr>
        <td><a href="https://github.com/wso2/integration-samples/tree/main/EI%20patterns/message_router" target="_blank">Message Router</a></td>
        <td><a href="{{base_path}}/assets/img/learn/eip/message-router.svg"><img src="{{base_path}}/assets/img/learn/eip/message-router.svg" alt="message-router" width="80"></a></td>
        <td>How to route messages to different output channels</td>
    </tr>
    <tr>
        <td><a href="https://github.com/wso2/integration-samples/tree/main/EI%20patterns/pipes_and_filters" target="_blank">Pipes and Filters</a></td>
        <td><a href="{{base_path}}/assets/img/learn/eip/pipes-and-filters.svg"><img src="{{base_path}}/assets/img/learn/eip/pipes-and-filters.svg" alt="pipes-and-filters" width="80"></a></td>
        <td>How to perform complex processing on a message while maintaining independence and flexibility</td>
    </tr>
</table>

## Messaging channels

<table>
    <tr>
        <td><a href="https://github.com/wso2/integration-samples/tree/main/EI%20patterns/channel_adapter" target="_blank">Channel Adapter</a></td>
        <td><a href="{{base_path}}assets/img/learn/eip/channel-adapter.svg"><img src="{{base_path}}/assets/img/learn/eip/channel-adapter.svg" alt="channel-adapter" width="80"></a></td>
        <td>How can two applications connected by a message channel exchange a piece of information</td>
    </tr>
    <tr>
        <td><a href="https://github.com/wso2/integration-samples/tree/main/EI%20patterns/messaging_bridge" target="_blank">Messaging Bridge</a></td>
        <td><a href="{{base_path}}/assets/img/learn/eip/messaging-bridge.svg"><img src="{{base_path}}/assets/img/learn/eip/messaging-bridge.svg" alt="messaging-bridge" width="80"></a></td>
        <td>How an application connects to a messaging channel to send and receive messages</td>
    </tr>
    <tr>
        <td><a href="https://github.com/wso2/integration-samples/tree/main/EI%20patterns/point_to_point_channel" target="_blank">Point to Point Channel</a></td>
        <td><a href="{{base_path}}/assets/img/learn/eip/point-to-point-channel.svg"><img src="{{base_path}}/assets/img/learn/eip/point-to-point-channel.svg" alt="point-to-point-channel" width="80"></a></td>
        <td>How systems using different data formats communicate with each other using messaging</td>
    </tr>
</table>

## Message construction

<table>
    <tr>
        <td><a href="https://github.com/wso2/integration-samples/tree/main/EI%20patterns/command_message" target="_blank">Command Message</a></td>
        <td><a href="{{base_path}}assets/img/learn/eip/command-message.svg"><img src="{{base_path}}/assets/img/learn/eip/command-message.svg" alt="command-message" width="80"></a></td>
        <td>How to use message to invoke a procedure in another application</td>
    </tr>
    <tr>
        <td><a href="https://github.com/wso2/integration-samples/tree/main/EI%20patterns/document_message" target="_blank">Document Message</a></td>
        <td><a href="{{base_path}}assets/img/learn/eip/document-message.svg"><img src="{{base_path}}/assets/img/learn/eip/document-message.svg" alt="document-message" width="80"></a></td>
        <td>How messaging can be used to transfer data between applications.</td>
    </tr>
    <tr>
        <td><a href="https://github.com/wso2/integration-samples/tree/main/EI%20patterns/event_message" target="_blank">Event Message</a></td>
        <td><a href="{{base_path}}/assets/img/learn/eip/event-message.svg"><img src="{{base_path}}/assets/img/learn/eip/event-message.svg" alt="event-message" width="80"></a></td>
        <td>How messaging can be used to transmit events from one application to another</td>
    </tr>
    <tr>
        <td><a href="https://github.com/wso2/integration-samples/tree/main/EI%20patterns/format_indicator" target="_blank">Format Indicator</a></td>
        <td><a href="{{base_path}}/assets/img/learn/eip/format-indicator.svg"><img src="{{base_path}}/assets/img/learn/eip/format-indicator.svg" alt="format-indicator" width="80"></a></td>
        <td>How a message’s data format can be designed to allow for possible future changes</td>
    </tr>
    <tr>
        <td><a href="https://github.com/wso2/integration-samples/tree/main/EI%20patterns/message_sequence" target="_blank">Message Sequence</a></td>
        <td><a href="{{base_path}}/assets/img/learn/eip/message-sequence.svg"><img src="{{base_path}}/assets/img/learn/eip/message-sequence.svg" alt="message-sequence" width="80"></a></td>
        <td>How messaging can transmit an arbitrarily large amount of data</td>
    </tr>
</table>

## Message routing

<table>
    <tr>
        <td><a href="https://github.com/wso2/integration-samples/tree/main/EI%20patterns/content_based_router" target="_blank">Content-Based Router</a></td>
        <td><a href="{{base_path}}assets/img/learn/eip/content-based-router.svg"><img src="{{base_path}}/assets/img/learn/eip/content-based-router.svg" alt="content-based-router" width="80"></a></td>
        <td>How to connect one application to another</td>
    </tr>
    <tr>
        <td><a href="https://github.com/wso2/integration-samples/tree/main/EI%20patterns/aggregator" target="_blank">Aggregator</a></td>
        <td><a href="{{base_path}}assets/img/learn/eip/aggregator.svg"><img src="{{base_path}}/assets/img/learn/eip/aggregator.svg" alt="aggregator" width="80"></a></td>
        <td>How to combine the results of individual, but related messages so that they can be processed as a whole</td>
    </tr>
    <tr>
        <td><a href="https://github.com/wso2/integration-samples/tree/main/EI%20patterns/message_filter" target="_blank">Message Filter</a></td>
        <td><a href="{{base_path}}/assets/img/learn/eip/message-filter.svg"><img src="{{base_path}}/assets/img/learn/eip/message-filter.svg" alt="message-filter" width="80"></a></td>
        <td>How a component avoids receiving uninteresting messages</td>
    </tr>
    <tr>
        <td><a href="https://github.com/wso2/integration-samples/tree/main/EI%20patterns/process_manager" target="_blank">Process Manager</a></td>
        <td><a href="{{base_path}}/assets/img/learn/eip/process-manager.svg"><img src="{{base_path}}/assets/img/learn/eip/process-manager.svg" alt="process-manager" width="80"></a></td>
        <td>How to route a message through multiple processing steps, when the required steps may not be known at design time and may not be sequential</td>
    </tr>
    <tr>
        <td><a href="https://github.com/wso2/integration-samples/tree/main/EI%20patterns/routing_slip" target="_blank">Routing Slip</a></td>
        <td><a href="{{base_path}}/assets/img/learn/eip/routing-slip.svg"><img src="{{base_path}}/assets/img/learn/eip/routing-slip.svg" alt="routing-slip" width="80"></a></td>
        <td>How to route a message consecutively through a series of steps when the sequence of the steps is not known at design time and may vary for each message</td>
    </tr>
    <tr>
        <td><a href="https://github.com/wso2/integration-samples/tree/main/EI%20patterns/splitter" target="_blank">Splitter</a></td>
        <td><a href="{{base_path}}/assets/img/learn/eip/splitter.svg"><img src="{{base_path}}/assets/img/learn/eip/splitter.svg" alt="splitter" width="80"></a></td>
        <td>How to process a message if it contains multiple elements, each of which may have to be processed in a different way</td>
    </tr>
</table>

## Message transformation

<table>
    <tr>
        <td><a href="https://github.com/wso2/integration-samples/tree/main/EI%20patterns/content_enricher" target="_blank">Content Enricher</a></td>
        <td><a href="{{base_path}}assets/img/learn/eip/content-enricher.svg"><img src="{{base_path}}/assets/img/learn/eip/content-enricher.svg" alt="content-enricher" width="80"></a></td>
        <td>How to communicate with another system if the message originator does not have all the required data items available</td>
    </tr>
    <tr>
        <td><a href="https://github.com/wso2/integration-samples/tree/main/EI%20patterns/content_filter" target="_blank">Content Filter</a></td>
        <td><a href="{{base_path}}/assets/img/learn/eip/content-filter.svg"><img src="{{base_path}}/assets/img/learn/eip/content-filter.svg" alt="content-filter" width="80"></a></td>
        <td>How to simplify dealing with a large message when you are interested only in a few data items</td>
    </tr>
    <tr>
        <td><a href="https://github.com/wso2/integration-samples/tree/main/EI%20patterns/normalizer" target="_blank">Normalizer</a></td>
        <td><a href="{{base_path}}/assets/img/learn/eip/normalizer.svg"><img src="{{base_path}}/assets/img/learn/eip/normalizer.svg" alt="normalizer" width="80"></a></td>
        <td>How to process messages that are semantically equivalent but arrive in a different format</td>
    </tr>
</table>

## Messaging Endpoints

<table>
    <tr>
        <td><a href="https://github.com/wso2/integration-samples/tree/main/EI%20patterns/idempotent_receiver" target="_blank">Idempotent Receiver</a></td>
        <td><a href="{{base_path}}assets/img/learn/eip/idempotent-receiver.svg"><img src="{{base_path}}/assets/img/learn/eip/idempotent-receiver.svg" alt="idempotent-receiver" width="80"></a></td>
        <td>How to safely receive the same message multiple times</td>
    </tr>
</table>

## System Management

<table>
    <tr>
        <td><a href="https://github.com/wso2/integration-samples/tree/main/EI%20patterns/message_store" target="_blank">Message Store</a></td>
        <td><a href="{{base_path}}assets/img/learn/eip/message-store.svg"><img src="{{base_path}}/assets/img/learn/eip/message-store.svg" alt="message-store" width="80"></a></td>
        <td>How to capture message information in a central location</td>
    </tr>
</table>

