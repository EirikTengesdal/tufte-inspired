#import "@preview/drafting:0.2.0": *
#import "@preview/marge:0.1.0": sidenote, container

#let marginfontsize = 8pt
#let fontsize = 12pt

#let leftpadding = 1.5em
#let rightpadding = 4em

#let footnote = sidenote.with(
  numbering: "1",
  padding: (left: 1.5em, right: 4.5em),//left: leftpadding - 0.24em, // If you want to make the two types of sidenotes occur in parallell apart from the superscript?

  format: it => {
    set text(size: marginfontsize)
    it.default
  }
)

// TODO: marge is not compatible with my #sidecite() if it occurs in figure captions from Quarto.

#let sidecitation = sidenote.with(
  padding: (left: 1.5em, right: 4.5em),
  format: it => {
    set text(size: marginfontsize)
    it.default
  }
)

#let sidecite(key, mode, prefix, suffix, noteNum, hash) = context {
  if query(bibliography).len()>0 {
    let supplement = if suffix.split(",").filter(value => not value.contains("dy.")).join(",") == "" {
      none
    } else {
      suffix.split(",").filter(value => not value.contains("dy.")).join(",")
    }

    let filtered = suffix.split(",").filter(value => value.contains("dy.")).join(",")
    
    let dy = if filtered != none {
      eval(filtered.match(regex("(\d+)(pt|mm|cm|in|em)")).text)
    } else {
      0pt
    }    
    if supplement != none and supplement.len()>0 {cite(key, form: "normal", supplement: supplement)} else {cite(key, form: "normal")}

    [#sidecitation(dy: dy)[
      #if supplement != none and supplement.len()>0 {
        cite(key, form:"full", supplement: supplement)
      } else {
        cite(key, form:"full")
      }]]
  }
}



// #let wideblock(content, ..kwargs) = block(..kwargs, width: 100% + rightval - leftval, content)
#let wideblock(content, ..kwargs) = block(..kwargs, width:100%+3.5in-.75in, content)

// Fonts used in front matter, sidenotes, bibliography, and captions
#let sans-fonts = (
    "Gill Sans MT",
    "TeX Gyre Heros",
    // "Noto Sans"
  )

// Fonts used for headings and body copy
#let serif-fonts = (
  "Minion 3",
  "ETBookOT",
  "ETBembo",
  "Heuristica",
  "Merriweather",
  // "Harding Text Web",
  // "Linux Libertine",
)

// Monospaced fonts
#let mono-fonts = (
  "DejaVu Sans Mono",
  "SF Mono",
)

// Math fonts
//#show math.equation: set text(font: "Euler Math")
//#show math.equation: set text(font: "TeX Gyre Pagella Math", number-type: "old-style")
#show math.equation: set text(number-type: "old-style")

// Global font settings
#show page: set text(font: serif-fonts)

// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

