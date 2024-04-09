resource "aws_iam_role" "sesrole_test" {
  name               = "ses-roletf"
  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
          "Service": "ec2.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "cloudwatch-policy" {
  role       = aws_iam_role.sesrole_test.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchFullAccess"
}

resource "aws_iam_role_policy_attachment" "ec2-policy" {
  role       = aws_iam_role.sesrole_test.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}

resource "aws_iam_role_policy" "ses-policy" {
  name   = "example-role-policy-ses"
  role   = aws_iam_role.sesrole_test.name

  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "ses:SendRawEmail",
          "ses:SendEmail"
        ],
        "Resource": "*"
      }
    ]
  })
}