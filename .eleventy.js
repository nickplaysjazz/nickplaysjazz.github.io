const fs = require("fs");
const {DateTime} = require("luxon")

const TIME_ZONE = "America/Chicago";

module.exports = async function(eleventyConfig) {
  const { EleventyHtmlBasePlugin } = await import("@11ty/eleventy");
  const pluginRss = await import("@11ty/eleventy-plugin-rss");

  // fix time zone
  eleventyConfig.addDateParsing(function(dateValue) {
		let localDate;
		if(dateValue instanceof Date) { // and YAML
			localDate = DateTime.fromJSDate(dateValue, { zone: "utc" }).setZone(TIME_ZONE, { keepLocalTime: true });
		} else if(typeof dateValue === "string") {
			localDate = DateTime.fromISO(dateValue, { zone: TIME_ZONE });
		}
		if (localDate?.isValid === false) {
			throw new Error(`Invalid \`date\` value (${dateValue}) is invalid for ${this.page.inputPath}: ${localDate.invalidReason}`);
		}
		return localDate;
	});

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