///////////////////////////////////////////
// Birzeit University
// Faculty of Engineering and Technology
// ENCS5337 – Chip Design Verification
// Homework #5 – Packet Filter DUT
// 2nd semester 25/26
// Instructor: Elias Khalil
///////////////////////////////////////////

// Disable randomization on src_mac and lock it to a fixed value.
// Demonstrates `rand_mode(0)` + post-set assignment.
class bzu_fixed_src_mac_seq extends bzu_base_seq;
  logic [47:0] src_mac_val = 48'h0011_2233_4455;

  function new(string name = "fixed_src_mac_seq");
    super.new(name);
  endfunction

  virtual task body();
    for (int unsigned i = 0; i < num_txn; i++) begin
      bzu_packet pkt = new();
      apply_cfg(pkt);

      pkt.src_mac.rand_mode(0);
      pkt.src_mac = src_mac_val;

      if (!pkt.randomize()) $fatal(1, "[%s] randomize failed", name);
      if (pkt.src_mac !== src_mac_val)
        $fatal(1, "[%s] src_mac changed unexpectedly", name);

      send(pkt);
    end
  endtask
endclass
