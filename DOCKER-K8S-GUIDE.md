# 🚀 Docker + Kubernetes Deployment Guide

## 📚 Table of Contents
1. [Concepts Explained](#concepts-explained)
2. [Prerequisites](#prerequisites)
3. [Step 1: Test Docker Locally](#step-1-test-docker-locally)
4. [Step 2: Push to Docker Hub](#step-2-push-to-docker-hub)
5. [Step 3: Setup Kubernetes](#step-3-setup-kubernetes)
6. [Step 4: Configure Jenkins](#step-4-configure-jenkins)
7. [Step 5: Run the Pipeline](#step-5-run-the-pipeline)
8. [Troubleshooting](#troubleshooting)

---

## 📚 Concepts Explained

### 🐳 What is Docker?
**Docker** packages your application and all its dependencies into a **container** - a lightweight, standalone package that runs consistently anywhere.

**Analogy:** Think of Docker like a shipping container. Just like a shipping container holds products and can be moved from ship → truck → train without unpacking, a Docker container holds your app and dependencies and can run on your laptop → test server → production without changes.

**Key Components:**
- **Dockerfile** = Recipe (instructions to build your container)
- **Image** = Template (built from Dockerfile, stored in registry)
- **Container** = Running instance (your app actually running)
- **Registry** = Storage (Docker Hub is like GitHub for Docker images)

### ☸️ What is Kubernetes (K8s)?
**Kubernetes** is a container orchestrator - it manages running containers across multiple servers.

**Analogy:** If Docker is like a single shipping container, Kubernetes is like the entire port management system that decides which containers go on which ships, how many containers to load, what to do if a container falls off, etc.

**Key Components:**
- **Pod** = Smallest unit (usually 1 container)
- **Deployment** = Manages multiple pods (ensures X copies are always running)
- **Service** = Load balancer (distributes traffic across pods)
- **Namespace** = Isolated environment (like folders for organization)

### 🔄 Why Both?
- **Docker** = Packages your app
- **Kubernetes** = Runs Docker containers at scale with:
  - **Auto-healing** (restarts crashed containers)
  - **Scaling** (add more containers when traffic increases)
  - **Load balancing** (distribute traffic)
  - **Rolling updates** (deploy new versions with zero downtime)

---

## ✅ Prerequisites

### 1. Docker Desktop
```powershell
# Verify Docker is installed
docker --version
docker ps
```

### 2. Docker Hub Account
1. Go to https://hub.docker.com/
2. Sign up for a free account
3. Remember your username (you'll need it)

### 3. Kubernetes Cluster
**Option A: Local Development (Recommended for Learning)**
- Enable Kubernetes in Docker Desktop:
  - Docker Desktop → Settings → Kubernetes → Enable Kubernetes
  
**Option B: Cloud Kubernetes**
- Minikube (local)
- AWS EKS
- Azure AKS
- Google GKE

### 4. kubectl CLI
```powershell
# Verify kubectl is installed
kubectl version --client

# Check cluster connection
kubectl cluster-info
kubectl get nodes
```

---

## 🧪 Step 1: Test Docker Locally

### 1.1 Build Docker Image
```powershell
cd C:\Users\gunasec\Petclinic\spring-petclinic

# Build the Docker image
docker build -t spring-petclinic:local .

# This will:
# - Read Dockerfile
# - Download base image (Java 17)
# - Copy your code
# - Run Maven build
# - Create final image
```

### 1.2 Run Container Locally
```powershell
# Run the container
docker run -d --name petclinic-test -p 8080:8080 spring-petclinic:local

# Explanation:
# -d           = Run in background (detached)
# --name       = Give it a friendly name
# -p 8080:8080 = Map port (host:container)

# Check if it's running
docker ps

# View logs
docker logs petclinic-test

# Test the application
Start-Process "http://localhost:8080"

# Stop and remove
docker stop petclinic-test
docker rm petclinic-test
```

### 1.3 Use Docker Compose (Easier!)
```powershell
# Build and run with one command
docker-compose -f docker-compose-app.yml up --build

# This will:
# - Build the image
# - Start the container
# - Show logs in terminal

# Access app: http://localhost:8080

# Stop: Ctrl+C, then:
docker-compose -f docker-compose-app.yml down
```

---

## 📤 Step 2: Push to Docker Hub

### 2.1 Login to Docker Hub
```powershell
# Login (enter your password when prompted)
docker login

# You should see: "Login Succeeded"
```

### 2.2 Tag Your Image
```powershell
# Replace 'gunacg' with YOUR Docker Hub username
docker tag spring-petclinic:local gunacg/spring-petclinic:4.0.0
docker tag spring-petclinic:local gunacg/spring-petclinic:latest
```

### 2.3 Push to Registry
```powershell
# Push both tags
docker push gunacg/spring-petclinic:4.0.0
docker push gunacg/spring-petclinic:latest

# Verify on web: https://hub.docker.com/r/gunacg/spring-petclinic
```

### 2.4 Update Config Files
**IMPORTANT:** Replace `gunacg` with your Docker Hub username in:
1. `Jenkinsfile-docker-k8s` (line 20)
2. `k8s/petclinic.yml` (line 47)
3. `docker-compose-app.yml` (line 21)

---

## ☸️ Step 3: Setup Kubernetes

### 3.1 Verify Cluster
```powershell
# Check cluster is running
kubectl cluster-info
kubectl get nodes

# Should show at least 1 node in "Ready" status
```

### 3.2 Create Namespace (Optional)
```powershell
# Create a namespace for organization
kubectl create namespace petclinic-dev

# Or use 'default' namespace (we'll use this)
```

### 3.3 Deploy to Kubernetes
```powershell
cd C:\Users\gunasec\Petclinic\spring-petclinic

# Apply the Kubernetes manifests
kubectl apply -f k8s/petclinic.yml

# This creates:
# - Service (load balancer)
# - Deployment (2 replicas of your app)
```

### 3.4 Check Deployment
```powershell
# View deployment
kubectl get deployments

# View pods (running containers)
kubectl get pods

# View services
kubectl get services

# Describe deployment (detailed info)
kubectl describe deployment petclinic
```

### 3.5 Access the Application
```powershell
# Method 1: NodePort (configured in petclinic.yml)
# If using Docker Desktop K8s: http://localhost:30080

# Method 2: Port Forward
kubectl port-forward service/petclinic 8080:80

# Then access: http://localhost:8080

# Method 3: Get service URL (for cloud K8s)
kubectl get service petclinic
```

### 3.6 View Logs
```powershell
# Get pod logs
kubectl logs -l app=petclinic --tail=50

# Follow logs (live)
kubectl logs -l app=petclinic -f

# Logs from specific pod
kubectl get pods
kubectl logs petclinic-xxxxxxxxx-xxxxx
```

### 3.7 Scale Application
```powershell
# Scale to 3 replicas
kubectl scale deployment petclinic --replicas=3

# Check pods
kubectl get pods -w

# Scale back to 2
kubectl scale deployment petclinic --replicas=2
```

---

## 🔧 Step 4: Configure Jenkins

### 4.1 Add Docker Hub Credentials
1. Jenkins → Manage Jenkins → Credentials
2. Click **(global)** domain
3. Click **Add Credentials**
4. Fill in:
   - **Kind:** Username with password
   - **Scope:** Global
   - **Username:** Your Docker Hub username
   - **Password:** Your Docker Hub password
   - **ID:** `dockerhub-credentials` (must match Jenkinsfile)
   - **Description:** Docker Hub Login
5. Click **Create**

### 4.2 Install Docker Pipeline Plugin
1. Jenkins → Manage Jenkins → Plugins
2. Search for "Docker Pipeline"
3. Install and restart Jenkins

### 4.3 Configure Docker in Jenkins
```powershell
# Test Docker access from Jenkins container
docker exec -it petclinic-jenkins docker --version

# If error: Need to mount Docker socket
# Update jenkins-setup/docker-compose.yml to add:
# volumes:
#   - /var/run/docker.sock:/var/run/docker.sock
```

### 4.4 Add kubectl to Jenkins
```powershell
# Copy kubectl to Jenkins container
docker cp $(where.exe kubectl).Split([Environment]::NewLine)[0] petclinic-jenkins:/usr/local/bin/kubectl

# Or install inside container:
docker exec -it petclinic-jenkins sh
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
mv kubectl /usr/local/bin/
exit
```

### 4.5 Configure K8s Access
```powershell
# Copy your kubeconfig to Jenkins
docker cp $env:USERPROFILE\.kube\config petclinic-jenkins:/var/jenkins_home/.kube/config

# Verify inside Jenkins
docker exec petclinic-jenkins kubectl get nodes
```

### 4.6 Create New Pipeline Job
1. Jenkins → New Item
2. Name: `PetClinic-Docker-K8s-Pipeline`
3. Type: **Pipeline**
4. Click **OK**
5. Configuration:
   - **Pipeline Definition:** Pipeline script from SCM
   - **SCM:** Git
   - **Repository URL:** https://github.com/Guna-CG/Petclinic.git
   - **Branch:** main
   - **Script Path:** `Jenkinsfile-docker-k8s`
6. Save

---

## ▶️ Step 5: Run the Pipeline

### 5.1 Update Configuration
Before running, update these files with YOUR Docker Hub username:

**Jenkinsfile-docker-k8s:**
```groovy
DOCKER_IMAGE_NAME = 'YOUR_USERNAME/spring-petclinic'  // Line 20
```

**k8s/petclinic.yml:**
```yaml
image: YOUR_USERNAME/spring-petclinic:latest  // Line 47
```

### 5.2 Commit and Push
```powershell
git add .
git commit -m "Add Docker and Kubernetes support"
git push origin main
```

### 5.3 Run Pipeline
1. Go to Jenkins → PetClinic-Docker-K8s-Pipeline
2. Click **Build Now**
3. Watch the progress through 10 stages:
   - 1️⃣ Checkout
   - 2️⃣ Build
   - 3️⃣ Unit Tests
   - 4️⃣ Package
   - 5️⃣ Archive
   - 6️⃣ Docker Build
   - 7️⃣ Docker Push
   - 8️⃣ Docker Test
   - 9️⃣ Deploy to K8s
   - 🔟 Verify K8s

### 5.4 Monitor Build
```powershell
# Watch Jenkins logs in console

# Meanwhile, in another terminal, watch K8s:
kubectl get pods -w

# Check deployment updates:
kubectl rollout status deployment/petclinic
```

---

## 🐛 Troubleshooting

### Docker Issues

**Problem: "Docker daemon not running"**
```powershell
# Solution: Start Docker Desktop
```

**Problem: "Permission denied accessing Docker"**
```powershell
# Solution: Run as Administrator or add user to docker-users group
```

**Problem: "Failed to build image"**
```powershell
# Check Docker build logs
docker build -t test .

# Clean up and retry
docker system prune -a
```

### Kubernetes Issues

**Problem: "Connection refused to cluster"**
```powershell
# Verify cluster is running
kubectl cluster-info

# If using Docker Desktop, ensure it's enabled:
# Docker Desktop → Settings → Kubernetes → Enable
```

**Problem: "ImagePullBackOff" error**
```powershell
# Check image name is correct
kubectl describe pod <pod-name>

# Verify image exists on Docker Hub
docker pull gunacg/spring-petclinic:latest
```

**Problem: "Pods in CrashLoopBackOff"**
```powershell
# Check pod logs
kubectl logs <pod-name>

# Check resource limits
kubectl describe pod <pod-name>

# Common fixes:
# - Increase memory limits in petclinic.yml
# - Check application properties
# - Verify health check paths
```

**Problem: "Service not accessible"**
```powershell
# Check service exists
kubectl get service petclinic

# Check endpoints are populated
kubectl get endpoints petclinic

# Port forward for testing
kubectl port-forward service/petclinic 8080:80
```

### Jenkins Issues

**Problem: "Docker not available in Jenkins"**
```powershell
# Mount Docker socket in jenkins docker-compose.yml:
volumes:
  - /var/run/docker.sock:/var/run/docker.sock
  
# Restart Jenkins
docker-compose restart jenkins
```

**Problem: "kubectl not found"**
```powershell
# Install kubectl in Jenkins container (see Step 4.4)
```

**Problem: "Credentials not found"**
```powershell
# Verify credential ID matches exactly 'dockerhub-credentials'
# Re-create credential if needed (Step 4.1)
```

---

## 🎓 Key Learnings

### What You Built:
1. **Dockerfile** - Containerized your Spring Boot app
2. **Docker Image** - Stored in Docker Hub registry
3. **Kubernetes Deployment** - Running 2 replicas with auto-healing
4. **Jenkins Pipeline** - Full CI/CD automation:
   - Code → Build → Test → Package → Containerize → Push → Deploy

### Industry Best Practices You Learned:
- ✅ Multi-stage Docker builds (smaller images)
- ✅ Health checks (liveness & readiness probes)
- ✅ Resource limits (prevent out-of-memory)
- ✅ Rolling updates (zero-downtime deployments)
- ✅ Container orchestration (automatic scaling & healing)
- ✅ GitOps workflow (version-controlled infrastructure)

### Next Steps (Optional):
1. **Helm Charts** - Package manager for Kubernetes
2. **Ingress Controller** - Better routing (instead of NodePort)
3. **Monitoring** - Prometheus + Grafana
4. **Logging** - ELK Stack (Elasticsearch, Logstash, Kibana)
5. **Service Mesh** - Istio for advanced traffic management
6. **Secret Management** - HashiCorp Vault or Sealed Secrets
7. **CI/CD Enhancements**:
   - Integration tests
   - Security scanning (Trivy, Snyk)
   - Performance tests (JMeter)
   - Code coverage (JaCoCo)

---

## 📞 Quick Reference Commands

```powershell
# Docker
docker build -t myapp .                    # Build image
docker run -p 8080:8080 myapp              # Run container
docker ps                                  # List running containers
docker logs <container>                    # View logs
docker exec -it <container> sh             # Shell into container
docker stop <container>                    # Stop container
docker system prune -a                     # Clean up everything

# Kubernetes
kubectl apply -f manifests/                # Deploy
kubectl get pods                           # List pods
kubectl get services                       # List services
kubectl logs <pod>                         # View logs
kubectl describe pod <pod>                 # Detailed pod info
kubectl delete pod <pod>                   # Delete pod (recreates)
kubectl scale deployment myapp --replicas=3  # Scale
kubectl rollout restart deployment myapp   # Restart deployment
kubectl port-forward service/myapp 8080:80 # Access service

# Jenkins + Git
git add .                                  # Stage changes
git commit -m "message"                    # Commit
git push origin main                       # Push to GitHub
# Then trigger build in Jenkins UI
```

---

🎉 **Congratulations!** You now understand Docker, Kubernetes, and industry-standard CI/CD pipelines!
