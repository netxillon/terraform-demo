data "aws_caller_identity" "rscontrol" {}
data "aws_region" "rscontrol" {}

resource "aws_iam_role" "redshift_full_access_role" {
  name = "${var.org}-${var.project}-${var.environment}-redshift-full-access-role"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
        "Effect": "Allow",
        "Principal": {
            "Service": "redshift.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
        }
    ]
}
EOF
}

locals {
  managed_policy_arns_for_redshift_full_access_role = [ "arn:aws:iam::aws:policy/AmazonRedshiftAllCommandsFullAccess"]
}

resource "aws_iam_role_policy_attachment" "redshift_full_access_role" {
  role       = "${aws_iam_role.redshift_full_access_role.name}"
  count      = "${length(local.managed_policy_arns_for_redshift_full_access_role)}"
  policy_arn = "${local.managed_policy_arns_for_redshift_full_access_role[count.index]}"
}

# Export to S3
resource "aws_iam_role" "redshift_export_role" {
  name = "RedshiftExportToS3Role-${var.environment}"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": [
                    "redshift.amazonaws.com",
                    "s3.amazonaws.com"
                ]
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy" "redshift_export" {
  name = "RedshiftExportToS3-${var.environment}-policy"
  role = aws_iam_role.redshift_export_role.id

  policy = jsonencode(
				{
				    "Version": "2012-10-17",
				    "Statement": [
				        {
				            "Effect": "Allow",
				            "Action": [
				                "s3:PutObject",
				                "s3:GetObject",
				                "redshift:ModifyClusterIamRoles",
				                "s3:ListBucket"
				            ],
				            "Resource": [
				                "arn:aws:s3:::data-${var.environment}-demo1-zone",
				                "arn:aws:s3:::data-${var.environment}-demo1-zone/*"
				            ]
				        }
				    ]
				}
         )
}

resource "aws_redshift_subnet_group" "redshift_subnet_group" {
  name       = "${var.org}-data-platform-${var.environment}-redshift"
  subnet_ids = "${aws_subnet.private_subnets_redshift.*.id}"

  tags = {
    environment = "${var.org}-data-platform-${var.environment}"
  }
}


resource "aws_redshift_cluster" "redshift_cluster" {
  count                                 = "${var.environment}" == "dev" || "${var.environment}" == "test" ? 1 : 0
  cluster_identifier                    = "${var.org}-data-platform-${var.environment}"
  node_type                             = "${var.cluster_node_type}"
  number_of_nodes                       = "${var.cluster_number_of_nodes}"
  database_name                         = "sap_${var.environment}"
  master_username                       = "${var.CLUSTER_MASTER_USERNAME}"
  master_password                       = "${var.CLUSTER_MASTER_PASSWORD}"
  publicly_accessible			              = false
  enhanced_vpc_routing                  = true
  final_snapshot_identifier             = "${var.org}-data-platform-${var.environment}-final-snapshot"
  skip_final_snapshot                   = false
  automated_snapshot_retention_period   = "${var.automated_snapshot_retention_period}"
  cluster_subnet_group_name             = "${aws_redshift_subnet_group.redshift_subnet_group.id}"
  vpc_security_group_ids                = ["${aws_security_group.dbt_public_vpc.id}","${aws_default_security_group.default_private_vpc.id}"]
  iam_roles                             = [aws_iam_role.redshift_full_access_role.arn, aws_iam_role.redshift_export_role.arn]
}

/*
resource "aws_redshift_cluster" "redshift_cluster_snapshot" {
  count                                 = "${var.environment}" == "dev" ? 1 : 0
  cluster_identifier                    = "${var.org}-data-snap-${var.environment}"
  node_type                             = "${var.cluster_node_type}"
  number_of_nodes                       = "${var.cluster_number_of_nodes}"
  database_name                         = "sap_${var.environment}"
  master_username                       = "${var.CLUSTER_MASTER_USERNAME}"
  master_password                       = "${var.CLUSTER_MASTER_PASSWORD}"
  publicly_accessible			              = false
  snapshot_identifier                   = "may11snap"
  snapshot_cluster_identifier           = "${var.org}-data-platform-${var.environment}"
  final_snapshot_identifier             = "${var.org}-data-platform-snap-${var.environment}-final-snapshot"
  skip_final_snapshot                   = false
  automated_snapshot_retention_period   = "${var.automated_snapshot_retention_period}"
  cluster_subnet_group_name             = "${aws_redshift_subnet_group.redshift_subnet_group.id}"
  vpc_security_group_ids                = ["${aws_security_group.dbt_public_vpc.id}","${aws_default_security_group.default_private_vpc.id}"]
  iam_roles                             = [aws_iam_role.redshift_full_access_role.arn, aws_iam_role.redshift_export_role.arn]
}
*/

resource "aws_redshift_snapshot_schedule" "default" {
  identifier = "${var.org}-data-${var.environment}-at21hours-schedule"
  definitions = [
    "rate(21 hours)",
  ]
}

resource "aws_redshift_snapshot_schedule_association" "default" {
  cluster_identifier  = aws_redshift_cluster.redshift_cluster[0].id
  schedule_identifier = aws_redshift_snapshot_schedule.default.id
}