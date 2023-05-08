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

resource "aws_redshift_subnet_group" "redshift_subnet_group" {
  name       = "${var.org}-data-platform-${var.environment}-redshift"
  subnet_ids = "${aws_subnet.private_subnets_redshift.*.id}"

  tags = {
    environment = "${var.org}-data-platform-${var.environment}"
  }
}


resource "aws_redshift_cluster" "redshift_cluster" {
  cluster_identifier                    = "${var.org}-data-platform-${var.environment}"
  node_type                             = "${var.cluster_node_type}"
  number_of_nodes                       = "${var.cluster_number_of_nodes}"
  database_name                         = "sap_${var.environment}"
  master_username                       = "${var.CLUSTER_MASTER_USERNAME}"
  master_password                       = "${var.CLUSTER_MASTER_PASSWORD}"
  publicly_accessible			= false
  automated_snapshot_retention_period   = "${var.automated_snapshot_retention_period}"
  cluster_subnet_group_name             = "${aws_redshift_subnet_group.redshift_subnet_group.id}"
  vpc_security_group_ids                = ["${aws_security_group.dbt_public_vpc.id}","${aws_default_security_group.default_private_vpc.id}"]
  iam_roles                             = [aws_iam_role.redshift_full_access_role.arn]
}
