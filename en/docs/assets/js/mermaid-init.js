document.addEventListener("DOMContentLoaded", function () {
    // Select all .mermaid elements
    const mermaidElements = document.querySelectorAll(".mermaid");

    mermaidElements.forEach((el) => {
        // 1. Extract content from <code> tag if it exists, otherwise use el.innerHTML
        const codeTag = el.querySelector("code");
        let content = codeTag ? codeTag.innerHTML : el.innerHTML;

        // 2. Decode HTML entities (e.g., &gt; to >)
        content = content
            .replace(/&lt;/g, "<")
            .replace(/&gt;/g, ">")
            .replace(/&amp;/g, "&")
            .replace(/&quot;/g, '"');

        // 3. Update the element's textContent with the clean, decoded content
        // We use textContent to ensure no HTML tags remain.
        el.textContent = content.trim();
    });

    // 4. Initialize mermaid now that the content is clean
    mermaid.initialize({
        startOnLoad: true,
        theme: document.body.getAttribute("data-md-color-scheme") === "slate" ? "dark" : "default",
        securityLevel: "loose",
    });

    // 5. Manually trigger rendering in case startOnLoad doesn't pick up the changes
    mermaid.run();
});
