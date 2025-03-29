# restore_signature.py
# Fixes the NanoDump-obfuscated minidump signature

dump_path = r"C:\Windows\Temp\nanodump.dmp"

try:
    with open(dump_path, 'rb') as f:
        full_data = f.read()
except FileNotFoundError:
    print(f"Can't find dump file: {dump_path}")
    exit(1)

valid_signature = bytes([0x4d, 0x44, 0x4d, 0x50, 0x93, 0xa7, 0x00, 0x00])
restored = valid_signature + full_data[8:]

with open(dump_path, 'wb') as f:
    f.write(restored)

print(f"[✓] File signature restored: {dump_path}")

