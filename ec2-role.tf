resource "aws_iam_role" "codedeploy_ec2_role" {
  name = "CodeDeployEC2ServiceRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
        Effect = "Allow",
        Sid    = ""
      }
    ]
  })
}
/*
resource "aws_iam_role_policy_attachment" "codedeploy_policy_attachment" {
  role       = aws_iam_role.codedeploy_ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2RoleforAWSCodeDeploy"
}
*/

resource "aws_iam_policy" "codedeploy_custom_policy" {
  name = "CodeDeployEC2Policy"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "codedeploy:*",
          "s3:Get*",
          "s3:List*",
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_policy_attachment" "codedeploy_custom_attach" {
  name       = "codedeploy-custom-attach"
  roles      = [aws_iam_role.codedeploy_ec2_role.name]
  policy_arn = aws_iam_policy.codedeploy_custom_policy.arn
}


resource "aws_iam_instance_profile" "codedeploy_instance_profile" {
  name = "codedeploy-ec2-instance-profile"
  role = aws_iam_role.codedeploy_ec2_role.name
}