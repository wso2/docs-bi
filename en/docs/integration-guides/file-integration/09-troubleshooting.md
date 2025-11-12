---
title: Troubleshooting File Integrations
// TODO https://github.com/wso2/product-ballerina-integrator/issues/641
// The usal error messages are in cause of the error. This must be bought to higher level.
---

# Troubleshooting Guide

Diagnose and resolve issues across discovery, access, transfer, processing, and delivery stages.

## 1. Discovery (File Not Found / Not Picked Up)
- Wrong path or permissions: Verify directory exists and service account can read.
- Pattern mismatch: Confirm glob or extension filter.
- File still writing: Implement stability check (size unchanged over interval).

## 2. Access & Authentication (Remote Servers)
- Invalid credentials: Test manually with SFTP/FTP client; rotate password or key.
- SSH key format: Ensure OpenSSH format; correct permissions on private key.
- TLS errors (FTPS): Certificate expired or CN mismatch → update trust store.

## 3. Transfer Integrity
- Partial/corrupt file: Compare expected vs actual size or checksum.
- Encoding issues: Detect BOM; convert to UTF-8 early.
- Timeouts: Increase socket/data timeout; check network latency.

## 4. Processing Failures
- Malformed JSON/CSV: Log first error line; move file to `./quarantine/`.
- Large file memory pressure: Switch to streaming API, reduce batch size.
- Duplicate ingestion: Use hash manifest; skip already processed.
