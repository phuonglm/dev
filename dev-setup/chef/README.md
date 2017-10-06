# teracy-dev-setup cookbook

Chef cookbooks are used to manage teracy-dev VM for the project.

You can use other software provisioning tools other than Chef, see: https://www.vagrantup.com/docs/provisioning/
`teracy-dev` supports all the configuration of vagrant supported provisioners into the
`vagrant_config_override.json` file, you can combine them for the dev-setup.


## dev-setup/chef/main-cookbooks/teracy-dev-setup cookbook

- This Chef project is used to manage the VM for the `teracy-dev` project.

- The `teracy-dev-setup` Chef project was initially generated by the following commands:

```
$ vagrant ssh
$ ws
$ cd dev/dev-setup/chef/
$ docker run --rm -it -v $(pwd):/opt/app -w /opt/app chef/chefdk bash
# mkdir main-cookbooks
# cd main-cookbooks
# chef generate cookbook teracy-dev-setup
```

You should see the similar following output:

```
Generating cookbook teracy-dev-setup
- Ensuring correct cookbook file content
- Ensuring delivery configuration
- Ensuring correct delivery build cookbook content

Your cookbook is ready. Type `cd teracy-dev-setup` to enter it.

There are several commands you can run to get started locally developing and testing your cookbook.
Type `delivery local --help` to see a full list.

Why not start by writing a test? Tests for the default recipe are stored at:

test/smoke/default/default_test.rb

If you'd prefer to dive right in, the default recipe can be found at:

recipes/default.rb

```

- After that, sync the generated files from the guest VM to the host machine:

```
$ # open a new terminal window
$ cd ~/teracy-dev
$ vagrant rsync-back
```

And you should see the generated files to the `dev/dev-setup/chef/main-cookbooks` directory.

See more: https://github.com/chef/chef-dk


## dev-setup/chef/berks-cookbooks


This is the auto genereated cookbooks with dependencies from
the `dev/dev-setup/chef/main-cookbooks/teracy-dev-setup` cookbook.


`dev/dev-setup/chef/berks-cookbooks` is generated with:

```
$ vagrant ssh
$ ws
$ cd dev/dev-setup/chef
$ docker-compose up
```

and then `$ vagrant rsync-back` from the host terminal to sync generated files back to the host.


## Configuring the teracy cookbook to be used with `teracy-dev`

The following sample configuration is used to configure the Chef provisioner of Vagrant
for the `vagrant_config_default.json` file:

```
{
  "provisioners": [{
    "_id": "0",
    "_ua_cookbooks_path": [
      // "workspace/dev/dev-setup/chef/berks-cookbookss",
      "workspace/dev/dev-setup/chef/main-cookbooks"
    ],
    "_ua_run_list": [
      "teracy-dev-setup"
    ]
  }]
}
```