data "oci_identity_tenancy" "t" {
  tenancy_id = var.oci_tenancy_ocid
}

data "oci_identity_availability_domains" "ads" {
  compartment_id = coalesce(var.compartment_id, data.oci_identity_tenancy.t.id)
}

data "oci_core_images" "ubuntu" {
  compartment_id           = coalesce(var.compartment_id, data.oci_identity_tenancy.t.id)
  operating_system         = "Canonical Ubuntu"
  operating_system_version = "22.04"
  shape                    = "VM.Standard.E2.1.Micro"
  sort_by                  = "TIMECREATED"
  sort_order               = "DESC"
}
