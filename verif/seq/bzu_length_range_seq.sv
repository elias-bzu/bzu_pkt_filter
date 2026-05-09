///////////////////////////////////////////
// Birzeit University
// Faculty of Engineering and Technology
// ENCS5337 – Chip Design Verification
// Homework #5 – Packet Filter DUT
// 2nd semester 25/26
// Instructor: Elias Khalil
///////////////////////////////////////////

// Length constrained inline to a [min:max] range.
// Useful for inline override tests and payload-shape tests.
class bzu_length_range_seq extends bzu_base_seq;
  logic [10:0] length_min = 11'd64;
  logic [10:0] length_max = 11'd1500;

  function new(string name = "length_range_seq");
    super.new(name);
  endfunction

  virtual task body();
    for (int unsigned i = 0; i < num_txn; i++) begin
      bzu_packet pkt = new();
      apply_cfg(pkt);
      if (!pkt.randomize() with {
        length inside {[local::length_min:local::length_max]};
      }) $fatal(1, "[%s] randomize failed", name);

      if (!(pkt.length >= length_min && pkt.length <= length_max))
        $fatal(1, "[%s] inline range not respected len=%0d", name, pkt.length);

      if (pkt.payload.size() != pkt.length)
        $fatal(1, "[%s] payload size mismatch payload=%0d length=%0d",
               name, pkt.payload.size(), pkt.length);

      send(pkt);
    end
  endtask
endclass
