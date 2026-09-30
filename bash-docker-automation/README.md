## bash-docker-automation

**Folder:** `bash-docker-automation/`
**File:** `flask_mariadb_test.sh` (only file — everything else is generated at runtime)

A single self-contained bash script that:
1. Creates a custom Docker network
2. Starts MariaDB
3. Waits for readiness
4. Generates a `Dockerfile` + `app.py` in a temp dir, builds the Flask image
5. Runs the Flask container
6. Tests Flask → MariaDB
7. Cleans up containers, network, image, and the temp dir

### Run
```bash
cd bash-docker-automation
chmod +x flask_mariadb_test.sh
./flask_mariadb_test.sh
