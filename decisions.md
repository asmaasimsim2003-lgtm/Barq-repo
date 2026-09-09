# Architectural & Design Decisions

## Decision 1: Dual Bridge Network Strategy
- **Decision**: Separate frontend/proxy network (`app-network`) from data storage network (`db-network`).
- **Alternatives Considered**: Single flat network for all containers.
- **Trade-offs**: Slightly more complex Compose file vs. superior security isolation (Nginx cannot directly touch DB/Redis).

## Decision 2: Automated Pre-Restore Table Dropping
- **Decision**: Add `DROP TABLE IF EXISTS` inside `restore.sh` script.
- **Alternatives Considered**: Re-creating the entire Postgres container before restore.
- **Trade-offs**: Faster execution time and lower memory footprint, though destructive if run accidentally on wrong environment.

## Decision 3: Custom Bounded Wait Validation Script
- **Decision**: Implement `validate.py` with bounded timeouts and explicit HTTP status code checks.
- **Alternatives Considered**: Relying solely on `docker inspect` health status.
- **Trade-offs**: Requires Python environment runtime, but delivers precise application-level verification.

## Decision 4: GitHub Actions Automated CI Pipeline
- **Decision**: Run Docker Compose validation, build, and Python test scripts on every `push` and `pull_request`.
- **Alternatives Considered**: Manual pre-commit bash validation hooks.
- **Trade-offs**: Consumes GitHub runner compute minutes, but guarantees standard baseline testing on clean environments.

## Decision 5: Non-Exposed Backend Host Ports
- **Decision**: Keep `app-01`, `app-02`, `postgres`, and `redis` ports unmapped to the host system.
- **Alternatives Considered**: Exposing port `5000`, `5432`, `6379` to localhost.
- **Trade-offs**: Limits direct local host access (requires `docker exec`), but strictly enforces network perimeter security.
