# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  require 'json'
  load File.dirname(__FILE__) + '/lib/utility.rb'

  # Load default setting
  file = File.read(File.dirname(__FILE__) + '/vagrant_config.json')
  data_hash = JSON.parse(file)

  # Check and override if exist any match JSON object from vagrant_config_override.json
  if File.exist? (File.dirname(__FILE__) + '/vagrant_config_override.json')
    override_file = File.read(File.dirname(__FILE__) + '/vagrant_config_override.json')

    begin
      data_hash = overrides(data_hash, JSON.parse(override_file))
    rescue Exception => msg
      puts red(msg)
      puts red('from vagrant_config_override.json')
      ans = prompt yellow("You have occured some errors and this file will not be used, do you want to continue? [y/n]: ")
      if ans.downcase != 'y'
        exit!
      end
    end

  end

  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.

  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = data_hash["vm_box"]

  # The url from where the 'config.vm.box' box will be fetched if it
  # doesn't already exist on the user's system.
  config.vm.box_url = data_hash['vm_box_url']

  # Other configs: https://docs.vagrantup.com/v2/vagrantfile/machine_settings.html

  if !data_hash["vm_box_version"].nil? and !data_hash["vm_box_version"].strip().empty?
    config.vm.box_version = data_hash['vm_box_version']
  end

  if !data_hash["vm_boot_timeout"].nil?
    config.vm.boot_timeout = data_hash['vm_boot_timeout']
  end

  if !data_hash["vm_box_check_update"].nil?
    config.vm.box_check_update = data_hash['vm_box_check_update']
  end

  if !data_hash["vm_box_download_checksum"].nil? and !data_hash["vm_box_download_checksum"].strip().empty?
    config.vm.box_download_checksum = data_hash['vm_box_download_checksum']

    # box_download_checksum_type must be specified if box_download_checksum is specified
    config.vm.box_download_checksum_type = data_hash['vm_box_download_checksum_type']
  end

  if !data_hash["vm_box_download_client_cert"].nil? and !data_hash["vm_box_download_client_cert"].strip().empty?
    config.vm.box_download_client_cert = data_hash['vm_box_download_client_cert']
  end

  if !data_hash["vm_box_download_ca_cert"].nil? and !data_hash["vm_box_download_ca_cert"].strip().empty?
    config.vm.box_download_ca_cert = data_hash['vm_box_download_ca_cert']
  end

  if !data_hash["vm_box_download_ca_path"].nil? and !data_hash["vm_box_download_ca_path"].strip().empty?
    config.vm.box_download_ca_path = data_hash['vm_box_download_ca_path']
  end

  if !data_hash["vm_box_download_insecure"].nil?
    config.vm.box_download_insecure = data_hash['vm_box_download_insecure']
  end

  if !data_hash["vm_communicator"].nil? and !data_hash["vm_communicator"].strip().empty?
    config.vm.communicator = :data_hash['vm_communicator']
  end

  if !data_hash["vm_graceful_halt_timeout"].nil?
    config.vm.graceful_halt_timeout = data_hash['vm_graceful_halt_timeout']
  end

  if !data_hash["vm_guest"].nil? and !data_hash["vm_guest"].strip().empty?
    config.vm.guest = :data_hash['vm_guest']
  end

  if !data_hash["vm_guest"].nil? and !data_hash["vm_hostname"].strip().empty?
    config.vm.hostname = data_hash['vm_hostname']
  end

  if !data_hash["vm_post_up_message"].nil? and !data_hash["vm_post_up_message"].strip().empty?
    config.vm.post_up_message = data_hash['vm_post_up_message']
  end

  if !data_hash["vm_usable_port_range"].nil? and !data_hash["vm_usable_port_range"].strip().empty?
    ranges = data_hash['vm_usable_port_range'].split('..').map{|d| Integer(d)}
    config.vm.usable_port_range = ranges[0]..ranges[1]
  end

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  vm_network = data_hash['vm_network']

  if vm_network['mode'] == 'forwarded_port'
    vm_network['forwarded_ports'].each do |item|
      config.vm.network :forwarded_port, guest: item["guest"], host: item["host"]
    end
  elsif vm_network['mode'] == 'private_network'
    ip = vm_network['ip']
    type = vm_network['type']
    if !ip.nil? and !ip.strip().empty?
      auto_config = !(vm_network['auto_config'] == false)
      config.vm.network :private_network, ip: ip.strip(), auto_config: auto_config
    elsif !type.nil? and type.strip() == 'dhcp'
      config.vm.network :private_network, type: 'dhcp'
    else
      puts red('ip or type (dhcp) required for private_network mode')
    end
  elsif vm_network['mode'] == 'public_network'
    ip = vm_network['ip']
    bridge = vm_network['bridge']

    if !bridge.nil? and !bridge.strip().empty?
      if !ip.nil? and !ip.strip().empty?
        config.vm.network :public_network, ip: ip.strip(), bridge: bridge
      else
        config.vm.network :public_network, bridge: bridge
      end
    else
      if !ip.nil? and !ip.strip().empty?
        config.vm.network :public_network, ip: ip.strip()
      else
        config.vm.network :public_network
      end
    end
  end

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network :private_network, ip: "192.168.33.10"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network :public_network

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"

  data_hash['vm_synced_folders'].each do |x|

    hostOS = Vagrant::Util::Platform.platform
    hostOSType = ''

    case hostOS
    when /^(mswin|mingw).*/
      hostOSType = 'windows'
    when /^(linux|cygwin).*/
      hostOSType = 'linux'
    when /^(mac|darwin).*/
      hostOSType = 'mac'
    end

    if x["supports"].nil?
      if x["mount_options"].nil?
        config.vm.synced_folder x["host"], x["guest"]
      else
        config.vm.synced_folder x["host"], x["guest"], :mount_options => x["mount_options"]
      end
    else
      if x["supports"].include?(hostOSType)
        if x["mount_options"].nil?
          config.vm.synced_folder x["host"], x["guest"]
        else
          config.vm.synced_folder x["host"], x["guest"], :mount_options => x["mount_options"]
        end
      end
    end

  end

  # ssh configuration
  config.ssh.forward_agent = data_hash['vm_forward_agent']

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  # View the documentation for the provider you're using for more
  # information on available options.
  config.vm.provider :virtualbox do |vb|

    vb_hash = data_hash['vb']

    # Don't boot with headless mode
    if vb_hash['gui']  == true
      vb.gui = true
    end

    # general settings for modifyvm: https://www.virtualbox.org/manual/ch08.html#vboxmanage-modifyvm
    # TODO(hoatle): add support for key<1-N> type
    # TODO(hoatle): add support for other settings

    # FIXME(hoatle): there were 3 loops here, why?
    # puts vb_hash

    general_settings_keys = ['name', 'groups', 'description', 'ostype', 'memory', 'vram', 'acpi',
      'ioapic', 'hardwareuuid', 'cpus', 'rtcuseutc', 'cpuhotplug', 'plugcpu', 'unplugcpu',
      'cpuexecutioncap', 'pae', 'longmode', 'synthcpu', 'hpet', 'hwvirtex', 'triplefaultreset',
      'nestedpaging', 'largepages', 'vtxvpid', 'vtxux', 'accelerate3d', 'bioslogofadein',
      'bioslogodisplaytime', 'bioslogoimagepath', 'biosbootmenu', 'snapshotfolder', 'firmware',
      'guestmemoryballoon', 'defaultfrontend'
    ]

    vb_hash.each do |key, val|
      if general_settings_keys.include?(key) and !vb_hash[key].nil?
        val = val.to_s.strip()
        if !val.empty?
          vb.customize ["modifyvm", :id, "--" + key, val]
        end
      end
    end

  end

  # Enable provisioning with chef solo, specifying a cookbooks path, roles
  # path, and data_bags path (all relative to this Vagrantfile), and adding
  # some recipes and/or roles.
  #
  config.vm.provision :chef_solo do |chef|
    chef.log_level = data_hash['chef_log_level']
    chef.cookbooks_path = data_hash['chef_cookbooks']
    chef.roles_path = data_hash['chef_role']
    chef.data_bags_path = data_hash['chef_bags_path']

    data_hash['chef_recipes'].each do |x|
      chef.add_recipe x
    end
  # custom JSON attributes for chef-solo, see more at http://docs.vagrantup.com/v2/provisioning/chef_solo.html
    chef.json = data_hash['chef_json']
  end
  # Enable provisioning with chef server, specifying the chef server URL,
  # and the path to the validation key (relative to this Vagrantfile).
  #
  # The Opscode Platform uses HTTPS. Substitute your organization for
  # ORGNAME in the URL and validation key.
  #
  # If you have your own Chef Server, use the appropriate URL, which may be
  # HTTP instead of HTTPS depending on your configuration. Also change the
  # validation key to validation.pem.
  #
  # config.vm.provision :chef_client do |chef|
  #   chef.chef_server_url = ENV['KNIFE_CHEF_SERVER']
  #   chef.validation_key_path = "#{ENV['KNIFE_VALIDATION_KEY_FOLDER']}/#{ENV['OPSCODE_ORGNAME']}-validator.pem"
  #   chef.validation_client_name = "#{ENV['OPSCODE_ORGNAME']}-validator"
  #   chef.node_name = "#{ENV['OPSCODE_USER']}-vagrant"
  #   chef.run_list = [
  #     'motd',
  #     'minitest-handler'
  #   ]
  # end
  #
  # If you're using the Opscode platform, your validator client is
  # ORGNAME-validator, replacing ORGNAME with your organization name.
  #
  # If you have your own Chef Server, the default validation client name is
  # chef-validator, unless you changed the configuration.
  #
  #   chef.validation_client_name = "ORGNAME-validator"


end
