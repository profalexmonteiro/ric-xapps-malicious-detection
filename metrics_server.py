#!/usr/bin/env python3

import socket
import json
import argparse


def run_receiver(ip, port, filename):
    """
    Listens for UDP packets containing JSON data and saves them instantly to a file.

    Each JSON object is saved as a new line in the specified file.

    Args:
        ip (str): The IP address to bind the receiver to.
        port (int): The port to listen on.
        filename (str): The name of the file to save data to (in JSON Lines format).
    """
    sock = None
    log_file = None
    try:
        # Open file in append mode ('a') to save data as it arrives
        log_file = open(filename, "a", encoding="utf-8")

        # Create a UDP socket
        sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)

        # Bind the socket to the IP address and port
        sock.bind((ip, port))

        print(f"✅ UDP Receiver started on {ip}:{port}")
        print(f"💾 Received data is being saved instantly to '{filename}'.")
        print("Press Ctrl+C to exit.")

        while True:
            # Receive message from the sender (buffer size 65535 bytes)
            data, addr = sock.recvfrom(65535)

            # Decode the received message as JSON and write to file
            try:
                json_data = json.loads(data.decode("utf-8"))

                # Write the JSON object to the file, followed by a newline
                json.dump(json_data, log_file)
                log_file.write("\n")

                # Flush the file's buffer to ensure data is written to disk immediately
                log_file.flush()
            except (json.JSONDecodeError, UnicodeDecodeError):
                print(f"⚠️ Received non-JSON or malformed data from {addr}")

    except OSError as e:
        print(f"Error: Could not bind to {ip}:{port} or access file '{filename}'. {e}")
    except KeyboardInterrupt:
        print("\nInterrupt received. Shutting down...")
    finally:
        # Ensure resources are closed when the program exits
        if log_file:
            log_file.close()
            print("File closed.")
        if sock:
            sock.close()
            print("Socket closed.")
        print("Exiting...")


if __name__ == "__main__":
    # Set up the argument parser to handle command-line inputs
    parser = argparse.ArgumentParser(
        description="A UDP receiver for logging JSON data instantly to a file."
    )

    parser.add_argument(
        "-f",
        "--filename",
        default="gnb_metrics.jsonl",
        help="The name of the file to save received data to (default: gnb_metrics.jsonl).",
    )
    parser.add_argument(
        "--ip",
        default="127.0.0.1",
        help="The IP address to bind to (default: 127.0.0.1).",
    )
    parser.add_argument(
        "-p",
        "--port",
        type=int,
        default=55555,
        help="The port to listen on (default: 55555).",
    )

    args = parser.parse_args()

    # Run the receiver with the parsed arguments
    run_receiver(args.ip, args.port, args.filename)
