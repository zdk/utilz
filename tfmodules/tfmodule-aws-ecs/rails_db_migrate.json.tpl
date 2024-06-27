[
  {
    "essential": true,
    "image": "${repo_url}:${app_version}",
    "memoryReservation": 512,
    "name": "${container_name}",
    "command": ["bin/rails","db:migrate"],
    "environment" : [
      { "name" : "DB_HOST", "value" : "${db_host}" },
      { "name" : "DB_USERNAME", "value" : "${db_username}" },
      { "name" : "DB_PASSWORD", "value" : "${db_password}" },
      { "name" : "SECRET_KEY_BASE", "value" : "${secret_key_base}" },
      { "name" : "REDIS_URL", "value" : "${redis_url}" },
      { "name" : "ELASTICSEARCH_URL", "value" : "${elasticsearch_url}" },
      { "name" : "RACK_TIMEOUT_WAIT_TIMEOUT", "value" : "${rack_timeout_wait_timeout}" },
      { "name" : "RACK_TIMEOUT_SERVICE_TIMEOUT", "value" : "${rack_timeout_service_timeout}" },
      { "name" : "STATEMENT_TIMEOUT", "value" : "${statement_timeout}" }
    ],
    "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "awslogs-<namespace>-website",
          "awslogs-region": "ap-southeast-1",
          "awslogs-stream-prefix": "awslogs-<namespace>-website"
        }
    }
  }
]