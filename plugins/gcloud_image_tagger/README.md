# Gcloud image tagger Plugin

Tag gcloud images with the stage permalink they deployed to, so developers can pull down the "producion" image.

## Setup

 - enable [cloudbuild api](https://console.cloud.google.com/apis/api/cloudbuild.googleapis.com/overview)
 - create a gcloud service account with admin access to cloudbuild
 - download credentials for that account
 - run `gcloud auth activate-service-account --key-file <YOUR-KEY>` on the samson host
 - run `gcloud config set account $(jq -r .client_email < <YOUR-KEY>)` on the samson host
