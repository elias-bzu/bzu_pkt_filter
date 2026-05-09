# Packet filter RTL and SystemVerilog testbench

Course assignment for **ENCS5337 – Chip Design Verification** (Birzeit University, 2nd semester 2025/26): a **plain SystemVerilog** verification environment (packages, stimulus sequences, monitors, and a checker—no UVM dependency) sits on top of this DUT.

---

## Design overview

**`bzu_pkt_filter`** is a small  **Ethernet-style packet filter**. On each clock where **`valid_in`** is high, the block treats the parallel fields on the datapath as one header snapshot and, in the same cycle, drives **`valid_out`** (mirroring `valid_in`) plus whether that packet is **accepted** or **dropped** and **why**. There is no internal packet buffer: the decision is **combinational on the registered rule checks**, with outputs registered on the clock edge. A separate **configuration port** programs four 8-bit registers (broadcast enable, multicast enable, VLAN minimum, VLAN maximum) before or between traffic beats.

### Inputs

| Signal | Width | Role |
|--------|------:|------|
| `clk` | 1 | System clock. |
| `rst_n` | 1 | Asynchronous active-low reset. |
| `valid_in` | 1 | When high, all datapath fields below are valid for this cycle. |
| `dst_mac` | 48 | Destination MAC (broadcast / multicast derived from this). |
| `src_mac` | 48 | Source MAC (carried for stimulus / visibility; not used in filter rules). |
| `eth_type` | 16 | EtherType field; only a small allow-list passes. |
| `length` | 11 | Frame length in bytes; must sit in the legal range. |
| `has_vlan` | 1 | High if a VLAN tag is present for this packet. |
| `vlan_id` | 4 | VLAN identifier (checked only when `has_vlan` is high). |
| `cfg_addr` | 2 | Configuration register index (0–3). |
| `cfg_wdata` | 8 | Write data for the selected register. |
| `cfg_we` | 1 | High on a clock edge to update `cfg_mem[cfg_addr]` with `cfg_wdata`. |

### Outputs

| Signal | Width | Role |
|--------|------:|------|
| `cfg_rdata` | 8 | Read data: `cfg_mem[cfg_addr]` (same-cycle comb read of the register file). |
| `valid_out` | 1 | Qualifier for the decision outputs; follows `valid_in` in lockstep. |
| `accept` | 1 | High only when **`valid_in`** is high **and** the packet passes every rule; low on idle cycles (`!valid_in`). |
| `drop_reason` | 3 | When **`valid_in`** is high: **`0`** if accepted or no drop, **`1`–`5`** for the failing rule (length / broadcast / multicast / EtherType / VLAN; RTL `DROP_*`). When **`valid_in`** is low, the RTL drives **`0`** (none). |

---



## Filtering rules

`bzu_pkt_filter` applies the following checks when `valid_in` is asserted (order matches the RTL priority):

| Check | Behavior |
|--------|----------|
| **Length** | Must be **64–1500** bytes (field width is 11 bits). |
| **Broadcast** | `dst_mac == 48'hFFFF_FFFF_FFFF`. Dropped if `broadcast_enable` in config is 0. |
| **Multicast** | `dst_mac[40] == 1`. Dropped if `multicast_enable` is 0. |
| **EtherType** | Only **IPv4 (`0x0800`)**, **ARP (`0x0806`)**, and **IPv6 (`0x86DD`)** pass. |
| **VLAN** | If `has_vlan`, **vlan_id** must fall in **[vlan_min, vlan_max]** from config. |

`drop_reason` encodes why a packet was dropped (length, broadcast, multicast, EtherType, VLAN, or none). A small **CFG register file** (`cfg_addr` / `cfg_wdata` / `cfg_we`) programs broadcast/multicast enables and VLAN bounds; defaults match the RTL comments in `design/bzu_pkt_filter.v`.

---

## Repository layout

```
design/          RTL (Verilog)
verif/if/        datapath + configuration interfaces
verif/env/       packages, generator/driver/monitor/agent/env, checker
verif/cfg/       filter-related configuration objects
verif/seq/       stimulus sequences
verif/tests/     test classes (15 scenarios)
verif/tb/        top testbench (`bzu_pkt_filter_tb`) and test harness (`bzu_pkt_filter_test.sv`)
vcs.f            file list for Synopsys VCS (+ include paths)
```

---

## Prerequisites

- A **SystemVerilog** simulator. The supplied file list targets **Synopsys VCS**; other tools can compile the same sources if you recreate the `+incdir+` paths and compilation order.

---

## Build and run (VCS example)

Run from the **repository root** (the directory that contains `vcs.f`).

**Compile:**

```bash
vcs -full64 -sverilog -debug_access+all -timescale=1ns/1ps -f vcs.f -o simv
```

**Simulate:**

- Run **all 15 tests** in order (`TEST_ID=0`):

  ```bash
  ./simv
  ```

  or explicitly:

  ```bash
  ./simv +TEST_ID=0
  ```

- Run a **single** test (replace `N` with `1`…`15`):

  ```bash
  ./simv +TEST_ID=N
  ```

**Optional plusarg:**

- **`+VERBOSE`** — increased messaging from the bench (wired in `bzu_pkt_filter_test.sv`).

---

## Tests (TEST_ID mapping)

| `TEST_ID` | Test module | Focus |
|-----------|-------------|--------|
| 1 | `bzu_test_01_random_valid` | Random valid traffic |
| 2 | `bzu_test_02_directed_protocol` | Directed protocol / types |
| 3 | `bzu_test_03_boundary_length` | Length boundaries |
| 4 | `bzu_test_04_vlan_behavior` | VLAN and config range |
| 5 | `bzu_test_05_broadcast_multicast` | Broadcast / multicast policy |
| 6 | `bzu_test_06_weighted_traffic` | Weighted randomization |
| 7 | `bzu_test_07_constraint_disable` | Constraint manipulation |
| 8 | `bzu_test_08_fixed_field` | Fixed-field stimulus |
| 9 | `bzu_test_09_partial_randomization` | Partial rand |
| 10 | `bzu_test_10_inline_constraint_override` | Inline constraints |
| 11 | `bzu_test_11_constraint_validation` | Constraint correctness |
| 12 | `bzu_test_12_payload_constraints` | Payload-side constraints |
| 13 | `bzu_test_13_cyclic_pkt_id` | Cyclic IDs |
| 14 | `bzu_test_14_solve_order` | `solve … before` style ordering |
| 15 | `bzu_test_15_scenario_sequence` | Larger scenario sequences |

---

## Academic context

This repository is homework/course material. **Course:** ENCS5337 – Chip Design Verification, **Faculty of Engineering and Technology**, Birzeit University. Retain attribution headers in sources when modifying or redistributing for class use.
