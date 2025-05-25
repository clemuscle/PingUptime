resource "oci_core_virtual_network" "vcn" {
  compartment_id = coalesce(var.compartment_id, data.oci_identity_tenancy.t.id)
  cidr_block     = var.vcn_cidr
  display_name   = "PingUpTime-VCN"
}

resource "oci_core_internet_gateway" "ig" {
  compartment_id = coalesce(var.compartment_id, data.oci_identity_tenancy.t.id)
  vcn_id         = oci_core_virtual_network.vcn.id
  display_name   = "PingUpTime-IGW"
  enabled        = true
}

resource "oci_core_route_table" "rt" {
  compartment_id = coalesce(var.compartment_id, data.oci_identity_tenancy.t.id)
  vcn_id         = oci_core_virtual_network.vcn.id
  display_name   = "PingUpTime-RT"

  # on utilise un bloc route_rules plutôt qu’un attribut list
  route_rules {
    destination       = "0.0.0.0/0"
    network_entity_id = oci_core_internet_gateway.ig.id
  }
}

resource "oci_core_security_list" "sl" {
  compartment_id = coalesce(var.compartment_id, data.oci_identity_tenancy.t.id)
  vcn_id         = oci_core_virtual_network.vcn.id
  display_name   = "PingUpTime-SL"

  # ingress via bloc
  ingress_security_rules {
    protocol = "6" # TCP
    source   = "0.0.0.0/0"

    tcp_options { # bloc imbriqué pour les ports
      min = 22
      max = 22
    }
  }

  # on ajoute le HTTP sur le port 5000
  ingress_security_rules {
    protocol = "6"
    source   = "0.0.0.0/0"
    tcp_options {
      min = 5000
      max = 5000
    }
  }

  # egress via bloc
  egress_security_rules {
    protocol    = "all"
    destination = "0.0.0.0/0"
  }
}

resource "oci_core_subnet" "subnet" {
  compartment_id             = coalesce(var.compartment_id, data.oci_identity_tenancy.t.id)
  vcn_id                     = oci_core_virtual_network.vcn.id
  cidr_block                 = var.subnet_cidr
  display_name               = "PingUpTime-Subnet"
  availability_domain        = data.oci_identity_availability_domains.ads.availability_domains[0].name
  route_table_id             = oci_core_route_table.rt.id
  security_list_ids          = [oci_core_security_list.sl.id]
  prohibit_public_ip_on_vnic = false
}
