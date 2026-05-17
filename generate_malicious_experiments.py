import os
import shutil
from pathlib import Path
from argparse import ArgumentParser
from mmap_generator import MMapGenerator, generate_channel_parameters

# === Configuration ===
UE_COUNT = 3
EXPERIMENTS_PER_TR = 1
TOTAL_TRAINING_RUNS = 100
TRAFFIC_PROFILE_DIR = Path("traffic_profiles")
# Changed output directory to keep malicious data separate
OUTPUT_DIR = Path("generated_malicious_experiments")
SCENARIO_SCRIPT = Path(os.environ.get("PWD", os.getcwd())) / "openran" / "my-srsproject-demo" / "multi-ue-setup" / "multi_ue_scenario.py"
DURATION_SEC = 480  # 8 minutes


def list_and_categorize_profiles():
    """Separates available profiles into normal and malicious lists."""
    all_profiles = list(TRAFFIC_PROFILE_DIR.glob("**/*.sh"))
    normal_profiles = []
    malicious_profiles = []

    malicious_dir_name = "malicious"

    for profile in all_profiles:
        # Check if 'malicious' is in the path parts
        if malicious_dir_name in profile.parts:
            malicious_profiles.append(profile)
        else:
            normal_profiles.append(profile)

    return sorted(normal_profiles), sorted(malicious_profiles)


def assign_profiles_with_malicious(generator, normal_profiles, malicious_profiles):
    """Assigns two UEs malicious profiles and the rest normal profiles."""
    assignments = {}

    # Select two unique UEs to be malicious for this training run.
    malicious_ue_indices = set()
    while len(malicious_ue_indices) < 2:
        idx = int(generator.next() * UE_COUNT) + 1
        malicious_ue_indices.add(idx)

    for i in range(1, UE_COUNT + 1):
        ue_name = f"UE{i}"
        if i in malicious_ue_indices:
            # Assign a malicious profile
            idx = int(generator.next() * len(malicious_profiles)) % len(
                malicious_profiles
            )
            assignments[ue_name] = malicious_profiles[idx]
        else:
            # Assign a normal profile
            idx = int(generator.next() * len(normal_profiles)) % len(normal_profiles)
            assignments[ue_name] = normal_profiles[idx]

    return assignments


def create_exp_folder(tr_id, exp_id, g, channel_params, profile_assignments):
    exp_path = OUTPUT_DIR / f"tr{tr_id}" / f"exp{exp_id}"
    exp_path.mkdir(parents=True, exist_ok=True)

    # Save run script
    run_script_path = exp_path / "run_scenario.sh"
    with open(run_script_path, "w") as f:
        f.write("#!/bin/bash\n\n")
        f.write(f"# Run script for tr{tr_id} exp{exp_id}\n")
        f.write(f"# Conditions generated with seed={g.seed} and p={g.p}\n")
        args_str = " ".join(
            [f"--{k.replace('_', '-')} {v}" for k, v in channel_params.items()]
        )
        f.write(f"python3 {SCENARIO_SCRIPT} {args_str} &\n")
        f.write("PYTHON_PID=$!\n")
        f.write("echo $PYTHON_PID > /tmp/python_scenario.pid\n")
    os.chmod(run_script_path, 0o755)

    # Save conditions.csv
    cond_path = exp_path / "conditions.csv"
    with open(cond_path, "w") as f:
        f.write("UE,Profile\n")
        for ue, profile_path in profile_assignments.items():
            f.write(f"{ue},{str(profile_path.resolve())}\n")
        f.write("\n# M-map Parameters\n")
        f.write(f"seed,{g.seed}\n")
        f.write(f"p,{g.p}\n")
        f.write("\n# Channel Parameters\n")
        for k, v in channel_params.items():
            f.write(f"{k},{v}\n")

    print(f"  [OK] Created: {exp_path.relative_to(OUTPUT_DIR)}")


def main():
    parser = ArgumentParser(
        description="Generate training experiments with ONE malicious UE per run."
    )
    parser.add_argument(
        "--seed",
        type=float,
        default=None,
        help="Base seed for M-map generator. If not set, a random seed is used for each run.",
    )
    parser.add_argument(
        "--p",
        type=float,
        default=None,
        help="M-map parameter (0.25 to 0.5). If not set, a random p is used for each run.",
    )
    args = parser.parse_args()

    normal_profiles, malicious_profiles = list_and_categorize_profiles()

    if not normal_profiles:
        print(f"Error: No normal MGEipN profiles found in {TRAFFIC_PROFILE_DIR}")
        return
    if not malicious_profiles:
        print(
            f"Error: No malicious Iperf4 profiles found in a '{TRAFFIC_PROFILE_DIR}/malicious' subdirectory."
        )
        return

    if OUTPUT_DIR.exists():
        shutil.rmtree(OUTPUT_DIR)
    OUTPUT_DIR.mkdir(parents=True)

    for tr in range(TOTAL_TRAINING_RUNS):
        # Determine the seed for this training run.
        tr_seed = (args.seed + tr) if args.seed is not None else None

        # Create a single generator for this entire training run.
        g = MMapGenerator(tr_seed, p=args.p)

        # Generate all conditions for this run.
        channel_params = generate_channel_parameters(g)
        profile_assignments = assign_profiles_with_malicious(
            g, normal_profiles, malicious_profiles
        )

        print(f"\nTR{tr}: Generating experiments with seed={g.seed:.4f}, p={g.p:.4f}")
        for exp in range(1, EXPERIMENTS_PER_TR + 1):
            create_exp_folder(tr, exp, g, channel_params, profile_assignments)

    print(f"\nAll malicious experiments generated in: {OUTPUT_DIR.resolve()}")


if __name__ == "__main__":
    main()
