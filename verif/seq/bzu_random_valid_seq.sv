///////////////////////////////////////////
// Birzeit University
// Faculty of Engineering and Technology
// ENCS5337 – Chip Design Verification
// Homework #5 – Packet Filter DUT
// 2nd semester 25/26
// Instructor: Elias Khalil
///////////////////////////////////////////

// Fully random, fully valid packets: every constraint left enabled.
class bzu_random_valid_seq extends bzu_base_seq;
  function new(string name = "random_valid_seq");
    super.new(name);
  endfunction

  virtual task body();
    for (int unsigned i = 0; i < num_txn; i++) begin
      bzu_packet pkt = new();
      apply_cfg(pkt);
      if (!pkt.randomize()) $fatal(1, "[%s] randomize failed", name);
      send(pkt);
    end
  endtask
endclass
