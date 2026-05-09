///////////////////////////////////////////
// Birzeit University
// Faculty of Engineering and Technology
// ENCS5337 – Chip Design Verification
// Homework #5 – Packet Filter DUT
// 2nd semester 25/26
// Instructor: Elias Khalil
///////////////////////////////////////////

class bzu_test_11_constraint_validation extends bzu_test_base;
  function new(virtual bzu_pkt_filter_if vif_i, virtual bzu_pkt_filter_cfg_if vif_cfg_i);
    super.new(vif_i, vif_cfg_i, 1);
    verbose = 0;
  endfunction

  virtual task run_body();
    bzu_packet pkt = new();
    pkt.cfg                     = cfg;
    pkt.payload_low_nibble_only = 1'b0;

    if (!pkt.randomize()) $fatal(1, "Test11: randomize failed");
    $display("[Test11] Initially valid pkt: %s", pkt.sprint());
    if (!pkt.constraints_ok()) $fatal(1, "Test11: constraints_ok() should be true for a valid packet");

    pkt.length = 11'd63;
    $display("[Test11] Modified invalid pkt (len=63): %s", pkt.sprint());
    if (pkt.constraints_ok()) $fatal(1, "Test11: constraints_ok() should be false after invalid modification");

    gen.transmit(pkt);
  endtask
endclass
