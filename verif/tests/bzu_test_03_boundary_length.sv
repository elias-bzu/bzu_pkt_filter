///////////////////////////////////////////
// Birzeit University
// Faculty of Engineering and Technology
// ENCS5337 – Chip Design Verification
// Homework #5 – Packet Filter DUT
// 2nd semester 25/26
// Instructor: Elias Khalil
///////////////////////////////////////////

class bzu_test_03_boundary_length extends bzu_test_base;
  function new(virtual bzu_pkt_filter_if vif_i, virtual bzu_pkt_filter_cfg_if vif_cfg_i);
    super.new(vif_i, vif_cfg_i, 4);
    verbose = 0;
  endfunction

  virtual task run_body();
    bzu_length_directed_seq seq;

    seq = new("len64_seq");
    seq.num_txn          = 1;
    seq.length_val       = 11'd64;
    seq.disable_c_length = 1'b0;
    seq.start(gen, cfg);

    seq = new("len1500_seq");
    seq.num_txn          = 1;
    seq.length_val       = 11'd1500;
    seq.disable_c_length = 1'b0;
    seq.start(gen, cfg);

    seq = new("len63_seq");
    seq.num_txn          = 1;
    seq.length_val       = 11'd63;
    seq.disable_c_length = 1'b1;
    seq.start(gen, cfg);

    seq = new("len1501_seq");
    seq.num_txn          = 1;
    seq.length_val       = 11'd1501;
    seq.disable_c_length = 1'b1;
    seq.start(gen, cfg);
  endtask
endclass
