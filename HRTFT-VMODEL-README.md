# HRTFT V-Model Agents
## Hard Real-Time Fault-Tolerant System — V-Model Development Framework for Claude Code

> **Branch:** `hrtft-vmodel-agents` | **Base repo:** `AI-Maddy/automotive-claude-code-agents`

---

## Table of Contents

1. [Why This Exists](#1-why-this-exists)
2. [What's Inside](#2-whats-inside)
3. [How It Works — Architecture Overview](#3-how-it-works--architecture-overview)
4. [The V-Model Lifecycle](#4-the-v-model-lifecycle)
5. [Agent Reference](#5-agent-reference)
   - [sys-requirements-engineer](#51-sys-requirements-engineer)
   - [rt-software-architect](#52-rt-software-architect)
   - [wcet-analyst](#53-wcet-analyst)
   - [fault-tolerance-architect](#54-fault-tolerance-architect)
   - [unit-verification-engineer](#55-unit-verification-engineer)
   - [integration-verification-engineer](#56-integration-verification-engineer)
   - [system-validation-engineer](#57-system-validation-engineer)
6. [Workflow Reference](#6-workflow-reference)
7. [Coding Rules Reference](#7-coding-rules-reference)
8. [Kickoff Command](#8-kickoff-command)
9. [Quick Start — How to Use](#9-quick-start--how-to-use)
10. [Usage Examples](#10-usage-examples)
11. [Standards Coverage](#11-standards-coverage)
12. [Phase Gate Checklist](#12-phase-gate-checklist)
13. [Extending the Framework](#13-extending-the-framework)
14. [FAQ](#14-faq)

---

## 1. Why This Exists

Developing software for **hard real-time fault-tolerant (HRTFT) systems** — medical devices, railway control, avionics, industrial safety controllers, autonomous systems — is fundamentally different from conventional software development. Every missed deadline is a safety failure. Every undetected fault can cascade into a catastrophic event.

The V-model is the industry-standard development lifecycle mandated or strongly recommended by IEC 61508, DO-178C, EN 50128, IEC 62304, and ISO 26262. But applying it correctly requires deep, simultaneous expertise in:

- Real-time scheduling theory (RMA, EDF, WCET analysis)
- Functional safety standards and SIL/ASIL allocation
- Fault detection, containment, and safe-state design
- Rigorous test coverage (MC/DC, fault injection, boundary analysis)
- Evidence traceability from requirements through validation

This framework turns **Claude Code into a team of seven specialist safety engineers**, each owning a distinct V-model phase, with enforced phase gates, safety evidence generation, and a shared coding standard — all in your existing Claude Code workspace.

---

## 2. What's Inside

```
hrtft-vmodel-agents branch
│
├── agents/vmodel/                          ← 7 specialist agent definitions
│   ├── sys-requirements-engineer.yaml      Left arm: system requirements
│   ├── rt-software-architect.yaml          Left arm: real-time architecture
│   ├── wcet-analyst.yaml                   Left arm: timing analysis
│   ├── fault-tolerance-architect.yaml      Left arm: fault tolerance design
│   ├── unit-verification-engineer.yaml     Right arm: unit testing
│   ├── integration-verification-engineer.yaml  Right arm: integration testing
│   └── system-validation-engineer.yaml     Right arm: system validation
│
├── workflows/vmodel-hrtft/
│   └── vmodel-hrtft-workflow.yaml          Full V-model workflow orchestration
│
├── rules/
│   └── hrtft-coding-rules.md               HRTFT coding standard (MISRA, RT, FT)
│
└── commands/automotive/
    └── vmodel-hrtft-kickoff.sh             One-command project bootstrap
```

**Component counts:**

| Type | Count | Description |
|------|-------|-------------|
| Agents | 7 | Specialist personas for each V-model phase |
| Workflows | 1 | End-to-end V-model lifecycle orchestrator |
| Rule sets | 1 | HRTFT coding standard (7 rule categories, 35+ rules) |
| Commands | 1 | Bootstrap / kickoff command |

---

## 3. How It Works — Architecture Overview

```
┌─────────────────────────────────────────────────────────────────────┐
│                         Claude Code CLI                             │
│                                                                     │
│  claude "Using <agent-name>, <your task>"                           │
│                          │                                          │
│                          ▼                                          │
│         ┌─────────────────────────────┐                             │
│         │   agents/vmodel/<agent>.yaml│                             │
│         │   • role & domain context   │                             │
│         │   • applicable standards    │                             │
│         │   • SIL/ASIL integrity lvls │                             │
│         │   • capabilities list       │                             │
│         │   • workflow steps          │                             │
│         │   • guidelines & rules      │                             │
│         │   • expected deliverables   │                             │
│         │   • recommended tools       │                             │
│         └──────────────┬──────────────┘                             │
│                        │  grounds Claude's responses in             │
│                        │  safety-engineering domain expertise       │
│                        ▼                                            │
│         ┌─────────────────────────────┐                             │
│         │  hrtft-coding-rules.md      │  enforces language subset,  │
│         │  (active rules context)     │  RT constraints, FT rules   │
│         └──────────────┬──────────────┘                             │
│                        │                                            │
│                        ▼                                            │
│              Claude generates safety-grade                          │
│              artefacts, code, and evidence                          │
└─────────────────────────────────────────────────────────────────────┘
```

Each **agent YAML** is a structured persona that tells Claude:
- What role it is playing (e.g., "Fault Tolerance Architect")
- Which domain (generic HRTFT — not automotive-specific)
- Which standards apply and at what integrity levels
- What its specific capabilities and workflows are
- What deliverables it must produce
- Which tools are appropriate

The **workflow YAML** orchestrates agents in sequence, enforcing phase gates — Claude cannot proceed to the next phase unless the gate criteria are met and evidenced.

The **coding rules Markdown** provides the enforceable software coding standard that all agents and generated code must comply with.

---

## 4. The V-Model Lifecycle

```
REQUIREMENTS ──────────────────────────────────── VALIDATION
    │                                                  │
    ▼                                                  ▲
[Phase 1]  System Requirements Engineer          [Phase 7]
    │       SRS, SIL/ASIL allocation              System Validation
    │                                              SVP, SVR, safety case
    ▼                                                  ▲
[Phase 2]  RT Software Architect                 [Phase 6]
    │       SADS, timing budget, ICD              Integration Verification
    │                                              ITP, ITR, timing evidence
    ▼                                                  ▲
[Phase 3]  WCET Analyst                          [Phase 5]
    │       WCET report, schedulability           Unit Verification
    │                                              UTP, UTR, MC/DC coverage
    ▼                                                  ▲
[Phase 4]  Fault Tolerance Architect ─────────────────┘
            FTAD, diagnostics, safe-state design
            (informs all verification phases)
```

The left arm (Phases 1–4) is **design and specification**. The right arm (Phases 5–7) is **verification and validation**. Each right-arm phase verifies the output of its corresponding left-arm phase:

| Left Arm | Right Arm |
|----------|-----------|
| Phase 1: System Requirements | Phase 7: System Validation |
| Phase 2: Architectural Design | Phase 6: Integration Verification |
| Phase 3: WCET + Phase 4: FT Design | Phase 5: Unit Verification |

---

## 5. Agent Reference

### 5.1 sys-requirements-engineer

**File:** `agents/vmodel/sys-requirements-engineer.yaml`

**Role:** System Requirements Engineer for HRTFT systems

**What it does:**
- Elicits and analyses system-level safety requirements from customer/operator documents and regulatory obligations
- Allocates safety integrity levels (SIL-1 to SIL-4 / ASIL-A to ASIL-D) to each safety function
- Produces the System Requirements Specification (SRS) with bidirectional traceability to hazard analyses (HARA, HAZOP, FTA)
- Verifies requirements are complete, unambiguous, testable, and consistent

**Key workflows:**
1. `requirements_elicitation` — hazard analysis → safety functions → SIL allocation
2. `requirements_specification` — structure SRS with formal attributes (ID, text, rationale, SIL, verification method)
3. `requirements_review` — peer checklist, consistency check, baseline

**Primary deliverables:**
- System Requirements Specification (SRS)
- Safety functions list with SIL/ASIL targets
- Requirements traceability matrix (RTM) seed

**Applicable standards:** IEC 61508-2/3, DO-178C, EN 50128, IEC 62304, ISO 26262-3

---

### 5.2 rt-software-architect

**File:** `agents/vmodel/rt-software-architect.yaml`

**Role:** Real-Time Software Architect

**What it does:**
- Designs a task-based software architecture that meets hard real-time deadlines and fault-tolerance requirements
- Allocates timing budgets (WCET, response time, hyperperiod) to every task and execution chain
- Designs spatial and temporal partitioning (freedom-from-interference between safety partitions)
- Specifies all inter-component interfaces in Interface Control Documents (ICD)

**Key workflows:**
1. `architecture_design` — decompose SRS into components → assign tasks → define timing budget
2. `timing_budget_allocation` — rate-monotonic or EDF analysis → per-task WCET target → margin tracking
3. `interface_specification` — define all APIs, shared memory regions, message queues

**Primary deliverables:**
- Software Architectural Design Specification (SADS)
- Timing budget table (per task, per execution chain)
- Interface Control Documents (ICD)
- Partitioning and freedom-from-interference (FFI) strategy

**Applicable standards:** IEC 61508-3, DO-178C, EN 50128, IEC 62304, ISO 26262-6

---

### 5.3 wcet-analyst

**File:** `agents/vmodel/wcet-analyst.yaml`

**Role:** WCET (Worst-Case Execution Time) Analyst

**What it does:**
- Analyses source code or binary to determine the maximum possible execution time of every safety-critical function
- Uses static analysis (abstract interpretation, IPET) and measurement-based methods (hardware performance counters)
- Verifies that task WCET ≤ timing budget under worst-case hardware and software load
- Performs Rate-Monotonic Analysis (RMA) or EDF schedulability proofs

**Key workflows:**
1. `wcet_measurement` — instrument code → measure on target → extract critical path
2. `schedulability_analysis` — task set parameters → RMA/EDF utilisation test → response-time analysis
3. `timing_margin_review` — identify tasks near budget limits → risk assessment → architecture feedback

**Primary deliverables:**
- WCET report per function and per task (with confidence bounds)
- Schedulability proof (RMA/EDF utilisation ≤ 1.0)
- Timing margin risk assessment
- Loop and recursion bound annotations (for static WCET tools)

**Applicable standards:** IEC 61508-3, DO-178C Section 6, EN 50128, ISO 26262-6

---

### 5.4 fault-tolerance-architect

**File:** `agents/vmodel/fault-tolerance-architect.yaml`

**Role:** Fault Tolerance Architect

**What it does:**
- Designs the fault detection, isolation, and recovery (FDIR) architecture for the system
- Maps every failure mode from FMEA/FTA to a detection mechanism and mitigation strategy
- Designs redundancy (hot, warm, cold standby), voting mechanisms (2oo2, 2oo3), and safe-state transitions
- Calculates diagnostic coverage (DC) and verifies it meets SIL requirements
- Defines the maximum fault reaction time and safe-state entry sequence

**Key workflows:**
1. `fmea_to_fdir_mapping` — failure mode → detection mechanism → coverage calculation
2. `redundancy_design` — select redundancy strategy → specify data flow → verify independence
3. `safe_state_design` — define safe states → transition sequences → timing requirement

**Primary deliverables:**
- Fault Tolerance Architecture Document (FTAD)
- FMEA → detection mechanism mapping table
- Diagnostic coverage (DC) analysis per SIL
- Safe-state transition design with timing
- Redundancy independence argument

**Applicable standards:** IEC 61508-2/3, DO-178C, EN 50128, IEC 62304, ISO 26262-5/6

---

### 5.5 unit-verification-engineer

**File:** `agents/vmodel/unit-verification-engineer.yaml`

**Role:** Unit Verification Engineer

**What it does:**
- Creates unit test plans from Software Unit Design Specifications
- Generates test vectors using equivalence class partitioning, boundary value analysis, and fault injection
- Achieves and reports structural coverage: MC/DC for SIL-3/4, branch coverage for SIL-1/2
- Measures WCET at function level; compares against allocated timing budget
- Verifies MISRA C / coding rule compliance before unit test execution

**Key workflows:**
1. `unit_test_planning` — parse SUDS → define coverage targets → generate test cases
2. `unit_test_execution` — set up harness → run vectors → measure coverage and WCET
3. `regression_and_review` — rerun on code changes → peer review → formal sign-off

**Coverage targets by integrity level:**

| SIL/ASIL | Minimum Coverage |
|----------|-----------------|
| SIL-1 / ASIL-A | Statement + Branch |
| SIL-2 / ASIL-B | Branch (100%) |
| SIL-3 / ASIL-C | MC/DC |
| SIL-4 / ASIL-D | MC/DC (100%) |

**Primary deliverables:**
- Unit Test Plan (UTP)
- Unit Test Report (UTR) with pass/fail per test case
- MC/DC coverage report (HTML + XML)
- WCET measurement log per function
- Traceability matrix (requirements ↔ test cases)

---

### 5.6 integration-verification-engineer

**File:** `agents/vmodel/integration-verification-engineer.yaml`

**Role:** Integration Verification Engineer

**What it does:**
- Verifies that integrated software components behave correctly at their interfaces
- Tests shared-resource access under maximum contention (mutexes, semaphores, spinlocks)
- Injects faults at interface boundaries and verifies error propagation is contained
- Measures end-to-end response times for critical execution chains on target hardware
- Verifies that fault detection at component boundaries works as designed

**Key workflows:**
1. `integration_test_planning` — map all integration points from SADS/ICD → generate scenarios
2. `integration_test_execution` — deploy on target/HIL → run nominal + fault-injection tests → measure latency
3. `regression_and_review` — rerun after component change → check timing regressions → sign-off

**Primary deliverables:**
- Integration Test Plan (ITP)
- Integration Test Report (ITR)
- End-to-end timing and jitter measurement log
- Fault propagation evidence
- Interface coverage matrix

---

### 5.7 system-validation-engineer

**File:** `agents/vmodel/system-validation-engineer.yaml`

**Role:** System Validation Engineer

**What it does:**
- Validates the complete, integrated system against all system requirements
- Demonstrates that every safety function achieves its required SIL/ASIL in real operating conditions
- Performs hardware fault injection on production hardware to demonstrate fault tolerance
- Measures safe-state entry time under worst-case fault and load conditions
- Produces the safety case contribution and Independent Safety Assessment (ISA) evidence package

**Key workflows:**
1. `system_validation_planning` — map SRS requirements → validation scenarios → acceptance criteria
2. `system_validation_execution` — nominal + degraded + fault-injection scenarios on production HW
3. `safety_case_contribution` — compile SVR + evidence → map to SIL claims → submit for ISA

**Primary deliverables:**
- System Validation Plan (SVP)
- System Validation Report (SVR)
- Safe-state timing evidence
- Fault-tolerance demonstration evidence
- PFH/PFD / diagnostic coverage evidence
- Safety case contribution document
- ISA response package

---

## 6. Workflow Reference

**File:** `workflows/vmodel-hrtft/vmodel-hrtft-workflow.yaml`

The workflow YAML is the **orchestration layer** that ties all seven agents into a governed development process.

### Structure

```yaml
workflow_phases:
  phase_1_system_requirements:   # agent: sys-requirements-engineer
  phase_2_architectural_design:  # agent: rt-software-architect
  phase_3_wcet_analysis:         # agent: wcet-analyst
  phase_4_fault_tolerance_design:# agent: fault-tolerance-architect
  phase_5_unit_verification:     # agent: unit-verification-engineer
  phase_6_integration_verification: # agent: integration-verification-engineer
  phase_7_system_validation:     # agent: system-validation-engineer
```

### Phase Gate Pattern

Every phase has a `gates` section listing **exit criteria** that must be evidenced before advancing:

```yaml
phase_1_system_requirements:
  gates:
    - All hazards mapped to at least one safety function
    - Every safety function assigned a SIL/ASIL target
    - SRS reviewed and baselined
```

Claude will flag any open gate criteria when you ask it to progress to the next phase.

### Cross-Cutting Concerns

The workflow also specifies:

| Concern | Specification |
|---------|---------------|
| **Traceability** | Bidirectional from system requirement → architecture → design → unit test → integration test → system validation |
| **Configuration Management** | GitFlow branching, locked dependency manifest, reproducible builds |
| **Phase Gate Enforcement** | All gate criteria evidenced before advancing; deviations require safety manager approval |
| **Entry Criteria** | Safety plan approved, tool qualification complete, environment version-controlled |
| **Exit Criteria** | All Phase 7 gates passed, safety case ISA-reviewed, no open safety-critical issues |

---

## 7. Coding Rules Reference

**File:** `rules/hrtft-coding-rules.md`

The coding standard is divided into seven rule categories, each with numbered, traceable rules:

### Category Summary

| Category | Prefix | Key Rules |
|----------|--------|-----------|
| **Language Subset** | LANG-xx | MISRA C:2012, no dynamic allocation, no recursion, no setjmp/longjmp |
| **Real-Time Constraints** | RT-xx | Bounded stacks, WCET budget, bounded loops, mutex protection, PCP/PIP |
| **Fault Tolerance** | FT-xx | Input validation, return-value checking, watchdog discipline, memory integrity |
| **Data Integrity** | DATA-xx | CRC protection, volatile + mutex, no implicit conversion, bounds-checked arrays |
| **Modularity & Traceability** | MOD-xx | Single-responsibility modules, structured headers, requirement traceability, cyclomatic complexity ≤ 15 |
| **Build & Config Management** | CM-xx | Reproducible builds, fixed compiler flags, third-party qualification, binary archive |
| **Static Analysis Gates** | SA-xx | Zero MISRA mandatory violations, all required-rule deviations documented, peer review mandatory |

### Selected Critical Rules

```
LANG-02  No dynamic memory allocation (malloc/free/new/delete) after initialisation
LANG-03  No recursion; all call graphs must be acyclic
RT-03    No unbounded loops in safety-critical paths
RT-04    All inter-task shared data protected by mutual exclusion
RT-05    Priority inversion prevented using PCP or PIP
FT-04    Watchdog kicked only after all safety checks pass (no unconditional kicking)
FT-06    Redundant channels must have independent data flows; no shared mutable state
DATA-01  Safety-critical data protected with CRC or parity at rest and in transit
MOD-05   Cyclomatic complexity ≤ 15 (≤ 10 for SIL-3/4 functions)
SA-01    MISRA C:2012 mandatory rules: zero violations permitted
```

---

## 8. Kickoff Command

**File:** `commands/automotive/vmodel-hrtft-kickoff.sh`

Bootstraps a complete HRTFT V-model project scaffold in your working directory.

### What It Creates

```
<project-name>/
├── docs/
│   ├── SRS.md                 System Requirements Specification template
│   ├── SADS.md                Software Architectural Design Specification template
│   ├── WCET-report.md         WCET analysis report template
│   ├── FTAD.md                Fault Tolerance Architecture Document template
│   ├── UTP.md                 Unit Test Plan template
│   ├── ITP.md                 Integration Test Plan template
│   └── SVP.md                 System Validation Plan template
├── src/                       Source code directory
├── tests/
│   ├── unit/
│   ├── integration/
│   └── system/
├── evidence/                  Safety evidence archive
├── .claude/
│   ├── agents/                (symlinks to vmodel agents)
│   └── rules/                 (copy of hrtft-coding-rules.md)
└── CLAUDE.md                  Project-specific Claude Code instructions
```

### Usage

```bash
# From your project root:
bash commands/automotive/vmodel-hrtft-kickoff.sh

# Follow the prompts:
#   Project name: my-hrtft-controller
#   Target SIL level: SIL-3
#   Applicable standard: IEC 61508
```

---

## 9. Quick Start — How to Use

### Prerequisites

- Claude Code CLI installed (`npm install -g @anthropic-ai/claude-code`)
- This branch checked out or the `agents/vmodel/` files copied to your `~/.claude/agents/` directory

### Step 1 — Install the agents

```bash
# Option A: Clone and install from this branch
git clone -b hrtft-vmodel-agents https://github.com/AI-Maddy/automotive-claude-code-agents.git
cd automotive-claude-code-agents
cp -r agents/vmodel ~/.claude/agents/
cp rules/hrtft-coding-rules.md ~/.claude/rules/
cp -r workflows/vmodel-hrtft ~/.claude/workflows/

# Option B: Run the kickoff command (if installed via the main repo installer)
bash commands/automotive/vmodel-hrtft-kickoff.sh
```

### Step 2 — Start at Phase 1: System Requirements

```bash
claude "Using sys-requirements-engineer, analyse this hazard log and produce a System \
Requirements Specification with SIL allocation for a SIL-2 industrial safety controller. \
Hazards: [describe or paste your HAZOP entries]"
```

### Step 3 — Move to Phase 2: Architecture

```bash
claude "Using rt-software-architect, design a task-based software architecture \
for the SIL-2 controller specified in SRS v1.0. The system has four periodic \
tasks: sensor sampling at 1 ms, control law at 5 ms, diagnostics at 10 ms, \
and communication at 100 ms. Produce the SADS and timing budget."
```

### Step 4 — WCET Analysis

```bash
claude "Using wcet-analyst, analyse the attached source code for the control_law() \
function and produce a WCET report. The timing budget is 2.5 ms on a Cortex-M4 \
at 168 MHz. Verify schedulability using Rate-Monotonic Analysis."
```

### Step 5 — Fault Tolerance Design

```bash
claude "Using fault-tolerance-architect, design the FDIR architecture for this \
SIL-2 controller. FMEA results are attached. Target diagnostic coverage: DC Medium \
(≥ 90%). Safe-state entry must complete within 50 ms of fault detection."
```

### Step 6 — Unit Verification

```bash
claude "Using unit-verification-engineer, create a Unit Test Plan for the \
control_law() module. Target coverage is MC/DC (SIL-2 requirement). \
Include fault-injection tests for all defensive error handlers."
```

### Step 7 — Integration Verification

```bash
claude "Using integration-verification-engineer, design integration tests for \
the interface between the control_law task and the safe_state_manager module. \
Include fault injection at the shared-memory interface."
```

### Step 8 — System Validation

```bash
claude "Using system-validation-engineer, create a System Validation Plan for \
the SIL-2 industrial controller. All system requirements from SRS v1.0 must \
be covered. Include fault-tolerance demonstration and safe-state timing \
measurement scenarios."
```

---

## 10. Usage Examples

### Example A — Full V-Model Kickoff (one prompt per phase)

```bash
# Phase 1
claude "Using sys-requirements-engineer, given that our medical infusion pump \
must prevent over-infusion (SIL-3, IEC 62304 Class C), produce the SRS."

# Phase 2
claude "Using rt-software-architect, the pump has a dose-control task (cycle 10 ms), \
alarm monitor (5 ms), and UI update (100 ms). Design the SADS."

# Phase 3
claude "Using wcet-analyst, prove schedulability for this task set on ARM Cortex-M7 \
at 216 MHz. Budget: dose-control 3 ms, alarm 1 ms, UI 20 ms."

# Phase 4
claude "Using fault-tolerance-architect, map the top 5 failure modes from our \
FMEA to detection mechanisms. Target DC High (≥ 99%) for dose-control path."

# Phase 5
claude "Using unit-verification-engineer, produce the UTP for dose_control_law(). \
Required: 100% MC/DC, WCET evidence, all error-handler tests."

# Phase 6
claude "Using integration-verification-engineer, test the interface between \
dose_control_law() and the syringe_driver_hw_abstraction module."

# Phase 7
claude "Using system-validation-engineer, validate that the infusion pump meets \
all SRS safety requirements. Produce the SVP and safety case contribution."
```

### Example B — Code Review Against Coding Standard

```bash
claude "Review the following C function against hrtft-coding-rules.md. \
Check specifically for LANG-02 (no dynamic allocation), RT-03 (bounded loops), \
and FT-02 (return value checking). Report all violations with line numbers.

[paste your C code]"
```

### Example C — WCET Estimation Without Tools

```bash
claude "Using wcet-analyst, perform a manual WCET estimate for this function \
using loop-bound analysis. Assume Cortex-M4, in-order pipeline, 0 wait-state \
flash. Identify the longest path and all loop bounds.

[paste your C function]"
```

### Example D — Safety Requirement Writing

```bash
claude "Using sys-requirements-engineer, write 5 formally structured safety \
requirements for a railway point machine controller targeting SIL-2 (EN 50128). \
Each requirement must include: ID, text, rationale, SIL, and verification method."
```

### Example E — Fault Tree Analysis Guidance

```bash
claude "Using fault-tolerance-architect, build a fault tree for the top event \
'Loss of braking force' in a pneumatic braking system. Identify all basic events, \
calculate the minimal cut sets, and recommend design changes to reduce PFH."
```

---

## 11. Standards Coverage

This framework is intentionally **generic** — not tied to a single industry or standard. Each agent supports multiple standards simultaneously and maps between their integrity-level taxonomies:

| Standard | Domain | Integrity Levels | Agent Coverage |
|----------|--------|-----------------|----------------|
| **IEC 61508** | Generic functional safety | SIL-1 to SIL-4 | All 7 agents |
| **DO-178C** | Airborne software | DAL-A to DAL-E | All 7 agents |
| **EN 50128** | Railway software | SIL-0 to SIL-4 | All 7 agents |
| **IEC 62304** | Medical device software | Class A/B/C | All 7 agents |
| **ISO 26262** | Road vehicles | QM, ASIL-A to ASIL-D | All 7 agents (reference) |
| **IEC 61511** | Process industry | SIL-1 to SIL-3 | system-validation-engineer |

### Integrity Level Mapping

```
IEC 61508    DO-178C    EN 50128    ISO 26262    Risk Level
  SIL-4       DAL-A      SIL-4      ASIL-D       Highest
  SIL-3       DAL-B      SIL-3      ASIL-C/D     High
  SIL-2       DAL-C      SIL-2      ASIL-B/C     Medium
  SIL-1       DAL-D      SIL-1      ASIL-A/B     Low
  ─           DAL-E      SIL-0      QM           Lowest
```

---

## 12. Phase Gate Checklist

Use this checklist to track progress through the V-model. Each item must be evidenced (document reference + review sign-off) before the gate is closed.

### Phase 1 Gate — System Requirements
- [ ] All identified hazards mapped to at least one safety function
- [ ] Every safety function has an assigned SIL/ASIL target with justification
- [ ] SRS is complete (no TBD/TBC items open), reviewed, and baselined
- [ ] Requirements traceability matrix (RTM) seed created

### Phase 2 Gate — Architectural Design
- [ ] All SRS requirements allocated to architectural elements
- [ ] Timing budget covers worst-case load scenario
- [ ] Freedom-from-interference (FFI) strategy documented
- [ ] All interfaces specified in ICD

### Phase 3 Gate — WCET Analysis
- [ ] WCET verified for all safety-critical tasks: WCET ≤ budget
- [ ] Schedulability proven (utilisation ≤ 1.0 under worst-case load)
- [ ] No unbounded loops remaining in safety-critical paths

### Phase 4 Gate — Fault Tolerance Design
- [ ] All FMEA failure modes covered by a detection or mitigation mechanism
- [ ] Diagnostic coverage target achieved per SIL
- [ ] Safe-state entry timing requirement defined and achievable

### Phase 5 Gate — Unit Verification
- [ ] Structural coverage target met (MC/DC for SIL-3/4)
- [ ] All defensive code paths exercised by at least one test case
- [ ] WCET measurements within budget for all safety-critical functions
- [ ] No unresolved MISRA mandatory-rule violations

### Phase 6 Gate — Integration Verification
- [ ] All architectural interfaces tested
- [ ] Shared-resource contention scenarios pass
- [ ] End-to-end chain timing within budget on target hardware
- [ ] Fault containment verified at all interface boundaries

### Phase 7 Gate — System Validation
- [ ] Every system safety requirement has a passed validation scenario
- [ ] Hardware fault injection demonstrates fault tolerance on production HW
- [ ] Safe-state entry timing within requirement under worst-case conditions
- [ ] Safety case contribution complete and submitted for ISA review

---

## 13. Extending the Framework

### Adding a New Agent

1. Create `agents/vmodel/<your-agent-name>.yaml` following the schema:

```yaml
name: <agent-name>
description: >
  ...
role: <Role Title>
system_domain: generic
applicable_standards: [...]
integrity_levels:
  IEC_61508: [SIL-1, SIL-2, SIL-3, SIL-4]
  ...
capabilities: [...]
workflows:
  <workflow_name>:
    inputs: [...]
    steps: [...]
    outputs: [...]
guidelines: [...]
deliverables: [...]
tools: {}
```

2. Reference the new agent in `workflows/vmodel-hrtft/vmodel-hrtft-workflow.yaml` under a new phase.

### Adding a New Rule Category

1. Open `rules/hrtft-coding-rules.md`
2. Add a new section with a unique category prefix (e.g., `CRYPTO-xx` for cryptography rules)
3. Follow the table format with Rule ID | Requirement columns
4. Reference the new rules in any relevant agent's `guidelines` list

### Adapting to a Specific Domain

The framework is generic by design. To specialise it for a domain:

- **Medical (IEC 62304):** Emphasise software class (A/B/C), use-error analysis, and usability engineering
- **Railway (EN 50128):** Add formal methods requirements for SIL-3/4, independence of verifier
- **Avionics (DO-178C):** Add tool qualification (DO-330), parameter data items, structural coverage objectives per DAL
- **Automotive (ISO 26262):** Add AUTOSAR architecture constraints, SEooC considerations, confirmation measures

---

## 14. FAQ

**Q: Do I need all seven agents for every project?**
A: No. For lower-SIL projects, you may combine phases or skip formal WCET analysis at Phase 3. However, IEC 61508 SIL-3/4 and DO-178C DAL-A/B require all phases to be covered.

**Q: Can I use these agents with my existing codebase?**
A: Yes. The agents work on existing code — use them for gap analysis, test plan generation, or coding standard review without a full V-model restart.

**Q: What is `system_domain: generic` in the agent YAML?**
A: It means the agent is not scoped to a single industry. It can apply IEC 61508 for a factory controller, DO-178C for an avionics system, or EN 50128 for a railway application. Specify your standard in your prompt.

**Q: How do I enforce the coding rules automatically?**
A: The rules in `hrtft-coding-rules.md` work best in combination with static analysis tools (LDRA, Polyspace, PC-lint, MISRA-C checker). Claude can help interpret and triage violations reported by those tools using the rule IDs in the document.

**Q: Can Claude replace a human safety engineer?**
A: No. Claude is a force-multiplier that accelerates documentation, review, and analysis tasks. A qualified functional safety engineer must review and approve all safety-critical artefacts. Claude is not a substitute for formal tool qualification or independent safety assessment.

**Q: How do I cite Claude in safety evidence?**
A: Treat Claude-generated artefacts the same as any other tool output — they require human review and approval before inclusion in safety evidence. Note in your tool qualification or development process documentation that AI-assisted generation was used, with the reviewer's identity and sign-off date.

---

## Licence

MIT — free for commercial and personal use. See `LICENSE` in the repository root.

---

*Built for safety-critical engineers who need standards-compliant development support without the overhead of reconfiguring their entire toolchain.*
