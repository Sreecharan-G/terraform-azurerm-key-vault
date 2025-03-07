module "key-vault" {
  source  = "kumarvna/key-vault/azurerm"
  version = "2.1.0"

  # Resource Group and Key Vault pricing tier details
  resource_group_name        = "rg-shared-westeurope-01"
  key_vault_name             = "demo-project-shard"
  key_vault_sku_pricing_tier = "premium"

  # Once `Purge Protection` has been Enabled it's not possible to Disable it
  # Deleting the Key Vault with `Purge Protection` enabled will schedule the Key Vault to be deleted 
  # The default retention period is 90 days, possible values are from 7 to 90 days
  # use `soft_delete_retention_days` to set the retention period
  enable_purge_protection = false

  # Adding Key vault logs to Azure monitoring and Log Analytics space
  # to enable key-vault logs, either one of log_analytics_workspace_id or storage_account_id required
  log_analytics_workspace_id = var.log_analytics_workspace_id
  storage_account_id         = var.storage_account_id

  # Access policies for users, you can provide list of Azure AD users and set permissions.
  # Make sure to use list of user principal names of Azure AD users.
  access_policies = [
    {
      azure_ad_user_principal_names = ["user1@example.com", "user2@example.com"]
      key_permissions               = ["get", "list"]
      secret_permissions            = ["get", "list"]
      certificate_permissions       = ["get", "import", "list"]
      storage_permissions           = ["backup", "get", "list", "recover"]
    },

  /* # Access policies for AD Groups, enable this feature to provide list of Azure AD groups and set permissions.
    {
      azure_ad_group_names = ["ADGroupName1", "ADGroupName2"]
      secret_permissions   = ["get", "list", "set"]
    },
    */
  ]

  # Create a required Secrets as per your need.
  # When you Add `usernames` with empty password this module creates a strong random password 
  # use .tfvars file to manage the secrets as variables to avoid security issues. 
  secrets = {
    "message" = "Hello, world!"
    "vmpass"  = ""
  }

  # Adding TAG's to your Azure resources (Required)
  # ProjectName and Env are already declared above, to use them here or create a varible. 
  tags = {
    ProjectName  = "demo-project"
    Env          = "dev"
    Owner        = "user@example.com"
    BusinessUnit = "CORP"
    ServiceClass = "Gold"
  }
}
