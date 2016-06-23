# BitswarmBox - Packer Convenience Wrapper for building Bitswarm.io

[Packer](http://packer.io) templates for provisioning host operating system environments for the
[Bitswarm](http://bitswarm.io) ecosystem.

## Packer Templates:

Before building any of these templates, you will need to ensure you have suitable `AWS_ACCESS_KEY_ID` and
`AWS_SECRET_ACCESS_KEY` environment variables available.
### bitswarm-base

Creates image suitable for general purpose usage, including Puppet 4 pre-configured against puppet master server.
### bitswarm-puppetmaster

A puppet master server, preloaded with Puppet 4, PuppetDB 4, Facter, Hiera, and mCollective.

If the Packer configuration variables `puppet_scm_repo` and `github_webhook_api_token` are set in Packer, this
repo will be preconfigured for use via r10k.

When this template is built, `scripts/local-ssh-key.sh` is invoked which will create an RSA keypair locally within keys/
and this will be preloaded into the resulting AMIs.

## Pre-requisites

- AWS api key and secret for user with sufficient permissions
- Github API token for user with "owner" role of repos to be used as r10k sources.  Owner is necessary for the
ability to interact with the Github API on the repos to install deployment keys.

## Installation & Requirements

```shell
[sudo] gem install bitswarmbox
```

bitswarmbox leans on [Packer][] and [VirtualBox][], [VMware Fusion][fusion] or
[VMware Workstation][workstation] for building boxes and these will need to
available in your `$PATH`.

## Example Usage

bitswarmbox is driven by the `bitswarmbox` command line tool, and works with artifacts
inside it's own working directory. You need to specify a name for the build,
a template to work with and the output provider. Something like so:

```shell
bitswarmbox build \
  --name=trusty64-empty \
  --template=ubuntu/trusty64 \
  --provider=vmware
```

This will build a file called `trusty64-empty.box` in the current directory.

There's lots more to `bitswarmbox` than building simple empty Vagrant boxes like
this, which can be see in the inline help.

## Acknowledgements

Many thanks to the upstream sources from which this derives, most notably
[Nick Charlton's Boxes.io](https://github.com/nickcharlton/boxes).

## Disclaimer

No warranties given, expressed or implied.  Use with parental supervision.

## For more information
http://bitswarm.io/
