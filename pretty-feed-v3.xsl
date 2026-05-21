<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet
    version="3.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:atom="http://www.w3.org/2005/Atom">
  <xsl:output method="html" version="4.0" encoding="UTF-8" indent="yes"/>
  <xsl:template name="format-date">
    <xsl:param name="iso" />

    <xsl:variable name="year"  select="substring($iso,1,4)" />
    <xsl:variable name="month" select="substring($iso,6,2)" />
    <xsl:variable name="day"   select="substring($iso,9,2)" />

    <xsl:choose>
      <xsl:when test="$month='01'">January</xsl:when>
      <xsl:when test="$month='02'">February</xsl:when>
      <xsl:when test="$month='03'">March</xsl:when>
      <xsl:when test="$month='04'">April</xsl:when>
      <xsl:when test="$month='05'">May</xsl:when>
      <xsl:when test="$month='06'">June</xsl:when>
      <xsl:when test="$month='07'">July</xsl:when>
      <xsl:when test="$month='08'">August</xsl:when>
      <xsl:when test="$month='09'">September</xsl:when>
      <xsl:when test="$month='10'">October</xsl:when>
      <xsl:when test="$month='11'">November</xsl:when>
      <xsl:when test="$month='12'">December</xsl:when>
    </xsl:choose>

    <xsl:text> </xsl:text>

    <xsl:value-of select="number($day)" />
    <xsl:text>, </xsl:text>

    <xsl:text> </xsl:text>
    <xsl:value-of select="$year" />
  </xsl:template>

  <xsl:template match="/">
    <html xmlns="http://www.w3.org/1999/xhtml" lang="en">
      <head>
        <meta charset="utf-8"/>
        <meta name="viewport" content="width=device-width, initial-scale=1"/>
        <title><xsl:value-of select="atom:feed/atom:title"/></title>
        <style type="text/css">*{box-sizing:border-box}body{background-color:#fff;color:#24292e;font-family:-apple-system,BlinkMacSystemFont,"Segoe UI",Helvetica,Arial,sans-serif,"Apple Color Emoji","Segoe UI Emoji","Segoe UI Symbol";line-height:1.5}a{color:#0366d6;text-decoration:none}a:hover{text-decoration:underline}.container{max-width:40rem;margin:1rem auto;padding:1rem}nav{margin-top:2rem;margin-bottom:2rem}p{margin-top:0;margin-bottom:1rem}h1,h2,h3{margin-top:0;margin-bottom:1rem;font-weight:600;line-height:1.25}h1{padding-bottom:.3em;font-size:2em}h1 svg{padding-right:.25rem;vertical-align:text-bottom;width:1.2em;height:1.2em}h2{margin-top:1.5rem;padding-bottom:.3em;font-size:1.5em;border-bottom:1px solid #eaecef}h3{font-size:1.25em;margin-bottom:0}.about{background-color:#fff5b1;margin:.25rem -.25rem;padding:.25rem}header{padding-top:2rem;padding-bottom:2rem}.item{padding-bottom:2rem}.gray{color:#586069}</style>
      </head>
      <body>
        <nav class="container">
          <p class="about">
            <strong>This is a web feed,</strong> also known as an RSS or Atom feed.<br /><strong>Subscribe</strong> by copying the URL from the address bar into your newsreader.
          </p>
          <p class="gray">
            Visit <a href="https://aboutfeeds.com">About Feeds</a> to get started with newsreaders and subscribing. It’s free.
          </p>
        </nav>
        <div class="container">
          <header>
            <h1>
              <svg xmlns="http://www.w3.org/2000/svg" version="1.1" viewBox="0 0 256 256">
                <defs>
                  <linearGradient x1="0.085" y1="0.085" x2="0.915" y2="0.915" id="RSSg">
                    <stop offset="0.0" stop-color="#E3702D"/><stop offset="0.1071" stop-color="#EA7D31"/>
                    <stop offset="0.3503" stop-color="#F69537"/><stop offset="0.5" stop-color="#FB9E3A"/>
                    <stop offset="0.7016" stop-color="#EA7C31"/><stop offset="0.8866" stop-color="#DE642B"/>
                    <stop offset="1.0" stop-color="#D95B29"/>
                  </linearGradient>
                </defs>
                <rect width="256" height="256" rx="55" ry="55" x="0"  y="0"  fill="#CC5D15"/>
                <rect width="246" height="246" rx="50" ry="50" x="5"  y="5"  fill="#F49C52"/>
                <rect width="236" height="236" rx="47" ry="47" x="10" y="10" fill="url(#RSSg)"/>
                <circle cx="68" cy="189" r="24" fill="#FFF"/>
                <path d="M160 213h-34a82 82 0 0 0 -82 -82v-34a116 116 0 0 1 116 116z" fill="#FFF"/>
                <path d="M184 213A140 140 0 0 0 44 73 V 38a175 175 0 0 1 175 175z" fill="#FFF"/>
              </svg>
              Web Feed Preview
            </h1>
            <h2><xsl:value-of select="atom:feed/atom:title"/></h2>
            <p><xsl:value-of select="atom:feed/atom:description"/></p>
            <a>
              <xsl:attribute name="href">
                <xsl:value-of select="/atom:feed/atom:link[not(@rel)]/@href"/>
              </xsl:attribute>
              Visit Website &#x2192;
            </a>
          </header>
          <h2>Recent Items</h2>
          <xsl:apply-templates select="atom:feed/atom:entry" />
          <small class="gray">
            <a href="https://github.com/genmon/aboutfeeds">Pretty Feed</a> by Matt Webb (with modifications by Nicolas Hoizey and Adam Saunders) is licensed under <a href="https://creativecommons.org/licenses/by-nc-sa/3.0/">CC BY-SA-NC 3.0</a>.
          </small>
        </div>
      </body>
    </html>
  </xsl:template>
  <xsl:template match="atom:feed/atom:entry">
    <div class="item">
      <h3>
        <a>
          <xsl:attribute name="href">
            <xsl:value-of select="atom:link/@href"/>
          </xsl:attribute>
          <xsl:value-of select="atom:title"/>
        </a>
      </h3>
      <small class="gray">
        <xsl:call-template name="format-date">
          <xsl:with-param name="iso" select="atom:updated" />
        </xsl:call-template>
      </small>
    </div>
  </xsl:template>
</xsl:stylesheet>
