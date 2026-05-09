///////////////////////////////////////////
// Birzeit University
// Faculty of Engineering and Technology
// ENCS5337 – Chip Design Verification
// Homework #5 – Packet Filter DUT
// 2nd semester 25/26
// Instructor: Elias Khalil
///////////////////////////////////////////

// Weighted eth_type distribution: IPv4 / ARP / IPv6.
// Counters are exposed for tests that want to assert the distribution shape.
class bzu_eth_type_weighted_seq extends bzu_base_seq;
  int unsigned w_ipv4 = 70;
  int unsigned w_arp  = 15;
  int unsigned w_ipv6 = 15;

  int unsigned cnt_ipv4;
  int unsigned cnt_arp;
  int unsigned cnt_ipv6;

  function new(string name = "eth_type_weighted_seq");
    super.new(name);
  endfunction

  virtual task body();
    cnt_ipv4 = 0; cnt_arp = 0; cnt_ipv6 = 0;
    for (int unsigned i = 0; i < num_txn; i++) begin
      bzu_packet pkt = new();
      apply_cfg(pkt);
      if (!pkt.randomize() with {
        eth_type dist {
          16'h0800 := local::w_ipv4,
          16'h0806 := local::w_arp,
          16'h86DD := local::w_ipv6
        };
      }) $fatal(1, "[%s] weighted randomize failed", name);

      unique case (pkt.eth_type)
        16'h0800: cnt_ipv4++;
        16'h0806: cnt_arp++;
        16'h86DD: cnt_ipv6++;
        default : $fatal(1, "[%s] unexpected eth_type=%h", name, pkt.eth_type);
      endcase

      send(pkt);
    end
    $display("[%s] dist counts: IPv4=%0d ARP=%0d IPv6=%0d (weights %0d/%0d/%0d)",
             name, cnt_ipv4, cnt_arp, cnt_ipv6, w_ipv4, w_arp, w_ipv6);
  endtask
endclass
