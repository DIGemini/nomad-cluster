data "azurerm_subscription" "primary" {}

data "azurerm_client_config" "cluster" {}

resource "azurerm_role_definition" "cluster" {
  role_definition_id = "f5762282-42b9-4d0c-b597-0f7a8c95da49"
  name               = "read-all"
  scope              = "${data.azurerm_subscription.primary.id}"

  permissions {
      # Read resources of all types, except secrets.
    actions     = ["*/read"]
    not_actions = []
  }

  assignable_scopes = [
    "${data.azurerm_subscription.primary.id}",
  ]
}

resource "azurerm_role_assignment" "cluster" {
  #name               = "00000000-0000-0000-0000-000000000000"  # will be generated
  scope              = "${data.azurerm_subscription.primary.id}"
  role_definition_id = "${azurerm_role_definition.cluster.id}"
  principal_id       = "${data.azurerm_client_config.cluster.service_principal_object_id}"
}