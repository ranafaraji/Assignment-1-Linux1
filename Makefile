.PHONY: all setup run verify clean

TMP_DIR := tmp
PROJECT_DIR := /$(TMP_DIR)/project
ARCHIVE_NAME := backup_$(shell date +%Y%m%d).tar.gz

all: verify

setup:
	@echo "Setting up environment..."
	mkdir -p $(PROJECT_DIR)/data $(PROJECT_DIR)/scripts $(PROJECT_DIR)/logs $(PROJECT_DIR)/backup
	@echo "Environment setup complete."

run: setup
	@echo "Running assignment script..."
	chmod +x src/lab1.sh
	./src/lab1.sh
	@echo "Script execution complete."

verify: run
	@echo "Verifying script output..."
	if [ ! -d "$(PROJECT_DIR)" ]; then echo "Directory 'project' does not exist"; exit 1; fi
	if [ ! -d "$(PROJECT_DIR)/data" ]; then echo "Directory 'data' does not exist in 'project'"; exit 1; fi
	if [ ! -d "$(PROJECT_DIR)/scripts" ]; then echo "Directory 'scripts' does not exist in 'project'"; exit 1; fi
	if [ ! -d "$(PROJECT_DIR)/logs" ]; then echo "Directory 'logs' does not exist in 'project'"; exit 1; fi
	if [ ! -d "$(PROJECT_DIR)/backup" ]; then echo "Directory 'backup' does not exist in 'project'"; exit 1; fi
	if [ ! -f "$(PROJECT_DIR)/data/file1.txt" ]; then echo "Expected file 'data/file1.txt' was not created"; exit 1; fi
	if [ ! -f "$(PROJECT_DIR)/data/file3_renamed.txt" ]; then echo "Expected file 'data/file3_renamed.txt' was not created"; exit 1; fi
	if [ ! -f "$(PROJECT_DIR)/logs/file4.txt" ]; then echo "Expected file 'logs/file4.txt' was not moved"; exit 1; fi
	if [ ! -f "$(PROJECT_DIR)/logs/file5.txt" ]; then echo "Expected file 'logs/file5.txt' was not moved"; exit 1; fi
	if [ -e "$(PROJECT_DIR)/data/file2.txt" ]; then echo "File 'data/file2.txt' should have been deleted"; exit 1; fi
	if [ ! -f "$(PROJECT_DIR)/backup/file1.txt" ]; then echo "Expected backup copy 'backup/file1.txt' was not created"; exit 1; fi
	if [ ! -f "$(PROJECT_DIR)/backup/$(ARCHIVE_NAME)" ]; then echo "Expected backup archive 'backup/$(ARCHIVE_NAME)' was not created"; exit 1; fi
	if [ ! -L "$(PROJECT_DIR)/scripts/file1_link.txt" ]; then echo "Expected symbolic link 'scripts/file1_link.txt' was not created"; exit 1; fi
	if [ "$$(readlink "$(PROJECT_DIR)/scripts/file1_link.txt")" != "../backup/file1.txt" ]; then echo "Symbolic link does not point to the expected target"; exit 1; fi
	# macOS-compatible permission/ownership checks
	# Use stat -f on macOS; fall back to stat -c on GNU systems
	perms=$$(if stat -f '%A' "$(PROJECT_DIR)/backup/file1.txt" >/dev/null 2>&1; then stat -f '%A' "$(PROJECT_DIR)/backup/file1.txt"; else stat -c '%a' "$(PROJECT_DIR)/backup/file1.txt"; fi); \
	if [ "$$perms" != "644" ]; then echo "Permission for 'backup/file1.txt' is not 644"; exit 1; fi
	perms=$$(if stat -f '%A' "$(PROJECT_DIR)/data/file3_renamed.txt" >/dev/null 2>&1; then stat -f '%A' "$(PROJECT_DIR)/data/file3_renamed.txt"; else stat -c '%a' "$(PROJECT_DIR)/data/file3_renamed.txt"; fi); \
	if [ "$$perms" != "644" ]; then echo "Permission for 'data/file3_renamed.txt' is not 644"; exit 1; fi
	# Ownership check: only enforce when running as root; skip otherwise (macOS users)
	if [ "$$(id -u)" -ne 0 ]; then \
		echo "Skipping ownership check: not running as root"; \
	else \
		owner=$$(if stat -f '%Su:%Sg' "$(PROJECT_DIR)/logs/file4.txt" >/dev/null 2>&1; then stat -f '%Su:%Sg' "$(PROJECT_DIR)/logs/file4.txt"; else stat -c '%U:%G' "$(PROJECT_DIR)/logs/file4.txt"; fi); \
		if [ "$$owner" != "nobody:nogroup" ]; then echo "Ownership for 'logs/file4.txt' is not nobody:nogroup"; exit 1; fi; \
	fi
	if [ ! -f "$(PROJECT_DIR)/README.md" ]; then echo "Expected completion log 'README.md' was not created"; exit 1; fi
	if ! grep -q "Assignment completed" "$(PROJECT_DIR)/README.md"; then echo "Completion log message is missing from 'README.md'"; exit 1; fi
	@echo "Verification complete."

clean:
	@echo "Cleaning up..."
	rm -rf $(PROJECT_DIR)
	@echo "Cleanup complete."
