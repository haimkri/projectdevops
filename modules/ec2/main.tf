# Security Group
resource "aws_security_group" "ec2_sg" {
  name        = "${var.environment}-ec2-sg"
  description = "Security group for EC2 instance"
  vpc_id      = var.vpc_id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.environment}-ec2-sg"
    Environment = var.environment
  }
}

# EC2 Instance עם user_data משופר
resource "aws_instance" "web_server" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]

  user_data = <<-EOF
    #!/bin/bash
    exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1
    echo "================================="
    echo "התחלת סקריפט התקנה"
    echo "================================="
    
    # עדכון המערכת
    echo "מעדכן חבילות..."
    yum update -y
    
    # התקנת Apache
    echo "מתקין Apache..."
    yum install -y httpd
    
    # יצירת דף HTML
    echo "יוצר דף HTML..."
    cat > /var/www/html/index.html <<HTML
    <!DOCTYPE html>
    <html>
    <head>
        <title>השרת שלי</title>
        <style>
            body { font-family: Arial; text-align: center; padding: 50px; background-color: #f0f0f0; }
            h1 { color: #333; }
            .info { background-color: white; padding: 20px; border-radius: 10px; margin: 20px; }
        </style>
    </head>
    <body>
        <div class="info">
            <h1>👋 שלום מ-Terraform!</h1>
            <h2>Environment: ${var.environment}</h2>
            <p><strong>Instance ID:</strong> $(curl -s http://169.254.169.254/latest/meta-data/instance-id)</p>
            <p><strong>Public IP:</strong> $(curl -s http://169.254.169.254/latest/meta-data/public-ipv4)</p>
            <p><strong>Availability Zone:</strong> $(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone)</p>
            <p><strong>תאריך:</strong> $(date)</p>
        </div>
    </body>
    </html>
    HTML
    
    # הפעלת Apache
    echo "מפעיל Apache..."
    systemctl start httpd
    systemctl enable httpd
    
    # בדיקה שApache רץ
    echo "בודק שApache רץ..."
    systemctl status httpd --no-pager
    
    # יצירת דף סטטוס
    echo "יוצר דף סטטוס..."
    cat > /var/www/html/status.html <<STATUS
    <html>
    <body>
        <h1>סטטוס שרת</h1>
        <pre>
$(systemctl status httpd)
        </pre>
    </body>
    </html>
    STATUS
    
    echo "================================="
    echo "סקריפט הסתיים בהצלחה"
    echo "================================="
  EOF

  tags = {
    Name        = "${var.environment}-web-server"
    Environment = var.environment
  }
}

# Elastic IP
resource "aws_eip" "web_eip" {
  instance = aws_instance.web_server.id
  domain   = "vpc"

  tags = {
    Name        = "${var.environment}-web-eip"
    Environment = var.environment
  }
}