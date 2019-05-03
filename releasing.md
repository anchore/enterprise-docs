# Making a new versioned Release of Docs

Versioning Behavior:
* The `/current/*` routes always represent the current release of Anchore Enterprise.
* Previous releases' documentation are available by version prefix: e.g. /1.2/, or /1.1/.
* Any request for the current version prefix (e.g. /1.0/) in the site will redirect to /current/*, e.g /1.0/overview -> /current/overview. 

The master branch always builds and deploys as /current/ in the target s3 bucket.
The /version.json resource in the root of the site contains the version listing, updated with each deploy of master.
Semversioned branch names are also deployed to a `/<major>.<minor>/` site, if present.

To Deploying a new release of Anchore Enterprise's Docs:

Assuming current version is N (1.0):
1. Develop in dev branch for N + 1 (1.1) (in that branch update data/versions.toml to have this_version="1.1" (the N+1)
1. When ready to release N + 1 first do the following:
1. Create new branch, N, (e.g. `1.0`) from master *before* any merge of dev branch to master. CI will build and push to path `/1.0/`
1. At this point the deployed site has `/current/` and `/1.0/` with the same content.
1. Merge dev branch to master branch to versions.json and in `data/version.toml` the _this_version_ value is set to `1.1`. The CI build
deploys the new version to `/current/`. At this point the site now contains `/1.0/` and `/current/` where they have different content.
1. Manually push the updated _versions.json_ to the root path of the site (e.g. /versions.json) with the new value and current=true in that element.
1. Update any route rewrite rules to rewrite /1.1/* to /current/* as needed.

As general practice, previously released versions of the documentation are not updated, only master branch and the current version.

## Detail on version tracking:

* The branch name is used for setting the baseURL in the docs build, so it should match the _this_version_ value in data/versions.toml for non-master branches that are releases.
  * Dev branches should **not** be named with a release. **Semver named branches are for releases only.**
* data/versions.toml should have one value, and it should be the value that is the version (mapping to "current" is done elsewhere)
* versions.json is the global tracker of all released versions on the site and populates the version selector. This should be up-to-date in master branch.
* Deployment of versions.json is manual and done on release, but not by CI (yet)
* The build_site.sh and deploy.sh translate the branch name to the proper path prefix for site-gen, where master->'current'.
