variable "rails_templates" {
  default = {
    "0" = "app"
    "1" = "db_create"
    "2" = "db_migrate"
    "3" = "sidekiq"
  }
}

data "template_file" "rails_task_definition_template" {
  count    = "${length(var.rails_templates)}"
  template = "${file("${path.module}/rails_${var.rails_templates[count.index]}.json.tpl")}"

  vars {
    repo_url                     = "${replace("${aws_ecr_repository.app.repository_url}", "https://", "")}"
    container_name               = "${var.container_name}"
    app_version                  = "${var.app_version}"
    db_host                      = "${var.db_host}"
    db_username                  = "${var.db_username}"
    db_password                  = "${var.db_password}"
    secret_key_base              = "${var.secret_key_base}"
    redis_url                    = "${var.redis_url}"
    elasticsearch_url            = "${var.elasticsearch_url}"
    rack_timeout_wait_timeout    = "${var.rack_timeout_wait_timeout}"
    rack_timeout_service_timeout = "${var.rack_timeout_service_timeout}"
    statement_timeout            = "${var.statement_timeout}"
  }
}

resource "aws_ecs_task_definition" "ecs_rails_task_definition" {
  count                 = "${length(var.rails_templates)}"
  family                = "${var.rails_templates[count.index]}"
  container_definitions = "${data.template_file.rails_task_definition_template.*.rendered[count.index]}"
}
