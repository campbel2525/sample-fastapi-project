# ---------------------------------------------
# Admin API
# ---------------------------------------------
module "admin_api" {
  source                       = "../../../modules/create_app"
  health_check_path            = "/hc"
  account_id                   = module.current_account.account_id
  aws_region                   = var.aws_region
  target_name                  = "admin-api"
  aws_tokyo_elb_account_id     = var.aws_tokyo_elb_account_id
  tokyo_cert_arn               = var.tokyo_cert_arn
  vpc_id                       = module.vpc.id
  public_subnet_1a_id          = module.public_subnet_1a.id
  public_subnet_1c_id          = module.public_subnet_1c.id
  private_subnet_1a_id         = module.private_subnet_1a.id
  private_subnet_1c_id         = module.private_subnet_1c.id
  security_group_alb_sg_id     = module.alb_security_group.id
  security_group_ecs_app_sg_id = module.ecs_app_security_group.id
  container_definitions = jsonencode([
    {
      name      = "admin-api-app",
      image     = "public.ecr.aws/docker/library/python:3.10-bullseye",
      essential = true,
      logConfiguration = {
        logDriver = "awslogs",
        options = {
          awslogs-region        = var.aws_region,
          awslogs-group         = "/aws/ecs/admin-api-app",
          awslogs-stream-prefix = "admin-api-app"
        }
      },
      portMappings = [
        {
          hostPort      = 8000,
          protocol      = "tcp",
          containerPort = 8000
        }
      ],
      environment = [],
      secrets = [
        {
          name      = "APP_ENV_VALUES",
          valueFrom = "arn:aws:ssm:${var.aws_region}:${module.current_account.account_id}:parameter/ecs/app/admin-api/.env"
        }
      ]
    }
  ])
}

# ---------------------------------------------
# User API
# ---------------------------------------------
module "user_api" {
  source                       = "../../../modules/create_app"
  health_check_path            = "/hc"
  account_id                   = module.current_account.account_id
  aws_region                   = var.aws_region
  target_name                  = "user-api"
  aws_tokyo_elb_account_id     = var.aws_tokyo_elb_account_id
  tokyo_cert_arn               = var.tokyo_cert_arn
  vpc_id                       = module.vpc.id
  public_subnet_1a_id          = module.public_subnet_1a.id
  public_subnet_1c_id          = module.public_subnet_1c.id
  private_subnet_1a_id         = module.private_subnet_1a.id
  private_subnet_1c_id         = module.private_subnet_1c.id
  security_group_alb_sg_id     = module.alb_security_group.id
  security_group_ecs_app_sg_id = module.ecs_app_security_group.id
  container_definitions = jsonencode([
    {
      name      = "user-api-app",
      image     = "public.ecr.aws/docker/library/python:3.10-bullseye",
      essential = true,
      logConfiguration = {
        logDriver = "awslogs",
        options = {
          awslogs-region        = var.aws_region,
          awslogs-group         = "/aws/ecs/user-api-app",
          awslogs-stream-prefix = "user-api-app"
        }
      },
      portMappings = [
        {
          hostPort      = 8000,
          protocol      = "tcp",
          containerPort = 8000
        }
      ],
      environment = [],
      secrets = [
        {
          name      = "APP_ENV_VALUES",
          valueFrom = "arn:aws:ssm:${var.aws_region}:${module.current_account.account_id}:parameter/ecs/app/user-api/.env"
        }
      ]
    }
  ])
}

# ---------------------------------------------
# Admin Front
# ---------------------------------------------
module "admin_front" {
  source                       = "../../../modules/create_app"
  health_check_path            = "/"
  account_id                   = module.current_account.account_id
  aws_region                   = var.aws_region
  target_name                  = "admin-front"
  aws_tokyo_elb_account_id     = var.aws_tokyo_elb_account_id
  tokyo_cert_arn               = var.tokyo_cert_arn
  vpc_id                       = module.vpc.id
  public_subnet_1a_id          = module.public_subnet_1a.id
  public_subnet_1c_id          = module.public_subnet_1c.id
  private_subnet_1a_id         = module.private_subnet_1a.id
  private_subnet_1c_id         = module.private_subnet_1c.id
  security_group_alb_sg_id     = module.alb_security_group.id
  security_group_ecs_app_sg_id = module.ecs_app_security_group.id
  container_definitions = jsonencode([
    {
      name      = "admin-front-app",
      image     = "public.ecr.aws/docker/library/node:18-bullseye",
      essential = true,
      logConfiguration = {
        logDriver = "awslogs",
        options = {
          awslogs-region        = var.aws_region,
          awslogs-group         = "/aws/ecs/admin-front-app",
          awslogs-stream-prefix = "admin-front-app"
        }
      },
      portMappings = [
        {
          hostPort      = 8000,
          protocol      = "tcp",
          containerPort = 8000
        }
      ],
      environment = [],
      secrets = [
        {
          name      = "APP_ENV_VALUES",
          valueFrom = "arn:aws:ssm:${var.aws_region}:${module.current_account.account_id}:parameter/ecs/app/admin-front/.env"
        }
      ]
    }
  ])
}

# ---------------------------------------------
# User Front
# ---------------------------------------------
module "user_front" {
  source                       = "../../../modules/create_app"
  health_check_path            = "/"
  account_id                   = module.current_account.account_id
  aws_region                   = var.aws_region
  target_name                  = "user-front"
  aws_tokyo_elb_account_id     = var.aws_tokyo_elb_account_id
  tokyo_cert_arn               = var.tokyo_cert_arn
  vpc_id                       = module.vpc.id
  public_subnet_1a_id          = module.public_subnet_1a.id
  public_subnet_1c_id          = module.public_subnet_1c.id
  private_subnet_1a_id         = module.private_subnet_1a.id
  private_subnet_1c_id         = module.private_subnet_1c.id
  security_group_alb_sg_id     = module.alb_security_group.id
  security_group_ecs_app_sg_id = module.ecs_app_security_group.id
  container_definitions = jsonencode([
    {
      name      = "user-front-app",
      image     = "public.ecr.aws/docker/library/node:18-bullseye",
      essential = true,
      logConfiguration = {
        logDriver = "awslogs",
        options = {
          awslogs-region        = var.aws_region,
          awslogs-group         = "/aws/ecs/user-front-app",
          awslogs-stream-prefix = "user-front-app"
        }
      },
      portMappings = [
        {
          hostPort      = 8000,
          protocol      = "tcp",
          containerPort = 8000
        }
      ],
      environment = [],
      secrets = [
        {
          name      = "APP_ENV_VALUES",
          valueFrom = "arn:aws:ssm:${var.aws_region}:${module.current_account.account_id}:parameter/ecs/app/user-front/.env"
        }
      ]
    }
  ])
}
