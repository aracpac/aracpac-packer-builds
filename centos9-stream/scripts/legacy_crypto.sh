#!/bin/sh -eux
# forked from https://github.com/chef/bento

# set legacy crypto policies so we can install Mongo
update-crypto-policies --set LEGACY
