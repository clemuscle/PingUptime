resource "oci_core_instance" "vm" {
  compartment_id      = coalesce(var.compartment_id, data.oci_identity_tenancy.t.id)
  availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
  shape               = "VM.Standard.E2.1.Micro"
  display_name        = "PingUpTime-VM"

  source_details {
    source_type = "image"
    source_id   = data.oci_core_images.ubuntu.images[0].id
  }

  create_vnic_details {
    subnet_id        = oci_core_subnet.subnet.id
    assign_public_ip = true
    display_name     = "PingUpTime-VNIC"
  }

  metadata = {
    ssh_authorized_keys = tls_private_key.ssh_key.public_key_openssh
    user_data = base64encode(<<-EOF
      #!/bin/bash
      apt-get update -y
      apt-get install -y docker.io
      usermod -aG docker ubuntu
      systemctl enable docker
      systemctl start docker
    EOF
    )
  }
}
