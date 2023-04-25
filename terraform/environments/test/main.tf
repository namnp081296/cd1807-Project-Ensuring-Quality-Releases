provider "azurerm" {
  tenant_id       = "${var.tenant_id}"
  subscription_id = "${var.subscription_id}"
  client_id       = "${var.client_id}"
  client_secret   = "${var.client_secret}"
  features {}
}
terraform {
  backend "azurerm" {
    storage_account_name = "tfstate7441142"
    container_name       = "tfstate"
    key                  = "test.terraform.tfstate"
    access_key           = "T+jxzkHVZNX7LpBEec46WOVXw/d5+Cy16aFTGHmFYymfGZ19ro5OHTnu5ME6V3dd0dUF3iQSbLh3+AStNluhnw=="
  }
}
# module "resource_group" {
#   source               = "../../modules/resource_group"
#   resource_group       = "${var.resource_group}"
#   location             = "${var.location}"
# }
module "network" {
  source               = "../../modules/network"
  address_space        = "${var.address_space}"
  location             = "${var.location}"
  virtual_network_name = "${var.virtual_network_name}"
  application_type     = "${var.application_type}"
  resource_type        = "NET"
  resource_group       = "${var.resource_group}"
  address_prefix_test  = "${var.address_prefix_test}"
}

module "nsg-test" {
  source           = "../../modules/networksecuritygroup"
  location         = "${var.location}"
  application_type = "${var.application_type}"
  resource_type    = "NSG"
  resource_group   = "${var.resource_group}"
  subnet_id        = "${module.network.subnet_id_test}"
  address_prefix_test = "${var.address_prefix_test}"
}
module "appservice" {
  source           = "../../modules/appservice"
  location         = "${var.location}"
  application_type = "${var.application_type}"
  resource_type    = "AppService"
  resource_group   = "${var.resource_group}"
}
module "publicip" {
  source           = "../../modules/publicip"
  location         = "${var.location}"
  application_type = "${var.application_type}"
  resource_type    = "publicip"
  resource_group   = "${var.resource_group}"
}
# Add VM module
module "vm" {
  source                    = "../../modules/vm"
  location                  = "${var.location}"
  application_type          = "${var.application_type}"
  resource_group            = "${var.resource_group}"
  public_ip_address_id      = "${module.publicip.public_ip_address_id}"
  subnet_id                 = "${module.network.subnet_id_test}"
}