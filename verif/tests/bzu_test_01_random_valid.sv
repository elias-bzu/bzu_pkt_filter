///////////////////////////////////////////
// Birzeit University
// Faculty of Engineering and Technology
// ENCS5337 – Chip Design Verification
// Homework #5 – Packet Filter DUT
// 2nd semester 25/26
// Instructor: Elias Khalil
///////////////////////////////////////////

class bzu_test_01_random_valid extends bzu_test_base;
  function new(virtual bzu_pkt_filter_if vif_i, virtual bzu_pkt_filter_cfg_if vif_cfg_i);
    super.new(vif_i, vif_cfg_i, 50);
    verbose = 1;
  endfunction

  virtual task run_body();
    bzu_random_valid_seq seq = new("random_valid_seq");
    seq.num_txn = num_txn;
    seq.verbose = 1'b1;
    seq.start(gen, cfg);
    $display("[Test1] Done sending %0d valid packets.", num_txn);
  endtask
endclass
