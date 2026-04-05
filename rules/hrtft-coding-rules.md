# HRTFT Coding Rules
## Hard Real-Time Fault-Tolerant System — Software Coding Standard

**Applicable Standards:** IEC 61508-3, DO-178C, EN 50128, IEC 62304, ISO 26262-6  
**Integrity Levels:** SIL-1..SIL-4 / DAL-A..DAL-E / ASIL-A..ASIL-D  
**Language scope:** C (MISRA C:2012), C++ (MISRA C++:2023 / HIC++ v4)

---

## 1. Language Subset

| Rule | Requirement |
|------|-------------|
| LANG-01 | Use only the MISRA C:2012 mandatory and required rules subset; deviations must be documented with safety justification |
| LANG-02 | No dynamic memory allocation (`malloc`, `free`, `new`, `delete`) after initialisation phase |
| LANG-03 | No recursion; all call graphs must be acyclic and verifiable by static analysis |
| LANG-04 | No use of `setjmp` / `longjmp` |
| LANG-05 | No function pointers in safety-critical paths unless explicitly validated at initialisation |
| LANG-06 | All variables must be explicitly initialised before use |
| LANG-07 | No use of undefined or implementation-defined behaviour as defined by ISO C standard |

---

## 2. Real-Time Constraints

| Rule | Requirement |
|------|-------------|
| RT-01 | All safety-critical tasks must have a statically allocated, bounded stack; no variable-length arrays |
| RT-02 | Worst-case execution time (WCET) must be analysed for every safety-critical function; WCET must not exceed allocated time budget |
| RT-03 | No unbounded loops in safety-critical code paths; all loops must have a provable upper bound |
| RT-04 | All inter-task shared data must be protected by appropriate mutual exclusion (mutex, spinlock, or interrupt disable with minimal critical section) |
| RT-05 | Priority inversion must be prevented using Priority Ceiling Protocol (PCP) or Priority Inheritance Protocol (PIP) |
| RT-06 | Task scheduling must be analysed for schedulability (Rate-Monotonic Analysis or Earliest-Deadline First) at the architectural design phase |
| RT-07 | Interrupt service routines (ISRs) must be kept minimal; deferred processing must be dispatched to tasks |
| RT-08 | No blocking system calls inside ISRs |

---

## 3. Fault Tolerance and Defensive Programming

| Rule | Requirement |
|------|-------------|
| FT-01 | All inputs from external sources (sensors, communications, operators) must be validated for range, rate-of-change, and plausibility |
| FT-02 | All safety-critical function return values and output parameters must be checked by the caller |
| FT-03 | Every safety-critical state must be reachable from any fault state via a defined safe-state transition |
| FT-04 | Watchdog timers must be kicked only from the appropriate task after all safety checks are passed; no unconditional kicking |
| FT-05 | Memory integrity (stack canaries, CRC of critical data regions) must be checked periodically at a rate consistent with the SIL diagnostic requirement |
| FT-06 | Redundant paths (hot, warm, or cold standby) must have independent data flows; no shared mutable state between redundant channels |
| FT-07 | All fault codes and diagnostic results must be logged to a non-volatile error log with timestamps |
| FT-08 | Safe-state entry must be achievable within the maximum fault reaction time specified in the safety requirements |

---

## 4. Data Integrity

| Rule | Requirement |
|------|-------------|
| DATA-01 | Safety-critical data must be protected with CRC or parity at rest and in transit |
| DATA-02 | All global variables accessible from multiple tasks must be declared `volatile` and protected by mutual exclusion |
| DATA-03 | No implicit type conversions that reduce precision or change signedness in safety-critical expressions |
| DATA-04 | Pointer arithmetic is prohibited except in explicitly reviewed and justified low-level drivers |
| DATA-05 | All arrays must be accessed with bounds-checked indices; static analysis must verify no out-of-bounds access |

---

## 5. Modularity and Traceability

| Rule | Requirement |
|------|-------------|
| MOD-01 | Each source file must implement a single, cohesive module with a documented interface (header file) |
| MOD-02 | Every function must have a structured header comment: purpose, parameters, return value, pre/post-conditions, and safety relevance |
| MOD-03 | Every safety-critical function must be traceable to at least one software requirement in the requirements management tool |
| MOD-04 | All deviations from this coding standard must be documented in a deviation register with impact assessment |
| MOD-05 | Cyclomatic complexity of any function must not exceed 15 without safety manager approval; SIL-3/4 functions ≤ 10 |

---

## 6. Build and Configuration Management

| Rule | Requirement |
|------|-------------|
| CM-01 | All source code and safety artefacts must be version-controlled; builds must be reproducible from a tagged commit |
| CM-02 | Compiler flags must be fixed and documented; optimisation levels must not suppress safety-critical code |
| CM-03 | Third-party libraries must be qualified per IEC 61508-3 Annex D / DO-178C COTS guidance before use in safety-critical paths |
| CM-04 | Build output (binary, map file, disassembly) must be archived alongside the source tag used to produce it |

---

## 7. Static Analysis and Review Gates

| Gate | Requirement |
|------|-------------|
| SA-01 | MISRA C:2012 mandatory rules: zero violations permitted |
| SA-02 | MISRA C:2012 required rules: all violations must be documented in deviation register with justification |
| SA-03 | Data-flow and control-flow analysis must show no undefined reads, no dead code in safety paths |
| SA-04 | Peer code review mandatory for all safety-critical modules; checklist must be completed and archived |
| SA-05 | Formal sign-off by designated safety reviewer required before merging safety-critical changes |

---

*This document is a controlled artefact. Changes require safety manager approval and a formal deviation record.*
