@description('The location for the resource(s) to be deployed.')
param location string = resourceGroup().location

@description('The objectId of the current user principal.')
param principalId string

resource project_identity 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' = {
  name: 'cm0c420d2f21084cd'
  location: location
}

resource cm_app_config 'Microsoft.AppConfiguration/configurationStores@2024-05-01' = {
  name: 'cm0c420d2f21084cd'
  location: location
  sku: {
    name: 'Free'
  }
}

resource cm_app_config_1_AppConfigurationDataOwner 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid('cm_app_config', 'cm0c420d2f21084cd', principalId, subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '5ae67dd6-50cb-40e7-96ff-dc2bfa4b606b'))
  properties: {
    principalId: principalId
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '5ae67dd6-50cb-40e7-96ff-dc2bfa4b606b')
    principalType: 'User'
  }
  scope: cm_app_config
}

resource cm_app_config_project_identity_AppConfigurationDataOwner 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid('cm_app_config', project_identity.id, subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '5ae67dd6-50cb-40e7-96ff-dc2bfa4b606b'))
  properties: {
    principalId: project_identity.properties.principalId
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '5ae67dd6-50cb-40e7-96ff-dc2bfa4b606b')
    principalType: 'ServicePrincipal'
  }
  scope: cm_app_config
}

resource openai 'Microsoft.CognitiveServices/accounts@2024-10-01' = {
  name: 'cm0c420d2f21084cd'
  location: location
  kind: 'OpenAI'
  properties: {
    customSubDomainName: 'cm0c420d2f21084cd'
    publicNetworkAccess: 'Enabled'
  }
  sku: {
    name: 'S0'
  }
}

resource openai_1_CognitiveServicesOpenAIContributor 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid('openai', 'cm0c420d2f21084cd', principalId, subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'a001fd3d-188f-4b5d-821b-7da978bf7442'))
  properties: {
    principalId: principalId
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'a001fd3d-188f-4b5d-821b-7da978bf7442')
    principalType: 'User'
  }
  scope: openai
}

resource openai_project_identity_CognitiveServicesOpenAIContributor 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid('openai', project_identity.id, subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'a001fd3d-188f-4b5d-821b-7da978bf7442'))
  properties: {
    principalId: project_identity.properties.principalId
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'a001fd3d-188f-4b5d-821b-7da978bf7442')
    principalType: 'ServicePrincipal'
  }
  scope: openai
}

resource openai_cm0c420d2f21084cd_chat 'Microsoft.CognitiveServices/accounts/deployments@2024-06-01-preview' = {
  name: 'cm0c420d2f21084cd_chat'
  properties: {
    model: {
      format: 'OpenAI'
      name: 'gpt-35-turbo'
      version: '0125'
    }
    raiPolicyName: 'Microsoft.DefaultV2'
    versionUpgradeOption: 'OnceNewDefaultVersionAvailable'
  }
  sku: {
    name: 'Standard'
    capacity: 10
  }
  parent: openai
}

resource openai_cm0c420d2f21084cd_embedding 'Microsoft.CognitiveServices/accounts/deployments@2024-06-01-preview' = {
  name: 'cm0c420d2f21084cd_embedding'
  properties: {
    model: {
      format: 'OpenAI'
      name: 'text-embedding-ada-002'
      version: '2'
    }
    raiPolicyName: 'Microsoft.DefaultV2'
    versionUpgradeOption: 'OnceNewDefaultVersionAvailable'
  }
  sku: {
    name: 'Standard'
    capacity: 10
  }
  parent: openai
  dependsOn: [
    openai_cm0c420d2f21084cd_chat
  ]
}

resource cm_connection_1 'Microsoft.AppConfiguration/configurationStores/keyValues@2024-05-01' = {
  name: 'Azure.AI.OpenAI.AzureOpenAIClient'
  properties: {
    value: 'https://cm0c420d2f21084cd.openai.azure.com'
  }
  parent: cm_app_config
}

resource cm_connection_2 'Microsoft.AppConfiguration/configurationStores/keyValues@2024-05-01' = {
  name: 'OpenAI.Chat.ChatClient'
  properties: {
    value: 'cm0c420d2f21084cd_chat'
  }
  parent: cm_app_config
}

resource cm_connection_3 'Microsoft.AppConfiguration/configurationStores/keyValues@2024-05-01' = {
  name: 'OpenAI.Embeddings.EmbeddingClient'
  properties: {
    value: 'cm0c420d2f21084cd_embedding'
  }
  parent: cm_app_config
}

output project_identity_id string = project_identity.id
