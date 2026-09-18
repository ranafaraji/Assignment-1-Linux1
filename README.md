# Lab 1: Linux Commands and File System Operations Assignment

## Purpose

This GitHub Classroom exercise is meant to help students practice essential Linux shell operations in a reproducible way. The assignment uses a starter script with placeholders so students can implement the required commands themselves.

Students should demonstrate competency in:

- Creating and managing directory structures
- Creating, copying, moving, renaming, and deleting files
- Adjusting file permissions and ownership
- Creating symbolic links
- Inspecting filesystem usage and process information
- Creating a compressed backup archive
- Writing a completion log entry

## Assignment Structure

- `src/lab1.sh`: starter script with placeholder sections for the Linux commands you must write
- `Makefile`: setup, execution, and grading targets
- `.github/workflows/test.yml`: GitHub Actions job that runs the automated checks

## Required Work

Complete the tasks in `src/lab1.sh` by replacing each `# TODO:` placeholder with the correct Linux command(s).

The script is expected to:

1. Create the `project` directory structure with `data`, `scripts`, `logs`, and `backup`
2. Create five initial files in `project/data` with sample content
3. Copy `file1.txt` into `project/backup`
4. Rename `file3.txt` to `file3_renamed.txt`
5. Move `file4.txt` and `file5.txt` into `project/logs`
6. Delete `file2.txt` from `project/data`
7. Display detailed directory listings and size information
8. Set permissions and ownership on the required files
9. Create a symbolic link in `project/scripts`
10. Display disk usage and process information
11. Create a dated backup archive under `project/backup`
12. Write a completion message to `project/README.md`
13. Verify that `project/data` exists at the end and exit with an error if it does not

## Make Targets

- `make setup`: creates the expected directory layout
- `make run`: runs `src/lab1.sh`
- `make verify`: runs the assignment and checks the required filesystem, permissions, ownership, link, archive, and log results
- `make all`: runs the full verification flow
- `make clean`: removes the temporary project directory

## GitHub Classroom Notes

- Do not replace the file names or directory names that are already specified in the assignment.
- Keep the script executable (`chmod +x src/lab1.sh`).
- Use placeholders only where the assignment explicitly asks for them.
- The grader is intentionally strict: the verification target checks the expected result of each task.

## Local Validation

Run the following commands locally before submitting:

```bash
make all
```

The above command should complete successfully only after you have implemented the required Linux commands in `src/lab1.sh`.
