///////////////////////////////////////////
// Birzeit University
// Faculty of Engineering and Technology
// ENCS5337 – Chip Design Verification
// Homework #5 – Packet Filter DUT
// 2nd semester 25/26
// Instructor: Elias Khalil
///////////////////////////////////////////

// Directed eth_type: every packet uses a single configurable eth_type value.
class bzu_eth_type_directed_seq extends bzu_base_seq;
  logic [15:0] eth_type_val = 16'h0800;

  function new(string name = "eth_type_directed_seq");
    super.new(name);
  endfunction

  virtual task body();
    for (int unsigned i = 0; i < num_txn; i++) begin
      bzu_packet pkt = new();
      apply_cfg(pkt);
      if (!pkt.randomize() with { eth_type == local::eth_type_val; })
        $fatal(1, "[%s] randomize failed (eth=%h)", name, eth_type_val);
      send(pkt);
    end
  endtask
endclass
