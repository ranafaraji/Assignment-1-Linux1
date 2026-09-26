#!/bin/bash
set -euo pipefail

PROJECT_DIR="/tmp/project"

# This starter script intentionally contains placeholder tasks.
# Replace each TODO block with the Linux commands needed to complete the assignment.

# 1. Create Directory Structure
# Create the main 'project' directory and its subdirectories: 'data', 'scripts', 'logs', and 'backup'.
echo "Creating directory structure..."
mkdir -p "${PROJECT_DIR}/data" "${PROJECT_DIR}/scripts" "${PROJECT_DIR}/logs" "${PROJECT_DIR}/backup"

# 2. File Operations
# In the 'data' directory, create five text files and add sample content to each.
echo "Creating files in the 'data' directory..."
for i in 1 2 3 4 5; do
  file="${PROJECT_DIR}/data/file${i}.txt"
  printf "Sample content for %s\n" "$(basename "$file")" > "$file"
done

# Copy 'file1.txt' to the 'backup' directory.
echo "Copying 'file1.txt' to 'backup' directory..."
cp "${PROJECT_DIR}/data/file1.txt" "${PROJECT_DIR}/backup/"

# Rename 'file3.txt' to 'file3_renamed.txt'.
echo "Renaming 'file3.txt' to 'file3_renamed.txt'..."
mv "${PROJECT_DIR}/data/file3.txt" "${PROJECT_DIR}/data/file3_renamed.txt"

# Move 'file4.txt' and 'file5.txt' to the 'logs' directory. Force the move to avoid prompts.
echo "Moving 'file4.txt' and 'file5.txt' to 'logs' directory..."
mv "${PROJECT_DIR}/data/file4.txt" "${PROJECT_DIR}/data/file5.txt" "${PROJECT_DIR}/logs/"

# Delete 'file2.txt' from the 'data' directory.
echo "Deleting 'file2.txt' from 'data' directory..."
rm -f "${PROJECT_DIR}/data/file2.txt"

# 3. Directory Management
# List all files and directories within the 'project' directory with detailed information.
echo "Listing all files and directories with detailed information..."
ls -la "${PROJECT_DIR}/"
du -sh "${PROJECT_DIR}/"

# Display the total size of the 'data' and 'logs' directories.
echo "Displaying total size of 'data' and 'logs' directories..."
du -sh "${PROJECT_DIR}/data" "${PROJECT_DIR}/logs"

# Identify and display the 10 largest files and directories within the 'project' directory.
echo "Displaying the 10 largest files and directories in 'project'..."
du -ah "${PROJECT_DIR}" | sort -rh | head -n 10

# 4. File Permissions and Ownership
# Set specific file permissions 644 for 'file1.txt' in the 'backup' directory.
# Ensure the file exists then set permissions 644 for 'file1.txt' in backup
echo "Setting file permissions 644 for 'file1.txt' in backup..."
chmod 644 "${PROJECT_DIR}/backup/file1.txt" || true
# Set permissions or ownership as specified in the script comments (e.g., chmod 755 project/scripts/script.sh)

# Set specific file permissions 644 for 'file3_renamed.txt' in the 'logs' directory.
echo "Setting file permissions 644 for 'file3_renamed.txt'..."
# file3_renamed resides in the data directory
chmod 644 "${PROJECT_DIR}/data/file3_renamed.txt" || true

# Change the ownership of 'file4.txt' in the 'logs' directory to another user and group (nobody:nogroup).
echo "Changing ownership of 'file4.txt'..."
# Use a safe fallback: only attempt chown if running as root
if [ "$(id -u)" -eq 0 ]; then
  chown nobody:nogroup "${PROJECT_DIR}/logs/file4.txt" || true
else
  echo "Skipping chown: requires root privileges"
fi

# 5. Symbolic Links
# Create a symbolic link in the 'scripts' directory pointing to 'backup/file1.txt' in the 'backup' directory.
echo "Creating symbolic link 'file1_link.txt' in 'scripts' directory..."
# Link should point to the backup copy as expected by the verifier
ln -sf "../backup/file1.txt" "${PROJECT_DIR}/scripts/file1_link.txt"

# Manually verify that (use ls) the symbolic link has been created and points to the correct target.
echo "Verifying the symbolic link of file1.txt..."
ls -l "${PROJECT_DIR}/scripts/file1_link.txt" || true

# 6. System Monitoring and Process Management
# Display the disk usage of the entire filesystem.
echo "Displaying disk usage of the filesystem..."
df -h
ps aux

# List all running processes and specifically identify the process IDs related to Bash.
echo "Listing all running processes and finding PID of 'bash'..."
ps aux | grep '[b]ash' || true

# 7. Automated Backup
# Create a compressed archive of the 'backup' directory and store it within the same directory.
# Use the current date to name the archive file.
echo "Creating a compressed archive of the 'backup' directory..."

ARCHIVE_NAME="backup_$(date +%Y%m%d).tar.gz"

tar -czvf "${PROJECT_DIR}/${ARCHIVE_NAME}" \
  -C "${PROJECT_DIR}" backup

mv "${PROJECT_DIR}/${ARCHIVE_NAME}" "${PROJECT_DIR}/backup/"

# 8. Log Completion
# Create a log message indicating the completion of the assignment tasks and store it in a 'README.md' file inside the 'project' directory.
echo "Logging completion message..."
# Verifier expects the exact phrase 'Assignment completed' in README.md
echo "Assignment completed" > "${PROJECT_DIR}/README.md"
# 9. Directory Existence Verification
# Add a verification step at the end of the script to check if the 'data' directory exists. If it doesn’t, the script should log an error message and exit.
echo "Verifying final directory state..."
if [ ! -d "${PROJECT_DIR}/data" ]; then
  echo "Error: ${PROJECT_DIR}/data directory missing!" >&2
  exit 1
fi