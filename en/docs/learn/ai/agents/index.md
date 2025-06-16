# Agents Overview

The Ballerina Integrator (BI) enables developers to easily create intelligent AI agents powered by large language models (LLMs) and integrated with external APIs and services. These AI agents can automate complex workflows, interact with users through natural language, and seamlessly connect with systems like Gmail, Google Calendar, and more. Designed for low-code development and rapid integration, BI makes it simple to embed AI-driven logic into your applications, services, and business processes.

There are two main types of AI agents in BI:

## Chat Agents

Chat agents are exposed through HTTP endpoints as REST APIs and are designed to interact with users or external systems. These agents are ideal when you need a chatbot-like experience, where users can type questions or commands and receive intelligent responses powered by an LLM.

## Inline Agents

Inline agents are embedded within service logic (e.g., REST APIs, GraphQL resolvers) and invoked programmatically as part of a backend workflow. These agents are ideal for automation, enrichment, or dynamic processing tasks within your services or business logic.

Both Chat and Inline agents can be extended with tools that connect to real-world systems via BI's built-in connectors. You can easily integrate agents with services like Gmail, Google Calendar, databases, or custom APIs—allowing agents to perform actions beyond reasoning, such as reading emails, sending messages, creating events, or fetching records.

To get started with agents, visit the following tutorial examples:

* [Introduction to Chat Agents](/learn/ai/agents/introduction-to-chat-agents/)
* [Introduction to Inline Agents](/learn/ai/agents/introduction-to-inline-agents/)
* [Integrating Agents with External Endpoints](/learn/ai/agents/integrating-agents-with-external-endpoints/)
