terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "0.72.0"
    }
  }
}

variable "vers" {
  type        = string
  description = "version to update hash"
}

provider "yandex" {
  service_account_key_file = "../key.json"
  cloud_id                 = "enpgl6p8jb2bo46li0mc"
  folder_id                = "b1g3m3auqr6l2tni6med"
  zone                     = "ru-central1-a"
}

resource "yandex_iam_service_account" "sa" {
  name        = "ftp-dev-api-invoker"
  description = "service account to manage VMs"
}

resource "yandex_function" "testfn" {
  name               = "api"
  description        = "any description"
  user_hash          = var.vers
  runtime            = "nodejs16"
  service_account_id = "aje6kiabfnjmqqk5d3ut"
  entrypoint         = "index.handler"
  memory             = "128"
  execution_timeout  = "10"
  content {
    zip_filename = "function.zip"
  }
}

resource "yandex_iam_service_account_api_key" "sa-api-key" {
  service_account_id = yandex_iam_service_account.sa.id
  description        = "api key for authorization"
}

resource "yandex_function_iam_binding" "function-iam" {
  function_id = yandex_function.testfn.id
  role        = "serverless.functions.invoker"

  members = [
    "serviceAccount:${yandex_iam_service_account.sa.id}",
  ]
}

