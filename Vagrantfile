IMAGE_NAME = "nconnolly1/basebox"
N = 3

Vagrant.configure("2") do |config|
    config.ssh.insert_key = false

    config.vm.provider "hyperv" do |v|
        v.enable_virtualization_extensions = true
        v.linked_clone = true
        v.memory = 2048
        v.cpus = 2
    end

    config.vm.define "master" do |master|
        master.vm.provider "hyperv" do |v|
            v.mac = "00155D005210"
        end
        master.vm.box = IMAGE_NAME
        master.vm.network "private_network", ip: "192.168.50.10"
        master.vm.hostname = "master"
        master.vm.provision "ansible" do |ansible|
            ansible.playbook = "kubernetes-setup/master-playbook.yml"
            ansible.extra_vars = {
                node_ip: "192.168.50.10",
            }
        end
    end

    (1..N).each do |i|
        config.vm.define "node-#{i}" do |node|
            node.vm.provider "hyperv" do |v|
                v.mac = "00155D0052#{i + 10}"
                v.memory = 4096
                v.cpus = 4
            end
            node.vm.box = IMAGE_NAME
            node.vm.network "private_network", ip: "192.168.50.#{i + 10}"
            node.vm.hostname = "node-#{i}"
            node.vm.provision "ansible" do |ansible|
                ansible.playbook = "kubernetes-setup/node-playbook.yml"
                ansible.extra_vars = {
                    node_ip: "192.168.50.#{i + 10}",
                }
            end
        end
    end
end
