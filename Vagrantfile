# -*- mode: ruby -*-
# vi: set ft=ruby :

# Uncomment these lines (and the ones in the generated Gemfile) if you want
# to live on the Edge:
#
# Vagrant.require_plugin "vagrant-berkshelf"
# Vagrant.require_plugin "vagrant-omnibus"

Vagrant.configure("2") do |config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.

  config.vm.hostname = "rage4dns-berkshelf"

  # Set the version of chef to install using the vagrant-omnibus plugin
  config.omnibus.chef_version = :latest

  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "opscode_ubuntu-12.04_provisionerless"

  # The url from where the 'config.vm.box' box will be fetched if it
  # doesn't already exist on the user's system.
  config.vm.box_url = "https://opscode-vm-bento.s3.amazonaws.com/vagrant/opscode_ubuntu-12.04_provisionerless.box"

  # Assign this VM to a host-only network IP, allowing you to access it
  # via the IP. Host-only networks can talk to the host machine as well as
  # any other machines on the same network, but cannot be accessed (through this
  # network interface) by any external networks.
  config.vm.network :private_network, ip: "172.30.0.10"

  config.vm.provider :virtualbox do |vb|
     # Use VBoxManage to customize the VM. For example to change memory:
     vb.customize ["modifyvm", :id, "--memory", "256"]
  end

  # Enabling the Berkshelf plugin. To enable this globally, add this configuration
  # option to your ~/.vagrant.d/Vagrantfile file
  config.berkshelf.enabled = true


  config.vm.provision :chef_solo do |chef|
    chef.encrypted_data_bag_secret_key_path = '~/.chef/encrypted_data_bag_secret'
    chef.data_bags_path = "data_bags"
    chef.json = {
      "dev_vagrant" => true,
      "dev_mode" => true,
      "ng-base" => {
        :sudo => {
          :exempt_group => 'vagrant'
        },
        :management_subnets => {
          :ssh => {
            "dev" => '172.30.0.0/24'
          }
        },
        :logging => {
            :server_ip => '172.30.0.12'
        }
      }
    }

    chef.run_list = [
    ]
  end
end
