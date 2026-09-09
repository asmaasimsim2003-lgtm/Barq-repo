# Security Assessment & Concrete Risk Review

## Implemented Fixes vs Production Security Roadmap

### 1. Plaintext Credentials in Environment Variables
- **Current Risk**: Database credentials stored in Compose environment files.
- **Production Improvement**: Inject secrets dynamically using HashiCorp Vault or AWS Secrets Manager.

### 2. Containers Running as Root User
- **Current Risk**: Docker containers run process as `root` inside container namespace.
- **Production Improvement**: Define non-root execution user inside Dockerfiles (`USER 10001`).

### 3. Missing Image Vulnerability Scanning
- **Current Risk**: Base images might contain unpatched CVE vulnerabilities.
- **Production Improvement**: Integrate `Trivy` or `Docker Scout` scans into CI/CD pipeline.

### 4. Unencrypted Database Backups
- **Current Risk**: Dump files in `./backups/` are unencrypted standard SQL files.
- **Production Improvement**: Encrypt backup dumps using `GPG` or AES-256 before disk write.

### 5. Lack of Rate Limiting on Reverse Proxy
- **Current Risk**: Nginx proxy is vulnerable to HTTP flood / DoS attempts.
- **Production Improvement**: Configure `limit_req_zone` in `nginx.conf` to throttle request bursts.

### 6. Storage Volume Persistence & Loss Risks
- **Current Risk**: Host volume data isn't replicated offsite.
- **Production Improvement**: Implement automated EBS snapshotting / S3 sync for backups.

### 7. Application Log Data Sensitivity
- **Current Risk**: Logs may output sensitive SQL queries or user input payload.
- **Production Improvement**: Implement structured JSON logging with log masking filters.

### 8. Network Exposure Perimeter
- **Current Status (Good)**: Backend & DB ports strictly isolated from host interfaces.
- **Production Improvement**: Enforce strict firewall rules (Security Groups) and MTLS between services.
