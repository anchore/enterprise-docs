# Enterprise Documentation

This is the repository for the Anchore Enterprise Documentation site.

Contributing: See Contributing

Filing Bugs/Issues: See Issues

Making Changes/Contribution:

1. Fork the repository

1. Install [hugo-extended](https://github.com/gohugoio/hugo/releases/), this is necessary because the docsy theme uses some scss functionality only in the extended version.

1. Install 'postcss-cli' and 'autoprefixer' using npm:
`npm install`

1. Clone the forked repo locally, with submodules to ensure the theme is available:
 `git clone --recurse-submodules https://github.com/<your_repo>`
 
1. Run hugo for local debugging/dev:
`cd enterprise-docs ; hugo server`

1. Make changes

1. Commit and push

1. Open PR to github.com/anchore/enterprise-docs for merge to master




