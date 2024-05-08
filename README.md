# Caravel User SRAM

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

## Overview

This is a simple example showcasing how to integrate the commercial SRAM in the `user_project_wrapper` using `IPM`.

## Quick start

1. Start with cloning the repo
```
git clone https://github.com/efabless/caravel_user_sram.git
```
2. Setup your enviroment
```
cd caravel_user_sram
make setup
```
3. Install IPM
```
pip install ipm
```
4. Install the SRAM IP
```
ipm install-dep
```
5. Harden the SRAM macro
```
make SRAM_1024x32
```
6. Harden the `user_project_wrapper`
```
make user_project_wrapper
```
