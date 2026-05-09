///////////////////////////////////////////
// Birzeit University
// Faculty of Engineering and Technology
// ENCS5337 – Chip Design Verification
// Homework #5 – Packet Filter DUT
// 2nd semester 25/26
// Instructor: Elias Khalil
///////////////////////////////////////////

import bzu_pkt_filter_dv_pkg::*;
import bzu_pkt_filter_dv_components_pkg::*;
import bzu_pkt_filter_seq_pkg::*;
import bzu_pkt_filter_test_base_pkg::*;

  `include "bzu_test_01_random_valid.sv"
  `include "bzu_test_02_directed_protocol.sv"
  `include "bzu_test_03_boundary_length.sv"
  `include "bzu_test_04_vlan_behavior.sv"
  `include "bzu_test_05_broadcast_multicast.sv"
  `include "bzu_test_06_weighted_traffic.sv"
  `include "bzu_test_07_constraint_disable.sv"
  `include "bzu_test_08_fixed_field.sv"
  `include "bzu_test_09_partial_randomization.sv"
  `include "bzu_test_10_inline_constraint_override.sv"
  `include "bzu_test_11_constraint_validation.sv"
  `include "bzu_test_12_payload_constraints.sv"
  `include "bzu_test_13_cyclic_pkt_id.sv"
  `include "bzu_test_14_solve_order.sv"
  `include "bzu_test_15_scenario_sequence.sv"

  initial begin
    int unsigned TEST_ID;

    // Allow runtime override via plusarg: e.g. simv +TEST_ID=3
    // 0 means run all 15 tests sequentially.
    if (!$value$plusargs("TEST_ID=%d", TEST_ID)) 
      TEST_ID = 0;

    if($test$plusargs("VERBOSE"))
      verbose = 1;
    else
      verbose = 0;

    $display("[bzu_pkt_filter_test] TEST_ID=%0d (0 = run all)", TEST_ID);

    // Wait for reset deassertion driven from the harness module.
    wait (ifc.rst_n === 1'b1);
    @(posedge ifc.clk);

    if (TEST_ID == 0 || TEST_ID == 1) begin
      bzu_test_01_random_valid t = new(ifc, cifc);
      t.run();
    end

    if (TEST_ID == 0 || TEST_ID == 2) begin
      bzu_test_02_directed_protocol t = new(ifc, cifc);
      t.run();
    end

    if (TEST_ID == 0 || TEST_ID == 3) begin
      bzu_test_03_boundary_length t = new(ifc, cifc);
      t.run();
    end

    if (TEST_ID == 0 || TEST_ID == 4) begin
      bzu_test_04_vlan_behavior t = new(ifc, cifc);
      t.run();
    end

    if (TEST_ID == 0 || TEST_ID == 5) begin
      bzu_test_05_broadcast_multicast t = new(ifc, cifc);
      t.run();
    end

    if (TEST_ID == 0 || TEST_ID == 6) begin
      bzu_test_06_weighted_traffic t = new(ifc, cifc);
      t.run();
    end

    if (TEST_ID == 0 || TEST_ID == 7) begin
      bzu_test_07_constraint_disable t = new(ifc, cifc);
      t.run();
    end

    if (TEST_ID == 0 || TEST_ID == 8) begin
      bzu_test_08_fixed_field t = new(ifc, cifc);
      t.run();
    end

    if (TEST_ID == 0 || TEST_ID == 9) begin
      bzu_test_09_partial_randomization t = new(ifc, cifc);
      t.run();
    end

    if (TEST_ID == 0 || TEST_ID == 10) begin
      bzu_test_10_inline_constraint_override t = new(ifc, cifc);
      t.run();
    end

    if (TEST_ID == 0 || TEST_ID == 11) begin
      bzu_test_11_constraint_validation t = new(ifc, cifc);
      t.run();
    end

    if (TEST_ID == 0 || TEST_ID == 12) begin
      bzu_test_12_payload_constraints t = new(ifc, cifc);
      t.run();
    end

    if (TEST_ID == 0 || TEST_ID == 13) begin
      bzu_test_13_cyclic_pkt_id t = new(ifc, cifc);
      t.run();
    end

    if (TEST_ID == 0 || TEST_ID == 14) begin
      bzu_test_14_solve_order t = new(ifc, cifc);
      t.run();
    end

    if (TEST_ID == 0 || TEST_ID == 15) begin
      bzu_test_15_scenario_sequence t = new(ifc, cifc);
      t.run();
    end

    $display("[bzu_pkt_filter_test] finished TEST_ID=%0d", TEST_ID);
    $finish;
  end
