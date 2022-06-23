# creating Ecs for a projecr

resource "aws_ecs_cluster" "assignment_ecs_cluster" {
    name = "assignment-ECS-cluster"
}

resource "aws_ecr_repository" "worker" {
    name = "worker"
}

resource "aws_ecs_service" "assignment_ECS_worker" {
    name            = "assignment_ECS_worker"
    cluster         = aws_ecs_cluster.assignment_ecs_cluster.id
    task_definition = aws_ecs_task_definition.assignment_task_definition.arn
    desired_count   = 2
}

resource "aws_ecs_task_definition" "assignment_task_definition" {
    family                = "worker"
    container_definitions = data.template_file.assignment_task_definition_template.rendered
}


data "template_file" "assignment_task_definition_template" {
    template = file("task_definition.json.tpl")
    vars = {
    REPOSITORY_URL = replace(aws_ecr_repository.worker.repository_url, "https://", "")
    }
}

output "mysql_endpoint" {
    value = aws_db_instance.assignment-mysql.endpoint 
}

output "ecr_repository_worker_endpoint" {
    value = aws_ecr_repository.worker.repository_url 
    }     