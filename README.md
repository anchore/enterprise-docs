# Enterprise Documentation

This is the repository for the Anchore Enterprise Documentation

Contributing: See Contributing

Filing Bugs/Issues: See Issues

To run/edit locally:

1. Install [hugo-extended](https://github.com/gohugoio/hugo/releases/), this is necessary because the docsy theme uses some scss functionality only in the extended version.

1. Install 'postcss-cli' and 'autoprefixer' using npm:
`npm install -D postcss-cli autoprefixer`

1. Clone this repo locally:
 `git clone --recurse-submodules --depth 1 https://github.com/anchore/enterprise-docs`
 
1. Run hugo
`cd enterprise-docs ; hugo server`


