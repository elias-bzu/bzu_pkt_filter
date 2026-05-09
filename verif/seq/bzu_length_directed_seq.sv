///////////////////////////////////////////
// Birzeit University
// Faculty of Engineering and Technology
// ENCS5337 – Chip Design Verification
// Homework #5 – Packet Filter DUT
// 2nd semester 25/26
// Instructor: Elias Khalil
///////////////////////////////////////////

// Directed length value (e.g. 64, 1500, 63, 1501).
// When `disable_c_length` is set, the packet's length-range constraint
// is turned off so out-of-range values can be exercised.
class bzu_length_directed_seq extends bzu_base_seq;
  logic [10:0] length_val       = 11'd64;
  bit          disable_c_length = 1'b0;

  function new(string name = "length_directed_seq");
    super.new(name);
  endfunction

  virtual task body();
    for (int unsigned i = 0; i < num_txn; i++) begin
      bzu_packet pkt = new();
      apply_cfg(pkt);
      if (disable_c_length) pkt.c_length_valid.constraint_mode(0);
      if (!pkt.randomize() with { length == local::length_val; })
        $fatal(1, "[%s] randomize len=%0d failed", name, length_val);
      send(pkt, disable_c_length ? "DROP" : "ACCEPT");
    end
  endtask
endclass