#let article(
  title: [Paper Title],
  shorttitle: none,
  subtitle: none,
  authors: none,
  product: none,
  date: none,
  dateformat: "[day].[month].[year]",
  paper: "us-letter",
  margin: none,
  headerascent: 30% + 0pt,
  lang: "en",
  region: "US",
  sectionnumbering: none,
  version: none,
  draft: false,
  distribution: none,
  abstract: none,
  abstracttitle: none,
  publisher: none,
  documenttype: none,
  toc: none,
  toc_title: none,
  bib: none,
  bibliography-title: "Referanser",
  bibliography-style: "springer-humanities-author-date",
  first-page-footer: none,
  doc
) = {
  // Definitions
  let margin = if margin == none {
    if paper == "a4" {
      (
        left: 20mm,
        right: 90mm,
        top: 25mm,
        bottom: 20mm
      )
    } else if paper == "us-letter" {
      (
        left: .75in,
        right: 3.5in,
        top: 1in,
        bottom: 1in
      )
    }
  } else {
    margin
  }
  
  let header-ascent = if paper == "a4" {
    50% + 0pt
  } else {
    headerascent
  }

  // Definitions
  let page_width = if paper == "a4" {
    210mm
  } else {
    8.5in
  }
  
  let margin = if margin == none {
    if paper == "a4" {
      (
        left: 24.8mm,
        right: 100mm - 24.8mm,
        top: 25mm,
        bottom: 20mm
      )
    } else if paper == "us-letter" {
      (
        left: .75in,
        right: 3.5in,
        top: 1in,
        bottom: 1in
      )
    }
  } else {
    margin
  }
  
  let wideblock(content) = block(width: 100% + margin.right - rightpadding, content)
  
  let header-ascent = if paper == "a4" {
    50% + 0pt
  } else {
    headerascent
  }
  
  // Page setup 
  
  // From https://github.com/gnishihara/quarto-appendix/blob/main/_extensions/appendix/typst-template.typ
  // Allow custom title for bibliography section
  //set bibliography(title: bibliography-title, style: bibliography-style)
  set bibliography(title: none, style: bibliography-style)
  

  // Just a subtle lightness to decrease the harsh contrast
  set text(
    fill: luma(30),
    lang: lang,
    region: region,
    historical-ligatures: true,
    number-type: "old-style",
  )
  
  let lr(l, r, ..kwargs) = wideblock( ..kwargs, 
    grid(columns: (1fr, 4fr), align(left, text(size: 8pt, l)), align(right, text(size: 11pt, r)))
  )

  set par(justify: true)
  set page(
    //width: auto,
    //background: container,
    //background: container, //marge
    paper: paper,
    //margin: margin,
    //width: 8cm,
    //height: auto,
    //width: page_width - 10em,//210mm,
    margin: margin,
    //margin: (right: 7cm),

    //height: 297mm,
    header: context {
      if counter(page).get().first() > 1 {
        set text(font: serif-fonts, tracking: 1.5pt)
        //lr([],
        lr([],
        [#if shorttitle !=none {smallcaps(lower([#shorttitle#h(1em)#counter(page).display()]))} else {smallcaps(lower([#title#h(1em)#counter(page).display()]))}])
      }
    },
    header-ascent: header-ascent,
    footer: context {
      if counter(page).get().first() < 2 {
        if first-page-footer !=none {first-page-footer}
      } 
    },
  )

  //set-page-properties()
  
 // set-margin-note-defaults(
 //   stroke: none,
 //   side: right,
  //  page-width: page_width - margin.right - .5in - 1em,
  //  margin-right: margin.right - margin.left
  //)
  set par(leading: .75em, justify: true, linebreaks: "optimized", first-line-indent: 1em)//, spacing: 0.65em)
  show par: set block(
    spacing: 0.65em
  )

  // Frontmatter

  let authorblock() = [
    #set text(font: serif-fonts, size: fontsize, style: "italic")
    #set par(first-line-indent: 0em)
    #for (author) in authors [
      #author.name
      #linebreak() 
      #if author.email != none [#text(size: 7pt, font: mono-fonts, link("mailto:" + author.email.replace("\\@", "@")))]
      //#if author.email != none [#text(size: 7pt, font: mono-fonts, [#author.email])]
      #linebreak()
    ]
    
    #if date != none {
      if date.contains(".") {
        let (day, month, year) = date.split(".")
        let day = datetime(year: int(year), month: int(month), day: int(day))
        [#day.display(dateformat)]
      } else {
        let (year, month, day) = date.split("-")
        let day = datetime(year: int(year), month: int(month), day: int(day))
        [#day.display(dateformat)]
      }
    }
  ]
  
  //title block
  wideblock({
    set par(first-line-indent: 0pt)
    v(-.5cm)
    text(font: sans-fonts, number-type: "lining", tracking: 1.5pt, fill: gray.lighten(60%), upper(documenttype))
    v(.1cm)//v(.5cm)
    text(font: serif-fonts, style: "italic", size: 22pt, hyphenate: false, weight: "regular", title)
    linebreak()
    text(font: serif-fonts, style: "italic", size: 16pt, stretch: 80%, weight: "regular", hyphenate: true, subtitle)
    linebreak()
    if version != none {text(font: sans-fonts, size: 8pt, style: "normal", fill: gray)[#version]} else []
    if authors != none {authorblock()}
    if abstract != none {
      block(inset: 1.5em)[#text(font: serif-fonts, size: 11pt)[#abstract]]
    } else {v(3em)}
  })
  
  //TOC
  let tocblock() = {
    set par(first-line-indent: 0pt)
    [
      #text(font: serif-fonts, size: fontsize, weight: "regular", style: "italic", [#toc_title])
      #set text(font: serif-fonts, size: .75em, weight: "regular", style: "italic")
      #outline(
        title: none,
        depth: 1,
        indent: 1em,
      )
    ]
  }

  if toc !=none [#sidenote(padding:(left: leftpadding, right: rightpadding), dy: 0.45em)[#tocblock()]]//[#margin-note(dx: 0em, dy: -1em)[#tocblock()]]


  // Headings
  set heading(
    numbering: sectionnumbering
  )
  show heading.where(level:1): it => {
    v(2em, weak: true)
    text(size: 14pt, weight: "regular", style: "italic", it)
    v(1em, weak: true)
  }

  show heading.where(level:2): it => {
    v(1.3em, weak: true)
    text(size: 13pt, weight: "regular", style: "italic", it)
    v(1em, weak: true)
  }

  show heading.where(level:3): it => {
    v(1em, weak:true)
    text(size: 11pt, style:"italic", weight: "thin", it)
    v(0.65em, weak:true)
  }

  show heading: it => {
    if it.level <= 3 {it} else {}
  }
  
  // TODO: Handle Quarto appendices.


  // Tables and figures
  show figure: set figure.caption(separator: [.#h(0.5em)])
  show figure.caption: set align(left)
  show figure.caption: set text(font: serif-fonts)

  show figure.where(kind: table): set figure.caption(position: bottom)
  show figure.where(kind: table): set figure(numbering: "I")
  
  show figure.where(kind: image): set figure(supplement: [Figure], numbering: "1")
  
  show figure.where(kind: raw): set figure.caption(position: bottom)
  show figure.where(kind: raw): set figure(supplement: [Code], numbering: "1")
  show raw: set text(font: mono-fonts, size: 8pt, historical-ligatures: false)
  

  // Equations
  // set math.equation(numbering: "(1)")
  set math.equation(numbering: (..n) => {
    text(font: serif-fonts, numbering("(1)", ..n))
  })
  show math.equation: set block(spacing: 0.65em)

  //show link: underline

  // Lists
  set enum(
    indent: 1em,
    body-indent: 1em,
  )
  show enum: set par(justify: false)
  set list(
    indent: 1em,
    body-indent: 1em,
  )
  show list: set par(justify: false)


  // Body text
  set text(
    font: serif-fonts,
    style: "normal",
    weight: "regular",
    hyphenate: true,
    size: fontsize
  )
  
  show cite.where(form: "prose"): none
  
  //set text(size: 12pt)
  v(-.5in)
  doc
  
  //if bib != none {
  //  heading(level:1,[References])
  //  bib
  //}
}
