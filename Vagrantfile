# -*- mode: ruby -*-
# vi: set ft=ruby :

nodes = [
  { :hostname => 'swarm-master-1', :ip => '10.0.0.11', :ram => 1024, :cpus => 1 },
  { :hostname => 'swarm-master-2', :ip => '10.0.0.12', :ram => 1024, :cpus => 1 },
  { :hostname => 'swarm-worker-1', :ip => '10.0.0.21', :ram => 1024, :cpus => 1 },
  { :hostname => 'swarm-worker-2', :ip => '10.0.0.22', :ram => 1024, :cpus => 1 },
  { :hostname => 'swarm-worker-3', :ip => '10.0.0.23', :ram => 1024, :cpus => 1 }
]

Vagrant.configure("2") do |config|
  config.ssh.insert_key = false
  config.ssh.forward_agent = true
  nodes.each do |node|
    config.vm.define node[:hostname] do |nodeconfig|
      nodeconfig.vm.box = "debian/buster64"
      nodeconfig.vm.hostname = node[:hostname] + ".box"
      nodeconfig.vm.network :private_network, ip: node[:ip]
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
  config.vm.define "swarm-worker-3" do |ansible|
    ansible.vm.provision "file", source: ".", destination: "$HOME"
    ansible.vm.provision "shell", path: "ansible.sh"
  end
end