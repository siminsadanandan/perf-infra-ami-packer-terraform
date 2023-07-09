############
# MODULE: IAM policy and instance profile provisioning
# module input params defined in module specific variable.tf file 
# output value are defined in output.tf file 
resource "aws_iam_policy" "perf-loadgen-s3-policy" {
  name        = "perf-loadgen-s3-policy"
  path        = "/"
  description = "Allow "

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "VisualEditor0",
        "Effect" : "Allow",
        "Action" : [
          "s3:PutObject",
          "s3:GetObject",
          "s3:ListBucket",
          "s3:DeleteObject"
        ],
        "Resource" : [
          "arn:aws:s3:::*/*",
          "arn:aws:s3:::perf-loadgen-store"
        ]
      }
    ]
  })
}

resource "aws_iam_role" "perf-loadgen-role" {
  name = "perf-loadgen-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "perf-loadgen-s3-policy-att" {
  role       = aws_iam_role.perf-loadgen-role.name
  policy_arn = aws_iam_policy.perf-loadgen-s3-policy.arn
}

resource "aws_iam_role_policy_attachment" "perf-loadgen-cloud-watch-policy" {
  role       = aws_iam_role.perf-loadgen-role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

resource "aws_iam_instance_profile" "perf-loadgen-s3-profile" {
  name = "perf-loadgen-s3-profile"
  role = aws_iam_role.perf-loadgen-role.name
}


