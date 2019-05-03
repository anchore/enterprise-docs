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

Documentation Versioning implementation:

Behavior:
* The /current/* routes always represent the current release of Anchore Enterprise.
* Previous releases' documentation are available by version prefix: e.g. /1.2/, or /1.1/.
* Any request for the current version prefix (e.g. /2.0/) in the site will redirect to /current/*, e.g /2.0/overview -> /current/overview. 

The master branch always builds and deploys as /current/ in the target s3 bucket.
The /version.json resource in the root of the site contains the version listing, updated with each deploy of master.
Semversioned branch names are also deployed to a `/<major>.<minor>/` site, if present.

Deploying new release of Anchore Enterprise's Docs:
1. Upon pending release of a new version of Anchore Enterprise, version N, then a branch is created for
the previous version prior to bumping the version in master, N - 1, and the CI build will deploy it to `/<version n-1>/`
1. At this point the deployed site has `/current/` and `/<version n-1>/` with the same content.
1. Master branch is updated with version N added to versions.json and the CI build
deploys the new version to `/current/`. At this point the site now contains `/<n-1>/` and `/current/` where they have different content.

As general practice, previously released versions of the documentation are not updated, only master branch and the current version.



