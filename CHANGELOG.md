# Changelog

Note sha256 digests are generated after pushing the image to the registry therefore the last version of this docker-selenium will always have digest TBD (to be determined) but will be updated manually at [releases][]

Note image ids also change after scm-source.json has being updated which triggers a cyclic problem so value TBD will be set here and updated in the [release][] page by navigating into any release tag.

###### To get container versions
    docker exec ruby versions

## 2.3.1a
 + Date: 2016-06-09
 + Small TravisCI fixes
 + Image tag details:
  + Timezone: Europe/Berlin
  + FROM ubuntu:xenial-20160525
  + Ruby: 2.3.1p112
  + Tested on kernel dev host: 4.4.0-23-generic x86_64
  + Tested on kernel CI  host: 3.19.0-30-generic x86_64
  + Built at dev host with: Docker version 1.11.2, build b9f10c9
  + Built at CI  host with: Docker version 1.11.2, build b9f10c9
  + Image size: TBD_IMAGE_SIZE
  + Digest: sha256:819932c1f9fd7f9737f1903511da6b7c66fb2604993d497b56ee327c4a0c43c0
  + Image ID: sha256:c9a91af64bf853e6fdf2f16dc965418965a34125729508cab673ccf372ee2125


[releases]: https://github.com/elgalu/docker-ruby/releases/
