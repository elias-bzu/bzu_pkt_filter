///////////////////////////////////////////
// Birzeit University
// Faculty of Engineering and Technology
// ENCS5337 – Chip Design Verification
// Homework #5 – Packet Filter DUT
// 2nd semester 25/26
// Instructor: Elias Khalil
///////////////////////////////////////////

class bzu_test_07_constraint_disable extends bzu_test_base;
  function new(virtual bzu_pkt_filter_if vif_i, virtual bzu_pkt_filter_cfg_if vif_cfg_i);
    super.new(vif_i, vif_cfg_i, 30);
    verbose = 0;
  endfunction

  virtual task run_body();
    bzu_invalid_length_seq seq = new("invalid_length_seq");
    seq.num_txn = num_txn;
    seq.start(gen, cfg);
  endtask
endclass
