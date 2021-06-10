terraform {
  required_providers {
    vagrant = {
      source  = "bmatcuk/vagrant"
      version = "~> 4.0.0"
    }
    hyperv = {
      source = "taliesins/hyperv"
      version = "1.0.3"
    }
  }
}

provider "vagrant" {
  # no config
}

provider "hyperv" {
  user = "Nick"  
  # Configuration options
}

resource "vagrant_vm" "win_vm" {
  env = {
    # force terraform to re-run vagrant if the Vagrantfile changes
    VAGRANTFILE_HASH = md5(file("../win/Vagrantfile")),
  }
  # get_ports = false
  vagrantfile_dir = "../win"

  # see schema for additional options
}