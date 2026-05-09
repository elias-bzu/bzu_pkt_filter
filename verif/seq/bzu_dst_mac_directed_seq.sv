///////////////////////////////////////////
// Birzeit University
// Faculty of Engineering and Technology
// ENCS5337 – Chip Design Verification
// Homework #5 – Packet Filter DUT
// 2nd semester 25/26
// Instructor: Elias Khalil
///////////////////////////////////////////

// Directed dst_mac: drives a specific MAC value.
// `disable_c_dst` should be set when broadcast/multicast filtering would
// otherwise reject the chosen MAC at the constraint stage.
class bzu_dst_mac_directed_seq extends bzu_base_seq;
  logic [47:0] dst_mac_val   = 48'h0;
  bit          disable_c_dst = 1'b0;

  function new(string name = "dst_mac_directed_seq");
    super.new(name);
  endfunction

  virtual task body();
    for (int unsigned i = 0; i < num_txn; i++) begin
      bzu_packet pkt = new();
      apply_cfg(pkt);
      if (disable_c_dst) pkt.c_dst_mac_valid_sensitive_to_cfg.constraint_mode(0);
      if (!pkt.randomize() with { dst_mac == local::dst_mac_val; })
        $fatal(1, "[%s] randomize failed", name);
      send(pkt);
    end
  endtask
endclass
