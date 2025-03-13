<div class="homePage">
    <div class="section01">
        <div class="leftContent">
            <div class="about-home">
                <div>
                    <b>Ballerina Integrator</b> is a low-code integration solution built on <a href="https://ballerina.io">Ballerina</a>, enabling fast and efficient integration development with minimal coding. The Ballerina Integrator extension for Visual Studio Code (VS Code) provides a familiar, AI-assisted environment that streamlines tasks and enhances accuracy, accelerating digital transformation efforts.
                    <div style="width: 75%" class="linkSet2" onclick="location.href='{{base_path}}/get-started/quick-start-guide';">
                    <a href="get-started/quick-start-guide"><h3>Quick Start Guide </h3></a>
                        <p>
                        Get started with Ballerina Integrator by running a simple integration use case in your local environment.
                        </p>
                    </div>
                </div>
                <div  style="text-align:center">
                    <a href="{{base_path}}/assets/img/introduction/bi.png"><img src="{{base_path}}/assets/img/introduction/bi.png" alt="Ballerina Integrator" width="55%"></a>
                </div>
            </div>
        </div>
    </div>
    <hr class="rounded">
    <div class="section02">
        <div class="rightContent">
                <div class="about-home">
                    <div  style="text-align:center">
                        <a href="{{base_path}}/assets/img/introduction/low-code.gif"><img src="{{base_path}}/assets/img/introduction/low-code.gif" alt="low-code" width="90%" style="padding-top: 60px" ></a>
                    </div>
                    <div>
                        <h3>Low-code integration development</h3>
                        <p>
                            Ballerina Integrator offers a user-friendly, streamlined environment for building integrations with minimal coding, accessible to both experienced developers and beginners. Here’s how Ballerina Integrator’s low-code features simplify integration development:
                        </p>
                        <ul>
                            <li><b>Design visually:</b> Ballerina Integrator’s interface lets users design integrations visually, simplifying flow creation and management.</li>
                            <li><b>Pre-built connectors:</b> Ballerina Integrator offers connectors for easy integration with various systems and services.</li>
                            <li><b>Reuse components:</b> Create and share reusable components across integrations, saving time and effort.</li>
                            <li><b>Automate testing:</b> Automated testing helps identify and fix issues early.</li>
                            <li><b>AI-assisted development:</b> Ballerina Integrator’s AI provides smart suggestions to boost coding efficiency and accuracy.</li>
                        </ul>
                    </div>
                </div>
        </div>
    </div>
     <hr class="rounded">
     <div class="section02">
        <div class="leftContent">
                <div class="about-home">
                    <div>
                        <h3>AI-assisted development</h3>
                        <p>
                            Ballerina Integrator leverages AI to streamline coding tasks, improve code quality, and reduce time on error-prone processes. Here’s how Ballerina Integrator’s AI capabilities make a difference:
                        </p>
                        <ul>
                            <li><b>Code suggestions and autocompletion:</b> Ballerina Integrator’s AI provides context-aware suggestions, helping developers code faster with real-time prompts for methods, properties, and configurations.</li>
                            <li><b>Error detection and fix recommendations:</b> AI identifies errors and suggests fixes early, enhancing code quality and minimizing debugging needs.</li>
                            <li><b>Pattern recognition and code optimization:</b> Ballerina Integrator’s AI detects code patterns and suggests optimizations, boosting performance and aiding code standardization.</li>
                            <li><b>Natural language code search and commands:</b> Developers can search for code snippets or methods using natural language, reducing documentation time and accelerating onboarding.</li>
                            <li><b>Smart refactoring and code restructuring:</b> Ballerina Integrator’s AI suggests refactoring options, enabling a cleaner, more maintainable codebase.</li>
                        </ul>
                    </div>
                    <div  style="text-align:center">
                        <a href="{{base_path}}/assets/img/introduction/ai.gif"><img src="{{base_path}}/assets/img/introduction/ai.gif" alt="AI" width="90%" style="padding-top: 60px; padding-right: 50px" ></a>
                    </div>
                </div>
        </div>
    </div>
    <hr class="rounded">
    <div class="section02">
        <div class="rightContent">
                <div class="about-home">
                    <div  style="text-align:left; display: flex; flex-direction: column;  justify-content: center">
                        <img src="{{base_path}}/assets/img/introduction/ballerina.svg" alt="ballerina" width="80%" style="padding-right: 50px" >
                    </div>
                    <div>
                        <h3>Leverage the power of Ballerina</h3>
                        <p>
                            Ballerina Integrator uses <a href="https://ballerina.io"><b>Ballerina</b></a>, a language designed for seamless integration development, making API-driven, cloud-native workflows simpler and more efficient. Ballerina offers:
                        </p>
                        <ul>
                            <li><b>Integration-centric syntax:</b> Optimized syntax with constructs like services, data types, and data mappers for clear API orchestration.</li>
                            <li><b>Cloud-native design:</b> Supports HTTP, WebSocket, gRPC, and Kafka for API-first, microservices-ready development.</li>
                            <li><b>Visual flow representation:</b> Graphical views that show data flow and logic for complex workflows.</li>
                            <li><b>Observability and resilience:</b> Built-in tracing, metrics, and logging for efficient monitoring.</li>
                            <li><b>Unified data handling:</b> Simplifies data transformations for diverse integrations.</li>
                            <li><b>Testing and deployment tools:</b> Integrated tools for scalable, reliable cloud deployment.</li>
                        </ul>
                    </div>
                </div>
        </div>
    </div>
</div>
{% raw %}
<style>
.md-sidebar.md-sidebar--primary {
    display: none;
}
.md-sidebar.md-sidebar--secondary{
    display: none;
}
.section02 {
    display: flex;
    justify-content: space-between;
}
header.md-header .md-header__button:not([hidden]) {
    /* display: none; */
}
.about-home {
    display: flex;
}
.about-home div:first-child {
    width: 50%;
    padding-top: 20px;
}
.about-home div:nth-child(2) {
    width: 50%;
}
@media screen and (max-width: 76.1875em) {
    .md-sidebar.md-sidebar--primary {
        display: block;
    }
}
@media screen and (max-width: 945px) {
    .about-home div:first-child {
        width: 100%;
    }
    .about-home div:nth-child(2) {
        width: 100%;
    }
    .about-home {
        flex-direction: column;
    }
    .md-typeset a {
        background-position-x: left;
    }
    .download-btn-wrapper {
        display: block;
        text-align: center;
    }
}
.md-typeset h1{
    visibility: hidden;
    margin-bottom: 0;
}
.md-search-result__article.md-typeset h1{
    visibility: visible;
}
</style>
{% endraw %}