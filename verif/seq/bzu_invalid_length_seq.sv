///////////////////////////////////////////
// Birzeit University
// Faculty of Engineering and Technology
// ENCS5337 – Chip Design Verification
// Homework #5 – Packet Filter DUT
// 2nd semester 25/26
// Instructor: Elias Khalil
///////////////////////////////////////////

// Disable c_length_valid and force length to invalid boundary values.
// Drives the DROP_LENGTH path of the DUT.
class bzu_invalid_length_seq extends bzu_base_seq;
  function new(string name = "invalid_length_seq");
    super.new(name);
  endfunction

  virtual task body();
    for (int unsigned i = 0; i < num_txn; i++) begin
      bzu_packet pkt = new();
      apply_cfg(pkt);
      pkt.c_length_valid.constraint_mode(0);
      if (!pkt.randomize() with { length inside {11'd63, 11'd1501}; })
        $fatal(1, "[%s] randomize failed", name);
      send(pkt, "INV-LEN");
    end
  endtask
endclass
