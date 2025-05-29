{% set tiles = [
    [{
        "title": "Get Started",
        "icon": "🚀",
        "links": [
            {"name": "Introduction", "url": "get-started/introduction/"},
            {"name": "Key Concepts", "url": "get-started/key-concepts/"},
            {"name": "Quick Start Guide", "url": "get-started/quick-start-guide/"}
        ]
    },
    {
        "title": "Deployment Options",
        "icon": "⚙️",
        "links": [
            {"name": "Deploy to Devant", "url": "deploy/deploy-to-devant/"},
            {"name": "Deploy as a Docker Image", "url": "deploy/deploy-as-docker-image/"},
            {"name": "Deploy on VM as an Executable JAR", "url": "deploy/deploy-on-vm-as-executable-jar/"}
        ]
    }
    ],
    [{
        "title": "Install & Setup",
        "icon": "⏬",
        "links": [
            {"name": "Install Ballerina Integrator", "url": "install-and-setup/install-ballerina-integrator/"},
            {"name": "Install Integration Control Plane", "url": "install-and-setup/install-integration-control-plane/"}
        ]
    },
    {
        "title": "Community & Support",
        "icon": "❓",
        "links": [
            {"name": "GitHub", "url": "https://github.com/wso2/product-ballerina-integrator/issues"},
            {"name": "Discord", "url": "https://discord.com/invite/wso2"},
            {"name": "Enterprise Support", "url": "https://wso2.com/subscription/"}
        ]
    }
    ],
    [
    {
        "title": "Tutorials",
        "icon": "📚",
        "links": [
            {"name": "Introduction to Chat Agents", "url": "learn/ai/agents/introduction-to-chat-agents/"},
            {"name": "Introduction to Inline Agents", "url": "learn/ai/agents/introduction-to-inline-agents"},
            {"name": "Integrating Agents with External Endpoints", "url": "learn/ai/agents/integrating-agents-with-external-endpoints/"},
            {"name": "File Integration With Directory Service", "url": "learn/file-integration/file-integration-with-directory-service/"},
            {"name": "Build an HTTP Service With WSO2 Copilot", "url": "develop/ai-assisted-development/build-an-http-service-with-wso2-copilot/"},
            {"name": "Message Transformation", "url": "learn/samples/message-transformation/"},
            {"name": "Message Routing", "url": "learn/samples/message-routing/"},
            {"name": "Service Orchestration", "url": "learn/samples/service-orchestration"}
        ]
    },
    {
        "title": "Samples",
        "icon": "📖",
        "links": [
            {"name": "Enterprise Integration Patterns", "url": "learn/enterprise-integrations-patterns/"}
        ]
    }
    ]
] %}

<div class="homePage">
    <div class="description-section">
        <div>
            WSO2 Ballerina Integrator</b> is a low-code integration solution built on <a href="https://ballerina.io">Ballerina</a>, enabling fast and efficient integration development with minimal coding. The Ballerina Integrator extension for Visual Studio Code (VS Code) provides a familiar, AI-assisted environment that streamlines tasks and enhances accuracy, accelerating digital transformation efforts.
        </div>
        <div>
            <a href="https://wso2.com/integrator/ballerina-integrator/" class="banner-link"></a>
        </div>
    </div>
    <div class="section02">
        <div class="tiles-container">
            {% for column in tiles %}
            <div class="tiles-column">
                {% for tile in column %}
                <div class="tile">
                    <div class="tile-header">
                        <h3>{{ tile.title }}</h3>
                        <span class="tile-icon">{{ tile.icon }}</span>
                    </div>
                    <ul class="links-list">
                        {% for link in tile.links %}
                        <li>
                            {% if tile.title == "Community & Support" %}
                                <a href="{{ link.url }}" target="_blank" class="link">{{ link.name }}</a>
                            {% else %}
                                <a href="{{ base_path }}/{{ link.url }}" class="link">{{ link.name }}</a>
                            {% endif %}
                        </li>
                        {% endfor %}
                    </ul>
                    {% if tile.more_btn %}
                    <div class="button-container">
                        <a href="{{base_path}}/{{ tile.more_btn.url }}" class="view-all-button">{{ tile.more_btn.name }}</a>
                    </div>
                    {% endif %}
                </div>
                {% endfor %}
            </div>
            {% endfor %}
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
    justify-content: center;
    /* background: linear-gradient(100deg, #fff9ee, #ffffff); */
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
.description-section {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 30px;
    margin-left: 100px;
}
.tiles-container {
    display: flex;
    align-items: start;
}
.tile {
    display: inline-block;
    vertical-align: top;
    background-color: rgba(255, 255, 255, 0.03);
    padding: 20px;
    border-radius: 10px;
    box-shadow: 0px 0px 5px rgba(0, 0, 0, 0.2);
    transition: transform 0.2s ease-in-out;
    position: relative;
    display: flex;
    flex-direction: column;
    justify-content: flex-start;
    margin: 0 0 25px 25px;
}
.tile:hover {
    transform: scale(1.01);
}
.tile-header {
    display: flex;
    justify-content: space-between;
    border-bottom: 1px solid rgb(215, 215, 215);
}
.tile h3 {
    font-size: 0.9rem;
    margin-top: 0px;
}
.tile-icon {
    margin-left: 30px;
    font-size: 1rem;
}
.links-list li {
    list-style-type: none;
}
.link {
    display: inline-block;
    margin-left: -30px;
    color: var(--text-color) !important;
    text-decoration: none;
}
.link:hover {
    color: rgb(255, 112, 67) !important;
    text-decoration: none;
}
.link:before {
    content: '→';
    font-weight: bold;
    margin-right: 5px;
}
.button-container {
    text-align: right;
}
.view-all-button {
    display: inline-block;
    background-color: none;
    color: var(--text-color) !important;
    text-decoration: none;
    border-radius: 5px;
}
.view-all-button:hover {
    color: rgb(255, 112, 67) !important;
}
</style>
{% endraw %}
