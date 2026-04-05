#!/bin/bash
# /automotive vmodel-hrtft-kickoff
# Starts a complete V-model development session for a Generic Hard Real-Time Fault-Tolerant System
#
# Usage: /automotive vmodel-hrtft-kickoff [domain] [integrity_level] [system_name]
#   domain:           generic | aerospace | medical | industrial | automotive (default: generic)
#   integrity_level:  SIL-1 | SIL-2 | SIL-3 | SIL-4 (generic)
#                     DAL-E | DAL-D | DAL-C | DAL-B | DAL-A (aerospace)
#                     ASIL-A | ASIL-B | ASIL-C | ASIL-D (automotive)
#                     Class-A | Class-B | Class-C (medical)
#   system_name:      Name of the system under development (default: "HRTFT System")
#
# Example: /automotive vmodel-hrtft-kickoff generic SIL-4 "Engine Control Unit"
# Example: /automotive vmodel-hrtft-kickoff aerospace DAL-A "Flight Control Computer"
# Example: /automotive vmodel-hrtft-kickoff medical Class-C "Infusion Pump Controller"

DOMAIN=${1:-generic}
INTEGRITY_LEVEL=${2:-SIL-3}
SYSTEM_NAME=${3:-"HRTFT System"}

echo "============================================================"
echo "  HARD REAL-TIME FAULT-TOLERANT V-MODEL DEVELOPMENT"
echo "  System: ${SYSTEM_NAME}"
echo "  Domain: ${DOMAIN} | Integrity Level: ${INTEGRITY_LEVEL}"
echo "============================================================"
echo ""
echo "This session will guide you through the complete V-model:"
echo ""
echo "LEFT SIDE (Development)"
echo "  Phase 1: Hazard & Risk Analysis"
echo "    Agent: hazard-risk-analyst"
echo "    Goal: Identify hazards, assign ${INTEGRITY_LEVEL} to safety functions"
echo "    Key output: Hazard log + Safety goals"
echo ""
echo "  Phase 2: System Requirements"
echo "    Agent: sys-requirements-engineer"
echo "    Goal: Define SRS with timing budgets and fault tolerance requirements"
echo "    Key output: SRS + FTTI budgets"
echo ""
echo "  Phase 3: Software Requirements"
echo "    Agent: sys-requirements-engineer"
echo "    Goal: Decompose system requirements to software level"
echo "    Key output: SwRS with integrity level per function"
echo ""
echo "  Phase 4: Software Architecture"
echo "    Agents: rt-software-architect + fault-tolerance-architect"
echo "    Goal: Schedulable task model + FDIR design + redundancy architecture"
echo "    Key output: SAS + SCHED analysis + FDIR design"
echo ""
echo "  Phase 5: Detailed Design & Code"
echo "    Agent: safety-engineer (with coding rules: hrtft-coding-rules)"
echo "    Goal: Implement to RT-RULE-001 through RT-RULE-012"
echo "    Key output: Source code + static analysis reports"
echo ""
echo "RIGHT SIDE (Verification)"
echo "  Phase 6: Unit Verification"
echo "    Agents: unit-verification-engineer + wcet-analyst"
echo "    Goal: Achieve coverage target, verify WCET, fault injection at unit level"
echo "    Coverage target for ${INTEGRITY_LEVEL}:"
case $INTEGRITY_LEVEL in
  "SIL-4"|"DAL-A"|"ASIL-D")
    echo "    -> 100% MC/DC + 100% branch + 100% statement";;
  "SIL-3"|"DAL-B"|"ASIL-C")
    echo "    -> 100% MC/DC + 100% branch";;
  "SIL-2"|"DAL-C"|"ASIL-B")
    echo "    -> 100% branch coverage";;
  *)
    echo "    -> 100% statement coverage";;
esac
echo ""
echo "  Phase 7: Software Integration Testing"
echo "    Agents: integration-verification-engineer + sil-test-engineer"
echo "    Goal: Interface testing, switchover timing, fault propagation"
echo "    Key output: SITS + E2E timing measurements"
echo ""
echo "  Phase 8: System Validation"
echo "    Agents: system-validation-engineer + hil-test-engineer"
echo "    Goal: FTTI compliance, fault tolerance, safety case closure"
echo "    Key output: SVTS + FTTI evidence + safety case package"
echo ""
echo "============================================================"
echo "PHASE GATES ACTIVE:"
echo "  Each phase must satisfy its gate checklist before proceeding"
echo "  Traceability chain: hazard -> safety goal -> SRS -> SwRS ->"
echo "                      SAS -> code -> unit test -> integ test ->"
echo "                      sys validation"
echo "============================================================"
echo ""
echo "To start Phase 1, use:"
echo "  claude "Using hazard-risk-analyst, perform hazard analysis for [${SYSTEM_NAME}]""
echo "  Provide the system concept description and operational profile."
echo ""
echo "To start Phase 4 architecture, use:"
echo "  claude "Using rt-software-architect and fault-tolerance-architect, design the""
echo "         "RTOS task model and FDIR for [${SYSTEM_NAME}] at ${INTEGRITY_LEVEL}""
echo ""
echo "To start Phase 6 unit verification, use:"
echo "  claude "Using unit-verification-engineer, design unit tests achieving""
echo "         "${INTEGRITY_LEVEL} coverage for function [function_name]""
echo ""
echo "To run the full workflow, use:"
echo "  claude "Using vmodel-hrtft workflow, develop [${SYSTEM_NAME}] from""
echo "         "requirements to validated system at ${INTEGRITY_LEVEL}""
