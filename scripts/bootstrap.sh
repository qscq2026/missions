#!/bin/bash
# missions/scripts/bootstrap.sh
# Optional: Run once to set up the missions runtime environment

set -e

MISSIONS_DIR=".missions"

echo "🚀 Missions Bootstrap"

# Create runtime directories
for dir in 00-orchestrate 01-contract 02-ready 03-running 04-review 05-done 06-fix 07-pr 08-merged archive; do
    mkdir -p "${MISSIONS_DIR}/${dir}"
    touch "${MISSIONS_DIR}/${dir}/.gitkeep"
done

# Create logs subdirectories for audit trail and experience
for logdir in audit metrics experience/patterns experience/anti-patterns experience/fixes; do
    mkdir -p "${MISSIONS_DIR}/logs/${logdir}"
    touch "${MISSIONS_DIR}/logs/${logdir}/.gitkeep"
done

# Copy config template if not exists
if [ ! -f "${MISSIONS_DIR}/config.yaml" ]; then
    echo "Creating default config.yaml..."
    cat > "${MISSIONS_DIR}/config.yaml" << 'EOF'
project:
  name: "my-project"
  language: "python"
  framework: ""

roles:
  worker:
    enforce_tdd: true
    min_coverage: 80

  validator:
    strict_mode: true
EOF
fi

echo "✅ Missions runtime ready at ${MISSIONS_DIR}/"
echo ""
echo "Next steps:"
echo "  1. Edit ${MISSIONS_DIR}/config.yaml"
echo "  2. Invoke the missions skill in your agent"
