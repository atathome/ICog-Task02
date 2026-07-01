#!/usr/bin/env python3

from itertools import count
import threading
import random
import math
import time

lower_bound = 200   #only primes bigger than this will be used
n_recipients = 4    # number of recipients in the simulation
n_primes = 100
max_work_time = 20  #max running time for brute forcing a message

def pow_mod(x, y, m):
    res = 1
    x = x % m

    while y > 0:
        if y % 2 == 1:
            res = (res * x) % m

        x = (x * x) % m
        y = y // 2

    return res

def get_primes(lower_bound, n_primes):
    if lower_bound < 0 or n_primes <= 0:
        return []

    primes = [2]
    c_primes = 1 if lower_bound < 2 else 0

    while c_primes < n_primes:
        for j in count(primes[-1]+1):
            is_prime = True

            for p in primes:
                if j % p == 0:
                    is_prime = False
                    break

            if is_prime:
                primes.append(j)
                if j > lower_bound:
                    c_primes += 1
                break
    return primes[-n_primes:]

def gen_keypair_from(p, q):
    n = p * q
    phi = (p - 1) * (q - 1)

    e = -1
    for i in range(2, phi):
        if math.gcd(phi, i) == 1:
            e = i
            break

    if e == -1:
        return

    d = -1
    for i in range(2, phi):
        if (e * i) % phi == 1:
            d = i
            break

    if d == -1:
        return

    return ((n, e), (n, d))

def gen_keypair(primes):
    return gen_keypair_from(random.choice(primes), random.choice(primes))

def encrypt(message, public_key):
    (n, e) = public_key
    return pow_mod(message, e, n)

def decrypt(cipher, private_key):
    (n, d) = private_key
    return pow_mod(cipher, d, n)

def try_get_privatekey(n):
    initial_guess = random.randrange(n)
    start_time = time.clock_gettime(time.CLOCK_MONOTONIC)

    if math.gcd(initial_guess, n) > 1:
        p = math.gcd(initial_guess, n)
        q = n // p
        (_, private_key) = gen_keypair_from(p, q)

        return private_key

    for p in count(start=2, step=2):
        if pow_mod(initial_guess, p, n) == 1:
            g1 = initial_guess ** (p // 2) + 1
            g2 = initial_guess ** (p // 2) - 1

            cp1 = math.gcd(g1, n)
            cp2 = math.gcd(g2, n)

            if cp1 == n or cp2 == n:
                continue

            p = max(cp1, cp2)
            q = n // p
            (_, private_key) = gen_keypair_from(p, q)
            return private_key

        current_time = time.clock_gettime(time.CLOCK_MONOTONIC)
        if current_time - start_time >= max_work_time:
            break

    return

class MessageRecipient:
    def __init__(self, rec_id, public_key, private_key = None):
        self.rec_id = rec_id
        self.public_key = public_key
        self.private_key = private_key
        self.active_thread = None

    def receive_cipher(self, cipher):
        #Simulates a recipient of the ciphertext
        #if it has the private key it will use it to decrypt the message
        #will try a period finding attack otherwise
        print(self, "MESSAGE RECEIVED")
        if self.private_key != None:
            print(self, "MESSAGE DECRYPTED WITH PRIVATE KEY:", decrypt(cipher, self.private_key))
            return
        else:
            print(self, "DON'T HAVE PRIVATE KEY, ATTEMPTING TO USE PERIOD FINDING ATTACK!")
            (n, _) = self.public_key
            private_key = try_get_privatekey(n)

            if private_key != None:
                print(self, "MESSAGE DECRYPTED WITHOUT PRIVATE KEY:", decrypt(cipher, private_key))
            else:
                print(self, "FAILED, MAYBE BUY A QUANTUM COMPUTER!")

    def start_decrypt_message(self, cipher):
        if self.active_thread != None:
            print(self.rec_id, "DECRYPTING ANOTHER MESSAGE")
            return

        self.active_thread = threading.Thread(target=self.receive_cipher, args=(cipher,))
        self.active_thread.start()

    def __repr__(self):
        return f"Recipient {self.rec_id}"

    def wait_decrypt_message(self):
        self.active_thread.join()
        self.active_thread = None

def main():
    random.seed()
    primes = get_primes(lower_bound, n_primes)
    (public_key, private_key) = gen_keypair(primes)

    recipients = [MessageRecipient(rec_id+1, public_key) for rec_id in range(n_recipients)]
    true_recipient = random.randrange(n_recipients)
    recipients[true_recipient].private_key = private_key

    message = int(input(f"Enter a small integer message for {recipients[true_recipient]}: "))
    cipher = encrypt(message, public_key)

    for recipient in recipients:
        recipient.start_decrypt_message(cipher)

    for recipient in recipients:
        recipient.wait_decrypt_message()

if __name__ == "__main__":
    main()
