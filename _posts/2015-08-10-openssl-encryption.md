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
	$ echo -n “123456789” | openssl enc -base64

or
	
	$ openssl enc -base64 -in number.txt
	
##### decoding

	$ echo -n "YWJjZGVmZ2hpamtsbW5vcA==" | openssl enc -base64 -d -A
	
'-A' option required for bigger encrypted data.


### aes-128-ecb mode with cipher key


##### encryptyion

	$ echo -n "abcdefghijklmnop" | openssl aes-128-ecb -K '59454c4c4f57205355424d4152494e45' -nosalt -v -nopad -out result1.bin

##### decryption

	$ openssl aes-128-ecb -d -K '59454c4c4f57205355424d4152494e45' -nosalt -nopad -in output.bin
	$ openssl enc -base64 -in output.bin
	
Note:

* key should be in hexadecimal format
* 'echo' adds newline character at end. So use 'echo -n' instead. 
* Use 'hexdump -C' to check output of openssl commands.
* '-nopad' option is added to remove OpenSSL's PKCS#7 padding to ensure there are full blocks. Refer [this](http://crypto.stackexchange.com/questions/12621/why-does-openssl-append-extra-bytes-when-encrypting-with-aes-8-ecb) for more details.


### aes-256-cbc mode using password

##### encryption

	$ touch plain.txt
	$ echo "I love OpenSSL!" > plain.txt
	$ openssl enc -aes-256-cbc -in plain.txt -out encrypted.bin
	enter aes-256-cbc encryption password: hello
	Verifying - enter aes-256-cbc encryption password: hello

The secret key of 256 bits is computed from the password. Note that of course the choice of password “hello” is really INSECURE! Please take the time to choose a better password to protect your privacy! The output file encrypted.bin is binary.

##### decryption

	$ openssl enc -aes-256-cbc -d -in encrypted.bin -pass pass:hello
	I love OpenSSL!

	
	


