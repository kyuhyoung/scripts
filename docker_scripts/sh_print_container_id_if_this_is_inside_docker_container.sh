# Check if this is inside a docker containier
# If so, the container ID such as "8b89729774cceb78289ef8a5ce1321d81bb29ff25c1c3e1840ff29d49c3564f6" would be printed.
# Otherwise, nothing will be printed.
awk -F/ '$2 == "docker"' /proc/self/cgroup | head -n 1 | xargs basename
