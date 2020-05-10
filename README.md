# DITA-mini-toc-element

## Introduction

This plugin allows you to place a mini-toc anywhere in your content, with optional introductory text. The mini-TOC is inserted during the preprocessing stage, so it works for all output formats (including normalized DITA).

## Getting Started

Install the following provided plugin in your DITA-OT:

```
plugins/com.synopsys.mini-toc
```

## Usage

To insert a mini-TOC in your content, add a &lt;sub-toc&gt; element and optionally insert introductory content:

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

The plugin also looks for a `&lt;sub-toc&gt;` element, which you can specialize from `div` in your own grammar plugin:

```
    <sub-toc>
      <p>The following topics provide information about the XYZ feature:</p>
    </sub-toc>
```

For an easy way to create your own DITA grammars, see:

[chrispy-snps / DITA-plugin-utilities on Github](https://github.com/chrispy-snps/DITA-plugin-utilities)

## Operation

The plugin operates in two stages during preprocessing:

1. During `maplink`, the plugin creates an extra copy of all child links in a `&lt;linkpool @role="mini-toc"&gt;` element, which is run regardless of the value of the `` parameter.

2. During `topicpull`, &lt;mini-toc&gt; elements are located and an unordered list of child links is appended as the last child, then the special `&lt;linkpool&gt;` list is deleted.

Here is the `html5` output:

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

The child links are obtained using the existing `&lt;nav&gt;` (child/parent/sibling navigation) link collection code.

## Limitations

Note the following limitations of the plugin:

* The child links do reflect any DITAVAL filtering conditions applied to the child topics, but they *do not* reflect any DITAVAL flagging or highlighting properties applied to the child topics.
* Because navigation collection ignores the `toc="no"` attribute of topic references, so does this plugin.

