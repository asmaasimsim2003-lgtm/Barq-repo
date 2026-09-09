# Troubleshooting & Investigation Journal

## Incident 1: Nginx 502 Bad Gateway / Network Isolation Conflict
- **Root Cause**: Nginx was unable to route requests to app instances due to misconfigured upstream hostname resolution and network bridging.
- **Failed Attempt**: Binding backend containers directly to host `127.0.0.1` ports.
- **Learned Lesson**: Direct host port mapping breaks network isolation requirements and bypasses Nginx proxying.
- **Resolution**: Connected Nginx and Backends on a dedicated Docker bridge network (`app-network`) and referenced service names (`app-01`, `app-02`) in Nginx upstream settings.

## Incident 2: Host Port Exposure Violation (Security & Isolation)
- **Root Cause**: Initially, backend applications and databases had mapped ports (e.g., `5000:5000`, `5432:5432`), violating the requirement that backends must not be accessible via host ports.
- **Failed Attempt**: Testing the API directly via `http://localhost:5000` bypassing the load balancer.
- **Learned Lesson**: Only the reverse proxy should be exposed to the host. Internal services must communicate purely over Docker networks.
- **Resolution**: Removed all `ports:` directives from `app-01`, `app-02`, `postgres`, and `redis` in the `docker-compose.yml`. Only Nginx exposes port `8080:80`.

## Incident 3: Application Crash on Startup (Race Condition)
- **Root Cause**: `app-01` and `app-02` started faster than `postgres` and `redis`. When the apps tried to connect, the DB was still initializing, causing the apps to crash and exit.
- **Failed Attempt**: Hardcoding a `sleep 10` command inside the application startup script.
- **Learned Lesson**: Static sleeps are unreliable. Docker Compose needs native dependency management based on actual service health.
- **Resolution**: Added `healthcheck` to `postgres` and `redis`, and configured the apps with `depends_on: condition: service_healthy` to ensure they wait gracefully.

## Incident 4: PostgreSQL Restore Constraint Violations (`records` Table Conflict)
- **Root Cause**: Running `pg_dump` restore on an active database threw `relation "records" already exists` and key duplication errors.
- **Failed Attempt**: Executing `psql < backup.sql` directly without resetting existing schema.
- **Learned Lesson**: PostgreSQL dumps do not drop existing schemas by default unless explicitly instructed or pre-cleared.
- **Resolution**: Updated `restore.sh` to include `DROP TABLE IF EXISTS records CASCADE;` prior to importing the SQL dump.

## Incident 5: Script Execution Permission Denied
- **Root Cause**: Attempting to run `./validate.py` or `./failure_test.sh` resulted in a `Permission denied` OS error.
- **Resolution**: Executed `chmod +x *.sh validate.py` to grant executable permissions to all automation scripts.

## Incident 6: High Availability Verification during App Failure
- **Root Cause**: Needed proof that killing `app-01` does not cause downtime for end-users.
- **Verification Method**: Created `failure_test.sh` to execute continuously against `http://localhost:8080/records` while manually stopping `app-01`.
- **Outcome**: Verified 100% success rate as Nginx automatically redirected 100% of incoming traffic to `app-02` without dropping connections.
