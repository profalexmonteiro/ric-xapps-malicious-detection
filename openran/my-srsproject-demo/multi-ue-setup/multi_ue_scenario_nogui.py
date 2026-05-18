#!/usr/bin/env python3
# -*- coding: utf-8 -*-

#
# SPDX-License-Identifier: GPL-3.0
#
# GNU Radio Python Flow Graph
# Title: srsRAN_multi_UE
# GNU Radio version: 3.10.11.0

from gnuradio import blocks
from gnuradio import gr
from gnuradio import zeromq
from gnuradio.filter import firdes
from gnuradio.fft import window
import sys
import signal


class multi_ue_scenario(gr.top_block):

    def __init__(self):
        gr.top_block.__init__(self, "srsRAN_multi_UE", catch_exceptions=True)

        ##################################################
        # Variables
        ##################################################
        self.samp_rate = samp_rate = 11520000
        self.slow_down_ratio = slow_down_ratio = 4
        self.ue1_path_loss_db = ue1_path_loss_db = 0
        self.ue2_path_loss_db = ue2_path_loss_db = 10
        self.ue3_path_loss_db = ue3_path_loss_db = 20
        self.zmq_hwm = zmq_hwm = -1
        self.zmq_timeout = zmq_timeout = 100

        ##################################################
        # Blocks
        ##################################################

        # ZMQ REQ Sources (UEs -> channel sim)
        self.zeromq_req_source_0 = zeromq.req_source(
            gr.sizeof_gr_complex, 1,
            'tcp://127.0.0.1:2000',
            zmq_timeout, False, zmq_hwm, False)

        self.zeromq_req_source_0_0 = zeromq.req_source(
            gr.sizeof_gr_complex, 1,
            'tcp://127.0.0.1:2301',
            zmq_timeout, False, zmq_hwm, False)

        self.zeromq_req_source_1 = zeromq.req_source(
            gr.sizeof_gr_complex, 1,
            'tcp://127.0.0.1:2101',
            zmq_timeout, False, zmq_hwm, False)

        self.zeromq_req_source_1_0 = zeromq.req_source(
            gr.sizeof_gr_complex, 1,
            'tcp://127.0.0.1:2201',
            zmq_timeout, False, zmq_hwm, False)

        # Throttle (eNB downlink path)
        self.blocks_throttle_0 = blocks.throttle(
            gr.sizeof_gr_complex * 1,
            1.0 * samp_rate / (1.0 * slow_down_ratio),
            True)

        # Multiply const blocks — downlink (eNB -> each UE)
        self.blocks_multiply_const_vxx_0_1 = blocks.multiply_const_cc(
            10 ** (-1.0 * ue1_path_loss_db / 20.0))

        self.blocks_multiply_const_vxx_0_1_1 = blocks.multiply_const_cc(
            10 ** (-1.0 * ue2_path_loss_db / 20.0))

        self.blocks_multiply_const_vxx_0_1_0 = blocks.multiply_const_cc(
            10 ** (-1.0 * ue3_path_loss_db / 20.0))

        # Multiply const blocks — uplink (each UE -> eNB)
        self.blocks_multiply_const_vxx_0 = blocks.multiply_const_cc(
            10 ** (-1.0 * ue1_path_loss_db / 20.0))

        self.blocks_multiply_const_vxx_0_0 = blocks.multiply_const_cc(
            10 ** (-1.0 * ue2_path_loss_db / 20.0))

        self.blocks_multiply_const_vxx_0_0_0 = blocks.multiply_const_cc(
            10 ** (-1.0 * ue3_path_loss_db / 20.0))

        # Add block — combines uplink signals from all 3 UEs
        self.blocks_add_xx_0 = blocks.add_vcc(1)

        # ZMQ REP Sinks (channel sim -> eNB / UEs)
        self.zeromq_rep_sink_0 = zeromq.rep_sink(
            gr.sizeof_gr_complex, 1,
            'tcp://127.0.0.1:2100',
            zmq_timeout, False, zmq_hwm, True)

        self.zeromq_rep_sink_0_0 = zeromq.rep_sink(
            gr.sizeof_gr_complex, 1,
            'tcp://127.0.0.1:2200',
            zmq_timeout, False, zmq_hwm, True)

        self.zeromq_rep_sink_0_1 = zeromq.rep_sink(
            gr.sizeof_gr_complex, 1,
            'tcp://127.0.0.1:2001',
            zmq_timeout, False, zmq_hwm, True)

        self.zeromq_rep_sink_0_2 = zeromq.rep_sink(
            gr.sizeof_gr_complex, 1,
            'tcp://127.0.0.1:2300',
            100, False, zmq_hwm, True)

        ##################################################
        # Connections
        ##################################################

        # eNB downlink: source -> throttle -> path loss per UE -> sink to each UE
        self.connect((self.zeromq_req_source_0, 0),
                     (self.blocks_throttle_0, 0))
        self.connect((self.blocks_throttle_0, 0),
                     (self.blocks_multiply_const_vxx_0_1, 0))
        self.connect((self.blocks_throttle_0, 0),
                     (self.blocks_multiply_const_vxx_0_1_1, 0))
        self.connect((self.blocks_throttle_0, 0),
                     (self.blocks_multiply_const_vxx_0_1_0, 0))

        self.connect((self.blocks_multiply_const_vxx_0_1, 0),
                     (self.zeromq_rep_sink_0, 0))
        self.connect((self.blocks_multiply_const_vxx_0_1_1, 0),
                     (self.zeromq_rep_sink_0_0, 0))
        self.connect((self.blocks_multiply_const_vxx_0_1_0, 0),
                     (self.zeromq_rep_sink_0_2, 0))

        # UE uplink: each UE -> path loss -> add -> sink to eNB
        self.connect((self.zeromq_req_source_1, 0),
                     (self.blocks_multiply_const_vxx_0, 0))
        self.connect((self.zeromq_req_source_1_0, 0),
                     (self.blocks_multiply_const_vxx_0_0, 0))
        self.connect((self.zeromq_req_source_0_0, 0),
                     (self.blocks_multiply_const_vxx_0_0_0, 0))

        self.connect((self.blocks_multiply_const_vxx_0, 0),
                     (self.blocks_add_xx_0, 0))
        self.connect((self.blocks_multiply_const_vxx_0_0, 0),
                     (self.blocks_add_xx_0, 1))
        self.connect((self.blocks_multiply_const_vxx_0_0_0, 0),
                     (self.blocks_add_xx_0, 2))

        self.connect((self.blocks_add_xx_0, 0),
                     (self.zeromq_rep_sink_0_1, 0))

    def get_samp_rate(self):
        return self.samp_rate

    def set_samp_rate(self, samp_rate):
        self.samp_rate = samp_rate
        self.blocks_throttle_0.set_sample_rate(
            1.0 * self.samp_rate / (1.0 * self.slow_down_ratio))

    def get_slow_down_ratio(self):
        return self.slow_down_ratio

    def set_slow_down_ratio(self, slow_down_ratio):
        self.slow_down_ratio = slow_down_ratio
        self.blocks_throttle_0.set_sample_rate(
            1.0 * self.samp_rate / (1.0 * self.slow_down_ratio))

    def get_ue1_path_loss_db(self):
        return self.ue1_path_loss_db

    def set_ue1_path_loss_db(self, ue1_path_loss_db):
        self.ue1_path_loss_db = ue1_path_loss_db
        self.blocks_multiply_const_vxx_0.set_k(
            10 ** (-1.0 * self.ue1_path_loss_db / 20.0))
        self.blocks_multiply_const_vxx_0_1.set_k(
            10 ** (-1.0 * self.ue1_path_loss_db / 20.0))

    def get_ue2_path_loss_db(self):
        return self.ue2_path_loss_db

    def set_ue2_path_loss_db(self, ue2_path_loss_db):
        self.ue2_path_loss_db = ue2_path_loss_db
        self.blocks_multiply_const_vxx_0_0.set_k(
            10 ** (-1.0 * self.ue2_path_loss_db / 20.0))
        self.blocks_multiply_const_vxx_0_1_1.set_k(
            10 ** (-1.0 * self.ue2_path_loss_db / 20.0))

    def get_ue3_path_loss_db(self):
        return self.ue3_path_loss_db

    def set_ue3_path_loss_db(self, ue3_path_loss_db):
        self.ue3_path_loss_db = ue3_path_loss_db
        self.blocks_multiply_const_vxx_0_0_0.set_k(
            10 ** (-1.0 * self.ue3_path_loss_db / 20.0))
        self.blocks_multiply_const_vxx_0_1_0.set_k(
            10 ** (-1.0 * self.ue3_path_loss_db / 20.0))

    def get_zmq_hwm(self):
        return self.zmq_hwm

    def get_zmq_timeout(self):
        return self.zmq_timeout


def main(top_block_cls=multi_ue_scenario, options=None):
    tb = top_block_cls()

    def sig_handler(sig=None, frame=None):
        tb.stop()
        tb.wait()
        sys.exit(0)

    signal.signal(signal.SIGINT, sig_handler)
    signal.signal(signal.SIGTERM, sig_handler)

    tb.start()
    try:
        input('Press Enter to quit: ')
    except EOFError:
        pass
    tb.stop()
    tb.wait()


if __name__ == '__main__':
    main()
