const fs = require("fs");

module.exports = async function(eleventyConfig) {
  const { EleventyHtmlBasePlugin } = await import("@11ty/eleventy");
  const pluginRss = await import("@11ty/eleventy-plugin-rss");

  eleventyConfig.addPassthroughCopy("style.css");
  eleventyConfig.addPassthroughCopy("waves.js");
  eleventyConfig.addPassthroughCopy("pretty-feed-v3.xsl");

  eleventyConfig.addPlugin(pluginRss.default);

  // date formatting filter
  eleventyConfig.addFilter("postDate", (dateObj) => {
    return new Intl.DateTimeFormat('en-US', {
      year: 'numeric',
      month: 'short',
      day: 'numeric'
    }).format(dateObj);
  });

  eleventyConfig.addFilter("feedDate", (dateObj) => {
    const d = new Date(dateObj);
    const dateOnly = d.toISOString().split('T')[0];
    // return with UTC noon
    return `${dateOnly}T12:00:00Z`;
  });

  eleventyConfig.addCollection("posts", function(collectionApi) {
    return collectionApi.getFilteredByTag("posts").sort((a, b) => {
      return b.date - a.date; // newest to oldest
    });
  });

  // 404 routing config for local development
  eleventyConfig.setServerOptions({
      callbacks: {
        ready: function(err, serverLib) {
          serverLib.addMiddleware("*", (req, res, next) => {
            try {
              const content_404 = fs.readFileSync("_site/404.html");
              res.writeHead(404, { "Content-Type": "text/html; charset=UTF-8" });
              res.write(content_404);
              res.end();
            } catch(e) {
              next();
            }
          });
        },
      },
    });

  //icon 
  eleventyConfig.addPassthroughCopy("icon.svg");

  return {
    dir: {
      input: ".",
      output: "_site",
      includes: "_includes"
    }
  };
};