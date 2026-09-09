# Log Analysis & Traffic Pattern Inspection

## Useful Log Analysis Commands
- **View Nginx Traffic Logs**:
  `docker compose logs nginx`
- **Count Total Requests Handled**:
  `docker compose logs nginx | grep "GET /" | wc -l`
- **Filter Backend Distribution**:
  `docker compose logs app-01 | grep "200 OK" | wc -l`
  `docker compose logs app-02 | grep "200 OK" | wc -l`

## Traffic Insights & Findings
- **Request Distribution**: Load is distributed evenly across `app-01` and `app-02` via Nginx round-robin balancing.
- **Avoiding Double-Counting**: Filtered HTTP request logs by unique client request IDs and upstream log entries rather than raw container stdout metrics.
