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

# Copy seed experiences if experience directory is empty
SKILL_DIR="$(cd "$(dirname "$0")/.." && pwd)"
EXP_DIR="${MISSIONS_DIR}/logs/experience"
SEED_DIR="${SKILL_DIR}/references/examples/experience"

if [ -d "${SEED_DIR}" ] && [ -z "$(ls -A "${EXP_DIR}/patterns" "${EXP_DIR}/anti-patterns" "${EXP_DIR}/fixes" 2>/dev/null | grep -v '.gitkeep')" ]; then
    echo "Seeding experience library..."
    cp "${SEED_DIR}/INDEX.md" "${EXP_DIR}/INDEX.md"
    for f in "${SEED_DIR}/patterns"/EXP-*.md; do [ -f "$f" ] && cp "$f" "${EXP_DIR}/patterns/"; done
    for f in "${SEED_DIR}/anti-patterns"/EXP-*.md; do [ -f "$f" ] && cp "$f" "${EXP_DIR}/anti-patterns/"; done
    for f in "${SEED_DIR}/fixes"/EXP-*.md; do [ -f "$f" ] && cp "$f" "${EXP_DIR}/fixes/"; done
    echo "  → $(ls ${EXP_DIR}/patterns ${EXP_DIR}/anti-patterns ${EXP_DIR}/fixes 2>/dev/null | grep -c EXP) seed experience(s) loaded"
fi

# Copy contract template reference to 01-contract/ for Orchestrator
SKILL_DIR="$(cd "$(dirname "$0")/.." && pwd)"
CONTRACT_TEMPLATE="${SKILL_DIR}/assets/contract-template.md"
if [ -f "${CONTRACT_TEMPLATE}" ] && [ ! -f "${MISSIONS_DIR}/01-contract/contract-template.md" ]; then
    cp "${CONTRACT_TEMPLATE}" "${MISSIONS_DIR}/01-contract/contract-template.md"
    echo "  → contract-template.md copied to 01-contract/"
fi

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
