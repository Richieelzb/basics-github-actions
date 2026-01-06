resource "aws_ecr_repository" "lzb-project" {
  name                 = "lzb-project-repo"
  image_tag_mutability = "MUTABLE"

  encryption_configuration {
    encryption_type = "AES256"
  }

  tags = {
    Environment = "dev"
    Team        = "DevOps"
  }
}

resource "aws_ecr_repository_policy" "my_app_policy" {
  repository = aws_ecr_repository.lzb-project.name

  policy = jsonencode({
    Version = "2008-10-17"
    Statement = [
      {
        Sid       = "AllowPull"
        Effect    = "Allow"
        Principal = "*"
        Action = [
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecr:BatchCheckLayerAvailability"
        ]
      }
    ]
  })
}