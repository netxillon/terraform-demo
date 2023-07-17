resource "aws_iam_role" "bastion_ssm_role" {
  name = "bastion_ssm-${var.environment}-role"

  assume_role_policy = <<EOF
{
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
}
EOF
}


resource "aws_iam_role_policy" "bastion_ssm" {
  name = "bastion_ssm-${var.environment}-policy"
  role = aws_iam_role.bastion_ssm_role.id

  policy = jsonencode(
				{
				    "Version": "2012-10-17",
				    "Statement": [
				        {
				            "Action": [
				                "cloudwatch:PutMetricData",
				                "ds:CreateComputer",
				                "ds:DescribeDirectories",
				                "ec2:DescribeInstanceStatus",
				                "ec2messages:GetEndpoint",
				                "ec2messages:GetMessages",
				                "ec2messages:DeleteMessage",
				                "ec2messages:FailMessage",
				                "ec2messages:AcknowledgeMessage",
				                "ec2messages:SendReply",
				                "logs:CreateLogGroup",
				                "logs:PutLogEvents",
				                "logs:DescribeLogStreams",
				                "logs:CreateLogStream",
				                "logs:DescribeLogGroups",
				                "ssm:SendCommand",
				                "ssm:DescribeDocument",
				                "s3:ListBucket",
				                "s3:GetEncryptionConfiguration",
				                "s3:AbortMultipartUpload",
				                "s3:ListBucketMultipartUploads",
				                "s3:PutObject",
				                "s3:GetObject",
				                "s3:PutObjectAcl",
				                "s3:ListMultipartUploadParts",
				                "s3:GetBucketLocation",
				                "ssm:GetDeployablePatchSnapshotForInstance",
				                "ssm:GetParameters",
				                "ssm:PutInventory",
				                "ssm:ListAssociations",
				                "ssm:UpdateInstanceAssociationStatus",
				                "ssm:GetDocument",
				                "ssm:PutComplianceItems",
				                "ssm:DescribeAssociation",
				                "ssm:PutConfigurePackageResult",
				                "ssm:ListInstanceAssociations",
				                "ssm:GetParameter",
				                "ssm:UpdateAssociationStatus",
				                "ssm:GetManifest",
				                "ssm:UpdateInstanceInformation",
				                "ssmmessages:OpenControlChannel",
				                "ssmmessages:OpenDataChannel",
				                "ssmmessages:CreateControlChannel",
				                "ssmmessages:CreateDataChannel",
				                "ec2:DescribeTags"
				            ],
				            "Resource": "*",
				            "Effect": "Allow",
				            "Sid": "SSMAgentPolicy"
				        }
				    ]
				}
         )
}


