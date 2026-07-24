#!/bin/bash
# Redirect all output to user-data.log for debugging
exec > /var/log/user-data.log 2>&1

echo "[+] Starting User Data Script..."
date

echo "[+] Updating system packages..."
dnf update -y || yum update -y

echo "[+] Installing Nginx web server..."
dnf install -y nginx || yum install -y nginx

echo "[+] Creating custom landing page..."
cat <<'EOF' > /usr/share/nginx/html/index.html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>IBM Internship — Terraform AWS IaC</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #0f2027, #203a43, #2c5364);
            color: #ffffff;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }
        .card {
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(10px);
            border-radius: 16px;
            padding: 40px;
            box-shadow: 0 8px 32px 0 rgba(0, 0, 0, 0.37);
            border: 1px solid rgba(255, 255, 255, 0.18);
            text-align: center;
            max-width: 600px;
        }
        h1 { color: #00d2ff; margin-bottom: 10px; }
        p { font-size: 1.1rem; line-height: 1.6; }
        .badge {
            display: inline-block;
            background: #00d2ff;
            color: #0f2027;
            padding: 6px 16px;
            border-radius: 20px;
            font-weight: bold;
            margin-top: 15px;
        }
        .footer { margin-top: 25px; font-size: 0.85rem; color: #a0aec0; }
    </style>
</head>
<body>
    <div class="card">
        <h1>🚀 Infrastructure Deployed via Terraform</h1>
        <p>This web server was automatically provisioned using <strong>Infrastructure as Code (IaC)</strong> on Amazon Web Services (AWS).</p>
        <div class="badge">IBM Internship Project — Nakul Yadav</div>
        <div class="footer">AWS EC2 | Nginx | Terraform Modular Architecture</div>
    </div>
</body>
</html>
EOF

echo "[+] Starting and enabling Nginx..."
systemctl start nginx
systemctl enable nginx

echo "[+] User-data execution complete!"
