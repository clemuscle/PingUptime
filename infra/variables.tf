variable "region" {
  description = "Région OCI"
  type        = string
  default     = "eu-marseille-1"
}

variable "compartment_id" {
  description = "OCID du compartment (root tenancy par défaut)"
  type        = string
  default     = "" # laisser vide pour utiliser le root tenancy
}

variable "vcn_cidr" {
  description = "CIDR block du VCN"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_cidr" {
  description = "CIDR block du subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "ssh_key_filename" {
  description = "Nom du fichier de la clé privée SSH générée"
  type        = string
  default     = "id_rsa_pinguptime"
}

variable "oci_tenancy_ocid" {
  description = "OCID de la tenancy OCI"
  type        = string
}

variable "oci_user_ocid" {
  description = "OCID de l'utilisateur OCI"
  type        = string
}

variable "oci_fingerprint" {
  description = "Empreinte de la clé publique configurée dans OCI"
  type        = string
}

variable "oci_private_key_path" {
  description = "Chemin vers votre clé privée OCI (PEM)"
  type        = string
}