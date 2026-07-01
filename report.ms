.ds FAM T
.nr PS +4

.EQ
delim $$
.EN

.TL
RSA Encryption, Quantum Computers and Shor's Algorithm
.AU
Menase Teshale
.SH
.bp
.ce
.ps +3
RSA Algorithm for Asymmetric Encryption
.PP

\f[I]Asymmetric encryption\f[R] is a type of encryption where there are two keys called \f[I]public\f[R] and \f[I]private\f[R] where one(typically the private key) can only decrypt and the other(public key) can only encrypt the messages. This solves the middleman problem with symmetric encryption wherin you have to send an unencrypted key to begin communication but if the key is intercepted then the rest of the communication being encrypted is of no importance. Asymmetric encryption is vital for there to be any secure connection to the internet. It is also used in digital signatures and authentication for signing documents and commits on github, asymmetric encryption \f[I]is the reason you can be sure code for your operating system is written by the people whose job it is to write it.\f[R] The \f[B]RSA\f[R] algorithm is one of the simplest asymmetric encryption algorithms and it works as follows:

.ds FAM C
.IP \[bu]
Choose two prime numbers $p, q$ then set $N = pq$
.IP \[bu]
Find $phi (N) = (p - 1) times (q - 1)$
.IP \[bu]
Find $e$ such that $gcd(e, phi ) = 1$
.IP \[bu]
Find $d$ such that $e times d == 1$ $mod$ $N$ that is the multiplicative inverse of \f[I]e mod N\f[R]
.IP \[bu]
$C == M sup e$ \f[I]mod N\f[R] therefore $(N, e)$ is the public key
.IP \[bu]
$M == C sup d$ \f[I]mod N\f[R] therefore $(N, d)$ is the private key

.ds FAM T
.SH
Breaking RSA on Classical Computer
.LP
This can be done by first selecting two random primes and checking if they multiply to give \f[I]N\f[R] if they do you can input them into the second step of the RSA algorithm to get the private and public keys. This is needlessly time consuming as you actually dont need to find the numbers themselves. You only need to find $a$ multiple of \f[I]p\f[R] or \f[I]q\f[R] \f[B]but not both\f[R] then all you have to do is $gcd(a, N)$ to find one of the primes (say \f[I]p\f[R])
