from urllib import response
import pytest
import asyncio

from bleak import BleakClient, discover

DEVICE_NAME = "Nordic_UART_Service"
NUS_RX_UUID = "6e400002-b5a3-f393-e0a9-e50e24dcca9e"
NUS_TX_UUID = "6e400003-b5a3-f393-e0a9-e50e24dcca9e"

@pytest.mark.asyncio
async def test_ble_write_read():
    """Test sending data and receiving notifications."""
    devices = await discover()
    target_device = next((d for d in devices if d.name and DEVICE_NAME in d.name), None)
    
    assert target_device, "BLE device not found!"

    async with BleakClient(target_device.address) as client:
        assert await client.is_connected(), "Failed to connect to BLE device!"
        received_data = []

        def callback(sender, data: bytearray):
            try:
                decoded_data = data.decode("utf-8")
                print(f"Received from {sender}: {decoded_data}")
                received_data.append(decoded_data)
            except UnicodeDecodeError:
                print(f"Could not decode data: {data}")

        await client.start_notify(NUS_TX_UUID, callback)
        await asyncio.sleep(2)
        test_data = b"Test Message\n"
        await client.write_gatt_char(NUS_RX_UUID, test_data)
        await asyncio.sleep(10)  
        await client.stop_notify(NUS_TX_UUID)
        print(received_data)
        assert received_data, "No data received from BLE device!"
        assert "Test Message" in received_data[0], "Incorrect data received!"