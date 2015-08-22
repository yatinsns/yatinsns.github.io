---
layout: post
title: openssl-encryption
date: 2015-08-10 00:35:14
categories:
---

## Using openssl (command line tool)

	$ openssl version
	$ openssl list-standard-commands
	
enc -> encrypt/decrypt using secret key algorithms. It is possible to generate using a password or directly a secret key stored in a file.

	$ openssl list-cipher-commands
	aes-128-ecb
	base64
	…


### base64

##### encoding
	$ printf “123456789” | openssl enc -base64

or
	
	$ openssl enc -base64 -in number.txt
	
##### decoding

	$ printf "YWJjZGVmZ2hpamtsbW5vcA==" | openssl enc -base64 -d -A
	
`-A` option required for bigger encrypted data.


### aes-128-ecb mode with cipher key


##### encryptyion

	$ printf "abcdefghijklmnop" | openssl aes-128-ecb -K '59454c4c4f57205355424d4152494e45' -nosalt -v -nopad -out result.bin
	$ openssl enc -base64 -in result.bin

##### decryption

	$ openssl aes-128-ecb -d -K '59454c4c4f57205355424d4152494e45' -nosalt -nopad -in result.bin


### aes-128-cbc mode with cipher key


##### encryptyion

	$ printf "abcdefghijklmnop" | openssl aes-128-cbc -K '59454c4c4f57205355424d4152494e45' -iv '00000000000000000000000000000000' -nosalt -v -nopad -out result.bin
	$ openssl enc -base64 -in result.bin

##### decryption

	$ openssl aes-128-cbc -d -K '59454c4c4f57205355424d4152494e45' -iv '00000000000000000000000000000000' -nosalt -nopad -in result.bin

	
Note:

* key should be in hexadecimal format
* Don't use `echo`. It treats length of "0\n1" as 4 instead of 3. Use printf instead.
* Use `hexdump -C` to check output of openssl commands.
* `-nopad` option is added to remove OpenSSL's PKCS#7 padding to ensure there are full blocks. Refer [this](http://crypto.stackexchange.com/questions/12621/why-does-openssl-append-extra-bytes-when-encrypting-with-aes-8-ecb) for more details.
* If you want to use PKCS#7 padding, don't use `-nopad` flog.


### aes-256-cbc mode using password

##### encryption

	$ touch plain.txt
	$ printf "I love OpenSSL!" > plain.txt
	$ openssl enc -aes-256-cbc -in plain.txt -out encrypted.bin
	enter aes-256-cbc encryption password: hello
	Verifying - enter aes-256-cbc encryption password: hello

The secret key of 256 bits is computed from the password. Note that of course the choice of password “hello” is really INSECURE! Please take the time to choose a better password to protect your privacy! The output file encrypted.bin is binary.

##### decryption

	$ openssl enc -aes-256-cbc -d -in encrypted.bin -pass pass:hello
	I love OpenSSL!

	
	


