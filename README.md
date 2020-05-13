# DITA-mini-toc-element

## Introduction

This plugin allows you to place a mini-toc anywhere in your content, with optional introductory text. The mini-TOC is inserted during the preprocessing stage, so it works for all output formats (including normalized DITA).

## Getting Started

Install the following provided plugin in your DITA-OT:

```
com.synopsys.mini-toc/
```

## Usage

To insert a mini-TOC in your content, add a `<div outputclass="mini-toc">` element and optionally include introductory content:

```
<topic>
  <title>My Topic</title>
  <body>
    <div outputclass="mini-toc">
      <p>The following topics provide information about the XYZ feature:</p>
    </div>
  </body>

  <topic>
    <title>XYZ Feature Writeup 1</title>
    ...
  </topic>

  <topic>
    <title>XYZ Feature Writeup 2</title>
    ...
  </topic>
</topic>
```

The plugin also looks for a `<mini-toc>` element, which you can specialize from `div` in your own grammar plugin:

```
    <mini-toc>
      <p>The following topics provide information about the XYZ feature:</p>
    </mini-toc>
```

For an easy way to create your own DITA grammars, see:

[chrispy-snps / DITA-plugin-utilities on Github](https://github.com/chrispy-snps/DITA-plugin-utilities)

In Oxygen XML Author, we use the following CSS to add placeholder items for author comfort:

```
@media oxygen {
  *[class~='snps-d/mini-toc'] {
    border-style: dotted;
    border-color: blue;
    border-width: thin;
  }

  *[class~='snps-d/mini-toc']:after {
    display: block;
    content: oxy_label(text, "\2022", styles, "font-size:1.5em;") oxy_label(text, "   (child topics will", styles, "color:blue;display:inline-block;")
        '\a' oxy_label(text, "\2022", styles, "font-size:1.5em;") oxy_label(text, "   be added here)", styles, "color:blue;display:inline-block;");
    list-style-type: disc;
    list-style-position: outside;
    margin-top: -6pt;
  }
}
```

## Operation

The plugin operates in two stages during preprocessing:

1. During `maplink`, the plugin creates an extra copy of all child links.

2. During `topicpull`, mini-TOC elements in the DITA content have an unordered list of child links appended. In addition, the special `<linkpool>` list from step 1 is deleted.

Here is the `html5` output from the previous example:

```
<h1 class="title topictitle1" id="ariaid-title1">My Topic</h1>
<div class="body">
  <div class="div mini-toc">
    <p class="p">The following topics provide information about the XYZ feature:</p>
    <ul class="ul">
      <li class="li"><a class="xref" href="topic.html#sub1">XYZ Feature #1</a></li>
      <li class="li"><a class="xref" href="topic.html#sub2">XYZ Feature #2</a></li>
    </ul>
  </div>
</div>
```

You can use the `mini-toc` value in the `@class` attribute to apply CSS formatting or to display/hide the entire mini-TOC (such as including in PDF, excluding in online help).

## Examples

To run the example, install the DITA-OT plugin, then run the following commands:

    cd ./example
    ./runme.sh

## Implementation Notes

During `maplink`, the child links are obtained using the existing `<nav>` (child/parent/sibling navigation) link collection code. The `maplink-minitoc.xsl` file creates an extra copy of all child links in a `<linkpool @role="mini-toc">` list (even if the `args.rellinks` parameter is set to `none`). And fortunately, the `org.dita.dost.module.MoveLinksModule` Java class is kind enough to copy our list into the topics along with its own content!

## Limitations

Note the following limitations of the plugin:

* The mini-TOC child `<xref>` elements do appear/disappear to reflect any DITAVAL filtering conditions applied to the child topics, but they *do not* show any DITAVAL flagging or highlighting properties applied to the child topics. This is purely cosmetic.
* Because navigation collection ignores the `@toc="no"` attribute of topic references, so does this plugin.

