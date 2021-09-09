data "aws_ssm_parameter" "amzn2_ami" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

resource "aws_instance" "a" {
  ami                         = data.aws_ssm_parameter.amzn2_ami.value
  instance_type               = "t3.nano"
  key_name                    = "${var.app_name}-key-pair" // AWSコンソールで生成したキーペアの名前
  subnet_id                   = aws_subnet.public_1a.id
  vpc_security_group_ids      = [aws_security_group.test.id]
  associate_public_ip_address = true

  tags = {
    Name = "${var.app_name}-ec2-a-${var.environment}"
  }
}

resource "aws_instance" "c" {
  ami                         = data.aws_ssm_parameter.amzn2_ami.value
  instance_type               = "t3.nano"
  key_name                    = "${var.app_name}-key-pair" // AWSコンソールで生成したキーペアの名前
  subnet_id                   = aws_subnet.public_1c.id
  vpc_security_group_ids      = [aws_security_group.test.id]
  associate_public_ip_address = true

  tags = {
    Name = "${var.app_name}-ec2-c-${var.environment}"
  }
}

// security-group
resource "aws_security_group" "test" {
  name        = "${var.app_name}-security-group-${var.environment}"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "${var.app_name}-security-group-${var.environment}"
  }
}

/// ssh
resource "aws_security_group_rule" "ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.test.id
}

/// インバウンドルール
resource "aws_security_group_rule" "tcp" {
  type              = "ingress"
  // インバウンドは接続制限したいから設定
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.test.id
}

/// アウトバウンドルール
resource "aws_security_group_rule" "egress" {
  type              = "egress"
  // アウトバウンドは接続制限する必要ないから設定しない
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.test.id
}

// エラスティックIP
resource "aws_eip" "a" {
  instance = aws_instance.a.id
  vpc = true

  tags = {
    Name = "${var.app_name}-eip-a-${var.environment}"
  }
}

resource "aws_eip" "c" {
  instance = aws_instance.c.id
  vpc = true

  tags = {
    Name = "${var.app_name}-eip-c-${var.environment}"
  }
}
