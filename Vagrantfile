# -*- mode: ruby -*-
# vi: set ft=ruby :

nodes = [
  { :hostname => 'swarm-master-1', :ip => '10.0.0.11', :ram => 1024, :cpus => 1 },
  { :hostname => 'swarm-master-2', :ip => '10.0.0.12', :ram => 1024, :cpus => 1 },
  { :hostname => 'swarm-master-3', :ip => '10.0.0.13', :ram => 1024, :cpus => 1 },
  { :hostname => 'swarm-worker-4', :ip => '10.0.0.24', :ram => 2048, :cpus => 2 }
]

Vagrant.configure("2") do |config|
  config.ssh.insert_key = false
  config.ssh.forward_agent = true
  nodes.each do |node|
    config.vm.define node[:hostname] do |nodeconfig|
      nodeconfig.vm.box = "qa_epam/debian10"
      nodeconfig.vm.box_version = "0.0.1"
      nodeconfig.vm.hostname = node[:hostname] + ".box"
      nodeconfig.vm.network :private_network, ip: node[:ip]
      if node[:hostname].include? "master"
        nodeconfig.vm.network :forwarded_port, guest: 8080, host: 8080, host_ip: '127.0.0.' + node[:ip][-1]
        nodeconfig.vm.network :forwarded_port, guest: 80, host: 80, host_ip: '127.0.0.' + node[:ip][-1]
      end
      nodeconfig.vm.synced_folder "./host_system", "/data", type: "nfs", create: true, group: "vagrant", owner: "vagrant", :mount_options => ["dmode=775","fmode=666"]
      nodeconfig.vm.provision :shell, privileged: false do |s|
      s.inline = <<-SHELL
          sudo sed -i 's/.*PasswordAuthentication.*/PasswordAuthentication yes/g' /etc/ssh/sshd_config
          sudo systemctl restart sshd
        SHELL
      end
      nodeconfig.vm.provider :virtualbox do |vb|
	vb.memory = node[:ram]
        vb.cpus = node[:cpus]
      end
      nodeconfig.vm.post_up_message = "VM: %s is ready with address: %s" % [node[:hostname], node[:ip]]
    end
  end
  config.vm.define "swarm-worker-4" do |ansible|
    ansible.vm.provision "shell", path: "start_configuration.sh"
  end
end
