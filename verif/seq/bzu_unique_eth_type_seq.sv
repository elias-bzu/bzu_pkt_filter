///////////////////////////////////////////
// Birzeit University
// Faculty of Engineering and Technology
// ENCS5337 – Chip Design Verification
// Homework #5 – Packet Filter DUT
// 2nd semester 25/26
// Instructor: Elias Khalil
///////////////////////////////////////////

// Sequential / scenario-style: each packet's eth_type must differ from
// the previous one. Demonstrates state carried across randomize() calls.
class bzu_unique_eth_type_seq extends bzu_base_seq;
  logic [15:0] last_eth_type = 16'hFFFF;

  function new(string name = "unique_eth_type_seq");
    super.new(name);
  endfunction

  virtual task body();
    last_eth_type = 16'hFFFF;
    for (int unsigned i = 0; i < num_txn; i++) begin
      bzu_packet pkt = new();
      apply_cfg(pkt);
      if (!pkt.randomize() with { eth_type != local::last_eth_type; })
        $fatal(1, "[%s] randomize failed", name);
      $display("[%s] seq[%0d] eth_type=%h (prev=%h)",
               name, i, pkt.eth_type, last_eth_type);
      last_eth_type = pkt.eth_type;
      gen.transmit(pkt);
    end
  endtask
endclass
