# BARQ Academy - DevOps Assessment (Part 1 to 4)

## Architecture Overview
The system consists of a high-availability microservices infrastructure:
- **Nginx**: Reverse proxy and load balancer (Exposed on host port `8080`).
- **App 01 & App 02**: Flask/Python backends (Internal `app-network` only).
- **PostgreSQL**: Primary persistent database (Internal `db-network`).
- **Redis**: Cache and state storage (Internal `db-network`).

## Quick Start Commands

### Build & Start System
docker compose up -d --build

### Check System Status
docker compose ps

### Validate Infrastructure
python3 validate.py

### Run Failure Test (High Availability Verification)
./failure_test.sh

### Backup & Restore PostgreSQL
# Take Backup
./backup.sh
# Restore Backup
./restore.sh ./backups/postgres_backup_YYYYMMDD_HHMMSS.sql

### Clean Up Environment
docker compose down -v

## Critical Architectural Questions
- **How requests flow**: Traffic arrives at Nginx on host port 8080, which proxies requests round-robin to app-01 and app-02 over the isolated app-network. Backends communicate with PostgreSQL and Redis over db-network.
- **Why these readiness checks**: Health checks ensure services (especially PostgreSQL/Redis) accept socket connections before application containers attempt DB migrations/reads.
- **What green CI proves (and doesn't prove)**:
  - **Proves**: Syntactical validity, clean build environment, zero service startup failures, successful health check responses.
  - **Does NOT prove**: System resilience under long-term memory leaks, stress/load traffic scalability, or zero-day security vulnerabilities.
- **Remaining Single Points of Failure (SPOF)**:
  - Single Nginx instance.
  - Single PostgreSQL primary instance.
  - **Production Fix**: Deploy Nginx behind an AWS ALB/HAProxy cluster and convert PostgreSQL to a Primary/Replica cluster (e.g., AWS RDS Multi-AZ).
