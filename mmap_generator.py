import random


class MMapGenerator:
    """
    Chaotic pseudo-random generator based on the skewed tent map (M-map).

    The skewed tent map is defined as:
        x_{n+1} = x_n / p          if x_n < p
        x_{n+1} = (1 - x_n)/(1-p) if x_n >= p

    It is chaotic for all p in (0, 1) and produces values in (0, 1).
    p is constrained to [0.25, 0.5] to ensure good mixing without degeneracy.
    """

    def __init__(self, seed=None, p=None):
        if seed is None:
            seed = random.uniform(0.01, 0.99)
        if p is None:
            p = random.uniform(0.25, 0.5)

        self.seed = float(seed)
        self.p = float(p)

        # Derive initial state in (0, 1) from the full seed value.
        # Using random.Random ensures seeds like 0.42, 1.42, 2.42 produce
        # distinct initial states (a plain % 1.0 would collapse them).
        rng = random.Random(self.seed)
        self._state = rng.uniform(0.001, 0.999)

    def next(self):
        """Advance the map one step and return the new value in (0, 1)."""
        x = self._state
        if x < self.p:
            self._state = x / self.p
        else:
            self._state = (1.0 - x) / (1.0 - self.p)
        # Guard against degenerate fixed points due to floating-point precision
        if self._state <= 0.0 or self._state >= 1.0:
            self._state = 0.5
        return self._state


def generate_channel_parameters(g):
    """
    Generates randomized per-UE radio channel parameters for the 3-UE srsRAN/GNURadio scenario.

    Uses three successive M-map draws to produce independent path-loss values for
    UE1, UE2, and UE3. The range 0-60 dB covers indoor to outdoor propagation
    conditions typical of a ZMQ-emulated channel.

    Returns a dict whose keys map directly to CLI args of multi_ue_scenario_nogui.py
    (underscores are replaced by hyphens by the caller).
    """
    ue1_path_loss = round(g.next() * 60)
    ue2_path_loss = round(g.next() * 60)
    ue3_path_loss = round(g.next() * 60)

    return {
        "ue1_path_loss_db": ue1_path_loss,
        "ue2_path_loss_db": ue2_path_loss,
        "ue3_path_loss_db": ue3_path_loss,
    }
