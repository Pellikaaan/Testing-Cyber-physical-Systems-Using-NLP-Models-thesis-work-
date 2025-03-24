from bleak import BleakClient

DEVICE_MAC = "XX:XX:XX:XX:XX:XX"  # Replace with your board's BLE address
UUID = "00002A37-0000-1000-8000-00805F9B34FB"  # Adjust UUID to match your GATT characteristic

async def send_data(data_to_be_sent):
    async with BleakClient(DEVICE_MAC) as client:
        await client.write_gatt_char(UUID, data_to_be_sent)

import asyncio
asyncio.run(send_data())