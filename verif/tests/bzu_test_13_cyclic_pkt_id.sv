///////////////////////////////////////////
// Birzeit University
// Faculty of Engineering and Technology
// ENCS5337 – Chip Design Verification
// Homework #5 – Packet Filter DUT
// 2nd semester 25/26
// Instructor: Elias Khalil
///////////////////////////////////////////

class bzu_test_13_cyclic_pkt_id extends bzu_test_base;
  function new(virtual bzu_pkt_filter_if vif_i, virtual bzu_pkt_filter_cfg_if vif_cfg_i);
    super.new(vif_i, vif_cfg_i, 20);
    verbose = 0;
  endfunction

  // randc on pkt_id [0:15] should produce a unique value in each of the
  // first 16 calls. We need to inspect every packet, so this test runs
  // its own loop instead of delegating to a sequence.
  virtual task run_body();
    bit seen[16];
    foreach (seen[i]) seen[i] = 0;

    for (int unsigned i = 0; i < num_txn; i++) begin
      bzu_packet pkt = new();
      pkt.cfg = cfg;

      if (!pkt.randomize()) $fatal(1, "[Test13] randomize failed");

      if (i < 16) begin
        if (seen[pkt.pkt_id]) $display("[Test13][WARN] pkt_id repeated early: %0d", pkt.pkt_id);
        else seen[pkt.pkt_id] = 1;
      end

      $display("[Test13] pkt_id=%0d", pkt.pkt_id);
      gen.transmit(pkt);
    end
  endtask
endclass
