cat > README.md << 'EOF'
# 🚀 DevOps Staj Projesi

Bu proje Infrastructure as Code, Configuration Management ve Monitoring stack'ini içerir.

## 🏗️ Kullanılan Teknolojiler
- **Infrastructure:** Terraform + Terragrunt
- **Configuration:** Ansible  
- **Monitoring:** Prometheus + Grafana + Node Exporter
- **Development:** Docker + Docker Compose
- **Cloud:** AWS (VPC, EC2, Security Groups)

 🎯 Çalıştırma
```bash
# 1. AWS credentials ayarla
# 2. Docker'ı başlat
docker-compose up -d
# 3. Container'a gir ve deploy et
docker exec -it staj-devops bash
terragrunt apply --terragrunt-config vpc.hcl
terragrunt apply --terragrunt-config ec2.hcl
