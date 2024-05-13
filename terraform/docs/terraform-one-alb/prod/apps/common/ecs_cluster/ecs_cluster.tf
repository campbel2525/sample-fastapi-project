# クラスター
resource "aws_ecs_cluster" "ecs_cluster" {
  name = "${var.project_name}-${var.environment}-ecs-cluster"
  # tags = {
  #   Name    = "${var.project_name}-${var.environment}-ecs-cluster-api"
  #   Project = var.project_name
  #   Env     = var.environment
  # }

  # configuration {
  #   execute_command_configuration {
  #     # OVERRIDE、DEFAULT、NONE のいずれかを指定できます。この設定は execute-command のログがどのように扱われるかを制御します。OVERRIDE を指定すると、log_configuration セクションで指定した設定が適用されます。しかし、log_configuration セクションが存在しない場合、OVERRIDE と DEFAULT の挙動は同じになります。
  #     logging = "OVERRIDE" # OVERRIDE, DEFAULT, NONE
  #   }
  # }
}
