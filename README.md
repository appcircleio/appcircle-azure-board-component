# Appcircle _Azure Board_ component

Add comment to Azure Board Issue and optionally change the status.

## Required Inputs

- `AC_AZUREBOARD_INSTANCE`: Instance. If you're using a self-hosted instance, write the instance URL.
- `AC_AZUREBOARD_API_VERSION`: API Version. The version of the Azure DevOps Services REST API
- `AC_AZUREBOARD_EMAIL`: Email. Email of Azure user. Please add this using **locked** environment variables.
- `AC_AZUREBOARD_TOKEN`: Personal Access Token. Personal access token of the user. It can be created by visiting User settings. Please add this using **locked** environment variables.
- `AC_AZUREBOARD_ORG`: Organization. Azure Organization. The organization can be identified by its URL, such as for the `https://dev.azure.com/JohnDoe/MyProject/_boards/board/t/MyTeam/Issues` **JohnDoe** is the organization name.
- `AC_AZUREBOARD_PROJECT`: Project. Azure Project. The project can be identified by its URL, such as for the `https://dev.azure.com/JohnDoe/MyProject/_boards/board/t/MyTeam/Issues` **MyProject** is the project name.
- `AC_AZUREBOARD_WORKITEM`: The work item ID. Azure work item ID. The work item ID(integer) is shown next to the issue.
- `AC_AZUREBOARD_TEMPLATE`: Comment Template. This comment template will be used to post a comment. Variables donated with `$` will be replaced during the build. Please check [this document](https://learn.microsoft.com/en-us/rest/api/azure/devops/wit/work-items/update?view=azure-devops-rest-7.0) to learn more about possible updates.

## Optional Inputs

- `AC_AZUREBOARD_FAIL_STATE`: Fail State. The state name for the failed step. If the previous state fails, you can optionally change the state of your issue.
- `AC_AZUREBOARD_SUCCESS_STATE`: Success State. The state name for the successful step. If the previous state succeeds, you can optionally change the state of your issue.
