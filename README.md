# An adapted Tufte-inspired Quarto template

This is a Quarto template[^readme-1] that lets you create documents with formatting inspired by the Tufte style. The main output file formats are HTML and PDF (via Typst).

[^readme-1]: This adapted repository is based on a GitHub repository fork, [fredguth/tufte-inspired](https://github.com/fredguth/tufte-inspired).

## Installing the template in Quarto

You can install this template in two ways:

### From GitHub (recommended)
Run the following command in a terminal[^readme-2] to install the template directly from this repository:

[^readme-2]: For instance in your RStudio `Terminal`. See further instructions in the [Quarto documentation](https://quarto.org/docs/extensions/starter-templates.html).

``` bash
quarto use template EirikTengesdal/tufte-inspired
```

### Manual installation
1. Download or clone this repository
2. Copy the `_extensions/tufte-inspired` folder to your project
3. Use the provided `index.qmd` as a starting point

This will install the format extension and create an example QMD file that you can use as a starting point for your document.

## Features

- **HTML output** with Tufte-style sidenotes and margin content
- **PDF output** via Typst with similar styling
- Support for fullwidth content blocks
- Integrated ET Book font (included)
- Norwegian language support (customisable)
- Bibliography and citation support

## Sample Typst PDF output

![A Tufte inspired Quarto Manuscript format](/Images/tufte-inpired.png)

## Usage

See the example `index.qmd` file for detailed usage examples, including:
- Sidenotes and margin content
- Fullwidth content blocks
- Figure and table placement
- Bibliography formatting

## Customisation

The template supports customisation through:
- Language files (see `custom.yml` for Norwegian terms)
- Custom CSS for HTML output
- Typst template modifications

## A note on the font ET Book

This repository includes a folder with the webfont ET Book (`et-book`), which is used in the Tufte style. It was downloaded from [https://github.com/edwardtufte/et-book](https://github.com/edwardtufte/et-book), with the MIT license. A CSS file is included to load the font in the HTML output, with oldstyle figures activated.

## License

This template is provided under the same license as the original Tufte-inspired template. The ET Book font is licensed under the MIT license.