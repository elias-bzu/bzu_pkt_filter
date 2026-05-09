///////////////////////////////////////////
// Birzeit University
// Faculty of Engineering and Technology
// ENCS5337 – Chip Design Verification
// Homework #5 – Packet Filter DUT
// 2nd semester 25/26
// Instructor: Elias Khalil
///////////////////////////////////////////

class bzu_driver;
  virtual bzu_pkt_filter_if vif;
  mailbox #(bzu_packet) mb_drv;

  function new(virtual bzu_pkt_filter_if vif_i, mailbox #(bzu_packet) mb_drv_i);
    vif = vif_i;
    mb_drv = mb_drv_i;
  endfunction

  task run(int unsigned num_txn);
    bzu_packet pkt;
    int unsigned sent;

    @(vif.cb_drv);
    vif.cb_drv.valid_in <= 1'b0;

    sent = 0;
    while (sent < num_txn) begin
      @(vif.cb_drv);
      if (mb_drv.try_get(pkt)) begin
        vif.cb_drv.dst_mac  <= pkt.dst_mac;
        vif.cb_drv.src_mac  <= pkt.src_mac;
        vif.cb_drv.eth_type <= pkt.eth_type;
        vif.cb_drv.length   <= pkt.length;
        vif.cb_drv.has_vlan <= pkt.has_vlan;
        vif.cb_drv.vlan_id  <= pkt.vlan_id;
        vif.cb_drv.valid_in <= 1'b1;
        sent++;
      end else begin
        vif.cb_drv.valid_in <= 1'b0;
      end
    end

    @(vif.cb_drv);
    vif.cb_drv.valid_in <= 1'b0;
  endtask
endclass
