# Changelog
### v0.2.1, 2020-07-28 (Maintenance release)
- Merged dependabot's security updates

### v0.2.0, 2019-11-16 (Feature release)
- Added the following specific tasks
  - cap {stage} systemd:{service}:upload to upload a single service file
  - cap {stage} systemd:{service}:remove to upload a single service file
- Added the following global tasks
  - cap {stage} systemd:enable to enable all services
  - cap {stage} systemd:disable to disable all services
  - cap {stage} systemd:remove to remove all services
- Moved both global and specific tasks into one file
- Pruned dependencies

### v0.1.1, 2019-10-26 (Maintenance release)
- Moved gem to new repository (https://github.com/gkosae/capistrano-simple_systemd.git)
- Added sample service file template to README

### v0.1.0, 2019-09-20 (Feature Release)
- Initial release