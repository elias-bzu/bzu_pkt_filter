///////////////////////////////////////////
// Birzeit University
// Faculty of Engineering and Technology
// ENCS5337 – Chip Design Verification
// Homework #5 – Packet Filter DUT
// 2nd semester 25/26
// Instructor: Elias Khalil
///////////////////////////////////////////

class bzu_packet;
  // Packet fields (randomized in most tests)
  rand logic [47:0] dst_mac;
  rand logic [47:0] src_mac;
  rand logic [15:0] eth_type;
  rand logic [10:0] length;
  rand logic        has_vlan;
  rand logic [3:0]  vlan_id;

  // Cyclic packet ID (for Test 13)
  randc logic [7:0] pkt_id;

  // Payload: size is tied to `length` (filled in post_randomize)
  byte unsigned payload[];

  // Active configuration handle (set by sequence/test before randomize)
  bzu_filter_cfg cfg;

  // Payload generation knob (for Test 12)
  bit payload_low_nibble_only;

  // ----------------------------
  // Constraints (valid by default)
  // ----------------------------
  constraint c_pkt_id_range { pkt_id inside {[8'd0:8'd15]}; }

  constraint c_length_valid { length inside {[11'd64:11'd1500]}; }

  constraint c_eth_type_valid {
    eth_type inside {16'h0800, 16'h0806, 16'h86DD};
  }

  constraint c_cfg_handle_valid { cfg != null; }

  constraint c_vlan_valid {
    if (has_vlan) vlan_id inside {[cfg.vlan_min:cfg.vlan_max]};
    else vlan_id == 4'd0;
  }

  constraint c_dst_mac_valid_sensitive_to_cfg {
    if (cfg.broadcast_enable == 1'b0)
      dst_mac != 48'hFFFF_FFFF_FFFF;
    if (cfg.multicast_enable == 1'b0)
      dst_mac[40] == 1'b0;
  }

  constraint c_src_mac_valid {
    src_mac != 48'hFFFF_FFFF_FFFF;
    src_mac[40] == 1'b0;
  }

  function void post_randomize();
    byte unsigned b;
    payload = new[length];
    for (int i = 0; i < payload.size(); i++) begin
      if (payload_low_nibble_only)
        void'(std::randomize(b) with { b inside {[8'd0:8'd15]}; });
      else
        void'(std::randomize(b));
      payload[i] = b;
    end
  endfunction

  function automatic bit constraints_ok();
    logic exp_accept;
    drop_reason_t exp_drop;
    if (cfg == null) return 1'b0;
    calc_expected(
      dst_mac, src_mac, eth_type, length, has_vlan, vlan_id,
      cfg.broadcast_enable, cfg.multicast_enable, cfg.vlan_min, cfg.vlan_max,
      exp_accept, exp_drop
    );
    return (exp_accept == 1'b1) && (exp_drop == DROP_NONE);
  endfunction

  function automatic string sprint();
    bit        b_en;
    bit        m_en;
    logic [3:0] v_min;
    logic [3:0] v_max;
    if (cfg != null) begin
      b_en  = cfg.broadcast_enable;
      m_en  = cfg.multicast_enable;
      v_min = cfg.vlan_min;
      v_max = cfg.vlan_max;
    end else begin
      b_en  = 1'bx;
      m_en  = 1'bx;
      v_min = 4'hx;
      v_max = 4'hx;
    end
    return $sformatf(
      "pkt_id=%0d dst_mac=%h src_mac=%h eth_type=%h len=%0d has_vlan=%0b vlan_id=%0d cfg[b_en=%0b m_en=%0b v_rng=%0d:%0d] payload_sz=%0d",
      pkt_id, dst_mac, src_mac, eth_type, length, has_vlan, vlan_id,
      b_en, m_en, v_min, v_max, payload.size()
    );
  endfunction
endclass

