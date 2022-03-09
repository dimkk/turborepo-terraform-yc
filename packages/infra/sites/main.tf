terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "0.72.0"
    }
  }
}


provider "yandex" {
  service_account_key_file = "../key.json"
  cloud_id                 = "enpgl6p8jb2bo46li0mc"
  folder_id                = "b1g3m3auqr6l2tni6med"
  zone                     = "ru-central1-a"
}

// Create SA
resource "yandex_iam_service_account" "sa" {
  name = "main-site"
}

// Grant permissions
resource "yandex_resourcemanager_folder_iam_member" "sa-editor" {
  role      = "storage.editor"
  folder_id = "b1g3m3auqr6l2tni6med"
  member    = "serviceAccount:${yandex_iam_service_account.sa.id}"
}

// Create Static Access Keys
resource "yandex_iam_service_account_static_access_key" "sa-static-key" {
  service_account_id = yandex_iam_service_account.sa.id
  description        = "static access key for object storage"
}

resource "yandex_storage_bucket" "main" {
  bucket     = "tfp-dev"
  acl        = "public-read"
  access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  website {
    index_document = "index.html"
    error_document = "index.html"
    routing_rules  = <<EOF
[{
    "Condition": {
        "KeyPrefixEquals": "/"
    },
    "Redirect": {
        "ReplaceKeyPrefixWith": "documents/"
    }
}]
EOF
  }
  # cors_rule {
  #   allowed_headers = ["*"]
  #   allowed_methods = ["PUT", "POST"]
  #   allowed_origins = ["https://s3-website-test.hashicorp.com"]
  #   expose_headers  = ["ETag"]
  #   max_age_seconds = 3000
  # }
}

resource "yandex_storage_bucket" "main-docs" {
  bucket     = "docs-tfp-dev"
  acl        = "public-read"
  access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  website {
    index_document = "index.html"
    error_document = "index.html"
    routing_rules  = <<EOF
[{
    "Condition": {
        "KeyPrefixEquals": "/"
    },
    "Redirect": {
        "ReplaceKeyPrefixWith": "documents/"
    }
}]
EOF
  }
  # cors_rule {
  #   allowed_headers = ["*"]
  #   allowed_methods = ["PUT", "POST"]
  #   allowed_origins = ["https://s3-website-test.hashicorp.com"]
  #   expose_headers  = ["ETag"]
  #   max_age_seconds = 3000
  # }
}

resource "yandex_storage_bucket" "main-admin" {
  bucket     = "admin-tfp-dev"
  acl        = "public-read"
  access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  website {
    index_document = "index.html"
    error_document = "index.html"
    routing_rules  = <<EOF
[{
    "Condition": {
        "KeyPrefixEquals": "/"
    },
    "Redirect": {
        "ReplaceKeyPrefixWith": "documents/"
    }
}]
EOF
  }
  # cors_rule {
  #   allowed_headers = ["*"]
  #   allowed_methods = ["PUT", "POST"]
  #   allowed_origins = ["https://s3-website-test.hashicorp.com"]
  #   expose_headers  = ["ETag"]
  #   max_age_seconds = 3000
  # }
}
