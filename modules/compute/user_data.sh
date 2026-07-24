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
    <title>IBM Internship — Group 4 | Terraform AWS IaC</title>
    <style>
        * { box-sizing: border-box; }
        body {
            font-family: 'Segoe UI', system-ui, -apple-system, BlinkMacSystemFont, Roboto, sans-serif;
            background: linear-gradient(135deg, #0b132b, #1c2541, #3a506b);
            color: #ffffff;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            margin: 0;
            padding: 20px;
        }
        .card {
            background: rgba(255, 255, 255, 0.07);
            backdrop-filter: blur(16px);
            -webkit-backdrop-filter: blur(16px);
            border-radius: 20px;
            padding: 40px;
            box-shadow: 0 16px 40px rgba(0, 0, 0, 0.4);
            border: 1px solid rgba(255, 255, 255, 0.15);
            text-align: center;
            max-width: 750px;
            width: 100%;
        }
        .icon { font-size: 3.2rem; margin-bottom: 10px; }
        h1 {
            color: #48cae4;
            font-size: 2.2rem;
            margin-top: 0;
            margin-bottom: 15px;
            letter-spacing: -0.5px;
        }
        .subtitle {
            font-size: 1.15rem;
            line-height: 1.6;
            color: #e0e1dd;
            margin-bottom: 25px;
        }
        .badge-container {
            display: flex;
            justify-content: center;
            gap: 12px;
            flex-wrap: wrap;
            margin-bottom: 30px;
        }
        .badge {
            padding: 8px 18px;
            border-radius: 30px;
            font-weight: 600;
            font-size: 0.95rem;
        }
        .badge-main { background: #0077b6; color: #ffffff; }
        .badge-sub { background: #48cae4; color: #0b132b; }
        .badge-tier { background: rgba(255, 255, 255, 0.15); color: #90e0ef; border: 1px solid rgba(255, 255, 255, 0.2); }
        
        .grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
            text-align: left;
            margin-bottom: 25px;
        }
        .grid-item {
            background: rgba(0, 0, 0, 0.25);
            padding: 18px;
            border-radius: 12px;
            border: 1px solid rgba(255, 255, 255, 0.08);
        }
        .grid-item h3 {
            margin: 0 0 8px 0;
            font-size: 1rem;
            color: #90e0ef;
        }
        .grid-item p {
            margin: 0;
            font-size: 0.88rem;
            color: #caf0f8;
            line-height: 1.4;
        }
        .footer {
            margin-top: 20px;
            font-size: 0.85rem;
            color: #8d99ae;
            border-top: 1px solid rgba(255, 255, 255, 0.1);
            padding-top: 20px;
        }
    </style>
</head>
<body>
    <div class="card">
        <div class="icon">🚀</div>
        <h1>Infrastructure Deployed via Terraform</h1>
        <p class="subtitle">This production-inspired web application environment was fully automated & provisioned using <strong>Infrastructure as Code (IaC)</strong> on <strong>Amazon Web Services (AWS)</strong>.</p>

        <div class="badge-container">
            <div class="badge badge-main">IBM Internship Project — Group 4</div>
            <div class="badge badge-sub">Lead Engineer: Nakul Yadav</div>
            <div class="badge badge-tier">AWS Region: ap-south-1 (Mumbai)</div>
        </div>

        <div class="grid">
            <div class="grid-item">
                <h3>🌐 Networking Tier</h3>
                <p>Custom VPC (10.0.0.0/16), Public & Private Subnets, IGW, Route Tables & Stateful Firewalls.</p>
            </div>
            <div class="grid-item">
                <h3>⚡ Compute Tier</h3>
                <p>Amazon EC2 t3.micro with automated Nginx user-data bootstrapper & Static Elastic IP.</p>
            </div>
            <div class="grid-item">
                <h3>🔒 Storage & Security</h3>
                <p>Amazon S3 with AES-256 Encryption, Object Versioning & Public Access Block.</p>
            </div>
        </div>

        <div class="footer">
            Modular HCL Architecture | 15 Managed AWS Resources | Zero Manual ClickOps
        </div>
    </div>
</body>
</html>
EOF

echo "[+] Starting and enabling Nginx..."
systemctl start nginx
systemctl enable nginx

echo "[+] User-data execution complete!"
