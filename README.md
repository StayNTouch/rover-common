# StayNTouch

## Local Development
In order to make changes on this gem and use it within another project you will need to do a few things to get started.

1. Checkout the github repo

2. Do a configure bundler to use a local git repo instead of the remote version

        bundle config local.snt /path/to/local/git/repository

3. Disable local branch checking in Bundler in order to provide updates to any local apps.

    **Note**: This will require you to manually check you pushed any committed changes to remote, otherwise other
apps will be pointing to a commit only existing in your local machine.
