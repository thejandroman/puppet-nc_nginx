The solution uses some preexisting modules so as not to reinvent the
wheel:

* puppetlabs/stdlib
* puppetlabs/vcsrepo
* jfryman/nginx

All of these modules are considered best in class by the puppet
community.

The manifest, `manifests/init.pp`, is fairly
straightforward. Variables are used where a reasonable expectation of
customization can be expected. Sane defaults can be found in
`manifests/params.pp`. The use of the Package -> Config ~> Service
pattern was not used for this module as it would probably have been
overkill.

Two different types of tests are implemented:

* unit tests (rspec-puppet)
* integration tests (beaker)

Unit testing is done via Travis-CI. Integration tests must be run
locally at this time as they use vagrant/virtualbox. This can be
expanded/changed to allow for
[any backend that beaker supports](https://github.com/puppetlabs/beaker/wiki/Creating-A-Test-Environment#supported-virtualization-providers). To
learn more about how the tests work please see
[CONTRIBUTING.md](https://github.com/thejandroman/puppet-nc_nginx/blob/master/CONTRIBUTING.md).
