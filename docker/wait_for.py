import argparse
import socket
import time


def wait_for_socket(host, port, count):
    with socket.socket() as s:
        for i in range(count):
            print('Wait for {}:{}, seconds left: {}'.format(host, port, count - i))
            try:
                s.connect((host, port))
                break
            except socket.error:
                time.sleep(1)
        else:
            print('Service on {}:{} unavailable.'.format(host, port))
            raise SystemExit(1)


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('--host', type=str, required=True, help='Service host for waiting for.')
    parser.add_argument('--port', type=int, required=True, help='Service port for waiting for.')
    parser.add_argument('--timeout', type=int, default=30, help='Waiting for timeout.')
    args = parser.parse_args()

    wait_for_socket(args.host, args.port, args.timeout)
