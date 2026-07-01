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

\f[I]Asymmetric encryption\f[R] is a type of encryption where there are two keys called \f[I]public\f[R] and \f[I]private\f[R] where one(typically the private key) can only decrypt and the other(public key) can only encrypt the messages. This solves the middleman problem with symmetric encryption wherein you have to send an unencrypted key to begin communication but if the key is intercepted then the rest of the communication being encrypted is of no importance. Asymmetric encryption is vital for there to be any secure connection to the internet. It is also used in digital signatures and authentication for signing documents and commits on github, asymmetric encryption \f[I]is the reason you can be sure code for your operating system is written by the people whose job it is to write it.\f[R] The \f[B]RSA\f[R] algorithm is one of the simplest asymmetric encryption algorithms and it works as follows:

.ds FAM C
.IP \[bu]
Choose two prime numbers $p, q$ then set $N = p times q$
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
This can be done by first selecting two random primes and checking if they multiply to give \f[I]N\f[R] if they do you can input them into the second step of the RSA algorithm to get the private and public keys. This is needlessly time consuming as you actually dont need to find the numbers themselves. You only need to find $a$ multiple of \f[I]p\f[R] or \f[I]q\f[R] \f[B]but not both\f[R] then all you have to do is $gcd(a, N)$ to find one of the primes (say \f[I]p\f[R]) then you can easily find the other $q = N / p$. If you didn't find a multiple of \f[I]p or q\f[R] a result in number theory guarantees that there is a number $g$ for your number $a$ such that $a sup g = mN + 1$ for some $m$. We can rearrange this equation to get $(a sup {g over 2} - 1) times (a sup {g over 2} + 1) = mN$. Now we are not guaranteed either of these factors is a number we need one of them could be a multiple of $N$ while the other one a factor of $m$ giving us no new information. But it is much more likely that these factors are the numbers we need $37.5%$ of such pairs to be exact. But the difficulty is in finding the original $g$ to do such factorization. On classical computers we are back now to sequential guessing, this is where quantum computers come in.
.SH
.ce
.ps +3
Quantum Computers
.PP

Are a special type of computer that can in a single step perform a number of computations that doesn't scale linearly to the number of gates/cores/pipeline phases used to build it. They do this by using the property of superposition where a \f[I]qbit\f[R] can be in a combination of multiple states at the same time. It has to be noted that the qbit will when observed land on one of these states with a given probability and then the quantum properties (entanglement, superposition...) are lost. Quantum computers can only answer one question very fast not multiple questions at the same time. The important properties of quantum computers are:

.IP \[bu]
Superposition - Used to represent a combination of multiple states
.IP \[bu]
Interference - The basic concept of a computational step where correct answers reinforce while incorrect answers cancel out
.IP \[bu]
Entanglement - When a state cannot be decomposed cleanly, meaning that a part of the system affects another part of the system

.SH
Breaking RSA on Quantum Computers (Shor's Algorithm)
.LP
To break RSA on a quantum computer we first represent our state a s a superposition of all the guesses for p. $left | 1 right > + left | 2 right > + left | 3 right > ...$ then you from this create a superposition which for each guess has $left | x, a sup x mod N right >$ now if you measure only the remainder part it collapses on a single value \f[I]but the other half of the superposition doesn't\f[R]. This is one of the properties of a quantum system if measured by part the other part remains in a superposition but one in which the measured value is guaranteed to be the same for all components of the superposition. This is why we kept all the quesses in the previous step since all the values of x that yield constant $a sup x$ \f[I]mod N\f[R] are separated by a period of $g$ the number which when given our number which is unlikely to share factors with $N$ gives us a pair which are likely to. Now if we input this superposition into a system called the quantum forier transform the remaining state will be the frequency of the superposition $left | 1 over g right >$ and so our result is found in a few sequential steps.

.SH
.ps +3
.ce
Post Quantum Security
.PP

In the first segment we have hilighted how critical asymmetric encryption is so if quantum computers can crack one of the most widely used asymmetric encryption schemes, is all lost? First of all there is no proof that all encryptions cannot be broken effectively by quantum or even classical computers. The best we have are conditional statements on what seem to be highly likely conjenctures like the \f[B]PRG\f[R] conjecncture that have held up in practical expirience.
