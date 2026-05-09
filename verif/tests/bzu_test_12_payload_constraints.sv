///////////////////////////////////////////
// Birzeit University
// Faculty of Engineering and Technology
// ENCS5337 – Chip Design Verification
// Homework #5 – Packet Filter DUT
// 2nd semester 25/26
// Instructor: Elias Khalil
///////////////////////////////////////////

class bzu_test_12_payload_constraints extends bzu_test_base;
  function new(virtual bzu_pkt_filter_if vif_i, virtual bzu_pkt_filter_cfg_if vif_cfg_i);
    super.new(vif_i, vif_cfg_i, 10);
    verbose = 0;
  endfunction

  virtual task run_body();
    bzu_length_range_seq seq = new("payload_low_nibble_seq");
    seq.num_txn                 = num_txn;
    seq.length_min              = 11'd64;
    seq.length_max              = 11'd80;
    seq.payload_low_nibble_only = 1'b1;
    seq.start(gen, cfg);
  endtask
endclass
