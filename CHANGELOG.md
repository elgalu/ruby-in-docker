# Changelog

Note sha256 digests are generated after pushing the image to the registry therefore the last version of this docker-selenium will always have digest TBD (to be determined) but will be updated manually at [releases][]

Note image ids also change after scm-source.json has being updated which triggers a cyclic problem so value TBD will be set here and updated in the [releases][] page by navigating into any release tag.

###### To get container versions
    docker exec ruby versions

## 2.3.1a
 + Date: 2016-06-09
 + TravisCI fixes
 + Image tag details:
  + Timezone: Europe/Berlin
  + FROM ubuntu:xenial-20160525
  + Ruby: 2.3.1p112
  + Tested on kernel dev host: 4.4.0-23-generic x86_64
  + Tested on kernel CI  host: 3.19.0-30-generic x86_64
  + Built at dev host with: Docker version 1.11.2, build b9f10c9
  + Built at CI  host with: Docker version 1.11.2, build b9f10c9
  + Image size: 862.6 MB
  + Digest: sha256:8c35430adc04bb8e809a1b0bcb807c404e6d0c4ca5eea43624ec2a85e8aa2397
  + Image ID: sha256:0ec09d4144926c576f4668e67b3b5f5dd38e98a4f350275e85ca2efcfc4c2cec


[releases]: https://github.com/elgalu/docker-ruby/releases/
