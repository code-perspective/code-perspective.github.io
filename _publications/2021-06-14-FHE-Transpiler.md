---
title: "A General Purpose Transpiler for Fully Homomorphic Encryption"
kind: paper
permalink: /publication/2021-06-14-FHE-Transpiler
description: 'A fully homomorphic encryption transpiler that converts high-level programs over unencrypted data into programs that operate on encrypted data.'
date: 2021-06-14
venue: 'github/google/fully-homomorphic-encryption'
paper_url: 'https://arxiv.org/abs/2106.07893'
---

Fully homomorphic encryption (FHE) is an encryption scheme which enables computation on encrypted data without revealing the underlying data. While there have been many advances in the field
of FHE, developing programs using FHE still requires expertise in cryptography. In this white paper,
we present a fully homomorphic encryption transpiler that allows developers to convert high-level code
(e.g., C++) that works on unencrypted data into high-level code that operates on encrypted data. Thus,
our transpiler makes transformations possible on encrypted data.
