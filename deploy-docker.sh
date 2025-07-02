#!/bin/bash

echo "=== Docker ile Staj Projesi ==="

# Gerekli klasörleri oluştur
mkdir -p docker

# Docker Compose ile ortamı başlat
echo "Docker container'ları başlatılıyor..."
docker-compose up -d

echo "Container'ların hazır olması bekleniyor..."
sleep 30

# DevOps container'ına gir ve AWS deployment yap
echo "AWS'ye deployment başlatılıyor..."
docker-compose exec devops-env bash -c "
    echo '=== AWS Credentials Kontrolü ==='
    aws sts get-caller-identity

    echo '=== Terraform/Terragrunt Deployment ==='
    chmod 600 staj-key.pem || true
    
    echo '1/3 - VPC oluşturuluyor...'
    terragrunt apply -auto-approve --terragrunt-config vpc.hcl
    
    echo '2/3 - EC2 oluşturuluyor...'
    terragrunt apply -auto-approve --terragrunt-config ec2.hcl
    
    echo '3/3 - Public IP alınıyor...'
    PUBLIC_IP=\$(terragrunt output -raw public_ip --terragrunt-config ec2.hcl)
    echo \"AWS EC2 Public IP: \$PUBLIC_IP\"
    
    echo 'Ansible deployment...'
    mkdir -p inventory
    echo \"[web]\" > inventory/hosts.ini
    echo \"\$PUBLIC_IP ansible_user=ec2-user ansible_ssh_private_key_file=../sstaj-key.pem ansible_ssh_common_args='-o StrictHostKeyChecking=no'\" >> inventory/hosts.ini
    
    sleep 60
    ansible-playbook -i inventory/hosts.ini playbooks/install_flask.yaml
    ansible-playbook -i inventory/hosts.ini playbooks/monitoring.yaml
    
    echo \"\"
    echo \"=== AWS Deployment Tamamlandı! ===\"
    echo \"AWS Flask App: http://\$PUBLIC_IP:5000\"
    echo \"AWS Grafana: http://\$PUBLIC_IP:3000\"
"

echo ""
echo "=== Sonuç ==="
echo "Local Test Ortamı:"
echo "   Flask:      http://localhost:5000"
echo "   Grafana:    http://localhost:3000 (admin/admin)"
echo "   Prometheus: http://localhost:9090"
echo "   Node Exp:   http://localhost:9100"
echo ""
echo "AWS Production:"
echo "   Deployment tamamlandı - container log'larını kontrol edin"
echo ""
echo "Container'lara erişim:"
echo "   docker-compose exec devops-env bash"