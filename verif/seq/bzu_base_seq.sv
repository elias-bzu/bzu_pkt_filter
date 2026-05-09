///////////////////////////////////////////
// Birzeit University
// Faculty of Engineering and Technology
// ENCS5337 – Chip Design Verification
// Homework #5 – Packet Filter DUT
// 2nd semester 25/26
// Instructor: Elias Khalil
///////////////////////////////////////////

// Virtual base class for all packet generation sequences.
// A sequence owns a randomization recipe and a count, and feeds packets
// into the agent's generator (and therefore the driver + checker).
//
// Each sequence holds a handle to the test-level bzu_filter_cfg and passes
// it into each packet so packet constraints solve against DUT-programmed cfg.
virtual class bzu_base_seq;
  bzu_generator   gen;
  bzu_filter_cfg  cfg;
  string          name;
  int unsigned    num_txn = 1;

  // Payload generation knob (sequences may toggle for low-nibble traffic).
  bit             payload_low_nibble_only = 1'b0;

  bit             verbose = 1'b0;

  function new(string name = "bzu_base_seq");
    this.name = name;
  endfunction

  // Stamp the active cfg handle (and payload knob) onto a packet.
  virtual function void apply_cfg(bzu_packet pkt);
    if (cfg == null)
      $fatal(1, "[%s] cfg handle is null - test must set seq.cfg before start()", name);
    pkt.cfg                     = cfg;
    pkt.payload_low_nibble_only = payload_low_nibble_only;
  endfunction

  virtual task send(bzu_packet pkt, string tag = "TX");
    if (verbose) $display("[%s][%s] %s", name, tag, pkt.sprint());
    gen.transmit(pkt);
  endtask

  virtual task start(bzu_generator gen_i, bzu_filter_cfg cfg_i);
    gen = gen_i;
    cfg = cfg_i;
    body();
  endtask

  // Override in derived sequences.
  virtual task body(); endtask
endclass
